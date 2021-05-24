/*
	Script de ejemplo usuario: Administrador
*/
USE mydb;

-- Obtener información sobre los clientes
SELECT * FROM mydb.Cliente;

-- Obtener información económica sobre los proyectos
SELECT * FROM mydb.Proyecto;

-- Obtener el nombre de los proyectos firmados por el cliente'Idiger'
SELECT * FROM mydb.vw_cliente_vs_proyecto
WHERE cli_razonSocial = 'Idiger';

-- Modifica un atributo de un EnsayoMuestra para el ensayo con id=5
UPDATE mydb.EnsayoMuestra
SET ens_hayResiduo = 0 
WHERE ens_idEnsayoMuestra = 5;
SELECT * FROM mydb.EnsayoMuestra;