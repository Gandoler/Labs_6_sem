# LAB 2

## 1. Функция `min_positive_number(List)`

Реализуйте функцию `min_positive_number(List)`, которая возвращает минимальное положительное число, входящее в `List`. Если положительных чисел нет, функция должна вернуть атом `error`.

Факт is_positive(X) – проверяет, является ли X числом и больше ли он нуля.
Предикат min_positive_number/2 – находит минимальное положительное число в списке:
Фильтрует список, оставляя только положительные числа (include/3).
Если положительных чисел нет, результат – error.
Иначе находит минимальный элемент среди положительных (min_list/2).


```prolog
% Проверяет, является ли X числом и положительным
is_positive(X) :- number(X), X > 0.

% min_positive_number(+List, -Min)
% Находит минимальное положительное число в списке List
% Если положительных чисел нет, возвращает error
min_positive_number(List, Min) :-
    % Оставляем в списке только положительные числа
    include(is_positive, List, PositiveList),
    % Если после фильтрации список пуст, возвращаем error
    (   PositiveList = [] -> Min = error
    % Иначе находим минимальный элемент среди положительных
    ;   min_list(PositiveList, Min)
    ).
```

```prolog
min_positive_number([3, -10, 4, -3, 1], Min)
```

<img width="829" alt="image" src="https://github.com/user-attachments/assets/086d30dc-2a69-4ac4-b150-a8f993f937be" />

## 2. Функция `zipwith(Fun, List1, List2)`

Не смотря на определение в модуле `lists` стандартной библиотеки, реализуйте функцию `zipwith(Fun, List1, List2)`. Возвращается список значений `Fun` (функции от двух аргументов) на аргументах, взятых из списков `List1` и `List2`. В случае разных длин списков функция должна выкинуть исключение.


```prolog
% zipwith(+Fun, +List1, +List2, -Result)
% Применяет функцию Fun к соответствующим элементам двух списков.
% Если списки разной длины — выбрасывает исключение.

% Базовый случай: если оба списка пустые, результат тоже пустой.
zipwith(_, [], [], []) :- !.

% Ошибка, если первый список длиннее второго.
zipwith(_, [_|_], [], _) :- 
    throw(error(length_mismatch, zipwith/3)).

% Ошибка, если второй список длиннее первого.
zipwith(_, [], [_|_], _) :- 
    throw(error(length_mismatch, zipwith/3)).

% Рекурсивный случай: 
% 1. Берём первый элемент X из первого списка и Y из второго.
% 2. Вызываем переданную функцию Fun с X и Y, получаем Z.
% 3. Рекурсивно вызываем zipwith для оставшихся элементов.
zipwith(Fun, [X|Xs], [Y|Ys], [Z|Zs]) :-
    call(Fun, X, Y, Z),
    zipwith(Fun, Xs, Ys, Zs).

% Пример функции, создающей пары элементов (кортежи).
pair(X, Y, (X, Y)).

% Пример вызова zipwith/3, который создаёт список пар.
example(Result) :-
    zipwith(pair, [1,2,3], [4,5,6], Result).

```

```prolog
example(Result)
```

Функция zipwith/3 — это обобщённая версия zip/2, которая позволяет применить произвольную бинарную функцию ко всем соответствующим элементам двух списков.


Основная идея
Берём элементы из обоих списков по очереди.
Применяем переданную функцию (Fun).
Записываем результат в новый список.
Если списки разной длины — выбрасываем ошибку.

<img width="697" alt="image" src="https://github.com/user-attachments/assets/f530b9d5-08c7-4bb3-9644-4f02d3635ad5" />


<img width="849" alt="image" src="https://github.com/user-attachments/assets/6b64f86e-6ece-455e-bb36-613404506314" />


## 3. Функция `iteratemap(F, X0, N)`

Реализуйте функцию `iteratemap(F, X0, N)`, которая возвращает список длины `N`, состоящий из результатов последовательного применения `F` к `X0`.


Разбор iteratemap/4
Этот предикат создаёт список результатов последовательного применения функции F к начальному значению X N раз.

🔍 Разбор кода
```prolog
% iteratemap(+F, +X, +N, -Result)
% Строит список из N+1 элементов, начиная с X, применяя F на каждом шаге.
% Базовый случай: если N == 0, список пустой.
iteratemap(_, _, 0, []).
```
Если N = 0, итераций нет, результат — пустой список [].

```prolog
iteratemap(F, X, N, [X|Result]) :-
    N > 0,              % Проверяем, что N положительное
    N1 is N - 1,        % Уменьшаем N на 1
    call(F, X, X1),     % Вызываем функцию F, получаем X1 (следующее значение)
    iteratemap(F, X1, N1, Result).  % Рекурсивно вызываем для X1
```
 В каждом шаге:
Добавляем X в результат.
Вызываем F(X, X1), чтобы получить следующее значение.
Рекурсивно вызываем iteratemap/4, пока N не станет 0.



``` prolog
% Генерация списка результатов последовательного применения функции
iteratemap(_, _, 0, []).
iteratemap(F, X, N, [X|Result]) :-
    N > 0,
    N1 is N - 1,
    call(F, X, X1),
    iteratemap(F, X1, N1, Result).
```

```prolog
iteratemap([X, Y]>>(Y is X * 2), 1, 4, Result).
```

<img width="947" alt="image" src="https://github.com/user-attachments/assets/34f04470-254c-42d4-ab8c-b5aa0bc5337f" />


## 4. Функция `diff(F, DX)`

Реализуйте функцию `diff(F, DX)`, которая принимает функцию `F` от одного аргумента и шаг `DX`, и возвращает функцию одного аргумента: приближение к производной функции `F`. 


```prolog
diff(F, DX, X, Result) :-
    X1 is X + DX,
    call(F, X, Y),
    call(F, X1, Y1),
    Result is (Y1 - Y) / DX.

square(X, Y) :- Y is X * X.
```

```prolog
diff(square, 0.001, 1.0, Result).
```

X1 — новая точка чуть дальше X (на DX вправо).
Вычисляем Y = F(X), значение функции в X.
Вычисляем Y1 = F(X1), значение функции в X1.
(Y1 - Y) / DX — это приближённое значение производной F'(X).

<img width="598" alt="image" src="https://github.com/user-attachments/assets/806dcbe9-b657-4851-9936-123b8540a09d" />


Попробуйте вспомнить (или найти) формулу, которая даёт лучшее приближение для производной, чем `(F(X + DX) - F(X))/DX`, но она тоже принимается.

## 5. Функция `for(Init, Cond, Step, Body)`

Реализуйте функцию `for(Init, Cond, Step, Body)`, которая работает как цикл `for` (I = Init; Cond(I); I = Step(I)) { Body(I) } в C-подобных языках:

- Поддерживается "текущее значение" `I`. В начале это `Init`.
- На каждом шаге проверяется, выполняется ли условие `Cond(I)`.
- Если да, то вызывается функция `Body(I)`. Потом вычисляется новое значение как `Step(I)` и возвращаемся к проверке `Cond`.
- Если нет, то работа функции заканчивается.

```prolog
% Основной случай: цикл продолжается, если Cond(Init) истина.
for(Init, Cond, Step, Body) :-
    call(Cond, Init),      % Проверяем условие Cond(Init)
    call(Body, Init),      % Вызываем тело цикла Body(Init)
    call(Step, Init, Next), % Вычисляем следующее значение Next = Step(Init)
    for(Next, Cond, Step, Body). % Рекурсивный вызов с Next

```

```porlog
for(1, [X]>>(X =< 5), [X, Y]>>(Y is X + 1), [X]>>(writeln(X))).
```

Сначала проверяет условие Cond(Init).
Если true, выполняет Body(Init).
Затем вычисляет Next = Step(Init).
Вызывает for/4 снова, но уже с Next.



<img width="880" alt="image" src="https://github.com/user-attachments/assets/a64286dd-253e-44a8-8bf4-2f92aa50586b" />


## 6. Функция `sortBy(Comparator, List)`

Реализуйте функцию `sortBy(Comparator, List)`, которая сортирует список `List`, используя `Comparator` для сравнения элементов. `Comparator(X, Y)` возвращает один из атомов `less` (если `X < Y`), `equal` (`X == Y`), `greater` (`X > Y`) для любых элементов `List`. Можете использовать любой алгоритм сортировки, но укажите, какой именно. Сортировка слиянием очень хорошо подходит для связных списков.


```prolog
% Базовые случаи: пустой список и список из одного элемента уже отсортированы.
sortBy(_, [], []).
sortBy(_, [X], [X]).


sortBy(Comparator, List, Sorted) :-
    length(List, Len),              % Вычисляем длину списка
    Half is Len // 2,               % Находим середину списка
    length(Left, Half),             % Создаём список Left длины Half
    append(Left, Right, List),      % Разделяем List на Left и Right
    sortBy(Comparator, Left, LeftSorted),   % Рекурсивно сортируем левую часть
    sortBy(Comparator, Right, RightSorted), % Рекурсивно сортируем правую часть
    merge(Comparator, LeftSorted, RightSorted, Sorted). % Объединяем два отсортированных списка

% Если один из списков пуст — возвращаем другой список.
merge(_, [], Right, Right).
merge(_, Left, [], Left).

% Если X < Y, X идёт первым.
merge(Comparator, [X|Left], [Y|Right], [X|Result]) :-
    call(Comparator, X, Y, less),
    merge(Comparator, Left, [Y|Right], Result).

% Если X > Y, Y идёт первым.
merge(Comparator, [X|Left], [Y|Right], [Y|Result]) :-
    call(Comparator, X, Y, greater),
    merge(Comparator, [X|Left], Right, Result).

% Если X == Y, включаем оба элемента.
merge(Comparator, [X|Left], [Y|Right], [X, Y|Result]) :-
    call(Comparator, X, Y, equal),
    merge(Comparator, Left, Right, Result).

num_cmp(X, Y, less) :- X < Y.
num_cmp(X, Y, greater) :- X > Y.
num_cmp(X, Y, equal) :- X =:= Y.

```

```prolog
sortBy(num_cmp, [4, 2, 5, 1, 3], Sorted).
```

<img width="920" alt="image" src="https://github.com/user-attachments/assets/31a7f09b-2cfb-44fd-8818-2039809e5614" />




