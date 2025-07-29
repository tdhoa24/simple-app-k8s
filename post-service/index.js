const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');

const app = express();
app.use(cors()); // 🔥 Enable CORS
app.use(express.json());

const pool = new Pool({
  host: 'postgres',
  user: 'appuser',
  password: 'apppassword',
  database: 'appdb',
});

async function init() {
  let connected = false;
  while (!connected) {
    try {
      await pool.query(`
        CREATE TABLE IF NOT EXISTS posts (
          id SERIAL PRIMARY KEY,
          content TEXT NOT NULL
        );
      `);
      connected = true;
      console.log("Posts table is ready.");
    } catch (err) {
      console.log("Postgres not ready, retrying...");
      await new Promise(r => setTimeout(r, 1000));
    }
  }
}
init();

app.get('/posts', async (req, res) => {
  const result = await pool.query("SELECT * FROM posts;");
  res.json(result.rows);
});

app.post('/posts', async (req, res) => {
  const { content } = req.body;
  await pool.query("INSERT INTO posts (content) VALUES ($1);", [content]);
  res.json({ status: "Post created" });
});

app.listen(5001, () => {
  console.log('Post service on 5001');
});
