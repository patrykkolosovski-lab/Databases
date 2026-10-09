-- Fictional teaching data: 8 students, 4 drugs, 4 doctors, 13 prescriptions.
-- Includes parent rows without prescriptions, repeat prescriptions and same-date events.
-- Drug products and doses are illustrative, not clinical recommendations.
INSERT INTO Student (student_id, program_name, study_year, name, age) VALUES
(1, 'Computer Science', 2, 'Emma de Vries', 20),
(2, 'Business Administration', 3, 'Noah Bakker', 22),
(3, 'Psychology', 1, 'Sofia Jansen', 19),
(4, 'Computer Science', 3, 'Liam Visser', 23),
(5, 'Nursing', 2, 'Mila Smit', 21),
(6, 'Psychology', 2, 'Lucas Meijer', 20),
(7, 'Business Administration', 1, 'Amira Hassan', 18),
(8, 'Nursing', 4, 'Oliver Peters', 25);

INSERT INTO StudyDrug (drug_id, drug_producer, drug_name) VALUES
(1, 'Northbridge Pharma', 'Study Compound A'),
(2, 'Canal Laboratories', 'Study Compound B'),
(3, 'Northbridge Pharma', 'Study Compound C'),
(4, 'Dune Therapeutics', 'Study Compound D');

INSERT INTO Doctor (doctor_id, role, department, name, age) VALUES
(1, 'General practitioner', 'Student Health', 'Eva van Dijk', 42),
(2, 'Psychiatrist', 'Mental Health', 'Thomas Willems', 51),
(3, 'Research physician', 'Clinical Research', 'Sara Ahmed', 35),
(4, 'General practitioner', 'Student Health', 'Daniel Vos', 39);

INSERT INTO Prescription
(prescription_id, student_id, drug_id, doctor_id, prescription_date, dose_mg, quantity_tablets) VALUES
(1, 1, 1, 1, '2026-01-12', 10.00, 30),
(2, 2, 2, 2, '2026-01-15', 5.00, 28),
(3, 3, 1, 1, '2026-01-20', 5.00, 14),
(4, 4, 3, 3, '2026-02-02', 20.00, 30),
(5, 1, 1, 1, '2026-02-12', 10.00, 30),
(6, 5, 2, 2, '2026-02-18', 5.00, 28),
(7, 6, 3, 3, '2026-02-21', 10.00, 14),
(8, 2, 2, 2, '2026-03-15', 5.00, 28),
(9, 3, 2, 2, '2026-03-17', 5.00, 14),
(10, 4, 3, 3, '2026-03-19', 20.00, 30),
(11, 1, 3, 3, '2026-03-23', 10.00, 14),
(12, 5, 1, 1, '2026-03-25', 5.00, 14),
(13, 6, 3, 3, '2026-02-21', 2.50, 14);
