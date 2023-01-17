<cf_date tarih="attributes.startdate">
<cf_date tarih="attributes.finishdate">

<cfscript>
	status = 0;	
	if(isDefined("attributes.record") and not isDefined("attributes.email"))
		status = 0;
	else if(isDefined("attributes.email") and not isDefined("attributes.record"))
		status = 1;
	else if(isDefined("attributes.record") and isDefined("attributes.email"))
		status = 2;
	else if(not isDefined("attributes.record") and not isDefined("attributes.email")) 
		status = -1;
</cfscript>
<cfif isDefined("attributes.schedule_id") and Len(attributes.schedule_id)>
	<cfquery name="GET_SCHEDULES" datasource="#DSN#">
		UPDATE
			SCHEDULED_REPORTS
		SET	
			INFORMED_PEOPLE = <cfif len(attributes.emp_id)>'#attributes.emp_id#'<cfelse>NULL</cfif>,
			INFORMED_PEOPLE_MAILS = '#attributes.emp_mail#',
			SCHEDULE_STATUS = #status#,
			REPORT_NAME = '#attributes.report_name#',
			SCHEDULE_PARAMS = <cfif len(attributes.extra)>'#attributes.extra#'<cfelse>NULL</cfif>,
			SCHEDULE_IDS = ',#attributes.schedule_id#,',
			UPDATE_EMP = #SESSION.EP.USERID#,
			UPDATE_DATE = #NOW()#,
			UPDATE_IP = '#cgi.REMOTE_ADDR#'
		WHERE
			REPORT_ID = #form.report_id#	
	</cfquery>
<cfelse>
	<cfquery name="DEL_REPORT_SCHEDULE" datasource="#DSN#">
		DELETE FROM SCHEDULED_REPORTS WHERE REPORT_ID = #form.report_id#
	</cfquery>
</cfif>		 
<script type="text/javascript">
	location.href = document.referrer;
</script>
