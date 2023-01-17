<!--- Modified by : Halime Gül Şimşek  Operasyon filtresi listeleme sayfası 20122707--->
<cfparam name="attributes.keyword" default=''>
<cf_get_lang_set module_name="prod">
<cfif isdefined("attributes.is_submitted")>
	<cfquery name="get_operation_type" datasource="#dsn3#">
		SELECT
		 	OT.OPERATION_TYPE_ID,
			OT.OPERATION_TYPE,
			OT.OPERATION_CODE
		FROM 
			OPERATION_TYPES OT
		WHERE
			1 = 1
			<cfif isdefined("attributes.status") and attributes.status eq 0>
				AND OT.OPERATION_STATUS = 0
			<cfelseif isdefined("attributes.status") and attributes.status eq 1>				
				AND OT.OPERATION_STATUS = 1
			<cfelse>
				AND OT.OPERATION_STATUS IN (0,1)
			</cfif>
			<cfif  len(attributes.keyword)>
				AND OT.OPERATION_TYPE LIKE '%#attributes.keyword#%'
			</cfif>
		ORDER BY
			OT.OPERATION_TYPE
	</cfquery>
<cfelse>
	<cfset get_operation_type.recordcount=0>
</cfif>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_operation_type.recordcount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1 >
<cfset url_string = "">
<cfif isdefined("attributes.is_submitted")>
	<cfset url_string = "#url_string#&is_submitted=#attributes.is_submitted#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='36451.Operasyon Tipleri'></cfsavecontent>
<cf_medium_list_search title="#message#">
	<cf_medium_list_search_area>
		<table>
			<cfform name="search_operation_type" method="post" action="#request.self#?fuseaction=objects.popup_list_operation_type&#url_string#">
				<input name="is_submitted" id="is_submitted" type="hidden" value="1">
				<tr>
					<td><cf_get_lang dictionary_id='57460.Filtre'>:</td>
					<td><cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" style="width:100px;"></td>
					<td>
						<select name="status" id="status" style="width:50px;">
							<option value="1" <cfif isdefined("attributes.status") and attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
							<option value="0" <cfif isdefined("attributes.status") and attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
							<option value="2" <cfif isdefined("attributes.status") and attributes.status eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
						</select>			
					</td>
					<td>
					  <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					  <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</td>
					<td><cf_wrk_search_button></td>
				</tr>
			</cfform>
		</table>
	</cf_medium_list_search_area>
</cf_medium_list_search>
<cf_medium_list>
	<thead>
		<tr>
			<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
			<th width="150"><cf_get_lang dictionary_id='36377.Operasyon Kodu'></th>
			<th width="150"><cf_get_lang dictionary_id='29419.Operasyon'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_operation_type.recordcount>
			<cfoutput query="get_operation_type" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td width="30">#currentrow#</td>
					<td>#operation_code#</td>
					<td><a href="javascript://" class="tableyazi" onclick="gonder('#operation_type_id#','#operation_type#');">#operation_type#</a></td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="3"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
			</tr>
		</cfif>
	</tbody>
</cf_medium_list>
<cf_popup_box_footer>
	<cfif attributes.maxrows lt attributes.totalrecords>
		<table cellpadding="2" cellspacing="0" border="0" width="98%" align="center">
			<tr height="2" >
				<td>
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
					<cf_pages page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="#url_string2#">
				</td>
				<!-- sil -->
				<td style="text-align:right;"><cfoutput> <cf_get_lang dictionary_id='57540.Toplam Kayit'>:#attributes.totalrecords# - <cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
				<!-- sil -->
			</tr>
		</table>
	</cfif>
</cf_popup_box_footer>
<script type="text/javascript">
document.getElementById('keyword').focus();
function gonder(field_id,field_name)
{
	<cfoutput>
		<cfif isDefined("attributes.field_id")>
			window.opener.document.#attributes.field_id#.value = field_id;
		</cfif>
		<cfif isDefined("attributes.field_name")>
			window.opener.document.#attributes.field_name#.value = field_name;
		</cfif>
	</cfoutput>
	window.close();
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
