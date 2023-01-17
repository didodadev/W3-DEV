<cfscript>
cfparam(name="attributes.keyword",default="");
cfparam(name="attributes.form_submitted",default="1");

if (isdefined("attributes.form_submitted")){
	gdpr_comp = createObject("component","addons.devonomy.gdpr.cfc.data_officer");
	gdpr_data = gdpr_comp.get_data_officer(
		keyword: '#attributes.keyword#'
	);

}else{
	gdpr_data.recordcount = 0;
}
</cfscript>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform name="officer" action="#request.self#?fuseaction=#url.fuseaction#">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1" />
			<cf_box_search more="0">
					<cfoutput>
						<div class="form-group">
							<div class="input-group x-12">
								<input type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('','Filtre',57460)#">
							</div>
						</div>
						<div class="form-group">
							<cf_wrk_search_button button_type="4">
						</div>
					</cfoutput>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Veri Sorumluluğu ve Politikalar',65301)#"  uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th> 
					<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
					<th><cf_get_lang dictionary_id='43654.Bağlantı Adı'></th>
					<th><cf_get_lang dictionary_id='36199.Açıklama'></th>
					<th><cf_get_lang dictionary_id='959.Geçerli'><cf_get_lang dictionary_id='29531.Şirketler'></th>
					<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<th><cf_get_lang dictionary_id='47990.Güncelleme Tarihi'></th>
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
				<cfif gdpr_data.recordcount>
					<!--- <cfset attributes.totalrecords = gdpr_data.query_count>	 --->
					<cfoutput query="gdpr_data">
						<tr>
							<td width="35">#currentrow#</td>
							<td>#DATA_OFFICER_NAME#</td>
							<!--- xml durumuna göre --->
							<td>#CONTACT_NAME#</td>
							<td>#data_officer_description#</td>
							<td>
							<cfset get_data_officer = gdpr_comp.get_data_officer_byId(data_officer_id : gdpr_data.data_officer_id)>

								<cfloop from="1" to="#listlen(get_data_officer.our_company_id)#" index="i">
									<cfset get_company_data_officer = gdpr_comp.get_company_data_officer(comp_id : listgetat(get_data_officer.our_company_id,i,','))>
								
									#get_company_data_officer.company_name#<cfif i neq listlen(get_data_officer.our_company_id)>,</cfif>
								</cfloop>
							</td>
							<td>#dateFormat(record_date,dateformat_style)#</td>
							<td>#dateFormat(update_date,dateformat_style)#</td>
							<!-- sil -->
							<td width="35"><a href="#request.self#?fuseaction=#url.fuseaction#&event=det&id=#DATA_OFFICER_ID#" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
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
		</cf_grid_list>
	</cf_box>
</div>