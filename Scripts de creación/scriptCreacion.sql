CREATE SCHEMA IF NOT EXISTS mydb DEFAULT CHARACTER SET latin1 ;
USE mydb ;

-- -----------------------------------------------------
-- Table mydb.Cliente
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.Cliente (
  cli_NIT BIGINT PRIMARY KEY COMMENT 'NIT es el identificador único que tiene cada empresa en Colombia',
  cli_razonSocial VARCHAR(100) NOT NULL COMMENT 'La razón social es el nombre comercial de una empresa',
  cli_telefono VARCHAR(11) NOT NULL COMMENT 'Representa un único teléfono de contacto para la empresa (Mismos entes de la empresa sugieren el guardado de solamente un teléfono de contacto)',
  cli_sede VARCHAR(20) NULL COMMENT 'Representa la sede de la empresa que ha solicitado la realización de algún proyecto',
  cli_certificadoCamaraComercio VARCHAR(255) NULL COMMENT 'Certificado de cada empresa disponible en https://linea.ccb.org.co/CertificadosElectronicosR/Index.html',
  cli_nombreContacto VARCHAR(45) NOT NULL COMMENT 'Nombre persona intermediaria de una empresa. Por ejemplo puede ser una secretaria o un empleado específico en una empresa',
  cli_apellidoContacto VARCHAR(45) NOT NULL COMMENT 'Representa el apellido del contacto de la empresa. Mismas directivas del negocio destino de la base de dato manifiestan la necesidad de guardar sólo un contacto de la empresa',
  cli_emailContacto VARCHAR(45) NOT NULL COMMENT 'Representa el email de contacto. La presencia de sólo un contacto por empresa se explica en la columna \"cli_apellidoContacto\"'
)
ENGINE = InnoDB
COMMENT = 'Representa la entidad Fuerte \'Cliente\', señala siempre a una empresa (por ésta razón su identificador es el NIT de dicha empresa)';


-- -----------------------------------------------------
-- Table mydb.Proyecto
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Proyecto (
  pro_idProyecto INT PRIMARY KEY COMMENT 'Representa la llave primaria de la entidad proyecto de tipo numérico',
  pro_cantidadEnsayos INT NULL COMMENT 'Cantidad total de ensayos a realizar',
  pro_valorTotal INT NOT NULL COMMENT 'Precio total del proyecto',
  pro_IVA INT NOT NULL DEFAULT 0.19 COMMENT 'representa un iva específico a cobrar dentro del proyecto: (19% del valor total) con la posibilidad de ser distinto',
  pro_nombreProyecto VARCHAR(80) NOT NULL COMMENT 'Representa el nombre dado por el cliente para asignar a un proyecto que éste planea realizar o para el cuál busca estudiar alguna muestra',
  pro_FechaInicioProyecto DATE NOT NULL COMMENT 'Representa la fecha en la que se inicia un proyecto (Fecha en la que se crea el registro)',
  pro_FechaFinalizacionProyecto DATE NOT NULL COMMENT 'Representa la fecha en la que se da fin a un proyecto. Puede ser cuando se entrega el informe, cuando se completa el pago u otra fecha.',
  cli_NIT BIGINT NOT NULL COMMENT 'Representa la llave foránea que relaciona cada proyecto con un único cliente',
  FOREIGN KEY (cli_NIT)
    REFERENCES Cliente(cli_NIT)
    ON DELETE CASCADE
    ON UPDATE NO ACTION) 
ENGINE = InnoDB
COMMENT = 'Representa la entidad Proyecto, la cual es generada cada vez que un servicio es prestado a un cliente';


-- -----------------------------------------------------
-- Table mydb.Perforacion
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.Perforacion (
  per_idPerforacion INT PRIMARY KEY COMMENT 'Representa un identificador unico para cada perforación realizada',
  per_nombrePerforacion VARCHAR(45) NOT NULL COMMENT 'Define un nombre para la perforación realizada (no se usa como identificador dado que no es único para cada perforación)',
  per_localizacion VARCHAR(100) NOT NULL COMMENT 'Se refiere a la localización general de la perforación',
  per_latitud DECIMAL(8,6) NOT NULL COMMENT 'Define las coordenadas en latitud de la perforación',
  per_longitud DECIMAL(9,6) NOT NULL COMMENT 'Representa la longitud donde se encuentra la perforación',
  pro_idProyecto INT NOT NULL COMMENT 'Representa la llave foránea para la relación 1 a varios con la entidad proyecto',
  FOREIGN KEY (pro_idProyecto)
    REFERENCES Proyecto(pro_idProyecto)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Representa la entidad Muestra, proveida por el cliente dentro de un proyecto';


-- -----------------------------------------------------
-- Table mydb.Muestra
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.Muestra (
  mue_idMuestra INT PRIMARY KEY COMMENT 'Representa un identificador único para cada muestra (llave primaria)',
  mue_numeroMuestra INT NOT NULL COMMENT 'Define el nombre de la muestra entregada para un proyecto (obligatorio)',
  mue_condicionEmpaque ENUM('TUBO', 'BOLSA', 'BLOQUE') NOT NULL COMMENT 'EL empaque puede ser tubo, bolsa o apique',
  mue_tipoMuestra ENUM('ALTERADA', 'INALTERADA') NOT NULL COMMENT 'El tipo de muestra puede ser alterada o inalterada',
  mue_ubicacionBodega VARCHAR(45) NOT NULL COMMENT 'Representa una cadena describiendo la ubicación de la muestra en bodega',
  mue_tipoExploracion ENUM('SONDEO', 'APIQUE') NOT NULL COMMENT 'El tipo de exploración puede ser sondeo o apique',
  mue_descripcionMuestra VARCHAR(45) NOT NULL COMMENT 'Descripción física de la muestra. Incluye datos como el lugar donde fue extraída, la profundidad y una breve descripción del color y su tipo de suelo.',
  per_idPerforacion INT NOT NULL COMMENT 'Representa la llave foránea de la relación 1 a varios con la entidad Perforación',
  mue_profundidad DECIMAL(5,2) NOT NULL COMMENT 'Representa la profundidad a la que fue tomada la muestra',
  FOREIGN KEY (per_idPerforacion)
    REFERENCES mydb.Perforacion (per_idPerforacion)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Representa la entidad Muestra, proveida por el cliente dentro de un proyecto';


-- -----------------------------------------------------
-- Table mydb.estadoPago
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.estadoPago (
  pro_idProyecto INT PRIMARY KEY COMMENT 'Representa una llave foránea converitda en primaria que identifica una relación 1-1 entre la presente relación y un proyecto.',
  esp_valorAbonado INT NOT NULL COMMENT 'Representa un valor abonado por el cliente en el momento de iniciar un proyecto. Puede ser 0 para indicar que el cliente no abonó ningún valor. Según sea el caso',
  esp_fechaAbono DATETIME NULL COMMENT 'Representa la fecha en la que se entregó un abono para la realización de un proyecto. Puede ser vacía si no se ha pagado ningún abono',
  esp_fechaPagoTotal DATETIME NULL COMMENT 'Representa la fecha en la que se ha pagado la totalidad del proyecto, puede ser nula si aún no ha sido pagado ',
  FOREIGN KEY (pro_idProyecto)
    REFERENCES mydb.Proyecto (pro_idProyecto)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Representa la entidad \'Estado de pago de un proyecto\'; ésta entidad específicamente representa la existencia de un anticipo por parte de el cliente ante la propuesta de un proyecto';


-- -----------------------------------------------------
-- Table mydb.Empleado
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.Empleado (
  emp_idEmpleado INT PRIMARY KEY COMMENT 'Número de cédula',  
  emp_nombreEmpleado VARCHAR(60) NOT NULL,
  emp_apellidoEmpleado VARCHAR(60) NOT NULL,
  emp_oficioEmpleado VARCHAR(20) NOT NULL,
  emp_salario INT NOT NULL,
  emp_nombreUsuario VARCHAR(60) NOT NULL COMMENT 'Nombre de usuario en la base de datos',
  emp_nombreEPS VARCHAR(60) NOT NULL,
  emp_nombreARL VARCHAR(60) NOT NULL,
  emp_nombreFondoPension VARCHAR(60) NOT NULL
)
ENGINE = InnoDB
COMMENT = 'Entidad fuerte Empleado, participante en el estudio de las muestras';


-- -----------------------------------------------------
-- Table mydb.TipoEnsayo
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.TipoEnsayo (
  tip_idTipoEnsayo INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Representa la identificación única de cada tipo de Ensayo. ',
  tip_nombreTipoEnsayo VARCHAR(45) NOT NULL COMMENT 'Representa el nombre de ensayo proveniente de un conjunto de datos ya especificado dentro de la entidad'
)
ENGINE = InnoDB
COMMENT = 'Representa la entidad Ensayo, ésta entidad puede ser definida como una constante con alteraciones poco frecuentes';


-- -----------------------------------------------------
-- Table mydb.EnsayoMuestra
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.EnsayoMuestra (
  ens_idEnsayoMuestra INT PRIMARY KEY auto_increment COMMENT 'Representa una llave primaria autogenerada que identifica a cada registro único de la relación EnsayoMuestra',
  ens_fechaEnsayoMuestra DATETIME NULL COMMENT 'Representa la fecha en la que se realizó el ensayo, NULL si no se ha realizado',
  ens_hayResiduo TINYINT NULL COMMENT 'Un ensayo puede generar un residuo o no. NUll si no se ha realizado',
  ens_condicionesParticularesEstudio VARCHAR(400) NULL COMMENT 'Condiciones específicas establecidas por el cliente para un ensayo. Puede ser cambiar un parámetro como la presión o la humedad de un ensayo.',
  emp_idEmpleado INT NULL COMMENT 'Representa una llave foránea proveniente la relación Empleado. Representa la identificación de la persona que realizó el ensayo. NUll si no se ha realizado',
  mue_idMuestra INT NOT NULL COMMENT 'Representa la identificación de la muestra estudiada dentro de un ensayo.',
  tip_idTipoEnsayo INT NOT NULL COMMENT 'Representa una llave foránea relativa al id (identificador único dentro de dicha tabla) del tipo de ensayo realizado.',
  ens_estado ENUM('PENDIENTE', 'EN CURSO', 'REALIZADO') NOT NULL DEFAULT 'PENDIENTE' COMMENT 'La columna estado representa si el ensayo ya fue realizado, esta en curso o no ha sido iniciado',
  FOREIGN KEY (emp_idEmpleado)
    REFERENCES mydb.Empleado (emp_idEmpleado)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  FOREIGN KEY (mue_idMuestra)
    REFERENCES mydb.Muestra (mue_idMuestra)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  FOREIGN KEY (tip_idTipoEnsayo)
    REFERENCES mydb.TipoEnsayo (tip_idTipoEnsayo)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Esta relación representa cada ensayo de laboratorio individual que se realice.';


-- -----------------------------------------------------
-- Table mydb.informeFinal
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.informeFinal (
  inf_fechaRemisionInforme DATETIME PRIMARY KEY COMMENT 'Representa la fecha en la cual un informe ha sido remitido',
  inf_observacionesInforme VARCHAR(1000) NULL COMMENT 'Representa observaciones opcionales dadas a un informe al momento de ser creado / entregado',
  pro_idProyecto INT NOT NULL COMMENT 'Representa una llave foránea converitda en primaria en una relación 1-1 con la tabla proyecto',
  inf_rutaInformeFinal VARCHAR (200) NOT NULL COMMENT 'Ruta donde están almacenados los archivos resultado individuales',
  FOREIGN KEY (pro_idProyecto)
    REFERENCES mydb.Proyecto (pro_idProyecto)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Define la entidad débil \'Informe Final\', la cual representa un resumen de los resultados a entregar dentro de un proyecto';


-- -----------------------------------------------------
-- Table mydb.ArchivoResultado
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.ArchivoResultado (
  ens_idEnsayoMuestra INT PRIMARY KEY COMMENT 'Representa una llave foránea convertida en primaria en una relación 1-1 con la tabla EnsayoMuestra. ',
  ens_rutaArchivo VARCHAR(1000) NOT NULL COMMENT 'Representa una cadena que contiene la ruta (Path) de un archivo de excel generado por la empresa esquematizando detalladamente el resultado de la aplicación de un ensayo a una muestra',
  pro_idProyecto INT NOT NULL COMMENT 'Representa una llave foránea que relaciona los archivos con un único informe al que pertenece (Nótese que a través de ésta llave puede ser encontrado directamente el proyecto y el estado de pago relativo al archivo en cuestión)',
  FOREIGN KEY (ens_idEnsayoMuestra)
    REFERENCES mydb.EnsayoMuestra (ens_idEnsayoMuestra)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  FOREIGN KEY (pro_idProyecto)
    REFERENCES mydb.informeFinal (pro_idProyecto)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Define la entidad débil \'Resultado Muestra\' la cual representa el resultado alcanzado dentro de un ensayo a una determinada muestra';


-- Datos clientes

INSERT INTO Cliente VALUES(8999992948,'Servicio Geológico Colombiano',2200200,'Bogotá','C:\Users\josel\Documents\CertificadoServicioGeologicoColombiano','Óscar Eladio','Paredes Zapata','cliente@sgc.gov.co');
INSERT INTO Cliente VALUES(8001542751,'Idiger',4292800,'Bogotá','C:\Users\josel\Documents\CertificadoIdiger','Guillermo','Escobar Castro','notificacionesjudiciales@idiger.gov.co');
INSERT INTO Cliente VALUES(8170014359,'CI Ambiental S.A.S',3175030960,'Barranquilla','C:\Users\josel\Documents\CertificadoCIAmbiental','Carlos','Trujillo','info@ciambiental.com');
INSERT INTO Cliente VALUES(9005586047,'DACH & ASOCIADOS S.A.S',6421617,'Bogotá','C:\Users\josel\Documents\CertificadoDACHAsociados','Julián','Ramírez','dachasociados@hotmail.com');
INSERT INTO Cliente VALUES(8300108934,'Geocing S.A.S',7046969,'Bogotá','C:\Users\josel\Documents\CertificadoGeocing','Carlos','Gómez','proyectos@geocing.com'); 


-- Datos proyectos
INSERT INTO Proyecto VALUES(1,NULL,'130142100','24726999','Contrato de interventoría No. 481 de 2017','2017-12-14','2018-1-9',8001542751);
INSERT INTO Proyecto VALUES(2,567,'136796825','25991396.75','500 de 2019','2019-12-16','2020-8-21',8001542751);
INSERT INTO Proyecto VALUES(3,7,'79640000','15131600','Certificado trabajos realizados en el año 2011','2011-1-1','2011-12-31',8170014359);
INSERT INTO Proyecto VALUES(4,NULL,'29000000','5510000','Orden de servicios No. 002','2013-3-1','2013-11-01',9005586047);
INSERT INTO Proyecto VALUES(5,28,'22800000','4332000','Proyecto GE-334 Fopae','2014-5-8','2014-9-23',8300108934);
INSERT INTO Proyecto VALUES(6,14,'10150000','1928500','OS No. CG-280','2011-8-9','2011-9-5',8300108934);
INSERT INTO Proyecto VALUES(7,6,'3828000','727320','OS No. CG-294','2011-12-20','2012-01-24',8300108934);


-- Datos perforación
INSERT INTO Perforacion VALUES(1,'PZ-12','Ciudad Bolívar',4.5795,74.1574,1);
INSERT INTO Perforacion VALUES(2,'PZ-3','Ciudad Bolívar',4.5797,74.1524,1);
INSERT INTO Perforacion VALUES(3,'PZ-12','Cáqueza',4.418807,-73.93555,2);
INSERT INTO Perforacion VALUES(4,'PZ-1','Fomeque',4.438735,-73.824062,3);
INSERT INTO Perforacion VALUES(5,'PZ-2','Macheta',4.960182,-73.690088,4);
INSERT INTO Perforacion VALUES(6,'PZ-3','Gachala',4.588114,-73.60923,5);
INSERT INTO Perforacion VALUES(7,'PZ-4','Miraflores',5.185256,-73.15222,6);
INSERT INTO Perforacion VALUES(8,'PZ-5','Aquitania',5.337696,-72.904008,7);


-- Datos muestras
INSERT INTO Muestra VALUES(1,'2','2','2','Pasillo 3','2','Suelo limoso','1','75');
INSERT INTO Muestra VALUES(2,'4','1','2','Pasillo 1','2','Arena naranja','1','115');
INSERT INTO Muestra VALUES(3,'5','2','1','Pasillo 1','2','Arcilla blanda con gravas','1','170');
INSERT INTO Muestra VALUES(4,'6','1','1','Pasillo 4','1','Arena naranja','1','37');
INSERT INTO Muestra VALUES(5,'7','1','2','Pasillo 4','1','Suelo volcánico','1','183');
INSERT INTO Muestra VALUES(6,'8','1','1','Pasillo 3','1','Suelo volcánico','1','165');
INSERT INTO Muestra VALUES(7,'1','1','2','Pasillo 1','2','Suelo volcánico','2','185');
INSERT INTO Muestra VALUES(8,'2','1','1','Pasillo 2','1','Suelo limoso','2','19');
INSERT INTO Muestra VALUES(9,'3','1','1','Pasillo 4','1','Suelo volcánico','2','47');
INSERT INTO Muestra VALUES(10,'4','1','1','Pasillo 2','2','Suelo volcánico','2','19');
INSERT INTO Muestra VALUES(11,'5','1','1','Pasillo 3','1','Suelo volcánico','2','63');
INSERT INTO Muestra VALUES(12,'6','1','2','Pasillo 5','1','Arcilla blanda con gravas','2','37');
INSERT INTO Muestra VALUES(13,'7','2','2','Pasillo 6','1','Arena naranja','2','54');
INSERT INTO Muestra VALUES(14,'1','1','1','Pasillo 6','2','Lutita roja','3','14');
INSERT INTO Muestra VALUES(15,'2','1','2','Pasillo 1','1','Arcilla blanda con gravas','3','79');
INSERT INTO Muestra VALUES(16,'3','2','2','Pasillo 5','1','Arcilla blanda con gravas','3','3');
INSERT INTO Muestra VALUES(17,'4','2','2','Pasillo 3','2','Suelo con gravas','3','156');
INSERT INTO Muestra VALUES(18,'5','1','1','Pasillo 6','1','Arena naranja','3','55');
INSERT INTO Muestra VALUES(19,'1','1','1','Pasillo 3','1','Suelo limoso','4','162');
INSERT INTO Muestra VALUES(20,'2','1','2','Pasillo 4','1','Lutita roja','4','151');
INSERT INTO Muestra VALUES(21,'3','2','2','Pasillo 2','1','Suelo con gravas','4','91');
INSERT INTO Muestra VALUES(22,'4','1','2','Pasillo 3','2','Arena naranja','4','8');
INSERT INTO Muestra VALUES(23,'5','1','1','Pasillo 4','1','Suelo con gravas','4','147');
INSERT INTO Muestra VALUES(24,'6','1','2','Pasillo 2','2','Suelo volcánico','4','149');
INSERT INTO Muestra VALUES(25,'7','1','2','Pasillo 3','1','Arcilla blanda con gravas','4','113');
INSERT INTO Muestra VALUES(26,'8','1','2','Pasillo 1','2','Suelo volcánico','4','136');
INSERT INTO Muestra VALUES(27,'9','2','1','Pasillo 4','2','Arcilla blanda con gravas','4','9');
INSERT INTO Muestra VALUES(28,'10','2','2','Pasillo 1','2','Arcilla blanda con gravas','4','41');
INSERT INTO Muestra VALUES(29,'11','2','2','Pasillo 5','1','Suelo volcánico','4','1');
INSERT INTO Muestra VALUES(30,'1','1','1','Pasillo 5','1','Lutita roja','5','23');
INSERT INTO Muestra VALUES(31,'2','1','1','Pasillo 3','2','Suelo volcánico','5','158');
INSERT INTO Muestra VALUES(32,'3','2','2','Pasillo 2','2','Suelo con gravas','5','96');
INSERT INTO Muestra VALUES(33,'1','1','1','Pasillo 2','2','Suelo con gravas','6','6');
INSERT INTO Muestra VALUES(34,'1','1','1','Pasillo 4','2','Suelo limoso','7','194');
INSERT INTO Muestra VALUES(35,'2','1','2','Pasillo 4','1','Suelo volcánico','7','27');
INSERT INTO Muestra VALUES(36,'3','1','1','Pasillo 3','1','Suelo con gravas','7','157');
INSERT INTO Muestra VALUES(37,'1','2','1','Pasillo 2','2','Arena naranja','8','198');
INSERT INTO Muestra VALUES(38,'2','2','2','Pasillo 6','1','Suelo volcánico','8','171');
INSERT INTO Muestra VALUES(39,'3','2','2','Pasillo 5','2','Arena naranja','8','193');
INSERT INTO Muestra VALUES(40,'4','2','2','Pasillo 5','2','Suelo volcánico','8','74');


-- Datos estados pagos
INSERT INTO estadoPago VALUES(2,41039047.5,'2019-12-16','2020-08-21');
INSERT INTO estadoPago VALUES(3,0,NULL,'2011-12-31');
INSERT INTO estadoPago VALUES(4,0,NULL,'2013-11-1');
INSERT INTO estadoPago VALUES(5,7524000,'2014-5-8','2014-9-23');
INSERT INTO estadoPago VALUES(6,0,NULL,'2011-9-5');
INSERT INTO estadoPago VALUES(7,0,NULL,'2012-01-24');


----------------------- Datos empleados -----------------------
-- Laboratoristas
INSERT INTO Empleado VALUES(1,'Jesús','Bermúdez','Laboratorista', 1000000, 'empleadoLaboratorista1', 'Sanitas', 'Positiva', 'Colpensiones');

INSERT INTO Empleado VALUES(4,'Isabel','Álvarez','Laboratorista', 1000000, 'empleadoLaboratorista2', 'Sanitas', 'Positiva', 'Colpensiones');

INSERT INTO Empleado VALUES(5,'Paula','Bello','Laboratorista', 2000000, 'empleadoLaboratorista3', 'Compensar', 'Sura', 'Porvenir');

INSERT INTO Empleado VALUES(6,'Javier','Bello','Laboratorista', 3000000, 'empleadoLaboratorista4', 'Sanitas', 'Positiva', 'Colpensiones');

-- Jefe de laboratorio
INSERT INTO Empleado VALUES(2,'Helena','Medina','Jefe Laboratorio', 2000000, 'jefeLaboratorio1', 'Compensar', 'Sura', 'Porvenir');

-- Administrador
INSERT INTO Empleado VALUES(3,'David','Gómez','Administrador', 3000000, 'Administrador1', 'Sanitas', 'Positiva', 'Colpensiones');


-- Datos tipos ensayos
INSERT INTO TipoEnsayo VALUES(1,'Triaxial UU');
INSERT INTO TipoEnsayo VALUES(2,'Triaxial CU');
INSERT INTO TipoEnsayo VALUES(3,'Triaxial CD');
INSERT INTO TipoEnsayo VALUES(4,'Compresión inconfinada');
INSERT INTO TipoEnsayo VALUES(5,'Corte directo');
INSERT INTO TipoEnsayo VALUES(6,'Triaxial cíclico');
INSERT INTO TipoEnsayo VALUES(7,'Columna resonante');
INSERT INTO TipoEnsayo VALUES(8,'Bender element');
INSERT INTO TipoEnsayo VALUES(9,'Consolidación');
INSERT INTO TipoEnsayo VALUES(10,'Expansión libre ');
INSERT INTO TipoEnsayo VALUES(11,'Expansión controlada ');
INSERT INTO TipoEnsayo VALUES(12,'Consolidación en succión controlada');
INSERT INTO TipoEnsayo VALUES(13,'Humedad');
INSERT INTO TipoEnsayo VALUES(14,'Límites');
INSERT INTO TipoEnsayo VALUES(15,'Peso unitario');
INSERT INTO TipoEnsayo VALUES(16,'Granulometría');
INSERT INTO TipoEnsayo VALUES(17,'Hidrometría');


-- Datos ensayos muestras
INSERT INTO EnsayoMuestra VALUES(1,'2020-12-19',0,'Realizar con presiones de 120kPa',6,1,3,3);
INSERT INTO EnsayoMuestra VALUES(2,'2020-12-20',0,'NULL',3,2,13,'3');
INSERT INTO EnsayoMuestra VALUES(3,'2020-12-21',0,'NULL',1,3,4,'3');
INSERT INTO EnsayoMuestra VALUES(4,'2020-12-22',0,'NULL',2,4,15,'3');
INSERT INTO EnsayoMuestra VALUES(5,'2020-12-23',0,'NULL',1,5,5,'3');
INSERT INTO EnsayoMuestra VALUES(6,'2020-12-24',1,'NULL',2,6,17,'3');
INSERT INTO EnsayoMuestra VALUES(7,'2018-12-25',1,'NULL',5,7,17,'3');
INSERT INTO EnsayoMuestra VALUES(8,'2018-12-26',0,'NULL',2,8,8,'3');
INSERT INTO EnsayoMuestra VALUES(9,'2018-12-27',0,'NULL',1,9,9,'3');
INSERT INTO EnsayoMuestra VALUES(10,'2018-12-28',0,'NULL',6,10,3,'3');
INSERT INTO EnsayoMuestra VALUES(11,'2018-12-29',0,'NULL',2,11,2,'3');
INSERT INTO EnsayoMuestra VALUES(12,'2018-12-30',0,'NULL',4,12,15,'3');
INSERT INTO EnsayoMuestra VALUES(13,'2018-12-31',1,'NULL',4,13,12,'3');
INSERT INTO EnsayoMuestra VALUES(14,'2020--01-02',1,'NULL',5,14,9,'3');
INSERT INTO EnsayoMuestra VALUES(15,'2020--01-03',0,'NULL',6,15,4,'3');
INSERT INTO EnsayoMuestra VALUES(16,'2020--01-04',0,'NULL',3,16,16,'3');
INSERT INTO EnsayoMuestra VALUES(17,'2020--01-05',1,'NULL',6,17,11,'3');
INSERT INTO EnsayoMuestra VALUES(18,'2020--01-06',1,'NULL',5,18,16,'3');
INSERT INTO EnsayoMuestra VALUES(19,'2012-01-05',0,'NULL',6,19,2,'3');
INSERT INTO EnsayoMuestra VALUES(20,'2012-01-06',0,'NULL',3,20,13,'3');
INSERT INTO EnsayoMuestra VALUES(21,'2012-01-07',1,'NULL',6,21,12,'3');
INSERT INTO EnsayoMuestra VALUES(22,'2012-01-08',0,'NULL',5,22,4,'3');
INSERT INTO EnsayoMuestra VALUES(23,'2012-01-09',0,'NULL',4,23,12,'3');
INSERT INTO EnsayoMuestra VALUES(24,'2012-01-10',1,'NULL',4,24,13,'3');
INSERT INTO EnsayoMuestra VALUES(25,'2012-01-11',1,'NULL',6,25,9,'3');
INSERT INTO EnsayoMuestra VALUES(26,'2012-01-12',1,'NULL',3,26,1,'3');
INSERT INTO EnsayoMuestra VALUES(27,'2012-01-13',0,'NULL',6,27,9,'3');
INSERT INTO EnsayoMuestra VALUES(28,'2012-01-14',0,'NULL',6,28,7,'3');
INSERT INTO EnsayoMuestra VALUES(29,'2012-01-15',1,'NULL',1,29,12,'3');
INSERT INTO EnsayoMuestra VALUES(30,'2013-11-03',0,'NULL',4,30,3,'3');
INSERT INTO EnsayoMuestra VALUES(31,'2013-11-04',0,'NULL',4,31,8,'3');
INSERT INTO EnsayoMuestra VALUES(32,'2013-11-05',0,'NULL',1,32,8,'3');
INSERT INTO EnsayoMuestra VALUES(33,'2014-10-22',0,'NULL',6,33,4,'3');
INSERT INTO EnsayoMuestra VALUES(34,'2011-09-16',1,'NULL',5,34,16,'3');
INSERT INTO EnsayoMuestra VALUES(35,'2011-09-17',1,'NULL',5,35,9,'3');
INSERT INTO EnsayoMuestra VALUES(36,'2011-09-18',1,'NULL',3,36,13,'3');
INSERT INTO EnsayoMuestra VALUES(37,'2012-10-25',0,'NULL',6,37,3,'3');
INSERT INTO EnsayoMuestra VALUES(38,'2012-10-26',1,'NULL',2,38,8,'3');
INSERT INTO EnsayoMuestra VALUES(39,'2012-10-27',0,'NULL',6,39,5,'3');
INSERT INTO EnsayoMuestra VALUES(40,'2012-10-28',0,'NULL',3,40,7,'3');
INSERT INTO EnsayoMuestra VALUES(41,'2020-12-19',0,'NULL',6,1,2,'3');
INSERT INTO EnsayoMuestra VALUES(42,'2012-01-05',1,'NULL',2,22,15,'3');
INSERT INTO EnsayoMuestra VALUES(43,'2011-09-16',1,'NULL',2,34,6,'3');


-- datos informes finales
INSERT INTO informeFinal VALUES('2018-01-09','NULL','1', 'C:\Users\josel\Documents\Proyecto empresa dbms\git repo\ProyectoBasesDeDatos\Informe Final 1');
INSERT INTO informeFinal VALUES('2020-08-21','NULL','2', 'C:\Users\josel\Documents\Proyecto empresa dbms\git repo\ProyectoBasesDeDatos\Informe Final 2');
INSERT INTO informeFinal VALUES('2011-12-31','NULL','3', 'C:\Users\josel\Documents\Proyecto empresa dbms\git repo\ProyectoBasesDeDatos\Informe Final 3');
INSERT INTO informeFinal VALUES('2013-11-1','NULL','4', 'C:\Users\josel\Documents\Proyecto empresa dbms\git repo\ProyectoBasesDeDatos\Informe Final 4');
INSERT INTO informeFinal VALUES('2014-9-23','NULL','5', 'C:\Users\josel\Documents\Proyecto empresa dbms\git repo\ProyectoBasesDeDatos\Informe Final 5');
INSERT INTO informeFinal VALUES('2011-9-5','NULL','6', 'C:\Users\josel\Documents\Proyecto empresa dbms\git repo\ProyectoBasesDeDatos\Informe Final 6');
INSERT INTO informeFinal VALUES('2012-01-24','NULL','7', 'C:\Users\josel\Documents\Proyecto empresa dbms\git repo\ProyectoBasesDeDatos\Informe Final 7');


-- datos archivos resultado
INSERT INTO ArchivoResultado VALUES('1','C:\Users\josel\Documents\Resultado1','1');
INSERT INTO ArchivoResultado VALUES('2','C:\Users\josel\Documents\Resultado2','1');
INSERT INTO ArchivoResultado VALUES('3','C:\Users\josel\Documents\Resultado3','1');
INSERT INTO ArchivoResultado VALUES('4','C:\Users\josel\Documents\Resultado4','1');
INSERT INTO ArchivoResultado VALUES('5','C:\Users\josel\Documents\Resultado5','1');
INSERT INTO ArchivoResultado VALUES('6','C:\Users\josel\Documents\Resultado6','1');
INSERT INTO ArchivoResultado VALUES('7','C:\Users\josel\Documents\Resultado7','1');
INSERT INTO ArchivoResultado VALUES('8','C:\Users\josel\Documents\Resultado8','1');
INSERT INTO ArchivoResultado VALUES('9','C:\Users\josel\Documents\Resultado9','1');
INSERT INTO ArchivoResultado VALUES('10','C:\Users\josel\Documents\Resultado10','1');
INSERT INTO ArchivoResultado VALUES('11','C:\Users\josel\Documents\Resultado11','1');
INSERT INTO ArchivoResultado VALUES('12','C:\Users\josel\Documents\Resultado12','1');
INSERT INTO ArchivoResultado VALUES('13','C:\Users\josel\Documents\Resultado13','1');
INSERT INTO ArchivoResultado VALUES('14','C:\Users\josel\Documents\Resultado14','2');
INSERT INTO ArchivoResultado VALUES('15','C:\Users\josel\Documents\Resultado15','2');
INSERT INTO ArchivoResultado VALUES('16','C:\Users\josel\Documents\Resultado16','2');
INSERT INTO ArchivoResultado VALUES('17','C:\Users\josel\Documents\Resultado17','2');
INSERT INTO ArchivoResultado VALUES('18','C:\Users\josel\Documents\Resultado18','2');
INSERT INTO ArchivoResultado VALUES('19','C:\Users\josel\Documents\Resultado19','3');
INSERT INTO ArchivoResultado VALUES('20','C:\Users\josel\Documents\Resultado20','3');
INSERT INTO ArchivoResultado VALUES('21','C:\Users\josel\Documents\Resultado21','3');
INSERT INTO ArchivoResultado VALUES('22','C:\Users\josel\Documents\Resultado22','3');
INSERT INTO ArchivoResultado VALUES('23','C:\Users\josel\Documents\Resultado23','3');
INSERT INTO ArchivoResultado VALUES('24','C:\Users\josel\Documents\Resultado24','3');
INSERT INTO ArchivoResultado VALUES('25','C:\Users\josel\Documents\Resultado25','3');
INSERT INTO ArchivoResultado VALUES('26','C:\Users\josel\Documents\Resultado26','3');
INSERT INTO ArchivoResultado VALUES('27','C:\Users\josel\Documents\Resultado27','3');
INSERT INTO ArchivoResultado VALUES('28','C:\Users\josel\Documents\Resultado28','3');
INSERT INTO ArchivoResultado VALUES('29','C:\Users\josel\Documents\Resultado29','3');
INSERT INTO ArchivoResultado VALUES('30','C:\Users\josel\Documents\Resultado30','4');
INSERT INTO ArchivoResultado VALUES('31','C:\Users\josel\Documents\Resultado31','4');
INSERT INTO ArchivoResultado VALUES('32','C:\Users\josel\Documents\Resultado32','4');
INSERT INTO ArchivoResultado VALUES('33','C:\Users\josel\Documents\Resultado33','5');
INSERT INTO ArchivoResultado VALUES('34','C:\Users\josel\Documents\Resultado34','6');
INSERT INTO ArchivoResultado VALUES('35','C:\Users\josel\Documents\Resultado35','6');
INSERT INTO ArchivoResultado VALUES('36','C:\Users\josel\Documents\Resultado36','6');
INSERT INTO ArchivoResultado VALUES('37','C:\Users\josel\Documents\Resultado37','7');
INSERT INTO ArchivoResultado VALUES('38','C:\Users\josel\Documents\Resultado38','7');
INSERT INTO ArchivoResultado VALUES('39','C:\Users\josel\Documents\Resultado39','7');
INSERT INTO ArchivoResultado VALUES('40','C:\Users\josel\Documents\Resultado40','7');
INSERT INTO ArchivoResultado VALUES('41','C:\Users\josel\Documents\Resultado41','1');
INSERT INTO ArchivoResultado VALUES('42','C:\Users\josel\Documents\Resultado42','4');
INSERT INTO ArchivoResultado VALUES('43','C:\Users\josel\Documents\Resultado43','6');