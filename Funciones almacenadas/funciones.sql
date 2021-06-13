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