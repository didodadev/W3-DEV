<cfquery name="GET_SERVICE_ASSETS" datasource="#DSN#">
	SELECT
		A.ASSET_FILE_NAME,
		A.MODULE_NAME,
		A.ASSET_ID,
		A.ASSETCAT_ID,
		A.ASSET_NAME,
		A.IMAGE_SIZE,
		A.ASSET_FILE_SERVER_ID,
		AC.ASSETCAT,
		AC.ASSETCAT_PATH,
		CP.NAME,
		A.RECORD_PAR,
        A.RECORD_PUB
	FROM
		ASSET A,
		CONTENT_PROPERTY CP,
		ASSET_CAT AC,
        ASSET_SITE_DOMAIN ASD
	WHERE
        ASD.ASSET_ID = ASSET.ASSET_ID AND
        ASD.SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#"> AND
		A.ASSETCAT_ID = AC.ASSETCAT_ID AND
		A.ACTION_SECTION = 'SERVICE_ID' AND
		A.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#"> AND
		A.PROPERTY_ID = CP.CONTENT_PROPERTY_ID AND 
        A.IS_SPECIAL = 0 AND 
        A.IS_INTERNET = 1
	ORDER BY 
		A.RECORD_DATE DESC 
</cfquery>

<table border="0" class="color-border" cellpadding="2" cellspacing="1" style="width:98%;">
	<tr class="color-header" style="height:22px;">
		<td class="form-title"><cf_get_lang_main no='156.Belgeler'></td>
		<td align="right" style="text-align:right;"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_add_asset&action_id=#attributes.service_id#&action_section=SERVICE_ID&module_id=14&asset_cat_id=-5&module=service<cfif isdefined('attributes.is_file_upload_size')>&is_file_upload_size=#attributes.is_file_upload_size#</cfif></cfoutput>','small')"><img src="/images/pod_add.gif" title="<cf_get_lang_main no ='74.Güncelle'>" border="0" align="absmiddle"></a></td>
	</tr>
	<cfoutput query="get_service_asset">
        <tr class="color-list">
			<td><a href="javascript:" onclick="windowopen('#file_web_path##module_name#/#asset_file_name#','small')" title="" class="tableyazi">#asset_name#</a></td>
			<td align="right" style="text-align:right;">
				<cfif record_par eq session.pp.userid>
					<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_upd_asset&asset_id=#asset_id#','small')"><img src="images/pod_edit.gif" title="<cf_get_lang_main no ='52.Güncelle'>" border="0"></a>
				</cfif>
			</td>
        </tr>
    </cfoutput>
</table>
