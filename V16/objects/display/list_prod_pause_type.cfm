<!--- Duraklama Tipleri icin... --->
<cfparam name="attributes.keyword" default=''>
<cfif isdefined("attributes.is_submitted")>
	<cfquery name="get_pause_type" datasource="#dsn3#">
		SELECT
		 	SPPT.PROD_PAUSE_TYPE_ID,
			SPPT.PROD_PAUSE_TYPE_CODE,
			SPPT.PROD_PAUSE_TYPE,
			SPPC.IS_WORKING_TIME 
		FROM 
			SETUP_PROD_PAUSE_TYPE SPPT,
			SETUP_PROD_PAUSE_CAT SPPC,
			SETUP_PROD_PAUSE_TYPE_ROW SPPTR
		WHERE
			SPPT.PROD_PAUSE_CAT_ID = SPPC.PROD_PAUSE_CAT_ID AND
			SPPT.PROD_PAUSE_TYPE_ID=SPPTR.PROD_PAUSE_TYPE_ID AND
			SPPTR.PROD_PAUSE_PRODUCTCAT_ID IN (#Product_cat_List#)
			<cfif isdefined("attributes.status") and attributes.status eq 0>
				AND SPPT.IS_ACTIVE = 0
			<cfelseif isdefined("attributes.status") and attributes.status eq 1>				
				AND SPPT.IS_ACTIVE = 1
			<cfelse>
				AND SPPT.IS_ACTIVE IN (0,1)
			</cfif>
			<cfif  len(attributes.keyword)>
				AND (SPPT.PROD_PAUSE_TYPE_CODE LIKE '%#attributes.keyword#%' OR 
					 SPPT.PROD_PAUSE_TYPE LIKE '%#attributes.keyword#%')
			</cfif>
		ORDER BY
			SPPT.PROD_PAUSE_TYPE_CODE
	</cfquery>
<cfelse>
	<cfset get_pause_type.recordcount=0>
</cfif>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_pause_type.recordcount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1 >
<cfset url_string = "">
<cfif isdefined("attributes.is_submitted")>
	<cfset url_string = "#url_string#&is_submitted=#attributes.is_submitted#">
</cfif>
<cfif isdefined("attributes.product_cat_list")>
	<cfset url_string = "#url_string#&product_cat_list=#attributes.product_cat_list#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.field_time")>
	<cfset url_string = "#url_string#&field_time=#attributes.field_time#">
</cfif>
<cfif isdefined("attributes.field_status")>
	<cfset url_string = "#url_string#&field_status=#attributes.field_status#">
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='33198.Duraklama Tipleri'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#message#">
		<cfform name="search_pause_type" method="post" action="#request.self#?fuseaction=objects.popup_list_prod_pause_type&#url_string#">
			<input name="is_submitted" id="is_submitted" type="hidden" value="1">
			<cf_box_search more="0">
					<div class="form-group">
						<cfsavecontent variable="mess"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
						<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" style="width:100px;" placeholder="#mess#">
					</div>
					<div class="form-group">
						<select name="status" id="status" style="width:50px;">
							<option value="1" <cfif isdefined("attributes.status") and attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
							<option value="0" <cfif isdefined("attributes.status") and attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
							<option value="2" <cfif isdefined("attributes.status") and attributes.status eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
						</select>			
					</div>
					<div class="form-group small">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
					</div>
					<div class="form-group"><cf_wrk_search_button button_type="4"></div>
			</cf_box_search>
		</cfform>
		<cf_grid_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id="58577.Sıra"></th>
					<th><cf_get_lang dictionary_id="33196.Duraklama Kodu"></th>
					<th><cf_get_lang dictionary_id="33197.Duraklama Tipi"></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_pause_type.recordcount>
					<cfoutput query="get_pause_type" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td width="30">#currentrow#</td>
							<td>#prod_pause_type_code#</td>
							<td><a href="javascript://" onclick="gonder('#prod_pause_type_id#','#prod_pause_type#','#is_working_time#');">#prod_pause_type#</a></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="3"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id="57484.Kayıt Yok">!<cfelse><cf_get_lang dictionary_id="57701.Filtre Ediniz">!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.maxrows lt attributes.totalrecords>
			<cfset url_string2=attributes.fuseaction>
			<cfif len(attributes.keyword)>
				<cfset url_string2 = "#url_string2#&keyword=#attributes.keyword#">
			</cfif>
			<cfif isdefined("attributes.is_submitted")>
				<cfset url_string2 = "#url_string2#&is_submitted=#attributes.is_submitted#">
			</cfif>
			<cfif len(url_string)>
				<cfset url_string2 = "#url_string2#&#url_string#">
			</cfif>
			<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#url_string2#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
document.getElementById('keyword').focus();
function gonder(field_id,field_name,field_time)
{
	<cfoutput>
		<cfif isDefined("attributes.field_id")>
			window.opener.document.#attributes.field_id#.value = field_id;
		</cfif>
		<cfif isDefined("attributes.field_name")>
			window.opener.document.#attributes.field_name#.value = field_name;
		</cfif>
		<cfif isDefined("attributes.field_time")>
			window.opener.document.#attributes.field_time#.value = field_time;
		</cfif>
		<cfif isDefined("attributes.field_status")>
			if(field_time == 1)
				window.opener.document.#attributes.field_status#.value = 'Dahil';
			else
				window.opener.document.#attributes.field_status#.value = 'Değil';
		</cfif>
	</cfoutput>
	window.close();
}
</script>
