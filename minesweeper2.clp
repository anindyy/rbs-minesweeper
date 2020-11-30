;;; TEMPLATES
(deftemplate position
  (slot x (type INTEGER) (range 0 ?VARIABLE))
  (slot y (type INTEGER) (range 0 ?VARIABLE)))

(deftemplate flagged
  (slot x (type INTEGER) (range 0 ?VARIABLE))
  (slot y (type INTEGER) (range 0 ?VARIABLE)))

(deftemplate probed
	(slot x (type INTEGER) (range 0 ?VARIABLE))
  (slot y (type INTEGER) (range 0 ?VARIABLE))
	(slot value (type INTEGER) (range 0 ?VARIABLE)))

(deftemplate adjacent
  (slot x1 (type INTEGER) (range 0 ?VARIABLE))
  (slot y1 (type INTEGER) (range 0 ?VARIABLE))
  (slot x2 (type INTEGER) (range 0 ?VARIABLE))
  (slot y2 (type INTEGER) (range 0 ?VARIABLE)))

(deftemplate move
  (slot x (type INTEGER) (range 0 ?VARIABLE))
  (slot y (type INTEGER) (range 0 ?VARIABLE))
  (slot action (type SYMBOL) (allowed-values flag probe)))

;;; inigausa? kaga tauu wkwk
(deftemplate bomb-probability
  (multislot pos)
  (slot bomb-count (type INTEGER) (range 0 ?VARIABLE)))

;;; FUNCTION
(deffunction cek-ujung (?x ?y)
  (bind ?c 0)
  (loop-for-count (?x1 (- ?x 1) (+ ?x 1))
    (loop-for-count (?y1 (- ?y 1) (+ ?y 1)) 
      (if (and (and (and (> ?y1 0) (> ?x1 0)) (< ?y1 ?*size*)) (< ?x1 ?*size*))
        then
        (bind ?c (+ ?c 1)))))
  (bind ?res (= ?c 6))
  ?res)

;;; RULES
;;; Mendefinisikan kotak-kotak yang bersebelahan
(defrule check-adjacent-top-left
  ?p1 <- (position (x ?x1) (y ?y1))
  ?p2 <- (position (x ?x2) (y ?y2))
  (test (and (= ?x1 (- ?x2 1)) (= ?y1 (- ?y2 1))))
  =>
  (assert (adjacent (x1 ?x1) (y1 ?y1) (x2 ?x2) (y2 ?y2))))

(defrule check-adjacent-top
  ?p1 <- (position (x ?x1) (y ?y1))
  ?p2 <- (position (x ?x2) (y ?y2))
  (test (and (= ?x1 ?x2) (= ?y1 (- ?y2 1))))
  =>
  (assert (adjacent (x1 ?x1) (y1 ?y1) (x2 ?x2) (y2 ?y2))))
  
(defrule check-adjacent-top-right
  ?p1 <- (position (x ?x1) (y ?y1))
  ?p2 <- (position (x ?x2) (y ?y2))
  (test (and (= ?x1 (+ ?x2 1)) (= ?y1 (- ?y2 1))))
  =>
  (assert (adjacent (x1 ?x1) (y1 ?y1) (x2 ?x2) (y2 ?y2))))

(defrule check-adjacent-left
  ?p1 <- (position (x ?x1) (y ?y1))
  ?p2 <- (position (x ?x2) (y ?y2))
  (test (and (= ?x1 (- ?x2 1)) (= ?y1 ?y2)))
  =>
  (assert (adjacent (x1 ?x1) (y1 ?y1) (x2 ?x2) (y2 ?y2))))

(defrule check-adjacent-right
  ?p1 <- (position (x ?x1) (y ?y1))
  ?p2 <- (position (x ?x2) (y ?y2))
  (test (and (= ?x1 (+ ?x2 1)) (= ?y1 ?y2)))
  =>
  (assert (adjacent (x1 ?x1) (y1 ?y1) (x2 ?x2) (y2 ?y2))))

(defrule check-adjacent-bottom-left
  ?p1 <- (position (x ?x1) (y ?y1))
  ?p2 <- (position (x ?x2) (y ?y2))
  (test (and (= ?x1 (- ?x2 1)) (= ?y1 (+ ?y2 1))))
  =>
  (assert (adjacent (x1 ?x1) (y1 ?y1) (x2 ?x2) (y2 ?y2))))

(defrule check-adjacent-bottom
  ?p1 <- (position (x ?x1) (y ?y1))
  ?p2 <- (position (x ?x2) (y ?y2))
  (test (and (= ?x1 ?x2) (= ?y1 (+ ?y2 1))))
  =>
  (assert (adjacent (x1 ?x1) (y1 ?y1) (x2 ?x2) (y2 ?y2))))

(defrule check-adjacent-bottom-right
  ?p1 <- (position (x ?x1) (y ?y1))
  ?p2 <- (position (x ?x2) (y ?y2))
  (test (and (= ?x1 (+ ?x2 1)) (= ?y1 (+ ?y2 1))))
  =>
  (assert (adjacent (x1 ?x1) (y1 ?y1) (x2 ?x2) (y2 ?y2))))

(defrule one-one
  (position (x ?x1) (y ?y1))
  (position (x ?x2) (y ?y2))
  (cek-ujung ?x1 ?y1)
  (adjacent (x1 ?x1) (y1 ?y1) (x2 ?x2) (y2 ?y2))
  (probed (x ?x1) (y ?y1) (value ?val1))
  (probed (x ?x1) (y ?y1) (value ?val2))
  (test (and (= ?val1 1) (= ?val2 1)))
=>
  (assert (move (x (+ x2 2)) (y (- y2 1)) probe))

(defrule one-two
  (position (x ?x1) (y ?y1))
  (position (x ?x2) (y ?y2))
  (cek-ujung ?x1 ?y1)
  (adjacent (x1 ?x1) (y1 ?y1) (x2 ?x2) (y2 ?y2))
  (probed (x ?x1) (y ?y1) (value ?val1))
  (probed (x ?x1) (y ?y1) (value ?val2))
  (test (and (= ?val1 1) (= ?val2 2)))
=>
  (assert (move (x (+ x2 2)) (y (- y2 1)) flag))