<cfif not isdefined("session.cp.userid")>
	<cflocation url="#request.self#?fuseaction=objects2.kariyer_login" addtoken="no">
</cfif>
<cf_date tarih="attributes.birth_date_relative">
<cfquery name="UPD_RELATIVE" datasource="#DSN#">
	UPDATE
		EMPLOYEES_RELATIVES
	SET
		EMPAPP_ID = #session.cp.userid#,
		EMPLOYEE_ID = NULL,
		NAME = '#attributes.name_relative#',
		SURNAME = '#attributes.surname_relative#',
		RELATIVE_LEVEL = '#attributes.relative_level#',
		BIRTH_DATE = #attributes.birth_date_relative#,
		BIRTH_PLACE = '#attributes.birth_place_relative#',
		JOB='#attributes.job_relative#',
		COMPANY='#attributes.company_relative#',
		JOB_POSITION='#attributes.job_position_relative#',
		UPDATE_IP='#CGI.REMOTE_ADDR#',
		UPDATE_DATE=#NOW()#
	WHERE 
		RELATIVE_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.relative_id#">
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
