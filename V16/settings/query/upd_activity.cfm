<cfquery name="UPD_ACTIVITY" datasource="#DSN#">
	UPDATE 
		SETUP_ACTIVITY
	SET 
		ACTIVITY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.activity_name#">,
		ACTIVITY_STATUS = <cfif isdefined("attributes.activity_status")>1<cfelse>0</cfif>,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
	WHERE 
		ACTIVITY_ID = #attributes.activity_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_activity" addtoken="no">
