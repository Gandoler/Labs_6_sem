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

Автоматически заполните поле, содержащее номер аудитории подразделения в формате, установленном в предыдущей лабораторной работе (AAXX, где AA могут принимать значения 29, 25, 14, 33, 87). Выбор первых двух цифр аудитории организуйте рандомно из списка допустимых значений. Последние две цифры – количество букв полном названии подразделения.
<img width="763" alt="image" src="https://github.com/user-attachments/assets/6471303d-3749-43d6-9345-f6746f519633" />
 
 ```sql
UPDATE structural_units
SET room_number = CONCAT(
    (ARRAY['29', '25', '14', '33', '87'])[FLOOR(RANDOM() * 5) + 1], 
    LPAD(CHAR_LENGTH(full_title)::VARCHAR, 2, '0') 
);
```

<img width="1002" alt="image" src="https://github.com/user-attachments/assets/7f78a6d4-c378-4352-95bf-eddba9926696" />

тк лабой ранее было задание: Отредактируйте базу данных в соответствии с вашим вариантом. Добавьте в таблицу structural_units поле, содержащее номер аудитории подразделения. Сделайте ограничение, позволяющее хранить номер аудитории в формате: ABXX, где A может принимать значения 1,3,4; B – от 1-3. Значение XX может лежать от 00 до 39



чуть перепишем запрос по условия 

```sql
UPDATE structural_units
SET room_number = CONCAT(
    (ARRAY['1', '3', '4'])[FLOOR(RANDOM() * 3) + 1],
    (ARRAY['1', '2', '3'])[FLOOR(RANDOM() * 3) + 1],
    LPAD(LEAST(CHAR_LENGTH(full_title), 39)::VARCHAR, 2, '0')
);
```


<img width="793" alt="image" src="https://github.com/user-attachments/assets/9230c5bf-2da1-4ab0-9750-f083a4d1e833" />

### обьяснение запросика

```sql
UPDATE structural_units
SET room_number = CONCAT(
    (ARRAY['1', '3', '4'])[FLOOR(RANDOM() * 3) + 1],
    (ARRAY['1', '2', '3'])[FLOOR(RANDOM() * 3) + 1],
    LPAD(LEAST(CHAR_LENGTH(full_title), 39)::VARCHAR, 2, '0')
);
```

1. **Генерация первой буквы `A`**
   ```sql
   (ARRAY['1', '3', '4'])[FLOOR(RANDOM() * 3) + 1]
   ```
   - Создаём массив `['1', '3', '4']`.
   - `RANDOM()` возвращает случайное число от `0` до `1`.
   - `FLOOR(RANDOM() * 3) + 1` генерирует случайный индекс от `1` до `3`.
   - Выбираем случайное значение `A` из массива.

2. **Генерация второй буквы `B`**
   ```sql
   (ARRAY['1', '2', '3'])[FLOOR(RANDOM() * 3) + 1]
   ```
   - Аналогично, создаём массив `['1', '2', '3']`.
   - Случайным образом выбираем `B`.

3. **Генерация двузначного числа `XX`**
   ```sql
   LPAD(LEAST(CHAR_LENGTH(full_title), 39)::VARCHAR, 2, '0')
   ```
   - `CHAR_LENGTH(full_title)` — получаем длину строки `full_title`.
   - `LEAST(CHAR_LENGTH(full_title), 39)` — ограничиваем значение сверху (если длина `full_title` больше `39`, используем `39`).
   - `::VARCHAR` — приводим число к строке.
   - `LPAD(..., 2, '0')` — дополняем строку слева нулями до двух символов.





## num 3
В зависимости от варианта, добавьте значения в исправленную вами базу данных в прошлой лабораторной работе. В каждую из таблиц необходимо добавить не менее 10 осмысленных значений. 


```sql

SELECT * FROM portfolio;

SELECT * FROM achievements;

SELECT * FROM projects;

SELECT * FROM skills;

```
<img width="518" alt="image" src="https://github.com/user-attachments/assets/4c2340a2-fdf9-4500-a2db-1c3b8abcd6df" />
<img width="823" alt="image" src="https://github.com/user-attachments/assets/fbff793d-78a4-4669-a942-db4381282ecd" />
<img width="956" alt="image" src="https://github.com/user-attachments/assets/205c2653-93fa-42ee-984d-882101e48297" />
<img width="607" alt="image" src="https://github.com/user-attachments/assets/9b97e053-a47b-4838-924d-4582d49c929c" />

