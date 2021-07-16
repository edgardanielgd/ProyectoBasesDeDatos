/* 
	Script de creación de usuarios y roles.
    MUST RUN AS ROOT.
*/

-- Creación de usuarios
CREATE USER IF NOT EXISTS 'empleadoLaboratorista1'@'localhost' IDENTIFIED BY 'ABCD1234@';
CREATE USER IF NOT EXISTS 'empleadoLaboratorista2'@'localhost' IDENTIFIED BY 'ABCD1234@';
CREATE USER IF NOT EXISTS 'empleadoLaboratorista3'@'localhost' IDENTIFIED BY 'ABCD1234@';
CREATE USER IF NOT EXISTS 'empleadoLaboratorista4'@'localhost' IDENTIFIED BY 'ABCD1234@';
CREATE USER IF NOT EXISTS 'jefeLaboratorio1'@'localhost' IDENTIFIED BY 'ABCD1234@';
CREATE USER IF NOT EXISTS 'Administrador1'@'localhost' IDENTIFIED BY 'ABCD1234@';

-- Creación de roles
CREATE ROLE IF NOT EXISTS 'Administrador';
CREATE ROLE IF NOT EXISTS 'empleadoLaboratorista';
CREATE ROLE IF NOT EXISTS 'jefeLaboratorio';

-- Permisos para admin
GRANT ALL ON mydb.* TO 'Administrador'; 

-- Permisos para laboratorista
GRANT SELECT, UPDATE ON mydb.Perforacion TO 'empleadoLaboratorista';
GRANT SELECT, UPDATE ON mydb.Muestra TO 'empleadoLaboratorista';
GRANT SELECT ON mydb.TipoEnsayo TO 'empleadoLaboratorista';
GRANT SELECT ON mydb.EnsayoMuestra TO 'empleadoLaboratorista';
GRANT SELECT, INSERT, UPDATE ON mydb.ArchivoResultado TO 'empleadoLaboratorista';
GRANT SELECT ON mydb.vw_proyecto_lab TO 'empleadoLaboratorista';
GRANT SELECT ON mydb.vw_proyecto_perforacion_muestra_ensayomuestra TO 'empleadoLaboratorista';
GRANT SELECT ON mydb.vw_proyecto_vs_archivoresultado TO 'empleadoLaboratorista';
GRANT SELECT ON mydb.vw_perforacion_vs_proyecto TO 'empleadoLaboratorista';
GRANT SELECT ON mydb.vw_idEmpleado_vs_nombreUsuario TO 'empleadoLaboratorista';
GRANT SELECT, UPDATE, INSERT ON mydb.vw_ensayoMuestra_laboratorista TO 'empleadoLaboratorista';
GRANT SELECT ON vw_ejecutorEnsayoMuestra TO 'empleadoLaboratorista';
GRANT SELECT ON vw_nombreEmpleado_vs_idEmpleado TO 'empleadoLaboratorista';
GRANT SELECT ON vw_idProyecto_nombreProyecto_estadoProyecto TO 'empleadoLaboratorista';
GRANT EXECUTE ON PROCEDURE finalizarEnsayoMuestra TO 'empleadoLaboratorista';

-- Permisos para jefe de laboratorio
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.Perforacion TO 'jefeLaboratorio';
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.Muestra TO 'jefeLaboratorio';
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.EnsayoMuestra TO 'jefeLaboratorio';
GRANT SELECT on mydb.TipoEnsayo TO 'jefeLaboratorio';
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.ArchivoResultado TO 'jefeLaboratorio';
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.informeFinal TO 'jefeLaboratorio';
GRANT SELECT ON mydb.vw_proyecto_lab TO 'jefeLaboratorio';
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.vw_proyecto_perforacion_muestra_ensayomuestra TO 'jefeLaboratorio';
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.vw_proyecto_vs_archivoresultado TO 'jefeLaboratorio';
GRANT SELECT ON mydb.vw_empleado_vs_proyecto TO 'jefeLaboratorio';
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.vw_perforacion_vs_proyecto TO 'jefeLaboratorio';
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.vw_informeFinal_vs_Proyecto TO 'jefeLaboratorio';
GRANT SELECT ON mydb.vw_idEmpleado_vs_nombreUsuario TO 'jefeLaboratorio';
GRANT SELECT ON vw_ejecutorEnsayoMuestra TO 'jefeLaboratorio';
GRANT SELECT ON vw_nombreEmpleado_vs_idEmpleado TO 'jefeLaboratorio';
GRANT SELECT ON vw_idProyecto_nombreProyecto_estadoProyecto TO 'jefeLaboratorio';
GRANT EXECUTE ON PROCEDURE finalizarEnsayoMuestra TO 'jefeLaboratorio';


-- Asignar roles a los usuarios
GRANT 'empleadoLaboratorista' TO 'empleadoLaboratorista1'@'localhost';
GRANT 'empleadoLaboratorista' TO 'empleadoLaboratorista2'@'localhost';
GRANT 'empleadoLaboratorista' TO 'empleadoLaboratorista3'@'localhost';
GRANT 'empleadoLaboratorista' TO 'empleadoLaboratorista4'@'localhost';
GRANT 'jefeLaboratorio' TO 'jefeLaboratorio1'@'localhost';
GRANT 'Administrador' TO 'Administrador1'@'localhost';

-- Activar roles
SET DEFAULT ROLE ALL
TO 'empleadoLaboratorista1'@'localhost', 'jefeLaboratorio1'@'localhost', 'Administrador1'@'localhost', 'empleadoLaboratorista2'@'localhost', 'empleadoLaboratorista3'@'localhost', 'empleadoLaboratorista4'@'localhost';