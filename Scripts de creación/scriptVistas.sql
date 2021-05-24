use mydb;

-- Nombre de los proyectos firmados con cada cliente
CREATE VIEW vw_cliente_vs_proyecto
AS SELECT cli_razonSocial, pro_nombreProyecto
FROM Cliente NATURAL JOIN Proyecto;

-- Estado de los ensayos para un proyecto
CREATE VIEW vw_proyecto_perforacion_muestra_ensayomuestra
AS SELECT DISTINCT pro_nombreProyecto, per_nombrePerforacion,mue_numeroMuestra, ens_estado FROM
Proyecto NATURAL JOIN Perforacion
NATURAL JOIN Muestra
NATURAL JOIN EnsayoMuestra;

-- Archivos resultado para un proyecto dado
CREATE VIEW vw_proyecto_vs_archivoresultado
AS SELECT ens_rutaArchivo, pro_nombreProyecto FROM
Proyecto NATURAL JOIN Perforacion
NATURAL JOIN Muestra
NATURAL JOIN EnsayoMuestra
NATURAL JOIN ArchivoResultado;

-- Nombre de los proyectos en que participa cada empleado
CREATE VIEW vw_empleado_vs_proyecto
AS SELECT emp_nombreEmpleado, emp_oficioEmpleado, pro_nombreProyecto FROM
Proyecto NATURAL JOIN Perforacion
NATURAL JOIN Muestra
NATURAL JOIN EnsayoMuestra
NATURAL JOIN Empleado;

-- Nombre de las perforaciones en un proyecto
CREATE VIEW vw_perforacion_vs_proyecto
AS SELECT per_nombrePerforacion, pro_nombreProyecto FROM
Proyecto NATURAL JOIN Perforacion;

-- Vista para que los empleados no vean la información económica
CREATE VIEW vw_proyecto_lab
AS SELECT pro_idProyecto,pro_nombreProyecto FROM Proyecto; 

-- Rutas de informe final para cada proyecto
CREATE VIEW vw_informeFinal_vs_Proyecto
AS SELECT inf_rutaInformeFinal, inf_fechaRemisionInforme, inf_observacionesInforme, pro_nombreProyecto FROM
informeFinal NATURAL JOIN Proyecto
















