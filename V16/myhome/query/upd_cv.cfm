<cfif len(attributes.email)>
	<cfquery name="get_empapp_mail" datasource="#dsn#">
		SELECT
			EMAIL
		FROM
			EMPLOYEES_APP
		WHERE
			EMAIL = '#attributes.email#' AND
			EMPAPP_ID <> #attributes.empapp_id#
	</cfquery>
	<cfif get_empapp_mail.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1212.Girdiğiniz mail adresine ait bir kullanıcı var Aynı mail adresi ile başka bir kullanıcı ekleyemezsiniz'>!");
			history.go(-1);
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfset upload_folder = "#upload_folder#hr#dir_seperator#">
<cfif len(attributes.old_photo)>
	<cfif len(attributes.photo)>
		<cf_del_server_file output_file="hr/#attributes.old_photo#" output_server="#attributes.old_photo_server_id#">
		<cfset attributes.old_photo = "">
	<cfelse>
		<cfif isdefined("del_photo")>
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
				alert("<cf_get_lang no ='1213.Resim yüklenemedi lütfen tekrar deneyiniz'> !");
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

<cfif len(attributes.birth_date)><cf_date tarih="attributes.birth_date"></cfif>
<cfif len(attributes.licence_start_date)><cf_date tarih="attributes.licence_start_date"></cfif>
<cfif len(attributes.given_date)><cf_date tarih="attributes.given_date"></cfif>
<cfif len(attributes.military_finishdate)><cf_date tarih="attributes.military_finishdate"></cfif>
<cfif len(attributes.military_delay_date)><cf_date tarih="attributes.military_delay_date"></cfif>

<cfquery name="UPD_EMP_APP" datasource="#DSN#">
	UPDATE 
		EMPLOYEES_APP
	SET
		 APP_STATUS = <cfif isdefined('attributes.app_status')>1<cfelse>0</cfif>,
		<cfif isdefined("valid")>
			VALID = <cfif valid eq 1>1<cfelse>0</cfif>,
			VALID_DATE = #now()#, 
			VALID_EMP = #session.ep.userid#,
		</cfif>
		TAX_NUMBER = <cfif isdefined('attributes.tax_number') and len(attributes.tax_number)>'#attributes.tax_number#'<cfelse>NULL</cfif>,
		TAX_OFFICE = <cfif len(attributes.tax_office)>'#attributes.tax_office#'<cfelse>NULL</cfif>,
		IMMIGRANT = <cfif isdefined("attributes.immigrant") and len(attributes.immigrant)>#attributes.immigrant#<cfelse>0</cfif>,
		<cfif isdefined("attributes.defected") and len(attributes.defected)>
			DEFECTED = #attributes.defected#,
			DEFECTED_LEVEL = <cfif isdefined('attributes.defected_level') and len(attributes.defected_level)>#attributes.defected_level#<cfelse>NULL</cfif>,
		<cfelse>
			DEFECTED = 0,
			DEFECTED_LEVEL = 0,
		</cfif>
		SENTENCED = <cfif isDefined("attributes.sentenced") and len(attributes.sentenced)>#attributes.sentenced#<cfelse>0</cfif>,
		IDENTYCARD_NO = '#attributes.identycard_no#',
		NAME = '#attributes.name#',
		SURNAME = '#attributes.surname#',
		SEX = <cfif isdefined("attributes.sex") and len(attributes.sex)>#attributes.sex#<cfelse>0</cfif>,
		WORKTELCODE = <cfif len(attributes.worktelcode)>'#attributes.worktelcode#'<cfelse>NULL</cfif>,
		WORKTEL = <cfif len(attributes.worktel)>'#attributes.worktel#'<cfelse>NULL</cfif>,
		EMPAPP_PASSWORD = <cfif isdefined('attributes.empapp_password') and len(attributes.empapp_password)>'#sifreli#'<cfelse>NULL</cfif>,
		EXTENSION = <cfif len(attributes.extension)>'#attributes.extension#'<cfelse>NULL</cfif>,
		EMAIL = <cfif len(attributes.email)>'#attributes.email#'<cfelse>NULL</cfif>,
		MOBILCODE = <cfif len(attributes.mobilcode)>'#attributes.mobilcode#'<cfelse>NULL</cfif>,
		MOBIL = <cfif len(attributes.mobil)>'#attributes.mobil#'<cfelse>NULL</cfif>,
		MOBILCODE2 = <cfif len(attributes.mobilcode2)>'#attributes.mobilcode2#'<cfelse>NULL</cfif>,
		MOBIL2 = <cfif len(attributes.mobil2)>'#attributes.mobil2#'<cfelse>NULL</cfif>,
<!---		IMCAT_ID = <cfif len(attributes.imcat_id)>#attributes.imcat_id#<cfelse>NULL</cfif>,
		IM = <cfif len(attributes.im)>'#attributes.im#'<cfelse>NULL</cfif>,--->
		PHOTO = <cfif len(attributes.photo)>'#attributes.photo#'<cfelse>NULL</cfif>,
		PHOTO_SERVER_ID = <cfif len(attributes.photo)>#fusebox.server_machine#<cfelse>NULL</cfif>,
		IDENTYCARD_CAT = <cfif len(attributes.identycard_cat)>#attributes.identycard_cat#<cfelse>NULL</cfif>,
		PARTNER_COMPANY = '#attributes.partner_company#',
		PARTNER_NAME = <cfif len(attributes.partner_name)>'#attributes.partner_name#'<cfelse>NULL</cfif>,
		PARTNER_POSITION = '#attributes.partner_position#',
	  	DEFECTED_PROBABILITY = <cfif isdefined("attributes.defected_probability")>#attributes.defected_probability#<cfelse>0</cfif>,	
		ILLNESS_PROBABILITY = <cfif isdefined("attributes.illness_probability")>#attributes.illness_probability#<cfelse>0</cfif>,  	
	    ILLNESS_DETAIL = '#attributes.illness_detail#',
		HOMETELCODE = <cfif len(attributes.hometelcode)>'#attributes.hometelcode#'<cfelse>NULL</cfif>,
		HOMETEL = <cfif len(attributes.hometel)>'#attributes.hometel#'<cfelse>NULL</cfif>,
		HOMEADDRESS = '#attributes.homeaddress#',
		HOMEPOSTCODE = '#attributes.homepostcode#',
		HOMECOUNTY = <cfif len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
		HOMECITY = <cfif len(attributes.homecity_name) and len(attributes.homecity)>#attributes.homecity#<cfelse>NULL</cfif>,
		HOMECOUNTRY =<cfif len(attributes.homecountry)>#attributes.homecountry#<cfelse>NULL</cfif>,
		PREFERED_CITY = <cfif isdefined("attributes.prefered_city") and len(attributes.prefered_city)>'#attributes.prefered_city#'<cfelse>NULL</cfif>,
		IS_TRIP = <cfif len(attributes.is_trip)>#attributes.is_trip#</cfif>,
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
		KURS1 = '#attributes.kurs1#',
		KURS1_YIL = <cfif len(attributes.kurs1_yil) eq 4>{TS '#attributes.kurs1_yil#-01-01 00:00:00'}<cfelse>NULL</cfif>,
		KURS1_YER = '#attributes.kurs1_yer#',
		KURS1_GUN = <cfif len(attributes.kurs1_gun)>'#attributes.kurs1_gun#'<cfelse>NULL</cfif>,
		KURS2 = '#attributes.kurs2#',
		KURS2_YIL = <cfif len(attributes.kurs2_yil) eq 4>{TS '#attributes.kurs2_yil#-01-01 00:00:00'}<cfelse>NULL</cfif>,
		KURS2_YER = '#attributes.kurs2_yer#',
		KURS2_GUN = <cfif len(attributes.kurs2_gun)>'#attributes.kurs2_gun#'<cfelse>NULL</cfif>,
		KURS3 = '#attributes.kurs3#',
		KURS3_YIL = <cfif len(attributes.kurs3_yil) eq 4>{TS '#attributes.kurs3_yil#-01-01 00:00:00'}<cfelse>NULL</cfif>,
		KURS3_YER = <cfif len(attributes.kurs3_yer)>'#attributes.kurs3_yer#'<cfelse>NULL</cfif>,
		KURS3_GUN = <cfif len(attributes.kurs3_gun)>'#attributes.kurs3_gun#'<cfelse>NULL</cfif>,
		DRIVER_LICENCE = <cfif len(attributes.driver_licence)>'#attributes.driver_licence#'<cfelse>NULL</cfif>,
		LICENCE_START_DATE = <cfif len(attributes.licence_start_date)>#attributes.licence_start_date#<cfelse>NULL</cfif>,
		LICENCECAT_ID = <cfif len(attributes.driver_licence_type)>#attributes.driver_licence_type#<cfelse>NULL</cfif>,
		DRIVER_LICENCE_ACTIVED = <cfif len(attributes.driver_licence_actived)>#attributes.driver_licence_actived#<cfelse>NULL</cfif>,
		COMP_EXP = <cfif isdefined("attributes.comp_exp") and len("attributes.comp_exp")>'#attributes.comp_exp#'<cfelse>NULL</cfif>,
		INVESTIGATION = <cfif len(attributes.investigation)>'#attributes.investigation#'<cfelse>NULL</cfif>,
		TRAINING_LEVEL = <cfif len(attributes.training_level)>#attributes.training_level#<cfelse>NULL</cfif>,
		NATIONALITY = <cfif isdefined('attributes.nationality') and len(attributes.nationality)>#attributes.nationality#<cfelse>NULL</cfif>,
		CLUB = <cfif isdefined("attributes.club") and len(attributes.club)>'#attributes.club#'<cfelse>NULL</cfif>,
		HOBBY = <cfif isdefined("attributes.hobby") and len(attributes.hobby)>'#attributes.hobby#'<cfelse>NULL</cfif>,
		USE_CIGARETTE = <cfif isdefined("attributes.use_cigarette") and len(attributes.use_cigarette)>#attributes.use_cigarette#<cfelse>NULL</cfif>,
		MARTYR_RELATIVE = <cfif isdefined("attributes.martyr_relative") and len(attributes.martyr_relative)>#attributes.martyr_relative#<cfelse>NULL</cfif>,
		HOME_STATUS = <cfif isdefined('attributes.home_status') and len(attributes.home_status)>#attributes.home_status#<cfelse>NULL</cfif>,
		RESUME_TEXT = <cfif len(resume_text)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#resume_text#"><cfelse>NULL</cfif>
	WHERE
		EMPAPP_ID = #attributes.empapp_id#
</cfquery>
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
<!--- Bilgisayar Bilgisi --->
<cfquery name="get_teacher_info" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_APP_TEACHER_INFO WHERE EMPAPP_ID=#attributes.empapp_id#
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
					 EMPAPP_ID=#attributes.empapp_id#
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
					  #attributes.empapp_id#,
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
			 EMPAPP_ID=#attributes.empapp_id#
	</cfquery>
</cfif>
 <cfquery name="DETAIL_EXISTS" datasource="#DSN#">
	SELECT EMPLOYEE_IDENTY_ID FROM EMPLOYEES_IDENTY WHERE EMPAPP_ID = #attributes.EMPAPP_ID#
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
			TC_IDENTY_NO = <cfif len(attributes.tc_identy_no)>'#attributes.tc_identy_no#'<cfelse>NULL</cfif>,
			NUMBER = '#attributes.number#',
			FATHER = '#attributes.father#',
			MOTHER = '#attributes.mother#',
			FATHER_JOB = <cfif len(attributes.father_job)>'#attributes.father_job#'<cfelse>NULL</cfif>,
			MOTHER_JOB = <cfif len(attributes.mother_job)>'#attributes.mother_job#'<cfelse>NULL</cfif>,
			TAX_NUMBER = <cfif isdefined('attributes.tax_number') and len(attributes.tax_number)>'#attributes.tax_number#'<cfelse>NULL</cfif>,
			TAX_OFFICE = <cfif len(attributes.tax_office)>'#attributes.tax_office#'<cfelse>NULL</cfif>,
			BIRTH_DATE = <cfif len(attributes.birth_date)>#attributes.birth_date#<cfelse>NULL</cfif>,
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
			GIVEN_DATE = <cfif len(attributes.given_date)>#attributes.given_date#<cfelse>NULL</cfif>,
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
					EMPAPP_ID = #attributes.empapp_id#,
					IS_CONT_WORK= <cfif isdefined("attributes.is_cont_work#k#") and evaluate('attributes.is_cont_work#k#') eq 1>1<cfelse>0</cfif>
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
					IS_CONT_WORK
					)
				VALUES
					(
					#attributes.empapp_id#,
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
					<cfif len(evaluate('attributes.exp_task_id#k#'))>#evaluate('attributes.exp_task_id#k#')#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.is_cont_work#k#") and evaluate('attributes.is_cont_work#k#') eq 1>1<cfelse>0</cfif>
					)
			</cfquery>
		</cfif>
	 <cfelse>
	 	<cfif isDefined("attributes.empapp_row_id#k#") and len(evaluate("attributes.empapp_row_id#k#"))>
	 		<cfquery name="del_empapp_work_info" datasource="#dsn#">
				DELETE FROM EMPLOYEES_APP_WORK_INFO WHERE EMPAPP_ROW_ID = #evaluate("attributes.empapp_row_id#k#")#
			</cfquery>
		</cfif>
	 </cfif>
</cfloop>
<!--- İş Tecrübeleri --->

<!--- Eğitim Bilgileri --->
<cfloop from="1" to="#attributes.row_edu#" index="j">
	<cfif isdefined("attributes.row_kontrol_edu#j#") and evaluate("attributes.row_kontrol_edu#j#")>
		<cfif len(evaluate('attributes.edu_start#j#'))>
			<cfset attributes.edu_start=evaluate('attributes.edu_start#j#')>
			<cf_date tarih="attributes.edu_start">
		<cfelse>
			<cfset attributes.edu_start="">
		</cfif>
		<cfif len(evaluate('attributes.edu_finish#j#'))>
			<cfset attributes.edu_finish=evaluate('attributes.edu_finish#j#')>
			<cf_date tarih="attributes.edu_finish">
		<cfelse>
			<cfset attributes.edu_finish="">
		</cfif>
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
						EDU_START = <cfif len(attributes.edu_start)>#attributes.edu_start#<cfelse>NULL</cfif>,
						EDU_FINISH = <cfif len(attributes.edu_finish)>#attributes.edu_finish#<cfelse>NULL</cfif>,
						EDU_RANK = <cfif isdefined("attributes.edu_rank#j#") and len(evaluate('attributes.edu_rank#j#'))>'#wrk_eval('attributes.edu_rank#j#')#'<cfelse>NULL</cfif>,
						EMPAPP_ID=#attributes.empapp_id#,
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
						<cfif len(attributes.edu_start)>#attributes.edu_start#<cfelse>NULL</cfif>,
					<cfif len(attributes.edu_finish)>#attributes.edu_finish#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.edu_rank#j#") and len(evaluate('attributes.edu_rank#j#'))>'#wrk_eval('attributes.edu_rank#j#')#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.is_edu_continue#j#") and evaluate('attributes.is_edu_continue#j#') eq 1>1<cfelse>0</cfif>
					)
			</cfquery>
		</cfif>
	<cfelse>
		<cfif isDefined("attributes.empapp_edu_row_id#j#") and len(evaluate("attributes.empapp_edu_row_id#j#"))>
			<cfquery name="del_empapp_edu_info" datasource="#dsn#">
				DELETE FROM EMPLOYEES_APP_EDU_INFO WHERE EMPAPP_EDU_ROW_ID = #evaluate("attributes.empapp_edu_row_id#j#")#
			</cfquery>
		</cfif>
	</cfif>
</cfloop>
<!--- Eğitim Bilgileri--->


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
				DELETE FROM EMPLOYEES_RELATIVES WHERE RELATIVE_ID=#evaluate('attributes.relative_id#i#')#
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
<!--- çalışmak istediği birimler--->
<cfquery name="del_app_unit" datasource="#dsn#"> 
	DELETE FROM EMPLOYEES_APP_UNIT WHERE EMPAPP_ID = #attributes.empapp_id#
</cfquery>
	<cfquery name="get_cv_unit" datasource="#DSN#">
		SELECT * FROM SETUP_CV_UNIT
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
	<!--- Yabancı dil bilgileri--->
	<cfquery name="delete_lang" datasource="#dsn#">
		DELETE EMPLOYEES_APP_LANGUAGE WHERE EMPAPP_ID = #empapp_id#
	</cfquery>	
	<cfloop from="1" to="#attributes.add_lang_info#" index="m">
		<cfif isdefined('attributes.del_lang_info#m#') and  evaluate('attributes.del_lang_info#m#') eq 1><!--- silinmemiş ise.. --->
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
	<!--- Referans bilgileri---->
	<cfquery name="delete_emp_reference" datasource="#dsn#">
		DELETE EMPLOYEES_REFERENCE WHERE EMPAPP_ID=#empapp_id#
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
					#empapp_id#,
					NULL,
					<cfif len(wrk_eval('attributes.ref_type#r#'))>#wrk_eval('attributes.ref_type#r#')#<cfelse>NULL</cfif>,
					<cfif len(wrk_eval('attributes.ref_name#r#'))>'#wrk_eval('attributes.ref_name#r#')#'<cfelse>NULL</cfif>,
					<cfif len(wrk_eval('attributes.ref_company#r#'))>'#wrk_eval('attributes.ref_company#r#')#'<cfelse>NULL</cfif>,
					<cfif len(wrk_eval('attributes.ref_position#r#'))>'#wrk_eval('attributes.ref_position#r#')#'<cfelse>NULL</cfif>,
					<cfif len(wrk_eval('attributes.ref_telcode#r#'))>'#wrk_eval('attributes.ref_telcode#r#')#'<cfelse>NULL</cfif>,
					<cfif len(wrk_eval('attributes.ref_tel#r#'))>'#wrk_eval('attributes.ref_tel#r#')#'<cfelse>NULL</cfif>,
					<cfif len(wrk_eval('attributes.ref_mail#r#'))>'#wrk_eval('attributes.ref_mail#r#')#'<cfelse>NULL</cfif>
				 )
			</cfquery>
		</cfif>
	</cfloop>
	<!---//referans bilgileri --->
<script type="text/javascript">
	window.location.href = document.referrer;
</script>
