;;; sepertinya butuh constant size berapa, bomb berapa
;;; dari python deffact bomb
;;; dari python juga defglobal MAIN ?*size* = brp

;;; TYPE DEFINITION
(defclass POSITION (is-a USER)
  (pattern-match reactive)
  (slot x (type INTEGER) (range 0 ?VARIABLE)
    (create-accessor read))
  (slot y (type INTEGER) (range 0 ?VARIABLE)
    (create-accessor read)) )

;;; to create instance:
(definstances Pos
(p1 of POSITION (x 1) (y 2))
(p2 of POSITION (x 3) (y 4)))

;;; to match pattern / define rule:
(defrule print-at-position
     (object (is-a POSITION) (x ?x) (y ?y)
     =>
     (printout t crlf "At position " ?x ?y)))

;;; TEMPLATE DEFINITIONS
(deftemplate flagged 
  (slot pos))

(deftemplate probed
	(slot pos)
	(slot value (type INTEGER) (range 1 ?VARIABLE)))

(deftemplate adjacent
  (slot pos1)
  (slot pos2))

(deftemplate move
  (slot pos)
  (slot action (type SYMBOL) (allowed-values flag probe)))

(deftemplate bomb-probability
  (multislot pos)
  (slot bomb-count (type INTEGER) range 0 ?VARIABLE))



;;; assert atribut yang intersect ya

;;; deffunction complement

;;; RULE DEFINITIONS
;;; Mengecek apakah ada kotak sekitar yang pasti bom
(defrule flag	
	?node <- (state (x ?center-x)
                  (y ?center-y)
                  (value ?val))
  
  =>
  (assert move (x ?flag-x) (y ?flag-y) (action flag))

;;; Mengecek apakah ada kotak sekitar yang pasti aman
(defrule probe	
	?node <- (state (x ?center-x)
                  (y ?center-y)
                  (value ?val))

  =>
  (assert move (x ?flag-x) (y ?flag-y) (action probe))

;;; TODO: STOP CONDITION



;;; Mendefinisikan kotak-kotak yang bersebelahan
(defrule check-adjacent-top-left
  (p1 (is-a POSITION) (x1 ?x) (y1 ?y))
  (p2 (is-a POSITION) (x2 ?x) (x2 ?y))
  (test (and (= x1 x2-1) (= y1 y2-1)))
  =>
  (assert (adjacent (pos1 p1) (pos2 p2))))

(defrule check-adjacent-top
  (p1 (is-a POSITION) (x1 ?x) (y1 ?y))
  (p2 (is-a POSITION) (x2 ?x) (x2 ?y))
  (test (and (= x1 x2) (= y1 y2-1)))
  =>
  (assert (adjacent (pos1 p1) (pos2 p2))))
  
(defrule check-adjacent-top-right
  (p1 (is-a POSITION) (x1 ?x) (y1 ?y))
  (p2 (is-a POSITION) (x2 ?x) (x2 ?y))
  (test (and (= x1 x2+1) (= y1 y2-1)))
  =>
  (assert (adjacent (pos1 p1) (pos2 p2))))

(defrule check-adjacent-left
  (p1 (is-a POSITION) (x1 ?x) (y1 ?y))
  (p2 (is-a POSITION) (x2 ?x) (x2 ?y))
  (test (and (= x1 x2-1) (= y1 y2)))
  =>
  (assert (adjacent (pos1 p1) (pos2 p2))))

(defrule check-adjacent-right
  (p1 (is-a POSITION) (x1 ?x) (y1 ?y))
  (p2 (is-a POSITION) (x2 ?x) (x2 ?y))
  (test (and (= x1 x2+1) (= y1 y2)))
  =>
  (assert (adjacent (pos1 p1) (pos2 p2))))

(defrule check-adjacent-bottom-left
  (p1 (is-a POSITION) (x1 ?x) (y1 ?y))
  (p2 (is-a POSITION) (x2 ?x) (x2 ?y))
  (test (and (= x1 x2-1) (= y1 y2+1)))
  =>
  (assert (adjacent (pos1 p1) (pos2 p2))))

(defrule check-adjacent-bottom
  (p1 (is-a POSITION) (x1 ?x) (y1 ?y))
  (p2 (is-a POSITION) (x2 ?x) (x2 ?y))
  (test (and (= x1 x2) (= y1 y2+1)))
  =>
  (assert (adjacent (pos1 p1) (pos2 p2))))

(defrule check-adjacent-bottom-right
  (p1 (x1 ?x) (y1 ?y))
  (p2 (x2 ?x) (x2 ?y))
  (test (and (= x1 x2+1) (= y1 y2+1)))
  =>
  (assert (adjacent (pos1 p1) (pos2 p2))))

;;; DRAFT
(defrule check-adjacent-bottom-right
  (object (is-a POSITION)
          (x ?x1)
          (y ?y1))
  (object (is-a POSITION) 
          (x ?x2)
          (y ?y2))
  (test (and (= x1 (+ x2 1)) (= y1 (+ y2 1))))
  =>
  (assert (adjacent (pos1 p1) (pos2 p2))))
  ;;; error: katanya x1 bukan integer :(


(defrule find-flag
  (bind ?p1 (instance-name (object (is-a POSITION) (x ?x1) (y ?y1))))
  (bind ?p2 (object (is-a POSITION) (x ?x2) (x ?y2)))
  (adjacent p1 p2)
  (?probe1 <- (probed (pos p1)
                      (value ?v1)))
  (?probe2 <- (probed (pos p2)
                      (value ?v2)))
  (test (> ?v1 ?v2))
  =>
  (bind ?selisih (- ?v1 ?v2))
  (bind ?c 0)
  (bind ?list (create$))
  (loop-for-count (?posx1 (x1-1) (x1+1))
    (loop-for-count (?posy1 (y1-1) (y1+1))
      (if (not (and (= ?posx1 x1) (= ?posy1 y1)))
        then
        (bind ?unique TRUE)
        (loop-for-count (?posx2 (x2-1) (x2+1))
          (loop-for-count (?posy2 (y2-1) (y2+1))
            (if (not (and (= ?posx2 x2) (= ?posy2 y2)))
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
    (progn$ (?each ?list) (assert (flagged (pos ?each))))))




;;; ada 2 position (?) syaratnya: dua"nya sebelahan, dua"nya 
;;; udah kebuka, angkanya > 0 (adjacent, probed, test)
;;; cek mana yg value nya lebih gede -> P1, lebih kecil -> P2
;;; selisih = P1.value - P2.value (bind)
;;; set c = 0 (bind)
;;; set list = [] // bingung disini gimana caranya (create$)
;;; list = (create$ 1 2 3)   (create$ ?list 4) (delete$ ?list 3)
;;; loop x1 (P1.x-1 to P1.x+1) dan y1 (P1.y-1 to P1.y+1) kecuali posisi P1 sendiri
;;;   set unique = TRUE
;;;   loop x2(P2.x-1 to P2.x+1) dan y2(P2.y-1 to P2.y+1) kecuali posisi P2 sendiri
;;;     if x1 == x2 & y1 == y2:
;;;       unique = FALSE
;;;   if unique == TRUE:
;;;     c += 1
;;;     list.append(P1.x, P1.y) // 
;;; if c == selisih
;;;   assert P1 flag
;;; 
;;; 
;;; 
;;; 
;;; 
;;; 
