<cfsetting showdebugoutput="no">
<cfquery name="add_" datasource="#dsn#">
	INSERT INTO
		CUBE_MAIL_FOLDER
		(
		FOLDER_NAME,
		EMPLOYEE_ID,
		UPPER_FOLDER_ID
		)
	VALUES
		(
		'#attributes.file_name#',
		#session.ep.userid#,
		<cfif len(attributes.upper_folder_id)>#attributes.upper_folder_id#<cfelse>NULL</cfif>
		)
</cfquery>
