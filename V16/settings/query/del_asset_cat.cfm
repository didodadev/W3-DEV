<cfquery name="KLASOR" datasource="#dsn#">
	SELECT ASSETCAT_ID, ASSETCAT_PATH FROM ASSET_CAT WHERE ASSETCAT_ID=<cfqueryparam value = "#attributes.ASSETCAT_ID#" cfsqltype = "cf_sql_varchar">
</cfquery>
<cfset fileSystem = createObject("component","V16.asset.cfc.file_system")>
<CFTRY>
	<cfscript>
		folderList = fileSystem.fileListinFolder(folderPath:"ASSET#dir_seperator##KLASOR.ASSETCAT_PATH#");
		if(folderList.recordcount){
			for (folder in folderList) {
				fileSystem.deleteFolder("ASSET#dir_seperator##KLASOR.ASSETCAT_PATH#/#folder.Name#");
			}
		}
	</cfscript>	
	<CFDIRECTORY ACTION="DELETE" DIRECTORY="#upload_folder#ASSET#dir_seperator##KLASOR.ASSETCAT_PATH#">
	<cfquery name="DELASSETCAT" datasource="#dsn#">
		DELETE 
		FROM 
			ASSET_CAT 
		WHERE 
			ASSETCAT_ID = <cfqueryparam value = "#attributes.ASSETCAT_ID#" cfsqltype = "cf_sql_varchar"> OR 
			ASSETCAT_MAIN_ID = <cfqueryparam value = "#attributes.ASSETCAT_ID#" cfsqltype = "cf_sql_varchar">
	</cfquery>
	<CFCATCH>
		<script type="text/javascript">
			alert("<cf_get_lang no='94.Seçtiğiniz Klasör İsmi ile İlgili Bir Sorun Oluştu !'>");
			history.back();
		</script>
		<CFABORT>
	</CFCATCH>
</CFTRY>
<cfif isdefined("attributes.popup")>
	<script>
		window.opener.document.getElementById("listFolder").click();
		window.close();
	</script>
<cfelse>
	<cflocation url="#request.self#?fuseaction=settings.form_add_asset_cat" addtoken="no">
</cfif>