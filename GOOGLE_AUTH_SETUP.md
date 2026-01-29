# Google Sign-In Setup Guide

This guide will walk you through setting up Google Authentication for your PThrive app using Google Cloud Console.

## Prerequisites

- A Google account
- Your backend is hosted at: `https://pthrive.onrender.com`

## Step 1: Create a Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Click on the project dropdown at the top of the page
3. Click **"New Project"**
4. Enter a project name (e.g., "PThrive App")
5. Click **"Create"**
6. Wait for the project to be created, then select it

## Step 2: Enable Google+ API

1. In the left sidebar, go to **"APIs & Services"** > **"Library"**
2. Search for **"Google+ API"** or **"Google Identity"**
3. Click on **"Google+ API"**
4. Click **"Enable"**

## Step 3: Configure OAuth Consent Screen

1. Go to **"APIs & Services"** > **"OAuth consent screen"**
2. Select **"External"** as the user type
3. Click **"Create"**

### Fill in the required information:

- **App name**: PThrive
- **User support email**: Your email address
- **App logo**: (Optional) Upload your app logo
- **Application home page**: `https://pthrive.onrender.com`
- **Authorized domains**: Add `onrender.com`
- **Developer contact information**: Your email address

4. Click **"Save and Continue"**

### Scopes (Step 2):

5. Click **"Add or Remove Scopes"**
6. Select these scopes:
   - `userinfo.email`
   - `userinfo.profile`
   - `openid`
7. Click **"Update"** then **"Save and Continue"**

### Test Users (Step 3):

8. Add test users if your app is in testing mode (add your email and any testers)
9. Click **"Save and Continue"**

### Summary (Step 4):

10. Review your settings and click **"Back to Dashboard"**

## Step 4: Create OAuth 2.0 Credentials

1. Go to **"APIs & Services"** > **"Credentials"**
2. Click **"Create Credentials"** > **"OAuth client ID"**
3. Select **"Web application"** as the application type

### Configure the OAuth client:

- **Name**: PThrive Web Client

#### Authorized JavaScript origins:
Add these URLs (click "+ Add URI" for each):
```
https://pthrive.onrender.com
```

#### Authorized redirect URIs:
Add these URLs (click "+ Add URI" for each):
```
https://pthrive.onrender.com/api/auth/google/callback
https://pthrive.onrender.com/auth/google/callback
```

4. Click **"Create"**

## Step 5: Save Your Credentials

After creating the OAuth client, you'll see a popup with:
- **Client ID**: A long string ending in `.apps.googleusercontent.com`
- **Client Secret**: A shorter secret string

**IMPORTANT**: Copy both of these values immediately!

### Add to your backend `.env` file:

```env
GOOGLE_CLIENT_ID=your_client_id_here.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your_client_secret_here
GOOGLE_CALLBACK_URL=https://pthrive.onrender.com/api/auth/google/callback
```

## Step 6: Update Render Environment Variables

1. Go to your [Render Dashboard](https://dashboard.render.com/)
2. Select your PThrive backend service
3. Go to **"Environment"** tab
4. Add these environment variables:
   - `GOOGLE_CLIENT_ID`: (paste your Client ID)
   - `GOOGLE_CLIENT_SECRET`: (paste your Client Secret)
   - `GOOGLE_CALLBACK_URL`: `https://pthrive.onrender.com/api/auth/google/callback`
5. Click **"Save Changes"**
6. Your service will automatically redeploy

## Step 7: Test Your Setup

1. Open your app
2. Click on "Sign in with Google"
3. You should see the Google sign-in popup
4. Select your Google account
5. Grant permissions
6. You should be redirected back to your app and logged in

## Troubleshooting

### "Error 400: redirect_uri_mismatch"
- Double-check that your redirect URI in Google Cloud Console exactly matches: `https://pthrive.onrender.com/api/auth/google/callback`
- Make sure there are no trailing slashes
- Wait a few minutes after making changes (Google can take time to propagate)

### "Access blocked: This app's request is invalid"
- Make sure you've completed the OAuth consent screen configuration
- Verify that the authorized domains include `onrender.com`

### "Error 401: invalid_client"
- Check that your `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` are correctly set in Render
- Make sure there are no extra spaces or quotes in the environment variables

### Still in testing mode?
- If your OAuth consent screen is in "Testing" mode, only test users you've added can sign in
- To allow anyone to sign in, publish your app (go to OAuth consent screen > "Publish App")

## Important Notes

- **Never commit** your `.env` file with real credentials to Git
- Keep your `GOOGLE_CLIENT_SECRET` secure
- If you change your backend URL, update all the URLs in Google Cloud Console
- For mobile apps (Android/iOS), you'll need to create separate OAuth clients with different configurations

## Need Help?

If you encounter issues:
1. Check the browser console for error messages
2. Check your backend logs in Render
3. Verify all URLs match exactly (no http vs https mismatches)
4. Make sure your backend is running and accessible at `https://pthrive.onrender.com`
