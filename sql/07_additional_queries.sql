-- Queries 1 and 2 use the fictional prescription data; 3 and 4 use the FDA data.

-- 7.1: Prescriptions by study programme: LEFT JOIN keeps students without prescriptions.
-- Question: Do some programmes have more students with prescriptions than others?
-- Two fictional students per programme cannot show real programme differences.
SELECT s.program_name,
       COUNT(DISTINCT s.student_id) AS students,
       COUNT(DISTINCT p.student_id) AS students_with_prescription,
       ROUND(100 * COUNT(DISTINCT p.student_id) / COUNT(DISTINCT s.student_id))
           AS pct_with_prescription,
       COUNT(p.prescription_id) AS prescriptions,
       COALESCE(SUM(p.quantity_tablets), 0) AS total_tablets
FROM Student AS s
LEFT JOIN Prescription AS p ON p.student_id = s.student_id
GROUP BY s.program_name
ORDER BY pct_with_prescription DESC, prescriptions DESC, s.program_name;

-- 7.2: Days between repeat prescriptions of the same drug: LAG window function.
-- Question: How soon do students receive the same drug again, and does the dose change?
-- Shortest gaps first. A short gap does not prove misuse: the schema does not record daily tablet intake, and doses can change.
WITH prescription_gaps AS (
    SELECT p.*,
           LAG(p.prescription_date) OVER w AS previous_date,
           LAG(p.dose_mg) OVER w AS previous_dose_mg
    FROM Prescription AS p
    WINDOW w AS (PARTITION BY p.student_id, p.drug_id
                 ORDER BY p.prescription_date, p.prescription_id)
)
SELECT s.name AS student, sd.drug_name, pg.prescription_id,
       pg.previous_date, pg.prescription_date,
       DATEDIFF(pg.prescription_date, pg.previous_date) AS days_since_previous,
       pg.previous_dose_mg, pg.dose_mg
FROM prescription_gaps AS pg
JOIN Student AS s ON s.student_id = pg.student_id
JOIN StudyDrug AS sd ON sd.drug_id = pg.drug_id
WHERE pg.previous_date IS NOT NULL
ORDER BY days_since_previous, pg.prescription_id;

-- 7.3: Recalls per year with a running total: change over time.
-- Question: Have methylphenidate recalls become more or less frequent over time?
-- Counts reflect FDA enforcement reports, not how often products were used.
SELECT YEAR(recall_initiation_date) AS recall_year,
       COUNT(*) AS recall_count,
       SUM(classification = 'Class II') AS class_ii,
       SUM(classification = 'Class III') AS class_iii,
       SUM(COUNT(*)) OVER (ORDER BY YEAR(recall_initiation_date)) AS cumulative_recalls
FROM FDA_Recall
GROUP BY recall_year
ORDER BY recall_year;

-- 7.4: Recall reasons grouped from free text: CASE expression and a window total.
-- Question: Why are methylphenidate products recalled, and are the problems recent?
-- Groups follow the FDA category at the start of each reason. Product defects do not indicate misuse.
SELECT CASE
           WHEN reason_for_recall LIKE 'Defective Delivery System%'
             OR reason_for_recall LIKE 'Miscalibrated%' THEN 'Defective delivery system'
           WHEN reason_for_recall LIKE 'Failed Dissolution%' THEN 'Failed dissolution'
           WHEN reason_for_recall LIKE 'Subpotent%' THEN 'Subpotent drug'
           WHEN reason_for_recall LIKE 'Presence of Foreign Substance%' THEN 'Foreign substance'
           WHEN reason_for_recall LIKE 'Labeling%' THEN 'Labeling'
           WHEN reason_for_recall LIKE 'CGMP%' THEN 'Manufacturing practice (CGMP)'
           ELSE 'Other'
       END AS reason_group,
       COUNT(*) AS recall_count,
       ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER ()) AS pct_of_recalls,
       MIN(YEAR(recall_initiation_date)) AS first_year,
       MAX(YEAR(recall_initiation_date)) AS latest_year
FROM FDA_Recall
GROUP BY reason_group
ORDER BY recall_count DESC, reason_group;
