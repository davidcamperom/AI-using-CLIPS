;Plantillas para la elaboracion de la practica

(deftemplate Enfermedad
	(field NombreEnfermedad)
	(multifield Sintomas)
	(multifield Medicamentos)
	(multifield Doctores)
)

(deftemplate Doctor
	(field Tipo)
	(multifield Tratamientos)
)

(deftemplate Posibles_Enfermedades
	(field Nombre)
	(multifield Sintomas_detectados)
	(multifield Sintomas_posibles)
	(field Mostrar)
)

;Sistema e introducir datos

(defrule inicio
	?i <- (inicio)
	=>
	(retract ?i)
	(printout t crlf)
	(printout t "********************************************************************" crlf)
	(printout t "         Sistema Experto Medico (alumno: David Campero Maña)        " crlf)
	(printout t "         Bienvenido al programa de diagnostico        " crlf)
	(printout t "********************************************************************" crlf)
	(printout t crlf)
	(assert (Sintomas_paciente))
)

(defrule meter_sintomas
	?sp <- (Sintomas_paciente)
	(not(diagnosticado))
	=>
	(retract ?sp)
	(printout t "A continuacion, introduzca los sintomas, de uno en uno, para realizar el diagnostico." crlf)
	(printout t "Una vez introducido los sintomas, escriba 'fin'" crlf)
	(printout t crlf)
	(printout t "Introduzca el primer sintoma: ")
	(assert (Sintomas (read)))
	(assert (pedir_sintoma))
)

(defrule Seguir_pidiendo_Sintomas
	?ps <- (pedir_sintoma)
	(not (Sintomas fin))
	=>
	(retract ?ps)
	(assert (pedir_sintoma2))
)

(defrule Seguir_pidiendo_Sintomas2
	?ps2 <- (pedir_sintoma2)
	(not (diagnosticado))
	=>
	(retract ?ps2)
	(printout t "Introduzca el siguiente sintoma: ")
	(assert (Sintomas (read)))
	(assert (pedir_sintoma))
)

(defrule dejar_pedir_sintomas
	?f <- (Sintomas fin)
	=>
	(retract ?f)
	(printout t crlf)
	(printout t "--------------------------------------------------------------------------" crlf)
	(printout t "         Ha finalizado la introduccion de sintomas en el sistema" crlf)
	(printout t "--------------------------------------------------------------------------" crlf)
	(printout t crlf)
	(printout t "----------------------------- DIAGNOSTICOS -------------------------------" crlf)
	(printout t crlf)
	(assert (diagnosticado))
)


;Agrupacion de los sintomas de las enfermedades
(defrule Enfermedades_Doctores
	(diagnosticado)
	(forall (Enfermedad)(Doctor))
	?variable <- (Enfermedad(NombreEnfermedad ?nombre) (Sintomas $?s) (Medicamentos $?a ?m $?b) (Doctores $?d))
	(Doctor (Tipo ?t) (Tratamientos $?u ?m $?k))
	(test(eq(member$ ?t $?d) FALSE))
	=>
	(retract ?variable)
	(assert (Enfermedad(NombreEnfermedad ?nombre)(Sintomas $?s)(Medicamentos $?a ?m $?b) (Doctores $?d ?t)))
	(assert (almacenar))
)

(defrule agrupacion_sintomas
	(diagnosticado)
	?cs <- (Conjunto_Sintomas $?t)
	?s <- (Sintomas ?x)
	=>
	(retract ?cs ?s)
	(assert(Conjunto_Sintomas $?t ?x))
)

(defrule seguir_agrupando
	(diagnosticado)
	(not(Sintomas ?x))
	=>
	(assert(sintomas_agrupados))
)

(defrule almacenar_posibles_enfermedades
	(almacenar)
	(diagnosticado)
	(sintomas_agrupados)
	(Conjunto_Sintomas $?x)
	(Enfermedad (NombreEnfermedad ?nombre)(Sintomas $?y)(Medicamentos $?m))
	(test(subsetp $?x $?y))
	=>
	(assert(Posibles_Enfermedades (Nombre ?nombre)(Sintomas_detectados $?x)(Sintomas_posibles $?y)))
	(assert(preparado))
)

(defrule posibles_sintomas
	?p <- (preparado)
	?variable <- (Posibles_Enfermedades(Nombre ?nombre)(Sintomas_detectados $?a ?x $?b)(Sintomas_posibles $?c ?y $?d))
	(test(eq(str-compare ?x ?y) 0))
	=>
	(retract ?p ?variable)
	(assert(Posibles_Enfermedades(Nombre ?nombre)(Sintomas_detectados $?a ?x $?b)(Sintomas_posibles $?c $?d)(Mostrar No)))
	(assert(preparado))
)

(defrule mostrar_diagnosticofinal
	(preparado)
	?pe <- (Posibles_Enfermedades(Nombre ?nombre) (Sintomas_detectados $?x)(Sintomas_posibles $?y)(Mostrar No))
	(Enfermedad(NombreEnfermedad ?nombre)(Medicamentos $?m)(Doctores $?d))
	(forall (Enfermedad)(Posibles_Enfermedades))
	=>
	(retract ?pe)
	(assert(Posibles_Enfermedades (Nombre ?nombre)(Sintomas_detectados $?x) (Sintomas_posibles $?y) (Mostrar Si)))
	(printout t "El paciente podria tener " ?nombre "." crlf)
	(printout t "El paciente presenta los siguientes sintomas: " (implode$ ?x) "." crlf)
	(printout t "Ademas, podria tener los siguientes sintomas: " (implode$ ?y) "." crlf)
	(printout t "Los medicamentos para tratar la enfermedad son: " (implode$ ?m) "." crlf)
	(printout t "Puede ser tratado por " (implode$ ?d) crlf)
	(printout t crlf)
)