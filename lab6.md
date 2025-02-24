# lab 6

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

<img width="334" alt="image" src="https://github.com/user-attachments/assets/476cb388-66c4-43b9-b255-8599bfacc4a5" />

### Простой запрос:

```sql
SELECT AVG(field_comprehensions.mark)  

FROM field_comprehensions
WHERE field_comprehensions.student_id = '847516'; 

```
<img width="580" alt="image" src="https://github.com/user-attachments/assets/d27b7e57-ca9e-4439-9e83-add52797a921" />


### Сравнение времени выполнения в консоле

#### Функция

<img width="318" alt="image" src="https://github.com/user-attachments/assets/3cc10083-64c6-477d-869c-012891adc6b0" />

####  обычный запрос

<img width="469" alt="image" src="https://github.com/user-attachments/assets/47fcb973-7cbb-444f-af26-4be541501f88" />

