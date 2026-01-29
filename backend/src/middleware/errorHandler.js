const errorHandler = (err, req, res, next) => {
  console.error('Error:', err);

  // Network/Connection errors
  if (err.code === 'ECONNREFUSED') {
    return res.status(503).json({
      error: 'Database connection failed. Please try again later.'
    });
  }

  // Validation errors
  if (err.name === 'ValidationError') {
    return res.status(400).json({
      error: err.message || 'Validation failed'
    });
  }

  // JWT errors
  if (err.name === 'JsonWebTokenError') {
    return res.status(401).json({
      error: 'Invalid token. Please login again.'
    });
  }

  if (err.name === 'TokenExpiredError') {
    return res.status(401).json({
      error: 'Session expired. Please login again.'
    });
  }

  // Supabase errors
  if (err.code === '23505') {
    return res.status(409).json({
      error: 'Email already exists. Please use a different email.'
    });
  }

  // Default error
  res.status(err.status || 500).json({
    error: err.message || 'Internal server error. Please try again later.'
  });
};

module.exports = errorHandler;
