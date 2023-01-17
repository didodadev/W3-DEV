<cfquery name="UPDCARD" datasource="#DSN#">
	UPDATE 
		SETUP_CREDITCARD 
	SET	
		CARDCAT='#CARDCAT#',
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#
	WHERE 
		CARDCAT_ID=#CARDCAT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_card" addtoken="no">
