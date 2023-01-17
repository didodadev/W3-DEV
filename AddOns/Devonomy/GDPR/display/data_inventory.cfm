<cfsetting showdebugoutput="true">
<cfscript>
enums = createObject("component","addons.devonomy.gdpr.cfc.enums");
status = enums.get_status();
storage_types = enums.get_storage_types();
gdpr_categories = createObject("component","addons.devonomy.gdpr.cfc.data_category").get_data_category();

cfparam(name="attributes.keyword",default="");
cfparam(name="attributes.is_active",default="True");
cfparam(name="attributes.data_category_id",default="0");
cfparam(name="attributes.page",default="1");
cfparam(name="attributes.totalrecords",default="0");
cfparam(name="attributes.maxrows",default="#session.ep.maxrows#");
cfparam(name="attributes.form_submitted",default="1");

attributes.startrow=((attributes.page-1)*attributes.maxrows)+1

if (isdefined("attributes.form_submitted")){
	data_inventory_comp = new addons.devonomy.gdpr.cfc.data_inventory(data_officer_id: attributes.data_officer_id);

	//data_inventory_comp = createObject("component","addons.devonomy.gdpr.cfc.data_inventory");
	data_inventory_data = data_inventory_comp.get_data_inventory(
		keyword: '#attributes.keyword#',
		is_active: attributes.is_active,
		data_category_id: attributes.data_category_id
	);
}else{
	data_inventory_data.recordcount = 0;
}
</cfscript>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform name="data_inventory" action="#request.self#?fuseaction=#url.fuseaction#&data_officer_id=#attributes.data_officer_id#">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1" />
			<input type="hidden" name="data_officer_id" id="data_officer_id" value="<cfoutput>#attributes.data_officer_id#</cfoutput>" />
			<cf_box_search>
				<cfoutput>
					<div class="form-group">
						<div class="input-group x-12">
							<input type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('','Filtre',57460)#">
						</div>
					</div>
					<div class="form-group x-12">
						<select id="data_category_id" name="data_category_id">
							<option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfloop query="gdpr_categories">
								<option value="#data_category_id#" <cfif attributes.data_category_id eq data_category_id>selected</cfif>>#data_category#</option>
							</cfloop>
						</select>
					</div>
					<div class="form-group">
						<select id="is_active" name="is_active">
							<cfloop index="st" array="#status#">
								<option VALUE="#st.value#" <cfif attributes.is_active eq st.value>selected</cfif>>#st.name#</option>
							</cfloop>
						</select>
					</div>
					<div class="form-group small">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4">
					</div>
				</cfoutput>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Veri Envanteri',61755)#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='61755.Veri Envanteri'></th>
					<th><cf_get_lang dictionary_id='61729.Veri Kategorisi'></th>
					<th><cf_get_lang dictionary_id='61737.Veri Konusu Grubu'></th>
					<th><cf_get_lang dictionary_id='61756.Depolama Tipi'></th>
					<th><cf_get_lang dictionary_id='30633.Periyod'></th>
					<th><cf_get_lang dictionary_id='36199.Açıklama'></th>
					<th><cf_get_lang dictionary_id='57756.Durum'></th>			
					<!-- sil -->
					<th width="35">
						<a href="<cfoutput>#request.self#?fuseaction=#url.fuseaction#&event=add&data_officer_id=#attributes.data_officer_id#</cfoutput>" class="tableyazi">
							<i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i>
						</a>
					</th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif data_inventory_data.recordcount>
					<cfset attributes.totalrecords = data_inventory_data.recordcount>
					<cfoutput query="data_inventory_data">
						<tr>
							<td width="35">#currentrow#</td>
							<td>#DATA_INVENTORY#</td>
							<td>#DATA_CATEGORY#</td>
							<td>#DATA_SUBJECT_GROUP#</td>
							<td>#storage_types[ArrayFind(storage_types, function(struct){ return struct.value == data_inventory_data.STORAGE_TYPE;} )]["name"]#</td>
							<td>#PERIOD#</td>
							<td>#DATA_INVENTORY_DESCRIPTION#</td>
							<td>#status[ArrayFind(status, function(struct){ return struct.value == data_inventory_data.IS_ACTIVE;} )]["name"]#</td>
							<!-- sil -->
							<td width="35"><a href="#request.self#?fuseaction=#url.fuseaction#&event=upd&id=#DATA_INVENTORY_ID#&data_officer_id=#attributes.data_officer_id#" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="16">
							<cfif not isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</cfif>
						</td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfscript>
			url_str = attributes.fuseaction;
			if(isDefined('attributes.keyword') and len(attributes.keyword))url_str = url_str&"&keyword="&attributes.keyword;
			if(isDefined('attributes.status') and len(attributes.solution))url_str = url_str&"&status="&attributes.status;
			if(isdefined('form_submitted'))url_str = url_str&"&form_submitted=1";
		</cfscript>
		<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#url_str#">
		</cf_box>
</div>