/*
	Script de ejemplo usuario: Jefe de laboratorio
*/
USE mydb;

-- Intentar obtener información sobre los clientes
SELECT * FROM mydb.Cliente;

-- Intentar obtener información económica sobre los proyectos
SELECT * FROM mydb.Proyecto;

-- Modificar las observaciones de un informe final
UPDATE mydb.vw_informeFinal_vs_Proyecto
SET inf_observacionesInforme = 'UCI covid 19'
WHERE pro_nombreProyecto = 'Contrato de interventoría No. 481 de 2017';
SELECT * FROM mydb.informeFinal;