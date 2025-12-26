const express = require('express');
const router = express.Router();
const pool = require('../db');

// Obtenir tous les utilisateurs
router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM utilisateur');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Obtenir un utilisateur par ID
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('SELECT * FROM utilisateur WHERE id = $1', [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Utilisateur non trouvé' });
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Créer un utilisateur
router.post('/', async (req, res) => {
  try {
    const { nom, email, motDePasse, type, telephone } = req.body;
    
    // Validation des champs requis
    if (!nom || !email || !motDePasse || !type) {
      return res.status(400).json({ error: 'Tous les champs (nom, email, motDePasse, type) sont obligatoires' });
    }

    // Créer l'utilisateur minimal
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
      motdepasse: motDePasse,
      telephone: telephone || null
    };

    // Créer le parent ou directeur avec les infos complètes
    if (type === 'parent') {
      await pool.query(
        'INSERT INTO parent (id, nom, email, motdepasse, telephone) VALUES ($1, $2, $3, $4, $5)',
        [utilisateur.id, nom, email, motDePasse, telephone || null]
      );
    } else if (type === 'directeur' || type === 'garderie') {
      // Pour type directeur ET garderie, on insère dans la table directeur
      await pool.query(
        'INSERT INTO directeur (id, nom, email, motdepasse, telephone) VALUES ($1, $2, $3, $4, $5)',
        [utilisateur.id, nom, email, motDePasse, telephone || null]
      );
    }

    res.status(201).json(userDetails);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur lors de la création' });
  }
});

// Authentification
router.post('/login', async (req, res) => {
  try {
    const { email, motDePasse } = req.body;
    // Chercher l'utilisateur par email
    const utilisateurResult = await pool.query(
      'SELECT * FROM utilisateur WHERE email = $1',
      [email]
    );
    if (utilisateurResult.rows.length === 0) {
      return res.status(401).json({ error: 'Email ou mot de passe incorrect' });
    }
    const utilisateur = utilisateurResult.rows[0];

    let userDetails;
    if (utilisateur.type === 'parent') {
      const parentResult = await pool.query(
        'SELECT * FROM parent WHERE email = $1',
        [email]
      );
      if (parentResult.rows.length === 0 || parentResult.rows[0].motdepasse !== motDePasse) {
        return res.status(401).json({ error: 'Email ou mot de passe incorrect' });
      }
      userDetails = parentResult.rows[0];
    } else if (utilisateur.type === 'directeur' || utilisateur.type === 'garderie') {
      // Pour type directeur ou garderie, comparer le mot de passe avec la table directeur
      const directeurResult = await pool.query(
        'SELECT * FROM directeur WHERE email = $1',
        [email]
      );
      if (directeurResult.rows.length === 0 || directeurResult.rows[0].motdepasse !== motDePasse) {
        return res.status(401).json({ error: 'Email ou mot de passe incorrect' });
      }
      userDetails = directeurResult.rows[0];
    } else {
      return res.status(401).json({ error: 'Type utilisateur inconnu' });
    }

    // Fusionner les infos utilisateur et userDetails
    res.json({
      id: utilisateur.id,
      email: utilisateur.email,
      type: utilisateur.type,
      nom: userDetails.nom,
      telephone: userDetails.telephone || null,
      motdepasse: userDetails.motdepasse
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Mettre à jour un utilisateur
router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { nom, email, type, telephone } = req.body;
    const result = await pool.query(
      'UPDATE utilisateur SET nom = $1, email = $2, type = $3, telephone = $4 WHERE id = $5 RETURNING *',
      [nom, email, type, telephone || null, id]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Utilisateur non trouvé' });
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erreur lors de la mise à jour' });
  }
});

// Supprimer un utilisateur
router.delete('/:id', async (req, res) => {
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
});

module.exports = router;
