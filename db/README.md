# Структура Базы Данных
## в начале 6

### `achievements`
- **Описание:** Хранит информацию о достижениях студентов.
- **Поля:**
  - `achievement_id` (serial, PRIMARY KEY)
  - `portfolio_id` (integer, FOREIGN KEY REFERENCES `portfolio`)
  - `achievement_name` (varchar(100))
  - `description` (text)
  - `date` (date)

### `employments`
- **Описание:** Хранит информацию о трудоустройстве преподавателей.
- **Поля:**
  - `structural_unit_id` (integer, PRIMARY KEY, FOREIGN KEY REFERENCES `structural_units`)
  - `professor_id` (integer, PRIMARY KEY, FOREIGN KEY REFERENCES `professors`)
  - `contract_number` (integer)
  - `wage_rate` (numeric(3, 2))

### `field_comprehensions`
- **Описание:** Хранит информацию о понимании студентами различных областей.
- **Поля:**
  - `student_id` (integer, PRIMARY KEY, FOREIGN KEY REFERENCES `students`)
  - `field` (uuid, PRIMARY KEY, FOREIGN KEY REFERENCES `fields`)
  - `mark` (integer)

### `field_professors`
- **Описание:** Хранит информацию о преподавателях, связанных с определенными областями.
- **Поля:**
  - `field_id` (uuid, PRIMARY KEY, FOREIGN KEY REFERENCES `fields`)
  - `professor_id` (integer, PRIMARY KEY, FOREIGN KEY REFERENCES `professors`)

### `fields`
- **Описание:** Хранит информацию о различных областях знаний.
- **Поля:**
  - `field_id` (uuid, PRIMARY KEY)
  - `field_name` (varchar(100))
  - `structural_unit_id` (integer, FOREIGN KEY REFERENCES `structural_units`)
  - `zet` (integer)
  - `semester` (integer)

### `portfolio`
- **Описание:** Хранит информацию о портфолио студентов.
- **Поля:**
  - `portfolio_id` (serial, PRIMARY KEY)
  - `student_id` (integer, FOREIGN KEY REFERENCES `students`)
  - `creation_date` (date, DEFAULT CURRENT_DATE)
  - `last_update_date` (date, DEFAULT CURRENT_DATE)

### `professors`
- **Описание:** Хранит информацию о преподавателях.
- **Поля:**
  - `professor_id` (integer, PRIMARY KEY)
  - `last_name` (varchar(30))
  - `first_name` (varchar(30))
  - `patronymic` (varchar(30))
  - `degree` (varchar(15))
  - `academic_title` (varchar(40))
  - `current_position` (varchar(40))
  - `experience` (integer)
  - `salary` (money)

### `projects`
- **Описание:** Хранит информацию о проектах студентов.
- **Поля:**
  - `project_id` (serial, PRIMARY KEY)
  - `portfolio_id` (integer, FOREIGN KEY REFERENCES `portfolio`)
  - `project_name` (varchar(100))
  - `description` (text)
  - `start_date` (date)
  - `end_date` (date)

### `skills`
- **Описание:** Хранит информацию о навыках студентов.
- **Поля:**
  - `skill_id` (serial, PRIMARY KEY)
  - `portfolio_id` (integer, FOREIGN KEY REFERENCES `portfolio`)
  - `skill_name` (varchar(100))
  - `proficiency_level` (varchar(20))

### `structural_units`
- **Описание:** Хранит информацию о структурных подразделениях.
- **Поля:**
  - `structural_unit_id` (serial, PRIMARY KEY)
  - `full_title` (text)
  - `abbreviated_title` (varchar(20))
  - `head_of_the_unit` (varchar(40))
  - `phone_number` (varchar(5))
  - `room_number` (varchar(4))

### `student_ids`
- **Описание:** Хранит информацию о студенческих билетах.
- **Поля:**
  - `student_id` (integer, PRIMARY KEY, FOREIGN KEY REFERENCES `students`)
  - `issue_date` (date, DEFAULT CURRENT_DATE)
  - `expiration_date` (date, DEFAULT CURRENT_DATE + 4 years)

### `students`
- **Описание:** Хранит информацию о студентах.
- **Поля:**
  - `student_id` (integer, PRIMARY KEY)
  - `last_name` (varchar(30))
  - `first_name` (varchar(30))
  - `patronymic` (varchar(30))
  - `students_group_number` (varchar(7), FOREIGN KEY REFERENCES `students_groups`)
  - `birthday` (date)
  - `email` (varchar(30), UNIQUE)

### `students_groups`
- **Описание:** Хранит информацию о группах студентов.
- **Поля:**
  - `students_group_number` (varchar(7), PRIMARY KEY)
  - `enrolment_status` (varchar(12))
  - `structural_unit_id` (integer, FOREIGN KEY REFERENCES `structural_units`)

## Связи между таблицами

- `achievements` связана с `portfolio` через `portfolio_id`.
- `employments` связана с `professors` через `professor_id` и с `structural_units` через `structural_unit_id`.
- `field_comprehensions` связана с `students` через `student_id` и с `fields` через `field`.
- `field_professors` связана с `fields` через `field_id` и с `professors` через `professor_id`.
- `fields` связана с `structural_units` через `structural_unit_id`.
- `portfolio` связана с `students` через `student_id`.
- `projects` связана с `portfolio` через `portfolio_id`.
- `skills` связана с `portfolio` через `portfolio_id`.
- `student_ids` связана с `students` через `student_id`.
- `students` связана с `students_groups` через `students_group_number`.
- `students_groups` связана с `structural_units` через `structural_unit_id`.


## на момент первой лабы

### Таблица Structural_units

| Поле                  | Тип данных       | Ограничения                                                                 |
|-----------------------|------------------|------------------------------------------------------------------------------|
| structural_unit_id    | SERIAL           | PRIMARY KEY                                                                  |
| full_title            | TEXT             | NOT NULL                                                                     |
| abbreviated_title     | VARCHAR(20)      | NULL                                                                         |
| head_of_the_unit      | VARCHAR(40)      | NOT NULL                                                                     |
| phone_number          | VARCHAR(5)       | CHECK (формат 'XX-XX')                                                       |

### Таблица Students_groups

| Поле                  | Тип данных       | Ограничения                                                                 |
|-----------------------|------------------|------------------------------------------------------------------------------|
| students_group_number | VARCHAR(7)       | PRIMARY KEY, CHECK (формат 'Буквы-Цифри')                                    |
| enrolment_status      | VARCHAR(12)      | NOT NULL, CHECK ('Очная', 'Заочная', 'Очно-заочная')                         |
| structural_unit_id    | INTEGER          | NOT NULL, FOREIGN KEY до Structural_units                                    |

### Таблица Students

| Поле                  | Тип данных       | Ограничения                                                                 |
|-----------------------|------------------|------------------------------------------------------------------------------|
| student_id            | INTEGER          | NOT NULL, PRIMARY KEY                                                       |
| last_name             | VARCHAR(30)      | NOT NULL                                                                    |
| first_name            | VARCHAR(30)      | NOT NULL                                                                    |
| patronymic            | VARCHAR(30)      | NULL                                                                        |
| students_group_number | VARCHAR(7)       | NOT NULL, FOREIGN KEY до Students_groups                                     |
| birthday              | DATE             | NOT NULL                                                                    |
| email                 | VARCHAR(30)      | UNIQUE, CHECK (формат email)                                                |

### Таблица Student_ids

| Поле                  | Тип данных       | Ограничения                                                                 |
|-----------------------|------------------|------------------------------------------------------------------------------|
| student_id            | INTEGER          | NOT NULL, PRIMARY KEY, FOREIGN KEY до Students                               |
| issue_date            | DATE             | NOT NULL, DEFAULT CURRENT_DATE                                              |
| expiration_date       | DATE             | NOT NULL, DEFAULT CURRENT_DATE + 4 роки                                      |

### Таблица Professors

| Поле                  | Тип данных       | Ограничения                                                                 |
|-----------------------|------------------|------------------------------------------------------------------------------|
| professor_id          | INTEGER          | NOT NULL, PRIMARY KEY                                                       |
| last_name             | VARCHAR(30)      | NOT NULL                                                                    |
| first_name            | VARCHAR(30)      | NOT NULL                                                                    |
| patronymic            | VARCHAR(30)      | NULL                                                                        |
| degree                | VARCHAR(15)      | NULL, CHECK (формат 'к.н.', 'д.н.')                                         |
| academic_title        | VARCHAR(40)      | NULL                                                                        |
| current_position      | VARCHAR(40)      | NOT NULL                                                                    |
| experience            | INTEGER          | NOT NULL                                                                    |
| salary                | MONEY            |                                                                             |

### Таблица Fields

| Поле                  | Тип данных       | Ограничения                                                                 |
|-----------------------|------------------|------------------------------------------------------------------------------|
| field_id              | UUID             | NOT NULL, PRIMARY KEY                                                       |
| field_name            | VARCHAR(100)     | NOT NULL                                                                    |
| structural_unit_id    | INTEGER          | NOT NULL, FOREIGN KEY до Structural_units                                    |
| professor_id          | INTEGER          | NOT NULL, FOREIGN KEY до Professors                                          |
| ZET                   | INTEGER          | NOT NULL                                                                    |
| semester              | INTEGER          | NOT NULL                                                                    |

### Таблица Employments

| Поле                  | Тип данных       | Ограничения                                                                 |
|-----------------------|------------------|------------------------------------------------------------------------------|
| structural_unit_id    | INTEGER          | NOT NULL, FOREIGN KEY до Structural_units                                    |
| professor_id          | INTEGER          | NOT NULL, FOREIGN KEY до Professors                                          |
| contract_number       | INTEGER          | NOT NULL                                                                    |
| wage_rate             | NUMERIC(3,2)     | NOT NULL                                                                    |
| PRIMARY KEY           |                  | (structural_unit_id, professor_id)                                           |

### Таблица Field_comprehensions

| Поле                  | Тип данных       | Ограничения                                                                 |
|-----------------------|------------------|------------------------------------------------------------------------------|
| student_id            | INTEGER          | NOT NULL, FOREIGN KEY до Students                                            |
| field                 | UUID             | NOT NULL, FOREIGN KEY до Fields                                              |
| mark                  | INTEGER          | CHECK (2 <= mark <= 5)                                                      |
| PRIMARY KEY           |                  | (student_id, field)                                                         |


![Shema](https://github.com/user-attachments/assets/d7a29d96-12cb-4461-bc82-2f598e43bced)
