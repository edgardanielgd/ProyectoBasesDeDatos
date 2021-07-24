/*                 Triggers para el historial de EnsayoMuestra         */

DELIMITER $$
CREATE TRIGGER tgr_update_ensayoMuestra AFTER UPDATE ON EnsayoMuestra
FOR EACH ROW BEGIN
    SELECT per_nombrePerforacion INTO @nombrePerforacion
    FROM ensayoMuestra NATURAL JOIN muestra NATURAL JOIN perforacion
    WHERE ens_idEnsayoMuestra = OLD.ens_idEnsayoMuestra;

    SELECT mue_numeroMuestra INTO @numeroMuestra
    FROM ensayoMuestra NATURAL JOIN muestra
    WHERE ens_idEnsayoMuestra = OLD.ens_idEnsayoMuestra;

    INSERT INTO historialEnsayoMuestra VALUES(@nombrePerforacion, @numeroMuestra, "Actualización", USER(), NOW());
END $$
DELIMITER ;


DELIMITER $$
CREATE TRIGGER tgr_insert_ensayoMuestra AFTER INSERT ON EnsayoMuestra
FOR EACH ROW BEGIN
    SELECT per_nombrePerforacion INTO @nombrePerforacion
    FROM ensayoMuestra NATURAL JOIN muestra NATURAL JOIN perforacion
    WHERE ens_idEnsayoMuestra = NEW.ens_idEnsayoMuestra;

    SELECT mue_numeroMuestra INTO @numeroMuestra
    FROM ensayoMuestra NATURAL JOIN muestra
    WHERE ens_idEnsayoMuestra = NEW.ens_idEnsayoMuestra;

    INSERT INTO historialEnsayoMuestra VALUES(@nombrePerforacion, @numeroMuestra, "Adición", USER(), NOW());
END $$
DELIMITER ;

create table joda(
	id INT NOT NULL auto_increment primary key,
    numeroMuestra INT NOT NULL
);

drop table joda;

DELIMITER $$
CREATE TRIGGER tgr_delete_ensayoMuestra BEFORE DELETE ON EnsayoMuestra
FOR EACH ROW BEGIN
    SELECT per_nombrePerforacion INTO @nombrePerforacion
    FROM ensayoMuestra NATURAL JOIN muestra NATURAL JOIN perforacion
    WHERE ensayoMuestra.ens_idEnsayoMuestra = OLD.ens_idEnsayoMuestra;

    SELECT mue_numeroMuestra INTO @numeroMuestra
    FROM ensayoMuestra NATURAL JOIN muestra
    WHERE ens_idEnsayoMuestra = OLD.ens_idEnsayoMuestra;
    
    INSERT INTO historialEnsayoMuestra VALUES(@nombrePerforacion, @numeroMuestra, "Borrado", USER(), NOW());
END $$
DELIMITER ;

drop TRIGGER tgr_delete_ensayoMuestra;


/*                 Triggers para el historial de Perforación         */
DELIMITER $$
CREATE TRIGGER tgr_update_perforacion AFTER UPDATE ON perforacion
FOR EACH ROW BEGIN
    INSERT INTO historialPerforacion VALUES(OLD.per_nombrePerforacion, "Actualización", USER(), NOW());
END $$
DELIMITER ;
 
DELIMITER $$
CREATE TRIGGER tgr_insert_perforacion AFTER INSERT ON perforacion
FOR EACH ROW BEGIN
    INSERT INTO historialPerforacion VALUES(NEW.per_nombrePerforacion, "Adición", USER(), NOW());
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER tgr_delete_perforacion BEFORE DELETE ON perforacion
FOR EACH ROW BEGIN
    INSERT INTO historialPerforacion VALUES(OLD.per_nombrePerforacion, "Borrado", USER(), NOW());
END $$
DELIMITER ;


/*                 Triggers para el historial de Muestra         */
DELIMITER $$
CREATE TRIGGER tgr_update_Muestra AFTER UPDATE ON Muestra
FOR EACH ROW BEGIN
    INSERT INTO historialMuestra VALUES (OLD.mue_numeroMuestra, "Actualización", USER(), NOW());
END $$
DELIMITER ;
 
DELIMITER $$
CREATE TRIGGER tgr_insert_Muestra AFTER INSERT ON Muestra
FOR EACH ROW BEGIN
    INSERT INTO historialMuestra VALUES (NEW.mue_numeroMuestra, "Adición", USER(), NOW());
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER tgr_delete_Muestra BEFORE DELETE ON Muestra
FOR EACH ROW BEGIN
    INSERT INTO historialMuestra VALUES (OLD.mue_numeroMuestra, "Borrado", USER(), NOW());
END $$
DELIMITER ;

/*Poner los campos de fecha, ejecutor y hayResiduo como NULL cuando se ingrese un EnsayoMuestra que
todavía no se ha hecho*/
DELIMITER $$
CREATE TRIGGER checkUnfinishedEnsayoMuestra BEFORE INSERT ON EnsayoMuestra
FOR EACH ROW BEGIN
    IF NEW.ens_estado = 'PENDIENTE' THEN
        SET NEW.ens_hayResiduo = IF(NEW.ens_hayResiduo IS NOT NULL, NULL, NEW.ens_hayResiduo),
			NEW.emp_idEmpleado = IF(NEW.emp_idEmpleado IS NOT NULL, NULL, NEW.emp_idEmpleado),
			NEW.ens_fechaEnsayoMuestra = IF(NEW.ens_fechaEnsayoMuestra IS NOT NULL, NULL, NEW.ens_fechaEnsayoMuestra);
    END IF;
END $$
DELIMITER ;

/*Revisar que la profundidad de una muestra tenga valores coherentes entre 1 y 150 metros*/
DELIMITER $$
CREATE TRIGGER revisarProfundidadMuestra AFTER INSERT ON muestra
FOR EACH ROW BEGIN
    IF NOT NEW.mue_profundidad BETWEEN 1 AND 150 THEN
        signal sqlstate '45000';  -- Abort the insert with an error
    END IF;
END $$
DELIMITER ;

/*Revisar que la latitud y longitud de una perforación tengan valores coherentes*/
DELIMITER $$
CREATE TRIGGER revisarCoordenadas AFTER INSERT ON perforacion
FOR EACH ROW BEGIN
    IF NOT ((NEW.per_latitud BETWEEN -90 AND 90) AND (NEW.per_longitud BETWEEN -180 AND 180)) THEN
         SIGNAL SQLSTATE '45000';  -- Abort the insert with an error
    END IF;
END $$
DELIMITER ;