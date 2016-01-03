#lang racket

(require "automata.rkt" "population.rkt" "scan.rkt" "inout.rkt" plot)
(plot-new-window? #t)

(provide main test1s plot-dynamics)

;; UTILITIES
  (define N 1000)
  (define CYCLES 1000)
  (define SPEED 100)
  (define DELTA 1)

;; TEST 1: POPULATION: COOPERATES, DEFECTS, TIT-FOR-TAT
(define (build-population d t c)
  (define p
    (vector-append
     (build-vector t (lambda (_) (tit-for-tat)))
     (build-vector d (lambda (_) (defects)))
     (build-vector c (lambda (_) (cooperates)))))
  (shuffle-vector p p))

(define point-list
  (list
   (list 50 50 900)
   (list 50 100 850)
   (list 50 150 800)
   (list 50 200 750)
   (list 50 250 700)
   (list 50 300 650)
   (list 50 350 500)
   (list 50 400 550)
   (list 50 450 500)))

(define (evolve-rd population cycles speed r d)
  (cond
   [(zero? cycles) '()]
   [else (define p2 (match-up* population r d))
         (define pp (population-payoffs p2))
         (define p3 (regenerate p2 speed))
         (cons (scan-defects-tft p3)
               (evolve-rd p3 (- cycles 1) speed r d))]))

(define (test1 test-point file-name)
  (collect-garbage)
  (collect-garbage)
  (collect-garbage)
  (define A (apply build-population test-point))
  (define ROUNDS-PER-MATCH 20)
  (define rd-types
    (time (evolve-rd A CYCLES SPEED ROUNDS-PER-MATCH DELTA)))
  (out-data file-name (map list (flatten rd-types)))
  (define rd (lines rd-types))
  (plot rd #:x-min 0.0 #:x-max N #:y-min 0 #:y-max N #:title "replicator dynamics"))

(define (test1s test-points)
  (for ([i (length test-points)])
    (test1 (list-ref test-points i)
           (string-append "rd" (number->string i)))))

(define file-list
  (list "rd0" "rd1" "rd2" "rd3" "rd4" "rd5" "rd6" "rd7" "rd8"))

(define (plot-dynamics file-list)
  (define data (load-dynamics file-list))
  (plot data
        #:x-max N #:y-max N
        #:x-label "defects" #:y-label "tft" #:title "delta 1"))

(define (main)
  (collect-garbage)
  (collect-garbage)
  (collect-garbage)
  (test1s point-list)
  (plot-dynamics file-list))
