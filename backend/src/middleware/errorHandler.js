const errorHandler = (err, req, res, next) => {
  // Log error for debugging (server-side only)
  console.error('Error:', {
    message: err.message,
    stack: err.stack,
    code: err.code,
    name: err.name
  });

  // Never expose technical details to client
  let statusCode = 500;
  let userMessage = 'Something went wrong. Please try again later.';

  // Authentication errors
  if (err.name === 'JsonWebTokenError' || err.name === 'TokenExpiredError') {
    statusCode = 401;
    userMessage = 'Session expired. Please login again.';
  }
  
  // Validation errors (only if message is safe)
  else if (err.name === 'ValidationError' && err.message && !err.message.includes('database') && !err.message.includes('query')) {
    statusCode = 400;
    userMessage = err.message;
  }
  
  // Duplicate email
  else if (err.code === '23505' || err.message?.includes('already registered')) {
    statusCode = 409;
    userMessage = 'Email already registered. Please login instead.';
  }
  
  // Invalid credentials
  else if (err.message?.includes('Invalid email or password')) {
    statusCode = 401;
    userMessage = 'Invalid email or password';
  }
  
  // Custom safe error messages
  else if (err.status && err.message && !containsTechnicalDetails(err.message)) {
    statusCode = err.status;
    userMessage = err.message;
  }

  res.status(statusCode).json({
    error: userMessage
  });
};

// Helper function to detect technical details in error messages
function containsTechnicalDetails(message) {
  const technicalKeywords = [
    'database', 'query', 'sql', 'connection', 'supabase',
    'postgres', 'table', 'column', 'constraint', 'schema',
    'jwt', 'token', 'secret', 'key', 'api', 'endpoint',
    'stack', 'trace', 'undefined', 'null', 'function',
    'module', 'require', 'import', 'node_modules'
  ];
  
  const lowerMessage = message.toLowerCase();
  return technicalKeywords.some(keyword => lowerMessage.includes(keyword));
}

module.exports = errorHandler;
