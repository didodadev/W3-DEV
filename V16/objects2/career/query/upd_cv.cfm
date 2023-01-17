<cfif not isdefined('session.cp.userid')>
	<cflocation url="#request.self#?fuseaction=objects2.kariyer_login" addtoken="no">
</cfif>
<cfif isdefined("attributes.stage") and attributes.stage eq 1>
	<cfif len(attributes.empapp_password)>
		<cf_cryptedpassword password="#attributes.empapp_password#" output="sifre">
	</cfif>
	<cfif len(attributes.birth_date)>
		<cf_date tarih="attributes.birth_date">
	<cfelse>
		<cfset attributes.birth_date = "NULL">
	</cfif>
	<cfquery name="UPD_CV_1" datasource="#DSN#">
		UPDATE 
			EMPLOYEES_APP
		SET
			NAME = '#attributes.emp_name#',
			SURNAME = '#attributes.emp_surname#',
			WORKTELCODE = <cfif len(attributes.worktelcode)>'#attributes.worktelcode#'<cfelse>NULL</cfif>,
			WORKTEL = <cfif len(attributes.worktel)>'#attributes.worktel#'<cfelse>NULL</cfif>,
			EMAIL = <cfif len(attributes.email)>'#attributes.email#'<cfelse>NULL</cfif>,
			MOBILCODE = <cfif len(attributes.mobilcode)>'#attributes.mobilcode#'<cfelse>NULL</cfif>,
			MOBIL = <cfif len(attributes.mobil)> '#attributes.mobil#'<cfelse>NULL</cfif>,
			MOBILCODE2 = <cfif len(attributes.mobilcode2)>'#attributes.mobilcode2#'<cfelse>NULL</cfif>,
			MOBIL2 = <cfif len(attributes.mobil2)> '#attributes.mobil2#'<cfelse>NULL</cfif>,
			HOMETELCODE = <cfif len(attributes.hometelcode)>'#attributes.hometelcode#'<cfelse>NULL</cfif>,
			HOMETEL = <cfif len(attributes.hometel)>'#attributes.hometel#'<cfelse>NULL</cfif>,
			HOMEADDRESS = '#attributes.homeaddress#',
			HOMEPOSTCODE = '#attributes.homepostcode#',
			HOMECOUNTY = '#attributes.homecounty#',
			<cfif len(attributes.empapp_password)>EMPAPP_PASSWORD ='#sifre#',</cfif>
			HOMECITY=<cfif len(attributes.homecity)>#attributes.homecity#<cfelse>NULL</cfif>,
			HOMECOUNTRY = <cfif len(attributes.homecountry)>#attributes.homecountry#<cfelse>NULL</cfif>,
			HOME_STATUS = <cfif isdefined('attributes.home_status') and len(attributes.home_status)>#attributes.home_status#<cfelse>NULL</cfif>,
			EXTENSION = <cfif len(attributes.extension)> '#attributes.extension#'<cfelse>NULL</cfif>,
			TAX_OFFICE = <cfif len(attributes.tax_office)>'#attributes.tax_office#'<cfelse>NULL</cfif>,
			TAX_NUMBER = <cfif len(attributes.tax_number)>#attributes.tax_number#<cfelse>NULL</cfif>,
			NATIONALITY = <cfif isdefined('attributes.nationality') and len(attributes.nationality)>#attributes.nationality#,<cfelse>NULL,</cfif>
			IDENTYCARD_CAT = <cfif len(attributes.identycard_cat)>#attributes.identycard_cat#<cfelse>NULL</cfif>, 
			IMCAT_ID = <cfif len(attributes.imcat_id)>#attributes.imcat_id#<cfelse>NULL</cfif>,
			IM = <cfif len(attributes.im)>'#attributes.im#'<cfelse>NULL</cfif>,
			IDENTYCARD_NO = <cfif len(attributes.identycard_no)>'#attributes.identycard_no#'<cfelse>NULL</cfif>,
			UPDATE_DATE = NULL,
			UPDATE_IP = NULL,
			UPDATE_EMP = NULL,
			UPDATE_APP_DATE = #now()#,
			UPDATE_APP_IP = '#cgi.remote_addr#',
			UPDATE_APP = #session.cp.userid#
		WHERE
			EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
	</cfquery>

	<cfquery name="UPD_IDENTY_1" datasource="#DSN#">
		UPDATE
			EMPLOYEES_IDENTY
		SET
			TC_IDENTY_NO = '#attributes.tc_identy_no#',
			BIRTH_DATE = <cfif len(attributes.birth_date)>#attributes.birth_date#<cfelse>NULL</cfif>,
			BIRTH_PLACE = '#attributes.birth_place#',
			CITY = <cfif len(attributes.city)>'#attributes.city#'<cfelse>NULL</cfif>,
			UPDATE_DATE = #now()#,
			UPDATE_IP = '#cgi.remote_addr#'
		WHERE
			EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
	</cfquery>
	<cflocation url="#request.self#?fuseaction=objects2.form_upd_cv_2" addtoken="no">
<cfelseif isdefined("attributes.stage") and attributes.stage eq 2>
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
	<cfif len(attributes.licence_start_date)>
		<cf_date tarih="attributes.licence_start_date">
	<cfelse>
		<cfset attributes.licence_start_date = "NULL">
	</cfif>

	<cfquery name="UPD_CV_2" datasource="#DSN#">
		UPDATE 
			EMPLOYEES_APP
		SET
		<cfif isdefined("attributes.defected")>
			DEFECTED = #attributes.defected#,
			<cfif isdefined('attributes.defected_level')>DEFECTED_LEVEL=#attributes.defected_level#,</cfif>
		<cfelse>
			DEFECTED = 0,
			DEFECTED_LEVEL = 0,
		</cfif>
		<cfif isDefined("attributes.sentenced")>
			SENTENCED = #attributes.sentenced#,
		<cfelse>
			SENTENCED = 0,
		</cfif>
			<cfif isdefined("attributes.sex") and len(attributes.sex)>SEX = #attributes.sex#<cfelse>SEX = 0</cfif>,
			MILITARY_STATUS = <cfif isdefined("attributes.military_status") and len(attributes.military_status)>#attributes.military_status#<cfelse>0</cfif>,
			MILITARY_DELAY_REASON = <cfif isdefined("attributes.military_status") and attributes.military_status eq 4>'#attributes.military_delay_reason#'<cfelse>NULL</cfif>,
			MILITARY_DELAY_DATE = <cfif isdefined("attributes.military_status") and attributes.military_status eq 4 and len(attributes.military_delay_date)>#attributes.military_delay_date#<cfelse>NULL</cfif>,
			MILITARY_FINISHDATE = <cfif isdefined("attributes.military_status") and attributes.military_status eq 1 and len(attributes.military_finishdate)>#attributes.military_finishdate#<cfelse>NULL</cfif>,
			MILITARY_EXEMPT_DETAIL = <cfif isdefined("attributes.military_status") and len(attributes.military_exempt_detail) and attributes.military_status eq 2>'#attributes.military_exempt_detail#'<cfelse>NULL</cfif>,
			MILITARY_MONTH = <cfif isdefined("attributes.military_status") and attributes.military_status eq 1 and len(attributes.military_month)>#attributes.military_month#<cfelse>NULL</cfif>,
			MILITARY_RANK = <cfif isdefined("attributes.military_status") and attributes.military_status eq 1 and isdefined('attributes.military_rank')>#attributes.military_rank#<cfelse>NULL</cfif>,
			USE_CIGARETTE = <cfif isdefined('attributes.use_cigarette') and len(attributes.use_cigarette)>#attributes.use_cigarette#<cfelse>NULL</cfif>,
			IMMIGRANT = <cfif isdefined('attributes.immigrant') and len(attributes.immigrant)>#attributes.immigrant#<cfelse>NULL</cfif>,
			DEFECTED_PROBABILITY = <cfif isdefined('attributes.defected_probability') and len(attributes.defected_probability)>#attributes.defected_probability#<cfelse>NULL</cfif>,
			MARTYR_RELATIVE = <cfif isdefined('attributes.martyr_relative') and len(attributes.martyr_relative)>#attributes.martyr_relative#<cfelse>NULL</cfif>,
			PARTNER_COMPANY = '#attributes.partner_company#',
			PARTNER_NAME = <cfif isdefined('attributes.partner_name') and len(attributes.partner_name)>'#attributes.partner_name#',<cfelse>NULL,</cfif>
			PARTNER_POSITION = <cfif isdefined('attributes.partner_position') and len(attributes.partner_position)>'#attributes.partner_position#',<cfelse>NULL,</cfif>
			LICENCE_START_DATE = <cfif isdefined('attributes.licence_start_date') and len(attributes.licence_start_date)>#attributes.licence_start_date#<cfelse>NULL</cfif>,
			LICENCECAT_ID = <cfif isdefined('attributes.driver_licence_type') and  len(attributes.driver_licence_type)>#attributes.driver_licence_type#<cfelse>NULL</cfif>,
			DRIVER_LICENCE_ACTIVED = <cfif  isdefined('attributes.driver_licence_actived') and  len(attributes.driver_licence_actived)>#attributes.driver_licence_actived#,<cfelse>NULL,</cfif>
			INVESTIGATION = <cfif isdefined('attributes.investigation') and len(attributes.investigation)>'#attributes.investigation#'<cfelse>NULL</cfif>,
			ILLNESS_PROBABILITY = <cfif isdefined("attributes.illness_probability") and len(attributes.illness_probability)>#attributes.illness_probability#,<cfelse>0,</cfif>  	
	   		ILLNESS_DETAIL = <cfif isdefined("attributes.illness_detail") and len(attributes.illness_detail)>'#attributes.illness_detail#',<cfelse>NULL,</cfif>
			SURGICAL_OPERATION = <cfif isdefined("attributes.surgical_operation") and len(attributes.surgical_operation)>'#attributes.surgical_operation#',<cfelse>NULL,</cfif>
			CHILD = <cfif isdefined("attributes.child") and len(attributes.child)>#attributes.child#<cfelse> NULL</cfif>,
			DRIVER_LICENCE = <cfif isdefined("attributes.driver_licence") and len(attributes.driver_licence)>'#attributes.driver_licence#'<cfelse>NULL</cfif>,
			UPDATE_DATE = NULL,
			UPDATE_IP = NULL,
			UPDATE_EMP = NULL,
			UPDATE_APP_DATE = #now()#,
			UPDATE_APP_IP = '#cgi.remote_addr#',
			UPDATE_APP = #session.cp.userid#
		WHERE
			EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
	</cfquery>
	<cfif not isdefined("attributes.married")>
		<cfset attributes.married = 0>
	</cfif>
	<cfquery name="UPD_IDENTY_2" datasource="#DSN#">
		UPDATE
			EMPLOYEES_IDENTY
		SET
			MARRIED = <cfif isdefined("attributes.married") and len(attributes.married)>#attributes.married#<cfelse>NULL</cfif>,
			UPDATE_DATE = #now()#,
			UPDATE_IP = '#cgi.REMOTE_ADDR#'
		WHERE
			EMPAPP_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
	</cfquery>
	<cfif isdefined('attributes.is_identity_detail') and attributes.is_identity_detail eq 1>
		<cflocation url="#request.self#?fuseaction=objects2.form_upd_cv_3" addtoken="no">
	<cfelse>
		<cflocation url="#request.self#?fuseaction=objects2.form_upd_cv_4" addtoken="no">	
	</cfif>
<cfelseif isdefined("attributes.stage") and attributes.stage eq 3>
	<cfif len(attributes.given_date)>
		<cf_date tarih="attributes.given_date">
	</cfif>
	<cfquery name="UPD_IDENTY" datasource="#DSN#">
		UPDATE 
			EMPLOYEES_IDENTY
		SET
			SERIES = <cfif len(attributes.series)>'#attributes.series#',<cfelse>NULL,</cfif>
			NUMBER = <cfif len(attributes.number)>'#attributes.number#',<cfelse>NULL,</cfif>
			BLOOD_TYPE = <cfif len(attributes.blood_type)>#attributes.blood_type#,<cfelse>NULL,</cfif> 
			FATHER = <cfif len(attributes.father)>'#attributes.father#',<cfelse>NULL,</cfif> 
			MOTHER = <cfif len(attributes.mother)>'#attributes.mother#',<cfelse>NULL,</cfif> 
			LAST_SURNAME = <cfif len(attributes.last_surname)>'#attributes.last_surname#',<cfelse>NULL,</cfif> 
			RELIGION = <cfif len(attributes.religion)>'#attributes.religion#',<cfelse>NULL,</cfif>  
			COUNTY = <cfif len(attributes.county)>'#attributes.county#',<cfelse>NULL,</cfif>  
			BINDING = <cfif len(attributes.binding)>'#attributes.binding#',<cfelse>NULL,</cfif> 
			WARD = <cfif len(attributes.ward)>'#attributes.ward#',<cfelse>NULL,</cfif> 
			FAMILY = <cfif len(attributes.family)>'#attributes.family#',<cfelse>NULL,</cfif> 
			VILLAGE = <cfif len(attributes.village)>'#attributes.village#',<cfelse>NULL,</cfif> 
			GIVEN_PLACE = <cfif len(attributes.given_place)>'#attributes.given_place#',<cfelse>NULL,</cfif> 
			GIVEN_DATE = <cfif len(attributes.given_date)>#attributes.given_date#,<cfelse>NULL,</cfif> 
			GIVEN_REASON = <cfif len(attributes.given_reason)>'#attributes.given_reason#',<cfelse>NULL,</cfif> 
			RECORD_NUMBER = <cfif len(attributes.record_number)>'#attributes.record_number#',<cfelse>NULL,</cfif> 
			FATHER_JOB = <cfif len(attributes.father_job)>'#attributes.father_job#',<cfelse>NULL,</cfif>
			MOTHER_JOB = <cfif len(attributes.mother_job)>'#attributes.mother_job#',<cfelse>NULL,</cfif>
			CUE = <cfif len(attributes.cue)>'#attributes.cue#'<cfelse>NULL</cfif>  
		WHERE 
			EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
	</cfquery>

	<cflocation url="#request.self#?fuseaction=objects2.form_upd_cv_4" addtoken="no">
<cfelseif isdefined("attributes.stage") and attributes.stage eq 4>
	<cfquery name="GET_TEACHER_INFO" datasource="#DSN#">
		SELECT * FROM EMPLOYEES_APP_TEACHER_INFO WHERE EMPAPP_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
	</cfquery>
	<cfif get_teacher_info.recordcount and len(get_teacher_info.COMPUTER_EDUCATION)>
		<cfset comp_edu_list = listsort(get_teacher_info.COMPUTER_EDUCATION,"numeric","ASC",",")>
	</cfif>
	<cfif isdefined('attributes.comp_exp') and len(attributes.comp_exp)>
		<cfif get_teacher_info.recordcount>
			<cfif len(get_teacher_info.COMPUTER_EDUCATION)>
				<cfset comp_edu_list=listappend(comp_edu_list,-1)>
				<cfquery name="UPD_TEACHER_INFO" datasource="#dsn#">
					UPDATE
						EMPLOYEES_APP_TEACHER_INFO
					SET
						COMPUTER_EDUCATION = ',#comp_edu_list#,'
					WHERE
						 EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
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
					#session.cp.userid#,
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
				 EMPAPP_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
		</cfquery>
	</cfif>
	<cfquery name="upd_cv_3" datasource="#dsn#">
		UPDATE 
			EMPLOYEES_APP
		SET
			TRAINING_LEVEL=<cfif isdefined("attributes.training_level") and len(attributes.training_level)>#attributes.training_level#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.lang1') and len(attributes.lang1)>
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
			<cfif isdefined('attributes.lang2') and len(attributes.lang2)>
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
			<cfif isdefined('attributes.lang3') and len(attributes.lang3)>
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
			<cfif isdefined('attributes.lang4') and len(attributes.lang4)>
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
			<cfif isdefined('attributes.lang5') and len(attributes.lang5)>
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
			COMP_EXP=<cfif len(attributes.comp_exp)>'#attributes.comp_exp#'<cfelse>NULL</cfif>,
			UPDATE_DATE = NULL,
			UPDATE_IP = NULL,
			UPDATE_EMP = NULL,
			UPDATE_APP_DATE = #now()#,
			UPDATE_APP_IP = '#cgi.remote_addr#',
			UPDATE_APP = #session.cp.userid#
		WHERE
			EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
	</cfquery>
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
								EMPAPP_ID = #session.cp.userid#,
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
							#session.cp.userid#,
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
		<!--- Eğitim Bilgileri --->
		<cfquery name="DELETE_EMP_COUR" datasource="#DSN#">
			DELETE EMPLOYEES_COURSE WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
		</cfquery>
	<cfloop from="1" to="#attributes.extra_course#" index="z">
		<cfif isdefined('attributes.del_course_prog#z#') and  evaluate('attributes.del_course_prog#z#') eq 1><!--- silinmemiş ise.. --->
			<cfif len(evaluate('attributes.kurs1_yil#z#')) and len(evaluate('attributes.kurs1_#z#'))>
				<cfquery name="add_employees_course" datasource="#dsn#">
					INSERT 
					INTO
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
						#session.cp.userid#,
						NULL,
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
	<!--- Eğitim Bilgileri--->	
	<cflocation url="#request.self#?fuseaction=objects2.form_upd_cv_5" addtoken="no">
<cfelseif isdefined("attributes.stage") and attributes.stage eq 5>
	<cfif not isdefined("attributes.is_exp")><!---tecrübe yok şeçilmediyse ise--->
		<!--- İş Tecrübeleri --->
		<cfloop from="1" to="#attributes.row_count#" index="k">
			<cfif isdefined("attributes.row_kontrol#k#") and evaluate("attributes.row_kontrol#k#")>
				<cfif isdate(evaluate('attributes.exp_start#k#'))>
					<cfset attributes.exp_start=evaluate('attributes.exp_start#k#')>
					<cf_date tarih="attributes.exp_start">
				<cfelse>
					<cfset attributes.exp_start="">
				</cfif>
				<cfif isdate(evaluate('attributes.exp_finish#k#'))>
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
					<cfset exp_name_ = evaluate("attributes.exp_name#k#")>
					<cfquery name="UPD_EMPLOYEES_APP_WORK_INFO" datasource="#DSN#">
						UPDATE
							EMPLOYEES_APP_WORK_INFO
						SET
							EXP = <cfif len(exp_name_)>'#exp_name_#'<cfelse>NULL</cfif>,
							<!--- FS 20080805 tirnak hatasi veriyordu bu sekilde duzenledim, sorun ortadan kalkti
							EXP = <cfif len(evaluate('attributes.exp_name#k#'))>'#wrk_eval('attributes.exp_name#k#')#'<cfelse>NULL</cfif>, --->
							EXP_POSITION = <cfif len(evaluate('attributes.exp_position#k#'))>'#wrk_eval('attributes.exp_position#k#')#'<cfelse>NULL</cfif>,
							EXP_START = <cfif isdate(attributes.exp_start)>#attributes.exp_start#<cfelse>NULL</cfif>,
							EXP_FINISH = <cfif isdate(attributes.exp_finish)>#attributes.exp_finish#<cfelse>NULL</cfif>,
							EXP_FARK = <cfif len(attributes.exp_fark)>#attributes.exp_fark#<cfelse>NULL</cfif>,
							EXP_REASON = <cfif len(evaluate('attributes.exp_reason#k#'))>'#Replace(evaluate('attributes.exp_reason#k#'),"'"," ","all")#'<cfelse>NULL</cfif>,
							EXP_EXTRA = <cfif len(evaluate('attributes.exp_extra#k#'))>'#Replace(evaluate('attributes.exp_extra#k#'),"'"," ","all")#'<cfelse>NULL</cfif>,
							EXP_TELCODE = <cfif len(evaluate('attributes.exp_telcode#k#'))>'#wrk_eval('attributes.exp_telcode#k#')#'<cfelse>NULL</cfif>,
							EXP_TEL = <cfif len(evaluate('attributes.exp_tel#k#'))>'#wrk_eval('attributes.exp_tel#k#')#'<cfelse>NULL</cfif>,
							EXP_SECTOR_CAT= <cfif len(evaluate('attributes.exp_sector_cat#k#'))>#evaluate('attributes.exp_sector_cat#k#')#<cfelse>NULL</cfif>,
							EXP_MONEY_TYPE = <cfif len(evaluate('attributes.exp_money_type#k#')) and evaluate('attributes.exp_money_type#k#') gt 0>'#evaluate('attributes.exp_money_type#k#')#'<cfelse>NULL</cfif>,
							EXP_SALARY = <cfif len(evaluate('attributes.exp_salary#k#')) and evaluate('attributes.exp_salary#k#') gt 0>#evaluate('attributes.exp_salary#k#')#<cfelse>NULL</cfif>,
							EXP_EXTRA_SALARY = <cfif len(evaluate('attributes.exp_extra_salary#k#')) and evaluate('attributes.exp_extra_salary#k#') gt 0>'#wrk_eval('attributes.exp_extra_salary#k#')#'<cfelse>NULL</cfif>,
							EXP_TASK_ID = <cfif len(evaluate('attributes.exp_task_id#k#'))>#evaluate('attributes.exp_task_id#k#')#<cfelse>NULL</cfif>,
							EMPAPP_ID = #session.cp.userid#,
							IS_CONT_WORK= <cfif isdefined("attributes.is_cont_work#k#") and evaluate('attributes.is_cont_work#k#') eq 1>1<cfelse>0</cfif>
						WHERE
							EMPAPP_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.empapp_row_id#k#")#">
					</cfquery>
				<cfelse>
					<cfset exp_name_ = evaluate("attributes.exp_name#k#")>
					<cfquery name="ADD_EMPLOYEES_APP_WORK_INFO" datasource="#DSN#">
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
							EXP_MONEY_TYPE,
							EXP_SALARY,
							EXP_EXTRA_SALARY,
							EXP_TASK_ID,
							IS_CONT_WORK
						)
						VALUES
						(
							#session.cp.userid#,
							<cfif len(exp_name_)>'#exp_name_#'<cfelse>NULL</cfif>,
							<!--- <cfif len(evaluate('attributes.exp_name#k#'))>'#wrk_eval('attributes.exp_name#k#')#'<cfelse>NULL</cfif>, --->
							<cfif len(evaluate('attributes.exp_position#k#'))>'#wrk_eval('attributes.exp_position#k#')#'<cfelse>NULL</cfif>,
							<cfif isdate(attributes.exp_start)>#attributes.exp_start#<cfelse>NULL</cfif>,
							<cfif isdate(attributes.exp_finish)>#attributes.exp_finish#<cfelse>NULL</cfif>,
							<cfif len(attributes.exp_fark)>#attributes.exp_fark#<cfelse>NULL</cfif>,
							<cfif len(evaluate('attributes.exp_reason#k#'))>'#Replace(evaluate('attributes.exp_reason#k#'),"'"," ","all")#'<cfelse>NULL</cfif>,
							<cfif len(evaluate('attributes.exp_extra#k#'))>'#Replace(evaluate('attributes.exp_extra#k#'),"'"," ","all")#'<cfelse>NULL</cfif>,
							<cfif len(evaluate('attributes.exp_telcode#k#'))>'#wrk_eval('attributes.exp_telcode#k#')#'<cfelse>NULL</cfif>,
							<cfif len(evaluate('attributes.exp_tel#k#'))>'#wrk_eval('attributes.exp_tel#k#')#'<cfelse>NULL</cfif>,			
							<cfif len(evaluate('attributes.exp_sector_cat#k#'))>#evaluate('attributes.exp_sector_cat#k#')#<cfelse>NULL</cfif>,
							<cfif len(evaluate('attributes.exp_money_type#k#')) and evaluate('attributes.exp_money_type#k#') gt 0>'#evaluate('attributes.exp_money_type#k#')#'<cfelse>NULL</cfif>,
							<cfif len(evaluate('attributes.exp_salary#k#')) and evaluate('attributes.exp_salary#k#') gt 0>#evaluate('attributes.exp_salary#k#')#<cfelse>NULL</cfif>,
							<cfif len(evaluate('attributes.exp_extra_salary#k#')) and evaluate('attributes.exp_extra_salary#k#') gt 0>'#wrk_eval('attributes.exp_extra_salary#k#')#'<cfelse>NULL</cfif>,
							<cfif len(evaluate('attributes.exp_task_id#k#'))>#evaluate('attributes.exp_task_id#k#')#<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.is_cont_work#k#") and evaluate('attributes.is_cont_work#k#') eq 1>1<cfelse>0</cfif>
						)
					</cfquery>
				</cfif>
			<cfelse>
				<cfif isDefined("attributes.empapp_row_id#k#") and len(evaluate("attributes.empapp_row_id#k#"))>
					<cfquery name="DEL_EMPAPP_WORK_INFO" datasource="#DSN#">
						DELETE FROM
							EMPLOYEES_APP_WORK_INFO
						WHERE
							EMPAPP_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.empapp_row_id#k#")#">
					</cfquery>
				</cfif>
			 </cfif>
		</cfloop>
		<cfquery name="DELETE_EMP_REFERENCE" datasource="#DSN#">
			DELETE EMPLOYEES_REFERENCE WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
		</cfquery>		
		<cfloop from="1" to="#attributes.add_ref_info#" index="r">
			<cfif isdefined('attributes.del_ref_info#r#') and  evaluate('attributes.del_ref_info#r#') eq 1><!--- silinmemiş ise.. --->
				<cfquery name="ADD_EMPLOYEES_REFERENCE" datasource="#DSN#">
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
							#session.cp.userid#,
							NULL,
							<cfif len(evaluate('attributes.ref_type#r#'))>#wrk_eval('attributes.ref_type#r#')#<cfelse>NULL</cfif>,
							'#wrk_eval('attributes.ref_name#r#')#',
							'#wrk_eval('attributes.ref_company#r#')#',
							'#wrk_eval('attributes.ref_position#r#')#',
							'#wrk_eval('attributes.ref_telcode#r#')#',
							'#wrk_eval('attributes.ref_tel#r#')#',
							'#wrk_eval('attributes.ref_mail#r#')#'
						 )
				</cfquery>
			</cfif>
		</cfloop>
		<cfquery name="UPD_CV_5" datasource="#DSN#">
			UPDATE 
				EMPLOYEES_APP
			SET
				UPDATE_DATE = NULL,
				UPDATE_IP = NULL,
				UPDATE_EMP = NULL,
				UPDATE_APP_DATE = #now()#,
				UPDATE_APP_IP = '#cgi.remote_addr#',
				UPDATE_APP = #session.cp.userid#
			WHERE
				EMPAPP_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
		</cfquery>
		<!--- İş Tecrübeleri --->
	</cfif>
	<cfquery name="UPD_CV_6" datasource="#DSN#">
		UPDATE 
			EMPLOYEES_APP
		SET
			CLUB='#attributes.club#',
			HOBBY='#attributes.hobby#'
		WHERE
			EMPAPP_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
	</cfquery>
	<cflocation url="#request.self#?fuseaction=objects2.form_upd_cv_6" addtoken="no">
<cfelseif isdefined("attributes.stage") and attributes.stage eq 6>
	<cfquery name="UPD_CV_9" datasource="#DSN#">
		UPDATE 
			EMPLOYEES_APP
		SET
			<!---PHOTO=<cfif len(attributes.photo)>'#attributes.photo#',<cfelse>NULL,</cfif>
			PHOTO_SERVER_ID=<cfif len(attributes.photo)>#fusebox.server_machine#,<cfelse>NULL,</cfif>--->
			PREFERED_CITY =<cfif isdefined("attributes.prefered_city") and len(attributes.prefered_city)>',#attributes.prefered_city#,',<cfelse>NULL,</cfif>
			IS_TRIP = #attributes.is_trip#,
			EXPECTED_PRICE =<cfif isDefined("attributes.expected_price") and len(attributes.expected_price)>#replace(EXPECTED_PRICE,',','','all')#<cfelse>NULL</cfif>,
			EXPECTED_MONEY_TYPE = <cfif isDefined("attributes.expected_money_type") and len(attributes.expected_money_type)>'#EXPECTED_MONEY_TYPE#'</cfif>,
			APPLICANT_NOTES = '#attributes.applicant_notes#',
			UPDATE_IP=NULL,
			UPDATE_DATE=NULL,
			UPDATE_EMP = NULL,
			UPDATE_APP_DATE = #now()#,
			UPDATE_APP_IP = '#cgi.remote_addr#',
			UPDATE_APP = #session.cp.userid#
		WHERE
			EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
	</cfquery>
	
	<!--- çalışmak istediği birimler--->
	<cfquery name="del_app_unit" datasource="#dsn#"> 
		DELETE FROM EMPLOYEES_APP_UNIT WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
	</cfquery>
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
						#session.cp.userid#,
						#get_cv_unit.unit_id#,
						#evaluate('unit#get_cv_unit.unit_id#')#
					)
			</cfquery> 
		</cfif>
		</cfoutput>
	<!--- //çalışmak istediği birimler--->
	<cflocation url="#request.self#?fuseaction=objects2.form_upd_cv_7" addtoken="no">
<cfelseif isdefined("attributes.stage") and attributes.stage eq 7>
<!---kayıtları sayfa içined popuplar yaptığı için query yok--->
	<cfquery name="UPD_CV_10" datasource="#DSN#">
		UPDATE 
			EMPLOYEES_APP
		SET
			APP_STATUS = <cfif isdefined('attributes.app_status')>#attributes.app_status#</cfif>,
			UPDATE_IP = NULL,
			UPDATE_DATE = NULL,
			UPDATE_EMP = NULL,
			UPDATE_APP_IP = '#cgi.remote_addr#',
			UPDATE_APP_DATE = #now()#,
			UPDATE_APP = #session.cp.userid#
		WHERE
			EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
	</cfquery>
	<cflocation url="#request.self#?fuseaction=objects2.dsp_cv" addtoken="no">
<cfelseif isdefined("attributes.stage") and attributes.stage eq 11>
	<!---Ek Bilgiler--->
    ek bgilgiler buraya gelcek   
</cfif>
<!---<cfelseif isdefined("attributes.stage") and attributes.stage eq 8>
	<cfquery name="upd_cv_1" datasource="#dsn#">
		UPDATE 
			EMPLOYEES_APP
		SET
			PREFERENCE_BRANCH = <cfif isdefined("attributes.preference_branch") and len(attributes.preference_branch)>'#attributes.preference_branch#',<cfelse>NULL,</cfif>
			UPDATE_DATE = NULL,
			UPDATE_IP = NULL,
			UPDATE_EMP = NULL,
			UPDATE_APP_DATE = #now()#,
			UPDATE_APP_IP = '#cgi.remote_addr#',
			UPDATE_APP = #session.cp.userid#
		WHERE
			EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
	</cfquery>

	
	<cflocation url="#request.self#?fuseaction=objects2.form_upd_cv_9" addtoken="no">
<cfelseif isdefined("attributes.stage") and attributes.stage eq 9>

	<cfset upload_folder = "#upload_folder#hr#dir_seperator#">
	<cfif len(attributes.old_photo)>
		<cfif len(attributes.photo)>
			<cffile action="delete" file="#upload_folder##attributes.old_photo#">
			<cfset attributes.old_photo = "">
		<cfelse>
			<cfif isdefined("del_photo")>
				<cffile action="delete" file="#upload_folder##attributes.old_photo#">
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
	<!---<cfquery name="upd_cv_9" datasource="#dsn#">
		UPDATE 
			EMPLOYEES_APP
		SET
			PHOTO=<cfif len(attributes.photo)>'#attributes.photo#',<cfelse>NULL,</cfif>
			PHOTO_SERVER_ID=<cfif len(attributes.photo)>#fusebox.server_machine#,<cfelse>NULL,</cfif>
			PREFERED_CITY =<cfif isdefined("attributes.prefered_city") and len(attributes.prefered_city)>',#attributes.prefered_city#,',<cfelse>NULL,</cfif>
			IS_TRIP = #attributes.is_trip#,
			EXPECTED_PRICE =<cfif isDefined("attributes.expected_price") and len(attributes.expected_price)>#replace(EXPECTED_PRICE,',','','all')#<cfelse>NULL</cfif>,
			EXPECTED_MONEY_TYPE = <cfif isDefined("attributes.expected_money_type") and len(attributes.expected_money_type)>'#EXPECTED_MONEY_TYPE#'</cfif>,
			APPLICANT_NOTES = '#attributes.applicant_notes#',
			UPDATE_IP=NULL,
			UPDATE_DATE=NULL,
			UPDATE_EMP = NULL,
			UPDATE_APP_DATE = #now()#,
			UPDATE_APP_IP = '#cgi.remote_addr#',
			UPDATE_APP = #session.cp.userid#
		WHERE
			EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
	</cfquery>--->
<!---dosya sil--->
	<cfif isdefined("attributes.old_asset_file") and len(attributes.old_asset_file) and isdefined("attributes.del_asset_file") and len(attributes.del_asset_file)>
		<cfset upload_folder = "#upload_folder#">
		<cfif FileExists("#upload_folder##attributes.old_asset_file#")>
			<cffile action="delete" file="#upload_folder##attributes.old_asset_file#">
		</cfif>
		<cfquery name="DEL_ASSET" datasource="#dsn#">
			DELETE FROM ASSET WHERE ASSET_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.del_asset_file#">
		</cfquery>
	</cfif>
<!---dosya ekle--->
<cfif isdefined("attributes.asset_file") and len(attributes.asset_file) and len(attributes.asset_file_name)>
	<cfset upload_folder = "#upload_folder##dir_seperator#">
 	<cftry>
		<cfset file_name = createUUID()>
		<cffile action="UPLOAD" nameconflict="MAKEUNIQUE" filefield="asset_file" destination="#upload_folder#" mode="777">
		<cffile action="rename" source="#upload_folder##dir_seperator##cffile.serverfile#" destination="#upload_folder##dir_seperator##file_name#.#cffile.serverfileext#">
		<!---Script dosyalarını engelle  02092010 FA-ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder##dir_seperator##file_name#.#cffile.serverfileext#">
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
		</cfif>
 		<cfcatch type="any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
<!--- PROPERTY_ID belge tipi 1 set ediliyor ancak 1 olmaya bilir dbde kariyer belgeleri için seçilen belge no ona göre ayarlanmalı--->
	<cfquery name="ADD_ASSET" datasource="#dsn#">
		INSERT INTO 
			ASSET
		(
		   MODULE_NAME,
		   MODULE_ID,
		   ACTION_SECTION,
		   ACTION_ID,
		   ASSETCAT_ID, 
		   ASSET_NAME,
		   ASSET_FILE_NAME,
		   ASSET_FILE_SIZE,
		   ASSET_DETAIL,
		   IS_SPECIAL,
		   RECORD_DATE,
		   RECORD_PUB,
		   RECORD_IP,
		   PROPERTY_ID,
		   COMPANY_ID,
		   ASSET_FILE_SERVER_ID
		)
		VALUES
		(
		   'HR',
		   3,
		   'EMPLOYEES_APP_ID',
		   #session.cp.userid#,
		   -8,
		   '#attributes.asset_file_name#' ,
		   '#file_name#.#cffile.serverfileext#',
		   #ROUND(CFFILE.FILESIZE/1024)#,
		   'Kariyer portalından eklenen dosya',
		   0,
		   #now()#,
		   #session.cp.userid#,
		   '#cgi.remote_addr#',
		   1,
		   1,
		   #fusebox.server_machine#
		)
	</cfquery>
</cfif>
	
	<cflocation url="#request.self#?fuseaction=objects2.form_upd_cv_10" addtoken="no">
<cfelseif isdefined("attributes.stage") and attributes.stage eq 10>
	<!---<cfquery name="upd_cv_10" datasource="#dsn#">
		UPDATE 
			EMPLOYEES_APP
		SET
			APP_STATUS = <cfif isdefined('attributes.app_status')>#attributes.app_status#</cfif>,
			UPDATE_IP = NULL,
			UPDATE_DATE = NULL,
			UPDATE_EMP = NULL,
			UPDATE_APP_IP = '#cgi.remote_addr#',
			UPDATE_APP_DATE = #now()#,
			UPDATE_APP = #session.cp.userid#
		WHERE
			EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
	</cfquery>--->
	<cflocation url="#request.self#?fuseaction=objects2.form_upd_cv_1" addtoken="no">
</cfif>--->

