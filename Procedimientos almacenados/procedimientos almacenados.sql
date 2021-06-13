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