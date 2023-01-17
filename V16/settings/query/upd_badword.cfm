<cfquery name="UPD_BADWORD" datasource="#dsn#">
	UPDATE 
		SETUP_FORUM_FILTER
	SET	
		WORD= <cfqueryparam cfsqltype="cf_sql_varchar" value="#WORD#"> 
	WHERE 
		WORD_ID=#WORD_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_badword" addtoken="no">
