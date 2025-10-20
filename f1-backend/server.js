const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');

const app = express();
app.use(cors());

const pool = new Pool({
  user: 'dhineshthiyagarajan', // Your PostgreSQL username
  host: 'localhost',
  port: 5432,
  database: 'f1_2024'
});

// --- Helper Function for DB Queries ---
async function executeQuery(res, query, params = [], errorMessage = "Failed to fetch data") {
  try {
    const data = await pool.query(query, params);
    res.json(data.rows);
  } catch (err) {
    console.error(`Error executing query (${errorMessage}):`, err.message);
    res.status(500).json({ error: errorMessage });
  }
}

// --- API Endpoints ---

app.get('/api/teams', async (req, res) => {
  const query = 'SELECT * FROM vw_driver_lineup ORDER BY team_name, driver_name';
  await executeQuery(res, query, [], "Failed to fetch teams data");
});

app.get('/api/calendar', async (req, res) => {
  const query = 'SELECT * FROM vw_race_calendar ORDER BY race_date';
  await executeQuery(res, query, [], "Failed to fetch calendar data");
});

app.get('/api/standings', async (req, res) => {
  const query = 'SELECT * FROM vw_driver_standings ORDER BY total_points DESC, driver_name';
  await executeQuery(res, query, [], "Failed to fetch standings data");
});

// *** CONSOLIDATED ENDPOINT FOR ALL RESULTS ***
// This single endpoint provides all session data to the frontend.
app.get('/api/results', async (req, res) => {
  const query = `
    SELECT
        res.result_id,
        s.session_id,
        s.session_type,
        r.name AS grand_prix,
        r.race_date,
        res.final_position,
        d.driver_id,
        d.first_name || ' ' || d.last_name AS driver_name,
        c.constructor_id,
        c.name AS team_name,
        res.grid_position,
        res.laps_completed,
        res.time_or_status,
        res.points
    FROM Results res
    JOIN Sessions s ON res.session_id = s.session_id
    JOIN Races r ON s.race_id = r.race_id
    JOIN Drivers d ON res.driver_id = d.driver_id
    JOIN Constructors c ON d.constructor_id = c.constructor_id
    ORDER BY r.race_date, s.session_date_time, res.final_position;
  `;
  await executeQuery(res, query, [], "Failed to fetch all session results");
});


// --- Start Server ---
app.listen(3001, () => console.log('API running on http://localhost:3001'));
