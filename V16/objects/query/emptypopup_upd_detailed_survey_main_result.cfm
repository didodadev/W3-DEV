<cflock name="#createUUID()#" timeout="60">			
<cftransaction>
<cfquery name="upd_survey_main_result" datasource="#dsn#">
	UPDATE 
		SURVEY_MAIN_RESULT
	SET	
		ACTION_TYPE = <cfif len(attributes.action_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type#"><cfelse>NULL</cfif>, 
		ACTION_ID = <cfif len(attributes.action_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type_id#"><cfelse>NULL</cfif>, 
		PROCESS_ROW_ID = <cfif isdefined("attributes.process_stage") and len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
		COMPANY_ID = <cfif isdefined("attributes.company_id") and  len(attributes.company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"><cfelse>NULL</cfif>,
		PARTNER_ID = <cfif isdefined("attributes.partner_id") and len(attributes.partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#"><cfelse>NULL</cfif>,
		CONSUMER_ID = <cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"><cfelse>NULL</cfif>,
		EMP_ID = <cfif isdefined("attributes.employee_order") and len(attributes.employee_order)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_order_id#"><cfelse>NULL</cfif>,
		START_DATE = <cfif isdefined("attributes.start_date") and len(attributes.start_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateformat(attributes.start_date,dateformat_style)#"><cfelse>NULL</cfif>,
		FINISH_DATE = <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateformat(attributes.finish_date,dateformat_style)#"><cfelse>NULL</cfif>,
		SCORE_RESULT = <cfif isdefined('attributes.total_point') and len(attributes.total_point)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.total_point#"><cfelse>0</cfif>,
		RESULT_NOTE = <cfif isdefined('attributes.notes') and len(attributes.notes)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.notes#"><cfelse>NULL</cfif>,
		COMMENT = <cfif isdefined('attributes.comment') and len(attributes.comment)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.comment#"><cfelse>NULL</cfif>,
		MANAGER1_EMP_ID = <cfif isdefined('attributes.manager_1_emp_id') and len(attributes.manager_1_emp_id) and isdefined('attributes.manager_1_pos_name') and len(attributes.manager_1_pos_name)>#attributes.manager_1_emp_id#<cfelse>NULL</cfif>,
		MANAGER1_POS = <cfif isdefined('attributes.manager_1_pos') and len(attributes.manager_1_pos) and isdefined('attributes.manager_1_pos_name') and len(attributes.manager_1_pos_name)>#attributes.manager_1_pos#<cfelse>NULL</cfif>,
		MANAGER2_EMP_ID = <cfif isdefined('attributes.manager_2_emp_id') and len(attributes.manager_2_emp_id) and isdefined('attributes.manager_2_pos_name') and len(attributes.manager_2_pos_name)>#attributes.manager_2_emp_id#<cfelse>NULL</cfif>,
		MANAGER2_POS = <cfif isdefined('attributes.manager_2_pos') and len(attributes.manager_2_pos) and isdefined('attributes.manager_2_pos_name') and len(attributes.manager_2_pos_name)>#attributes.manager_2_pos#<cfelse>NULL</cfif>,
		MANAGER3_EMP_ID = <cfif isdefined('attributes.manager_3_emp_id') and len(attributes.manager_3_emp_id) and isdefined('attributes.manager_3_pos_name') and len(attributes.manager_3_pos_name)>#attributes.manager_3_emp_id#<cfelse>NULL</cfif>,
		MANAGER3_POS = <cfif isdefined('attributes.manager_3_pos') and len(attributes.manager_3_pos) and isdefined('attributes.manager_3_pos_name') and len(attributes.manager_3_pos_name)>#attributes.manager_3_pos#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.valid1') and len(attributes.valid1)>
			VALID1 = #attributes.valid1#,
			VALID1_EMP = #session.ep.userid#,
			VALID1_DATE = #now()#,
		</cfif>
		<cfif isdefined('attributes.valid2') and len(attributes.valid2)>
			VALID2 = #attributes.valid2#,
			VALID2_EMP = #session.ep.userid#,
			VALID2_DATE = #now()#,
		</cfif>
		<cfif isdefined('attributes.valid3') and len(attributes.valid3)>
			VALID3 = #attributes.valid3#,
			VALID3_EMP = #session.ep.userid#,
			VALID3_DATE = #now()#,
		</cfif>
		<cfif isdefined('attributes.valid') and len(attributes.valid)>VALID = #attributes.valid#,</cfif>
		<cfif isdefined('attributes.valid4') and len(attributes.valid4)>VALID4 = #attributes.valid4#,</cfif>
		<cfif isdefined('attributes.user_name') and len(attributes.user_name) and isdefined('attributes.user_id') and len(attributes.user_id)>
			<cfif attributes.user_type eq 'employee'>
				CLASS_ATTENDER_EMP_ID = #attributes.user_id#,
			<cfelseif attributes.user_type eq 'partner'>
				CLASS_ATTENDER_PAR_ID = #attributes.user_id#,
			<cfelseif attributes.user_type eq 'consumer'>
				CLASS_ATTENDER_CONS_ID = #attributes.user_id#,
			</cfif>
		</cfif>
		IS_SHOW_EMPLOYEE = <cfif isdefined("attributes.is_show_employee") and len(attributes.is_show_employee)>1<cfelse>0</cfif>,
		UPDATE_EMP = <cfif isdefined('session.ep.userid')><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,<cfelse>NULL,</cfif> 
		UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">
	WHERE 
		SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">
</cfquery>  
<cfquery name="get_related_questions_id" datasource="#dsn#">
	SELECT SURVEY_QUESTION_ID,QUESTION_TYPE,SURVEY_CHAPTER_ID,IS_SHOW_GD FROM SURVEY_QUESTION WHERE SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
</cfquery>
<cfquery name="get_chapter" datasource="#dsn#">
	SELECT SURVEY_CHAPTER_WEIGHT,SURVEY_CHAPTER_ID,IS_SHOW_GD FROM SURVEY_CHAPTER WHERE SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#"> ORDER BY SURVEY_CHAPTER_ID
</cfquery>
<cfset toplam_agirlik = 0>
<!--- bölüm açıklamaları güncelleniyor--->
<cfloop query="get_chapter">
	<cfif isdefined("survey_chapter_detail2_#get_chapter.survey_chapter_id#") and len(evaluate("survey_chapter_detail2_#get_chapter.survey_chapter_id#"))>
		<cfquery name="get_control" datasource="#dsn#">
			SELECT CHAPTER_RESULT_ID FROM SURVEY_CHAPTER_RESULT WHERE SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#"> AND SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_chapter.survey_chapter_id#">
		</cfquery>
		<cfif get_control.recordcount>
			<cfquery name="upd_chapter_result" datasource="#dsn#">
				UPDATE
					SURVEY_CHAPTER_RESULT
				SET
					EXPLANATION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.survey_chapter_detail2_#get_chapter.survey_chapter_id#')#">
					<cfif isdefined("attributes.emp_id") and session.ep.userid eq attributes.emp_id><!--- Çalışan--->
					,EMP_EXPL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.survey_chapter_detail2_#get_chapter.survey_chapter_id#')#">
					<cfelseif isdefined('attributes.manager_3_emp_id') and len(attributes.manager_3_emp_id) and isdefined('attributes.manager_3_pos_name') and len(attributes.manager_3_pos_name) and session.ep.userid eq attributes.manager_3_emp_id><!---Görüş bildiren --->
					,MANAGER3_EXPL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.survey_chapter_detail2_#get_chapter.survey_chapter_id#')#">
					<cfelseif isdefined('attributes.amir_onay') and attributes.amir_onay neq 1 and isdefined('attributes.manager_1_emp_id') and len(attributes.manager_1_emp_id) and isdefined('attributes.manager_1_pos_name') and len(attributes.manager_1_pos_name) and session.ep.userid eq attributes.manager_1_emp_id><!---1.amir --->
					,MANAGER1_EXPL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.survey_chapter_detail2_#get_chapter.survey_chapter_id#')#">
					<cfelseif isdefined('attributes.amir_onay') and attributes.amir_onay eq 1 and isdefined('attributes.manager_4_emp_id') and len(attributes.manager_4_emp_id) and session.ep.userid eq attributes.manager_4_emp_id><!---ortak değerlendirme --->
					,MANAGER4_EXPL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.survey_chapter_detail2_#get_chapter.survey_chapter_id#')#">
					<cfelseif isdefined('attributes.manager_2_emp_id') and len(attributes.manager_2_emp_id) and isdefined('attributes.manager_2_pos_name') and len(attributes.manager_2_pos_name) and session.ep.userid eq attributes.manager_2_emp_id><!---2.amir --->
					,MANAGER2_EXPL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.survey_chapter_detail2_#get_chapter.survey_chapter_id#')#">
					</cfif>
				WHERE
					SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#"> AND
					SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_chapter.survey_chapter_id#"> 
			</cfquery>
		<cfelse>
			<cfquery name="add_chapter_result" datasource="#dsn#">
				INSERT INTO
					SURVEY_CHAPTER_RESULT
					(
						SURVEY_CHAPTER_ID,
						SURVEY_MAIN_RESULT_ID,
						EXPLANATION
						<cfif isdefined("attributes.emp_id") and session.ep.userid eq attributes.emp_id><!--- Çalışan--->
							,EMP_EXPL
						<cfelseif isdefined('attributes.manager_3_emp_id') and len(attributes.manager_3_emp_id) and isdefined('attributes.manager_3_pos_name') and len(attributes.manager_3_pos_name) and session.ep.userid eq attributes.manager_3_emp_id><!---Görüş bildiren --->
							,MANAGER3_EXPL
						<cfelseif isdefined('attributes.amir_onay') and attributes.amir_onay neq 1 and isdefined('attributes.manager_1_emp_id') and len(attributes.manager_1_emp_id) and isdefined('attributes.manager_1_pos_name') and len(attributes.manager_1_pos_name) and session.ep.userid eq attributes.manager_1_emp_id><!---1.amir --->
							,MANAGER1_EXPL
						<cfelseif isdefined('attributes.amir_onay') and attributes.amir_onay eq 1 and isdefined('attributes.manager_4_emp_id') and len(attributes.manager_4_emp_id) and session.ep.userid eq attributes.manager_4_emp_id><!---ortak değerlendirme --->
							,MANAGER4_EXPL
						<cfelseif isdefined('attributes.manager_2_emp_id') and len(attributes.manager_2_emp_id) and isdefined('attributes.manager_2_pos_name') and len(attributes.manager_2_pos_name) and session.ep.userid eq attributes.manager_2_emp_id><!---2.amir --->
							,MANAGER2_EXPL
						</cfif>
					)
				VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#get_chapter.survey_chapter_id#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">,
						<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.survey_chapter_detail2_#get_chapter.survey_chapter_id#')#">
						<cfif isdefined("attributes.emp_id") or isdefined('attributes.manager_3_emp_id') or isdefined('attributes.manager_4_emp_id') or isdefined('attributes.manager_2_emp_id')>
						,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.survey_chapter_detail2_#get_chapter.survey_chapter_id#')#">
						</cfif>
					)
			</cfquery>
		</cfif>
	</cfif>
	<cfif len(get_chapter.SURVEY_CHAPTER_WEIGHT)>
		<cfset toplam_agirlik = toplam_agirlik+get_chapter.SURVEY_CHAPTER_WEIGHT>
	</cfif>
</cfloop>
<cfset all_total_point = 0><!--- genel toplam--->
<cfset secilen_sik_toplam_puani = 0>
<cfset gd_secili_soru_sayisi = 0>
<cfset sayac = 0>
<cfset max_point_survey = 0>
<cfset gecerli_agirlik = 0>
<!--- performans formunda amirler dışında bir kullanıcı formu güncellerse şık ve değerlendirme alanında herhangi bir değişiklik yapılamaması için kontrol eklendi SG20121107--->
<cfif (attributes.action_type eq 8 and ((isdefined("attributes.emp_id") and session.ep.userid eq attributes.emp_id) or (isdefined("attributes.manager_3_emp_id") and session.ep.userid eq attributes.manager_3_emp_id) or (isdefined("attributes.manager_1_emp_id") and session.ep.userid eq attributes.manager_1_emp_id) or (isdefined("attributes.manager_4_emp_id") and session.ep.userid eq attributes.manager_4_emp_id) or (isdefined("attributes.manager_2_emp_id") and session.ep.userid eq attributes.manager_2_emp_id)) or attributes.action_type neq 8)>
	<cfquery name="del_related_result_info" datasource="#DSN#">
		DELETE FROM SURVEY_QUESTION_RESULT WHERE SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">
	</cfquery>
	<cfoutput query="get_related_questions_id">
		<cfset sayac = sayac+1>
		<cfquery name="get_info" datasource="#dsn#">
			SELECT SURVEY_QUESTION_ID FROM SURVEY_OPTION WHERE SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_questions_id.survey_question_id#">
		</cfquery>
		<cfquery name="get_related_options_id" datasource="#dsn#">
			SELECT SURVEY_OPTION_ID,OPTION_POINT,SURVEY_QUESTION_ID FROM SURVEY_OPTION WHERE <cfif get_info.recordcount>SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_info.survey_question_id#"> AND</cfif> SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_questions_id.survey_chapter_id#">
		</cfquery>
		<cfset gd_option = 0>
			<cfif (isdefined("attributes.user_answer_#get_related_questions_id.survey_question_id#") and Len(Evaluate("attributes.user_answer_#get_related_questions_id.survey_question_id#")))><!--- Tekli ve coklu sorulari kaydeder --->
			<cfset answer_option_ = Evaluate("attributes.user_answer_#get_related_questions_id.survey_question_id#")>
			<cfif answer_option_ eq -1>
				<cfset gd_option = 1>
				<cfset gd_secili_soru_sayisi = gd_secili_soru_sayisi+1>
			</cfif>
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
								<!--- OPTION_NOTE, --->  
								CHAPTER_DETAIL2,
								COMPANY_ID,
								PARTNER_ID,  
								CONSUMER_ID,
								EMP_ID, 
								<!--- performans formunda bu alanlara kayıt atılıyor --->
								<cfif attributes.action_type eq 8>
									GD_OPTION, 
									SURVEY_OPTION_ID_EMP,
									SURVEY_OPTION_POINT_EMP,
									SURVEY_OPTION_GD_EMP,
									SURVEY_OPTION_ID_MANAGER3,
									SURVEY_OPTION_POINT_MANAGER3,
									SURVEY_OPTION_GD_MANAGER3,
									SURVEY_OPTION_ID_MANAGER1,
									SURVEY_OPTION_POINT_MANAGER1,
									SURVEY_OPTION_GD_MANAGER1,
									SURVEY_OPTION_ID_MANAGER4,
									SURVEY_OPTION_POINT_MANAGER4,
									SURVEY_OPTION_GD_MANAGER4,
									SURVEY_OPTION_ID_MANAGER2,
									SURVEY_OPTION_POINT_MANAGER2,
									SURVEY_OPTION_GD_MANAGER2,
								</cfif>
								RECORD_DATE
							)
							VALUES
							(	
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_questions_id.survey_question_id#">,
								<cfif len(get_related_options_id.survey_option_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#"></cfif>,
								<cfif len(get_related_options_id.option_point)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.option_point#"><cfelse>NULL</cfif>, 
								<!--- <cfif isdefined("attributes.add_note_#get_related_questions_id.survey_question_id#") and Len(Evaluate("attributes.add_note_#get_related_questions_id.survey_question_id#"))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.add_note_#get_related_questions_id.survey_question_id#')#"><cfelse>NULL</cfif>, --->
								<cfif isdefined("attributes.survey_chapter_detail2_#get_related_questions_id.survey_chapter_id#") and Len(Evaluate("attributes.survey_chapter_detail2_#get_related_questions_id.survey_chapter_id#"))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.survey_chapter_detail2_#get_related_questions_id.survey_chapter_id#')#"><cfelse>NULL</cfif>,
								<cfif isdefined("attributes.company_id") and len(attributes.company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"><cfelse>NULL</cfif>,
								<cfif isdefined("attributes.partner_id") and len(attributes.partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#"><cfelse>NULL</cfif>,  
								<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"><cfelse>NULL</cfif>,
								<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"><cfelse>NULL</cfif>, 
								<cfif attributes.action_type eq 8>
									#gd_option#,
									<cfif (isdefined("attributes.emp_id") and session.ep.userid eq attributes.emp_id)>			
										<!---calisan --->
										<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#">,	
										<cfif len(get_related_options_id.option_point)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.option_point#"><cfelse>NULL</cfif>, 
										#gd_option#,
										<!--- gorus bildiren--->
										<cfif isdefined("survey_option_id_manager3_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager3_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager3_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager3_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager3_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager3_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager3_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager3_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager3_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<!--- birinci amir--->
										<cfif isdefined("survey_option_id_manager1_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager1_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager1_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager1_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager1_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager1_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager1_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager1_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager1_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<!--- ortak degerlendirme--->
										<cfif isdefined("survey_option_id_manager4_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager4_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager4_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager4_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager4_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager4_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager4_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager4_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager4_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<!--- ikinci amir--->
										<cfif isdefined("survey_option_id_manager2_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager2_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager2_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager2_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager2_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager2_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager2_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager2_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager2_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
									<cfelseif isdefined('attributes.manager_3_emp_id') and len(attributes.manager_3_emp_id) and isdefined('attributes.manager_3_pos_name') and len(attributes.manager_3_pos_name) and session.ep.userid eq attributes.manager_3_emp_id>
										<!---calisan --->
										<cfif isdefined('survey_option_id_emp_#get_related_questions_id.survey_question_id#') and len(Evaluate("survey_option_id_emp_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_emp_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined('survey_option_point_emp_#get_related_questions_id.survey_question_id#') and len(Evaluate("survey_option_point_emp_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_emp_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined('survey_option_gd_emp_#get_related_questions_id.survey_question_id#') and len(Evaluate("survey_option_gd_emp_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_emp_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<!--- gorus bildiren--->
										<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#">,	
										<cfif len(get_related_options_id.option_point)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.option_point#"><cfelse>NULL</cfif>, 
										#gd_option#,
										<!--- birinci amir--->
										<cfif isdefined("survey_option_id_manager1_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager1_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager1_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager1_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager1_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager1_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager1_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager1_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager1_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<!--- ortak degerlendirme--->
										<cfif isdefined("survey_option_id_manager4_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager4_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager4_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager4_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager4_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager4_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager4_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager4_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager4_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<!--- ikinci amir--->
										<cfif isdefined("survey_option_id_manager2_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager2_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager2_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager2_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager2_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager2_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager2_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager2_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager2_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
									<cfelseif isdefined("amir_onay") and amir_onay neq 1 and isdefined('attributes.manager_1_emp_id') and len(attributes.manager_1_emp_id) and isdefined('attributes.manager_1_pos_name') and len(attributes.manager_1_pos_name) and session.ep.userid eq attributes.manager_1_emp_id>
										<!---calisan --->
										<cfif isdefined("survey_option_id_emp_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_emp_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_emp_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_emp_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_emp_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_emp_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_emp_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_emp_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_emp_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<!--- gorus bildiren--->
										<cfif isdefined("survey_option_id_manager3_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager3_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager3_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager3_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager3_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager3_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager3_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager3_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager3_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<!--- birinci amir--->
										<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#">,	
										<cfif len(get_related_options_id.option_point)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.option_point#"><cfelse>NULL</cfif>, 
										#gd_option#,
										<!--- ortak degerlendirme--->
										<cfif isdefined("survey_option_id_manager4_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager4_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager4_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager4_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager4_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager4_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager4_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager4_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager4_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<!--- ikinci amir--->
										<cfif isdefined("survey_option_id_manager2_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager2_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager2_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager2_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager2_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager2_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager2_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager2_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager2_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
									<cfelseif isdefined("amir_onay") and amir_onay eq 1 and isdefined('attributes.manager_4_emp_id') and len(attributes.manager_4_emp_id) and session.ep.userid eq attributes.manager_4_emp_id>
										<!---calisan --->
										<cfif isdefined("survey_option_id_emp_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_emp_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_emp_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_emp_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_emp_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_emp_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_emp_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_emp_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_emp_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<!--- gorus bildiren--->
										<cfif isdefined("survey_option_id_manager3_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager3_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager3_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager3_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager3_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager3_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager3_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager3_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager3_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<!--- birinci amir--->
										<cfif isdefined("survey_option_id_manager1_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager1_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager1_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager1_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager1_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager1_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager1_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager1_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager1_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<!--- ortak degerlendirme--->
										<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#">,	
										<cfif len(get_related_options_id.option_point)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.option_point#"><cfelse>NULL</cfif>, 
										#gd_option#,
										<!--- ikinci amir--->
										<cfif isdefined("survey_option_id_manager2_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager2_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager2_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager2_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager2_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager2_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager2_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager2_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager2_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
									<cfelseif isdefined('attributes.manager_2_emp_id') and len(attributes.manager_2_emp_id) and isdefined('attributes.manager_2_pos_name') and len(attributes.manager_2_pos_name) and session.ep.userid eq attributes.manager_2_emp_id>
										<!---calisan --->
										<cfif isdefined("survey_option_id_emp_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_emp_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_emp_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_emp_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_emp_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_emp_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_emp_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_emp_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_emp_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<!--- gorus bildiren--->
										<cfif isdefined("survey_option_id_manager3_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager3_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager3_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager3_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager3_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager3_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager3_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager3_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager3_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<!--- birinci amir--->
										<cfif isdefined("survey_option_id_manager1_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager1_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager1_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager1_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager1_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager1_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager1_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager1_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager1_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<!--- ortak degerlendirme--->
										<cfif isdefined("survey_option_id_manager4_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager4_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager4_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager4_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager4_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager4_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager4_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager4_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager4_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<!--- ikinci amir--->
										<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#">,	
										<cfif len(get_related_options_id.option_point)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.option_point#"><cfelse>NULL</cfif>, 
										#gd_option#,
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
								<cfif attributes.action_type eq 8>
									GD_OPTION,
									SURVEY_OPTION_ID_EMP,
									SURVEY_OPTION_POINT_EMP,
									SURVEY_OPTION_GD_EMP,
									SURVEY_OPTION_ID_MANAGER3,
									SURVEY_OPTION_POINT_MANAGER3,
									SURVEY_OPTION_GD_MANAGER3,
									SURVEY_OPTION_ID_MANAGER1,
									SURVEY_OPTION_POINT_MANAGER1,
									SURVEY_OPTION_GD_MANAGER1,
									SURVEY_OPTION_ID_MANAGER4,
									SURVEY_OPTION_POINT_MANAGER4,
									SURVEY_OPTION_GD_MANAGER4,
									SURVEY_OPTION_ID_MANAGER2,
									SURVEY_OPTION_POINT_MANAGER2,
									SURVEY_OPTION_GD_MANAGER2,
								</cfif>
								RECORD_DATE
							)
							VALUES
							(	
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_questions_id.survey_question_id#">,
								<cfif isdefined("attributes.survey_chapter_detail2_#get_related_questions_id.survey_chapter_id#") and Len(Evaluate("attributes.survey_chapter_detail2_#get_related_questions_id.survey_chapter_id#"))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.survey_chapter_detail2_#get_related_questions_id.survey_chapter_id#')#"><cfelse>NULL</cfif>,
								<cfif isdefined("attributes.company_id") and len(attributes.company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"><cfelse>NULL</cfif>,
								<cfif isdefined("attributes.partner_id") and len(attributes.partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#"><cfelse>NULL</cfif>,  
								<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"><cfelse>NULL</cfif>,
								<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"><cfelse>NULL</cfif>, 
								<cfif attributes.action_type eq 8>
									<cfif gd_option eq 1>1<cfelse>NULL</cfif>,
									<cfif isdefined("attributes.emp_id") and session.ep.userid eq attributes.emp_id>			
										<cfif isdefined("survey_option_id_emp_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_emp_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_emp_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_emp_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_emp_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_emp_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif gd_option eq 1>1<cfelse>NULL</cfif>,
										<!--- gorus bildiren--->
										<cfif isdefined("survey_option_id_manager3_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager3_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager3_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager3_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager3_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager3_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager3_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager4_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager4_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<!--- 1.amir--->
										<cfif isdefined("survey_option_id_manager1_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager1_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager1_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager1_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager1_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager1_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager1_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager1_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager1_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<!--- ortak degerlendirme--->
										<cfif isdefined("survey_option_id_manager4_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager4_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager4_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager4_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager4_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager4_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager4_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager4_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager4_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<!--- 2.amir--->
										<cfif isdefined("survey_option_id_manager2_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager2_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager2_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager2_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager2_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager2_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager2_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager2_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager2_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
									<cfelseif isdefined('attributes.manager_3_emp_id') and len(attributes.manager_3_emp_id) and isdefined('attributes.manager_3_pos_name') and len(attributes.manager_3_pos_name) and session.ep.userid eq attributes.manager_3_emp_id>
										<cfif isdefined("survey_option_id_emp_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_emp_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_emp_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_emp_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_emp_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_emp_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_emp_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_emp_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_emp_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_id_manager3_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager3_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager3_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager3_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager3_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager3_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif gd_option eq 1>1<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_id_manager1_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager1_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager1_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager1_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager1_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager1_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager1_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager1_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager1_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_id_manager4_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager4_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager4_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager4_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager4_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager4_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager4_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager4_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager4_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_id_manager2_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager2_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager2_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager2_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager2_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager2_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager2_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager2_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager2_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
									<cfelseif isdefined("amir_onay") and amir_onay neq 1 and isdefined('attributes.manager_1_emp_id') and len(attributes.manager_1_emp_id) and isdefined('attributes.manager_1_pos_name') and len(attributes.manager_1_pos_name) and session.ep.userid eq attributes.manager_1_emp_id>
										<cfif isdefined("survey_option_id_emp_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_emp_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_emp_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_emp_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_emp_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_emp_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_emp_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_emp_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_emp_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_id_manager3_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager3_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager3_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager3_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager3_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager3_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager3_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager3_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager3_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_id_manager1_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager1_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager1_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager1_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager1_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager1_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif gd_option eq 1>1<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_id_manager4_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager4_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager4_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager4_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager4_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager4_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager4_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager4_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager4_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_id_manager2_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager2_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager2_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager2_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager2_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager2_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager2_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager2_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager2_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
									<cfelseif isdefined("amir_onay") and amir_onay eq 1 and isdefined('attributes.manager_4_emp_id') and len(attributes.manager_4_emp_id) and session.ep.userid eq attributes.manager_4_emp_id>
										<cfif isdefined("survey_option_id_emp_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_emp_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_emp_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_emp_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_emp_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_emp_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_emp_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_emp_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_emp_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_id_manager3_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager3_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager3_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager3_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager3_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager3_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager3_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager3_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager3_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_id_manager1_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager1_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager1_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager1_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager1_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager1_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager1_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager1_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager1_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_id_manager4_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager4_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager4_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager4_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager4_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager4_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif gd_option eq 1>1<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_id_manager2_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager2_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager2_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager2_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager2_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager2_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager2_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager2_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager2_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
									<cfelseif isdefined('attributes.manager_2_emp_id') and len(attributes.manager_2_emp_id) and isdefined('attributes.manager_2_pos_name') and len(attributes.manager_2_pos_name) and session.ep.userid eq attributes.manager_2_emp_id>
										<cfif isdefined("survey_option_id_emp_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_emp_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_emp_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_emp_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_emp_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_emp_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_emp_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_emp_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_emp_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_id_manager3_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager3_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager3_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager3_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager3_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager3_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager3_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager3_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager3_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_id_manager1_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager1_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager1_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager1_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager1_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager1_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager1_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager1_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager1_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_id_manager4_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager4_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager4_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager4_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager4_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager4_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_gd_manager4_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_gd_manager4_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_gd_manager4_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_id_manager2_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_id_manager2_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_id_manager2_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif isdefined("survey_option_point_manager2_#get_related_questions_id.survey_question_id#") and len(Evaluate("survey_option_point_manager2_#get_related_questions_id.survey_question_id#"))>#Evaluate('survey_option_point_manager2_#get_related_questions_id.survey_question_id#')#<cfelse>NULL</cfif>,
										<cfif gd_option eq 1>1<cfelse>NULL</cfif>,
									</cfif>
								</cfif>
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
							)
					</cfquery>
					</cfif>
				</cfloop> 
			<cfelse>
			<cfloop query="get_related_options_id">
				<!---Acık uclu ve skor tipi sorulari kaydeder --->
				<cfif (isdefined("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#") and Len(Evaluate("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#"))) or isdefined("attributes.gd_#get_related_questions_id.survey_question_id#")  or isdefined("attributes.gd_#get_related_questions_id.survey_question_id#") or (isdefined("attributes.user_answer_ex_#get_related_questions_id.survey_question_id#_#survey_option_id#") and Len(Evaluate("attributes.user_answer_ex_#get_related_questions_id.survey_question_id#_#survey_option_id#")))> 
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
								COMPANY_ID,
								PARTNER_ID,  
								CONSUMER_ID,
								EMP_ID,  
								<!--- performans formu ise --->
								<cfif attributes.action_type eq 8>
									OPTION_HEAD_EMP,
									OPTION_HEAD_MANAGER3,
									OPTION_HEAD_MANAGER1,
									OPTION_HEAD_MANAGER4,
									OPTION_HEAD_MANAGER2,
									GD_OPTION,
									<cfif isdefined("attributes.emp_id") and session.ep.userid eq attributes.emp_id>
									SURVEY_OPTION_ID_EMP,
									SURVEY_OPTION_POINT_EMP,
									<cfelseif isdefined("valid3") and valid3 neq 1 and isdefined('attributes.manager_3_emp_id') and len(attributes.manager_3_emp_id) and isdefined('attributes.manager_3_pos_name') and len(attributes.manager_3_pos_name) and session.ep.userid eq attributes.manager_3_emp_id>
									SURVEY_OPTION_ID_MANAGER3,
									SURVEY_OPTION_POINT_MANAGER3,
									<cfelseif isdefined("amir_onay") and amir_onay neq 1 and isdefined('attributes.manager_1_emp_id') and len(attributes.manager_1_emp_id) and isdefined('attributes.manager_1_pos_name') and len(attributes.manager_1_pos_name) and session.ep.userid eq attributes.manager_1_emp_id>
									SURVEY_OPTION_ID_MANAGER1,
									SURVEY_OPTION_POINT_MANAGER1,
									<cfelseif isdefined("amir_onay") and amir_onay eq 1 and isdefined('attributes.manager_4_emp_id') and len(attributes.manager_4_emp_id) and session.ep.userid eq attributes.manager_4_emp_id>
									SURVEY_OPTION_ID_MANAGER4,
									SURVEY_OPTION_POINT_MANAGER4,
									<cfelseif isdefined('attributes.manager_2_emp_id') and len(attributes.manager_2_emp_id) and isdefined('attributes.manager_2_pos_name') and len(attributes.manager_2_pos_name) and session.ep.userid eq attributes.manager_2_emp_id>
									SURVEY_OPTION_ID_MANAGER2,
									SURVEY_OPTION_POINT_MANAGER2,
									</cfif>
								</cfif>
								RECORD_DATE
							)
							VALUES
							(	
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_questions_id.survey_question_id#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#">,
								<cfif isdefined("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#") and get_related_questions_id.question_type neq 3 and get_related_questions_id.question_type neq 5><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#')#"><cfelse>NULL</cfif>, 
								<cfif ((attributes.action_type eq 8 and isdefined("attributes.emp_id") and session.ep.userid eq attributes.emp_id) or attributes.action_type neq 8) and isdefined("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#") and Len(Evaluate("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#")) and get_related_questions_id.question_type neq 4>
									<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#')#">
								<cfelseif isdefined("attributes.user_answer_ex_#get_related_questions_id.survey_question_id#_#survey_option_id#") and Len(Evaluate("attributes.user_answer_ex_#get_related_questions_id.survey_question_id#_#survey_option_id#")) and get_related_questions_id.question_type neq 4>
									<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.user_answer_ex_#get_related_questions_id.survey_question_id#_#survey_option_id#')#">
								<cfelse>
									NULL
								</cfif>,
								<cfif isdefined("attributes.survey_chapter_detail2_#get_related_questions_id.survey_chapter_id#") and Len(Evaluate("attributes.survey_chapter_detail2_#get_related_questions_id.survey_chapter_id#"))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.survey_chapter_detail2_#get_related_questions_id.survey_chapter_id#')#"><cfelse>NULL</cfif>,
								<cfif isdefined("attributes.company_id") and len(attributes.company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"><cfelse>NULL</cfif>,
								<cfif isdefined("attributes.partner_id") and len(attributes.partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#"><cfelse>NULL</cfif>,  
								<cfif isdefined("attributes.consumer_id") and  len(attributes.consumer_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"><cfelse>NULL</cfif>,
								<cfif isdefined("attributes.employee_id") and  len(attributes.employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"><cfelse>NULL</cfif>, 
								<cfif attributes.action_type eq 8>
									<cfif (isdefined("attributes.emp_id") and session.ep.userid eq attributes.emp_id) and isdefined("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#") and Len(Evaluate("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#")) and get_related_questions_id.question_type neq 4>
										<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#')#">
									<cfelseif isdefined("attributes.user_answer_ex_emp_#get_related_questions_id.survey_question_id#_#survey_option_id#") and Len(Evaluate("attributes.user_answer_ex_emp_#get_related_questions_id.survey_question_id#_#survey_option_id#")) and get_related_questions_id.question_type neq 4>
										<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.user_answer_ex_emp_#get_related_questions_id.survey_question_id#_#survey_option_id#')#">
									<cfelse>
										NULL
									</cfif>,
									<cfif (isdefined("valid3") and valid3 neq 1 and isdefined('attributes.manager_3_emp_id') and len(attributes.manager_3_emp_id) and isdefined('attributes.manager_3_pos_name') and len(attributes.manager_3_pos_name) and session.ep.userid eq attributes.manager_3_emp_id) and isdefined("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#") and Len(Evaluate("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#")) and get_related_questions_id.question_type neq 4>
										<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#')#">
									<cfelseif isdefined("attributes.user_answer_ex3_#get_related_questions_id.survey_question_id#_#survey_option_id#") and Len(Evaluate("attributes.user_answer_ex3_#get_related_questions_id.survey_question_id#_#survey_option_id#")) and get_related_questions_id.question_type neq 4>
										<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.user_answer_ex3_#get_related_questions_id.survey_question_id#_#survey_option_id#')#">
									<cfelse>
										NULL
									</cfif>,
									<cfif (isdefined("amir_onay") and amir_onay neq 1 and isdefined('attributes.manager_1_emp_id') and len(attributes.manager_1_emp_id) and isdefined('attributes.manager_1_pos_name') and len(attributes.manager_1_pos_name) and session.ep.userid eq attributes.manager_1_emp_id) and isdefined("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#") and Len(Evaluate("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#")) and get_related_questions_id.question_type neq 4>
										<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#')#">
									<cfelseif isdefined("attributes.user_answer_ex1_#get_related_questions_id.survey_question_id#_#survey_option_id#") and Len(Evaluate("attributes.user_answer_ex1_#get_related_questions_id.survey_question_id#_#survey_option_id#")) and get_related_questions_id.question_type neq 4>
										<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.user_answer_ex1_#get_related_questions_id.survey_question_id#_#survey_option_id#')#">
									<cfelse>
										NULL
									</cfif>,
									<cfif (isdefined("amir_onay") and amir_onay eq 1 and isdefined('attributes.manager_4_emp_id') and len(attributes.manager_4_emp_id) and session.ep.userid eq attributes.manager_4_emp_id) and isdefined("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#") and Len(Evaluate("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#")) and get_related_questions_id.question_type neq 4>
										<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#')#">
									<cfelseif isdefined("attributes.user_answer_ex4_#get_related_questions_id.survey_question_id#_#survey_option_id#") and Len(Evaluate("attributes.user_answer_ex4_#get_related_questions_id.survey_question_id#_#survey_option_id#")) and get_related_questions_id.question_type neq 4>
										<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.user_answer_ex4_#get_related_questions_id.survey_question_id#_#survey_option_id#')#">
									<cfelse>
										NULL
									</cfif>,
									<cfif (isdefined('attributes.manager_2_emp_id') and len(attributes.manager_2_emp_id) and isdefined('attributes.manager_2_pos_name') and len(attributes.manager_2_pos_name) and session.ep.userid eq attributes.manager_2_emp_id) and isdefined("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#") and Len(Evaluate("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#")) and get_related_questions_id.question_type neq 4>
										<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#')#">
									<cfelseif isdefined("attributes.user_answer_ex2_#get_related_questions_id.survey_question_id#_#survey_option_id#") and Len(Evaluate("attributes.user_answer_ex2_#get_related_questions_id.survey_question_id#_#survey_option_id#")) and get_related_questions_id.question_type neq 4>
										<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.user_answer_ex2_#get_related_questions_id.survey_question_id#_#survey_option_id#')#">
									<cfelse>
										NULL
									</cfif>,
									<cfif isdefined("attributes.gd_#get_related_questions_id.survey_question_id#")>#evaluate("attributes.gd_#get_related_questions_id.survey_question_id#")#<cfelse>NULL</cfif>,
									<cfif isdefined("attributes.emp_id") and session.ep.userid eq attributes.emp_id>
										<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#">,
										<cfif isdefined("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#") and get_related_questions_id.question_type neq 3 and get_related_questions_id.question_type neq 5><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#')#"><cfelse>NULL</cfif>, 
									<cfelseif isdefined("valid3") and valid3 neq 1 and isdefined('attributes.manager_3_emp_id') and len(attributes.manager_3_emp_id) and isdefined('attributes.manager_3_pos_name') and len(attributes.manager_3_pos_name) and session.ep.userid eq attributes.manager_3_emp_id>
										<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#">,
										<cfif isdefined("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#") and get_related_questions_id.question_type neq 3 and get_related_questions_id.question_type neq 5><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#')#"><cfelse>NULL</cfif>, 
									<cfelseif isdefined("amir_onay") and  amir_onay neq 1 and isdefined('attributes.manager_1_emp_id') and len(attributes.manager_1_emp_id) and isdefined('attributes.manager_1_pos_name') and len(attributes.manager_1_pos_name) and session.ep.userid eq attributes.manager_1_emp_id>
										<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#">,
										<cfif isdefined("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#") and get_related_questions_id.question_type neq 3 and get_related_questions_id.question_type neq 5><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#')#"><cfelse>NULL</cfif>, 
									<cfelseif isdefined("amir_onay") and  amir_onay eq 1 and isdefined('attributes.manager_4_emp_id') and len(attributes.manager_4_emp_id) and session.ep.userid eq attributes.manager_4_emp_id>
										<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#">,
										<cfif isdefined("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#") and get_related_questions_id.question_type neq 3 and get_related_questions_id.question_type neq 5><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#')#"><cfelse>NULL</cfif>, 
									<cfelseif isdefined('attributes.manager_2_emp_id') and len(attributes.manager_2_emp_id) and isdefined('attributes.manager_2_pos_name') and len(attributes.manager_2_pos_name) and session.ep.userid eq attributes.manager_2_emp_id>
										<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_options_id.survey_option_id#">,
										<cfif isdefined("attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#") and get_related_questions_id.question_type neq 3 and get_related_questions_id.question_type neq 5><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.user_answer_#get_related_questions_id.survey_question_id#_#survey_option_id#')#"><cfelse>NULL</cfif>, 
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
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_questions_id.survey_question_id#">,
								<cfif isdefined("attributes.survey_chapter_detail2_#get_related_questions_id.survey_chapter_id#") and Len(Evaluate("attributes.survey_chapter_detail2_#get_related_questions_id.survey_chapter_id#"))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#Evaluate('attributes.survey_chapter_detail2_#get_related_questions_id.survey_chapter_id#')#"><cfelse>NULL</cfif>,
								<cfif isdefined("attributes.company_id") and len(attributes.company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"><cfelse>NULL</cfif>,
								<cfif isdefined("attributes.partner_id") and len(attributes.partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#"><cfelse>NULL</cfif>,  
								<cfif isdefined("attributes.consumer_id") and  len(attributes.consumer_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"><cfelse>NULL</cfif>,
								<cfif isdefined("attributes.employee_id") and  len(attributes.employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"><cfelse>NULL</cfif>, 
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
			<!---<cfif len(get_chapter_weight.SURVEY_CHAPTER_WEIGHT)>
				<cfset toplam_agirlik = toplam_agirlik+get_chapter_weight.SURVEY_CHAPTER_WEIGHT>
			</cfif>--->
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
				<cfif attributes.action_type eq 8>
					GD_OPTION, 
					SURVEY_OPTION_ID_EMP,
					SURVEY_OPTION_POINT_EMP,
					SURVEY_OPTION_GD_EMP,
					OPTION_HEAD_EMP,
					SURVEY_OPTION_ID_MANAGER1,
					SURVEY_OPTION_POINT_MANAGER1,
					SURVEY_OPTION_GD_MANAGER1,
					OPTION_HEAD_MANAGER1,
					SURVEY_OPTION_ID_MANAGER2,
					SURVEY_OPTION_POINT_MANAGER2,
					SURVEY_OPTION_GD_MANAGER2,
					OPTION_HEAD_MANAGER2,
					SURVEY_OPTION_ID_MANAGER3,
					SURVEY_OPTION_POINT_MANAGER3,
					SURVEY_OPTION_GD_MANAGER3,
					OPTION_HEAD_MANAGER3,
					SURVEY_OPTION_ID_MANAGER4,
					SURVEY_OPTION_POINT_MANAGER4,
					SURVEY_OPTION_GD_MANAGER4,
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
				<cfif attributes.action_type eq 8>
					GD_OPTION,			  
					SURVEY_OPTION_ID_EMP,
					SURVEY_OPTION_POINT_EMP,
					SURVEY_OPTION_GD_EMP,
					OPTION_HEAD_EMP,
					SURVEY_OPTION_ID_MANAGER1,
					SURVEY_OPTION_POINT_MANAGER1,
					SURVEY_OPTION_GD_MANAGER1,
					OPTION_HEAD_MANAGER1,
					SURVEY_OPTION_ID_MANAGER2,
					SURVEY_OPTION_POINT_MANAGER2,
					SURVEY_OPTION_GD_MANAGER2,
					OPTION_HEAD_MANAGER2,
					SURVEY_OPTION_ID_MANAGER3,
					SURVEY_OPTION_POINT_MANAGER3,
					SURVEY_OPTION_GD_MANAGER3,	
					OPTION_HEAD_MANAGER3,	
					SURVEY_OPTION_ID_MANAGER4,
					SURVEY_OPTION_POINT_MANAGER4,
					SURVEY_OPTION_GD_MANAGER4,
					OPTION_HEAD_MANAGER4,
				</cfif>
				#now()#
			FROM
				SURVEY_QUESTION_RESULT
			WHERE 
				SURVEY_MAIN_RESULT_ID = #attributes.result_id#
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
			<cfelseif isdefined("valid3") and valid3 neq 1 and isdefined('attributes.manager_3_emp_id') and len(attributes.manager_3_emp_id) and isdefined('attributes.manager_3_pos_name') and len(attributes.manager_3_pos_name) and session.ep.userid eq attributes.manager_3_emp_id><!---Görüş bildiren --->
			,SCORE_RESULT_MANAGER3 = #all_total_point#
			<cfelseif isdefined('attributes.amir_onay') and attributes.amir_onay neq 1 and isdefined('attributes.manager_1_emp_id') and len(attributes.manager_1_emp_id) and isdefined('attributes.manager_1_pos_name') and len(attributes.manager_1_pos_name) and session.ep.userid eq attributes.manager_1_emp_id><!---1.amir --->
			,SCORE_RESULT_MANAGER1 = #all_total_point#
			<cfelseif isdefined('attributes.amir_onay') and attributes.amir_onay eq 1 and isdefined('attributes.manager_4_emp_id') and len(attributes.manager_4_emp_id) and session.ep.userid eq attributes.manager_4_emp_id><!---ortak değerlendirme --->
			,SCORE_RESULT_MANAGER4 = #all_total_point#
			<cfelseif isdefined('attributes.manager_2_emp_id') and len(attributes.manager_2_emp_id) and isdefined('attributes.manager_2_pos_name') and len(attributes.manager_2_pos_name) and session.ep.userid eq attributes.manager_2_emp_id><!---2.amir --->
			,SCORE_RESULT_MANAGER2 = #all_total_point#
			</cfif>
		WHERE
			SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">
	</cfquery>
</cfif>
<!--- main action file --->
<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>
<cf_workcube_process 
	is_upd='1' 
	data_source='#dsn#' 
	old_process_line='0'
	process_stage='#attributes.process_stage#'
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_table='SURVEY_MAIN_RESULT'
	action_column='SURVEY_MAIN_RESULT_ID'
	action_id='#attributes.result_id#'
	action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_form_upd_detailed_survey_main_result&survey_id=#attributes.survey_id#&result_id=#attributes.result_id#' 
	warning_description='İş-Değerlendirme Formu'>
</cfif>
</cftransaction>
</cflock>
<cfif (isdefined('attributes.is_popup') and attributes.is_popup eq 1)> 
<script type="text/javascript">
    <cfif not isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');</cfif>
</script>
<cfelse>
	<cfif fuseaction contains 'objects'>
		<cfset fuseact = 'popup_form_upd_detailed_survey_main_result'>
	<cfelse>
		<cfset fuseact = 'form_upd_detailed_survey_main_result'>
	</cfif>
	<cflocation addtoken="no" url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.#fuseact#&survey_id=#attributes.survey_id#&result_id=#attributes.result_id#"> 
</cfif>