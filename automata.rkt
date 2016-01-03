#lang racket
(provide (all-defined-out))

;; CONFIGURATION
(define COOPERATE 0)
(define DEFECT 1)

(define ACTIONS#  2) ; the number of strategies available for each player
(define STATE-LENGTH 3)
;; the state length is 3 bc each state has 3 information:
;; the strategy to be played at that state
;; and 2 dispatching rules: given that the opponent plays C D, which state to jump to?

(define PAYOFF-TABLE
  (vector (vector (cons 3 3) (cons 0 4))
          (vector (cons 4 0) (cons 1 1))))

(define AUTO-CODE "auto-code.nb") ; file name if exporting matha code

;; AUTOMATON
;; an automaton has 4 parts:
;; current state + initial state + the payoff it has so far + a table of its states
(struct automaton (current initial payoff table) #:transparent)
;; a state has 2 parts: the action of that state + the ending trajectories
;; (ie: if the opponent plays x, dispatch to state y)
(struct state (action dispatch) #:transparent)

(define (make-random-automaton states#)
  (define initial-current (random states#)) ; the initial state is set randomly
  (define (states*) (build-vector states# make-state))
  (define (make-state _) (state (random ACTIONS#) (transitions))) ; the action in each state is set randomly
  (define (transitions) (build-vector ACTIONS# make-transition))
  (define (make-transition _) (random states#)) ; the ending trajectories are set randomly
  (automaton initial-current initial-current 0 (states*)))

(define (clone a)
  (match-define (automaton current c0 payoff table) a)
  (automaton c0 c0 0 table))

;; CLASSIC AUTOMATA
;; all coops: one state: playing Coop,
;; dispatching rules: C D -> stays in state 0
(define (cooperates)
  (automaton 0 0 0 (vector (state COOPERATE (vector 0 0)))))
(define (defects)
  (automaton 0 0 0 (vector (state DEFECT (vector 0 0)))))
(define (tit-for-tat)
  (automaton 0 0 0 (vector (state COOPERATE (vector 0 1))
                           (state DEFECT (vector 0 1)))))
(define (grim-trigger)
  (automaton 0 0 0 (vector (state COOPERATE (vector 0 1))
                           (state DEFECT (vector 1 1)))))

;; PAIR MATCH
(define (interact auto1 auto2 rounds-per-match delta)
  (match-define (automaton current1 c1 payoff1 table1) auto1)
  (match-define (automaton current2 c2 payoff2 table2) auto2)
  (define-values (new1 p1 new2 p2 round-results)
    (for/fold ([current1 current1] [payoff1 payoff1]
               [current2 current2] [payoff2 payoff2]
               [round-results '()])
              ([_ (in-range rounds-per-match)])
      (match-define (state a1 v1) (vector-ref table1 current1))
      (match-define (state a2 v2) (vector-ref table2 current2))
      (match-define (cons p1 p2) (payoff a1 a2))
      (define n1 (vector-ref v1 a2))
      (define n2 (vector-ref v2 a1))
      (define round-result (list p1 p2))
      (values n1 (+ payoff1 (* (expt delta _) p1))
              n2 (+ payoff2 (* (expt delta _) p2))
              (cons round-result round-results))))
  (values (reverse round-results) (automaton new1 c1 p1 table1) (automaton new2 c2 p2 table2)))

(define (payoff current1 current2)
  (vector-ref (vector-ref PAYOFF-TABLE current1) current2))

;; (IMMUTABLE) MUTATION
;; turn the automaton structure into a flattened list
(define (flatten-automaton au)
  (match-define (automaton current initial payoff states) au)
  (define l (vector-length states))
  (define body
    (for/list ([i (in-range l)])
      (match-define (state action dispatch) (vector-ref states i))
      (list action (vector->list dispatch))))
  (flatten (list initial body)))

;; recover automaton structure from a list
(define (recover au)
  (define-values (head body) (split-at au 1))
  (define s (/ (length body) STATE-LENGTH))
  (define (recover-body s a-body)
    (cond [(zero? s) '()]
          [else
           (define-values (first-state the-rest)
             (split-at a-body STATE-LENGTH))
           (define-values (action dispatch)
             (split-at first-state 1))
           (define result-state (state (car action) (list->vector dispatch)))
           (cons result-state (recover-body (- s 1) the-rest))]))
  (automaton (car head) (car head) 0 (list->vector (recover-body s body))))

(define (immutable-set a-list a-posn a-value)
  (define-values (head tail) (split-at a-list a-posn))
  (append head (list a-value) (drop tail 1)))

(define (mutate au)
  (define a (flatten-automaton au))
  (define r (random (length a)))
  (define s (quotient (length a) STATE-LENGTH))
  (recover
   (cond
    [(zero? r) (immutable-set a 0 (random s))]
    [(= 1 (modulo r STATE-LENGTH)) (immutable-set a r (random ACTIONS#))]
    [else (immutable-set a r (random s))])))

;; EXPORT MATHA CODE OF THE AUTOMATON
(define (generate-state-code table)
  (define l (vector-length table))
  (define state-numbers (vector-map state-action table))
  (define state-labels
    (vector-map (lambda (x)
                  (cond ([zero? x] "C")
                        ([= 1 x] "D")))
                state-numbers))
  (define state-code
    (apply string-append
           (add-between
            (for/list ([i l])
              (string-append (number->string i) " -> Placed[\"~a\", Center]"))
            ", ")))
  (apply format
         (list* state-code (vector->list state-labels))))

(define (scan-duplicate dispatch)
  (match-define (vector a1 a2) dispatch)
  (if (= a1 a2) (list "\"C,D\"" "\"C,D\"")
      (list "\"C\"" "\"D\"")))

(define (generate-dispatch-code state# dispatch)
  (define l (vector-length dispatch))
  (define ending (scan-duplicate dispatch))
  (remove-duplicates
   (for/list ([i l])
     (string-append
      "Labeled["
      (number->string state#)
      " -> "
      (number->string (vector-ref dispatch i))
      ", "
      (list-ref ending i)
      "] \n"))))

(define (generate-dispatch-codes table)
  (define dispatches (vector-map state-dispatch table))
  (define dispatch-code
    (for/list ([i (vector-length dispatches)])
      (generate-dispatch-code i (vector-ref dispatches i))))
  (apply string-append (add-between (flatten dispatch-code) ", ")))

(define (generate-matha-code au name)
  (match-define (automaton current initial payoff states) au)
  (string-append
   "VertexCircle[{xc_, yc_}, name_, {w_, h_}] := Disk[{xc, yc}, .1];\n"
   name "Graph =\n"
   "   Graph[{-1 -> " (number->string initial) " ,\n"
   (generate-dispatch-codes states)
   "     },\n"
   "   EdgeShapeFunction -> \n"
   "    GraphElementData[\"EdgeShapeFunction\", \"FilledArrow\"],\n"
   "   VertexStyle -> LightGray,\n"
   "   VertexShapeFunction -> VertexCircle,\n"
   "   VertexLabels -> {" (generate-state-code states) "}\n"
   "   ];\n"
   "G = Graphics[{White, Disk[{0, 0}, 0.2]}];\n"
   "Show[" name "Graph, G]\n"
   "(*Export[\"" name ".png\",S]*)\n \n"))

(define (export-matha-code au name)
  (with-output-to-file AUTO-CODE
    (lambda () (printf (generate-matha-code au name)))
    #:exists 'append))

(define (export-matha-codes a-list name)
  (for ([i (length a-list)])
    (export-matha-code (list-ref a-list i)
                       (string-append (symbol->string name)
                                      (number->string i)))))
