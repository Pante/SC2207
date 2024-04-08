WITH shop_earnings AS (
  SELECT 
    m.address AS mall_address,
    SUM(st.amount_spent) AS total_mall_shop_earnings
  FROM mall m
  INNER JOIN shop s ON m.id = s.mall_id
  INNER JOIN shop_transaction st ON s.id = st.shop_id
  GROUP BY m.address
),
restaurant_earnings AS (
  SELECT
    m.address AS mall_address,
    SUM(COALESCE(rt.amount_spent, 0)) AS total_mall_restaurant_earnings
  FROM mall m
  LEFT JOIN restaurant_outlet ro ON m.id = ro.mall_id
  LEFT JOIN restaurant_transaction rt ON ro.id = rt.restaurant_outlet_id
  GROUP BY m.address
)
SELECT TOP 3
  se.mall_address,
  se.total_mall_shop_earnings,
  re.total_mall_restaurant_earnings,
  se.total_mall_shop_earnings + COALESCE(re.total_mall_restaurant_earnings, 0) AS total_mall_earnings,
  'Mall' AS entity_type
FROM shop_earnings se
LEFT JOIN restaurant_earnings re ON se.mall_address = re.mall_address
ORDER BY se.total_mall_shop_earnings DESC;
