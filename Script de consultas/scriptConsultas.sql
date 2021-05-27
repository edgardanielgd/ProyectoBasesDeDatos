use mydb;
SET GLOBAL local_infile = 'ON';
SHOW VARIABLES LIKE "secure_file_priv";

-- Nombres de proyecto para un cliente con nombre
SELECT pro_nombreProyecto AS NombreProyecto 
FROM Proyecto JOIN 
(SELECT cli_NIT FROM Cliente WHERE cli_razonSocial="Idiger")
AS clien 
USING (cli_NIT);

-- Lista de ensayos que faltan por realizar en un proyecto dado por su ID
SELECT per_nombrePerforacion, mue_numeroMuestra, mue_profundidad, tip_nombreTipoEnsayo FROM Proyecto
NATURAL JOIN Perforacion NATURAL JOIN Muestra NATURAL JOIN EnsayoMuestra NATURAL JOIN TipoEnsayo
WHERE Proyecto.pro_idProyecto = 4 AND ens_estado = 1;  -- ens_estado = 1 -> pendiente

-- Lista de ensayos que ya se realizaron, junto con su ejecutor y fecha
SELECT per_nombrePerforacion, mue_numeroMuestra, mue_profundidad, tip_nombreTipoEnsayo, emp_nombreEmpleado, ens_fechaEnsayoMuestra FROM Proyecto
NATURAL JOIN Perforacion NATURAL JOIN Muestra NATURAL JOIN EnsayoMuestra NATURAL JOIN TipoEnsayo NATURAL JOIN Empleado
WHERE Proyecto.pro_idProyecto = 4 AND ens_estado = 3;  -- ens_estado = 3 -> realizado

-- Abono y saldo por pagar para un proyecto dado su ID proyecto
SELECT cli_razonSocial, pro_nombreProyecto, esp_valorAbonado, esp_fechaAbono, (pro_valorTotal - esp_valorAbonado) AS saldoPorPagar
FROM Cliente NATURAL JOIN Proyecto NATURAL JOIN estadoPago WHERE pro_idProyecto = 3;

-- Nombres de tipo de ensayo para un proyecto con ID
SELECT DISTINCT tip_nombreTipoEnsayo AS TipoEnsayo
FROM TipoEnsayo
NATURAL JOIN EnsayoMuestra 
NATURAL JOIN Muestra
NATURAL JOIN (
	SELECT per_idPerforacion FROM Perforacion
    WHERE pro_idProyecto=5
) AS perforacion;

-- -- Nombres de tipo de ensayo para una muestra con ID
SELECT DISTINCT tip_nombreTipoEnsayo AS TipoEnsayo
FROM TipoEnsayo
NATURAL JOIN (
	SELECT tip_idTipoEnsayo FROM EnsayoMuestra
    WHERE mue_idMuestra=5
) AS tipoensayo;

-- Nombres de tipo de ensayo para una muestra y ejecutores con ID de muestra
SELECT DISTINCT tip_nombreTipoEnsayo AS TipoEnsayo,emp_nombreEmpleado AS Nombre,emp_apellidoEmpleado AS Apellido
FROM (TipoEnsayo
NATURAL JOIN (
	SELECT tip_idTipoEnsayo,emp_idEmpleado FROM EnsayoMuestra
    WHERE mue_idMuestra=5
) AS t1)
NATURAL JOIN Empleado;

-- Nombres de proyectos cuyos informes aun no entregados (Cuyos proyectos no han sido pagados)
SELECT pro_nombreProyecto AS Nombre
FROM Proyecto
NATURAL JOIN (
	SELECT pro_idProyecto FROM informeFinal
    WHERE inf_fechaRemisionInforme = NULL
)AS t2;

-- Quién hace un ensayo, estado de los ensayos, ruta del archivo (si fue ejecutado)
SELECT emp_nombreEmpleado AS Nombre,emp_apellidoEmpleado AS Apellido,ens_estado AS Estado, archivoresultado.ens_rutaArchivo AS Ruta
FROM EnsayoMuestra
NATURAL JOIN Empleado 
NATURAL JOIN ArchivoResultado;

-- Valor promedio $$$ contratado con un conjunto de clientes
SELECT cli_razonSocial ,AVG(pro_valorTotal) AS valorPromedioContratado 
FROM Proyecto NATURAL JOIN Cliente 
WHERE cli_razonSocial IN ('Idiger','CI Ambiental S.A.S','DACH & ASOCIADOS S.A.S');

-- Seleccionar los tipos de ensayo y la cantidad de ensayos muestra
-- que se han realizado sobre ellos, para aquellos con minimo tres ensayos a muestras

SELECT tip_nombreTipoEnsayo, COUNT(ens_idEnsayoMuestra) FROM TipoEnsayo
NATURAL JOIN EnsayoMuestra
GROUP BY tip_idTipoEnsayo
HAVING COUNT(ens_idEnsayoMuestra)>=3;

-- Seleccionar los clientes para los cuales se han hecho mas de 3 ensayos distintos

SELECT cli_razonSocial, COUNT(DISTINCT tip_idTipoEnsayo) FROM Cliente
NATURAL JOIN Proyecto
NATURAL JOIN Perforacion
NATURAL JOIN Muestra
NATURAL JOIN EnsayoMuestra
GROUP BY cli_NIT
HAVING COUNT(DISTINCT tip_idTipoEnsayo)>=3;


-- Obtener por localizaciones la cantidad de perforaciones hechas para un proyecto
SELECT per_localizacion AS Localizacion, COUNT(per_idPerforacion) AS Cantidad
FROM Perforacion
NATURAL JOIN (
	SELECT pro_idProyecto FROM Proyecto
    WHERE pro_nombreProyecto='OS No. CG-280'
) AS t3
GROUP BY per_localizacion;