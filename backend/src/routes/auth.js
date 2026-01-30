const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { OAuth2Client } = require('google-auth-library');
const axios = require('axios');
const supabase = require('../config/supabase');

const router = express.Router();
const googleClient = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

// In-memory OTP storage (in production, use Redis or database)
const otpStorage = new Map();

// Clean up expired OTPs every 5 minutes
setInterval(() => {
  const now = Date.now();
  for (const [key, data] of otpStorage.entries()) {
    if (now > data.expiresAt) {
      otpStorage.delete(key);
    }
  }
}, 5 * 60 * 1000);

// Input validation middleware
const validateRegister = (req, res, next) => {
  const { fullName, email, phoneNumber, password } = req.body;
  
  if (!fullName || fullName.trim().length < 2) {
    return res.status(400).json({ error: 'Full name must be at least 2 characters' });
  }
  
  if (!email || !email.match(/^[^\s@]+@[^\s@]+\.[^\s@]+$/)) {
    return res.status(400).json({ error: 'Please provide a valid email address' });
  }
  
  if (!phoneNumber || phoneNumber.trim().length < 10) {
    return res.status(400).json({ error: 'Please provide a valid phone number' });
  }
  
  if (!password || password.length < 6) {
    return res.status(400).json({ error: 'Password must be at least 6 characters' });
  }
  
  next();
};

const validateLogin = (req, res, next) => {
  const { emailOrPhone, password } = req.body;
  
  if (!emailOrPhone || !emailOrPhone.trim()) {
    return res.status(400).json({ error: 'Email or phone number is required' });
  }
  
  if (!password || !password.trim()) {
    return res.status(400).json({ error: 'Password is required' });
  }
  
  next();
};

const validateForgotPassword = (req, res, next) => {
  const { emailOrPhone } = req.body;
  
  if (!emailOrPhone || !emailOrPhone.trim()) {
    return res.status(400).json({ error: 'Please provide your email address or phone number' });
  }
  
  const trimmed = emailOrPhone.trim();
  
  // Check if it's an email or phone number
  const isEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(trimmed);
  const isPhone = /^[\d\s\-\+\(\)]{10,15}$/.test(trimmed.replace(/\D/g, ''));
  
  if (!isEmail && !isPhone) {
    return res.status(400).json({ error: 'Please provide a valid email address or phone number' });
  }
  
  next();
};

const validateResetPassword = (req, res, next) => {
  const { emailOrPhone, otp, newPassword } = req.body;
  
  if (!emailOrPhone || !emailOrPhone.trim()) {
    return res.status(400).json({ error: 'Please provide your email address or phone number' });
  }
  
  if (!otp || otp.length !== 6 || !/^\d{6}$/.test(otp)) {
    return res.status(400).json({ error: 'Please provide a valid 6-digit OTP' });
  }
  
  if (!newPassword || newPassword.length < 6) {
    return res.status(400).json({ error: 'Password must be at least 6 characters' });
  }
  
  next();
};

router.post('/register', validateRegister, async (req, res, next) => {
  try {
    const { fullName, email, phoneNumber, password } = req.body;
    
    // Check if email already exists
    const { data: existingUser } = await supabase
      .from('users')
      .select('id')
      .eq('email', email.toLowerCase())
      .single();
    
    if (existingUser) {
      return res.status(409).json({ error: 'Email already registered. Please login instead.' });
    }
    
    const hashedPassword = await bcrypt.hash(password, 10);
    
    const { data, error } = await supabase
      .from('users')
      .insert([{ 
        full_name: fullName.trim(), 
        email: email.toLowerCase().trim(), 
        phone_number: phoneNumber.trim(), 
        password: hashedPassword 
      }])
      .select()
      .single();

    if (error) {
      console.error('Registration error:', error);
      return res.status(500).json({ error: 'Registration failed. Please try again later.' });
    }

    const token = jwt.sign({ userId: data.id }, process.env.JWT_SECRET, { expiresIn: '7d' });
    
    res.status(201).json({ 
      token, 
      user: { 
        id: data.id, 
        fullName: data.full_name, 
        email: data.email 
      } 
    });
  } catch (error) {
    next(error);
  }
});

router.post('/login', validateLogin, async (req, res, next) => {
  try {
    const { emailOrPhone, password } = req.body;
    const input = emailOrPhone.trim();
    
    // Determine if input is email or phone
    const isEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(input);
    let user;
    
    if (isEmail) {
      // Search by email
      const { data, error } = await supabase
        .from('users')
        .select('*')
        .eq('email', input.toLowerCase())
        .single();
      
      if (error || !data) {
        return res.status(401).json({ error: 'Invalid email or password' });
      }
      user = data;
    } else {
      // Search by phone number - try multiple formats
      let phoneNumber = input.replace(/\D/g, '');
      
      // Try different phone number formats
      const phoneVariants = [];
      if (phoneNumber.startsWith('0')) {
        phoneVariants.push(phoneNumber);
        phoneVariants.push('91' + phoneNumber.substring(1));
        phoneVariants.push(phoneNumber.substring(1));
      } else if (phoneNumber.startsWith('91')) {
        phoneVariants.push(phoneNumber);
        phoneVariants.push('0' + phoneNumber.substring(2));
        phoneVariants.push(phoneNumber.substring(2));
      } else {
        phoneVariants.push(phoneNumber);
        phoneVariants.push('91' + phoneNumber);
        phoneVariants.push('0' + phoneNumber);
      }
      
      // Search for user with any phone variant
      let userData = null;
      for (const variant of phoneVariants) {
        const { data, error } = await supabase
          .from('users')
          .select('*')
          .eq('phone_number', variant)
          .single();
        
        if (data && !error) {
          userData = data;
          break;
        }
      }
      
      if (!userData) {
        return res.status(401).json({ error: 'Invalid phone number or password' });
      }
      user = userData;
    }

    const isValidPassword = await bcrypt.compare(password, user.password);
    
    if (!isValidPassword) {
      return res.status(401).json({ error: isEmail ? 'Invalid email or password' : 'Invalid phone number or password' });
    }

    const token = jwt.sign({ userId: user.id }, process.env.JWT_SECRET, { expiresIn: '7d' });
    
    res.json({ 
      token, 
      user: { 
        id: user.id, 
        fullName: user.full_name, 
        email: user.email 
      } 
    });
  } catch (error) {
    next(error);
  }
});

// Google Sign-In endpoint
router.post('/google', async (req, res, next) => {
  try {
    const { idToken } = req.body;
    
    if (!idToken) {
      return res.status(400).json({ error: 'Authentication failed. Please try again.' });
    }

    // Verify Google token
    const ticket = await googleClient.verifyIdToken({
      idToken,
      audience: process.env.GOOGLE_CLIENT_ID,
    });
    
    const payload = ticket.getPayload();
    const { email, name, sub: googleId, picture } = payload;

    if (!email) {
      return res.status(400).json({ error: 'Unable to retrieve account information.' });
    }

    // Check if user exists
    let { data: user, error } = await supabase
      .from('users')
      .select('*')
      .eq('email', email.toLowerCase())
      .single();

    // If user doesn't exist, create new user
    if (!user) {
      const { data: newUser, error: insertError } = await supabase
        .from('users')
        .insert([{
          full_name: name || email.split('@')[0],
          email: email.toLowerCase(),
          google_id: googleId,
          profile_picture: picture,
          phone_number: '',
          password: ''
        }])
        .select()
        .single();

      if (insertError) {
        console.error('Google sign-in error:', insertError);
        return res.status(500).json({ error: 'Sign-in failed. Please try again later.' });
      }

      user = newUser;
    } else {
      // Update Google ID and picture if not set
      if (!user.google_id) {
        await supabase
          .from('users')
          .update({ 
            google_id: googleId,
            profile_picture: picture 
          })
          .eq('id', user.id);
      }
    }

    // Generate JWT token
    const token = jwt.sign({ userId: user.id }, process.env.JWT_SECRET, { expiresIn: '7d' });
    
    res.json({
      token,
      user: {
        id: user.id,
        fullName: user.full_name,
        email: user.email,
        profilePicture: user.profile_picture
      }
    });
  } catch (error) {
    console.error('Google authentication error:', error);
    return res.status(500).json({ error: 'Sign-in failed. Please try again later.' });
  }
});

// Forgot Password - Send OTP
router.post('/forgot-password', validateForgotPassword, async (req, res, next) => {
  try {
    const { emailOrPhone } = req.body;
    const input = emailOrPhone.trim();
    
    // Determine if input is email or phone
    const isEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(input);
    let user;
    
    if (isEmail) {
      // Search by email
      const { data, error } = await supabase
        .from('users')
        .select('id, phone_number, full_name, email')
        .eq('email', input.toLowerCase())
        .single();
      
      if (error || !data) {
        return res.status(404).json({ 
          error: 'We couldn\'t find an account with this email address. Please check your email or create a new account.' 
        });
      }
      user = data;
    } else {
      // Search by phone number
      let phoneNumber = input.replace(/\D/g, '');
      
      // Try different phone number formats
      const phoneVariants = [];
      if (phoneNumber.startsWith('0')) {
        phoneVariants.push(phoneNumber); // Original with 0
        phoneVariants.push('91' + phoneNumber.substring(1)); // +91 format
        phoneVariants.push(phoneNumber.substring(1)); // Without 0
      } else if (phoneNumber.startsWith('91')) {
        phoneVariants.push(phoneNumber); // Original +91 format
        phoneVariants.push('0' + phoneNumber.substring(2)); // 0 format
        phoneVariants.push(phoneNumber.substring(2)); // Without country code
      } else {
        phoneVariants.push(phoneNumber); // Original
        phoneVariants.push('91' + phoneNumber); // +91 format
        phoneVariants.push('0' + phoneNumber); // 0 format
      }
      
      // Search for user with any phone variant
      let userData = null;
      for (const variant of phoneVariants) {
        const { data, error } = await supabase
          .from('users')
          .select('id, phone_number, full_name, email')
          .eq('phone_number', variant)
          .single();
        
        if (data && !error) {
          userData = data;
          break;
        }
      }
      
      if (!userData) {
        return res.status(404).json({ 
          error: 'We couldn\'t find an account with this phone number. Please check your number or create a new account.' 
        });
      }
      user = userData;
    }

    // Check if user has a valid phone number
    if (!user.phone_number || user.phone_number.trim() === '') {
      if (isEmail) {
        return res.status(400).json({ 
          error: 'Your account doesn\'t have a mobile number registered. Please contact our support team to update your profile and reset your password.' 
        });
      } else {
        return res.status(400).json({ 
          error: 'There seems to be an issue with your mobile number. Please contact our support team for assistance.' 
        });
      }
    }

    // Check rate limiting (max 3 attempts per hour)
    const rateLimitKey = `rate_limit_${user.id}`;
    const rateLimitData = otpStorage.get(rateLimitKey);
    const now = Date.now();
    
    if (rateLimitData && rateLimitData.attempts >= 3 && now < rateLimitData.resetTime) {
      const remainingTime = Math.ceil((rateLimitData.resetTime - now) / (60 * 1000));
      return res.status(429).json({ 
        error: `You've reached the maximum number of attempts. Please try again in ${remainingTime} minutes for your security.` 
      });
    }

    // Generate 6-digit OTP
    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    
    // Format phone number (ensure it starts with country code)
    let phoneNumber = user.phone_number.replace(/\D/g, '');
    if (phoneNumber.startsWith('0')) {
      phoneNumber = '91' + phoneNumber.substring(1); // Assuming Indian numbers
    } else if (!phoneNumber.startsWith('91')) {
      phoneNumber = '91' + phoneNumber;
    }

    // Store OTP immediately for faster response
    const otpKey = `otp_${user.id}`;
    otpStorage.set(otpKey, {
      otp,
      userId: user.id,
      emailOrPhone: input,
      expiresAt: now + (5 * 60 * 1000), // 5 minutes
      attempts: 0
    });

    // Update rate limiting
    const currentAttempts = rateLimitData ? rateLimitData.attempts + 1 : 1;
    otpStorage.set(rateLimitKey, {
      attempts: currentAttempts,
      resetTime: now + (60 * 60 * 1000) // 1 hour
    });

    // Mask phone number for response
    const maskedPhone = phoneNumber.replace(/(\d{2})(\d{4})(\d{4})/, '$1****$3');

    // Send response immediately, then send SMS asynchronously
    res.json({ 
      message: `We've sent a verification code to your mobile number ending with ${maskedPhone.slice(-4)}. Please check your messages.`,
      expiresIn: 300, // 5 minutes in seconds
      userId: user.id
    });

    // Send OTP asynchronously for faster response
    setImmediate(async () => {
      try {
        const response = await axios.get(
          `https://2factor.in/API/V1/${process.env.TWOFACTOR_API_KEY}/SMS/${phoneNumber}/${otp}`,
          { timeout: 8000 }
        );

        if (response.data.Status !== 'Success') {
          console.error('2Factor API error:', response.data);
          // Update OTP storage to mark as failed
          otpStorage.delete(otpKey);
        }
      } catch (apiError) {
        console.error('SMS API error:', apiError.message);
        // Update OTP storage to mark as failed
        otpStorage.delete(otpKey);
      }
    });

  } catch (error) {
    console.error('Forgot password error:', error);
    return res.status(500).json({ 
      error: 'We\'re experiencing technical difficulties. Please try again in a few moments.' 
    });
  }
});

// Reset Password - Verify OTP and Update Password
router.post('/reset-password', validateResetPassword, async (req, res, next) => {
  try {
    const { emailOrPhone, otp, newPassword } = req.body;
    const input = emailOrPhone.trim();
    
    // Find the OTP data by searching all stored OTPs
    let otpData = null;
    let otpKey = null;
    
    for (const [key, data] of otpStorage.entries()) {
      if (key.startsWith('otp_') && data.emailOrPhone === input) {
        otpData = data;
        otpKey = key;
        break;
      }
    }
    
    if (!otpData) {
      return res.status(400).json({ 
        error: 'The verification code has expired or is invalid. Please request a new code.' 
      });
    }

    // Check if OTP is expired
    if (Date.now() > otpData.expiresAt) {
      otpStorage.delete(otpKey);
      return res.status(400).json({ 
        error: 'The verification code has expired. Please request a new code.' 
      });
    }

    // Check OTP attempts (max 3 attempts)
    if (otpData.attempts >= 3) {
      otpStorage.delete(otpKey);
      return res.status(400).json({ 
        error: 'You\'ve entered an incorrect code too many times. Please request a new verification code.' 
      });
    }

    // Verify OTP
    if (otpData.otp !== otp) {
      otpData.attempts += 1;
      otpStorage.set(otpKey, otpData);
      
      const remainingAttempts = 3 - otpData.attempts;
      return res.status(400).json({ 
        error: `Incorrect verification code. You have ${remainingAttempts} attempt${remainingAttempts !== 1 ? 's' : ''} remaining.` 
      });
    }

    // Hash new password and update database in parallel
    const hashPasswordPromise = bcrypt.hash(newPassword, 10);
    
    try {
      const hashedPassword = await hashPasswordPromise;
      
      // Update password in database
      const { error: updateError } = await supabase
        .from('users')
        .update({ password: hashedPassword })
        .eq('id', otpData.userId);

      if (updateError) {
        console.error('Password update error:', updateError);
        return res.status(500).json({ 
          error: 'We couldn\'t update your password right now. Please try again in a moment.' 
        });
      }

      // Clean up OTP data
      otpStorage.delete(otpKey);
      
      res.json({ 
        message: 'Your password has been reset successfully! You can now sign in with your new password.' 
      });

    } catch (hashError) {
      console.error('Password hashing error:', hashError);
      return res.status(500).json({ 
        error: 'We couldn\'t process your request right now. Please try again in a moment.' 
      });
    }

  } catch (error) {
    console.error('Reset password error:', error);
    return res.status(500).json({ 
      error: 'We\'re experiencing technical difficulties. Please try again in a few moments.' 
    });
  }
});

module.exports = router;
