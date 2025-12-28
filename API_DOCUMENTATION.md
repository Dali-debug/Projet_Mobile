# Backend API & Flutter Service Layer - Documentation

## Overview

This project provides a complete REST API backend built with Node.js + Express + PostgreSQL, and a Flutter service layer for connecting the mobile app to the database.

## Architecture

```
backend/
├── controllers/          # Business logic for each resource
│   ├── utilisateurController.js
│   ├── enfantController.js
│   ├── paiementController.js
│   └── activiteController.js
├── middleware/          # Authentication middleware
│   └── auth.js
├── routes/             # API route definitions
│   ├── utilisateur.js
│   ├── enfant.js
│   ├── paiement.js
│   ├── activite.js
│   ├── garderie.js
│   └── message.js
├── db.js               # PostgreSQL connection
├── server.js           # Express server setup
├── Dockerfile          # Docker configuration
└── package.json        # Dependencies

lib/services/           # Flutter service layer
├── base_service.dart   # Base HTTP service
├── auth_service.dart   # Authentication service
└── data_service.dart   # Data fetching service
```

## Backend Setup

### Prerequisites
- Node.js 18+ 
- PostgreSQL 15+
- Docker (optional)

### Installation

1. **Install dependencies:**
```bash
cd backend
npm install
```

2. **Configure environment:**
Create or update `.env` file:
```env
PORT=3000
DB_HOST=localhost
DB_PORT=5432
DB_USER=dali
DB_PASSWORD=testdali
DB_NAME=mobile
JWT_SECRET=votre_secret_jwt_super_securise_changez_moi_en_production
```

3. **Start the server:**
```bash
# Development mode (with auto-reload)
npm run dev

# Production mode
npm start
```

### Using Docker Compose

Run the entire stack (PostgreSQL + API) with:

```bash
# Start services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

## API Endpoints

Base URL: `http://localhost:3000/api`

### Authentication

All protected endpoints require JWT token in Authorization header:
```
Authorization: Bearer <token>
```

#### POST `/utilisateurs/login`
Login user

**Request:**
```json
{
  "email": "ahmed@parent.com",
  "motDePasse": "password123"
}
```

**Response:**
```json
{
  "id": 1,
  "email": "ahmed@parent.com",
  "type": "parent",
  "nom": "Ahmed Ben Ali",
  "telephone": "98765432",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

#### POST `/utilisateurs`
Register new user

**Request:**
```json
{
  "nom": "Ahmed Ben Ali",
  "email": "ahmed@parent.com",
  "motDePasse": "password123",
  "type": "parent",
  "telephone": "98765432"
}
```

### Utilisateurs (Users) - Protected Routes

#### GET `/utilisateurs`
Get all users (requires auth)

#### GET `/utilisateurs/:id`
Get user by ID (requires auth)

#### PUT `/utilisateurs/:id`
Update user (requires auth)

#### DELETE `/utilisateurs/:id`
Delete user (requires auth)

### Enfants (Children) - Protected Routes

#### GET `/enfants`
Get all children

#### GET `/enfants/by-parent/:parentId`
Get children by parent ID

#### GET `/enfants/by-garderie/:garderieId`
Get children by nursery ID

#### GET `/enfants/:id`
Get child by ID

#### POST `/enfants`
Create new child

**Request:**
```json
{
  "nom": "Sofia",
  "age": 3,
  "parent_id": 1,
  "garderie_id": 2
}
```

#### PUT `/enfants/:id`
Update child

#### DELETE `/enfants/:id`
Delete child

### Paiements (Payments) - Protected Routes

#### GET `/paiements`
Get all payments

#### GET `/paiements/by-parent/:parentId`
Get payments by parent ID

**Note:** This endpoint is not currently implemented as the paiement table doesn't have a parent_id column. Returns 501 Not Implemented.

#### GET `/paiements/by-status/:statut`
Get payments by status (payé, en attente)

#### GET `/paiements/:id`
Get payment by ID

#### POST `/paiements`
Create new payment

**Request:**
```json
{
  "montant": 350.00,
  "datePaiement": "2024-11-01",
  "statut": "payé"
}
```

#### PUT `/paiements/:id`
Update payment

#### DELETE `/paiements/:id`
Delete payment

### Activites (Activities) - Protected Routes

#### GET `/activites`
Get all activities

#### GET `/activites/:id`
Get activity by ID

#### POST `/activites`
Create new activity

**Request:**
```json
{
  "titre": "Peinture et Dessin",
  "description": "Atelier créatif pour développer l'imagination"
}
```

#### PUT `/activites/:id`
Update activity

#### DELETE `/activites/:id`
Delete activity

### Garderies (Nurseries)

See existing `garderie.js` route for endpoints.

### Messages

See existing `message.js` route for endpoints.

## Flutter Service Layer

### Setup

The service layer is already integrated. Add to your pubspec.yaml if not present:

```yaml
dependencies:
  http: ^1.1.0
  shared_preferences: ^2.2.2
```

### Usage Examples

#### 1. Authentication

```dart
import 'package:garderie/services/auth_service.dart';

final authService = AuthService();

// Login
try {
  final user = await authService.login('ahmed@parent.com', 'password123');
  if (user != null) {
    print('Logged in: ${user['nom']}');
    // Token is automatically saved
  }
} catch (e) {
  print('Login error: $e');
}

// Check if logged in
bool isLoggedIn = await authService.isLoggedIn();

// Get user data
final userData = await authService.getUserData();

// Logout
await authService.logout();
```

#### 2. Fetching Data

```dart
import 'package:garderie/services/data_service.dart';
import 'package:garderie/services/auth_service.dart';

final dataService = DataService();
final authService = AuthService();

// Set token for authenticated requests
final userData = await authService.getUserData();
if (userData != null) {
  dataService.setToken(userData['token']);
}

// Get all children
try {
  final enfants = await dataService.getAllEnfants();
  print('Enfants: $enfants');
} catch (e) {
  print('Error: $e');
}

// Get children by parent
final parentId = await authService.getUserId();
if (parentId != null) {
  final enfants = await dataService.getEnfantsByParent(parentId);
}

// Get all activities
final activites = await dataService.getAllActivites();

// Create new child
final newEnfant = await dataService.createEnfant(
  nom: 'Sofia',
  age: 3,
  parentId: parentId,
);
```

#### 3. Using with Provider

```dart
import 'package:provider/provider.dart';
import 'package:garderie/services/auth_service.dart';
import 'package:garderie/services/data_service.dart';

// In main.dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<DataService>(create: (_) => DataService()),
      ],
      child: MyApp(),
    ),
  );
}

// In a widget
final authService = Provider.of<AuthService>(context, listen: false);
final dataService = Provider.of<DataService>(context, listen: false);
```

### Base Service Class

All services extend `BaseService` which provides:
- `get(endpoint)` - GET request
- `post(endpoint, body)` - POST request
- `put(endpoint, body)` - PUT request
- `delete(endpoint)` - DELETE request
- Automatic token management
- Error handling

## Security Features

### Password Hashing
- Passwords are hashed using bcrypt with salt rounds of 10
- Backward compatible with plain text passwords (for existing data)

### JWT Authentication
- Tokens expire after 24 hours
- Include user ID, email, and type in payload
- Protected routes require valid token

### Environment Variables
- Sensitive data stored in `.env` file
- Never commit `.env` to version control

## Testing

### Health Check
```bash
curl http://localhost:3000/api/health
```

### Test Login
```bash
curl -X POST http://localhost:3000/api/utilisateurs/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "ahmed@parent.com",
    "motDePasse": "password123"
  }'
```

### Test Protected Endpoint
```bash
# Get token from login response, then:
curl http://localhost:3000/api/enfants \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

## Database Schema

The database includes the following tables:
- `utilisateur` - User accounts
- `parent` - Parent details
- `directeur` - Nursery director details
- `enfant` - Children information
- `garderie` - Nursery information
- `paiement` - Payments
- `activite` - Activities
- `message` - Messages
- `notification` - Notifications
- `devoir` - Homework
- `avis` - Reviews
- `programme` - Programs

## Troubleshooting

### Connection Issues
- Check PostgreSQL is running: `docker ps` or `pg_isready`
- Verify connection details in `.env`
- Check network connectivity

### Authentication Errors
- Ensure token is included in Authorization header
- Check token hasn't expired (24h validity)
- Verify JWT_SECRET matches between requests

### CORS Errors (Flutter Web)
- CORS is enabled on backend
- Check baseUrl in Flutter services matches backend URL

## Production Deployment

1. **Update environment variables:**
   - Use strong JWT_SECRET
   - Use secure database credentials
   - Set appropriate PORT

2. **Enable HTTPS:**
   - Use reverse proxy (nginx, Apache)
   - Configure SSL certificates

3. **Security hardening:**
   - Rate limiting
   - Input validation
   - SQL injection prevention (using parameterized queries)

4. **Monitoring:**
   - Set up logging
   - Monitor API performance
   - Track error rates

## License

This project is part of the Garderie mobile application.
