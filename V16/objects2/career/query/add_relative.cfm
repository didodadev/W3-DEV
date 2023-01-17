<cfif not isdefined("session.cp.userid")>
	<cflocation url="#request.self#?fuseaction=objects2.kariyer_login" addtoken="no">
</cfif>
<cf_date tarih="attributes.birth_date_relative">
<cfquery name="add_relative" datasource="#dsn#">
 INSERT INTO
	EMPLOYEES_RELATIVES
	(
		EMPAPP_ID,	
		EMPLOYEE_ID,
		NAME,
		SURNAME,
		RELATIVE_LEVEL,
		BIRTH_DATE,
		BIRTH_PLACE,
		JOB,
		COMPANY,
		JOB_POSITION,
		RECORD_IP,
		RECORD_DATE
	)
  VALUES
	(
		#session.cp.userid#,
		NULL,
		'#attributes.name_relative#',
		'#attributes.surname_relative#',
		'#attributes.relative_level#',
		<cfif len(attributes.birth_date_relative)>#attributes.birth_date_relative#<cfelse>NULL</cfif>,
		'#attributes.birth_place_relative#',
		'#attributes.job_relative#',
		'#attributes.company_relative#',
		'#attributes.job_position_relative#',
		'#CGI.REMOTE_ADDR#',
		#NOW()#
	)
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
