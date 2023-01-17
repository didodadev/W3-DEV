<cfset count=0>
<cfloop list="#attributes.empapp_id_list#" index="attributes.empapp_id">
	<cfset count=count+1>
	<cfif count lte attributes.emp_count>
		<cflock name="#CreateUUID()#" timeout="20">
			<cftransaction>
				<cf_papers paper_type="EMPLOYEE">
				<cfset system_paper_no=paper_code & '-' & paper_number>
				<cfset system_paper_no_add=paper_number>
				<cfset NEWEST_EMPLOYEE_NO=system_paper_no>
				
				<cfquery name="control_emp_start" datasource="#dsn#">
					SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE EMPAPP_ID = #listgetat(attributes.empapp_id_list,count,',')#
				</cfquery>
				<!--- işe alınırsa deneme süresi için employees_app update ediyor---->
				<cfif isdefined("attributes.test_time_#count#") and len(evaluate('attributes.test_time_#count#'))>
					<cfquery name="ADD_CAUTION" datasource="#DSN#">
					UPDATE
						EMPLOYEES_APP
					SET
						TEST_TIME = #evaluate('attributes.test_time_#count#')#,
						TEST_DETAIL = <cfif len(evaluate('attributes.test_detail_#count#'))>'#wrk_eval('attributes.test_detail_#count#')#',<cfelse>NULL,</cfif>
						CAUTION_TIME = <cfif len(evaluate('attributes.caution_time_#count#'))>#evaluate('attributes.caution_time_#count#')#,<cfelse>0,</cfif>
						CAUTION_EMP = <cfif len(evaluate('attributes.caution_emp_id_#count#'))>#evaluate('attributes.caution_emp_id_#count#')#,<cfelse>NULL,</cfif>
						QUIZ_ID = <cfif len(evaluate('attributes.quiz_id_#count#'))>#evaluate('attributes.quiz_id_#count#')#<cfelse>NULL</cfif>
					WHERE
						EMPAPP_ID = #listgetat(attributes.empapp_id_list,count,',')#
					</cfquery>
				</cfif>
			
				<cfset empapp_id=#listgetat(attributes.empapp_id_list,count,',')#>
				<cfinclude template="get_app.cfm">
				
				<!--- İŞE ALINDIĞINI İŞ BAŞVURU HİSTORY E EKLE --->
				<cfquery name="ADD_HISTORY" datasource="#DSN#">
					INSERT INTO
						EMPLOYEES_APP_HISTORY
					(
						EMPAPP_ID,
						APP_POS_ID,
						APP_STATUS,
						NAME,
						SURNAME,
						STARTED,
						STEP_NAME,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
					VALUES
					(
						#get_app.empapp_id#,
						<cfif listlen(attributes.list_app_pos_id,',') gte count>#listgetat(attributes.list_app_pos_id,count,',')#<cfelse>NULL</cfif>,
						<cfif len(get_app.app_status)>1<cfelse>0</cfif>,
						'#get_app.name#',
						'#get_app.surname#',
						1,
						'İşe Alındı',
						#NOW()#,
						#SESSION.EP.USERID#,
						'#CGI.REMOTE_ADDR#'
					)
				</cfquery>
				
				<!---işe başladığını belli edecek bit valuelar düzenleniyor--->
				<cfquery name="set_worked" datasource="#dsn#">
					UPDATE 
						EMPLOYEES_APP
					SET
						WORK_STARTED = 1,
						WORK_FINISHED = 0
					WHERE
						EMPAPP_ID = #listgetat(attributes.empapp_id_list,count,',')#
				</cfquery>
			
			
				<!--- emp_control_start --->
				<cfif control_emp_start.recordcount eq 0> 	
					<cfquery name="ADD_EMPLOYEES" datasource="#DSN#" result="MAX_ID">
						INSERT INTO 
							EMPLOYEES
						(
<!---							<cfif len(get_app.imcat_id)>IMCAT_ID,</cfif>--->
							<cfif len(get_app.worktelcode)>DIRECT_TELCODE,</cfif>
							<cfif len(get_app.worktel)>DIRECT_TEL,</cfif>
							<cfif len(get_app.extension)>EXTENSION,</cfif>
							<cfif len(get_app.mobilcode)>MOBILCODE,</cfif>
							<cfif len(get_app.mobil)>MOBILTEL,</cfif>
							EMPLOYEE_STATUS, 
							EMPLOYEE_NAME, 
							EMPLOYEE_SURNAME, 
							EMPLOYEE_EMAIL, 
							<!---IM,---> 
							PHOTO, 
							EMPAPP_ID,
							PHOTO_SERVER_ID,
							EMPLOYEE_STAGE,
							RECORD_DATE, 
							RECORD_EMP, 
							RECORD_IP,
							EMPLOYEE_NO 
						)
						VALUES
						(
<!---							<cfif len(get_app.imcat_id)>#get_app.imcat_id#,</cfif>--->
							<cfif len(get_app.worktelcode)>'#get_app.worktelcode#',</cfif>
							<cfif len(get_app.worktel)>'#get_app.worktel#',</cfif>
							<cfif len(get_app.extension)>'#get_app.extension#',</cfif>
							<cfif len(get_app.mobilcode)>'#get_app.mobilcode#',</cfif>
							<cfif len(get_app.mobil)>'#get_app.mobil#',</cfif>
							1, 
							'#get_app.name#', 
							'#get_app.surname#', 
							'#get_app.email#', 
							<!---'#get_app.im#',---> 
							'#get_app.photo#', 
							#get_app.empapp_id#,
							1,
							#attributes.process_stage#,
							#now()#,
							#SESSION.EP.USERID#,
							'#CGI.REMOTE_ADDR#',
							'#NEWEST_EMPLOYEE_NO#' 
						)
					</cfquery>
					<cfset get_max_emp.MAX_ID = MAX_ID.IDENTITYCOL>
					<cfquery name="upd_empapp" datasource="#dsn#">
						UPDATE 
							EMPLOYEES_APP
						SET
							EMPLOYEE_ID=#get_max_emp.MAX_ID#
						WHERE
							EMPAPP_ID = #listgetat(attributes.empapp_id_list,count,',')#
					</cfquery>
			
					<cfif len(get_app.caution_time) and (get_app.caution_time neq 0)>
						<cfif len(get_app.caution_emp)>
							<cfquery name="get_pos_code" datasource="#DSN#">
							   SELECT 
								 POSITION_CODE
							  FROM 
								 EMPLOYEE_POSITIONS 
							  WHERE 
								 EMPLOYEE_ID = #get_app.caution_emp# 
							</cfquery>
							<cfquery name="get_max_emps" datasource="#DSN#">
								SELECT
									MAX(EMPLOYEE_ID) AS MAX_ID
								FROM
									EMPLOYEES
							</cfquery>
							<cfif isdefined("attributes.quiz_id_#count#") and len(evaluate('attributes.quiz_id_#count#'))>
								<cfquery name="ADD_QUIZ_RESULT" datasource="#dsn#">
									INSERT INTO
										EMPLOYEE_QUIZ_RESULTS
									(
										QUIZ_ID,
										EMP_ID,
										USER_POINT
									)
									VALUES
									(
										#evaluate('attributes.quiz_id_#count#')#,
										#GET_MAX_EMPS.MAX_ID#,
										0			
									)
								</cfquery>
							</cfif>
							<cfset url_link ='#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#get_max_emp.max_id#'>
							<cfset pos_code = get_pos_code.position_code>
							<cfset all_time = get_app.test_time - get_app.caution_time>
							<cfset caution_date = date_add("D",all_time,now())>
							<cfset title = 'Deneme süresi dolan '&'#get_app.name# #get_app.surname#'&' için değerlendirme bekleniyor'>
							<cfquery name="add_warning" datasource="#DSN#"><!--- Onay Ve Uyarılar Listesine ekleme yapılıyor --->
								INSERT INTO
									PAGE_WARNINGS
								(
									URL_LINK,
									WARNING_HEAD,
									WARNING_DESCRIPTION,
									EMAIL_WARNING_DATE,
									LAST_RESPONSE_DATE,
									RECORD_DATE,
									RECORD_IP,
									RECORD_EMP,
									POSITION_CODE,
									IS_ACTIVE,
									IS_PARENT,
									IS_CAUTION_ACTION,
									RESPONSE_ID
								)
								VALUES
								(
									'#url_link#',
									'#title#',
									'#get_app.test_detail#',
									#caution_date#,
									#caution_date#,
									#now()#,
									'#CGI.REMOTE_ADDR#',
									#SESSION.EP.USERID#,
									#pos_code#,
									1,
									1,
									1,
									0
								)
							</cfquery>
							<cfquery name="GET_WARNINGS" datasource="#dsn#">
								SELECT MAX(W_ID) MAX FROM PAGE_WARNINGS
							</cfquery>
					
							<cfquery name="GET_WARNINGS" datasource="#dsn#">
								UPDATE
									PAGE_WARNINGS 
								SET
									PARENT_ID = #GET_WARNINGS.max# 
								WHERE
									W_ID = #GET_WARNINGS.max#			
							</cfquery>
						</cfif>
					</cfif>  
			
					<cfset member_code = "E#get_max_emp.max_id#">
					<cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
						UPDATE
							EMPLOYEES
						SET
							MEMBER_CODE = '#member_code#'
						WHERE
							EMPLOYEE_ID = #get_max_emp.max_id#
					</cfquery>
					
					<cfquery name="ADD_MY_SETTINGS" datasource="#DSN#">
						INSERT INTO
							MY_SETTINGS
						(
							EMPLOYEE_ID,
							DAY_AGENDA,
							MAIN_NEWS,
							TIME_ZONE,
							LANGUAGE_ID,
							INTERFACE_ID,
							INTERFACE_COLOR,
							AGENDA,
							POLL_NOW,
							MYWORKS,
							MY_VALIDS,
							MY_BUYERS,
							MY_SELLERS,
							MAXROWS,
							TIMEOUT_LIMIT
						)
						VALUES
						(
							#get_max_emp.max_id#,
							1,
							1,
							'+2',
							'tr',
							1,
							1,
							1,
							1,
							1,
							1,
							1,
							1,
							20,
							30
						)
					</cfquery>

				<!--- EMPLOYEES_APP DEN ŞAHSİ İLETİŞİM BİLGİLERİ ALINIYOR --->
				<cfquery name="GET_CONT_INFOS" datasource="#DSN#">
					SELECT
						WORKTELCODE,
						WORKTEL,
						EXTENSION,
						MOBILCODE,
						MOBIL,
						MOBILCODE2,
						MOBIL2,
						EMAIL
					FROM
						EMPLOYEES_APP
					WHERE
						EMPAPP_ID = #get_app.empapp_id#
				</cfquery>
			
				<cfquery name="ADD_EMPLOYEES_DETAIL" datasource="#DSN#">
					INSERT INTO 
						EMPLOYEES_DETAIL
					(
						<cfif len(get_app.sex)>SEX,</cfif> 
						<cfif len(get_app.hometelcode)>HOMETEL_CODE,</cfif>
						<cfif len(get_app.hometel)>HOMETEL,</cfif>
						<cfif len(get_app.homeaddress)>HOMEADDRESS,</cfif>
						<cfif len(get_app.homepostcode)>HOMEPOSTCODE,</cfif>
						<cfif len(get_app.homecounty)>HOMECOUNTY,</cfif>
						<cfif len(get_app.homecity)>HOMECITY,</cfif>
						<cfif len(get_app.homecountry)>HOMECOUNTRY,</cfif>
						<cfif len(get_app.comp_exp)>COMP_EXP,</cfif>
						<cfif len(get_app.military_status)>MILITARY_STATUS,</cfif>
						<cfif len(get_app.military_delay_reason)>MILITARY_DELAY_REASON,</cfif>
						<cfif len(get_app.military_delay_date)>MILITARY_DELAY_DATE,</cfif>
						<cfif len(get_app.military_finish_date)>MILITARY_FINISHDATE,</cfif>
						<cfif len(get_app.military_month)>MILITARY_MONTH,</cfif>
						<cfif len(get_app.military_rank)>MILITARY_RANK,</cfif>
						<cfif len(get_app.military_exempt_detail)>MILITARY_EXEMPT_DETAIL,</cfif>
						<cfif len(get_app.IDENTYCARD_CAT)>IDENTYCARD_CAT, </cfif>
						<cfif len(get_app.defected)>DEFECTED, </cfif>
						<cfif len(get_app.defected_level)>DEFECTED_LEVEL, </cfif>
						<cfif len(get_app.SENTENCED)>SENTENCED, </cfif>
						<cfif len(get_app.TEST_TIME)>TEST_TIME,</cfif>
						<cfif len(get_app.TEST_DETAIL)>TEST_DETAIL,</cfif>
						<cfif len(get_app.CAUTION_TIME)>CAUTION_TIME,</cfif>
						<cfif len(get_app.CAUTION_EMP)>CAUTION_EMP,</cfif>
						<cfif len(get_app.QUIZ_ID)>QUIZ_ID,</cfif>
						EMPLOYEE_ID,
						IDENTYCARD_NO, 
						PARTNER_COMPANY, 
						PARTNER_POSITION
						<cfif len(GET_CONT_INFOS.WORKTELCODE)>,DIRECT_TELCODE_SPC</cfif>
						<cfif len(GET_CONT_INFOS.WORKTEL)>,DIRECT_TEL_SPC</cfif>
						<cfif len(GET_CONT_INFOS.EXTENSION)>,EXTENSION_SPC</cfif>
						<cfif len(GET_CONT_INFOS.MOBILCODE)>,MOBILCODE_SPC</cfif>
						<cfif len(GET_CONT_INFOS.MOBIL)>,MOBILTEL_SPC</cfif>
						<cfif len(GET_CONT_INFOS.MOBILCODE2)>,MOBILCODE2_SPC</cfif>
						<cfif len(GET_CONT_INFOS.MOBIL2)>,MOBILTEL2_SPC</cfif>
						<cfif len(GET_CONT_INFOS.EMAIL)>,EMAIL_SPC</cfif>
						<cfif len(get_app.training_level)>,LAST_SCHOOL</cfif>
						<cfif len(get_app.ILLNESS_PROBABILITY)>,ILLNESS_PROBABILITY</cfif>
						<cfif len(get_app.ILLNESS_DETAIL)>,ILLNESS_DETAIL</cfif>
						<cfif len(get_app.CLUB)>,CLUB</cfif>
						<cfif len(get_app.DEFECTED_PROBABILITY)>,DEFECTED_PROBABILITY</cfif>
					)
					VALUES
					(
						<cfif len(get_app.sex)>#get_app.sex#,</cfif> 
						<cfif len(get_app.hometelcode)>'#get_app.hometelcode#',</cfif>
						<cfif len(get_app.hometel)>'#get_app.hometel#',</cfif>
						<cfif len(get_app.homeaddress)>'#get_app.homeaddress#',</cfif>
						<cfif len(get_app.homepostcode)>'#get_app.homepostcode#',</cfif>
						<cfif len(get_app.homecounty)>'#get_app.homecounty#',</cfif>
						<cfif len(get_app.homecity)>#get_app.homecity#,</cfif>
						<cfif len(get_app.homecountry)>#get_app.homecountry#,</cfif>
						<cfif len(get_app.comp_exp)>'#get_app.comp_exp#',</cfif>
						<cfif len(get_app.military_status)>#get_app.military_status#,</cfif>
						<cfif len(get_app.military_delay_reason)>'#get_app.military_delay_reason#',</cfif>
						<cfif len(get_app.military_delay_date)>#CreateODBCDate(get_app.military_delay_date)#,</cfif>
						<cfif len(get_app.military_finish_date)>#get_app.military_finish_date#,</cfif>
						<cfif len(get_app.military_month)>#get_app.military_month#,</cfif>
						<cfif len(get_app.military_rank)>#get_app.military_rank#,</cfif>
						<cfif len(get_app.military_exempt_detail)>'#get_app.military_exempt_detail#',</cfif>
						<cfif len(get_app.IDENTYCARD_CAT)>#get_app.IDENTYCARD_CAT#,</cfif>
						<cfif len(get_app.defected)>#get_app.defected#,</cfif>
						<cfif len(get_app.defected_level)>#get_app.defected_level#, </cfif>
						<cfif len(get_app.SENTENCED)>#get_app.SENTENCED#,</cfif>
						<cfif len(get_app.TEST_TIME)>#get_app.TEST_TIME#,</cfif>
						<cfif len(get_app.TEST_DETAIL)>'#get_app.TEST_DETAIL#',</cfif>
						<cfif len(get_app.CAUTION_TIME)>#get_app.CAUTION_TIME#,</cfif>
						<cfif len(get_app.CAUTION_EMP)>#get_app.CAUTION_EMP#,</cfif>
						<cfif len(get_app.QUIZ_ID)>#get_app.QUIZ_ID#,</cfif>
						#get_max_emp.max_id#,
						'#get_app.IDENTYCARD_NO#', 
						'#get_app.PARTNER_COMPANY#', 
						'#get_app.PARTNER_POSITION#'
						<cfif len(GET_CONT_INFOS.WORKTELCODE)>,'#GET_CONT_INFOS.WORKTELCODE#'</cfif>
						<cfif len(GET_CONT_INFOS.WORKTEL)>,'#GET_CONT_INFOS.WORKTEL#'</cfif>
						<cfif len(GET_CONT_INFOS.EXTENSION)>,'#GET_CONT_INFOS.EXTENSION#'</cfif>
						<cfif len(GET_CONT_INFOS.MOBILCODE)>,'#GET_CONT_INFOS.MOBILCODE#'</cfif>
						<cfif len(GET_CONT_INFOS.MOBIL)>,'#GET_CONT_INFOS.MOBIL#'</cfif>
						<cfif len(GET_CONT_INFOS.MOBILCODE2)>,'#GET_CONT_INFOS.MOBILCODE2#'</cfif>
						<cfif len(GET_CONT_INFOS.MOBIL2)>,'#GET_CONT_INFOS.MOBIL2#'</cfif>
						<cfif len(GET_CONT_INFOS.EMAIL)>,'#GET_CONT_INFOS.EMAIL#'</cfif>
						<cfif len(get_app.training_level)>,#get_app.training_level#</cfif>
						<cfif len(get_app.ILLNESS_PROBABILITY)>,#get_app.ILLNESS_PROBABILITY#</cfif>
						<cfif len(get_app.ILLNESS_DETAIL)>,'#get_app.ILLNESS_DETAIL#'</cfif>
						<cfif len(get_app.CLUB)>,'#get_app.CLUB#'</cfif>
						<cfif len(get_app.DEFECTED_PROBABILITY)>,#get_app.DEFECTED_PROBABILITY#</cfif>
					)
				</cfquery>
				<!--- KURS bilgileri aktarılıyor--->
				<cfquery name="get_course" datasource="#dsn#">
					SELECT
						COURSE_SUBJECT,
						COURSE_EXPLANATION,
						COURSE_YEAR,
						COURSE_LOCATION,
						COURSE_PERIOD
					FROM
						EMPLOYEES_COURSE
					WHERE
						EMPAPP_ID = #get_app.empapp_id#
				</cfquery>
				<cfif get_course.recordcount>
					<cfloop query="get_course">
						<cfquery name="add_course" datasource="#dsn#">
							INSERT INTO
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
									#get_max_emp.max_id#,
									<cfif len(get_course.COURSE_SUBJECT)>'#get_course.COURSE_SUBJECT#'<cfelse>NULL</cfif>,
									<cfif len(get_course.COURSE_EXPLANATION)>'#get_course.COURSE_EXPLANATION#'<cfelse>NULL</cfif>,
									<cfif len(get_course.COURSE_YEAR)>'#get_course.COURSE_YEAR#'<cfelse>NULL</cfif>,
									<cfif len(get_course.COURSE_LOCATION)>'#get_course.COURSE_LOCATION#'<cfelse>NULL</cfif>,
									<cfif len(get_course.COURSE_PERIOD)>'#get_course.COURSE_PERIOD#'<cfelse>NULL</cfif>
								)
						</cfquery>
					</cfloop>
				</cfif>
				<!---//kurs bilgileri --->
				
				<!--- ehliyet bilgileri coklu tabloya atiliyor. BK 20090213--->
				<cfif len(get_app.licencecat_id)>
					<cfquery name="ADD_EMPLOYEE_DRIVERLICENCE_ROWS" datasource="#DSN#">
						INSERT INTO
							EMPLOYEE_DRIVERLICENCE_ROWS
						(
							EMPLOYEE_ID,
							LICENCECAT_ID,
							LICENCE_START_DATE,
							LICENCE_NO,
							LICENCE_ACTIVED,
							UPDATE_EMP,
							UPDATE_DATE,
							UPDATE_IP
						)
							VALUES
						(
							#get_max_emp.max_id#,
							#get_app.licencecat_id#,
							<cfif len(get_app.licence_start_date)>#CreateODBCDateTime(get_app.licence_start_date)#<cfelse>NULL</cfif>,
							<cfif len(get_app.driver_licence)>'#get_app.driver_licence#'<cfelse>NULL</cfif>,
							<cfif len(get_app.driver_licence_actived)>#get_app.driver_licence_actived#<cfelse>NULL</cfif>,
							#session.ep.userid#,
							#now()#,
							'#cgi.remote_addr#'
						)
					</cfquery>	
				</cfif>
				<!--- yabancı dil bilgileri--->
				<cfquery name="get_language" datasource="#dsn#">
					SELECT 
						LANG_ID,
						LANG_SPEAK,
						LANG_MEAN,
						LANG_WRITE,
						LANG_WHERE
					FROM
						EMPLOYEES_APP_LANGUAGE
					WHERE 
						EMPAPP_ID = #get_app.empapp_id#
				</cfquery>
				<cfif get_language.recordcount>
					<cfloop query="get_language">
						<cfquery name="insert_lang" datasource="#dsn#">
							INSERT INTO
								EMPLOYEES_APP_LANGUAGE
								(
									EMPLOYEE_ID,
									LANG_ID,
									LANG_SPEAK,
									LANG_MEAN,
									LANG_WRITE,
									LANG_WHERE
								)
							VALUES
								(
									#get_max_emp.max_id#,
									<cfif len(get_language.lang_id)>#get_language.lang_id#<cfelse>NULL</cfif>,
									<cfif len(get_language.lang_speak)>#get_language.lang_speak#<cfelse>NULL</cfif>,
									<cfif len(get_language.lang_mean)>#get_language.lang_mean#<cfelse>NULL</cfif>,
									<cfif len(get_language.lang_write)>#get_language.lang_write#<cfelse>NULL</cfif>,
									<cfif len(get_language.lang_where)>'#get_language.lang_where#'<cfelse>NULL</cfif>
								)
						</cfquery>
					</cfloop>
				</cfif>
				<!--- //yabancı dil bilgileri---->
				<!--- referans bilgileri--->
				<cfquery name="get_ref" datasource="#dsn#">
					SELECT
						REFERENCE_TYPE,
						REFERENCE_NAME,
						REFERENCE_COMPANY,
						REFERENCE_POSITION,
						REFERENCE_TELCODE,
						REFERENCE_TEL,
						REFERENCE_EMAIL
					FROM
						EMPLOYEES_REFERENCE
					WHERE
						EMPAPP_ID = #get_app.empapp_id#
				</cfquery>
				<cfif get_ref.recordcount>
					<cfloop query="get_ref">
						<cfquery name="insert_ref" datasource="#dsn#">
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
									REFERENCE_EMAIL
								)
							VALUES
								(
									#get_max_emp.max_id#,
									<cfif len(get_ref.reference_type)>#get_ref.reference_type#<cfelse>NULL</cfif>,
									<cfif len(get_ref.reference_name)>'#get_ref.reference_name#'<cfelse>NULL</cfif>,
									<cfif len(get_ref.reference_company)>'#get_ref.reference_company#'<cfelse>NULL</cfif>,
									<cfif len(get_ref.reference_position)>'#get_ref.reference_position#'<cfelse>NULL</cfif>,
									<cfif len(get_ref.reference_telcode)>'#get_ref.reference_telcode#'<cfelse>NULL</cfif>,
									<cfif len(get_ref.reference_tel)>'#get_ref.reference_tel#'<cfelse>NULL</cfif>,
									<cfif len(get_ref.reference_email)>'#get_ref.reference_email#'<cfelse>NULL</cfif>
								)
						</cfquery>
					</cfloop>
				</cfif>
				<!--- //referans bilgileri--->
				<cfquery name="GET_WORK_INFO" datasource="#DSN#">
					SELECT
						EXP,
						EXP_POSITION,
						EXP_START,
						EXP_FINISH,
						EXP_FARK,
						EXP_ADDR,
						EXP_REASON,
						EXP_EXTRA,
						EXP_TELCODE,
						EXP_TEL,
						EXP_SECTOR_CAT,
						EXP_SALARY,
						EXP_EXTRA_SALARY,
						EXP_TASK_ID,
						IS_CONT_WORK
					FROM
						EMPLOYEES_APP_WORK_INFO
					WHERE
						EMPAPP_ID = #get_app.empapp_id#
				</cfquery>
				<cfif GET_WORK_INFO.recordcount>
					<cfloop query="GET_WORK_INFO">
						<cfquery name="INSERT_WORK" datasource="#DSN#">
							INSERT 
								INTO EMPLOYEES_APP_WORK_INFO
							(
								EMPLOYEE_ID,
								EMPAPP_ID,
								EXP,
								EXP_POSITION,
								EXP_START,
								EXP_FINISH,
								EXP_FARK,
								EXP_ADDR,
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
								#get_max_emp.max_id#,
								NULL,
								<cfif len(GET_WORK_INFO.EXP)>'#GET_WORK_INFO.EXP#'<cfelse>NULL</cfif>,
								<cfif len(GET_WORK_INFO.EXP_POSITION)>'#GET_WORK_INFO.EXP_POSITION#'<cfelse>NULL</cfif>,
								<cfif len(GET_WORK_INFO.EXP_START)>#CreateODBCDateTime(evaluate('GET_WORK_INFO.EXP_START'))#<cfelse>NULL</cfif>,
								<cfif len(GET_WORK_INFO.EXP_FINISH)>#CreateODBCDateTime(evaluate('GET_WORK_INFO.EXP_FINISH'))#<cfelse>NULL</cfif>,
								<cfif len(GET_WORK_INFO.EXP_FARK)>#GET_WORK_INFO.EXP_FARK#<cfelse>NULL</cfif>,
								<cfif len(GET_WORK_INFO.EXP_ADDR)>'#GET_WORK_INFO.EXP_ADDR#'<cfelse>NULL</cfif>,
								<cfif len(GET_WORK_INFO.EXP_REASON)>'#GET_WORK_INFO.EXP_REASON#'<cfelse>NULL</cfif>,
								<cfif len(GET_WORK_INFO.EXP_EXTRA)>'#GET_WORK_INFO.EXP_EXTRA#'<cfelse>NULL</cfif>,
								<cfif len(GET_WORK_INFO.EXP_TELCODE)>'#GET_WORK_INFO.EXP_TELCODE#'<cfelse>NULL</cfif>,
								<cfif len(GET_WORK_INFO.EXP_TEL)>'#GET_WORK_INFO.EXP_TEL#'<cfelse>NULL</cfif>,
								<cfif len(GET_WORK_INFO.EXP_SECTOR_CAT)>#GET_WORK_INFO.EXP_SECTOR_CAT#<cfelse>NULL</cfif>,
								<cfif len(GET_WORK_INFO.EXP_SALARY)>#GET_WORK_INFO.EXP_SALARY#<cfelse>NULL</cfif>,
								<cfif len(GET_WORK_INFO.EXP_EXTRA_SALARY)>'#GET_WORK_INFO.EXP_EXTRA_SALARY#'<cfelse>NULL</cfif>,
								<cfif len(GET_WORK_INFO.EXP_TASK_ID)>#GET_WORK_INFO.EXP_TASK_ID#<cfelse>NULL</cfif>,
								<cfif len(GET_WORK_INFO.IS_CONT_WORK)>#GET_WORK_INFO.IS_CONT_WORK#<cfelse>NULL</cfif>
							)
						</cfquery>
					</cfloop>
				</cfif>
				<cfquery name="GET_EDU_INFO" datasource="#DSN#">
					SELECT
						EDU_TYPE,
						EDU_ID,
						EDU_NAME,
						EDU_PART_ID,
						EDU_PART_NAME,
						EDU_START,
						EDU_FINISH,
						EDU_RANK,
						IS_EDU_CONTINUE
					FROM
						EMPLOYEES_APP_EDU_INFO
					WHERE
						EMPAPP_ID = #get_app.empapp_id#
				</cfquery>
				<cfif GET_EDU_INFO.recordcount>
					<cfloop query="GET_EDU_INFO">
						<cfquery name="INSERT_EDU" datasource="#DSN#">
							INSERT 
								INTO EMPLOYEES_APP_EDU_INFO
							(
								EMPLOYEE_ID,
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
								#get_max_emp.max_id#,
								NULL,
								<cfif len(GET_EDU_INFO.EDU_TYPE)>#GET_EDU_INFO.EDU_TYPE#<cfelse>NULL</cfif>,
								<cfif len(GET_EDU_INFO.EDU_ID)>#GET_EDU_INFO.EDU_ID#<cfelse>NULL</cfif>,
								<cfif len(GET_EDU_INFO.EDU_NAME)>'#GET_EDU_INFO.EDU_NAME#'<cfelse>NULL</cfif>,
								<cfif len(GET_EDU_INFO.EDU_PART_ID)>#GET_EDU_INFO.EDU_PART_ID#<cfelse>NULL</cfif>,
								<cfif len(GET_EDU_INFO.EDU_PART_NAME)>'#GET_EDU_INFO.EDU_PART_NAME#'<cfelse>NULL</cfif>,
								<cfif len(GET_EDU_INFO.EDU_START)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#GET_EDU_INFO.EDU_START#"><cfelse>NULL</cfif>,
								<cfif len(GET_EDU_INFO.EDU_FINISH)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#GET_EDU_INFO.EDU_FINISH#"><cfelse>NULL</cfif>,
								<cfif len(GET_EDU_INFO.EDU_RANK)>'#GET_EDU_INFO.EDU_RANK#'<cfelse>NULL</cfif>,
								<cfif len(GET_EDU_INFO.IS_EDU_CONTINUE)>#GET_EDU_INFO.IS_EDU_CONTINUE#<cfelse>NULL</cfif>
							)
						</cfquery>
					</cfloop>
				</cfif>
				<cfquery name="UPD_IDENTY" datasource="#DSN#">
					UPDATE
						EMPLOYEES_IDENTY
					SET
						EMPLOYEE_ID = #GET_MAX_EMP.MAX_ID#,
						NATIONALITY = <cfif len(get_app.NATIONALITY)>#get_app.NATIONALITY#<cfelse>NULL</cfif>
					WHERE
						EMPAPP_ID = #get_app.empapp_id#
				</cfquery>
				
				<cfquery name="upd_relatives" datasource="#DSN#">
					UPDATE
						EMPLOYEES_RELATIVES
					SET
						EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MAX_EMP.MAX_ID#">,
                        VALIDITY_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(YEAR(NOW()),MONTH(NOW()),1)#">
					WHERE
						EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.empapp_id#">
				</cfquery>
			
				<cfquery name="upd_app_status_false" datasource="#DSN#">
					UPDATE
						EMPLOYEES_APP
					SET
						APP_STATUS = 0
					WHERE
						EMPAPP_ID = #get_app.empapp_id#
				</cfquery>
			
				<!--- paperno update ediliyor.. --->
                <cfif len(system_paper_no_add)>
                    <cfquery name="UPD_GEN_PAP" datasource="#DSN#">
                        UPDATE 
                            GENERAL_PAPERS_MAIN
                        SET
                            EMPLOYEE_NUMBER=#system_paper_no_add#
                        WHERE
                            EMPLOYEE_NUMBER IS NOT NULL
                    </cfquery>
                </cfif>
				<cfelse>
					<script type="text/javascript">
						alert("<cf_get_lang no ='1737.İşe başlatmak istediğiniz kişi, çalışan olarak daha önce kayıt edilmiş'>.<cf_get_lang_main no='1075.Çalışan No'> : <cfoutput>#control_emp_start.EMPLOYEE_ID#</cfoutput>!");
					</script>
				</cfif>
			</cftransaction>
		</cflock>
	</cfif>
</cfloop>

<script type="text/javascript">
	<cfif isDefined("attributes.draggable") and attributes.draggable eq 1>
		location.href= document.referrer;
	<cfelse>
        <cfif control_emp_start.recordcount eq 0>
            <cflocation addtoken="no" url="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#get_max_emp.max_id#">
		    /* window.opener.location.href='<cfoutput>#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#get_max_emp.max_id#</cfoutput>'; */
        <cfelse>
            <cflocation addtoken="no" url="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#control_emp_start.EMPLOYEE_ID#">
		    /* window.opener.location.href='<cfoutput>#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#control_emp_start.EMPLOYEE_ID#</cfoutput>'; */
        </cfif>
	</cfif>
</script>
