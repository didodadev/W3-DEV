<cfif len(attributes.email)>
	<cfquery name="get_empapp_mail" datasource="#dsn#">
		SELECT
			EMAIL
		FROM
			EMPLOYEES_APP
		WHERE
			EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.email#"> AND
			EMPAPP_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.empapp_id#">
	</cfquery>
	<cfif get_empapp_mail.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1411.Girdiğiniz mail adresine ait bir kullanıcı var. Aynı mail adresi ile başka bir kullanıcı ekleyemezsiniz'>!");
			history.go(-1);
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfset upload_folder = "#upload_folder#hr#dir_seperator#">
<cfif len(attributes.old_photo)>
	<cfif len(attributes.photo)>
		<cf_del_server_file output_file="content/#attributes.old_photo#" output_server="#attributes.old_photo_server_id#">
		<cfset attributes.old_photo = "">
	<cfelse>
		<cfif isdefined("del_photo")>
			<cf_del_server_file output_file="content/#attributes.old_photo#" output_server="#attributes.old_photo_server_id#">
			<cfset attributes.old_photo = "">
		</cfif>
	</cfif>
</cfif>

<cfif len(attributes.photo)>
	<cftry>
		<cffile action = "upload" 
			  filefield = "photo" 
			  destination = "#upload_folder#" 
			  nameconflict = "MakeUnique" 
			  accept="image/*"
			  mode="777">

		<cfset file_name = createUUID()>
		<cffile action="rename" source="#upLOAD_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
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
	<cfset attributes.photo = attributes.old_photo>
</cfif>

<cfif isdefined('attributes.empapp_password') and len(attributes.empapp_password)>
	<cf_cryptedpassword password="#attributes.empapp_password#" output="sifreli" mod="1">
</cfif>

<cfif len(attributes.birth_date)>
	<cf_date tarih="attributes.birth_date">
<cfelse>
	<cfset attributes.birth_date = "null">
</cfif>


<cfif len(attributes.given_date)>
	<cf_date tarih="attributes.given_date">
</cfif>
<cfif len(attributes.licence_start_date)><cf_date tarih="attributes.licence_start_date"></cfif>
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

<cfquery name="UPD_EMP_APP" datasource="#DSN#">
	UPDATE 
		EMPLOYEES_APP
	SET
		 APP_STATUS=<cfif isdefined('attributes.app_status')>1<cfelse>0</cfif>,
	<cfif isdefined("valid")>
		<cfif valid eq 1>
		VALID = 1, 
		VALID_DATE = #now()#, 
		VALID_EMP = #session.ep.userid#,
		<cfelseif valid eq 0>
		VALID = 0, 
		VALID_DATE = #now()#, 
		VALID_EMP = #session.ep.userid#,
		</cfif>
	</cfif>
		TAX_NUMBER=<cfif isdefined('attributes.tax_number') and len(attributes.tax_number)>'#attributes.tax_number#',<cfelse>NULL,</cfif>
		TAX_OFFICE=<cfif len(attributes.tax_office)>'#attributes.tax_office#',<cfelse>NULL,</cfif>
		IMMIGRANT =<cfif isdefined("attributes.immigrant") and len(attributes.immigrant)>#attributes.immigrant#,<cfelse>0,</cfif>
		<cfif isdefined("attributes.defected") and len(attributes.defected)>
			DEFECTED = #attributes.defected#,
			<cfif isdefined('attributes.defected_level') and len(attributes.defected_level)>DEFECTED_LEVEL=#attributes.defected_level#,</cfif>
		<cfelse>
			DEFECTED = 0,
			DEFECTED_LEVEL=0,
		</cfif>
		<cfif isDefined("attributes.sentenced") and len(attributes.sentenced)>
			SENTENCED = #attributes.sentenced#,
		<cfelse>
			SENTENCED = 0,
		</cfif>
		<cfif isdefined("attributes.sex") and len(attributes.sex)>SEX = #attributes.sex#,<cfelse>SEX = 0,</cfif>
		NAME = '#attributes.name#',
		WORKTELCODE =<cfif len(attributes.worktelcode)>'#attributes.worktelcode#',<cfelse>NULL,</cfif>
		WORKTEL =<cfif len(attributes.worktel)>'#attributes.worktel#',<cfelse>NULL,</cfif>
		SURNAME = '#attributes.surname#',
		<cfif isdefined('attributes.empapp_password') and len(attributes.empapp_password)>EMPAPP_PASSWORD='#sifreli#',</cfif>
		EXTENSION=<cfif len(attributes.extension)>'#attributes.extension#',<cfelse>NULL,</cfif>
		EMAIL =<cfif len(attributes.email)>'#attributes.email#',<cfelse>NULL,</cfif>
		MOBILCODE =<cfif len(attributes.mobilcode)>'#attributes.mobilcode#',<cfelse>NULL,</cfif>
		MOBIL =<cfif len(attributes.mobil)> '#attributes.mobil#',<cfelse>NULL,</cfif>
		MOBILCODE2 =<cfif len(attributes.mobilcode2)>'#attributes.mobilcode2#',<cfelse>NULL,</cfif>
		MOBIL2=<cfif len(attributes.mobil2)> '#attributes.mobil2#',<cfelse>NULL,</cfif>
		IMCAT_ID=<cfif len(attributes.imcat_id)>#attributes.imcat_id#,<cfelse>NULL,</cfif>
		IM = <cfif len(attributes.im)>'#attributes.im#',<cfelse>NULL,</cfif>
		PHOTO = <cfif len(attributes.photo)>'#attributes.photo#',<cfelse>NULL,</cfif>
		PHOTO_SERVER_ID = <cfif len(attributes.photo)>#fusebox.server_machine#,<cfelse>NULL,</cfif>
		IDENTYCARD_CAT = <cfif len(attributes.identycard_cat)>#attributes.identycard_cat#<cfelse>NULL</cfif>,
		IDENTYCARD_NO = '#attributes.identycard_no#',
		PARTNER_COMPANY = '#attributes.partner_company#',
		PARTNER_NAME = <cfif len(attributes.partner_name)>'#attributes.partner_name#',<cfelse>NULL,</cfif>
		PARTNER_POSITION = '#attributes.partner_position#',
	  	DEFECTED_PROBABILITY =<cfif isdefined("attributes.defected_probability")>#attributes.defected_probability#,<cfelse>0,</cfif>	
		ILLNESS_PROBABILITY =<cfif isdefined("attributes.illness_probability")>#attributes.illness_probability#,<cfelse>0,</cfif>  	
	    ILLNESS_DETAIL = '#attributes.illness_detail#',
		<cfif len(attributes.lang1)>
			LANG1 = #attributes.lang1#,
			LANG1_SPEAK = #attributes.lang1_speak#,
			LANG1_MEAN = #attributes.lang1_mean#,
			LANG1_WRITE = #attributes.lang1_write#,
			LANG1_WHERE = '#attributes.lang1_where#',
		<cfelse>
			LANG1 =NULL,
			LANG1_SPEAK =NULL,
			LANG1_MEAN =NULL,
			LANG1_WRITE =NULL,
			LANG1_WHERE = NULL,
		</cfif>
		<cfif len(attributes.lang2)>
			LANG2 = #attributes.lang2#,
			LANG2_SPEAK = #attributes.lang2_speak#,
			LANG2_MEAN = #attributes.lang2_mean#,
			LANG2_WRITE = #attributes.lang2_write#,
			LANG2_WHERE = '#attributes.lang2_where#',
		<cfelse>
			LANG2 =NULL,
			LANG2_SPEAK =NULL,
			LANG2_MEAN =NULL,
			LANG2_WRITE =NULL,
			LANG2_WHERE = NULL,
		</cfif>
		<cfif len(attributes.lang3)>
			LANG3 = #attributes.lang3#,
			LANG3_SPEAK = #attributes.lang3_speak#,
			LANG3_MEAN = #attributes.lang3_mean#,
			LANG3_WRITE = #attributes.lang3_write#,
			LANG3_WHERE = '#attributes.lang3_where#',
		<cfelse>
			LANG3 =NULL,
			LANG3_SPEAK =NULL,
			LANG3_MEAN =NULL,
			LANG3_WRITE =NULL,
			LANG3_WHERE = NULL,
		</cfif>
		<cfif len(attributes.lang4)>
			LANG4 = #attributes.lang4#,
			LANG4_SPEAK = #attributes.lang4_speak#,
			LANG4_MEAN = #attributes.lang4_mean#,
			LANG4_WRITE = #attributes.lang4_write#,
			LANG4_WHERE = '#attributes.lang4_where#',
		<cfelse>
			LANG4 =NULL,
			LANG4_SPEAK =NULL,
			LANG4_MEAN =NULL,
			LANG4_WRITE =NULL,
			LANG4_WHERE = NULL,
		</cfif>
		<cfif len(attributes.lang5)>
			LANG5 = #attributes.lang5#,
			LANG5_SPEAK = #attributes.lang5_speak#,
			LANG5_MEAN = #attributes.lang5_mean#,
			LANG5_WRITE = #attributes.lang5_write#,
			LANG5_WHERE = '#attributes.lang5_where#',
		<cfelse>
			LANG5 =NULL,
			LANG5_SPEAK =NULL,
			LANG5_MEAN =NULL,
			LANG5_WRITE =NULL,
			LANG5_WHERE = NULL,
		</cfif>
		HOMETELCODE =<cfif len(attributes.hometelcode)>'#attributes.hometelcode#',<cfelse>NULL,</cfif>
		HOMETEL =<cfif len(attributes.hometel)>'#attributes.hometel#',<cfelse>NULL,</cfif>
		HOMEADDRESS = '#attributes.homeaddress#',
		HOMEPOSTCODE = '#attributes.homepostcode#',
		HOMECOUNTY = '#attributes.homecounty#',
		HOMECITY=<cfif len(attributes.homecity_name) and len(attributes.homecity)>#attributes.homecity#,<cfelse>NULL,</cfif>
		HOMECOUNTRY =<cfif len(attributes.homecountry)>#attributes.homecountry#,<cfelse>NULL,</cfif>
 		REF1 = '#attributes.ref1#',
		REF1_COMPANY = '#attributes.ref1_company#',
		REF1_POSITION = '#attributes.ref1_position#',
		REF1_TELCODE =<cfif len(attributes.ref1_telcode)>'#attributes.ref1_telcode#',<cfelse>NULL,</cfif>
		REF1_TEL =<cfif len(attributes.ref1_tel)>'#attributes.ref1_tel#',<cfelse>NULL,</cfif>
		REF1_EMAIL = '#attributes.ref1_email#',
		REF2 = '#attributes.ref2#',
		REF2_COMPANY = '#attributes.ref2_company#',
		REF2_POSITION = '#attributes.ref2_position#',
		REF2_TELCODE =<cfif len(attributes.ref2_telcode)>'#REF2_TELCODE#',<cfelse>NULL,</cfif>
		REF2_TEL =<cfif len(attributes.ref2_tel)>'#attributes.ref2_tel#',<cfelse>NULL,</cfif>
		REF1_EMP = '#attributes.ref1_emp#',
		REF1_COMPANY_EMP = '#attributes.ref1_company_emp#',
		REF1_POSITION_EMP = '#attributes.ref1_position_emp#',
		REF1_TELCODE_EMP =<cfif len(attributes.ref1_telcode_emp)>'#attributes.ref1_telcode_emp#',<cfelse>NULL,</cfif>
		REF1_TEL_EMP =<cfif len(attributes.ref1_tel_emp)>'#attributes.ref1_tel_emp#',<cfelse>NULL,</cfif>
		REF1_EMAIL_EMP =<cfif len(attributes.ref1_email_emp)>'#attributes.ref1_email_emp#',<cfelse>NULL,</cfif>
		REF2_EMP = '#attributes.ref2_emp#',
		REF2_COMPANY_EMP = '#attributes.ref2_company_emp#',
		REF2_POSITION_EMP = '#attributes.ref2_position_emp#',
		REF2_TELCODE_EMP =<cfif len(attributes.ref2_telcode_emp)>'#attributes.ref2_telcode_emp#',<cfelse>NULL,</cfif>
		REF2_TEL_EMP =<cfif len(attributes.ref2_tel_emp)>'#attributes.ref2_tel_emp#',<cfelse>NULL,</cfif>
		REF2_EMAIL_EMP =<cfif len(attributes.ref2_email_emp)>'#attributes.ref2_email_emp#',<cfelse>NULL,</cfif>
		REF2_EMAIL = '#attributes.ref2_email#',
		PREFERED_CITY =<cfif isdefined("attributes.prefered_city") and len(attributes.prefered_city)>',#attributes.prefered_city#,',<cfelse>NULL,</cfif>
		IS_TRIP = <cfif len(attributes.is_trip)>#attributes.is_trip#</cfif>,
		APPLICANT_NOTES = '#attributes.applicant_notes#',
		MILITARY_STATUS = <cfif isdefined("attributes.military_status") and len(attributes.military_status)>#attributes.military_status#,<cfelse>0,</cfif>
		<cfif isdefined("attributes.military_status") and attributes.military_status eq 4>
			MILITARY_DELAY_REASON ='#attributes.military_delay_reason#',
		<cfelse>
			MILITARY_DELAY_REASON =NULL,
		</cfif>
		<cfif isdefined("attributes.military_status") and attributes.military_status eq 4 and len(attributes.military_delay_date)>
			MILITARY_DELAY_DATE =#attributes.military_delay_date#,
		<cfelse>
			MILITARY_DELAY_DATE =NULL,
		</cfif>
		<cfif isdefined("attributes.military_status") and attributes.military_status eq 1 and len(attributes.military_finishdate)>
			MILITARY_FINISHDATE =#attributes.military_finishdate#,
		<cfelse>
			MILITARY_FINISHDATE =NULL,
		</cfif>
		<cfif isdefined("attributes.military_status") and len(attributes.military_exempt_detail) and attributes.military_status eq 2>
			MILITARY_EXEMPT_DETAIL ='#attributes.military_exempt_detail#',
		<cfelse>
			MILITARY_EXEMPT_DETAIL = NULL,
		</cfif>
		<cfif isdefined("attributes.military_status") and attributes.military_status eq 1 and len(attributes.military_month)>
			MILITARY_MONTH=#attributes.military_month#,
		<cfelse>
			MILITARY_MONTH= NULL,
		</cfif>
		<cfif isdefined("attributes.military_status") and attributes.military_status eq 1 and isdefined('attributes.military_rank')>
			MILITARY_RANK=#attributes.military_rank#,
		<cfelse>
			MILITARY_RANK=NULL,
		</cfif>
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',

		KURS1 = '#attributes.kurs1#',
		KURS1_YIL = <cfif len(attributes.kurs1_yil) eq 4>{TS '#attributes.kurs1_yil#-01-01 00:00:00'},<cfelse>NULL,</cfif>
		KURS1_YER = '#attributes.kurs1_yer#',
		KURS1_GUN = <cfif len(attributes.kurs1_gun)>#attributes.kurs1_gun#,<cfelse>NULL,</cfif>
		KURS2 = '#attributes.kurs2#',
		KURS2_YIL = <cfif len(attributes.kurs2_yil) eq 4>{TS '#attributes.kurs2_yil#-01-01 00:00:00'},<cfelse>NULL,</cfif>
		KURS2_YER = '#attributes.kurs2_yer#',
		KURS2_GUN = <cfif len(attributes.kurs2_gun)>#attributes.kurs2_gun#,<cfelse>NULL,</cfif>
		KURS3 = '#attributes.kurs3#',
		KURS3_YIL = <cfif len(attributes.kurs3_yil) eq 4>{TS '#attributes.kurs3_yil#-01-01 00:00:00'},<cfelse>NULL,</cfif>
		KURS3_YER = '#attributes.kurs3_yer#',
		KURS3_GUN = <cfif len(attributes.kurs3_gun)>#attributes.kurs3_gun#,<cfelse>NULL,</cfif>
		DRIVER_LICENCE = '#attributes.driver_licence#',
		LICENCE_START_DATE = <cfif len(attributes.licence_start_date)>#attributes.licence_start_date#<cfelse>NULL</cfif>,
		LICENCECAT_ID = <cfif len(attributes.driver_licence_type)>#attributes.driver_licence_type#<cfelse>NULL</cfif>,
		DRIVER_LICENCE_ACTIVED = <cfif len(attributes.driver_licence_actived)>#attributes.driver_licence_actived#<cfelse>NULL</cfif>,
		COMP_EXP = '#attributes.comp_exp#',
		INVESTIGATION = <cfif len(attributes.investigation)>'#attributes.investigation#',<cfelse>NULL,</cfif>
	<cfif len(attributes.training_level)>
	   TRAINING_LEVEL = #attributes.training_level#,
	<cfelse>
	   TRAINING_LEVEL = NULL,
	</cfif>
		NATIONALITY=<cfif isdefined('attributes.nationality') and len(attributes.nationality)>#attributes.nationality#,<cfelse>NULL,</cfif>
		CLUB='#attributes.club#',
		HOBBY='#attributes.hobby#',
		USE_CIGARETTE=#attributes.use_cigarette#,
		MARTYR_RELATIVE=#attributes.martyr_relative#,
		HOME_STATUS=<cfif isdefined('attributes.home_status')>#attributes.home_status#<cfelse>NULL</cfif>
	WHERE
		EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.empapp_id#">
</cfquery>

 <cfquery name="DETAIL_EXISTS" datasource="#DSN#">
	SELECT 
		EMPLOYEE_IDENTY_ID
	FROM 
		EMPLOYEES_IDENTY
	WHERE 
		EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.empapp_id#">
</cfquery>

<cfif not isdefined("attributes.married")>
	<cfset attributes.married = 0>
</cfif>
<!--- Bilgisayar Bilgisi --->
<cfquery name="get_teacher_info" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_APP_TEACHER_INFO WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.empapp_id#">
</cfquery>
<cfif get_teacher_info.recordcount and len(get_teacher_info.COMPUTER_EDUCATION)>
	<cfset comp_edu_list = listsort(get_teacher_info.COMPUTER_EDUCATION,"numeric","ASC",",")>
</cfif>
<cfif len(attributes.comp_exp)>
	<cfif get_teacher_info.recordcount>
		<cfif len(get_teacher_info.COMPUTER_EDUCATION)>
			<cfset comp_edu_list=listappend(comp_edu_list,-1)>
			<cfquery name="UPD_TEACHER_INFO" datasource="#dsn#">
				UPDATE
					EMPLOYEES_APP_TEACHER_INFO
				SET
					COMPUTER_EDUCATION = ',#comp_edu_list#,'
				WHERE
					 EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.empapp_id#">
			</cfquery>
		</cfif>
	<cfelse>
		<cfquery name="ADD_TEACHER_INFO" datasource="#dsn#">
			INSERT INTO 
				EMPLOYEES_APP_TEACHER_INFO
					(
					 EMPAPP_ID,
					 COMPUTER_EDUCATION
					 )
				VALUES
					(
					  #attributes.EMPAPP_ID#,
					  ',-1,'
					 )
		</cfquery>
	</cfif>
<cfelseif not len(attributes.comp_exp) and get_teacher_info.recordcount and len(get_teacher_info.COMPUTER_EDUCATION) and listfind(comp_edu_list,-1,',')>
	<cfset comp_edu_list=listdeleteat(comp_edu_list,listfindnocase(comp_edu_list,-1))>
	<cfquery name="UPD_TEACHER_INFO" datasource="#dsn#">
		UPDATE
			EMPLOYEES_APP_TEACHER_INFO
		SET
			COMPUTER_EDUCATION = ',#comp_edu_list#,'
		WHERE
			 EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.empapp_id#">
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
					EXP_TASK_ID = <cfif len(evaluate('attributes.exp_task_id#k#'))>#evaluate('attributes.exp_task_id#k#')#<cfelse>NULL</cfif>,
					EMPAPP_ID =  #attributes.EMPAPP_ID#,
					EMPLOYEE_ID = NULL,
					IS_CONT_WORK= <cfif isdefined("attributes.is_cont_work#k#") and evaluate('attributes.is_cont_work#k#') eq 1>1<cfelse>0</cfif>
				WHERE
					EMPAPP_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.empapp_row_id#k#")#">
			</cfquery>
		<cfelse>
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
					#attributes.empapp_id#,
					NULL,
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
					<cfif len(evaluate('attributes.exp_salary#k#'))>#evaluate('attributes.exp_salary#k#')#<cfelse>NULL</cfif>,
					<cfif len(evaluate('attributes.exp_extra_salary#k#'))>'#wrk_eval('attributes.exp_extra_salary#k#')#'<cfelse>NULL</cfif>,
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
					EMPAPP_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.empapp_row_id#k#")#">
			</cfquery>
		</cfif>
	 </cfif>
</cfloop>
<!--- İş Tecrübeleri --->

<!--- Eğitim Bilgileri --->
<cfloop from="1" to="#attributes.row_edu#" index="j">
	<cfif isdefined("attributes.row_kontrol_edu#j#") and evaluate("attributes.row_kontrol_edu#j#")>

	<cfif isdefined("attributes.edu_high_part_id#j#") and  len(evaluate('attributes.edu_high_part_id#j#'))  and evaluate('attributes.edu_type#j#') eq 3>
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
						EDU_START = <cfif isdefined("attributes.edu_start#j#") and len(evaluate('attributes.edu_start#j#'))>#evaluate('attributes.edu_start#j#')#<cfelse>NULL</cfif>,
						EDU_FINISH = <cfif isdefined("attributes.edu_finish#j#") and len(evaluate('attributes.edu_finish#j#'))>#evaluate('attributes.edu_finish#j#')#<cfelse>NULL</cfif>,
						EDU_RANK = <cfif isdefined("attributes.edu_rank#j#") and len(evaluate('attributes.edu_rank#j#'))>'#wrk_eval('attributes.edu_rank#j#')#'<cfelse>NULL</cfif>,
						EMPAPP_ID = #attributes.empapp_id#,
						IS_EDU_CONTINUE= <cfif isdefined("attributes.is_edu_continue#j#") and evaluate('attributes.is_edu_continue#j#') eq 1>1<cfelse>0</cfif>
					WHERE
						EMPAPP_EDU_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.empapp_edu_row_id#j#")#">
			</cfquery>
		<cfelse>
			<cfquery name="ADD_EMPLOYEES_APP_EDU_INFO" datasource="#dsn#">
				INSERT INTO
					EMPLOYEES_APP_EDU_INFO
					(
					EMPAPP_ID,
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
					#attributes.empapp_id#,
					#evaluate('attributes.edu_type#j#')#,
					<cfif isdefined("attributes.edu_id#j#") and len(evaluate('attributes.edu_id#j#'))>#evaluate('attributes.edu_id#j#')#<cfelse>-1</cfif>,
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
	<cfelse>
		<cfif isDefined("attributes.empapp_edu_row_id#j#") and len(evaluate("attributes.empapp_edu_row_id#j#"))>
			<cfquery name="del_empapp_edu_info" datasource="#dsn#">
				DELETE FROM
					EMPLOYEES_APP_EDU_INFO
				WHERE
					EMPAPP_EDU_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.empapp_edu_row_id#j#")#">
			</cfquery>
		</cfif>
	</cfif>
</cfloop>
<!--- Eğitim Bilgileri--->

<cfif detail_exists.recordcount>

	<cfquery name="UPD_IDENTY" datasource="#dsn#">
		UPDATE
			EMPLOYEES_IDENTY
		SET
			SERIES = '#attributes.series#',
			<cfif len(attributes.tc_identy_no)>
			TC_IDENTY_NO = '#attributes.tc_identy_no#',
			<cfelse>
			TC_IDENTY_NO = NULL, 
			</cfif>
			NUMBER = '#attributes.number#',
			FATHER = '#attributes.father#',
			MOTHER = '#attributes.mother#',
			FATHER_JOB = <cfif len(attributes.father_job)>'#attributes.father_job#',<cfelse>NULL,</cfif>
			MOTHER_JOB = <cfif len(attributes.mother_job)>'#attributes.mother_job#',<cfelse>NULL,</cfif>
		<cfif isdefined('attributes.tax_number') and len(attributes.tax_number)>
			TAX_NUMBER = '#attributes.tax_number#',
		<cfelse>
			TAX_NUMBER = NULL,
		</cfif>
		TAX_OFFICE = <cfif len(attributes.tax_office)>'#attributes.tax_office#',<cfelse>NULL,</cfif>
		<cfif len(attributes.birth_date)>
			BIRTH_DATE = #attributes.birth_date#,
		<cfelse>
			BIRTH_DATE = NULL,
		</cfif>
			BIRTH_PLACE = '#attributes.birth_place#',
			MARRIED = <cfif len(attributes.married)>#attributes.married#<cfelse>NULL</cfif>,
			RELIGION = '#attributes.religion#',
		 <cfif LEN(attributes.blood_type)>
			BLOOD_TYPE= #attributes.blood_type#,
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
			UPDATE_DATE = #now()#,
			UPDATE_IP = '#cgi.REMOTE_ADDR#'
			,UPDATE_EMP = #session.ep.userid#
		WHERE
			EMPLOYEE_IDENTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#detail_exists.employee_identy_id#">
	</cfquery>

<cfelse>

	<cfquery name="ADD_IDENTY" datasource="#dsn#">
		INSERT INTO
			EMPLOYEES_IDENTY
			(
			EMPAPP_ID,
			SERIES,
			TC_IDENTY_NO,
			TAX_NUMBER,
			TAX_OFFICE,
			NUMBER,
			FATHER,
			MOTHER,
			BIRTH_DATE,
			BIRTH_PLACE,
			MARRIED,
			RELIGION,
			BLOOD_TYPE,
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
			RECORD_DATE,
			RECORD_IP,
			RECORD_EMP
			)
		VALUES
			(
			#attributes.empapp_id#,
			'#attributes.series#',
			'#attributes.tc_identy_no#',
		<cfif len(attributes.tax_number)>
			'#attributes.tax_number#',
		<cfelse>
			NULL,
		</cfif>
		<cfif len(attributes.tax_office)>
			'#attributes.tax_office#',
		<cfelse>
			NULL,
		</cfif>
			'#attributes.number#',
			'#attributes.father#',
			'#attributes.mother#',
		<cfif len(attributes.birth_date)>
			#attributes.birth_date#,
		<cfelse>
			NULL,

		</cfif>
			'#attributes.birth_place#',
			#attributes.married#,
			'#attributes.religion#',
			'#attributes.blood_type#',
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
			#now()#,
			'#cgi.REMOTE_ADDR#',
			#session.ep.userid#
			)
	</cfquery>
</cfif>

<!--- yakınları--->
<cfif attributes.rowCount gt 0>
<cfloop from="1" to="#attributes.rowCount#" index="i">
 	<cfif isdefined('attributes.name_relative#i#')>
			<cfif len(evaluate('attributes.name_relative#i#')) and len(evaluate('attributes.birth_date_relative#i#'))>
				<cfset attributes.birth_date_relative=evaluate('attributes.birth_date_relative#i#')>
				<cf_date tarih="attributes.birth_date_relative">
			<cfelse>
				<cfset attributes.birth_date_relative='NULL'>
			</cfif>
		<cfif isdefined('attributes.relative_id#i#') and len(evaluate('attributes.relative_id#i#')) and evaluate('attributes.relative_sil#i#') neq 1>
			<cfquery name="upd_relative" datasource="#dsn#">
			UPDATE
				EMPLOYEES_RELATIVES
			SET
				EMPAPP_ID=#attributes.empapp_id#,
				EMPLOYEE_ID=NULL,
				NAME='#wrk_eval('attributes.name_relative#i#')#',
				SURNAME='#wrk_eval('attributes.surname_relative#i#')#',
				RELATIVE_LEVEL='#wrk_eval('attributes.relative_level#i#')#',
				BIRTH_DATE=#attributes.birth_date_relative#,
				BIRTH_PLACE='#wrk_eval('attributes.birth_place_relative#i#')#',
				<!--- TC_IDENTY_NO='#evaluate('attributes.tc_identy_no_relative#i#')#', --->
				EDUCATION=<cfif len(evaluate('attributes.education_relative#i#'))>#evaluate('attributes.education_relative#i#')#,<cfelse>NULL,</cfif>
				EDUCATION_STATUS=<cfif isdefined("attributes.education_status_relative#i#")>1,<cfelse>0,</cfif>
				JOB='#wrk_eval('attributes.job_relative#i#')#',
				COMPANY='#wrk_eval('attributes.company_relative#i#')#',
				JOB_POSITION='#wrk_eval('attributes.job_position_relative#i#')#',
				UPDATE_EMP=#SESSION.EP.USERID#,
				UPDATE_IP='#CGI.REMOTE_ADDR#',
				UPDATE_DATE=#NOW()#
			WHERE 
				RELATIVE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.relative_id#i#')#">
			</cfquery>
		<cfelseif isdefined('attributes.name_relative#i#') and isdefined('attributes.relative_sil#i#') and evaluate('attributes.relative_sil#i#') eq 1>
			<cfquery name="del_relative" datasource="#dsn#">
				DELETE FROM
					EMPLOYEES_RELATIVES
				WHERE
					RELATIVE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.relative_id#i#')#">
			</cfquery>
		<cfelseif len(evaluate('attributes.name_relative#i#'))>
			<cfquery name="add_relative" datasource="#DSN#">
			 INSERT INTO
				EMPLOYEES_RELATIVES
				(
				EMPAPP_ID,	
				EMPLOYEE_ID,
				NAME,
				SURNAME,
				RELATIVE_LEVEL,
				BIRTH_DATE,
				BIRTH_PLACE,
				<!--- TC_IDENTY_NO, --->
				EDUCATION,
				EDUCATION_STATUS,
				JOB,
				COMPANY,
				JOB_POSITION,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE
				)
			  VALUES
				(
				#attributes.empapp_id#,
				NULL,
				'#wrk_eval('attributes.name_relative#i#')#',
				'#wrk_eval('attributes.surname_relative#i#')#',
				'#wrk_eval('attributes.relative_level#i#')#',
				<cfif len(attributes.birth_date_relative)>#attributes.birth_date_relative#,<cfelse>NULL,</cfif>
				'#wrk_eval('attributes.birth_place_relative#i#')#',
				<!--- '#evaluate('attributes.tc_identy_no_relative#i#')#', --->
				<cfif len(evaluate('attributes.education_relative#i#'))>#evaluate('attributes.education_relative#i#')#,<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.education_status_relative#i#")>1,<cfelse>0,</cfif>	
				'#wrk_eval('attributes.job_relative#i#')#',
				'#wrk_eval('attributes.company_relative#i#')#',
				'#wrk_eval('attributes.job_position_relative#i#')#',
				#SESSION.EP.USERID#,
				'#CGI.REMOTE_ADDR#',
				#NOW()#
				)
			</cfquery>
		</cfif>
	</cfif>
</cfloop>
</cfif>
<!--- //yakınları--->

<!--- çalışmak istediği birimler--->
<cfquery name="del_app_unit" datasource="#dsn#"> 
DELETE FROM 
	EMPLOYEES_APP_UNIT 
	WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.empapp_id#">
</cfquery>
	<cfquery name="get_cv_unit" datasource="#DSN#">
		SELECT 
			* 
		FROM 
			SETUP_CV_UNIT
	</cfquery>
	<cfoutput query="get_cv_unit">
	<cfif isdefined('unit#get_cv_unit.unit_id#') and len(evaluate('unit#get_cv_unit.unit_id#'))>
		<cfquery name="add_unit" datasource="#dsn#">
			INSERT 
				INTO EMPLOYEES_APP_UNIT
				(
				EMPAPP_ID,
				UNIT_ID,
				UNIT_ROW)
				VALUES
				(
					#empapp_id#,
					#get_cv_unit.unit_id#,
					#evaluate('unit#get_cv_unit.unit_id#')#
				)
		</cfquery> 
	</cfif>
	</cfoutput>
<!--- //çalışmak istediği birimler--->

<cflocation url="#request.self#?fuseaction=hr.form_upd_cv&empapp_id=#attributes.empapp_id#" addtoken="No">
