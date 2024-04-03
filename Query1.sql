WITH 
PackageRelations AS (
    SELECT dp.id, r.user_1_id, r.user_2_id, r.type
    FROM day_package dp
    INNER JOIN related r ON dp.user_id = r.user_1_id OR dp.user_id = r.user_2_id
),
PackageCounts AS (
    SELECT dp.description, COUNT(DISTINCT CASE WHEN pr.type IN ('Family', 'Club') THEN pr.user_1_id END) AS participant_count
    FROM day_package dp
    JOIN PackageRelations pr ON dp.id = pr.id
    GROUP BY dp.description
)
SELECT pc.description, pc.participant_count AS popularity
FROM PackageCounts pc
ORDER BY popularity DESC;
