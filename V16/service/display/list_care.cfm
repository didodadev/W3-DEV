<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_active" default="1">
<cfparam name="attributes.care_type" default="">
<cfparam name="attributes.period_type" default="">
<cfparam name="attributes.product_id" default="">
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_service_care.cfm">
<cfelse>
	<cfset get_service_care.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_service_care.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="form" method="post" action="#request.self#?fuseaction=service.list_care">
			<cf_box_search>
				<cfinput type="hidden" name="form_submitted" id="form_submitted" value="1">
				<div class="form-group">
					<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50" placeholder = "#getLang(48,'Filtre',57460)#">
				</div>
				<div class="form-group" id="item-is_active">
					<select name="is_active" id="is_active">
						<option value="" <cfif attributes.is_active eq "">selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(19,'Bakım Planları',41661)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57480.Başlık'></th>
					<th><cf_get_lang dictionary_id='57657.Ürün'></th>
					<th><cf_get_lang dictionary_id='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id='57637.Seri No'></th>
					<th><cf_get_lang dictionary_id='41753.Bakım Başlangıç Tarihi'></th>
					<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<!-- sil -->
					<cfif not listfindnocase(denied_pages,'service.popup_add_service_care')>
						<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=service.list_care&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					</cfif>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_service_care.recordcount>
					<cfoutput query="get_service_care" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td>#care_description#</td>
							<td><cfif len(product_id)>#PRODUCT_NAME#</cfif></td>
							<td><cfif get_service_care.company_authorized_type is "partner">
									<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#COMPANY_ID#','medium');">#FULLNAME#</a>
								<cfelseif get_service_care.company_authorized_type is "consumer">
									<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#CONSUMER_ID#','medium');">#CONSUMER#</a>
								</cfif>
							</td>
							<td>#serial_no#</td>
							<td>#dateformat(start_date,dateformat_style)#</td>
							<td>#dateformat(record_date,dateformat_style)#</td>
							<!-- sil --><td width="15">
							<cfif not listfindnocase(denied_pages,'service.popup_upd_service_care')>
								<a href="#request.self#?fuseaction=service.list_care&event=upd&id=#product_care_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
							</cfif>
							</td><!-- sil -->
						</tr>
				</cfoutput>
				<cfelse>
					<tr>
						<td colspan="8"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset url_str = "service.list_care">
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.is_active") and len(attributes.is_active)>
			<cfset url_str = "#url_str#&is_active=#attributes.is_active#">
		</cfif>
		<cfif isdefined("attributes.care_type") and len(attributes.care_type)>
			<cfset url_str = "#url_str#&care_type=#attributes.care_type#">
		</cfif>
		<cfif isdefined("attributes.period_type") and len(attributes.period_type)>
			<cfset url_str = "#url_str#&period_type=#attributes.period_type#">
		</cfif>
		<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
			<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cf_paging
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
