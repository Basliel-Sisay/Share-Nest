const { test, describe, beforeEach } = require('node:test');
const assert = require('node:assert');
const { authenticate, requireAdmin } = require('../src/routes/auth');
const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'share-nest-dev-secret';

describe('Auth Middleware Unit Tests', () => {
  let mockReq;
  let mockRes;
  let nextCalled;

  const nextFunction = () => {
    nextCalled = true;
  };

  beforeEach(() => {
    nextCalled = false;
    mockReq = {
      headers: {}
    };
    mockRes = {
      status: function(code) {
        this.statusCode = code;
        return this;
      },
      json: function(data) {
        this.body = data;
        return this;
      }
    };
  });

  test('authenticate should fail if no is token provided', () => {
    authenticate(mockReq, mockRes, nextFunction);
    assert.strictEqual(mockRes.statusCode, 401);
    assert.deepStrictEqual(mockRes.body, { error: 'No token provided' });
    assert.strictEqual(nextCalled, false);
  });

  test('authenticate should fail if invalid is token provided', () => {
    mockReq.headers.authorization = 'Bearer invalid-token';
    authenticate(mockReq, mockRes, nextFunction);
    assert.strictEqual(mockRes.statusCode, 401);
    assert.deepStrictEqual(mockRes.body, { error: 'Invalid or expired token' });
    assert.strictEqual(nextCalled, false);
  });

  test('authenticate should succeed with valid token', () => {
    const payload = { userId: '123', email: 'test@test.com', role: 'user'};
    const token = jwt.sign(payload, JWT_SECRET);
    mockReq.headers.authorization = `Bearer ${token}`;
    authenticate(mockReq, mockRes, nextFunction);
    assert.strictEqual(mockReq.userId, payload.userId);
    assert.strictEqual(mockReq.userRole, payload.role);
    assert.strictEqual(nextCalled, true);
  });

  test('requireAdmin should fail for non admin user', () => {
    mockReq.userRole = 'user';
    requireAdmin(mockReq, mockRes, nextFunction);
    assert.strictEqual(mockRes.statusCode, 403);
    assert.deepStrictEqual(mockRes.body, { error: 'Admin access required' });
    assert.strictEqual(nextCalled, false);
  });
  test('requireAdmin should succeed for admin user', () => {
    mockReq.userRole = 'admin';
    requireAdmin(mockReq, mockRes, nextFunction);
    assert.strictEqual(nextCalled, true);
  });
});
