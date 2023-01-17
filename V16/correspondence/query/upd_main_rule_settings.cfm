<cfif attributes.operation eq 'upd'>
	<cfquery name="upd_emp_main_mail_rule" datasource="#dsn#">
		UPDATE 
			CUBE_MAIL_MAIN_RULES
		SET
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = '#CGI.REMOTE_ADDR#',
			UPDATE_DATE = #now()#,
			TYPE = #attributes.type#,
			RULE_NAME = '#attributes.rule_name#',
			ACTION = '#attributes.action#'
		WHERE
			RULE_ID = #attributes.rule_id#
	</cfquery>
<cfelseif attributes.operation eq 'del'>
	<cfquery name="del_emp_main_main_rule" datasource="#dsn#">
		DELETE FROM
			CUBE_MAIL_MAIN_RULES
		WHERE
			RULE_ID = #attributes.rule_id#
	</cfquery>
</cfif>
<cflocation url="#request.self#?fuseaction=correspondence.list_mymails" addtoken="no">
