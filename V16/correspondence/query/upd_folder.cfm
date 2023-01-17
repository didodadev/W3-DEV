<cfsetting showdebugoutput="no">
<cfif attributes.operation eq 'upd'>	
	<cfquery name="upd_" datasource="#dsn#">
		UPDATE
			CUBE_MAIL_FOLDER
		SET
			FOLDER_NAME = '#attributes.folder_name#',
			UPPER_FOLDER_ID = <cfif len(attributes.upper_folder_id)>#attributes.upper_folder_id#<cfelse>NULL</cfif>
		WHERE
			FOLDER_ID = #attributes.folder_id# 
	</cfquery>
<cfelseif attributes.operation eq 'del'>
	<cfquery name="del_" datasource="#dsn#">
		DELETE FROM
			CUBE_MAIL_FOLDER
		WHERE
			FOLDER_ID = #attributes.folder_id# 
	</cfquery>
</cfif>


