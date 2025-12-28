-- Script d'initialisation de la base de données avec des données de test

-- Insérer des utilisateurs de test
INSERT INTO utilisateur (nom, email, motdepasse, type) VALUES
('Ahmed Ben Ali', 'ahmed@parent.com', 'password123', 'parent'),
('Fatma Trabelsi', 'fatma@parent.com', 'password123', 'parent'),
('Mohamed Gharbi', 'mohamed@parent.com', 'password123', 'parent'),
('Directeur Les Petits Anges', 'directeur@petitsanges.com', 'password123', 'directeur'),
('Directeur Jardin d''Enfants', 'directeur@jardin.com', 'password123', 'directeur'),
('Directeur Étoiles', 'directeur@etoiles.com', 'password123', 'garderie');

-- Insérer des garderies de test
INSERT INTO garderie (nom, adresse, tarif, disponibilite, description) VALUES
('Les Petits Anges', '15 Avenue Habib Bourguiba, Tunis', 350.00, 5, 'Garderie moderne avec un programme éducatif complet, située en plein centre-ville. Nous proposons des activités créatives, sportives et éducatives adaptées à chaque âge.'),
('Jardin d''Enfants Étoiles', '42 Rue de la Liberté, Ariana', 280.00, 8, 'Un espace chaleureux et sécurisé pour vos enfants. Notre équipe qualifiée accompagne les enfants dans leur développement avec bienveillance.'),
('Crèche Les Bambins', '78 Avenue de Carthage, La Marsa', 420.00, 3, 'Crèche haut de gamme avec équipements modernes et personnel hautement qualifié. Programme bilingue français-anglais dès 2 ans.'),
('Garderie Soleil', '23 Rue Ibn Khaldoun, Sousse', 260.00, 12, 'Garderie familiale avec grand jardin extérieur. Activités en plein air quotidiennes et alimentation bio.'),
('Les P''tits Loups', '56 Avenue Mongi Slim, Sfax', 300.00, 6, 'Garderie spécialisée dans l''éveil musical et artistique. Ateliers de peinture, musique et danse.');

-- Insérer des enfants de test
INSERT INTO enfant (nom, age) VALUES
('Sofia Ben Ali', 3),
('Youssef Trabelsi', 4),
('Lina Gharbi', 2),
('Adam Ben Said', 5),
('Nour Mansour', 3);

-- Insérer des activités
INSERT INTO activite (titre, description) VALUES
('Peinture et Dessin', 'Atelier créatif pour développer l''imagination et la motricité fine'),
('Musique et Chant', 'Initiation musicale avec instruments adaptés aux enfants'),
('Jeux Éducatifs', 'Jeux de société et puzzles pour développer la logique'),
('Sport et Motricité', 'Activités physiques adaptées pour développer la coordination'),
('Lecture et Contes', 'Séances de lecture interactive pour stimuler le langage');

-- Insérer des programmes
INSERT INTO programme (contenu, date) VALUES
('Matinée: Accueil et jeux libres. Collation. Atelier peinture. Déjeuner.', '2024-11-25'),
('Après-midi: Sieste. Goûter. Activité musicale. Jeux en plein air.', '2024-11-25'),
('Matinée: Éveil corporel. Atelier créatif. Jeux éducatifs.', '2024-11-26'),
('Après-midi: Conte et lecture. Goûter. Jeux libres.', '2024-11-26');

-- Insérer des avis
INSERT INTO avis (note, commentaire) VALUES
(5, 'Excellente garderie! Mon enfant adore y aller chaque jour.'),
(4, 'Très bon accueil, personnel attentif et compétent.'),
(5, 'Je recommande vivement! Activités variées et enrichissantes.'),
(3, 'Bon établissement mais un peu cher pour notre budget.');

-- Insérer des paiements
INSERT INTO paiement (montant, datepaiement, statut) VALUES
(350.00, '2024-11-01', 'payé'),
(280.00, '2024-11-01', 'payé'),
(420.00, '2024-11-05', 'en attente'),
(260.00, '2024-11-10', 'payé');

-- Insérer des messages de test
INSERT INTO message (id, expediteurid, destinataireid, contenu, dateenvoi, estlu) VALUES
('msg1', '1', '4', 'Bonjour, je voudrais inscrire mon enfant dans votre garderie.', '2024-11-20 09:00:00', true),
('msg2', '4', '1', 'Bonjour! Nous serions ravis d''accueillir votre enfant. Quand souhaitez-vous commencer?', '2024-11-20 10:30:00', true),
('msg3', '1', '4', 'Idéalement début décembre. Quels sont les documents nécessaires?', '2024-11-20 14:00:00', false),
('msg4', '2', '5', 'Mon enfant sera absent demain pour raison médicale.', '2024-11-21 08:00:00', true),
('msg5', '5', '2', 'Merci de nous avoir prévenus. Bon rétablissement!', '2024-11-21 08:30:00', true);

-- Insérer des devoirs
INSERT INTO devoir (titre, contenu) VALUES
('Apprendre les couleurs', 'Réviser les couleurs primaires et secondaires avec les parents'),
('Compter jusqu''à 10', 'S''entraîner à compter les objets du quotidien'),
('Reconnaître son prénom', 'Apprendre à reconnaître et écrire les lettres de son prénom');

-- Insérer des notifications
INSERT INTO notification (message, dateenvoi) VALUES
('Nouvelle activité: Atelier cuisine mercredi prochain!', '2024-11-22 10:00:00'),
('Rappel: Réunion parents-enseignants vendredi à 17h', '2024-11-23 09:00:00'),
('Photos de la sortie au parc disponibles dans l''espace parents', '2024-11-24 14:00:00');
