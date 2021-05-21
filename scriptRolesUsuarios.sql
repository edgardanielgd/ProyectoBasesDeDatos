/* 
	Script de creación de usuarios y roles.
    MUST RUN AS ROOT.
*/

-- Creación de usuarios
CREATE USER IF NOT EXISTS 'empleadoLaboratorista1'@'localhost' IDENTIFIED BY 'ABCD1234@';
CREATE USER IF NOT EXISTS 'jefeLaboratorio1'@'localhost' IDENTIFIED BY 'ABCD1234@';
CREATE USER IF NOT EXISTS 'Administrador1'@'localhost' IDENTIFIED BY 'ABCD1234@';

-- Creación de roles
CREATE ROLE IF NOT EXISTS 'Administrador';
CREATE ROLE IF NOT EXISTS 'empleadoLaboratorista';
CREATE ROLE IF NOT EXISTS 'jefeLaboratorio';

-- Permisos para admin
GRANT ALL ON mydb.* TO 'Administrador';

-- Vista para que los empleados no vean la información económica
CREATE VIEW vw_proyecto_lab
AS SELECT pro_idProyecto,pro_nombreProyecto FROM Proyecto;  

-- Permisos para laboratorista
GRANT SELECT, INSERT, UPDATE ON mydb.Perforacion TO 'empleadoLaboratorista';
GRANT SELECT, INSERT, UPDATE ON mydb.Muestra TO 'empleadoLaboratorista';
GRANT SELECT, INSERT, UPDATE ON mydb.EnsayoMuestra TO 'empleadoLaboratorista';
GRANT SELECT, INSERT, UPDATE ON mydb.ArchivoResultado TO 'empleadoLaboratorista';
GRANT SELECT ON mydb.vw_proyecto_lab TO 'empleadoLaboratorista';

-- Permisos para jefe de laboratorio
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.Perforacion TO 'jefeLaboratorio';
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.Muestra TO 'jefeLaboratorio';
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.EnsayoMuestra TO 'jefeLaboratorio';
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.ArchivoResultado TO 'jefeLaboratorio';
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.informeFinal TO 'jefeLaboratorio';
GRANT SELECT ON mydb.vw_proyecto_lab TO 'jefeLaboratorio';

-- Asignar roles a los usuarios
GRANT 'empleadoLaboratorista' TO 'empleadoLaboratorista1'@'localhost';
GRANT 'jefeLaboratorio' TO 'jefeLaboratorio1'@'localhost';
GRANT 'Administrador' TO 'Administrador1'@'localhost';

-- Activar roles
SET DEFAULT ROLE ALL
TO 'empleadoLaboratorista1'@'localhost', 'jefeLaboratorio1'@'localhost', 'Administrador1'@'localhost';