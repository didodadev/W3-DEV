<cfquery name="get_image" datasource="#DSN#">
	SELECT 
		SECTOR_IMAGE,
		SERVER_SECTOR_IMAGE_ID
	FROM 
		SETUP_SECTOR_CAT_UPPER
	WHERE
		SECTOR_UPPER_ID = #SECTOR_UPPER_ID#
</cfquery>

<cfset upload_folder = "#upload_folder#settings#dir_seperator#">

<cfif isDefined("del_sector_image")>
<!--- sadece varsa resmi sil --->
	<cfif len(get_image.sector_image)>
		<cf_del_server_file output_file="settings/#get_image.sector_image#" output_server="#get_image.server_sector_image_id#">
	</cfif>
	<cfset attributes.sector_image = "">
<cfelse>
	<cfif isDefined("attributes.sector_image") and len(attributes.sector_image)>
	<!--- eski varsa sil --->
		<cfif len(get_image.sector_image)>
			<cf_del_server_file output_file="settings/#get_image.sector_image#" output_server="#get_image.server_sector_image_id#">
		</cfif>
	<!--- yeni upload --->
		<cftry>
			<cffile action="UPLOAD" filefield="sector_image" destination="#upload_folder#" mode="777" nameconflict="MAKEUNIQUE">
			<cfcatch type="Any">
				<script type="text/javascript">
					alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
					history.back();
				</script>
			</cfcatch>  
		</cftry>

		<cfset file_name = createUUID()>
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
		<cfset attributes.sector_image = '#file_name#.#cffile.serverfileext#'>

	<cfelse>
	<!--- eski deðeri yerine yaz --->
		<cfset attributes.sector_image = get_image.sector_image>
	</cfif>
</cfif>


<cfquery name="UPD_SECTOR_UPPER" datasource="#dsn#">
	UPDATE 
		SETUP_SECTOR_CAT_UPPER 
	SET 
		SECTOR_CAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SECTOR_CAT#">,
		IS_INTERNET = <cfif isdefined("attributes.is_internet")>1<cfelse>0</cfif>,
		<cfif isDefined("attributes.sector_image") and len(attributes.sector_image)>
			SECTOR_IMAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sector_image#">,
			SERVER_SECTOR_IMAGE_ID = #fusebox.server_machine#,
		</cfif>
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#',
        SECTOR_CAT_CODE = <cfif isdefined ('attributes.sector_cat_code') and len(attributes.sector_cat_code)>'#attributes.sector_cat_code#'<cfelse>NULL</cfif>
	WHERE 
		SECTOR_UPPER_ID = #SECTOR_UPPER_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.list_sector_upper" addtoken="no">

