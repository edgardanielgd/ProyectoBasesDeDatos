  -- Nombres de proyecto para un cliente con nombre
use mydb;
SELECT pro_nombreProyecto AS NombreProyecto 
FROM Proyecto JOIN 
(SELECT cli_NIT FROM cliente WHERE cli_razonSocial="Idiger")
AS clien 
USING (cli_NIT);

-- Lista de ensayos que faltan por realizar en un proyecto dado por su ID
SELECT per_nombrePerforacion, mue_numeroMuestra, mue_profundidad, tip_nombreTipoEnsayo FROM Proyecto
NATURAL JOIN perforacion NATURAL JOIN muestra NATURAL JOIN EnsayoMuestra NATURAL JOIN TipoEnsayo
WHERE Proyecto.pro_idProyecto = 4 AND ens_estado = 1;  -- ens_estado = 1 -> pendiente

-- Lista de ensayos que ya se realizaron, junto con su ejecutor y fecha
SELECT per_nombrePerforacion, mue_numeroMuestra, mue_profundidad, tip_nombreTipoEnsayo, emp_nombreEmpleado, ens_fechaEnsayoMuestra FROM Proyecto
NATURAL JOIN perforacion NATURAL JOIN muestra NATURAL JOIN EnsayoMuestra NATURAL JOIN TipoEnsayo NATURAL JOIN Empleado
WHERE Proyecto.pro_idProyecto = 4 AND ens_estado = 3;  -- ens_estado = 3 -> realizado

-- Abono y saldo por pagar para un proyecto dado su ID proyecto
SELECT cli_razonSocial, pro_nombreProyecto, esp_valorAbonado, esp_fechaAbono, (pro_valorTotal - esp_valorAbonado) AS saldoPorPagar
FROM cliente NATURAL JOIN Proyecto NATURAL JOIN EstadoPago WHERE pro_idProyecto = 3;

-- Nombres de tipo de ensayo para un proyecto con ID
SELECT DISTINCT tip_nombreTipoEnsayo AS TipoEnsayo
FROM tipoensayo
JOIN ensayomuestra USING(tip_idTipoEnsayo)
JOIN muestra USING(mue_idMuestra)
JOIN (
	SELECT per_idPerforacion FROM perforacion
    WHERE pro_idProyecto=5
) AS perforacion USING (per_idPerforacion);

-- -- Nombres de tipo de ensayo para una muestra con ID
SELECT DISTINCT tip_nombreTipoEnsayo AS TipoEnsayo
FROM tipoensayo
JOIN (
	SELECT tip_idTipoEnsayo FROM ensayomuestra
    WHERE mue_idMuestra=5
) AS tipoensayo USING (tip_idTipoEnsayo);

-- -- Nombres de tipo de ensayo para una muestra y ejecutores con ID de muestra
SELECT DISTINCT tip_nombreTipoEnsayo AS TipoEnsayo,emp_nombreEmpleado AS Nombre,emp_apellidoEmpleado AS Apellido
FROM (tipoensayo
JOIN (
	SELECT tip_idTipoEnsayo,emp_idEmpleado FROM ensayomuestra
    WHERE mue_idMuestra=5
) AS t1 USING (tip_idTipoEnsayo))
JOIN empleado USING (emp_idEmpleado);

-- Nombres de proyectos cuyos informes aun no entregados (Cuyos proyectos no han sido pagados)
SELECT pro_nombreProyecto AS Nombre
FROM Proyecto
JOIN (
	SELECT pro_idProyecto FROM informefinal
    WHERE inf_fechaRemisionInforme=NULL
)AS t2 USING (pro_idProyecto);

-- Quién hace un ensayo, estado de los ensayos, ruta del archivo (si fue ejecutado)
SELECT emp_nombreEmpleado AS Nombre,emp_apellidoEmpleado AS Apellido,ens_estado AS Estado, archivoresultado.ens_rutaArchivo AS Ruta
FROM ensayomuestra
JOIN empleado USING(emp_idEmpleado)
JOIN archivoresultado USING(ens_idEnsayoMuestra);

-- Valor promedio $$$ contratado con un cliente dado
SELECT cli_razonSocial ,AVG(pro_valorTotal) AS valorPromedioContratado 
FROM Proyecto NATURAL JOIN Cliente 
WHERE cli_razonSocial = 'Idiger';

-- Obtener por localizaciones la cantidad de perforaciones hechas para un proyecto
SELECT per_localizacion AS Localizacion, COUNT(per_idPerforacion) AS Cantidad
FROM perforacion
JOIN (
	SELECT pro_idProyecto FROM proyecto
    WHERE pro_nombreProyecto='OS No. CG-280'
) AS t3 USING(pro_idProyecto)
GROUP BY per_localizacion;


-- Actualizar los archivos resultado para una muestra
UPDATE archivoresultado SET ens_rutaArchivo="C:\Downloads\Resultado20" 
WHERE archivoresultado.ens_idEnsayoMuestra IN (
	SELECT ens_idEnsayoMuestra FROM ensayomuestra
    WHERE mue_idMuestra=5
);

--  Reemplazar un tipo de ensayo por otro en un conjunto de perforaciones
UPDATE ensayomuestra SET tip_idTipoEnsayo=10
WHERE tip_idTipoEnsayo=5 AND 
mue_idMuestra IN (
	SELECT muestra.mue_idMuestra FROM muestra
    WHERE per_idPerforacion IN (1,5,6)
);

-- Cambiar el estado de un ensayo a muestra (conociendo id de ensayo muestra)
UPDATE ensayomuestra SET ens_estado=3
WHERE ens_idEnsayoMuestra=5;


-- Remover un proyecto (con sus perforaciones, muestras, ensayos a muestras,
-- archivos resultado e informe final)
-- Nos dan la ID de proyecto
DELETE FROM informefinal 
WHERE pro_idProyecto=5; -- Borando el informe del proyecto

DELETE FROM estadopago
WHERE pro_idProyecto=5; -- Borrando el estado de pago

DELETE FROM archivoresultado
WHERE pro_idProyecto=5; -- Borrando los archivos resultado 

CREATE VIEW vw_perforaciones 
AS SELECT per_idPerforacion FROM perforacion 
WHERE pro_idProyecto=5;

CREATE VIEW vw_muestras
AS SELECT mue_idMuestra FROM muestra
NATURAL JOIN vw_perforaciones;

DELETE FROM ensayomuestra 
WHERE mue_idMuestra IN (vw_muestras);

DELETE FROM muestras
WHERE per_idPerforacion IN (vw_perforacion);

DELETE FROM perforacion
WHERE pro_idProyecto=5;

DELETE FROM proyecto
WHERE pro_idProyecto=5;

DROP VIEW vw_muestras;
DROP VIEW vw_perforaciones;


-- Remover los clientes cuya sumatoria de pago de proyectos sea menor a
-- un millón
CREATE VIEW vw_clientes AS 
SELECT cliente.cli_NIT FROM cliente
    JOIN Proyecto USING(cli_NIT)
    GROUP BY cliente.cli_NIT
    HAVING SUM(Proyecto.pro_valorTotal)<1000000;

CREATE VIEW vw_proyectos 
AS SELECT pro_idProyecto FROM proyecto
WHERE cli_NIT IN (vw_clientes);

-- Delete Edgar
-- Update Jose Luis

CREATE USER IF NOT EXISTS 'administrador'@'localhost' IDENTIFIED BY 'P&Logistica123';
CREATE USER IF NOT EXISTS 'administrador2'@'localhost' IDENTIFIED BY 'OlaDeMar';
CREATE USER IF NOT EXISTS 'jefeLab1'@'localhost' IDENTIFIED BY 'JoseBarrera123';
CREATE USER IF NOT EXISTS 'laboratorista1'@'localhost' IDENTIFIED BY 'JuanRodrigo123';
CREATE USER IF NOT EXISTS 'laboratorista2'@'localhost' IDENTIFIED BY 'NatyBD123';
CREATE USER IF NOT EXISTS 'laboratorista3'@'localhost' IDENTIFIED BY 'AnitaSofia123';
CREATE USER IF NOT EXISTS 'laboratorista4'@'localhost' IDENTIFIED BY 'AndresMendoza123';

SELECT * FROM mysql.user;
CREATE ROLE IF NOT EXISTS 'admin';
CREATE ROLE IF NOT EXISTS 'jefeLab';
CREATE ROLE IF NOT EXISTS 'laboratorista';


GRANT ALL ON mydb.* TO 'laboratorista','jefeLab','admin';
REVOKE INSERT,UPDATE,SELECT,DELETE ON mydb.* FROM 'laboratorista','jefeLab';
GRANT SELECT ON mydb.* TO 'laboratorista','jefeLab';
REVOKE SELECT ON mydb.cliente FROM 'laboratorista','jefeLab';
REVOKE SELECT ON mydb.estadopago FROM 'laboratorista','jefeLab';
REVOKE SELECT ON mydb.proyecto FROM 'laboratorista','jefeLab';

CREATE VIEW vw_proyecto_lab
AS SELECT pro_idProyecto,pro_nombreProyecto FROM proyecto;

GRANT SELECT on mydb.vw_proyecto_lab TO 'laboratorista','jefeLab';

GRANT INSERT,UPDATE ON mydb.ensayomuestra TO 'laboratorista','jefeLab';
GRANT INSERT,UPDATE ON mydb.archivoresultado TO 'laboratorista','jefeLab';
GRANT ALL ON mydb.informefinal TO 'jefeLab';
GRANT 'jefeLab' TO 'jefeLab1'@'localhost';
GRANT 'laboratorista' TO 'laboratorista1'@'localhost';
GRANT 'laboratorista' TO 'laboratorista2'@'localhost';
GRANT 'laboratorista' TO 'laboratorista3'@'localhost';
GRANT 'laboratorista' TO 'laboratorista4'@'localhost';
GRANT 'admin' TO 'administrador'@'localhost';
GRANT 'admin' TO 'administrador2'@'localhost';

