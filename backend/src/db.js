const { DatabaseSync } = require('node:sqlite');
const fs = require('fs');
const path = require('path');
const dataDir = path.join(__dirname, '..', 'data');
if (!fs.existsSync(dataDir)) {
  fs.mkdirSync(dataDir, { recursive: true });
}
const dbPath = path.join(dataDir, 'share_nest.db');
const database = new DatabaseSync(dbPath);
database.exec('PRAGMA journal_mode = WAL;');
function initSchema(){
  database.exec(`
    CREATE TABLE IF NOT EXISTS resources (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      owner_name TEXT NOT NULL,
      distance TEXT NOT NULL,
      rating REAL NOT NULL,
      category TEXT NOT NULL,
      description TEXT NOT NULL,
      image_path TEXT NOT NULL,
      location TEXT DEFAULT '',
      condition TEXT DEFAULT '',
      status_text TEXT DEFAULT 'Available Today',
      is_available INTEGER NOT NULL DEFAULT 1
    );

    CREATE TABLE IF NOT EXISTS loans (
      id TEXT PRIMARY KEY,
      resource_id TEXT NOT NULL,
      title TEXT NOT NULL,
      owner_name TEXT NOT NULL,
      status_text TEXT NOT NULL,
      date_text TEXT NOT NULL,
      return_date TEXT NOT NULL,
      status_color INTEGER NOT NULL,
      status_text_color INTEGER NOT NULL
    );

    CREATE TABLE IF NOT EXISTS users (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL,
      created_at TEXT DEFAULT (datetime('now'))
    );

    CREATE TABLE IF NOT EXISTS reservations (
      id TEXT PRIMARY KEY,
      resource_id TEXT NOT NULL,
      title TEXT NOT NULL,
      pickup_location TEXT NOT NULL,
      pickup_date TEXT NOT NULL,
      return_date TEXT NOT NULL,
      pickup_time TEXT NOT NULL,
      return_time TEXT NOT NULL,
      distance TEXT DEFAULT '0.8 Km away',
      status TEXT DEFAULT 'CONFIRMED'
    );
  `);
}
initSchema();
function prepare(sql){
  const stmt = database.prepare(sql);
  return {
    all:(...params) => stmt.all(...params),
    get:(...params) => stmt.get(...params),
    run:(...params) => stmt.run(...params),
  };
}
function transaction(fn){
  return (arg) => {
    database.exec('BEGIN IMMEDIATE');
    try{
      fn(arg);
      database.exec('COMMIT');
    } 
    catch (error){
      database.exec('ROLLBACK');
      throw error;
    }
  };
}
module.exports = { 
  prepare, 
  transaction, 
  exec: (sql) => database.exec(sql) 
};
