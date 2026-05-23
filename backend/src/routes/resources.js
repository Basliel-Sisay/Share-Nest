const express = require('express');
const db = require('../db');

const router = express.Router();

router.get('/', (req, res) => {
  const rows = db.prepare('SELECT * FROM resources ORDER BY title ASC').all();
  res.json(rows);
});

router.get('/:id', (req, res) => {
  const row = db
    .prepare('SELECT * FROM resources WHERE id = ?')
    .get(req.params.id);
  if (!row) {
    return res.status(404).json({ error: 'Resource not found' });
  }
  res.json(row);
});

router.post('/', (req, res) => {
  const body = req.body;
  const id =
    body.id ||
    body.title
      ?.toLowerCase()
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-|-$/g, '') ||
    `resource-${Date.now()}`;

  if (!body.title) {
    return res.status(400).json({ error: 'title is required' });
  }

  const isAvailable =
    body.is_available === 0 || body.is_available === false ? 0 : 1;

  db.prepare(
    `
    INSERT INTO resources (
      id, title, owner_name, distance, rating, category, description,
      image_path, location, condition, status_text, is_available
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ON CONFLICT(id) DO UPDATE SET
      title = excluded.title,
      owner_name = excluded.owner_name,
      distance = excluded.distance,
      rating = excluded.rating,
      category = excluded.category,
      description = excluded.description,
      image_path = excluded.image_path,
      location = excluded.location,
      condition = excluded.condition,
      status_text = excluded.status_text,
      is_available = excluded.is_available
  `,
  ).run(
    id,
    body.title,
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

module.exports = router;
