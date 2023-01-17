<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_code_cat.cfm">
<cfelse>
	<cfset get_code_cat.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_code_cat.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="search_prod_code" action="#request.self#?fuseaction=product.list_prod_code_cat" method="post">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search more="0">
				<div class="form-group">
					<cfinput type="text" name="keyword" id="keyword" placeholder="#getLang('','Filtre',57460)#" value= "#attributes.keyword#" maxlength="255">
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Muhasebe Bütçe Grupları',37502)#" hide_table_column="1" uidrop="1"> 
		<cf_flat_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sira'></th>
					<th><cf_get_lang dictionary_id='58969.Grup Adı'></th>
					<th><cf_get_lang dictionary_id='57482.Aşama'></th>
					<th width="20" class="header_icn_none"><cfoutput><a href="#request.self#?fuseaction=product.list_prod_code_cat&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></cfoutput></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_code_cat.recordcount>
					<cfoutput query="get_code_cat" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td><a href="#request.self#?fuseaction=product.list_prod_code_cat&event=upd&cat_id=#PRO_CODE_CATID#">#PRO_CODE_CAT_NAME#</a></td>
							<td><cfif IS_ACTIVE eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
							<td><a href="#request.self#?fuseaction=product.list_prod_code_cat&event=upd&cat_id=#PRO_CODE_CATID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="10"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filte Ediniz'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfset adres = "">
		<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
			<cfset adres = "#adres#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cfif len(attributes.keyword)>
			<cfset adres = "#adres#&keyword=#attributes.keyword#">
		</cfif>
			
		<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="product.list_prod_code_cat#adres#">
	</cf_box>
</div>
