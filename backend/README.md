# Backend API - Garderie

Backend Node.js avec Express et PostgreSQL pour l'application de gestion de garderie.

## Installation

```bash
cd backend
npm install
```

## Configuration

Créez un fichier `.env` avec les variables suivantes:

```
PORT=3000
DB_HOST=localhost
DB_PORT=5432
DB_USER=dali
DB_PASSWORD=testdali
DB_NAME=mobile
```

## Initialiser la base de données

Pour ajouter des données de test, connectez-vous à PostgreSQL et exécutez:

```bash
docker exec -it my_postgres_db psql -U dali -d mobile -f /path/to/init-db.sql
```

Ou copiez le fichier dans le container puis exécutez-le:

```bash
docker cp init-db.sql my_postgres_db:/init-db.sql
docker exec -it my_postgres_db psql -U dali -d mobile -f /init-db.sql
```

## Démarrer le serveur

```bash
npm start
```

Ou en mode développement avec rechargement automatique:

```bash
npm run dev
```

## API Endpoints

### Utilisateurs
- `GET /api/utilisateurs` - Liste tous les utilisateurs
- `GET /api/utilisateurs/:id` - Obtenir un utilisateur
- `POST /api/utilisateurs` - Créer un utilisateur
- `POST /api/utilisateurs/login` - Authentification
- `PUT /api/utilisateurs/:id` - Mettre à jour un utilisateur
- `DELETE /api/utilisateurs/:id` - Supprimer un utilisateur

### Garderies
- `GET /api/garderies` - Liste toutes les garderies
- `GET /api/garderies/:id` - Obtenir une garderie
- `POST /api/garderies` - Créer une garderie
- `PUT /api/garderies/:id` - Mettre à jour une garderie
- `DELETE /api/garderies/:id` - Supprimer une garderie

### Enfants
- `GET /api/enfants` - Liste tous les enfants
- `GET /api/enfants/:id` - Obtenir un enfant
- `POST /api/enfants` - Créer un enfant
- `PUT /api/enfants/:id` - Mettre à jour un enfant
- `DELETE /api/enfants/:id` - Supprimer un enfant

### Messages
- `GET /api/messages` - Liste tous les messages
- `GET /api/messages/conversation/:expediteurId/:destinataireId` - Messages d'une conversation
- `POST /api/messages` - Créer un message
- `PUT /api/messages/:id/lu` - Marquer comme lu

## Test de l'API

```bash
curl http://localhost:3000/api/health
curl http://localhost:3000/api/garderies
```
