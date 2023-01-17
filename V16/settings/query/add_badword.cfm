<cfquery name="ADD_BADWORD" datasource="#dsn#">
		INSERT INTO 
		SETUP_FORUM_FILTER
		(
		WORD
		) 
		VALUES 
		(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#WORD#">
		)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_badword" addtoken="no">
