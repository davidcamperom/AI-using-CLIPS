(deftemplate Pais
	(field Nombre)
	(multifield Bandera)
)

(defrule colorbandera
	?h <- (fase color)
    =>
	(retract ?h)
	(printout t "Introduzca el color 1: ")
	(assert (color (read)) (fase otro_color))
)

(defrule otro_color
	?h <- (fase otro_color)
    =>
	(retract ?h)
	(printout t "Introduzca el color 2: ")
	(assert (color (read)) (fase dos_colores))
	(printout t crlf)
	(printout t "---------- BANDERAS CON LOS COLORES INTRODUCIDOS ----------- " crlf)
	(printout t crlf)
)

(defrule banderas_colores
	(Pais (Nombre ?x))
	(forall (color ?y) (Pais (Nombre ?x) (Bandera $? ?y $?)))
=>
	(printout t ?x crlf)
)