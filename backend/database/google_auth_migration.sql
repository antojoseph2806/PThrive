-- Migration to add Google Sign-In support
-- Run this in your Supabase SQL Editor

-- Add Google authentication fields to users table
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS google_id VARCHAR(255) UNIQUE,
ADD COLUMN IF NOT EXISTS profile_picture TEXT;

-- Make password optional for Google sign-in users
ALTER TABLE users 
ALTER COLUMN password DROP NOT NULL;

-- Create index for faster Google ID lookups
CREATE INDEX IF NOT EXISTS idx_users_google_id ON users(google_id);

-- Update existing users to have empty string for phone_number if NULL
UPDATE users SET phone_number = '' WHERE phone_number IS NULL;
