const express = require('express');
const db = require('../db');
const { authenticate } = require('./auth');

const router = express.Router();

function hasOverlap(existingPickup, existingReturn, newPickup, newReturn) {
  const ep = new Date(existingPickup);
  const er = new Date(existingReturn);
  const np = new Date(newPickup);
  const nr = new Date(newReturn);
  return np < er && nr > ep;
}

router.get('/', authenticate, (req, res) => {
  const rows = db
    .prepare(
      'SELECT * FROM reservations WHERE owner_id = ? OR borrower_id = ? ORDER BY pickup_date ASC'
    )
    .all(req.userId, req.userId);
  res.json(rows);
});

router.post('/', authenticate, (req, res) => {
  const body = req.body;
  if (!body.resource_id || !body.title || !body.pickup_date || !body.return_date) {
    return res.status(400).json({
      error: 'resource_id, title, pickup_date, and return_date are required',
    });
  }

  const resource = db.prepare('SELECT * FROM resources WHERE id = ?').get(body.resource_id);
  if (!resource) return res.status(404).json({ error: 'Resource not found' });

  const conflicting = db
    .prepare(
      `SELECT * FROM reservations
       WHERE resource_id = ? AND status IN ('PENDING', 'CONFIRMED')
       AND pickup_date < ? AND return_date > ?`
    )
    .all(body.resource_id, body.return_date, body.pickup_date);

  if (conflicting.length > 0) {
    return res.status(409).json({ error: 'This time slot conflicts with an existing reservation' });
  }

  const id = body.id || `res-${Date.now()}`;
  db.prepare(
    `INSERT INTO reservations (
      id, resource_id, title, owner_id, borrower_id, pickup_location,
      pickup_date, return_date, pickup_time, return_time, distance, status
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`
  ).run(
    id,
    body.resource_id,
    body.title,
    resource.owner_id,
    req.userId,
    body.pickup_location || 'Pickup from community hub',
    body.pickup_date,
    body.return_date,
    body.pickup_time || '',
    body.return_time || '',
    body.distance || '0.8 Km away',
    body.status || 'PENDING',
  );

  const saved = db.prepare('SELECT * FROM reservations WHERE id = ?').get(id);
  res.status(201).json(saved);
});

router.put('/:id', authenticate, (req, res) => {
  const existing = db.prepare('SELECT * FROM reservations WHERE id = ?').get(req.params.id);
  if (!existing) return res.status(404).json({ error: 'Reservation not found' });
  if (existing.borrower_id !== req.userId && existing.owner_id !== req.userId) {
    return res.status(403).json({ error: 'Not authorized' });
  }

  const body = req.body;
  const newPickup = body.pickup_date || existing.pickup_date;
  const newReturn = body.return_date || existing.return_date;

  const conflicting = db
    .prepare(
      `SELECT * FROM reservations
       WHERE resource_id = ? AND id != ? AND status IN ('PENDING', 'CONFIRMED')
       AND pickup_date < ? AND return_date > ?`
    )
    .all(existing.resource_id, req.params.id, newReturn, newPickup);

  if (conflicting.length > 0) {
    return res.status(409).json({ error: 'Updated time slot conflicts with an existing reservation' });
  }

  db.prepare(
    `UPDATE reservations SET
      pickup_location = ?, pickup_date = ?, return_date = ?,
      pickup_time = ?, return_time = ?, distance = ?, status = ?
    WHERE id = ?`
  ).run(
    body.pickup_location || existing.pickup_location,
    newPickup,
    newReturn,
    body.pickup_time ?? existing.pickup_time,
    body.return_time ?? existing.return_time,
    body.distance ?? existing.distance,
    body.status || existing.status,
    req.params.id,
  );

  const updated = db.prepare('SELECT * FROM reservations WHERE id = ?').get(req.params.id);
  res.json(updated);
});

router.delete('/:id', authenticate, (req, res) => {
  const existing = db.prepare('SELECT * FROM reservations WHERE id = ?').get(req.params.id);
  if (!existing) return res.status(404).json({ error: 'Reservation not found' });
  if (existing.borrower_id !== req.userId && existing.owner_id !== req.userId) {
    return res.status(403).json({ error: 'Not authorized' });
  }

  db.prepare('DELETE FROM reservations WHERE id = ?').run(req.params.id);
  res.json({ message: 'Reservation cancelled' });
});

module.exports = router;
