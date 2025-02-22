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


