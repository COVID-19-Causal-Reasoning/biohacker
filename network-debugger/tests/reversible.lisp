;; biohacker/trunk/network-debugger/tests/reversible.lisp

(network-debugger reversible :debugging t :rules :extended-reactions)

;; Network
(reaction 
 r1 
 :reactants (c g)
 :products (a b)
 :enzymes (e1))

(reaction 
 r2
 :reactants (b c)
 :products (d)
 :enzymes (e2))

(reaction 
 r3
 :reactants (d g)
 :products (e)
 :enzymes (e3))

(reaction 
 r4
 :reactants (e)
 :products (b f)
 :enzymes (g4))

(enzyme e1 g1)
(enzyme e2 g2)
(enzyme e3 g3 g3p)
(enzyme e4 g4)

;; Experiments
(experiment
 growth-if-r1-reversible
 (a b)
 :growth? t
 :essential-compounds (a e)
 :knock-outs (g4))

(experiment
 no-growth-if-r4-not-reversible
 (a b f)
 :growth? nil
 :essential-compounds (a e)
 :knock-outs (g1))

(summarize-findings)

#|
Network Debugger REVERSIBLE
Adding reaction R1.
Adding reaction R2.
Adding reaction R3.
Adding reaction R4.
Adding enzyme E1.
Adding enzyme E2.
Adding enzyme E3.
Adding enzyme E4.
Closing network for EXPERIMENT.
Adding experiment GROWTH-IF-R1-REVERSIBLE
Assuming simplify-investigations.
Assuming unknown genes and reaction reversibilities as convenient.
Focusing on experiment GROWTH-IF-R1-REVERSIBLE.
Experiment GROWTH-IF-R1-REVERSIBLE is consistent with model.
Adding experiment NO-GROWTH-IF-R4-NOT-REVERSIBLE
Retracting focus on experiment GROWTH-IF-R1-REVERSIBLE.
Focusing on experiment NO-GROWTH-IF-R4-NOT-REVERSIBLE.
Experiment NO-GROWTH-IF-R4-NOT-REVERSIBLE is consistent with model.
1 positive findings: (GROWTH-IF-R1-REVERSIBLE)
1 negative findings: (NO-GROWTH-IF-R4-NOT-REVERSIBLE)
0 false-negative findings: NIL
0 false-positive findings: NIL
|#

#|
(explain 'growth)

  1 (FOCUS-EXPERIMENT GROWTH-IF-R1-REVERSIBLE) ()   Assumption
  2    (NUTRIENT A)               (1)  (:OR (NUTRIENT A) (:NOT (FOCUS-EXPERIMENT GROWTH-IF-R1-REVERSIBLE)))
  3 (COMPOUND-PRESENT A)          (2)  (:OR (COMPOUND-PRESENT A) (:NOT (NUTRIENT A)))
  4 ASSUME-UNKNOWNS-AS-CONVENIENT  ()   Assumption
  5 EXPERIMENT-GROWTH             (1)  (:OR EXPERIMENT-GROWTH (:NOT (FOCUS-EXPERIMENT GROWTH-IF-R1-REVERSIBLE)))
  6 (REACTION-REVERSIBLE R1)    (4 5)  (:OR (:NOT EXPERIMENT-GROWTH) (:NOT ASSUME-UNKNOWNS-AS-CONVENIENT) (REACTION-REVERSIBLE R1))
  7 SIMPLIFY-INVESTIGATIONS        ()   Assumption
  8    (GENE-ON G1)             (7 1)  (:OR (GENE-ON G1) (:NOT (FOCUS-EXPERIMENT GROWTH-IF-R1-REVERSIBLE)) (:NOT SIMPLIFY-INVESTIGATIONS))
  9 (:NOT (UNKNOWN-GENE-FOR E1))  NIL  (:OR (:NOT (UNKNOWN-GENE-FOR E1)))
 10 (ENZYME-PRESENT E1)         (8 9)  (:OR (UNKNOWN-GENE-FOR E1) (:NOT (GENE-ON G1)) (ENZYME-PRESENT E1))
 11 (REACTION-ENABLED R1)        (10)  (:OR (:NOT (ENZYME-PRESENT E1)) (REACTION-ENABLED R1))
 12    (NUTRIENT B)               (1)  (:OR (NUTRIENT B) (:NOT (FOCUS-EXPERIMENT GROWTH-IF-R1-REVERSIBLE)))
 13 (COMPOUND-PRESENT B)         (12)  (:OR (COMPOUND-PRESENT B) (:NOT (NUTRIENT B)))
 14 (COMPOUND-PRESENT G)  (6 3 11 13)  (:OR (:NOT (COMPOUND-PRESENT B)) (COMPOUND-PRESENT G) (:NOT (REACTION-ENABLED R1)) (:NOT (COMPOUND-PRESENT A)) (:NOT (REACTION-REVERSIBLE R1)))
 15 (COMPOUND-PRESENT C)  (6 3 11 13)  (:OR (:NOT (COMPOUND-PRESENT B)) (COMPOUND-PRESENT C) (:NOT (REACTION-ENABLED R1)) (:NOT (COMPOUND-PRESENT A)) (:NOT (REACTION-REVERSIBLE R1)))
 16    (GENE-ON G2)             (7 1)  (:OR (GENE-ON G2) (:NOT (FOCUS-EXPERIMENT GROWTH-IF-R1-REVERSIBLE)) (:NOT SIMPLIFY-INVESTIGATIONS))
 17 (:NOT (UNKNOWN-GENE-FOR E2))             NIL  (:OR (:NOT (UNKNOWN-GENE-FOR E2)))
 18 (ENZYME-PRESENT E2)       (16 17)  (:OR (UNKNOWN-GENE-FOR E2) (:NOT (GENE-ON G2)) (ENZYME-PRESENT E2))
 19 (REACTION-ENABLED R2)        (18)  (:OR (:NOT (ENZYME-PRESENT E2)) (REACTION-ENABLED R2))
 20 (COMPOUND-PRESENT D)   (15 19 13)  (:OR (:NOT (COMPOUND-PRESENT B)) (COMPOUND-PRESENT D) (:NOT (REACTION-ENABLED R2)) (:NOT (COMPOUND-PRESENT C)))
 21   (GENE-ON G3P)             (7 1)  (:OR (GENE-ON G3P) (:NOT (FOCUS-EXPERIMENT GROWTH-IF-R1-REVERSIBLE)) (:NOT SIMPLIFY-INVESTIGATIONS))
 22    (GENE-ON G3)             (7 1)  (:OR (GENE-ON G3) (:NOT (FOCUS-EXPERIMENT GROWTH-IF-R1-REVERSIBLE)) (:NOT SIMPLIFY-INVESTIGATIONS))
 23 (:NOT (UNKNOWN-GENE-FOR E3))             NIL  (:OR (:NOT (UNKNOWN-GENE-FOR E3)))
 24 (ENZYME-PRESENT E3)    (21 22 23)  (:OR (UNKNOWN-GENE-FOR E3) (:NOT (GENE-ON G3)) (:NOT (GENE-ON G3P)) (ENZYME-PRESENT E3))
 25 (REACTION-ENABLED R3)        (24)  (:OR (:NOT (ENZYME-PRESENT E3)) (REACTION-ENABLED R3))
 26 (COMPOUND-PRESENT E)   (14 20 25)  (:OR (COMPOUND-PRESENT E) (:NOT (REACTION-ENABLED R3)) (:NOT (COMPOUND-PRESENT D)) (:NOT (COMPOUND-PRESENT G)))
 27          GROWTH          (1 3 26)  (:OR (:NOT (COMPOUND-PRESENT E)) (:NOT (COMPOUND-PRESENT A)) (:NOT (FOCUS-EXPERIMENT GROWTH-IF-R1-REVERSIBLE)) GROWTH)

  1 (FOCUS-EXPERIMENT NO-GROWTH-IF-R4-NOT-REVERSIBLE) ()   Assumption
  2 SIMPLIFY-INVESTIGATIONS             ()   Assumption
  3 (:NOT (NUTRIENT E))              (1 2)  (:OR (:NOT (NUTRIENT E)) (:NOT SIMPLIFY-INVESTIGATIONS) (:NOT (FOCUS-EXPERIMENT NO-GROWTH-IF-R4-NOT-REVERSIBLE)))
  4 (:NOT (NUTRIENT G))              (1 2)  (:OR (:NOT (NUTRIENT G)) (:NOT SIMPLIFY-INVESTIGATIONS) (:NOT (FOCUS-EXPERIMENT NO-GROWTH-IF-R4-NOT-REVERSIBLE)))
  5 (:NOT EXPERIMENT-GROWTH)           (1)  (:OR (:NOT EXPERIMENT-GROWTH) (:NOT (FOCUS-EXPERIMENT NO-GROWTH-IF-R4-NOT-REVERSIBLE)))
  6 (:NOT (GENE-ON G1))                (1)  (:OR (:NOT (GENE-ON G1)) (:NOT (FOCUS-EXPERIMENT NO-GROWTH-IF-R4-NOT-REVERSIBLE)))
  7 (:NOT (ENZYME-PRESENT E1))         (6)  (:OR (GENE-ON G1) (:NOT (ENZYME-PRESENT E1)))
  8 (:NOT (REACTION-ENABLED R1))     (5 7)  (:OR (ENZYME-PRESENT E1) EXPERIMENT-GROWTH (:NOT (REACTION-ENABLED R1)))
  9 (:NOT (REVERSE-REACTION-FIRED R1)) (8)  (:OR (REACTION-ENABLED R1) (:NOT (REVERSE-REACTION-FIRED R1)))
 10 ASSUME-UNKNOWNS-AS-CONVENIENT       ()   Assumption
 11 (:NOT (REACTION-REVERSIBLE R3)) (10 5)  (:OR EXPERIMENT-GROWTH (:NOT ASSUME-UNKNOWNS-AS-CONVENIENT) (:NOT (REACTION-REVERSIBLE R3)))
 12 (:NOT (REVERSE-REACTION-FIRED R3))            (11)  (:OR (REACTION-REVERSIBLE R3) (:NOT (REVERSE-REACTION-FIRED R3)))
 13 (:NOT (COMPOUND-PRESENT G))   (4 9 12)  (:OR (:NOT (COMPOUND-PRESENT G)) (REVERSE-REACTION-FIRED R3) (REVERSE-REACTION-FIRED R1) (NUTRIENT G))
 14 (:NOT (REACTION-FIRED R3))        (13)  (:OR (COMPOUND-PRESENT G) (:NOT (REACTION-FIRED R3)))
 15 (:NOT (REACTION-REVERSIBLE R4)) (10 5)  (:OR EXPERIMENT-GROWTH (:NOT (REACTION-REVERSIBLE R4)) (:NOT ASSUME-UNKNOWNS-AS-CONVENIENT))
 16 (:NOT (REVERSE-REACTION-FIRED R4))(15)  (:OR (REACTION-REVERSIBLE R4) (:NOT (REVERSE-REACTION-FIRED R4)))
 17 (:NOT (COMPOUND-PRESENT E))  (3 14 16)  (:OR (:NOT (COMPOUND-PRESENT E)) (REVERSE-REACTION-FIRED R4) (REACTION-FIRED R3) (NUTRIENT E))
 18   (:NOT GROWTH)                 (1 17)  (:OR (COMPOUND-PRESENT E) (:NOT GROWTH) (:NOT (FOCUS-EXPERIMENT NO-GROWTH-IF-R4-NOT-REVERSIBLE)))

|#