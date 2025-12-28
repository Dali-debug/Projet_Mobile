const express = require('express');
const router = express.Router();
const {
  getAllPaiements,
  getPaiementById,
  getPaiementsByParent,
  getPaiementsByStatus,
  createPaiement,
  updatePaiement,
  deletePaiement
} = require('../controllers/paiementController');
const { verifyToken } = require('../middleware/auth');

// All routes are protected
router.get('/', verifyToken, getAllPaiements);
router.get('/by-parent/:parentId', verifyToken, getPaiementsByParent);
router.get('/by-status/:statut', verifyToken, getPaiementsByStatus);
router.get('/:id', verifyToken, getPaiementById);
router.post('/', verifyToken, createPaiement);
router.put('/:id', verifyToken, updatePaiement);
router.delete('/:id', verifyToken, deletePaiement);

module.exports = router;
