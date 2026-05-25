-- -----------------------------------------------
-- BACKGROUND
-- Dataset had two date formats. Split in Excel:
-- complaintcd  = correct date format (MM/DD/YY)
-- complaintswd = wrong date format (YY/MM/DD)
-- Cleaned separately then combined with UNION ALL
-- -----------------------------------------------


-- Preview raw tables
SELECT * FROM complaintcd LIMIT 10;
SELECT * FROM complaintswd LIMIT 10;

-- Row counts
SELECT COUNT(*) FROM complaintcd;
SELECT COUNT(*) FROM complaintswd;


-- Fix incorrect dates in complaintswd
SELECT
    "Date_received",
    MAKE_DATE(
        2000 + EXTRACT(DAY FROM "Date_received")::INT,
        EXTRACT(YEAR FROM "Date_received")::INT - 2000,
        EXTRACT(MONTH FROM "Date_received")::INT
    ) AS fixed_date
FROM complaintswd;

UPDATE complaintswd
SET "Date_received" =
    MAKE_DATE(
        2000 + EXTRACT(DAY FROM "Date_received")::INT,
        EXTRACT(YEAR FROM "Date_received")::INT - 2000,
        EXTRACT(MONTH FROM "Date_received")::INT
    );

SELECT "Date_received" FROM complaintswd LIMIT 10;


-- Standardize text casing
UPDATE complaintcd
SET
  "Product" = INITCAP(TRIM("Product")),
  "Sub_product" = INITCAP(TRIM("Sub_product")),
  "Issue" = INITCAP(TRIM("Issue")),
  "Company_response" = INITCAP(TRIM("Company_response")),
  "Submitted_via" = INITCAP(TRIM("Submitted_via"));

UPDATE complaintswd
SET
  "Product" = INITCAP(TRIM("Product")),
  "Sub_product" = INITCAP(TRIM("Sub_product")),
  "Issue" = INITCAP(TRIM("Issue")),
  "Company_response" = INITCAP(TRIM("Company_response")),
  "Submitted_via" = INITCAP(TRIM("Submitted_via"));


-- Handle missing values
UPDATE complaintcd
SET "State" = 'Unknown'
WHERE "State" IS NULL OR TRIM("State") = '';

UPDATE complaintcd
SET "Consumer_disputed" = 'Unknown'
WHERE "Consumer_disputed" IS NULL
OR TRIM("Consumer_disputed") = ''
OR "Consumer_disputed" = 'N/A';

UPDATE complaintswd
SET "State" = 'Unknown'
WHERE "State" IS NULL OR TRIM("State") = '';

UPDATE complaintswd
SET "Consumer_disputed" = 'Unknown'
WHERE "Consumer_disputed" IS NULL
OR TRIM("Consumer_disputed") = ''
OR "Consumer_disputed" = 'N/A';


-- Combine both cleaned tables
CREATE TABLE complaints AS
SELECT * FROM complaintcd
UNION ALL
SELECT * FROM complaintswd;

SELECT COUNT(*) FROM complaints;


-- Check for duplicates
SELECT complaint_id, COUNT(*)
FROM complaints
GROUP BY complaint_id
HAVING COUNT(*) > 1
LIMIT 10;


-- Remove duplicates
DELETE FROM complaints
WHERE ctid NOT IN (
    SELECT MIN(ctid)
    FROM complaints
    GROUP BY complaint_id
);

SELECT COUNT(*) FROM complaints;


-- Add date dimension columns
ALTER TABLE complaints
  ADD COLUMN complaint_year    INT,
  ADD COLUMN complaint_month   INT,
  ADD COLUMN complaint_quarter VARCHAR(10),
  ADD COLUMN month_name        VARCHAR(10);

UPDATE complaints SET
  complaint_year    = EXTRACT(YEAR FROM "Date_received"),
  complaint_month   = EXTRACT(MONTH FROM "Date_received"),
  complaint_quarter = EXTRACT(YEAR FROM "Date_received")::TEXT
                      || ' Q'
                      || EXTRACT(QUARTER FROM "Date_received")::TEXT,
  month_name        = TO_CHAR("Date_received", 'Month');


-- Final checks
SELECT COUNT(*) FROM complaints;
SELECT MIN("Date_received"), MAX("Date_received") FROM complaints;

SELECT
  SUM(CASE WHEN "Date_received" IS NULL THEN 1 ELSE 0 END) AS missing_dates,
  SUM(CASE WHEN "State" IS NULL THEN 1 ELSE 0 END) AS missing_states,
  SUM(CASE WHEN "Product" IS NULL THEN 1 ELSE 0 END) AS missing_products,
  SUM(CASE WHEN "Timely_response" IS NULL THEN 1 ELSE 0 END) AS missing_timely
FROM complaints;

SELECT
  "Date_received",
  complaint_year,
  complaint_month,
  complaint_quarter,
  month_name
FROM complaints
LIMIT 5;
