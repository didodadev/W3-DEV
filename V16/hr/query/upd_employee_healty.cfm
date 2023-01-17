<cfif not isdefined("attributes.is_status")>
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
	<cfquery name="upd_heal" datasource="#DSN#">
		UPDATE
			EMPLOYEE_HEALTY
		SET
			EMPLOYEE_ID=#attributes.EMPLOYEE_ID#,
			RELATIVE_ID=<cfif len(attributes.RELATIVE_ID)>#attributes.RELATIVE_ID#<cfelse>NULL</cfif>,
			HEALTH_COMPLAINT=<cfif LEN(attributes.employee_healty_no)>'#attributes.employee_healty_no#',<cfelse>NULL,</cfif>
			HEALTY_NO=<cfif LEN(attributes.employee_healty_no)>'#attributes.employee_healty_no#',<cfelse>NULL,</cfif>
			COMPLAINT=<cfif isdefined("attributes.COMPLAINT") and  LEN(attributes.COMPLAINT)>'#attributes.COMPLAINT#',<cfelse>NULL,</cfif>
			COMPLAINT2=<cfif isdefined("attributes.COMPLAINT2") and LEN(attributes.COMPLAINT2)>'#attributes.COMPLAINT2#',<cfelse>NULL,</cfif>
			PROCESS_TYPE=<cfif isdefined("attributes.inspection_type") and LEN(attributes.inspection_type)>#attributes.inspection_type#,<cfelse>NULL,</cfif>
			INSPECTION_RESULT=<cfif LEN(attributes.INSPECTION_RESULT)>'#attributes.INSPECTION_RESULT#',<cfelse>NULL,</cfif>
			INSPECTION_DATE=<cfif LEN(attributes.INSPECTION_DATE)>#attributes.INSPECTION_DATE#,<cfelse>NULL,</cfif>
			DECISION_MEDICINE=<cfif isdefined("attributes.DECISIONMECIDINE") and LEN(attributes.DECISIONMECIDINE)>'#attributes.DECISIONMECIDINE#',<cfelse>NULL,</cfif>
			DECISION_MEDICINE2=<cfif isdefined("attributes.DECISIONMECIDINE2") and LEN(attributes.DECISIONMECIDINE2)>'#attributes.DECISIONMECIDINE2#',<cfelse>NULL,</cfif>
			CONCLUSION=<cfif LEN(attributes.CONCLUSION)>#attributes.CONCLUSION#,<cfelse>NULL,</cfif>
			DELIVERY_PLACE=<cfif LEN(attributes.DELIVERY_PLACE)>'#attributes.DELIVERY_PLACE#',<cfelse>NULL,</cfif>
			REST_DAY=<cfif LEN(attributes.REST_DAY)>#attributes.REST_DAY#,<cfelse>NULL,</cfif>
			REST_HOUR=<cfif LEN(attributes.REST_HOUR)>#attributes.REST_HOUR#,<cfelse>NULL,</cfif>
			REST_START_DATE=<cfif LEN(attributes.REST_START_DATE)>#attributes.REST_START_DATE#,<cfelse>NULL,</cfif>
			NEXT_INSPECTION_DATE=<cfif LEN(attributes.NEXT_INSPECTION_DATE)>#attributes.NEXT_INSPECTION_DATE#,<cfelse>NULL,</cfif>
			HEALTY_DETAIL=<cfif isdefined("attributes.DETAIL") and LEN(attributes.DETAIL)>'#attributes.DETAIL#',<cfelse>NULL,</cfif>
			UPDATE_DATE=#NOW()#,
			UPDATE_EMP=#SESSION.EP.USERID#,
			UPDATE_IP='#CGI.REMOTE_USER#',
			HEALTY_STAGE=<cfif len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
			DOCTOR_EMP_ID=<cfif len(attributes.doctor_emp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.doctor_emp_id#"><cfelse>NULL</cfif>,
			DOCTOR_COMP_ID=<cfif len(attributes.doctor_comp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.doctor_comp_id#"><cfelse>NULL</cfif>
		WHERE
			HEALTY_ID=#attributes.HEALTY_ID#
	</cfquery>
<cfelse>
	<cfquery name="upd_heal" datasource="#DSN#">
		UPDATE EMPLOYEE_HEALTY SET STATUS = <cfif isdefined('attributes.status')>1<cfelse>0</cfif> WHERE HEALTY_ID=#attributes.HEALTY_ID#
	</cfquery>
</cfif>
<cf_workcube_process is_upd='1' 
old_process_line='0'
process_stage='#attributes.process_stage#' 
record_member='#session.ep.userid#' 
record_date='#now()#' 
action_table='EMPLOYEE_HEALTY'
action_column='HEALTY_ID'
action_id='#attributes.HEALTY_ID#'
action_page='#request.self#?fuseaction=hr.list_employee_healty_all&event=upd&healty_id=#attributes.HEALTY_ID#'	
warning_description='#getLang("","İşyeri Sağlık Muayeneleri",47131)#'>
<script type="text/javascript">
<cfif isdefined("attributes.draggable")>	
	location.href = document.referrer;
<cfelse>
	    window.location.href='<cfoutput>#request.self#?fuseaction=hr.list_employee_healty_all&event=det&healty_id=#attributes.HEALTY_ID#&employee_id=#attributes.EMPLOYEE_ID#</cfoutput>';
</cfif>

</script>
