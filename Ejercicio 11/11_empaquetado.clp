(deftemplate Articulo
    (field Nombre)
    (field Tipo)            ; Valores permitidos: fragil, pesado
    (field Forrado)         ; Valores permitidos Si - No
    (field Empaquetado)     ; Valores permitidos Si - No
    (field Dimension)       ; Valor numérico de 0 a 200
)

(deftemplate Caja
    (field IdCaja)
    (field Abierta)         
    (field Empezada)
    (field TipoContenido)
    (field EspacioLibre)
)

(defrule empaquetar
    ?art <- (Articulo (Nombre ?nombre) (Tipo ?t) (Forrado No) (Empaquetado No) (Dimension ?d))
    =>
    (retract ?art)
    (printout t "Se empaqueta el articulo " ?nombre "." crlf)
    (assert (Articulo (Nombre ?nombre) (Tipo ?t) (Forrado Si) (Empaquetado No) (Dimension ?d)))
)

(defrule empaquetado
    ?articulo <- (Articulo (Nombre ?name) (Tipo ?type) (Forrado Si) (Empaquetado No) (Dimension ?dim))
    ?caja <- (Caja (IdCaja ?id) (Abierta Si) (Empezada ?started) (TipoContenido ?type) (EspacioLibre ?slots))
    (test (< ?dim ?slots))
    =>
    (retract ?articulo ?caja)
    (bind ?slots (- ?slots ?dim))
    (assert (Articulo (Nombre ?name) (Tipo ?type) (Forrado Si) (Empaquetado Si) (Dimension ?dim)))
    (printout t "El articulo " ?name " ha sido introducido en la caja " ?id " y es de tipo " ?type "." crlf)
    (assert (Caja (IdCaja ?id) (Abierta Si) (Empezada Si) (TipoContenido ?type) (EspacioLibre ?slots)))
    (if (= ?slots 0)
    then (printout t "La caja " ?id " se ha llenado por completo." crlf))
)