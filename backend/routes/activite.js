const express = require('express');
const router = express.Router();
const {
  getAllActivites,
  getActiviteById,
  createActivite,
  updateActivite,
  deleteActivite
} = require('../controllers/activiteController');
const { verifyToken } = require('../middleware/auth');

// All routes are protected
router.get('/', verifyToken, getAllActivites);
router.get('/:id', verifyToken, getActiviteById);
router.post('/', verifyToken, createActivite);
router.put('/:id', verifyToken, updateActivite);
router.delete('/:id', verifyToken, deleteActivite);

module.exports = router;
