WITH RestaurantVisits AS (
  SELECT rt.user_id, ro.mall_id, COUNT(DISTINCT ro.restaurant_id) AS num_restaurants_visited
  FROM restaurant_transaction rt
  JOIN restaurant_outlet ro ON rt.restaurant_outlet_id = ro.id
  GROUP BY rt.user_id, ro.mall_id
),
MallRestaurantCounts AS (
  SELECT mall_id, COUNT(DISTINCT restaurant_id) AS num_restaurants
  FROM restaurant_outlet
  GROUP BY mall_id
),
UserMallVisits AS (
  SELECT rv.user_id, rv.mall_id,
    CASE WHEN rv.num_restaurants_visited = mrc.num_restaurants THEN 1 ELSE 0 END AS visited_all,
    CASE WHEN rv.num_restaurants_visited = 0 THEN 1 ELSE 0 END AS visited_none
  FROM RestaurantVisits rv 
  INNER JOIN MallRestaurantCounts mrc ON rv.mall_id = mrc.mall_id
)
SELECT user_id
FROM UserMallVisits
GROUP BY user_id
HAVING SUM(visited_all) > 0 AND SUM(visited_none) = (COUNT(*) - 1);
