<cfif not isDefined("attributes.MAILLIST_CAT_STATUS")>
	<cfset attributes.MAILLIST_CAT_STATUS = 0>
</cfif>
<cfquery name="ADD_MAILLIST" datasource="#dsn#">
	INSERT INTO 
			MAILLIST_CAT
		(
			MAILLIST_CAT,
			MAILLIST_CAT_STATUS,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
		) 
	VALUES 
		(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#MAILLIST_CAT#">,
			#attributes.MAILLIST_CAT_STATUS#,
			#NOW()#,
			#SESSION.EP.USERID#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
		)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_maillist_cat" addtoken="no">
