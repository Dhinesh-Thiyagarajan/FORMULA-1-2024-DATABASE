# **🏎️ F1 2024 Season Database**

## **Project Overview**

This is a full-stack, single-page web application designed to track and display real-time and historical data for the **Formula 1 2024 Season**.  
The application utilizes a robust PostgreSQL database to store detailed race, session, driver, and constructor information. A lightweight Node.js/Express API serves the data to a responsive, standalone HTML/JavaScript frontend, allowing users to view:

* **Race Results:** Filterable results for individual sessions (Practice, Qualifying, Sprint, Race) or a summary of race winners across the entire season.  
* **Driver Standings:** Up-to-date driver championship points and participation history.  
* **Teams & Lineup:** A clear breakdown of all constructors and their engine suppliers, along with their current driver pairings.  
* **Race Calendar:** The full 2024 Grand Prix schedule, including sprint weekends.

### 

## **🛠️ Local Setup and Installation**

To get this project running on your local machine, you will need **Node.js** and **PostgreSQL** installed.

### **1\. Database Setup (PostgreSQL)**

The database schema and initial data are provided in the f1.sql file.

1. **Create Database:** Create a new PostgreSQL database (e.g., f1\_2024).  
   psql \-U your\_user \-c "CREATE DATABASE f1\_2024;"

2. **Load Schema & Data:** Execute the contents of the f1.sql file against your new database.  
   psql \-U your\_user \-d f1\_2024 \-f f1.sql

3. **Update Configuration:** Open the server.js file and update the user property in the pool configuration to match your PostgreSQL username.  
   const pool \= new Pool({  
     user: 'your\_postgres\_username', // \<--- Update this\!  
     host: 'localhost',  
     port: 5432,  
     database: 'f1\_2024'  
   });

### **2\. API (Backend) Setup**

1. **Install Dependencies:** Navigate to the root directory where server.js is located and install the necessary Node modules.  
   npm install express cors pg

2. **Start API Server:** Run the server using Node.  
   node server.js

   The API should start running on http://localhost:3001.

### **3\. Frontend Access (Client)**

The frontend is a single, self-contained file (index.html).

1. **Run HTML:** Simply open the index.html file in your web browser.  
   * **Note:** Your browser must allow the HTML file to make API requests to http://localhost:3001. If you experience CORS issues, ensure your browser settings allow local file access to external resources, or serve the index.html file using a simple local web server (e.g., Python's http.server or Node's serve).

## **🚀 Key Technologies**

* **Frontend:** HTML5, CSS3 (Custom Styling), Vanilla JavaScript  
* **Backend:** Node.js, Express.js  
* **Database:** PostgreSQL (pg library)  
* **Data Structure:** Comprehensive SQL schema (f1.sql) covering drivers, constructors, races, sessions, and results.

## **💾 Database Schema (ER Diagram)**

The PostgreSQL database follows a classic relational structure to accurately map the Formula 1 season data, linking drivers to constructors, races to circuits, and all entities to session results.  
![er diag](https://github.com/user-attachments/assets/9b27f6df-9ce8-40e3-9ac8-3922281b1153)

