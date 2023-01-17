<cfscript>
	cfparam(name="attributes.keyword",default="");
	cfparam(name="attributes.page",default="1");
	cfparam(name="attributes.form_submitted",default="1");
/* 	cfparam(name="attributes.totalrecords",default="0");
	cfparam(name="attributes.maxrows",default="#session.ep.maxrows#");
	attributes.startrow=((attributes.page-1)*attributes.maxrows)+1; */

	if (isdefined("attributes.form_submitted"))
{
	gdpr_comp = createObject("component","addons.devonomy.gdpr.cfc.sensitivity_label");
	gdpr_data = gdpr_comp.get_sensitivity_label(
		keyword: '#attributes.keyword#'
	);
}else{
	gdpr_data.recordcount = 0;
}
</cfscript>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform name="categorytype" action="#request.self#?fuseaction=#url.fuseaction#">
			<cf_box_search more="0">
					<cfoutput>
							<div class="form-group">
								<input type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('main',48)#">
							</div>
							<!--- <div class="form-group x-3_5">
								<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
							</div> --->
							<div class="form-group">
								<cf_wrk_search_button button_type="4">
							</div>
					</cfoutput>
				</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Güvenlik Seviyesi',270)#">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th> 
					<th><cf_get_lang dictionary_id='35254.Seviye'></th>
					<th><cf_get_lang dictionary_id='36199.Açıklama'></th>
					<th width="35">
						<a href="<cfoutput>#request.self#?fuseaction=#url.fuseaction#&event=add</cfoutput>" class="tableyazi">
							<i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i>
						</a>
					</th>
				</tr>
			</thead>
			<tbody>
				<cfif gdpr_data.recordcount>
					<!--- <cfset attributes.totalrecords = gdpr_data.query_count>	 --->
					<cfoutput query="gdpr_data">
						<tr>
							<td width="35">#currentrow#</td>
							<td>#SENSITIVITY_LABEL#</td>
							<td>#SENSITIVITY_LABEL_DESCRIPTION#</td>
							<!-- sil -->
							<td width="35"><a href="#request.self#?fuseaction=#url.fuseaction#&event=upd&id=#SENSITIVITY_LABEL_ID#" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
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
</div>
<!---
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
	adres="#url_str#"> --->
