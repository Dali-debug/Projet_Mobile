const jwt = require('jsonwebtoken');

// Secret key for JWT - should be stored in environment variables
const JWT_SECRET = process.env.JWT_SECRET || 'votre_secret_jwt_super_securise';

// Middleware to verify JWT token
const verifyToken = (req, res, next) => {
  const token = req.headers['authorization']?.split(' ')[1]; // Bearer TOKEN

  if (!token) {
    return res.status(403).json({ error: 'Token requis pour l\'authentification' });
  }

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.user = decoded; // Add user info to request
    next();
  } catch (err) {
    return res.status(401).json({ error: 'Token invalide ou expiré' });
  }
};

// Generate JWT token
const generateToken = (userId, email, type) => {
  return jwt.sign(
    { id: userId, email, type },
    JWT_SECRET,
    { expiresIn: '24h' }
  );
};

module.exports = {
  verifyToken,
  generateToken,
  JWT_SECRET
};
