const express = require('express');
const db = require('../db');

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

router.get('/', (req, res) => {
  const rows = db.prepare('SELECT * FROM loans').all();
  res.json(rows);
});

router.patch('/:id/extend', (req, res) => {
  const { return_date: returnDate } = req.body;
  if (!returnDate) {
    return res.status(400).json({ error: 'return_date is required' });
  }

  const existing = db.prepare('SELECT * FROM loans WHERE id = ?').get(req.params.id);
  if (!existing) {
    return res.status(404).json({ error: 'Loan not found' });
  }

  const iso = new Date(returnDate).toISOString();
  db.prepare(
    `
    UPDATE loans SET
      return_date = ?,
      date_text = ?,
      status_text = 'EXTENDED'
    WHERE id = ?
  `,
  ).run(iso, formatReturnDate(iso), req.params.id);

  const updated = db.prepare('SELECT * FROM loans WHERE id = ?').get(req.params.id);
  res.json(updated);
});

module.exports = router;
