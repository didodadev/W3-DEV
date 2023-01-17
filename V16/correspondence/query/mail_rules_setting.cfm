<cfquery name="add_rule" datasource="#dsn#">
	INSERT INTO
 		CUBE_MAIL_RULES
		(
			EMPLOYEE_ID,
			RULE_NAME,
			FOLDER_ID,
			RULE_TYPE,
			RULE_CASE,
			PRIORITY
		)
		VALUES
		(
		#attributes.employee_id#,
		'#attributes.name#',
		#attributes.folder#,
		#attributes.type#,
		'#attributes.words#',
		#attributes.priority#
		)
</cfquery>
<cflocation url="#request.self#?fuseaction=correspondence.list_mymails&employee_id=#attributes.employee_id#" addtoken="no">
