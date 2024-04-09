-- TOP 3 MALLS BY EARNINGS
WITH shop_earnings AS (
  SELECT 
    m.address AS mall_address,
    m.id AS mall_id,
    SUM(st.amount_spent) AS total_mall_shop_earnings
  FROM mall m
  INNER JOIN shop s ON m.id = s.mall_id
  INNER JOIN shop_transaction st ON s.id = st.shop_id
  GROUP BY m.address,m.id
),
restaurant_earnings AS (
  SELECT
    m.address AS mall_address,
    SUM(rt.amount_spent) AS total_mall_restaurant_earnings
  FROM mall m
  LEFT JOIN restaurant_outlet ro ON m.id = ro.mall_id
  LEFT JOIN restaurant_transaction rt ON ro.id = rt.restaurant_outlet_id
  GROUP BY m.address
)
SELECT TOP 3
  se.mall_id,
  se.mall_address,
  se.total_mall_shop_earnings,
  re.total_mall_restaurant_earnings,
  se.total_mall_shop_earnings + re.total_mall_restaurant_earnings AS total_mall_earnings,
  'Mall' AS entity_type
FROM shop_earnings se
LEFT JOIN restaurant_earnings re ON se.mall_address = re.mall_address
ORDER BY se.total_mall_shop_earnings DESC;

-- TOP 3 RESTAURANTS BY EARNINGS
WITH RestaurantEarnings AS (
    SELECT ro.id AS outlet_id,
           ro.restaurant_id,
           rc.address AS restaurant_address,
           m.address AS mall_address,
           CASE WHEN ro.mall_id IS NULL THEN 'Independent' ELSE 'Mall' END AS outlet_type,
           SUM(rt.amount_spent) AS total_earnings
    FROM restaurant_transaction rt
    INNER JOIN restaurant_outlet ro ON rt.restaurant_outlet_id = ro.id
    INNER JOIN restaurant_chain rc ON ro.restaurant_id = rc.id
    LEFT JOIN mall m ON ro.mall_id = m.id
    GROUP BY ro.id, ro.restaurant_id, rc.address, m.address, ro.mall_id
)
SELECT TOP 3 outlet_id, total_earnings, restaurant_address, mall_address, outlet_type
FROM RestaurantEarnings
ORDER BY total_earnings DESC;
