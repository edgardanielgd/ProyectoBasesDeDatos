/*
	Script de ejemplo usuario: Laboratorista
*/
USE mydb;

-- Seleccionar información sobre las muestras 
SELECT * FROM Muestra;

-- Intentar obtener información sobre los clientes
SELECT * FROM mydb.Cliente;

-- Intentar obtener información económica sobre los proyectos
SELECT * FROM mydb.Proyecto;

--  Seleccionar información sobre los estados de los EnsayosMuestra para un proyecto
SELECT * FROM mydb.vw_proyecto_perforacion_muestra_ensayomuestra;

-- Modificar la ubicación en bodega de una muestra de suelo dada
UPDATE mydb.Muestra
SET mue_ubicacionBodega = 'Pasillo 5'
WHERE mue_idMuestra = 1;
SELECT * FROM mydb.Muestra;  -- Ver el resultado de la consulta anterior