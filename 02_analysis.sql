-- Total complaints
SELECT COUNT(*) AS total_complaints
FROM complaints;


-- Overall KPI summary
SELECT
  COUNT(*) AS total_complaints,
  COUNT(DISTINCT "Company") AS total_companies,
  COUNT(DISTINCT "State") AS total_states,
  ROUND(100.0 * SUM(CASE WHEN "Timely_response" = 'Yes' THEN 1 ELSE 0 END)
    / COUNT(*), 1) AS timely_response_rate_pct,
  ROUND(100.0 * SUM(CASE WHEN "Company_response" LIKE 'Closed%' THEN 1 ELSE 0 END)
    / COUNT(*), 1) AS resolution_rate_pct,
  MIN("Date_received") AS earliest_complaint,
  MAX("Date_received") AS latest_complaint
FROM complaints;


-- Complaint volume by month
SELECT
  complaint_year,
  complaint_month,
  month_name,
  complaint_quarter,
  COUNT(*) AS total_complaints
FROM complaints
GROUP BY complaint_year, complaint_month, month_name, complaint_quarter
ORDER BY complaint_year, complaint_month;


-- Month over month growth rate
SELECT
  complaint_year,
  complaint_month,
  month_name,
  COUNT(*) AS total_complaints,
  LAG(COUNT(*)) OVER (ORDER BY complaint_year, complaint_month) AS prev_month,
  ROUND(100.0 * (COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY complaint_year, complaint_month))
    / LAG(COUNT(*)) OVER (ORDER BY complaint_year, complaint_month), 1) AS mom_growth_pct
FROM complaints
GROUP BY complaint_year, complaint_month, month_name
ORDER BY complaint_year, complaint_month;


-- Quarterly complaint volume
SELECT
  complaint_quarter,
  COUNT(*) AS total_complaints,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_total
FROM complaints
GROUP BY complaint_quarter
ORDER BY complaint_quarter;


-- Top complaint categories
SELECT
  "Product",
  COUNT(*) AS total_complaints,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_total,
  RANK() OVER (ORDER BY COUNT(*) DESC) AS complaint_rank
FROM complaints
GROUP BY "Product"
ORDER BY total_complaints DESC;


-- Top 10 issues
SELECT
  "Issue",
  COUNT(*) AS total_complaints,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_total,
  RANK() OVER (ORDER BY COUNT(*) DESC) AS issue_rank
FROM complaints
GROUP BY "Issue"
ORDER BY total_complaints DESC
LIMIT 10;


-- Top issues by product
SELECT
  "Product",
  "Issue",
  COUNT(*) AS total_complaints,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY "Product"), 1) AS pct_of_product,
  RANK() OVER (PARTITION BY "Product" ORDER BY COUNT(*) DESC) AS rank_within_product
FROM complaints
GROUP BY "Product", "Issue"
ORDER BY "Product", total_complaints DESC;


-- Product and subproduct breakdown
SELECT
  "Product",
  "Sub_product",
  COUNT(*) AS total_complaints,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY "Product"), 1) AS pct_of_product
FROM complaints
GROUP BY "Product", "Sub_product"
ORDER BY "Product", total_complaints DESC;


-- Subproducts ranked overall and within product
SELECT
  "Product",
  "Sub_product",
  COUNT(*) AS total_complaints,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY "Product"), 1) AS pct_of_product,
  RANK() OVER (ORDER BY COUNT(*) DESC) AS overall_rank,
  RANK() OVER (PARTITION BY "Product" ORDER BY COUNT(*) DESC) AS rank_within_product
FROM complaints
GROUP BY "Product", "Sub_product"
ORDER BY overall_rank;


-- Products ordered by total volume with subproducts beneath
SELECT
  "Product",
  "Sub_product",
  COUNT(*) AS total_complaints,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY "Product"), 1) AS pct_of_product,
  RANK() OVER (PARTITION BY "Product" ORDER BY COUNT(*) DESC) AS rank_within_product,
  SUM(COUNT(*)) OVER (PARTITION BY "Product") AS product_total
FROM complaints
GROUP BY "Product", "Sub_product"
ORDER BY product_total DESC, rank_within_product;


-- Top 3 parent product groups
SELECT
  "Product",
  "Sub_product",
  COUNT(*) AS total_complaints,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY "Product"), 1) AS pct_of_product,
  RANK() OVER (PARTITION BY "Product" ORDER BY COUNT(*) DESC) AS rank_within_product,
  SUM(COUNT(*)) OVER (PARTITION BY "Product") AS product_total
FROM complaints
GROUP BY "Product", "Sub_product"
ORDER BY product_total DESC, rank_within_product
LIMIT 3;


-- Timely vs late response by product
SELECT
  "Product",
  COUNT(*) AS total,
  SUM(CASE WHEN "Timely_response" = 'Yes' THEN 1 ELSE 0 END) AS on_time,
  SUM(CASE WHEN "Timely_response" = 'No' THEN 1 ELSE 0 END) AS late,
  ROUND(100.0 * SUM(CASE WHEN "Timely_response" = 'Yes' THEN 1 ELSE 0 END)
    / COUNT(*), 1) AS on_time_rate_pct
FROM complaints
GROUP BY "Product"
ORDER BY total DESC;


-- Company response breakdown
SELECT
  "Company_response",
  COUNT(*) AS total_complaints,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_total
FROM complaints
GROUP BY "Company_response"
ORDER BY total_complaints DESC;


-- Top companies by complaint volume
SELECT
  "Company",
  COUNT(*) AS total_complaints,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_total,
  RANK() OVER (ORDER BY COUNT(*) DESC) AS company_rank
FROM complaints
GROUP BY "Company"
ORDER BY total_complaints DESC
LIMIT 15;


-- Company response performance
SELECT
  "Company",
  COUNT(*) AS total_complaints,
  ROUND(100.0 * SUM(CASE WHEN "Timely_response" = 'Yes' THEN 1 ELSE 0 END)
    / COUNT(*), 1) AS on_time_rate_pct,
  SUM(CASE WHEN "Timely_response" = 'No' THEN 1 ELSE 0 END) AS late_responses,
  ROUND(100.0 * SUM(CASE WHEN "Company_response" LIKE 'Closed%' THEN 1 ELSE 0 END)
    / COUNT(*), 1) AS resolution_rate_pct
FROM complaints
GROUP BY "Company"
ORDER BY total_complaints DESC
LIMIT 15;


-- Companies ranked by late response count
SELECT
  "Company",
  COUNT(*) AS total_complaints,
  SUM(CASE WHEN "Timely_response" = 'No' THEN 1 ELSE 0 END) AS late_responses,
  RANK() OVER (ORDER BY SUM(CASE WHEN "Timely_response" = 'No' THEN 1 ELSE 0 END) DESC) AS late_rank
FROM complaints
GROUP BY "Company"
HAVING COUNT(*) > 100
ORDER BY late_responses DESC
LIMIT 10;


-- Complaints by state with response performance
SELECT
  "State",
  COUNT(*) AS total_complaints,
  ROUND(100.0 * SUM(CASE WHEN "Timely_response" = 'Yes' THEN 1 ELSE 0 END)
    / COUNT(*), 1) AS on_time_rate_pct
FROM complaints
WHERE "State" != 'Unknown'
GROUP BY "State"
ORDER BY total_complaints DESC;


-- Top 10 states by volume
SELECT
  "State",
  COUNT(*) AS total_complaints,
  RANK() OVER (ORDER BY COUNT(*) DESC) AS state_rank
FROM complaints
WHERE "State" != 'Unknown'
GROUP BY "State"
ORDER BY total_complaints DESC
LIMIT 10;


-- How complaints were submitted
SELECT
  "Submitted_via",
  COUNT(*) AS total_complaints,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_total
FROM complaints
GROUP BY "Submitted_via"
ORDER BY total_complaints DESC;


-- Submission channel by product
SELECT
  "Product",
  "Submitted_via",
  COUNT(*) AS total_complaints,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY "Product"), 1) AS pct_of_product
FROM complaints
GROUP BY "Product", "Submitted_via"
ORDER BY "Product", total_complaints DESC;


-- Running total of complaints by month
SELECT
  complaint_year,
  complaint_month,
  month_name,
  COUNT(*) AS monthly_complaints,
  SUM(COUNT(*)) OVER (ORDER BY complaint_year, complaint_month) AS running_total
FROM complaints
GROUP BY complaint_year, complaint_month, month_name
ORDER BY complaint_year, complaint_month;


-- Peak complaint month
SELECT
  complaint_year,
  complaint_month,
  month_name,
  COUNT(*) AS total_complaints
FROM complaints
GROUP BY complaint_year, complaint_month, month_name
ORDER BY total_complaints DESC
LIMIT 1;
