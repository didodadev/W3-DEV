<cfset upload_folder = "#upload_folder#settings#dir_seperator#backgrounds">
<cftry>
	
	<cfset file_name = createUUID()>
	<cffile action = "upload" 
	  fileField = "asset" 
	  destination = "#upload_folder#" 
	  nameConflict = "MakeUnique" 
	  mode="777">
	  
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
	  
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>


<cfquery name="ADD_ASSET" datasource="#dsn#">
	INSERT INTO
		OUR_COMPANY_ASSET
		(
			ASSET_NAME,
			ASSET_FILE_NAME,
			ASSET_FILE_SIZE,
			ASSET_FILE_SERVER_ID,
			ASSET_DETAIL,
			RECORD_DATE,
			RECORD_EMP
			)
	VALUES(
		'#attributes.ASSET_NAME#',
		'#file_name#.#cffile.serverfileext#',
		#ROUND(CFFILE.FILESIZE/1024)#,
		#fusebox.server_machine#,
		'#attributes.ASSET_DETAIL#',
		#NOW()#,
		#SESSION.EP.USERID#
			)
</cfquery>

<script type="text/javascript">
wrk_opener_reload();
window.close();
</script>
