<cfquery name="GET_WORK_ASSET" datasource="#DSN#">
	SELECT
		A.ASSET_FILE_NAME,
		A.MODULE_NAME,
		A.ASSET_ID,
		A.ASSETCAT_ID,
		A.ASSET_NAME,
		A.RECORD_EMP,
		A.IMAGE_SIZE,
		A.ASSET_FILE_SERVER_ID,
		ASSET_CAT.ASSETCAT,
		ASSET_CAT.ASSETCAT_PATH,
		CP.NAME,
		A.RECORD_PAR
	FROM
		ASSET A,
		CONTENT_PROPERTY CP,
		ASSET_CAT
	WHERE
		A.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID AND
		A.ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="WORK_ID"> AND
		A.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_id#"> AND
		A.PROPERTY_ID = CP.CONTENT_PROPERTY_ID
		AND A.IS_SPECIAL = 0
		AND A.IS_INTERNET = 1
	ORDER BY 
		A.RECORD_DATE DESC 
</cfquery>

<table border="0" class="color-border" cellpadding="2" cellspacing="1" style="width:98%">
	<tr class="color-header" style="height:22px;">
		<td class="form-title"><cf_get_lang_main no='156.Belgeler'></td>
		<td align="right" style="text-align:right;"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_add_asset&action_id=#attributes.work_id#&action_section=WORK_ID&module_id=1&asset_cat_id=-21&module=project<cfif isdefined('attributes.is_file_upload_size')>&is_file_upload_size=#attributes.is_file_upload_size#</cfif></cfoutput>','small')"><img src="/images/pod_add.gif" title="<cf_get_lang_main no ='74.Güncelle'>" border="0" align="absmiddle"></a></td>
	</tr>
	<cfoutput query="get_work_asset">
		<cfif assetcat_id gt 0>
            <cfset folder_ = "asset/#assetcat_path#">
        <cfelse>
            <cfset folder_ = "#assetcat_path#">
        </cfif>
        <tr class="color-list">
			<td><a href="#request.self#?fuseaction=objects2.popup_download_file&amp;file_name=#folder_#/#asset_file_name#&amp;file_control=asset.form_upd_asset&amp;asset_id=#asset_id#&amp;assetcat_id=#assetcat_id#" title="" class="tableyazi">#asset_name#</a></td>
			<td align="right" style="text-align:right;">
				<cfif (isDefined('session.pp.userid') and record_par eq session.pp.userid) or (isDefined('session.pda.userid') and record_emp eq session.pda.userid)>
					<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_upd_asset&asset_id=#asset_id#<cfif isdefined('attributes.is_file_upload_size')>&is_file_upload_size=#attributes.is_file_upload_size#</cfif>','small')"><img src="images/pod_edit.gif" title="<cf_get_lang_main no ='52.Güncelle'>" border="0"></a>
				</cfif>
			</td>
        </tr>
    </cfoutput>
</table>
