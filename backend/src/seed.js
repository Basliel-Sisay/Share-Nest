const bcrypt = require('bcrypt');
const db = require('./db');

function formatReturnDate(d) {
  const months = [ 'January', 'February', 'March', 'April', 'May', 'June','July', 'August', 'September', 'October', 'November', 'December'];
  return 'Return by ' + months[d.getMonth()] + ' ' + d.getDate() + ', 6:00 PM';
}

function seed() {
  const userCount = db.prepare('SELECT COUNT(*) AS c FROM users').get().c;
  if (userCount === 0) {
    const hashed = bcrypt.hashSync('password123', 10);
    db.prepare(
      "INSERT INTO users (id, name, email, password, role) VALUES (?, ?, ?, ?, ?)"
    ).run('user-1', 'Test User', 'test@example.com', hashed, 'user');
    console.log('Seed user created: test@example.com / password123');
  }

  const adminCount = db.prepare("SELECT COUNT(*) AS c FROM users WHERE role = 'admin'").get().c;
  if (adminCount === 0) {
    const adminHashed = bcrypt.hashSync('admin123', 10);
    db.prepare(
      "INSERT INTO users (id, name, email, password, role) VALUES (?, ?, ?, ?, ?)"
    ).run('admin-1', 'Admin', 'admin@sharenest.com', adminHashed, 'admin');
    console.log('Admin user created: admin@sharenest.com / admin123');
  }

  const resourceCount = db.prepare('SELECT COUNT(*) AS c FROM resources').get().c;
  // Clear resources to ensure updated paths and order are applied
  db.prepare('DELETE FROM resources').run();
  
  const insertResource = db.prepare(
    `INSERT INTO resources (
      id, title, owner_id, owner_name, distance, rating, category, description,
      image_path, location, condition, status_text, is_available
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`
  );

  const resources = [
    ['woodworking-kit', 'Woodworking Kit', 'user-1', 'Abrham Tesfaye', '200m', 4.9, 'Tools',
      'Woodworking kits with essential tools for wooden projects.',
      'assets/images/wood kit.jpg', 'Mekanissa', 'Good condition',
      'Available Today', 1],
    ['power-drill', 'Power Drill', 'user-1', 'Tinsae Getaneh', '0.8 miles', 4.8, 'Tools',
      'Compact Drill for everyday wall drilling and light home projects.',
      'assets/images/drill.png', 'Jemo, Mekanissa',
      'Includes 2 rechargeable batteries. Charger and carrying case included.',
      'Available Today', 1],
    ['kitchen-set-kit', 'Kitchen Set Kit', 'user-1', 'Sarah Kinde', '1.2km', 5.0, 'Kitchen',
      'A complete kitchen set kit for all your cooking needs.',
      'assets/images/kitchen kits.jpg', 'Jemo', 'Excellent condition',
      'Available Today', 1],
    ['python-programming', 'Python Programming', 'user-1', 'Sarah W.', '1.2 miles', 4.9, 'Books',
      'Comprehensive Python programming guide covering fundamentals and projects.',
      'assets/images/python_book.png', 'Bole, Addis Ababa', 'Gently used.',
      'Free from Mar 15', 1],
    ['english-textbook', 'English Text Book', 'user-1', 'Sarah Kinde', '1.2km', 5.0, 'Books',
      'Grade 11 English Textbook for Ethiopian students.',
      'assets/images/english.jpg', 'Jemo', 'Like new',
      'Available Today', 1],
    ['book-of-daniel', 'Book of Daniel', 'user-1', 'Sarah W.', '1.5 miles', 4.9, 'Books',
      'The Book of Daniel from the Bible, explore ancient prophecy.',
      'assets/images/book_of_daniel.jpg', 'Bole', 'Good condition',
      'Available Today', 1],
    ['book-of-moses', 'Book of Moses', 'user-1', 'Sarah W.', '1.6 miles', 4.8, 'Books',
      'The Book of Moses, part of the Pearl of Great Price.',
      'assets/images/book of moses.jpg', 'Bole', 'Well preserved',
      'Available Today', 1],
    ['event-chairs', 'Event Chairs (Set of 10)', 'user-1', 'Community Hub', '0.8 Km', 4.7, 'Furniture',
      'Set of 10 folding event chairs for parties and gatherings.',
      'assets/images/plastic chairs.jpg', 'Jemo 1', 'Clean and sturdy',
      'Available Today', 1],
  ];


  const seedResources = db.transaction((rows) => {
    for (const row of rows) insertResource.run(...row);
  });
  seedResources(resources);

  const dueSoon = new Date();
  dueSoon.setDate(dueSoon.getDate() + 2);
  const activeReturn = new Date();
  activeReturn.setDate(activeReturn.getDate() + 4);

  db.prepare(
    `INSERT INTO loans (id, resource_id, title, owner_id, owner_name, borrower_id, borrower_name,
      status_text, date_text, pickup_date, return_date, pickup_time, return_time,
      status_color, status_text_color)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`
  ).run(
    'loan-1', 'power-drill', 'DeWalt Power Drill',
    'user-1', 'Mike R.', 'user-1', 'Test User',
    'ACTIVE', formatReturnDate(dueSoon), new Date().toISOString(),
    dueSoon.toISOString(), '10:00 AM', '6:00 PM',
    0xffdde8fc, 0xff1e8449,
  );

  db.prepare(
    `INSERT INTO reservations (id, resource_id, title, owner_id, borrower_id,
      pickup_location, pickup_date, return_date, pickup_time, return_time, distance, status)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`
  ).run(
    'res-1', 'event-chairs', 'Event Chairs (Set of 10)',
    'user-1', 'user-1',
    'Pickup from Jemo 1',
    new Date('2026-07-12T10:00:00').toISOString(),
    new Date('2026-07-14T16:00:00').toISOString(),
    '10:00 AM', '04:00 PM', '0.8 Km away', 'CONFIRMED',
  );

  console.log('SQLite database seeded successfully');
}

if (require.main === module) {
  seed();
}
module.exports = { seed };
