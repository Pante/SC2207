-- First result set: Top 3 Malls
SELECT TOP 3 
  m.address AS mall_address, 
  SUM(st.amount_spent) AS total_mall_earnings, 
  'Mall' AS entity_type
FROM 
  mall m
  JOIN shop s ON m.id = s.mall_id
  JOIN shop_transaction st ON s.id = st.shop_id
GROUP BY 
  m.address
ORDER BY 
  SUM(st.amount_spent) DESC;

-- Second result set: Top 3 Restaurants
SELECT TOP 3 
  rc.address AS restaurant_chain_address, 
  SUM(rt.amount_spent) AS total_restaurant_earnings, 
  'Restaurant' AS entity_type
FROM 
  restaurant_chain rc
  JOIN restaurant_outlet ro ON rc.id = ro.restaurant_id
  JOIN restaurant_transaction rt ON ro.id = rt.restaurant_outlet_id
GROUP BY 
  rc.address
ORDER BY 
  SUM(rt.amount_spent) DESC;
