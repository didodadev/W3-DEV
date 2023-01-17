<cf_date tarih="attributes.startdate">
<cf_date tarih="attributes.finishdate">

<cfscript>
	status = 0;	
	if(isDefined("attributes.record") and not isDefined("attributes.email"))
		status = 0;
	else 
	if(isDefined("attributes.email") and not isDefined("attributes.record"))
		status = 1;
	else 
	if(isDefined("attributes.record") and isDefined("attributes.email"))
		status = 2;
	else
	if(not isDefined("attributes.record") and not isDefined("attributes.email"))
		status = -1;
</cfscript>
<cfif isDefined("attributes.schedule_id") and Len(attributes.schedule_id)>
	<cfquery name="GET_SCHEDULES" datasource="#DSN#">
		INSERT INTO
			SCHEDULED_REPORTS
			(
				REPORT_ID,
				INFORMED_PEOPLE,
				INFORMED_PEOPLE_MAILS,
				SCHEDULE_STATUS,
				REPORT_NAME,
				SCHEDULE_PARAMS,
				SCHEDULE_IDS,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
		VALUES
			(
				#attributes.report_id#,
				<cfif len(attributes.emp_id)>'#attributes.emp_id#'<cfelse>NULL</cfif>,
				'#attributes.emp_mail#',
				#status#,
				'#attributes.report_name#',
				<cfif isdefined("attributes.extra") and len(attributes.extra)>'#attributes.extra#'<cfelse>NULL</cfif>,
				',#attributes.schedule_id#,',
				#SESSION.EP.USERID#,
				#NOW()#,
				'#cgi.REMOTE_ADDR#'
			)	
	</cfquery>
</cfif>		 
<script type="text/javascript">
	location.href = document.referrer;
</script>
