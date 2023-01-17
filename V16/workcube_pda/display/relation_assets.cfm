<cfif isDefined('attributes.work_id')>
	<cfset action_section = 'WORK_ID'>
    <cfset action_id = attributes.work_id>
<cfelseif isDefined('attributes.service_id')>
	<cfset action_section = 'SERVICE_ID'>
    <cfset action_id = attributes.service_id>
</cfif>

<cfquery name="GET_WORK_ASSET" datasource="#DSN#">
	SELECT
		A.ASSET_FILE_NAME,
		A.MODULE_NAME,
		A.ASSET_ID,
		A.ASSETCAT_ID,
		A.ASSET_NAME,
		A.IMAGE_SIZE,
		A.ASSET_FILE_SERVER_ID,
		ASSET_CAT.ASSETCAT,
		ASSET_CAT.ASSETCAT_PATH,
		CP.NAME,
        A.RECORD_EMP,
		A.RECORD_PAR
	FROM
		ASSET A,
		CONTENT_PROPERTY CP,
		ASSET_CAT
	WHERE
		A.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID AND
		A.ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#action_section#"> AND
		A.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#action_id#"> AND
		A.PROPERTY_ID = CP.CONTENT_PROPERTY_ID
		AND A.IS_SPECIAL = 0
		AND A.IS_INTERNET = 1
	ORDER BY 
		A.RECORD_DATE DESC 
</cfquery>

<table border="0" class="color-border" cellpadding="2" align="center" cellspacing="1" style="width:98%">
	<tr class="color-header" style="height:22px;">
		<td><cf_get_lang_main no='156.Belgeler'></td>
		<td align="right" style="text-align:right;"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=pda.popup_add_asset&action_id=#action_id#&action_section=#action_section#&module_id=1&asset_cat_id=-21&module=project<cfif isdefined('attributes.is_file_upload_size')>&is_file_upload_size=#attributes.is_file_upload_size#</cfif></cfoutput>','small')"><img src="/images/plus_list.gif" title="<cf_get_lang_main no ='74.Güncelle'>" border="0" align="absmiddle" class="form_icon"></a></td>
	</tr>
	<cfoutput query="get_work_asset">
        <tr class="color-list">
			<td><a href="javascript:" onClick="windowopen('#file_web_path##module_name#/#asset_file_name#','small')" title="" class="tableyazi">#asset_name#</a></td>
			<td align="right" style="text-align:right;">
				<cfif isDefined('session.pp.userid')>
					<cfif record_par eq session.pp.userid>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=pda.popup_upd_asset&asset_id=#asset_id#<cfif isdefined('attributes.is_file_upload_size')>&is_file_upload_size=#attributes.is_file_upload_size#</cfif>','small')"><img src="images/pod_edit.gif" title="<cf_get_lang_main no ='52.Güncelle'>" border="0" class="form_icon"></a>
					</cfif>
                <cfelseif isDefined('session.pda.userid')>
                	<cfif record_emp eq session.pda.userid>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=pda.popup_upd_asset&asset_id=#asset_id#<cfif isdefined('attributes.is_file_upload_size')>&is_file_upload_size=#attributes.is_file_upload_size#</cfif>','small')"><img src="images/pod_edit.gif" title="<cf_get_lang_main no ='52.Güncelle'>" border="0" class="form_icon"></a>
					</cfif>
                </cfif>
			</td>
        </tr>
    </cfoutput>
</table>
