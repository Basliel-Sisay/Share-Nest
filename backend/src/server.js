const express = require('express');
const cors = require('cors');
const { seed } = require('./seed');
const { router: authRouter } = require('./routes/auth');
const resourcesRouter = require('./routes/resources');
const loansRouter = require('./routes/loans');
const reservationsRouter = require('./routes/reservations');
const adminRouter = require('./routes/admin');

seed();

const app = express();
const PORT = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());

app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', service: 'share-nest-api' });
});
app.use('/api/auth', authRouter);
app.use('/api/resources', resourcesRouter);
app.use('/api/loans', loansRouter);
app.use('/api/reservations', reservationsRouter);
app.use('/api/admin', adminRouter);
app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: 'Internal server error' });
});
app.listen(PORT, () => {
  console.log('ShareNest API running at http://localhost:' + PORT);
});
