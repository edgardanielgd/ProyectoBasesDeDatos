/* Actualiza los registros nulos de EnsayoMuestra una vez que se realiza el ensayo
Los registros nulos son los campos ens_hayResiduo, ens_fechaEnsayoMuestra y 
emp_idEmpleado que solo se pueden obtener una vez se finaliza el ensayo */
DELIMITER $$
CREATE PROCEDURE finalizarEnsayoMuestra(id_ensayo_muestra INT, hay_residuo TINYINT)
BEGIN
    SELECT emp_idEmpleado INTO @id_empleado_actual
    FROM vw_idEmpleado_vs_nombreUsuario
    WHERE emp_nombreUsuario = USER();  -- Obtiene la id del empleado actual

    UPDATE EnsayoMuestra
    SET ens_fechaEnsayoMuestra = NOW(),
    ens_hayResiduo = hay_residuo,
    emp_idEmpleado = @id_empleado_actual
    WHERE ens_idEnsayoMuestra = id_ensayo_muestra;  

    


END $$
DELIMITER ;

-- Un procedimiento que actualice el atributo "cantidad de ensayos" de un proyecto
-- EN función de los ensayos que ya han sido realizados
DELIMITER $$
CREATE PROCEDURE proc_actualizarCantidadEnsayos(idProyecto INT)
BEGIN
	DECLARE cantidadExistente,existe,cantidadNecesitada INT DEFAULT 0;
    SELECT COUNT(*) INTO existe FROM Proyecto
    WHERE pro_idProyecto = idProyecto;
    IF existe > 0 THEN
		SELECT pro_cantidadEnsayos INTO cantidadExistente FROM
		Proyecto WHERE pro_idProyecto=idProyecto;
        
		SELECT COUNT(*) INTO cantidadNecesitada FROM
        (SELECT per_idPerforacion FROM Perforacion
        WHERE pro_idProyecto = idProyecto) AS t NATURAL JOIN Muestra
        NATURAL JOIN EnsayoMuestra;
        
        IF cantidadNecesitada > cantidadExistente THEN
			UPDATE Proyecto SET pro_cantidadEnsayos = cantidadNecesitada
            WHERE pro_idProyecto = idProyecto;
        END IF;
    END IF;
    
END $$
DELIMITER ;

-- Crea un procedimiento que muestra los proyectos localizados cerca de determinada
-- latitud y longitud (la cercanía se pasa en el parámetro "radio")
DELIMITER $$
CREATE PROCEDURE proc_proyectos_cerca_de(latitud INT,longitud INT,radio INT)
BEGIN
	SELECT DISTINCT pro_nombreProyecto,per_localizacion FROM Proyecto
    NATURAL JOIN (SELECT pro_idProyecto,per_localizacion FROM Perforacion WHERE
    per_latitud < latitud + radio AND per_latitud > latitud - radio
    AND per_longitud < longitud + radio AND per_longitud > longitud - radio)
    AS t1;
END $$
DELIMITER ;


