# Week 3 verification results

Tested on 2026-10-07 with MySQL 8.4.0.

Fresh schema creation and mock-data loading succeeded.
Counts: 8 students, 4 doctors, 4 drugs, 13 prescriptions.
Fractional dose 2.50 was preserved. The CRUD demonstration restored row counts.

## Basic operations output

```text
prescription_id	student_id	drug_id	doctor_id	prescription_date	dose_mg	quantity_tablets
14	9	1	1	2026-04-01	5.00	14
prescription_id	student_id	drug_id	doctor_id	prescription_date	dose_mg	quantity_tablets
14	9	1	1	2026-04-01	5.00	28
remaining_demo_students
0
```

## Advanced query outputs

### Query 1

```text
prescription_id	student	program_name	doctor	drug_name	prescription_date	dose_mg	quantity_tablets
1	Emma de Vries	Computer Science	Eva van Dijk	Study Compound A	2026-01-12	10.00	30
2	Noah Bakker	Business Administration	Thomas Willems	Study Compound B	2026-01-15	5.00	28
3	Sofia Jansen	Psychology	Eva van Dijk	Study Compound A	2026-01-20	5.00	14
4	Liam Visser	Computer Science	Sara Ahmed	Study Compound C	2026-02-02	20.00	30
5	Emma de Vries	Computer Science	Eva van Dijk	Study Compound A	2026-02-12	10.00	30
6	Mila Smit	Nursing	Thomas Willems	Study Compound B	2026-02-18	5.00	28
7	Lucas Meijer	Psychology	Sara Ahmed	Study Compound C	2026-02-21	10.00	14
13	Lucas Meijer	Psychology	Sara Ahmed	Study Compound C	2026-02-21	2.50	14
8	Noah Bakker	Business Administration	Thomas Willems	Study Compound B	2026-03-15	5.00	28
9	Sofia Jansen	Psychology	Thomas Willems	Study Compound B	2026-03-17	5.00	14
10	Liam Visser	Computer Science	Sara Ahmed	Study Compound C	2026-03-19	20.00	30
11	Emma de Vries	Computer Science	Sara Ahmed	Study Compound C	2026-03-23	10.00	14
12	Mila Smit	Nursing	Eva van Dijk	Study Compound A	2026-03-25	5.00	14
```

### Query 2

```text
drug_id	drug_name	prescription_count	student_count	total_tablets
3	Study Compound C	5	3	102
1	Study Compound A	4	3	88
2	Study Compound B	4	3	98
```

### Query 3

```text
student_id	name	program_name
7	Amira Hassan	Business Administration
8	Oliver Peters	Nursing
```

### Query 4

```text
name	prescription_id	prescription_date	drug_name
Emma de Vries	11	2026-03-23	Study Compound C
Noah Bakker	8	2026-03-15	Study Compound B
Sofia Jansen	9	2026-03-17	Study Compound B
Liam Visser	10	2026-03-19	Study Compound C
Mila Smit	12	2026-03-25	Study Compound A
Lucas Meijer	13	2026-02-21	Study Compound C
```

## Constraint checks

- student age: rejected (ERROR 3819 (HY000) at line 1: Check constraint 'chk_student_age' is violated.).
- study year: rejected (ERROR 3819 (HY000) at line 1: Check constraint 'chk_student_year' is violated.).
- doctor age: rejected (ERROR 3819 (HY000) at line 1: Check constraint 'chk_doctor_age' is violated.).
- required value: rejected (ERROR 1048 (23000) at line 1: Column 'name' cannot be null).
- duplicate product: rejected (ERROR 1062 (23000) at line 1: Duplicate entry 'Northbridge Pharma-Study Compound A' for key 'studydrug.uq_drug').
- orphan student: rejected (ERROR 1452 (23000) at line 1: Cannot add or update a child row: a foreign key constraint fails (`week3_verify_f6a322092e05`.`prescription`, CONSTRAINT `fk_prescription_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE RESTRICT ON UPDATE RESTRICT)).
- orphan drug: rejected (ERROR 1452 (23000) at line 1: Cannot add or update a child row: a foreign key constraint fails (`week3_verify_f6a322092e05`.`prescription`, CONSTRAINT `fk_prescription_drug` FOREIGN KEY (`drug_id`) REFERENCES `studydrug` (`drug_id`) ON DELETE RESTRICT ON UPDATE RESTRICT)).
- orphan doctor: rejected (ERROR 1452 (23000) at line 1: Cannot add or update a child row: a foreign key constraint fails (`week3_verify_f6a322092e05`.`prescription`, CONSTRAINT `fk_prescription_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`doctor_id`) ON DELETE RESTRICT ON UPDATE RESTRICT)).
- zero dose: rejected (ERROR 3819 (HY000) at line 1: Check constraint 'chk_dose' is violated.).
- zero quantity: rejected (ERROR 3819 (HY000) at line 1: Check constraint 'chk_quantity' is violated.).
- referenced parent deletion: rejected (ERROR 1451 (23000) at line 1: Cannot delete or update a parent row: a foreign key constraint fails (`week3_verify_f6a322092e05`.`prescription`, CONSTRAINT `fk_prescription_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE RESTRICT ON UPDATE RESTRICT)).

All expected results matched. The same-date tie selected prescription 13.
The disposable verification database was removed after testing.
