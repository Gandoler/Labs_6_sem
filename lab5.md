# lab 5

## num 1
Пересчитайте ставки преподавателей в соответствии с средним значением (округлите до целого) ЗЕТ дисциплин, которые он ведет, из расчета, что полная ставка соответствует 6 ЗЕТ. Значение ставки округлите до сотых.

### ситуация до 

<img width="840" alt="image" src="https://github.com/user-attachments/assets/bc390fba-8c84-413f-a843-c61013b77182" />
!. видимо будут понижения.....
```sql
WITH ProfessorZET AS (
    SELECT
        field_professors.professor_id,
        ROUND(AVG(fields.zet)) AS avg_zet 
    FROM
        field_professors 
    JOIN
        fields  ON field_professors.field_id = fields.field_id
    GROUP BY
        field_professors.professor_id
)



SELECT Professors.last_name,Professors.first_name, Professors.salary, ProfessorZET.avg_zet  
FROM Professors


Join ProfessorZET ON ProfessorZET.professor_id = Professors.professor_id

Order BY (Professors.salary) DESC

```
### ситуация после

```sql
WITH ProfessorZET AS (
    SELECT
        field_professors.professor_id,
        ROUND(AVG(fields.zet)) AS avg_zet 
    FROM
        field_professors 
    JOIN
        fields  ON field_professors.field_id = fields.field_id
    GROUP BY
        field_professors.professor_id
)


UPDATE professors
SET salary = ROUND((ProfessorZET.avg_zet / 6.0) * salary::numeric)

FROM
    ProfessorZET
WHERE
    professors.professor_id = ProfessorZET.professor_id;


```
<img width="837" alt="image" src="https://github.com/user-attachments/assets/38605222-ab3d-415a-8b0e-58a69637eeb6" />

стало грустнее

## num 2
