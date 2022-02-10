;Como son muchos templates, los declaro al principio de fichero

;Regla A
(deftemplate FichaPaciente
    (field Nombre)
    (field Edad)
    (field Casado)
    (field Sexo)
    (field Peso)
)

(deftemplate DatosExploracion
    (field Nombre)
    (multifield Sintomas)
    (field GravedadAfeccion)
)

;Regla B
(deftemplate Diagnostico
    (field Nombre)
    (field Resultado)
    (field ProximaRevision)
)

;Regla C
(deftemplate Paciente
    (field Nombre)
    (field Tipo)
)

;Regla D
(deftemplate Terapia
    (field Nombre)
    (field PrincipioActivo)
    (field Posologia)
)


;Regla A
;Añada una regla para el siguiente diagnóstico: Si un paciente tiene los síntomas picor y vesículas,
;entonces mostrar un mensaje diciendo que tiene un eccema.
(defrule Paciente_Eccema
    (DatosExploracion (Nombre ?nombrePaciente) (Sintomas $? picor $? vesiculas inflamadas))
    (FichaPaciente (Nombre ?nombrePaciente))
    =>
    (printout t "El paciente " ?nombrePaciente " tiene un eccema." crlf)
)

;Regla B
;Modifique el anterior programa para que, en vez de mostrar el resultado del diagnóstico, 
;añada un hecho con el diagnóstico correspondiente. Añada, además, otra regla que se activará cuando
;exista un diagnóstico y muestre el correspondiente mensaje en pantalla
(defrule Guardar_Diagnostico
    (DatosExploracion (Nombre ?nombrePaciente) (Sintomas $?) (GravedadAfeccion ?gravedad))
    (FichaPaciente (Nombre ?nombrePaciente))
    =>
    (assert(Diagnostico (Nombre ?nombrePaciente) (Resultado ?gravedad) (ProximaRevision proximamente)))
)

(defrule Mostrar_Diagnostico
    (Diagnostico (Nombre ?nombrePaciente))
    (FichaPaciente (Nombre ?nombrePaciente))
    =>
    (printout t "El paciente " ?nombrePaciente " tiene un diagnostico guardado." crlf)
)

;Regla C
;Añada una regla que añada un vector ordenado del tipo (Paciente Juan Es_un_bebe) cuando un paciente
;tenga una edad menor a dos años. 
(defrule Vector_Bebes
    (FichaPaciente (Nombre ?nombre) (Edad ?edad))
    =>
    (if (< ?edad 2)
        then
        (assert(Paciente (Nombre ?nombre) (Tipo Bebe)))
        else
        (assert(Paciente (Nombre ?nombre) (Tipo Adulto)))
    )
)

; Regla D y E (Ya que uno nos sugiere la terapia y el otro nos muestra la cual administrar)
(defrule Diagnosticar_Terapia
    (DatosExploracion (Nombre ?nombre) (GravedadAfeccion ?gravedad))
    (Paciente (Nombre ?nombre) (Tipo ?paciente))
    =>
    (if (eq (str-compare ?paciente "Bebe") 0)
        then
        (if (eq (str-compare ?gravedad "Grave") 0)
            then
            (assert(Terapia (Nombre ?nombre) (PrincipioActivo corticoides) (Posologia alta)))
            (printout t "Para el paciente " ?nombre " seria recomendable usar corticoides." crlf)
            else
            (assert(Terapia (Nombre ?nombre) (PrincipioActivo crema_hidratante) (Posologia baja)))
            (printout t "Para el paciente " ?nombre " seria recomendable usar crema_hidratante." crlf))
        else
        (assert(Terapia (Nombre ?nombre) (PrincipioActivo corticoides) (Posologia normal)))
        (printout t "Para el paciente " ?nombre " seria recomendable usar corticoides." crlf)
    )
)