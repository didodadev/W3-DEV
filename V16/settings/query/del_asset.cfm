<cfquery name="GET_ASSET" datasource="#dsn#">
	SELECT 
		ASSET_FILE_NAME,
		ASSET_FILE_SERVER_ID
	FROM 
		ASSET 
	WHERE 
		ASSET_ID=#attributes.ASSET_ID#
</cfquery>
<cfoutput query="get_asset">
	<cf_del_server_file output_file="settings/#asset_file_name#" output_server="#asset_file_server_id#">
</cfoutput>

<cfquery name="DEL_ASSET" datasource="#dsn#">
	DELETE 
    FROM 
		OUR_COMPANY_ASSET
	WHERE 
		ASSET_ID=#attributes.ASSET_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_company_info" addtoken="No">
