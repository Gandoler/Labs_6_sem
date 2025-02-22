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

