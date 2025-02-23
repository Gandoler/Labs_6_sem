# lab 4 
## NUM 1
В учебной базе данных одним из допущений является возможность прикрепить только одного преподавателя к дисциплине. Исправьте его.

ЕЩЕ и с повторениями
```sql
SELECT Fields.field_name, Professors.last_name, Professors.first_name
FROM Professors
inner JOIN Fields ON Fields.professor_id = Professors.professor_id
ORDER BY(Fields.field_name)


SELECT * FROM Fields
ORDER BY(field_name)
```
<img width="916" alt="image" src="https://github.com/user-attachments/assets/b7ca075c-c3bc-4e93-bb90-304cf6434df0" />

```sql
CREATE TABLE Field_Professors (
    field_id UUID NOT NULL REFERENCES Fields(field_id) ON DELETE CASCADE,
    professor_id INTEGER NOT NULL REFERENCES Professors(professor_id) ON DELETE CASCADE,
    PRIMARY KEY (field_id, professor_id)  -- Составной первичный ключ
);

INSERT INTO Field_Professors (field_id, professor_id)
SELECT field_id, professor_id
FROM Fields
WHERE professor_id IS NOT NULL;


ALTER TABLE Fields DROP COLUMN professor_id;
```
после операций

```sql
INSERT INTO Field_Professors (field_id, professor_id)
VALUES ('f81d63d6-ccd0-4cf0-a13a-340c44b852af', 820001);

SELECT Fields.field_name, Professors.last_name, Professors.first_name
FROM Professors
inner JOIN Field_Professors ON Field_Professors.professor_id = Professors.professor_id
inner JOIN Fields ON Fields.field_id = Field_Professors.field_id
WHERE Fields.field_id = 'f81d63d6-ccd0-4cf0-a13a-340c44b852af'
ORDER BY(Field_Professors.field_id)

```
<img width="709" alt="image" src="https://github.com/user-attachments/assets/70262eba-a878-4fc3-ad24-f9c215fbf0e5" />


## num 2
Отредактируйте базу данных в соответствии с вашим вариантом. 
Добавьте в таблицу structural_units поле, содержащее номер аудитории подразделения. Сделайте ограничение, позволяющее хранить номер аудитории в формате: ABXX, где A может принимать значения 1,3,4; B – от 1-3. Значение XX может лежать от 00 до 39 


``` sql
ALTER TABLE structural_units
ADD COLUMN room_number VARCHAR(4);


ALTER TABLE structural_units
ADD CONSTRAINT room_number_format
CHECK (room_number ~ '^[134][1-3][0-3][0-9]$');
```



```sql
INSERT INTO structural_units (full_title, abbreviated_title, head_of_the_unit, phone_number, room_number)
VALUES ('Подразделение 1', 'П1', 'Иванов И.И.', '12-34', '1305');  --правильно



INSERT INTO structural_units (full_title, abbreviated_title, head_of_the_unit, phone_number, room_number)
VALUES ('Подразделение 2', 'П2', 'Петров П.П.', '56-78', '2505');  --непраивильно


```
<img width="774" alt="image" src="https://github.com/user-attachments/assets/06d239d9-0e28-4e3a-86c9-09c4216228be" />


## num 3
В соответствии с вариантом доработайте логическую модель базы данных. При доработке БД должно быть добавлено не менее трех новых таблиц. Постройте схему новой базы данных в редакторе pgmodeler или Erwin. Экспортируйте её в созданную базу данных. 

1. **Portfolio** — основная таблица для хранения информации о портфолио студента.
2. **Achievements** — таблица для хранения достижений студента.
3. **Projects** — таблица для хранения проектов студента.
4. **Skills** — таблица для хранения навыков студента.

### Новые таблицы

#### 1. Таблица `Portfolio`

| Поле               | Тип данных         | Описание                                      |
|--------------------|--------------------|-----------------------------------------------|
| `portfolio_id`     | SERIAL PRIMARY KEY | Уникальный идентификатор портфолио.          |
| `student_id`       | INTEGER            | Связь с таблицей `Students` (ON DELETE CASCADE). |
| `creation_date`    | DATE               | Дата создания портфолио (по умолчанию CURRENT_DATE). |
| `last_update_date` | DATE               | Дата последнего обновления (по умолчанию CURRENT_DATE). |

#### 2. Таблица `Achievements`

| Поле               | Тип данных         | Описание                                      |
|--------------------|--------------------|-----------------------------------------------|
| `achievement_id`   | SERIAL PRIMARY KEY | Уникальный идентификатор достижения.         |
| `portfolio_id`     | INTEGER            | Связь с таблицей `Portfolio` (ON DELETE CASCADE). |
| `achievement_name` | VARCHAR(100)       | Название достижения.                         |
| `description`      | TEXT               | Описание достижения.                         |
| `date`             | DATE               | Дата достижения.                             |

#### 3. Таблица `Projects`

| Поле               | Тип данных         | Описание                                      |
|--------------------|--------------------|-----------------------------------------------|
| `project_id`       | SERIAL PRIMARY KEY | Уникальный идентификатор проекта.            |
| `portfolio_id`     | INTEGER            | Связь с таблицей `Portfolio` (ON DELETE CASCADE). |
| `project_name`     | VARCHAR(100)       | Название проекта.                            |
| `description`      | TEXT               | Описание проекта.                            |
| `start_date`       | DATE               | Дата начала проекта.                         |
| `end_date`         | DATE               | Дата завершения проекта (может быть NULL).   |

#### 4. Таблица `Skills`

| Поле               | Тип данных         | Описание                                      |
|--------------------|--------------------|-----------------------------------------------|
| `skill_id`         | SERIAL PRIMARY KEY | Уникальный идентификатор навыка.             |
| `portfolio_id`     | INTEGER            | Связь с таблицей `Portfolio` (ON DELETE CASCADE). |
| `skill_name`       | VARCHAR(100)       | Название навыка.                             |
| `proficiency_level`| VARCHAR(20)        | Уровень владения навыком (CHECK: 'Начальный', 'Средний', 'Продвинутый', 'Эксперт'). |

### SQL-код для создания новых таблиц

```sql
CREATE TABLE Portfolio (
    portfolio_id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL REFERENCES Students(student_id) ON DELETE CASCADE,
    creation_date DATE NOT NULL DEFAULT CURRENT_DATE,
    last_update_date DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE Achievements (
    achievement_id SERIAL PRIMARY KEY,
    portfolio_id INTEGER NOT NULL REFERENCES Portfolio(portfolio_id) ON DELETE CASCADE,
    achievement_name VARCHAR(100) NOT NULL,
    description TEXT,
    date DATE NOT NULL
);

CREATE TABLE Projects (
    project_id SERIAL PRIMARY KEY,
    portfolio_id INTEGER NOT NULL REFERENCES Portfolio(portfolio_id) ON DELETE CASCADE,
    project_name VARCHAR(100) NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE
);

CREATE TABLE Skills (
    skill_id SERIAL PRIMARY KEY,
    portfolio_id INTEGER NOT NULL REFERENCES Portfolio(portfolio_id) ON DELETE CASCADE,
    skill_name VARCHAR(100) NOT NULL,
    proficiency_level VARCHAR(20) CHECK (proficiency_level IN ('Начальный', 'Средний', 'Продвинутый', 'Эксперт'))
);
```


