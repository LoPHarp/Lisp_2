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
CL-USER> (defun check-my-remove-thirds (name input expected)
  "Execute `remove-thirds' on `input', compare result with `expected' and print comparison status"
  (format t "~:[FAILED~;passed~] ~a~%"
          (equal (remove-thirds input) expected)
          name))

(defun test-my-remove-thirds ()
  (check-my-remove-thirds "test 1" '(1 2 3 4 5 6) '(1 2 4 5))
  (check-my-remove-thirds "test 2" '(1 'b (nil) '|logo| 42 'r 0) '(1 'b '|logo| 42 0))
  (check-my-remove-thirds "test 3" '(1 2) '(1 2))
  )
TEST-MY-REMOVE-THIRDS
```
### Тестування
```lisp
CL-USER> (test-my-remove-thirds)
passed test 1
passed test 2
passed test 3
NIL
```
## Лістинг функції list-set-union-3
#### №1
```lisp
CL-USER> (defun chek-third-lst (x lst3)
  "If the third list is empty, the function returns T; if the third list contains the same element as "X", the function returns NIL."
  (cond
    ((null lst3) t)
    ((eql x (car lst3)) nil)
    (t (chek-third-lst x (cdr lst3)))))

(defun chek-second-lst (x lst2 lst3)
  "If either of the two lists is empty, it returns T; if any of the lists contains the same element as "X", the function will return NIL."
  (cond
    ((and (null lst2) (null lst3)) t)
    ((or (eql x (car lst2))  (eql x (car lst3))) nil)
    (t (chek-second-lst x (cdr lst2) (cdr lst3)))))

(defun chek-first-lst (x lst1 lst2 lst3)
  "If any of the three lists is empty, it returns T; if any of the lists contains the same element as "X", the function returns NIL."
  (cond
    ((and (null lst1) (null lst2) (null lst3)) t)
    ((or (eql x (car lst1))  (eql x (car lst2))  (eql x (car lst3))) nil)
    (t (chek-first-lst x (cdr lst1) (cdr lst2) (cdr lst3)))))
      

(defun list-set-union-3 (lst1 lst2 lst3)
  "The function creates a new list by checking each element first from lst1 and then from lst2; if a duplicate is found, the element will be skipped."
  (cond
    (lst1
     (if (chek-first-lst (car lst1) (cdr lst1) lst2 lst3)
         (cons (car lst1) (list-set-union-3 (cdr lst1) lst2 lst3))
         (list-set-union-3 (cdr lst1) lst2 lst3)))
    (lst2
     (if (chek-second-lst (car lst2) (cdr lst2) lst3)
         (cons (car lst2) (list-set-union-3 lst1 (cdr lst2) lst3))
         (list-set-union-3 lst1 (cdr lst2) lst3)))
    (lst3
     (if (chek-third-lst (car lst3) (cdr lst3))
         (cons (car lst3) (list-set-union-3 lst1 lst2 (cdr lst3)))
         (list-set-union-3 lst1 lst2 (cdr lst3))))))

LIST-SET-UNION-3
```
#### №2 (більш гарний варіант)
```lisp
CL-USER> (defun find-element (x lst)
  (cond
    ((null lst) nil) 
    ((eql x (car lst)) t)
    (t (find-element x (cdr lst)))))

(defun list-set-union-3-aux (lst)
  (cond
    ((null lst) nil)
    ((find-element (car lst) (cdr lst)) (list-set-union-3-aux (cdr lst)))
    (t (cons (car lst) (list-set-union-3-aux (cdr lst))))))

(defun list-set-union-3 (lst1 lst2 lst3)
  (when (and (listp lst1) (listp lst2) (listp lst3))
    (list-set-union-3-aux (append lst1 lst2 (copy-list lst3)))))

LIST-SET-UNION-3
```
### Тестові набори та утиліти (Результат однаковий в обох варіантах)
```lisp
CL-USER> (defun check-my-list-set-union-3 (name input1 input2 input3 expected)
  "Execute `list-set-union-3' on `input1, input2, input3', compare result with `expected' and print comparison status"
  (format t "~:[FAILED~;passed~] ~a~%"
          (equal (list-set-union-3 input1 input2 input3) expected)
          name))

(defun test-my-list-set-union-3 ()
  (check-my-list-set-union-3 "test 1" '(1 2 3) '(2 3 4) '(4 5 6 7 8) '(1 2 3 4 5 6 7 8))
  (check-my-list-set-union-3 "test 2" '(1 'b (nil) '|logo| 42 'r 0) '(1 'b '|logo| 42 0) '('|logo| 1 1 1) '('B (NIL) '|logo| 'R 'B '|logo| 42 0 '|logo| 1))
  (check-my-list-set-union-3 "test 3" '(1 2) '(1 2) '(a) '(1 2 a)))
TEST-MY-LIST-SET-UNION-3
```
### Тестування
```lisp
CL-USER> (test-my-list-set-union-3)
passed test 1
passed test 2
passed test 3
NIL
```
