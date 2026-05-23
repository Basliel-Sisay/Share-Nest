const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const db = require('../db');
const router = express.Router();
const JWT_SECRET = process.env.JWT_SECRET || 'share-nest-dev-secret';

function authenticate(req, res, next){
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'No token provided' });
  }
  try{
    const decoded = jwt.verify(authHeader.split(' ')[1], JWT_SECRET);
    req.userId = decoded.userId;
    req.userEmail = decoded.email;
    req.userRole = decoded.role;
    next();
  } 
  catch {
    return res.status(401).json({ error: 'Invalid or expired token' });
  }
}

router.post('/signup', (req, res) =>{
  const { name, email, password } = req.body;
  if (!name || !email || !password) {
    return res
      .status(400)
      .json({ error: 'name, email, and password are required' });
  }
  if (password.length < 6){
    return res
      .status(400)
      .json({ error: 'Password must be at least 6 characters' });
  }

  const existing = db.prepare('SELECT id FROM users WHERE email = ?').get(email);
  if (existing){
    return res.status(409).json({ error: 'Email already registered' });
  }
  const id = `user-${Date.now()}`;
  const hashed = bcrypt.hashSync(password, 10);
  db.prepare(
    'INSERT INTO users (id, name, email, password, role) VALUES (?, ?, ?, ?, ?)'
  ).run(id, name, email, hashed, 'user');

  const user = db
    .prepare('SELECT id, name, email, role, created_at FROM users WHERE id = ?')
    .get(id);
  const token = jwt.sign({ userId: user.id, email: user.email, role: user.role }, JWT_SECRET, {
    expiresIn: '1d',
  });
  res.status(201).json({ user, token });
});

router.post('/login', (req, res) =>{
  const { email, password } = req.body;
  if (!email || !password) {
    return res.status(400).json({ error: 'email and password are required' });
  }

  const user = db.prepare('SELECT * FROM users WHERE email = ?').get(email);
  if (!user || !bcrypt.compareSync(password, user.password)) {
    return res.status(401).json({ error: 'Invalid email or password' });
  }

  const safeUser = {
    id: user.id,
    name: user.name,
    email: user.email,
    role: user.role,
    created_at: user.created_at,
  };
  const token = jwt.sign(
    { userId: user.id, email: user.email, role: user.role },
    JWT_SECRET,
    { expiresIn: '1d' }
  );
  res.json({ user: safeUser, token });
});

router.get('/me', authenticate, (req, res) => {
  const user = db
    .prepare('SELECT id, name, email, role, created_at FROM users WHERE id = ?')
    .get(req.userId);
  if (!user) return res.status(404).json({ error: 'User not found' });
  res.json({ user });
});

router.delete('/account', authenticate, (req, res) =>{
  const userId = req.userId;
  db.prepare('DELETE FROM reservations WHERE owner_id = ? OR borrower_id = ?').run(
    userId, userId
  );
  db.prepare('DELETE FROM loans WHERE owner_id = ? OR borrower_id = ?').run(
    userId, userId
  );
  db.prepare('DELETE FROM resources WHERE owner_id = ?').run(userId);
  db.prepare('DELETE FROM users WHERE id = ?').run(userId);
  res.json({ message: 'Account and all associated data deleted' });
});

function requireAdmin(req, res, next){
  if (req.userRole !== 'admin') {
    return res.status(403).json({ error: 'Admin access required' });
  }
  next();
}

module.exports = { router, authenticate, requireAdmin };
