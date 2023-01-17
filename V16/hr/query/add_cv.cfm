<cfif len(attributes.email)>
	<cfquery name="get_empapp_mail" datasource="#dsn#">
		SELECT EMAIL FROM EMPLOYEES_APP WHERE EMAIL='#attributes.email#'
	</cfquery>
	<cfif get_empapp_mail.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1725.Girdiğiniz mail adresine ait bir kullanıcı var  Aynı mail adresi ile başka bir kullanıcı ekleyemezsiniz'>!");
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
				alert("<cf_get_lang no ='1726.Resim yüklenemedi lütfen tekrar deneyiniz'> !");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
<cfelse>
	<cfset attributes.photo = "">
</cfif>

<cfif len(attributes.empapp_password)>
	<cf_cryptedpassword password="#attributes.empapp_password#" output="sifreli" mod="1">
</cfif>

<cfif isdate(attributes.birth_date)>
	<cf_date tarih="attributes.birth_date">
<cfelse>
	<cfset attributes.birth_date = "null">
</cfif>

<cfif len(attributes.given_date)>
	<cf_date tarih="attributes.given_date">
</cfif>
<cfif len(attributes.work_start_date)>
	<cf_date tarih="attributes.work_start_date">
<cfelse>
	<cfset attributes.work_start_date = "null">
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

<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_EMP_APP" datasource="#DSN#" result="MAX_ID">
					INSERT INTO 
						EMPLOYEES_APP
						(
						CV_TYPE,
						CV_STAGE,
						CV_SOURCE_ID,
						REFERENCE_NAME,
						REFERENCE_SURNAME,
						REFERENCE_POSITION,
						RELATED_BRANCH_ID,
						CV_RECORDER_EMP_ID,
						CV_RECORDER_EMP_NAME,
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
						<cfif len(attributes.empapp_password)>EMPAPP_PASSWORD,</cfif>
						<cfif len(attributes.extension)>EXTENSION,</cfif>
						EMAIL,
						<cfif len(attributes.mobilcode)>MOBILCODE,</cfif>
						<cfif len(attributes.mobil)>MOBIL,</cfif>
						<cfif len(attributes.mobilcode2)>MOBILCODE2,</cfif>
						<cfif len(attributes.mobil2)>MOBIL2,</cfif>
						<cfif len(attributes.tax_number)>TAX_NUMBER,</cfif>
						<cfif len(attributes.tax_office)>TAX_OFFICE,</cfif>
						<!---IMCAT_ID,
						IM,--->
						PHOTO,
						PHOTO_SERVER_ID,
						IDENTYCARD_CAT,
						IDENTYCARD_NO,
						PARTNER_NAME,
						PARTNER_COMPANY,
						PARTNER_POSITION,
						DRIVER_LICENCE,
						<cfif len(attributes.comp_exp)>COMP_EXP,</cfif>
						<cfif len(attributes.hometelcode)>HOMETELCODE,</cfif>
						HOMETEL,
						HOMEADDRESS,
						HOMEPOSTCODE,
						HOMECOUNTY,
						HOMECITY,
						HOMECOUNTRY,
						<cfif isdefined('attributes.prefered_city') and len(attributes.prefered_city)>PREFERED_CITY,</cfif>
						IS_TRIP,
						<cfif isdefined('attributes.expected_price') and len(attributes.expected_price)>EXPECTED_PRICE,</cfif>
						<cfif isdefined('attributes.expected_money_type') and len(attributes.expected_money_type)>EXPECTED_MONEY_TYPE,</cfif>
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
						RECORD_APP_IP,
						TC_IDENTY_NO,
						DEFECTED_PROBABILITY,
						ILLNESS_PROBABILITY,
						<cfif len(attributes.illness_detail)>ILLNESS_DETAIL,</cfif>
						<cfif len(attributes.surgical_operation)>SURGICAL_OPERATION,</cfif>	
						<cfif len(attributes.training_level)>TRAINING_LEVEL,</cfif>
						<cfif len(attributes.investigation)>INVESTIGATION,</cfif>
						LICENCECAT_ID,
						LICENCE_START_DATE,
						DRIVER_LICENCE_ACTIVED,
						NATIONALITY,
						CLUB,
						USE_CIGARETTE,
						MARTYR_RELATIVE,
						HOME_STATUS,
						HOBBY,
						WORK_STARTED,
						INTERVIEW_RESULT,
						COM_PACKET_PRO,
						ELECTRONIC_TOOLS,
						IS_PSICOTECHNIC,
						RELATED_REF_NAME,
						RELATED_REF_COMPANY,
						WORK_START_DATE,
						WORK_FINISHED,
						POSITION_CAT_ID1,
						POSITION_CAT_ID2,
						POSITION_CAT_ID3,
						PREFERENCE_BRANCH,
						PREFERENCE_ZONE,
						HAVE_CHILDREN
						<cfif attributes.have_children eq 1>,CHILD</cfif>,
                        CONTACT,
						CONTACT_RELATION,
						CONTACT_EMAIL,
						CONTACT_TELCODE,
						CONTACT_TEL,
						WANT_EMAIL,
						WANT_SMS,
						WANT_CALL,
						RESOURCE_ID
						)
					VALUES
						(
							#attributes.cv_type#,
							#attributes.process_stage#,
							<cfif len(attributes.cv_source)>#attributes.cv_source#<cfelse>NULL</cfif>,
							'#attributes.reference_name#',
							'#attributes.reference_surname#',
							'#attributes.reference_position#',
							<cfif len(attributes.branch_id)>#attributes.branch_id#<cfelse>NULL</cfif>,
							<cfif len(attributes.cv_recorder_emp_id) and len(attributes.cv_recorder_emp_name)>#attributes.cv_recorder_emp_id#<cfelse>NULL</cfif>,
							<cfif len(attributes.cv_recorder_emp_id) and len(attributes.cv_recorder_emp_name)>'#attributes.cv_recorder_emp_name#'<cfelse>NULL</cfif>,
							<!---<cfif len(ATTRIBUTES.cv_status_id)>#ATTRIBUTES.cv_status_id#<cfelse>NULL</cfif>,--->
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
							'#attributes.name_#',
						<cfif len(attributes.worktelcode)>
							'#attributes.worktelcode#',
						</cfif>
						<cfif len(attributes.worktel)>
							'#attributes.worktel#',
						</cfif>
							'#attributes.surname#',
						<cfif len(attributes.empapp_password)>'#sifreli#',</cfif>
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
						<!---<cfif len(attributes.imcat_id)>#attributes.imcat_id#<cfelse>NULL</cfif>,
						'#attributes.im#',--->
						'#attributes.photo#',
						#fusebox.server_machine#,
						<cfif len(attributes.identycard_cat)>#attributes.identycard_cat#<cfelse>NULL</cfif>,
							'#attributes.identycard_no#',
						<cfif len(attributes.partner_name)>
							'#attributes.partner_name#',
						<cfelse>
							NULL,
						</cfif>
						'#attributes.partner_company#',
						'#attributes.partner_position#',
						'#attributes.driver_licence#',
						<cfif len(attributes.comp_exp)>'#attributes.comp_exp#',</cfif>
						<cfif len(attributes.hometelcode)>'#attributes.hometelcode#',</cfif>
						<cfif len(attributes.hometel)>'#attributes.hometel#'<cfelse>NULL</cfif>,
						<cfif len(attributes.homeaddress)>'#attributes.homeaddress#'<cfelse>NULL</cfif>,
						<cfif len(attributes.homepostcode)>'#attributes.homepostcode#'<cfelse>NULL</cfif>,
						<cfif len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
						<cfif len(attributes.homecity)>#attributes.homecity#,<cfelse>NULL,</cfif>
						<cfif len(attributes.homecountry)>#attributes.homecountry#,<cfelse>NULL,</cfif>
						<cfif isdefined('attributes.prefered_city') and len(attributes.prefered_city)>',#attributes.prefered_city#,',</cfif>
						<cfif isdefined('attributes.is_trip')>#attributes.is_trip#<cfelse>0</cfif>,
						<cfif isDefined("attributes.expected_price") and len(attributes.expected_price)>#attributes.expected_price#,</cfif>
						<cfif isDefined("attributes.expected_money_type") and len(attributes.expected_money_type)>'#attributes.expected_money_type#',</cfif>
						'#attributes.applicant_notes#',
						<cfif isdefined("attributes.military_status") and len(attributes.military_status)>#attributes.military_status#,<cfelse>NULL,</cfif>
						<cfif isdefined("attributes.military_status") and attributes.military_status eq 4 and len(attributes.MILITARY_DELAY_REASON)>'#attributes.MILITARY_DELAY_REASON#',<cfelse>NULL,</cfif>
						<cfif isdefined("attributes.military_status") and attributes.military_status eq 4 and len(attributes.MILITARY_DELAY_DATE)>#attributes.MILITARY_DELAY_DATE#,<cfelse>NULL,</cfif>
						<cfif isdefined("attributes.military_status") and attributes.military_status eq 1 and len(attributes.military_finishdate)>#attributes.military_finishdate#,<cfelse>NULL,</cfif>
						<cfif isdefined("attributes.military_status") and attributes.military_status eq 1 and len(attributes.military_month)>#attributes.military_month#,<cfelse>NULL,</cfif>
						<cfif isdefined("attributes.military_status") and attributes.military_status eq 1 and isdefined('attributes.military_rank')>#attributes.military_rank#,<cfelse>NULL,</cfif>
						<cfif isdefined("attributes.military_status") and attributes.military_status eq 2>'#attributes.military_exempt_detail#',<cfelse>NULL,</cfif>
						#NOW()#,
						#SESSION.EP.USERID#,
						'#CGI.REMOTE_ADDR#',
						NULL,
						NULL,
						NULL,
						'#attributes.tc_identy_no#',
						#attributes.defected_probability#,
						#attributes.illness_probability#,
						<cfif len(attributes.illness_detail)>'#attributes.illness_detail#',</cfif>
						<cfif len(attributes.surgical_operation)>'#attributes.surgical_operation#',</cfif>	
						 <cfif len(attributes.training_level)>#attributes.training_level#,</cfif>
						<cfif isdefined("attributes.notice_id") and len(attributes.notice_id)>#attributes.notice_id#,</cfif>
						<cfif len(attributes.investigation)>'#attributes.investigation#',</cfif>
						<cfif len(attributes.driver_licence_type)>#attributes.driver_licence_type#<cfelse>NULL</cfif>,
						<cfif len(attributes.licence_start_date)>#attributes.licence_start_date#<cfelse>NULL</cfif>,
						<cfif len(attributes.driver_licence_actived)>#attributes.driver_licence_actived#,<cfelse>NULL,</cfif>
						<cfif isdefined('attributes.nationality') and len(attributes.nationality)>#attributes.nationality#<cfelse>NULL</cfif>,
						'#attributes.club#',
						#attributes.use_cigarette#,
						#attributes.martyr_relative#,
						<cfif isdefined('attributes.home_status') and len(attributes.home_status)>#attributes.home_status#<cfelse>NULL</cfif>,
						<cfif len(attributes.hobby)>'#attributes.hobby#'<cfelse>NULL</cfif>,
						0,
						<cfif isdefined("attributes.interview_result") and len(attributes.interview_result)>'#attributes.interview_result#'<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.comp_packet_pro") and len(attributes.comp_packet_pro)>'#attributes.comp_packet_pro#'<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.electronic_tools") and len(attributes.electronic_tools)>'#electronic_tools#'<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.psikoteknik") and len(attributes.psikoteknik)>#attributes.psikoteknik#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.related_ref_name") and len(attributes.related_ref_name)>'#attributes.related_ref_name#'<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.related_ref_company") and len(attributes.related_ref_company)>'#attributes.related_ref_company#'<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.work_start_date") and len(attributes.work_start_date)>#attributes.work_start_date#<cfelse>NULL</cfif>,
						0,
						<cfif len(attributes.position_cat_id1)>#attributes.position_cat_id1#<cfelse>NULL</cfif>,
						<cfif len(attributes.position_cat_id2)>#attributes.position_cat_id2#<cfelse>NULL</cfif>,
						<cfif len(attributes.position_cat_id3)>#attributes.position_cat_id3#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.preference_branch') and len(attributes.preference_branch)>'#attributes.preference_branch#'<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.preference_zone') and len(attributes.preference_zone)>#attributes.preference_zone#<cfelse>NULL</cfif>,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.have_children#">
						<cfif attributes.have_children eq 1>,<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.child#"></cfif>,
                        <cfif len(attributes.contact)>'#attributes.contact#'<cfelse>NULL</cfif>,
                        <cfif len(attributes.contact_relation)>'#attributes.contact_relation#'<cfelse>NULL</cfif>,
                        <cfif len(attributes.contact_email)>'#attributes.contact_email#'<cfelse>NULL</cfif>,
                        <cfif len(attributes.contact_telcode)>'#attributes.contact_telcode#'<cfelse>NULL</cfif>,
                        <cfif len(attributes.contact_tel)>'#attributes.contact_tel#'<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.not_want_email') and len(attributes.not_want_email)>0<cfelse>1</cfif>,
						<cfif isdefined('attributes.not_want_sms') and len(attributes.not_want_sms)>0<cfelse>1</cfif>,
						<cfif isdefined('attributes.not_want_call') and len(attributes.not_want_call)>0<cfelse>1</cfif>,
						<cfif isdefined('attributes.resource') and len(attributes.resource)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.resource#"><cfelse>NULL</cfif>
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
					IS_CONT_WORK,
                    EXP_WORK_TYPE_ID
					)
				VALUES
					(
					#MAX_ID.IDENTITYCOL#,
					NULL,
					<cfif len(evaluate('attributes.exp_name#k#'))>'#Replace(evaluate('attributes.exp_name#k#'),"'"," ","all")#'<cfelse>NULL</cfif>,
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
					<cfif isdefined("attributes.is_cont_work#k#") and evaluate('attributes.is_cont_work#k#') eq 1>1<cfelse>0</cfif>,
                    <cfif len(evaluate('attributes.exp_work_type_id#k#'))>#evaluate('attributes.exp_work_type_id#k#')#<cfelse>NULL</cfif>
					)
			</cfquery>
			</cfif>
		</cfloop>
	</cfif>
	<!--- İş Tecrübeleri --->

	<!--- Eğitim Bilgileri --->
	 <cfif attributes.extra_course gt 0>
		<cfloop from="1" to="#attributes.extra_course#" index="z">
			<cfif isdefined('attributes.del_course_prog#z#') and  evaluate('attributes.del_course_prog#z#') eq 1><!--- silinmemiş ise.. --->
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
						#MAX_ID.IDENTITYCOL#,
						NULL,
						'#wrk_eval('attributes.kurs1_#z#')#',
						'#wrk_eval('attributes.kurs1_exp#z#')#',
						{TS '#evaluate('attributes.kurs1_yil#z#')#-01-01 00:00:00'},
						'#wrk_eval('attributes.kurs1_yer#z#')#',
						'#wrk_eval('attributes.kurs1_gun#z#')#'
					 )
				</cfquery>
			</cfif>
		</cfloop>
	 </cfif>  
	 <cfif attributes.add_ref_info gt 0>
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
						#MAX_ID.IDENTITYCOL#,
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
	 </cfif> 
     <cfif attributes.add_im_info gt 0>
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
                        #MAX_ID.IDENTITYCOL#
					 )
				</cfquery>
			</cfif>
		</cfloop>
	 </cfif> 
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
			SERIES,
			TC_IDENTY_NO,
		<cfif len(attributes.TAX_NUMBER)>TAX_NUMBER,</cfif>
		<cfif len(attributes.tax_office)>TAX_OFFICE,</cfif>
			NUMBER,
			FATHER,
			MOTHER,
			FATHER_JOB,
			MOTHER_JOB,
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
			#MAX_ID.IDENTITYCOL#,
			'#attributes.series#',
			'#attributes.tc_identy_no#',	
		<cfif len(attributes.tax_number)>
			'#attributes.tax_number#',
		</cfif>
		<cfif len(attributes.tax_office)>
			'#attributes.tax_office#',
		</cfif>
			'#attributes.number#',
			'#attributes.father#',
			'#attributes.mother#',
		<cfif len(attributes.father_job)>'#attributes.father_job#',<cfelse>NULL,</cfif>
		<cfif len(attributes.mother_job)>'#attributes.mother_job#',<cfelse>NULL,</cfif>
		<cfif isdate(attributes.birth_date)>#attributes.birth_date#,<cfelse>NULL,</cfif>
			'#attributes.birth_place#',
			<cfif len(attributes.birth_city)>#attributes.birth_city#<cfelse>NULL</cfif>,
			#attributes.married#,
			'#attributes.religion#',
			 <cfif len(attributes.blood_type)>#attributes.blood_type#,<cfelse>NULL,</cfif>
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
	
	<!--- yakınları--->
	<cfif attributes.rowCount gt 0>
	<cfloop from="1" to="#attributes.rowCount#" index="i">
		<cfif isdefined('attributes.name_relative#i#') and len(evaluate('attributes.name_relative#i#'))>
				<cfif len(evaluate('attributes.BIRTH_DATE_relative#i#'))>
					<cfset attributes.birth_date_relative=evaluate('attributes.BIRTH_DATE_relative#i#')>
					<cf_date tarih="attributes.birth_date_relative">
				</cfif>
	
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
				#MAX_ID.IDENTITYCOL#,
				NULL,
				'#wrk_eval('attributes.name_relative#i#')#',
				'#wrk_eval('attributes.surname_relative#i#')#',
				'#wrk_eval('attributes.relative_level#i#')#',
				#attributes.birth_date_relative#,
				'#wrk_eval('attributes.birth_place_relative#i#')#',
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
	</cfloop>
	</cfif>
	<!--- //yakınları--->
	
	<!--- çalışmak istediği birimler--->
		<cfquery name="get_cv_unit" datasource="#DSN#">
			SELECT UNIT_ID FROM SETUP_CV_UNIT
		</cfquery>
		<cfoutput query="get_cv_unit">
		<cfif isdefined('unit#get_cv_unit.unit_id#') and len(evaluate('unit#get_cv_unit.unit_id#'))>
			<cfquery name="add_unit" datasource="#dsn#">
				INSERT INTO 
					EMPLOYEES_APP_UNIT
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
	<!--- Yabancı dil bilgileri--->
	<cfif not len(attributes.add_lang_info)><cfset attributes.add_lang_info = 0></cfif>
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
					#MAX_ID.IDENTITYCOL#,
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
		<cfset attributes.info_id =  MAX_ID.IDENTITYCOL>
		<cfset attributes.is_upd = 0>
		<cfset attributes.info_type_id = -23>
		<cfinclude template="../../objects/query/add_info_plus2.cfm">
		<!---Ek Bilgiler--->
	
		<cf_workcube_process 
			is_upd='1' 
			data_source='#dsn#' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_table='EMPLOYEES_APP'
			action_column='EMPAPP_ID'
			action_id='#MAX_ID.IDENTITYCOL#'
			action_page='#request.self#?fuseaction=hr.form_upd_cv&empapp_id=#MAX_ID.IDENTITYCOL#' 
			warning_description='İK : #MAX_ID.IDENTITYCOL#'>
		<cf_add_content_relation action_type="7" action_type_id="#MAX_ID.IDENTITYCOL#">
	</cftransaction>
</cflock>

<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=hr.list_cv&event=upd&empapp_id=#MAX_ID.IDENTITYCOL#</cfoutput>";
</script>
