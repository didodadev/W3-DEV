<cfif not DirectoryExists("#upload_folder#asset")>
	<cfdirectory action="create" directory="#upload_folder#asset#dir_seperator#">
</cfif>
<cfset upload_folder = "#upload_folder#asset#dir_seperator#">


<cfif isDefined("attributes.image_path") and len(attributes.image_path)>
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
            <cfabort>
        </cfcatch>			
    </cftry>
	
        <cfset file_name = createUUID()>
        <cfset server_file= cffile.serverfileext>
        <cffile action='rename' source='#upload_folder##cffile.serverFile#' destination='#upload_folder##file_name#.#server_file#'>
</cfif>
<cfdump var="#attributes#">
<cflock timeout="60">
	<cftransaction>
		<cfquery name="ADD_LIBRARY_ASSET" datasource="#dsn#" result="MAX_ID">
			INSERT INTO
			LIBRARY_ASSET
				(	
					LIB_ASSET_NAME,
					LIB_ASSET_CAT,
					LIB_ASSET_CONTENT,
					LIB_ASSET_PUB,
					PUB_DATE,
					PUB_PLACE,
					DEPARTMENT_ID,
					WRITER,
					ASSET_TURN,
					PRESS,
					DETAIL,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE,
					BARCODE_NO,
					IMAGE_PATH,
					IMAGE_PATH_SERVER_ID
				) 
			VALUES
				(
					'#attributes.lib_asset_name#',
					#attributes.lib_asset_cat#,
					<cfif len(attributes.lib_asset_content)>'#attributes.lib_asset_content#'<cfelse>null</cfif>,
					<cfif len(attributes.lib_asset_pub)>'#attributes.lib_asset_pub#'<cfelse>null</cfif>,
					<cfif len(attributes.pub_date)>#attributes.pub_date#<cfelse>null</cfif>,
					<cfif len(attributes.pub_place)>'#attributes.pub_place#'<cfelse>null</cfif>,
					#attributes.department_id#,
					<cfif len(attributes.writer)>'#attributes.writer#'<cfelse>null</cfif>,
					<cfif len(attributes.asset_turn)>'#attributes.asset_turn#'<cfelse>null</cfif>,
					<cfif len(attributes.press)>#attributes.press#<cfelse>null</cfif>,
					<cfif len(attributes.detail)>'#attributes.detail#'<cfelse>null</cfif>,
					#session.ep.userid#,
					'#cgi.remote_addr#',
					#now()#,
					'#attributes.asset_barcode#',
					<cfif isDefined("attributes.image_path") and len(attributes.image_path)><cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#.#server_file#"><cfelse>NULL</cfif>,
					<cfif isDefined("attributes.image_path") and len(attributes.image_path)>#fusebox.server_machine#<cfelse>NULL</cfif>
				)
		</cfquery>
		<cfquery name="ADD_SYSTEMNO" datasource="#dsn#">
			UPDATE
				LIBRARY_ASSET
			SET
				SYSTEM_NO = '#MAX_ID.IDENTITYCOL#'
			WHERE
				LIB_ASSET_ID = #MAX_ID.IDENTITYCOL#
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	location.href = document.referrer;
</script>
