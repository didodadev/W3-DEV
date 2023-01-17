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
<cfquery name="GET_MEMBER_ASSET" datasource="#DSN#">
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
		<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
			A.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
			A.ACTION_SECTION = 'COMPANY_ID' AND
		<cfelse>
			A.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
			A.ACTION_SECTION = 'CONSUMER_ID' AND
		</cfif>
		A.PROPERTY_ID = CP.CONTENT_PROPERTY_ID
		AND A.IS_SPECIAL = 0
		AND A.IS_INTERNET = 1
	ORDER BY 
		A.RECORD_DATE DESC 
</cfquery>
<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
	<cfset action_id = attributes.company_id>
	<cfset action_section = 'COMPANY_ID'>
<cfelse>
	<cfset action_id = attributes.consumer_id>
	<cfset action_section = 'CONSUMER_ID'>
</cfif>

<cfsavecontent variable="head"><cf_get_lang dictionary_id='57568.Belgeler'></cfsavecontent>
<cf_box title="#head#">
	<div class="table-responsive-lg">
		<table class="table">
			<thead class="main-bg-color">
				<tr class="color-header" height="22">
					<th><cf_get_lang dictionary_id='35947.Belge Adı'></th>
					<th width="50"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_add_asset&action_id=#action_id#&action_section=#action_section#&module_id=4&asset_cat_id=-9&module=member<cfif isdefined('attributes.is_file_upload_size')>&is_file_upload_size=#attributes.is_file_upload_size#</cfif></cfoutput>','small')"><img src="/images/pod_add.gif" title="" border="0" align="absmiddle"></a></th>
				</tr>
			</thead>
			<tbody>
				<cfoutput query="get_member_asset">
					<tr class="color-list">
						<td><a href="javascript:" onClick="windowopen('../../V16/documents/#module_name#/#asset_file_name#','small')" title="" class="tableyazi">#asset_name#</a></td>
						<td  style="text-align:right;">
							<cfif record_par eq action_id>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_upd_asset&asset_id=#asset_id#<cfif isdefined('attributes.is_file_upload_size')>&is_file_upload_size=#attributes.is_file_upload_size#</cfif>','small')"><img src="images/pod_edit.gif" title="<cf_get_lang_main no ='52.Güncelle'>" border="0"></a>
							</cfif>
						</td>
					</tr>
				</cfoutput>
			</tbody>
		</table>
	</div>
</cf_box>