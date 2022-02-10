(deffacts Enfermedades_Sintomas_Doctores
	(Enfermedad(NombreEnfermedad Gripe) (Sintomas Tos Cansancio Fiebre Dolor) (Medicamentos Jarabe Contrex Vacuna))
	(Enfermedad(NombreEnfermedad Rubeola) (Sintomas Fiebre Escalofrios Jaqueca Secrecion) (Medicamentos Vacuna Pastilla))
	(Enfermedad(NombreEnfermedad Malaria) (Sintomas Diarrea Fiebre Ictericia Escalofrios) (Medicamentos Vacuna))
	(Enfermedad(NombreEnfermedad Hepatitis) (Sintomas Diarrea Nauseas Ictericia) (Medicamentos Vacuna Pastilla))
	(Enfermedad(NombreEnfermedad Turbeculosis) (Sintomas Tos Cansancio Fiebre) (Medicamentos Pastilla))
	(Enfermedad(NombreEnfermedad Anemia) (Sintomas Cansancio Nauseas Apatia) (Medicamentos Vitamina))
	
	(Doctor(Tipo Otorrino) (Tratamientos Jarabe Contrex))
	(Doctor(Tipo Endocrinologo) (Tratamientos Vacuna))
	(Doctor(Tipo Nutricionista) (Tratamientos Vitamina))
	(Doctor(Tipo Medico_Cabecera) (Tratamientos Vacuna Pastilla))
	
	(Conjunto_Sintomas)
	(inicio)
)