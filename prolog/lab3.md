
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

Как работает куча (Min-Heap)
Куча — это структура данных, которая поддерживает быстрый доступ к минимальному (или максимальному) элементу. В данном случае используется Min-Heap, то есть приоритетная очередь, в которой элементы с наименьшим приоритетом извлекаются первыми.

Основные операции:
insert(Heap, Value, Priority, NewHeap) – вставляет элемент в кучу, объединяя его с существующей кучей.
extract_min(Heap, Value, Priority, NewHeap) – извлекает элемент с минимальным приоритетом и возвращает обновленную кучу.
merge(Heap1, Heap2, NewHeap) – объединяет две кучи, сохраняя свойства Min-Heap.
to_list(Heap, List) – преобразует кучу в отсортированный список значений.



### Реализация 2: Использование кучи 
```prolog
% Определение кучи
heap(empty). % Пустая куча

% Слияние двух куч
merge(empty, H, H).  % Если первая куча пуста, результатом будет вторая куча.
merge(H, empty, H).  % Если вторая куча пуста, результатом будет первая куча.
merge(node(P1, V1, L1, R1), node(P2, V2, L2, R2), node(P1, V1, NewLeft, R1)) :-
    P1 =< P2,  % Если приоритет первого узла меньше или равен приоритету второго узла.
    merge(node(P2, V2, L2, R2), L1, NewLeft).  % Рекурсивно сливаем вторую кучу с левым поддеревом первой кучи.
merge(node(P1, V1, L1, R1), node(P2, V2, L2, R2), node(P2, V2, NewLeft, R2)) :-
    P1 > P2,  % Если приоритет первого узла больше приоритета второго узла.
    merge(node(P1, V1, L1, R1), L2, NewLeft).  % Рекурсивно сливаем первую кучу с левым поддеревом второй кучи.

% Вставка элемента в кучу
insert(Heap, Value, Priority, NewHeap) :-
    merge(Heap, node(Priority, Value, empty, empty), NewHeap).  % Сливаем существующую кучу с новой кучей, содержащей один элемент.

% Извлечение минимального элемента
extract_min(node(P, V, L, R), V, P, Merged) :-
    merge(L, R, Merged).  % Сливаем левое и правое поддеревья, чтобы получить новую кучу.

% Проверка на пустоту
is_empty(empty).  % Куча пуста, если она представлена как empty.

% Преобразование в список
to_list(Heap, List) :- to_list_helper(Heap, [], List).  % Запускаем вспомогательную функцию с пустым аккумулятором.

to_list_helper(empty, Acc, List) :- reverse(Acc, List).  % Если куча пуста, возвращаем аккумулятор в обратном порядке.
to_list_helper(Heap, Acc, List) :-
    extract_min(Heap, Value, _, NewHeap),  % Извлекаем минимальный элемент из кучи.
    to_list_helper(NewHeap, [Value | Acc], List).  % Рекурсивно добавляем значение в аккумулятор и продолжаем с новой кучей.

% Пример использования
example_list(List, MinValue, MinPriority) :-
    empty_queue(Q0),  % Создаем пустую очередь (ошибка: empty_queue не определен).
    insert(Q0, a, 3, Q1),  % Вставляем элемент 'a' с приоритетом 3.
    insert(Q1, b, 1, Q2),  % Вставляем элемент 'b' с приоритетом 1.
    insert(Q2, c, 2, Q3),  % Вставляем элемент 'c' с приоритетом 2.
    extract_min(Q3, MinValue, MinPriority, Q4),  % Извлекаем минимальный элемент.
    to_list(Q4, List).  % Преобразуем оставшуюся кучу в список.

example_heap(List, MinValue, MinPriority) :-
    heap(Q0),  % Создаем пустую кучу (ошибка: heap(Q0) не определен).
    insert(Q0, apple, 3, Q1),  % Вставляем элемент 'apple' с приоритетом 3.
    insert(Q1, banana, 1, Q2),  % Вставляем элемент 'banana' с приоритетом 1.
    insert(Q2, cherry, 2, Q3),  % Вставляем элемент 'cherry' с приоритетом 2.
    extract_min(Q3, MinValue, MinPriority, Q4),  % Извлекаем минимальный элемент.
    to_list(Q4, List).  % Преобразуем оставшуюся кучу в список.
```

<img width="1251" alt="image" src="https://github.com/user-attachments/assets/f20ddb8b-7605-4329-af35-f7a139d91e25" />

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
