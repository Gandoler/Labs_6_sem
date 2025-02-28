
# Отчет по выполнению заданий

## Задание 1: Функция count_leaves

### Описание задачи
Реализовать функцию `count_leaves(bin_tree) -> integer`, которая возвращает число листьев дерева.

### Реализация
```prolog
% Базовый случай: лист
count_leaves(tree(empty, _, empty), 1).

% Рекурсивный случай: левое поддерево не пусто
count_leaves(tree(Left, _, empty), Count) :-
    count_leaves(Left, LeftCount),
    Count is LeftCount.

% Рекурсивный случай: правое поддерево не пусто
count_leaves(tree(empty, _, Right), Count) :-
    count_leaves(Right, RightCount),
    Count is RightCount.

% Рекурсивный случай: оба поддерева не пусты
count_leaves(tree(Left, _, Right), Count) :-
    count_leaves(Left, LeftCount),
    count_leaves(Right, RightCount),
    Count is LeftCount + RightCount.

% Пустое дерево не имеет листьев
count_leaves(empty, 0).
```


### Примеры использования
```prolog
tree_example(
    tree(
        tree(tree(empty, d, empty), b, tree(empty, e, empty)),
        a,
        tree(empty, c, tree(empty, f, empty))
    )
).

tree_example(Tree), count_leaves(Tree, Count).
```
Базовый случай:

Если узел — лист (tree(empty, _, empty)), возвращаем 1.
Рекурсивные случаи:

Если у узла только левое поддерево, считаем листья в нем.
Если у узла только правое поддерево, считаем листья в нем.
Если у узла оба поддерева, считаем листья в каждом и суммируем.
Пустое дерево:

empty не содержит листьев, поэтому результат 0.

 Пример дерева:
       a
      / \
     b   c
    / \   \
   d   e   f
 Листья: d, e, f

<img width="941" alt="image" src="https://github.com/user-attachments/assets/a1aa2d23-2c31-4830-a8bc-f1e52f8d9081" />

## Задание 2: Интерфейс очереди с приоритетом

### Описание задачи
Разработать интерфейс для абстрактного типа данных "очередь с приоритетом", который позволяет хранить пары (значение, приоритет) и поддерживает операцию извлечения пары с минимальным приоритетом.

Очередь с приоритетом должна поддерживать следующие операции:
Вставка элемента: insert(Queue, Value, Priority, NewQueue).
Извлечение элемента с минимальным приоритетом: extract_min(Queue, Value, Priority, NewQueue).
Проверка на пустоту: is_empty(Queue).

```prolog
% Вставка элемента
insert(Queue, Value, Priority, NewQueue).

% Извлечение минимального элемента
extract_min(Queue, Value, Priority, NewQueue).

% Проверка, пуста ли очередь
is_empty(Queue).
```

## Задание 3: Функция to_list

### Описание задачи
Реализовать функцию `to_list(priority_queue) -> [any]`, которая возвращает список всех значений, содержащихся в очереди, в порядке возрастания приоритета.

.1 Определение пустой очереди

```prolog
empty_queue([]).
```

Определяет пустую очередь как пустой список [].

2. Вставка элемента в очередь

```prolog
insert(Queue, Value, Priority, NewQueue) :-
    append(Queue, [(Value, Priority)], TempQueue),
    sort(2, @=<, TempQueue, NewQueue). % Сортировка по приоритету
```
Добавляет элемент (Value, Priority) в конец списка Queue.
Затем сортирует список по приоритету (sort(2, @=<, ...)).

3. Извлечение элемента с минимальным приоритетом
   
```prolog
extract_min([(Value, Priority) | Rest], Value, Priority, Rest).
```

Так как список отсортирован по приоритету, первый элемент (Value, Priority) — минимальный.
Удаляет этот элемент и возвращает обновлённую очередь Rest.

4. Проверка, пуста ли очередь

```prolog
is_empty([]).
```
Успешно выполняется, если очередь пуста ([]).
5. Преобразование очереди в список значений (без приоритетов)

```prolog
to_list(Queue, Values) :-
    to_list_helper(Queue, [], Values).
```

Вызывает вспомогательный предикат to_list_helper, начиная с пустого аккумулятора.

```prolog
to_list_helper([], Acc, Values) :-
    reverse(Acc, Values).
```

Если очередь пуста, переворачивает аккумулятор Acc и возвращает Values.

```prolog
to_list_helper([(Value, _) | Rest], Acc, Values) :-
    to_list_helper(Rest, [Value | Acc], Values).
```

Рекурсивно добавляет Value в аккумулятор, убирая приоритет.

### Реализация
```prolog
empty_queue([]).

% Вставка элемента в очередь
insert(Queue, Value, Priority, NewQueue) :-
    append(Queue, [(Value, Priority)], TempQueue),
    sort(2, @=<, TempQueue, NewQueue). % Сортировка по приоритету

% Извлечение элемента с минимальным приоритетом
extract_min([(Value, Priority) | Rest], Value, Priority, Rest).

% Проверка, пуста ли очередь
is_empty([]).

% Преобразование очереди в список значений в порядке возрастания приоритета
to_list(Queue, Values) :-
    to_list_helper(Queue, [], Values).

to_list_helper([], Acc, Values) :-
    reverse(Acc, Values).
to_list_helper([(Value, _) | Rest], Acc, Values) :-
    to_list_helper(Rest, [Value | Acc], Values).

% Пример использования
example(List, Value, Priority) :-
    empty_queue(Q0),
    insert(Q0, a, 3, Q1),
    insert(Q1, b, 1, Q2),
    insert(Q2, c, 2, Q3),
    extract_min(Q3, Value, Priority, Q4),
    to_list(Q4, List).
```

### Примеры использования
```prolog
example(List, Value, Priority)


example4(List, First, Second) :-
    empty_queue(Q0),
    insert(Q0, apple, 3, Q1),
    insert(Q1, banana, 1, Q2),
    is_empty(Q2),  % Проверяем перед извлечением (вернёт false)
    extract_min(Q2, First, _, Q3),
    extract_min(Q3, Second, _, Q4),
    is_empty(Q4),  % Здесь уже true (очередь пуста)
    to_list(Q4, List).
```

<img width="1019" alt="image" src="https://github.com/user-attachments/assets/5d392703-4cbe-4703-a76f-2e26ec2d5426" />


## Задание 4: Реализации на примере кучи



### Реализация 2: Использование кучи (необязательно)
```python
import heapq

class PriorityQueueHeap:
    def __init__(self):
        # Инициализация очереди
        pass

    def insert(self, value, priority):
        # Вставка элемента в очередь
        pass

    def extract_min(self):
        # Извлечение элемента с минимальным приоритетом
        pass

    def is_empty(self):
        # Проверка на пустоту очереди
        pass
```

## Задание 5: Алгоритмическая сложность реализаций

### Анализ реализации 1 (список)
- Вставка: O(n)
- Извлечение минимума: O(n)
- Общая оценка: ...

### Анализ реализации 2 (куча)
- Вставка: O(log n)
- Извлечение минимума: O(log n)
- Общая оценка: ...

## Выводы
Здесь можно сделать выводы о проделанной работе, сравнить эффективность различных реализаций и т.д.
