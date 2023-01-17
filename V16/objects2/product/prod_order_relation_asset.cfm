<cfif not isdefined('attributes.company_id')>
	<cfif isdefined('session.pp.userid')>
		<cfset attributes.company_id = session.pp.company_id>
	</cfif>
</cfif>
<cfif not isdefined('attributes.consumer_id')>
	<cfif isdefined('session.ww.userid')>
		<cfset attributes.consumer_id = session.ww.userid>
	</cfif>
</cfif>
<cfquery name="GET_ORDER_ASSET" datasource="#DSN#">
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
		A.RECORD_PAR
	FROM
		ASSET A,
		CONTENT_PROPERTY CP,
		ASSET_CAT
	WHERE
		A.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID AND
		A.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#"> AND
		A.ACTION_SECTION = 'P_ORDER_ID' AND
		A.PROPERTY_ID = CP.CONTENT_PROPERTY_ID AND 
		A.IS_SPECIAL = 0 AND 
		A.IS_INTERNET = 1
	ORDER BY 
		A.RECORD_DATE DESC 
</cfquery>

<cfset action_section = 'P_ORDER_ID'>
<cfset action_id = attributes.upd>
<table border="0" width="98%" class="color-border" cellpadding="2" cellspacing="1">
	<tr class="color-header" height="22">
		<td class="form-title"><cf_get_lang_main no='156.Belgeler'></td>
		<td align="right" style="text-align:right;"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_add_asset&action_id=#attributes.upd#&action_section=#action_section#&module_id=11&asset_cat_id=-12&module=salespur<cfif isdefined('attributes.is_file_upload_size')>&is_file_upload_size=#attributes.is_file_upload_size#</cfif></cfoutput>','small')"><img src="/images/pod_add.gif" title="" border="0" align="absmiddle"></a></td>
	</tr>
	<cfoutput query="get_order_asset">
        <tr class="color-list">
			<td><a href="javascript:" onClick="windowopen('#file_web_path#salespur/#asset_file_name#','small')" title="" class="tableyazi">#asset_name#</a></td>
			<td align="right" style="text-align:right;">
				<cfif record_par eq action_id>
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_upd_asset&asset_id=#asset_id#<cfif isdefined('attributes.is_file_upload_size')>&is_file_upload_size=#attributes.is_file_upload_size#</cfif>','small')"><img src="images/pod_edit.gif" title="<cf_get_lang_main no ='52.Güncelle'>" border="0"></a>
				</cfif>
			</td>
        </tr>
    </cfoutput>
</table>
