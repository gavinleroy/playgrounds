#lang racket

(require (for-syntax syntax/parse)
         syntax/parse/define)

; yeah yeah yeah, these could be better

(define (fibonacci n)
  (if (< n 2)
      1
      (+ (fibonacci (- n 1))
         (fibonacci (- n 2)))))

(define (factorial n)
  (if (<= n 1)
      1
      (* n (factorial (- n 1)))))

; boring initial code
(let* ([before (current-inexact-milliseconds)]
       [answer (factorial (fibonacci 10))]
       [after (current-inexact-milliseconds)])
 (printf "It took ~a ms to compute.\n" (- after before))
 answer)

(define (thunk-time-it do-it)
  (let* ([before (current-inexact-milliseconds)]
         [answer (do-it)]
         [after (current-inexact-milliseconds)])
    (printf "It took ~a ms to compute.\n" (- after before))
    answer))

; boo, no abstraction
(printf "The factorial of the tenth fibonacci is: ~a\n"
        (thunk-time-it (λ () (factorial (fibonacci 10)))))

; better
(define-simple-macro (time-it v)
  (thunk-time-it (λ () v)))

(time-it (factorial (fibonacci 10)))

; mapping over things

(define-simple-macro (for/list-0 ((symb seq)) bdy)
  (map (λ (symb) bdy) seq))

; testing out the simple macro
(for/list-0 ((i '(1 2 3)))
  (* i i))

(define-simple-macro (for/list-1 ((symb seq) ...) bdy)
  (map (λ (symb ...) bdy) seq ...))

;; (for/list-1 ((i '(1 2 3))
;;              (j '(3 2 1))
;;              (k '(4 4 4 4))) ; Whoops! runtime error. length mismatch
;;   (list i j k))

; unveiling define-simple-macro

;; (define-simple-macro (macro-name input-pattern)
;;   output-template)
;; =>
;; (define-syntax macro-name
;;   (λ (the-syntax-of-the-application)
;;     (syntax-parse the-syntax-of-the-application
;;       [(macro-name input-pattern)
;;        #'output-template])))

;; Here we are binding the actual lists to 'list-name'. We are introducing a new new template variable with
;; the 'with-syntax' form.
(define-syntax (for/list-2 stx)
  (syntax-parse stx
    ; 1. We will have more input pattern cases.
    [(_ ([elem-name seq] ...) computation)
     ; 2. We will do more than just return the output template.
     (with-syntax ([(list-name ...) #'(elem-name ...)])
       #`(letrec ([iterate
                   (λ (list-name ...)
                     (cond
                       [(or (empty? list-name) ...)
                        empty]
                       [else
                        (cons
                         (let ([elem-name (first list-name)] ...)
                           computation)
                         (iterate (rest list-name) ...))]))])
           (printf "Iterating ~a lists.\n" #,(length (syntax->list #'(elem-name ...))))
           (iterate seq ...)))]))

;;

(for/list-2 ((i '(1 2 3))
             (j '(3 2 1))
             (q '(some new things))
             (k '(4 4 4 4))) ; Fine because we stop at a short iteration
  (list i q j k))

;; Macros with cases

(define-syntax (simple-match stx)
  (syntax-parse stx
    [(_ var)
     #'(error "input unmatched ~a\n" var)]
    [(_ var [(#:null) null-case] more ...)
     #'(if (null? var)
           null-case
           (simple-match var more ...))]

    [(_ var [(#:number) num-case] more ...)
     #'(if (number? var)
           num-case
           (simple-match var more ...))]

    [(_ var [(#:cons car-n cdr-n) cons-case] more ...)
     #'(if (cons? var)
           (let ([car-n (car var)]
                 [cdr-n (cdr var)])
             cons-case)
           (simple-match var more ...))]))

; Sum trees where numbers can occur anywhere
(define (sum-tree tree-var)
  (simple-match tree-var
   [(#:null) 0]
   [(#:cons left right)
    (+ (sum-tree left) (sum-tree right))]
   [(#:number) tree-var]))

; Sum lists where numbers only occur to the left of a cons pair
(define (sum-list tree-var)
  (simple-match tree-var
   [(#:null) 0]
   [(#:cons elem more)
    (+ elem (sum-list more))]))

; Sum trees where leaves are always numbers
(define (sum-leaves tree-var)
  (simple-match tree-var
   [(#:cons left right)
    (+ (sum-leaves left) (sum-leaves right))]
   [(#:number) tree-var]))

(printf "Tree Sum ~a List Sum ~a Leaves Sum ~a\n"
        (sum-tree (cons (cons null null) (cons null (cons null null))))
        (sum-list '(1 2 3 4 5))
        (sum-leaves (cons (cons 1 2) (cons 3 (cons 4 5)))))
