<cfif LEN(attributes.INSPECTION_DATE)>
	<cf_date tarih='attributes.INSPECTION_DATE'>
</cfif>
<cfif LEN(attributes.REST_START_DATE)>
	<cf_date tarih='attributes.REST_START_DATE'>
	<cfset attributes.REST_START_DATE = date_add("h", start_clock-session.ep.time_zone, attributes.REST_START_DATE)>
	<cfset attributes.REST_START_DATE = date_add("n", start_minute, attributes.REST_START_DATE)>
</cfif>
<cfif LEN(attributes.NEXT_INSPECTION_DATE)>
	<cf_date tarih='attributes.NEXT_INSPECTION_DATE'>
</cfif>
<cfquery name="get_old" datasource="#dsn#">
	SELECT HEALTY_NO FROM EMPLOYEE_HEALTY WHERE HEALTY_NO = '#attributes.employee_healty_no#'
</cfquery>
<cfif get_old.recordcount>
	<script type="text/javascript">
		alert('Girdiğiniz Belge Numarası Kullanılmaktadır!');
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="add_doctor_info" datasource="#DSN#">
INSERT INTO
		EMPLOYEE_HEALTY_REPORT
	(
		EMPLOYEE_ID,
		RECORD_DATE,
		RECORD_IP,
		RECORD_EMP
	)
	VALUES
	(
		#attributes.EMPLOYEE_ID#,
		#NOW()#,
		'#CGI.REMOTE_USER#',
		#SESSION.EP.USERID#
	)
</cfquery>

<cfquery name="add_heal" datasource="#DSN#" result="MAX_ID">
	INSERT INTO
		EMPLOYEE_HEALTY
	(
		EMPLOYEE_ID,
		RELATIVE_ID,
		HEALTH_COMPLAINT,
		COMPLAINT2,
		COMPLAINT,
		PROCESS_TYPE,
		INSPECTION_RESULT,
		INSPECTION_DATE,
		DECISION_MEDICINE,
		DECISION_MEDICINE2,
		CONCLUSION,
		DELIVERY_PLACE,
		REST_DAY,
		REST_HOUR,
		REST_START_DATE,
		NEXT_INSPECTION_DATE,
		HEALTY_DETAIL,
		HEALTY_NO,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP,
		HEALTY_STAGE,
		DOCTOR_EMP_ID,
		DOCTOR_COMP_ID
	)
	VALUES
	(
		#attributes.EMPLOYEE_ID#,
		<cfif LEN(attributes.RELATIVE_ID)>#attributes.RELATIVE_ID#<cfelse>NULL</cfif>,
		<cfif LEN(attributes.HEALTH_COMPLAINT)>'#attributes.HEALTH_COMPLAINT#',<cfelse>NULL,</cfif>
		<cfif isdefined("attributes.COMPLAINT2") and LEN(attributes.COMPLAINT2)>'#attributes.COMPLAINT2#',<cfelse>NULL,</cfif>
		<cfif isdefined("attributes.COMPLAINT") and LEN(attributes.COMPLAINT)>'#attributes.COMPLAINT#',<cfelse>NULL,</cfif>
		<cfif isdefined("attributes.inspection_type") and LEN(attributes.inspection_type)>#attributes.inspection_type#,<cfelse>NULL,</cfif>
		<cfif LEN(attributes.INSPECTION_RESULT)>'#attributes.INSPECTION_RESULT#',<cfelse>NULL,</cfif>
		<cfif LEN(attributes.INSPECTION_DATE)>#attributes.INSPECTION_DATE#,<cfelse>NULL,</cfif>
		<cfif isdefined("attributes.DECISIONMECIDINE") and LEN(attributes.DECISIONMECIDINE)>'#attributes.DECISIONMECIDINE#',<cfelse>NULL,</cfif>
		<cfif isdefined("attributes.DECISIONMECIDINE2") and LEN(attributes.DECISIONMECIDINE2)>'#attributes.DECISIONMECIDINE2#',<cfelse>NULL,</cfif>
		<cfif LEN(attributes.CONCLUSION)>#attributes.CONCLUSION#,<cfelse>NULL,</cfif>
		<cfif LEN(attributes.DELIVERY_PLACE)>'#attributes.DELIVERY_PLACE#',<cfelse>NULL,</cfif>
		<cfif LEN(attributes.REST_DAY)>#attributes.REST_DAY#,<cfelse>NULL,</cfif>
		<cfif LEN(attributes.REST_HOUR)>#attributes.REST_HOUR#,<cfelse>NULL,</cfif>
		<cfif LEN(attributes.REST_START_DATE)>#attributes.REST_START_DATE#,<cfelse>NULL,</cfif>
		<cfif LEN(attributes.NEXT_INSPECTION_DATE)>#attributes.NEXT_INSPECTION_DATE#,<cfelse>NULL,</cfif>
		<cfif isdefined("attributes.DETAIL") and LEN(attributes.DETAIL)>'#attributes.DETAIL#',<cfelse>NULL,</cfif>
		'#attributes.employee_healty_no#',
		#NOW()#,
		#SESSION.EP.USERID#,
		'#CGI.REMOTE_USER#',
		<cfif len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
		<cfif len(attributes.doctor_emp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.doctor_emp_id#"><cfelse>NULL</cfif>,
		<cfif len(attributes.doctor_comp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.doctor_comp_id#"><cfelse>NULL</cfif>
	)
</cfquery>
<cf_papers paper_type="EMPLOYEE_HEALTY">
<cfset system_paper_no=paper_code & '-' & paper_number>
<cfset system_paper_no_add=paper_number>
<cfif len(system_paper_no_add)>
	<cfquery name="UPD_GEN_PAP" datasource="#DSN#">
		UPDATE 
			GENERAL_PAPERS_MAIN
		SET
			EMPLOYEE_HEALTY_NUMBER = #system_paper_no_add#
		WHERE
			EMPLOYEE_HEALTY_NUMBER IS NOT NULL
	</cfquery>
</cfif>
	<cf_workcube_process is_upd='1' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_table='EMPLOYEE_HEALTY'
	action_column='HEALTY_ID'
	action_id='#MAX_ID.identityCol#'
	action_page='#request.self#?fuseaction=hr.list_employee_healty_all&event=upd&healty_id=#MAX_ID.identityCol#'	
	warning_description='#getLang("","İşyeri Sağlık Muayeneleri",47131)#'>
<script type="text/javascript">
	<cfif isdefined("attributes.draggable")>	
	location.href = document.referrer;
<cfelse>
	window.location.href='<cfoutput>#request.self#?fuseaction=hr.list_employee_healty_all&event=upd&healty_id=#MAX_ID.identityCol#</cfoutput>';
</cfif>
</script>
