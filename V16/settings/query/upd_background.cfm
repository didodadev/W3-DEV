<cfif len(attributes.background_file)>
<cfset upload_folder = "z:\">
		<cffile action = "upload" 
		  fileField = "background_file" 
		  destination = "#upload_folder#" 
		  nameConflict = "MakeUnique" 
		  mode="777">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#"> 
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#">
		  
	
	<cfif isdefined("attributes.old_background")>
		<cf_del_server_file output_file="settings/#attributes.old_background#" output_server="#attributes.old_background_server_id#">
	</cfif>	
</cfif>



<cfquery name="BACK" datasource="#dsn#">
	UPDATE SETUP_BACKGROUND SET
		BACKGROUND_NAME = '#attributes.BACKGROUND_NAME#',
		<cfif len(attributes.background_file)>BACKGROUND_FILE = '#file_name#',</cfif>
		<cfif len(attributes.background_file)>BACKGROUND_FILE_SERVER_ID= #fusebox.server_machine#,</cfif>
		PORTAL = #attributes.PORTAL#,
		PAGE = #attributes.PAGE#
	WHERE
		BACKGROUND_ID = #attributes.BACKGROUND_ID#
</cfquery>


<cflocation url="#request.self#?fuseaction=settings.form_add_background" addtoken="no">

