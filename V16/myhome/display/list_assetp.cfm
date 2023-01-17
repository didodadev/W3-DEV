<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.asset_cat" default="">
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="GET_ASSETP_CATS" datasource="#DSN#">
	SELECT ASSETP_CATID, ASSETP_CAT FROM ASSET_P_CAT ORDER BY ASSETP_CAT
</cfquery>
<cfif isdefined("is_form_submitted")>
	<cfinclude template="../query/get_assetps.cfm">
	<cfparam name='attributes.totalrecords' default="#get_assetps.recordcount#">
<cfelse>
	<cfparam name='attributes.totalrecords' default="0">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='57420.Varlıklar'></cfsavecontent>
<cf_box title="#message#" closable="0" uidrop="1" hide_table_column="1">
<cfform name="search_asset" action="#request.self#?fuseaction=myhome.list_assetp" method="post">
    <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
	<cf_box_search plus="0">
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#message#">
				</div>
				<div class="form-group">
					<select name="asset_cat" id="asset_cat">
						<option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
						<cfoutput query="get_assetp_cats">
							<option value="#assetp_catid#" <cfif attributes.asset_cat eq assetp_catid>selected</cfif>>#assetp_cat#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
	</cf_box_search>
</cfform>
	<cf_flat_list>
		<div class="extra_list">
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='29452.Varlık'></th>
					<th><cf_get_lang dictionary_id='58878.Demirbaş No'></th>
					<th><cf_get_lang dictionary_id='60371.Mekan'></th>
					<th><cf_get_lang dictionary_id='57486.Kategori'></th>
					<th><cf_get_lang dictionary_id='48015.Kayıtlı Departman'></th>
					<th><cf_get_lang dictionary_id='57544.Sorumlu'> 1</th>
					<th><cf_get_lang dictionary_id='57544.Sorumlu'> 2</th>
				</tr>
			</thead>
			<tbody>
				<cfif isdefined("attributes.is_form_submitted") and get_assetps.recordcount>
					<cfoutput query="get_assetps" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td>
								<cfif it_asset neq 1 and motorized_vehicle neq 1>
									<cfif get_module_user(40)>
										<a href="#request.self#?fuseaction=assetcare.list_assetp&event=upd&assetp_id=#assetp_id#" class="tableyazi">#assetp#</a>
									<cfelse>
										#assetp#
									</cfif>                        
								<cfelse>
									<cfif get_module_user(40)>
										<a href="#request.self#?fuseaction=assetcare.list_asset_it&event=upd&assetp_id=#assetp_id#" class="tableyazi">#assetp#</a>
									<cfelse>
										#assetp#
									</cfif>
								</cfif>
							</td>
							<td>#inventory_number#</td>
							<td>#space_name#</td>
							<td>#assetp_cat#</td>
							<td>#zone_name# / #branch_name# / #department_head#</td>
							<td><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');">#employee_name# #employee_surname#</a></td>
							<td>#get_emp_info(position_code2,0,0)#</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td height="20" colspan="10"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
					</tr>
				</cfif>
			</tbody>
		</div>
 	</cf_flat_list>
</cf_box>

<cfinclude  template="../display/list_assetp_demand.cfm"> 

<cfset url_str = "">
<cfif isdefined("attributes.is_form_submitted")>
	<cfset url_str = "#url_str#&is_form_submitted=#attributes.is_form_submitted#">
</cfif>
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.asset_cat)>
	<cfset url_str = "#url_str#&asset_cat=#attributes.asset_cat#">
</cfif>
<cf_paging
	page="#attributes.page#"
	maxrows="#attributes.maxrows#"
	totalrecords="#attributes.totalrecords#"
	startrow="#attributes.startrow#"
	adres="myhome.list_assetp#url_str#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>