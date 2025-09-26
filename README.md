<p align="center"><b>МОНУ НТУУ КПІ ім. Ігоря Сікорського ФПМ СПіСКС</b></p>

<p align="center">
<b>Звіт з лабораторної роботи 2</b><br/>
"Рекурсія"<br/>
дисципліни "Вступ до функціонального програмування"
</p>

<p align="right"><b>Студент</b>: Мануйлов Денис Денисович</p>
<p align="right"><b>Рік</b>: 2025</p>

## Загальне завдання
Реалізуйте дві рекурсивні функції, що виконують деякі дії з вхідним(и) списком(-ами), за можливості/необхідності використовуючи різні види рекурсії. Функції, які необхідно реалізувати, задаються варіантом (п. 2.1.1). Вимоги до функцій:
1. Зміна списку згідно із завданням має відбуватись за рахунок конструювання нового списку, а не зміни наявного (вхідного).
2. Не допускається використання функцій вищого порядку чи стандартних функцій для роботи зі списками, що не наведені в четвертому розділі навчального посібника.
3. Реалізована функція не має бути функцією вищого порядку, тобто приймати функції в якості аргументів.
4. Не допускається використання псевдофункцій (деструктивного підходу).
5. Не допускається використання циклів.

Кожна реалізована функція має бути протестована для різних тестових наборів. Тести мають бути оформленні у вигляді модульних тестів (див. п. 2.3).  

Додатковий бал за лабораторну роботу можна отримати в разі виконання всіх наступних умов:
- робота виконана до дедлайну (включно з датою дедлайну)
- крім основних реалізацій функцій за варіантом, також реалізовано додатковий варіант однієї чи обох функцій, який працюватиме швидше за основну реалізацію, не порушуючи при цьому перші три вимоги до основної реалізації (вимоги 4 і 5 можуть бути порушені), за виключенням того, що в разі необхідності можна також використати стандартну функцію copy-list.

## Варіант 11
1. Написати функцію remove-thirds , яка видаляє зі списку кожен третій елемент:
```lisp
CL-USER> (remove-thirds '(a b c d e f g))
(A B D E G)
```
2. Написати функцію list-set-union-3 , яка визначає об'єднання трьох множин, заданих списками атомів:
```lisp
CL-USER> (list-set-union-3 '(1 2 3) '(2 3 4) '(nil t))
(1 2 3 4 NIL T) ; порядок може відрізнятись
```

## Лістинг функції remove-thirds
```lisp
CL-USER> (defun remove-thirds-aux (lst)
  (if (cddr lst)
      (cons (car lst) (cons (cadr lst) (remove-thirds-aux (cdddr lst))))
      lst))

(defun remove-thirds (lst)
  (when (listp lst)
      (remove-thirds-aux lst)))
REMOVE-THIRDS
```
### Тестові набори та утиліти
```lisp
CL-USER> (defun check-my-reverse (name input expected)
  "Execute `my-reverse' on `input', compare result with `expected' and print comparison status"
  (format t "~:[FAILED~;passed~] ~a~%"
          (equal (remove-thirds input) expected)
          name))

(defun test-my-reverse ()
  (check-my-reverse "test 1" '(1 2 3 4 5 6) '(1 2 4 5))
  (check-my-reverse "test 2" '(1 'b (nil) '|logo| 42 'r 0) '(1 'b '|logo| 42 0))
  (check-my-reverse "test 3" '(1 2) '(1 2))
  )
TEST-MY-REVERSE
```
### Тестування
```lisp
CL-USER> (test-my-reverse)
passed test 1
passed test 2
passed test 3
NIL
```
## Лістинг функції list-set-union-3
```lisp
CL-USER> (defun list-set-union-3-aux (lst)
  (cond
    ((null lst) nil)
    ((member (car lst) (cdr lst))
     (list-set-union-3-aux (cdr lst)))
    (t (cons (car lst) (list-set-union-3-aux (cdr lst))))))

(defun list-set-union-3 (lst1 lst2 lst3)
  (when (and (listp lst1) (listp lst2) (listp lst3))
    (list-set-union-3-aux (append lst1 lst2 lst3))))

LIST-SET-UNION-3
```
### Тестові набори та утиліти
```lisp
CL-USER> (defun check-my-reverse (name input1 input2 input3 expected)
  "Execute `my-reverse' on `input', compare result with `expected' and print comparison status"
  (format t "~:[FAILED~;passed~] ~a~%"
          (equal (list-set-union-3 input1 input2 input3) expected)
          name))

(defun test-my-reverse ()
  (check-my-reverse "test 1" '(1 2 3) '(2 3 4) '(4 5 6 7 8) '(1 2 3 4 5 6 7 8))
  (check-my-reverse "test 2" '(1 'b (nil) '|logo| 42 'r 0) '(1 'b '|logo| 42 0) '('|logo| 1 1 1) '('B (NIL) '|logo| 'R 'B '|logo| 42 0 '|logo| 1))
  (check-my-reverse "test 3" '(1 2) '(1 2) 'a nil)
  )

TEST-MY-REVERSE
```
### Тестування
```lisp
CL-USER> (test-my-reverse)
passed test 1
passed test 2
passed test 3
NIL
```
