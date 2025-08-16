const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');
const app = express();
const port = 8080;

app.use(cors());

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: 5432,
  ssl: {
    rejectUnauthorized: false
  }
});

app.get('/', (req, res) => {
  res.send('Hello from the K-Stax backend!');
});

app.get('/status', async (req, res) => {
  try {
    const client = await pool.connect();
    res.json({ status: 'ok', db: 'connected' });
    client.release();
  } catch (err) {
    console.error("DB Connection Error:", err.message);
    res.status(500).json({ status: 'error', db: 'disconnected', error: err.message });
  }
});

app.listen(port, () => {
  console.log(`Backend listening at http://localhost:${port}`);
});
