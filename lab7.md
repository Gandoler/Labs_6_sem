# lab 7 

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
 ### 1
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

### 2
