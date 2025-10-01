SQL Part:
The SQL script creates a Bank Database with customers, accounts, loans, transactions, etc.
Inserts data for customers 
It also adds a special CustomerAudit table for logging user events (logins, clicks, logouts).
Views are created to analyze data, for example:
v_Sessions – pairs login and logout times
v_SessionMetrics – calculates session lengths
v_SessionAnomalies – flags suspicious activity
v_FailureBursts – detects repeated failed logins
v_TopUsersByTime – shows most active users

Python part: 
The Python script (producer.py) simulates user events and inserts them into the CustomerAudit table.
Uses Faker to generate fake IPs and random to choose actions (LOGIN, CLICK, LOGOUT, etc.).
Runs continuously, creating events in real-time until stopped.
Purpose: to feed live data into the SQL database
