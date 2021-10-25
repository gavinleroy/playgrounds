#lang racket

(provide
 Table?
 (contract-out
  (empty-table  (-> any/c any/c Table?))
  (extend-table (-> symbol? any/c Table? Table?))
  (in?          (-> Table? (-> any/c boolean?)))
  (retrieve     (-> symbol? Table? (or/c #false any/c)))))

;; -----------------------------------------------------------------------------
   
(struct Table (to from assoc))
;; is one of
(define (empty-table to from) (Table to from '()))

(define (extend-table id transformer more)
  (match-define (Table to from stuff) more)
  (Table to from (cons (cons id transformer) stuff)))

(define ((in? table) name)
  (and (symbol? name) (retrieve name table) #t))
  
(define (retrieve name table)
  (match table
    [(Table _ _ '()) #f]
    [(Table to from (cons (cons (? (curry symbol=? name)) t) more))
     (compose to t from)]
    [(Table _ _ (cons (cons x t) more)) (retrieve name more)]))