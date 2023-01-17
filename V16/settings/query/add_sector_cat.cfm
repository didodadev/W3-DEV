<cf_xml_page_edit fuseact="settings.form_add_sector_cat" is_multi_page="1">
<cfif isDefined("attributes.sector_image") and len(attributes.sector_image)>
	<cfset upload_folder = "#upload_folder##dir_seperator#settings#dir_seperator#">
	<cftry>
		<cffile action="UPLOAD"
				filefield="sector_image"
				destination="#upload_folder#"
				mode="777"
				nameconflict="MAKEUNIQUE" accept="image/*">
			<cfset file_name = createUUID()>
			<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
			<cfset attributes.sector_image = '#file_name#.#cffile.serverfileext#'>
	
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
</cfif>

<cfquery name="add_sector_cat" datasource="#dsn#">
	INSERT INTO 
		SETUP_SECTOR_CATS
	(
		SECTOR_UPPER_ID,
		SECTOR_CAT,
		SECTOR_LIMIT,
		IS_INTERNET,
		<cfif isDefined("attributes.sector_image") and len(attributes.sector_image)>
			SECTOR_IMAGE,
			SERVER_SECTOR_IMAGE_ID,
		</cfif>
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP,
        SECTOR_CAT_CODE
	)
	VALUES 
	(
		<cfif isdefined("attributes.sector_upper") and len(attributes.sector_upper)>#attributes.sector_upper#<cfelse>NULL</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#SECTOR_CAT#">,
		<cfif isdefined("attributes.sector_limit") and len(attributes.sector_limit)>#attributes.sector_limit#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.is_internet")>1<cfelse>0</cfif>,
		<cfif isDefined("attributes.sector_image") and len(attributes.sector_image)>
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sector_image#">,
			#fusebox.server_machine#,
		</cfif>
		#SESSION.EP.USERID#,
		#NOW()#,
		'#CGI.REMOTE_ADDR#',
        <cfif isdefined('attributes.sector_cat_code') and len(attributes.sector_cat_code)>'#attributes.sector_cat_code#'<cfelse>NULL</cfif>
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.list_sector_cat" addtoken="no">

