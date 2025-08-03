const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const client = require('prom-client');

const app = express();
const port = 5001;

// Prometheus metrics
const collectDefaultMetrics = client.collectDefaultMetrics;
const Registry = client.Registry;
const register = new Registry();
collectDefaultMetrics({ register });

const httpRequestCounter = new client.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status'],
});
register.registerMetric(httpRequestCounter);

// DB connection
const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  database: 'appdb',
  user: 'postgres',
  password: 'postgres',
});

app.use(cors());
app.use(express.json());

// Prometheus metrics endpoint
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});

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
      httpRequestCounter.inc({ method: req.method, route: '/posts', status: 200 });
      res.json(result.rows);
    });

    app.post('/posts', async (req, res) => {
      const { title } = req.body;
      const result = await pool.query(
        'INSERT INTO posts (title) VALUES ($1) RETURNING *',
        [title]
      );
      httpRequestCounter.inc({ method: req.method, route: '/posts', status: 201 });
      res.status(201).json(result.rows[0]);
    });

    // ✅ KEY FIX HERE
    app.listen(port, '0.0.0.0', () => console.log(`✅ Post service running on port ${port}`));
  })
  .catch(err => {
    console.error(err);
    process.exit(1);
  });
