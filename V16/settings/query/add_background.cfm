<cfif len(attributes.background_file)>
	<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
	<cftry>		
		<cffile action = "upload" 
		  fileField = "background_file" 
		  destination = "#upload_folder#" 
		  nameConflict = "MakeUnique" 
		  mode="777">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#"> 
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#">
		  
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
				history.back();				
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>
	
</cfif>

<cfquery name="BACK" datasource="#dsn#">
	INSERT INTO
		SETUP_BACKGROUND
		(
		BACKGROUND_NAME,
		BACKGROUND_FILE,
		BACKGROUND_FILE_SERVER_ID,
		PORTAL,
		PAGE
		)
		VALUES
		(
		'#attributes.BACKGROUND_NAME#',
		<cfif len(attributes.background_file)>'#file_name#',<cfelse>'',</cfif>
		<cfif len(attributes.background_file)>#fusebox.server_machine#,<cfelse>'',</cfif>
		#attributes.PORTAL#,
		#attributes.PAGE#
		)
</cfquery>


<cflocation url="#request.self#?fuseaction=settings.form_add_background" addtoken="no">

