const express = require('express');
const router = express.Router();
const {
  getAllUtilisateurs,
  getUtilisateurById,
  createUtilisateur,
  login,
  updateUtilisateur,
  deleteUtilisateur
} = require('../controllers/utilisateurController');
const { verifyToken } = require('../middleware/auth');

// Public routes
router.post('/login', login);
router.post('/', createUtilisateur);

// Protected routes
router.get('/', verifyToken, getAllUtilisateurs);
router.get('/:id', verifyToken, getUtilisateurById);
router.put('/:id', verifyToken, updateUtilisateur);
router.delete('/:id', verifyToken, deleteUtilisateur);

module.exports = router;
