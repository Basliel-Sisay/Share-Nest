const express = require('express');
const db = require('../db');
const { authenticate, requireAdmin } = require('./auth');

const router = express.Router();

router.use(authenticate, requireAdmin);

router.get('/users', (req, res) => {
  const users = db
    .prepare('SELECT id, name, email, role, created_at FROM users ORDER BY created_at DESC')
    .all();
  res.json(users);
});

router.patch('/users/:id/role', (req, res) => {
  const { role } = req.body;
  if (!role || !['user', 'admin'].includes(role)) {
    return res.status(400).json({ error: 'Role must be "user" or "admin"' });
  }
  const existing = db.prepare('SELECT * FROM users WHERE id = ?').get(req.params.id);
  if (!existing) return res.status(404).json({ error: 'User not found' });

  db.prepare('UPDATE users SET role = ? WHERE id = ?').run(role, req.params.id);
  const updated = db
    .prepare('SELECT id, name, email, role, created_at FROM users WHERE id = ?')
    .get(req.params.id);
  res.json(updated);
});

router.delete('/users/:id', (req, res) => {
  const existing = db.prepare('SELECT * FROM users WHERE id = ?').get(req.params.id);
  if (!existing) return res.status(404).json({ error: 'User not found' });

  db.prepare('DELETE FROM reservations WHERE owner_id = ? OR borrower_id = ?').run(
    req.params.id, req.params.id
  );
  db.prepare('DELETE FROM loans WHERE owner_id = ? OR borrower_id = ?').run(
    req.params.id, req.params.id
  );
  db.prepare('DELETE FROM resources WHERE owner_id = ?').run(req.params.id);
  db.prepare('DELETE FROM users WHERE id = ?').run(req.params.id);
  res.json({ message: 'User and all associated data deleted' });
});

router.get('/loans', (req, res) => {
  const loans = db
    .prepare('SELECT * FROM loans ORDER BY created_at DESC')
    .all();
  res.json(loans);
});

router.get('/reservations', (req, res) => {
  const rows = db
    .prepare('SELECT * FROM reservations ORDER BY created_at DESC')
    .all();
  res.json(rows);
});

router.patch('/resources/:id', (req, res) => {
  const existing = db.prepare('SELECT * FROM resources WHERE id = ?').get(req.params.id);
  if (!existing) return res.status(404).json({ error: 'Resource not found' });

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

router.delete('/resources/:id', (req, res) => {
  const existing = db.prepare('SELECT * FROM resources WHERE id = ?').get(req.params.id);
  if (!existing) return res.status(404).json({ error: 'Resource not found' });

  db.prepare('DELETE FROM loans WHERE resource_id = ?').run(req.params.id);
  db.prepare('DELETE FROM reservations WHERE resource_id = ?').run(req.params.id);
  db.prepare('DELETE FROM resources WHERE id = ?').run(req.params.id);
  res.json({ message: 'Resource deleted by admin' });
});

router.patch('/loans/:id/status', (req, res) => {
  const { status } = req.body;
  const validStatuses = ['APPROVED', 'REJECTED', 'RETURNED', 'CANCELLED', 'ACTIVE', 'CONFIRMED'];
  if (!validStatuses.includes(status)) {
    return res.status(400).json({ error: `Invalid status. Must be one of: ${validStatuses.join(', ')}` });
  }

  const loan = db.prepare('SELECT * FROM loans WHERE id = ?').get(req.params.id);
  if (!loan) return res.status(404).json({ error: 'Loan not found' });

  const colorMap = {
    APPROVED: { color: 0xFF4CAF50, textColor: 0xFFFFFFFF },
    CONFIRMED: { color: 0xFF4CAF50, textColor: 0xFFFFFFFF },
    REJECTED: { color: 0xFFF44336, textColor: 0xFFFFFFFF },
    RETURNED: { color: 0xFF9E9E9E, textColor: 0xFFFFFFFF },
    CANCELLED: { color: 0xFFFF9800, textColor: 0xFFFFFFFF },
    ACTIVE: { color: 0xFFDDE8FC, textColor: 0xFF1E8449 },
  };
  const c = colorMap[status] || { color: 0xFF4CAF50, textColor: 0xFFFFFFFF };

  db.prepare(
    `UPDATE loans SET status_text = ?, status_color = ?, status_text_color = ? WHERE id = ?`
  ).run(status, c.color, c.textColor, req.params.id);

  if (status === 'APPROVED' || status === 'CONFIRMED') {
    db.prepare('UPDATE resources SET is_available = 0 WHERE id = ?').run(loan.resource_id);
  }
  if (status === 'RETURNED' || status === 'CANCELLED' || status === 'REJECTED') {
    db.prepare('UPDATE resources SET is_available = 1 WHERE id = ?').run(loan.resource_id);
  }

  const updated = db.prepare('SELECT * FROM loans WHERE id = ?').get(req.params.id);
  res.json(updated);
});

router.patch('/reservations/:id/status', (req, res) => {
  const { status } = req.body;
  if (!['CONFIRMED', 'CANCELLED'].includes(status)) {
    return res.status(400).json({ error: 'Status must be CONFIRMED or CANCELLED' });
  }

  const existing = db.prepare('SELECT * FROM reservations WHERE id = ?').get(req.params.id);
  if (!existing) return res.status(404).json({ error: 'Reservation not found' });

  db.prepare('UPDATE reservations SET status = ? WHERE id = ?').run(status, req.params.id);
  const updated = db.prepare('SELECT * FROM reservations WHERE id = ?').get(req.params.id);
  res.json(updated);
});

router.get('/stats', (req, res) => {
  const totalUsers = db.prepare('SELECT COUNT(*) as count FROM users').get();
  const totalResources = db.prepare('SELECT COUNT(*) as count FROM resources').get();
  const totalLoans = db.prepare('SELECT COUNT(*) as count FROM loans').get();
  const pendingLoans = db.prepare("SELECT COUNT(*) as count FROM loans WHERE status_text = 'PENDING'").get();
  const activeLoans = db.prepare("SELECT COUNT(*) as count FROM loans WHERE status_text = 'ACTIVE'").get();
  const totalReservations = db.prepare('SELECT COUNT(*) as count FROM reservations').get();

  res.json({
    totalUsers: totalUsers.count,
    totalResources: totalResources.count,
    totalLoans: totalLoans.count,
    pendingLoans: pendingLoans.count,
    activeLoans: activeLoans.count,
    totalReservations: totalReservations.count,
  });
});

module.exports = router;
