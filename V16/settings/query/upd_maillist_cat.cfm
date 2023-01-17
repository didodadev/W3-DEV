<cfif not isDefined("attributes.MAILLIST_CAT_STATUS")>
	<cfset attributes.MAILLIST_CAT_STATUS = 0>
</cfif>
<cfquery name="UPD_MAILLIST" datasource="#dsn#">
	UPDATE 
		MAILLIST_CAT
	SET
		MAILLIST_CAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MAILLIST_CAT#">,
		MAILLIST_CAT_STATUS = #attributes.MAILLIST_CAT_STATUS#,
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
	WHERE
		MAILLIST_CAT_ID = #attributes.MAILLIST_CAT_ID#
</cfquery>

<cflocation url="#request.self#?fuseaction=settings.form_add_maillist_cat" addtoken="no">
