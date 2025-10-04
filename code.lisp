(defun remove-thirds-aux (lst)
  (if (cddr lst)
      (cons (car lst) (cons (cadr lst) (remove-thirds-aux (cdddr lst))))
      lst))

(defun remove-thirds (lst)
  (when (and (listp lst) (null (cdr (last lst))))
      (remove-thirds-aux lst)))

;;----------------------------------------------------------------------------
;; Набір тестів для remove-thirds

(defun check-my-remove-thirds (name input expected)
  "Execute `remove-thirds' on `input', compare result with `expected' and print comparison status"
  (format t "~:[FAILED~;passed~] ~a~%"
          (equal (remove-thirds input) expected)
          name))

(defun test-my-remove-thirds ()
  (check-my-remove-thirds "test 1" '(1 2 3 4 5 6) '(1 2 4 5))
  (check-my-remove-thirds "test 2" '(1 'b (nil) '|logo| 42 'r 0) '(1 'b '|logo| 42 0))
  (check-my-remove-thirds "test 3" '(1 2) '(1 2))
  )

;;----------------------------------------------------------------------------
;; Набір тестів для list-set-union-3

(defun check-my-list-set-union-3 (name input1 input2 input3 expected)
  "Execute `list-set-union-3' on `input1, input2, input3', compare result with `expected' and print comparison status"
  (format t "~:[FAILED~;passed~] ~a~%"
          (equal (list-set-union-3 input1 input2 input3) expected)
          name))

(defun test-my-list-set-union-3 ()
  (check-my-list-set-union-3 "test 1" '(1 2 3) '(2 3 4) '(4 5 6 7 8) '(1 2 3 4 5 6 7 8))
  (check-my-list-set-union-3 "test 2" '(1 'b (nil) '|logo| 42 'r 0) '(1 'b '|logo| 42 0) '('|logo| 1 1 1) '('B (NIL) '|logo| 'R 'B '|logo| 42 0 '|logo| 1))
  (check-my-list-set-union-3 "test 3" '(1 2) '(1 2) '(a) '(1 2 a)))

;;---------------------------------------------------------------------------
;; Через member
(defun list-set-union-3-aux (lst)
  (cond
    ((null lst) nil)
    ((member (car lst) (cdr lst))
     (list-set-union-3-aux (cdr lst)))
    (t (cons (car lst) (list-set-union-3-aux (cdr lst))))))

(defun list-set-union-3 (lst1 lst2 lst3)
  (when (and (listp lst1) (null (cdr (last lst1)))
             (listp lst2) (null (cdr (last lst2)))
             (listp lst3) (null (cdr (last lst3))))
    (list-set-union-3-aux (append lst1 lst2 *))))

;;----------------------------------------------------------------------------
;; Довга реалізація

(defun chek-third-lst (x lst3)
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

;;------------------------------------------------------------------------------
;; Надлишок копіювань

(defun find-element (x lst)
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

;;-------------------------------------------------------------------------------
;; Краща реалізація

(defun find-element (x lst)
  (cond
    ((null lst) nil) 
    ((eql x (car lst)) t)
    (t (find-element x (cdr lst)))))

(defun list-set-union-3-aux (lst1 lst2)
  (cond
    ((null lst1) lst2)
    ((or (find-element (car lst1) (cdr lst1))  
         (find-element (car lst1) lst2))        
     (list-set-union-3-aux (cdr lst1) lst2))
    (t (cons (car lst1) (list-set-union-3-aux (cdr lst1) lst2)))))

(defun list-set-union-3 (lst1 lst2 lst3)
  (when (and (listp lst1) (listp lst2) (listp lst3))
    (list-set-union-3-aux lst1 (list-set-union-3-aux lst2 (list-set-union-3-aux lst3 nil)))))

