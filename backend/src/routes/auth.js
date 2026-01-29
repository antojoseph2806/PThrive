const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { OAuth2Client } = require('google-auth-library');
const supabase = require('../config/supabase');

const router = express.Router();
const googleClient = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

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
      throw new Error('Registration failed. Please try again.');
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
      return res.status(400).json({ error: 'Google ID token is required' });
    }

    // Verify Google token
    const ticket = await googleClient.verifyIdToken({
      idToken,
      audience: process.env.GOOGLE_CLIENT_ID,
    });
    
    const payload = ticket.getPayload();
    const { email, name, sub: googleId, picture } = payload;

    if (!email) {
      return res.status(400).json({ error: 'Email not provided by Google' });
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
          phone_number: '', // Optional for Google sign-in
          password: '' // No password for Google users
        }])
        .select()
        .single();

      if (insertError) {
        console.error('Google sign-in error:', insertError);
        throw new Error('Failed to create user account');
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
    if (error.message.includes('Token used too late')) {
      return res.status(401).json({ error: 'Google token expired. Please try again.' });
    }
    next(error);
  }
});

module.exports = router;
