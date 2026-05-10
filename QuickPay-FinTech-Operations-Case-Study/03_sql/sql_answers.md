# SQL Answers

## Q1
### Query
SELECT status, COUNT(*) as count FROM cleaned_transactions GROUP BY status;
### Result Summary
    status  count
  captured     19
chargeback      4
    failed      7

## Q2
### Query
SELECT merchant_name, SUM(amount_usd) as total_captured_gmv FROM cleaned_transactions WHERE status = 'captured' GROUP BY merchant_name;
### Result Summary
merchant_name  total_captured_gmv
   Alpha Mart             29984.5
 Beta  Stores             11940.0
  Beta Stores             21491.0
  City Pharma              8640.0
Delta Travels             10300.0

## Q3
### Query
SELECT merchant_name, SUM(amount_usd) as total_captured_gmv FROM cleaned_transactions WHERE status = 'captured' GROUP BY merchant_name ORDER BY total_captured_gmv DESC LIMIT 10;
### Result Summary
merchant_name  total_captured_gmv
   Alpha Mart             29984.5
  Beta Stores             21491.0
 Beta  Stores             11940.0
Delta Travels             10300.0
  City Pharma              8640.0

## Q4
### Query
SELECT transaction_date, SUM(amount_usd) as daily_gmv, COUNT(*) as successful_count FROM cleaned_transactions WHERE status = 'captured' GROUP BY transaction_date ORDER BY transaction_date;
### Result Summary
transaction_date  daily_gmv  successful_count
      2026-03-01    26382.0                 5
      2026-03-02    11080.0                 3
      2026-03-03    16031.5                 4
      2026-03-04    13920.0                 4
      2026-03-05     6136.0                 1
      2026-03-06     8806.0                 2

## Q5
### Query
SELECT merchant_name, SUM(CASE WHEN status = 'chargeback' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) as chargeback_ratio FROM cleaned_transactions GROUP BY merchant_name HAVING chargeback_ratio > 0.01;
### Result Summary
merchant_name    ratio
  Alpha  Mart 0.333333
  Beta Stores 0.200000
Delta Travels 0.250000
     Eco Home 0.500000

## Q6
### Query
SELECT gateway_region, AVG(risk_score) as avg_risk, COUNT(*) as transaction_count FROM cleaned_transactions GROUP BY gateway_region HAVING avg_risk > 50 AND transaction_count > 20;
### Result Summary
Empty DataFrame
Columns: [gateway_region, avg_risk, transaction_count]
Index: []

## Q7
### Query
SELECT user_id FROM cleaned_transactions WHERE status IN ('failed', 'chargeback') GROUP BY user_id, DATE(transaction_date) HAVING COUNT(*) >= 3;
### Result Summary
U008

## Q8
### Query
SELECT merchant_name, SUM(CASE WHEN status = 'chargeback' THEN 1 ELSE 0 END) as chargeback_count, COUNT(DISTINCT user_id) as unique_affected_users, SUM(CASE WHEN status = 'chargeback' THEN amount_usd ELSE 0 END) as chargeback_amount FROM cleaned_transactions GROUP BY merchant_name;
### Result Summary
merchant_name  chargeback_count  unique_affected_users  chargeback_amount
  Alpha  Mart                 1                      1             5400.0
  Beta Stores                 1                      1             1711.0
Delta Travels                 1                      1             2500.0
     Eco Home                 1                      1             6649.0
