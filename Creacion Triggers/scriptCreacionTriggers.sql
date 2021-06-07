use mydb;


DELIMITER $$
CREATE TRIGGER trg_del_proyecto BEFORE DELETE ON Proyecto
FOR EACH ROW
BEGIN
	DELETE FROM Perforacion WHERE pro_idProyecto = OLD.pro_idProyecto;
    DELETE FROM InformeFinal WHERE pro_idProyecto = OLD.pro_idProyecto;
    DELETE FROM EstadoPago WHERE pro_idProyecto = OLD.pro_idProyecto;
END; $$

CREATE TRIGGER trg_del_perforacion BEFORE DELETE ON Perforacion
FOR EACH ROW
BEGIN
	DELETE FROM Muestra WHERE per_idPerforacion = OLD.per_idPerforacion;
END; $$

CREATE TRIGGER trg_del_muestra BEFORE DELETE ON Muestra
FOR EACH ROW
BEGIN
	DELETE FROM EnsayoMuestra WHERE mue_idMuestra = OLD.mue_idMuestra;
END; $$

CREATE TRIGGER trg_del_informe_final BEFORE DELETE ON InformeFinal
FOR EACH ROW
BEGIN
	DELETE FROM ArchivoResultado WHERE pro_idProyecto = OLD.pro_idProyecto;
END; $$

CREATE TRIGGER trg_del_ensayo_muestra BEFORE DELETE ON EnsayoMuestra
FOR EACH ROW
BEGIN
	DELETE FROM ArchivoResultado WHERE ens_idEnsayoMuestra = OLD.ens_idEnsayoMuestra;
END; $$

CREATE PROCEDURE proc_cambiar_empleado_default(IN id_empleado INT)
BEGIN
	DECLARE id INT DEFAULT 0;
    SELECT emp_idEmpleado INTO id FROM empleado WHERE
    emp_nombreEmpleado = "Default Employe" LIMIT 0,1;
    IF id = 0 THEN
		SELECT round(RAND()*99999) AS num INTO id 
		WHERE num NOT IN (SELECT emp_idEmpleado FROM Empleado);
		INSERT INTO empleado VALUES (id,"Default Employe","none","none");
	END IF;
    UPDATE EnsayoMuestra SET emp_idEmpleado = id WHERE emp_idEmpleado = id_empleado;
END $$


CREATE PROCEDURE proc_cambiar_tipo_ensayo_default(IN id_tipo INT)
BEGIN
	DECLARE id INT DEFAULT 0;
    SELECT tip_idTipoEnsayo INTO id FROM TipoEnsayo WHERE
    tip_nombreTipoEnsayo = "Default Type" LIMIT 0,1;
    IF id = 0 THEN
		SELECT MAX(tip_idTipoEnsayo) INTO id FROM TipoEnsayo;
		INSERT INTO TipoEnsayo VALUES (id+1,"Default Type");
	END IF;
    UPDATE EnsayoMuestra SET tip_idTipoEnsayo = id WHERE tip_idTipoEnsayo = id_tipo;
END $$

CREATE TRIGGER trg_del_empleado BEFORE DELETE ON Empleado
FOR EACH ROW
BEGIN
	CALL proc_cambiar_empleado_default(OLD.emp_idEmpleado);
END; $$

CREATE TRIGGER trg_del_tipo BEFORE DELETE ON TipoEnsayo
FOR EACH ROW
BEGIN
	CALL proc_cambiar_tipo_ensayo_default(OLD.tip_idTipoEnsayo);
END; $$
DELIMITER ;