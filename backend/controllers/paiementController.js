const pool = require('../db');

// Get all payments
const getAllPaiements = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM paiement ORDER BY datepaiement DESC');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur serveur' });
  }
};

// Get payment by ID
const getPaiementById = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('SELECT * FROM paiement WHERE idpaiement = $1', [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Paiement non trouvé' });
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur serveur' });
  }
};

// Get payments by parent ID (if the database schema supports this)
const getPaiementsByParent = async (req, res) => {
  try {
    const { parentId } = req.params;
    // Assuming there's a parent_id column in paiement table
    const result = await pool.query(
      'SELECT * FROM paiement WHERE parent_id = $1 ORDER BY datepaiement DESC',
      [parentId]
    );
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur serveur' });
  }
};

// Get payments by status
const getPaiementsByStatus = async (req, res) => {
  try {
    const { statut } = req.params;
    const result = await pool.query(
      'SELECT * FROM paiement WHERE statut = $1 ORDER BY datepaiement DESC',
      [statut]
    );
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur serveur' });
  }
};

// Create payment
const createPaiement = async (req, res) => {
  try {
    const { montant, datePaiement, statut, parent_id, enfant_id, garderie_id } = req.body;
    
    // Validation
    if (!montant || !datePaiement || !statut) {
      return res.status(400).json({ error: 'Les champs montant, datePaiement et statut sont obligatoires' });
    }

    // Build query based on available columns
    const result = await pool.query(
      'INSERT INTO paiement (montant, datepaiement, statut) VALUES ($1, $2, $3) RETURNING *',
      [montant, datePaiement, statut]
    );
    
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur lors de la création du paiement' });
  }
};

// Update payment
const updatePaiement = async (req, res) => {
  try {
    const { id } = req.params;
    const { montant, datePaiement, statut } = req.body;
    
    const result = await pool.query(
      'UPDATE paiement SET montant = $1, datepaiement = $2, statut = $3 WHERE idpaiement = $4 RETURNING *',
      [montant, datePaiement, statut, id]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Paiement non trouvé' });
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur lors de la mise à jour du paiement' });
  }
};

// Delete payment
const deletePaiement = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('DELETE FROM paiement WHERE idpaiement = $1 RETURNING *', [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Paiement non trouvé' });
    }
    
    res.json({ message: 'Paiement supprimé', paiement: result.rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur lors de la suppression' });
  }
};

module.exports = {
  getAllPaiements,
  getPaiementById,
  getPaiementsByParent,
  getPaiementsByStatus,
  createPaiement,
  updatePaiement,
  deletePaiement
};
