<cfif len(attributes.eposta)>
	<cfquery name="get_empapp_mail" datasource="#dsn#">
		SELECT
			EMAIL
		FROM
			EMPLOYEES_APP
		WHERE
			EMAIL='#attributes.eposta#' AND
			EMPAPP_ID<>#attributes.empapp_id#
	</cfquery>
	<cfif get_empapp_mail.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1725.Girdiğiniz mail adresine ait bir kullanıcı var Aynı mail adresi ile başka bir kullanıcı ekleyemezsiniz'>!");
			history.go(-1);
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfset upload_folder = "#upload_folder#hr#dir_seperator#">
<cfif len(attributes.old_photo)>
	<cfif len(attributes.photo)>
		<!--- <cffile action="delete" file="#upload_folder##attributes.old_photo#"> --->
		<cf_del_server_file output_file="hr/#attributes.old_photo#" output_server="#attributes.old_photo_server_id#">
		<cfset attributes.old_photo = "">
	<cfelse>
		<cfif isdefined("del_photo")>
			<!--- <cffile action="delete" file="#upload_folder##attributes.old_photo#"> --->
			<cf_del_server_file output_file="hr/#attributes.old_photo#" output_server="#attributes.old_photo_server_id#">
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
				alert("<cf_get_lang no ='1726.Resim yüklenemedi lütfen tekrar deneyiniz'> !");
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
	<cfset attributes.birth_date = "NULL">
</cfif>
<cfif len(attributes.given_date)>
	<cf_date tarih="attributes.given_date">
</cfif>
<cfif len(attributes.work_start_date)>
	<cf_date tarih="attributes.work_start_date">
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
<cfif len(attributes.licence_start_date)><cf_date tarih="attributes.licence_start_date"></cfif>

<cfquery name="UPD_EMP_APP" datasource="#DSN#">
	UPDATE 
		EMPLOYEES_APP
	SET
		APP_STATUS = <cfif isdefined('attributes.app_status')>1<cfelse>0</cfif>,
		APP_COLOR_STATUS = <cfif isdefined('attributes.cv_status_id') and len(attributes.cv_status_id)>#attributes.cv_status_id#<cfelse>NULL</cfif>,
		CV_SOURCE_ID = <cfif isdefined('attributes.cv_source') and len(attributes.cv_source)>#attributes.cv_source#<cfelse>NULL</cfif>,
		<cfif isdefined("valid") and len(valid)>
			VALID = <cfif valid eq 1>1<cfelse>0</cfif>, 
			VALID_DATE = #now()#, 
			VALID_EMP = #session.ep.userid#,
		</cfif>
		TAX_NUMBER = <cfif isdefined('attributes.tax_number') and len(attributes.tax_number)>'#attributes.tax_number#'<cfelse>NULL</cfif>,
		TAX_OFFICE = <cfif len(attributes.tax_office)>'#attributes.tax_office#'<cfelse>NULL</cfif>,
		IMMIGRANT = <cfif isdefined("attributes.immigrant") and len(attributes.immigrant)>#attributes.immigrant#<cfelse>0</cfif>,
		<cfif isdefined("attributes.defected") and len(attributes.defected)>
			DEFECTED = #attributes.defected#,
			<cfif isdefined('attributes.defected_level') and len(attributes.defected_level)>
				DEFECTED_LEVEL = #attributes.defected_level#,
			</cfif>
		<cfelse>
			DEFECTED = 0,
			DEFECTED_LEVEL = 0,
		</cfif>
		SENTENCED = <cfif isDefined("attributes.sentenced") and len(attributes.sentenced)>#attributes.sentenced#<cfelse>0</cfif>,
		SEX = <cfif isdefined("attributes.sex") and len(attributes.sex)>#attributes.sex#<cfelse>0</cfif>,
		NAME = '#attributes.name_#',
		SURNAME = '#attributes.surname#',
		WORKTELCODE = <cfif len(attributes.worktelcode)>'#attributes.worktelcode#'<cfelse>NULL</cfif>,
		WORKTEL = <cfif len(attributes.worktel)>'#attributes.worktel#'<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.empapp_password') and len(attributes.empapp_password)>EMPAPP_PASSWORD = '#sifreli#',</cfif>
		EXTENSION = <cfif len(attributes.extension)>'#attributes.extension#'<cfelse>NULL</cfif>,
		EMAIL = <cfif len(attributes.eposta)>'#attributes.eposta#'<cfelse>NULL</cfif>,
		MOBILCODE = <cfif len(attributes.mobilcode)>'#attributes.mobilcode#'<cfelse>NULL</cfif>,
		MOBIL = <cfif len(attributes.mobil)> '#attributes.mobil#'<cfelse>NULL</cfif>,
		MOBILCODE2 = <cfif len(attributes.mobilcode2)>'#attributes.mobilcode2#'<cfelse>NULL</cfif>,
		MOBIL2 = <cfif len(attributes.mobil2)>'#attributes.mobil2#'<cfelse>NULL</cfif>,
		<!---IMCAT_ID = <cfif len(attributes.imcat_id)>#attributes.imcat_id#<cfelse>NULL</cfif>,
		IM = <cfif len(attributes.im)>'#attributes.im#'<cfelse>NULL</cfif>,--->
		PHOTO = <cfif len(attributes.photo)>'#attributes.photo#'<cfelse>NULL</cfif>,
		PHOTO_SERVER_ID = <cfif len(attributes.photo)>#fusebox.server_machine#<cfelse>NULL</cfif>,
		IDENTYCARD_CAT = <cfif len(attributes.identycard_cat)>#attributes.identycard_cat#<cfelse>NULL</cfif>,
		IDENTYCARD_NO = '#attributes.identycard_no#',
		PARTNER_COMPANY = '#attributes.partner_company#',
		PARTNER_NAME = <cfif len(attributes.partner_name)>'#attributes.partner_name#'<cfelse>NULL</cfif>,
		PARTNER_POSITION = '#attributes.partner_position#',
		DEFECTED_PROBABILITY = <cfif isdefined("attributes.defected_probability")>#attributes.defected_probability#<cfelse>0</cfif>,	
		ILLNESS_PROBABILITY = <cfif isdefined("attributes.illness_probability")>#attributes.illness_probability#<cfelse>0</cfif>,
		ILLNESS_DETAIL = '#attributes.illness_detail#',
		DRIVER_LICENCE = '#attributes.driver_licence#',
		HOMETELCODE = <cfif len(attributes.hometelcode)>'#attributes.hometelcode#'<cfelse>NULL</cfif>,
		HOMETEL =<cfif len(attributes.hometel)>'#attributes.hometel#'<cfelse>NULL</cfif>,
		HOMEADDRESS = '#attributes.homeaddress#',
		HOMEPOSTCODE = '#attributes.homepostcode#',
		HOMECOUNTY = '#attributes.homecounty#',
		HOMECITY = <cfif len(attributes.homecity)>#attributes.homecity#<cfelse>NULL</cfif>,
		HOMECOUNTRY =<cfif len(attributes.homecountry)>#attributes.homecountry#<cfelse>NULL</cfif>,	
		PREFERED_CITY = <cfif isdefined("attributes.prefered_city") and len(attributes.prefered_city)>',#attributes.prefered_city#,'<cfelse>NULL</cfif>,
		IS_TRIP = <cfif len(attributes.is_trip) and attributes.is_trip eq 1>1<cfelse>0</cfif>,
		EXPECTED_PRICE = <cfif isDefined("attributes.expected_price") and len(attributes.expected_price)>#replace(EXPECTED_PRICE,',','','all')#<cfelse>NULL</cfif>,
		EXPECTED_MONEY_TYPE = <cfif isDefined("attributes.expected_money_type") and len(attributes.expected_money_type)>'#EXPECTED_MONEY_TYPE#'<cfelse>NULL</cfif>,
		APPLICANT_NOTES = '#attributes.applicant_notes#',
		MILITARY_STATUS = <cfif isdefined("attributes.military_status") and len(attributes.military_status)>#attributes.military_status#<cfelse>0</cfif>,
		MILITARY_DELAY_REASON = <cfif isdefined("attributes.military_status") and attributes.military_status eq 4>'#attributes.military_delay_reason#'<cfelse>NULL</cfif>,
		MILITARY_DELAY_DATE = <cfif isdefined("attributes.military_status") and attributes.military_status eq 4 and len(attributes.military_delay_date)>#attributes.military_delay_date#<cfelse>NULL</cfif>,
		MILITARY_FINISHDATE = <cfif isdefined("attributes.military_status") and attributes.military_status eq 1 and len(attributes.military_finishdate)>#attributes.military_finishdate#<cfelse>NULL</cfif>,
		MILITARY_EXEMPT_DETAIL = <cfif isdefined("attributes.military_status") and len(attributes.military_exempt_detail) and attributes.military_status eq 2>'#attributes.military_exempt_detail#'<cfelse>NULL</cfif>,
		MILITARY_MONTH = <cfif isdefined("attributes.military_status") and attributes.military_status eq 1 and len(attributes.military_month)>#attributes.military_month#<cfelse>NULL</cfif>,
		MILITARY_RANK = <cfif isdefined("attributes.military_status") and attributes.military_status eq 1 and isdefined('attributes.military_rank')>#attributes.military_rank#<cfelse>NULL</cfif>,
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_APP_DATE = NULL,
		UPDATE_APP = NULL,
		UPDATE_APP_IP = NULL,
		LICENCECAT_ID = <cfif len(attributes.driver_licence_type)>#attributes.driver_licence_type#<cfelse>NULL</cfif>,
		LICENCE_START_DATE = <cfif len(attributes.licence_start_date)>#attributes.licence_start_date#<cfelse>NULL</cfif>,
		DRIVER_LICENCE_ACTIVED = <cfif len(attributes.driver_licence_actived)>#attributes.driver_licence_actived#<cfelse>NULL</cfif>,
		COMP_EXP = '#attributes.comp_exp#',
		INVESTIGATION = <cfif len(attributes.investigation)>'#attributes.investigation#'<cfelse>NULL</cfif>,
		TRAINING_LEVEL = <cfif len(attributes.training_level)>#attributes.training_level#<cfelse>NULL</cfif>,
		NATIONALITY = <cfif isdefined('attributes.nationality') and len(attributes.nationality)>#attributes.nationality#<cfelse>NULL</cfif>,
		CLUB = '#attributes.club#',
		HOBBY = '#attributes.hobby#',
		USE_CIGARETTE = #attributes.use_cigarette#,
		MARTYR_RELATIVE = #attributes.martyr_relative#,
		HOME_STATUS = <cfif isdefined('attributes.home_status') and len(attributes.home_status)>#attributes.home_status#<cfelse>NULL</cfif>,
		PREFERENCE_BRANCH = <cfif isdefined('attributes.preference_branch') and len(attributes.preference_branch)>'#attributes.preference_branch#'<cfelse>NULL</cfif>,
		PREFERENCE_ZONE = <cfif isdefined('attributes.preference_zone') and len(attributes.preference_zone)>#attributes.preference_zone#<cfelse>NULL</cfif>,
		CV_TYPE =<cfif isdefined("attributes.cv_type") and len(attributes.cv_type)>#attributes.cv_type#<cfelse>0</cfif>,
		REFERENCE_NAME =<cfif isdefined("attributes.reference_name") and len(attributes.reference_name)>'#attributes.reference_name#'<cfelse>NULL</cfif>,
		REFERENCE_SURNAME =<cfif isdefined("attributes.reference_surname") and len(attributes.reference_surname)>'#attributes.reference_surname#'<cfelse>NULL</cfif>,
		REFERENCE_POSITION =<cfif isdefined("attributes.reference_position") and len(attributes.reference_position)>'#attributes.reference_position#'<cfelse>NULL</cfif>,
		RELATED_BRANCH_ID =<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>#attributes.branch_id#<cfelse>NULL</cfif>,
		INTERVIEW_RESULT=<cfif isdefined("attributes.interview_result") and len(attributes.interview_result)>'#attributes.interview_result#'<cfelse>NULL</cfif>,
		COM_PACKET_PRO =<cfif isdefined("attributes.comp_packet_pro") and len(attributes.comp_packet_pro)>'#attributes.comp_packet_pro#'<cfelse>NULL</cfif>,
		ELECTRONIC_TOOLS =<cfif isdefined("attributes.electronic_tools") and len(attributes.electronic_tools)>'#electronic_tools#'<cfelse>NULL</cfif>,
		IS_PSICOTECHNIC = <cfif isdefined("attributes.psikoteknik") and len(attributes.psikoteknik)>#attributes.psikoteknik#<cfelse>NULL</cfif>,
		RELATED_REF_NAME =<cfif isdefined("attributes.related_ref_name") and len(attributes.related_ref_name)>'#attributes.related_ref_name#'<cfelse>NULL</cfif>,
		RELATED_REF_COMPANY =<cfif isdefined("attributes.related_ref_company") and len(attributes.related_ref_company)>'#attributes.related_ref_company#'<cfelse>NULL</cfif>,
		WORK_START_DATE =<cfif isdefined("attributes.work_start_date") and len(attributes.work_start_date)>#attributes.work_start_date#<cfelse>NULL</cfif>,
		CV_STAGE =<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
		POSITION_CAT_ID1 = <cfif len(attributes.position_cat_id1)>#attributes.position_cat_id1#<cfelse>NULL</cfif>,
		POSITION_CAT_ID2 = <cfif len(attributes.position_cat_id2)>#attributes.position_cat_id2#<cfelse>NULL</cfif>,
		POSITION_CAT_ID3 = <cfif len(attributes.position_cat_id3)>#attributes.position_cat_id3#<cfelse>NULL</cfif>,
		HAVE_CHILDREN = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.have_children#">,
		CHILD = <cfif attributes.have_children eq 1><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.child#"><cfelse>NULL</cfif>,
        CONTACT = '#attributes.contact#',
        CONTACT_RELATION = '#attributes.contact_relation#',
        CONTACT_EMAIL = '#attributes.contact_email#',
        CONTACT_TELCODE = <cfif len(attributes.contact_telcode)>'#attributes.contact_telcode#'<cfelse>NULL</cfif>,
        CONTACT_TEL = <cfif len(attributes.contact_tel)>'#attributes.contact_tel#'<cfelse>NULL</cfif>,
        SURGICAL_OPERATION = <cfif len(attributes.surgical_operation)>'#attributes.surgical_operation#'<cfelse>NULL</cfif>,
		WANT_EMAIL = <cfif isdefined('attributes.not_want_email') and len(attributes.not_want_email)>0<cfelse>1</cfif>,
		WANT_SMS = <cfif isdefined('attributes.not_want_sms') and len(attributes.not_want_sms)>0<cfelse>1</cfif>,
		WANT_CALL = <cfif isdefined('attributes.not_want_call') and len(attributes.not_want_call)>0<cfelse>1</cfif>,
		RESOURCE_ID = <cfif isdefined('attributes.resource') and len(attributes.resource)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.resource#"><cfelse>NULL</cfif>
	WHERE
		EMPAPP_ID = #attributes.empapp_id#
</cfquery>
<!--- Bilgisayar Bilgisi --->
<cfquery name="get_teacher_info" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_APP_TEACHER_INFO WHERE EMPAPP_ID = #attributes.empapp_id#
</cfquery>
<cfif isdefined("attributes.computer_education")>
	<cfset attributes.computer_education=listappend(attributes.computer_education,-1)>
<cfelse>
	<cfset attributes.computer_education= '-1'>
</cfif>
<cfif get_teacher_info.recordcount>
	<cfquery name="UPD_TEACHER_INFO" datasource="#dsn#">
		UPDATE
			EMPLOYEES_APP_TEACHER_INFO
		SET
			COMPUTER_EDUCATION = ',#attributes.computer_education#,'
		WHERE
			 EMPAPP_ID=#attributes.empapp_id#
	</cfquery>
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
				  #attributes.empapp_id#,
				  ',#attributes.computer_education#,'
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
					EXP = <cfif len(evaluate('attributes.exp_name#k#'))>'#Replace(evaluate('attributes.exp_name#k#'),"'"," ","all")#'<cfelse>NULL</cfif>,
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
					EMPAPP_ID = #attributes.empapp_id#,
					IS_CONT_WORK= <cfif isdefined("attributes.is_cont_work#k#") and evaluate('attributes.is_cont_work#k#') eq 1>1<cfelse>0</cfif>,
                    EXP_WORK_TYPE_ID = <cfif len(evaluate('attributes.exp_work_type_id#k#'))>#evaluate('attributes.exp_work_type_id#k#')#<cfelse>NULL</cfif>
				WHERE
					EMPAPP_ROW_ID = #evaluate("attributes.empapp_row_id#k#")#
			</cfquery>
		<cfelse>
			<cfquery name="ADD_EMPLOYEES_APP_WORK_INFO" datasource="#dsn#">
				INSERT INTO
					EMPLOYEES_APP_WORK_INFO
					(
					EMPAPP_ID,
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
					IS_CONT_WORK,
                    EXP_WORK_TYPE_ID
					)
				VALUES
					(
					#attributes.empapp_id#,
					<cfif len(evaluate('attributes.exp_name#k#'))>'#Replace(evaluate('attributes.exp_name#k#'),"'"," ","all")#'<cfelse>NULL</cfif>,
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
					<cfif len(evaluate('attributes.exp_task_id#k#'))>#evaluate('attributes.exp_task_id#k#')#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.is_cont_work#k#") and evaluate('attributes.is_cont_work#k#') eq 1>1<cfelse>0</cfif>,
                    <cfif len(evaluate('attributes.exp_work_type_id#k#'))>#evaluate('attributes.exp_work_type_id#k#')#<cfelse>NULL</cfif>
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
<cfquery name="delete_emp_cour" datasource="#dsn#">
	DELETE EMPLOYEES_COURSE WHERE EMPAPP_ID=#attributes.empapp_id#
</cfquery>
<!--- Eğitim Bilgileri --->
<cfloop from="1" to="#attributes.extra_course#" index="z">
	<cfif isdefined('attributes.del_course_prog#z#') and  evaluate('attributes.del_course_prog#z#') eq 1><!--- silinmemiş ise.. --->
		<cfif len(evaluate('attributes.kurs1_yil#z#')) and len(evaluate('attributes.kurs1_#z#'))>
			<cfquery name="add_employees_course" datasource="#dsn#">
				INSERT INTO
					EMPLOYEES_COURSE
				 (
					EMPAPP_ID,
					EMPLOYEE_ID,
					COURSE_SUBJECT,
					COURSE_EXPLANATION,
					COURSE_YEAR,
					COURSE_LOCATION,
					COURSE_PERIOD
				 )
				 VALUES
				 (
					#attributes.empapp_id#,
					NULL,
					'#wrk_eval('attributes.kurs1_#z#')#',
					<cfif len(wrk_eval('attributes.kurs1_exp#z#'))>'#wrk_eval('attributes.kurs1_exp#z#')#'<cfelse>NULL</cfif>,
					{ts '#evaluate('attributes.kurs1_yil#z#')#-01-01 00:00:00'},
					'#wrk_eval('attributes.kurs1_yer#z#')#',
					<cfif len(wrk_eval('attributes.kurs1_gun#z#'))>'#wrk_eval('attributes.kurs1_gun#z#')#'<cfelse>NULL</cfif>
				 )
			</cfquery>
		</cfif>
	</cfif>
</cfloop>
<cfquery name="delete_emp_reference" datasource="#dsn#">
	DELETE EMPLOYEES_REFERENCE WHERE EMPAPP_ID=#attributes.empapp_id#
</cfquery>		
<cfloop from="1" to="#attributes.add_ref_info#" index="r">
	<cfif isdefined('attributes.del_ref_info#r#') and  evaluate('attributes.del_ref_info#r#') eq 1 and len(wrk_eval('attributes.ref_name#r#'))><!--- silinmemiş ise.. --->
		<cfquery name="add_employees_reference" datasource="#dsn#">
			INSERT INTO
				EMPLOYEES_REFERENCE
			 (
				EMPAPP_ID,
				EMPLOYEE_ID,
				REFERENCE_TYPE,
				REFERENCE_NAME,
				REFERENCE_COMPANY,
				REFERENCE_POSITION,
				REFERENCE_TELCODE,
				REFERENCE_TEL,
				REFERENCE_EMAIL
			 )
			 VALUES
			 (
				#attributes.empapp_id#,
				NULL,
				<cfif len(wrk_eval('attributes.ref_type#r#'))>#wrk_eval('attributes.ref_type#r#')#<cfelse>NULL</cfif>,
				'#wrk_eval('attributes.ref_name#r#')#',
				<cfif len(wrk_eval('attributes.ref_company#r#'))>'#wrk_eval('attributes.ref_company#r#')#'<cfelse>NULL</cfif>,
				<cfif len(wrk_eval('attributes.ref_position#r#'))>'#wrk_eval('attributes.ref_position#r#')#'<cfelse>NULL</cfif>,
				<cfif len(wrk_eval('attributes.ref_telcode#r#'))>'#wrk_eval('attributes.ref_telcode#r#')#'<cfelse>NULL</cfif>,
				<cfif len(wrk_eval('attributes.ref_tel#r#'))>'#wrk_eval('attributes.ref_tel#r#')#'<cfelse>NULL</cfif>,
				<cfif len(wrk_eval('attributes.ref_mail#r#'))>'#wrk_eval('attributes.ref_mail#r#')#'<cfelse>NULL</cfif>
			 )
		</cfquery>
	</cfif>
</cfloop>
<cfquery name="delete_emp_im" datasource="#dsn#">
	DELETE EMPLOYEES_INSTANT_MESSAGE WHERE EMPAPP_ID=#attributes.empapp_id#
</cfquery>		
<cfloop from="1" to="#attributes.add_im_info#" index="i">
	<cfif isdefined('attributes.del_im_info#i#') and  evaluate('attributes.del_im_info#i#') eq 1 and len(wrk_eval('attributes.im#i#'))><!--- silinmemiş ise.. --->
		<cfquery name="add_employees_im" datasource="#dsn#">
			INSERT INTO
						EMPLOYEES_INSTANT_MESSAGE
					 (
						IMCAT_ID,
						IM_ADDRESS,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP,
						EMPAPP_ID
					 )
					 VALUES
					 (
						#wrk_eval('attributes.imcat_id#i#')#,
                        <cfif len(wrk_eval('attributes.im#i#'))>'#wrk_eval('attributes.im#i#')#'<cfelse>NULL</cfif>,
                        #NOW()#,
						#SESSION.EP.USERID#,
						'#CGI.REMOTE_ADDR#',
                        #attributes.empapp_id#
					 )
		</cfquery>
	</cfif>
</cfloop>

<cfloop from="1" to="#attributes.row_edu#" index="j">
	<cfif isdefined("attributes.row_kontrol_edu#j#") and evaluate("attributes.row_kontrol_edu#j#")>
	
	<cfif isdefined("attributes.edu_high_part_id#j#") and  len(evaluate('attributes.edu_high_part_id#j#'))>
		<cfset bolum_id = evaluate('attributes.edu_high_part_id#j#')>
	<cfelseif isdefined("attributes.edu_part_id#j#") and len(evaluate('attributes.edu_part_id#j#')) >
		<cfset bolum_id = evaluate('attributes.edu_part_id#j#')>
	<cfelse>
		<cfset bolum_id = -1>
	</cfif>
		<cfif isDefined("attributes.empapp_edu_row_id#j#") and len(evaluate("attributes.empapp_edu_row_id#j#"))>
			<cfif isdefined("attributes.edu_name#j#") and len(evaluate('attributes.edu_name#j#'))>
				<cfset edu_name_ = '#evaluate('attributes.edu_name#j#')#'>
			<cfelse>
				<cfset edu_name_ = ''>
			</cfif>
			<cf_date tarih="attributes.edu_start#j#">
    		<cf_date tarih="attributes.edu_finish#j#">
			<cfquery name="UPD_EMPLOYEES_APP_EDU_INFO" datasource="#DSN#">
					UPDATE
						EMPLOYEES_APP_EDU_INFO
					SET
						EDU_TYPE = #evaluate('attributes.edu_type#j#')#,
						EDU_ID = <cfif isdefined("attributes.edu_id#j#") and len(evaluate('attributes.edu_id#j#'))>#evaluate('attributes.edu_id#j#')#<cfelse>-1</cfif>,
						EDU_NAME = '#edu_name_#',
						EDU_PART_ID = <cfif isdefined("bolum_id") and len(bolum_id)>#bolum_id#<cfelse>NULL</cfif>,
						EDU_PART_NAME = <cfif isdefined("attributes.edu_part_name#j#") and len(evaluate('attributes.edu_part_name#j#'))>'#wrk_eval('attributes.edu_part_name#j#')#'<cfelse>NULL</cfif>,
						EDU_START = <cfif isdefined("attributes.edu_start#j#") and len(evaluate('attributes.edu_start#j#'))>#evaluate('attributes.edu_start#j#')#<cfelse>NULL</cfif>,
						EDU_FINISH = <cfif isdefined("attributes.edu_finish#j#") and len(evaluate('attributes.edu_finish#j#'))>#evaluate('attributes.edu_finish#j#')#<cfelse>NULL</cfif>,
						EDU_RANK = <cfif isdefined("attributes.edu_rank#j#") and len(evaluate('attributes.edu_rank#j#'))>'#wrk_eval('attributes.edu_rank#j#')#'<cfelse>NULL</cfif>,
						IS_EDU_CONTINUE= <cfif isdefined("attributes.is_edu_continue#j#") and evaluate('attributes.is_edu_continue#j#') eq 1>1<cfelse>0</cfif>
					WHERE
						EMPAPP_EDU_ROW_ID = #evaluate("attributes.empapp_edu_row_id#j#")#
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
					EMPAPP_EDU_ROW_ID = #evaluate("attributes.empapp_edu_row_id#j#")#
			</cfquery>
		</cfif>
	</cfif>
</cfloop>
<!--- Eğitim Bilgileri--->

 <cfquery name="DETAIL_EXISTS" datasource="#DSN#">
	SELECT 
		EMPLOYEE_IDENTY_ID
	FROM 
		EMPLOYEES_IDENTY
	WHERE 
		EMPAPP_ID = #attributes.EMPAPP_ID#
</cfquery>

<cfif not isdefined("attributes.married")>
	<cfset attributes.married = 0>
</cfif>

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
			BIRTH_CITY = <cfif len(attributes.birth_city)>#attributes.birth_city#<cfelse>NULL</cfif>,
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
			UPDATE_IP = '#cgi.REMOTE_ADDR#',
			UPDATE_EMP = #session.ep.userid#
		WHERE
			EMPLOYEE_IDENTY_ID = #DETAIL_EXISTS.EMPLOYEE_IDENTY_ID#
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
			BIRTH_CITY,
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
			<cfif len(attributes.birth_city)>#attributes.birth_city#<cfelse>NULL</cfif>,
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
				<!--- TC_IDENTY_NO='#wrk_eval('attributes.tc_identy_no_relative#i#')#', --->
				EDUCATION=<cfif len(evaluate('attributes.education_relative#i#'))>#evaluate('attributes.education_relative#i#')#,<cfelse>NULL,</cfif>
				EDUCATION_STATUS=<cfif isdefined("attributes.education_status_relative#i#")>1,<cfelse>0,</cfif>
				JOB='#wrk_eval('attributes.job_relative#i#')#',
				COMPANY='#wrk_eval('attributes.company_relative#i#')#',
				JOB_POSITION='#wrk_eval('attributes.job_position_relative#i#')#',
				UPDATE_EMP=#SESSION.EP.USERID#,
				UPDATE_IP='#CGI.REMOTE_ADDR#',
				UPDATE_DATE=#NOW()#
			WHERE 
				RELATIVE_ID=#evaluate('attributes.relative_id#i#')#
			</cfquery>
		<cfelseif isdefined('attributes.name_relative#i#') and isdefined('attributes.relative_sil#i#') and evaluate('attributes.relative_sil#i#') eq 1>
			<cfquery name="del_relative" datasource="#dsn#">
				DELETE FROM
					EMPLOYEES_RELATIVES
				WHERE
					RELATIVE_ID=#evaluate('attributes.relative_id#i#')#
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
				<!--- '#wrk_eval('attributes.tc_identy_no_relative#i#')#', --->
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
	WHERE EMPAPP_ID = #attributes.empapp_id#
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
			INSERT INTO 
				EMPLOYEES_APP_UNIT
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
	<!--- Yabancı dil bilgileri--->
	<cfquery name="delete_lang" datasource="#dsn#">
		DELETE EMPLOYEES_APP_LANGUAGE WHERE EMPAPP_ID = #empapp_id#
	</cfquery>	
	<cfloop from="1" to="#attributes.add_lang_info#" index="m">
		<cfif isdefined('attributes.del_lang_info#m#') and  evaluate('attributes.del_lang_info#m#') eq 1 and len(wrk_eval('attributes.lang#m#'))><!--- silinmemiş ise.. --->
			<cfquery name="add_lang" datasource="#dsn#">
				INSERT INTO
					EMPLOYEES_APP_LANGUAGE
				 (
					EMPAPP_ID,
					LANG_ID,
					LANG_SPEAK,
					LANG_WRITE,
					LANG_MEAN,
					LANG_WHERE,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP			
				)
				VALUES
				(
					#empapp_id#,
					#wrk_eval('attributes.lang#m#')#,
					#wrk_eval('attributes.lang_speak#m#')#,
					#wrk_eval('attributes.lang_write#m#')#,
					#wrk_eval('attributes.lang_mean#m#')#,
					'#wrk_eval('attributes.lang_where#m#')#',
					#now()#,
					#session.ep.userid#,
					'#cgi.REMOTE_ADDR#'
				)
			</cfquery>
		</cfif>
	</cfloop>
	<!--- //Yabancı dil bilgileri--->
	<!---Ek Bilgiler--->
	<cfset attributes.info_id =  attributes.empapp_id>
	<cfset attributes.is_upd = 1>
	<cfset attributes.info_type_id = -23>
	<cfinclude template="../../objects/query/add_info_plus2.cfm">
	<!---Ek Bilgiler--->
	<cf_workcube_process 
		is_upd='1' 
		data_source='#dsn#' 
		old_process_line='#attributes.old_process_line#'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#'
		record_date='#now()#' 
		action_table='EMPLOYEES_RELATIVES'
		action_column='RELATIVE_ID'
		action_id='#attributes.empapp_id#' 
		action_page='#request.self#?fuseaction=hr.list_cv&event=upd&empapp_id=#attributes.empapp_id#' 
		warning_description='İK  : #attributes.empapp_id#'>
        <cfset attributes.actionid=attributes.info_id>
<script type="text/javascript">
    <cfif isdefined('attributes.selected_menu_info') AND len(attributes.selected_menu_info)>
			window.location.href="<cfoutput>#request.self#?fuseaction=hr.list_cv&event=upd&empapp_id=#attributes.empapp_id#&last_area=#attributes.selected_menu_info#</cfoutput>";
	<cfelse>
            window.location.href="<cfoutput>#request.self#?fuseaction=hr.list_cv&event=upd&empapp_id=#attributes.empapp_id#</cfoutput>";
    </cfif>
</script>
