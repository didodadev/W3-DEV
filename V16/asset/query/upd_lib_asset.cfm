<cfif not DirectoryExists("#upload_folder#asset")>
	<cfdirectory action="create" directory="#upload_folder#asset#dir_seperator#">
</cfif>
<cfset upload_folder = "#upload_folder#asset#dir_seperator#">

<cfif len(attributes.image_path)>
	<cftry>
		<cffile 
        action="UPLOAD" 
        nameconflict="OVERWRITE" 
        filefield="image_path" 
        destination="#upload_folder#" accept="image/*">	
		<cfcatch type="any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '> : " + #attributes.image_path#);
				history.back();
			</script>
		</cfcatch>			
	</cftry>
	<cfset file_name = createUUID()>
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
	<cfif len(attributes.old_icon)>
		<cffile action="delete" file="#upload_folder##attributes.old_icon#">
	</cfif>
</cfif>
<cfquery name="upd_lib_asset" datasource="#dsn#">
	UPDATE
		LIBRARY_ASSET
	SET
		LIB_ASSET_NAME = '#attributes.lib_asset_name#',
		LIB_ASSET_CAT = #attributes.lib_asset_cat#,
		LIB_ASSET_CONTENT = <cfif len(attributes.lib_asset_content)>'#attributes.lib_asset_content#',<cfelse>null,</cfif>
		LIB_ASSET_PUB = <cfif len(attributes.lib_asset_pub)>'#attributes.lib_asset_pub#',<cfelse>null,</cfif>
		PUB_DATE = <cfif len(attributes.pub_date)>#attributes.pub_date#,<cfelse>null,</cfif>
		PUB_PLACE = <cfif len(attributes.pub_place)>'#attributes.pub_place#',<cfelse>null,</cfif>
		DEPARTMENT_ID = #attributes.department_id#,
		WRITER = <cfif len(attributes.writer)>'#attributes.writer#',<cfelse>null,</cfif>
		ASSET_TURN = <cfif len(attributes.asset_turn)>'#attributes.asset_turn#',<cfelse>null,</cfif>
		PRESS = <cfif len(attributes.press)>#attributes.press#,<cfelse>null,</cfif>
		DETAIL = <cfif len(attributes.detail)>'#attributes.detail#',<cfelse>null,</cfif>
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		BARCODE_NO = '#attributes.asset_barcode#',
		IMAGE_PATH = <cfif isDefined("file_name")><cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#.#cffile.serverfileext#"><cfelse>NULL</cfif>
	WHERE 
		LIB_ASSET_ID = #attributes.lib_asset_id#
</cfquery>
<script type="text/javascript">
	 location.href = document.referrer;
</script>
