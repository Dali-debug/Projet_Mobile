const express = require('express');
const router = express.Router();
const pool = require('../db');

// Obtenir tous les messages
router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM message ORDER BY dateenvoi DESC');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Obtenir les messages d'une conversation
router.get('/conversation/:expediteurId/:destinataireId', async (req, res) => {
  try {
    const { expediteurId, destinataireId } = req.params;
    const result = await pool.query(
      'SELECT * FROM message WHERE (expediteurid = $1 AND destinataireid = $2) OR (expediteurid = $2 AND destinataireid = $1) ORDER BY dateenvoi ASC',
      [expediteurId, destinataireId]
    );
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Créer un message
router.post('/', async (req, res) => {
  try {
    const { id, expediteurId, destinataireId, contenu, dateEnvoi, estLu } = req.body;
    const result = await pool.query(
      'INSERT INTO message (id, expediteurid, destinataireid, contenu, dateenvoi, estlu) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
      [id, expediteurId, destinataireId, contenu, dateEnvoi || new Date(), estLu || false]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur lors de la création' });
  }
});

// Marquer un message comme lu
router.put('/:id/lu', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(
      'UPDATE message SET estlu = true WHERE id = $1 RETURNING *',
      [id]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Message non trouvé' });
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur lors de la mise à jour' });
  }
});

module.exports = router;
