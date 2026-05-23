const {DatabaseSync} = require('node:sqlite');
const fs = require('fs');
const path = require('path');
const dataDir = path.join(__dirname, '..', 'data');
if (!fs.existsSync(dataDir)){
  fs.mkdirSync(dataDir, { recursive: true });
}
const dbPath = path.join(dataDir, 'share_nest.db');
const database = new DatabaseSync(dbPath);
database.exec('PRAGMA journal_mode = WAL;');

function getColumnNames(table){
  const rows = database.prepare(`PRAGMA table_info(${table})`).all();
  return rows.map((r) => r.name);
}

function addColumnIfMissing(table, columnDef){
  const existing = getColumnNames(table);
  const colName = columnDef.split(' ')[0];
  if (!existing.includes(colName)) {
    database.exec(`ALTER TABLE ${table} ADD COLUMN ${columnDef}`);
  }
}

function initSchema(){
  database.exec(`
    CREATE TABLE IF NOT EXISTS users (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL,
      role TEXT NOT NULL DEFAULT 'user',
      created_at TEXT DEFAULT (datetime('now'))
    );

    CREATE TABLE IF NOT EXISTS resources (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      owner_id TEXT NOT NULL,
      owner_name TEXT NOT NULL,
      distance TEXT NOT NULL,
      rating REAL NOT NULL DEFAULT 5.0,
      category TEXT NOT NULL,
      description TEXT NOT NULL,
      image_path TEXT NOT NULL DEFAULT 'assets/images/drill.png',
      location TEXT DEFAULT '',
      condition TEXT DEFAULT '',
      status_text TEXT DEFAULT 'Available Today',
      is_available INTEGER NOT NULL DEFAULT 1,
      created_at TEXT DEFAULT (datetime('now'))
    );

    CREATE TABLE IF NOT EXISTS loans (
      id TEXT PRIMARY KEY,
      resource_id TEXT NOT NULL,
      title TEXT NOT NULL,
      owner_id TEXT NOT NULL,
      owner_name TEXT NOT NULL,
      borrower_id TEXT NOT NULL,
      borrower_name TEXT NOT NULL,
      status_text TEXT NOT NULL DEFAULT 'PENDING',
      date_text TEXT NOT NULL,
      pickup_date TEXT NOT NULL,
      return_date TEXT NOT NULL,
      pickup_time TEXT DEFAULT '',
      return_time TEXT DEFAULT '',
      status_color INTEGER NOT NULL DEFAULT 0xFF4CAF50,
      status_text_color INTEGER NOT NULL DEFAULT 0xFFFFFFFF,
      created_at TEXT DEFAULT (datetime('now'))
    );

    CREATE TABLE IF NOT EXISTS reservations (
      id TEXT PRIMARY KEY,
      resource_id TEXT NOT NULL,
      title TEXT NOT NULL,
      owner_id TEXT NOT NULL,
      borrower_id TEXT NOT NULL,
      pickup_location TEXT NOT NULL DEFAULT 'Pickup from community hub',
      pickup_date TEXT NOT NULL,
      return_date TEXT NOT NULL,
      pickup_time TEXT NOT NULL DEFAULT '',
      return_time TEXT NOT NULL DEFAULT '',
      distance TEXT DEFAULT '0.8 Km away',
      status TEXT NOT NULL DEFAULT 'PENDING',
      created_at TEXT DEFAULT (datetime('now'))
    );
  `);
  addColumnIfMissing('users', 'role TEXT NOT NULL DEFAULT \'user\'');
  addColumnIfMissing('resources', 'owner_id TEXT NOT NULL DEFAULT \'\'');
  addColumnIfMissing('loans', 'owner_id TEXT NOT NULL DEFAULT \'\'');
  addColumnIfMissing('loans', 'borrower_id TEXT NOT NULL DEFAULT \'\'');
  addColumnIfMissing('loans', 'borrower_name TEXT NOT NULL DEFAULT \'\'');
  addColumnIfMissing('loans', 'pickup_date TEXT NOT NULL DEFAULT \'\'');
  addColumnIfMissing('loans', 'pickup_time TEXT DEFAULT \'\'');
  addColumnIfMissing('loans', 'return_time TEXT DEFAULT \'\'');
  addColumnIfMissing('reservations', 'owner_id TEXT NOT NULL DEFAULT \'\'');
  addColumnIfMissing('reservations', 'borrower_id TEXT NOT NULL DEFAULT \'\'');
  addColumnIfMissing('loans', 'created_at TEXT DEFAULT \'\'');
}
initSchema();

function prepare(sql){
  const stmt = database.prepare(sql);
  return {
    all: (...params) => stmt.all(...params),
    get: (...params) => stmt.get(...params),
    run: (...params) => stmt.run(...params),
  };
}

function transaction(fn){
  return (arg) => {
    database.exec('BEGIN IMMEDIATE');
    try {
      fn(arg);
      database.exec('COMMIT');
    } 
    catch (error) {
      database.exec('ROLLBACK');
      throw error;
    }
  };
}
module.exports = {
  prepare,
  transaction,
  exec: (sql) => database.exec(sql),
};
