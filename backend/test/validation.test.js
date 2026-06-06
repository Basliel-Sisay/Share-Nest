const { test, describe, before } = require('node:test');
const assert = require('node:assert');
const request = require('supertest');
const express = require('express');
const { router } = require('../src/routes/auth');

const mockDb = {
  prepare: () => ({
    get: () => null,
    run: () => ({})
  })
};

describe('Auth Route Validation Tests', () => {
  let app;
  before(() => {
    app = express();
    app.use(express.json());
    app.use('/auth', router);
  });

  test('POST /auth/signup should fail with missing fields', async () => {
    const res = await request(app)
      .post('/auth/signup')
      .send({ name: 'Test' });
    assert.strictEqual(res.statusCode, 400);
    assert.strictEqual(res.body.error, 'name, email, and password are required');
  });

  test('POST /auth/signup should fail with short password', async () => {
    const res = await request(app)
      .post('/auth/signup')
      .send({ name: 'Test', email: 'test@test.com', password: '123' });
    
    assert.strictEqual(res.statusCode, 400);
    assert.strictEqual(res.body.error, 'Password must be at least 6 characters');
  });

  test('POST /auth/login should fail with missing fields', async () => {
    const res = await request(app)
      .post('/auth/login')
      .send({ email: 'test@test.com' });
    
    assert.strictEqual(res.statusCode, 400);
    assert.strictEqual(res.body.error, 'email and password are required');
  });
});
