const pool = require('../db');
const bcrypt = require('bcrypt');
const { generateToken } = require('../middleware/auth');

// Get all users
const getAllUtilisateurs = async (req, res) => {
  try {
    const result = await pool.query('SELECT id, email, type FROM utilisateur');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur serveur' });
  }
};

// Get user by ID
const getUtilisateurById = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('SELECT id, email, type FROM utilisateur WHERE id = $1', [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Utilisateur non trouvé' });
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur serveur' });
  }
};

// Create user
const createUtilisateur = async (req, res) => {
  try {
    const { nom, email, motDePasse, type, telephone } = req.body;
    
    // Validation
    if (!nom || !email || !motDePasse || !type) {
      return res.status(400).json({ error: 'Tous les champs (nom, email, motDePasse, type) sont obligatoires' });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(motDePasse, 10);

    // Create user in utilisateur table
    const utilisateurResult = await pool.query(
      'INSERT INTO utilisateur (email, type) VALUES ($1, $2) RETURNING *',
      [email, type]
    );
    const utilisateur = utilisateurResult.rows[0];

    let userDetails = {
      id: utilisateur.id,
      email: utilisateur.email,
      type: utilisateur.type,
      nom: nom,
      telephone: telephone || null
    };

    // Create in parent or directeur table with hashed password
    if (type === 'parent') {
      await pool.query(
        'INSERT INTO parent (id, nom, email, motdepasse, telephone) VALUES ($1, $2, $3, $4, $5)',
        [utilisateur.id, nom, email, hashedPassword, telephone || null]
      );
    } else if (type === 'directeur' || type === 'garderie') {
      await pool.query(
        'INSERT INTO directeur (id, nom, email, motdepasse, telephone) VALUES ($1, $2, $3, $4, $5)',
        [utilisateur.id, nom, email, hashedPassword, telephone || null]
      );
    }

    res.status(201).json(userDetails);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur lors de la création' });
  }
};

// Login
const login = async (req, res) => {
  try {
    const { email, motDePasse } = req.body;
    
    // Find user by email
    const utilisateurResult = await pool.query(
      'SELECT * FROM utilisateur WHERE email = $1',
      [email]
    );
    
    if (utilisateurResult.rows.length === 0) {
      return res.status(401).json({ error: 'Email ou mot de passe incorrect' });
    }
    
    const utilisateur = utilisateurResult.rows[0];
    let userDetails;
    let hashedPassword;

    if (utilisateur.type === 'parent') {
      const parentResult = await pool.query(
        'SELECT * FROM parent WHERE email = $1',
        [email]
      );
      if (parentResult.rows.length === 0) {
        return res.status(401).json({ error: 'Email ou mot de passe incorrect' });
      }
      userDetails = parentResult.rows[0];
      hashedPassword = userDetails.motdepasse;
    } else if (utilisateur.type === 'directeur' || utilisateur.type === 'garderie') {
      const directeurResult = await pool.query(
        'SELECT * FROM directeur WHERE email = $1',
        [email]
      );
      if (directeurResult.rows.length === 0) {
        return res.status(401).json({ error: 'Email ou mot de passe incorrect' });
      }
      userDetails = directeurResult.rows[0];
      hashedPassword = userDetails.motdepasse;
    } else {
      return res.status(401).json({ error: 'Type utilisateur inconnu' });
    }

    // Verify password (check if it's hashed or plain text for backward compatibility)
    let passwordMatch = false;
    if (hashedPassword.startsWith('$2b$') || hashedPassword.startsWith('$2a$')) {
      // Hashed password
      passwordMatch = await bcrypt.compare(motDePasse, hashedPassword);
    } else {
      // Plain text password (for backward compatibility with existing data)
      passwordMatch = motDePasse === hashedPassword;
    }

    if (!passwordMatch) {
      return res.status(401).json({ error: 'Email ou mot de passe incorrect' });
    }

    // Generate JWT token
    const token = generateToken(utilisateur.id, utilisateur.email, utilisateur.type);

    // Return user details with token
    res.json({
      id: utilisateur.id,
      email: utilisateur.email,
      type: utilisateur.type,
      nom: userDetails.nom,
      telephone: userDetails.telephone || null,
      token: token
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur serveur' });
  }
};

// Update user
const updateUtilisateur = async (req, res) => {
  try {
    const { id } = req.params;
    const { nom, email, type, telephone } = req.body;
    const result = await pool.query(
      'UPDATE utilisateur SET email = $1, type = $2 WHERE id = $3 RETURNING *',
      [email, type, id]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Utilisateur non trouvé' });
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur lors de la mise à jour' });
  }
};

// Delete user
const deleteUtilisateur = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('DELETE FROM utilisateur WHERE id = $1 RETURNING *', [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Utilisateur non trouvé' });
    }
    
    res.json({ message: 'Utilisateur supprimé', utilisateur: result.rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur lors de la suppression' });
  }
};

module.exports = {
  getAllUtilisateurs,
  getUtilisateurById,
  createUtilisateur,
  login,
  updateUtilisateur,
  deleteUtilisateur
};
