# lab 6

## num 1
Напишите скрипт на языке PL/pgSQL, вычисляющий среднюю оценку студента. Аналогичный запрос напишите на языке SQL. Сравните время выполнения работы в обоих случаях. Для расчета времени выполнения скрипта, запустите его в терминале psql, перед этим запустив таймер с помощью команды \timing. Для того, чтобы отключить таймер после окончания работы, выполните команду \timing off.

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

```
