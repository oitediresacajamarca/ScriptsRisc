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
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad   , h.id_punto_digitacion
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

		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
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

		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
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
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad  , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
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
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad  , h.id_punto_digitacion
	from rpt_plano_cbeta as h,
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

		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
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

		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
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



	----6-13- HORMONAL - INYECTABLE - MENSUAL- Atenciones - Nueva - 18 and 29    

	--56          
	insert into joven_tmp
	select '6-13- HORMONAL - INYECTABLE - MENSUAL- Atenciones - Nueva - 18 and 29' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	        
				h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z30051')
		and h.tipo_diagnostico='D'
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and trim(h.genero) in ('F')
		and h.mes=@mes
		and h.anio=@ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	---6-14. HORMONAL - INYECTABLE - MENSUAL - Atenciones - Continuadora - 18 and 29   


	--57            
	insert into joven_tmp
	select '6-14. HORMONAL - INYECTABLE - MENSUAL - Atenciones - Continuadora - 18 and 29' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z30451')
		and h.tipo_diagnostico='D'
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and trim(h.genero) in ('F')
		and h.mes = @mes
		and h.anio=@ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	-----6-15. HORMONAL - INYECTABLE - MENSUAL - Insumos - Nueva - 18 and 29    

	--58          
	insert into joven_tmp
	select '6-15. HORMONAL - INYECTABLE - MENSUAL - Insumos - Nueva - 18 and 29' Actividad,

		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		sum(convert(int,h.valor_lab)) Cantidad, h.id_punto_digitacion
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
			and trim(h1.codigo_item) in ('Z30051')
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
			and trim(h1.codigo_item) in ('Z30051')
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
			and trim(h1.codigo_item) in ('Z30051')
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
			and trim(h1.codigo_item) in ('Z30051')
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
			and trim(h1.codigo_item) in ('Z30051')
			and h1.tipo_diagnostico='D'
			and h1.anio_actual_paciente between 18 and 29
			and trim(h1.tipo_edad)='A'
			and h1.mes=@mes
			and h1.anio=@ano        
								)        
				)
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;
	--6-16. HORMONAL - INYECTABLE - MENSUAL - Insumos - Continuadora - 18 and 29    


	--59          
	insert into joven_tmp
	select '6-16. HORMONAL - INYECTABLE - MENSUAL - Insumos - Continuadora - 18 and 29' Actividad,

		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		sum(convert(int,h.valor_lab)) Cantidad, h.id_punto_digitacion
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
			and trim(h1.codigo_item) in ('Z30451')
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
			and trim(h1.codigo_item) in ('Z30451')
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
			and trim(h1.codigo_item) in ('Z30451')
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
			and trim(h1.codigo_item) in ('Z30451')
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
			and trim(h1.codigo_item) in ('Z30451')
			and h1.tipo_diagnostico='D'
			and h1.anio_actual_paciente between 18 and 29
			and trim(h1.tipo_edad)='A'
			and h1.mes=@mes
			and h1.anio=@ano        
								)        
				)
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;




	-------6-17. Metodo del implante - Atenciones - Nueva - 18 a 29   


	--60     
	insert into joven_tmp
	select '6-17. Metodo del implante - Atenciones - Nueva - 18 a 29' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	        
				h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z3006','11981')
		and h.tipo_diagnostico='D'
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and trim(h.genero) in ('F')
		and h.mes=@mes
		and h.anio=@ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	---60    
	-----  
	-----  
	-----  
	-----  
	--6-18. Metodo del implante - Atenciones - Continuadora - 18 and 29  

	--61         
	insert into joven_tmp
	select '6-18. Metodo del implante - Atenciones - Continuadora - 18 and 29' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z3046','Z306')
		and h.tipo_diagnostico='D'
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and trim(h.genero) in ('F')
		and h.mes=@mes
		and h.anio=@ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	--6-19- Metodo del implante - Insumos - Nueva - 18 a 29    

	--62       
	insert into joven_tmp
	select '6-19- Metodo del implante - Insumos - Nueva - 18 a 29' Actividad,

		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		sum(convert(int,h.valor_lab)) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	(        
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
			and trim(h1.codigo_item) in ('Z3006','11981')
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
			and trim(h1.codigo_item) in ('Z3006','11981')
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
			and trim(h1.codigo_item) in ('Z3006','11981')
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
			and trim(h1.codigo_item) in ('Z3006','11981')
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
			and trim(h1.codigo_item) in ('Z3006','11981')
			and h1.tipo_diagnostico='D'
			and h1.anio_actual_paciente between 18 and 29
			and trim(h1.tipo_edad)='A'
			and h1.mes=@mes
			and h1.anio=@ano        
								)        
				)
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;
	---6-20. Metodo del implante - Insumos - Continuadora - 18 and 29    


	--63   
	insert into joven_tmp
	select '6-20. Metodo del implante - Insumos - Continuadora - 18 and 29' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		sum(convert(int,h.valor_lab)) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	(        
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
			and trim(h1.codigo_item) in ('Z3046','Z306')
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
			and trim(h1.codigo_item) in ('Z3046','Z306')
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
			and trim(h1.codigo_item) in ('Z3046','Z306')
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
			and trim(h1.codigo_item) in ('Z3046','Z306')
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
			and trim(h1.codigo_item) in ('Z3046','Z306')
			and h1.tipo_diagnostico='D'
			and h1.anio_actual_paciente between 18 and 29
			and trim(h1.tipo_edad)='A'
			and h1.mes=@mes
			and h1.anio=@ano        
								)        
				)
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	---6-21-BARRERA CONDON MASCULINO - Atenciones - Nueva - 18 and 29 

	--64           
	insert into joven_tmp
	select '6-21-BARRERA CONDON MASCULINO - Atenciones - Nueva - 18 and 29' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	        
				h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z3008')
		and h.tipo_diagnostico='D'
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and h.mes=@mes
		and h.anio=@ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	--6-22. BARRERA - CONDON - MASCULINO - Atenciones - Continuadora - 18 and 29  


	--65          
	insert into joven_tmp
	select '6-22. BARRERA - CONDON - MASCULINO - Atenciones - Continuadora - 18 and 29' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where        
				h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z3048')
		and h.tipo_diagnostico='D'
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and h.mes=@mes
		and h.anio=@ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	---6-23-BARRERA - CONDON - MASCULINO - Insumos - Nueva - 18 and 29  

	--66            
	insert into joven_tmp
	select '6-23-BARRERA - CONDON - MASCULINO - Insumos - Nueva - 18 and 29' Actividad,

		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		sum(convert(int,h.valor_lab)) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	(        
					h.codigo_unico=e.COD_IPRESS
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=2
		and trim(h.valor_lab) in ('10')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=1
			and trim(h1.codigo_item) in ('Z3008')
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
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=3
		and trim(h.valor_lab) in ('10')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=2
			and trim(h1.codigo_item) in ('Z3008')
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
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=4
		and trim(h.valor_lab) in ('10')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=3
			and trim(h1.codigo_item) in ('Z3008')
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
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=5
		and trim(h.valor_lab) in ('10')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=4
			and trim(h1.codigo_item) in ('Z3008')
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
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=6
		and trim(h.valor_lab) in ('10')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=5
			and trim(h1.codigo_item) in ('Z3008')
			and h1.tipo_diagnostico='D'
			and h1.anio_actual_paciente between 18 and 29
			and trim(h1.tipo_edad)='A'
			and h1.mes=@mes
			and h1.anio=@ano        
								)        
				)
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;
	--6-24. BARRERA - CONDON - MASCULINO - Insumos - Continuadora - 18 and 29  


	--67             
	insert into joven_tmp
	select '6-24. BARRERA - CONDON - MASCULINO - Insumos - Continuadora - 18 and 29' Actividad,

		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		sum(convert(int,h.valor_lab)) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	(        
					h.codigo_unico=e.COD_IPRESS
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=2
		and trim(h.valor_lab) in ('30')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=1
			and trim(h1.codigo_item) in ('Z3048')
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
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=3
		and trim(h.valor_lab) in ('30')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=2
			and trim(h1.codigo_item) in ('Z3048')
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
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=4
		and trim(h.valor_lab) in ('30')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=3
			and trim(h1.codigo_item) in ('Z3048')
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
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=5
		and trim(h.valor_lab) in ('30')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=4
			and trim(h1.codigo_item) in ('Z3048')
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
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=6
		and trim(h.valor_lab) in ('30')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=5
			and trim(h1.codigo_item) in ('Z3048')
			and h1.tipo_diagnostico='D'
			and h1.anio_actual_paciente between 18 and 29
			and trim(h1.tipo_edad)='A'
			and h1.mes=@mes
			and h1.anio=@ano        
								)        
				)
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	-----6-25-BARRERA - CONDON - FEMENINO - Atenciones - Nueva - 18 and 29  


	--68           
	insert into joven_tmp
	select '6-25-BARRERA - CONDON - FEMENINO - Atenciones - Nueva - 18 and 29' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	              
				h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z3009')
		and h.tipo_diagnostico='D'
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and h.mes=@mes
		and h.anio=@ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;
	--6-26-BARRERA - CONDON - FEMENINO - Atenciones - Continuadora - 18 and 29  

	--69            
	insert into joven_tmp
	select '6-26-BARRERA - CONDON - FEMENINO - Atenciones - Continuadora - 18 and 29' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where        
				h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z3049')
		and h.tipo_diagnostico='D'
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and h.mes=@mes
		and h.anio=@ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	-----6-27-BARRERA - CONDON - FEMENINO - Insumos - Nueva - 18 and 29   


	--70             
	insert into joven_tmp
	select '6-27-BARRERA - CONDON - FEMENINO - Insumos - Nueva - 18 and 29' Actividad,

		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		sum(convert(int,h.valor_lab)) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	(        
					h.codigo_unico=e.COD_IPRESS
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=2
		and trim(h.valor_lab) in ('10')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=1
			and trim(h1.codigo_item) in ('Z3009')
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
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=3
		and trim(h.valor_lab) in ('10')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=2
			and trim(h1.codigo_item) in ('Z3009')
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
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=4
		and trim(h.valor_lab) in ('10')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=3
			and trim(h1.codigo_item) in ('Z3009')
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
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=5
		and trim(h.valor_lab) in ('10')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=4
			and trim(h1.codigo_item) in ('Z3009')
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
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=6
		and trim(h.valor_lab) in ('10')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=5
			and trim(h1.codigo_item) in ('Z3009')
			and h1.tipo_diagnostico='D'
			and h1.anio_actual_paciente between 18 and 29
			and trim(h1.tipo_edad)='A'
			and h1.mes=@mes
			and h1.anio=@ano        
								)        
				)
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	---70 
	-----      
	-----      
	-----      
	-----      
	--6-28-BARRERA - CONDON - FEMENINO - Insumos - Continuadora - 18 and 29   

	--71            
	insert into joven_tmp
	select '6-28-BARRERA - CONDON - FEMENINO - Insumos - Continuadora - 18 and 29' Actividad,

		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		sum(convert(int,h.valor_lab)) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	(        
					h.codigo_unico=e.COD_IPRESS
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=2
		and trim(h.valor_lab) in ('30')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=1
			and trim(h1.codigo_item) in ('Z3049')
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
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=3
		and trim(h.valor_lab) in ('30')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=2
			and trim(h1.codigo_item) in ('Z3049')
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
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=4
		and trim(h.valor_lab) in ('30')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=3
			and trim(h1.codigo_item) in ('Z3049')
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
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=5
		and trim(h.valor_lab) in ('30')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=4
			and trim(h1.codigo_item) in ('Z3049')
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
		and h.mes=@mes
		and h.anio=@ano
		and h.orden_atencion=6
		and trim(h.valor_lab) in ('30')
		and h.id_cita in	(select h1.id_cita
		from rpt_plano_cbeta h1
		where 	h1.orden_atencion=5
			and trim(h1.codigo_item) in ('Z3049')
			and h1.tipo_diagnostico='D'
			and h1.anio_actual_paciente between 18 and 29
			and trim(h1.tipo_edad)='A'
			and h1.mes=@mes
			and h1.anio=@ano        
								)        
				)
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	------6-29-ORIENTACION CONSEJERIA  - AQV - atencion nueva   


	--72     
	insert into joven_tmp
	select '6-29-ORIENTACION CONSEJERIA  - AQV - atencion nueva' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	        
				trim(h.genero) in ('F')
		and h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z3002')
		and h.tipo_diagnostico in ('D')
		and h.anio_actual_paciente between 30 and 59
		and trim(h.tipo_edad)='A'
		and h.mes=@mes
		and h.anio=@ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	--6-30-ORIENTACION CONSEJERIA  - AQV - Femenino -atencion continuadora  
	--73 
	insert into joven_tmp
	select '6-30-ORIENTACION CONSEJERIA  - AQV - Femenino -atencion continuadora' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	        
				trim(h.genero) in ('F')
		and h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z3002')
		and trim(h.valor_lab) in ('1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40')
		and h.tipo_diagnostico in ('D')
		and h.anio_actual_paciente between 30 and 59
		and trim(h.tipo_edad)='A'
		and h.mes=@mes
		and h.anio=@ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;
	--6-31. ORIENTACION CONSEJERIA  - AQV -Atencion nueva   


	--74      
	insert into joven_tmp
	select '6-31. ORIENTACION CONSEJERIA  - AQV -Atencion nueva' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	        
				trim(h.genero) in ('M')
		and h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z3002')
		and h.tipo_diagnostico in ('D')
		and h.anio_actual_paciente between 30 and 59
		and trim(h.tipo_edad)='A'
		and h.mes=@mes
		and h.anio=@ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	--6-32. ORIENTACION CONSEJERIA  - AQV -Atencion continuadorA 

	--75 

	insert into joven_tmp
	select '6-32. ORIENTACION CONSEJERIA  - AQV -Atencion continuadorA' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	        
				trim(h.genero) in ('M')
		and h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z3002')
		and trim(h.valor_lab) in ('1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40')
		and h.tipo_diagnostico in ('D')
		and h.anio_actual_paciente between 30 and 59
		and trim(h.tipo_edad)='A'
		and h.mes=@mes
		and h.anio=@ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	--6-33-MELA - Atenciones - Nueva - 18 and 29     


	--76          
	insert into joven_tmp
	select '6-33-MELA - Atenciones - Nueva - 18 and 29' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z30091')
		and h.tipo_diagnostico='D'
		and trim(h.genero) in ('F')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and h.mes=@mes
		and h.anio=@ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;
	--6-34-MELA - Atenciones - Continuadora - 18 and 29   


	--77             
	insert into joven_tmp
	select '6-34-MELA - Atenciones - Continuadora - 18 and 29' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z30491')
		and h.tipo_diagnostico='D'
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and trim(h.genero) in ('F')
		and h.mes=@mes
		and h.anio=@ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	--6-35-ABSTINENCIA PERIODICA BILLINGS Atenciones - Nueva - 18 and 29   

	--78 

	insert into joven_tmp
	select '6-35-ABSTINENCIA PERIODICA BILLINGS Atenciones - Nueva - 18 and 29' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z30093')
		and h.tipo_diagnostico='D'
		and trim(h.genero) in ('F')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and h.mes= @mes
		and h.anio = @ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;
	--6-36. ABSTINENCIA PERIODICA - BILLINGS - Atenciones - Continuadora - 18 and 29   


	--79        
	insert into joven_tmp
	select '6-36. ABSTINENCIA PERIODICA - BILLINGS - Atenciones - Continuadora - 18 and 29' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z30493')
		and h.tipo_diagnostico='D'
		and trim(h.genero) in ('F')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and h.mes=@mes
		and h.anio=@ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	--6-37-ABSTINENCIA PERIODICA - RITMO - Atenciones - Nueva   

	--80             
	insert into joven_tmp
	select '6-37-ABSTINENCIA PERIODICA - RITMO - Atenciones - Nueva' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z30092')
		and h.tipo_diagnostico='D'
		and trim(h.genero) in ('F')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and h.mes=@mes
		and h.anio=@ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	--80---- 
	----   
	----   
	----   
	--6-38. ABSTINENCIA PERIODICA - RITMO - Atenciones - Continuadora    


	--81       
	insert into joven_tmp
	select '6-38. ABSTINENCIA PERIODICA - RITMO - Atenciones - Continuadora' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z30492')
		and h.tipo_diagnostico='D'
		and trim(h.genero) in ('F')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and h.mes=@mes
		and h.anio=@ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	--6-39-ABSTINENCIA PERIODICA - COLLAR DIAS FIJOS - Atenciones - Nueva     

	--82  
	insert into joven_tmp
	select '6-39-ABSTINENCIA PERIODICA - COLLAR DIAS FIJOS - Atenciones - Nueva' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z30094')
		and h.tipo_diagnostico='D'
		and trim(h.genero) in ('F')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and h.mes=@mes
		and h.anio=@ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;
	--6-40-ABSTINENCIA PERIODICA - COLLAR DIAS FIJOS - Atenciones - Continuadora     

	--83       
	insert into joven_tmp
	select '6-40-ABSTINENCIA PERIODICA - COLLAR DIAS FIJOS - Atenciones - Continuadora' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z30494')
		and h.tipo_diagnostico='D'
		and trim(h.genero) in ('F')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and h.mes=@mes
		and h.anio=@ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;



	---7-0PRESTACION SALUD MENTAL EN JOVENES 
	---7-1-ENTREVISTA D ETAMIZAJES VIOLENCIA FAMILIAR  

	--84 

	insert into joven_tmp
	select '7-1-ENTREVISTA D ETAMIZAJES VIOLENCIA FAMILIAR' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('U140')
		and h.tipo_diagnostico='D'
		and trim(h.valor_lab) in ('VIF')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and h.mes = @mes
		and h.anio=@ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;
	--7-2-ENTREVISTA D ETAMIZAJES VIOLENCIA SEXUAL  

	--85 

	insert into joven_tmp
	select '7-2-ENTREVISTA D ETAMIZAJES VIOLENCIA SEXUAL' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('U140')
		and h.tipo_diagnostico='D'
		and trim(h.valor_lab) in ('VSX')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and h.mes = @mes
		and h.anio=@ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	--7-3-ENTREVISTA D ETAMIZAJES VIOLENCIA SOCIAL  

	--86 

	insert into joven_tmp
	select '7-3-ENTREVISTA D ETAMIZAJES VIOLENCIA SOCIAL' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('U140')
		and h.tipo_diagnostico='D'
		and trim(h.valor_lab) in ('VS')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and h.mes = @mes
		and h.anio=@ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	----7-4-ENTREVISTA D ETAMIZAJES ALCOHOL Y DROGAS 
	--87 

	insert into joven_tmp
	select '7-4-ENTREVISTA D ETAMIZAJES ALCOHOL Y DROGAS' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('U140')
		and h.tipo_diagnostico='D'
		and trim(h.valor_lab) in ('AD')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and h.mes = @mes
		and h.anio=@ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	---7-5-ENTREVISTA D ETAMIZAJES TRANSTORNOS DEPRESIVOS 
	--88 

	insert into joven_tmp
	select '7-5-ENTREVISTA D ETAMIZAJES TRANSTORNOS DEPRESIVOS' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('U140')
		and h.tipo_diagnostico='D'
		and trim(h.valor_lab) in ('TD')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and h.mes = @mes
		and h.anio=@ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	----7-6-TAMIZAJE POSITIVO Problemas relacionados con violencia 
	--89 

	insert into joven_tmp
	select '7-6-TAMIZAJE POSITIVO Problemas relacionados con violencia' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('R456')
		and h.tipo_diagnostico='D'
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and h.mes = @mes
		and h.anio=@ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	---7-7-TAMIZAJE POSITIVO Problemas Relacionados con el Uso de Tabaco 
	--90 

	insert into joven_tmp
	select '7-7-TAMIZAJE POSITIVO Problemas Relacionados con el Uso de Tabaco' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z720')
		and h.tipo_diagnostico='D'
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and h.mes = @mes
		and h.anio=@ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	---90--- 
	----- 
	----- 
	----- 

	--7-8-TAMIZAJE POSITIVO Problemas Sociales Relacionados con el Uso de Alcohol 

	--91 

	insert into joven_tmp
	select '7-8-TAMIZAJE POSITIVO Problemas Sociales Relacionados con el Uso de Alcohol' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z721')
		and h.tipo_diagnostico='D'
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and h.mes = @mes
		and h.anio=@ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;
	---7-9-TAMIZAJE POSITIVO Problemas Sociales Relacionados con el Uso de drogas 

	--92 

	insert into joven_tmp
	select '7-9-TAMIZAJE POSITIVO Problemas Sociales Relacionados con el Uso de drogas' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z722')
		and h.tipo_diagnostico='D'
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad)='A'
		and h.mes = @mes
		and h.anio=@ano
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	--7-10-TAMIZAJE POSITIVO Depresion 
	--93 

	insert into joven_tmp
	select '7-10-TAMIZAJE POSITIVO Depresion' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('U140')
		and trim(h.valor_lab) in ('TD')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_cita in(select h1.id_cita
		from rpt_plano_cbeta h1
		where trim(h1.valor_lab) in ('Z133')
			and trim(h1.tipo_diagnostico) in ('D')
			and h1.mes = @mes
			and h1.anio=@ano       
				)
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	--7-11-TAMIZAJE POSITIVO PSICOSIS 

	--94 

	insert into joven_tmp
	select '7-11-TAMIZAJE POSITIVO Depresion' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('U140')
		and trim(h.valor_lab) in ('EP')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_cita in(select h1.id_cita
		from rpt_plano_cbeta h1
		where trim(h1.valor_lab) in ('Z133')
			and trim(h1.tipo_diagnostico) in ('D')
			and h1.mes = @mes
			and h1.anio=@ano       
				)
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	--8-0-INMUNIZACIONES EN JOVENES 	 
	--8-1-Vacunación Diftotetánica (dT) No incluye Gestantes dosis 1 
	--95 


	insert into joven_tmp
	select '8-1-Vacunación Diftotetánica (dT) No incluye Gestantes dosis 1' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z2781')
		and trim(h.valor_lab) in ('1','D1')
		and trim(h.tipo_diagnostico) in ('D')
		and trim(h.genero) in ('F')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	--8-2-Vacunación Diftotetánica (dT) No incluye Gestantes dosis 2 
	--96 


	insert into joven_tmp
	select '8-2-Vacunación Diftotetánica (dT) No incluye Gestantes dosis 2' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z2781')
		and trim(h.valor_lab) in ('2','D2')
		and trim(h.tipo_diagnostico) in ('D')
		and trim(h.genero) in ('F')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	---8-3-Vacunación Diftotetánica (dT) No incluye Gestantes dosis 3 PRO 
	--97 


	insert into joven_tmp
	select '8-3-Vacunación Diftotetánica (dT) No incluye Gestantes dosis 3 PRO' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z2781')
		and trim(h.valor_lab) in ('3','D3')
		and trim(h.tipo_diagnostico) in ('D')
		and trim(h.genero) in ('F')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	--8-4-Vacunación Diftotetánica (dT)(SOLO Gestantes) DOSIS1  
	--98 

	insert into joven_tmp
	select '8-4-Vacunación Diftotetánica (dT)(SOLO Gestantes) DOSIS1' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z2781')
		and trim(h.valor_lab) in ('1','D1')
		and trim(h.tipo_diagnostico) in ('D')
		and trim(h.genero) in ('F')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_cita in(select h1.id_cita
		from rpt_plano_cbeta h1
		where trim(h1.valor_lab) in ('G')
			and h1.mes = @mes
			and h1.anio=@ano       
				)

	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;
	---8-5-Vacunación Diftotetánica (dT)(SOLO Gestantes) DOSIS2  
	--99 

	insert into joven_tmp
	select '8-5-Vacunación Diftotetánica (dT)(SOLO Gestantes) DOSIS2' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z2781')
		and trim(h.valor_lab) in ('2','D2')
		and trim(h.tipo_diagnostico) in ('D')
		and trim(h.genero) in ('F')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_cita in(select h1.id_cita
		from rpt_plano_cbeta h1
		where trim(h1.valor_lab) in ('G')
			and h1.mes = @mes
			and h1.anio=@ano       
				)

	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	---8-6-Vacunación Diftotetánica (dT)(SOLO Gestantes) DOSIS3PRO  
	--100 

	insert into joven_tmp
	select '8-6-Vacunación Diftotetánica (dT)(SOLO Gestantes) DOSIS3PRO' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z2781')
		and trim(h.valor_lab) in ('3','D3')
		and trim(h.tipo_diagnostico) in ('D')
		and trim(h.genero) in ('F')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_cita in(select h1.id_cita
		from rpt_plano_cbeta h1
		where trim(h1.valor_lab) in ('G')
			and h1.mes = @mes
			and h1.anio=@ano       
				)

	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	----100-- 
	--- 
	--- 
	--- 

	--8-7-Vacunación contra la Hepatitis B-DOSIS1 
	--101 

	insert into joven_tmp
	select '8-7-Vacunación contra la Hepatitis B-DOSIS1' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('90744')
		and trim(h.valor_lab) in ('1','D1')
		and trim(h.tipo_diagnostico) in ('D')
		and trim(h.genero) in ('F')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	---8-8-Vacunación contra la Hepatitis B-DOSIS2 
	--102 

	insert into joven_tmp
	select '8-8-Vacunación contra la Hepatitis B-DOSIS2' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('90744')
		and trim(h.valor_lab) in ('2','D2')
		and trim(h.tipo_diagnostico) in ('D')
		and trim(h.genero) in ('F')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	----8-9-Vacunación contra la Hepatitis B-DOSIS3 
	--103 

	insert into joven_tmp
	select '8-9-Vacunación contra la Hepatitis B-DOSIS3' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('90744')
		and trim(h.valor_lab) in ('3','D3')
		and trim(h.tipo_diagnostico) in ('D')
		and trim(h.genero) in ('F')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio= @ano

	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	--9-0-DETECCION DE TBC EN JOVENES 
	--9-1-Sintomáticos Respiratorios Examinados (TBC) 
	--104 


	insert into joven_tmp
	select '9-1-Sintomáticos Respiratorios Examinados (TBC)' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('U200')
		and trim(h.tipo_diagnostico) in ('D','R')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio= @ano
		and h.id_cita in(select h1.id_cita
		from rpt_plano_cbeta h1
		where  
					 trim(h1.codigo_item) in ('U2142')
			and trim(h1.valor_lab) in ('1')
			and h1.mes = @mes
			and h1.anio= @ano       
				)

	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	---9-2-Sintomáticos Respiratorios Identificados 
	--105 


	insert into joven_tmp
	select '9-2-Sintomáticos Respiratorios Identificados' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('U200')
		and trim(h.tipo_diagnostico) in ('D')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio= @ano

	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	--10-0-diagnosticos mas frecuentes 
	--10-1-tuberculosis 
	--106 


	insert into joven_tmp
	select '10-1-tuberculosis' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		--and trim(h.codigo_item) in ('A150','A151','A160','A162','A169','A180','A190','A199','U200')  
		and (trim(h.codigo_item)
	like '(A15|A16|A17|A18|A19)%' OR trim
	(h.codigo_item)='U200')
		and trim
	(h.tipo_diagnostico) in
	('D')
		and h.anio_actual_paciente between 18 and 29
		and trim
	(h.tipo_edad) in
	('A')
		and h.mes = @mes
		and h.anio = @ano

	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	--10-2-Transtornos mentales y del comportamiento por uso de sustancias psicoticas 

	--107		 


	insert into joven_tmp
	select '10-2-Transtornos mentales y del comportamiento por uso de sustancias psicoticas' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		--and trim(h.codigo_item) in ('F900','F901','F908','F909','F910','F911','F912','F913','F918','F919')  
		and trim(h.codigo_item)
	like  '(F10|F11|F12|F13|F14|F15|F16|F17|F18|F19)%'
		and trim
	(h.tipo_diagnostico) in
	('D')
		and h.anio_actual_paciente between 18 and 29
		and trim
	(h.tipo_edad) in
	('A')
		and h.mes = @mes
		and h.anio = @ano

	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	--10-3-PROBLEMAS RELACIONADOS CON EL USO DE ALCOHOL 
	--108 



	insert into joven_tmp
	select '10-3-PROBLEMAS RELACIONADOS CON EL USO DE ALCOHOL' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z721')
		and trim(h.tipo_diagnostico) in ('D')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio= @ano

	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;
	---10-4-PROBLEMAS RELACIONADOS CON EL USO DE TABACO 
	--109 



	insert into joven_tmp
	select '10-4-PROBLEMAS RELACIONADOS CON EL USO DE TABACO' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z720')
		and trim(h.tipo_diagnostico) in ('D')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio= @ano

	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	--10-5-PROBLEMAS RELACIONADOS CON EL USO DE DROGAS 
	--110 



	insert into joven_tmp
	select '10-5-PROBLEMAS RELACIONADOS CON EL USO DE DROGAS' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z722')
		and trim(h.tipo_diagnostico) in ('D')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio= @ano

	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	--110 
	--- 
	--- 
	--- 

	--10-6-Infecciones de modo predominantemente sexual 
	--111 

	insert into joven_tmp
	select '10-6-Infecciones de modo predominantemente sexual' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		-------	and trim(h.codigo_item) in ('A500','A502','A503','A504','A505','A506','A507','A508','A509','A600','A601','A602','A603','A604')  
		and trim(h.codigo_item)
	like '(A50|A51|A52|A53|A54|A55|A56|A57|A58|A59|A60|A61|A62|A63|A64)%'
		and trim
	(h.tipo_diagnostico) in
	('D')
		and h.anio_actual_paciente between 18 and 29
		and trim
	(h.tipo_edad) in
	('A')
		and h.mes = @mes
		and h.anio = @ano

	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;




	--10-7-Todos los diagnósticos definitivos de violencia 
	--112 

	insert into joven_tmp
	select '10-7-Todos los diagnósticos definitivos de violencia' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('T742','T743','T748','T749')
		and trim(h.tipo_diagnostico) in ('D')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio= @ano

	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	--10-8-Personas con diagnóstico confirmado de VIH 
	--113 

	insert into joven_tmp
	select '10-8-Personas con diagnóstico confirmado de VIH' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z21X','Z21X1','Z21X2')
		and trim(h.tipo_diagnostico) in ('D')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio= @ano

	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	--10-9-Personas que sufrieron accidentes ocupacionales (exposición VIH) 
	--114 

	insert into joven_tmp
	select '10-9-Personas que sufrieron accidentes ocupacionales (exposición VIH)' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z5781')
		and trim(h.tipo_diagnostico) in ('D')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio= @ano

	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;




	--10-10-Personas que sufrieron accidentes ocupacionales (exposición VIH) y reciben profilaxis ARV 
	--115 


	insert into joven_tmp
	select '10-10-Personas que sufrieron accidentes ocupacionales (exposición VIH) y reciben profilaxis ARV' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z5781')
		and trim(h.tipo_diagnostico) in ('D')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_cita in(select h1.id_cita
		from rpt_plano_cbeta h1
		where  trim(h1.codigo_item)  in ('Z5189')
			and trim(h1.valor_lab) in ('ST')
			and h1.mes = @mes
			and h1.anio= @ano  
					 
				)

	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	--10-11-Personas expuestas a VIH por violencia sexual y reciben profilaxis ARV 
	--116 

	insert into joven_tmp
	select '10-11-Personas expuestas a VIH por violencia sexual y reciben profilaxis ARV' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('Z5189')
		and trim(h.tipo_diagnostico) in ('D')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_cita in(select h1.id_cita
		from rpt_plano_cbeta h1
		where trim(h1.valor_lab) in ('VSX')
			and h1.mes = @mes
			and h1.anio = @ano  
					 
				)

	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;



	--10-12-Carcinoma in situ de cuello uterino 

	--117 
	insert into joven_tmp
	select '10-12-Carcinoma in situ de cuello uterino' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('D067','D069')
		and trim(h.tipo_diagnostico) in ('D')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio= @ano


	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;



	--10-13-Transtornos mentales y del comportamiento 
	--118 



	insert into joven_tmp
	select '10-13-Transtornos mentales y del comportamiento' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('F910','F919','F530','F531','F538')
		and trim(h.tipo_diagnostico) in ('D')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio= @ano

	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	--10-14-Lesiones autoinfligidas 
	--119 
	insert into joven_tmp
	select '10-14-Lesiones autoinfligidas' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		--and trim(h.codigo_item) in ('X600','X840')  
		and trim(h.codigo_item)
	like  '(X60|X61|X62|X63|X64|X65|X66|X67|X68|X69|X70|X71|X72|X73|X74|X75|X76|X77|X78|X79|X80|X81|X82|X83|X84)%'
		and trim
	(h.tipo_diagnostico) in
	('D')
		and h.anio_actual_paciente between 18 and 29
		and trim
	(h.tipo_edad) in
	('A')
		and h.mes = @mes
		and h.anio= @ano

	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	--10-15-Depresión 
	--120 


	insert into joven_tmp
	select '10-15-Depresión' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('F320','F321','F322','F323','F328','F329','F330','F920')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;


	--10-16-ANEMIA NUTRICIONAL- 
	--121 

	insert into joven_tmp
	select '10-16-ANEMIA NUTRICIONAL' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('D508','D509')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	--10-17-Embarazo terminado en aborto 
	--122 
	insert into joven_tmp
	select '10-17-Embarazo terminado en aborto' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('O021','O300','O400','O500','O600','O080')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;

	--10-18-OBESIDAD 

	--123 

	insert into joven_tmp
	select '10-18-OBESIDAD' Actividad,
		e.COD_IPRESS, e.NOMBRE, h.genero , '', '',
		count(*) Cantidad, h.id_punto_digitacion
	from rpt_plano_cbeta as h,
		IPRESS as e
	where 	h.codigo_unico=e.COD_IPRESS
		and trim(h.codigo_item) in ('E669')
		and h.anio_actual_paciente between 18 and 29
		and trim(h.tipo_edad) in ('A')
		and h.mes = @mes
		and h.anio=@ano
		and h.id_punto_digitacion like @id_punto_digitacion_txt
	group by e.COD_IPRESS,e.NOMBRE,h.genero,h.id_punto_digitacion;




	---------------------------------------------------------------------------------------------------------------------	    
	---------------------------------------------------------------------------------------------------------------------    
	--INGRESO DE IPRESSIMIENTOS--    
	---------------------------------------------------------------------------------------------------------------------    
	---------------------------------------------------------------------------------------------------------------------    
	--Crear tabla temporal    
	IF OBJECT_ID ( 'dbo.tmp_joven', 'U' ) IS NULL 
	create table tmp_joven
	(
		mes integer,
		anio integer,
		id_punto_digitacion character varying(10),
		NUMERO integer,
		COD_2000 character varying(150),
		CODIGO character varying(150),
		REGION character varying(150),
		PROVINCIA character varying(150),
		DISTRITO character varying(150),
		DISA character varying(150),
		RED character varying(150),
		MICRORED character varying(150),
		ESTABLECIMIENTO character varying(150),
		var1 int,
		var2 int,
		var3 int,
		var4 int,
		var5 int,
		var6 int,
		var7 int,
		var8 int,
		var9 int,
		var10 int,
		var11 int,
		var12 int,
		var13 int,
		var14 int,
		var15 int,
		var16 int,
		var17 int,
		var18 int,
		var19 int,
		var20 int,
		var21 int,
		var22 int,
		var23 int,
		var24 int,
		var25 int,
		var26 int,
		var27 int,
		var28 int,
		var29 int,
		var30 int,
		var31 int,
		var32 int,
		var33 int,
		var34 int,
		var35 int,
		var36 int,
		var37 int,
		var38 int,
		var39 int,
		var40 int,
		var41 int,
		var42 int,
		var43 int,
		var44 int,
		var45 int,
		var46 int,
		var47 int,
		var48 int,
		var49 int,
		var50 int,
		var51 int,
		var52 int,
		var53 int,
		var54 int,
		var55 int,
		var56 int,
		var57 int,
		var58 int,
		var59 int,
		var60 int,
		var61 int,
		var62 int,
		var63 int,
		var64 int,
		var65 int,
		var66 int,
		var67 int,
		var68 int,
		var69 int,
		var70 int,
		var71 int,
		var72 int,
		var73 int,
		var74 int,
		var75 int,
		var76 int,
		var77 int,
		var78 int,
		var79 int,
		var80 int,
		var81 int,
		var82 int,
		var83 int,
		var84 int,
		var85 int,
		var86 int,
		var87 int,
		var88 int,
		var89 int,
		var90 int,
		var91 int,
		var92 int,
		var93 int,
		var94 int,
		var95 int,
		var96 int,
		var97 int,
		var98 int,
		var99 int,
		var100 int,
		var101 int,
		var102 int,
		var103 int,
		var104 int,
		var105 int,
		var106 int,
		var107 int,
		var108 int,
		var109 int,
		var110 int,
		var111 int,
		var112 int,
		var113 int,
		var114 int,
		var115 int,
		var116 int,
		var117 int,
		var118 int,
		var119 int,
		var120 int,
		var121 int,
		var122 int,
		var123 int,
		var124 int,
		var125 int,
		var126 int,
		var127 int,
		var128 int,
		var129 int,
		var130 int,
		var131 int,
		var132 int,
		var133 int,
		var134 int,
		var135 int,
		var136 int,
		var137 int,
		var138 int,
		var139 int,
		var140 int,
		var141 int,
		var142 int,
		var143 int,
		var144 int,
		var145 int,
		var146 int,
		var147 int,
		var148 int,
		var149 int,
		var150 int,
		var151 int,
		var152 int,
		var153 int,
		var154 int,
		var155 int,
		var156 int,
		var157 int,
		var158 int,
		var159 int,
		var160 int,
		var161 int,
		var162 int,
		var163 int,
		var164 int,
		var165 int,
		var166 int,
		var167 int,
		var168 int,
		var169 int,
		var170 int,
		var171 int,
		var172 int,
		var173 int,
		var174 int,
		var175 int,
		var176 int,
		var177 int,
		var178 int,
		var179 int,
		var180 int,
		var181 int,
		var182 int,
		var183 int,
		var184 int,
		var185 int,
		var186 int,
		var187 int,
		var188 int,
		var189 int

	);

	--------------------------------------------------------------------------------------------------------------------------------------------------------------------    
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------    
	------------------------------      CREACION DE TABLA PARA REPORTE DE SALUD joven DEFINITIVA     --------------------------------------------------------------    
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------    
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------    
	delete from tmp_joven where mes=@mes and ano=@ano;
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------		    


	insert into tmp_joven
	SELECT @mes, @ano, @id_punto_digitacion,
		IPRESS.COD_IPRESS,
		IPRESS.COD_IPRESS,
		DISTRITO.ID_DISTRITO AS UBIGEO,
		DEPARTAMENTO.NOMBRE AS DEPARTAMENTO_NOMBRE,
		PROVINCIA.NOMBRE AS PROVINCIA_NOMBRE,
		DISTRITO.NOMBRE AS DISTRITO_NOMBRE,
		SUBREGION.NOMBRE AS SUBREGION_NOMBRE,
		RED.NOMBRE AS RED_NOMBRE,
		MICRORED.NOMBRE AS MICRORED_NOMBRE,
		IPRESS.NOMBRE AS IPRESS_NOMBRE,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0
	FROM DISTRITO INNER JOIN
		IPRESS ON DISTRITO.ID_DISTRITO = IPRESS.ID_DISTRITO INNER JOIN
		PROVINCIA ON DISTRITO.ID_PROVINCIA = PROVINCIA.ID_PROVINCIA INNER JOIN
		DEPARTAMENTO ON PROVINCIA.ID_DEPARTAMENTO = DEPARTAMENTO.ID_DEPARTAMENTO INNER JOIN
		MICRORED ON IPRESS.ID_MICRORED = MICRORED.ID_MICRORED INNER JOIN
		RED ON MICRORED.ID_RED = RED.ID_RED INNER JOIN
		SUBREGION ON RED.ID_SUBREGION = SUBREGION.ID_SUBREGION;
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------    
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------    
	--ACTUALIZACION DE DATOS EN TABLA FINAL DE SALUD joven ---------------------------------------------------------------------------------------------------------------    
	--ACTUALIZACION DE DATOS EN TABLA FINAL DE SALUD joven ---------------------------------------------------------------------------------------------------------------    
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------    
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------    


	update tmp_joven set var1=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='1-1-plan de atencion integral elaborado'and joven_tmp.rango='M') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var2=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='1-1-plan de atencion integral elaborado'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var3=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='1-2-plan de atencion integral ejecutado'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var4=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='1-2-plan de atencion integral ejecutado'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var5=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='1-3-Consejeria integral Finalizada'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var6=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='1-3-Consejeria integral Finalizada'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;


	update tmp_joven set var7=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='2-1-INDICE DE MASA CORPORAL (IMC)-OBECIDAD'and joven_tmp.rango='M') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var8=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='2-1-INDICE DE MASA CORPORAL (IMC)-OBECIDAD'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var9=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='2-2-INDICE DE MASA CORPORAL (IMC)-SOBREPESO'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var10=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='2-2-INDICE DE MASA CORPORAL (IMC)-SOBREPESO'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var11=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='2-3-INDICE DE MASA CORPORAL (IMC)-NORMAL'and joven_tmp.rango='M') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var12=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='2-3-INDICE DE MASA CORPORAL (IMC)-NORMAL'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var13=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='2-4-INDICE DE MASA CORPORAL (IMC)-DELGADEZ'and joven_tmp.rango='M') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var14=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='2-4-INDICE DE MASA CORPORAL (IMC)-DELGADEZ'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var15=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='2-5-TALLA/EDAD TALLA ALTA'and joven_tmp.rango='M') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var16=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='2-5-TALLA/EDAD TALLA ALTA'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var17=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='2-6-TALLA/EDAD TALLA NORMAL'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var18=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='2-6-TALLA/EDAD TALLA NORMAL'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var19=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='2-7-TALLA/EDAD TALLA BAJA'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var20=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='2-7-TALLA/EDAD TALLA BAJA'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;


	update tmp_joven set var21=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='3-1-EXAMEN ODONTOLOGICO NO GESTANTES INICIAN'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var22=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='3-1-EXAMEN ODONTOLOGICO NO GESTANTES INICIAN'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var23=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='3-2-EXAMEN ODONTOLOGICO NO GESTANTES TRATADO'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var24=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='3-2-EXAMEN ODONTOLOGICO NO GESTANTES TRATADO'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var25=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='3-3-EXAMEN ODONTOLOGICO  GESTANTES INICIAN'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var26=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='3-4-EXAMEN ODONTOLOGICO  GESTANTES TRATADO'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var27=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='3-5-Instrucción de Higiene Oral inician'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var28=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='3-5-Instrucción de Higiene Oral inician'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var29=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='3-6-Instrucción de Higiene Oral tratado'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var30=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='3-6-Instrucción de Higiene Oral tratado'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var31=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='3-7-Asesoría nutricional para el control de enfermedades dentales inician'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var32=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='3-7-Asesoría nutricional para el control de enfermedades dentales inician'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var33=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='3-8-Asesoría nutricional para el control de enfermedades dentales tratado'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var34=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='3-8-Asesoría nutricional para el control de enfermedades dentales tratado'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var35=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='3-9-Alta Basica Odontologica (ABO) no gestantes'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var36=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='3-9-Alta Basica Odontologica (ABO) no gestantes'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var37=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='3-10-Alta Basica Odontologica (ABO)  gestantes'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;


	update tmp_joven set var38=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='4-1-VALORACION CLINICA DE FACTORES DE RIESGO'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var39=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='4-1-VALORACION CLINICA DE FACTORES DE RIESGO'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var40=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='4-2-SEDENTARISMO'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var41=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='4-2-SEDENTARISMO'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var42=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='4-3-DISLIPIDEMIA'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var43=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='4-3-DISLIPIDEMIA'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var44=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='4-4-Glisemia basal alterada (de 100 a 139 mg/dl) - Prediabetes'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var45=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='4-4-Glisemia basal alterada (de 100 a 139 mg/dl) - Prediabetes'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var46=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='4-5-Tolerancia a la glucosa alterada (de 140 a 199 mg/dl) - Prediabetes'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var47=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='4-5-Tolerancia a la glucosa alterada (de 140 a 199 mg/dl) - Prediabetes'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var48=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='4-6-EXAMEN DE HEMOGLOBINA'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var49=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='4-6-EXAMEN DE HEMOGLOBINA'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;


	update tmp_joven set var50=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='5-1-Consejería para la prevención de ITS 1RA SESION'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var51=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='5-1-Consejería para la prevención de ITS 1RA SESION'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var52=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='5-2-Consejería para la prevención de ITS 2DA SESION'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var53=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='5-2-Consejería para la prevención de ITS 2DA SESION'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var54=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='5-3-Consejería para la prevención de ITS 3RA SESION'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var55=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='5-3-Consejería para la prevención de ITS 3RA SESION'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var56=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='5-4-Nº de personas tamizadas para VIH (incluye datos de ESNSSR y ESN TB)'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var57=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='5-4-Nº de personas tamizadas para VIH (incluye datos de ESNSSR y ESN TB)'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var58=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='5-5-Nº de personas tamizadas para VIH con resultado reactivo (incuye datos de ESNSSR y ESN TB)'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var59=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='5-5-Nº de personas tamizadas para VIH con resultado reactivo (incuye datos de ESNSSR y ESN TB)'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var60=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='5-6-Gestantes Atendidas (1º Control Prenatal)en 1º Trimestre de Gestación'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var61=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='5-7-Gestantes Atendidas (1º Control Prenatal)en 2º Trimestre de Gestación'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var62=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='5-8-Gestantes Atendidas (1º Control Prenatal)en 3º Trimestre de Gestación'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var63=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='5-9-Gestantes Controladas (6º Control Prenatal)'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var64=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='5-10-Gestantes con atención prenatal reenfocada'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var65=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='5-11-Suplementación con Sulfato Ferroso en Gestantes'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var66=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='5-12-Suplementación con Ácido Fólico en Gestantes'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var67=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='5-13-PARTO'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var68=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='5-14-TOMA DE PAP'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var69=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='5-15-Entrega de Resultados PAP'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var70=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='5-16-Resultado positivo de PAP (Gestantes)'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var71=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='5-17-Consejeria y orientacion general para Planificación Familiar'and joven_tmp.rango='M') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var72=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='5-17-Consejeria y orientacion general para Planificación Familiar'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;



	update tmp_joven set var73=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-1. DIU - Atenciones - Nueva - 18 and 29'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var74=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-2. DIU - Atenciones - Continuadora - 18 and 29'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var75=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-3 DIU - Insumos - Nueva - 18 and 29'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var76=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-4. DIU - Insumos - Continuadora - 18 and 29'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var77=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-5-HORMONAL ORAL COMBINADO  - Nueva - 18 and 29'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var78=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-6 HORMONAL - ORAL - COMBINADO - Atenciones - Continuadora - 18 and 29'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var79=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-7-HORMONAL - ORAL - COMBINADO - Insumos - Nueva - 18 and 29'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var80=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-8-. HORMONAL - ORAL - COMBINADO - Insumos - Continuadora - 18 and 29'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var81=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-9- HORMONAL - INYECTABLE - TRIMESTRAL - Atenciones - Nueva - 18 and 29'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var82=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-10. HORMONAL - INYECTABLE - TRIMESTRAL - Atenciones - Continuadora - 18 and 29'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var83=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-11. HORMONAL - INYECTABLE - TRIMESTRAL - Insumos - Nueva - 18 and 29'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var84=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-12. HORMONAL - INYECTABLE - TRIMESTRAL - Insumos - Continuadora - 18 and 29'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var85=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-13- HORMONAL - INYECTABLE - MENSUAL- Atenciones - Nueva - 18 and 29'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var86=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-14. HORMONAL - INYECTABLE - MENSUAL - Atenciones - Continuadora - 18 and 29'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var87=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-15. HORMONAL - INYECTABLE - MENSUAL - Insumos - Nueva - 18 and 29'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var88=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-16. HORMONAL - INYECTABLE - MENSUAL - Insumos - Continuadora - 18 and 29'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var89=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-17. Metodo del implante - Atenciones - Nueva - 18 a 29'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var90=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-18. Metodo del implante - Atenciones - Continuadora - 18 and 29'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var91=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-19- Metodo del implante - Insumos - Nueva - 18 a 29'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var92=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-20. Metodo del implante - Insumos - Continuadora - 18 and 29'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var93=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-21-BARRERA CONDON MASCULINO - Atenciones - Nueva - 18 and 29'and joven_tmp.rango='M') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var94=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-22. BARRERA - CONDON - MASCULINO - Atenciones - Continuadora - 18 and 29'and joven_tmp.rango='M') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var95=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-23-BARRERA - CONDON - MASCULINO - Insumos - Nueva - 18 and 29'and joven_tmp.rango='M') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var96=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-24. BARRERA - CONDON - MASCULINO - Insumos - Continuadora - 18 and 29'and joven_tmp.rango='M') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var97=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-25-BARRERA - CONDON - FEMENINO - Atenciones - Nueva - 18 and 29'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var98=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-26-BARRERA - CONDON - FEMENINO - Atenciones - Continuadora - 18 and 29'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var99=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-27-BARRERA - CONDON - FEMENINO - Insumos - Nueva - 18 and 29'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var100=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-28-BARRERA - CONDON - FEMENINO - Insumos - Continuadora - 18 and 29'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var101=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-29-ORIENTACION CONSEJERIA  - AQV - atencion nueva'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var102=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-30-ORIENTACION CONSEJERIA  - AQV - Femenino -atencion continuadora'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var103=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-31. ORIENTACION CONSEJERIA  - AQV -Atencion nueva'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var104=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-32. ORIENTACION CONSEJERIA  - AQV -Atencion continuadorA'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var105=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-33-MELA - Atenciones - Nueva - 18 and 29'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var106=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-34-MELA - Atenciones - Continuadora - 18 and 29'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var107=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-35-ABSTINENCIA PERIODICA BILLINGS Atenciones - Nueva - 18 and 29'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var108=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-36. ABSTINENCIA PERIODICA - BILLINGS - Atenciones - Continuadora - 18 and 29'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var109=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-37-ABSTINENCIA PERIODICA - RITMO - Atenciones - Nueva'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var110=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-38. ABSTINENCIA PERIODICA - RITMO - Atenciones - Continuadora'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var111=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-39-ABSTINENCIA PERIODICA - COLLAR DIAS FIJOS - Atenciones - Nueva'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var112=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='6-40-ABSTINENCIA PERIODICA - COLLAR DIAS FIJOS - Atenciones - Continuadora'and joven_tmp.rango='F') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;




	update tmp_joven set var113=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='7-1-ENTREVISTA D ETAMIZAJES VIOLENCIA FAMILIAR'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var114=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='7-1-ENTREVISTA D ETAMIZAJES VIOLENCIA FAMILIAR'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var115=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='7-2-ENTREVISTA D ETAMIZAJES VIOLENCIA SEXUAL'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var116=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='7-2-ENTREVISTA D ETAMIZAJES VIOLENCIA SEXUAL'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var117=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='7-3-ENTREVISTA D ETAMIZAJES VIOLENCIA SOCIAL'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var118=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='7-3-ENTREVISTA D ETAMIZAJES VIOLENCIA SOCIAL'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var119=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='7-4-ENTREVISTA D ETAMIZAJES ALCOHOL Y DROGAS'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var120=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='7-4-ENTREVISTA D ETAMIZAJES ALCOHOL Y DROGAS'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var121=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='7-5-ENTREVISTA D ETAMIZAJES TRANSTORNOS DEPRESIVOS'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var122=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='7-5-ENTREVISTA D ETAMIZAJES TRANSTORNOS DEPRESIVOS'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var123=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='7-6-TAMIZAJE POSITIVO Problemas relacionados con violencia'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var124=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='7-6-TAMIZAJE POSITIVO Problemas relacionados con violencia'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var125=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='7-7-TAMIZAJE POSITIVO Problemas Relacionados con el Uso de Tabaco'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var126=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='7-7-TAMIZAJE POSITIVO Problemas Relacionados con el Uso de Tabaco'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var127=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='7-8-TAMIZAJE POSITIVO Problemas Sociales Relacionados con el Uso de Alcohol'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var128=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='7-8-TAMIZAJE POSITIVO Problemas Sociales Relacionados con el Uso de Alcohol'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var129=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='7-9-TAMIZAJE POSITIVO Problemas Sociales Relacionados con el Uso de drogas'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var130=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='7-9-TAMIZAJE POSITIVO Problemas Sociales Relacionados con el Uso de drogas'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var131=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='7-10-TAMIZAJE POSITIVO Depresion'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var132=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='7-10-TAMIZAJE POSITIVO Depresion'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var133=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='7-11-TAMIZAJE POSITIVO Depresion'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var134=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='7-11-TAMIZAJE POSITIVO Depresion'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;


	update tmp_joven set var135=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='8-1-Vacunación Diftotetánica (dT) No incluye Gestantes dosis 1'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var136=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='8-1-Vacunación Diftotetánica (dT) No incluye Gestantes dosis 1'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var137=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='8-2-Vacunación Diftotetánica (dT) No incluye Gestantes dosis 2'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var138=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='8-2-Vacunación Diftotetánica (dT) No incluye Gestantes dosis 2'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var139=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='8-3-Vacunación Diftotetánica (dT) No incluye Gestantes dosis 3 PRO'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var140=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='8-3-Vacunación Diftotetánica (dT) No incluye Gestantes dosis 3 PRO'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var141=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='8-4-Vacunación Diftotetánica (dT)(SOLO Gestantes) DOSIS1') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var142=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='8-5-Vacunación Diftotetánica (dT)(SOLO Gestantes) DOSIS2') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var143=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='8-6-Vacunación Diftotetánica (dT)(SOLO Gestantes) DOSIS3PRO') where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var144=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='8-7-Vacunación contra la Hepatitis B-DOSIS1'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var145=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='8-7-Vacunación contra la Hepatitis B-DOSIS1'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var146=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='8-8-Vacunación contra la Hepatitis B-DOSIS2'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var147=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='8-8-Vacunación contra la Hepatitis B-DOSIS2'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var148=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='8-9-Vacunación contra la Hepatitis B-DOSIS3'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var149=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='8-9-Vacunación contra la Hepatitis B-DOSIS3'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;


	update tmp_joven set var150=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='9-1-Sintomáticos Respiratorios Examinados (TBC)'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var151=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='9-1-Sintomáticos Respiratorios Examinados (TBC)'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var152=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='9-2-Sintomáticos Respiratorios Identificados'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var153=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='9-2-Sintomáticos Respiratorios Identificados'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;


	update tmp_joven set var154=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-1-tuberculosis'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var155=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-1-tuberculosis'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var156=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-2-Transtornos mentales y del comportamiento por uso de sustancias psicoticas'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var157=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-2-Transtornos mentales y del comportamiento por uso de sustancias psicoticas'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var158=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-3-PROBLEMAS RELACIONADOS CON EL USO DE ALCOHOL'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var159=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-3-PROBLEMAS RELACIONADOS CON EL USO DE ALCOHOL'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var160=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-4-PROBLEMAS RELACIONADOS CON EL USO DE TABACO'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var161=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-4-PROBLEMAS RELACIONADOS CON EL USO DE TABACO'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var162=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-5-PROBLEMAS RELACIONADOS CON EL USO DE DROGAS'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var163=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-5-PROBLEMAS RELACIONADOS CON EL USO DE DROGAS'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var164=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-6-Infecciones de modo predominantemente sexual'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var165=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-6-Infecciones de modo predominantemente sexual'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var166=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-7-Todos los diagnósticos definitivos de violencia'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var167=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-7-Todos los diagnósticos definitivos de violencia'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var168=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-8-Personas con diagnóstico confirmado de VIH'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var169=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-8-Personas con diagnóstico confirmado de VIH'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var170=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-9-Personas que sufrieron accidentes ocupacionales (exposición VIH)'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var171=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-9-Personas que sufrieron accidentes ocupacionales (exposición VIH)'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var172=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-10-Personas que sufrieron accidentes ocupacionales (exposición VIH) y reciben profilaxis ARV'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var173=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-10-Personas que sufrieron accidentes ocupacionales (exposición VIH) y reciben profilaxis ARV'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var174=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-11-Personas expuestas a VIH por violencia sexual y reciben profilaxis ARV'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var175=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-11-Personas expuestas a VIH por violencia sexual y reciben profilaxis ARV'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var176=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-12-Carcinoma in situ de cuello uterino'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var177=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-12-Carcinoma in situ de cuello uterino'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var178=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-13-Transtornos mentales y del comportamiento'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var179=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-13-Transtornos mentales y del comportamiento'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var180=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-14-Lesiones autoinfligidas'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var181=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-14-Lesiones autoinfligidas'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var182=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-15-Depresión'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var183=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-15-Depresión'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var184=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-16-ANEMIA NUTRICIONAL'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var185=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-16-ANEMIA NUTRICIONAL'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var186=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-17-Embarazo terminado en aborto'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var187=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-17-Embarazo terminado en aborto'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var188=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-18-OBESIDAD'and joven_tmp.rango='M')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;
	update tmp_joven set var189=(select joven_tmp.cantidad
	from joven_tmp
	where joven_tmp.cod_estab=tmp_joven.COD_IPRESS and joven_tmp.actividad='10-18-OBESIDAD'and joven_tmp.rango='F')where tmp_joven.mes=@mes and tmp_joven.ano=@ano;


	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    


	drop table joven_tmp;


END
