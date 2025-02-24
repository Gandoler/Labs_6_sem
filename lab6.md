
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

Напишите скрипт имитирующий шахматный турнир. Выберите случайным образом 10 студентов.  Каждый играет с каждым по одному разу. Результат игры между двумя участниками выбирается рандомно из победы (победивший получает 2 очка, проигравший 0) и ничьи (каждому добавляется по одному баллу). После проведения первого тура отсеиваются 2 участника набравшие наименьшее количество очков. Проводится 2 тур между оставшимися 8 студентами. И так продолжать до тех пор, пока не останутся два победителя. Вывести результаты каждой игры каждого тура (фамилии участников и результат игры) и также для каждого тура итоговые таблицы всех участников с суммой полученных баллов в порядке убывания очков.
