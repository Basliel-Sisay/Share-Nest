const express = require('express');
const db = require('../db');

const router = express.Router();

router.get('/', (req, res) => {
  const rows = db
    .prepare('SELECT * FROM reservations ORDER BY pickup_date ASC')
    .all();
  res.json(rows);
});

router.post('/', (req, res) => {
  const body = req.body;
  const id = body.id || `res-${Date.now()}`;

  if (!body.resource_id || !body.title || !body.pickup_date || !body.return_date) {
    return res.status(400).json({
      error: 'resource_id, title, pickup_date, and return_date are required',
    });
  }

  db.prepare(
    `
    INSERT INTO reservations (
      id, resource_id, title, pickup_location, pickup_date, return_date,
      pickup_time, return_time, distance, status
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `,
  ).run(
    id,
    body.resource_id,
    body.title,
    body.pickup_location || 'Pickup from community hub',
    body.pickup_date,
    body.return_date,
    body.pickup_time || '',
    body.return_time || '',
    body.distance || '0.8 Km away',
    body.status || 'CONFIRMED',
  );

  const saved = db.prepare('SELECT * FROM reservations WHERE id = ?').get(id);
  res.status(201).json(saved);
});

module.exports = router;
