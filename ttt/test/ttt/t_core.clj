(ns ttt.t-core
  (:use midje.sweet)
  (:use [ttt.core]))

(fact (:board (init-position)) => '[- - -, - - -, - - -])
(fact (possible-moves (init-position)) => (range 0 9))
(fact (:board (move (init-position) 0)) => '[x - -, - - -, - - -])
(fact (other-turn 'x) => 'o)
(fact (other-turn 'o) => 'x)
(fact (:dim (init-position)) => 3)
(fact (:dim (init-position '[- - -, - - -, - - -] 'x)) => 3)
(fact (:turn (init-position)) => 'x)
(fact (:turn (move (init-position) 0)) => 'o)
(fact (:depth (init-position)) => 0)
(fact (:depth (move (init-position) 0)) => 1)
(fact (possible-moves (move (init-position) 0)) => (range 1 9))
(fact (win-lines {:board [0 1 2 3 4 5 6 7 8 9] :dim 3}) => '((0 1 2) (3 4 5) (6 7 8) [0 3 6] [1 4 7] [2 5 8] (0 4 8) (2 4 6)))

;;--------------------------------------------------
;; win?
;;--------------------------------------------------
(fact (win? (init-position) 'x) => falsey)
(fact (win? {:board '[x x x
                      o o -
                      - - -] :dim 3} 'x) => truthy)

(fact (win? {:board '[x x -
                      o o o
                      - - -] :dim 3} 'o) => truthy)

(fact (win? {:board '[x o x
                      o o -
                      x x x] :dim 3} 'x) => truthy)

(fact (win? {:board '[x - o
                      x o -
                      x - -] :dim 3} 'x) => truthy)

(fact (win? {:board '[o x -
                      o x -
                      - x -] :dim 3} 'x) => truthy)

(fact (win? {:board '[- o x
                      - o x
                      - - x] :dim 3} 'x) => truthy)

(fact (win? {:board '[x - o
                      o x -
                      - - x] :dim 3} 'x) => truthy)

(fact (win? {:board '[- o x
                      o x -
                      x - -] :dim 3} 'x) => truthy)

;;--------------------------------------------------
;; blocked?
;;--------------------------------------------------
(fact (blocked? {:board '[- o x
                          o x -
                          x - -] :dim 3}) => falsey)

(fact (blocked? {:board '[x o x
                          o o x
                          x x o] :dim 3}) => truthy)

;;--------------------------------------------------
;; evaluate-leaf
;;--------------------------------------------------
(fact (evaluate-leaf (init-position '[x - -
                                      - - -
                                      - - -] 'o)) => nil)

(fact (evaluate-leaf (init-position '[x - o
                                      x o -
                                      x - -] 'o)) => 100)

(fact (evaluate-leaf (init-position '[x o -
                                      x o x
                                      - o x] 'x)) => -100)

(fact (evaluate-leaf (init-position '[x o x
                                      o o x
                                      - x o] 'o)) => 0)

;;--------------------------------------------------
;; negamax
;;--------------------------------------------------
(binding [evaluate-leaf (fn [node]
                          (if (= (class node) java.lang.Long)
                            node
                            nil))
          find-children (fn [node] node)]
  (fact (negamax 4 -100 100 1) => 4)
  (fact (negamax [4] -100 100 1) => 4)
  (fact (negamax [4 5] -100 100 1) => 5)
  (fact (negamax [4 5 6 7] -100 5 1) => 4)
  (fact (negamax [4 5 6 7] -5 100 -1) => -4)
  ;; got this one from wikipedia on alpha-beta pruning
  (fact (negamax [[[[5 6] [7 4 5]] [[3]]] [[[6] [6 9]]] [[[5]] [[9 8] [6]]]] -100 100 1) => 6)) 

;;--------------------------------------------------
;; evaluate
;;--------------------------------------------------
(fact (evaluate (init-position '[x x o
                                 - x -
                                 - - o] 'o)) => -99)

(fact (evaluate (init-position '[x - o
                                 - x -
                                 - - o] 'x)) => 0)

(fact (evaluate (init-position '[x - o
                                 - x x
                                 - - o] 'o)) => 0)

(fact (evaluate (init-position '[x - o
                                 x o -
                                 - - -] 'x)) => 99)

(fact (evaluate (init-position '[x o o
                                 - o x
                                 - - x] 'o)) => -99)

;;--------------------------------------------------
;; best-move
;;--------------------------------------------------
(fact (best-move (init-position '[o - x
                                  - o x
                                  - - -] 'x)) => 8)

(fact (best-move (init-position '[x o x
                                  - o -
                                  - - -] 'o)) => 7)

(fact (best-move (init-position '[x o -
                                  - x -
                                  - - -] 'o)) => 8)

(fact (best-move (init-position '[x o -
                                  - - -
                                  - - -] 'x)) => 3)

(fact (time (best-move (init-position '[- - -
                                        - - -
                                        - - -] 'x))) => 0)

