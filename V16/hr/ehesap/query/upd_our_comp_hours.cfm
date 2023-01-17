<cfquery name="add_our_company_work_hours" datasource="#dsn#">
	UPDATE
		OUR_COMPANY_HOURS
	SET
		OUR_COMPANY_ID = #ATTRIBUTES.OUR_COMPANY_ID#,
		DAILY_WORK_HOURS = #ATTRIBUTES.DAILY_WORK_HOURS#,
		SATURDAY_WORK_HOURS = #ATTRIBUTES.SATURDAY_WORK_HOURS#,
		SSK_MONTHLY_WORK_HOURS = #ATTRIBUTES.SSK_MONTHLY_WORK_HOURS#,
		SSK_WORK_HOURS = #ATTRIBUTES.SSK_WORK_HOURS#,
		WEEKLY_OFFDAY = #attributes.weekly_offday#,
		SATURDAY_OFF = <cfif isdefined("attributes.saturday_off")>1<cfelse>0</cfif>,
		START_HOUR = #attributes.start_hour#,
        START_MIN = #attributes.start_min#,
        END_HOUR = #attributes.end_hour#,
        END_MIN = #attributes.end_min#,
        UPDATE_DATE = #NOW()#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_EMP = #SESSION.EP.USERID#
	WHERE
		OCH_ID = #FORM.OCH_ID#
</cfquery>

<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=ehesap.hours</cfoutput>';
</script>
