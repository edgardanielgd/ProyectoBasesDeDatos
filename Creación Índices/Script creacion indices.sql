/*Los proyectos se suelen buscar por su nombre, por eso se crea el índice*/
-----   Índice proyecto ---------
CREATE INDEX idx_nombre_proyecto
ON proyecto(pro_nombreProyecto);

/* Se crean los índices idx_nombre_perforacion y idx_numero_muestra porque estos dos valores definen cada muestra de suelo
y se deben ser consultadas constantemente */

-----   Índice perforacion ---------
CREATE INDEX idx_nombre_perforacion
ON perforacion(per_nombrePerforacion);

-----   Índice muestra ---------
CREATE INDEX idx_numero_muestra
ON muestra(mue_numeroMuestra);

/*Se crea un índice aquí porque hay muchos archivos resultado y 
estos necesitan ser constantemente consultados para analizar sus
datos*/

-----   Índice muestra ---------
CREATE INDEX idx_ruta_archivo_individual
ON archivoResultado(ens_rutaArchivo);

/* Adicionalmente se crearon índices en las llaves foráneas de las tablas del proyecto */