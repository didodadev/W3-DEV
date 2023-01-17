<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
<!--- önce eski belge silinir --->

<cfquery name="GET_ASSET" datasource="#dsn#">
	SELECT 
		ASSET_FILE_NAME ,
		ASSET_FILE_SERVER_ID
	FROM 
		ASSET 
	WHERE 
		ASSET_ID=#ASSET_ID#
</cfquery>
<cfoutput query="get_asset">
#asset_file_name#
<cf_del_server_file output_file="settings/asset_file_name#" output_server="#asset_file_server_id#">
</cfoutput>

<!--- belge upload edilir --->
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
			alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
			history.back();
		</script>
	</cfcatch>  
</cftry>


<cfquery name="UPD_ASSET" datasource="#dsn#">
	UPDATE 
		OUR_COMPANY_ASSET SET 
			ASSET_FILE_NAME='#file_name#.#cffile.serverfileext#',
			ASSET_FILE_SERVER_ID=#fusebox.server_machine#,
			ASSET_NAME='#attributes.ASSET_NAME#',
			ASSET_DETAIL='#attributes.ASSET_DETAIL#',
			RECORD_DATE=#NOW()#,
			RECORD_EMP=#SESSION.EP.USERID#
	WHERE 
		ASSET_ID=#ASSET_ID#
</cfquery>

<script type="text/javascript">

wrk_opener_reload();
window.close();
</script>
