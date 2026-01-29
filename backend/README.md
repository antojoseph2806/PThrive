# PThrive Backend

Node.js REST API for PThrive application with Supabase integration.

## Getting Started

### Prerequisites
- Node.js (v18 or higher)
- npm or yarn
- Supabase account

### Installation

1. Install dependencies:
```bash
npm install
```

2. Configure environment:
```bash
cp .env.example .env
```

Edit `.env` and add your Supabase credentials:
- SUPABASE_URL
- SUPABASE_ANON_KEY
- JWT_SECRET

3. Setup database:
Run the SQL script in `database/schema.sql` in your Supabase SQL editor.

4. Start the server:
```bash
npm run dev
```

The API will be available at `http://localhost:3000`

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user

### User
- `GET /api/user/profile` - Get user profile (requires auth)

## Project Structure
```
src/
├── config/         # Configuration files
├── middleware/     # Express middleware
├── routes/         # API routes
└── server.js       # Entry point
```
