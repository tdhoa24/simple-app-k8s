const express = require('express');
const { Pool } = require('pg');
const app = express();
app.use(express.json());

const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  database: 'appdb',
  user: 'postgres',
  password: 'postgres'
});

app.post('/posts', async (req, res) => {
  const { title } = req.body;
  const result = await pool.query('INSERT INTO posts (title) VALUES ($1) RETURNING id', [title]);
  res.json({ id: result.rows[0].id });
});

app.get('/posts', async (req, res) => {
  const result = await pool.query('SELECT * FROM posts');
  res.json(result.rows);
});

app.listen(5001, () => console.log('Post service on 5001'));
