-- Run in one connection after 01_schema.sql and 02_mock_data.sql.
-- The final ROLLBACK restores the original data.
START TRANSACTION;

-- CREATE: add a student and a related prescription.
INSERT INTO Student (program_name, study_year, name, age)
VALUES ('Computer Science', 1, 'Alex van Leeuwen', 19);
SET @demo_student_id = LAST_INSERT_ID();

INSERT INTO Prescription
(student_id, drug_id, doctor_id, prescription_date, dose_mg, quantity_tablets)
VALUES (@demo_student_id, 1, 1, '2026-04-01', 5.00, 14);
SET @demo_prescription_id = LAST_INSERT_ID();

-- READ: show the new record.
SELECT * FROM Prescription WHERE prescription_id = @demo_prescription_id;

-- UPDATE: correct the quantity and show the result.
UPDATE Prescription SET quantity_tablets = 28
WHERE prescription_id = @demo_prescription_id;
SELECT * FROM Prescription WHERE prescription_id = @demo_prescription_id;

-- DELETE: remove the child row before the parent to respect the foreign key.
DELETE FROM Prescription WHERE prescription_id = @demo_prescription_id;
DELETE FROM Student WHERE student_id = @demo_student_id;
SELECT COUNT(*) AS remaining_demo_students
FROM Student WHERE student_id = @demo_student_id;

ROLLBACK;
