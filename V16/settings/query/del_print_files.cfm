<cfif len(attributes.old_template_file)>
	<cfif FileExists("#upload_folder#settings#dir_seperator##attributes.old_template_file#")>
		<cf_del_server_file output_file="settings/#attributes.old_template_file#" output_server="#attributes.old_template_file_server_id#">
	</cfif>	
</cfif>
<cfquery name="add_" datasource="#dsn3#">
	 DELETE FROM SETUP_PRINT_FILES WHERE FORM_ID = #ATTRIBUTES.FORM_ID#
</cfquery>
<cfquery name="del_print_files_position" datasource="#dsn#">
	DELETE FROM SETUP_PRINT_FILES_POSITION WHERE FORM_ID = #attributes.FORM_ID# AND OUR_COMPANY_ID = #session.ep.company_id#
</cfquery>

<cflocation url="#request.self#?fuseaction=settings.form_add_print_files" addtoken="no">
