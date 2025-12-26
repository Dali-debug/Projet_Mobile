const express = require('express');
const router = express.Router();
const pool = require('../db');

// Obtenir tous les enfants
router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM enfant');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Obtenir les enfants d'un parent
router.get('/by-parent/:parentId', async (req, res) => {
  try {
    const { parentId } = req.params;
    const result = await pool.query(
      `SELECT e.*, g.nom as garderie_nom, g.adresse as garderie_adresse 
       FROM enfant e 
       LEFT JOIN garderie g ON e.garderie_id = g.idgarderie 
       WHERE e.parent_id = $1`,
      [parentId]
    );
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Obtenir les enfants d'une garderie
router.get('/by-garderie/:garderieId', async (req, res) => {
  try {
    const { garderieId } = req.params;
    const result = await pool.query(
      `SELECT e.*, p.nom as parent_nom, p.telephone as parent_telephone 
       FROM enfant e 
       LEFT JOIN parent p ON e.parent_id = p.id 
       WHERE e.garderie_id = $1`,
      [garderieId]
    );
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Obtenir un enfant par ID
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('SELECT * FROM enfant WHERE idenfant = $1', [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Enfant non trouvé' });
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Créer un enfant
router.post('/', async (req, res) => {
  const client = await pool.connect();
  try {
    const { nom, age, parent_id, garderie_id } = req.body;
    
    // Validation des champs requis
    if (!nom || !age) {
      return res.status(400).json({ error: 'Le nom et l\'âge sont obligatoires' });
    }
    
    await client.query('BEGIN');
    
    // Si une garderie est spécifiée, vérifier et décrémenter la disponibilité
    if (garderie_id) {
      const garderieCheck = await client.query(
        'SELECT disponibilite FROM garderie WHERE idgarderie = $1 FOR UPDATE',
        [garderie_id]
      );
      
      if (garderieCheck.rows.length === 0) {
        await client.query('ROLLBACK');
        return res.status(404).json({ error: 'Garderie non trouvée' });
      }
      
      if (garderieCheck.rows[0].disponibilite <= 0) {
        await client.query('ROLLBACK');
        return res.status(400).json({ error: 'Plus de places disponibles dans cette garderie' });
      }
      
      // Décrémenter la disponibilité
      await client.query(
        'UPDATE garderie SET disponibilite = disponibilite - 1 WHERE idgarderie = $1',
        [garderie_id]
      );
    }
    
    // Créer l'enfant
    const result = await client.query(
      'INSERT INTO enfant (nom, age, parent_id, garderie_id) VALUES ($1, $2, $3, $4) RETURNING *',
      [nom, age, parent_id || null, garderie_id || null]
    );
    
    await client.query('COMMIT');
    res.status(201).json(result.rows[0]);
  } catch (err) {
    await client.query('ROLLBACK');
    console.error(err);
    res.status(500).json({ error: 'Erreur lors de la création' });
  } finally {
    client.release();
  }
});

// Mettre à jour un enfant
router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { nom, age } = req.body;
    const result = await pool.query(
      'UPDATE enfant SET nom = $1, age = $2 WHERE idenfant = $3 RETURNING *',
      [nom, age, id]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Enfant non trouvé' });
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur lors de la mise à jour' });
  }
});

// Supprimer un enfant
router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('DELETE FROM enfant WHERE idenfant = $1 RETURNING *', [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Enfant non trouvé' });
    }
    
    res.json({ message: 'Enfant supprimé', enfant: result.rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur lors de la suppression' });
  }
});

module.exports = router;
