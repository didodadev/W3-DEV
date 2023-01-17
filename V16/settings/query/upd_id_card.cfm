<cfquery name="UPDIDENTYCARD" datasource="#dsn#">
	UPDATE 
		SETUP_IDENTYCARD 
	SET 
		IDENTYCAT = '#IDENTYCAT#',
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE 
		IDENTYCAT_ID=#IDENTYCAT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_id_card" addtoken="no">
