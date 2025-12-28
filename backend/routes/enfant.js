const express = require('express');
const router = express.Router();
const {
  getAllEnfants,
  getEnfantsByParent,
  getEnfantsByGarderie,
  getEnfantById,
  createEnfant,
  updateEnfant,
  deleteEnfant
} = require('../controllers/enfantController');
const { verifyToken } = require('../middleware/auth');

// All routes are protected
router.get('/', verifyToken, getAllEnfants);
router.get('/by-parent/:parentId', verifyToken, getEnfantsByParent);
router.get('/by-garderie/:garderieId', verifyToken, getEnfantsByGarderie);
router.get('/:id', verifyToken, getEnfantById);
router.post('/', verifyToken, createEnfant);
router.put('/:id', verifyToken, updateEnfant);
router.delete('/:id', verifyToken, deleteEnfant);

module.exports = router;
