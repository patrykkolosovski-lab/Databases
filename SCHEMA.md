# Relational schema

`PK` = primary key; `FK` = foreign key. All attributes are required.

- **Student** (**student_id** PK, program_name, study_year, name, age)
- **StudyDrug** (**drug_id** PK, drug_producer, drug_name)
- **Doctor** (**doctor_id** PK, role, department, name, age)
- **Prescription** (**prescription_id** PK, student_id FK → Student.student_id, drug_id FK → StudyDrug.drug_id, doctor_id FK → Doctor.doctor_id, prescription_date, dose_mg, quantity_tablets)

Each prescription refers to exactly one student, one drug and one doctor. Each student, drug and doctor can have multiple prescriptions. Parents may exist before their first prescription. A minimum of one child is not enforced by these foreign keys.

Assumed validation rules: student ages 16–100, doctor ages 23–100, study years 1–8, and positive doses and tablet quantities. Parent deletion is restricted while a prescription references it.
