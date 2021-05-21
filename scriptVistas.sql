use mydb;

CREATE VIEW vw_cliente_vs_proyecto
AS SELECT cli_razonSocial, pro_nombreProyecto
FROM Cliente NATURAL JOIN Proyecto;

CREATE VIEW vw_proyecto_muestra_ensayomuestra
AS SELECT pro_nombreProyecto, mue_numeroMuestra, ens_estado FROM
Proyecto NATURAL JOIN Perforacion
NATURAL JOIN Muestra
NATURAL JOIN EnsayoMuestra;

CREATE VIEW vw_proyecto_vs_archivoresultado
AS SELECT ens_rutaArchivo, pro_nombreProyecto FROM
Proyecto NATURAL JOIN Perforacion
NATURAL JOIN Muestra
NATURAL JOIN EnsayoMuestra
NATURAL JOIN ArchivoResultado;

CREATE VIEW vw_empleado_vs_proyecto
AS SELECT emp_nombreEmpleado, emp_oficioEmpleado, pro_nombreProyecto FROM
Proyecto NATURAL JOIN Perforacion
NATURAL JOIN Muestra
NATURAL JOIN EnsayoMuestra
NATURAL JOIN Empleado;

CREATE VIEW vw_perforacion_vs_proyecto
AS SELECT per_nombrePerforacion, pro_nombreProyecto FROM
Proyecto NATURAL JOIN Perforacion;