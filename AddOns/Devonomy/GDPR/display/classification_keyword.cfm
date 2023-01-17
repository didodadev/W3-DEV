<cfscript>
enums = createObject("component","addons.devonomy.gdpr.cfc.enums");
status = enums.get_status();
keyword_types = enums.get_keyword_types();
keyword_search_types = enums.get_keyword_search_types();
gdpr_types = createObject("component","addons.devonomy.gdpr.cfc.data_category");
gdpr_types.dsn = dsn;
data_category = gdpr_types.get_data_category();

cfparam(name="attributes.keyword",default="");
cfparam(name="attributes.is_active",default="True");
cfparam(name="attributes.data_category_id",default="0");
cfparam(name="attributes.keyword_type",default="");
cfparam(name="attributes.page",default="1");
cfparam(name="attributes.totalrecords",default="0");
cfparam(name="attributes.maxrows",default="#session.ep.maxrows#");
cfparam(name="attributes.form_submitted",default="1");


attributes.startrow=((attributes.page-1)*attributes.maxrows)+1

if (isdefined("attributes.form_submitted")){
	keyword_comp = createObject("component","addons.devonomy.gdpr.cfc.classification_keyword");
	keyword_comp.dsn = dsn;
	keyword_data = keyword_comp.get_classification_keyword(
		keyword: '#attributes.keyword#',
		data_category_id: attributes.data_category_id,
		keyword_type : attributes.keyword_type,
		is_active: '#attributes.is_active#'
	);
}else{
	keyword_data.recordcount = 0;
}
</cfscript>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform name="category" action="#request.self#?fuseaction=#url.fuseaction#">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1" />
			<cf_box_search more="0">
				<cfoutput>
						<div class="form-group">
							<input type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('','Filtre',57460)#">
						</div>
						<div class="form-group">
							<select id="data_category_id" name="data_category_id">
								<option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfloop query="data_category">
									<option value="#data_category_id#" <cfif attributes.data_category_id eq data_category_id>selected</cfif>>#data_category# (#DATA_CATEGORY_DESCRIPTION#)</option>
								</cfloop>
							</select>
						</div>
						<div class="form-group">
							<select id="keyword_type" name="keyword_type">
								<option VALUE=""><cf_get_lang dictionary_id='34969.Kelime'><cf_get_lang dictionary_id='30152.Tipi'></option>
								<cfloop index="st" array="#keyword_types#">
									<option VALUE="#st.value#" <cfif attributes.keyword_type eq st.value>selected</cfif>>#st.name#</option>
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
	<cf_box title="#getLang('','Anahtar Kelimeler',35597)#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th> 
					<th><cf_get_lang dictionary_id='34969.Kelime'></th>
					<th><cf_get_lang dictionary_id='61729.Veri Kategorisi'></th>
					<th><cf_get_lang dictionary_id='34969.Kelime'><cf_get_lang dictionary_id='30152.Tipi'></th>
					<th><cf_get_lang dictionary_id='47641.Arama'><cf_get_lang dictionary_id='30152.Tipi'></th>
					<th><cf_get_lang dictionary_id='57756.Durum'></th>
					<!-- sil -->
					<th width="35">
						<a href="<cfoutput>#request.self#?fuseaction=#url.fuseaction#&event=add</cfoutput>" class="tableyazi">
							<i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i>
						</a>
					</th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif keyword_data.recordcount>
					<!--- <cfset attributes.totalrecords = gdpr_data.query_count>	 --->
					<cfoutput query="keyword_data">
						<tr>
							<td width="35">#currentrow#</td>
							<td>#KEYWORD#</td>
							<td>#DATA_CATEGORY# (#DATA_CATEGORY_DESCRIPTION#)</td>
							<td>#keyword_types[ArrayFind(keyword_types, function(struct){ return struct.value == keyword_data.KEYWORD_TYPE;} )]["name"]#</td>
							<td>#keyword_search_types[ArrayFind(keyword_search_types, function(struct){ return struct.value == keyword_data.SEARCH_TYPE;} )]["name"]#</td>
							<td>#status[ArrayFind(status, function(struct){ return struct.value == keyword_data.IS_ACTIVE;} )]["name"]#</td>
							<!-- sil -->
							<td width="35"><a href="#request.self#?fuseaction=#url.fuseaction#&event=upd&id=#keyword_id#" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
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
	</cf_box>
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
</div>