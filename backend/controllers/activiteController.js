const pool = require('../db');

// Get all activities
const getAllActivites = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM activite ORDER BY titre');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur serveur' });
  }
};

// Get activity by ID
const getActiviteById = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('SELECT * FROM activite WHERE idactivite = $1', [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Activité non trouvée' });
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur serveur' });
  }
};

// Create activity
const createActivite = async (req, res) => {
  try {
    const { titre, description } = req.body;
    
    // Validation
    if (!titre || !description) {
      return res.status(400).json({ error: 'Les champs titre et description sont obligatoires' });
    }

    const result = await pool.query(
      'INSERT INTO activite (titre, description) VALUES ($1, $2) RETURNING *',
      [titre, description]
    );
    
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur lors de la création de l\'activité' });
  }
};

// Update activity
const updateActivite = async (req, res) => {
  try {
    const { id } = req.params;
    const { titre, description } = req.body;
    
    const result = await pool.query(
      'UPDATE activite SET titre = $1, description = $2 WHERE idactivite = $3 RETURNING *',
      [titre, description, id]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Activité non trouvée' });
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur lors de la mise à jour de l\'activité' });
  }
};

// Delete activity
const deleteActivite = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('DELETE FROM activite WHERE idactivite = $1 RETURNING *', [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Activité non trouvée' });
    }
    
    res.json({ message: 'Activité supprimée', activite: result.rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur lors de la suppression' });
  }
};

module.exports = {
  getAllActivites,
  getActiviteById,
  createActivite,
  updateActivite,
  deleteActivite
};
