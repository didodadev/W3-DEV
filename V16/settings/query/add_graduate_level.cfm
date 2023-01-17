<cfquery name="ADD_GRADUATE_LEVEL" datasource="#DSN#">
	INSERT INTO
		SETUP_GRADUATE_LEVEL
	(
		GRADUATE_NAME,
		DETAIL,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	)
	VALUES
	(
		'#attributes.graduate_name#',
		<cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
		'#cgi.remote_addr#',
		#now()#,
		#session.ep.userid#
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_graduate_level" addtoken="no">
