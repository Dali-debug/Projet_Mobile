# Quick Start Guide - Backend API & Flutter Integration

This guide will help you quickly set up and test the REST API and Flutter service layer.

## Prerequisites

- Node.js 18+ installed
- PostgreSQL 15+ installed (or Docker)
- Flutter SDK installed (for mobile app)
- Git

## Option 1: Quick Start with Docker (Recommended)

This is the fastest way to get everything running.

### 1. Clone and Navigate
```bash
git clone <repository-url>
cd Projet_Mobile
```

### 2. Start Services
```bash
docker-compose up -d
```

This will start:
- PostgreSQL database on port 5432
- Node.js API on port 3000

### 3. Verify Services
```bash
# Check if containers are running
docker-compose ps

# Check API health
curl http://localhost:3000/api/health

# View logs
docker-compose logs -f api
```

### 4. Test the API
```bash
# Test login (using default test data)
curl -X POST http://localhost:3000/api/utilisateurs/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "ahmed@parent.com",
    "motDePasse": "password123"
  }'
```

You should receive a response with a JWT token.

### 5. Stop Services
```bash
docker-compose down
```

## Option 2: Manual Setup (Without Docker)

### 1. Set Up PostgreSQL

Start PostgreSQL and create the database:
```bash
createdb mobile -U dali
psql -U dali -d mobile -f backend/init-db.sql
```

### 2. Install Backend Dependencies
```bash
cd backend
npm install
```

### 3. Configure Environment
Make sure `backend/.env` has correct values:
```env
PORT=3000
DB_HOST=localhost
DB_PORT=5432
DB_USER=dali
DB_PASSWORD=testdali
DB_NAME=mobile
JWT_SECRET=votre_secret_jwt_super_securise_changez_moi_en_production
```

### 4. Start Backend Server
```bash
# Development mode (with auto-reload)
npm run dev

# Or production mode
npm start
```

### 5. Verify Backend
Open another terminal and test:
```bash
curl http://localhost:3000/api/health
```

## Testing the API

### 1. Test User Authentication

**Login:**
```bash
curl -X POST http://localhost:3000/api/utilisateurs/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "ahmed@parent.com",
    "motDePasse": "password123"
  }'
```

Save the `token` from the response - you'll need it for authenticated requests.

**Register New User:**
```bash
curl -X POST http://localhost:3000/api/utilisateurs \
  -H "Content-Type: application/json" \
  -d '{
    "nom": "Test User",
    "email": "test@example.com",
    "motDePasse": "securepass123",
    "type": "parent",
    "telephone": "12345678"
  }'
```

### 2. Test Protected Endpoints

Replace `YOUR_TOKEN` with the token from login:

**Get All Children:**
```bash
curl http://localhost:3000/api/enfants \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**Get All Activities:**
```bash
curl http://localhost:3000/api/activites \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**Create a Child:**
```bash
curl -X POST http://localhost:3000/api/enfants \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "nom": "Sofia",
    "age": 3,
    "parent_id": 1
  }'
```

## Testing with Flutter

### 1. Install Flutter Dependencies
```bash
cd ../  # Back to project root
flutter pub get
```

### 2. Update Base URL (if needed)

If your API is not on localhost:3000, update `lib/services/base_service.dart`:
```dart
static const String baseUrl = 'http://YOUR_IP:3000/api';
```

For Android emulator, use: `http://10.0.2.2:3000/api`  
For iOS simulator, use: `http://localhost:3000/api`  
For physical device, use: `http://YOUR_COMPUTER_IP:3000/api`

### 3. Test Authentication Service

Create a test file or use in your app:
```dart
import 'package:garderie/services/auth_service.dart';

void testAuth() async {
  final authService = AuthService();
  
  try {
    // Login
    final user = await authService.login(
      'ahmed@parent.com',
      'password123'
    );
    
    if (user != null) {
      print('✅ Login successful!');
      print('User: ${user['nom']}');
      print('Token: ${user['token']?.substring(0, 20)}...');
    }
  } catch (e) {
    print('❌ Login failed: $e');
  }
}
```

### 4. Test Data Service

```dart
import 'package:garderie/services/data_service.dart';
import 'package:garderie/services/auth_service.dart';

void testData() async {
  final authService = AuthService();
  final dataService = DataService();
  
  // Login first
  final user = await authService.login(
    'ahmed@parent.com',
    'password123'
  );
  
  if (user != null) {
    // Set token for authenticated requests
    dataService.setToken(user['token']);
    
    try {
      // Get children
      final enfants = await dataService.getAllEnfants();
      print('✅ Found ${enfants.length} children');
      
      // Get activities
      final activites = await dataService.getAllActivites();
      print('✅ Found ${activites.length} activities');
      
    } catch (e) {
      print('❌ Error: $e');
    }
  }
}
```

### 5. Run Flutter App
```bash
# For web
flutter run -d chrome

# For Android
flutter run -d android

# For iOS
flutter run -d ios
```

## Common Issues & Solutions

### Issue: "Connection refused"
**Solution:** Make sure the backend server is running on the correct port.
```bash
# Check if server is running
curl http://localhost:3000/api/health

# Check backend logs
docker-compose logs api
# OR
cd backend && npm run dev
```

### Issue: "Token invalid or expired"
**Solution:** The token expires after 24 hours. Login again to get a new token.

### Issue: "CORS error" (Flutter Web)
**Solution:** CORS is already enabled in the backend. Make sure you're using the correct URL.

### Issue: Android emulator can't connect
**Solution:** Use `http://10.0.2.2:3000/api` instead of `localhost` in `base_service.dart`.

### Issue: Database connection error
**Solution:** 
```bash
# Check PostgreSQL is running
pg_isready

# Or if using Docker
docker-compose ps
```

## Test Data

The database is pre-populated with test data:

**Test Users:**
- **Parent:** ahmed@parent.com / password123
- **Parent:** fatma@parent.com / password123
- **Directeur:** directeur@petitsanges.com / password123

**Test Nurseries:**
- Les Petits Anges (5 places available)
- Jardin d'Enfants Étoiles (8 places available)
- Several others

**Test Children:**
- Sofia Ben Ali (age 3)
- Youssef Trabelsi (age 4)
- Lina Gharbi (age 2)
- And more...

## Next Steps

1. ✅ API is running
2. ✅ Can authenticate users
3. ✅ Can fetch data from protected endpoints
4. 📱 Integrate services into Flutter app UI
5. 🎨 Build UI components using Provider for state management
6. 🚀 Deploy to production

## Additional Resources

- **API Documentation:** See `API_DOCUMENTATION.md`
- **File Structure:** See `FILE_STRUCTURE.md`
- **Security Notes:** See `SECURITY_SUMMARY.md`

## Need Help?

Check the logs:
```bash
# Docker
docker-compose logs -f

# Manual
cd backend && npm run dev  # Backend logs appear here
```

Test individual components:
```bash
# Test database connection
psql -U dali -d mobile -c "SELECT COUNT(*) FROM utilisateur;"

# Test API endpoint
curl -v http://localhost:3000/api/health
```

Happy coding! 🚀
