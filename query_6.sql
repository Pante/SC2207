WITH mall_earnings AS (
  SELECT m.address AS mall_address, SUM(st.amount_spent) AS total_mall_earnings
  FROM mall m
  JOIN shop s ON m.id = s.mall_id
  JOIN shop_transaction st ON s.id = st.shop_id
  GROUP BY m.address
),
restaurant_earnings AS (
  SELECT rc.address AS restaurant_chain_address, SUM(rt.amount_spent) AS total_restaurant_earnings
  FROM restaurant_chain rc
  JOIN restaurant_outlet ro ON rc.id = ro.restaurant_id
  JOIN restaurant_transaction rt ON ro.id = rt.restaurant_outlet_id
  GROUP BY rc.address
)
SELECT 
  mall_address,
  total_mall_earnings,
  'Mall' AS entity_type
FROM mall_earnings
ORDER BY total_mall_earnings DESC
LIMIT 3
UNION
SELECT
  restaurant_chain_address,
  total_restaurant_earnings,
  'Restaurant' AS entity_type
FROM restaurant_earnings
ORDER BY total_restaurant_earnings DESC
LIMIT 3;
