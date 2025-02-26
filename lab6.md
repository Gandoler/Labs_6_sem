
## num 1
Напишите скрипт на языке PL/pgSQL, вычисляющий среднюю оценку студента. Аналогичный запрос напишите на языке SQL. Сравните время выполнения работы в обоих случаях. Для расчета времени выполнения скрипта, запустите его в терминале psql, перед этим запустив таймер с помощью команды \timing. Для того, чтобы отключить таймер после окончания работы, выполните команду \timing off.

### Функция:

```sql
CREATE OR REPLACE FUNCTION avg_mark(student_id_input INTEGER)
RETURNS NUMERIC(5,2)
LANGUAGE plpgsql
AS $$
DECLARE
    avg_grade NUMERIC(5,2);
BEGIN 
    SELECT AVG(field_comprehensions.mark) 
    INTO avg_grade
    FROM field_comprehensions
    WHERE field_comprehensions.student_id = student_id_input; 

    RETURN avg_grade;
END; 
$$;



SELECT avg_mark(847516)
```

### скрипт


```sql
DO $$
DECLARE
    avg_grade NUMERIC(5,2);
BEGIN
    SELECT AVG(field_comprehensions.mark) 
    INTO avg_grade
    FROM field_comprehensions
    WHERE field_comprehensions.student_id = 847516;

    -- Выводим результат
    RAISE NOTICE 'Average grade for student 847516: %', avg_grade;
END;
$$;



```


<img width="334" alt="image" src="https://github.com/user-attachments/assets/476cb388-66c4-43b9-b255-8599bfacc4a5" />

### Простой запрос:

```sql
SELECT AVG(field_comprehensions.mark)  

FROM field_comprehensions
WHERE field_comprehensions.student_id = '847516'; 

```
<img width="580" alt="image" src="https://github.com/user-attachments/assets/d27b7e57-ca9e-4439-9e83-add52797a921" />


### Сравнение времени выполнения в консоле

#### скрипт

<img width="573" alt="image" src="https://github.com/user-attachments/assets/dad4492d-6fd9-44d6-87d6-6c1312609d2d" />


#### Функция

<img width="318" alt="image" src="https://github.com/user-attachments/assets/3cc10083-64c6-477d-869c-012891adc6b0" />

####  обычный запрос

<img width="469" alt="image" src="https://github.com/user-attachments/assets/47fcb973-7cbb-444f-af26-4be541501f88" />

## num 2

Напишите SQL запросы к учебной базе данных в соответствии с вариантом. Вариант к практической части выбирается по формуле: V = (N % 10) +1, где N – номер в списке группы, % - остаток от деления. 

### num 9

Напишите скрипт определяющий знак зодиака каждого студента. Выведите Фамилию, имя, дату рождения и знак зодиака.

т.к. 


| Знак зодиака | Начало | Конец |
|-------------|--------|--------|
| Козерог     | 22 декабря | 19 января |
| Водолей     | 20 января  | 18 февраля |
| Рыбы        | 19 февраля | 20 марта |
| Овен        | 21 марта  | 19 апреля |
| Телец       | 20 апреля | 20 мая |
| Близнецы    | 21 мая   | 20 июня |
| Рак         | 21 июня  | 22 июля |
| Лев         | 23 июля  | 22 августа |
| Дева        | 23 августа | 22 сентября |
| Весы        | 23 сентября | 22 октября |
| Скорпион    | 23 октября | 21 ноября |
| Стрелец     | 22 ноября | 21 декабря |





#### скрипт

```sql
DO $$
DECLARE
    zodiac_sign VARCHAR(20);
    birthday DATE := '1990-03-25'; 
BEGIN
    zodiac_sign := CASE 
        WHEN (EXTRACT(MONTH FROM birthday) = 1 AND EXTRACT(DAY FROM birthday) >= 20) OR (EXTRACT(MONTH FROM birthday) = 2 AND EXTRACT(DAY FROM birthday) <= 18) THEN 'Водолей'
        WHEN (EXTRACT(MONTH FROM birthday) = 2 AND EXTRACT(DAY FROM birthday) >= 19) OR (EXTRACT(MONTH FROM birthday) = 3 AND EXTRACT(DAY FROM birthday) <= 20) THEN 'Рыбы'
        WHEN (EXTRACT(MONTH FROM birthday) = 3 AND EXTRACT(DAY FROM birthday) >= 21) OR (EXTRACT(MONTH FROM birthday) = 4 AND EXTRACT(DAY FROM birthday) <= 19) THEN 'Овен'
        WHEN (EXTRACT(MONTH FROM birthday) = 4 AND EXTRACT(DAY FROM birthday) >= 20) OR (EXTRACT(MONTH FROM birthday) = 5 AND EXTRACT(DAY FROM birthday) <= 20) THEN 'Телец'
        WHEN (EXTRACT(MONTH FROM birthday) = 5 AND EXTRACT(DAY FROM birthday) >= 21) OR (EXTRACT(MONTH FROM birthday) = 6 AND EXTRACT(DAY FROM birthday) <= 20) THEN 'Близнецы'
        WHEN (EXTRACT(MONTH FROM birthday) = 6 AND EXTRACT(DAY FROM birthday) >= 21) OR (EXTRACT(MONTH FROM birthday) = 7 AND EXTRACT(DAY FROM birthday) <= 22) THEN 'Рак'
        WHEN (EXTRACT(MONTH FROM birthday) = 7 AND EXTRACT(DAY FROM birthday) >= 23) OR (EXTRACT(MONTH FROM birthday) = 8 AND EXTRACT(DAY FROM birthday) <= 22) THEN 'Лев'
        WHEN (EXTRACT(MONTH FROM birthday) = 8 AND EXTRACT(DAY FROM birthday) >= 23) OR (EXTRACT(MONTH FROM birthday) = 9 AND EXTRACT(DAY FROM birthday) <= 22) THEN 'Дева'
        WHEN (EXTRACT(MONTH FROM birthday) = 9 AND EXTRACT(DAY FROM birthday) >= 23) OR (EXTRACT(MONTH FROM birthday) = 10 AND EXTRACT(DAY FROM birthday) <= 22) THEN 'Весы'
        WHEN (EXTRACT(MONTH FROM birthday) = 10 AND EXTRACT(DAY FROM birthday) >= 23) OR (EXTRACT(MONTH FROM birthday) = 11 AND EXTRACT(DAY FROM birthday) <= 21) THEN 'Скорпион'
        WHEN (EXTRACT(MONTH FROM birthday) = 11 AND EXTRACT(DAY FROM birthday) >= 22) OR (EXTRACT(MONTH FROM birthday) = 12 AND EXTRACT(DAY FROM birthday) <= 21) THEN 'Стрелец'
        WHEN (EXTRACT(MONTH FROM birthday) = 12 AND EXTRACT(DAY FROM birthday) >= 22) OR (EXTRACT(MONTH FROM birthday) = 1 AND EXTRACT(DAY FROM birthday) <= 19) THEN 'Козерог'
    END;

 
    RAISE NOTICE 'Zodiac sign for birthday %: %', birthday, zodiac_sign;
END;
$$;

```
<img width="1400" alt="image" src="https://github.com/user-attachments/assets/ed14c355-f1af-4fda-80ac-1267d15dfb02" />


#### функция

```sql

CREATE OR REPLACE FUNCTION ZODIAC_3_0(birthday date)
RETURNS VARCHAR(20)
LANGUAGE plpgsql
AS $$
BEGIN 

 RETURN CASE 
        WHEN (EXTRACT(MONTH FROM birthday) = 1 AND EXTRACT(DAY FROM birthday) >= 20) OR (EXTRACT(MONTH FROM birthday) = 2 AND EXTRACT(DAY FROM birthday) <= 18) THEN 'Водолей'
        WHEN (EXTRACT(MONTH FROM birthday) = 2 AND EXTRACT(DAY FROM birthday) >= 19) OR (EXTRACT(MONTH FROM birthday) = 3 AND EXTRACT(DAY FROM birthday) <= 20) THEN 'Рыбы'
        WHEN (EXTRACT(MONTH FROM birthday) = 3 AND EXTRACT(DAY FROM birthday) >= 21) OR (EXTRACT(MONTH FROM birthday) = 4 AND EXTRACT(DAY FROM birthday) <= 19) THEN 'Овен'
        WHEN (EXTRACT(MONTH FROM birthday) = 4 AND EXTRACT(DAY FROM birthday) >= 20) OR (EXTRACT(MONTH FROM birthday) = 5 AND EXTRACT(DAY FROM birthday) <= 20) THEN 'Телец'
        WHEN (EXTRACT(MONTH FROM birthday) = 5 AND EXTRACT(DAY FROM birthday) >= 21) OR (EXTRACT(MONTH FROM birthday) = 6 AND EXTRACT(DAY FROM birthday) <= 20) THEN 'Близнецы'
        WHEN (EXTRACT(MONTH FROM birthday) = 6 AND EXTRACT(DAY FROM birthday) >= 21) OR (EXTRACT(MONTH FROM birthday) = 7 AND EXTRACT(DAY FROM birthday) <= 22) THEN 'Рак'
        WHEN (EXTRACT(MONTH FROM birthday) = 7 AND EXTRACT(DAY FROM birthday) >= 23) OR (EXTRACT(MONTH FROM birthday) = 8 AND EXTRACT(DAY FROM birthday) <= 22) THEN 'Лев'
        WHEN (EXTRACT(MONTH FROM birthday) = 8 AND EXTRACT(DAY FROM birthday) >= 23) OR (EXTRACT(MONTH FROM birthday) = 9 AND EXTRACT(DAY FROM birthday) <= 22) THEN 'Дева'
        WHEN (EXTRACT(MONTH FROM birthday) = 9 AND EXTRACT(DAY FROM birthday) >= 23) OR (EXTRACT(MONTH FROM birthday) = 10 AND EXTRACT(DAY FROM birthday) <= 22) THEN 'Весы'
        WHEN (EXTRACT(MONTH FROM birthday) = 10 AND EXTRACT(DAY FROM birthday) >= 23) OR (EXTRACT(MONTH FROM birthday) = 11 AND EXTRACT(DAY FROM birthday) <= 21) THEN 'Скорпион'
        WHEN (EXTRACT(MONTH FROM birthday) = 11 AND EXTRACT(DAY FROM birthday) >= 22) OR (EXTRACT(MONTH FROM birthday) = 12 AND EXTRACT(DAY FROM birthday) <= 21) THEN 'Стрелец'
        WHEN (EXTRACT(MONTH FROM birthday) = 12 AND EXTRACT(DAY FROM birthday) >= 22) OR (EXTRACT(MONTH FROM birthday) = 1 AND EXTRACT(DAY FROM birthday) <= 19) THEN 'Козерог'
    END;


END;
$$;

```

```sql
SELECT 
    last_name, 
    first_name, 
    birthday, 
    ZODIAC_3_0(birthday) AS zodiac_sign
FROM students;

```

<img width="571" alt="image" src="https://github.com/user-attachments/assets/08bba441-b170-4efd-8d03-810a96b03011" />

### num 19

Напишите скрипт, генерирующий случайное местоположение каждого студента на карте (его координаты в градусах).  Определите материк, соответствующий этим координатам. Считайте, попаданием на материк, если координаты лежат в пределах:
Европа – между 1° с.ш. и 77° с.ш.  и между 9° з.д. и 67° в.д. 
Африка – между 37° с.ш. и 34° ю.ш.  и между 13° з.д. и 51° в.д. 
Австралия – между 10° ю.ш. и 39° ю.ш.  и между 113° в.д. и 153° в.д. 
Северная Америка – между 7° с.ш. и 71° с.ш.  и между 55° з.д. и 168° з.д. 
Южная Америка – между 12° с.ш. и 53° ю.ш.  и между 34° з.д. и 81° з.д. 
Антарктида– ниже 63° ю.ш.  

```sql
BEGIN;

-- Создание таблицы для хранения местоположения студентов
CREATE TABLE IF NOT EXISTS public.student_locations (
    student_id INTEGER PRIMARY KEY REFERENCES public.students(student_id),
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    continent VARCHAR(20) NOT NULL
);

-- Функция для определения материка по координатам
CREATE OR REPLACE FUNCTION get_continent(lat DOUBLE PRECISION, lon DOUBLE PRECISION) RETURNS VARCHAR AS $$
BEGIN
    IF lat BETWEEN 1 AND 77 AND lon BETWEEN -9 AND 67 THEN
        RETURN 'Europe';
    ELSIF lat BETWEEN -34 AND 37 AND lon BETWEEN -13 AND 51 THEN
        RETURN 'Africa';
    ELSIF lat BETWEEN -39 AND -10 AND lon BETWEEN 113 AND 153 THEN
        RETURN 'Australia';
    ELSIF lat BETWEEN 7 AND 71 AND lon BETWEEN -168 AND -55 THEN
        RETURN 'North America';
    ELSIF lat BETWEEN -53 AND 12 AND lon BETWEEN -81 AND -34 THEN
        RETURN 'South America';
    ELSIF lat < -63 THEN
        RETURN 'Antarctica';
    ELSE
        RETURN 'Ocean';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Заполнение таблицы случайными координатами
INSERT INTO public.student_locations (student_id, latitude, longitude, continent)
SELECT 
    student_id,
    ROUND((RANDOM() * 180 - 90)::NUMERIC, 6)::DOUBLE PRECISION AS latitude,
    ROUND((RANDOM() * 360 - 180)::NUMERIC, 6)::DOUBLE PRECISION AS longitude,
    get_continent(
        ROUND((RANDOM() * 180 - 90)::NUMERIC, 6)::DOUBLE PRECISION,
        ROUND((RANDOM() * 360 - 180)::NUMERIC, 6)::DOUBLE PRECISION
    ) AS continent
FROM public.students;

COMMIT;
```


<img width="654" alt="image" src="https://github.com/user-attachments/assets/c0e602dc-438c-45d4-85ba-cdc908e544ec" />





### num 29
Создайте процедуру продления студенческих билетов у определенной группы на 1 год. Входной параметр - номер группы

```sql
CREATE OR REPLACE PROCEDURE extend_student_ids(group_number VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE student_ids
    SET expiration_date = expiration_date + INTERVAL '1 year'
    WHERE student_id IN (SELECT student_id FROM students WHERE students_group_number = extend_student_ids.group_number);
END;
$$ ;
```

```sql
SELECT student_ids.student_id, expiration_date, students.students_group_number
FROM student_ids
JOIN students ON students.student_id =student_ids. student_id

CALL extend_student_ids('ИВТ-11');
```

<img width="728" alt="image" src="https://github.com/user-attachments/assets/b611b0a5-dc14-47c8-8240-0e8a5e3bf1a0" />

<img width="718" alt="image" src="https://github.com/user-attachments/assets/154c9abf-62d7-4403-8927-ad8dd7ec554b" />


### num 39

Создайте функцию, которая считает количество преподавателей, в структурном подразделении с номером N. N вводится в качестве параметра.

```sql
CREATE OR REPLACE FUNCTION count_professors_in_unit(unit_id INT) 
RETURNS INT 
LANGUAGE plpgsql
AS $$
DECLARE
    professor_count INT;
BEGIN
    SELECT COUNT(*) INTO professor_count
    FROM employments
    WHERE structural_unit_id = unit_id;
    
    RETURN professor_count;
END;
$$ ;
```

```sql
SELECT count_professors_in_unit(1) AS professor_count;
```
<img width="527" alt="image" src="https://github.com/user-attachments/assets/08c004db-8948-4c19-b98d-52bc4a916610" />


### num 49

Создайте функцию, выводящую всех преподавателей, преподающих в определенном структурном подразделении


```sql
CREATE OR REPLACE FUNCTION get_professors_in_unit(unit_id INT) 
RETURNS TABLE (professor_id INT, last_name VARCHAR, first_name VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT p.professor_id, p.last_name, p.first_name
    FROM professors p
    JOIN employments e ON p.professor_id = e.professor_id
    WHERE e.structural_unit_id = unit_id;
END;
$$;
```

```sql
SELECT * FROM get_professors_in_unit(1);
```

<img width="388" alt="image" src="https://github.com/user-attachments/assets/83a5644f-553e-46dd-aba4-113b36bfb08b" />


### num 59

Создайте триггер, запрещающий ставить студенту больше 4 двоек.

```sql
CREATE OR REPLACE FUNCTION prevent_too_many_Badmarks() 
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    fail_count INT;
BEGIN
    SELECT COUNT(*) INTO fail_count
    FROM field_comprehensions
    WHERE student_id = NEW.student_id AND mark = 2;
    
    IF fail_count >= 4 THEN
        RAISE EXCEPTION 'Студент уже имеет 4 или более двоек';
    END IF;
    
    RETURN NEW;
END;
$$;


CREATE TRIGGER prevent_too_many_Badmarks_trigger
BEFORE INSERT OR UPDATE ON field_comprehensions
FOR EACH ROW
EXECUTE FUNCTION prevent_too_many_Badmarks();  
```

```sql
SELECT students.student_id, students.last_name, field_comprehensions.mark,
							field_comprehensions.field 
									, fields.field_name
FROM students
JOIN field_comprehensions ON field_comprehensions.student_id  = students.student_id
JOIN fields ON fields.field_id = field_comprehensions.field
WHERE students.student_id = '847516'
ORDER BY field_comprehensions.mark


INSERT INTO field_comprehensions (student_id, field, mark)
VALUES (847516, 'e1feba4f-dd12-46dc-b4a9-b56af65fb1d4', 2);
```

<img width="1123" alt="image" src="https://github.com/user-attachments/assets/478dfed8-b602-4c58-8280-75fbef41e216" />

<img width="654" alt="image" src="https://github.com/user-attachments/assets/46359778-b759-4a3b-89fd-35add6506903" />


### num 69

Создайте триггер, сохраняющий информацию об изменениях оценок у студентов.


```sql
CREATE TABLE  mark_changes (
    change_id SERIAL PRIMARY KEY,
    student_id INT,
    field_id UUID,
    old_mark INT,
    new_mark INT,
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```


```sql
CREATE OR REPLACE FUNCTION log_mark_changes() 
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF OLD.mark IS DISTINCT FROM NEW.mark THEN
        INSERT INTO mark_changes (student_id, field_id, old_mark, new_mark)
        VALUES (OLD.student_id, OLD.field, OLD.mark, NEW.mark);
    END IF;
    
    RETURN NEW;
END;
$$ ;

CREATE TRIGGER log_mark_changes_trigger
AFTER UPDATE ON field_comprehensions
FOR EACH ROW
EXECUTE FUNCTION log_mark_changes();
```


```sql
SELECT students.student_id, students.last_name, field_comprehensions.mark,
							field_comprehensions.field 
									, fields.field_name
FROM students
JOIN field_comprehensions ON field_comprehensions.student_id  = students.student_id
JOIN fields ON fields.field_id = field_comprehensions.field
WHERE students.student_id = '847516'
ORDER BY field_comprehensions.mark
```

```sql
UPDATE field_comprehensions
SET mark = 4
WHERE student_id = 847516 AND field = 'a3043707-440b-4bc4-bd1c-defdfe87f745';
```


<img width="1054" alt="image" src="https://github.com/user-attachments/assets/83ce9881-fbb5-45c0-a263-6266475bfdf4" />

<img width="1126" alt="image" src="https://github.com/user-attachments/assets/2cb816d8-dac3-490f-966e-939ccf84fa3d" />

<img width="843" alt="image" src="https://github.com/user-attachments/assets/380a495d-f931-488a-a5c2-74dc28db432f" />


## num 3

Для добавленной в 4-й лабораторной работе таблицы создайте любой триггер. 

 создам триггер, который будет автоматически обновлять поле last_update_date в таблице portfolio при добавлении или изменении записей в связанных таблицах (achievements, projects, skills).

 ```sql
CREATE OR REPLACE FUNCTION update_portfolio_last_update_date()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Обновляем поле last_update_date в таблице portfolio
    UPDATE portfolio
    SET last_update_date = CURRENT_DATE
    WHERE portfolio_id = (
        CASE
            WHEN TG_TABLE_NAME = 'achievements' THEN NEW.portfolio_id
            WHEN TG_TABLE_NAME = 'projects' THEN NEW.portfolio_id
            WHEN TG_TABLE_NAME = 'skills' THEN NEW.portfolio_id
        END
    );

    RETURN NEW;
END;
$$;

```

Для таблицы achievements:

```sql
CREATE TRIGGER update_portfolio_after_achievements_change
AFTER INSERT OR UPDATE OR DELETE ON achievements
FOR EACH ROW
EXECUTE FUNCTION update_portfolio_last_update_date();
```

Для таблицы projects:

```sql
CREATE TRIGGER update_portfolio_after_projects_change
AFTER INSERT OR UPDATE OR DELETE ON projects
FOR EACH ROW
EXECUTE FUNCTION update_portfolio_last_update_date();
```

Для таблицы skills:
```sql
CREATE TRIGGER update_portfolio_after_skills_change
AFTER INSERT OR UPDATE OR DELETE ON skills
FOR EACH ROW
EXECUTE FUNCTION update_portfolio_last_update_date();
```


```sql
INSERT INTO achievements (portfolio_id, achievement_name, description, date)
VALUES (13, 'Победа в олимпиаде', '1 место по математике', '2023-10-01');

UPDATE projects
SET project_name = 'Новый проект'
WHERE project_id = 13;

```


<img width="546" alt="image" src="https://github.com/user-attachments/assets/8eca0402-b4f5-4955-a156-f5f3c940598f" />
