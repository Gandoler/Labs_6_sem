# Lab 1 

## 1. Функция `num_roots(A, B, C)`

Задайте функцию `num_roots(A, B, C)`, находящую число корней квадратного уравнения \( A \cdot x^2 + B \cdot x + C = 0 \).


```pl
% num_roots: вычисляет количество корней квадратного уравнения A*x^2 + B*x + C = 0.
% Аргументы:
%   A, B, C — коэффициенты уравнения.
%   N — количество корней (0, 1 или 2).

num_roots(A, B, C, 2) :-
    Discriminant is B^2 - 4*A*C,  % Вычисляем дискриминант.
    Discriminant > 0.             % Если дискриминант положительный, два корня.

num_roots(A, B, C, 1) :-
    Discriminant is B^2 - 4*A*C,  % Вычисляем дискриминант.
    Discriminant =:= 0.           % Если дискриминант равен нулю, один корень.

num_roots(A, B, C, 0) :-
    Discriminant is B^2 - 4*A*C,  % Вычисляем дискриминант.
    Discriminant < 0.             % Если дискриминант отрицательный, корней нет.
```

```pl
num_roots(1, 0, -2, N).
```

<img width="993" alt="image" src="https://github.com/user-attachments/assets/b6f4fc5d-e731-4975-8b17-d622743daba7" />


## 2. Функция `init(List)`

Задайте функцию `init(List)`, возвращающую список `List` без последнего элемента.


```pl
init(List, InitList) :-
    append(InitList, [_], List).
```

```pl
init([1, 2, 3, 4], InitList).

```

В контексте append(InitList, [_], List), это значит:

InitList получает все элементы List, кроме последнего.
[_]- ананонимная переменная и как бы . append делять лист на инит и эту анонимную переменную

<img width="1009" alt="image" src="https://github.com/user-attachments/assets/de4b6b99-2bba-4dc6-954f-2ee05fc1c439" />


## 3. Функция `split(List, N)`

Задайте функцию `split(List, N)`, которая делит список `List` на две части: первые `N` элементов и всё, что идёт за ними.

```pl
split(List, N, FirstPart, SecondPart) :-
    length(FirstPart, N),                % Определяем, что FirstPart имеет длину N
    append(FirstPart, SecondPart, List). % Объединяем FirstPart и SecondPart в List
```

```pl
split([1, 3, 4, 5], 2, FirstPart, SecondPart)
```

length(FirstPart, N) — устанавливает, что FirstPart состоит ровно из N элементов.
append(FirstPart, SecondPart, List) — объединяет FirstPart и SecondPart, получая List.


<img width="888" alt="image" src="https://github.com/user-attachments/assets/db691047-ff0c-4e8c-a548-1f564580cfc8" />


## 4. Функция `binary_to_int(Bin)`

Задайте функцию `binary_to_int(Bin)`, которая переводит двоичную запись числа (в виде строки `Bin`) в само это число.


```pl
inary_to_int(Bin, Num) :-
    atom_chars(Bin, Chars),        % Преобразуем строку в список символов.
    binary_to_int_helper(Chars, Num).  % Вызываем вспомогательную функцию.

% Вспомогательная функция для обработки списка символов.
binary_to_int_helper([], 0).  % Если список пуст, результат 0.
binary_to_int_helper(['-'|Chars], -Num) :-  % Если первый символ '-', результат будет отрицательным.
    binary_to_int_helper(Chars, Num).
binary_to_int_helper([Char|Chars], Num) :-
    char_code(Char, Code),        % Получаем ASCII-код символа.
    Code >= 48, Code =< 49,       % Проверяем, что символ — '0' или '1'.
    binary_to_int_helper(Chars, Rest),  % Рекурсивно обрабатываем оставшиеся символы.
    Num is (Code - 48) + 2 * Rest.  % Вычисляем значение числа.
```

## 5. Функция `sliding_average(List, WindowSize)`

Задайте функцию `sliding_average(List, WindowSize)`, которая возвращает скользящее среднее списка `List` с размером окна `WindowSize`.

**Пример:**
```
sliding_average([1, 2, 3, 4, 5, 6], 3) => [(1+2+3)/3, (2+3+4)/3, (3+4+5)/3, (4+5+6)/3] == [2.0, 3.0, 4.0, 5.0]
```

## 6. Функция `intersect(List1, List2)`

Задайте функцию `intersect(List1, List2)`, находящую все общие элементы двух списков `List1` и `List2`.

**Примеры:**
```
intersect([1, 3, 2, 5], [2, 3, 4]) => [3, 2] (или [2, 3]).
intersect([1, 6, 5], [2, 3, 4]) => [].
```

## 7. Функция `is_date(DayOfMonth, MonthOfYear, Year)`

Задайте функцию `is_date(DayOfMonth, MonthOfYear, Year)`, определяющую номер дня недели по числу месяца, номеру месяца и году. Год является високосным, если он либо делится на 4, но не на 100, либо делится на 400. В качестве точки отсчёта возьмите 1 января 2000 года (суббота). Не используйте каких-то формул для нахождения дня недели, это задание на рекурсию!

**Примеры:**
```
is_date(1, 1, 2000) => 6
is_date(1, 2, 2013) => 5
```
