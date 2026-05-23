const express = require('express');
const db = require('../db');
const { authenticate } = require('./auth');

const router = express.Router();

function formatReturnDate(iso) {
  const d = new Date(iso);
  const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  const hours = d.getHours();
  const minutes = d.getMinutes().toString().padStart(2, '0');
  const ampm = hours >= 12 ? 'PM' : 'AM';
  const h12 = hours % 12 || 12;
  return `Return by ${months[d.getMonth()]} ${d.getDate()}, ${h12}:${minutes} ${ampm}`;
}

router.get('/', authenticate, (req, res) => {
  const rows = db
    .prepare(
      'SELECT * FROM loans WHERE owner_id = ? OR borrower_id = ? ORDER BY created_at DESC'
    )
    .all(req.userId, req.userId);
  res.json(rows);
});

router.post('/', authenticate, (req, res) => {
  const { resource_id, title, owner_id, owner_name, pickup_date, return_date, pickup_time, return_time } = req.body;
  if (!resource_id || !title || !owner_id || !pickup_date || !return_date) {
    return res.status(400).json({
      error: 'resource_id, title, owner_id, pickup_date, and return_date are required',
    });
  }

  const resource = db.prepare('SELECT * FROM resources WHERE id = ?').get(resource_id);
  if (!resource) return res.status(404).json({ error: 'Resource not found' });
  if (!resource.is_available) return res.status(400).json({ error: 'Resource is not available' });

  const id = `loan-${Date.now()}`;
  const pickup = new Date(pickup_date);
  const ret = new Date(return_date);
  const dateText = `${formatReturnDate(ret.toISOString())}`;

  db.prepare(
    `INSERT INTO loans (id, resource_id, title, owner_id, owner_name, borrower_id, borrower_name,
      status_text, date_text, pickup_date, return_date, pickup_time, return_time,
      status_color, status_text_color)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`
  ).run(
    id,
    resource_id,
    title,
    owner_id,
    owner_name || resource.owner_name,
    req.userId,
    req.body.borrower_name || 'You',
    'PENDING',
    dateText,
    pickup_date,
    return_date,
    pickup_time || '',
    return_time || '',
    0xFFF3E5F5,
    0xFF7B1FA2,
  );

  const saved = db.prepare('SELECT * FROM loans WHERE id = ?').get(id);
  res.status(201).json(saved);
});

router.patch('/:id/status', authenticate, (req, res) => {
  const { status } = req.body;
  const validStatuses = ['APPROVED', 'REJECTED', 'RETURNED', 'CANCELLED', 'ACTIVE'];
  if (!validStatuses.includes(status)) {
    return res.status(400).json({ error: `Invalid status. Must be one of: ${validStatuses.join(', ')}` });
  }

  const loan = db.prepare('SELECT * FROM loans WHERE id = ?').get(req.params.id);
  if (!loan) return res.status(404).json({ error: 'Loan not found' });

  if (status === 'APPROVED' || status === 'REJECTED') {
    if (loan.owner_id !== req.userId) {
      return res.status(403).json({ error: 'Only the resource owner can approve or reject' });
    }
  }
  if (status === 'CANCELLED') {
    if (loan.borrower_id !== req.userId && loan.owner_id !== req.userId) {
      return res.status(403).json({ error: 'Only the borrower or owner can cancel' });
    }
  }
  if (status === 'RETURNED') {
    if (loan.owner_id !== req.userId) {
      return res.status(403).json({ error: 'Only the owner can mark as returned' });
    }
  }

  const colorMap = {
    APPROVED: { color: 0xFF4CAF50, textColor: 0xFFFFFFFF },
    REJECTED: { color: 0xFFF44336, textColor: 0xFFFFFFFF },
    RETURNED: { color: 0xFF9E9E9E, textColor: 0xFFFFFFFF },
    CANCELLED: { color: 0xFFFF9800, textColor: 0xFFFFFFFF },
    ACTIVE: { color: 0xFFDDE8FC, textColor: 0xFF1E8449 },
  };
  const c = colorMap[status] || { color: 0xFF4CAF50, textColor: 0xFFFFFFFF };

  db.prepare(
    `UPDATE loans SET status_text = ?, status_color = ?, status_text_color = ? WHERE id = ?`
  ).run(status, c.color, c.textColor, req.params.id);

  if (status === 'APPROVED') {
    db.prepare('UPDATE resources SET is_available = 0 WHERE id = ?').run(loan.resource_id);
  }
  if (status === 'RETURNED' || status === 'CANCELLED') {
    db.prepare('UPDATE resources SET is_available = 1 WHERE id = ?').run(loan.resource_id);
  }

  const updated = db.prepare('SELECT * FROM loans WHERE id = ?').get(req.params.id);
  res.json(updated);
});

router.patch('/:id/extend', authenticate, (req, res) => {
  const { return_date: returnDate } = req.body;
  if (!returnDate) return res.status(400).json({ error: 'return_date is required' });

  const existing = db.prepare('SELECT * FROM loans WHERE id = ?').get(req.params.id);
  if (!existing) return res.status(404).json({ error: 'Loan not found' });
  if (existing.borrower_id !== req.userId && existing.owner_id !== req.userId) {
    return res.status(403).json({ error: 'Not authorized' });
  }

  const iso = new Date(returnDate).toISOString();
  db.prepare(
    `UPDATE loans SET return_date = ?, date_text = ?, status_text = 'EXTENDED' WHERE id = ?`
  ).run(iso, formatReturnDate(iso), req.params.id);

  const updated = db.prepare('SELECT * FROM loans WHERE id = ?').get(req.params.id);
  res.json(updated);
});

module.exports = router;
