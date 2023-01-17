<cfquery name="RESIM" datasource="#DSN#">
	SELECT PHOTO,PHOTO_SERVER_ID,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID=#attributes.EMPLOYEE_ID#
</cfquery>
<cfif isDefined("del_photo") and isdefined('attributes._photo_') and len(attributes._photo_)>
	<cf_del_server_file output_file="hr/#resim.photo#" output_server="#resim.photo_server_id#">
	<cfset attributes.employee_img = "">
<cfelse>
	<cfif isDefined("attributes.employee_img") and len(attributes.employee_img)>
	<!--- eski varsa sil --->
		<cfif  isdefined('attributes._photo_') and len(attributes._photo_)>
			<cf_del_server_file output_file="hr/#resim.photo#" output_server="#resim.photo_server_id#">
		</cfif>
	<!--- yeni upload --->
		<CFTRY>
			<cffile 
				action="UPLOAD" 
				filefield="employee_img" 
				destination="#upload_folder#hr#dir_seperator#" 
				mode="777" 
				nameconflict="MAKEUNIQUE" 
			> 
			<cfset file_name = createUUID()>
			<cffile action="rename" source="#upload_folder#hr#dir_seperator##cffile.serverfile#" destination="#upload_folder#hr#dir_seperator##file_name#.#cffile.serverfileext#">
			<cfset attributes.employee_img = '#file_name#.#cffile.serverfileext#'>
			<CFCATCH type="Any">
				<script type="text/javascript">
					alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
					history.back();
				</script>
				<cfabort>
			</CFCATCH>  
		</CFTRY>		
	<cfelseif isdefined('attributes._photo_')>
		<!--- eski deðeri yerine yaz --->
		<cfset attributes.employee_img = attributes._photo_>
	</cfif>
</cfif>
<cfif isDefined("attributes.signature_") and len(attributes.signature_)>
	<cfset upload_folder = "#upload_folder#hr#dir_seperator#">
	<CFTRY>
		<cffile action="UPLOAD" 
				filefield="signature_" 
				destination="#upload_folder#" 
				mode="777" 
				nameconflict="MAKEUNIQUE">

		<cfset file_name = createUUID()>
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
		<cfset attributes.signature_ = '#file_name#.#cffile.serverfileext#'>
		<CFCATCH type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
				history.back();
			</script>
			<cfabort>
		</CFCATCH>  
	</CFTRY>
</cfif>
<cfset binary_signature_db = ''>
<cfif isDefined("attributes.signature_") and len(attributes.signature_)>
	<cffile action="readBinary" file="#upload_folder##attributes.signature_#" variable="binary_signature">
	<cfset binary_signature_db = binaryencode(binary_signature,'Base64')> <!---db ye kaydet böylece --->
	<cffile action="delete" file="#upload_folder##file_name#.#cffile.serverfileext#">	
</cfif>

<cf_date tarih ="attributes.military_delay_date">
<cf_date tarih ="attributes.military_finishdate">
<cfset tools = "">
<cfloop from="1" to="12" index="i">
	<cfif len(evaluate("form.tool"&i))>
		<cfset tools = tools & ";" & evaluate("form.tool"&i) & ";" & evaluate("form.tool"&i&"_level")>
	</cfif>
</cfloop>

<cfif ListLen(tools)>
	<cfset tools = right(tools,len(tools)-1)>
</cfif>

<cflock name="#CREATEUUID()#" timeout="20">
<cftransaction>
<cfquery name="UPD_EMP" datasource="#DSN#">
	UPDATE
		EMPLOYEES
	SET
		EMPLOYEE_EMAIL= <cfif isdefined('attributes.employee_email') and len(attributes.employee_email)><cfqueryparam cfsqltype="cf_sql_varchar" value='#attributes.employee_email#'><cfelse>NULL</cfif>,
		EMPLOYEE_STAGE = <cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>#attributes.process_stage#<cfelse>0</cfif>,
		EMPLOYEE_NAME=<cfif isdefined('attributes.employee_name') and len(attributes.employee_name)><cfqueryparam cfsqltype="cf_sql_varchar" value='#attributes.employee_name#'><cfelse>NULL</cfif>,
		EMPLOYEE_SURNAME=<cfif isdefined('attributes.employee_surname') and len(attributes.employee_surname)><cfqueryparam cfsqltype="cf_sql_varchar" value='#attributes.employee_surname#'><cfelse>NULL</cfif>,
		MOBILTEL=<cfif isdefined('attributes.mobiltel') and len(attributes.mobiltel)><cfqueryparam cfsqltype="cf_sql_varchar" value='#attributes.mobiltel#'><cfelse>NULL</cfif>,
		MOBILCODE=<cfif isdefined('attributes.mobilcode') and len(attributes.mobilcode)><cfqueryparam cfsqltype="cf_sql_varchar" value='#attributes.mobilcode#'><cfelse>NULL</cfif>,
		BIOGRAPHY = <cfif isdefined('attributes.biography') and len(attributes.biography)><cfqueryparam cfsqltype="cf_sql_varchar" value='#attributes.biography#'><cfelse>NULL</cfif>
		<cfif len(binary_signature_db)>
			,WET_SIGNATURE = <cfqueryparam cfsqltype="cf_sql_varchar" value='#binary_signature_db#'>
		</cfif>
		<cfif isdefined('attributes.employee_img')>
			,PHOTO = <cfqueryparam cfsqltype="cf_sql_varchar" value='#attributes.employee_img#'>
			,PHOTO_SERVER_ID=#fusebox.server_machine#
		</cfif> 
	 WHERE
		EMPLOYEE_ID = #attributes.employee_id#
</cfquery>
<cfquery name="upd_position_emp_name" datasource="#dsn#">
	UPDATE 
		EMPLOYEE_POSITIONS
	SET
		EMPLOYEE_EMAIL = <cfif len(attributes.EMPLOYEE_EMAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#EMPLOYEE_EMAIL#"><cfelse>NULL</cfif>,
		EMPLOYEE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#EMPLOYEE_NAME#">,
		EMPLOYEE_SURNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#EMPLOYEE_SURNAME#">
	WHERE
		EMPLOYEE_ID = #attributes.employee_id#
</cfquery>

<cfquery name="DETAIL_EXISTS" datasource="#DSN#">
	SELECT 
		EMPLOYEE_DETAIL_ID
	FROM 
		EMPLOYEES_DETAIL 
	WHERE 
		EMPLOYEE_ID = #attributes.employee_id#
</cfquery>
<cfif detail_exists.recordcount>
	<cfquery name="UPD_EMP_DET" datasource="#DSN#">
		UPDATE
			EMPLOYEES_DETAIL
		SET
			UPDATE_DATE = #now()#,
			UPDATE_IP = '#cgi.REMOTE_ADDR#',
			UPDATE_EMP = #session.ep.userid#,
			SENTENCED_SIX_MONTH =<cfif isdefined("attributes.sentenced_six_month")>#attributes.sentenced_six_month#,<cfelse>NULL,</cfif>
			MILITARY_STATUS =<cfif isdefined("attributes.military_status")>#attributes.military_status#,<cfelse>NULL,</cfif>
			MILITARY_DELAY_REASON =<cfif isdefined("attributes.military_delay_reason") and len(attributes.military_delay_reason) and isdefined("attributes.military_status") and attributes.military_status eq 4> '#attributes.military_delay_reason#'<cfelse>NULL</cfif>,
			MILITARY_DELAY_DATE =<cfif isdefined("attributes.military_delay_date") and len(attributes.military_delay_date)  and isdefined("attributes.military_status") and attributes.military_status eq 4>#attributes.military_delay_date#<cfelse>NULL</cfif>,
			MILITARY_FINISHDATE =<cfif isdefined("attributes.military_finishdate") and len(attributes.military_finishdate)  and isdefined("attributes.military_status") and attributes.military_status eq 1>#attributes.military_finishdate#<cfelse>NULL</cfif>,
			MILITARY_EXEMPT_DETAIL =<cfif isdefined('attributes.military_exempt_detail') and len(attributes.military_exempt_detail) and isdefined("attributes.military_status") and attributes.military_status eq 2>'#attributes.military_exempt_detail#'<cfelse>NULL</cfif>,
			MILITARY_MONTH=<cfif isdefined('attributes.military_month') and len(attributes.military_month) and isdefined("attributes.military_status") and attributes.military_status eq 1>#attributes.military_month#<cfelse>NULL</cfif>,
			MILITARY_RANK=<cfif isdefined("attributes.military_status") and attributes.military_status eq 1 and isdefined("attributes.military_rank") and len(attributes.military_rank)>#attributes.military_rank#<cfelse>NULL</cfif>,
			USE_CIGARETTE=<cfif isdefined('attributes.use_cigarette')>#attributes.use_cigarette#,<cfelse>NULL,</cfif>
			MARTYR_RELATIVE=<cfif isdefined('attributes.martyr_relative')>#attributes.martyr_relative#,<cfelse>NULL,</cfif>
			<cfif isdefined("attributes.defected") and attributes.defected eq 1>
				DEFECTED=#attributes.defected#,
				DEFECTED_LEVEL =#attributes.defected_level#,
			<cfelse>
				DEFECTED =0,
				DEFECTED_LEVEL =0,
			</cfif>
			SENTENCED =<cfif isdefined("attributes.sentenced")>#attributes.sentenced#,<cfelse> NULL,</cfif>
			SEX=<cfif isdefined('attributes.sex')>#attributes.sex#,<cfelse>1,</cfif>
			LAST_SCHOOL =<cfif len(attributes.last_school)>#attributes.last_school#<cfelse>NULL</cfif>,
		<cfif len(attributes.directTelCode_spc)>
			DIRECT_TELCODE_SPC = '#attributes.directTelCode_spc#',
		</cfif>
		<cfif len(attributes.directTel_spc)>
			DIRECT_TEL_SPC = '#attributes.directTel_spc#',
		</cfif>
		<cfif len(attributes.extension_spc)>
			EXTENSION_SPC = '#attributes.extension_spc#',
		</cfif>
		<cfif len(attributes.mobilcode_spc)>
			MOBILCODE_SPC = '#attributes.mobilcode_spc#',
		</cfif>
		<cfif len(attributes.mobiltel_spc)>
			MOBILTEL_SPC = '#attributes.mobiltel_spc#',
		</cfif>
		<cfif len(attributes.mobilcode2_spc)>
			MOBILCODE2_SPC = '#attributes.mobilcode2_spc#',
		</cfif>
		<cfif len(attributes.mobiltel2_spc)>
			MOBILTEL2_SPC = '#attributes.mobiltel2_spc#',
		</cfif>
		<cfif len(attributes.email_spc)>
			EMAIL_SPC = '#attributes.email_spc#',
		</cfif>
			CONTACT1=<cfif len(attributes.contact1)>'#attributes.contact1#'<cfelse>NULL</cfif>,
			CONTACT1_RELATION=<cfif len(attributes.contact1_relation)>'#attributes.contact1_relation#'<cfelse>NULL</cfif>,
			CONTACT1_EMAIL=<cfif len(attributes.contact1_email)>'#attributes.contact1_email#'<cfelse>NULL</cfif>,
			CONTACT1_TELCODE=<cfif len(attributes.contact1_telcode)>'#attributes.contact1_telcode#'<cfelse>NULL</cfif>,
			CONTACT1_TEL=<cfif len(attributes.contact1_tel)>'#attributes.contact1_tel#'<cfelse>NULL</cfif>,
			HOMETEL_CODE=<cfif len(attributes.hometel_code)>'#attributes.hometel_code#'<cfelse>NULL</cfif>,
			HOMETEL=<cfif len(attributes.hometel)>'#attributes.hometel#'<cfelse>NULL</cfif>,
			HOMEADDRESS=<cfif len(attributes.homeaddress)>'#attributes.homeaddress#'<cfelse>NULL</cfif>,
			HOMEPOSTCODE=<cfif len(attributes.homepostcode)>'#attributes.homepostcode#'<cfelse>NULL</cfif>,
			HOMECOUNTY=<cfif len(attributes.homecounty)>'#attributes.homecounty#'<cfelse>NULL</cfif>,
			HOMECITY=<cfif len(attributes.homecity)>#attributes.homecity#<cfelse>NULL</cfif>,
			HOMECOUNTRY=<cfif len(attributes.homecountry)>#attributes.homecountry#<cfelse>NULL</cfif>,			
			COMP_EXP=<cfif len(attributes.comp_detail)>'#attributes.comp_detail#'<cfelse>NULL</cfif>,
			TOOLS = '#TOOLS#',
			CLUB = <cfif len(attributes.club)>'#attributes.club#'<cfelse>NULL</cfif>,
			ILLNESS_PROBABILITY = <cfif isdefined('attributes.illness_probability') and len(attributes.illness_probability)>#attributes.illness_probability#<cfelse>NULL</cfif>,
			ILLNESS_DETAIL = <cfif len(illness_detail)>'#attributes.illness_detail#'<cfelse>NULL</cfif>
		WHERE
			EMPLOYEE_DETAIL_ID = #DETAIL_EXISTS.EMPLOYEE_DETAIL_ID#
	</cfquery>
<cfelse>
	<cfquery name="ADD_EMP_DET" datasource="#DSN#">
		INSERT INTO
			EMPLOYEES_DETAIL
			(
				EMPLOYEE_ID,
				SEX,
				USE_CIGARETTE,
				MARTYR_RELATIVE,
				PARTNER_COMPANY, 
				PARTNER_POSITION, 
				SENTENCED,
				SENTENCED_SIX_MONTH,
				MILITARY_DELAY_REASON,
				MILITARY_DELAY_DATE,
				MILITARY_STATUS,
				MILITARY_FINISHDATE,
				MILITARY_MONTH,
				MILITARY_EXEMPT_DETAIL,
				MILITARY_RANK,
				DEFECTED,
				DEFECTED_LEVEL,
				<cfif len(attributes.last_school)>LAST_SCHOOL,</cfif>
				CONTACT1,
				CONTACT1_RELATION,
				CONTACT1_EMAIL,
				CONTACT1_TELCODE,
				CONTACT1_TEL,
				CONTACT2,
				CONTACT2_RELATION,
				CONTACT2_EMAIL,
				CONTACT2_TELCODE,
				CONTACT2_TEL,
				HOMETEL_CODE,
				HOMETEL,
				HOMEADDRESS,
				HOMEPOSTCODE,
				HOMECOUNTY,
				HOMECITY,
				HOMECOUNTRY,
				COMP_EXP,
				TOOLS,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP,
				CLUB,
				DRIVER_LICENCE_ACTIVED,
				ILLNESS_PROBABILITY,
				ILLNESS_DETAIL,
				DIRECT_TELCODE_SPC,
				DIRECT_TEL_SPC,
				EXTENSION_SPC,
				MOBILCODE_SPC,
				MOBILTEL_SPC,
				MOBILCODE2_SPC,
				MOBILTEL2_SPC,
				EMAIL_SPC
			)
		VALUES
			(
				#attributes.EMPLOYEE_ID#,
				<cfif isdefined('attributes.use_cigarette')>#attributes.use_cigarette#,<cfelse>NULL,</cfif>
				<cfif isdefined('attributes.sex')>#attributes.sex#,<cfelse>1,</cfif>
				<cfif isdefined('attributes.martyr_relative')>#attributes.martyr_relative#,<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.partner_company") and len(attributes.partner_company)>'#attributes.partner_company#',<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.partner_position") and len(attributes.partner_position)>'#attributes.partner_position#',<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.sentenced")>#attributes.sentenced#,<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.sentenced_six_month")>#attributes.sentenced_six_month#,<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.military_delay_reason") and len(attributes.military_delay_reason)  and isdefined("attributes.military_status") and attributes.military_status eq 4>'#attributes.military_delay_reason#',<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.military_delay_date") and len(attributes.military_delay_date)  and isdefined("attributes.military_status") and attributes.military_status eq 4>#attributes.military_delay_date#,<cfelse>NULL,</cfif>
				<cfif isdefined('attributes.military_status')>#attributes.military_status#,<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.military_finishdate") and len(attributes.military_finishdate)  and isdefined("attributes.military_status") and attributes.military_status eq 1>#attributes.military_finishdate#,<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.military_month") and len(attributes.military_month)  and isdefined("attributes.military_status") and attributes.military_status eq 1>#attributes.military_month#,<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.military_exempt_detail") and len(attributes.military_exempt_detail)  and isdefined("attributes.military_status") and attributes.military_status eq 2>'#attributes.military_exempt_detail#',<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.military_rank") and len(attributes.military_rank)>#attributes.military_rank#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.defected')>#attributes.defected#,<cfelse>NULL,</cfif>
				<cfif isdefined('attributes.defected_level')>#attributes.defected_level#,<cfelse>0,</cfif>
				<cfif len(attributes.last_school)>#attributes.last_school#,</cfif>
				<cfif len(attributes.kurs3_gun)>#attributes.kurs3_gun#<cfelse>NULL</cfif>,
				<cfif len(attributes.contact1)>'#attributes.contact1#'<cfelse>NULL</cfif>,
				<cfif len(attributes.contact1_relation)>'#attributes.contact1_relation#'<cfelse>NULL</cfif>,
				<cfif len(attributes.contact1_email)>'#attributes.contact1_email#'<cfelse>NULL</cfif>,
				<cfif len(attributes.contact1_telcode)>'#attributes.contact1_telcode#'<cfelse>NULL</cfif>,
				<cfif len(attributes.contact1_tel)>'#attributes.contact1_tel#'<cfelse>NULL</cfif>,
				<cfif len(attributes.contact2)>'#attributes.contact2#'<cfelse>NULL</cfif>,
				<cfif len(attributes.contact2_relation)>'#attributes.contact2_relation#'<cfelse>NULL</cfif>,
				<cfif len(attributes.contact2_email)>'#attributes.contact2_email#'<cfelse>NULL</cfif>,
				<cfif len(attributes.contact2_telcode)>'#attributes.contact2_telcode#'<cfelse>NULL</cfif>,
				<cfif len(attributes.contact2_tel)>'#attributes.contact2_tel#'<cfelse>NULL</cfif>,
				<cfif len(attributes.hometel_code)>'#attributes.hometel_code#'<cfelse>NULL</cfif>,
				<cfif len(attributes.hometel)>'#attributes.hometel#'<cfelse>NULL</cfif>,
				<cfif len(attributes.homeaddress)>'#attributes.homeaddress#'<cfelse>NULL</cfif>,
				<cfif len(attributes.homepostcode)>'#attributes.homepostcode#'<cfelse>NULL</cfif>,
				<cfif len(attributes.homecounty)>'#attributes.homecounty#'<cfelse>NULL</cfif>,
				<cfif len(attributes.homecity)>#attributes.homecity#<cfelse>NULL</cfif>,
				<cfif len(attributes.homecountry)>#attributes.homecountry#<cfelse>NULL</cfif>,
				'#attributes.comp_detail#',
				'#TOOLS#',
				#now()#,
				'#cgi.REMOTE_ADDR#',
				#session.ep.userid#,
				<cfif len(attributes.club)>'#attributes.club#'<cfelse>NULL</cfif>,
				<cfif len(attributes.driver_licence_actived)>#attributes.driver_licence_actived#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.illness_probability") and len(attributes.illness_probability)>#attributes.illness_probability#<cfelse>NULL</cfif>,
				<cfif len(attributes.illness_detail)>'#attributes.illness_detail#'<cfelse>NULL</cfif>
				<cfif len(attributes.directTelCode_spc)>'#attributes.directTelCode_spc#'<cfelse>NULL</cfif>,
				<cfif len(attributes.directTel_spc)>'#attributes.directTel_spc#'<cfelse>NULL</cfif>,
				<cfif len(attributes.extension_spc)>'#attributes.extension_spc#'<cfelse>NULL</cfif>,
				<cfif len(attributes.mobilcode_spc)>'#attributes.mobilcode_spc#'<cfelse>NULL</cfif>,
				<cfif len(attributes.mobiltel_spc)>'#attributes.mobiltel_spc#'<cfelse>NULL</cfif>,
				<cfif len(attributes.mobilcode2_spc)>'#attributes.mobilcode2_spc#'<cfelse>NULL</cfif>,
				<cfif len(attributes.mobiltel2_spc)>'#attributes.mobiltel2_spc#'<cfelse>NULL</cfif>,
				<cfif len(attributes.email_spc)>'#attributes.email_spc#'<cfelse>NULL</cfif>
			)	
	</cfquery>
</cfif>

<!--- İş Tecrübeleri --->
<cfloop from="1" to="#attributes.row_count#" index="k">
	 <cfif isdefined("attributes.row_kontrol#k#") and evaluate("attributes.row_kontrol#k#")>
	 	<cfif len(evaluate('attributes.exp_start#k#'))>
			<cfset attributes.exp_start=evaluate('attributes.exp_start#k#')>
			<cf_date tarih="attributes.exp_start">
		<cfelse>
			<cfset attributes.exp_start="">
		</cfif>
		<cfif len(evaluate('attributes.exp_finish#k#'))>
			<cfset attributes.exp_finish=evaluate('attributes.exp_finish#k#')>
			<cf_date tarih="attributes.exp_finish">
		<cfelse>
			<cfset attributes.exp_finish="">
		</cfif>
		<cfif len(attributes.exp_start) gt 9 and len(attributes.exp_finish) gt 9>
		   <cfset attributes.exp_fark = datediff("d",attributes.exp_start,attributes.exp_finish)>
		 <cfelse>
			<cfset attributes.exp_fark="">
		</cfif>
	 	<cfif isDefined("attributes.empapp_row_id#k#") and len(evaluate("attributes.empapp_row_id#k#"))>
			<cfquery name="UPD_EMPLOYEES_APP_WORK_INFO" datasource="#DSN#">
				UPDATE
					EMPLOYEES_APP_WORK_INFO
				SET
					EXP = <cfif len(evaluate('attributes.exp_name#k#'))>'#wrk_eval('attributes.exp_name#k#')#'<cfelse>NULL</cfif>,
					EXP_POSITION = <cfif len(evaluate('attributes.exp_position#k#'))>'#wrk_eval('attributes.exp_position#k#')#'<cfelse>NULL</cfif>,
					EXP_START = <cfif len(attributes.exp_start)>#attributes.exp_start#<cfelse>NULL</cfif>,
					EXP_FINISH = <cfif len(attributes.exp_finish)>#attributes.exp_finish#<cfelse>NULL</cfif>,
					EXP_FARK = <cfif len(attributes.exp_fark)>#attributes.exp_fark#<cfelse>NULL</cfif>,
					EXP_REASON = <cfif len(evaluate('attributes.exp_reason#k#'))>'#Replace(evaluate('attributes.exp_reason#k#'),"'"," ","all")#'<cfelse>NULL</cfif>,
					EXP_EXTRA = <cfif len(evaluate('attributes.exp_extra#k#'))>'#Replace(evaluate('attributes.exp_extra#k#'),"'"," ","all")#'<cfelse>NULL</cfif>,
					EXP_TELCODE = <cfif len(evaluate('attributes.exp_telcode#k#'))>'#wrk_eval('attributes.exp_telcode#k#')#'<cfelse>NULL</cfif>,
					EXP_TEL = <cfif len(evaluate('attributes.exp_tel#k#'))>'#wrk_eval('attributes.exp_tel#k#')#'<cfelse>NULL</cfif>,
					EXP_SECTOR_CAT= <cfif len(evaluate('attributes.exp_sector_cat#k#'))>#evaluate('attributes.exp_sector_cat#k#')#<cfelse>NULL</cfif>,
					EXP_SALARY = <cfif len(evaluate('attributes.exp_salary#k#')) and evaluate('attributes.exp_salary#k#') gt 0>#evaluate('attributes.exp_salary#k#')#<cfelse>NULL</cfif>,
					EXP_EXTRA_SALARY = <cfif len(evaluate('attributes.exp_extra_salary#k#')) and evaluate('attributes.exp_extra_salary#k#') gt 0>'#wrk_eval('attributes.exp_extra_salary#k#')#'<cfelse>NULL</cfif>,
					EXP_WORK_TYPE_ID = <cfif len(evaluate('attributes.exp_work_type_id#k#')) and evaluate('attributes.exp_work_type_id#k#') gt 0>'#wrk_eval('attributes.exp_work_type_id#k#')#'<cfelse>NULL</cfif>,
					EXP_TASK_ID = <cfif len(evaluate('attributes.exp_task_id#k#'))>#evaluate('attributes.exp_task_id#k#')#<cfelse>NULL</cfif>,
					EMPLOYEE_ID = #attributes.EMPLOYEE_ID#,
					IS_CONT_WORK= <cfif isdefined("attributes.is_cont_work#k#") and evaluate('attributes.is_cont_work#k#') eq 1>1<cfelse>0</cfif>
				WHERE
					EMPAPP_ROW_ID = #evaluate("attributes.empapp_row_id#k#")#
			</cfquery>
		<cfelse>
			<cfquery name="ADD_EMPLOYEES_APP_WORK_INFO" datasource="#dsn#">
				INSERT INTO
					EMPLOYEES_APP_WORK_INFO
					(
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
					EXP_WORK_TYPE_ID,
					EXP_TASK_ID,
					IS_CONT_WORK
					)
				VALUES
					(
					#attributes.EMPLOYEE_ID#,
					<cfif len(evaluate('attributes.exp_name#k#'))>'#wrk_eval('attributes.exp_name#k#')#'<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_position#k#'))>'#wrk_eval('attributes.exp_position#k#')#'<cfelse>NULL</cfif>,
					<cfif len(attributes.exp_start)>#attributes.exp_start#<cfelse>NULL</cfif>,
					<cfif len(attributes.exp_finish)>#attributes.exp_finish#<cfelse>NULL</cfif>,
					<cfif len(attributes.exp_fark)>#attributes.exp_fark#<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_reason#k#'))>'#Replace(evaluate('attributes.exp_reason#k#'),"'"," ","all")#'<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_extra#k#'))>'#Replace(evaluate('attributes.exp_extra#k#'),"'"," ","all")#'<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_telcode#k#'))>'#wrk_eval('attributes.exp_telcode#k#')#'<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_tel#k#'))>'#wrk_eval('attributes.exp_tel#k#')#'<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_sector_cat#k#'))>#evaluate('attributes.exp_sector_cat#k#')#<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_salary#k#')) and evaluate('attributes.exp_salary#k#') gt 0>#evaluate('attributes.exp_salary#k#')#<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_extra_salary#k#')) and evaluate('attributes.exp_extra_salary#k#') gt 0>'#wrk_eval('attributes.exp_extra_salary#k#')#'<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_work_type_id#k#')) and evaluate('attributes.exp_work_type_id#k#') gt 0>'#wrk_eval('attributes.exp_work_type_id#k#')#'<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_task_id#k#'))>#evaluate('attributes.exp_task_id#k#')#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.is_cont_work#k#") and evaluate('attributes.is_cont_work#k#') eq 1>1<cfelse>0</cfif>
					)
			</cfquery>
		</cfif>
	 <cfelse>
	 	<cfif isDefined("attributes.empapp_row_id#k#") and len(evaluate("attributes.empapp_row_id#k#"))>
	 		<cfquery name="del_empapp_work_info" datasource="#dsn#">
				DELETE FROM
					EMPLOYEES_APP_WORK_INFO
				WHERE
					EMPAPP_ROW_ID = #evaluate("attributes.empapp_row_id#k#")#
			</cfquery>
		</cfif>
	 </cfif>
</cfloop>
<!--- İş Tecrübeleri --->

<!--- Referans Bilgileri--->
<cfquery name="delete_emp_reference" datasource="#dsn#">
	DELETE EMPLOYEES_REFERENCE WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
</cfquery>	
<cfloop from="1" to="#attributes.add_ref_info#" index="r">
	<cfif isdefined('attributes.del_ref_info#r#') and  evaluate('attributes.del_ref_info#r#') eq 1 and len(wrk_eval('attributes.ref_name#r#'))><!--- silinmemiş ise.. --->
		<cfquery name="add_employees_reference" datasource="#dsn#">
			INSERT INTO
				EMPLOYEES_REFERENCE
			 (
				EMPLOYEE_ID,
				REFERENCE_TYPE,
				REFERENCE_NAME,
				REFERENCE_COMPANY,
				REFERENCE_POSITION,
				REFERENCE_TELCODE,
				REFERENCE_TEL,
				REFERENCE_EMAIL,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			 )
			 VALUES
			 (
				#attributes.EMPLOYEE_ID#,
				'#wrk_eval('attributes.ref_type#r#')#',
				'#wrk_eval('attributes.ref_name#r#')#',
				'#wrk_eval('attributes.ref_company#r#')#',
				'#wrk_eval('attributes.ref_position#r#')#',
				'#wrk_eval('attributes.ref_telcode#r#')#',
				'#wrk_eval('attributes.ref_tel#r#')#',
				'#wrk_eval('attributes.ref_mail#r#')#',
				#session.ep.userid#,
				#now()#,
				'#cgi.REMOTE_ADDR#'
			 )
		</cfquery>
	</cfif>
</cfloop>
<!--- //Referans Bilgileri--->

<!--- İletişim Bilgileri--->
<cfquery name="delete_emp_im" datasource="#dsn#">
	DELETE EMPLOYEES_INSTANT_MESSAGE WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
</cfquery>
<cfloop from="1" to="#attributes.add_im_info#" index="i">
	<cfif isdefined('attributes.del_im_info#i#') and  evaluate('attributes.del_im_info#i#') eq 1 and len('#wrk_eval('attributes.im_address#i#')#')><!--- silinmemiş ise.. --->
		<cfquery name="add_employees_instant_message" datasource="#dsn#">
			INSERT INTO
				EMPLOYEES_INSTANT_MESSAGE
			 (
				EMPLOYEE_ID,
				IMCAT_ID,
                IM_ADDRESS,
                RECORD_DATE,
				RECORD_IP,
				RECORD_EMP                
			 )
			 VALUES
			 (
				#attributes.EMPLOYEE_ID#,
				<cfif len(wrk_eval('attributes.imcat_id#i#'))>#wrk_eval('attributes.imcat_id#i#')#<cfelse>NULL</cfif>,<!--- '#wrk_eval('attributes.ref_type#r#')#', --->
				<cfif len(wrk_eval('attributes.im_address#i#'))>'#wrk_eval('attributes.im_address#i#')#'<cfelse>NULL</cfif>,
                #now()#,
				'#cgi.REMOTE_ADDR#',
				#session.ep.userid#
			 )
		</cfquery>
	</cfif>
</cfloop>
<!--- //İletişim Bilgileri--->

<!--- Yabancı dil bilgileri--->
<cfquery name="delete_lang" datasource="#dsn#">
	DELETE EMPLOYEES_APP_LANGUAGE WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
</cfquery>	
<cfloop from="1" to="#attributes.add_lang_info#" index="m">
	<cfif isdefined('attributes.del_lang_info#m#') and  evaluate('attributes.del_lang_info#m#') eq 1><!--- silinmemiş ise.. --->
		<cfset attributes.paper_date=evaluate('attributes.paper_date#m#')>
		<cf_date tarih="attributes.paper_date">
		<cfset attributes.paper_finish_date=evaluate('attributes.paper_finish_date#m#')>
		<cf_date tarih="attributes.paper_finish_date">
		<cfquery name="add_lang" datasource="#dsn#">
			INSERT INTO
				EMPLOYEES_APP_LANGUAGE
			 (
				EMPLOYEE_ID,
				LANG_ID,
				LANG_SPEAK,
				LANG_WRITE,
				LANG_MEAN,
				LANG_WHERE,
				PAPER_NAME,
				PAPER_DATE,
				PAPER_FINISH_DATE,
				LANG_POINT,
				LANG_PAPER_NAME,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP			
			)
			VALUES
			(
				#attributes.EMPLOYEE_ID#,
				#wrk_eval('attributes.lang#m#')#,
				#wrk_eval('attributes.lang_speak#m#')#,
				#wrk_eval('attributes.lang_write#m#')#,
				#wrk_eval('attributes.lang_mean#m#')#,
				'#wrk_eval('attributes.lang_where#m#')#',
				<cfif isDefined('attributes.paper_name#m#') and len(evaluate('attributes.paper_name#m#'))>'#wrk_eval('attributes.paper_name#m#')#'<cfelse>NULL</cfif>,
				<cfif isDefined('attributes.paper_date') and len(attributes.paper_date)>#attributes.paper_date#<cfelse>NULL</cfif>,
				<cfif isDefined('attributes.paper_finish_date') and len(attributes.paper_finish_date)>#attributes.paper_finish_date#<cfelse>NULL</cfif>,
				<cfif isDefined('attributes.lang_point#m#') and len(evaluate('attributes.lang_point#m#'))>#wrk_eval('attributes.lang_point#m#')#<cfelse>NULL</cfif>,
				<cfif isDefined('attributes.lang_paper_name#m#') and len(evaluate('attributes.lang_paper_name#m#'))>'#wrk_eval('attributes.lang_paper_name#m#')#'<cfelse>NULL</cfif>,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
		</cfquery>
	</cfif>
</cfloop>
<!--- //Yabancı dil bilgileri--->

<!--- Eğitim Bilgileri --->
<cfquery name="delete_emp_cour" datasource="#dsn#">
	DELETE EMPLOYEES_COURSE WHERE EMPLOYEE_ID=#attributes.EMPLOYEE_ID#
</cfquery>
<!--- Eğitim Bilgileri --->
<cfloop from="1" to="#attributes.emp_ex_course#" index="z">
	<cfif isdefined('attributes.del_course_prog#z#') and  evaluate('attributes.del_course_prog#z#') eq 1><!--- silinmemiş ise.. --->
		<cfif len(wrk_eval('attributes.kurs1_#z#')) and len(evaluate('attributes.kurs1_yil#z#'))>
			<cfquery name="add_employees_course" datasource="#dsn#">
				INSERT 
				INTO
					EMPLOYEES_COURSE
				 (
					EMPLOYEE_ID,
					COURSE_SUBJECT,
					COURSE_EXPLANATION,
					COURSE_YEAR,
					COURSE_LOCATION,
					COURSE_PERIOD
				 )
				 VALUES
				 (
					#attributes.EMPLOYEE_ID#,
					'#wrk_eval('attributes.kurs1_#z#')#',
					'#wrk_eval('attributes.kurs1_exp#z#')#',
					{ts '#evaluate('attributes.kurs1_yil#z#')#-01-01 00:00:00'},
					'#wrk_eval('attributes.kurs1_yer#z#')#',
					'#wrk_eval('attributes.kurs1_gun#z#')#'
				 )
			</cfquery>
		</cfif>
	</cfif>
</cfloop>

<cfloop from="1" to="#attributes.row_edu#" index="j">
	<cfif isdefined("attributes.row_kontrol_edu#j#") and evaluate("attributes.row_kontrol_edu#j#")>

	<cfif isdefined("attributes.edu_high_part_id#j#") and  len(evaluate('attributes.edu_high_part_id#j#')) <!---and evaluate('attributes.edu_type#j#') eq 3--->>
		<cfset bolum_id = evaluate('attributes.edu_high_part_id#j#')>
	<cfelseif isdefined("attributes.edu_part_id#j#") and len(evaluate('attributes.edu_part_id#j#')) >
		<cfset bolum_id = evaluate('attributes.edu_part_id#j#')>
	<cfelse>
		<cfset bolum_id = -1>
	</cfif>
		<cfif isDefined("attributes.empapp_edu_row_id#j#") and len(evaluate("attributes.empapp_edu_row_id#j#"))>
			<cfquery name="UPD_EMPLOYEES_APP_EDU_INFO" datasource="#DSN#">
					UPDATE
						EMPLOYEES_APP_EDU_INFO
					SET
						EDU_TYPE = #evaluate('attributes.edu_type#j#')#,
						EDU_ID = <cfif isdefined("attributes.edu_id#j#") and len(evaluate('attributes.edu_id#j#'))>#evaluate('attributes.edu_id#j#')#<cfelse>-1</cfif>,
						EDU_NAME = <cfif isdefined("attributes.edu_name#j#") and len(evaluate('attributes.edu_name#j#'))>'#wrk_eval('attributes.edu_name#j#')#'<cfelse>NULL</cfif>,
						EDU_PART_ID = <cfif isdefined("bolum_id") and len(bolum_id)>#bolum_id#<cfelse>NULL</cfif>,
						EDU_PART_NAME = <cfif isdefined("attributes.edu_part_name#j#") and len(evaluate('attributes.edu_part_name#j#'))>'#wrk_eval('attributes.edu_part_name#j#')#'<cfelse>NULL</cfif>,
						EDU_START = <cfif isdefined("attributes.edu_start#j#") and len(evaluate('attributes.edu_start#j#'))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#evaluate('attributes.edu_start#j#')#"><cfelse>NULL</cfif>,
						EDU_FINISH = <cfif isdefined("attributes.edu_finish#j#") and len(evaluate('attributes.edu_finish#j#'))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#evaluate('attributes.edu_finish#j#')#"><cfelse>NULL</cfif>,
						EDU_RANK = <cfif isdefined("attributes.edu_rank#j#") and len(evaluate('attributes.edu_rank#j#'))>'#wrk_eval('attributes.edu_rank#j#')#'<cfelse>NULL</cfif>,
						EMPLOYEE_ID = #attributes.employee_id#,
						IS_EDU_CONTINUE= <cfif isdefined("attributes.is_edu_continue#j#") and evaluate('attributes.is_edu_continue#j#') eq 1>1<cfelse>0</cfif>,
                        EDU_LANG_RATE = <cfif isdefined("attributes.edu_lang_rate#j#") and len(evaluate('attributes.edu_lang_rate#j#'))>#wrk_eval('attributes.edu_lang_rate#j#')#<cfelse>NULL</cfif>,
                        EDUCATION_LANG = <cfif isdefined("attributes.edu_lang#j#") and len(evaluate('attributes.edu_lang#j#'))>#evaluate('attributes.edu_lang#j#')#<cfelse>NULL</cfif>,
                        EDUCATION_TIME = <cfif isdefined("attributes.education_time#j#") and len(evaluate('attributes.education_time#j#'))>#wrk_eval('attributes.education_time#j#')#<cfelse>NULL</cfif>
					WHERE
						EMPAPP_EDU_ROW_ID = #evaluate("attributes.empapp_edu_row_id#j#")#
			</cfquery>
		<cfelse>
			<cfquery name="ADD_EMPLOYEES_APP_EDU_INFO" datasource="#dsn#">
				INSERT INTO
					EMPLOYEES_APP_EDU_INFO
					(
                        EMPLOYEE_ID,
                        EDU_TYPE,
                        EDU_ID,
                        EDU_NAME,
                        EDU_PART_ID,
                        EDU_PART_NAME,
                        EDU_START,
                        EDU_FINISH,
                        EDU_RANK,
                        IS_EDU_CONTINUE,
                        EDU_LANG_RATE,
                        EDUCATION_LANG,
                        EDUCATION_TIME
					)
					VALUES
					(
                        #attributes.employee_id#,
                        #evaluate('attributes.edu_type#j#')#,
                        <cfif isdefined("attributes.edu_id#j#") and len(evaluate('attributes.edu_id#j#'))>#evaluate('attributes.edu_id#j#')#<cfelse>-1</cfif>,
                        <cfif isdefined("attributes.edu_name#j#") and len(evaluate('attributes.edu_name#j#'))>'#wrk_eval('attributes.edu_name#j#')#'<cfelse>NULL</cfif>,
                        <cfif isdefined("bolum_id") and len(bolum_id)>#bolum_id#<cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.edu_part_name#j#") and len(evaluate('attributes.edu_part_name#j#'))>'#wrk_eval('attributes.edu_part_name#j#')#'<cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.edu_start#j#") and len(evaluate('attributes.edu_start#j#'))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#evaluate('attributes.edu_start#j#')#"><cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.edu_finish#j#") and len(evaluate('attributes.edu_finish#j#'))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#evaluate('attributes.edu_finish#j#')#"><cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.edu_rank#j#") and len(evaluate('attributes.edu_rank#j#'))>'#wrk_eval('attributes.edu_rank#j#')#'<cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.is_edu_continue#j#") and evaluate('attributes.is_edu_continue#j#') eq 1>1<cfelse>0</cfif>,
                        <cfif isdefined("attributes.edu_lang_rate#j#") and len(evaluate('attributes.edu_lang_rate#j#'))>#wrk_eval('attributes.edu_lang_rate#j#')#<cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.edu_lang#j#") and len(evaluate('attributes.edu_lang#j#'))>#evaluate('attributes.edu_lang#j#')#<cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.education_time#j#") and len(evaluate('attributes.education_time#j#'))>#wrk_eval('attributes.education_time#j#')#<cfelse>NULL</cfif>
					)
			</cfquery>
		</cfif>
	<cfelse>
		<cfif isDefined("attributes.empapp_edu_row_id#j#") and len(evaluate("attributes.empapp_edu_row_id#j#"))>
			<cfquery name="del_empapp_edu_info" datasource="#dsn#">
				DELETE FROM
					EMPLOYEES_APP_EDU_INFO
				WHERE
					EMPAPP_EDU_ROW_ID = #evaluate("attributes.empapp_edu_row_id#j#")#
			</cfquery>
		</cfif>
	</cfif>
</cfloop>
<!--- Eğitim Bilgileri--->

<!---employees_identy tablosuna kayıt veya güncelle--->
<cfquery name="DETAIL_EXISTS_IDENTY" datasource="#DSN#">
	SELECT 
		EMPLOYEE_IDENTY_ID
	FROM 
		EMPLOYEES_IDENTY
	WHERE 
		EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
</cfquery>

<cfif not isdefined("attributes.married")>
	<cfset attributes.married = 0>
</cfif>

<cfif len(attributes.birth_date)>
	<CF_DATE tarih="attributes.birth_date">
</cfif>
<cfif len(attributes.given_date)>
	<CF_DATE tarih="attributes.given_date">
</cfif>

<cfif DETAIL_EXISTS_IDENTY.RECORDCOUNT>

	<cfquery name="UPD_IDENTY" datasource="#dsn#">
		UPDATE
			EMPLOYEES_IDENTY
		SET
			NATIONALITY=<cfif len(attributes.nationality)>#attributes.nationality#,<cfelse>NULL,</cfif>
			SERIES = '#attributes.series#',
			TC_IDENTY_NO='#attributes.tc_identy_no#',
			NUMBER = '#attributes.number#',
			FATHER = '#attributes.father#',
			MOTHER = '#attributes.mother#',
		<cfif len(attributes.birth_date)>
			BIRTH_DATE = #attributes.birth_date#,
		<cfelse>
			BIRTH_DATE = NULL,
		</cfif>
			BIRTH_PLACE = '#attributes.birth_place#',
			BIRTH_CITY = <cfif len(attributes.birth_city)>#attributes.birth_city#<cfelse>NULL</cfif>,
			TAX_NUMBER = '#attributes.tax_number#',
			TAX_OFFICE = <cfif len(attributes.tax_office)>'#attributes.tax_office#',<cfelse>NULL,</cfif>
			MARRIED = <cfif isdefined('attributes.married')>#attributes.married#<cfelse>NULL</cfif>,
			RELIGION = '#attributes.religion#',
		 <cfif len(attributes.blood_type)>
		    BLOOD_TYPE = #attributes.blood_type#,
		 </cfif>
			CITY = '#attributes.city#',
			COUNTY = '#attributes.county#',
			WARD = '#attributes.ward#',
			VILLAGE = '#attributes.village#',
			BINDING = '#attributes.binding#',
			FAMILY = '#attributes.family#',
			CUE = '#attributes.cue#',
			GIVEN_PLACE = '#attributes.given_place#',
			GIVEN_REASON = '#attributes.given_reason#',
			RECORD_NUMBER = '#attributes.record_number#',
		<cfif len(attributes.given_date)>
			GIVEN_DATE = #attributes.given_date#,
		<cfelse>
			GIVEN_DATE = NULL,
		</cfif>
			LAST_SURNAME = '#attributes.last_surname#',
			<cfif isdefined("attributes.socialsec_no")>SOCIALSECURITY_NO='#attributes.socialsec_no#',</cfif>
			UPDATE_DATE = #now()#,
			UPDATE_IP = '#cgi.REMOTE_ADDR#',
			UPDATE_EMP = #session.ep.userid#
		WHERE
			EMPLOYEE_IDENTY_ID = #DETAIL_EXISTS_IDENTY.EMPLOYEE_IDENTY_ID#
	</cfquery>
<cfelse>
	<cfquery name="ADD_IDENTY" datasource="#dsn#">
		INSERT INTO
			EMPLOYEES_IDENTY
			(
			EMPLOYEE_ID,
			NATIONALITY,
			TC_IDENTY_NO, 
			SERIES,
			NUMBER,
			FATHER,
			MOTHER,
			BIRTH_DATE,
			BIRTH_PLACE,
			MARRIED,
			RELIGION,
		 <cfif len(attributes.blood_type)>	
			BLOOD_TYPE,
		 </cfif>
			CITY,
			COUNTY,
			WARD,
			VILLAGE,
			BINDING,
			FAMILY,
			CUE,
			GIVEN_PLACE,
			GIVEN_REASON,
			RECORD_NUMBER,
			GIVEN_DATE,
			LAST_SURNAME,
			TAX_NUMBER,
			TAX_OFFICE,
			<cfif isdefined("attributes.socialsec_no")>
				SOCIALSECURITY_NO,
			</cfif>
			RECORD_DATE,
			RECORD_IP,
			RECORD_EMP
			)
		VALUES
			(
			#attributes.EMPLOYEE_ID#,
			<cfif len(attributes.nationality)>#attributes.nationality#,<cfelse>NULL,</cfif>
			'#attributes.tc_identy_no#', 
			'#attributes.series#',
			'#attributes.number#',
			'#attributes.father#',
			'#attributes.mother#',
		<cfif len(attributes.birth_date)>
			#attributes.birth_date#,
		<cfelse>
			NULL,
		</cfif>
			'#attributes.birth_place#',
			<cfif isdefined('attributes.married')>#attributes.married#,<cfelse>NULL,</cfif>
			'#attributes.religion#',
		  <cfif len(attributes.blood_type)>
			 <!---'#BLOOD_TYPE#',--->
			 #attributes.blood_type#,
		  </cfif>	
			'#attributes.city#',
			'#attributes.county#',
			'#attributes.ward#',
			'#attributes.village#',
			'#attributes.binding#',
			'#attributes.family#',
			'#attributes.cue#',
			'#attributes.given_place#',
			'#attributes.given_reason#',
			'#attributes.record_number#',
		<cfif len(attributes.given_date)>
			#attributes.given_date#,
		<cfelse>
			NULL,
		</cfif>
			'#attributes.last_surname#',
			'#attributes.tax_number#',
			<cfif len(attributes.tax_office)>'#attributes.tax_office#',<cfelse>NULL,</cfif>
			<cfif isdefined("attributes.socialsec_no")>'#attributes.socialsec_no#',</cfif>
			#now()#,
			'#cgi.REMOTE_ADDR#',
			#session.ep.userid#
			)
	</cfquery>
</cfif>

<!--- Hobiler--->
	<cfquery name="DEL_EMPLOYEES_HOBBY" datasource="#DSN#"> 
		DELETE FROM EMPLOYEES_HOBBY WHERE EMPLOYEE_ID = #attributes.employee_id#
	</cfquery>

	<cfif isdefined('attributes.hobby') and listlen(attributes.hobby) gt 0>
		<cfloop from="1" to="#listlen(attributes.hobby)#" index="i"> 
			<cfset liste = ListGetAt(attributes.hobby,i)>
			<cfquery name="add_emp_hobbies" datasource="#dsn#">
				INSERT INTO 
					EMPLOYEES_HOBBY
				(
					EMPLOYEE_ID,
					HOBBY_ID				
				)
				VALUES
				(
					#attributes.employee_id#,
					#liste#				
				)
			</cfquery>
		</cfloop>
	</cfif>

<!--- Adres Defteri --->
<cf_addressbook
	design		= "2"
	type		= "1"
	type_id		= "#attributes.employee_id#"
	name		= "#attributes.employee_name#"
	surname		= "#attributes.employee_surname#"
	email		= "#attributes.employee_email#"
	telcode		= "#attributes.contact1_telcode#"
	telno		= "#attributes.contact1_tel#"
	mobilcode	= "#attributes.mobilcode#"
	mobilno		= "#attributes.mobiltel#">
</cftransaction>
</cflock>
<cf_workcube_process 
	is_upd='1' 
	process_stage='#attributes.process_stage#' 
	old_process_line='#attributes.old_process_line#'
	record_member='#session.ep.userid#'
	record_date='#now()#' 
	action_table='EMPLOYEES'
	action_column='EMPLOYEE_ID'
	action_id='#attributes.employee_id#' 
	action_page='#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#attributes.employee_id#' 
	warning_description='Çalışan : #session.ep.name# #session.ep.surname#'>
<script>
	location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_detail";
</script>
