<cfsetting showdebugoutput="true">
<cfscript>
enums = createObject("component","addons.devonomy.gdpr.cfc.enums");
types = enums.get_classification_types();

cfparam(name="attributes.keyword",default="");
cfparam(name="attributes.classification_type_id",default="1");
cfparam(name="attributes.page",default="1");
cfparam(name="attributes.totalrecords",default="0");
cfparam(name="attributes.maxrows",default="#session.ep.maxrows#");

attributes.startrow=((attributes.page-1)*attributes.maxrows)+1

if (isdefined("attributes.form_submitted")){
	classitication_comp = createObject("component","addons.devonomy.gdpr.cfc.classification");
	classitication_comp.dsn = dsn;
	classitication_data = classitication_comp.get_classification(
		data_officer_id:'#attributes.data_officer_id#',
		keyword: '#attributes.keyword#',
		classification_type_id: '#attributes.classification_type_id#'
	);
}else{
	classitication_data.recordcount = 0;
}
</cfscript>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform name="category" action="#request.self#?fuseaction=#url.fuseaction#&data_officer_id=#attributes.data_officer_id#">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1" />
			<input type="hidden" name="data_officer_id" id="data_officer_id" value="<cfoutput>#attributes.data_officer_id#</cfoutput>" />
			<cf_box_search>
				<cfoutput>
					<div class="form-group">
						<input type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('main',48)#">
					</div>
					<div class="form-group x-12">
						<select id="classification_type_id" name="classification_type_id">
							<cfloop index="st" array="#types#">
								<option VALUE="#st.value#" <cfif attributes.classification_type_id eq st.value>selected</cfif>>#st.name#</option>
							</cfloop>
						</select>
					</div>
					<div class="form-group small">
						<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4">
					</div>
					<div class="form-group" id="form_ul_data_explorer">
						<a class="ui-btn ui-btn-gray2" href="<cfoutput>#request.self#?fuseaction=#url.fuseaction#&event=explorer&data_officer_id=#attributes.data_officer_id#</cfoutput>">Data Explorer DB</a>						
					</div>
				</cfoutput>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Veri Sınıflandırma',61765)#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang_main no='1165.Sıra'></th> 
					<th><cf_get_lang dictionary_id='61769.Sınıflandırma Tipi'></th>
					<th><cf_get_lang dictionary_id='61729.Veri Kategorisi'></th>
					<th><cf_get_lang dictionary_id='270.Güvenlik Seviyesi'></th>
					<cfif attributes.classification_type_id eq 1>
						<th><cf_get_lang dictionary_id='42215.Veri Tabanı'></th>
						<th><cf_get_lang dictionary_id='33591.Schema'></th>
						<th><cf_get_lang dictionary_id='38752.Tablo'></th>
						<th><cf_get_lang dictionary_id='43058.Kolon'></th>
					<cfelse>
						<th><cf_get_lang dictionary_id='49955.Dosya Yolu'></th>
					</cfif>
					<th><cf_get_lang dictionary_id='36199.Açıklama'></th>
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
				<cfif classitication_data.recordcount>
					<!--- <cfset attributes.totalrecords = gdpr_data.query_count>	 --->
					<cfoutput query="classitication_data">
						<tr>
							<td width="35">#currentrow#</td>
							<td>#types[ArrayFind(types, function(struct){ return struct.value == CLASSIFICATION_TYPE_ID;} )]["name"]#</td>
							<td>#DATA_CATEGORY#</td>
							<td>#SENSITIVITY_LABEL#</td>
							<cfif attributes.classification_type_id eq 1>
								<td>#DB_NAME#</td>
								<td>#SCHEMA_NAME#</td>
								<td>#TABLE_NAME#</td>
								<td>#COLUMN_NAME#</td>
							<cfelse>
								<td>#FILE_PATH#</td>
							</cfif>
							<td>#CLASSIFICATION_DESCRIPTION#</td>
							<!-- sil -->
							<td width="35"><a href="#request.self#?fuseaction=#url.fuseaction#&event=upd&id=#CLASSIFICATION_ID#&data_officer_id=#attributes.data_officer_id#" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
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