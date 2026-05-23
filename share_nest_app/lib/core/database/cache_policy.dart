/// Documents the cache-first read strategy used by repositories.
///
/// 1. Read from Flutter SQLite (local cache).
/// 2. On cache hit (rows exist), return immediately.
/// 3. On cache miss, HTTP GET to Node API (`backend/`).
/// 4. Persist response into SQLite, then return.
///
/// Writes go to Node first, then update the local SQLite cache.
library;
