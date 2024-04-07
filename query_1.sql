/* join day_package and related tables based on the matching user_id*/
WITH PackageRelations AS (
    SELECT dp.id, r.user_1_id, r.user_2_id, r.type
    FROM day_package dp
    INNER JOIN related r ON dp.user_id = r.user_1_id OR dp.user_id = r.user_2_id
),

/* join day_package with PackageRelations with matching package id*/
/* Select the package name (description) and the user counts of package*/
/* participant_count is the count where all users of that package are either family or club*/
/* family_count is the count where all users of that package are related by family*/
/* club_count is the count where all users of that package are related by club*/
PackageCounts AS (
    SELECT dp.description, 
           COUNT(DISTINCT CASE WHEN pr.type IN ('Family', 'Club') THEN pr.user_1_id END) AS participant_count,
           COUNT(DISTINCT CASE WHEN pr.type = 'Family' THEN pr.user_1_id END) AS family_count,
           COUNT(DISTINCT CASE WHEN pr.type = 'Club' THEN pr.user_1_id END) AS club_count
    FROM day_package dp
    JOIN PackageRelations pr ON dp.id = pr.id
    GROUP BY dp.description
),

/* Select only packages where pc.family_count = pc.participant_count OR pc.club_count = pc.participant_count*/
FilteredPackages AS (
    SELECT pc.description, 
           pc.participant_count AS popularity,
           pc.family_count,
           pc.club_count,
    FROM PackageCounts pc
    WHERE (pc.family_count = pc.participant_count OR pc.club_count = pc.participant_count)
)
    
SELECT description, popularity
FROM FilteredPackages
ORDER BY popularity desc;
