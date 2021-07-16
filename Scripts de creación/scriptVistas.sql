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
AS SELECT pro_idProyecto,pro_nombreProyecto, pro_FechaInicioProyecto FROM Proyecto; 

-- Rutas de informe final para cada proyecto
CREATE VIEW vw_informeFinal_vs_Proyecto
AS SELECT inf_rutaInformeFinal, inf_fechaRemisionInforme, inf_observacionesInforme, pro_nombreProyecto FROM
informeFinal NATURAL JOIN Proyecto;

-- ID de empleado con su nombre de usuario en la base de datos
CREATE VIEW vw_idEmpleado_vs_nombreUsuario
AS SELECT emp_idEmpleado, emp_nombreUsuario
FROM empleado;

-- Datos de la tabla ensayoMuestra que deben restringir el acceso a un laboratorista
CREATE VIEW vw_ensayoMuestra_laboratorista
AS SELECT ens_idEnsayoMuestra, ens_fechaEnsayoMuestra, ens_hayResiduo, emp_idEmpleado, ens_estado FROM EnsayoMuestra;

-- Vista que se utilizará en la interfaz del form3.cs
CREATE VIEW vw_idProyecto_nombreProyecto_estadoProyecto
AS SELECT pro_idProyecto AS ID, pro_nombreProyecto AS NombreProyecto, IF(pro_FechaFinalizacionProyecto = NULL, 'En curso', 'Finalizado') AS Estado
FROM proyecto;

-- Nombre del ejecutor de un ensayo muestra
CREATE VIEW vw_ejecutorEnsayoMuestra
AS SELECT emp_idEmpleado AS Ejecutor, ens_idEnsayoMuestra AS ensayoMuestra_id
FROM ensayoMuestra NATURAL JOIN empleado;

-- Nombre de un empleado dado su id
CREATE VIEW vw_nombreEmpleado_vs_idEmpleado
AS SELECT emp_nombreEmpleado AS nombre, emp_idEmpleado AS id 
FROM empleado;