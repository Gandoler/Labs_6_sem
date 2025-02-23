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

![bdshem](https://github.com/user-attachments/assets/d6f96dc0-20c8-4175-91fe-3d9df5e8ebb9)



# CREATE

```sql

-- This script was generated by the ERD tool in pgAdmin 4.
-- Please log an issue at https://github.com/pgadmin-org/pgadmin4/issues/new/choose if you find any bugs, including reproduction steps.
BEGIN;


CREATE TABLE IF NOT EXISTS public.achievements
(
    achievement_id serial NOT NULL,
    portfolio_id integer NOT NULL,
    achievement_name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default",
    date date NOT NULL,
    CONSTRAINT achievements_pkey PRIMARY KEY (achievement_id)
);

CREATE TABLE IF NOT EXISTS public.employments
(
    structural_unit_id integer NOT NULL,
    professor_id integer NOT NULL,
    contract_number integer NOT NULL,
    wage_rate numeric(3, 2) NOT NULL,
    CONSTRAINT employments_pkey PRIMARY KEY (structural_unit_id, professor_id)
);

CREATE TABLE IF NOT EXISTS public.field_comprehensions
(
    student_id integer NOT NULL,
    field uuid NOT NULL,
    mark integer,
    CONSTRAINT field_comprehensions_pkey PRIMARY KEY (student_id, field)
);

CREATE TABLE IF NOT EXISTS public.field_professors
(
    field_id uuid NOT NULL,
    professor_id integer NOT NULL,
    CONSTRAINT field_professors_pkey PRIMARY KEY (field_id, professor_id)
);

CREATE TABLE IF NOT EXISTS public.fields
(
    field_id uuid NOT NULL,
    field_name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    structural_unit_id integer NOT NULL,
    zet integer NOT NULL,
    semester integer NOT NULL,
    CONSTRAINT fields_pkey PRIMARY KEY (field_id)
);

CREATE TABLE IF NOT EXISTS public.portfolio
(
    portfolio_id serial NOT NULL,
    student_id integer NOT NULL,
    creation_date date NOT NULL DEFAULT CURRENT_DATE,
    last_update_date date NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT portfolio_pkey PRIMARY KEY (portfolio_id)
);

CREATE TABLE IF NOT EXISTS public.professors
(
    professor_id integer NOT NULL,
    last_name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    first_name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    patronymic character varying(30) COLLATE pg_catalog."default",
    degree character varying(15) COLLATE pg_catalog."default",
    academic_title character varying(40) COLLATE pg_catalog."default",
    current_position character varying(40) COLLATE pg_catalog."default" NOT NULL,
    experience integer NOT NULL,
    salary money,
    CONSTRAINT professors_pkey PRIMARY KEY (professor_id)
);

CREATE TABLE IF NOT EXISTS public.projects
(
    project_id serial NOT NULL,
    portfolio_id integer NOT NULL,
    project_name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default",
    start_date date NOT NULL,
    end_date date,
    CONSTRAINT projects_pkey PRIMARY KEY (project_id)
);

CREATE TABLE IF NOT EXISTS public.skills
(
    skill_id serial NOT NULL,
    portfolio_id integer NOT NULL,
    skill_name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    proficiency_level character varying(20) COLLATE pg_catalog."default",
    CONSTRAINT skills_pkey PRIMARY KEY (skill_id)
);

CREATE TABLE IF NOT EXISTS public.structural_units
(
    structural_unit_id serial NOT NULL,
    full_title text COLLATE pg_catalog."default" NOT NULL,
    abbreviated_title character varying(20) COLLATE pg_catalog."default",
    head_of_the_unit character varying(40) COLLATE pg_catalog."default" NOT NULL,
    phone_number character varying(5) COLLATE pg_catalog."default",
    CONSTRAINT structural_units_pkey PRIMARY KEY (structural_unit_id)
);

CREATE TABLE IF NOT EXISTS public.student_ids
(
    student_id integer NOT NULL,
    issue_date date NOT NULL DEFAULT CURRENT_DATE,
    expiration_date date NOT NULL DEFAULT (CURRENT_DATE + '4 years'::interval),
    CONSTRAINT student_ids_pkey PRIMARY KEY (student_id)
);

CREATE TABLE IF NOT EXISTS public.students
(
    student_id integer NOT NULL,
    last_name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    first_name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    patronymic character varying(30) COLLATE pg_catalog."default",
    students_group_number character varying(7) COLLATE pg_catalog."default" NOT NULL,
    birthday date NOT NULL,
    email character varying(30) COLLATE pg_catalog."default",
    CONSTRAINT students_pkey PRIMARY KEY (student_id),
    CONSTRAINT students_email_key UNIQUE (email)
);

CREATE TABLE IF NOT EXISTS public.students_groups
(
    students_group_number character varying(7) COLLATE pg_catalog."default" NOT NULL,
    enrolment_status character varying(12) COLLATE pg_catalog."default" NOT NULL,
    structural_unit_id integer NOT NULL,
    CONSTRAINT students_groups_pkey PRIMARY KEY (students_group_number)
);

ALTER TABLE IF EXISTS public.achievements
    ADD CONSTRAINT achievements_portfolio_id_fkey FOREIGN KEY (portfolio_id)
    REFERENCES public.portfolio (portfolio_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.employments
    ADD CONSTRAINT employments_professor_id_fkey FOREIGN KEY (professor_id)
    REFERENCES public.professors (professor_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.employments
    ADD CONSTRAINT employments_structural_unit_id_fkey FOREIGN KEY (structural_unit_id)
    REFERENCES public.structural_units (structural_unit_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.field_comprehensions
    ADD CONSTRAINT field_comprehensions_field_fkey FOREIGN KEY (field)
    REFERENCES public.fields (field_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.field_comprehensions
    ADD CONSTRAINT field_comprehensions_student_id_fkey FOREIGN KEY (student_id)
    REFERENCES public.students (student_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.field_professors
    ADD CONSTRAINT field_professors_professor_id_fkey FOREIGN KEY (professor_id)
    REFERENCES public.professors (professor_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.fields
    ADD CONSTRAINT fields_structural_unit_id_fkey FOREIGN KEY (structural_unit_id)
    REFERENCES public.structural_units (structural_unit_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.portfolio
    ADD CONSTRAINT portfolio_student_id_fkey FOREIGN KEY (student_id)
    REFERENCES public.students (student_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.projects
    ADD CONSTRAINT projects_portfolio_id_fkey FOREIGN KEY (portfolio_id)
    REFERENCES public.portfolio (portfolio_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.skills
    ADD CONSTRAINT skills_portfolio_id_fkey FOREIGN KEY (portfolio_id)
    REFERENCES public.portfolio (portfolio_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.student_ids
    ADD CONSTRAINT student_ids_student_id_fkey FOREIGN KEY (student_id)
    REFERENCES public.students (student_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;
CREATE INDEX IF NOT EXISTS student_ids_pkey
    ON public.student_ids(student_id);


ALTER TABLE IF EXISTS public.students
    ADD CONSTRAINT students_group_key FOREIGN KEY (students_group_number)
    REFERENCES public.students_groups (students_group_number) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.students_groups
    ADD CONSTRAINT students_groups_structural_unit_id_fkey FOREIGN KEY (structural_unit_id)
    REFERENCES public.structural_units (structural_unit_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;

END;


```


