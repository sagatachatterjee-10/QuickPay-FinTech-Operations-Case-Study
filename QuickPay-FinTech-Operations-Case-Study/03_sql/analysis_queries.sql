-- Q1
SELECT status, COUNT(*) as count
FROM cleaned_transactions
GROUP BY status;

-- Q2
SELECT merchant_name, SUM(amount_usd) as total_captured_gmv
FROM cleaned_transactions
WHERE status = 'captured'
GROUP BY merchant_name;

-- Q3
SELECT merchant_name, SUM(amount_usd) as total_captured_gmv
FROM cleaned_transactions
WHERE status = 'captured'
GROUP BY merchant_name
ORDER BY total_captured_gmv DESC
LIMIT 10;

-- Q4
SELECT transaction_date, SUM(amount_usd) as daily_gmv, COUNT(*) as successful_count
FROM cleaned_transactions
WHERE status = 'captured'
GROUP BY transaction_date
ORDER BY transaction_date;

-- Q5
SELECT merchant_name, 
       SUM(CASE WHEN status = 'chargeback' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) as chargeback_ratio
FROM cleaned_transactions
GROUP BY merchant_name
HAVING chargeback_ratio > 0.01;

-- Q6
SELECT gateway_region, AVG(risk_score) as avg_risk, COUNT(*) as transaction_count
FROM cleaned_transactions
GROUP BY gateway_region
HAVING avg_risk > 50 AND transaction_count > 20;

-- Q7
SELECT user_id
FROM cleaned_transactions
WHERE status IN ('failed', 'chargeback')
GROUP BY user_id, DATE(transaction_date)
HAVING COUNT(*) >= 3;

-- Q8
SELECT merchant_name, 
       SUM(CASE WHEN status = 'chargeback' THEN 1 ELSE 0 END) as chargeback_count,
       COUNT(DISTINCT user_id) as unique_affected_users,
       SUM(CASE WHEN status = 'chargeback' THEN amount_usd ELSE 0 END) as chargeback_amount
FROM cleaned_transactions
GROUP BY merchant_name;