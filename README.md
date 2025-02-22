Structural_units

structural_unit_id (SERIAL, PRIMARY KEY)

full_title (TEXT, NOT NULL)

abbreviated_title (VARCHAR(20), NULL)

head_of_the_unit (VARCHAR(40), NOT NULL)

phone_number (VARCHAR(5), CHECK (формат 'XX-XX'))

Students_groups

students_group_number (VARCHAR(7), PRIMARY KEY, CHECK (формат 'Буквы-Цифри'))

enrolment_status (VARCHAR(12), NOT NULL, CHECK ('Очная', 'Заочная', 'Очно-заочная'))

structural_unit_id (INTEGER, NOT NULL, FOREIGN KEY до Structural_units)

Students

student_id (INTEGER, NOT NULL, PRIMARY KEY)

last_name (VARCHAR(30), NOT NULL)

first_name (VARCHAR(30), NOT NULL)

patronymic (VARCHAR(30), NULL)

students_group_number (VARCHAR(7), NOT NULL, FOREIGN KEY до Students_groups)

birthday (DATE, NOT NULL)

email (VARCHAR(30), UNIQUE, CHECK (формат email))

Student_ids

student_id (INTEGER, NOT NULL, PRIMARY KEY, FOREIGN KEY до Students)

issue_date (DATE, NOT NULL, DEFAULT CURRENT_DATE)

expiration_date (DATE, NOT NULL, DEFAULT CURRENT_DATE + 4 роки)

Professors

professor_id (INTEGER, NOT NULL, PRIMARY KEY)

last_name (VARCHAR(30), NOT NULL)

first_name (VARCHAR(30), NOT NULL)

patronymic (VARCHAR(30), NULL)

degree (VARCHAR(15), NULL, CHECK (формат 'к.н.', 'д.н.'))

academic_title (VARCHAR(40), NULL)

current_position (VARCHAR(40), NOT NULL)

experience (INTEGER, NOT NULL)

salary (MONEY)

Fields

field_id (UUID, NOT NULL, PRIMARY KEY)

field_name (VARCHAR(100), NOT NULL)

structural_unit_id (INTEGER, NOT NULL, FOREIGN KEY до Structural_units)

professor_id (INTEGER, NOT NULL, FOREIGN KEY до Professors)

ZET (INTEGER, NOT NULL)

semester (INTEGER, NOT NULL)

Employments

structural_unit_id (INTEGER, NOT NULL, FOREIGN KEY до Structural_units)

professor_id (INTEGER, NOT NULL, FOREIGN KEY до Professors)

contract_number (INTEGER, NOT NULL)

wage_rate (NUMERIC(3,2), NOT NULL)

PRIMARY KEY (structural_unit_id, professor_id)

Field_comprehensions

student_id (INTEGER, NOT NULL, FOREIGN KEY до Students)

field (UUID, NOT NULL, FOREIGN KEY до Fields)

mark (INTEGER, CHECK (2 <= mark <= 5))

PRIMARY KEY (student_id, field)


![Shema](https://github.com/user-attachments/assets/d7a29d96-12cb-4461-bc82-2f598e43bced)
