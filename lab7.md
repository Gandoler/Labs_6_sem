<img width="1029" alt="image" src="https://github.com/user-attachments/assets/98dc44d6-c5d8-4603-811f-94a013e493e2" />![image](https://github.com/user-attachments/assets/e1781bb9-e5e1-4e3b-916c-e4423e9f7a66)<img width="753" alt="image" src="https://github.com/user-attachments/assets/15e83d50-a0b4-43b0-93f5-1535b018045c" /># lab 7 

## num 1 
Исследование производительности системы
Создайте таблицу, содержащую значения посещаемости студентом института. Таблица содержит номер студенческого билета, время его входа, выхода и сгенерированное случайное кодовое число при выходе из вуза.  


```sql
CREATE TABLE attendance (
attendance_id SERIAL PRIMARY KEY, 
generated_code VARCHAR(64),
person_id integer,
enter_time timestamp,
exit_time timestamp,
FOREIGN KEY (person_id) REFERENCES student_ids (student_id)
);

```

С помощью следующего скрипта заполните таблицу данными. 

```sql
do
$$
DECLARE 
	enter_time timestamp(0);
	exit_time timestamp(0);
	person_id integer; 
	enter_id VARCHAR(64);
BEGIN
	FOR i IN 1..1000000 LOOP

-- Генерируем случайную дату в указанном диапазоне

	enter_time := to_timestamp(random() * 
(
						extract(epoch from '2023-12-31'::date) - 
						extract(epoch from '2023-01-01'::date)
					)
					 	+ extract(epoch from '2023-01-01'::date)
					);

-- Генерируем случайный интервал времени, который пробыл в вузе студент (не более 10 часов)

	exit_time := enter_time + (floor(random() * 36000 + 1)*'1 SECOND'::interval);
	
person_id := (
				SELECT student_id FROM students
				ORDER BY random()
				LIMIT 1
			);

	enter_id := md5(random()::text);

    	INSERT INTO attendance(generated_code, person_id, enter_time,exit_time) 
VALUES(enter_id, person_id, enter_time, exit_time);

	END LOOP;	
END
$$;

```
 ### 1.1

Добавьте в таблицу attendance одно значение, измерив время данной операции. Далее измерьте время выполнения запроса, выводящего содержимого таблицы в отсортированном виде по столбцу generated_code. 
Добавьте индекс на столбец generated_code. Повторите предыдущие две операции. Сравните полученное время. Во сколько раз оно изменилось? Результаты вычисления занесите в таблицу. 

 
1. **Операция 1: Вставка значения в таблицу `attendance`**


```sql
--рандомить будет не честно

INSERT INTO attendance(generated_code, person_id, enter_time, exit_time) 
VALUES (md5(random()::text), 847516, NOW(), NOW() + '5 hours'::interval);
-- минус

INSERT INTO attendance(generated_code, person_id, enter_time, exit_time) 
VALUES ('fixed_code_123', 847516, '2023-10-01 09:00:00', '2023-10-01 14:00:00');
```

   - Без индекса:
     | Операция | Время выполнения |
     |----------|------------------|
     | Вставка  |  3,403 ms        |

<img width="674" alt="image" src="https://github.com/user-attachments/assets/5902ef3c-b74d-4010-b3ce-781f60e05c5b" />


   - С индексом:
     | Операция | Время выполнения |
     |----------|------------------|
     | Вставка  |    1,940 ms      |
     
<img width="676" alt="image" src="https://github.com/user-attachments/assets/625d2966-9cd0-45dc-8716-ac9cd23d54ac" />

1. **Операция 2: Выборка содержимого таблицы `attendance` отсортированного по столбцу `generated_code`**

```sql
SELECT * FROM attendance ORDER BY generated_code LIMIT 10;
```

   - Без индекса:
     | Операция | Время выполнения |
     |----------|------------------|
     | Выборка  | 56,785 ms    |


<img width="752" alt="image" src="https://github.com/user-attachments/assets/0c3696d3-fd2a-4cd7-bac6-a3f94ae6d07e" />

   - С индексом:
     | Операция | Время выполнения |
     |----------|------------------|
     | Выборка  |     3,140 ms     |

<img width="766" alt="image" src="https://github.com/user-attachments/assets/3b288b24-961c-4b66-af96-96bb7ec853c7" />


2. **Сравнение времени выполнения операций до и после добавления индекса**

<img width="606" alt="image" src="https://github.com/user-attachments/assets/029003f8-80fd-4317-a055-2eff40710cd9" />


   | Операция | Время до индексирования T<sub>b</sub> | Время после индексирования T<sub>a</sub> | T<sub>a</sub>/T<sub>b</sub> |
   |----------|--------------------------------------|----------------------------------------|-----------------------------|
   | SELECT   | 56,785 ms                            |     3,140 ms                           | 18                          |
   | INSERT   | 3,403 ms                             |     1,940 ms                           | 1.75                        |

ну и тут проблема с выводом 1000000 записей


с индексом 

<img width="1039" alt="image" src="https://github.com/user-attachments/assets/7ab27cc3-d84a-4c90-a790-a7c6d7959f7b" />


без индекса 

<img width="969" alt="image" src="https://github.com/user-attachments/assets/79d141c0-e041-42f0-a975-e99426cc6129" />




### 1.2
Выполните запрос, выводящий все строки таблицы attendance, измерьте время его выполнения. Добавьте условие, выбрав только все записи, связанные с одним конкретным студентом. Аналогично измерьте время выполнения. Создайте индекс на атрибут person_id и повторите эксперименты. Сравните время выполнения операций до создания индекса и после. Объясните полученный результат.


что бы все было честно в начале

```sql
DROP INDEX idx_generated_code;
```

## Результаты измерений

1. **Запрос без условий (SELECT)**

   - Без индекса:
     | Операция | Время выполнения |
     |----------|------------------|
     | SELECT   | 100,987	   |

```sql
SELECT * FROM attendance LIMIT 10;
```

<img width="753" alt="image" src="https://github.com/user-attachments/assets/93919c76-c9d0-468c-95b3-a93553d8fe26" />

```sql
EXPLAIN ANALYZE SELECT * FROM attendance;
```

<img width="842" alt="image" src="https://github.com/user-attachments/assets/4a436ff7-971b-4dfc-b407-53aa0e97bf2f" />

   - С индексом:
     | Операция | Время выполнения |
     |----------|------------------|
     | SELECT   | 89,818    |



<img width="839" alt="image" src="https://github.com/user-attachments/assets/9478608e-6e52-432c-ade9-e51fb10f31bc" />


2. **Запрос с условием (SELECT + WHERE)**

   - Без индекса:
     | Операция | Время выполнения |
     |----------|------------------|
     | SELECT + WHERE | 53,450 |

```sql
EXPLAIN ANALYZE  SELECT * FROM attendance WHERE person_id = 847516;
```
<img width="887" alt="image" src="https://github.com/user-attachments/assets/fbc7c08a-1fc4-4157-be32-a954f41280dc" />


   - С индексом:
     | Операция | Время выполнения |
     |----------|------------------|
     | SELECT + WHERE | 10,151 |


<img width="892" alt="image" src="https://github.com/user-attachments/assets/8f81a175-b9b4-4a41-993e-dbf4f29bcb83" />


3. **Сравнение времени выполнения операций до и после добавления индекса**

```sql
CREATE INDEX idx_person_id ON attendance(person_id);
```

   | Операция        | Время до индексирования T<sub>b</sub> | Время после индексирования T<sub>a</sub> | T<sub>a</sub>/T<sub>b</sub> |
   |-----------------|--------------------------------------|----------------------------------------|-----------------------------|
   | SELECT          | 100,987                        	    | 89,818                         	     |      1.1               |
   | SELECT + WHERE  | 53,450                        	    | 10,151                         	     | 5                         |

4. **Выводы**

   - Для операции `SELECT` без условий, время выполнения практически не изменилось после добавления индекса. Это связано с тем, что индекс на атрибут `person_id` не влияет на выборку всех строк таблицы.
   - Для операции `SELECT + WHERE`, время выполнения значительно уменьшилось после добавления индекса. Индекс позволяет быстро находить строки, соответствующие заданному значению `person_id`, что существенно ускоряет выполнение запроса.

### 1.3

Составьте запрос к таблице attendance, выводящий все строки в отсортированном порядке, в которых столбец generated_code заканчивается символом ‘a’. Проанализируйте полученный запрос и объясните результат. Используется ли в данном случае индекс? 

```sql
EXPLAIN ANALYZE
SELECT * FROM attendance 
WHERE generated_code LIKE '%a'
ORDER BY generated_code;
```
<img width="957" alt="image" src="https://github.com/user-attachments/assets/207cbcf2-bd6f-413c-844a-3f5fcd6b525b" />

Запрос не использует индекс, потому что он использует условие `LIKE '%a'`, которое не может эффективно работать с индексами. В PostgreSQL индексы оптимизированы для запросов, использующих префиксный поиск (например, `LIKE 'prefix%'`), но не для поиска в конце строки (например, `LIKE '%a'`). Когда база данных выполняет поиск по окончанию строки, как в данном случае, она не может использовать индекс эффективно, и вместо этого проводит полный скан таблицы, чтобы найти все строки, соответствующие этому условию.


## num 2

во первых создадим такого студента 

```sql
INSERT INTO students (student_id, last_name, first_name, patronymic, students_group_number, birthday, email)
VALUES (13, 'Шариков', 'Полиграф', 'Полиграфович', 'ИВТ-42', '2000-01-01', 'sharikov@gmail.com');


INSERT INTO student_ids (student_id, issue_date, expiration_date)
VALUES (13, CURRENT_DATE, CURRENT_DATE + INTERVAL '4 years');


INSERT INTO fields (field_id, field_name, structural_unit_id, zet, semester)
VALUES ('550e8400-e29b-41d4-a716-446655440000', 'Операционные системы 7л', 1, 5, 1);


INSERT INTO fields (field_id, field_name, structural_unit_id, zet, semester)
VALUES ('550e8400-e29b-41d4-a716-446655440001', 'Базы данных 7л', 1, 5, 1);


INSERT INTO field_comprehensions (student_id, field, mark)
VALUES (13, '550e8400-e29b-41d4-a716-446655440000', 4);

INSERT INTO field_comprehensions (student_id, field, mark)
VALUES (13, '550e8400-e29b-41d4-a716-446655440001', 4);
```

1. **Работа с транзакциями**

В рамках транзакции измените значение оценки студента по Операционным системам и проверьте значение в первом и втором окне. Зафиксируйте изменения и вновь проверьте значения. Аналогично внесите новую оценку по Базам данных и проверьте изменения. 

преподователь

```sql
UPDATE field_comprehensions SET mark = 5 WHERE student_id = 13 AND field = (SELECT field_id FROM fields WHERE field_name = 'Операционные системы 7л');
INSERT INTO field_comprehensions (student_id, field, mark) VALUES (13, (SELECT field_id FROM fields WHERE field_name = 'Базы данных 7л'), 5);
COMMIT;
```
методист 

```sql
SELECT * FROM field_comprehensions WHERE student_id = 42;
```
тут баг с бесконечной прокруткой

<img width="1029" alt="image" src="https://github.com/user-attachments/assets/5bf70c21-3854-44fb-8ad9-2dfcfbfda2d3" />

а тут уже компит случился и все правильно

<img width="1158" alt="image" src="https://github.com/user-attachments/assets/7a5de0e6-84a6-454b-93a3-8b21233c3ed2" />


2. **Отмена изменений транзакций**
   
Удалите добавленное значение и верните исправленную оценку в прежнее состояние. Повторите аналогичные действия, только по окончании внесения изменений преподавателем откатите их с помощью команды ROLLBACK.  Какое значение увидела методист?
