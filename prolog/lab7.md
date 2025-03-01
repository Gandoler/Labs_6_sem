
# Лабораторная работа 7



## Разбор операторов =, ==, =:= и is

Чтобы разобраться с различиями операторов `=`, `==`, `=:=` и `is`, для каждого запроса сначала попытайтесь понять, как должен ответить Пролог, а потом проверьте, правильны ли ваши предположения.

### Запросы

Два терма унифицируются, если их можно сделать одинаковыми, подставляя значения переменным.

- `?- X = 1+2.`       X унифицируется с термом 1+2, X = 1+2.
- `?- 3 = 1+2.`       3 не унифицируется с 1+2, false.
- `?- 2+1 = 1+2.`     2+1 не унифицируется с 1+2, false.
- `?- X == 1+2.`      X не идентичен терму 1+2, false.
- `?- 3 == 1+2.`      3 не идентичен терму 1+2, false.
- `?- 2+1 == 1+2.`    2+1 не идентичен 1+2, false.
- `?- X =:= 1+2.`     X должен быть числом, равным 3, но X не определен, ошибка. 
- `?- 3 =:= 1+2.`     3 равно 3, true. 
- `?- 2+1 =:= 1+2.`   3 равно 3, true. 
- `?- X is 1+2.`      X вычисляется как 3, X = 3.
- `?- 3 is 1+2.`      3 равно 3, true.
- `?- 2+1 is 1+2.`    3 равно 3, true.

## Предикаты проверки типов

- `var(Term)` -- удаётся для свободных переменных
- `nonvar(Term)` -- противоположный `var`
- `float(Term)` -- удаётся для чисел с плавающей точкой
- `integer(Term)` -- удаётся для целых чисел
- `number(Term)` -- удаётся для любых чисел
- `atom(Term)` -- удаётся для атомов 
- `compound(Term)` -- удаётся для составных термов
- `atomic(Term)` -- удаётся, если Term -- атом или число (или значение встроенного типа "строка", который в нашем курсе не используется)
- `callable(Term)` -- удаётся, если Term -- атом или составной терм
- `ground(Term)` -- удаётся, если Term не содержит свободных переменных 

## Задание 1: Определение предиката `factorial(N, FactN)`

Определите предикат `factorial(N, FactN)`, который выполняется, если `FactN` -- факториал `N`.


```prolog
factorial(0, 1).
factorial(N, FactN) :-
    N > 0,
    N1 is N - 1,
    factorial(N1, FactN1),
    FactN is N * FactN1.
```

<img width="574" alt="image" src="https://github.com/user-attachments/assets/22773ccf-f3e2-45d0-971f-588eec95103e" />


Запрос: factorial(3, Fact).

N = 3, условие N > 0 выполняется.
Вычисляем N1 = 3 - 1 = 2.
Вызываем factorial(2, FactN1).
Запрос: factorial(2, FactN1).

N = 2, условие N > 0 выполняется.
Вычисляем N1 = 2 - 1 = 1.
Вызываем factorial(1, FactN1).
Запрос: factorial(1, FactN1).

N = 1, условие N > 0 выполняется.
Вычисляем N1 = 1 - 1 = 0.
Вызываем factorial(0, FactN1).
Запрос: factorial(0, FactN1).

Это базовый случай, который возвращает FactN1 = 1.
Теперь начинается возврат значений по цепочке:

factorial(1, Fact1): Fact1 = 1 * 1 = 1
factorial(2, Fact2): Fact2 = 2 * 1 = 2
factorial(3, Fact3): Fact3 = 3 * 2 = 6
Ответ: Fact = 6.

## Задание 2: Определение предиката `occurrences(Elem, List, Number)`

Определите предикат `occurrences(Elem, List, Number)`, который выполняется, если элемент `Elem` встречается в списке `List` `Number` раз.


```prolog
occurrences(_, [], 0).
occurrences(Elem, [Elem|Tail], N) :-
    occurrences(Elem, Tail, N1),
    N is N1 + 1.
occurrences(Elem, [Head|Tail], N) :-
    Elem \= Head,
    occurrences(Elem, Tail, N).
```

<img width="685" alt="image" src="https://github.com/user-attachments/assets/cb1ddbb5-e78c-49d7-8bf1-521608f70f86" />


#### **Пример 1: `occurrences(a, [a, b, a], N).`**
- `List = [a, b, a]`, `Elem = a`
1. `a == a` → рекурсивный вызов `occurrences(a, [b, a], N1)`, `N is N1 + 1`
2. `b \= a` → рекурсивный вызов `occurrences(a, [a], N2)`, `N2 = N1`
3. `a == a` → рекурсивный вызов `occurrences(a, [], N3)`, `N3 = 0`
4. Базовый случай → `N3 = 0`
5. Поднятие вверх:  
   - `N2 = 0 + 1 = 1`
   - `N1 = 1 + 1 = 2`
   - `N = 2`

Пример 1: occurrences(a, [a, b, a], N).
List = [a, b, a], Elem = a
a == a → рекурсивный вызов occurrences(a, [b, a], N1), N is N1 + 1
b \= a → рекурсивный вызов occurrences(a, [a], N2), N2 = N1
a == a → рекурсивный вызов occurrences(a, [], N3), N3 = 0
Базовый случай → N3 = 0
Поднятие вверх:
N2 = 0 + 1 = 1
N1 = 1 + 1 = 2
N = 2


## Задание 3: Определение предиката `rule(Rule)`

Определите предикат `rule(Rule)`, который проверяет, является ли терм `Rule` правилом (без точки в конце), то есть: 1. Голова правила может быть вызвана (в смысле `callable/1`); 2. Тело правила состоит из (1 или более) callable термов, разделённых ',' и ';' (заметьте, что `T1,T2` и `T1;T2` -- сами callable, но их нужно обрабатывать отдельно).

Что такое правило в Prolog?
В Prolog правило имеет форму:

prolog
Копировать
Редактировать
Head :- Body.
Где:

Head (голова) — это вызываемый (callable/1) предикат.
Body (тело) — это последовательность предикатов, соединённых , (конъюнкция "и") или ; (дизъюнкция "или").
Например, a, b, c означает, что должны выполниться все три предиката.
А x; y означает, что должен выполниться хотя бы один из двух.
Тебе нужно написать предикат, который проверит, что:

Head — это корректный вызываемый терм.
Body состоит из одного или нескольких вызываемых термов, соединённых , или ;.


```proloq


```

<img width="1050" alt="image" src="https://github.com/user-attachments/assets/c636ef06-323c-4d95-bd62-00238b79b9a2" />

3. rule(4 :- (p, q)). → false
Проверка:

Голова: 4 — это число (не является вызываемым термом!). 
Итог: false (некорректное правило, так как голова не является предикатом).

Проверяет, что Head (голова правила) является вызываемым (callable/1)

В Prolog вызываемые (callable) термы — это атомы, структуры (функторы) и выражения типа p(X).
Числа, списки и другие невызываемые термы не пройдут проверку.
Проверяет Body (тело правила) через valid_body/1

Если тело — это true, оно всегда допустимо.
Если тело — это просто вызываемый предикат (callable/1), то оно допустимо.
Если тело содержит , (конъюнкция) или ; (дизъюнкция), то рекурсивно проверяются оба аргумента.

Примеры:
```prolog
?- rule(p(X, Y) :- q(X)).
Yes
?- rule(p :- (q(X), r, r)).
Yes
?- rule(4 :- (p, q)).
No
?- rule(p :- 4, q).
No
```


## Задание 4: Определение предиката `eval_arithmetic(Expr, Values, Result)`

Определите предикат `eval_arithmetic(Expr, Values, Result)`, который выполняется, если `Expr` -- арифметическое выражение (содержащее операторы +, *, -, / и атомы в качестве переменных), `Values` -- список термов `Var = Val`, где `Var` -- атом, а `Val` -- число, а `Result` -- результат вычисления `Expr` при подстановке вместо каждого атома соответствующего ему значения из `Values`. 

Этот предикат выполняет подстановку значений переменных в арифметическое выражение, а затем вычисляет его.

eval_arithmetic/3 принимает:

Expr — арифметическое выражение (например, x + 3*y).
Values — список вида [x = 2, y = 1], где каждому атому сопоставлено значение.
Result — результат вычисления выражения после подстановки.
Сначала substitute_vars/3 заменяет переменные в выражении их значениями.

Затем is/2 вычисляет полученное выражение.

---

Механика работы
Возьмём пример eval_arithmetic(x + 3*y, [x = 2, y = 1], Result).

substitute_vars(x + 3*y, [x = 2, y = 1], EvaluatedExpr) заменяет:

x → 2,
y → 1,
Получаем 2 + 3*1.
Result is 2 + 3*1, то есть Result = 5.

```prolog
% Предикат eval_arithmetic/3
% Подставляет значения переменных в выражение и вычисляет его результат.
eval_arithmetic(Expr, Values, Result) :-
    substitute_vars(Expr, Values, EvaluatedExpr),  % Заменяем переменные их значениями
    Result is EvaluatedExpr.  % Вычисляем результат выражения

% Предикат substitute_vars/3 выполняет замену переменных на их значения в выражении.

% Если Expr — число, то его не нужно заменять (базовый случай).
substitute_vars(Expr, _, Expr) :- number(Expr).

% Если Expr — переменная (атом), ищем её значение в списке Values.
substitute_vars(Var, Values, Value) :-
    atom(Var),                  % Проверяем, что это атом (переменная)
    member(Var = Value, Values). % Ищем соответствующее значение в списке подстановок

% Если выражение — сумма (A + B), обрабатываем обе части.
substitute_vars(Expr1 + Expr2, Values, Result1 + Result2) :-
    substitute_vars(Expr1, Values, Result1), % Подставляем значения в Expr1
    substitute_vars(Expr2, Values, Result2). % Подставляем значения в Expr2

% Если выражение — разность (A - B), обрабатываем обе части.
substitute_vars(Expr1 - Expr2, Values, Result1 - Result2) :-
    substitute_vars(Expr1, Values, Result1), % Подставляем значения в Expr1
    substitute_vars(Expr2, Values, Result2). % Подставляем значения в Expr2

% Если выражение — произведение (A * B), обрабатываем обе части.
substitute_vars(Expr1 * Expr2, Values, Result1 * Result2) :-
    substitute_vars(Expr1, Values, Result1), % Подставляем значения в Expr1
    substitute_vars(Expr2, Values, Result2). % Подставляем значения в Expr2

% Если выражение — деление (A / B), обрабатываем обе части.
substitute_vars(Expr1 / Expr2, Values, Result1 / Result2) :-
    substitute_vars(Expr1, Values, Result1), % Подставляем значения в Expr1
    substitute_vars(Expr2, Values, Result2). % Подставляем значения в Expr2

```

<img width="1043" alt="image" src="https://github.com/user-attachments/assets/24fe0795-9530-4a1b-9e63-67f771209926" />


Пример:
```prolog
eval_arithmetic(x + 3*y, [x = 2, y = 1], Result).

eval_arithmetic(a * (b + c), [a = 2, b = 3, c = 4], Result).

eval_arithmetic(10 - x, [x = 4], Result).

eval_arithmetic(x / y, [x = 8, y = 2], Result).
```


## Задание 5: Определение предиката `prime_factors(Num, Factors)`

Определите предикат `prime_factors(Num, Factors)`, находящий все простые делители числа `Num` и их кратность.

Механика работы:

-Основной предикат prime_factors/2 вызывает вспомогательный предикат prime_factors/3, начиная проверку делимости с числа 2.
-Базовый случай prime_factors(1, _, []) завершается, когда все множители учтены.
-Если число делится на Factor, вызывается count_divisions/4, которая подсчитывает, сколько раз Factor входит в Num.
-После учета текущего делителя процесс продолжается с NextFactor.


```prolog
% Предикат prime_factors/2
% Разлагает число Num на простые множители с их кратностью.
prime_factors(Num, Factors) :-
    prime_factors(Num, 2, Factors).  % Начинаем проверку делителей с 2.

% Базовый случай: если число уже стало 1, возвращаем пустой список (больше нет множителей).
prime_factors(1, _, []).

% Если Factor делит Num, считаем, сколько раз он входит в Num.
% После этого продолжаем разложение для оставшейся части числа.
prime_factors(Num, Factor, [factor(Factor, Count) | Rest]) :-
    count_divisions(Num, Factor, Count, Remaining), % Подсчет количества делений на Factor
    Count > 0,  % Если Factor делит Num хотя бы раз, добавляем его в список факторов.
    NextFactor is Factor + 1,  % Переходим к следующему возможному делителю.
    prime_factors(Remaining, NextFactor, Rest).  % Продолжаем разложение для оставшегося числа.

% Если текущий Factor не делит Num, просто переходим к следующему числу.
prime_factors(Num, Factor, Rest) :-
    NextFactor is Factor + 1,  % Переходим к следующему возможному делителю.
    prime_factors(Num, NextFactor, Rest).  % Пробуем разложить число дальше.

% Предикат count_divisions/4
% Подсчитывает, сколько раз Factor делит Num, и возвращает остаток после деления.
count_divisions(Num, Factor, 0, Num) :- 
    Num mod Factor =\= 0, !.  % Если Num не делится на Factor, кратность 0, остаётся Num.

count_divisions(Num, Factor, Count, Remaining) :-
    Num mod Factor =:= 0,  % Если Num делится на Factor...
    NextNum is Num // Factor,  % Делим Num на Factor.
    count_divisions(NextNum, Factor, NextCount, Remaining),  % Рекурсивно продолжаем деление.
    Count is NextCount + 1.  % Увеличиваем счётчик кратности.

```

<img width="908" alt="image" src="https://github.com/user-attachments/assets/52a4196c-b7ec-4bc5-8699-45f4fea0c539" />


 ```prolog
prime_factors(315, L).
```

## Задание 6: Определение предиката `polynomize(Expr, Poly)`

Определите предикат `polynomize(Expr, Poly)`, который выполняется, если `Expr` -- арифметическое выражение (включающее операции +, *, ^ в константную степень), а `Poly` -- многочлен в нормальной форме (см. 1.3), получающийся в результате его упрощения.

Пример:
```prolog
?- polynomize((x + x)*(x + 1), Poly).
Poly = 2*x^2 + 2*x
```

