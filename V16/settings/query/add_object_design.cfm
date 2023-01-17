<cfquery name="add_object_design" datasource="#dsn#">
	INSERT INTO 
		MAIN_SITE_OBJECT_DESIGN
	(
		DESIGN_NAME,
		DESIGN_DETAIL,
		DESIGN_PATH,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
	) 
	VALUES 
	(
		'#attributes.design_name#',
		<cfif len(attributes.design_detail)>'#attributes.design_detail#'<cfelse>NULL</cfif>,
		'#attributes.design_path#',
		#session.ep.userid#,
		#now()#,
		'#CGI.REMOTE_ADDR#'
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_object_design" addtoken="no">
