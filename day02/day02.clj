(require '[clojure.string :as str])

(defn drive [pos line]
    (let [
        x (first pos) 
        y (second pos)
        word (first line)
        step (read-string (second line))] 
        (case word 
            "forward" (list (+ x step) y)
            "down"    (list x (+ y step))
            "up"      (list x (- y step))
            )))

(defn drive2 [pos line]
    (let [
        x (first pos) 
        y (second pos)
        aim (second (rest pos))
        word (first line)
        step (read-string (second line))] 
        (case word 
            "forward" (list (+ x step) (+ y (* aim step)) aim)
            "down"    (list x y (+ aim step))
            "up"      (list x y (- aim step))
            )))

(defn part1 
    "solve the first part by reducing the input"
    [input]
    (reduce * (reduce drive '(0 0) input))
    )

(defn part2
    [input]
    (reduce * (take 2 (reduce drive2 '(0 0 0) input)))
    )
        
(defn main [] 
    (def input (map #(str/split % #" ") 
        (clojure.string/split-lines (slurp "input.txt"))))
    (println (part1 input))
    (println (part2 input))
)
(main)