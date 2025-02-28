
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

### Интерфейс
```python
class PriorityQueue:
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

## Задание 3: Функция to_list

### Описание задачи
Реализовать функцию `to_list(priority_queue) -> [any]`, которая возвращает список всех значений, содержащихся в очереди, в порядке возрастания приоритета.

### Реализация
```python
def to_list(priority_queue):
    # Ваш код здесь
    pass
```

### Примеры использования
```python
# Примеры вызова функции и их результаты
```

## Задание 4: Реализации очереди с приоритетом

### Реализация 1: Использование списка
```python
class PriorityQueueList:
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
