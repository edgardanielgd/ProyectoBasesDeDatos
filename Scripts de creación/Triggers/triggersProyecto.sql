/*                 Triggers para el historial de EnsayoMuestra         */
DELIMITER $$
CREATE TRIGGER tgr_update_ensayoMuestra BEFORE UPDATE ON EnsayoMuestra
FOR EACH ROW BEGIN
    INSERT INTO historialEnsayoMuestra(id_ensayo_muestra, usuario, operacion, fecha)
    VALUES (OLD.ens_idEnsayoMuestra , USER(), "Actualizacion", NOW());
END $$
DELIMITER ;
 
DELIMITER $$
CREATE TRIGGER tgr_insert_ensayoMuestra BEFORE INSERT ON EnsayoMuestra
FOR EACH ROW BEGIN
    INSERT INTO historialEnsayoMuestra(id_ensayo_muestra, usuario, operacion, fecha)
    VALUES (NEW.ens_idEnsayoMuestra , USER(), "Adicion", NOW());
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER tgr_delete_ensayoMuestra BEFORE DELETE ON EnsayoMuestra
FOR EACH ROW BEGIN
    INSERT INTO historialEnsayoMuestra(id_ensayo_muestra, usuario, operacion, fecha)
    VALUES (OLD.ens_idEnsayoMuestra , USER(), "Borrado", NOW());
END $$
DELIMITER ;

/*                 Triggers para el historial de Muestra         */
DELIMITER $$
CREATE TRIGGER tgr_update_Muestra BEFORE UPDATE ON Muestra
FOR EACH ROW BEGIN
    INSERT INTO historialMuestra(id_muestra, usuario, operacion, fecha)
    VALUES (OLD.mue_idMuestra , USER(), "Actualizacion", NOW());
END $$
DELIMITER ;
 
DELIMITER $$
CREATE TRIGGER tgr_insert_Muestra BEFORE INSERT ON Muestra
FOR EACH ROW BEGIN
    INSERT INTO historialMuestra(id_muestra, usuario, operacion, fecha)
    VALUES (NEW.mue_idMuestra , USER(), "Adicion", NOW());
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER tgr_delete_Muestra BEFORE DELETE ON Muestra
FOR EACH ROW BEGIN
    INSERT INTO historialMuestra(id_muestra, usuario, operacion, fecha)
    VALUES (OLD.mue_idMuestra , USER(), "Borrado", NOW());
END $$
DELIMITER ;







