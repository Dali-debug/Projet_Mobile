const express = require('express');
const router = express.Router();
const pool = require('../db');

// Obtenir toutes les garderies
router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM garderie ORDER BY nom');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Obtenir une garderie par directeur
router.get('/by-directeur/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('SELECT * FROM garderie WHERE directeur_id = $1', [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Aucune garderie trouvée pour ce directeur' });
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Obtenir une garderie par ID
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('SELECT * FROM garderie WHERE idgarderie = $1', [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Garderie non trouvée' });
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Créer une garderie
router.post('/', async (req, res) => {
  try {
    const { nom, adresse, tarif, disponibilite, description, directeur_id, photo, nombre_places } = req.body;
    // Vérifier que tous les champs requis sont présents
    if (!nom || !adresse || tarif === undefined || disponibilite === undefined || !description || !directeur_id) {
      return res.status(400).json({ error: 'Tous les champs sont obligatoires.' });
    }
    
    // Si nombre_places n'est pas fourni, utiliser disponibilite comme valeur par défaut
    const totalPlaces = nombre_places !== undefined ? nombre_places : disponibilite;
    
    const result = await pool.query(
      'INSERT INTO garderie (nom, adresse, tarif, disponibilite, description, directeur_id, photo, nombre_places) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *',
      [nom, adresse, tarif, disponibilite, description, directeur_id, photo || null, totalPlaces]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur lors de la création' });
  }
});

// Mettre à jour une garderie
router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { nom, adresse, tarif, disponibilite, description } = req.body;
    const result = await pool.query(
      'UPDATE garderie SET nom = $1, adresse = $2, tarif = $3, disponibilite = $4, description = $5 WHERE idgarderie = $6 RETURNING *',
      [nom, adresse, tarif, disponibilite, description, id]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Garderie non trouvée' });
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur lors de la mise à jour' });
  }
});

// Supprimer une garderie
router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('DELETE FROM garderie WHERE idgarderie = $1 RETURNING *', [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Garderie non trouvée' });
    }
    
    res.json({ message: 'Garderie supprimée', garderie: result.rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur lors de la suppression' });
  }
});

module.exports = router;
