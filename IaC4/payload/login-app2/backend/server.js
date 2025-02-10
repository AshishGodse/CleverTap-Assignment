require("dotenv").config(); // Load environment variables
const express = require("express");
const mysql = require("mysql");
const bodyParser = require("body-parser");
const cors = require("cors");
const app = express();
app.use(express.json())
const port = process.env.PORT || 3000; // Middleware app.use(bodyParser.json()); app.use(cors()); // MySQL Connection
const db = mysql.createConnection({
  port: process.env.DB_PORT,
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

db.connect((err) => {
  if (err) throw err;
  console.log("MySQL Connected");
}); // Create users table if it doesn't exist

db.query(
  ` CREATE TABLE IF NOT EXISTS users ( id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(255) NOT NULL, password VARCHAR(255) NOT NULL ) `,
  (err) => {
    if (err) throw err;
    console.log("Users table created or already exists");
  }
); // Login endpoint
app.post("/api/login", (req, res) => {
  const { username, password } = req.body;
  const query = "SELECT * FROM users WHERE username = ? AND password = ?";
  db.query(query, [username, password], (err, results) => {
    if (err) throw err;
    if (results.length > 0) {
      res.json({ success: true, message: "Login successful" });
    } else {
      res.status(401).json({ success: false, message: "Invalid credentials" });
    }
  });
}); // Registration endpoint
app.post("/api/register", (req, res) => {
  const { username, password } = req.body; // Check if the username already exists
  const checkUserQuery = "SELECT * FROM users WHERE username = ?";
  db.query(checkUserQuery, [username], (err, results) => {
    if (err) throw err;
    if (results.length > 0) {
      res
        .status(400)
        .json({ success: false, message: "Username already exists" });
    } else {
      // Insert new user into the database
      const insertUserQuery =
        "INSERT INTO users (username, password) VALUES (?, ?)";
      db.query(insertUserQuery, [username, password], (err, results) => {
        if (err) throw err;
        res.json({ success: true, message: "User registered successfully" });
      });
    }
  });
}); // Start the server
app.listen(port, () => {
  console.log(`Server running on ${port}`);
});
