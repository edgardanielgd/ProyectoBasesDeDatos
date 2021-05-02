-- Nombres de proyecto para un cliente con nombre
SELECT pro_nombreProyecto AS NombreProyecto 
FROM Proyecto JOIN 
(SELECT cli_NIT FROM cliente WHERE cli_razonSocial="Idiger")
AS clien 
USING (cli_NIT);

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

-- Quien hace un ensayo, estado de los ensayos, ruta del archivo (si fue ejecutado)
SELECT emp_nombreEmpleado AS Nombre,emp_apellidoEmpleado AS Apellido,ens_estado AS Estado, archivoresultado.ens_rutaArchivo AS Ruta
FROM ensayomuestra
JOIN empleado USING(emp_idEmpleado)
JOIN archivoresultado USING(ens_idEnsayo);

-- Obtener el promedio de profundidad de las muestras para cada proyecto
SELECT pro_nombreProyecto AS Nombre,AVG(mue_profundidad) AS Promedio
FROM proyecto
JOIN perforacion USING(pro_idProyecto)
JOIN muestra USING(per_idPerforacion)
GROUP BY (pro_idProyecto);

-- Obtener por localizaciones la cantidad de perforaciones hechas para un proyecto
SELECT per_localizacion AS Localizacion, COUNT(per_idPerforacion) AS Cantidad
FROM perforacion
JOIN (
	SELECT pro_idProyecto FROM proyecto
    WHERE pro_nombreProyecto='Idiger'
) AS t3 USING(pro_idProyecto);


