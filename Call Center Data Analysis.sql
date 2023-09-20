CREATE DATABASE callcenterDB;
USE callcenterDB;
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

SELECT * FROM calls LIMIT 10;

-- -----------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------- Cleaning our data -------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------


-- The call_timestamp is a string, so we need to convert it to a date.

SET SQL_SAFE_UPDATES = 0;

UPDATE calls SET call_timestamp = str_to_date(call_timestamp, "%m/%d/%Y");

UPDATE calls SET csat_score = NULL WHERE csat_score = 0;

SET SQL_SAFE_UPDATES = 1;

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

-- The count and precentage from total of each of the distinct values we got:
SELECT sentiment, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100, 1) AS pct
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT reason, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100, 1) AS pct
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT channel, COUNT(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100, 1) AS pct
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT response_time, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) *100,1) AS pct
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT call_center, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) *100,1) AS PCT
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT state, COUNT(*) FROM calls GROUP BY 1 ORDER BY 2 DESC;

SELECT DAYNAME(call_timestamp) as Day_of_call, COUNT(*) num_of_calls FROM calls GROUP BY 1 ORDER BY 2 DESC;


-- Aggregations :

 








