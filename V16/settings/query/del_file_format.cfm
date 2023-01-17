<cfquery name="DELFORMAT" datasource="#dsn#">

	DELETE FROM
	      SETUP_FILE_FORMAT
	WHERE 
	       FORMAT_ID=#attributes.file_format_id#
	
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_file_format" addtoken="no">
