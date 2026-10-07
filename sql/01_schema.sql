-- MySQL 8.0.16+; run once in an empty database.
-- InnoDB enforces foreign keys. utf8mb4 supports international names.
CREATE TABLE Student (
    student_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    program_name VARCHAR(100) NOT NULL,
    study_year INT UNSIGNED NOT NULL,
    name VARCHAR(100) NOT NULL,
    age INT UNSIGNED NOT NULL,
    CONSTRAINT chk_student_year CHECK (study_year BETWEEN 1 AND 8),
    CONSTRAINT chk_student_age CHECK (age BETWEEN 16 AND 100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE StudyDrug (
    drug_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    drug_producer VARCHAR(100) NOT NULL,
    drug_name VARCHAR(100) NOT NULL,
    CONSTRAINT uq_drug UNIQUE (drug_producer, drug_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Doctor (
    doctor_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    role VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,
    name VARCHAR(100) NOT NULL,
    age INT UNSIGNED NOT NULL,
    CONSTRAINT chk_doctor_age CHECK (age BETWEEN 23 AND 100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Prescription (
    prescription_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    student_id INT UNSIGNED NOT NULL,
    drug_id INT UNSIGNED NOT NULL,
    doctor_id INT UNSIGNED NOT NULL,
    prescription_date DATE NOT NULL,
    dose_mg DECIMAL(6,2) NOT NULL,
    quantity_tablets INT UNSIGNED NOT NULL,
    CONSTRAINT chk_dose CHECK (dose_mg > 0),
    CONSTRAINT chk_quantity CHECK (quantity_tablets > 0),
    CONSTRAINT fk_prescription_student FOREIGN KEY (student_id)
        REFERENCES Student (student_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_prescription_drug FOREIGN KEY (drug_id)
        REFERENCES StudyDrug (drug_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_prescription_doctor FOREIGN KEY (doctor_id)
        REFERENCES Doctor (doctor_id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
