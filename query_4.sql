-- We first find the transactions that occurred in shops & restaurants and merge the results into all_transactions.
-- We then find the total amount spent by compulsive shoppers in December 2023 and store the results in total_spent.
-- Next, we find the compulsive shoppers' date of births by performing an inner join with user_account.
-- Lastly, we sort the compulsive shoppers by their date of births and take the first row returned (the youngest shopper).

WITH total_spent AS (
  SELECT user_id, SUM(amount_spent) AS total_spent FROM (
    SELECT user_id, started_at, ended_at, amount_spent FROM shop_transaction UNION ALL
    SELECT user_id, started_at, ended_at, amount_spent FROM restaurant_transaction
  ) AS all_transactions
  WHERE '2023-12-01 00:00:00' <= started_at AND ended_at < '2024-01-01 00:00:00'
  GROUP BY user_id
  HAVING 5 <= COUNT(*)
)
SELECT TOP 1 total_spent.user_id, total_spent.total_spent, user_account.date_of_birth FROM total_spent
  INNER JOIN user_account ON total_spent.user_id = user_account.id
  ORDER BY user_account.date_of_birth DESC;