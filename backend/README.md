# here is the admin emain and password 
Admin credentials: admin@sharenest.com 
password: admin123
# ShareNest Node API

This is a small backend built with Node.js and Express  
It uses SQLite for storage and works together with the ShareNest Flutter app

## How it works

- The Flutter app keeps a local cache in SQLite 
- When data isn’t found locally, the app calls this API
- The API stores the main database and handles requests

## Getting Started

```bash
cd backend
npm install
npm start

The server runs at: http://localhost:3001

Main Endpoints
GET /api/health → Check if the server is running

GET /api/resources → List all resources

GET /api/resources/:id → Get one resource

POST /api/resources → Add or update a resource

GET /api/loans → List loans

PATCH /api/loans/:id/extend → Extend a loan

GET /api/reservations → List reservations

POST /api/reservations → Create a reservation

The database file is created automatically at: backend/data/share_nest.db

Connecting from Flutter

Windows / iOS Simulator / Web → http://localhost:3001

Android Emulator → http://10.0.2.2:3001

Physical device → Use your PC’s LAN IP such as http://192.168.1.x:3001

You can override the API URL when running Flutter:

flutter run --dart-define=API_BASE_URL=http://192.168.1.10:3001
