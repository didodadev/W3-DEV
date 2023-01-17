<cfif len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
<cfif len(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>
<cfquery name="UPD_QUIZ" datasource="#dsn#">
	UPDATE
		EMPLOYEE_QUIZ
	SET
	<cfif isDefined("POSITION_CAT_ID")>
		POSITION_CAT_ID = ',#POSITION_CAT_ID#,', 
	<cfelse>
		POSITION_CAT_ID = NULL, 
	</cfif>
	<cfif isDefined("POSITION_ID")>
		POSITION_ID = ',#POSITION_ID#,',  
	<cfelse>
		POSITION_ID = NULL,  
	</cfif>
	<cfif isDefined("QUIZ_OBJECTIVE")>
		QUIZ_OBJECTIVE = '#Trim(QUIZ_OBJECTIVE)#',  
	<cfelse>
		QUIZ_OBJECTIVE = NULL,  
	</cfif>
		QUIZ_HEAD = '#QUIZ_HEAD#', 
		COMMETHOD_ID = #COMMETHOD_ID#,
		EMP_QUIZ_WEIGHT = <cfif len(attributes.emp_quiz_weight)>#attributes.emp_quiz_weight#<cfelse>NULL</cfif>,
		MANAGER_QUIZ_WEIGHT_1 = <cfif len(attributes.manager_quiz_weight_1)>#attributes.manager_quiz_weight_1#<cfelse>NULL</cfif>,
		MANAGER_QUIZ_WEIGHT_2 = <cfif len(attributes.manager_quiz_weight_2)>#attributes.manager_quiz_weight_2#<cfelse>NULL</cfif>,
		MANAGER_QUIZ_WEIGHT_3 = <cfif len(attributes.manager_quiz_weight_3)>#attributes.manager_quiz_weight_3#<cfelse>NULL</cfif>,
		MANAGER_QUIZ_WEIGHT_4 = <cfif len(attributes.manager_quiz_weight_4)>#attributes.manager_quiz_weight_4#<cfelse>NULL</cfif>,
		IS_ALL_EMPLOYEE = <cfif IsDefined("attributes.IS_ALL_EMPLOYEE")>1<cfelse>0</cfif>,
		IS_MAIL_CONTROL = <cfif IsDefined("attributes.is_mail_control")>1<cfelse>0</cfif>,
		IS_ACTIVE = <cfif IsDefined("attributes.IS_ACTIVE")>1<cfelse>0</cfif>,
		IS_EDUCATION = <cfif attributes.IS_TYPE IS 'IS_EDUCATION'>1<cfelse>0</cfif>,
		IS_TRAINER = <cfif attributes.IS_TYPE IS 'IS_TRAINER'>1<cfelse>0</cfif>,
		IS_INTERVIEW = <cfif attributes.IS_TYPE IS 'IS_INTERVIEW'>1<cfelse>0</cfif>,
		IS_INTERVIEW_IN = <cfif attributes.IS_TYPE IS 'IS_INTERVIEW_IN'>1<cfelse>0</cfif>,
		IS_TEST_TIME = <cfif attributes.IS_TYPE IS 'IS_TEST_TIME'>1<cfelse>0</cfif>,
		FORM_OPEN_TYPE = <cfif isDefined("form_open_type_id")>#form_open_type_id#<cfelse>NULL</cfif>,
		IS_EXTRA_RECORD = <cfif IsDefined("attributes.IS_EXTRA_RECORD")>1<cfelse>0</cfif>,
		IS_EXTRA_RECORD_EMP = <cfif IsDefined("attributes.IS_EXTRA_RECORD_EMP")>1<cfelse>0</cfif>,
		IS_RECORD_TYPE = <cfif IsDefined("attributes.IS_RECORD_TYPE")>1<cfelse>0</cfif>,
		IS_VIEW_QUESTION = <cfif IsDefined("attributes.IS_VIEW_QUESTION")>1<cfelse>0</cfif>,
		IS_EXTRA_QUIZ = <cfif IsDefined("attributes.IS_EXTRA_QUIZ")>1<cfelse>0</cfif>,
		IS_MANAGER_0 = <cfif IsDefined("attributes.IS_MANAGER_0")>1<cfelse>0</cfif>,
		IS_MANAGER_1 = <cfif IsDefined("attributes.IS_MANAGER_1")>1<cfelse>0</cfif>,
		IS_MANAGER_2 = <cfif IsDefined("attributes.IS_MANAGER_2")>1<cfelse>0</cfif>,
		IS_MANAGER_3 = <cfif IsDefined("attributes.IS_MANAGER_3")>1<cfelse>0</cfif>,
		IS_MANAGER_4 = <cfif IsDefined("attributes.IS_MANAGER_4")>1<cfelse>0</cfif>,
		IS_CAREER = <cfif IsDefined("attributes.IS_CAREER")>1<cfelse>0</cfif>,
		IS_TRAINING = <cfif IsDefined("attributes.IS_TRAINING")>1<cfelse>0</cfif>,
		IS_OPINION = <cfif IsDefined("attributes.IS_OPINION")>1<cfelse>0</cfif>,
		IS_SHOW = <cfif isDefined("attributes.IS_SHOW")>1<cfelse>0</cfif>,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #SESSION.EP.USERID#, 
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		START_DATE = <cfif len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
		FINISH_DATE = <cfif len(attributes.finish_date)>#attributes.finish_date#<cfelse>NULL</cfif>
	WHERE
		QUIZ_ID = #attributes.QUIZ_ID#
</cfquery>
<cf_relation_segment
	is_upd='1' 
	is_form='0'
	field_id='#attributes.QUIZ_ID#'
	table_name='EMPLOYEE_QUIZ'
	action_table_name='RELATION_SEGMENT_QUIZ'
	select_list='3'>
<cfif isDefined("attributes.process_stage") and Len(attributes.process_stage)>
	<cf_workcube_process
		is_upd='1' 
		data_source='#dsn#' 
		old_process_line='0'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#' 
		action_table='EMPLOYEE_QUIZ'
		action_column='QUIZ_ID'
		action_id='#attributes.QUIZ_ID#'
		action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_form_upd_quiz&quiz_id=#attributes.QUIZ_ID#' 
		warning_description='Form : #attributes.QUIZ_ID#'>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
