-- Fix RLS policy to allow user registration
-- Run this in your Supabase SQL Editor

-- Allow anyone to insert new users (for registration)
CREATE POLICY "Allow public user registration" ON users 
  FOR INSERT 
  WITH CHECK (true);

-- Alternative: If you want to use service role key instead, 
-- you can disable RLS for service role by using the service_role key in your backend
-- But the above policy is the recommended approach for public registration

