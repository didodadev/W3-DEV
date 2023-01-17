<!--- belgenin kaydedilecegi klasör --->
<cfset uploadFolder = application.systemParam.systemParam().upload_folder />
<cfset path=''>
<cflock timeout="20">
	<cftransaction>
		<cfquery name="GET_UPLOAD_FOLDER" datasource="#dsn#">
			SELECT 
				ASSETCAT_ID,
				ASSETCAT_PATH
			FROM
				ASSET_CAT
			WHERE
				ASSETCAT_ID = #attributes.ASSETCAT_ID#
		</cfquery>
		<cfquery name="GET_FILE" datasource="#dsn#">
			SELECT
				ASSET_ID,
				ASSET_FILE_NAME,
				ASSET_FILE_SERVER_ID,
				ASSET_NO,
				ASSETCAT_ID,
                ASSET_STAGE,
                ACTION_ID,
                RECORD_DATE,
                RELATED_ASSET_ID
			FROM
				ASSET
			WHERE
				ASSET_ID = #attributes.ASSET_ID#
		</cfquery>
		<cfquery name="control_" datasource="#dsn#">
			SELECT
				ASSET_ID
			FROM
				ASSET
			WHERE
				ASSET_ID <> #attributes.ASSET_ID# AND
				ASSET_FILE_NAME = '#GET_FILE.ASSET_FILE_NAME#'
		</cfquery>
        
        <cfif GET_UPLOAD_FOLDER.ASSETCAT_ID gte 0>
			<cfset path = "asset/#GET_UPLOAD_FOLDER.ASSETCAT_PATH#">
        <cfelse>
        	<cfset path = GET_UPLOAD_FOLDER.ASSETCAT_PATH>
        </cfif>
        <cfif company_asset_relation eq 1>
			<cfif len(GET_FILE.related_asset_id)>
                <cfquery name="getAssetRelated" datasource="#dsn#">
                    SELECT ACTION_ID,RECORD_DATE FROM ASSET WHERE ASSET_ID = #GET_FILE.related_asset_id#
                </cfquery>
                <cfif len(getAssetRelated.action_id)>
                    <cfset folder="#path#/#year(getAssetRelated.record_date)#/#getAssetRelated.action_id#">
                <cfelse>
                    <cfset folder="#path#/#year(GET_FILE.record_date)#">
                </cfif>
            <cfelseif len(GET_FILE.action_id)>
                <cfset folder="#path#/#year(GET_FILE.record_date)#/#GET_FILE.action_id#">
            <cfelse>
                <cfset folder="#path#/#year(GET_FILE.record_date)#">
            </cfif>
        <cfelse>
			<cfset folder="#path#">
        </cfif>
		<cfquery name="DEL_ASSET" datasource="#dsn#">
			DELETE FROM ASSET WHERE ASSET_ID = #attributes.ASSET_ID#
		</cfquery>
		<cfif not control_.recordcount><!--- sadece database silinir ... aynı dosya başka bir kayıtta da kullanılıyor... --->
			<cf_del_server_file output_file="#folder#/#get_file.asset_file_name#" output_server="#GET_FILE.asset_file_server_id#">
			<cf_del_server_file output_file="#uploadFolder#thumbnails/middle/#get_file.asset_file_name#" output_server="#GET_FILE.asset_file_server_id#">
			<cf_del_server_file output_file="#uploadFolder#thumbnails/icon/#get_file.asset_file_name#" output_server="#GET_FILE.asset_file_server_id#">
		</cfif>
		<cf_add_log  log_type="-1" action_id="#attributes.asset_id#" action_name="Belge Silindi #attributes.head#" paper_no="#get_file.asset_no#" process_stage="#get_file.ASSET_STAGE#">
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=asset.list_asset" addtoken="no">
