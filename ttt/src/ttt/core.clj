(ns ttt.core
  (require [clojure.string :as string]))

(defmacro debug [form]
  `(let [val# ~form]
     (prn val#)
     val#))

(defn other-turn [turn] 
  (if (= turn 'x) 'o 'x))

(defn init-position
  ([] (init-position 3))
  ([dim] {:board (vec (take (* dim dim) (repeat '-)))
          :turn 'x
          :other-turn 'o
          :depth 0
          :dim dim})
  ([board turn] {:board board
                 :turn turn
                 :other-turn (other-turn turn)
                 :depth 0
                 :dim (int (Math/sqrt (count board)))}))

(defn position-str [position]
  (str "\n"
       (string/join "\n-----------\n"
                    (map #(string/join " | " % ) (partition (:dim position) (:board position))))
       "\nturn: "
       (:turn position)
       "\n"))

(defn possible-moves [position]
  (keep-indexed #(when-not (or (= 'x %2) (= 'o %2)) %1) (:board position)))

(defn move [position n]
  (merge position {:board (assoc (:board position) n (:turn position))
                   :turn (:other-turn position) 
                   :other-turn (:turn position)
                   :depth (inc (:depth position))}))

(defn win-lines [position]
  (let [dim (:dim position)
        rows (partition dim (:board position)) ]
    (concat rows
            (apply mapv vector rows)
            (vector (map first (partition 1 (inc dim) (:board position))))
            (vector (->> (:board position)
                         (partition 1 (dec dim))
                         (map first)
                         (drop 1)
                         (take dim))))))

(defn win? [position piece]
  (some #(every? #{piece} %) (win-lines position)))

(defn blocked? [position]
  (every? #(and (some '#{x} %)
                (some '#{o} %)) (win-lines position)))

(def MAX-VALUE 100)

(defn ^:dynamic evaluate-leaf [position]
  (cond (win? position 'x) (- MAX-VALUE (:depth position 0))
        (win? position 'o) (- (- MAX-VALUE (:depth position 0)))
        (blocked? position) 0
        :else nil))

(defn ^:dynamic find-children [position]
  (map #(move position %) (possible-moves position)))

(def negamax
  (memoize
    (fn [node alpha beta color]
      (let [node-value (evaluate-leaf node)]
        (if node-value
          (* color node-value)
          (->> node
               (find-children)
               (map #(- (negamax % (- beta) (- alpha) (- color))))
               (take-while #(< % beta))
               (cons alpha)
               (apply max)))))))

(defn get-color [position ] ({'x 1 'o -1} (:turn position)))

(defn evaluate [position]
  (let [color (get-color position)]
    (* color (negamax position (- MAX-VALUE) MAX-VALUE color))))

(defn best-moves [position]
  (let [color (get-color position)
        choices (->> position
                     (possible-moves)
                     (map #(vector (evaluate (move position %)) %))
                     (sort #(* (- color) (compare (first %1) (first %2)))))
        best-score (ffirst choices)]
    (keep #(if (= best-score (first %)) (second %)) choices)))

(defn best-move [position]
  (first (best-moves position)))

(defn random-best-move [position]
  (rand-nth (best-moves position)))
