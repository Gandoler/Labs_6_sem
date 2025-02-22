# lab 3
## Num 1
<img width="590" alt="image" src="https://github.com/user-attachments/assets/e43de129-60dd-4b0d-aa19-ae26f7b7fda7" />
<img width="465" alt="image" src="https://github.com/user-attachments/assets/64067ef0-8ac2-471b-9a03-79c8be83fa63" />
<img width="478" alt="image" src="https://github.com/user-attachments/assets/1fffaf47-c245-4017-b100-ed13b4588442" />

т.к команда count(*) - учитывает все результаты включая null

<img width="460" alt="image" src="https://github.com/user-attachments/assets/ecf1520f-2a4f-4849-862f-7549e6bee4a7" />

## Num 2

<img width="603" alt="image" src="https://github.com/user-attachments/assets/202b4311-98d4-4434-b7e4-374158e5e96a" />

### 9
Вывести ФИО преподавателей, названия преподаваемых ими дисциплин. Отсортировать по фамилии и имени.

<img width="913" alt="image" src="https://github.com/user-attachments/assets/26c8a20d-4664-4f77-b2eb-62c87de7b569" />

```sql
SELECT Professors.last_name, Professors.first_name, Professors.patronymic, Fields.field_name
FROM Professors
JOIN Fields ON Fields.professor_id = Professors.professor_id
ORDER BY Professors.last_name, Professors.first_name;
```

### 19
Вывести ФИО всех студентов с оценками, освоивших дисциплину «Философия» меньше, чем на 4. Отсортировать по фамилии и имени.

<img width="697" alt="image" src="https://github.com/user-attachments/assets/adb731ef-6811-435b-b4ba-266706ee9c17" />

```sql
with Field_and_Marks AS(
SELECT  Field_comprehensions.student_id,field_name, mark
FROM Fields
JOIN Field_comprehensions ON Field_comprehensions.field = Fields.field_id
WHERE field_name = 'Философия' AND Field_comprehensions.mark < 4
)
SELECT last_name, first_name, patronymic 
FROM Students
JOIN Field_and_Marks ON Field_and_Marks.student_id = Students.student_id
ORDER BY Students.last_name, Students.first_name
```

### 29
Подсчитать количество всех оценок у студентов чьи номера студенческих билетов лежат в интервале 820000–850000. Вывести фамилию, имя, номер студенческого, оценку и ее количество. Исключить из подсчета незаполненные поля оценок. Отсортировать по номеру студенческого билета.

<img width="718" alt="image" src="https://github.com/user-attachments/assets/a771e73d-0905-42bd-b599-cb7353132c68" />

```sql
SELECT 
    Students.last_name, 
    Students.first_name, 
    Students.student_id, 
    Field_comprehensions.mark, 
    COUNT(Field_comprehensions.mark) AS mark_count
FROM Students
JOIN Field_comprehensions ON Students.student_id = Field_comprehensions.student_id
WHERE 
    Students.student_id BETWEEN 820000 AND 850000 
    AND Field_comprehensions.mark IS NOT NULL
GROUP BY 
    Students.last_name, 
    Students.first_name, 
    Students.student_id, 
    Field_comprehensions.mark
ORDER BY 
    Students.student_id;
```

### 39
Выведите полные названия структурных подразделений, название групп в него входящих и количество студентов в каждой группе.  Оставьте только группы содержащие в своем названии буквы “В” и “Б” и оканчивающиеся цифрой “1”. Отсортируйте по номеру группы.


<img width="703" alt="image" src="https://github.com/user-attachments/assets/4ea10472-9aa8-43d3-87c0-4dc92089b7e3" />

```sql
WITH students_in_group AS (
    SELECT 
        Students_groups.students_group_number, 
        COUNT(Students.student_id) AS amount
    FROM Students_groups
    JOIN Students ON Students_groups.students_group_number = Students.students_group_number
    GROUP BY Students_groups.students_group_number
)

SELECT Structural_units.full_title, Students_groups.students_group_number, students_in_group.amount
FROM Structural_units
JOIN Students_groups ON Students_groups.structural_unit_id = Structural_units.structural_unit_id
JOIN students_in_group ON students_in_group.students_group_number = Students_groups.students_group_number
WHERE Students_groups.students_group_number ~ '.*[ВБ].*1$'
ORDER BY(Students_groups.students_group_number)

```

### 49

Вывести всех руководителей структурных подразделений, их номера телефонов и ФИ и электронные почты всех студентов

<img width="918" alt="image" src="https://github.com/user-attachments/assets/5f67442d-21b5-49f2-a659-5b3bc73b478d" />

```sql
SELECT Structural_units.head_of_the_unit, Structural_units.phone_number,
		Students.last_name, Students.first_name, Students.email
FROM Structural_units
JOIN Students_groups ON Students_groups.structural_unit_id = Structural_units.structural_unit_id
JOIN Students ON Students_groups.students_group_number = Students.students_group_number
```


### 59

Вывести ФИО, оклад и должность всех преподавателей, кроме преподавателей МПСУ. Сортировать по убыванию оклада. Использовать EXCEPT.

<img width="769" alt="image" src="https://github.com/user-attachments/assets/e29c89c0-f7d9-4254-beb4-a49c9503a586" />

```sql
WITH All_Professors AS (
    SELECT 
        Professors.professor_id AS IDS
    FROM 
        Professors
),

MPSU_Professors AS (
    SELECT 
        Professors.professor_id AS IDS
    FROM 
        Professors
    JOIN 
        Employments ON Employments.professor_id = Professors.professor_id
    JOIN 
        Structural_units ON Structural_units.structural_unit_id = Employments.structural_unit_id
    WHERE 
        Structural_units.full_title = 'МПСУ'
)


SELECT Professors.last_name, Professors.first_name, Professors.patronymic,
			Professors.salary, Professors.current_position
FROM Professors
JOIN 
    (SELECT IDS FROM All_Professors
     EXCEPT
     SELECT IDS FROM MPSU_Professors) AS Filtered_Professors
ON 
    Professors.professor_id = Filtered_Professors.IDS
ORDER BY(Professors.salary)


```


### 69

Найдите ФИО всех девушек среди студентов (пол определить по окончанию фамилии или отчества).  Используя найденную информацию выведите всех юношей среди студентов.
    
<img width="477" alt="image" src="https://github.com/user-attachments/assets/7287012d-4612-446e-8477-7e9f16396fd7" />


```sql
with female AS(
SELECT last_name, first_name, patronymic
FROM Students
WHERE  last_name LIKE '%а' 
        OR last_name LIKE '%я' 
        OR patronymic LIKE '%на' 
        OR patronymic LIKE '%ич'

)

SELECT last_name, first_name, patronymic
FROM Students
EXCEPT (SELECT 
    last_name, 
    first_name, 
    patronymic
FROM 
    female)

```

### 79
Вывести фамилия, имя и оклад всех преподавателей, чей оклад меньше среднего. Отсортируйте по окладу в порядке убывания. Первой строчкой выведите средний оклад.

<img width="671" alt="image" src="https://github.com/user-attachments/assets/65d3647b-aac1-4a94-b7ab-992401656e4d" />

```sql

SELECT 
    'Средний оклад' AS last_name, 
    NULL AS first_name, 
    (AVG(salary::NUMERIC))::MONEY AS salary
FROM 
    Professors

UNION ALL

SELECt last_name, first_name,  salary
FROM 
    Professors
WHERE 
    salary::NUMERIC < (SELECT AVG(salary::NUMERIC) FROM Professors)
ORDER BY 
    salary DESC;


```

### 89

Вывести фамилию, имя всех студентов, чей средний балл выше среднего балла в ИТД-21 

<img width="686" alt="image" src="https://github.com/user-attachments/assets/4ede504a-a34e-4cb6-be8f-94981b6bd523" />

``` sql

WITH avg_markIn_ITD AS (
    SELECT AVG(mark) AS avg_mark
    FROM Field_comprehensions
    JOIN Students ON Field_comprehensions.student_id = Students.student_id
    JOIN Students_groups ON Students.students_group_number = Students_groups.students_group_number
    WHERE Students_groups.students_group_number = 'ИТД-21'
),

avg_mark_students AS (
    SELECT 
        Students.student_id, 
        AVG(Field_comprehensions.mark) AS avg_mark
    FROM 
        Students
    JOIN 
        Field_comprehensions ON Students.student_id = Field_comprehensions.student_id
    GROUP BY 
        Students.student_id
)


SELECT last_name, first_name
FROM Students
JOIN avg_mark_students ON avg_mark_students.student_id = Students.student_id
CROSS JOIN 
    avg_markIn_ITD 
WHERE     avg_mark_students.avg_mark > avg_markIn_ITD.avg_mark;

```

### 99
<img width="699" alt="image" src="https://github.com/user-attachments/assets/a5bb08b9-1a06-4d70-b5a1-828d67b99f14" />


```sql
SELECT 
    last_name, 
    first_name, 
    patronymic, 
    birthday
FROM 
    Students
WHERE 
    birthday = (SELECT MAX(birthday) FROM Students);
```


## NUM 3
<img width="1083" alt="image" src="https://github.com/user-attachments/assets/3403fda6-bec4-4ec8-bc12-10111ff88a74" />

### 1
