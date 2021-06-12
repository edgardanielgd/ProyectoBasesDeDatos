-----   Índice proyecto ---------
CREATE INDEX idx_nombre_proyecto
ON proyecto(pro_nombreProyecto);

-----   Índice perforacion ---------
CREATE INDEX idx_nombre_perforacion
ON perforacion(nombrePerforacion);

-----   Índice muestra ---------
CREATE INDEX idx_numero_muestra
ON muestra(mue_numeroMuestra);

-----   Índice muestra ---------
CREATE INDEX idx_ruta_archivo_individual
ON archivoResultado(ens_rutaArchivo);