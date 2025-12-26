const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Routes
const utilisateurRoutes = require('./routes/utilisateur');
const garderieRoutes = require('./routes/garderie');
const enfantRoutes = require('./routes/enfant');
const messageRoutes = require('./routes/message');

app.use('/api/utilisateurs', utilisateurRoutes);
app.use('/api/garderies', garderieRoutes);
app.use('/api/enfants', enfantRoutes);
app.use('/api/messages', messageRoutes);

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', message: 'API fonctionnelle' });
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Serveur démarré sur le port ${PORT}`);
});
