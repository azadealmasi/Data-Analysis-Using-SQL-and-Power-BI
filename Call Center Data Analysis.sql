-- Create a new database named "callcenterDB."
CREATE DATABASE callcenterDB;	

-- Switch to the "callcenterDB" database to work within it.
USE callcenterDB;

-- Create a table called "calls" to store call center data with various columns.
CREATE TABLE calls(
ID CHAR(50),
cust_name CHAR(50),
sentiment CHAR(20),
csat_score INT,
call_timestamp CHAR(10),
reason CHAR(20),
city CHAR(20),
state CHAR(20),
channel CHAR(20),
response_time CHAR(20),
call_duration_minutes INT,
call_center CHAR(20)
);

-- Retrieve the first 10 rows from the "calls" table for inspection.
SELECT * FROM calls LIMIT 10;

-- -----------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------- Cleaning the data -------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------


-- ------The call_timestamp is a string, so we need to convert it to a date.------

-- Disable safe updates to allow potentially unsafe queries
SET SQL_SAFE_UPDATES = 0;

-- Convert the "call_timestamp" column values from a string format to a date format
UPDATE calls SET call_timestamp = str_to_date(call_timestamp, "%m/%d/%Y");

-- Set the "csat_score" column to NULL where it currently has a value of 0
UPDATE calls SET csat_score = NULL WHERE csat_score = 0;

-- Re-enable safe updates to ensure the safety of future queries
SET SQL_SAFE_UPDATES = 1;

-- Retrieve the first 10 rows from the "calls" table
SELECT * FROM calls LIMIT 10;


-- -----------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------- Exploring our data ------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------


-- lets see the shape pf our data, i.e, the number of columns and rows
SELECT COUNT(*) AS rows_num FROM calls;
SELECT COUNT(*) AS cols_num FROM information_schema.columns WHERE table_name = 'calls' ;

-- Checking the distinct values of some columns 
SELECT DISTINCT sentiment FROM calls;
SELECT DISTINCT reason FROM calls;
SELECT DISTINCT channel FROM calls;
SELECT DISTINCT response_time FROM calls;
SELECT DISTINCT call_center FROM calls;

-- ------The count and precentage from total of each of the distinct values we got:------

-- Calculate the distribution of sentiment in calls, including count and percentage, and order by percentage in descending order.
SELECT sentiment, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100, 1) AS pct
FROM calls GROUP BY 1 ORDER BY 3 DESC;

-- To see the distribution of our calls among different columns. Let’s see the reason column
SELECT reason, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100, 1) AS pct
FROM calls GROUP BY 1 ORDER BY 3 DESC;

-- Count and calculate the percentage of calls by channel, ordered by percentage in descending order.
SELECT channel, COUNT(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100, 1) AS pct
FROM calls GROUP BY 1 ORDER BY 3 DESC;

-- Count and calculate the percentage of calls by response time, ordered by percentage in descending order.
SELECT response_time, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) *100,1) AS pct
FROM calls GROUP BY 1 ORDER BY 3 DESC;

-- Count and calculate the percentage of calls by call center, ordered by percentage in descending order.
SELECT call_center, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) *100,1) AS PCT
FROM calls GROUP BY 1 ORDER BY 3 DESC;

-- Count the number of calls by state, ordered by the count in descending order.
SELECT state, COUNT(*) FROM calls GROUP BY 1 ORDER BY 2 DESC;

-- which day has the most calls?
SELECT DAYNAME(call_timestamp) as Day_of_call, COUNT(*) num_of_calls FROM calls GROUP BY 1 ORDER BY 2 DESC;


-- ------Aggregations:------

SELECT MIN(csat_score) AS min_score, MAX(csat_score) AS max_score, ROUND(AVG(csat_score),1) AS avg_score
FROM calls WHERE csat_score != 0; 

SELECT MIN(call_timestamp) AS earliest_date, MAX(call_timestamp) AS most_recent FROM calls;

-- The min, max and average call duration in minutes
SELECT MIN(call_duration_minutes) AS min_call_duration, MAX(call_duration_minutes) AS max_call_duration, AVG(call_duration_minutes) AS avg_call_duration FROM calls;

-- Here we are checking how many calls are within, below or above the Service-Level -Agreement time
SELECT call_center, response_time, COUNT(*) AS count
FROM calls GROUP BY 1,2 ORDER BY 1,3 DESC;

-- Calculate the average call duration in minutes for each call center.
SELECT call_center, AVG(call_duration_minutes) FROM calls GROUP BY 1 ORDER BY 2 DESC;

-- Calculate the average call duration in minutes for each channel.
SELECT channel, AVG(call_duration_minutes) FROM calls GROUP BY 1 ORDER BY 2 DESC;

-- Count the number of calls for each state and display the results in descending order of call counts.
SELECT state, COUNT(*) FROM calls GROUP BY 1 ORDER BY 2 DESC;

-- Count calls by state and reason, ordered by state, reason, and count.
SELECT state, reason, COUNT(*) FROM calls GROUP BY 1,2 ORDER BY 1,2,3 DESC;


-- Count calls by state and sentiment, ordered by state and count in descending order.
SELECT state, sentiment , COUNT(*) FROM calls GROUP BY 1,2 ORDER BY 1,3 DESC;

-- Calculate and order the average CSAT scores by state, excluding scores of 0.
SELECT state, AVG(csat_score) as avg_csat_score FROM calls WHERE csat_score != 0 GROUP BY 1 ORDER BY 2 DESC;

-- Calculate the average call duration for each sentiment and sort in descending order.
SELECT sentiment, AVG(call_duration_minutes) FROM calls GROUP BY 1 ORDER BY 2 DESC;

-- Find the maximum call duration for each call timestamp and order the results by max duration in descending order.
SELECT call_timestamp, MAX(call_duration_minutes) AS max_call_duration
FROM calls
GROUP BY call_timestamp
ORDER BY max_call_duration DESC;

SHOW VARIABLES LIKE 'secure_file_priv';
SHOW VARIABLES LIKE 'datadir';

SELECT * FROM calls
INTO OUTFILE 'callcenter_prepared.csv'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';






 








