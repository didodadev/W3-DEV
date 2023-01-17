<cfparam name="attributes.action_section" default="">
<cfparam name="attributes.action_id" default="">
<cfset uploadFolder = application.systemParam.systemParam().upload_folder />
<cfset company_asset_relation = application.systemParam.systemParam().company_asset_relation />

<cfset attributes.action_section = attributes.action_section eq 'INTERNAL_ID' ? 'INTERNALDEMAND_ID' : attributes.action_section />

<cfquery name="GET_ASSET" datasource="#DSN#">
	SELECT 
        ASSET.ASSETCAT_ID,
        ASSET.ASSET_ID,
        ASSET.ASSET_NO,
        ASSET.ASSET_FILE_NAME,
        ASSET.ASSET_NAME,
        ASSET.ASSET_DESCRIPTION,
        ASSET.ASSET_FILE_SERVER_ID,
        ASSET.RELATED_ASSET_ID,
        ASSET_CAT.ASSETCAT_PATH
	FROM 
		ASSET,
		ASSET_CAT
	WHERE
		ASSET.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID AND
		ASSET.ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.action_section#"> AND
        ASSET.ACTION_ID IN(#attributes.action_id#)
        <cfif isdefined("attributes.our_company_id") and len(attributes.our_company_id)>
			AND ASSET.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
		</cfif>
</cfquery>

<table class="ajax_list">
<cfif GET_ASSET.recordCount>
    <thead>
        <th style="width:40px"><cf_get_lang dictionary_id='57487.No'></th>
        <th><cf_get_lang dictionary_id='57880.Belge No'></th>
        <th><cf_get_lang dictionary_id='42266.Doküman Adı'></th>
        <th style="width:20px"><i class="fa fa-download"  title="<cfoutput>#getLang('asset',6)#</cfoutput>"></i></th>
        <th style="width:20px"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='48799.Kaynak'> <cf_get_lang dictionary_id ='57468.Belge'>"></i></th>
    </thead>
    
    <cfoutput query="GET_ASSET">

        <cfset url_ = "">
        <cfset path_ = ( ASSETCAT_ID gte 0 ) ? "asset/#ASSETCAT_PATH#" : "#assetcat_path#">
        <cfset ext = lcase(listlast(ASSET_FILE_NAME, '.')) />

        <cfif company_asset_relation eq 1>
            <cfif len(RELATED_ASSET_ID)>
                <cfquery name="getAssetRelated" datasource="#DSN#">
                    SELECT ACTION_ID,RECORD_DATE FROM ASSET WHERE ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#RELATED_ASSET_ID#">
                </cfquery>
                <cfif len(getAssetRelated.ACTION_ID)>
                    <cfset url_ = "#file_web_path#/#path_#/#year(getAssetRelated.RECORD_DATE)#/#getAssetRelated.ACTION_ID#/">
                    <cfset path = "#upload_folder##path_##dir_seperator##year(getAssetRelated.RECORD_DATE)##dir_seperator##getAssetRelated.ACTION_ID##dir_seperator#">
                <cfelse>
                    <cfset url_ = "#file_web_path#/#path_#/#year(RECORD_DATE)#/">
                    <cfset path = "#upload_folder##path_##dir_seperator##year(RECORD_DATE)##dir_seperator#">
                </cfif>
            <cfelseif len(ACTION_ID)>
                <cfset url_ = "#file_web_path#/#path_#/#year(RECORD_DATE)#/#ACTION_ID#/">
                <cfset path = "#upload_folder##path_##dir_seperator##year(RECORD_DATE)##dir_seperator##ACTION_ID##dir_seperator#">
            <cfelse>
                <cfset url_ = "#file_web_path#/#path_#/#year(RECORD_DATE)#/">
                <cfset path = "#upload_folder##path_##dir_seperator##year(RECORD_DATE)##dir_seperator#">
            </cfif>
        <cfelse>
            <cfset url_ = "#file_web_path##path_#/">
            <cfset path = "#upload_folder##path_##dir_seperator#">
        </cfif>

        <tr>
            <td>#currentrow#</td>
            <td>#ASSET_NO#</td>
            <td><a href="#request.self#?fuseaction=asset.list_asset&event=upd&asset_id=#ASSET_ID#&assetcat_id=#ASSETCAT_ID#" target="_blank">#ASSET_NAME#</a></td>
            <td>
                <cfif asset_file_server_id eq fusebox.server_machine>
                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_download_file&<cfif ext eq "jpg" or ext eq "jpeg" or ext eq "png" or ext eq "bmp" or ext eq "pdf" or ext eq "txt" or ext eq "gif">direct_show=1&</cfif>file_name=#url_##asset_file_name#&asset_id=#asset_id#&assetcat_id=#ASSETCAT_ID#','medium');return false;"><i class="fa fa-download"  title="#getLang('asset',6)#"></i></a>
                <cfelse>
                    <cf_get_server_file output_file="#url_##asset_file_name#" output_server="#asset_file_server_id#" output_type="2" small_image="/images/download.gif" image_link="1">
                </cfif>
            </td>
            <td><a href="#request.self#?fuseaction=asset.list_asset&event=upd&asset_id=#ASSET_ID#&assetcat_id=#ASSETCAT_ID#" target="_blank"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='48799.Kaynak'> <cf_get_lang dictionary_id ='57468.Belge'>"></i></a></td>
        </tr>
    </cfoutput>
<cfelse>
    <cf_get_lang dictionary_id='57484.Kayıt Yok'>
</cfif>
</table>