<cfquery name="add_broadcast_cat" datasource="#dsn#">
	INSERT INTO 
		BROADCAST_CAT
	(
		BROADCAST_CAT_NAME,
		BROADCAST_CAT_DETAIL,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
	) 
	VALUES 
	(
		'#attributes.broadcast_cat#',
		<cfif len(attributes.broadcast_detail)>'#attributes.broadcast_detail#'<cfelse>NULL</cfif>,
		#session.ep.userid#,
		#now()#,
		'#CGI.REMOTE_ADDR#'
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_broadcast_cat" addtoken="no">
