USE [risc_2030]
GO
/****** Object:  StoredProcedure [dbo].[proc_joven]    Script Date: 27/08/2020 19:38:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[proc_joven]
	@ano integer,
	@mes integer,
	@id_punto_digitacion varchar(30)
AS
BEGIN

	----------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------ CREAR TABLA TEMPORAL -------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------
	declare @id_punto_digitacion_txt varchar(10);
	--Se declara variable para manejar punto de digitacion

	set @id_punto_digitacion_txt = @id_punto_digitacion+'%';
	--Se concatena para que funcione con like----------------------------------------------------------------------------------------

	IF OBJECT_ID ( 'dbo.joven_tmp','U' ) IS NULL
	CREATE TABLE joven_tmp
	(
		[actividad] [varchar](300) NOT NULL,
		[cod_estab] [varchar](100) NOT NULL,
		[descripcion] [varchar](100) NOT NULL,
		[rango] [varchar](100) NOT NULL,
		[criterio1] [varchar](20),
		[criterio2] [varchar](20),
		[cantidad] [int] NOT NULL,
		id_punto_digitacion int not null
	)

	--------------------------------------------------------------------------------
	-----ELIMINAR DATOS TEMPORALES
	--------------------------------------------------------------------------------
	DELETE from joven_tmp;--------------------------------------------



	--1 


	insert into joven_tmp
	select '1-1-plan de atencion integral elaborado' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('C8002')
		and trim(h.valor_lab) in ('1')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes= @mes
		and h.anio = @ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by 
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion
	;







	--1-2-plan de atencion integral ejecutado 
	--2	



	insert into joven_tmp
	select '1-2-plan de atencion integral ejecutado' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero, '', '',
		count(*) Cantidad  , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('C8002')
		and trim(h.valor_lab) in ('TA')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes= @mes
		and h.anio = @ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by 
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;




	--1-3-Consejeria integral Finalizada 
	--3		




	insert into joven_tmp
	select '1-3-Consejeria integral Finalizada' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero ,
		count(*) Cantidad  , '', '' , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('99401')
		and trim(h.tipo_diagnostico) in ('D')
		and trim(h.valor_lab) in ('TA')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio = @ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by 
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;




	------2--EVALUACION NUTRICIONAL EN JOVENES 18-29 
	------2-1-INDICE DE MASA CORPORAL (IMC)-OBECIDAD  

	--4		



	insert into joven_tmp

	select '2-1-INDICE DE MASA CORPORAL (IMC)-OBECIDAD' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '' ,
		count(*) Cantidad   , h.id_punto_digitacion

	from rpt_plano_cbeta as h, IPRESS as e

	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('E669')
		and trim(h.tipo_diagnostico) in ('D')
		and trim(h.valor_lab) in ('IMC')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio = @ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by 
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	-----2-2-INDICE DE MASA CORPORAL (IMC)-SOBREPESO 
	--5 




	insert into joven_tmp
	select '2-2-INDICE DE MASA CORPORAL (IMC)-SOBREPESO' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '' ,
		count(*) Cantidad , h.id_punto_digitacion
	from rpt_plano_cbeta as h  ,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('E660')
		and trim(h.tipo_diagnostico) in ('D')
		and trim(h.valor_lab) in ('IMC')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by  e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;



	---2-3-INDICE DE MASA CORPORAL (IMC)-NORMAL 
	--6 


	insert into joven_tmp
	select '2-3-INDICE DE MASA CORPORAL (IMC)-NORMAL' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad  , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z006')
		and trim(h.tipo_diagnostico) in ('D')
		and trim(h.valor_lab) in ('IMC')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by 
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	-------2-4-INDICE DE MASA CORPORAL (IMC)-DELGADEZ 
	--7 



	insert into joven_tmp
	select '2-4-INDICE DE MASA CORPORAL (IMC)-DELGADEZ' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad  , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('E440')
		and trim(h.tipo_diagnostico) in ('D')
		and trim(h.valor_lab) in ('IMC')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio = @ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by 
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	---2-5-TALLA/anio_actual_paciente TALLA ALTA			        
	--8	        


	insert into joven_tmp
	select '2-5-TALLA/anio_actual_paciente TALLA ALTA' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad   , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('E344')
		and trim(h.tipo_diagnostico) in ('D')
		and trim(h.valor_lab) in ('TE')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by 
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	---2-6-TALLA/anio_actual_paciente TALLA NORMAL			        

	--9	   


	insert into joven_tmp
	select '2-6-TALLA/anio_actual_paciente TALLA NORMAL' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad   , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z006')
		and trim(h.tipo_diagnostico) in ('D')
		and trim(h.valor_lab) in ('TE')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by 
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	------2-7-TALLA/anio_actual_paciente TALLA BAJA			        
	--10		        


	insert into joven_tmp
	select '2-7-TALLA/anio_actual_paciente TALLA BAJA' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('E45X')
		and trim(h.tipo_diagnostico) in ('D')
		and trim(h.valor_lab) in ('TE')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by 
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	---10 


	---3-0-Prestación de salud Bucal en Jóvenes (Gestantes y no gestantes)	        
	---3-1-EXAMEN ODONTOLOGICO NO GESTANTES INICIAN	 

	--11	        

	insert into joven_tmp
	select '3-1-EXAMEN ODONTOLOGICO NO GESTANTES INICIAN' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z012','D0150','D0120')
		and trim(h.tipo_diagnostico) in ('D')
		and trim(h.valor_lab) in ('1')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio = @ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by 
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	---3-2-EXAMEN ODONTOLOGICO NO GESTANTES tratado 
	--12 


	insert into joven_tmp
	select '3-2-EXAMEN ODONTOLOGICO NO GESTANTES TRATADO' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad  , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z012','D0150','D0120')
		and trim(h.tipo_diagnostico) in ('D')
		and trim(h.valor_lab) in ('2')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by  e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	--3-3-EXAMEN ODONTOLOGICO  GESTANTES INICIAN 

	--13        

	insert into joven_tmp
	select '3-3-EXAMEN ODONTOLOGICO  GESTANTES INICIAN' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad   , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z012','D0150','D0120')
		and trim(h.tipo_diagnostico) in ('D')
		and trim(h.valor_lab) in ('1')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and trim(h.genero) in ('F')
		and h.mes = @mes
		and h.anio = @ano
		and h.id_cita in(select h1.id_cita
		from rpt_plano_cbeta h1
		where trim(h1.valor_lab) in ('G')
			and h1.mes = @mes
			and h1.anio = @ano   
				    
				)
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by 
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;



	--3-4-EXAMEN ODONTOLOGICO  GESTANTES tratado 
	--14 


	insert into joven_tmp
	select '3-4-EXAMEN ODONTOLOGICO  GESTANTES TRATADO' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad   , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z012','D0150','D0120')
		and trim(h.tipo_diagnostico) in ('D')
		and trim(h.valor_lab) in ('2')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and trim(h.genero) in ('F')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_cita in(select h1.id_cita
		from rpt_plano_cbeta h1
		where trim(h1.valor_lab) in ('G')
			and h1.mes = @mes
			and h1.anio=@ano       
				)
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by 
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;




	--3-5-Instrucción de Higiene Oral inician 	 
	--15 
	insert into joven_tmp
	select '3-5-Instrucción de Higiene Oral inician' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad  , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('D1330','U540')
		and trim(h.tipo_diagnostico) in ('D')
		and trim(h.valor_lab) in ('1')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by 
		 e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	----3-6-Instrucción de Higiene Oral Tratado 	 
	--16	 
	insert into joven_tmp
	select '3-6-Instrucción de Higiene Oral tratado' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad  , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('D1330','U540')
		and trim(h.tipo_diagnostico) in ('D')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.valor_lab) in ('2')
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by  
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	--3-7-Asesoría nutricional para el control de enfermanio_actual_pacientees dentales inician	 
	--17	 

	insert into joven_tmp
	select '3-7-Asesoría nutricional para el control de enfermanio_actual_pacientees dentales inician' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad  , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('D1310')
		and trim(h.tipo_diagnostico) in ('D')
		and trim(h.valor_lab) in ('1')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;



	---3-8-Asesoría nutricional para el control de enfermanio_actual_pacientees dentales tratado	 
	--18	 
	insert into joven_tmp
	select '3-8-Asesoría nutricional para el control de enfermanio_actual_pacientees dentales tratado' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad   , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('D1310')
		and trim(h.tipo_diagnostico) in ('D')
		and trim(h.valor_lab) in ('2')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by  e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	--3-9-Alta Basica Odontologica (ABO) no gestantes 
	--19 


	insert into joven_tmp
	select '3-9-Alta Basica Odontologica (ABO) no gestantes' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad  , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('U510')
		and trim(h.tipo_diagnostico) in ('D')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by  e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	--3-10-Alta Basica Odontologica (ABO)  gestantes 
	--20		        
	insert into joven_tmp
	select '3-10-Alta Basica Odontologica (ABO)  gestantes' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad  , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('U510')
		and trim(h.tipo_diagnostico) in ('D')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and trim(h.genero) in ('F')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
		and h.id_cita in(select h1.id_cita
		from rpt_plano_cbeta h1
		where trim(h1.valor_lab) in ('G')
			and h1.mes = @mes
			and h1.anio=@ano       
				)
	group by 
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	--20 

	---------4-0--Detección de Enfermanio_actual_pacientees No Transmisibles  en Jóvenes		 
	---------4-1-VALORACION CLINICA DE FACTORES DE RIESGO 	        

	--21	        

	insert into joven_tmp
	select '4-1-VALORACION CLINICA DE FACTORES DE RIESGO' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad   , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z019')
		AND trim(h.valor_lab) in ('DNT')
		and trim(h.tipo_diagnostico) in ('D')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by  
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	---4-2-SEDENTARISMO  
	--22		        
	insert into joven_tmp
	select '4-2-SEDENTARISMO' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad   , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z723')
		and trim(h.tipo_diagnostico) in ('D')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by  
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	---4-3-DISLIPIDEMIA  
	--23 

	insert into joven_tmp
	select '4-3-DISLIPIDEMIA' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad   , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('E785')
		and trim(h.tipo_diagnostico) in ('D')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by  
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;



	--4-4-Glisemia basal alterada (de 100 a 139 mg/dl) - Prediabetes 
	--24 


	insert into joven_tmp
	select '4-4-Glisemia basal alterada (de 100 a 139 mg/dl) - Prediabetes' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad   , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('R739')
		and trim(h.tipo_diagnostico) in ('D')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by  
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	--4-5-Tolerancia a la glucosa alterada (de 140 a 199 mg/dl) - Prediabetes 
	--25 

	insert into joven_tmp
	select '4-5-Tolerancia a la glucosa alterada (de 140 a 199 mg/dl) - Prediabetes' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad  , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('R730')
		and trim(h.tipo_diagnostico) in ('D')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by  
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;



	--4-6-EXAMEN DE HEMOGLOBINA	 
	--26	        

	insert into joven_tmp
	select '4-6-EXAMEN DE HEMOGLOBINA' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad   , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z017')
		and trim(h.tipo_diagnostico) in ('D')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by  e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	--5-0-Prestaciones de Salud Sexual y Reproductiva en Jóvenes		 
	--5-1-Consejería para la prevención de ITS 1RA SESION 
	--27 

	insert into joven_tmp
	select '5-1-Consejería para la prevención de ITS 1RA SESION' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad  , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('U130')
		and trim(h.tipo_diagnostico) in ('D')
		and trim(h.valor_lab) in ('1')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by  e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;



	----5-2-Consejería para la prevención de ITS 2DA SESION 
	--28 

	insert into joven_tmp
	select '5-2-Consejería para la prevención de ITS 2DA SESION' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad  , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('U130')
		and trim(h.tipo_diagnostico) in ('D')
		and trim(h.valor_lab) in ('2')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by  e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	---5-3-Consejería para la prevención de ITS 3RA SESION 
	--29 

	insert into joven_tmp
	select '5-3-Consejería para la prevención de ITS 3RA SESION' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad  , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('U130')
		and trim(h.tipo_diagnostico) in ('D')
		and trim(h.valor_lab) in ('3')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by  e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	--5-4-Nº de personas tamizadas para VIH (incluye datos de ESNSSR y ESN TB)		        
	--30 

	insert into joven_tmp
	select '5-4-Nº de personas tamizadas para VIH (incluye datos de ESNSSR y ESN TB)' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad  , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z7172','Z7173')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by  e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	--5-5-Nº de personas tamizadas para VIH con resultado reactivo (incuye datos de ESNSSR y ESN TB)	 
	--31 

	insert into joven_tmp
	select '5-5-Nº de personas tamizadas para VIH con resultado reactivo (incuye datos de ESNSSR y ESN TB)' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad  , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z7172')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by  e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	--5-6-Gestantes Atendidas (1º Control Prenatal)en 1º Trimestre de Gestación 
	--32 

	insert into joven_tmp
	select '5-6-Gestantes Atendidas (1º Control Prenatal)en 1º Trimestre de Gestación' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad  , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z3591','Z3491')
		and trim(h.valor_lab) in ('1')
		and trim(h.genero) in ('F')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by  e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	--5-7-Gestantes Atendidas (1º Control Prenatal)en 2º Trimestre de Gestación 
	--33 

	insert into joven_tmp
	select '5-7-Gestantes Atendidas (1º Control Prenatal)en 2º Trimestre de Gestación' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad  , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z3592','Z3492')
		and trim(h.valor_lab) in ('1')
		and trim(h.genero) in ('F')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by  e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	--5-8-Gestantes Atendidas (1º Control Prenatal)en 3º Trimestre de Gestación 
	--34 

	insert into joven_tmp
	select '5-8-Gestantes Atendidas (1º Control Prenatal)en 3º Trimestre de Gestación' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad   , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z3593','Z3493')
		and trim(h.valor_lab) in ('1')
		and trim(h.genero) in ('F')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by  e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	--5-9-Gestantes Controladas (6º Control Prenatal)		        
	--35	        

	insert into joven_tmp
	select '5-9-Gestantes Controladas (6º Control Prenatal)' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad   , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z3491','Z3491','Z3493','Z3591','Z3592','Z3593')
		and trim(h.valor_lab) in ('6')
		and trim(h.genero) in ('F')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by  e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	--5-10-Gestantes con atención prenatal reenfocada		        

	--36	        
	insert into joven_tmp
	select '5-10-Gestantes con atención prenatal reenfocada' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad   , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z359','Z3591','Z3592','Z3593','Z3491','Z3492','Z3493')
		and trim(h.tipo_diagnostico) in ('D')
		and trim(h.genero) in ('F')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.valor_lab) in ('6')
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_cita in(select h1.id_cita
		from rpt_plano_cbeta h1
		where trim(h1.valor_lab) in ('TA')
			and h1.mes = @mes
			and h1.anio=@ano       
				) and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by  e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	--5-11-Suplementación con Sulfato Ferroso en Gestantes	 
	--37 

	---(TD=D + DX=Z359 / Z3591 / Z3592 / Z3593 / Z3491 / Z3492 / Z3493) + (TD=D + DX=Z298 + Lab=SF6)    

	insert into joven_tmp
	select '5-11-Suplementación con Sulfato Ferroso en Gestantes' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad  , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z359','Z3591','Z3592','Z3593','Z3491','Z3492','Z3493')
		and trim(h.tipo_diagnostico) in ('D')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and trim(h.genero) in ('F')
		and h.mes = @mes
		and h.anio = @ano
		and h.id_cita in(select h1.id_cita
		from rpt_plano_cbeta h1
		where  trim(h1.codigo_item)  in ('Z298')
			and trim(h1.tipo_diagnostico) in ('D')
			and trim(h1.valor_lab) in ('SF6')
			and h1.mes = @mes
			and h1.anio = @ano  
					 
					      
				) and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by  e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	--5-12-Suplementación con Ácido Fólico en Gestantes		        
	--38	        


	insert into joven_tmp
	select '5-12-Suplementación con Ácido Fólico en Gestantes' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad   , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z359','Z3591','Z3592','Z3593','Z3491','Z3492','Z3493')
		and trim(h.tipo_diagnostico) in ('D')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_cita in(select h1.id_cita
		from rpt_plano_cbeta h1
		where  trim(h1.codigo_item)  in ('Z298')
			and trim(h1.tipo_diagnostico) in ('D')
			and trim(h1.valor_lab) in ('AF3')
			and h1.mes = @mes
			and h1.anio=@ano  
					 
				) and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by  e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	--5-13-PARTO 
	--39	        
	insert into joven_tmp
	select '5-13-PARTO' Actividad,

		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad  , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('O800','O801','O808','O809')
		and trim(h.tipo_diagnostico) in ('D')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio = @ano
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by  e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	--5-14-TOMA DE PAP	 
	--40        

	insert into joven_tmp
	select '5-14-TOMA DE PAP' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad  , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z359')
		and trim(h.tipo_diagnostico) in ('D')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_cita in(select h1.id_cita
		from rpt_plano_cbeta h1
		where  trim(h1.codigo_item)  in ('88141')
			and trim(h1.valor_lab) in ('PV','PC')
			and h1.mes = @mes
			and h1.anio=@ano  
					 
				)
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by  e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;



	--5-15-Entrega de Resultados PAP		        
	--41	        

	insert into joven_tmp
	select '5-15-Entrega de Resultados PAP' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('U2601')
		and trim(h.tipo_diagnostico) in ('D')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
	group by 
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	--5-16-Resultado positivo de PAP (Gestantes) 

	--42 

	insert into joven_tmp
	select '5-16-Resultado positivo de PAP (Gestantes)' Actividad,

		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		sum(CONVERT(int,h.valor_lab)) Cantidad  , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	 
		(         
					h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('U2601')
		and trim(h.tipo_diagnostico) in ('D')
		and h.anio_actual_paciente between 18 and 29
		and (h.tipo_edad) = 'A'
		and h.mes = @mes
		and h.anio=@ano
		and h.id_cita in(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=2
			and trim(h1.codigo_item) in ('D060', 'D061', 'D069', 'N879', 'N870', 'N871', 'N872')
			and trim(h1.valor_lab) in ('G')
			and h1.mes = @mes
			and h1.anio=@ano       
								)         
					 
					         
				)
		or
		(         
					h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z359')
		and trim(h.tipo_diagnostico) in ('D')
		and h.anio_actual_paciente between 18 and 29
		and (h.tipo_edad) = 'A'
		and h.mes = @mes
		and h.anio=@ano
		and h.id_cita in(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=2
			and trim(h1.codigo_item) in ('U2601')
			and h1.mes = @mes
			and h1.anio=@ano         
								)
		and h.id_cita in(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=2
			and trim(h1.codigo_item) in ('D060', 'D061', 'D069', 'N879', 'N870', 'N871', 'N872')
			and h1.mes = @mes
			and h1.anio=@ano         
								)					         
				)
	group by 
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;




	--5-17-Consejeria y orientacion general para Planificación Familiar		        


	--43	        
	insert into joven_tmp
	select '5-17-Consejeria y orientacion general para Planificación Familiar' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad   , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z0031','99402')
		and trim(h.valor_lab) in ('1')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio = @ano
	group by 
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	--6-METODO DE PLANIFICACION FAMILIAR EN JOVENES  
	--6-1. DIU - Atenciones - Nueva - 18 and 29    

	--44     
	insert into joven_tmp
	select '6-1. DIU - Atenciones - Nueva - 18 and 29' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad  , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('58300')
		and h.tipo_diagnostico='D'
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and trim(h.genero) in ('F')
		and h.mes= @mes
		and h.anio = @ano
	group by 
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	--6-2. DIU - Atenciones - Continuadora - 18 and 29   

	--45             
	insert into joven_tmp
	select '6-2. DIU - Atenciones - Continuadora - 18 and 29' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad  , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z305')
		and h.tipo_diagnostico='D'
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and trim(h.genero) in ('F')
		and h.mes = @mes
		and h.anio=@ano
	group by 
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	----6-3 DIU - Insumos - Nueva - 18 and 29    

	--46   
	insert into joven_tmp
	select '6-3 DIU - Insumos - Nueva - 18 and 29' Actividad,

		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		sum(CONVERT(int,h.valor_lab)) Cantidad  , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	        
				(        
					h.codigo_unico=e.COD_IPRESS
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and trim(h.genero) in ('F')
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=2
		and trim(h.valor_lab) in ('1')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=1
			and trim(h1.codigo_item) in ('58300')
			and h1.tipo_diagnostico='D'
			and h1.anio_actual_paciente between 18 and 29
			and trim(h1.tipo_edad)='A'
			and h1.mes=@mes
			and h1.anio=@ano      
								)        
				)
		or
		(        
					h.codigo_unico=e.COD_IPRESS
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and trim(h.genero) in ('F')
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=3
		and trim(h.valor_lab) in ('1')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=2
			and trim(h1.codigo_item) in ('58300')
			and h1.tipo_diagnostico='D'
			and h1.anio_actual_paciente between 18 and 29
			and trim(h1.tipo_edad)='A'
			and h1.mes=@mes
			and h1.anio=@ano      
								)        
				)
		or
		(        
					h.codigo_unico=e.COD_IPRESS
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and trim(h.genero) in ('F')
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=4
		and trim(h.valor_lab) in ('1')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=3
			and trim(h1.codigo_item) in ('58300')
			and h1.tipo_diagnostico='D'
			and h1.anio_actual_paciente between 18 and 29
			and trim(h1.tipo_edad)='A'
			and h1.mes=@mes
			and h1.anio=@ano      
								)        
				)
		or
		(        
					h.codigo_unico=e.COD_IPRESS
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and trim(h.genero) in ('F')
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=5
		and trim(h.valor_lab) in ('1')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=4
			and trim(h1.codigo_item) in ('58300')
			and h1.tipo_diagnostico='D'
			and h1.anio_actual_paciente between 18 and 29
			and trim(h1.tipo_edad)='A'
			and h1.mes=@mes
			and h1.anio=@ano       
								)        
				)
		or
		(        
					h.codigo_unico=e.COD_IPRESS
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and trim(h.genero) in ('F')
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=6
		and trim(h.valor_lab) in ('1')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=5
			and trim(h1.codigo_item) in ('58300')
			and h1.tipo_diagnostico='D'
			and h1.anio_actual_paciente between 18 and 29
			and trim(h1.tipo_edad)='A'
			and h1.mes=@mes
			and h1.anio=@ano        
								)        
				)
	group by 
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	--6-4. DIU - Insumos - Continuadora - 18 and 29   


	--47           
	insert into joven_tmp
	select '6-4. DIU - Insumos - Continuadora - 18 and 29' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero, '', '',
		sum(CONVERT(int,h.valor_lab)) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	        
				(        
					h.codigo_unico=e.COD_IPRESS
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and trim(h.genero) in ('F')
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=2
		and trim(h.valor_lab) in ('1')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=1
			and trim(h1.codigo_item) in ('Z305')
			and h1.tipo_diagnostico='D'
			and h1.anio_actual_paciente between 18 and 29
			and trim(h1.tipo_edad)='A'
			and h1.mes=@mes
			and h1.anio=@ano        
								)        
				)
		or
		(        
					h.codigo_unico=e.COD_IPRESS
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and trim(h.genero) in ('F')
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=3
		and trim(h.valor_lab) in ('1')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=2
			and trim(h1.codigo_item) in ('Z305')
			and h1.tipo_diagnostico='D'
			and h1.anio_actual_paciente between 18 and 29
			and trim(h1.tipo_edad)='A'
			and h1.mes=@mes
			and h1.anio=@ano        
								)        
				)
		or
		(        
					h.codigo_unico=e.COD_IPRESS
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and trim(h.genero) in ('F')
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=4
		and trim(h.valor_lab) in ('1')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=3
			and trim(h1.codigo_item) in ('Z305')
			and h1.tipo_diagnostico='D'
			and h1.anio_actual_paciente between 18 and 29
			and trim(h1.tipo_edad)='A'
			and h1.mes=@mes
			and h1.anio=@ano        
								)        
				)
		or
		(        
					h.codigo_unico=e.COD_IPRESS
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and trim(h.genero) in ('F')
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=5
		and trim(h.valor_lab) in ('1')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=4
			and trim(h1.codigo_item) in ('Z305')
			and h1.tipo_diagnostico='D'
			and h1.anio_actual_paciente between 18 and 29
			and trim(h1.tipo_edad)='A'
			and h1.mes=@mes
			and h1.anio=@ano        
								)        
				)
		or
		(        
					h.codigo_unico=e.COD_IPRESS
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and trim(h.genero) in ('F')
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=6
		and trim(h.valor_lab) in ('1')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=5
			and trim(h1.codigo_item) in ('Z305')
			and h1.tipo_diagnostico='D'
			and h1.anio_actual_paciente between 18 and 29
			and trim(h1.tipo_edad)='A'
			and h1.mes=@mes
			and h1.anio=@ano        
								)        
				)
	group by 
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	----6-5-HORMONAL ORAL COMBINADO  - Nueva - 18 and 29  

	--48     

	insert into joven_tmp
	select '6-5-HORMONAL ORAL COMBINADO  - Nueva - 18 and 29' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad  , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	        
				h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z3003')
		and h.tipo_diagnostico='D'
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and trim(h.genero) in ('F')
		and h.mes=@mes
		and h.anio=@ano
	group by 
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;
	------------6-6 HORMONAL - ORAL - COMBINADO - Atenciones - Continuadora - 18 and 29  

	--49             
	insert into joven_tmp
	select '6-6 HORMONAL - ORAL - COMBINADO - Atenciones - Continuadora - 18 and 29' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 					        
				h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z3043')
		and h.tipo_diagnostico='D'
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and trim(h.genero) in ('F')
		and h.mes=@mes
		and h.anio=@ano
	group by 
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

--6-7. HORMONAL - ORAL - COMBINADO - Insumos - Nueva - 18 and 29      

--50     

		insert into joven_tmp        
		select '6-7-HORMONAL - ORAL - COMBINADO - Insumos - Nueva - 18 and 29' Actividad,        
			      
			e.COD_IPRESS,e.NOMBRE,h.genero ,'','',        
			sum(CONVERT(int,h.valor_lab)) Cantidad,h.id_punto_digitacion        
			from 	rpt_plano_cbeta as h,         
				IPRESS as e 
			where 	        
				(        
					h.codigo_unico=e.COD_IPRESS              
					and h.anio_actual_paciente between 18 and 29        
					and trim(h.tipo_edad)='A'        
					and trim(h.genero) in ('F')				        
					and h.mes=@mes        
					and h.anio=@ano        
					and h.orden_atencion=2        
					and trim(h.valor_lab) in ('1')        
					and h.id_cita in	(select h1.id_cita        
									from rpt_plano_cbeta h1        
									where 	h1.orden_atencion=1        
										and trim(h1.codigo_item) in ('Z3003') 
										and h1.tipo_diagnostico='D'  									       									        
										and h1.anio_actual_paciente between 18 and 29        
										and trim(h1.tipo_edad)='A'             
										and h1.mes=@mes        
										and h1.anio=@ano        
								)        
				)        
				or        
				(        
					h.codigo_unico=e.COD_IPRESS              
					and h.anio_actual_paciente between 18 and 29        
					and trim(h.tipo_edad)='A'        
					and trim(h.genero) in ('F')				        
					and h.mes=@mes        
					and h.anio=@ano        
					and h.orden_atencion=3        
					and trim(h.valor_lab) in ('1')        
					and h.id_cita in	(select h1.id_cita        
									from rpt_plano_cbeta h1        
									where 	h1.orden_atencion=2        
										and trim(h1.codigo_item) in ('Z3003') 
										and h1.tipo_diagnostico='D'  									       									        
										and h1.anio_actual_paciente between 18 and 29        
										and trim(h1.tipo_edad)='A'            
										and h1.mes=@mes        
										and h1.anio=@ano        
								)        
				)        
				or        
				(        
					h.codigo_unico=e.COD_IPRESS              
					and h.anio_actual_paciente between 18 and 29        
					and trim(h.tipo_edad)='A'        
					and trim(h.genero) in ('F')				        
					and h.mes=@mes        
					and h.anio=@ano        
					and h.orden_atencion=4        
					and trim(h.valor_lab) in ('1')        
					and h.id_cita in	(select h1.id_cita        
									from rpt_plano_cbeta h1        
									where 	h1.orden_atencion=3        
										and trim(h1.codigo_item) in ('Z3003') 
										and h1.tipo_diagnostico='D'  									       									        
										and h1.anio_actual_paciente between 18 and 29        
										and trim(h1.tipo_edad)='A'           
										and h1.mes=@mes        
										and h1.anio=@ano        
								)        
				)        
				or        
				(        
					h.codigo_unico=e.COD_IPRESS              
					and h.anio_actual_paciente between 18 and 29        
					and trim(h.tipo_edad)='A'        
					and trim(h.genero) in ('F')				        
					and h.mes=@mes        
					and h.anio=@ano        
					and h.orden_atencion=5        
					and trim(h.valor_lab) in ('1')        
					and h.id_cita in	(select h1.id_cita        
									from rpt_plano_cbeta h1        
									where 	h1.orden_atencion=4        
										and trim(h1.codigo_item) in ('Z3003') 
										and h1.tipo_diagnostico='D'  									       									        
										and h1.anio_actual_paciente between 18 and 29        
										and trim(h1.tipo_edad)='A'           
										and h1.mes=@mes        
										and h1.anio=@ano        
								)        
				)        
				or        
				(        
					h.codigo_unico=e.COD_IPRESS              
					and h.anio_actual_paciente between 18 and 29        
					and trim(h.tipo_edad)='A'        
					and trim(h.genero) in ('F')				        
					and h.mes=@mes        
					and h.anio=@ano        
					and h.orden_atencion=6        
					and trim(h.valor_lab) in ('1')        
					and h.id_cita in	(select h1.id_cita        
									from rpt_plano_cbeta h1        
									where 	h1.orden_atencion=5        
										and trim(h1.codigo_item) in ('Z3003') 
										and h1.tipo_diagnostico='D'  									       									        
										and h1.anio_actual_paciente between 18 and 29        
										and trim(h1.tipo_edad)='A'              
										and h1.mes=@mes        
										and h1.anio=@ano        
								)        
				)						        
				group by 
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion; 
 

				       
	----6-8-. HORMONAL - ORAL - COMBINADO - Insumos - Continuadora - 18 and 29   
 
	--51            
		insert into joven_tmp        
		select '6-8-. HORMONAL - ORAL - COMBINADO - Insumos - Continuadora - 18 and 29' Actividad,        
	     
			e.COD_IPRESS,e.NOMBRE,h.genero , '','',       
			sum(CONVERT(int,h.valor_lab)) Cantidad,h.id_punto_digitacion        
			from 	rpt_plano_cbeta as h,         
				IPRESS as e 
			where 	        
				(        
					h.codigo_unico=e.COD_IPRESS              
					and h.anio_actual_paciente between 18 and 29        
					and trim(h.tipo_edad)='A'        
					and trim(h.genero) in ('F')				        
					and h.mes=@mes        
					and h.anio=@ano        
					and h.orden_atencion=2        
					and trim(h.valor_lab) in ('4')        
					and h.id_cita in	(select h1.id_cita        
									from rpt_plano_cbeta h1        
									where 	h1.orden_atencion=1        
										and trim(h1.codigo_item) in ('Z3043') 
										and h1.tipo_diagnostico='D'  									       									        
										and h1.anio_actual_paciente between 18 and 29        
										and trim(h1.tipo_edad)='A'       
										and h1.mes=@mes        
										and h1.anio=@ano        
								)        
				)        
				or        
				(        
					h.codigo_unico=e.COD_IPRESS              
					and h.anio_actual_paciente between 18 and 29        
					and trim(h.tipo_edad)='A'        
					and trim(h.genero) in ('F')				        
					and h.mes=@mes        
					and h.anio=@ano        
					and h.orden_atencion=3        
					and trim(h.valor_lab) in ('4')        
					and h.id_cita in	(select h1.id_cita        
									from rpt_plano_cbeta h1        
									where 	h1.orden_atencion=2        
										and trim(h1.codigo_item) in ('Z3043') 
										and h1.tipo_diagnostico='D'  									       									        
										and h1.anio_actual_paciente between 18 and 29        
										and trim(h1.tipo_edad)='A'        
										and h1.mes=@mes        
										and h1.anio=@ano        
								)        
				)        
				or        
				(        
					h.codigo_unico=e.COD_IPRESS              
					and h.anio_actual_paciente between 18 and 29        
					and trim(h.tipo_edad)='A'        
					and trim(h.genero) in ('F')				        
					and h.mes=@mes        
					and h.anio=@ano        
					and h.orden_atencion=4        
					and trim(h.valor_lab) in ('4')        
					and h.id_cita in	(select h1.id_cita        
									from rpt_plano_cbeta h1        
									where 	h1.orden_atencion=3        
										and trim(h1.codigo_item) in ('Z3043') 
										and h1.tipo_diagnostico='D'  									       									        
										and h1.anio_actual_paciente between 18 and 29        
										and trim(h1.tipo_edad)='A'        
										and h1.mes=@mes        
										and h1.anio=@ano        
								)        
				)        
				or        
				(        
					h.codigo_unico=e.COD_IPRESS              
					and h.anio_actual_paciente between 18 and 29        
					and trim(h.tipo_edad)='A'        
					and trim(h.genero) in ('F')				        
					and h.mes=@mes        
					and h.anio=@ano        
					and h.orden_atencion=5        
					and trim(h.valor_lab) in ('4')        
					and h.id_cita in	(select h1.id_cita        
									from rpt_plano_cbeta h1        
									where 	h1.orden_atencion=4        
										and trim(h1.codigo_item) in ('Z3043') 
										and h1.tipo_diagnostico='D'  									       									        
										and h1.anio_actual_paciente between 18 and 29        
										and trim(h1.tipo_edad)='A'        
										and h1.mes=@mes        
										and h1.anio=@ano        
								)        
				)        
				or        
				(        
					h.codigo_unico=e.COD_IPRESS               
					and h.anio_actual_paciente between 18 and 29        
					and trim(h.tipo_edad)='A'        
					and trim(h.genero) in ('F')				        
					and h.mes=@mes        
					and h.anio=@ano        
					and h.orden_atencion=6        
					and trim(h.valor_lab) in ('4')        
					and h.id_cita in	(select h1.id_cita        
									from rpt_plano_cbeta h1        
									where 	h1.orden_atencion=5        
										and trim(h1.codigo_item) in ('Z3043') 
										and h1.tipo_diagnostico='D'  									       									        
										and h1.anio_actual_paciente between 18 and 29        
										and trim(h1.tipo_edad)='A'       
										and h1.mes=@mes        
										and h1.anio=@ano        
								)       
				)			        
				group by 
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion; 
 
 
 
	 
 
---6-9- HORMONAL - INYECTABLE - TRIMESTRAL - Atenciones - Nueva - 18 and 29   
 
--52           
		insert into joven_tmp        
		select '6-9- HORMONAL - INYECTABLE - TRIMESTRAL - Atenciones - Nueva - 18 and 29' Actividad,        
			e.COD_IPRESS,e.NOMBRE,h.genero ,   '','',    
			count(*) Cantidad  ,    h.id_punto_digitacion    
			from 	rpt_plano_cbeta as h,         
				IPRESS as e 
			where 	        
				h.codigo_unico=e.COD_IPRESS              
				and trim(h.codigo_item) in ('Z30052')  
				and h.tipo_diagnostico='D'        
				and h.anio_actual_paciente between 18 and 29        
				and trim(h.tipo_edad)='A'        
				and trim(h.genero) in ('F')        
				and h.mes=@mes     
				and h.anio=@ano     			        
				group by 
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;        
     ---6-10. HORMONAL - INYECTABLE - TRIMESTRAL - Atenciones - Continuadora - 18 and 29    
 
     --53           
		insert into joven_tmp        
		select '6-10. HORMONAL - INYECTABLE - TRIMESTRAL - Atenciones - Continuadora - 18 and 29' Actividad,		        
			e.COD_IPRESS,e.NOMBRE,h.genero ,   '','',    
			count(*) Cantidad  ,   h.id_punto_digitacion    
			from 	rpt_plano_cbeta as h,         
				IPRESS as e 
			where h.codigo_unico=e.COD_IPRESS		             
				and trim(h.codigo_item) in ('Z30452') 
				and h.tipo_diagnostico='D' 				        
				and h.anio_actual_paciente between 18 and 29        
				and trim(h.tipo_edad)='A'        
				and trim(h.genero) in ('F')            
				and h.mes = @mes        
				and h.anio=@ano        
				group by 
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;   
 
 
 
------------------------ 
-----6-11. HORMONAL - INYECTABLE - TRIMESTRAL - Insumos - Nueva - 18 and 29    
 
--54          
		insert into joven_tmp        
		select '6-11. HORMONAL - INYECTABLE - TRIMESTRAL - Insumos - Nueva - 18 and 29' Actividad,        
		     
			e.COD_IPRESS,e.NOMBRE,h.genero , '','',       
			sum(CONVERT(int,h.valor_lab)) Cantidad,h.id_punto_digitacion        
			from 	rpt_plano_cbeta as h,         
				IPRESS as e 
			where 	        
				(        
					h.codigo_unico=e.COD_IPRESS              
					and h.anio_actual_paciente between 18 and 29        
					and trim(h.tipo_edad)='A'        
					and trim(h.genero) in ('F')				        
					and h.mes=@mes        
					and h.anio=@ano        
					and h.orden_atencion=2        
					and trim(h.valor_lab) in ('1')        
					and h.id_cita in	(select h1.id_cita        
									from rpt_plano_cbeta h1        
									where 	h1.orden_atencion=1        
										and trim(h1.codigo_item) in ('Z30052') 
										and h1.tipo_diagnostico='D'  									       									        
										and h1.anio_actual_paciente between 18 and 29        
										and trim(h1.tipo_edad)='A'             
										and h1.mes=@mes        
										and h1.anio=@ano        
								)        
				)        
				or        
				(        
					h.codigo_unico=e.COD_IPRESS              
					and h.anio_actual_paciente between 18 and 29        
					and trim(h.tipo_edad)='A'        
					and trim(h.genero) in ('F')				        
					and h.mes=@mes        
					and h.anio=@ano        
					and h.orden_atencion=3        
					and trim(h.valor_lab) in ('1')        
					and h.id_cita in	(select h1.id_cita        
									from rpt_plano_cbeta h1        
									where 	h1.orden_atencion=2        
										and trim(h1.codigo_item) in ('Z30052') 
										and h1.tipo_diagnostico='D'  									       									        
										and h1.anio_actual_paciente between 18 and 29        
										and trim(h1.tipo_edad)='A'            
										and h1.mes=@mes        
										and h1.anio=@ano        
								)        
				)        
				or        
				(        
					h.codigo_unico=e.COD_IPRESS              
					and h.anio_actual_paciente between 18 and 29        
					and trim(h.tipo_edad)='A'        
					and trim(h.genero) in ('F')				        
					and h.mes=@mes        
					and h.anio=@ano        
					and h.orden_atencion=4        
					and trim(h.valor_lab) in ('1')        
					and h.id_cita in	(select h1.id_cita        
									from rpt_plano_cbeta h1        
									where 	h1.orden_atencion=3        
										and trim(h1.codigo_item) in ('Z30052') 
										and h1.tipo_diagnostico='D'  									       									        
										and h1.anio_actual_paciente between 18 and 29        
										and trim(h1.tipo_edad)='A'           
										and h1.mes=@mes        
										and h1.anio=@ano        
								)        
				)        
				or        
				(        
					h.codigo_unico=e.COD_IPRESS              
					and h.anio_actual_paciente between 18 and 29        
					and trim(h.tipo_edad)='A'        
					and trim(h.genero) in ('F')				        
					and h.mes=@mes        
					and h.anio=@ano        
					and h.orden_atencion=5        
					and trim(h.valor_lab) in ('1')        
					and h.id_cita in	(select h1.id_cita        
									from rpt_plano_cbeta h1        
									where 	h1.orden_atencion=4        
										and trim(h1.codigo_item) in ('Z30052') 
										and h1.tipo_diagnostico='D'  									       									        
										and h1.anio_actual_paciente between 18 and 29        
										and trim(h1.tipo_edad)='A'           
										and h1.mes=@mes        
										and h1.anio=@ano        
								)        
				)        
				or        
				(        
					h.codigo_unico=e.COD_IPRESS              
					and h.anio_actual_paciente between 18 and 29        
					and trim(h.tipo_edad)='A'        
					and trim(h.genero) in ('F')				        
					and h.mes=@mes        
					and h.anio=@ano        
					and h.orden_atencion=6        
					and trim(h.valor_lab) in ('1')        
					and h.id_cita in	(select h1.id_cita        
									from rpt_plano_cbeta h1        
									where 	h1.orden_atencion=5        
										and trim(h1.codigo_item) in ('Z30052') 
										and h1.tipo_diagnostico='D'  									       									        
										and h1.anio_actual_paciente between 18 and 29        
										and trim(h1.tipo_edad)='A'              
										and h1.mes=@mes        
										and h1.anio=@ano        
								)        
				)						        
				group by 
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion; 
				       
	---6-12. HORMONAL - INYECTABLE - TRIMESTRAL - Insumos - Continuadora - 18 and 29  
 
	--55  
           
		insert into joven_tmp        
		select '6-12. HORMONAL - INYECTABLE - TRIMESTRAL - Insumos - Continuadora - 18 and 29' Actividad,        
			    
			e.COD_IPRESS,e.NOMBRE,h.genero , '','',       
			sum(CONVERT(int,h.valor_lab)) Cantidad,h.id_punto_digitacion        
			from 	rpt_plano_cbeta as h,         
				IPRESS as e 
			where 	        
				(        
					h.codigo_unico=e.COD_IPRESS              
					and h.anio_actual_paciente between 18 and 29        
					and trim(h.tipo_edad)='A'        
					and trim(h.genero) in ('F')				        
					and h.mes=@mes        
					and h.anio=@ano        
					and h.orden_atencion=2        
					and trim(h.valor_lab) in ('4')        
					and h.id_cita in	(select h1.id_cita        
									from rpt_plano_cbeta h1        
									where 	h1.orden_atencion=1        
										and trim(h1.codigo_item) in ('Z30452') 
										and h1.tipo_diagnostico='D'  									       									        
										and h1.anio_actual_paciente between 18 and 29        
										and trim(h1.tipo_edad)='A'       
										and h1.mes=@mes        
										and h1.anio=@ano        
								)        
				)        
				or        
				(        
					h.codigo_unico=e.COD_IPRESS              
					and h.anio_actual_paciente between 18 and 29        
					and trim(h.tipo_edad)='A'        
					and trim(h.genero) in ('F')				        
					and h.mes=@mes        
					and h.anio=@ano        
					and h.orden_atencion=3        
					and trim(h.valor_lab) in ('4')        
					and h.id_cita in	(select h1.id_cita        
									from rpt_plano_cbeta h1        
									where 	h1.orden_atencion=2        
										and trim(h1.codigo_item) in ('Z30452') 
										and h1.tipo_diagnostico='D'  									       									        
										and h1.anio_actual_paciente between 18 and 29        
										and trim(h1.tipo_edad)='A'        
										and h1.mes=@mes        
										and h1.anio=@ano        
								)        
				)        
				or        
				(        
					h.codigo_unico=e.COD_IPRESS              
					and h.anio_actual_paciente between 18 and 29        
					and trim(h.tipo_edad)='A'        
					and trim(h.genero) in ('F')				        
					and h.mes=@mes        
					and h.anio=@ano        
					and h.orden_atencion=4        
					and trim(h.valor_lab) in ('4')        
					and h.id_cita in	(select h1.id_cita        
									from rpt_plano_cbeta h1        
									where 	h1.orden_atencion=3        
										and trim(h1.codigo_item) in ('Z30452') 
										and h1.tipo_diagnostico='D'  									       									        
										and h1.anio_actual_paciente between 18 and 29        
										and trim(h1.tipo_edad)='A'        
										and h1.mes=@mes        
										and h1.anio=@ano        
								)        
				)        
				or        
				(        
					h.codigo_unico=e.COD_IPRESS              
					and h.anio_actual_paciente between 18 and 29        
					and trim(h.tipo_edad)='A'        
					and trim(h.genero) in ('F')				        
					and h.mes=@mes        
					and h.anio=@ano        
					and h.orden_atencion=5        
					and trim(h.valor_lab) in ('4')        
					and h.id_cita in	(select h1.id_cita        
									from rpt_plano_cbeta h1        
									where 	h1.orden_atencion=4        
										and trim(h1.codigo_item) in ('Z30452') 
										and h1.tipo_diagnostico='D'  									       									        
										and h1.anio_actual_paciente between 18 and 29        
										and trim(h1.tipo_edad)='A'        
										and h1.mes=@mes        
										and h1.anio=@ano        
								)        
				)        
				or        
				(        
					h.codigo_unico=e.COD_IPRESS               
					and h.anio_actual_paciente between 18 and 29        
					and trim(h.tipo_edad)='A'        
					and trim(h.genero) in ('F')				        
					and h.mes=@mes        
					and h.anio=@ano        
					and h.orden_atencion=6        
					and trim(h.valor_lab) in ('4')        
					and h.id_cita in	(select h1.id_cita        
									from rpt_plano_cbeta h1        
									where 	h1.orden_atencion=5        
										and trim(h1.codigo_item) in ('Z30452') 
										and h1.tipo_diagnostico='D'  									       									        
										and h1.anio_actual_paciente between 18 and 29        
										and trim(h1.tipo_edad)='A'       
										and h1.mes=@mes        
										and h1.anio=@ano        
								)       
				)			        
				group by 
		e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion; 
 

END
