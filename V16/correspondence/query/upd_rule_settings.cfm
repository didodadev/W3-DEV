<cfif attributes.operation eq 'upd'>
	<cfquery name="upd_emp_mail_rule" datasource="#DSN#">  
		UPDATE 
			CUBE_MAIL_RULES
    	SET	
			EMPLOYEE_ID=#attributes.employee_id#,
			RULE_NAME='#attributes.name#',
			FOLDER_ID=#attributes.folder#,
			RULE_TYPE=#attributes.type#,
			RULE_CASE='#attributes.words#',
			PRIORITY = #attributes.priority#
		WHERE 
			RULE_ID=#attributes.rule_id#
	</cfquery>
<cfelseif attributes.operation eq 'del'>
		<cfquery name="del_emp_mail_rule" datasource="#DSN#">  
		  DELETE FROM
			CUBE_MAIL_RULES
		  WHERE
			RULE_ID = #attributes.rule_id# AND EMPLOYEE_ID=#attributes.employee_id#
	</cfquery>
</cfif>
<cflocation url="#request.self#?fuseaction=correspondence.list_mymails&employee_id=#attributes.employee_id#" addtoken="no">
