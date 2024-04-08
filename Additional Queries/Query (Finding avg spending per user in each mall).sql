--Finding the average spending per visit for each user in each mall, considering both shopping and dining transactions.

WITH UserMallSpending AS (
    SELECT ua.id AS user_id, m.id AS mall_id, 
        SUM(st.amount_spent) AS total_shop_spending, 
        SUM(rt.amount_spent) AS total_restaurant_spending,
        COUNT(DISTINCT st.started_at) AS num_shop_visits,
        COUNT(DISTINCT rt.started_at) AS num_restaurant_visits
    FROM user_account ua
    CROSS JOIN mall m
    LEFT JOIN shop s ON m.id = s.mall_id
    LEFT JOIN shop_transaction st ON s.id = st.shop_id AND ua.id = st.user_id
    LEFT JOIN restaurant_outlet ro ON m.id = ro.mall_id
    LEFT JOIN restaurant_transaction rt ON ro.id = rt.restaurant_outlet_id AND ua.id = rt.user_id
    GROUP BY ua.id, m.id
)
SELECT user_id, mall_id, 
    (total_shop_spending + total_restaurant_spending) / (num_shop_visits + num_restaurant_visits) AS avg_spending_per_visit
FROM UserMallSpending
WHERE total_shop_spending+total_restaurant_spending > 0
ORDER BY user_id, mall_id;
