-- 1. Prescription history: join all four tables.
SELECT p.prescription_id, s.name AS student, s.program_name,
       d.name AS doctor, sd.drug_name, p.prescription_date,
       p.dose_mg, p.quantity_tablets
FROM Prescription AS p
JOIN Student AS s ON s.student_id = p.student_id
JOIN Doctor AS d ON d.doctor_id = p.doctor_id
JOIN StudyDrug AS sd ON sd.drug_id = p.drug_id
ORDER BY p.prescription_date, p.prescription_id;

-- 2. Frequently prescribed drugs: aggregation, DISTINCT and HAVING.
SELECT sd.drug_id, sd.drug_name, COUNT(*) AS prescription_count,
       COUNT(DISTINCT p.student_id) AS student_count,
       SUM(p.quantity_tablets) AS total_tablets
FROM StudyDrug AS sd
JOIN Prescription AS p ON p.drug_id = sd.drug_id
GROUP BY sd.drug_id, sd.drug_name
HAVING COUNT(*) >= 4
ORDER BY prescription_count DESC, sd.drug_id;

-- 3. Students without prescriptions: correlated NOT EXISTS.
SELECT s.student_id, s.name, s.program_name
FROM Student AS s
WHERE NOT EXISTS (
    SELECT 1 FROM Prescription AS p WHERE p.student_id = s.student_id
)
ORDER BY s.student_id;

-- 4. Latest prescription per student: CTE and window function.
-- The ID breaks ties when two prescriptions share a date.
WITH ranked_prescriptions AS (
    SELECT p.*,
           ROW_NUMBER() OVER (
               PARTITION BY student_id
               ORDER BY prescription_date DESC, prescription_id DESC
           ) AS row_num
    FROM Prescription AS p
)
SELECT s.name, rp.prescription_id, rp.prescription_date, sd.drug_name
FROM ranked_prescriptions AS rp
JOIN Student AS s ON s.student_id = rp.student_id
JOIN StudyDrug AS sd ON sd.drug_id = rp.drug_id
WHERE rp.row_num = 1
ORDER BY rp.student_id;
