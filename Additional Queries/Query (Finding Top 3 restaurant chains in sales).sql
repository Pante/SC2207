--Finding the top 3 restaurant chains with the highest number of transactions and their respective total sales amount.

WITH RestaurantTransactions AS (
    SELECT rc.id AS restaurant_chain_id, rt.amount_spent
    FROM restaurant_chain rc
    JOIN restaurant_outlet ro ON rc.id = ro.restaurant_id
    JOIN restaurant_transaction rt ON ro.id = rt.restaurant_outlet_id
)
SELECT TOP 3 restaurant_chain_id, COUNT(*) AS total_transactions, SUM(amount_spent) AS total_sales
FROM RestaurantTransactions
GROUP BY restaurant_chain_id
ORDER BY total_transactions DESC;
