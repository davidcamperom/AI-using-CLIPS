(deffacts valores
    (vector 2 4 6 8 10 3)
)

(defrule Inicio
    (initial-fact)
    (vector $?x)
    =>
    (assert (vector-procesar $?x))
    (assert (suma 0))
)

(defrule suma
    ?h <- (vector-procesar $?y ?x $?g)
    ?s <- (suma ?f)
    =>
    (retract ?h)
    (retract ?s)
    (assert (vector-procesar $?y $?g))
    (assert (suma (+ ?f ?x)))
)

(defrule final
    ?vp <- (vector-procesar)
    (suma ?f)
    =>
    (retract ?vp)
    (printout t "El total es " ?f "." crlf)
)