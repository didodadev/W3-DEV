<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
        <cfset GET_camp_stage.MAX_ID = MAX_ID.IDENTITYCOL>
		<cfquery name="add_camp_stage" datasource="#dsn#" result="MAX_ID">
			INSERT INTO
				SETUP_ACTION_STAGES
				(
				STAGE_ID,
				STAGE_NAME,
				RECORD_DATE,
				RECORD_IP,
				<cfif len(detail)>DETAIL,</cfif>
				RECORD_EMP
				)
			VALUES
				(
				#GET_CAMP_STAGE.MAX_ID#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.STAGE_NAME#">,
				#NOW()#,
				'#CGI.REMOTE_ADDR#',
				<cfif len(detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#detail#">,</cfif>
				#SESSION.EP.USERID#
				)
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.form_add_action_stage" addtoken="no">
