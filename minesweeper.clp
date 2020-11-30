;;; sepertinya butuh constant size berapa, bomb berapa
;;; dari python deffact bomb
;;; dari python juga defglobal MAIN ?*size* = brp

;;; TEMPLATE DEFINITIONS
(deftemplate position
  (slot x (type INTEGER) (range 0 ?VARIABLE))
  (slot y (type INTEGER) (range 0 ?VARIABLE)))

(deftemplate flagged
  (slot pos))

(deftemplate probed
	(slot pos)
	(slot value (type INTEGER) (range 0 ?VARIABLE)))

(deftemplate adjacent
  (slot pos1)
  (slot pos2))

(deftemplate move
  (slot pos)
  (slot action (type SYMBOL) (allowed-values flag probe)))

(deftemplate bomb-probability
  (multislot pos)
  (slot bomb-count (type INTEGER) (range 0 ?VARIABLE)))


;;; RULE DEFINITIONS
;;; Mendefinisikan kotak-kotak yang bersebelahan
(defrule check-adjacent-top-left
  ?p1 <- (position (x ?x1) (y ?y1))
  ?p2 <- (position (x ?x2) (y ?y2))
  (test (and (= ?x1 (- ?x2 1)) (= ?y1 (- ?y2 1))))
  =>
  (assert (adjacent (pos1 ?p1) (pos2 ?p2))))

(defrule check-adjacent-top
  ?p1 <- (position (x ?x1) (y ?y1))
  ?p2 <- (position (x ?x2) (y ?y2))
  (test (and (= ?x1 ?x2) (= ?y1 (- ?y2 1))))
  =>
  (assert (adjacent (pos1 ?p1) (pos2 ?p2))))
  
(defrule check-adjacent-top-right
  ?p1 <- (position (x ?x1) (y ?y1))
  ?p2 <- (position (x ?x2) (y ?y2))
  (test (and (= ?x1 (+ ?x2 1)) (= ?y1 (- ?y2 1))))
  =>
  (assert (adjacent (pos1 ?p1) (pos2 ?p2))))

(defrule check-adjacent-left
  ?p1 <- (position (x ?x1) (y ?y1))
  ?p2 <- (position (x ?x2) (y ?y2))
  (test (and (= ?x1 (- ?x2 1)) (= ?y1 ?y2)))
  =>
  (assert (adjacent (pos1 ?p1) (pos2 ?p2))))

(defrule check-adjacent-right
  ?p1 <- (position (x ?x1) (y ?y1))
  ?p2 <- (position (x ?x2) (y ?y2))
  (test (and (= ?x1 (+ ?x2 1)) (= ?y1 ?y2)))
  =>
  (assert (adjacent (pos1 ?p1) (pos2 ?p2))))

(defrule check-adjacent-bottom-left
  ?p1 <- (position (x ?x1) (y ?y1))
  ?p2 <- (position (x ?x2) (y ?y2))
  (test (and (= ?x1 (- ?x2 1)) (= ?y1 (+ ?y2 1))))
  =>
  (assert (adjacent (pos1 ?p1) (pos2 ?p2))))

(defrule check-adjacent-bottom
  ?p1 <- (position (x ?x1) (y ?y1))
  ?p2 <- (position (x ?x2) (y ?y2))
  (test (and (= ?x1 ?x2) (= ?y1 (+ ?y2 1))))
  =>
  (assert (adjacent (pos1 ?p1) (pos2 ?p2))))

(defrule check-adjacent-bottom-right
  ?p1 <- (position (x ?x1) (y ?y1))
  ?p2 <- (position (x ?x2) (y ?y2))
  (test (and (= ?x1 (+ ?x2 1)) (= ?y1 (+ ?y2 1))))
  =>
  (assert (adjacent (pos1 ?p1) (pos2 ?p2))))

(defrule find-flag
  ?p1 <- (position (x ?x1) (y ?y1))
  ?p2 <- (position (x ?x2) (y ?y2))
  ?probed1 <- (probed (pos ?p1)
                      (value ?v1))
  ?probed2 <- (probed (pos ?p2)
                      (value ?v2))
  ?adj1 <- (adjacent (pos1 ?p1) (pos2 ?p2))
  (test (>= ?v1 ?v2))
  =>
  (bind ?selisih (- ?v1 ?v2))
  (bind ?c 0)
  (bind ?list (create$))
  (loop-for-count (?posx1 (- ?x1 1) (+ ?x1 1))
    (loop-for-count (?posy1 (- ?y1 1) (+ ?y1 1))
      (if (not (and (= ?posx1 ?x1) (= ?posy1 ?y1)))
        then
        (bind ?unique TRUE)
        (loop-for-count (?posx2 (- ?x2 1) (+ ?x2 1))
          (loop-for-count (?posy2 (- ?y2 1) (+ ?y2 1))
            (if (not (and (= ?posx2 ?x2) (= ?posy2 ?y2)))
              then
              (if (and (= ?posx1 ?posx2) (= ?posy1 ?posy2))
                then
                (bind ?unique FALSE)))))
        (if (eq ?unique TRUE)
          then
          (bind ?c (+ ?c 1))
          (bind ?list (create$ ?list p1))))))
  (if (= ?selisih ?c)
    then
    (progn$ (?each ?list) (assert (move (pos ?each) (action flag))))))

(defrule find-probe
  ?p1 <- (position (x ?x) (y ?y))
  ?probed1 <- (probed (pos ?p1)
                      (value ?v1))
  =>
  (bind ?c 0)
  (bind ?list (create$))
  (loop-for-count (?posx (- ?x 1) (+ ?x 1))
    (loop-for-count (?posy (- ?y 1) (+ ?y 1))
      (bind ?c (+ ?c 1))
      (bind ?list (create$ ?list ?p1))))
  (if (= ?v1 ?c)
    then
    (progn$ (?each ?list) (assert (move (pos ?each) (action probe))))))