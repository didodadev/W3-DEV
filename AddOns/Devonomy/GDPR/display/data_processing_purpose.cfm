<cfscript>
	enums = createObject("component","addons.devonomy.gdpr.cfc.enums");
	status = enums.get_status();
	cfparam(name="attributes.keyword",default="");
	cfparam(name="attributes.page",default="1");
	cfparam(name="attributes.is_active",default="True");
 	cfparam(name="attributes.totalrecords",default="0");
	cfparam(name="attributes.maxrows",default="#session.ep.maxrows#");
	cfparam(name="attributes.form_submitted",default="1");
	attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;

	if (isdefined("attributes.form_submitted"))
{
	gdpr_comp = createObject("component","addons.devonomy.gdpr.cfc.data_processing_purpose");
	gdpr_data = gdpr_comp.get_data_processing_purpose(
		keyword: '#attributes.keyword#',
		is_active: '#attributes.is_active#'
	);
}else{
	gdpr_data.recordcount = 0;
}
</cfscript>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform name="processingpurposeform" action="#request.self#?fuseaction=#url.fuseaction#">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1" />
			<cf_box_search more="0">
				<cfoutput>
					<div class="form-group">
						<input type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('','Filtre',57460)#">
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
	<cf_box title="#getLang('','Data Processing Purpose',61739)#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.S??ra'></th> 
					<th><cf_get_lang dictionary_id='61739.Veri ????leme Amac??'></th>
					<th><cf_get_lang dictionary_id='36199.A????klama'></th>
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
				<cfif gdpr_data.recordcount>
					<cfset attributes.totalrecords = gdpr_data.recordcount>
					<cfoutput query="gdpr_data">
						<tr>
							<td width="35">#currentrow#</td>
							<td>#DATA_PROCESSING_PURPOSE#</td>
							<td>#DATA_PROCESSING_PURPOSE_DESCRIPTION#</td>
							<td>#status[ArrayFind(status, function(struct){ return struct.value == gdpr_data.IS_ACTIVE;} )]["name"]#</td>
							<!-- sil -->
							<td width="35"><a href="#request.self#?fuseaction=#url.fuseaction#&event=upd&id=#DATA_PROCESSING_PURPOSE_ID#" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.G??ncelle'>"></a></td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="16">
							<cfif not isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id='57484.Kay??t Yok'> !</cfif>
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
