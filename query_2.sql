WITH family_activities AS (
    SELECT
        LEAST(r.user_1_id, r.user_2_id) AS user_id,
        GREATEST(r.user_1_id, r.user_2_id) AS related_user_id,
        'shopping' AS activity_type,
        CASE
            WHEN dp.id IS NOT NULL THEN 'Used Day Package'
            ELSE 'Did not use Day Package'
        END AS day_package_usage
    FROM related r
    JOIN shop_transaction st1 ON r.user_1_id = st1.user_id
    JOIN shop_transaction st2 ON r.user_2_id = st2.user_id
        AND st1.started_at <= st2.ended_at
        AND st1.ended_at >= st2.started_at
    LEFT JOIN day_package dp ON dp.user_id IN (r.user_1_id, r.user_2_id)
    WHERE r.type = 'Family'
    UNION ALL
    SELECT
        LEAST(r.user_1_id, r.user_2_id) AS user_id,
        GREATEST(r.user_1_id, r.user_2_id) AS related_user_id,
        'dining' AS activity_type,
        CASE
            WHEN dp.id IS NOT NULL THEN 'Used Day Package'
            ELSE 'Did not use Day Package'
        END AS day_package_usage
    FROM related r
    JOIN restaurant_transaction rt1 ON r.user_1_id = rt1.user_id
    JOIN restaurant_transaction rt2 ON r.user_2_id = rt2.user_id
        AND rt1.started_at <= rt2.ended_at
        AND rt1.ended_at >= rt2.started_at
    LEFT JOIN day_package dp ON dp.user_id IN (r.user_1_id, r.user_2_id)
    WHERE r.type = 'Family'
),

family_activity_counts AS (
 SELECT
  user_id,
  related_user_id,
  COUNT(*) AS total_family_activities,
  SUM(CASE WHEN day_package_usage = 'Used Day Package' THEN 1 ELSE 0 END) AS day_package_activities
 FROM family_activities
 GROUP BY user_id, related_user_id
),

total_activities AS (
 SELECT
  user_id,
  COUNT(*) AS total_activities
 FROM (
  SELECT user_id FROM shop_transaction
  UNION ALL
  SELECT user_id FROM restaurant_transaction
 ) t
 GROUP BY user_id
),

family_day_package_usage AS (
    SELECT DISTINCT
        LEAST(fac.user_id, fac.related_user_id) AS user_id,
        GREATEST(fac.user_id, fac.related_user_id) AS related_user_id,
        CASE
            WHEN dp.id IS NOT NULL THEN 'Used Day Package'
            WHEN EXISTS (
                SELECT 1
                FROM related r
                JOIN day_package dp2 ON dp2.user_id IN (r.user_1_id, r.user_2_id)
                WHERE r.type = 'Family'
                  AND (
                    (r.user_1_id = fac.user_id AND r.user_2_id = fac.related_user_id)
                    OR (r.user_1_id = fac.related_user_id AND r.user_2_id = fac.user_id)
                  )
            ) THEN 'Used Day Package'
            ELSE 'Did not use Day Package'
        END AS day_package_usage,
        fac.total_family_activities,
        ta.total_activities
    FROM family_activity_counts fac
    JOIN total_activities ta ON fac.user_id = ta.user_id
    LEFT JOIN day_package dp ON dp.user_id IN (fac.user_id, fac.related_user_id)
)

SELECT DISTINCT
    user_id,
    related_user_id,
    day_package_usage
FROM family_day_package_usage fdpu
WHERE total_family_activities >= 2
AND total_family_activities >= 0.5 * total_activities;