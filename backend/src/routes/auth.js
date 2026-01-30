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
  const { email, password } = req.body;
  
  if (!email || !email.trim()) {
    return res.status(400).json({ error: 'Email is required' });
  }
  
  if (!password || !password.trim()) {
    return res.status(400).json({ error: 'Password is required' });
  }
  
  next();
};

const validateForgotPassword = (req, res, next) => {
  const { email } = req.body;
  
  if (!email || !email.match(/^[^\s@]+@[^\s@]+\.[^\s@]+$/)) {
    return res.status(400).json({ error: 'Please provide a valid email address' });
  }
  
  next();
};

const validateResetPassword = (req, res, next) => {
  const { email, otp, newPassword } = req.body;
  
  if (!email || !email.match(/^[^\s@]+@[^\s@]+\.[^\s@]+$/)) {
    return res.status(400).json({ error: 'Please provide a valid email address' });
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
    const { email, password } = req.body;
    
    const { data: user, error } = await supabase
      .from('users')
      .select('*')
      .eq('email', email.toLowerCase().trim())
      .single();

    if (error || !user) {
      return res.status(401).json({ error: 'Invalid email or password' });
    }

    const isValidPassword = await bcrypt.compare(password, user.password);
    
    if (!isValidPassword) {
      return res.status(401).json({ error: 'Invalid email or password' });
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
    const { email } = req.body;
    
    // Check if user exists and has phone number
    const { data: user, error } = await supabase
      .from('users')
      .select('id, phone_number, full_name')
      .eq('email', email.toLowerCase().trim())
      .single();

    if (error || !user) {
      return res.status(404).json({ error: 'No account found with this email address' });
    }

    if (!user.phone_number || user.phone_number.trim() === '') {
      return res.status(400).json({ 
        error: 'Phone number not found. Please contact support to reset your password.' 
      });
    }

    // Check rate limiting (max 3 attempts per hour)
    const rateLimitKey = `rate_limit_${email.toLowerCase()}`;
    const rateLimitData = otpStorage.get(rateLimitKey);
    const now = Date.now();
    
    if (rateLimitData && rateLimitData.attempts >= 3 && now < rateLimitData.resetTime) {
      const remainingTime = Math.ceil((rateLimitData.resetTime - now) / (60 * 1000));
      return res.status(429).json({ 
        error: `Too many attempts. Please try again in ${remainingTime} minutes.` 
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

    try {
      // Send OTP via 2factor.in
      const response = await axios.get('https://2factor.in/API/V1/' + process.env.TWOFACTOR_API_KEY + '/SMS/' + phoneNumber + '/' + otp, {
        timeout: 10000
      });

      if (response.data.Status !== 'Success') {
        console.error('2Factor API error:', response.data);
        return res.status(500).json({ error: 'Unable to send OTP. Please try again later.' });
      }

      // Store OTP with 5-minute expiry
      const otpKey = `otp_${email.toLowerCase()}`;
      otpStorage.set(otpKey, {
        otp,
        userId: user.id,
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
      
      res.json({ 
        message: `OTP sent to your registered mobile number ending with ${maskedPhone.slice(-4)}`,
        expiresIn: 300 // 5 minutes in seconds
      });

    } catch (apiError) {
      console.error('SMS API error:', apiError.message);
      return res.status(500).json({ error: 'Unable to send OTP. Please try again later.' });
    }

  } catch (error) {
    console.error('Forgot password error:', error);
    next(error);
  }
});

// Reset Password - Verify OTP and Update Password
router.post('/reset-password', validateResetPassword, async (req, res, next) => {
  try {
    const { email, otp, newPassword } = req.body;
    
    const otpKey = `otp_${email.toLowerCase()}`;
    const otpData = otpStorage.get(otpKey);
    
    if (!otpData) {
      return res.status(400).json({ error: 'OTP expired or invalid. Please request a new one.' });
    }

    // Check if OTP is expired
    if (Date.now() > otpData.expiresAt) {
      otpStorage.delete(otpKey);
      return res.status(400).json({ error: 'OTP has expired. Please request a new one.' });
    }

    // Check OTP attempts (max 3 attempts)
    if (otpData.attempts >= 3) {
      otpStorage.delete(otpKey);
      return res.status(400).json({ error: 'Too many incorrect attempts. Please request a new OTP.' });
    }

    // Verify OTP
    if (otpData.otp !== otp) {
      otpData.attempts += 1;
      otpStorage.set(otpKey, otpData);
      
      const remainingAttempts = 3 - otpData.attempts;
      return res.status(400).json({ 
        error: `Invalid OTP. ${remainingAttempts} attempts remaining.` 
      });
    }

    // Hash new password
    const hashedPassword = await bcrypt.hash(newPassword, 10);
    
    // Update password in database
    const { error: updateError } = await supabase
      .from('users')
      .update({ password: hashedPassword })
      .eq('id', otpData.userId);

    if (updateError) {
      console.error('Password update error:', updateError);
      return res.status(500).json({ error: 'Failed to update password. Please try again.' });
    }

    // Clean up OTP data
    otpStorage.delete(otpKey);
    
    res.json({ message: 'Password reset successfully. You can now login with your new password.' });

  } catch (error) {
    console.error('Reset password error:', error);
    next(error);
  }
});

module.exports = router;
