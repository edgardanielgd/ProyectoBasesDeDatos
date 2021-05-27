use mydb;
SET GLOBAL local_infile = 'ON';
SHOW VARIABLES LIKE "secure_file_priv";


-- Actualizar los archivos resultado para una muestra
UPDATE ArchivoResultado SET ens_rutaArchivo="C:\Downloads\Resultado20" 
WHERE ArchivoResultado.ens_idEnsayoMuestra IN (
	SELECT ens_idEnsayoMuestra FROM EnsayoMuestra
    WHERE mue_idMuestra=5
);


-- Actualizar el nombre de un cliente dado su NIT
UPDATE Cliente SET cli_razonSocial = 'Idiger'
WHERE cli_NIT = 8001542751;

-- Actualizar el valor total de un proyecto dado su ID
UPDATE Proyecto SET pro_valorTotal = ValorEnteroDado
WHERE pro_idProyecto = id_dado;

-- Actualizar el valor abonado en un proyecto dado su ID
UPDATE estadoPago SET esp_valorAbonado = ValorAbonadoNuevo
WHERE pro_idProyecto = id_dado;

-- Actualizar la ubicación en bodega de una muestra dado su ID de muestra
UPDATE Muestra SET mue_ubicacionBodega = "Nueva Ubicación"
WHERE mue_idMuestra = id_muestra_dado;

-- Actualizar el estado de realización de un EnsayoMuestra dado ens_idEnsayoMuestra
UPDATE EnsayoMuestra SET ens_estado = nuevoEstado
WHERE ens_idEnsayoMuestra = id_ensayo_dado;

-- Actualizar las observaciones de un informe final dado un id_proyecto
UPDATE informeFinal SET inf_observacionesInforme = "nuevas observaciones"
WHERE pro_idProyecto = id_proyecto_dado;



--  Reemplazar un tipo de ensayo por otro en un conjunto de perforaciones
UPDATE EnsayoMuestra SET tip_idTipoEnsayo=10
WHERE tip_idTipoEnsayo=5 AND 
mue_idMuestra IN (
	SELECT muestra.mue_idMuestra FROM Muestra
    WHERE per_idPerforacion IN (1,5,6)
);

-- Cambiar el estado de un ensayo a muestra (conociendo id de ensayo muestra)
UPDATE EnsayoMuestra SET ens_estado=3
WHERE ens_idEnsayoMuestra=5;


-- Remover un proyecto (con sus perforaciones, muestras, ensayos a muestras,
-- archivos resultado e informe final)
-- Nos dan la ID de proyecto
CREATE VIEW vw_perforaciones 
AS SELECT DISTINCT per_idPerforacion FROM Perforacion 
WHERE pro_idProyecto=5;

CREATE VIEW vw_muestras
AS SELECT DISTINCT mue_idMuestra FROM Muestra
NATURAL JOIN vw_perforaciones;

CREATE VIEW vw_ensayosmuestra
AS SELECT DISTINCT ens_idEnsayoMuestra FROM EnsayoMuestra
NATURAL JOIN vw_muestras;

DELETE FROM ArchivoResultado
WHERE ens_idEnsayoMuestra IN (
	SELECT * FROM vw_ensayosmuestra
    );


DELETE FROM informeFinal 
WHERE pro_idProyecto=5; -- Borando el informe del proyecto

DELETE FROM estadoPago
WHERE pro_idProyecto=5; -- Borrando el estado de pago

DELETE FROM EnsayoMuestra 
WHERE ens_idEnsayoMuestra IN (
	SELECT * FROM 
    vw_ensayosmuestra
);

DELETE FROM Muestra
WHERE mue_idMuestra IN (SELECT * FROM 
vw_muestras);

DELETE FROM Perforacion
WHERE per_idPerforacion IN (SELECT * FROM 
vw_perforaciones);

DELETE FROM Proyecto
WHERE pro_idProyecto=5;

DROP VIEW vw_muestras;
DROP VIEW vw_perforaciones;
DROP VIEW vw_ensayosmuestra;

-- Remover los clientes cuya sumatoria de pago de proyectos sea menor a
-- un millón
CREATE VIEW vw_clientes AS 
SELECT Cliente.cli_NIT FROM Cliente
    JOIN Proyecto USING(cli_NIT)
    GROUP BY Cliente.cli_NIT
    HAVING SUM(Proyecto.pro_valorTotal)<1000000;

CREATE VIEW vw_proyectos 
AS SELECT  DISTINCT pro_idProyecto FROM Proyecto
NATURAL JOIN vw_clientes;

CREATE VIEW vw_perforaciones
AS SELECT  DISTINCT per_idPerforacion FROM Perforacion
NATURAL JOIN vw_proyectos;

CREATE VIEW vw_muestras
AS SELECT  DISTINCT mue_idMuestra FROM Muestra
NATURAL JOIN vw_perforaciones;

CREATE VIEW vw_ensayosmuestra
AS SELECT  DISTINCT ens_idEnsayoMuestra FROM EnsayoMuestra
NATURAL JOIN vw_muestras;

DELETE FROM ArchivoResultado
WHERE ens_idEnsayoMuestra IN (SELECT * FROM vw_ensayosmuestra);

DELETE FROM informeFinal
WHERE pro_idproyecto IN (SELECT * FROM vw_proyectos);

DELETE FROM estadoPago
WHERE pro_idproyecto IN (SELECT * FROM vw_proyectos);

DELETE FROM EnsayoMuestra
WHERE ens_idEnsayoMuestra IN ( 
SELECT ens_idEnsayoMuestra FROM vw_ensayosmuestra
);

DELETE FROM Muestra
WHERE mue_idMuestra IN(SELECT * FROM vw_muestras);

DELETE FROM perforacion
WHERE per_idPerforacion IN(SELECT * FROM vw_perforaciones);

DELETE FROM Proyecto
WHERE pro_idProyecto IN (SELECT * FROM vw_proyectos);

DELETE FROM Cliente
WHERE cli_NIT IN (SELECT * FROM vw_clientes);

DROP VIEW vw_ensayosmuestra;
DROP VIEW vw_muestras;
DROP VIEW vw_perforaciones;
DROP VIEW vw_proyectos;
DROP VIEW vw_clientes;
-- Delete Edgar
-- Update Jose Luis

-- Borrar una muestra de un proyecto
CREATE VIEW vw_ensayosmuestra
as select distinct ens_idEnsayoMuestra FROM
EnsayoMuestra WHERE mue_idMuestra=10;

DELETE FROM ArchivoResultado 
WHERE ens_idEnsayoMuestra IN (
	SELECT * FROM vw_ensayosmuestra
);
DELETE FROM EnsayoMuestra
WHERE ens_idEnsayoMuestra IN (
	SELECT * FROM vw_ensayosmuestra
);
DELETE FROM Muestra WHERE mue_idMuestra=10;
DROP VIEW vw_ensayosmuestra;	