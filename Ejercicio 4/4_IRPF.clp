;Template Persona

(deftemplate Persona
    (field Nombre)
    (field Edad)
    (field NombreConyuge)
    (field PosicionEconomica)
    (field Salario)
)

;Datos para el template

(deffacts Datos
    (Persona (Nombre David) (Edad 40) (NombreConyuge Alicia) (PosicionEconomica ahogada) (Salario 2500))
    (Persona (Nombre Clara) (Edad 40) (NombreConyuge Igor) (PosicionEconomica ahogada) (Salario 1400))
    (Persona (Nombre Fran) (Edad 40) (NombreConyuge Cristina) (PosicionEconomica ahogada) (Salario 1600))
    (Persona (Nombre Alicia) (Edad 60) (NombreConyuge David) (PosicionEconomica desahogada) (Salario 1200))
    (Persona (Nombre Igor) (Edad 60) (NombreConyuge Clara) (PosicionEconomica ahogada) (Salario 1800))
    (Persona (Nombre Cristina) (Edad 60) (NombreConyuge Fran) (PosicionEconomica desahogada) (Salario 1700))
)

;Regla A:
;Mostrar por pantalla los nombres de todas las personas de 60 años
(defrule Nombres_60
	(Persona (Nombre ?Nombre) (Edad 60))
	=>
	(printout t ?Nombre " tiene 60 ayos." crlf)
)

;Regla B
;Mostrar en pantalla el nombre y salario de las personas de 40 años
(defrule NombresSalario_40
	(Persona (Nombre ?Nombre) (Edad 40) (Salario ?Salario))
	=>
	(printout t ?Nombre " tiene 40 ayos y su salario es de " ?Salario " euros." crlf)
)

;Regla C
;Mostrar en pantalla los datos de todas las personas.
(defrule MostrarTodo
    (Persona (Nombre ?nombre) (Edad ?edad) (NombreConyuge ?nc) (PosicionEconomica ?economia) (Salario ?salario))
    =>
    (printout t ?nombre " tiene " ?edad " ayos, su pareja es " ?nc ", su posicion economica es " ?economia " y su salario es de " ?salario " euros." crlf)
)

;Regla D
;Mostrar en pantalla el nombre de aquellas personas cuyo cónyuge tenga una posición económica desahogada.
(defrule Conyuge_desahogado
    (Persona (NombreConyuge ?nc) (PosicionEconomica desahogada))
    (Persona (Nombre ?nombre))
    =>
    (printout t ?nombre ", su pareja esta en una posicion desahogada." crlf)
)

;Regla E
;Por cada persona cuyo cónyuge tenga una posición económica desahogada, añadir a la memoria de trabajo
;un vector ordenado de características de la forma (DatosFiscales <Nombre> ConyugeDesahogado)

(deftemplate DatosFiscales
    (field Nombre)
    (field Estado)
)

(defrule Conyuge_desahogado_DatosFiscales
    (Persona (Nombre ?nombre) (NombreConyuge ?nc))
    (Persona (Nombre ?nombre) (PosicionEconomica desahogada))
    =>
    (assert(DatosFiscales (Nombre ?nombre) (Estado ConyugeDesahogado)))
)

;Regla F
;Borrar de la memoria de trabajo aquellas personas que tengan un cónyuge con una posicion economica
;desahogada. Recomendación: Use los hechos (DatosFiscales) del apartado anterior.
(defrule EliminarConyugeDesahogado
    (DatosFiscales (Nombre ?nombre))
    ?Persona <- (Persona (Nombre ?nombre))
    =>
    (retract ?Persona)
)

;Regla G
;Borrar de la memoria de trabajo aquellas personas que tengan una posición económica desahogada.
(defrule EliminarDesahogados
    ?Persona <- (Persona (PosicionEconomica desahogada))
    =>
    (retract ?Persona)
)