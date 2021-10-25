#lang racket

(require (only-in 2htdp/universe sexp?))

(define data-rep? (or/c sexp? syntax?))

(provide
 (contract-out 
  (make-transformer
   ;; transform an S-expression into a procedure that maps S-expr to itself
   (-> data-rep? (-> data-rep? data-rep?)))))

;; -----------------------------------------------------------------------------
(define (make-transformer f)
  (parameterize ([current-namespace (make-base-empty-namespace)])
    (namespace-require 'racket)
    (namespace-require 'syntax/parse) ;; for the syn. obj. step
    (eval f)))
