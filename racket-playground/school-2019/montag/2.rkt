;; Gavin Gray, School of Racket 2019
;;

#lang racket

;; (define program-as-text "((lambda (x) (+ x 10)) 42)")

;; (define macro-as-text
;;   (string-append
;;     "((lambda (y)"
;;     "   (let-syntax (plus10"
;;     "               (lambda (stx)"
;;     "                 (match stx"
;;     "                   [`(plus10 ,x) `(+ ,x 10)])))"
;;     "     (plus10 y)))"
;;     " 42)"))


;; (define another-example
;;   (string-append
;;   "((lambda (fun)"
;;   "   (fun "
;;   "    (let-syntax (syn (lambda (stx)"
;;   "                         23))"
;;   "      (syn (fun 1) 20))))"
;;   " (lambda (x) (+ x 1)))"))

;; ; A SyntaxTree is one of:
;; ; – (Syntax Number)
;; ; – (Syntax Symbol)
;; ; – (Syntax (list SyntaxTree ... SyntaxTree))
;; (struct Syntax (e {stuff #:auto}) #:transparent #:auto-value 'stuff)

;; ; S-expression -> SyntaxTree
;; (define (to-Syntax stx)
;;   (cond
;;     [(cons? stx) (Syntax (map to-Syntax stx))]
;;     [else (Syntax stx)]))

;; ; String -> S-exp
;; ; read string (of characters) and transform into an S-expression
;; (define (lex str) ; also known as READER
;;   ... read ... to-Syntax ...)

;; ((lambda (fun)
;;    (fun
;;     (let-syntax ([syn (lambda (stx)     ; fix 1: add [...]
;;                         #'23)])   ; fix 2: add syntax
;;       (syn (fun 1) 20))))
;;  (lambda (x) (+ x 1)))

(let ([fun (lambda (x) 65)])
  (list (fun 0)
        (let-syntax ((syn (lambda (stx)
                            (displayln stx)
                            #'23)))
          (list
           (syn)
           (syn 10)
           (syn 10 20)))
        (fun 1)))

(let ([fun (lambda (x) x)])
  (fun
   (let-syntax ((lambda (lambda (stx)
                          (displayln stx)
                          #'23)))
     (let ([fun (lambda (x) (+ 99 x))])
       fun))))
