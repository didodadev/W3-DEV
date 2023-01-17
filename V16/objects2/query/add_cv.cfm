<cfif len(attributes.email)>
	<cfquery name="get_empapp_mail" datasource="#dsn#">
		SELECT
			EMAIL
		FROM
			EMPLOYEES_APP
		WHERE
			EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.email#">
	</cfquery>
	<cfif get_empapp_mail.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1411.Girdiğiniz mail adresine ait bir kullanıcı  Aynı mail adresi ile başka bir kullanıcı ekleyemezsiniz'>!");
			history.go(-1);
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfif len(attributes.photo)>
	<cftry>
		<cfset upload_folder = "#upload_folder##dir_seperator#hr#dir_seperator#">

		<CFFILE action = "upload" 
			  filefield = "photo" 
			  destination = "#upload_folder#" 
			  nameconflict = "MakeUnique" 
			  mode="777">

		<cfset file_name = createUUID()>
		<CFFILE action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
		<cfset attributes.photo = '#file_name#.#cffile.serverfileext#'>
		
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang no ='1412.Resim yüklenemedi lütfen tekrar deneyiniz'> !");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
<cfelse>
	<cfset attributes.photo = "">
</cfif>

<cfif len(attributes.birth_date)>
	<cf_date tarih="attributes.birth_date">
<cfelse>
	<cfset attributes.birth_date = "null">
</cfif>

<cfif len(attributes.licence_start_date)>
	<cf_date tarih="attributes.licence_start_date">
</cfif>

<cfif len(attributes.military_finishdate)>
	<cf_date tarih="attributes.military_finishdate">
<cfelse>
	<cfset attributes.military_finishdate = "NULL">
</cfif>

<cfif len(attributes.military_delay_date)>
	<cf_date tarih="attributes.military_delay_date">
<cfelse>
	<cfset attributes.military_delay_date = "NULL">
</cfif>

<!--- çalışmak istediği departmanlar--->
<cfquery name="get_cv_unit" datasource="#DSN#">
	SELECT * FROM SETUP_CV_UNIT
</cfquery>

<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
	<cfquery name="ADD_EMP_APP" datasource="#DSN#" result="MAX_ID">
		INSERT INTO 
			EMPLOYEES_APP
			(
			STEP_NO,
			APP_STATUS,
			<cfif isdefined("attributes.sentenced")>SENTENCED,</cfif>		
			<cfif isdefined("attributes.defected")>
			DEFECTED,
			DEFECTED_LEVEL,
			</cfif>
			<cfif isdefined("attributes.sex")>SEX,</cfif>
			NAME,
			<cfif len(attributes.worktelcode)>WORKTELCODE,</cfif>
			<cfif len(attributes.worktel)>WORKTEL,</cfif>
			SURNAME,
			<cfif len(attributes.extension)>EXTENSION,</cfif>
			EMAIL,
			<cfif len(attributes.mobilcode)>MOBILCODE,</cfif>
			<cfif len(attributes.mobil)>MOBIL,</cfif>
			<cfif len(attributes.mobilcode2)>MOBILCODE2,</cfif>
			<cfif len(attributes.mobil2)>MOBIL2,</cfif>
			<cfif len(attributes.tax_number)>TAX_NUMBER,</cfif>
			<cfif len(attributes.tax_office)>TAX_OFFICE,</cfif>
			IMCAT_ID,
			IM,
			PHOTO,
			PHOTO_SERVER_ID,
			IDENTYCARD_CAT,
			IDENTYCARD_NO,
		<cfif attributes.lang1 gt 0>
			LANG1,
			LANG1_SPEAK,
			LANG1_MEAN,
			LANG1_WRITE,
			LANG1_WHERE,
		</cfif>
		<cfif attributes.lang2 gt 0>
			LANG2,
			LANG2_SPEAK,
			LANG2_MEAN,
			LANG2_WRITE,
			LANG2_WHERE,
		</cfif>	
		<cfif attributes.lang3 gt 0>	
			LANG3,
			LANG3_SPEAK,
			LANG3_MEAN,
			LANG3_WRITE,
			LANG3_WHERE,
		</cfif>
		<cfif attributes.lang4 gt 0>
			LANG4,
			LANG4_SPEAK,
			LANG4_MEAN,
			LANG4_WRITE,
			LANG4_WHERE,
		</cfif>
		<cfif attributes.lang5 gt 0>
			LANG5,
			LANG5_SPEAK,
			LANG5_MEAN,
			LANG5_WRITE,
			LANG5_WHERE,
		</cfif>
			KURS1,
			<cfif len(attributes.kurs1_yil)>KURS1_YIL,</cfif>
			<cfif len(attributes.kurs1_yer)>KURS1_YER,</cfif>
			<cfif len(attributes.kurs1_gun)>KURS1_GUN,</cfif>
			KURS2,
			<cfif len(attributes.kurs2_yil)>KURS2_YIL,</cfif>
			<cfif len(attributes.kurs2_yer)>KURS2_YER,</cfif>
			<cfif len(attributes.kurs2_gun)>KURS2_GUN,</cfif>
			KURS3,
			<cfif len(attributes.kurs3_yil)>KURS3_YIL,</cfif>
			<cfif len(attributes.kurs3_yer)>KURS3_YER,</cfif>
			<cfif len(attributes.kurs3_gun)>KURS3_GUN,</cfif>
			<cfif len(attributes.comp_exp)>COMP_EXP,</cfif>
			<cfif len(attributes.hometelcode)>HOMETELCODE,</cfif>
			<cfif len(attributes.hometel)>HOMETEL,</cfif>
			HOMEADDRESS,
			HOMEPOSTCODE,
			HOMECOUNTY,
			HOMECITY,
			HOMECOUNTRY,
			<cfif isdefined('attributes.prefered_city') and len(attributes.prefered_city)>PREFERED_CITY,</cfif>
			IS_TRIP,
			APPLICANT_NOTES,
			MILITARY_STATUS,
			MILITARY_DELAY_REASON,
			MILITARY_DELAY_DATE,
			MILITARY_FINISHDATE,
			MILITARY_MONTH,
			MILITARY_RANK,
			MILITARY_EXEMPT_DETAIL,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP,
			RECORD_APP_DATE,
			RECORD_APP,
			RECORD_APP_DATE,
			TC_IDENTY_NO,
			DEFECTED_PROBABILITY,
			ILLNESS_PROBABILITY,
			<cfif len(attributes.illness_detail)>ILLNESS_DETAIL,</cfif>
			<cfif len(attributes.surgical_operation)>SURGICAL_OPERATION,</cfif>	
			<cfif len(attributes.training_level)>TRAINING_LEVEL,</cfif>
			<cfif len(attributes.investigation)>INVESTIGATION,</cfif>
			DRIVER_LICENCE,
			LICENCECAT_ID,
			LICENCE_START_DATE,
			DRIVER_LICENCE_ACTIVED,
			NATIONALITY,
			CLUB,
			USE_CIGARETTE,
			MARTYR_RELATIVE,
			HOME_STATUS,
			<cfif len(attributes.hobby)>HOBBY,</cfif>
			WORK_STARTED,
			WORK_FINISHED
			)
		VALUES
			(
			-1,
			1,
		<cfif isdefined("attributes.sentenced") and len(attributes.sentenced)>
			#attributes.sentenced#,
		</cfif>	
		<cfif isDefined("attributes.defected") and len(attributes.defected)>
			#attributes.defected#,
			<cfif isdefined('attributes.defected_level') and len(attributes.defected_level)>
				#attributes.defected_level#,
			<cfelse>
				NULL,
			</cfif>
		</cfif>		
		<cfif isDefined("attributes.sex")>
			#attributes.sex#,
		</cfif>
			'#attributes.name#',
		<cfif len(attributes.worktelcode)>
			'#attributes.worktelcode#',
		</cfif>
		<cfif len(attributes.worktel)>
			'#attributes.worktel#',
		</cfif>
			'#attributes.surname#',
		<cfif len(attributes.extension)>
			'#attributes.extension#',
		</cfif>
			'#attributes.email#',
		<cfif len(attributes.mobilcode)>
			'#attributes.mobilcode#',
		</cfif>
		<cfif len(attributes.mobil)>
			'#attributes.mobil#',
		</cfif>
		<cfif len(attributes.mobilcode2)>
			'#attributes.mobilcode2#',
		</cfif>
		<cfif len(attributes.mobil2)>
			'#attributes.mobil2#',
		</cfif>
		<cfif len(attributes.tax_number)>'#attributes.tax_number#',</cfif>
		<cfif len(attributes.tax_office)>'#attributes.tax_office#',</cfif>
		<cfif len(attributes.imcat_id)>#attributes.imcat_id#<cfelse>NULL</cfif>,
		'#attributes.im#',
		'#attributes.photo#',
		#fusebox.server_machine#,
		<cfif len(attributes.identycard_cat)>#attributes.identycard_cat#<cfelse>NULL</cfif>,
		'#attributes.identycard_no#',		
		<cfif attributes.lang1 gt 0>
			#attributes.lang1#,
			#attributes.lang1_speak#,
			#attributes.lang1_mean#,
			#attributes.lang1_write#,
			'#attributes.lang1_where#',
		</cfif>
		<cfif len(attributes.lang2)>
			#attributes.lang2#,
			#attributes.lang2_speak#,
			#attributes.lang2_mean#,
			#attributes.lang2_write#,
			'#attributes.lang2_where#',
		</cfif>	
		<cfif len(attributes.lang3)>
			#attributes.lang3#,
			#attributes.lang3_speak#,
			#attributes.lang3_mean#,
			#attributes.lang3_write#,
			'#attributes.lang3_where#',
		</cfif>
		<cfif len(attributes.lang4)>
			#attributes.lang4#,
			#attributes.lang4_speak#,
			#attributes.lang4_mean#,
			#attributes.lang4_write#,
			'#attributes.lang4_where#',
		</cfif>
		<cfif len(attributes.lang5)>
			#attributes.lang5#,
			#attributes.lang5_speak#,
			#attributes.lang5_mean#,
			#attributes.lang5_write#,
			'#attributes.lang5_where#',
		</cfif>
			'#attributes.KURS1#',
			<cfif len(attributes.kurs1_yil)>{TS '#attributes.kurs1_yil#-01-01 00:00:00'},</cfif>
			<cfif len(attributes.kurs1_yer)>'#attributes.kurs1_yer#',</cfif>
			<cfif len(attributes.kurs1_gun)>#attributes.kurs1_gun#,</cfif>
			'#attributes.kurs2#',
			<cfif len(attributes.kurs2_yil)>{TS '#attributes.kurs2_yil#-01-01 00:00:00'},</cfif>
			<cfif len(attributes.kurs2_yer)>'#attributes.kurs2_yer#',</cfif>
			<cfif len(attributes.kurs2_gun)>#attributes.kurs2_gun#,</cfif>
			'#attributes.kurs3#',
			<cfif len(attributes.kurs3_yil)>{TS '#attributes.kurs3_yil#-01-01 00:00:00'},</cfif>
			<cfif len(attributes.kurs3_yer)>'#attributes.kurs3_yer#',</cfif>
			<cfif len(attributes.kurs3_gun)>#attributes.KURS3_GUN#,</cfif>			
			<cfif len(attributes.comp_exp)>'#attributes.comp_exp#',</cfif>
			<cfif len(attributes.hometelcode)>'#attributes.hometelcode#',</cfif>
			<cfif len(attributes.hometel)>'#attributes.hometel#',</cfif>
			'#attributes.homeaddress#',
			'#attributes.homepostcode#',
			'#attributes.homecounty#',
			<cfif len(attributes.homecity_name) and len(attributes.homecity)>#attributes.homecity#,<cfelse>NULL,</cfif>
			<cfif len(attributes.homecountry)>#attributes.homecountry#,<cfelse>NULL,</cfif>
			<cfif isdefined('attributes.prefered_city') and len(attributes.prefered_city)>',#attributes.prefered_city#,',</cfif>
			#attributes.is_trip#,
			'#attributes.applicant_notes#',
			#attributes.military_status#,
			<cfif attributes.military_status eq 4 and len(attributes.MILITARY_DELAY_REASON)>'#attributes.MILITARY_DELAY_REASON#',<cfelse>NULL,</cfif>
			<cfif attributes.military_status eq 4 and len(attributes.MILITARY_DELAY_DATE)>#attributes.MILITARY_DELAY_DATE#,<cfelse>NULL,</cfif>
			<cfif attributes.military_status eq 1 and len(attributes.military_finishdate)>#attributes.military_finishdate#,<cfelse>NULL,</cfif>
			<cfif attributes.military_status eq 1 and len(attributes.military_month)>#attributes.military_month#,<cfelse>NULL,</cfif>
			<cfif attributes.military_status eq 1 and isdefined('attributes.military_rank')>#attributes.military_rank#,<cfelse>NULL,</cfif>
			<cfif attributes.military_status eq 2>'#attributes.military_exempt_detail#',<cfelse>NULL,</cfif>
			NULL,
			NULL,
			NULL,
			#NOW()#,
			<cfif isdefined("session.ww.userid") and len(session.ww.userid)>#SESSION.WW.USERID#,<cfelse>NULL,</cfif>
			'#CGI.REMOTE_ADDR#',
			#attributes.defected_probability#,
			#attributes.illness_probability#,
			<cfif len(attributes.illness_detail)>'#attributes.illness_detail#',</cfif>
			<cfif len(attributes.surgical_operation)>'#attributes.surgical_operation#',</cfif>	
			 <cfif len(attributes.training_level)>#attributes.training_level#,</cfif>
			<cfif isdefined("attributes.notice_id") and len(attributes.notice_id)>#attributes.notice_id#,</cfif>
			<cfif len(attributes.investigation)>'#attributes.investigation#',</cfif>
			'#attributes.driver_licence#',
			<cfif len(attributes.driver_licence_type)>#attributes.driver_licence_type#<cfelse>NULL</cfif>,
			<cfif len(attributes.licence_start_date)>#attributes.licence_start_date#<cfelse>NULL</cfif>,
			<cfif len(attributes.driver_licence_actived)>#attributes.driver_licence_actived#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.nationality') and len(attributes.nationality)>#attributes.nationality#<cfelse>NULL</cfif>,
			'#attributes.club#',
			#attributes.use_cigarette#,
			#attributes.martyr_relative#,
			<cfif isdefined('attributes.home_status')>#attributes.home_status#<cfelse>NULL</cfif>,
			<cfif len(attributes.hobby)>'#attributes.hobby#',</cfif>
			0,
			0
		) 
	</cfquery>
	<!--- Bilgisayar Bilgisi --->
	<cfif len(attributes.comp_exp)>
		<cfquery name="ADD_TEACHER_INFO" datasource="#dsn#">
			INSERT INTO 
				EMPLOYEES_APP_TEACHER_INFO
					(
					 EMPAPP_ID,
					 COMPUTER_EDUCATION
					 )
				VALUES
					(
					  #MAX_ID.IDENTITYCOL#,
					  ',-1,'
					 )
		</cfquery>
	</cfif>
	<!--- İş Tecrübeleri --->
	<cfset attributes.exp_fark = "">
	<cfif attributes.row_count gt 0>
		<cfloop from="1" to="#attributes.row_count#" index="k">
			<cfif isdefined("attributes.exp_start#k#") and len(evaluate('attributes.exp_start#k#'))>
				<cfset attributes.exp_start=evaluate('attributes.exp_start#k#')>
				<cf_date tarih="attributes.exp_start">
			<cfelse>
				<cfset attributes.exp_start="">
			</cfif>
			<cfif isdefined("attributes.exp_finish#k#") and  len(evaluate('attributes.exp_finish#k#'))>
				<cfset attributes.exp_finish=evaluate('attributes.exp_finish#k#')>
				<cf_date tarih="attributes.exp_finish">
			<cfelse>
				<cfset attributes.exp_finish="">
			</cfif>
			<cfif len(attributes.exp_start) gt 9 and len(attributes.exp_finish) gt 9>
			   <cfset attributes.exp_fark = datediff("d",attributes.exp_start,attributes.exp_finish)>
			</cfif>
			<cfif isdefined("attributes.row_kontrol#k#") and evaluate("attributes.row_kontrol#k#")>
			<cfquery name="ADD_EMPLOYEES_APP_WORK_INFO" datasource="#dsn#">
				INSERT INTO
					EMPLOYEES_APP_WORK_INFO
					(
					EMPAPP_ID,
					EMPLOYEE_ID,
					EXP,
					EXP_POSITION,
					EXP_START,
					EXP_FINISH,
					EXP_FARK,
					EXP_REASON,
					EXP_EXTRA,
					EXP_TELCODE,
					EXP_TEL,
					EXP_SECTOR_CAT,
					EXP_SALARY,
					EXP_EXTRA_SALARY,
					EXP_TASK_ID,
					IS_CONT_WORK
					)
				VALUES
					(
					#MAX_ID.IDENTITYCOL#,
					NULL,
					<cfif len(evaluate('attributes.exp_name#k#'))>'#wrk_eval('attributes.exp_name#k#')#'<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_position#k#'))>'#wrk_eval('attributes.exp_position#k#')#'<cfelse>NULL</cfif>,
					<cfif len(attributes.exp_start)>#attributes.exp_start#,<cfelse>NULL,</cfif>
					<cfif len(attributes.exp_finish)>#attributes.exp_finish#,<cfelse>NULL,</cfif>
					<cfif len(attributes.exp_fark)>#attributes.exp_fark#<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_reason#k#'))>'#Replace(evaluate('attributes.exp_reason#k#'),"'"," ","all")#'<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_extra#k#'))>'#Replace(evaluate('attributes.exp_extra#k#'),"'"," ","all")#'<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_telcode#k#'))>'#wrk_eval('attributes.exp_telcode#k#')#'<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_tel#k#'))>'#wrk_eval('attributes.exp_tel#k#')#'<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_sector_cat#k#'))>#evaluate('attributes.exp_sector_cat#k#')#<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_salary#k#'))>#evaluate('attributes.exp_salary#k#')#<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_extra_salary#k#'))>'#wrk_eval('attributes.exp_extra_salary#k#')#'<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_task_id#k#'))>#evaluate('attributes.exp_task_id#k#')#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.is_cont_work#k#") and evaluate('attributes.is_cont_work#k#') eq 1>1<cfelse>0</cfif>
					)
			</cfquery>
			</cfif>
		</cfloop>
	</cfif>
	<!--- İş Tecrübeleri --->
	<!--- Eğitim Bilgileri --->
	<cfif attributes.row_edu gt 0>
		<cfloop from="1" to="#attributes.row_edu#" index="j">
			<cfif isdefined("attributes.edu_high_part_id#j#") and  len(evaluate('attributes.edu_high_part_id#j#'))  and evaluate('attributes.edu_type#j#') eq 3>
				<cfset bolum_id = evaluate('attributes.edu_high_part_id#j#')>
			<cfelseif isdefined("attributes.edu_part_id#j#") and len(evaluate('attributes.edu_part_id#j#')) >
				<cfset bolum_id = evaluate('attributes.edu_part_id#j#')>
			<cfelse>
				<cfset bolum_id = -1>
			</cfif>
			<cfif isdefined("attributes.row_kontrol_edu#j#") and evaluate("attributes.row_kontrol_edu#j#")>
				<cfquery name="ADD_EMPLOYEES_APP_EDU_INFO" datasource="#dsn#">
					INSERT INTO
						EMPLOYEES_APP_EDU_INFO
						(
						EMPAPP_ID,
						EMPLOYEE_ID,
						EDU_TYPE,
						EDU_ID,
						EDU_NAME,
						EDU_PART_ID,
						EDU_PART_NAME,
						EDU_START,
						EDU_FINISH,
						EDU_RANK,
						IS_EDU_CONTINUE
						)
						VALUES
						(
						#MAX_ID.IDENTITYCOL#,
						NULL,
						#evaluate('attributes.edu_type#j#')#,
						<cfif isdefined("attributes.edu_id#j#") and len(evaluate('attributes.edu_id#j#'))>#evaluate('attributes.edu_id#j#')#<cfelseif evaluate('attributes.edu_type#j#') eq 3 or evaluate('attributes.edu_type#j#') eq 4 or evaluate('attributes.edu_type#j#') eq 5 or evaluate('attributes.edu_type#j#') eq 6>-1<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.edu_name#j#") and len(evaluate('attributes.edu_name#j#'))>'#wrk_eval('attributes.edu_name#j#')#'<cfelse>NULL</cfif>,
						<cfif isdefined("bolum_id") and len(bolum_id)>#bolum_id#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.edu_part_name#j#") and len(evaluate('attributes.edu_part_name#j#'))>'#wrk_eval('attributes.edu_part_name#j#')#'<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.edu_start#j#") and len(evaluate('attributes.edu_start#j#'))>#evaluate('attributes.edu_start#j#')#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.edu_finish#j#") and len(evaluate('attributes.edu_finish#j#'))>#evaluate('attributes.edu_finish#j#')#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.edu_rank#j#") and len(evaluate('attributes.edu_rank#j#'))>'#wrk_eval('attributes.edu_rank#j#')#'<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.is_edu_continue#j#") and evaluate('attributes.is_edu_continue#j#') eq 1>1<cfelse>0</cfif>
						)
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
	<!--- Eğitim Bilgileri --->
	<cfquery name="ADD_IDENTY" datasource="#dsn#">
		INSERT INTO
			EMPLOYEES_IDENTY
			(
			EMPAPP_ID,
			TC_IDENTY_NO,
		<cfif len(attributes.TAX_NUMBER)>TAX_NUMBER,</cfif>
		<cfif len(attributes.tax_office)>TAX_OFFICE,</cfif>
			BIRTH_DATE,
			BIRTH_PLACE,
			MARRIED,
			CITY,
			RECORD_DATE,
			RECORD_IP,
			RECORD_EMP
			)
		VALUES
			(
			#MAX_ID.IDENTITYCOL#,
			'#attributes.tc_identy_no#',	
		<cfif len(attributes.tax_number)>
			'#attributes.tax_number#',
		</cfif>
		<cfif len(attributes.tax_office)>
			'#attributes.tax_office#',
		</cfif>
		<cfif len(attributes.birth_date)>#attributes.birth_date#,<cfelse>NULL,</cfif>
			'#attributes.birth_place#',
			#attributes.married#,
			'#attributes.city#',
			#now()#,
			'#cgi.REMOTE_ADDR#',
			<cfif isdefined("session.ww.userid") and len(session.ww.userid)>#SESSION.WW.USERID#<cfelse>NULL</cfif>
			)
	</cfquery>
	<!--- çalışmak istediği birimler--->
		<cfquery name="get_cv_unit" datasource="#DSN#">
			SELECT * FROM SETUP_CV_UNIT
		</cfquery>
 		<cfoutput query="get_cv_unit">
		<cfif isdefined('unit#get_cv_unit.unit_id#') and len(evaluate('unit#get_cv_unit.unit_id#'))>
			<cfquery name="add_unit" datasource="#dsn#">
				INSERT 
					INTO EMPLOYEES_APP_UNIT
					(
						EMPAPP_ID,
						UNIT_ID,
						UNIT_ROW
					)
					VALUES
					(
						#MAX_ID.IDENTITYCOL#,
						#get_cv_unit.unit_id#,
						#evaluate('unit#get_cv_unit.unit_id#')#
					)
			</cfquery> 
		</cfif>
		</cfoutput>
	<!--- //çalışmak istediği birimler--->
	</cftransaction>
</cflock>

<script type="text/javascript">
	 window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.welcome';
	 windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_message','small');
</script>
