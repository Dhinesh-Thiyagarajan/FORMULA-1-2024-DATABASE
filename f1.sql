-- =============================================
-- F1 2024 SEASON DATABASE - COMPLETE SCRIPT
-- PostgreSQL Implementation - CORRECTED VERSION
-- =============================================

-- Drop existing tables if they exist (for clean installation)
DROP TABLE IF EXISTS Results CASCADE;
DROP TABLE IF EXISTS Sessions CASCADE;
DROP TABLE IF EXISTS Races CASCADE;
DROP TABLE IF EXISTS Circuits CASCADE;
DROP TABLE IF EXISTS Drivers CASCADE;
DROP TABLE IF EXISTS Constructors CASCADE;

-- =============================================
-- 1. CONSTRUCTORS (TEAMS) TABLE
-- =============================================
CREATE TABLE Constructors (
    constructor_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    nationality VARCHAR(50) NOT NULL,
    base_location VARCHAR(100),
    engine_supplier VARCHAR(100)
);

-- =============================================
-- 2. DRIVERS TABLE
-- =============================================
CREATE TABLE Drivers (
    driver_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    driver_number INT UNIQUE NOT NULL CHECK (driver_number > 0),
    country_code CHAR(3),
    constructor_id INT REFERENCES Constructors(constructor_id) ON DELETE RESTRICT,
    UNIQUE (first_name, last_name)
);

-- =============================================
-- 3. CIRCUITS (TRACKS) TABLE
-- =============================================
CREATE TABLE Circuits (
    circuit_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    location VARCHAR(100),
    country VARCHAR(100) NOT NULL,
    track_length_km NUMERIC(5, 3) NOT NULL
);

-- =============================================
-- 4. RACES/EVENTS TABLE
-- =============================================
CREATE TABLE Races (
    race_id SERIAL PRIMARY KEY,
    name VARCHAR(150) UNIQUE NOT NULL,
    race_date DATE NOT NULL,
    circuit_id INT REFERENCES Circuits(circuit_id) ON DELETE RESTRICT,
    total_laps INT,
    is_sprint_weekend BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE INDEX idx_race_date ON Races (race_date);

-- =============================================
-- 5. SESSIONS TABLE
-- =============================================
CREATE TABLE Sessions (
    session_id BIGSERIAL PRIMARY KEY,
    race_id INT REFERENCES Races(race_id) ON DELETE CASCADE,
    session_type VARCHAR(50) NOT NULL,
    session_date_time TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    UNIQUE (race_id, session_type)
);

-- =============================================
-- 6. RESULTS TABLE
-- =============================================
CREATE TABLE Results (
    result_id BIGSERIAL PRIMARY KEY,
    session_id BIGINT REFERENCES Sessions(session_id) ON DELETE CASCADE,
    driver_id INT REFERENCES Drivers(driver_id) ON DELETE RESTRICT,
    final_position INT NOT NULL,
    grid_position INT,
    laps_completed INT,
    time_or_status VARCHAR(50),
    points NUMERIC(5, 2) NOT NULL DEFAULT 0,
    UNIQUE (session_id, driver_id)
);

CREATE INDEX idx_results_session_driver ON Results (session_id, driver_id);
CREATE INDEX idx_results_driver ON Results (driver_id);

-- =============================================
-- INSERT DATA: CONSTRUCTORS
-- =============================================
INSERT INTO Constructors (name, nationality, base_location, engine_supplier) VALUES
('Oracle Red Bull Racing', 'Austrian', 'Milton Keynes, UK', 'Honda RBPT'),
('McLaren Formula 1 Team', 'British', 'Woking, UK', 'Mercedes'),
('Scuderia Ferrari', 'Italian', 'Maranello, Italy', 'Ferrari'),
('Mercedes-AMG Petronas F1 Team', 'German', 'Brackley, UK', 'Mercedes'),
('Aston Martin Aramco F1 Team', 'British', 'Silverstone, UK', 'Mercedes'),
('BWT Alpine F1 Team', 'French', 'Enstone, UK', 'Renault'),
('Williams Racing', 'British', 'Grove, UK', 'Mercedes'),
('Visa Cash App RB F1 Team', 'Italian', 'Faenza, Italy', 'Honda RBPT'),
('Stake F1 Team Kick Sauber', 'Swiss', 'Hinwil, Switzerland', 'Ferrari'),
('MoneyGram Haas F1 Team', 'American', 'Kannapolis, USA', 'Ferrari');

-- =============================================
-- INSERT DATA: DRIVERS
-- =============================================
INSERT INTO Drivers (first_name, last_name, driver_number, country_code, constructor_id) VALUES
-- Red Bull Racing
('Max', 'Verstappen', 1, 'NED', 1),
('Sergio', 'Pérez', 11, 'MEX', 1),
-- McLaren
('Lando', 'Norris', 4, 'GBR', 2),
('Oscar', 'Piastri', 81, 'AUS', 2),
-- Ferrari
('Charles', 'Leclerc', 16, 'MCO', 3),
('Carlos', 'Sainz Jr.', 55, 'ESP', 3),
-- Mercedes
('Lewis', 'Hamilton', 44, 'GBR', 4),
('George', 'Russell', 63, 'GBR', 4),
-- Aston Martin
('Fernando', 'Alonso', 14, 'ESP', 5),
('Lance', 'Stroll', 18, 'CAN', 5),
-- Alpine
('Pierre', 'Gasly', 10, 'FRA', 6),
('Esteban', 'Ocon', 31, 'FRA', 6),
-- Williams
('Alexander', 'Albon', 23, 'THA', 7),
('Franco', 'Colapinto', 43, 'ARG', 7),
-- RB (Racing Bulls)
('Yuki', 'Tsunoda', 22, 'JPN', 8),
('Daniel', 'Ricciardo', 3, 'AUS', 8),
('Liam', 'Lawson', 30, 'NZL', 8),
-- Sauber
('Valtteri', 'Bottas', 77, 'FIN', 9),
('Zhou', 'Guanyu', 24, 'CHN', 9),
-- Haas
('Nico', 'Hülkenberg', 27, 'DEU', 10),
('Kevin', 'Magnussen', 20, 'DNK', 10);

-- =============================================
-- INSERT DATA: CIRCUITS
-- =============================================
INSERT INTO Circuits (name, location, country, track_length_km) VALUES
('Bahrain International Circuit', 'Sakhir', 'Bahrain', 5.412),
('Jeddah Corniche Circuit', 'Jeddah', 'Saudi Arabia', 6.174),
('Albert Park Circuit', 'Melbourne', 'Australia', 5.278),
('Suzuka International Racing Course', 'Suzuka', 'Japan', 5.807),
('Shanghai International Circuit', 'Shanghai', 'China', 5.451),
('Miami International Autodrome', 'Miami', 'United States', 5.412),
('Imola Circuit', 'Imola', 'Italy', 4.909),
('Circuit de Monaco', 'Monaco', 'Monaco', 3.337),
('Circuit Gilles Villeneuve', 'Montreal', 'Canada', 4.361),
('Circuit de Barcelona-Catalunya', 'Montmeló', 'Spain', 4.675),
('Red Bull Ring', 'Spielberg', 'Austria', 4.318),
('Silverstone Circuit', 'Silverstone', 'United Kingdom', 5.891),
('Hungaroring', 'Mogyoród', 'Hungary', 4.381),
('Circuit de Spa-Francorchamps', 'Stavelot', 'Belgium', 7.004),
('Circuit Zandvoort', 'Zandvoort', 'Netherlands', 4.259),
('Monza Circuit', 'Monza', 'Italy', 5.793),
('Baku City Circuit', 'Baku', 'Azerbaijan', 6.003),
('Marina Bay Street Circuit', 'Singapore', 'Singapore', 4.940),
('Circuit of the Americas', 'Austin', 'United States', 5.513),
('Autódromo Hermanos Rodríguez', 'Mexico City', 'Mexico', 4.304),
('Interlagos Circuit', 'São Paulo', 'Brazil', 4.309),
('Las Vegas Strip Circuit', 'Paradise', 'United States', 6.201),
('Lusail International Circuit', 'Lusail', 'Qatar', 5.419),
('Yas Marina Circuit', 'Abu Dhabi', 'UAE', 5.281);

-- =============================================
-- INSERT DATA: RACES
-- =============================================
INSERT INTO Races (name, race_date, circuit_id, total_laps, is_sprint_weekend) VALUES
('Bahrain Grand Prix', '2024-03-02', 1, 57, FALSE),
('Saudi Arabian Grand Prix', '2024-03-09', 2, 50, FALSE),
('Australian Grand Prix', '2024-03-24', 3, 58, FALSE),
('Japanese Grand Prix', '2024-04-07', 4, 53, FALSE),
('Chinese Grand Prix', '2024-04-21', 5, 56, TRUE),
('Miami Grand Prix', '2024-05-05', 6, 57, TRUE),
('Emilia Romagna Grand Prix', '2024-05-19', 7, 63, FALSE),
('Monaco Grand Prix', '2024-05-26', 8, 78, FALSE),
('Canadian Grand Prix', '2024-06-09', 9, 70, FALSE),
('Spanish Grand Prix', '2024-06-23', 10, 66, FALSE),
('Austrian Grand Prix', '2024-06-30', 11, 71, TRUE),
('British Grand Prix', '2024-07-07', 12, 52, FALSE),
('Hungarian Grand Prix', '2024-07-21', 13, 70, FALSE),
('Belgian Grand Prix', '2024-07-28', 14, 44, FALSE),
('Dutch Grand Prix', '2024-08-25', 15, 72, FALSE),
('Italian Grand Prix', '2024-09-01', 16, 53, FALSE),
('Azerbaijan Grand Prix', '2024-09-15', 17, 51, FALSE),
('Singapore Grand Prix', '2024-09-22', 18, 62, FALSE),
('United States Grand Prix', '2024-10-20', 19, 56, TRUE),
('Mexico City Grand Prix', '2024-10-27', 20, 71, FALSE),
('São Paulo Grand Prix', '2024-11-03', 21, 71, TRUE),
('Las Vegas Grand Prix', '2024-11-23', 22, 50, FALSE),
('Qatar Grand Prix', '2024-12-01', 23, 57, TRUE),
('Abu Dhabi Grand Prix', '2024-12-08', 24, 58, FALSE);

-- =============================================
-- INSERT DATA: SAMPLE SESSIONS (First 3 Races)
-- =============================================

-- Bahrain GP Sessions
INSERT INTO Sessions (race_id, session_type, session_date_time) VALUES
(1, 'FP1', '2024-03-01 14:30:00'),
(1, 'FP2', '2024-03-01 18:00:00'),
(1, 'FP3', '2024-03-02 14:30:00'),
(1, 'QUALIFYING', '2024-03-02 18:00:00'),
(1, 'RACE', '2024-03-02 21:00:00');

-- Saudi Arabian GP Sessions
INSERT INTO Sessions (race_id, session_type, session_date_time) VALUES
(2, 'FP1', '2024-03-08 14:30:00'),
(2, 'FP2', '2024-03-08 18:00:00'),
(2, 'FP3', '2024-03-09 14:30:00'),
(2, 'QUALIFYING', '2024-03-09 18:00:00'),
(2, 'RACE', '2024-03-09 21:00:00');

-- Australian GP Sessions
INSERT INTO Sessions (race_id, session_type, session_date_time) VALUES
(3, 'FP1', '2024-03-22 12:30:00'),
(3, 'FP2', '2024-03-22 16:00:00'),
(3, 'FP3', '2024-03-23 12:30:00'),
(3, 'QUALIFYING', '2024-03-23 16:00:00'),
(3, 'RACE', '2024-03-24 15:00:00');

-- =============================================
-- INSERT DATA: SAMPLE RACE RESULTS (CORRECTED)
-- =============================================

-- Bahrain GP Race Results (Session ID: 5)
-- FIXED: Changed driver_id 27 to 20 (Hülkenberg), 22 to 15 (Tsunoda), 16 to 17 (Lawson)
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
(5, 1, 1, 1, 57, '1:31:44.742', 25.0),     -- Verstappen
(5, 2, 2, 5, 57, '+22.457', 18.0),         -- Pérez
(5, 6, 3, 3, 57, '+25.692', 15.0),         -- Sainz
(5, 5, 4, 2, 57, '+28.444', 12.0),         -- Leclerc
(5, 8, 5, 4, 57, '+30.011', 10.0),         -- Russell
(5, 3, 6, 8, 57, '+33.821', 8.0),          -- Norris
(5, 7, 7, 7, 57, '+51.870', 6.0),          -- Hamilton
(5, 4, 8, 9, 57, '+55.513', 4.0),          -- Piastri
(5, 9, 9, 11, 57, '+1:00.421', 2.0),       -- Alonso
(5, 19, 10, 15, 57, '+1:03.212', 1.0),     -- Zhou
(5, 10, 11, 13, 57, '+1:05.833', 0.0),     -- Stroll
(5, 20, 12, 12, 57, '+1:08.127', 0.0),     -- Hülkenberg (FIXED)
(5, 15, 13, 17, 57, '+1:10.506', 0.0),     -- Tsunoda (FIXED)
(5, 17, 14, 14, 56, '+1 lap', 0.0),        -- Lawson (FIXED)
(5, 21, 15, 16, 56, '+1 lap', 0.0);        -- Magnussen

-- Saudi Arabian GP Race Results (Session ID: 10)
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
(10, 1, 1, 1, 50, '1:20:43.273', 25.0),    -- Verstappen
(10, 2, 2, 2, 50, '+13.643', 18.0),        -- Pérez
(10, 5, 3, 3, 50, '+18.639', 15.0),        -- Leclerc
(10, 4, 4, 5, 50, '+21.570', 12.0),        -- Piastri
(10, 9, 5, 4, 50, '+25.889', 10.0),        -- Alonso
(10, 8, 6, 6, 50, '+28.114', 8.0),         -- Russell
(10, 3, 7, 8, 50, '+30.502', 6.0),         -- Norris
(10, 7, 8, 7, 50, '+35.213', 4.0),         -- Hamilton
(10, 11, 9, 11, 50, '+38.122', 2.0),       -- Gasly
(10, 13, 10, 12, 50, '+40.751', 1.0);      -- Albon

-- Australian GP Race Results (Session ID: 15)
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
(15, 6, 1, 1, 58, '1:20:26.843', 25.0),    -- Sainz
(15, 5, 2, 2, 58, '+2.366', 18.0),         -- Leclerc
(15, 3, 3, 3, 58, '+5.029', 15.0),         -- Norris
(15, 4, 4, 4, 58, '+8.569', 12.0),         -- Piastri
(15, 1, 5, 5, 58, '+12.065', 10.0),        -- Verstappen
(15, 8, 6, 7, 58, '+15.241', 8.0),         -- Russell
(15, 7, 7, 11, 58, '+17.823', 6.0),        -- Hamilton
(15, 15, 8, 8, 58, '+19.514', 4.0),        -- Tsunoda
(15, 20, 9, 10, 58, '+21.328', 2.0),       -- Hülkenberg
(15, 11, 10, 13, 58, '+23.987', 1.0);      -- Gasly

-- =============================================
-- CREATE USEFUL VIEWS FOR QUERYING
-- =============================================

-- View: Complete Driver Information with Team
CREATE VIEW vw_driver_lineup AS
SELECT 
    d.driver_id,
    d.driver_number,
    d.first_name || ' ' || d.last_name AS driver_name,
    d.country_code,
    c.name AS team_name,
    c.engine_supplier
FROM Drivers d
JOIN Constructors c ON d.constructor_id = c.constructor_id
ORDER BY c.constructor_id, d.driver_number;

-- View: Complete Race Calendar
CREATE VIEW vw_race_calendar AS
SELECT 
    r.race_id,
    r.name AS grand_prix,
    r.race_date,
    c.name AS circuit_name,
    c.location,
    c.country,
    c.track_length_km,
    r.total_laps,
    CASE WHEN r.is_sprint_weekend THEN 'Yes' ELSE 'No' END AS sprint_weekend
FROM Races r
JOIN Circuits c ON r.circuit_id = c.circuit_id
ORDER BY r.race_date;

-- View: Race Results with Driver and Team Info
CREATE VIEW vw_race_results AS
SELECT 
    r.name AS grand_prix,
    s.session_type,
    res.final_position,
    d.first_name || ' ' || d.last_name AS driver_name,
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
WHERE s.session_type = 'RACE'
ORDER BY r.race_date, res.final_position;

-- View: Driver Championship Standings
CREATE VIEW vw_driver_standings AS
SELECT 
    d.driver_id,
    d.first_name || ' ' || d.last_name AS driver_name,
    c.name AS team_name,
    COALESCE(SUM(res.points), 0) AS total_points,
    COUNT(DISTINCT s.race_id) AS races_participated
FROM Drivers d
JOIN Constructors c ON d.constructor_id = c.constructor_id
LEFT JOIN Results res ON d.driver_id = res.driver_id
LEFT JOIN Sessions s ON res.session_id = s.session_id AND s.session_type = 'RACE'
GROUP BY d.driver_id, d.first_name, d.last_name, c.name
ORDER BY total_points DESC;

-- View: Constructor Championship Standings
CREATE VIEW vw_constructor_standings AS
SELECT 
    c.constructor_id,
    c.name AS team_name,
    COALESCE(SUM(res.points), 0) AS total_points,
    COUNT(DISTINCT s.race_id) AS races_participated
FROM Constructors c
JOIN Drivers d ON c.constructor_id = d.constructor_id
LEFT JOIN Results res ON d.driver_id = res.driver_id
LEFT JOIN Sessions s ON res.session_id = s.session_id AND s.session_type = 'RACE'
GROUP BY c.constructor_id, c.name
ORDER BY total_points DESC;

-- =============================================
-- SAMPLE QUERIES TO RUN
-- =============================================

-- Query 1: View All Teams and Drivers
SELECT * FROM vw_driver_lineup;

-- Query 2: View Complete Race Calendar
SELECT * FROM vw_race_calendar;

-- Query 3: View Driver Championship Standings
SELECT * FROM vw_driver_standings;

-- Query 4: View Constructor Championship Standings
SELECT * FROM vw_constructor_standings;

-- Query 5: View All Race Results
SELECT * FROM vw_race_results;

-- Query 6: Sprint Race Weekends
SELECT grand_prix, race_date, circuit_name, country 
FROM vw_race_calendar 
WHERE sprint_weekend = 'Yes';

-- Query 7: Drivers by Team
SELECT team_name, COUNT(*) as driver_count, 
       STRING_AGG(driver_name, ', ') as drivers
FROM vw_driver_lineup
GROUP BY team_name
ORDER BY team_name;

-- Query 8: Longest and Shortest Circuits
SELECT name, country, track_length_km 
FROM Circuits 
ORDER BY track_length_km DESC;

-- =============================================
-- DATABASE SUMMARY
-- =============================================

-- Summary Statistics
SELECT 
    'Teams' as entity, COUNT(*) as count FROM Constructors
UNION ALL
SELECT 'Drivers', COUNT(*) FROM Drivers
UNION ALL
SELECT 'Circuits', COUNT(*) FROM Circuits
UNION ALL
SELECT 'Races', COUNT(*) FROM Races
UNION ALL
SELECT 'Sessions', COUNT(*) FROM Sessions
UNION ALL
SELECT 'Results', COUNT(*) FROM Results;

-- =============================================
-- END OF SCRIPT - Ready to Execute!
-- =============================================

-----------

-------------------------------------------------------------

-- =============================================
-- SCRIPT TO UPDATE AND ADD 2024 F1 DATA
-- =============================================

-- =============================================
-- 1. ADD MISSING DRIVER (Logan Sargeant)
-- (He raced in Bahrain but was replaced by Colapinto mid-season)
-- =============================================
INSERT INTO Drivers (first_name, last_name, driver_number, country_code, constructor_id)
VALUES ('Logan', 'Sargeant', 2, 'USA', 7)
ON CONFLICT (first_name, last_name) DO NOTHING;


-- =============================================
-- 2. CORRECT BAHRAIN GP DATA (Race 1)
-- (Your original data was incomplete and had errors)
-- =============================================

-- Delete the old, incomplete results for the Bahrain GP Race (Session ID 5)
DELETE FROM Results WHERE session_id = 5;

-- Insert the COMPLETE and CORRECTED 20-driver results for Bahrain
-- Driver IDs are mapped from your 'Drivers' table. Logan Sargeant will be ID 22.
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
(5, 1, 1, 1, 57, '1:31:44.742', 26.0), -- Verstappen (Had fastest lap)
(5, 2, 2, 5, 57, '+22.457', 18.0),     -- Pérez
(5, 6, 3, 3, 57, '+25.110', 15.0),     -- Sainz
(5, 5, 4, 2, 57, '+39.669', 12.0),     -- Leclerc
(5, 8, 5, 4, 57, '+46.788', 10.0),     -- Russell
(5, 3, 6, 8, 57, '+48.458', 8.0),      -- Norris
(5, 7, 7, 7, 57, '+50.324', 6.0),      -- Hamilton
(5, 4, 8, 9, 57, '+56.082', 4.0),      -- Piastri
(5, 9, 9, 11, 57, '+1:14.887', 2.0),   -- Alonso
(5, 10, 10, 13, 57, '+1:33.216', 1.0), -- Stroll
(5, 19, 11, 15, 56, '+1 lap', 0.0),    -- Zhou
(5, 21, 12, 12, 56, '+1 lap', 0.0),    -- Magnussen
(5, 16, 13, 14, 56, '+1 lap', 0.0),    -- Ricciardo
(5, 15, 14, 17, 56, '+1 lap', 0.0),    -- Tsunoda
(5, 13, 15, 16, 56, '+1 lap', 0.0),    -- Albon
(5, 20, 16, 10, 56, '+1 lap', 0.0),    -- Hülkenberg
(5, 12, 17, 18, 56, '+1 lap', 0.0),    -- Ocon
(5, 11, 18, 19, 56, '+1 lap', 0.0),    -- Gasly
(5, 18, 19, 20, 56, '+1 lap', 0.0),    -- Bottas
(5, 22, 20, 1, 55, '+2 laps', 0.0);   -- Sargeant (Assumes ID 22)

-- Note: This script assumes Logan Sargeant was assigned driver_id 22.
-- If he was assigned a different ID, please update the last line.
-- You can check with: SELECT driver_id, first_name, last_name FROM Drivers;


-- =============================================
-- 3. ADD JAPANESE GP SESSIONS (Race 4)
-- =============================================
INSERT INTO Sessions (race_id, session_type, session_date_time) VALUES
(4, 'FP1', '2024-04-05 11:30:00'),
(4, 'FP2', '2024-04-05 15:00:00'),
(4, 'FP3', '2024-04-06 11:30:00'),
(4, 'QUALIFYING', '2024-04-06 15:00:00'),
(4, 'RACE', '2024-04-07 14:00:00');


-- =============================================
-- 4. ADD JAPANESE GP QUALIFYING RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'QUALIFYING'), 1, 1, '1:28.197', 0.0),  -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'QUALIFYING'), 2, 2, '1:28.263', 0.0),  -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'QUALIFYING'), 3, 3, '1:28.489', 0.0),  -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'QUALIFYING'), 6, 4, '1:28.682', 0.0),  -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'QUALIFYING'), 9, 5, '1:28.686', 0.0),  -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'QUALIFYING'), 4, 6, '1:28.760', 0.0),  -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'QUALIFYING'), 7, 7, '1:28.766', 0.0),  -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'QUALIFYING'), 5, 8, '1:28.786', 0.0),  -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'QUALIFYING'), 8, 9, '1:29.008', 0.0),  -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'QUALIFYING'), 15, 10, '1:29.413', 0.0), -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'QUALIFYING'), 16, 11, '1:29.472', 0.0), -- Ricciardo
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'QUALIFYING'), 20, 12, '1:29.494', 0.0), -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'QUALIFYING'), 18, 13, '1:29.593', 0.0), -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'QUALIFYING'), 13, 14, '1:29.714', 0.0), -- Albon
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'QUALIFYING'), 12, 15, '1:29.816', 0.0), -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'QUALIFYING'), 10, 16, '1:30.024', 0.0), -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'QUALIFYING'), 11, 17, '1:30.119', 0.0), -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'QUALIFYING'), 21, 18, '1:30.131', 0.0), -- Magnussen
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'QUALIFYING'), 22, 19, '1:30.139', 0.0), -- Sargeant
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'QUALIFYING'), 19, 20, '1:30.143', 0.0); -- Zhou


-- =============================================
-- 5. ADD JAPANESE GP RACE RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'RACE'), 1, 1, 1, 53, '1:54:23.566', 26.0), -- Verstappen (Had fastest lap)
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'RACE'), 2, 2, 2, 53, '+12.535', 18.0),     -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'RACE'), 6, 3, 4, 53, '+20.866', 15.0),     -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'RACE'), 5, 4, 8, 53, '+26.522', 12.0),     -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'RACE'), 3, 5, 3, 53, '+29.700', 10.0),     -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'RACE'), 9, 6, 5, 53, '+44.272', 8.0),      -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'RACE'), 8, 7, 9, 53, '+45.951', 6.0),      -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'RACE'), 4, 8, 6, 53, '+47.525', 4.0),      -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'RACE'), 7, 9, 7, 53, '+48.626', 2.0),      -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'RACE'), 15, 10, 10, 52, '+1 lap', 1.0),    -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'RACE'), 20, 11, 12, 52, '+1 lap', 0.0),    -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'RACE'), 10, 12, 16, 52, '+1 lap', 0.0),    -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'RACE'), 21, 13, 18, 52, '+1 lap', 0.0),    -- Magnussen
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'RACE'), 18, 14, 13, 52, '+1 lap', 0.0),    -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'RACE'), 12, 15, 15, 52, '+1 lap', 0.0),    -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'RACE'), 11, 16, 17, 52, '+1 lap', 0.0),    -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'RACE'), 22, 17, 19, 52, '+1 lap', 0.0),    -- Sargeant
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'RACE'), 19, 18, 20, 12, 'Gearbox', 0.0),  -- Zhou
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'RACE'), 16, 19, 11, 0, 'Collision', 0.0),  -- Ricciardo
((SELECT session_id FROM Sessions WHERE race_id = 4 AND session_type = 'RACE'), 13, 20, 14, 0, 'Collision', 0.0);  -- Albon

-- =============================================
-- 5. ADD CHINESE GP SESSIONS (Race 5 - Sprint Weekend)
-- =============================================
INSERT INTO Sessions (race_id, session_type, session_date_time) VALUES
(5, 'FP1', '2024-04-19 11:30:00'),
(5, 'SPRINT_QUALIFYING', '2024-04-19 15:30:00'),
(5, 'SPRINT', '2024-04-20 11:00:00'),
(5, 'QUALIFYING', '2024-04-20 15:00:00'),
(5, 'RACE', '2024-04-21 15:00:00');

-- =============================================
-- 6. ADD CHINESE GP SPRINT QUALIFYING RESULTS
-- (Sets the grid for the Sprint)
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT_QUALIFYING'), 3, 1, '1:57.940', 0.0),  -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT_QUALIFYING'), 7, 2, '1:59.201', 0.0),  -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT_QUALIFYING'), 9, 3, '1:59.915', 0.0),  -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT_QUALIFYING'), 1, 4, '2:00.028', 0.0),  -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT_QUALIFYING'), 6, 5, '2:00.213', 0.0),  -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT_QUALIFYING'), 2, 6, '2:00.374', 0.0),  -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT_QUALIFYING'), 5, 7, '2:00.544', 0.0),  -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT_QUALIFYING'), 4, 8, '2:00.990', 0.0),  -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT_QUALIFYING'), 18, 9, '2:01.044', 0.0), -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT_QUALIFYING'), 19, 10, '2:03.657', 0.0), -- Zhou
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT_QUALIFYING'), 8, 11, '1:36.303', 0.0), -- Russell (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT_QUALIFYING'), 21, 12, '1:36.347', 0.0), -- Magnussen (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT_QUALIFYING'), 20, 13, '1:36.473', 0.0), -- Hülkenberg (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT_QUALIFYING'), 16, 14, '1:36.543', 0.0), -- Ricciardo (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT_QUALIFYING'), 10, 15, '1:36.650', 0.0), -- Stroll (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT_QUALIFYING'), 11, 16, '1:37.886', 0.0), -- Gasly (Out in SQ1)
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT_QUALIFYING'), 12, 17, '1:37.915', 0.0), -- Ocon (Out in SQ1)
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT_QUALIFYING'), 13, 18, '1:37.965', 0.0), -- Albon (Out in SQ1)
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT_QUALIFYING'), 15, 19, '1:38.257', 0.0), -- Tsunoda (Out in SQ1)
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT_QUALIFYING'), 22, 20, '1:38.420', 0.0); -- Sargeant (Out in SQ1)

-- =============================================
-- 7. ADD CHINESE GP SPRINT RACE RESULTS
-- (Points awarded to top 8)
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT'), 1, 1, 4, 19, '32:04.660', 8.0),  -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT'), 7, 2, 2, 19, '+13.043', 7.0),  -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT'), 2, 3, 6, 19, '+15.258', 6.0),  -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT'), 5, 4, 7, 19, '+17.486', 5.0),  -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT'), 6, 5, 5, 19, '+20.696', 4.0),  -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT'), 3, 6, 1, 19, '+22.088', 3.0),  -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT'), 4, 7, 8, 19, '+24.713', 2.0),  -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT'), 8, 8, 11, 19, '+25.696', 1.0),  -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT'), 19, 9, 10, 19, '+31.951', 0.0), -- Zhou
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT'), 21, 10, 12, 19, '+37.398', 0.0), -- Magnussen
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT'), 16, 11, 14, 19, '+37.840', 0.0), -- Ricciardo
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT'), 18, 12, 9, 19, '+38.295', 0.0), -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT'), 12, 13, 17, 19, '+39.841', 0.0), -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT'), 10, 14, 15, 19, '+40.299', 0.0), -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT'), 11, 15, 16, 19, '+40.838', 0.0), -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT'), 15, 16, 19, 19, '+41.870', 0.0), -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT'), 13, 17, 18, 19, '+42.998', 0.0), -- Albon
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT'), 22, 18, 20, 19, '+46.352', 0.0), -- Sargeant
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT'), 20, 19, 13, 19, '+49.630', 0.0), -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'SPRINT'), 9, 20, 3, 17, 'Collision damage', 0.0); -- Alonso

-- =============================================
-- 8. ADD CHINESE GP MAIN QUALIFYING RESULTS
-- (Sets the grid for the Main Race)
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'QUALIFYING'), 1, 1, '1:33.660', 0.0),  -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'QUALIFYING'), 2, 2, '1:33.982', 0.0),  -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'QUALIFYING'), 9, 3, '1:34.148', 0.0),  -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'QUALIFYING'), 3, 4, '1:34.165', 0.0),  -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'QUALIFYING'), 4, 5, '1:34.168', 0.0),  -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'QUALIFYING'), 5, 6, '1:34.289', 0.0),  -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'QUALIFYING'), 6, 7, '1:34.437', 0.0),  -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'QUALIFYING'), 8, 8, '1:34.490', 0.0),  -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'QUALIFYING'), 20, 9, '1:34.604', 0.0), -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'QUALIFYING'), 18, 10, '1:34.667', 0.0), -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'QUALIFYING'), 10, 11, '1:34.729', 0.0), -- Stroll (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'QUALIFYING'), 16, 12, '1:34.845', 0.0), -- Ricciardo (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'QUALIFYING'), 12, 13, '1:35.051', 0.0), -- Ocon (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'QUALIFYING'), 13, 14, '1:35.086', 0.0), -- Albon (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'QUALIFYING'), 11, 15, '1:35.483', 0.0), -- Gasly (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'QUALIFYING'), 19, 16, '1:35.505', 0.0), -- Zhou (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'QUALIFYING'), 21, 17, '1:35.518', 0.0), -- Magnussen (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'QUALIFYING'), 7, 18, '1:35.573', 0.0), -- Hamilton (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'QUALIFYING'), 15, 19, '1:35.579', 0.0), -- Tsunoda (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'QUALIFYING'), 22, 20, '1:35.736', 0.0); -- Sargeant (Out in Q1)

-- =============================================
-- 9. ADD CHINESE GP MAIN RACE RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'RACE'), 1, 1, 1, 56, '1:40:52.554', 25.0), -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'RACE'), 3, 2, 4, 56, '+13.773', 18.0),     -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'RACE'), 2, 3, 2, 56, '+19.160', 15.0),     -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'RACE'), 5, 4, 6, 56, '+23.623', 12.0),     -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'RACE'), 6, 5, 7, 56, '+33.983', 10.0),     -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'RACE'), 8, 6, 8, 56, '+38.724', 8.0),      -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'RACE'), 9, 7, 3, 56, '+43.414', 7.0),      -- Alonso (6 pts + 1 for fastest lap)
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'RACE'), 4, 8, 5, 56, '+56.198', 4.0),      -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'RACE'), 7, 9, 18, 56, '+57.986', 2.0),     -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'RACE'), 20, 10, 9, 56, '+1:00.476', 1.0),   -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'RACE'), 12, 11, 13, 56, '+1:04.788', 0.0),  -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'RACE'), 13, 12, 14, 56, '+1:05.511', 0.0),  -- Albon
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'RACE'), 11, 13, 15, 56, '+1:09.382', 0.0),  -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'RACE'), 19, 14, 16, 56, '+1:11.689', 0.0),  -- Zhou
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'RACE'), 10, 15, 11, 56, '+1:12.760', 0.0),  -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'RACE'), 21, 16, 17, 56, '+1:13.370', 0.0),  -- Magnussen
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'RACE'), 22, 17, 20, 56, '+1:16.182', 0.0),  -- Sargeant
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'RACE'), 18, 18, 10, 27, 'Power Unit', 0.0), -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'RACE'), 16, 19, 12, 26, 'Collision', 0.0),  -- Ricciardo
((SELECT session_id FROM Sessions WHERE race_id = 5 AND session_type = 'RACE'), 15, 20, 19, 26, 'Collision', 0.0);  -- Tsunoda

-- =============================================
-- 10. ADD MIAMI GP SESSIONS (Race 6 - Sprint Weekend)
-- =============================================
INSERT INTO Sessions (race_id, session_type, session_date_time) VALUES
(6, 'FP1', '2024-05-03 12:30:00'),
(6, 'SPRINT_QUALIFYING', '2024-05-03 16:30:00'),
(6, 'SPRINT', '2024-05-04 12:00:00'),
(6, 'QUALIFYING', '2024-05-04 16:00:00'),
(6, 'RACE', '2024-05-05 16:00:00');

-- =============================================
-- 11. ADD MIAMI GP SPRINT QUALIFYING RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT_QUALIFYING'), 1, 1, '1:27.641', 0.0),  -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT_QUALIFYING'), 5, 2, '1:27.749', 0.0),  -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT_QUALIFYING'), 2, 3, '1:27.876', 0.0),  -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT_QUALIFYING'), 16, 4, '1:28.044', 0.0), -- Ricciardo
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT_QUALIFYING'), 6, 5, '1:28.103', 0.0),  -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT_QUALIFYING'), 4, 6, '1:28.161', 0.0),  -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT_QUALIFYING'), 10, 7, '1:28.375', 0.0), -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT_QUALIFYING'), 9, 8, '1:28.419', 0.0),  -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT_QUALIFYING'), 3, 9, '1:28.472', 0.0),  -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT_QUALIFYING'), 20, 10, '1:28.476', 0.0), -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT_QUALIFYING'), 8, 11, '1:28.324', 0.0), -- Russell (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT_QUALIFYING'), 7, 12, '1:28.372', 0.0), -- Hamilton (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT_QUALIFYING'), 12, 13, '1:28.528', 0.0), -- Ocon (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT_QUALIFYING'), 21, 14, '1:28.544', 0.0), -- Magnussen (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT_QUALIFYING'), 15, 15, '1:28.620', 0.0), -- Tsunoda (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT_QUALIFYING'), 11, 16, '1:29.043', 0.0), -- Gasly (Out in SQ1)
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT_QUALIFYING'), 19, 17, '1:29.179', 0.0), -- Zhou (Out in SQ1)
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT_QUALIFYING'), 18, 18, '1:29.213', 0.0), -- Bottas (Out in SQ1)
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT_QUALIFYING'), 22, 19, '1:29.352', 0.0), -- Sargeant (Out in SQ1)
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT_QUALIFYING'), 13, 20, '1:29.509', 0.0); -- Albon (Out in SQ1)

-- =============================================
-- 12. ADD MIAMI GP SPRINT RACE RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT'), 1, 1, 1, 19, '31:31.383', 8.0),  -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT'), 5, 2, 2, 19, '+3.371', 7.0),   -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT'), 2, 3, 3, 19, '+5.095', 6.0),   -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT'), 16, 4, 4, 19, '+14.971', 5.0),  -- Ricciardo
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT'), 6, 5, 5, 19, '+15.222', 4.0),  -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT'), 4, 6, 6, 19, '+15.750', 3.0),   -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT'), 20, 7, 10, 19, '+22.054', 2.0), -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT'), 15, 8, 15, 19, '+29.816', 1.0),  -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT'), 11, 9, 16, 19, '+31.880', 0.0),  -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT'), 22, 10, 19, 19, '+34.355', 0.0), -- Sargeant
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT'), 19, 11, 17, 19, '+35.078', 0.0), -- Zhou
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT'), 8, 12, 11, 19, '+35.755', 0.0),  -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT'), 13, 13, 20, 19, '+36.086', 0.0), -- Albon
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT'), 18, 14, 18, 19, '+36.892', 0.0), -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT'), 12, 15, 13, 19, '+37.740', 0.0), -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT'), 7, 16, 12, 19, '+49.347', 0.0),  -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT'), 9, 17, 8, 19, '+59.409', 0.0),   -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT'), 21, 18, 14, 19, '+1:06.303', 0.0),-- Magnussen
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT'), 10, 19, 7, 1, 'DNF', 0.0),      -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'SPRINT'), 3, 20, 9, 0, 'DNF', 0.0);       -- Norris

-- =============================================
-- 13. ADD MIAMI GP MAIN QUALIFYING RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'QUALIFYING'), 1, 1, '1:27.241', 0.0),  -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'QUALIFYING'), 5, 2, '1:27.382', 0.0),  -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'QUALIFYING'), 6, 3, '1:27.455', 0.0),  -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'QUALIFYING'), 2, 4, '1:27.460', 0.0),  -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'QUALIFYING'), 3, 5, '1:27.597', 0.0),  -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'QUALIFYING'), 4, 6, '1:27.622', 0.0),  -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'QUALIFYING'), 8, 7, '1:27.848', 0.0),  -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'QUALIFYING'), 7, 8, '1:27.910', 0.0),  -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'QUALIFYING'), 20, 9, '1:28.107', 0.0), -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'QUALIFYING'), 15, 10, '1:28.167', 0.0), -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'QUALIFYING'), 10, 11, '1:28.222', 0.0), -- Stroll (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'QUALIFYING'), 11, 12, '1:28.232', 0.0), -- Gasly (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'QUALIFYING'), 12, 13, '1:28.324', 0.0), -- Ocon (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'QUALIFYING'), 13, 14, '1:28.375', 0.0), -- Albon (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'QUALIFYING'), 9, 15, '1:28.463', 0.0),  -- Alonso (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'QUALIFYING'), 18, 16, '1:28.617', 0.0), -- Bottas (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'QUALIFYING'), 22, 17, '1:28.706', 0.0), -- Sargeant (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'QUALIFYING'), 16, 18, '1:28.874', 0.0), -- Ricciardo (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'QUALIFYING'), 21, 19, '1:28.914', 0.0), -- Magnussen (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'QUALIFYING'), 19, 20, '1:29.020', 0.0); -- Zhou (Out in Q1)

-- =============================================
-- 14. ADD MIAMI GP MAIN RACE RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'RACE'), 3, 1, 5, 57, '1:30:49.876', 25.0), -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'RACE'), 1, 2, 1, 57, '+7.612', 18.0),     -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'RACE'), 5, 3, 2, 57, '+9.920', 15.0),     -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'RACE'), 2, 4, 4, 57, '+14.650', 12.0),     -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'RACE'), 6, 5, 3, 57, '+16.407', 10.0),     -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'RACE'), 7, 6, 8, 57, '+16.585', 8.0),      -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'RACE'), 15, 7, 10, 57, '+26.185', 6.0),     -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'RACE'), 8, 8, 7, 57, '+34.789', 4.0),      -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'RACE'), 9, 9, 15, 57, '+37.107', 2.0),     -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'RACE'), 12, 10, 13, 57, '+39.746', 1.0),     -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'RACE'), 20, 11, 9, 57, '+40.789', 0.0),     -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'RACE'), 11, 12, 12, 57, '+44.958', 0.0),     -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'RACE'), 4, 13, 6, 57, '+49.756', 1.0),      -- Piastri (1 pt for fastest lap)
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'RACE'), 19, 14, 20, 57, '+49.979', 0.0),     -- Zhou
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'RACE'), 16, 15, 18, 57, '+50.956', 0.0),     -- Ricciardo
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'RACE'), 18, 16, 16, 57, '+52.356', 0.0),     -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'RACE'), 10, 17, 11, 57, '+55.173', 0.0),     -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'RACE'), 13, 18, 14, 57, '+1:16.091', 0.0),    -- Albon
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'RACE'), 21, 19, 19, 57, '+1:24.683', 0.0),    -- Magnussen
((SELECT session_id FROM Sessions WHERE race_id = 6 AND session_type = 'RACE'), 22, 20, 17, 27, 'Collision', 0.0);  -- Sargeant

-- =============================================
-- 15. ADD EMILIA ROMAGNA GP SESSIONS (Race 7)
-- =============================================
INSERT INTO Sessions (race_id, session_type, session_date_time) VALUES
(7, 'FP1', '2024-05-17 13:30:00'),
(7, 'FP2', '2024-05-17 17:00:00'),
(7, 'FP3', '2024-05-18 12:30:00'),
(7, 'QUALIFYING', '2024-05-18 16:00:00'),
(7, 'RACE', '2024-05-19 15:00:00');

-- =============================================
-- 16. ADD EMILIA ROMAGNA GP QUALIFYING RESULTS
-- =============================================
-- Note: Piastri qualified 2nd but received a 3-place grid penalty.
-- The 'final_position' here reflects qualifying time, not the final grid.
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'QUALIFYING'), 1, 1, '1:14.746', 0.0),  -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'QUALIFYING'), 4, 2, '1:14.820', 0.0),  -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'QUALIFYING'), 3, 3, '1:14.837', 0.0),  -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'QUALIFYING'), 5, 4, '1:14.970', 0.0),  -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'QUALIFYING'), 6, 5, '1:15.233', 0.0),  -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'QUALIFYING'), 8, 6, '1:15.234', 0.0),  -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'QUALIFYING'), 15, 7, '1:15.465', 0.0), -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'QUALIFYING'), 7, 8, '1:15.504', 0.0),  -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'QUALIFYING'), 16, 9, '1:15.674', 0.0), -- Ricciardo
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'QUALIFYING'), 20, 10, '1:15.980', 0.0), -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'QUALIFYING'), 2, 11, '1:15.706', 0.0), -- Pérez (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'QUALIFYING'), 12, 12, '1:15.941', 0.0), -- Ocon (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'QUALIFYING'), 10, 13, '1:16.003', 0.0), -- Stroll (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'QUALIFYING'), 13, 14, '1:16.105', 0.0), -- Albon (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'QUALIFYING'), 11, 15, '1:16.183', 0.0), -- Gasly (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'QUALIFYING'), 18, 16, '1:16.626', 0.0), -- Bottas (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'QUALIFYING'), 19, 17, '1:16.654', 0.0), -- Zhou (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'QUALIFYING'), 21, 18, '1:16.710', 0.0), -- Magnussen (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'QUALIFYING'), 9, 19, '1:16.784', 0.0),  -- Alonso (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'QUALIFYING'), 22, 20, '1:16.969', 0.0); -- Sargeant (Out in Q1)

-- =============================================
-- 17. ADD EMILIA ROMAGNA GP MAIN RACE RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'RACE'), 1, 1, 1, 63, '1:25:25.252', 25.0), -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'RACE'), 3, 2, 2, 63, '+0.725', 18.0),     -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'RACE'), 5, 3, 3, 63, '+7.916', 15.0),     -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'RACE'), 4, 4, 5, 63, '+14.132', 12.0),     -- Piastri (Started 5th after penalty)
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'RACE'), 6, 5, 4, 63, '+22.325', 10.0),     -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'RACE'), 7, 6, 8, 63, '+30.235', 8.0),      -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'RACE'), 8, 7, 6, 63, '+37.258', 7.0),      -- Russell (6 pts + 1 for fastest lap)
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'RACE'), 2, 8, 11, 63, '+47.293', 4.0),     -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'RACE'), 10, 9, 13, 63, '+52.088', 2.0),     -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'RACE'), 15, 10, 7, 63, '+52.941', 1.0),     -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'RACE'), 20, 11, 10, 62, '+1 lap', 0.0),    -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'RACE'), 21, 12, 18, 62, '+1 lap', 0.0),    -- Magnussen
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'RACE'), 16, 13, 9, 62, '+1 lap', 0.0),     -- Ricciardo
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'RACE'), 12, 14, 12, 62, '+1 lap', 0.0),    -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'RACE'), 19, 15, 17, 62, '+1 lap', 0.0),    -- Zhou
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'RACE'), 11, 16, 15, 62, '+1 lap', 0.0),    -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'RACE'), 22, 17, 20, 62, '+1 lap', 0.0),    -- Sargeant
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'RACE'), 18, 18, 16, 62, '+1 lap', 0.0),    -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'RACE'), 9, 19, 19, 62, '+1 lap', 0.0),     -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 7 AND session_type = 'RACE'), 13, 20, 14, 51, 'Retirement', 0.0); -- Albon

-- =============================================
-- 18. ADD MONACO GP SESSIONS (Race 8)
-- =============================================
INSERT INTO Sessions (race_id, session_type, session_date_time) VALUES
(8, 'FP1', '2024-05-24 13:30:00'),
(8, 'FP2', '2024-05-24 17:00:00'),
(8, 'FP3', '2024-05-25 12:30:00'),
(8, 'QUALIFYING', '2024-05-25 16:00:00'),
(8, 'RACE', '2024-05-26 15:00:00');

-- =============================================
-- 19. ADD MONACO GP QUALIFYING RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'QUALIFYING'), 5, 1, '1:10.270', 0.0),  -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'QUALIFYING'), 4, 2, '1:10.424', 0.0),  -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'QUALIFYING'), 6, 3, '1:10.518', 0.0),  -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'QUALIFYING'), 3, 4, '1:10.542', 0.0),  -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'QUALIFYING'), 8, 5, '1:10.543', 0.0),  -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'QUALIFYING'), 1, 6, '1:10.567', 0.0),  -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'QUALIFYING'), 7, 7, '1:10.621', 0.0),  -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'QUALIFYING'), 15, 8, '1:10.858', 0.0), -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'QUALIFYING'), 13, 9, '1:10.975', 0.0), -- Albon
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'QUALIFYING'), 11, 10, '1:11.106', 0.0), -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'QUALIFYING'), 12, 11, '1:11.116', 0.0), -- Ocon (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'QUALIFYING'), 20, 12, '1:11.319', 0.0), -- Hülkenberg (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'QUALIFYING'), 16, 13, '1:11.325', 0.0), -- Ricciardo (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'QUALIFYING'), 10, 14, '1:11.489', 0.0), -- Stroll (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'QUALIFYING'), 21, 15, '1:11.492', 0.0), -- Magnussen (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'QUALIFYING'), 9, 16, '1:11.563', 0.0),  -- Alonso (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'QUALIFYING'), 22, 17, '1:11.653', 0.0), -- Sargeant (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'QUALIFYING'), 2, 18, '1:11.725', 0.0),  -- Pérez (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'QUALIFYING'), 18, 19, '1:11.832', 0.0), -- Bottas (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'QUALIFYING'), 19, 20, '1:11.976', 0.0); -- Zhou (Out in Q1)

-- =============================================
-- 20. ADD MONACO GP MAIN RACE RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'RACE'), 5, 1, 1, 78, '2:23:15.554', 25.0), -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'RACE'), 4, 2, 2, 78, '+7.152', 18.0),     -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'RACE'), 6, 3, 3, 78, '+7.585', 15.0),     -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'RACE'), 3, 4, 4, 78, '+8.650', 12.0),     -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'RACE'), 8, 5, 5, 78, '+13.309', 10.0),    -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'RACE'), 1, 6, 6, 78, '+13.853', 8.0),      -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'RACE'), 7, 7, 7, 78, '+14.908', 7.0),      -- Hamilton (6 pts + 1 for fastest lap)
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'RACE'), 15, 8, 8, 77, '+1 lap', 4.0),      -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'RACE'), 13, 9, 9, 77, '+1 lap', 2.0),      -- Albon
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'RACE'), 11, 10, 10, 77, '+1 lap', 1.0),    -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'RACE'), 9, 11, 14, 77, '+1 lap', 0.0),     -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'RACE'), 16, 12, 13, 77, '+1 lap', 0.0),    -- Ricciardo
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'RACE'), 18, 13, 17, 77, '+1 lap', 0.0),    -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'RACE'), 10, 14, 12, 77, '+1 lap', 0.0),    -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'RACE'), 22, 15, 15, 77, '+1 lap', 0.0),    -- Sargeant
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'RACE'), 19, 16, 18, 76, '+2 laps', 0.0),   -- Zhou
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'RACE'), 12, 17, 11, 0, 'Collision', 0.0),  -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'RACE'), 2, 18, 16, 0, 'Collision', 0.0),   -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'RACE'), 20, 19, 19, 0, 'Collision', 0.0),  -- Hülkenberg (Started from pits)
((SELECT session_id FROM Sessions WHERE race_id = 8 AND session_type = 'RACE'), 21, 20, 20, 0, 'Collision', 0.0);  -- Magnussen (Started from pits)

-- =============================================
-- 21. ADD CANADIAN GP SESSIONS (Race 9)
-- =============================================
INSERT INTO Sessions (race_id, session_type, session_date_time) VALUES
(9, 'FP1', '2024-06-07 13:30:00'),
(9, 'FP2', '2024-06-07 17:00:00'),
(9, 'FP3', '2024-06-08 12:30:00'),
(9, 'QUALIFYING', '2024-06-08 16:00:00'),
(9, 'RACE', '2024-06-09 14:00:00');

-- =============================================
-- 22. ADD CANADIAN GP QUALIFYING RESULTS
-- =============================================
-- Note: Russell and Verstappen set identical 1:12.000 times.
-- Russell is P1 as he set the time first.
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'QUALIFYING'), 8, 1, '1:12.000', 0.0),  -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'QUALIFYING'), 1, 2, '1:12.000', 0.0),  -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'QUALIFYING'), 3, 3, '1:12.021', 0.0),  -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'QUALIFYING'), 4, 4, '1:12.103', 0.0),  -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'QUALIFYING'), 16, 5, '1:12.178', 0.0), -- Ricciardo
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'QUALIFYING'), 9, 6, '1:12.228', 0.0),  -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'QUALIFYING'), 7, 7, '1:12.280', 0.0),  -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'QUALIFYING'), 15, 8, '1:12.414', 0.0), -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'QUALIFYING'), 10, 9, '1:12.701', 0.0), -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'QUALIFYING'), 13, 10, '1:12.796', 0.0), -- Albon
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'QUALIFYING'), 5, 11, '1:12.310', 0.0), -- Leclerc (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'QUALIFYING'), 6, 12, '1:12.313', 0.0), -- Sainz (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'QUALIFYING'), 22, 13, '1:12.579', 0.0), -- Sargeant (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'QUALIFYING'), 21, 14, '1:12.713', 0.0), -- Magnussen (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'QUALIFYING'), 11, 15, '1:12.718', 0.0), -- Gasly (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'QUALIFYING'), 2, 16, '1:13.326', 0.0),  -- Pérez (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'QUALIFYING'), 18, 17, '1:13.330', 0.0), -- Bottas (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'QUALIFYING'), 12, 18, '1:13.356', 0.0), -- Ocon (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'QUALIFYING'), 20, 19, '1:13.366', 0.0), -- Hülkenberg (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'QUALIFYING'), 19, 20, '1:13.479', 0.0); -- Zhou (Out in Q1)

-- =============================================
-- 23. ADD CANADIAN GP MAIN RACE RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'RACE'), 1, 1, 2, 70, '1:45:47.927', 25.0), -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'RACE'), 3, 2, 3, 70, '+3.879', 18.0),     -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'RACE'), 8, 3, 1, 70, '+4.317', 15.0),     -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'RACE'), 7, 4, 7, 70, '+4.915', 13.0),     -- Hamilton (12 pts + 1 for fastest lap)
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'RACE'), 4, 5, 4, 70, '+10.199', 10.0),    -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'RACE'), 9, 6, 6, 70, '+17.510', 8.0),      -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'RACE'), 10, 7, 9, 70, '+23.625', 6.0),     -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'RACE'), 16, 8, 5, 70, '+25.672', 4.0),     -- Ricciardo
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'RACE'), 11, 9, 15, 70, '+28.321', 2.0),     -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'RACE'), 12, 10, 18, 70, '+30.021', 1.0),    -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'RACE'), 20, 11, 19, 70, '+30.349', 0.0),    -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'RACE'), 21, 12, 14, 70, '+31.699', 0.0),    -- Magnussen
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'RACE'), 18, 13, 20, 70, '+40.489', 0.0),    -- Bottas (Started from pits)
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'RACE'), 15, 14, 8, 69, '+1 lap', 0.0),      -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'RACE'), 19, 15, 20, 69, '+1 lap', 0.0),    -- Zhou (Started from pits)
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'RACE'), 6, 16, 12, 54, 'Collision', 0.0),  -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'RACE'), 13, 17, 10, 54, 'Collision', 0.0),  -- Albon
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'RACE'), 2, 18, 16, 53, 'Retirement', 0.0), -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'RACE'), 5, 19, 11, 51, 'Power Unit', 0.0), -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 9 AND session_type = 'RACE'), 22, 20, 13, 25, 'Collision', 0.0);  -- Sargeant

-- =============================================
-- 24. ADD SPANISH GP SESSIONS (Race 10)
-- =============================================
INSERT INTO Sessions (race_id, session_type, session_date_time) VALUES
(10, 'FP1', '2024-06-21 13:30:00'),
(10, 'FP2', '2024-06-21 17:00:00'),
(10, 'FP3', '2024-06-22 12:30:00'),
(10, 'QUALIFYING', '2024-06-22 16:00:00'),
(10, 'RACE', '2024-06-23 15:00:00');

-- =============================================
-- 25. ADD SPANISH GP QUALIFYING RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'QUALIFYING'), 3, 1, '1:11.383', 0.0),  -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'QUALIFYING'), 1, 2, '1:11.403', 0.0),  -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'QUALIFYING'), 7, 3, '1:11.701', 0.0),  -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'QUALIFYING'), 8, 4, '1:11.703', 0.0),  -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'QUALIFYING'), 5, 5, '1:11.731', 0.0),  -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'QUALIFYING'), 6, 6, '1:11.736', 0.0),  -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'QUALIFYING'), 11, 7, '1:11.857', 0.0), -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'QUALIFYING'), 2, 8, '1:12.061', 0.0),  -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'QUALIFYING'), 12, 9, '1:12.125', 0.0), -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'QUALIFYING'), 4, 10, '0.000', 0.0),   -- Piastri (No time in Q3)
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'QUALIFYING'), 9, 11, '1:12.128', 0.0), -- Alonso (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'QUALIFYING'), 18, 12, '1:12.227', 0.0), -- Bottas (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'QUALIFYING'), 20, 13, '1:12.310', 0.0), -- Hülkenberg (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'QUALIFYING'), 10, 14, '1:12.372', 0.0), -- Stroll (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'QUALIFYING'), 19, 15, '1:12.738', 0.0), -- Zhou (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'QUALIFYING'), 21, 16, '1:12.937', 0.0), -- Magnussen (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'QUALIFYING'), 15, 17, '1:12.985', 0.0), -- Tsunoda (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'QUALIFYING'), 16, 18, '1:13.075', 0.0), -- Ricciardo (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'QUALIFYING'), 13, 19, '1:13.153', 0.0), -- Albon (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'QUALIFYING'), 22, 20, '1:13.509', 0.0); -- Sargeant (Out in Q1)

-- =============================================
-- 26. ADD SPANISH GP MAIN RACE RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'RACE'), 1, 1, 2, 66, '1:28:20.227', 25.0), -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'RACE'), 3, 2, 1, 66, '+2.219', 19.0),     -- Norris (18 pts + 1 for fastest lap)
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'RACE'), 7, 3, 3, 66, '+17.790', 15.0),    -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'RACE'), 8, 4, 4, 66, '+22.320', 12.0),    -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'RACE'), 5, 5, 5, 66, '+22.709', 10.0),    -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'RACE'), 6, 6, 6, 66, '+31.028', 8.0),      -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'RACE'), 4, 7, 10, 66, '+33.760', 6.0),     -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'RACE'), 2, 8, 11, 66, '+59.524', 4.0),     -- Pérez (Started 11th)
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'RACE'), 11, 9, 7, 66, '+1:02.025', 2.0),   -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'RACE'), 12, 10, 9, 66, '+1:11.889', 1.0),   -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'RACE'), 20, 11, 13, 66, '+1:19.215', 0.0),  -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'RACE'), 9, 12, 11, 65, '+1 lap', 0.0),     -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'RACE'), 19, 13, 15, 65, '+1 lap', 0.0),     -- Zhou
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'RACE'), 10, 14, 14, 65, '+1 lap', 0.0),     -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'RACE'), 16, 15, 18, 65, '+1 lap', 0.0),     -- Ricciardo
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'RACE'), 18, 16, 12, 65, '+1 lap', 0.0),     -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'RACE'), 21, 17, 16, 65, '+1 lap', 0.0),     -- Magnussen
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'RACE'), 13, 18, 19, 65, '+1 lap', 0.0),     -- Albon
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'RACE'), 15, 19, 17, 65, '+1 lap', 0.0),     -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 10 AND session_type = 'RACE'), 22, 20, 20, 64, '+2 laps', 0.0);    -- Sargeant (Started from pits)

-- =============================================
-- F1 2024 - Data Update Script (Races 11-15)
-- Austrian GP, British GP, Hungarian GP, Belgian GP, Dutch GP
-- =============================================


-- =============================================
-- 27. ADD AUSTRIAN GP SESSIONS (Race 11 - Sprint Weekend)
-- =============================================
INSERT INTO Sessions (race_id, session_type, session_date_time) VALUES
(11, 'FP1', '2024-06-28 12:30:00'),
(11, 'SPRINT_QUALIFYING', '2024-06-28 16:30:00'),
(11, 'SPRINT', '2024-06-29 12:00:00'),
(11, 'QUALIFYING', '2024-06-29 16:00:00'),
(11, 'RACE', '2024-06-30 15:00:00');

-- =============================================
-- 28. ADD AUSTRIAN GP SPRINT QUALIFYING RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT_QUALIFYING'), 1, 1, '1:04.686', 0.0), -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT_QUALIFYING'), 3, 2, '1:04.778', 0.0), -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT_QUALIFYING'), 4, 3, '1:04.991', 0.0), -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT_QUALIFYING'), 8, 4, '1:05.025', 0.0), -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT_QUALIFYING'), 6, 5, '1:05.122', 0.0), -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT_QUALIFYING'), 7, 6, '1:05.323', 0.0), -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT_QUALIFYING'), 12, 7, '1:05.579', 0.0), -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT_QUALIFYING'), 11, 8, '1:05.819', 0.0), -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT_QUALIFYING'), 5, 9, '1:05.908', 0.0), -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT_QUALIFYING'), 2, 10, '1:06.128', 0.0), -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT_QUALIFYING'), 10, 11, '1:05.675', 0.0), -- Stroll (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT_QUALIFYING'), 20, 12, '1:05.677', 0.0), -- Hülkenberg (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT_QUALIFYING'), 9, 13, '1:05.688', 0.0), -- Alonso (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT_QUALIFYING'), 15, 14, '1:05.792', 0.0), -- Tsunoda (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT_QUALIFYING'), 21, 15, '1:05.890', 0.0), -- Magnussen (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT_QUALIFYING'), 16, 16, '1:06.014', 0.0), -- Ricciardo (Out in SQ1)
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT_QUALIFYING'), 18, 17, '1:06.046', 0.0), -- Bottas (Out in SQ1)
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT_QUALIFYING'), 13, 18, '1:06.208', 0.0), -- Albon (Out in SQ1)
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT_QUALIFYING'), 19, 19, '1:06.568', 0.0), -- Zhou (Out in SQ1)
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT_QUALIFYING'), 22, 20, '1:06.643', 0.0); -- Sargeant (Out in SQ1)

-- =============================================
-- 29. ADD AUSTRIAN GP SPRINT RACE RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT'), 1, 1, 1, 23, '30:08.681', 8.0), -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT'), 4, 2, 3, 23, '+4.616', 7.0),  -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT'), 3, 3, 2, 23, '+5.348', 6.0),  -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT'), 8, 4, 4, 23, '+8.354', 5.0),  -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT'), 6, 5, 5, 23, '+9.904', 4.0),  -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT'), 7, 6, 6, 23, '+11.839', 3.0), -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT'), 5, 7, 9, 23, '+18.174', 2.0), -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT'), 2, 8, 10, 23, '+18.985', 1.0), -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT'), 12, 9, 7, 23, '+20.710', 0.0), -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT'), 11, 10, 8, 23, '+23.951', 0.0), -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT'), 16, 11, 16, 23, '+27.697', 0.0), -- Ricciardo
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT'), 21, 12, 15, 23, '+31.439', 0.0), -- Magnussen
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT'), 10, 13, 11, 23, '+31.879', 0.0), -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT'), 9, 14, 13, 23, '+32.454', 0.0),  -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT'), 15, 15, 14, 23, '+32.876', 0.0), -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT'), 20, 16, 12, 23, '+33.454', 0.0), -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT'), 13, 17, 18, 23, '+37.034', 0.0), -- Albon
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT'), 22, 18, 20, 23, '+37.568', 0.0), -- Sargeant
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT'), 19, 19, 19, 23, '+38.932', 0.0), -- Zhou
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'SPRINT'), 18, 20, 17, 23, '+39.461', 0.0); -- Bottas

-- =============================================
-- 30. ADD AUSTRIAN GP MAIN QUALIFYING RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'QUALIFYING'), 1, 1, '1:04.314', 0.0),  -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'QUALIFYING'), 3, 2, '1:04.718', 0.0),  -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'QUALIFYING'), 8, 3, '1:04.840', 0.0),  -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'QUALIFYING'), 6, 4, '1:04.851', 0.0),  -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'QUALIFYING'), 7, 5, '1:04.903', 0.0),  -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'QUALIFYING'), 5, 6, '1:05.106', 0.0),  -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'QUALIFYING'), 4, 7, '1:05.120', 0.0),  -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'QUALIFYING'), 2, 8, '1:05.127', 0.0),  -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'QUALIFYING'), 20, 9, '1:05.378', 0.0), -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'QUALIFYING'), 12, 10, '1:05.748', 0.0), -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'QUALIFYING'), 16, 11, '1:05.474', 0.0), -- Ricciardo (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'QUALIFYING'), 21, 12, '1:05.518', 0.0), -- Magnussen (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'QUALIFYING'), 11, 13, '1:05.589', 0.0), -- Gasly (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'QUALIFYING'), 15, 14, '1:05.614', 0.0), -- Tsunoda (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'QUALIFYING'), 9, 15, '1:05.656', 0.0),  -- Alonso (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'QUALIFYING'), 13, 16, '1:06.027', 0.0), -- Albon (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'QUALIFYING'), 10, 17, '1:06.059', 0.0), -- Stroll (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'QUALIFYING'), 18, 18, '1:06.071', 0.0), -- Bottas (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'QUALIFYING'), 22, 19, '1:06.082', 0.0), -- Sargeant (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'QUALIFYING'), 19, 20, '1:06.568', 0.0); -- Zhou (Out in Q1)

-- =============================================
-- 31. ADD AUSTRIAN GP MAIN RACE RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'RACE'), 8, 1, 3, 71, '1:24:22.798', 25.0), -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'RACE'), 4, 2, 7, 71, '+1.906', 18.0),     -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'RACE'), 6, 3, 4, 71, '+4.533', 15.0),     -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'RACE'), 7, 4, 5, 71, '+23.142', 12.0),    -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'RACE'), 1, 5, 1, 71, '+37.253', 10.0),    -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'RACE'), 20, 6, 9, 71, '+49.886', 8.0),     -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'RACE'), 2, 7, 8, 71, '+54.672', 6.0),     -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'RACE'), 21, 8, 12, 71, '+1:00.355', 4.0),   -- Magnussen
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'RACE'), 16, 9, 11, 71, '+1:01.169', 2.0),   -- Ricciardo
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'RACE'), 11, 10, 13, 71, '+1:01.766', 1.0), -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'RACE'), 5, 11, 6, 71, '+1:02.325', 0.0),    -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'RACE'), 12, 12, 10, 71, '+1:03.951', 0.0),  -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'RACE'), 10, 13, 17, 70, '+1 lap', 0.0),     -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'RACE'), 15, 14, 14, 70, '+1 lap', 0.0),     -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'RACE'), 13, 15, 16, 70, '+1 lap', 0.0),     -- Albon
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'RACE'), 18, 16, 18, 70, '+1 lap', 0.0),     -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'RACE'), 22, 17, 19, 70, '+1 lap', 0.0),     -- Sargeant
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'RACE'), 9, 18, 15, 70, '+1 lap', 1.0),      -- Alonso (1 pt for fastest lap)
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'RACE'), 19, 19, 20, 69, '+2 laps', 0.0),    -- Zhou
((SELECT session_id FROM Sessions WHERE race_id = 11 AND session_type = 'RACE'), 3, 20, 2, 61, 'Collision damage', 0.0); -- Norris

-- =============================================
-- 32. ADD BRITISH GP SESSIONS (Race 12)
-- =============================================
INSERT INTO Sessions (race_id, session_type, session_date_time) VALUES
(12, 'FP1', '2024-07-05 12:30:00'),
(12, 'FP2', '2024-07-05 16:00:00'),
(12, 'FP3', '2024-07-06 11:30:00'),
(12, 'QUALIFYING', '2024-07-06 15:00:00'),
(12, 'RACE', '2024-07-07 15:00:00');

-- =============================================
-- 33. ADD BRITISH GP QUALIFYING RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'QUALIFYING'), 8, 1, '1:25.819', 0.0),  -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'QUALIFYING'), 7, 2, '1:25.990', 0.0),  -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'QUALIFYING'), 3, 3, '1:26.030', 0.0),  -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'QUALIFYING'), 1, 4, '1:26.203', 0.0),  -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'QUALIFYING'), 4, 5, '1:26.237', 0.0),  -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'QUALIFYING'), 20, 6, '1:26.338', 0.0), -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'QUALIFYING'), 6, 7, '1:26.585', 0.0),  -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'QUALIFYING'), 10, 8, '1:26.657', 0.0), -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'QUALIFYING'), 13, 9, '1:26.772', 0.0), -- Albon
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'QUALIFYING'), 9, 10, '1:26.788', 0.0), -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'QUALIFYING'), 5, 11, '1:26.772', 0.0), -- Leclerc (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'QUALIFYING'), 22, 12, '1:26.877', 0.0), -- Sargeant (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'QUALIFYING'), 15, 13, '1:26.904', 0.0), -- Tsunoda (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'QUALIFYING'), 19, 14, '1:27.099', 0.0), -- Zhou (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'QUALIFYING'), 16, 15, '1:27.147', 0.0), -- Ricciardo (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'QUALIFYING'), 18, 16, '1:30.513', 0.0), -- Bottas (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'QUALIFYING'), 21, 17, '1:30.519', 0.0), -- Magnussen (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'QUALIFYING'), 12, 18, '1:30.566', 0.0), -- Ocon (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'QUALIFYING'), 2, 19, '1:30.583', 0.0),  -- Pérez (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'QUALIFYING'), 11, 20, '1:30.938', 0.0); -- Gasly (Out in Q1)

-- =============================================
-- 34. ADD BRITISH GP MAIN RACE RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'RACE'), 7, 1, 2, 52, '1:22:27.059', 25.0), -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'RACE'), 1, 2, 4, 52, '+1.465', 18.0),     -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'RACE'), 3, 3, 3, 52, '+7.547', 15.0),     -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'RACE'), 4, 4, 5, 52, '+15.088', 12.0),    -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'RACE'), 6, 5, 7, 52, '+15.779', 11.0),    -- Sainz (10 pts + 1 for fastest lap)
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'RACE'), 20, 6, 6, 52, '+39.456', 8.0),     -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'RACE'), 10, 7, 8, 52, '+43.705', 6.0),     -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'RACE'), 9, 8, 10, 52, '+45.749', 4.0),     -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'RACE'), 13, 9, 9, 52, '+46.507', 2.0),     -- Albon
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'RACE'), 15, 10, 13, 52, '+55.722', 1.0),    -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'RACE'), 22, 11, 12, 52, '+57.303', 0.0),    -- Sargeant
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'RACE'), 21, 12, 17, 52, '+1:00.083', 0.0),   -- Magnussen
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'RACE'), 16, 13, 15, 52, '+1:02.576', 0.0),   -- Ricciardo
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'RACE'), 5, 14, 11, 51, '+1 lap', 0.0),     -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'RACE'), 18, 15, 16, 51, '+1 lap', 0.0),     -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'RACE'), 12, 16, 18, 50, '+2 laps', 0.0),   -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'RACE'), 2, 17, 19, 50, '+2 laps', 0.0),    -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'RACE'), 19, 18, 14, 49, '+3 laps', 0.0),    -- Zhou
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'RACE'), 8, 19, 1, 35, 'Water system', 0.0),-- Russell
((SELECT session_id FROM Sessions WHERE race_id = 12 AND session_type = 'RACE'), 11, 20, 20, 0, 'Collision', 0.0);   -- Gasly

-- =============================================
-- 35. ADD HUNGARIAN GP SESSIONS (Race 13)
-- =============================================
INSERT INTO Sessions (race_id, session_type, session_date_time) VALUES
(13, 'FP1', '2024-07-19 13:30:00'),
(13, 'FP2', '2024-07-19 17:00:00'),
(13, 'FP3', '2024-07-20 12:30:00'),
(13, 'QUALIFYING', '2024-07-20 16:00:00'),
(13, 'RACE', '2024-07-21 15:00:00');

-- =============================================
-- 36. ADD HUNGARIAN GP QUALIFYING RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'QUALIFYING'), 3, 1, '1:15.227', 0.0),  -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'QUALIFYING'), 4, 2, '1:15.227', 0.0),  -- Piastri (Identical time, Norris pole as set first)
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'QUALIFYING'), 1, 3, '1:15.328', 0.0),  -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'QUALIFYING'), 6, 4, '1:15.698', 0.0),  -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'QUALIFYING'), 7, 5, '1:15.772', 0.0),  -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'QUALIFYING'), 5, 6, '1:15.781', 0.0),  -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'QUALIFYING'), 9, 7, '1:16.075', 0.0),  -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'QUALIFYING'), 10, 8, '1:16.142', 0.0), -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'QUALIFYING'), 16, 9, '1:16.307', 0.0), -- Ricciardo
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'QUALIFYING'), 8, 10, '1:16.436', 0.0), -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'QUALIFYING'), 20, 11, '1:16.431', 0.0), -- Hülkenberg (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'QUALIFYING'), 18, 12, '1:16.481', 0.0), -- Bottas (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'QUALIFYING'), 13, 13, '1:16.516', 0.0), -- Albon (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'QUALIFYING'), 22, 14, '1:16.551', 0.0), -- Sargeant (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'QUALIFYING'), 21, 15, '1:16.565', 0.0), -- Magnussen (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'QUALIFYING'), 2, 16, '1:16.896', 0.0),  -- Pérez (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'QUALIFYING'), 11, 17, '1:16.901', 0.0), -- Gasly (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'QUALIFYING'), 19, 18, '1:16.923', 0.0), -- Zhou (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'QUALIFYING'), 12, 19, '1:16.994', 0.0), -- Ocon (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'QUALIFYING'), 15, 20, '1:17.087', 0.0); -- Tsunoda (Out in Q1)

-- =============================================
-- 37. ADD HUNGARIAN GP MAIN RACE RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'RACE'), 4, 1, 2, 70, '1:38:01.989', 25.0), -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'RACE'), 3, 2, 1, 70, '+2.141', 18.0),     -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'RACE'), 7, 3, 5, 70, '+14.880', 15.0),    -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'RACE'), 5, 4, 6, 70, '+19.686', 12.0),    -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'RACE'), 1, 5, 3, 70, '+23.493', 10.0),    -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'RACE'), 6, 6, 4, 70, '+34.172', 8.0),      -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'RACE'), 2, 7, 16, 70, '+35.762', 6.0),     -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'RACE'), 8, 8, 10, 70, '+42.508', 5.0),    -- Russell (4 pts + 1 for fastest lap)
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'RACE'), 15, 9, 20, 70, '+1:03.493', 2.0),   -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'RACE'), 10, 10, 8, 70, '+1:04.225', 1.0),   -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'RACE'), 9, 11, 7, 70, '+1:05.176', 0.0),    -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'RACE'), 16, 12, 9, 69, '+1 lap', 0.0),     -- Ricciardo
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'RACE'), 20, 13, 11, 69, '+1 lap', 0.0),    -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'RACE'), 13, 14, 13, 69, '+1 lap', 0.0),    -- Albon
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'RACE'), 21, 15, 15, 69, '+1 lap', 0.0),    -- Magnussen
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'RACE'), 18, 16, 12, 69, '+1 lap', 0.0),    -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'RACE'), 22, 17, 14, 69, '+1 lap', 0.0),    -- Sargeant
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'RACE'), 12, 18, 19, 69, '+1 lap', 0.0),    -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'RACE'), 19, 19, 18, 69, '+1 lap', 0.0),    -- Zhou
((SELECT session_id FROM Sessions WHERE race_id = 13 AND session_type = 'RACE'), 11, 20, 17, 37, 'Hydraulics', 0.0); -- Gasly

-- =============================================
-- 38. ADD BELGIAN GP SESSIONS (Race 14)
-- =============================================
INSERT INTO Sessions (race_id, session_type, session_date_time) VALUES
(14, 'FP1', '2024-07-26 13:30:00'),
(14, 'FP2', '2024-07-26 17:00:00'),
(14, 'FP3', '2024-07-27 12:30:00'),
(14, 'QUALIFYING', '2024-07-27 16:00:00'),
(14, 'RACE', '2024-07-28 15:00:00');

-- =============================================
-- 39. ADD BELGIAN GP QUALIFYING RESULTS
-- =============================================
-- Note: Verstappen qualified 1st but had a 10-place grid penalty.
-- Leclerc pole position, final_position reflects qual time.
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'QUALIFYING'), 1, 1, '1:53.159', 0.0),  -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'QUALIFYING'), 5, 2, '1:53.754', 0.0),  -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'QUALIFYING'), 2, 3, '1:53.765', 0.0),  -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'QUALIFYING'), 7, 4, '1:53.835', 0.0),  -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'QUALIFYING'), 3, 5, '1:53.945', 0.0),  -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'QUALIFYING'), 4, 6, '1:53.951', 0.0),  -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'QUALIFYING'), 8, 7, '1:54.027', 0.0),  -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'QUALIFYING'), 6, 8, '1:54.276', 0.0),  -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'QUALIFYING'), 9, 9, '1:54.918', 0.0),  -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'QUALIFYING'), 12, 10, '1:57.789', 0.0), -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'QUALIFYING'), 13, 11, '1:55.369', 0.0), -- Albon (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'QUALIFYING'), 11, 12, '1:55.740', 0.0), -- Gasly (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'QUALIFYING'), 16, 13, '1:56.223', 0.0), -- Ricciardo (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'QUALIFYING'), 18, 14, '1:56.401', 0.0), -- Bottas (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'QUALIFYING'), 10, 15, '1:57.730', 0.0), -- Stroll (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'QUALIFYING'), 21, 16, '2:00.024', 0.0), -- Magnussen (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'QUALIFYING'), 15, 17, '2:00.654', 0.0), -- Tsunoda (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'QUALIFYING'), 22, 18, '2:01.071', 0.0), -- Sargeant (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'QUALIFYING'), 20, 19, '2:02.181', 0.0), -- Hülkenberg (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'QUALIFYING'), 19, 20, '2:04.423', 0.0); -- Zhou (Out in Q1)

-- =============================================
-- 40. ADD BELGIAN GP MAIN RACE RESULTS
-- =============================================
-- Note: Russell finished 1st but was disqualified (DSQ) for underweight car.
-- Hamilton is the winner. Grid positions reflect penalties (Verstappen started 11th).
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'RACE'), 7, 1, 3, 44, '1:19:57.566', 25.0), -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'RACE'), 4, 2, 5, 44, '+0.647', 18.0),     -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'RACE'), 5, 3, 1, 44, '+8.023', 15.0),     -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'RACE'), 1, 4, 11, 44, '+8.600', 12.0),    -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'RACE'), 3, 5, 4, 44, '+16.516', 10.0),    -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'RACE'), 6, 6, 7, 44, '+18.156', 8.0),      -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'RACE'), 2, 7, 2, 44, '+19.340', 7.0),      -- Pérez (6 pts + 1 for fastest lap)
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'RACE'), 9, 8, 8, 44, '+38.970', 4.0),      -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'RACE'), 12, 9, 9, 44, '+1:07.412', 2.0),    -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'RACE'), 16, 10, 13, 44, '+1:08.016', 1.0),   -- Ricciardo
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'RACE'), 10, 11, 15, 44, '+1:09.326', 0.0),   -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'RACE'), 13, 12, 10, 44, '+1:10.511', 0.0),   -- Albon
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'RACE'), 21, 13, 16, 44, '+1:15.836', 0.0),   -- Magnussen
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'RACE'), 11, 14, 12, 44, '+1:16.837', 0.0),   -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'RACE'), 18, 15, 14, 44, '+1:17.436', 0.0),   -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'RACE'), 15, 16, 17, 44, '+1:18.910', 0.0),   -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'RACE'), 22, 17, 18, 44, '+1:21.005', 0.0),   -- Sargeant
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'RACE'), 20, 18, 19, 44, '+1:23.708', 0.0),   -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'RACE'), 19, 19, 20, 18, 'Hydraulics', 0.0), -- Zhou
((SELECT session_id FROM Sessions WHERE race_id = 14 AND session_type = 'RACE'), 8, 20, 6, 44, 'DSQ', 0.0);       -- Russell (Disqualified)

-- =============================================
-- 41. ADD DUTCH GP SESSIONS (Race 15)
-- =============================================
INSERT INTO Sessions (race_id, session_type, session_date_time) VALUES
(15, 'FP1', '2024-08-23 12:30:00'),
(15, 'FP2', '2024-08-23 16:00:00'),
(15, 'FP3', '2024-08-24 11:30:00'),
(15, 'QUALIFYING', '2024-08-24 15:00:00'),
(15, 'RACE', '2024-08-25 15:00:00');

-- =============================================
-- 42. ADD DUTCH GP QUALIFYING RESULTS
-- =============================================
-- Note: Albon qualified 8th but was disqualified (DSQ) post-qualifying.
-- Hamilton had a 3-place grid penalty for impeding Perez.
-- Magnussen started from pit lane due to PU change.
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'QUALIFYING'), 3, 1, '1:09.673', 0.0),  -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'QUALIFYING'), 1, 2, '1:10.029', 0.0),  -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'QUALIFYING'), 4, 3, '1:10.172', 0.0),  -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'QUALIFYING'), 8, 4, '1:10.244', 0.0),  -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'QUALIFYING'), 2, 5, '1:10.416', 0.0),  -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'QUALIFYING'), 5, 6, '1:10.582', 0.0),  -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'QUALIFYING'), 9, 7, '1:10.633', 0.0),  -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'QUALIFYING'), 10, 8, '1:10.857', 0.0), -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'QUALIFYING'), 11, 9, '1:10.977', 0.0), -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'QUALIFYING'), 6, 10, '1:10.914', 0.0), -- Sainz (No time in Q3)
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'QUALIFYING'), 15, 11, '1:10.955', 0.0), -- Tsunoda (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'QUALIFYING'), 20, 12, '1:11.215', 0.0), -- Hülkenberg (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'QUALIFYING'), 21, 13, '1:11.295', 0.0), -- Magnussen (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'QUALIFYING'), 16, 14, '1:11.943', 0.0), -- Ricciardo (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'QUALIFYING'), 12, 15, '1:11.995', 0.0), -- Ocon (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'QUALIFYING'), 7, 16, '1:10.948', 0.0),  -- Hamilton (Out in Q1 - had penalty)
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'QUALIFYING'), 18, 17, '1:12.168', 0.0), -- Bottas (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'QUALIFYING'), 19, 18, '1:13.261', 0.0), -- Zhou (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'QUALIFYING'), 22, 19, '0.000', 0.0),   -- Sargeant (No time in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'QUALIFYING'), 13, 20, '1:10.653', 0.0);  -- Albon (DSQ from Q3)

-- =============================================
-- 43. ADD DUTCH GP MAIN RACE RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'RACE'), 3, 1, 1, 72, '1:30:45.519', 26.0), -- Norris (25 pts + 1 for fastest lap)
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'RACE'), 1, 2, 2, 72, '+22.896', 18.0),    -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'RACE'), 5, 3, 6, 72, '+25.439', 15.0),    -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'RACE'), 4, 4, 3, 72, '+27.337', 12.0),    -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'RACE'), 6, 5, 10, 72, '+32.137', 10.0),   -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'RACE'), 2, 6, 5, 72, '+39.542', 8.0),     -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'RACE'), 8, 7, 4, 72, '+44.617', 6.0),     -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'RACE'), 7, 8, 14, 72, '+48.727', 4.0),     -- Hamilton (Started 14th)
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'RACE'), 11, 9, 9, 72, '+55.006', 2.0),     -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'RACE'), 9, 10, 7, 72, '+55.358', 1.0),    -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'RACE'), 20, 11, 12, 72, '+57.778', 0.0),   -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'RACE'), 16, 12, 13, 72, '+1:00.612', 0.0),  -- Ricciardo
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'RACE'), 10, 13, 8, 72, '+1:01.831', 0.0),   -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'RACE'), 13, 14, 19, 72, '+1:02.167', 0.0),  -- Albon (Started 19th)
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'RACE'), 12, 15, 15, 71, '+1 lap', 0.0),    -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'RACE'), 22, 16, 18, 71, '+1 lap', 0.0),    -- Sargeant (Started 18th)
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'RACE'), 15, 17, 11, 71, '+1 lap', 0.0),    -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'RACE'), 21, 18, 20, 71, '+1 lap', 0.0),    -- Magnussen (Started Pits)
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'RACE'), 18, 19, 16, 71, '+1 lap', 0.0),    -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 15 AND session_type = 'RACE'), 19, 20, 17, 71, '+1 lap', 0.0);    -- Zhou

-- =============================================
-- ADD MISSING DRIVER (Ollie Bearman) - OLDER POSTGRESQL VERSION
-- Drove for Haas in Azerbaijan (Race 17)
-- =============================================
INSERT INTO Drivers (first_name, last_name, driver_number, country_code, constructor_id)
SELECT 'Oliver', 'Bearman', 50, 'GBR', 10 -- Assigning Haas (10) as constructor
WHERE NOT EXISTS (
    SELECT 1 FROM Drivers WHERE (first_name = 'Oliver' AND last_name = 'Bearman') OR driver_number = 50
);

-- Note: Driver number 50 is used when he drives for Haas.
-- After running this, check Bearman's assigned driver_id:
-- SELECT driver_id, first_name, last_name FROM Drivers WHERE last_name = 'Bearman';
-- Then, go to the script for Races 16-24, find the Azerbaijan GP Results (Race 17),
-- and make sure the driver_id used for Bearman (currently 23) matches the ID he was actually assigned.
-- Update it if necessary.

-- =============================================
-- ADD MISSING DRIVER (Jack Doohan) - OLDER POSTGRESQL VERSION
-- Drove for Alpine in Abu Dhabi (Race 24)
-- =============================================
INSERT INTO Drivers (first_name, last_name, driver_number, country_code, constructor_id)
SELECT 'Jack', 'Doohan', 61, 'AUS', 6 -- Assigning Alpine (6) as constructor
WHERE NOT EXISTS (
    SELECT 1 FROM Drivers WHERE (first_name = 'Jack' AND last_name = 'Doohan') OR driver_number = 61
);

-- Note: After running this, check Doohan's assigned driver_id:
-- SELECT driver_id, first_name, last_name FROM Drivers WHERE last_name = 'Doohan';
-- Then, go to the script for Races 16-24, find the Abu Dhabi GP Results (Race 24),
-- and make sure the driver_id used for Doohan (currently 24) matches the ID he was actually assigned.
-- Update it if necessary.

-- =============================================
-- F1 2024 - Data Update Script (Races 16-24)
-- =============================================


-- =============================================
-- 44. ADD ITALIAN GP SESSIONS (Race 16)
-- =============================================
INSERT INTO Sessions (race_id, session_type, session_date_time) VALUES
(16, 'FP1', '2024-08-30 13:30:00'),
(16, 'FP2', '2024-08-30 17:00:00'),
(16, 'FP3', '2024-08-31 12:30:00'),
(16, 'QUALIFYING', '2024-08-31 16:00:00'),
(16, 'RACE', '2024-09-01 15:00:00');

-- =============================================
-- 45. ADD ITALIAN GP QUALIFYING RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'QUALIFYING'), 3, 1, '1:19.327', 0.0), -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'QUALIFYING'), 4, 2, '1:19.461', 0.0), -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'QUALIFYING'), 8, 3, '1:19.608', 0.0), -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'QUALIFYING'), 5, 4, '1:19.638', 0.0), -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'QUALIFYING'), 6, 5, '1:19.727', 0.0), -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'QUALIFYING'), 7, 6, '1:19.907', 0.0), -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'QUALIFYING'), 1, 7, '1:19.967', 0.0), -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'QUALIFYING'), 2, 8, '1:20.192', 0.0), -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'QUALIFYING'), 13, 9, '1:20.395', 0.0), -- Albon
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'QUALIFYING'), 20, 10, '1:20.529', 0.0),-- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'QUALIFYING'), 9, 11, '1:20.479', 0.0), -- Alonso (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'QUALIFYING'), 15, 12, '1:20.596', 0.0), -- Tsunoda (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'QUALIFYING'), 10, 13, '1:20.640', 0.0), -- Stroll (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'QUALIFYING'), 14, 14, '1:20.697', 0.0), -- Colapinto (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'QUALIFYING'), 16, 15, '1:20.736', 0.0), -- Ricciardo (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'QUALIFYING'), 12, 16, '1:21.013', 0.0), -- Ocon (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'QUALIFYING'), 11, 17, '1:21.041', 0.0), -- Gasly (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'QUALIFYING'), 18, 18, '1:21.043', 0.0), -- Bottas (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'QUALIFYING'), 21, 19, '1:21.085', 0.0), -- Magnussen (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'QUALIFYING'), 19, 20, '1:21.435', 0.0); -- Zhou (Out in Q1)

-- =============================================
-- 46. ADD ITALIAN GP MAIN RACE RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'RACE'), 5, 1, 4, 53, '1:14:40.727', 25.0), -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'RACE'), 4, 2, 2, 53, '+2.664', 18.0),     -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'RACE'), 3, 3, 1, 53, '+6.153', 16.0),     -- Norris (15 pts + 1 for fastest lap)
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'RACE'), 6, 4, 5, 53, '+10.623', 12.0),    -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'RACE'), 7, 5, 6, 53, '+30.635', 10.0),    -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'RACE'), 1, 6, 7, 53, '+31.264', 8.0),     -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'RACE'), 8, 7, 3, 53, '+43.904', 6.0),     -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'RACE'), 13, 8, 9, 53, '+48.983', 4.0),     -- Albon
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'RACE'), 2, 9, 8, 53, '+55.623', 2.0),     -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'RACE'), 21, 10, 19, 53, '+1:02.169', 1.0),   -- Magnussen
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'RACE'), 11, 11, 17, 53, '+1:03.130', 0.0),  -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'RACE'), 14, 12, 14, 53, '+1:04.328', 0.0),  -- Colapinto
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'RACE'), 20, 13, 10, 53, '+1:05.179', 0.0),  -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'RACE'), 12, 14, 16, 53, '+1:07.456', 0.0),  -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'RACE'), 10, 15, 13, 53, '+1:08.741', 0.0),  -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'RACE'), 18, 16, 18, 53, '+1:09.431', 0.0),  -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'RACE'), 9, 17, 11, 53, '+1:15.540', 0.0),   -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'RACE'), 16, 18, 15, 53, '+1:24.499', 0.0),   -- Ricciardo
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'RACE'), 19, 19, 20, 53, '+1:31.752', 0.0),   -- Zhou
((SELECT session_id FROM Sessions WHERE race_id = 16 AND session_type = 'RACE'), 15, 20, 12, 49, 'Engine', 0.0);       -- Tsunoda


-- =============================================
-- 47. ADD AZERBAIJAN GP SESSIONS (Race 17)
-- =============================================
INSERT INTO Sessions (race_id, session_type, session_date_time) VALUES
(17, 'FP1', '2024-09-13 13:30:00'),
(17, 'FP2', '2024-09-13 17:00:00'),
(17, 'FP3', '2024-09-14 12:30:00'),
(17, 'QUALIFYING', '2024-09-14 16:00:00'),
(17, 'RACE', '2024-09-15 15:00:00');

-- =============================================
-- 48. ADD AZERBAIJAN GP QUALIFYING RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'QUALIFYING'), 5, 1, '1:41.390', 0.0), -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'QUALIFYING'), 4, 2, '1:41.631', 0.0), -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'QUALIFYING'), 6, 3, '1:41.771', 0.0), -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'QUALIFYING'), 2, 4, '1:41.971', 0.0), -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'QUALIFYING'), 8, 5, '1:41.984', 0.0), -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'QUALIFYING'), 3, 6, '1:42.046', 0.0), -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'QUALIFYING'), 13, 7, '1:42.185', 0.0), -- Albon
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'QUALIFYING'), 9, 8, '1:42.274', 0.0), -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'QUALIFYING'), 10, 9, '1:42.405', 0.0), -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'QUALIFYING'), 20, 10, '1:42.607', 0.0),-- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'QUALIFYING'), 14, 11, '1:42.508', 0.0), -- Colapinto (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'QUALIFYING'), 15, 12, '1:42.548', 0.0), -- Tsunoda (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'QUALIFYING'), 18, 13, '1:42.706', 0.0), -- Bottas (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'QUALIFYING'), 16, 14, '1:42.748', 0.0), -- Ricciardo (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'QUALIFYING'), 19, 15, '1:43.088', 0.0), -- Zhou (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'QUALIFYING'), 11, 16, '1:43.030', 0.0), -- Gasly (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'QUALIFYING'), 1, 17, '1:43.036', 0.0), -- Verstappen (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'QUALIFYING'), 7, 18, '1:43.040', 0.0), -- Hamilton (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'QUALIFYING'), 12, 19, '1:43.178', 0.0), -- Ocon (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'QUALIFYING'), 17, 20, '1:43.472', 0.0); -- Lawson (Out in Q1)

-- =============================================
-- 49. ADD AZERBAIJAN GP MAIN RACE RESULTS
-- =============================================
-- Note: Kevin Magnussen was banned for this race. Ollie Bearman drove for Haas.
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'RACE'), 4, 1, 2, 51, '1:32:58.007', 25.0), -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'RACE'), 5, 2, 1, 51, '+10.910', 18.0),    -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'RACE'), 8, 3, 5, 51, '+31.328', 15.0),    -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'RACE'), 3, 4, 6, 51, '+39.142', 12.0),    -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'RACE'), 1, 5, 17, 51, '+1:03.325', 10.0),   -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'RACE'), 9, 6, 8, 51, '+1:04.824', 8.0),     -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'RACE'), 13, 7, 7, 51, '+1:11.176', 6.0),    -- Albon
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'RACE'), 14, 8, 11, 51, '+1:14.368', 4.0),    -- Colapinto
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'RACE'), 7, 9, 18, 51, '+1:14.903', 2.0),    -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'RACE'), 23, 10, 21, 51, '+1:17.398', 1.0),   -- Bearman (Replacing Magnussen)
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'RACE'), 20, 11, 10, 51, '+1:17.970', 0.0),  -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'RACE'), 11, 12, 16, 51, '+1:20.769', 0.0),  -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'RACE'), 16, 13, 14, 51, '+1:23.018', 0.0),  -- Ricciardo
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'RACE'), 15, 14, 12, 51, '+1:23.791', 0.0),  -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'RACE'), 6, 15, 3, 51, '+1:24.883', 0.0),   -- Sainz (Spun on final lap)
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'RACE'), 18, 16, 13, 51, '+1:29.468', 0.0),  -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'RACE'), 12, 17, 19, 51, '+1:32.401', 0.0),  -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'RACE'), 10, 18, 9, 51, '+1:48.741', 0.0),   -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'RACE'), 19, 19, 15, 50, '+1 lap', 0.0),     -- Zhou
((SELECT session_id FROM Sessions WHERE race_id = 17 AND session_type = 'RACE'), 2, 20, 4, 1, 'Collision damage', 0.0); -- Pérez (Out after Lap 1 incident)


-- =============================================
-- 50. ADD SINGAPORE GP SESSIONS (Race 18)
-- =============================================
INSERT INTO Sessions (race_id, session_type, session_date_time) VALUES
(18, 'FP1', '2024-09-20 17:30:00'),
(18, 'FP2', '2024-09-20 21:00:00'),
(18, 'FP3', '2024-09-21 17:30:00'),
(18, 'QUALIFYING', '2024-09-21 21:00:00'),
(18, 'RACE', '2024-09-22 20:00:00');

-- =============================================
-- 51. ADD SINGAPORE GP QUALIFYING RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'QUALIFYING'), 3, 1, '1:29.525', 0.0), -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'QUALIFYING'), 1, 2, '1:29.728', 0.0), -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'QUALIFYING'), 7, 3, '1:30.125', 0.0), -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'QUALIFYING'), 8, 4, '1:30.221', 0.0), -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'QUALIFYING'), 4, 5, '1:30.316', 0.0), -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'QUALIFYING'), 20, 6, '1:30.472', 0.0), -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'QUALIFYING'), 9, 7, '1:30.516', 0.0), -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'QUALIFYING'), 15, 8, '1:30.684', 0.0), -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'QUALIFYING'), 5, 9, '1:30.865', 0.0), -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'QUALIFYING'), 6, 10, '1:31.023', 0.0), -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'QUALIFYING'), 13, 11, '1:30.983', 0.0), -- Albon (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'QUALIFYING'), 14, 12, '1:31.066', 0.0), -- Colapinto (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'QUALIFYING'), 2, 13, '1:31.077', 0.0), -- Pérez (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'QUALIFYING'), 10, 14, '1:31.189', 0.0), -- Stroll (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'QUALIFYING'), 12, 15, '1:31.196', 0.0), -- Ocon (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'QUALIFYING'), 16, 16, '1:31.488', 0.0), -- Ricciardo (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'QUALIFYING'), 11, 17, '1:31.597', 0.0), -- Gasly (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'QUALIFYING'), 18, 18, '1:31.794', 0.0), -- Bottas (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'QUALIFYING'), 23, 19, '1:31.952', 0.0), -- Bearman (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'QUALIFYING'), 19, 20, '1:32.110', 0.0); -- Zhou (Out in Q1)

-- =============================================
-- 52. ADD SINGAPORE GP MAIN RACE RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'RACE'), 3, 1, 1, 62, '1:40:52.571', 25.0), -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'RACE'), 1, 2, 2, 62, '+20.945', 18.0),    -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'RACE'), 4, 3, 5, 62, '+41.823', 15.0),    -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'RACE'), 8, 4, 4, 62, '+58.803', 12.0),    -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'RACE'), 5, 5, 9, 62, '+1:04.903', 10.0),   -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'RACE'), 6, 6, 10, 62, '+1:09.583', 8.0),    -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'RACE'), 7, 7, 3, 62, '+1:16.812', 6.0),    -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'RACE'), 15, 8, 8, 62, '+1:18.477', 4.0),    -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'RACE'), 20, 9, 6, 62, '+1:31.854', 2.0),    -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'RACE'), 10, 10, 14, 61, '+1 lap', 1.0),    -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'RACE'), 9, 11, 7, 61, '+1 lap', 0.0),     -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'RACE'), 19, 12, 20, 61, '+1 lap', 0.0),    -- Zhou
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'RACE'), 14, 13, 12, 61, '+1 lap', 0.0),    -- Colapinto
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'RACE'), 2, 14, 13, 61, '+1 lap', 0.0),    -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'RACE'), 12, 15, 15, 61, '+1 lap', 0.0),    -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'RACE'), 11, 16, 17, 61, '+1 lap', 0.0),    -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'RACE'), 18, 17, 18, 61, '+1 lap', 0.0),    -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'RACE'), 23, 18, 19, 61, '+1 lap', 0.0),    -- Bearman
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'RACE'), 16, 19, 16, 61, '+1 lap', 1.0),    -- Ricciardo (1 pt for fastest lap)
((SELECT session_id FROM Sessions WHERE race_id = 18 AND session_type = 'RACE'), 13, 20, 11, 60, 'Collision', 0.0);-- Albon


-- =============================================
-- 53. ADD UNITED STATES GP SESSIONS (Race 19 - Sprint Weekend)
-- =============================================
INSERT INTO Sessions (race_id, session_type, session_date_time) VALUES
(19, 'FP1', '2024-10-18 13:30:00'),
(19, 'SPRINT_QUALIFYING', '2024-10-18 17:30:00'),
(19, 'SPRINT', '2024-10-19 14:00:00'),
(19, 'QUALIFYING', '2024-10-19 18:00:00'),
(19, 'RACE', '2024-10-20 15:00:00');

-- =============================================
-- 54. ADD UNITED STATES GP SPRINT QUALIFYING RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT_QUALIFYING'), 1, 1, '1:32.445', 0.0), -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT_QUALIFYING'), 8, 2, '1:32.656', 0.0), -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT_QUALIFYING'), 5, 3, '1:32.748', 0.0), -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT_QUALIFYING'), 3, 4, '1:32.853', 0.0), -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT_QUALIFYING'), 6, 5, '1:32.894', 0.0), -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT_QUALIFYING'), 4, 6, '1:33.003', 0.0), -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT_QUALIFYING'), 11, 7, '1:33.376', 0.0), -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT_QUALIFYING'), 12, 8, '1:33.479', 0.0), -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT_QUALIFYING'), 14, 9, '1:33.588', 0.0), -- Colapinto
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT_QUALIFYING'), 7, 10, '1:33.684', 0.0), -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT_QUALIFYING'), 10, 11, '1:33.612', 0.0), -- Stroll (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT_QUALIFYING'), 15, 12, '1:33.725', 0.0), -- Tsunoda (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT_QUALIFYING'), 17, 13, '1:33.743', 0.0), -- Lawson (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT_QUALIFYING'), 9, 14, '1:33.744', 0.0), -- Alonso (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT_QUALIFYING'), 21, 15, '1:34.020', 0.0), -- Magnussen (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT_QUALIFYING'), 2, 16, '1:34.204', 0.0), -- Pérez (Out in SQ1)
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT_QUALIFYING'), 23, 17, '1:34.332', 0.0), -- Bearman (Out in SQ1)
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT_QUALIFYING'), 18, 18, '1:34.423', 0.0), -- Bottas (Out in SQ1)
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT_QUALIFYING'), 19, 19, '1:34.453', 0.0), -- Zhou (Out in SQ1)
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT_QUALIFYING'), 20, 20, '1:34.502', 0.0); -- Hülkenberg (Out in SQ1)

-- =============================================
-- 55. ADD UNITED STATES GP SPRINT RACE RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT'), 1, 1, 1, 19, '31:07.744', 8.0), -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT'), 5, 2, 3, 19, '+5.013', 7.0),  -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT'), 6, 3, 5, 19, '+6.879', 6.0),  -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT'), 8, 4, 2, 19, '+7.265', 5.0),  -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT'), 3, 5, 4, 19, '+7.726', 4.0),  -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT'), 11, 6, 7, 19, '+12.783', 3.0), -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT'), 7, 7, 10, 19, '+18.156', 2.0), -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT'), 15, 8, 12, 19, '+19.380', 1.0), -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT'), 12, 9, 8, 19, '+21.362', 0.0), -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT'), 17, 10, 13, 19, '+22.518', 0.0),-- Lawson
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT'), 14, 11, 9, 19, '+23.957', 0.0), -- Colapinto
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT'), 2, 12, 16, 19, '+26.757', 0.0), -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT'), 10, 13, 11, 19, '+27.696', 0.0), -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT'), 9, 14, 14, 19, '+28.324', 0.0),  -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT'), 23, 15, 17, 19, '+31.758', 0.0), -- Bearman
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT'), 21, 16, 15, 19, '+33.153', 0.0), -- Magnussen
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT'), 20, 17, 20, 19, '+34.053', 0.0), -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT'), 18, 18, 18, 19, '+36.002', 0.0), -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT'), 19, 19, 19, 19, '+37.284', 0.0), -- Zhou
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'SPRINT'), 4, 20, 6, 0, 'Collision', 0.0);  -- Piastri

-- =============================================
-- 56. ADD UNITED STATES GP MAIN QUALIFYING RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'QUALIFYING'), 3, 1, '1:32.330', 0.0), -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'QUALIFYING'), 5, 2, '1:32.361', 0.0), -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'QUALIFYING'), 6, 3, '1:32.445', 0.0), -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'QUALIFYING'), 1, 4, '1:32.617', 0.0), -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'QUALIFYING'), 4, 5, '1:32.697', 0.0), -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'QUALIFYING'), 8, 6, '1:32.730', 0.0), -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'QUALIFYING'), 11, 7, '1:32.955', 0.0), -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'QUALIFYING'), 15, 8, '1:33.003', 0.0), -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'QUALIFYING'), 7, 9, '1:33.033', 0.0), -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'QUALIFYING'), 2, 10, '1:33.056', 0.0), -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'QUALIFYING'), 14, 11, '1:33.355', 0.0), -- Colapinto (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'QUALIFYING'), 20, 12, '1:33.390', 0.0), -- Hülkenberg (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'QUALIFYING'), 9, 13, '1:33.407', 0.0), -- Alonso (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'QUALIFYING'), 23, 14, '1:33.472', 0.0), -- Bearman (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'QUALIFYING'), 17, 15, '1:33.528', 0.0), -- Lawson (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'QUALIFYING'), 10, 16, '1:33.708', 0.0), -- Stroll (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'QUALIFYING'), 21, 17, '1:33.802', 0.0), -- Magnussen (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'QUALIFYING'), 12, 18, '1:33.820', 0.0), -- Ocon (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'QUALIFYING'), 18, 19, '1:34.027', 0.0), -- Bottas (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'QUALIFYING'), 19, 20, '1:34.092', 0.0); -- Zhou (Out in Q1)

-- =============================================
-- 57. ADD UNITED STATES GP MAIN RACE RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'RACE'), 5, 1, 2, 56, '1:35:09.639', 25.0), -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'RACE'), 6, 2, 3, 56, '+8.562', 18.0),     -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'RACE'), 1, 3, 4, 56, '+19.412', 15.0),    -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'RACE'), 3, 4, 1, 56, '+20.086', 12.0),    -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'RACE'), 4, 5, 5, 56, '+29.071', 10.0),    -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'RACE'), 8, 6, 6, 56, '+30.822', 8.0),     -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'RACE'), 11, 7, 7, 56, '+44.316', 6.0),     -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'RACE'), 15, 8, 8, 56, '+48.772', 4.0),     -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'RACE'), 20, 9, 12, 56, '+52.934', 2.0),    -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'RACE'), 9, 10, 13, 56, '+59.809', 2.0),    -- Alonso (1 pt + 1 pt fastest lap)
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'RACE'), 7, 11, 9, 56, '+1:05.152', 0.0),  -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'RACE'), 23, 12, 14, 56, '+1:05.799', 0.0),  -- Bearman
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'RACE'), 17, 13, 15, 56, '+1:07.037', 0.0),  -- Lawson
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'RACE'), 2, 14, 10, 56, '+1:10.592', 0.0),  -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'RACE'), 14, 15, 11, 56, '+1:13.083', 0.0),  -- Colapinto
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'RACE'), 12, 16, 18, 56, '+1:15.828', 0.0),  -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'RACE'), 18, 17, 19, 55, '+1 lap', 0.0),     -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'RACE'), 19, 18, 20, 55, '+1 lap', 0.0),     -- Zhou
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'RACE'), 10, 19, 16, 55, '+1 lap', 0.0),     -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 19 AND session_type = 'RACE'), 21, 20, 17, 41, 'Engine', 0.0);       -- Magnussen


-- =============================================
-- 58. ADD MEXICO CITY GP SESSIONS (Race 20)
-- =============================================
INSERT INTO Sessions (race_id, session_type, session_date_time) VALUES
(20, 'FP1', '2024-10-25 13:30:00'),
(20, 'FP2', '2024-10-25 17:00:00'),
(20, 'FP3', '2024-10-26 12:30:00'),
(20, 'QUALIFYING', '2024-10-26 16:00:00'),
(20, 'RACE', '2024-10-27 15:00:00');

-- =============================================
-- 59. ADD MEXICO CITY GP QUALIFYING RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'QUALIFYING'), 6, 1, '1:15.946', 0.0), -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'QUALIFYING'), 1, 2, '1:16.171', 0.0), -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'QUALIFYING'), 3, 3, '1:16.200', 0.0), -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'QUALIFYING'), 5, 4, '1:16.336', 0.0), -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'QUALIFYING'), 8, 5, '1:16.410', 0.0), -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'QUALIFYING'), 7, 6, '1:16.429', 0.0), -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'QUALIFYING'), 21, 7, '1:16.841', 0.0), -- Magnussen
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'QUALIFYING'), 11, 8, '1:16.891', 0.0), -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'QUALIFYING'), 4, 9, '1:16.920', 0.0), -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'QUALIFYING'), 20, 10, '1:17.365', 0.0),-- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'QUALIFYING'), 15, 11, '1:17.043', 0.0), -- Tsunoda (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'QUALIFYING'), 12, 12, '1:17.085', 0.0), -- Ocon (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'QUALIFYING'), 17, 13, '1:17.165', 0.0), -- Lawson (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'QUALIFYING'), 14, 14, '1:17.293', 0.0), -- Colapinto (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'QUALIFYING'), 18, 15, '1:17.487', 0.0), -- Bottas (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'QUALIFYING'), 19, 16, '1:18.022', 0.0), -- Zhou (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'QUALIFYING'), 10, 17, '1:18.027', 0.0), -- Stroll (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'QUALIFYING'), 2, 18, '1:18.096', 0.0), -- Pérez (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'QUALIFYING'), 9, 19, '1:18.272', 0.0), -- Alonso (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'QUALIFYING'), 13, 20, '1:18.531', 0.0); -- Albon (Out in Q1)

-- =============================================
-- 60. ADD MEXICO CITY GP MAIN RACE RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'RACE'), 6, 1, 1, 71, '1:40:55.800', 25.0), -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'RACE'), 3, 2, 3, 71, '+4.705', 18.0),     -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'RACE'), 5, 3, 4, 71, '+34.387', 16.0),    -- Leclerc (15 pts + 1 fastest lap)
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'RACE'), 7, 4, 6, 71, '+41.030', 12.0),    -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'RACE'), 8, 5, 5, 71, '+48.572', 10.0),    -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'RACE'), 1, 6, 2, 71, '+59.558', 8.0),     -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'RACE'), 21, 7, 7, 71, '+1:03.642', 6.0),    -- Magnussen
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'RACE'), 4, 8, 9, 71, '+1:08.572', 4.0),     -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'RACE'), 20, 9, 10, 71, '+1:10.079', 2.0),   -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'RACE'), 11, 10, 8, 71, '+1:10.609', 1.0),   -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'RACE'), 10, 11, 17, 71, '+1:20.358', 0.0),  -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'RACE'), 18, 12, 15, 70, '+1 lap', 0.0),     -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'RACE'), 19, 13, 16, 70, '+1 lap', 0.0),     -- Zhou
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'RACE'), 17, 14, 13, 70, '+1 lap', 0.0),    -- Lawson
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'RACE'), 12, 15, 12, 70, '+1 lap', 0.0),    -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'RACE'), 2, 16, 18, 70, '+1 lap', 0.0),     -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'RACE'), 14, 17, 14, 65, 'Collision', 0.0), -- Colapinto
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'RACE'), 15, 18, 11, 65, 'Collision', 0.0), -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'RACE'), 13, 19, 20, 56, 'Brakes', 0.0),     -- Albon
((SELECT session_id FROM Sessions WHERE race_id = 20 AND session_type = 'RACE'), 9, 20, 19, 55, 'Brakes', 0.0);      -- Alonso


-- =============================================
-- 61. ADD SÃO PAULO GP SESSIONS (Race 21 - Sprint Weekend)
-- =============================================
INSERT INTO Sessions (race_id, session_type, session_date_time) VALUES
(21, 'FP1', '2024-11-01 11:30:00'),
(21, 'SPRINT_QUALIFYING', '2024-11-01 15:30:00'),
(21, 'SPRINT', '2024-11-02 11:00:00'),
(21, 'QUALIFYING', '2024-11-02 15:00:00'),
(21, 'RACE', '2024-11-03 14:00:00');

-- =============================================
-- 62. ADD SÃO PAULO GP SPRINT QUALIFYING RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT_QUALIFYING'), 4, 1, '1:10.410', 0.0), -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT_QUALIFYING'), 3, 2, '1:10.614', 0.0), -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT_QUALIFYING'), 5, 3, '1:10.622', 0.0), -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT_QUALIFYING'), 1, 4, '1:10.784', 0.0), -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT_QUALIFYING'), 6, 5, '1:10.837', 0.0), -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT_QUALIFYING'), 23, 6, '1:11.051', 0.0), -- Bearman
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT_QUALIFYING'), 20, 7, '1:11.121', 0.0), -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT_QUALIFYING'), 11, 8, '1:11.306', 0.0), -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT_QUALIFYING'), 2, 9, '1:11.488', 0.0), -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT_QUALIFYING'), 8, 10, '1:11.545', 0.0), -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT_QUALIFYING'), 7, 11, '1:11.161', 0.0), -- Hamilton (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT_QUALIFYING'), 12, 12, '1:11.230', 0.0), -- Ocon (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT_QUALIFYING'), 17, 13, '1:11.233', 0.0), -- Lawson (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT_QUALIFYING'), 10, 14, '1:11.341', 0.0), -- Stroll (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT_QUALIFYING'), 9, 15, '1:11.411', 0.0), -- Alonso (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT_QUALIFYING'), 18, 16, '1:11.814', 0.0), -- Bottas (Out in SQ1)
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT_QUALIFYING'), 14, 17, '1:11.854', 0.0), -- Colapinto (Out in SQ1)
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT_QUALIFYING'), 15, 18, '1:11.879', 0.0), -- Tsunoda (Out in SQ1)
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT_QUALIFYING'), 21, 19, '1:11.902', 0.0), -- Magnussen (Out in SQ1)
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT_QUALIFYING'), 19, 20, '1:12.115', 0.0); -- Zhou (Out in SQ1)

-- =============================================
-- 63. ADD SÃO PAULO GP SPRINT RACE RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT'), 3, 1, 2, 24, '28:16.276', 8.0), -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT'), 4, 2, 1, 24, '+0.593', 7.0),  -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT'), 5, 3, 3, 24, '+3.635', 6.0),  -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT'), 1, 4, 4, 24, '+4.485', 5.0),  -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT'), 6, 5, 5, 24, '+5.170', 4.0),  -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT'), 8, 6, 10, 24, '+6.096', 3.0),  -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT'), 2, 7, 9, 24, '+6.908', 2.0),  -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT'), 7, 8, 11, 24, '+8.019', 1.0),  -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT'), 23, 9, 6, 24, '+8.567', 0.0),  -- Bearman
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT'), 20, 10, 7, 24, '+13.784', 0.0), -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT'), 11, 11, 8, 24, '+14.654', 0.0), -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT'), 17, 12, 13, 24, '+17.481', 0.0), -- Lawson
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT'), 12, 13, 12, 24, '+18.157', 0.0), -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT'), 10, 14, 14, 24, '+19.349', 0.0), -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT'), 18, 15, 16, 24, '+20.151', 0.0), -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT'), 14, 16, 17, 24, '+20.730', 0.0), -- Colapinto
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT'), 15, 17, 18, 24, '+21.362', 0.0), -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT'), 9, 18, 15, 24, '+22.564', 0.0),  -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT'), 21, 19, 19, 24, '+23.018', 0.0), -- Magnussen
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'SPRINT'), 19, 20, 20, 24, '+24.471', 0.0); -- Zhou

-- =============================================
-- 64. ADD SÃO PAULO GP MAIN QUALIFYING RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'QUALIFYING'), 3, 1, '1:09.822', 0.0), -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'QUALIFYING'), 8, 2, '1:09.829', 0.0), -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'QUALIFYING'), 15, 3, '1:10.021', 0.0), -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'QUALIFYING'), 17, 4, '1:10.154', 0.0), -- Lawson
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'QUALIFYING'), 5, 5, '1:10.292', 0.0), -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'QUALIFYING'), 1, 6, '1:10.316', 0.0), -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'QUALIFYING'), 4, 7, '1:10.320', 0.0), -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'QUALIFYING'), 9, 8, '1:10.322', 0.0), -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'QUALIFYING'), 11, 9, '1:10.485', 0.0), -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'QUALIFYING'), 14, 10, '1:10.510', 0.0),-- Colapinto
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'QUALIFYING'), 6, 11, '1:10.481', 0.0), -- Sainz (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'QUALIFYING'), 23, 12, '1:10.519', 0.0), -- Bearman (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'QUALIFYING'), 20, 13, '1:10.528', 0.0), -- Hülkenberg (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'QUALIFYING'), 18, 14, '1:10.554', 0.0), -- Bottas (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'QUALIFYING'), 10, 15, '1:10.630', 0.0), -- Stroll (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'QUALIFYING'), 2, 16, '1:10.879', 0.0), -- Pérez (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'QUALIFYING'), 12, 17, '1:10.952', 0.0), -- Ocon (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'QUALIFYING'), 7, 18, '1:11.126', 0.0), -- Hamilton (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'QUALIFYING'), 19, 19, '1:11.310', 0.0), -- Zhou (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'QUALIFYING'), 21, 20, '1:11.365', 0.0); -- Magnussen (Out in Q1)

-- =============================================
-- 65. ADD SÃO PAULO GP MAIN RACE RESULTS
-- =============================================
-- Race shortened to 69 laps due to aborted start.
-- Points awarded based on 69 laps completed.
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'RACE'), 1, 1, 6, 69, '2:06:54.430', 26.0), -- Verstappen (25 pts + 1 fastest lap)
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'RACE'), 12, 2, 17, 69, '+19.477', 18.0),    -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'RACE'), 11, 3, 9, 69, '+22.532', 15.0),    -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'RACE'), 8, 4, 2, 69, '+30.444', 12.0),    -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'RACE'), 5, 5, 5, 69, '+33.079', 10.0),    -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'RACE'), 3, 6, 1, 69, '+34.385', 8.0),     -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'RACE'), 15, 7, 3, 69, '+41.280', 6.0),     -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'RACE'), 4, 8, 7, 69, '+45.619', 4.0),     -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'RACE'), 17, 9, 4, 69, '+49.803', 2.0),     -- Lawson
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'RACE'), 7, 10, 18, 69, '+50.243', 1.0),    -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'RACE'), 20, 11, 13, 69, '+56.128', 0.0),   -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'RACE'), 2, 12, 16, 69, '+1:02.599', 0.0),  -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'RACE'), 18, 13, 14, 69, '+1:07.163', 0.0),  -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'RACE'), 9, 14, 8, 69, '+1:15.172', 0.0),   -- Alonso (Started Pits)
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'RACE'), 10, 15, 15, 69, '+1:17.568', 0.0),  -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'RACE'), 14, 16, 10, 69, '+1:18.106', 0.0),  -- Colapinto
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'RACE'), 19, 17, 19, 68, '+1 lap', 0.0),     -- Zhou
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'RACE'), 21, 18, 20, 68, '+1 lap', 0.0),     -- Magnussen
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'RACE'), 23, 19, 12, 5, 'Collision', 0.0),   -- Bearman
((SELECT session_id FROM Sessions WHERE race_id = 21 AND session_type = 'RACE'), 6, 20, 11, 0, 'Collision', 0.0);   -- Sainz


-- =============================================
-- 66. ADD LAS VEGAS GP SESSIONS (Race 22)
-- =============================================
INSERT INTO Sessions (race_id, session_type, session_date_time) VALUES
(22, 'FP1', '2024-11-21 18:30:00'),
(22, 'FP2', '2024-11-21 22:00:00'),
(22, 'FP3', '2024-11-22 18:30:00'),
(22, 'QUALIFYING', '2024-11-22 22:00:00'),
(22, 'RACE', '2024-11-23 22:00:00');

-- =============================================
-- 67. ADD LAS VEGAS GP QUALIFYING RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'QUALIFYING'), 8, 1, '1:32.312', 0.0), -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'QUALIFYING'), 6, 2, '1:32.321', 0.0), -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'QUALIFYING'), 5, 3, '1:32.404', 0.0), -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'QUALIFYING'), 3, 4, '1:32.618', 0.0), -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'QUALIFYING'), 1, 5, '1:32.656', 0.0), -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'QUALIFYING'), 4, 6, '1:32.793', 0.0), -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'QUALIFYING'), 20, 7, '1:32.887', 0.0), -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'QUALIFYING'), 7, 8, '1:32.904', 0.0), -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'QUALIFYING'), 11, 9, '1:33.008', 0.0), -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'QUALIFYING'), 13, 10, '1:33.064', 0.0),-- Albon
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'QUALIFYING'), 9, 11, '1:33.190', 0.0), -- Alonso (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'QUALIFYING'), 15, 12, '1:33.294', 0.0), -- Tsunoda (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'QUALIFYING'), 12, 13, '1:33.348', 0.0), -- Ocon (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'QUALIFYING'), 10, 14, '1:33.379', 0.0), -- Stroll (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'QUALIFYING'), 19, 15, '1:33.570', 0.0), -- Zhou (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'QUALIFYING'), 17, 16, '1:33.788', 0.0), -- Lawson (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'QUALIFYING'), 2, 17, '1:33.804', 0.0), -- Pérez (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'QUALIFYING'), 21, 18, '1:33.886', 0.0), -- Magnussen (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'QUALIFYING'), 18, 19, '1:33.992', 0.0), -- Bottas (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'QUALIFYING'), 14, 20, '1:34.456', 0.0); -- Colapinto (Out in Q1)

-- =============================================
-- 68. ADD LAS VEGAS GP MAIN RACE RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'RACE'), 8, 1, 1, 50, '1:22:05.969', 25.0), -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'RACE'), 7, 2, 8, 50, '+7.313', 18.0),     -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'RACE'), 6, 3, 2, 50, '+11.906', 15.0),    -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'RACE'), 5, 4, 3, 50, '+14.617', 12.0),    -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'RACE'), 1, 5, 5, 50, '+16.599', 10.0),    -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'RACE'), 3, 6, 4, 50, '+17.481', 9.0),     -- Norris (8 pts + 1 fastest lap)
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'RACE'), 4, 7, 6, 50, '+23.835', 6.0),     -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'RACE'), 20, 8, 7, 50, '+29.049', 4.0),     -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'RACE'), 15, 9, 12, 50, '+36.363', 2.0),    -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'RACE'), 2, 10, 17, 50, '+43.238', 1.0),    -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'RACE'), 9, 11, 11, 50, '+47.668', 0.0),    -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'RACE'), 21, 12, 18, 50, '+49.035', 0.0),   -- Magnussen
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'RACE'), 19, 13, 15, 50, '+50.413', 0.0),   -- Zhou
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'RACE'), 17, 14, 16, 50, '+51.530', 0.0),   -- Lawson
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'RACE'), 10, 15, 14, 50, '+52.129', 0.0),   -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'RACE'), 14, 16, 20, 50, '+1:19.445', 0.0),  -- Colapinto
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'RACE'), 18, 17, 19, 49, '+1 lap', 0.0),     -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'RACE'), 12, 18, 13, 49, '+1 lap', 0.0),     -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'RACE'), 11, 19, 9, 42, 'Collision', 0.0),   -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 22 AND session_type = 'RACE'), 13, 20, 10, 1, 'Collision', 0.0);   -- Albon


-- =============================================
-- 69. ADD QATAR GP SESSIONS (Race 23 - Sprint Weekend)
-- =============================================
INSERT INTO Sessions (race_id, session_type, session_date_time) VALUES
(23, 'FP1', '2024-11-29 16:30:00'),
(23, 'SPRINT_QUALIFYING', '2024-11-29 20:30:00'),
(23, 'SPRINT', '2024-11-30 16:00:00'),
(23, 'QUALIFYING', '2024-11-30 20:00:00'),
(23, 'RACE', '2024-12-01 20:00:00');

-- =============================================
-- 70. ADD QATAR GP SPRINT QUALIFYING RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT_QUALIFYING'), 3, 1, '1:21.012', 0.0), -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT_QUALIFYING'), 8, 2, '1:21.085', 0.0), -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT_QUALIFYING'), 4, 3, '1:21.139', 0.0), -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT_QUALIFYING'), 6, 4, '1:21.211', 0.0), -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT_QUALIFYING'), 5, 5, '1:21.281', 0.0), -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT_QUALIFYING'), 1, 6, '1:21.314', 0.0), -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT_QUALIFYING'), 7, 7, '1:21.419', 0.0), -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT_QUALIFYING'), 11, 8, '1:21.500', 0.0), -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT_QUALIFYING'), 20, 9, '1:21.688', 0.0), -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT_QUALIFYING'), 17, 10, '1:21.758', 0.0),-- Lawson
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT_QUALIFYING'), 15, 11, '1:21.921', 0.0), -- Tsunoda (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT_QUALIFYING'), 10, 12, '1:21.999', 0.0), -- Stroll (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT_QUALIFYING'), 12, 13, '1:22.022', 0.0), -- Ocon (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT_QUALIFYING'), 9, 14, '1:22.046', 0.0), -- Alonso (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT_QUALIFYING'), 13, 15, '1:22.083', 0.0), -- Albon (Out in SQ2)
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT_QUALIFYING'), 2, 16, '1:22.259', 0.0), -- Pérez (Out in SQ1)
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT_QUALIFYING'), 14, 17, '1:22.569', 0.0), -- Colapinto (Out in SQ1)
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT_QUALIFYING'), 18, 18, '1:22.576', 0.0), -- Bottas (Out in SQ1)
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT_QUALIFYING'), 21, 19, '1:22.598', 0.0), -- Magnussen (Out in SQ1)
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT_QUALIFYING'), 19, 20, '1:22.641', 0.0); -- Zhou (Out in SQ1)

-- =============================================
-- 71. ADD QATAR GP SPRINT RACE RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT'), 4, 1, 3, 19, '27:03.283', 8.0), -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT'), 8, 2, 2, 19, '+0.136', 7.0),  -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT'), 3, 3, 1, 19, '+0.704', 6.0),  -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT'), 1, 4, 6, 19, '+1.411', 5.0),  -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT'), 6, 5, 4, 19, '+1.916', 4.0),  -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT'), 20, 6, 9, 19, '+8.900', 3.0),  -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT'), 5, 7, 5, 19, '+9.642', 2.0),  -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT'), 11, 8, 8, 19, '+10.457', 1.0), -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT'), 7, 9, 7, 19, '+11.396', 0.0), -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT'), 17, 10, 10, 19, '+11.838', 0.0),-- Lawson
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT'), 2, 11, 16, 19, '+12.333', 0.0), -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT'), 10, 12, 12, 19, '+17.479', 0.0), -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT'), 9, 13, 14, 19, '+18.157', 0.0), -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT'), 12, 14, 13, 19, '+18.736', 0.0), -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT'), 15, 15, 11, 19, '+19.390', 0.0), -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT'), 13, 16, 15, 19, '+23.237', 0.0), -- Albon
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT'), 18, 17, 18, 19, '+27.465', 0.0), -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT'), 21, 18, 19, 19, '+27.776', 0.0), -- Magnussen
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT'), 19, 19, 20, 19, '+31.026', 0.0), -- Zhou
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'SPRINT'), 14, 20, 17, 19, '+32.196', 0.0); -- Colapinto

-- =============================================
-- 72. ADD QATAR GP MAIN QUALIFYING RESULTS
-- =============================================
-- Note: Verstappen qualified 1st but started Pits due to PU change. Russell inherited pole.
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'QUALIFYING'), 1, 1, '1:20.575', 0.0),  -- Verstappen (Started Pits)
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'QUALIFYING'), 8, 2, '1:20.672', 0.0),  -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'QUALIFYING'), 3, 3, '1:20.801', 0.0),  -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'QUALIFYING'), 4, 4, '1:20.916', 0.0),  -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'QUALIFYING'), 5, 5, '1:21.050', 0.0),  -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'QUALIFYING'), 7, 6, '1:21.241', 0.0),  -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'QUALIFYING'), 11, 7, '1:21.366', 0.0), -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'QUALIFYING'), 6, 8, '1:21.383', 0.0),  -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'QUALIFYING'), 9, 9, '1:21.463', 0.0),  -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'QUALIFYING'), 2, 10, '1:21.650', 0.0), -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'QUALIFYING'), 15, 11, '1:21.784', 0.0), -- Tsunoda (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'QUALIFYING'), 17, 12, '1:21.904', 0.0), -- Lawson (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'QUALIFYING'), 10, 13, '1:21.954', 0.0), -- Stroll (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'QUALIFYING'), 18, 14, '1:21.996', 0.0), -- Bottas (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'QUALIFYING'), 12, 15, '1:22.031', 0.0), -- Ocon (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'QUALIFYING'), 13, 16, '1:22.251', 0.0), -- Albon (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'QUALIFYING'), 21, 17, '1:22.378', 0.0), -- Magnussen (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'QUALIFYING'), 19, 18, '1:22.427', 0.0), -- Zhou (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'QUALIFYING'), 14, 19, '1:22.519', 0.0), -- Colapinto (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'QUALIFYING'), 20, 20, '1:22.579', 0.0); -- Hülkenberg (Out in Q1)

-- =============================================
-- 73. ADD QATAR GP MAIN RACE RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'RACE'), 1, 1, 20, 57, '1:31:05.323', 25.0), -- Verstappen (Started Pits)
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'RACE'), 5, 2, 4, 57, '+6.031', 18.0),     -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'RACE'), 4, 3, 3, 57, '+6.819', 15.0),     -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'RACE'), 8, 4, 1, 57, '+12.623', 12.0),    -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'RACE'), 3, 5, 2, 57, '+16.596', 10.0),    -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'RACE'), 11, 6, 6, 57, '+18.309', 8.0),     -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'RACE'), 6, 7, 7, 57, '+19.230', 6.0),     -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'RACE'), 9, 8, 8, 57, '+28.389', 4.0),     -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'RACE'), 12, 9, 14, 57, '+34.869', 2.0),    -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'RACE'), 2, 10, 9, 57, '+36.192', 1.0),    -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'RACE'), 7, 11, 5, 57, '+57.199', 0.0),    -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'RACE'), 10, 12, 12, 57, '+59.863', 0.0),   -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'RACE'), 17, 13, 11, 57, '+1:07.727', 0.0),  -- Lawson
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'RACE'), 13, 14, 15, 57, '+1:10.706', 0.0),  -- Albon
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'RACE'), 20, 15, 19, 57, '+1:11.756', 1.0),  -- Hülkenberg (1 pt fastest lap)
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'RACE'), 14, 16, 18, 57, '+1:22.388', 0.0),  -- Colapinto
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'RACE'), 18, 17, 13, 57, '+1:24.965', 0.0),  -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'RACE'), 19, 18, 17, 56, '+1 lap', 0.0),     -- Zhou
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'RACE'), 15, 19, 10, 55, 'Collision', 0.0),   -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 23 AND session_type = 'RACE'), 21, 20, 16, 55, 'Collision', 0.0);   -- Magnussen


-- =============================================
-- 74. ADD ABU DHABI GP SESSIONS (Race 24)
-- =============================================
INSERT INTO Sessions (race_id, session_type, session_date_time) VALUES
(24, 'FP1', '2024-12-06 13:30:00'),
(24, 'FP2', '2024-12-06 17:00:00'),
(24, 'FP3', '2024-12-07 14:30:00'),
(24, 'QUALIFYING', '2024-12-07 18:00:00'),
(24, 'RACE', '2024-12-08 17:00:00');

-- =============================================
-- 75. ADD ABU DHABI GP QUALIFYING RESULTS
-- =============================================
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'QUALIFYING'), 3, 1, '1:22.595', 0.0), -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'QUALIFYING'), 4, 2, '1:22.804', 0.0), -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'QUALIFYING'), 6, 3, '1:22.868', 0.0), -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'QUALIFYING'), 11, 4, '1:23.080', 0.0), -- Gasly (Had penalty)
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'QUALIFYING'), 1, 5, '1:23.102', 0.0), -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'QUALIFYING'), 8, 6, '1:23.132', 0.0), -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'QUALIFYING'), 20, 7, '1:23.136', 0.0), -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'QUALIFYING'), 9, 8, '1:23.284', 0.0), -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'QUALIFYING'), 7, 9, '1:23.368', 0.0), -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'QUALIFYING'), 2, 10, '1:23.447', 0.0), -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'QUALIFYING'), 5, 11, '1:23.435', 0.0), -- Leclerc (Out in Q2, had penalty)
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'QUALIFYING'), 15, 12, '1:23.479', 0.0), -- Tsunoda (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'QUALIFYING'), 17, 13, '1:23.585', 0.0), -- Lawson (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'QUALIFYING'), 10, 14, '1:23.784', 0.0), -- Stroll (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'QUALIFYING'), 14, 15, '1:23.931', 0.0), -- Colapinto (Out in Q2)
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'QUALIFYING'), 21, 16, '1:23.966', 0.0), -- Magnussen (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'QUALIFYING'), 13, 17, '1:23.999', 0.0), -- Albon (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'QUALIFYING'), 18, 18, '1:24.191', 0.0), -- Bottas (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'QUALIFYING'), 24, 19, '1:24.225', 0.0), -- Doohan (Out in Q1)
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'QUALIFYING'), 19, 20, '1:24.285', 0.0); -- Zhou (Out in Q1)

-- =============================================
-- 76. ADD ABU DHABI GP MAIN RACE RESULTS
-- =============================================
-- Note: Gasly started 7th after Leclerc's penalty. Leclerc started 11th.
INSERT INTO Results (session_id, driver_id, final_position, grid_position, laps_completed, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'RACE'), 3, 1, 1, 58, '1:26:33.291', 25.0), -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'RACE'), 6, 2, 3, 58, '+5.832', 18.0),     -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'RACE'), 5, 3, 11, 58, '+31.928', 15.0),    -- Leclerc (Started 11th)
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'RACE'), 7, 4, 9, 58, '+39.489', 12.0),    -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'RACE'), 8, 5, 6, 58, '+48.803', 10.0),    -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'RACE'), 1, 6, 5, 58, '+49.704', 8.0),     -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'RACE'), 2, 7, 10, 58, '+1:12.502', 6.0),    -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'RACE'), 9, 8, 8, 58, '+1:17.570', 4.0),    -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'RACE'), 4, 9, 2, 58, '+1:18.457', 2.0),    -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'RACE'), 15, 10, 12, 58, '+1:23.055', 1.0),   -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'RACE'), 17, 11, 13, 57, '+1 lap', 0.0),    -- Lawson
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'RACE'), 14, 12, 15, 57, '+1 lap', 0.0),    -- Colapinto
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'RACE'), 10, 13, 14, 57, '+1 lap', 0.0),    -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'RACE'), 24, 14, 19, 57, '+1 lap', 0.0),    -- Doohan
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'RACE'), 20, 15, 7, 57, '+1 lap', 0.0),    -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'RACE'), 13, 16, 17, 57, '+1 lap', 0.0),    -- Albon
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'RACE'), 21, 17, 16, 57, '+1 lap', 1.0),    -- Magnussen (1 pt fastest lap)
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'RACE'), 18, 18, 18, 56, '+2 laps', 0.0),    -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'RACE'), 19, 19, 20, 56, '+2 laps', 0.0),    -- Zhou
((SELECT session_id FROM Sessions WHERE race_id = 24 AND session_type = 'RACE'), 11, 20, 7, 55, 'Collision', 0.0);   -- Gasly (Started 7th)

-- =============================================
-- END OF 2024 SEASON DATA SCRIPTS
-- =============================================

-- =============================================
-- SCRIPT TO ADD MISSING QUALIFYING RESULTS FOR RACES 1-3
-- Bahrain, Saudi Arabia, Australia
-- =============================================

-- BAHRAIN GRAND PRIX QUALIFYING RESULTS (Race 1)
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 1 AND session_type = 'QUALIFYING'), 1, 1, '1:29.179', 0.0), -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 1 AND session_type = 'QUALIFYING'), 5, 2, '1:29.407', 0.0), -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 1 AND session_type = 'QUALIFYING'), 8, 3, '1:29.480', 0.0), -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 1 AND session_type = 'QUALIFYING'), 6, 4, '1:29.507', 0.0), -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 1 AND session_type = 'QUALIFYING'), 2, 5, '1:29.542', 0.0), -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 1 AND session_type = 'QUALIFYING'), 9, 6, '1:29.658', 0.0), -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 1 AND session_type = 'QUALIFYING'), 3, 7, '1:29.708', 0.0), -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 1 AND session_type = 'QUALIFYING'), 4, 8, '1:29.714', 0.0), -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 1 AND session_type = 'QUALIFYING'), 7, 9, '1:29.801', 0.0), -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 1 AND session_type = 'QUALIFYING'), 20, 10, '1:30.013', 0.0),-- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 1 AND session_type = 'QUALIFYING'), 15, 11, '1:30.030', 0.0),-- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 1 AND session_type = 'QUALIFYING'), 10, 12, '1:30.084', 0.0),-- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 1 AND session_type = 'QUALIFYING'), 13, 13, '1:30.243', 0.0),-- Albon
((SELECT session_id FROM Sessions WHERE race_id = 1 AND session_type = 'QUALIFYING'), 16, 14, '1:30.369', 0.0),-- Ricciardo
((SELECT session_id FROM Sessions WHERE race_id = 1 AND session_type = 'QUALIFYING'), 21, 15, '1:30.581', 0.0),-- Magnussen
((SELECT session_id FROM Sessions WHERE race_id = 1 AND session_type = 'QUALIFYING'), 18, 16, '1:30.647', 0.0),-- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 1 AND session_type = 'QUALIFYING'), 19, 17, '1:30.680', 0.0),-- Zhou
((SELECT session_id FROM Sessions WHERE race_id = 1 AND session_type = 'QUALIFYING'), 22, 18, '1:30.756', 0.0),-- Sargeant
((SELECT session_id FROM Sessions WHERE race_id = 1 AND session_type = 'QUALIFYING'), 12, 19, '1:30.798', 0.0),-- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 1 AND session_type = 'QUALIFYING'), 11, 20, '1:30.980', 0.0); -- Gasly

-- SAUDI ARABIAN GRAND PRIX QUALIFYING RESULTS (Race 2)
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 2 AND session_type = 'QUALIFYING'), 1, 1, '1:27.472', 0.0), -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 2 AND session_type = 'QUALIFYING'), 5, 2, '1:27.791', 0.0), -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 2 AND session_type = 'QUALIFYING'), 2, 3, '1:27.807', 0.0), -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 2 AND session_type = 'QUALIFYING'), 9, 4, '1:27.851', 0.0), -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 2 AND session_type = 'QUALIFYING'), 4, 5, '1:28.089', 0.0), -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 2 AND session_type = 'QUALIFYING'), 3, 6, '1:28.132', 0.0), -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 2 AND session_type = 'QUALIFYING'), 8, 7, '1:28.316', 0.0), -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 2 AND session_type = 'QUALIFYING'), 7, 8, '1:28.318', 0.0), -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 2 AND session_type = 'QUALIFYING'), 15, 9, '1:28.546', 0.0), -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 2 AND session_type = 'QUALIFYING'), 10, 10, '1:28.646', 0.0),-- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 2 AND session_type = 'QUALIFYING'), 23, 11, '1:28.688', 0.0),-- Bearman
((SELECT session_id FROM Sessions WHERE race_id = 2 AND session_type = 'QUALIFYING'), 13, 12, '1:28.796', 0.0),-- Albon
((SELECT session_id FROM Sessions WHERE race_id = 2 AND session_type = 'QUALIFYING'), 21, 13, '1:28.806', 0.0),-- Magnussen
((SELECT session_id FROM Sessions WHERE race_id = 2 AND session_type = 'QUALIFYING'), 16, 14, '1:28.995', 0.0),-- Ricciardo
((SELECT session_id FROM Sessions WHERE race_id = 2 AND session_type = 'QUALIFYING'), 20, 15, '1:29.025', 0.0),-- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 2 AND session_type = 'QUALIFYING'), 18, 16, '1:29.181', 0.0),-- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 2 AND session_type = 'QUALIFYING'), 12, 17, '1:29.199', 0.0),-- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 2 AND session_type = 'QUALIFYING'), 11, 18, '1:29.480', 0.0),-- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 2 AND session_type = 'QUALIFYING'), 22, 19, '1:29.526', 0.0),-- Sargeant
((SELECT session_id FROM Sessions WHERE race_id = 2 AND session_type = 'QUALIFYING'), 19, 20, '1:29.759', 0.0); -- Zhou

-- AUSTRALIAN GRAND PRIX QUALIFYING RESULTS (Race 3)
INSERT INTO Results (session_id, driver_id, final_position, time_or_status, points) VALUES
((SELECT session_id FROM Sessions WHERE race_id = 3 AND session_type = 'QUALIFYING'), 1, 1, '1:15.915', 0.0), -- Verstappen
((SELECT session_id FROM Sessions WHERE race_id = 3 AND session_type = 'QUALIFYING'), 6, 2, '1:16.185', 0.0), -- Sainz
((SELECT session_id FROM Sessions WHERE race_id = 3 AND session_type = 'QUALIFYING'), 2, 3, '1:16.274', 0.0), -- Pérez
((SELECT session_id FROM Sessions WHERE race_id = 3 AND session_type = 'QUALIFYING'), 3, 4, '1:16.315', 0.0), -- Norris
((SELECT session_id FROM Sessions WHERE race_id = 3 AND session_type = 'QUALIFYING'), 5, 5, '1:16.353', 0.0), -- Leclerc
((SELECT session_id FROM Sessions WHERE race_id = 3 AND session_type = 'QUALIFYING'), 4, 6, '1:16.557', 0.0), -- Piastri
((SELECT session_id FROM Sessions WHERE race_id = 3 AND session_type = 'QUALIFYING'), 8, 7, '1:16.724', 0.0), -- Russell
((SELECT session_id FROM Sessions WHERE race_id = 3 AND session_type = 'QUALIFYING'), 15, 8, '1:16.731', 0.0), -- Tsunoda
((SELECT session_id FROM Sessions WHERE race_id = 3 AND session_type = 'QUALIFYING'), 10, 9, '1:16.732', 0.0), -- Stroll
((SELECT session_id FROM Sessions WHERE race_id = 3 AND session_type = 'QUALIFYING'), 9, 10, '1:16.750', 0.0), -- Alonso
((SELECT session_id FROM Sessions WHERE race_id = 3 AND session_type = 'QUALIFYING'), 7, 11, '1:16.984', 0.0), -- Hamilton
((SELECT session_id FROM Sessions WHERE race_id = 3 AND session_type = 'QUALIFYING'), 13, 12, '1:17.056', 0.0), -- Albon
((SELECT session_id FROM Sessions WHERE race_id = 3 AND session_type = 'QUALIFYING'), 18, 13, '1:17.167', 0.0), -- Bottas
((SELECT session_id FROM Sessions WHERE race_id = 3 AND session_type = 'QUALIFYING'), 21, 14, '1:17.369', 0.0), -- Magnussen
((SELECT session_id FROM Sessions WHERE race_id = 3 AND session_type = 'QUALIFYING'), 12, 15, '1:17.433', 0.0), -- Ocon
((SELECT session_id FROM Sessions WHERE race_id = 3 AND session_type = 'QUALIFYING'), 20, 16, '1:17.435', 0.0), -- Hülkenberg
((SELECT session_id FROM Sessions WHERE race_id = 3 AND session_type = 'QUALIFYING'), 11, 17, '1:17.577', 0.0), -- Gasly
((SELECT session_id FROM Sessions WHERE race_id = 3 AND session_type = 'QUALIFYING'), 16, 18, '1:17.617', 0.0), -- Ricciardo
((SELECT session_id FROM Sessions WHERE race_id = 3 AND session_type = 'QUALIFYING'), 19, 19, '1:18.045', 0.0); -- Zhou

