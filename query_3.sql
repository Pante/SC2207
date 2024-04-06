SELECT 
    mall.id,
    mall.address,
    COUNT(recommendation.mall_id) AS recommendation_count
FROM 
    recommendation
JOIN 
    mall ON recommendation.mall_id = mall.id
GROUP BY 
    mall.id, mall.address
ORDER BY 
    recommendation_count DESC;