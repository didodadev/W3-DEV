<cfquery name="BACKGROUND" datasource="#dsn#">
SELECT BACKGROUND_FILE ,BACKGROUND_FILE_SERVER_ID FROM SETUP_BACKGROUND WHERE BACKGROUND_ID = #attributes.BACKGROUND_ID#
</cfquery>
<cfif len(BACKGROUND.BACKGROUND_FILE)>
	<cfset upload_folder = "#upload_folder#settings#dir_seperator#backgrounds#dir_seperator#">
	<cf_del_server_file output_file="settings/#BACKGROUND.BACKGROUND_FILE#" output_server="#BACKGROUND.BACKGROUND_FILE_SERVER_ID#">
</cfif>

<cfquery name="BACK" datasource="#dsn#">
	DELETE FROM SETUP_BACKGROUND 
		WHERE
		BACKGROUND_ID = #attributes.BACKGROUND_ID#
</cfquery>


<cflocation url="#request.self#?fuseaction=settings.form_add_background" addtoken="no">

