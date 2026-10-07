"""Verify Week 3 on MySQL using a unique disposable database.

Requires the mysql client on PATH. Authentication uses the client's normal
configuration; optional command-line arguments are passed to mysql (e.g. a login path).
Never pass a password as a command-line value. The test database is removed.
"""
import pathlib
import subprocess
import sys
import uuid
from datetime import date

ROOT = pathlib.Path(__file__).resolve().parents[1]
DATABASE = 'week3_verify_' + uuid.uuid4().hex[:12]
CLIENT = ['mysql', *sys.argv[1:], '--batch', '--raw']

def run(sql, database=None, expect_error=False):
    command = CLIENT + ([database] if database else [])
    result = subprocess.run(command, input=sql, text=True, capture_output=True)
    if expect_error:
        if result.returncode == 0:
            raise AssertionError('Invalid data was accepted: ' + sql)
        return result.stderr.strip()
    if result.returncode:
        raise RuntimeError(result.stderr)
    return result.stdout

def scalar(sql):
    return run(sql, DATABASE).splitlines()[1]

created = False
try:
    version = run('SELECT VERSION();').splitlines()[1]
    run(f'CREATE DATABASE {DATABASE} CHARACTER SET utf8mb4;')
    created = True
    for filename in ['01_schema.sql', '02_mock_data.sql']:
        run((ROOT / 'sql' / filename).read_text(), DATABASE)
    assert scalar('SELECT COUNT(*) FROM Student;') == '8'
    assert scalar('SELECT COUNT(*) FROM Doctor;') == '4'
    assert scalar('SELECT COUNT(*) FROM StudyDrug;') == '4'
    assert scalar('SELECT COUNT(*) FROM Prescription;') == '13'
    assert scalar('SELECT dose_mg FROM Prescription WHERE prescription_id=13;') == '2.50'
    operations = run((ROOT / 'sql/03_basic_operations.sql').read_text(), DATABASE)
    operation_lines = operations.strip().splitlines()
    assert operation_lines[1].split('\t')[-1] == '14'
    assert operation_lines[3].split('\t')[-1] == '28'
    assert operation_lines[-1] == '0'
    assert scalar('SELECT COUNT(*) FROM Student;') == '8'
    assert scalar('SELECT COUNT(*) FROM Prescription;') == '13'

    queries = (ROOT / 'sql/04_advanced_queries.sql').read_text().split(';')
    outputs = [run(query + ';', DATABASE) for query in queries if query.strip()]
    rows = [output.strip().splitlines()[1:] for output in outputs]
    assert len(rows[0]) == 13
    assert [row.split('\t')[0] for row in rows[1]] == ['3', '1', '2']
    assert [row.split('\t')[2:] for row in rows[1]] == [['5', '3', '102'], ['4', '3', '88'], ['4', '3', '98']]
    assert [row.split('\t')[0] for row in rows[2]] == ['7', '8']
    assert [row.split('\t')[1] for row in rows[3]] == ['11', '8', '9', '10', '12', '13']

    invalid = {
        'student age': "INSERT INTO Student(program_name,study_year,name,age) VALUES('Test',1,'Test',15);",
        'study year': "INSERT INTO Student(program_name,study_year,name,age) VALUES('Test',9,'Test',20);",
        'doctor age': "INSERT INTO Doctor(role,department,name,age) VALUES('Test','Test','Test',22);",
        'required value': "INSERT INTO Student(program_name,study_year,name,age) VALUES('Test',1,NULL,20);",
        'duplicate product': "INSERT INTO StudyDrug(drug_producer,drug_name) VALUES('Northbridge Pharma','Study Compound A');",
        'orphan student': "INSERT INTO Prescription(student_id,drug_id,doctor_id,prescription_date,dose_mg,quantity_tablets) VALUES(999,1,1,'2026-01-01',5,10);",
        'orphan drug': "INSERT INTO Prescription(student_id,drug_id,doctor_id,prescription_date,dose_mg,quantity_tablets) VALUES(1,999,1,'2026-01-01',5,10);",
        'orphan doctor': "INSERT INTO Prescription(student_id,drug_id,doctor_id,prescription_date,dose_mg,quantity_tablets) VALUES(1,1,999,'2026-01-01',5,10);",
        'zero dose': "UPDATE Prescription SET dose_mg=0 WHERE prescription_id=1;",
        'zero quantity': "UPDATE Prescription SET quantity_tablets=0 WHERE prescription_id=1;",
        'referenced parent deletion': 'DELETE FROM Student WHERE student_id=1;',
    }
    checks = []
    for label, sql in invalid.items():
        error = run(sql, DATABASE, expect_error=True)
        expected_code = ('1048' if label == 'required value' else
                         '1062' if label == 'duplicate product' else
                         '1452' if label.startswith('orphan ') else
                         '1451' if label == 'referenced parent deletion' else '3819')
        assert f'ERROR {expected_code} ' in error, error
        checks.append(f'- {label}: rejected ({error.splitlines()[0]}).')

    report = ['# Week 3 verification results', '', f'Tested on {date.today().isoformat()} with MySQL {version}.', '',
              'Fresh schema creation and mock-data loading succeeded.',
              'Counts: 8 students, 4 doctors, 4 drugs, 13 prescriptions.',
              'Fractional dose 2.50 was preserved. The CRUD demonstration restored row counts.', '',
              '## Basic operations output', '', '```text', operations.rstrip(), '```', '',
              '## Advanced query outputs']
    for index, output in enumerate(outputs, 1):
        report.extend(['', f'### Query {index}', '', '```text', output.rstrip(), '```'])
    report.extend(['', '## Constraint checks', '', *checks, '',
                   'All expected results matched. The same-date tie selected prescription 13.',
                   'The disposable verification database was removed after testing.', ''])
    (ROOT / 'docs/week3/RESULTS.md').write_text('\n'.join(report))
    print('PASS: schema, mock data, CRUD, four queries, fractional dose, and 11 rejection checks.')
finally:
    if created:
        run(f'DROP DATABASE {DATABASE};')
