-- Nombres de proyectos hechos para un cliente (para cliente con nombre)

b1=ρ NombreProyecto←pro_nombreProyecto π Proyecto.pro_nombreProyecto (Proyecto ⨝ Proyecto.cli_NIT=Cliente.cli_NIT σ Cliente.cli_razonSocial="Hola" Cliente)

-- Nombres de tipos de ensayos realizados en un proyecto (para proyecto con ID 5) (REV)

b2=ρ NombreEnsayo ← tip_nombreTipoEnsayo π TipoEnsayo.tip_nombreTipoEnsayo  (((σ InformeFinal.pro_idProyecto=5 InformeFinal ⨝  ArchivoResultado) ⨝  EnsayoMuestra) ⨝  TipoEnsayo)

-- Nombres de los tipos de ensayos realizados a una muestra (Para muestra con id 4)

b4=ρ NombreEnsayo←tip_nombreTipoEnsayo π TipoEnsayo.tip_nombreTipoEnsayo  ((σ Muestra.mue_idMuestra=4 Muestra ⨝  EnsayoMuestra) ⨝  TipoEnsayo)

-- Nombre de los ensayos realizados a la muestra anterior y su ejecutor

b5=ρ NombreEnsayo←tip_nombreTipoEnsayo ρ Empleado←emp_nombreEmpleado π TipoEnsayo.tip_nombreTipoEnsayo,Empleado.emp_nombreEmpleado (((σ Muestra.mue_idMuestra=4 Muestra ⨝  EnsayoMuestra) ⨝  TipoEnsayo) ⨝ Empleado)

-- Nombres de proyectos cuyos informes aun no entregados (Cuyos proyectos no han sido pagados)

b6=ρ NombreProyecto←Proyecto.pro_nombreProyecto  π Proyecto.pro_nombreProyecto (( InformeFinal ⨝ Proyecto)⨝ σ EstadoPago.esp_fechaPagoTotal='' EstadoPago)

-- Quien hace un ensayo, estado de los ensayos, ruta del archivo (si fue ejecutado)

b7=ρ NombreEmpleado←Empleado.emp_nombreEmpleado ρ ApellidoEmpleado←Empleado.emp_apellidoEmpleado ρ Estado←EnsayoMuestra.ens_estado ρ Ruta←ArchivoResultado.ens_rutaArchivo π Empleado.emp_nombreEmpleado,Empleado.emp_apellidoEmpleado, EnsayoMuestra.ens_estado, ArchivoResultado.ens_rutaArchivo ((((Proyecto ⨝ Muestra) ⨝EnsayoMuestra)⨝ Empleado)⟕ArchivoResultado)

-- Obtener la suma y promedio de todos los proyectos por Cliente

b8=ρ RazonSocial←cli_razonSocial ρ Resultado π cli_razonSocial,TotalPagado,PromedioProyecto γ cli_NIT,cli_razonSocial;sum(pro_valorTotal)→TotalPagado,avg(pro_valorTotal)→PromedioProyecto (Cliente⟕Proyecto)

-- Obtener el promedio de profundidad de las muestras para cada proyecto

b9=ρ NombreProyecto←Proyecto.pro_nombreProyecto π Proyecto.pro_nombreProyecto,Promedio γ Proyecto.pro_idProyecto,Proyecto.pro_nombreProyecto; avg(Muestra.mue_profundidad)→Promedio (Proyecto⨝Perforacion⨝Muestra)

-- Obtener por localizaciones la cantidad de perforaciones hechas para un proyecto

γ Perforacion.per_localizacion; count(Perfor acion.per_idPerforacion)→Cantidad (Perforacion⨝(σ pro_idProyecto=2 Proyecto))


