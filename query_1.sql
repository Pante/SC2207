WITH PackageRelations AS (
    SELECT dp.id, r.user_1_id, r.user_2_id, r.type
    FROM day_package dp
    INNER JOIN related r ON dp.user_id = r.user_1_id OR dp.user_id = r.user_2_id
),
PackageCounts AS (
    SELECT dp.description, 
           COUNT(DISTINCT CASE WHEN pr.type IN ('Family', 'Club') THEN pr.user_1_id END) AS participant_count,
           COUNT(DISTINCT CASE WHEN pr.type = 'Family' THEN pr.user_1_id END) AS family_count,
           COUNT(DISTINCT CASE WHEN pr.type = 'Club' THEN pr.user_1_id END) AS club_count
    FROM day_package dp
    JOIN PackageRelations pr ON dp.id = pr.id
    GROUP BY dp.description
),
FilteredPackages AS (
    SELECT pc.description, 
           pc.participant_count AS popularity,
           pc.family_count,
           pc.club_count,
           RANK() OVER (ORDER BY pc.participant_count DESC) AS popularity_rank
    FROM PackageCounts pc
    WHERE (pc.family_count = pc.participant_count OR pc.club_count = pc.participant_count)
)
SELECT description, popularity
FROM FilteredPackages
ORDER BY popularity desc;
