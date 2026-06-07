const express = require('express');
const db = require('../db');
const { authenticate } = require('./auth');

const router = express.Router();

router.get('/', (req, res) => {
  const rows = db.prepare('SELECT * FROM resources ORDER BY title ASC').all();
  res.json(rows);
});

router.get('/:id', (req, res) => {
  const row = db.prepare('SELECT * FROM resources WHERE id = ?').get(req.params.id);
  if (!row) return res.status(404).json({ error: 'Resource not found' });
  res.json(row);
});

router.post('/', authenticate, (req, res) => {
  const body = req.body;
  if (!body.title) return res.status(400).json({ error: 'title is required' });

  const id =
    body.id ||
    body.title
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-|-$/g, '') ||
    `resource-${Date.now()}`;

  const isAvailable = body.is_available === 0 || body.is_available === false ? 0 : 1;

  db.prepare(
    `INSERT INTO resources (
      id, title, owner_id, owner_name, distance, rating, category, description,
      image_path, location, condition, status_text, is_available
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ON CONFLICT(id) DO UPDATE SET
      title = excluded.title, owner_id = excluded.owner_id,
      owner_name = excluded.owner_name, distance = excluded.distance,
      rating = excluded.rating, category = excluded.category,
      description = excluded.description, image_path = excluded.image_path,
      location = excluded.location, condition = excluded.condition,
      status_text = excluded.status_text, is_available = excluded.is_available`
  ).run(
    id,
    body.title,
    req.userId,
    body.owner_name || 'You',
    body.distance || 'Nearby',
    body.rating ?? 5.0,
    body.category || 'Tools',
    body.description || '',
    body.image_path || 'assets/images/drill.png',
    body.location || '',
    body.condition || '',
    body.status_text || 'Available Today',
    isAvailable,
  );

  const saved = db.prepare('SELECT * FROM resources WHERE id = ?').get(id);
  res.status(201).json(saved);
});

router.put('/:id', authenticate, (req, res) => {
  const existing = db.prepare('SELECT * FROM resources WHERE id = ?').get(req.params.id);
  if (!existing) return res.status(404).json({ error: 'Resource not found' });
  if (existing.owner_id !== req.userId && req.userRole !== 'admin') {
    return res.status(403).json({ error: 'Only the owner or admin can edit this resource' });
  }

  const body = req.body;
  const isAvailable = body.is_available === 0 || body.is_available === false ? 0 : 1;

  db.prepare(
    `UPDATE resources SET
      title = ?, owner_name = ?, distance = ?, rating = ?, category = ?,
      description = ?, image_path = ?, location = ?, condition = ?,
      status_text = ?, is_available = ?
    WHERE id = ?`
  ).run(
    body.title || existing.title,
    body.owner_name || existing.owner_name,
    body.distance || existing.distance,
    body.rating ?? existing.rating,
    body.category || existing.category,
    body.description ?? existing.description,
    body.image_path || existing.image_path,
    body.location ?? existing.location,
    body.condition ?? existing.condition,
    body.status_text || existing.status_text,
    isAvailable,
    req.params.id,
  );

  const updated = db.prepare('SELECT * FROM resources WHERE id = ?').get(req.params.id);
  res.json(updated);
});

router.delete('/:id', authenticate, (req, res) => {
  const existing = db.prepare('SELECT * FROM resources WHERE id = ?').get(req.params.id);
  if (!existing) return res.status(404).json({ error: 'Resource not found' });
  if (existing.owner_id !== req.userId && req.userRole !== 'admin') {
    return res.status(403).json({ error: 'Only the owner or admin can delete this resource' });
  }

  db.prepare('DELETE FROM loans WHERE resource_id = ?').run(req.params.id);
  db.prepare('DELETE FROM reservations WHERE resource_id = ?').run(req.params.id);
  db.prepare('DELETE FROM resources WHERE id = ?').run(req.params.id);
  res.json({ message: 'Resource deleted' });
});

module.exports = router;
