--Top 3 malls with the highest number of complaints and the most common complaint type for each mall

WITH MallComplaints AS (
    SELECT m.id AS mall_id, c.id AS complaint_id, c.status, 
        CASE 
            WHEN cs.shop_id IS NOT NULL THEN 'Shop'
            WHEN cr.restaurant_outlet_id IS NOT NULL THEN 'Restaurant'
        END AS complaint_type
    FROM mall m
    LEFT JOIN shop s ON m.id = s.mall_id
    LEFT JOIN complaint_on_shop cs ON s.id = cs.shop_id
    LEFT JOIN complaint c ON cs.complaint_id = c.id
    LEFT JOIN restaurant_outlet ro ON m.id = ro.mall_id
    LEFT JOIN complaint_on_restaurant_outlet cr ON ro.id = cr.restaurant_outlet_id
    WHERE cs.shop_id IS NOT NULL OR cr.restaurant_outlet_id IS NOT NULL
),
MallComplaintCounts AS (
    SELECT mall_id, complaint_type, COUNT(*) AS complaint_count
    FROM MallComplaints
    GROUP BY mall_id, complaint_type
),
MallComplaintSummary AS (
    SELECT mall_id, complaint_type, complaint_count,
        ROW_NUMBER() OVER (PARTITION BY mall_id ORDER BY complaint_count DESC) AS row_num
    FROM MallComplaintCounts
)
SELECT TOP 3 mall_id, complaint_type AS most_common_complaint_type, SUM(complaint_count) AS total_complaints
FROM MallComplaintSummary
WHERE row_num = 1
GROUP BY mall_id, complaint_type
ORDER BY total_complaints DESC;
