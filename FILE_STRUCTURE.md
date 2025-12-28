# Backend API and Flutter Service Layer - File Structure

## Project Structure

```
Projet_Mobile/
│
├── backend/                         # Node.js Backend API
│   ├── controllers/                 # Business logic controllers
│   │   ├── utilisateurController.js # User management (CRUD + JWT auth)
│   │   ├── enfantController.js      # Children management (CRUD)
│   │   ├── paiementController.js    # Payment management (CRUD)
│   │   └── activiteController.js    # Activity management (CRUD)
│   │
│   ├── middleware/                  # Authentication middleware
│   │   └── auth.js                  # JWT verification & token generation
│   │
│   ├── routes/                      # API route definitions
│   │   ├── utilisateur.js           # User routes (login, register, CRUD)
│   │   ├── enfant.js                # Children routes
│   │   ├── paiement.js              # Payment routes
│   │   ├── activite.js              # Activity routes
│   │   ├── garderie.js              # Nursery routes (existing)
│   │   └── message.js               # Message routes (existing)
│   │
│   ├── db.js                        # PostgreSQL connection pool
│   ├── server.js                    # Express server setup
│   ├── Dockerfile                   # Docker image for Node.js API
│   ├── package.json                 # Dependencies (express, pg, jwt, bcrypt)
│   ├── .env                         # Environment configuration
│   ├── init-db.sql                  # Database initialization script
│   └── README.md                    # Backend documentation
│
├── lib/                             # Flutter Application
│   ├── services/                    # Service layer for API calls
│   │   ├── base_service.dart        # Base HTTP service (GET, POST, PUT, DELETE)
│   │   ├── auth_service.dart        # Authentication (login, logout, token mgmt)
│   │   ├── data_service.dart        # Data fetching (children, activities, payments)
│   │   ├── api_service.dart         # Existing API service
│   │   └── chat_service.dart        # Existing chat service
│   │
│   ├── models/                      # Data models
│   │   ├── utilisateur.dart         # User model
│   │   ├── enfant.dart              # Child model (with JSON serialization)
│   │   ├── paiement.dart            # Payment model (with JSON serialization)
│   │   ├── activite.dart            # Activity model (with JSON serialization)
│   │   ├── garderie.dart            # Nursery model
│   │   └── ...                      # Other existing models
│   │
│   ├── providers/                   # State management
│   ├── screens/                     # UI screens
│   ├── widgets/                     # Reusable widgets
│   └── ...
│
├── docker-compose.yml               # Docker orchestration (PostgreSQL + API)
├── API_DOCUMENTATION.md             # Complete API documentation
├── pubspec.yaml                     # Flutter dependencies
└── README.md                        # Project documentation
```

## Key Features Implemented

### Backend (Node.js + Express)

1. **Standard Folder Structure:**
   - `controllers/` - Business logic separated from routes
   - `middleware/` - Reusable middleware (authentication)
   - `routes/` - API endpoint definitions
   - `db.js` - Database connection management

2. **JWT Authentication:**
   - Login endpoint returns JWT token
   - Token-based authentication middleware
   - Protected routes require valid token
   - 24-hour token expiration

3. **Password Security:**
   - Bcrypt hashing for passwords
   - Salt rounds: 10
   - Backward compatible with existing plain text passwords

4. **CRUD Endpoints:**
   - **Enfant (Children):** Full CRUD + filtering by parent/nursery
   - **Utilisateur (Users):** Authentication + CRUD
   - **Paiement (Payments):** Full CRUD + filtering by status/parent
   - **Activite (Activities):** Full CRUD

5. **Docker Support:**
   - Dockerfile for Node.js API
   - docker-compose.yml for full stack (PostgreSQL + API)
   - Health checks for database

### Flutter Service Layer

1. **BaseService:**
   - Reusable HTTP methods (GET, POST, PUT, DELETE)
   - Automatic token management in headers
   - Centralized error handling
   - Response parsing and validation

2. **AuthService:**
   - Login/Register functionality
   - JWT token storage (SharedPreferences)
   - Session management (isLoggedIn, logout)
   - User data persistence

3. **DataService:**
   - Fetch all children / by parent / by nursery
   - Fetch all activities
   - Fetch all payments / by parent / by status
   - CRUD operations for all entities
   - Automatic authentication headers

4. **Enhanced Models:**
   - JSON serialization (fromJson/toJson)
   - Support for database field names
   - Nullable fields handled properly

## API Endpoints Summary

### Public Endpoints (No Auth Required)
- `POST /api/utilisateurs/login` - User login
- `POST /api/utilisateurs` - User registration
- `GET /api/health` - Health check

### Protected Endpoints (Auth Required)
All other endpoints require JWT token in Authorization header:
- `/api/utilisateurs/*` - User management
- `/api/enfants/*` - Children management
- `/api/paiements/*` - Payment management
- `/api/activites/*` - Activity management
- `/api/garderies/*` - Nursery management
- `/api/messages/*` - Message management

## Environment Configuration

### Backend (.env)
```env
PORT=3000
DB_HOST=localhost
DB_PORT=5432
DB_USER=dali
DB_PASSWORD=testdali
DB_NAME=mobile
JWT_SECRET=your_secret_key
```

### Flutter (base_service.dart)
```dart
static const String baseUrl = 'http://localhost:3000/api';
```

## Database Schema

Key tables:
- `utilisateur` - User accounts (email, type)
- `parent` - Parent details (name, password, phone)
- `directeur` - Director details (name, password, phone)
- `enfant` - Children (name, age, parent_id, garderie_id)
- `garderie` - Nurseries (name, address, tariff, availability)
- `paiement` - Payments (amount, date, status)
- `activite` - Activities (title, description)
- `message` - Messages
- `notification` - Notifications
- `devoir` - Homework
- `avis` - Reviews
- `programme` - Programs

## Dependencies

### Backend (package.json)
- express ^4.18.2 - Web framework
- pg ^8.11.3 - PostgreSQL client
- cors ^2.8.5 - CORS middleware
- dotenv ^16.3.1 - Environment variables
- body-parser ^1.20.2 - Body parsing
- jsonwebtoken ^9.0.2 - JWT authentication
- bcrypt ^5.1.1 - Password hashing

### Flutter (pubspec.yaml)
- http ^1.1.0 - HTTP client
- shared_preferences ^2.2.2 - Local storage
- provider ^6.1.1 - State management

## How to Run

### Using Docker Compose (Recommended)
```bash
docker-compose up -d
```

### Manual Setup
1. Start PostgreSQL
2. Install backend dependencies: `cd backend && npm install`
3. Start backend: `npm start`
4. Run Flutter app: `flutter run`

## Testing

### Backend
```bash
# Health check
curl http://localhost:3000/api/health

# Login
curl -X POST http://localhost:3000/api/utilisateurs/login \
  -H "Content-Type: application/json" \
  -d '{"email": "ahmed@parent.com", "motDePasse": "password123"}'
```

### Flutter
See `API_DOCUMENTATION.md` for usage examples with the service layer.

## Security Considerations

1. **JWT Secret:** Change JWT_SECRET in production
2. **Password Hashing:** All new passwords are hashed with bcrypt
3. **CORS:** Currently allows all origins (configure for production)
4. **Rate Limiting:** Consider adding in production
5. **HTTPS:** Use reverse proxy with SSL in production
6. **Input Validation:** Parameterized queries prevent SQL injection

## Next Steps

1. Add rate limiting middleware
2. Add input validation schemas (e.g., Joi)
3. Add API documentation with Swagger
4. Add logging system (Winston)
5. Add unit and integration tests
6. Set up CI/CD pipeline
7. Configure production environment
