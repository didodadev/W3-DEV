<cflock name="#createUUID()#" timeout="60">			
<cftransaction>
<cfquery name="add_survey_questions" datasource="#dsn#">
	INSERT INTO 
		SURVEY_MAIN_RESULT
		(	
			SURVEY_MAIN_ID,
			PROCESS_ROW_ID, 
			ACTION_ID,
			ACTION_TYPE,
			COMPANY_ID,
			PARTNER_ID,  
			CONSUMER_ID,
			EMP_ID,  
			RESULT_NOTE,
			START_DATE,
			FINISH_DATE,
			IS_CLOSED,
			EMPAPP_ID,
			<cfif attributes.action_type eq 8><!--- sadece performans formunda gelecek---->
			MANAGER1_EMP_ID,
			MANAGER1_POS,
			MANAGER2_EMP_ID,
			MANAGER2_POS,
			MANAGER3_EMP_ID,
			MANAGER3_POS,
			</cfif>
			<cfif isdefined('attributes.valid1') and len(attributes.valid1)>
				VALID1 ,
				VALID1_EMP,
				VALID1_DATE,
			</cfif>
			<cfif isdefined('attributes.valid2') and len(attributes.valid2)>
				VALID2,
				VALID2_EMP,
				VALID2_DATE,
			</cfif>
			<cfif isdefined('attributes.valid3') and len(attributes.valid3)>
				VALID3,
				VALID3_EMP,
				VALID3_DATE,
			</cfif>
			<cfif isdefined('attributes.valid') and len(attributes.valid)>
				VALID,
			</cfif>
			<cfif isdefined('attributes.valid4') and len(attributes.valid4)>
				VALID4,
			</cfif>			
			IS_SHOW_EMPLOYEE,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP,
			EMPLOYEE_EMAIL
			<cfif isdefined('attributes.user_name') and len(attributes.user_name) and isdefined('attributes.user_id') and len(attributes.user_id)>
				<cfif attributes.user_type eq 'employee'>
					,CLASS_ATTENDER_EMP_ID
				<cfelseif attributes.user_type eq 'partner'>
					,CLASS_ATTENDER_PAR_ID
				<cfelseif attributes.user_type eq 'consumer'>
					,CLASS_ATTENDER_CONS_ID
				</cfif>
			</cfif>
		)
		VALUES
		(	
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">,
			<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>, 
			<cfif isdefined('attributes.action_type_id') and len(attributes.action_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type_id#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.action_type') and len(attributes.action_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.company_id') and len(attributes.company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#"><cfelse>NULL</cfif>,  
			<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.employee_id') and len(attributes.employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"><cfelse>NULL</cfif>, 
			<cfif isdefined('attributes.notes') and len(attributes.notes)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.notes#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.start_date') and len(attributes.start_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateformat(attributes.start_date,dateformat_style)#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateformat(attributes.finish_date,dateformat_style)#"><cfelse>NULL</cfif>,
			0,
			<cfif isdefined('attributes.empapp_id') and len(attributes.empapp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.empapp_id#"><cfelse>NULL</cfif>,
			<cfif attributes.action_type eq 8><!--- sadece performans formunda gelecek---->
				<cfif isdefined('attributes.manager_1_emp_id') and len(attributes.manager_1_emp_id)>#attributes.manager_1_emp_id#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.manager_1_pos') and len(attributes.manager_1_pos)>#attributes.manager_1_pos#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.manager_2_emp_id') and len(attributes.manager_2_emp_id)>#attributes.manager_2_emp_id#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.manager_2_pos') and len(attributes.manager_2_pos)>#attributes.manager_2_pos#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.manager_3_emp_id') and len(attributes.manager_3_emp_id)>#attributes.manager_3_emp_id#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.manager_3_pos') and len(attributes.manager_3_pos)>#attributes.manager_3_pos#<cfelse>NULL</cfif>,
			</cfif>
			<cfif isdefined('attributes.valid1') and len(attributes.valid1)>
				#attributes.valid1#,
				#session.ep.userid#,
				#now()#,
			</cfif>
			<cfif isdefined('attributes.valid2') and len(attributes.valid2)>
				#attributes.valid2#,
				#session.ep.userid#,
				#now()#,
			</cfif>
			<cfif isdefined('attributes.valid3') and len(attributes.valid3)>
				#attributes.valid3#,
				#session.ep.userid#,
				#now()#,
			</cfif>
			<cfif isdefined('attributes.valid') and len(attributes.valid)>
				#attributes.valid#,
			</cfif>
			<cfif isdefined('attributes.valid4') and len(attributes.valid4)>
				#attributes.valid4#,
			</cfif>
			<cfif isdefined("attributes.is_show_employee") and len(attributes.is_show_employee)>1<cfelse>0</cfif>,
			<cfif isdefined('session.ep.userid')><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,<cfelse>NULL,</cfif>
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
			<cfif isdefined('attributes.control_value')><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.control_value#"><cfelse>NULL</cfif>
			<cfif isdefined('attributes.user_name') and len(attributes.user_name) and isdefined('attributes.user_id') and len(attributes.user_id)>
			,#attributes.user_id#
			</cfif>
		)
</cfquery>
<cfquery name="get_max_main_result_id" datasource="#dsn#">
	SELECT MAX(SURVEY_MAIN_RESULT_ID) AS MAX_RESULT_ID FROM SURVEY_MAIN_RESULT 
</cfquery><!--- en son doldurulan formun id sini verir, survey_questio_result tablosu survey_main_result id alanına atanır  --->
<cfquery name="get_related_questions_id" datasource="#dsn#">
	SELECT SURVEY_QUESTION_ID, QUESTION_TYPE,SURVEY_CHAPTER_ID FROM SURVEY_QUESTION WHERE SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#"> ORDER BY SURVEY_CHAPTER_ID
</cfquery>
<cfquery name="get_chapter" datasource="#dsn#">
	SELECT SURVEY_CHAPTER_WEIGHT,SURVEY_CHAPTER_ID,IS_SHOW_GD FROM SURVEY_CHAPTER WHERE SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#"> ORDER BY SURVEY_CHAPTER_ID
</cfquery>
<cfset toplam_agirlik = 0>
<!--- bolum aciklamalari tabloya yazdiriliyor--->
<cfloop query="get_chapter">
	<cfif isdefined("survey_chapter_detail2_#get_chapter.survey_chapter_id#") and len(evaluate("survey_chapter_detail2_#get_chapter.survey_chapter_id#"))>
		<cfquery name="add_chapter_result" datasource="#dsn#">
			INSERT INTO
				SURVEY_CHAPTER_RESULT
				(
					SURVEY_MAIN_RESULT_ID,
					SURVEY_CHAPTER_ID,
					EXPLANATION
					<cfif isdefined("attributes.emp_id") and session.ep.userid eq attributes.emp_id>
					,EMP_EXPL
					<cfelseif isdefined('attributes.manager_1_emp_id') and len(attributes.manager_1_emp_id) and isdefined('attributes.manager_1_pos_name') and len(attributes.manager_1_pos_name) and session.ep.userid eq attributes.manager_1_emp_id>
					,MANAGER3_EXPL
					<cfelseif isdefined('attributes.manager_3_emp_id') and len(attributes.manager_3_emp_id) and isdefined('attributes.manager_3_pos_name') and len(attributes.manager_3_pos_name) and session.ep.userid eq attributes.manager_3_emp_id>
					,MANAGER1_EXPL
					<cfelseif isdefined('attributes.manager_4_emp_id') and len(attributes.manager_4_emp_id) and session.ep.userid eq attributes.manager_4_emp_id>
					,MANAGER4_EXPL
					<cfelseif isdefined('attributes.manager_2_emp_id') and len(attributes.manager_2_emp_id) and isdefined('attributes.manager_2_pos_name') and len(attributes.manager_2_pos_name) and session.ep.userid eq attributes.manager_2_emp_id>					
					,MANAGER2_EXPL
					</cfif>
				)
			VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_main_result_id.MAX_RESULT_ID#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#get_chapter.survey_chapter_id#">,
					<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.survey_chapter_detail2_#get_chapter.survey_chapter_id#')#">
					<cfif isdefined("attributes.emp_id") or isdefined('attributes.manager_1_emp_id') or isdefined('attributes.manager_3_emp_id') or isdefined('attributes.manager_4_emp_id') or isdefined('attributes.manager_2_emp_id')>
						,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.survey_chapter_detail2_#get_chapter.survey_chapter_id#')#">
					</cfif>
				)
		</cfquery>
	</cfif>
	<cfif len(get_chapter.SURVEY_CHAPTER_WEIGHT)>
		<cfset toplam_agirlik = toplam_agirlik+get_chapter.SURVEY_CHAPTER_WEIGHT>
	</cfif>
</cfloop>

<!--- //bolum aciklamalari--->
<cfset all_total_point = 0>
<cfset secilen_sik_toplam_puani = 0>
<cfset gd_secili_soru_sayisi = 0>
<cfset sayac = 0>
<cfset max_point_survey = 0>
<cfset gecerli_agirlik = 0>
<cfoutput query="get_related_questions_id">
	<cfset sayac = sayac+1>
	<cfquery name="get_info" datasource="#dsn#">
		SELECT SURVEY_QUESTION_ID FROM SURVEY_OPTION WHERE SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_questions_id.survey_question_id#">
	</cfquery>
	<cfquery name="get_related_options_id" datasource="#dsn#">
		SELECT SURVEY_OPTION_ID,OPTION_POINT,SURVEY_QUESTION_ID FROM SURVEY_OPTION WHERE <cfif get_info.recordcount>SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_info.survey_question_id#"> AND</cfif> SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_questions_id.survey_chapter_id#">
	</cfquery>
	<cfset gd_option = 0>
	<cfif isdefined("attributes.user_answer_#get_related_questions_id.survey_question_id#") and Len(Evaluate("attributes.user_answer_#get_related_questions_id.survey_question_id#"))>
		<cfset answer_option_ = Evaluate("attributes.user_answer_#get_related_questions_id.survey_question_id#")>
		<cfif answer_option_ eq -1>
			<cfset gd_option = 1>
			<cfset gd_secili_soru_sayisi = gd_secili_soru_sayisi+1>
		</cfif>
		<cfset answer_option_ = Evaluate("attributes.user_answer_#get_related_questions_id.survey_question_id#")>
		<cfloop query="get_related_options_id">
			<cfif ListFind(answer_option_,survey_option_id)>
				<cfset secilen_sik_toplam_puani = secilen_sik_toplam_puani+get_related_options_id.option_point>
				<cfquery name="add_survey_questions" datasource="#dsn#"> 
					INSERT INTO 
						SURVEY_QUESTION_RESULT
						(	
							SURVEY_MAIN_ID,
							SURVEY_MAIN_RESULT_ID,
							SURVEY_QUESTION_ID,
							SURVEY_OPTION_ID,
							OPTION_POINT, 
							CHAPTER_DETAIL2, 
							COMPANY_ID,
							PARTNER_ID,  
							CONSUMER_ID,
							EMP_ID,  
							<!--- performans formunda bu alanlara kayıt atılıyor --->
							<cfif attributes.action_type eq 8><!--- sadece performans formunda gelecek---->
								GD_OPTION,
								<cfif (isdefined("attributes.emp_id") and session.ep.userid eq attributes.emp_id)>		
								SURVEY_OPTION_ID_EMP,
								SURVEY_OPTION_POINT_EMP,
								SURVEY_OPTION_GD_EMP,
								<cfelseif isdefined('attributes.manager_3_emp_id') and len(attributes.manager_3_emp_id) and isdefined('attributes.manager_3_pos_name') and len(attributes.manager_3_pos_name) and session.ep.userid eq attributes.manager_3_emp_id>								
								SURVEY_OPTION_ID_MANAGER3,
								SURVEY_OPTION_POINT_MANAGER3,
								SURVEY_OPTION_GD_MANAGER3,
								<cfelseif isdefined('attributes.manager_1_emp_id') and len(attributes.manager_1_emp_id) and isdefined('attributes.manager_1_pos_name') and len(attributes.manager_1_pos_name) and session.ep.userid eq attributes.manager_1_emp_id>
								SURVEY_OPTION_ID_MANAGER1,
								SURVEY_OPTION_POINT_MANAGER1,
								SURVEY_OPTION_GD_MANAGER1,
								<cfelseif isdefined('attributes.manager_4_emp_id') and len(attributes.manager_4_emp_id) and session.ep.userid eq attributes.manager_4_emp_id>
								SURVEY_OPTION_ID_MANAGER4,
								SURVEY_OPTION_POINT_MANAGER4,
								SURVEY_OPTION_GD_MANAGER4,
								<cfelseif isdefined('attributes.manager_2_emp_id') and len(attributes.manager_2_emp_id) and isdefined('attributes.manager_2_pos_name') and len(attributes.manager_2_pos_name) and session.ep.userid eq attributes.manager_2_emp_id>
								SURVEY_OPTION_ID_MANAGER2,
								SURVEY_OPTION_POINT_MANAGER2,
								SURVEY_OPTION_GD_MANAGER2,
								</cfif>
							</cfif>
							RECORD_DATE
						)
						VALUES
						(	
							<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_main_result_id.max_result_id#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_questions_id.survey_question_id#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#">,
							<cfif len(get_related_options_id.option_point)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.option_point#"><cfelse>NULL</cfif>, 
							<!--- <cfif isdefined("attributes.add_note_#get_related_questions_id.survey_question_id#") and Len(Evaluate("attributes.add_note_#get_related_questions_id.survey_question_id#"))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.add_note_#get_related_questions_id.survey_question_id#')#"><cfelse>NULL</cfif>, --->
							<cfif isdefined("attributes.survey_chapter_detail2_#get_related_questions_id.survey_question_id#") and Len(Evaluate("attributes.survey_chapter_detail2_#get_related_questions_id.survey_question_id#"))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.survey_chapter_detail2_#get_related_questions_id.survey_question_id#')#"><cfelse>NULL</cfif>,
							<cfif isdefined('attributes.company_id') and len(attributes.company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"><cfelse>NULL</cfif>,
							<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#"><cfelse>NULL</cfif>,  
							<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"><cfelse>NULL</cfif>,
							<cfif isdefined('attributes.employee_id') and len(attributes.employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"><cfelse>NULL</cfif>, 
							<cfif attributes.action_type eq 8><!--- sadece performans formunda gelecek---->							
								#gd_option#,
								<cfif (isdefined("attributes.emp_id") and session.ep.userid eq attributes.emp_id)>			
									<!---calisan --->
									<cfif ListFind(answer_option_,survey_option_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#"><cfelse>NULL</cfif>,	
									<cfif len(get_related_options_id.option_point) and ListFind(answer_option_,survey_option_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.option_point#"><cfelse>NULL</cfif>, 
									<cfif ListFind(answer_option_,survey_option_id)>#gd_option#<cfelse>NULL</cfif>,
								<cfelseif isdefined('attributes.manager_3_emp_id') and len(attributes.manager_3_emp_id) and isdefined('attributes.manager_3_pos_name') and len(attributes.manager_3_pos_name) and session.ep.userid eq attributes.manager_3_emp_id>
									<!--- gorus bildiren--->
									<cfif ListFind(answer_option_,survey_option_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#"><cfelse>NULL</cfif>,	
									<cfif len(get_related_options_id.option_point) and ListFind(answer_option_,survey_option_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.option_point#"><cfelse>NULL</cfif>, 
									<cfif ListFind(answer_option_,survey_option_id)>#gd_option#<cfelse>NULL</cfif>,
								<cfelseif isdefined('attributes.manager_1_emp_id') and len(attributes.manager_1_emp_id) and isdefined('attributes.manager_1_pos_name') and len(attributes.manager_1_pos_name) and session.ep.userid eq attributes.manager_1_emp_id>
									<!--- birinci amir--->
									<cfif ListFind(answer_option_,survey_option_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#"><cfelse>NULL</cfif>,	
									<cfif len(get_related_options_id.option_point) and ListFind(answer_option_,survey_option_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.option_point#"><cfelse>NULL</cfif>, 
									<cfif ListFind(answer_option_,survey_option_id)>#gd_option#<cfelse>NULL</cfif>,
									<!--- ikinci amir--->
								<cfelseif isdefined('attributes.manager_4_emp_id') and len(attributes.manager_4_emp_id) and session.ep.userid eq attributes.manager_4_emp_id>
									<!--- ortak degerlendirme--->
									<cfif ListFind(answer_option_,survey_option_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#"><cfelse>NULL</cfif>,	
									<cfif len(get_related_options_id.option_point) and ListFind(answer_option_,survey_option_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.option_point#"><cfelse>NULL</cfif>, 
									<cfif ListFind(answer_option_,survey_option_id)>#gd_option#<cfelse>NULL</cfif>,
								<cfelseif isdefined('attributes.manager_2_emp_id') and len(attributes.manager_2_emp_id) and isdefined('attributes.manager_2_pos_name') and len(attributes.manager_2_pos_name) and session.ep.userid eq attributes.manager_2_emp_id>
									<!--- ikinci amir--->
									<cfif ListFind(answer_option_,survey_option_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#"><cfelse>NULL</cfif>,	
									<cfif len(get_related_options_id.option_point) and ListFind(answer_option_,survey_option_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.option_point#"><cfelse>NULL</cfif>, 
									<cfif ListFind(answer_option_,survey_option_id)>#gd_option#<cfelse>NULL</cfif>,
								</cfif>
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						)
				</cfquery>
			<cfelse>
				<!--- hiç bir şık seçilmediğinde buraya giriyor performans formundaki GD alanını da burada atıyor--->
				<cfquery name="add_survey_questions" datasource="#dsn#"> 
					INSERT INTO 
						SURVEY_QUESTION_RESULT
						(	
							SURVEY_MAIN_ID,
							SURVEY_MAIN_RESULT_ID,
							SURVEY_QUESTION_ID,
							CHAPTER_DETAIL2, 
							COMPANY_ID,
							PARTNER_ID,  
							CONSUMER_ID,
							EMP_ID, 
							<cfif attributes.action_type eq 8><!--- sadece performans formunda gelecek---->
								GD_OPTION,
								<cfif (isdefined("attributes.emp_id") and session.ep.userid eq attributes.emp_id)>		
								SURVEY_OPTION_ID_EMP,
								SURVEY_OPTION_POINT_EMP,
								SURVEY_OPTION_GD_EMP,
								<cfelseif isdefined('attributes.manager_3_emp_id') and len(attributes.manager_3_emp_id) and isdefined('attributes.manager_3_pos_name') and len(attributes.manager_3_pos_name) and session.ep.userid eq attributes.manager_3_emp_id>								
								SURVEY_OPTION_ID_MANAGER3,
								SURVEY_OPTION_POINT_MANAGER3,
								SURVEY_OPTION_GD_MANAGER3,
								<cfelseif isdefined('attributes.manager_1_emp_id') and len(attributes.manager_1_emp_id) and isdefined('attributes.manager_1_pos_name') and len(attributes.manager_1_pos_name) and session.ep.userid eq attributes.manager_1_emp_id>
								SURVEY_OPTION_ID_MANAGER1,
								SURVEY_OPTION_POINT_MANAGER1,
								SURVEY_OPTION_GD_MANAGER1,
								<cfelseif isdefined('attributes.manager_4_emp_id') and len(attributes.manager_4_emp_id) and session.ep.userid eq attributes.manager_4_emp_id>
								SURVEY_OPTION_ID_MANAGER4,
								SURVEY_OPTION_POINT_MANAGER4,
								SURVEY_OPTION_GD_MANAGER4,
								<cfelseif isdefined('attributes.manager_2_emp_id') and len(attributes.manager_2_emp_id) and isdefined('attributes.manager_2_pos_name') and len(attributes.manager_2_pos_name) and session.ep.userid eq attributes.manager_2_emp_id>
								SURVEY_OPTION_ID_MANAGER2,
								SURVEY_OPTION_POINT_MANAGER2,
								SURVEY_OPTION_GD_MANAGER2,
								</cfif>
							</cfif>
							RECORD_DATE
						)
						VALUES
						(	
							<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_main_result_id.max_result_id#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_questions_id.survey_question_id#">,
							<cfif isdefined("attributes.survey_chapter_detail2_#get_related_questions_id.survey_question_id#") and Len(Evaluate("attributes.survey_chapter_detail2_#get_related_questions_id.survey_question_id#"))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.survey_chapter_detail2_#get_related_questions_id.survey_question_id#')#"><cfelse>NULL</cfif>,
							<cfif isdefined('attributes.company_id') and len(attributes.company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"><cfelse>NULL</cfif>,
							<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#"><cfelse>NULL</cfif>,  
							<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"><cfelse>NULL</cfif>,
							<cfif isdefined('attributes.employee_id') and len(attributes.employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"><cfelse>NULL</cfif>, 
							<cfif attributes.action_type eq 8><!--- sadece performans formunda gelecek---->
								#gd_option#,
								<cfif (isdefined("attributes.emp_id") and session.ep.userid eq attributes.emp_id)>			
									<!---calisan --->
									<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#">,	
									<cfif len(get_related_options_id.option_point)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.option_point#"><cfelse>NULL</cfif>, 
									<cfif ListFind(answer_option_,survey_option_id)>#gd_option#<cfelse>NULL</cfif>,
								<cfelseif isdefined('attributes.manager_3_emp_id') and len(attributes.manager_3_emp_id) and isdefined('attributes.manager_3_pos_name') and len(attributes.manager_3_pos_name) and session.ep.userid eq attributes.manager_3_emp_id>
									<!--- gorus bildiren--->
									<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#">,	
									<cfif len(get_related_options_id.option_point)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.option_point#"><cfelse>NULL</cfif>, 
									<cfif ListFind(answer_option_,survey_option_id)>#gd_option#<cfelse>NULL</cfif>,
								<cfelseif isdefined('attributes.manager_1_emp_id') and len(attributes.manager_1_emp_id) and isdefined('attributes.manager_1_pos_name') and len(attributes.manager_1_pos_name) and session.ep.userid eq attributes.manager_1_emp_id>
									<!--- birinci amir--->
									<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#">,	
									<cfif len(get_related_options_id.option_point)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.option_point#"><cfelse>NULL</cfif>, 
									<cfif ListFind(answer_option_,survey_option_id)>#gd_option#<cfelse>NULL</cfif>,
									<!--- ikinci amir--->
								<cfelseif isdefined('attributes.manager_4_emp_id') and len(attributes.manager_4_emp_id) and session.ep.userid eq attributes.manager_4_emp_id>
									<!--- ortak degerlendirme--->
									<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#">,	
									<cfif len(get_related_options_id.option_point)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.option_point#"><cfelse>NULL</cfif>, 
									<cfif ListFind(answer_option_,survey_option_id)>#gd_option#<cfelse>NULL</cfif>,
								<cfelseif isdefined('attributes.manager_2_emp_id') and len(attributes.manager_2_emp_id) and isdefined('attributes.manager_2_pos_name') and len(attributes.manager_2_pos_name) and session.ep.userid eq attributes.manager_2_emp_id>
									<!--- ikinci amir--->
									<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#">,	
									<cfif len(get_related_options_id.option_point)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.option_point#"><cfelse>NULL</cfif>, 
									<cfif ListFind(answer_option_,survey_option_id)>#gd_option#<cfelse>NULL</cfif>,
								</cfif>
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						)
					</cfquery>
				</cfif> 
		</cfloop>
		<cfelse>
		<cfloop query="get_related_options_id">
			<!---Açık uçlu ve skor tipi soruları kaydeder --->
			<cfif (isdefined("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#") and Len(Evaluate("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#")))> 
				<cfquery name="add_survey_questions" datasource="#dsn#"> 
					INSERT INTO 
						SURVEY_QUESTION_RESULT
						(	
							SURVEY_MAIN_ID,
							SURVEY_MAIN_RESULT_ID,
							SURVEY_QUESTION_ID,
							SURVEY_OPTION_ID,
							OPTION_POINT, 
							OPTION_HEAD,
							CHAPTER_DETAIL2,
							RESULT_NUMBER,  
							COMPANY_ID,
							PARTNER_ID,  
							CONSUMER_ID,
							EMP_ID,
							<!--- performans formu ise --->
							<cfif attributes.action_type eq 8>
								GD_OPTION,
								<cfif isdefined("attributes.emp_id") and session.ep.userid eq attributes.emp_id>
								SURVEY_OPTION_ID_EMP,
								SURVEY_OPTION_POINT_EMP,
								OPTION_HEAD_EMP,
								<cfelseif isdefined('attributes.manager_3_emp_id') and len(attributes.manager_3_emp_id) and isdefined('attributes.manager_3_pos_name') and len(attributes.manager_3_pos_name) and session.ep.userid eq attributes.manager_3_emp_id>
								SURVEY_OPTION_ID_MANAGER3,
								SURVEY_OPTION_POINT_MANAGER3,
								OPTION_HEAD_MANAGER3,
								<cfelseif isdefined('attributes.manager_1_emp_id') and len(attributes.manager_1_emp_id) and isdefined('attributes.manager_1_pos_name') and len(attributes.manager_1_pos_name) and session.ep.userid eq attributes.manager_1_emp_id>
								SURVEY_OPTION_ID_MANAGER1,
								SURVEY_OPTION_POINT_MANAGER1,
								OPTION_HEAD_MANAGER1,
								<cfelseif isdefined('attributes.manager_4_emp_id') and len(attributes.manager_4_emp_id) and session.ep.userid eq attributes.manager_4_emp_id>
								SURVEY_OPTION_ID_MANAGER4,
								SURVEY_OPTION_POINT_MANAGER4,
								OPTION_HEAD_MANAGER4,
								<cfelseif isdefined('attributes.manager_2_emp_id') and len(attributes.manager_2_emp_id) and isdefined('attributes.manager_2_pos_name') and len(attributes.manager_2_pos_name) and session.ep.userid eq attributes.manager_2_emp_id>
								SURVEY_OPTION_ID_MANAGER2,
								SURVEY_OPTION_POINT_MANAGER2,
								OPTION_HEAD_MANAGER2,
								</cfif>
							</cfif>
							RECORD_DATE
						)
						VALUES
						(	
							<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_main_result_id.max_result_id#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_questions_id.survey_question_id#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#">,
							<cfif isdefined("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#") and get_related_questions_id.question_type neq 3 and get_related_questions_id.question_type neq 5><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#')#"><cfelse>NULL</cfif>, 
							<cfif isdefined("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#") and Len(Evaluate("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#")) and get_related_questions_id.question_type neq 4><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#')#"><cfelse>NULL</cfif>,
							<!--- <cfif isdefined("attributes.add_note_#get_related_questions_id.survey_question_id#") and Len(Evaluate("attributes.add_note_#get_related_questions_id.survey_question_id#"))>'#Evaluate("attributes.add_note_#get_related_questions_id.survey_question_id#")#'<cfelse>NULL</cfif>, --->
							<cfif isdefined("attributes.survey_chapter_detail2_#get_related_questions_id.survey_question_id#") and Len(Evaluate("attributes.survey_chapter_detail2_#get_related_questions_id.survey_question_id#"))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.survey_chapter_detail2_#get_related_questions_id.survey_question_id#')#"><cfelse>NULL</cfif>,
							1,
							<cfif isdefined('attributes.company_id') and len(attributes.company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"><cfelse>NULL</cfif>,
							<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#"><cfelse>NULL</cfif>,  
							<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"><cfelse>NULL</cfif>,
							<cfif isdefined('attributes.employee_id') and len(attributes.employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"><cfelse>NULL</cfif>, 
							<cfif attributes.action_type eq 8>
								<cfif isdefined("attributes.gd_#get_related_questions_id.survey_question_id#")>#evaluate("attributes.gd_#get_related_questions_id.survey_question_id#")#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.emp_id") and session.ep.userid eq attributes.emp_id>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#">,
									<cfif isdefined("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#") and get_related_questions_id.question_type neq 3 and get_related_questions_id.question_type neq 5><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#')#"><cfelse>NULL</cfif>, 
									<cfif isdefined("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#") and Len(Evaluate("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#")) and get_related_questions_id.question_type neq 4><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#')#"><cfelse>NULL</cfif>,
								<cfelseif isdefined('attributes.manager_3_emp_id') and len(attributes.manager_3_emp_id) and isdefined('attributes.manager_3_pos_name') and len(attributes.manager_3_pos_name) and session.ep.userid eq attributes.manager_3_emp_id>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#">,
									<cfif isdefined("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#") and get_related_questions_id.question_type neq 3 and get_related_questions_id.question_type neq 5><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#')#"><cfelse>NULL</cfif>, 
									<cfif isdefined("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#") and Len(Evaluate("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#")) and get_related_questions_id.question_type neq 4><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#')#"><cfelse>NULL</cfif>,
								<cfelseif isdefined('attributes.manager_1_emp_id') and len(attributes.manager_1_emp_id) and isdefined('attributes.manager_1_pos_name') and len(attributes.manager_1_pos_name) and session.ep.userid eq attributes.manager_1_emp_id>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#">,
									<cfif isdefined("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#") and get_related_questions_id.question_type neq 3 and get_related_questions_id.question_type neq 5><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#')#"><cfelse>NULL</cfif>, 
									<cfif isdefined("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#") and Len(Evaluate("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#")) and get_related_questions_id.question_type neq 4><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#')#"><cfelse>NULL</cfif>,
								<cfelseif isdefined('attributes.manager_4_emp_id') and len(attributes.manager_4_emp_id) and session.ep.userid eq attributes.manager_4_emp_id>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#">,
									<cfif isdefined("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#") and get_related_questions_id.question_type neq 3 and get_related_questions_id.question_type neq 5><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#')#"><cfelse>NULL</cfif>, 
									<cfif isdefined("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#") and Len(Evaluate("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#")) and get_related_questions_id.question_type neq 4><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#')#"><cfelse>NULL</cfif>,
								<cfelseif isdefined('attributes.manager_2_emp_id') and len(attributes.manager_2_emp_id) and isdefined('attributes.manager_2_pos_name') and len(attributes.manager_2_pos_name) and session.ep.userid eq attributes.manager_2_emp_id>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#">,
									<cfif isdefined("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#") and get_related_questions_id.question_type neq 3 and get_related_questions_id.question_type neq 5><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#')#"><cfelse>NULL</cfif>, 
									<cfif isdefined("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#") and Len(Evaluate("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#")) and get_related_questions_id.question_type neq 4><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#')#"><cfelse>NULL</cfif>,
								</cfif>
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						)
				</cfquery>
			<cfelse>
				<cfquery name="add_survey_questions" datasource="#dsn#"> 
					INSERT INTO 
						SURVEY_QUESTION_RESULT
						(	
							SURVEY_MAIN_ID,
							SURVEY_MAIN_RESULT_ID,
							SURVEY_QUESTION_ID,
							CHAPTER_DETAIL2,
							COMPANY_ID,
							PARTNER_ID,  
							CONSUMER_ID,
							EMP_ID,  
							RECORD_DATE
						)
						VALUES
						(	
							<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_main_result_id.max_result_id#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_questions_id.survey_question_id#">,
							<cfif isdefined("attributes.survey_chapter_detail2_#get_related_questions_id.survey_question_id#") and Len(Evaluate("attributes.survey_chapter_detail2_#get_related_questions_id.survey_question_id#"))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.survey_chapter_detail2_#get_related_questions_id.survey_question_id#')#"><cfelse>NULL</cfif>,
							<cfif isdefined('attributes.company_id') and len(attributes.company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"><cfelse>NULL</cfif>,
							<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#"><cfelse>NULL</cfif>,  
							<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"><cfelse>NULL</cfif>,
							<cfif isdefined('attributes.employee_id') and len(attributes.employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"><cfelse>NULL</cfif>, 
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					)
				</cfquery>
			</cfif>
		</cfloop> 
	</cfif>
	<cfif get_related_questions_id.survey_chapter_id neq get_related_questions_id.survey_chapter_id[currentrow+1]> 
		<cfquery name="get_chapter_weight" dbtype="query">
			SELECT SURVEY_CHAPTER_WEIGHT,IS_SHOW_GD FROM get_chapter WHERE SURVEY_CHAPTER_ID = #get_related_questions_id.survey_chapter_id#
		</cfquery>
		<cfquery name="get_survey_option_max" datasource="#dsn#">
			SELECT MAX(OPTION_POINT) AS MAX_OPTION_POINT FROM SURVEY_OPTION WHERE SURVEY_CHAPTER_ID = #get_related_questions_id.SURVEY_CHAPTER_ID#
		</cfquery>
		<cfif get_survey_option_max.recordcount and get_survey_option_max.MAX_OPTION_POINT gt 0>
			<cfset max_point_survey = get_survey_option_max.MAX_OPTION_POINT>
		</cfif>
		<cfif len(get_chapter_weight.SURVEY_CHAPTER_WEIGHT) and sayac gt 0 and (max_point_survey*sayac) gt 0>
			<cfif gd_secili_soru_sayisi neq sayac>
				<cfif gd_secili_soru_sayisi gt 0>
					<cfset all_total_point = all_total_point+(secilen_sik_toplam_puani*get_chapter_weight.SURVEY_CHAPTER_WEIGHT)/((sayac-gd_secili_soru_sayisi)*max_point_survey)>
				<cfelse>
					<cfset all_total_point = all_total_point+((secilen_sik_toplam_puani*get_chapter_weight.SURVEY_CHAPTER_WEIGHT)/(sayac*max_point_survey))>
				</cfif>
				<cfset gecerli_agirlik = gecerli_agirlik+get_chapter_weight.SURVEY_CHAPTER_WEIGHT>
			</cfif>
		</cfif>	
		<cfset secilen_sik_toplam_puani = 0>
		<cfset gd_secili_soru_sayisi = 0>
		<cfset sayac =0>
	</cfif>	
</cfoutput>
<cfquery name="duplicate_last_record" datasource="#dsn#">
	INSERT INTO 
		SURVEY_QUESTION_RESULT_HISTORY
		(	
			SURVEY_MAIN_RESULT_ID,
			SURVEY_QUESTION_ID,
			SURVEY_OPTION_ID,
			OPTION_POINT, 
			CHAPTER_DETAIL2,
			OPTION_HEAD,  
			COMPANY_ID,
			PARTNER_ID,  
			CONSUMER_ID,
			EMP_ID,
			<cfif attributes.action_type eq 8><!--- sadece performans formunda gelecek---->
				GD_OPTION, 
				SURVEY_OPTION_ID_EMP,
				SURVEY_OPTION_POINT_EMP,
				OPTION_HEAD_EMP,
				SURVEY_OPTION_ID_MANAGER1,
				SURVEY_OPTION_POINT_MANAGER1,
				OPTION_HEAD_MANAGER1,
				SURVEY_OPTION_ID_MANAGER2,
				SURVEY_OPTION_POINT_MANAGER2,
				OPTION_HEAD_MANAGER2,
				SURVEY_OPTION_ID_MANAGER3,
				SURVEY_OPTION_POINT_MANAGER3,
				OPTION_HEAD_MANAGER3,
				SURVEY_OPTION_ID_MANAGER4,
				SURVEY_OPTION_POINT_MANAGER4,
				OPTION_HEAD_MANAGER4,
			</cfif>
			RECORD_DATE
		)
		SELECT 
			SURVEY_MAIN_RESULT_ID,
			SURVEY_QUESTION_ID,
			SURVEY_OPTION_ID,
			OPTION_POINT, 
			CHAPTER_DETAIL2, 
			OPTION_HEAD, 
			COMPANY_ID,
			PARTNER_ID,  
			CONSUMER_ID,
			EMP_ID,
			<cfif attributes.action_type eq 8><!--- sadece performans formunda gelecek---->			
				GD_OPTION,  
				SURVEY_OPTION_ID_EMP,
				SURVEY_OPTION_POINT_EMP,
				OPTION_HEAD_EMP,
				SURVEY_OPTION_ID_MANAGER1,
				SURVEY_OPTION_POINT_MANAGER1,
				OPTION_HEAD_MANAGER1,
				SURVEY_OPTION_ID_MANAGER2,
				SURVEY_OPTION_POINT_MANAGER2,
				OPTION_HEAD_MANAGER2,
				SURVEY_OPTION_ID_MANAGER3,
				SURVEY_OPTION_POINT_MANAGER3,
				OPTION_HEAD_MANAGER3,
				SURVEY_OPTION_ID_MANAGER4,
				SURVEY_OPTION_POINT_MANAGER4,
				OPTION_HEAD_MANAGER4,
			</cfif>
			#now()#
		FROM
			SURVEY_QUESTION_RESULT
		WHERE 
			SURVEY_MAIN_RESULT_ID = #get_max_main_result_id.MAX_RESULT_ID#
</cfquery>
<cfquery name="get_survey_main" datasource="#dsn#">
	SELECT TOTAL_SCORE FROM SURVEY_MAIN WHERE SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
</cfquery>
<cfif gecerli_agirlik gt 0>
	<cfset all_total_point = (toplam_agirlik*all_total_point)/gecerli_agirlik>
</cfif>
<!--- hesaplanan toplam puanı result tablosuna yazılıyor--->
<cfquery name="upd_survey_main_result" datasource="#dsn#">
	UPDATE
		SURVEY_MAIN_RESULT
	SET
		SCORE_RESULT = #all_total_point#
		<cfif isdefined("attributes.emp_id") and session.ep.userid eq attributes.emp_id><!--- Çalışan--->
		,SCORE_RESULT_EMP = #all_total_point#
		<cfelseif isdefined('attributes.manager_3_emp_id') and len(attributes.manager_3_emp_id) and isdefined('attributes.manager_3_pos_name') and len(attributes.manager_3_pos_name) and session.ep.userid eq attributes.manager_3_emp_id><!---Görüş bildiren --->
		,SCORE_RESULT_MANAGER3 = #all_total_point#
		<cfelseif isdefined('attributes.manager_1_emp_id') and len(attributes.manager_1_emp_id) and isdefined('attributes.manager_1_pos_name') and len(attributes.manager_1_pos_name) and session.ep.userid eq attributes.manager_1_emp_id><!---1.amir --->
		,SCORE_RESULT_MANAGER1 = #all_total_point#
		<cfelseif isdefined('attributes.manager_4_emp_id') and len(attributes.manager_4_emp_id) and session.ep.userid eq attributes.manager_4_emp_id><!---ortak değerlendirme --->
		,SCORE_RESULT_MANAGER4 = #all_total_point#
		<cfelseif isdefined('attributes.manager_2_emp_id') and len(attributes.manager_2_emp_id) and isdefined('attributes.manager_2_pos_name') and len(attributes.manager_2_pos_name) and session.ep.userid eq attributes.manager_2_emp_id><!---2.amir --->
		,SCORE_RESULT_MANAGER2 = #all_total_point#
		</cfif>
	WHERE
		SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_main_result_id.max_result_id#">
</cfquery>
<!--- main action file --->
<cfif isdefined('attributes.process_stage') and len(attributes.process_stage) and isdefined("session.ep.userid")>
<cf_workcube_process 
	is_upd='1' 
	data_source='#dsn#' 
	old_process_line='0'
	process_stage='#attributes.process_stage#'
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_table='SURVEY_MAIN_RESULT'
	action_column='SURVEY_MAIN_RESULT_ID'
	action_id='#get_max_main_result_id.max_result_id#'
	action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#..popup_form_upd_detailed_survey_main_result&survey_id=#attributes.survey_id#' 
	warning_description='İş-Değerlendirme Formu'>
</cfif>
</cftransaction>
</cflock>
<!--- //main action file --->
<cfif not isdefined("session.ep.userid")>
	<script type="text/javascript">
		window.close();
	</script>
<cfelse>
	<cfif isdefined('attributes.is_popup') and attributes.is_popup eq 1>
		<script type="text/javascript">
			wrk_opener_reload();
			window.close();
		</script>
	<cfelseif isdefined('attributes.is_popup') and attributes.is_popup eq 2>
		<script type="text/javascript">
			alert('Kaydedildi');
			history.back();
		</script>
	<cfelse>
		<cfif fuseaction contains 'objects'>
			<cfset fuseact = 'popup_form_upd_detailed_survey_main_result'>
		<cfelse>
			<cfset fuseact = 'form_upd_detailed_survey_main_result'>
		</cfif>
		<cflocation addtoken="no" url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.#fuseact#&survey_id=#attributes.survey_id#&result_id=#get_max_main_result_id.max_result_id#&action_type_id=#action_type_id#">
	</cfif>
</cfif>
