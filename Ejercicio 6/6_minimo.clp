(deffacts valores
    (vector 2 4 6 8 10 3)
)

(defrule valor_minimo
    (vector $? ?x $?)
    (not (vector $? ?y&:(< ?y ?x) $?))
    =>
    (printout t "El minimo es " ?x crlf)
)