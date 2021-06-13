-- Calcula el IVA 19% de un proyecto dado su ID
DELIMITER $$
CREATE FUNCTION calcular_IVA_proyecto(id_proyecto INT) RETURNS FLOAT
DETERMINISTIC
BEGIN
    SELECT pro_valorTotal INTO @valorProyecto
    FROM proyecto
    WHERE pro_idProyecto = id_proyecto;
    
    RETURN @valorProyecto * 0.19;
END $$
DELIMITER ;

-- Funcion creada para facilitar el pago de un proyecto
DELIMITER $$
CREATE FUNCTION func_pagarProyecto(idProyecto INT, pago INT) 
RETURNS INT DETERMINISTIC
-- 0 = NO EXISTE PROYECTO
-- 1 = PAGO COMPLETO
-- 2 = DEBE DEVOLVER DINERO
-- 3 = ABONO
BEGIN
	DECLARE total, falto, existe INT DEFAULT 0;
    SELECT COUNT(*) INTO existe FROM Proyecto
    WHERE pro_idProyecto = idProyecto;
    IF exiiste <= 0 THEN
		RETURN 0;
    END IF;
    SELECT pro_valorTotal INTO total FROM Proyecto
    WHERE pro_idProyecto = idProyecto;
    SET falto = total - pago;
    IF falto <= 0 THEN
		SELECT COUNT(*) INTO existe FROM EstadoPago
        WHERE pro_idProyecto = idProyecto;
        IF existe > 0 THEN
			UPDATE EstadoPago SET esp_fechaPagoTotal = current_timestamp()
            WHERE pro_idProyecto = idProyecto;
		else
			INSERT INTO EstadoPago(pro_idProyecto, esp_valorAbonado,esp_fechaPagoTotal)
            VALUES (idProyecto,0,current_timestamp());
        END IF;
        IF falto = 0 THEN RETURN 1; END IF;
        RETURN 2;
	else
		SELECT COUNT(*) INTO existe FROM EstadoPago
        WHERE pro_idProyecto = idProyecto;
        IF existe > 0 THEN
			UPDATE EstadoPago SET esp_fechaAbono = current_timestamp(),
            esp_valorAbonado = pago
            WHERE pro_idProyecto = idProyecto;
		else
			INSERT INTO EstadoPago(pro_idProyecto, esp_valorAbonado,esp_fechaAbono)
            VALUES (idProyecto,pago,current_timestamp());
        END IF;
        RETURN 3;
    END IF;
END $$
DELIMITER ;

-- Retorna la cantidad de ensayos que faltan por realizar
-- en un proyecto
DELIMITER $$
CREATE FUNCTION func_contarEnsayosFaltantes(idProyecto INT)
RETURNS INT DETERMINISTIC
-- -1 = No existe el proyecto
BEGIN
	DECLARE cantidad, existe INT DEFAULT 0;
    
    SELECT COUNT(*) INTO existe FROM Proyecto
    WHERE pro_idProyecto = idProyecto;
    
    IF existe <= 0 THEN
		RETURN -1;
    END IF;
    
    SELECT COUNT(*) INTO cantidad FROM
    EnsayoMuestra WHERE mue_idMuestra IN
    (
		SELECT mue_idMuestra FROM (
			SELECT per_idPerforacion FROM Perforacion
            WHERE pro_idProyecto = idProyecto
        ) AS t2 NATURAL JOIN Muestra
    ) && ens_estado = 3 ;
    
    RETURN cantidad;
END $$
DELIMITER ;

-- Cuenta y retorna la cantidad de ensayos que ha hecho un empleado (actividad)
DELIMITER $$
CREATE FUNCTION func_contarParticipacionesEmpleado(idEmpleado INT)
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE cantidad, existe INT DEFAULT 0;
    SELECT COUNT(*) INTO existe FROM Empleado
    WHERE emp_idEmpleado = idEmpleado;
    
    IF existe <= 0 THEN
		RETURN -1;
	END IF;
    
    SELECT COUNT(*) INTO cantidad FROM EnsayoMuestra
    WHERE emp_idEmpleado = idEmpleado;
    
    RETURN cantidad;
END $$
DELIMITER ;

-- Retorna una fecha en la cual se espera (a partir del promedio de duración de proyectos)
-- acabe el proyecto pasado como parámetro (ID)
DELIMITER $$
CREATE FUNCTION func_estimar_finalizacion(idProyecto INT)
RETURNS DATE DETERMINISTIC
BEGIN
	DECLARE actual DATE;
    DECLARE existe,promedio INT DEFAULT 0;
    SELECT COUNT(*) INTO existe FROM Proyecto
    WHERE pro_idProyecto = idProyecto;
    IF existe <= 0 THEN
		RETURN NULL;
    END IF;
    
    SELECT AVG(TIMESTAMPDIFF(SECOND,pro_FechaInicioProyecto,pro_FechaFinalizacionProyecto)) INTO
    promedio FROM Proyecto WHERE pro_FechaFinalizacionProyecto IS NOT NULL AND
    pro_FechaInicioProyecto IS NOT NULL;
    SET @cosa = promedio;
    SELECT pro_FechaInicioProyecto INTO actual FROM Proyecto WHERE
    pro_idProyecto = idProyecto;
    IF actual IS NOT NULL THEN
		RETURN DATE_ADD(actual,INTERVAL promedio SECOND);
	ELSE
		RETURN NULL;
	END IF;
END $$
DELIMITER ;