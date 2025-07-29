const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const app = express();
const port = 5001;

const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  database: 'appdb',
  user: 'postgres',
  password: 'postgres',
});

app.use(cors()); // 🔥 Enable CORS
app.use(express.json());

const waitForDB = async () => {
  for (let i = 0; i < 10; i++) {
    try {
      await pool.query('SELECT 1');
      return;
    } catch (e) {
      console.log("Postgres not ready, retrying...");
      await new Promise(res => setTimeout(res, 2000));
    }
  }
  throw new Error("Could not connect to PostgreSQL");
};

const createTableIfNotExists = async () => {
  try {
    await pool.query(`
      CREATE TABLE IF NOT EXISTS posts (
        id SERIAL PRIMARY KEY,
        title TEXT
      )
    `);
    console.log("Posts table is ready.");
  } catch (err) {
    console.error("Error creating posts table:", err);
  }
};

waitForDB()
  .then(createTableIfNotExists)
  .then(() => {
    app.get('/posts', async (req, res) => {
      const result = await pool.query('SELECT * FROM posts');
      res.json(result.rows);
    });

    app.post('/posts', async (req, res) => {
      const { title } = req.body;
      const result = await pool.query('INSERT INTO posts (title) VALUES ($1) RETURNING *', [title]);
      res.json(result.rows[0]);
    });

    app.listen(port, () => console.log(`Post service on ${port}`));
  })
  .catch(err => {
    console.error(err);
    process.exit(1);
  });
