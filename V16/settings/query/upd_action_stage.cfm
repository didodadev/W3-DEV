<cfquery name="add_camp_stage" datasource="#dsn#">
	UPDATE
		SETUP_ACTION_STAGES
	SET
		STAGE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.STAGE_NAME#">,
		UPDATE_DATE = #NOW()#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		<cfif isdefined("detail")>DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#detail#">,</cfif>
		UPDATE_EMP = #SESSION.EP.USERID#
	WHERE
		STAGE_ID = #FORM.STAGE_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_action_stage" addtoken="no">
