# Lab 1 

## 1. Функция `num_roots(A, B, C)`

Задайте функцию `num_roots(A, B, C)`, находящую число корней квадратного уравнения \( A \cdot x^2 + B \cdot x + C = 0 \).


```prolog
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

```prolog
num_roots(1, 0, -2, N).
```

<img width="993" alt="image" src="https://github.com/user-attachments/assets/b6f4fc5d-e731-4975-8b17-d622743daba7" />


## 2. Функция `init(List)`

Задайте функцию `init(List)`, возвращающую список `List` без последнего элемента.


```prolog
init(List, InitList) :-
    append(InitList, [_], List).
```

```prolog
init([1, 2, 3, 4], InitList).

```

В контексте append(InitList, [_], List), это значит:

InitList получает все элементы List, кроме последнего.
[_]- ананонимная переменная и как бы . append делять лист на инит и эту анонимную переменную

<img width="1009" alt="image" src="https://github.com/user-attachments/assets/de4b6b99-2bba-4dc6-954f-2ee05fc1c439" />


## 3. Функция `split(List, N)`

Задайте функцию `split(List, N)`, которая делит список `List` на две части: первые `N` элементов и всё, что идёт за ними.

```prolog
split(List, N, FirstPart, SecondPart) :-
    length(FirstPart, N),                % Определяем, что FirstPart имеет длину N
    append(FirstPart, SecondPart, List). % Объединяем FirstPart и SecondPart в List
```

```prolog
split([1, 3, 4, 5], 2, FirstPart, SecondPart)
```

length(FirstPart, N) — устанавливает, что FirstPart состоит ровно из N элементов.
append(FirstPart, SecondPart, List) — объединяет FirstPart и SecondPart, получая List.


<img width="888" alt="image" src="https://github.com/user-attachments/assets/db691047-ff0c-4e8c-a548-1f564580cfc8" />


## 4. Функция `binary_to_int(Bin)`

Задайте функцию `binary_to_int(Bin)`, которая переводит двоичную запись числа (в виде строки `Bin`) в само это число.


```prolog
binary_to_int(Bin, Num) :-
    atom_chars(Bin, Chars),        % Преобразуем строку в список символов.
    reverse(Chars, ReversedChars), % Разворачиваем список символов.
    binary_to_int_parse(ReversedChars, Num).  % Вызываем вспомогательную функцию.

% Вспомогательная функция для обработки списка символов.
binary_to_int_parse([], 0).  % Если список пуст, результат 0.
binary_to_int_parse(['-'|Chars], -Num) :-  % Если первый символ '-', результат будет отрицательным.
    binary_to_int_parse(Chars, Num).
binary_to_int_parse([Char|Chars], Num) :-
    char_code(Char, Code),        % Получаем ASCII-код символа.
    Code >= 48, Code =< 49,       % Проверяем, что символ — '0' или '1'.
    binary_to_int_parse(Chars, Rest),  % Рекурсивно обрабатываем оставшиеся символы.
    Num is (Code - 48) + 2 * Rest.  % Вычисляем значение числа.
```

```prolog
binary_to_int("111", Num).
```
Num рассчитывается по формуле: Num = ( Текущий бит ) + 2 × ( Оставшаяся часть ) Num=(Текущий бит)+2×(Оставшаяся часть) Это аналогично тому, как двоичное число переводится в десятичное.

<img width="657" alt="image" src="https://github.com/user-attachments/assets/86c27a4c-5cca-4323-9da2-2cbab4f3533d" />


## 5. Функция `sliding_average(List, WindowSize)`

Задайте функцию `sliding_average(List, WindowSize)`, которая возвращает скользящее среднее списка `List` с размером окна `WindowSize`.

Скользящее среднее (или скользящая средняя) - это метод анализа временных рядов, который используется для выявления основных тенденций в данных. Он представляет собой последовательность средних значений подмножеств исходного набора данных.

В простейшем случае, если у нас есть временной ряд с N точками данных, и мы хотим рассчитать скользящее среднее с окном размером W, то мы начинаем с первых W точек данных, находим их среднее значение, затем перемещаемся на одну точку вправо, оставляя первую точку и добавляя следующую после W-й точки, снова находим среднее значение этих W точек, и так далее до конца ряда.

Например, если у нас есть данные [1, 2, 3, 4, 5] и мы хотим найти скользящее среднее с окном размером 3, то мы получим [(1+2+3)/3, (2+3+4)/3, (3+4+5)/3], что равно [2, 3, 4].

Этот метод полезен для сглаживания "шума" или случайных колебаний в данных, чтобы можно было лучше видеть общие тенденции.

```prolog

sliding_average(List, WindowSize, Averages) :-
    length(List, Len),            % Получаем длину списка.
    Len >= WindowSize,            % Проверяем, что список достаточно длинный.
    sliding_average_helper(List, WindowSize, Len, Averages).  % Вызываем вспомогательную функцию.

% Вспомогательная функция для вычисления скользящего среднего.
sliding_average_helper(List, WindowSize, Len, Averages) :-
    Len >= WindowSize,            % Пока в списке достаточно элементов.
    length(Window, WindowSize),   % Создаем окно размером WindowSize.
    append(Window, _, List),     % Разделяем список на окно и оставшиеся элементы.
    sum_list(Window, Sum),        % Суммируем элементы окна.
    Average is Sum / WindowSize,  % Вычисляем среднее значение.
    append([Average], RestAverages, Averages),  % Добавляем среднее в результат.
    List = [_|Tail],              % Переходим к следующему окну.
    sliding_average_helper(Tail, WindowSize, Len - 1, RestAverages).  % Рекурсивный вызов.
sliding_average_helper(_, _, _, []).  % Если элементов недостаточно, возвращаем пустой список.
```

```prolog
sliding_average([1, 2, 3, 4, 5, 6], 3, Averages).
```

<img width="919" alt="image" src="https://github.com/user-attachments/assets/3efa491c-888d-48dd-8f03-393c24d8195e" />


## 6. Функция `intersect(List1, List2)`

Задайте функцию `intersect(List1, List2)`, находящую все общие элементы двух списков `List1` и `List2`.


```prolog
intersect(List1, List2, CommonSet) :-
    findall(X, (member(X, List1), member(X, List2)), Common),
    list_to_set(Common, CommonSet).
```


```prolog
intersect([1, 3, 2, 5], [2, 3, 4], Common).

intersect([1, 6, 5], [2, 3, 4], Common).
```


```prolog
findall(X, (member(X, List1), member(X, List2)), Common)
```
- `member(X, List1)` — выбираем элемент `X` из `List1`.
- `member(X, List2)` — проверяем, содержится ли `X` в `List2`.
- `findall/3` собирает **все такие `X`** в список `Common`, включая возможные дубликаты.

**Пример работы `findall/3`:**
```prolog
?- findall(X, (member(X, [1, 3, 2, 5]), member(X, [2, 3, 4])), Common).
Common = [3, 2].
```
Здесь `3` и `2` присутствуют в обоих списках, поэтому они добавлены в `Common`.

### Удаление дубликатов
```prolog
list_to_set(Common, CommonSet).
```
- `list_to_set/2` преобразует список в **множество**, удаляя дубликаты.

**Пример работы `list_to_set/2`:**
```prolog
?- list_to_set([3, 3, 2, 2], X).
X = [3, 2].
```
Это позволяет получить **пересечение без повторений**.



<img width="873" alt="image" src="https://github.com/user-attachments/assets/654e6dcb-c580-49c5-a864-8d212e93fd2f" />

<img width="863" alt="image" src="https://github.com/user-attachments/assets/fde89c8a-b670-44bf-ac8d-ad03da90678d" />


## 7. Функция `is_date(DayOfMonth, MonthOfYear, Year)`

Задайте функцию `is_date(DayOfMonth, MonthOfYear, Year)`, определяющую номер дня недели по числу месяца, номеру месяца и году. Год является високосным, если он либо делится на 4, но не на 100, либо делится на 400. В качестве точки отсчёта возьмите 1 января 2000 года (суббота). Не используйте каких-то формул для нахождения дня недели, это задание на рекурсию!


```prolog
% Количество дней в месяце
days_in_month(1, _, 31).
days_in_month(2, Y, 29) :- leap_year(Y), !.
days_in_month(2, _, 28).
days_in_month(3, _, 31).
days_in_month(4, _, 30).
days_in_month(5, _, 31).
days_in_month(6, _, 30).
days_in_month(7, _, 31).
days_in_month(8, _, 31).
days_in_month(9, _, 30).
days_in_month(10, _, 31).
days_in_month(11, _, 30).
days_in_month(12, _, 31).

% Проверка на високосный год
leap_year(Y) :- (Y mod 400 =:= 0; (Y mod 4 =:= 0, Y mod 100 =\= 0)).

% Базовый случай: 1 января 2000 года - суббота (6-й день недели)
is_date(1, 1, 2000, 6) :- !.

% Если дата позже 1 января 2000 - идем назад
is_date(D, M, Y, W) :-
    (Y > 2000 ; (Y =:= 2000, M > 1) ; (Y =:= 2000, M =:= 1, D > 1)),
    prev_date(D, M, Y, PrevD, PrevM, PrevY),
    is_date(PrevD, PrevM, PrevY, PrevW),
    W is (PrevW + 1) mod 7.

% Определение предыдущей даты
prev_date(1, 1, Y, 31, 12, PrevY) :- PrevY is Y - 1.
prev_date(1, M, Y, PrevD, PrevM, Y) :-
    PrevM is M - 1,
    days_in_month(PrevM, Y, PrevD).
prev_date(D, M, Y, PrevD, M, Y) :-
    PrevD is D - 1.

```


```prolog
is_date(1, 1, 2000, DayOfWeek).

is_date(1, 2, 2001, W).
```
<img width="798" alt="image" src="https://github.com/user-attachments/assets/7084bdae-5a70-4190-9d02-2a74ebc01a92" />


### **Определение дня недели (is_date/4) — принцип работы**  

Функция `is_date(Day, Month, Year, Weekday)` вычисляет день недели для заданной даты, используя **рекурсию** и **отсчет от базовой даты** (1 января 2000 года — суббота).  

1. **Базовый случай**: Если дата — 1 января 2000 года, то день недели сразу известен (6 — суббота).  
2. **Рекурсивный переход**: Если дата больше 1 января 2000 года, мы **рекурсивно уменьшаем дату** до базового случая.  
3. **Переход к предыдущей дате**:  
   - Если это 1-й день месяца, переходим на последний день предыдущего месяца.  
   - Если это 1 января, переходим на 31 декабря предыдущего года.  
   - Иначе просто уменьшаем день.  
4. **Расчет дня недели**: После рекурсивного вызова прибавляем 1 к дню недели (цикл от 0 до 6).  

Таким образом, за `N` дней функция выполняет `N` шагов назад
