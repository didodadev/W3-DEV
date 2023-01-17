<cfsetting showdebugoutput="true">
<cfscript>
cfparam(name="attributes.keyword",default="");
cfparam(name="attributes.classification_type_id",default="1");
cfparam(name="attributes.page",default="1");
cfparam(name="attributes.totalrecords",default="0");
cfparam(name="attributes.maxrows",default="#session.ep.maxrows#");

attributes.startrow=((attributes.page-1)*attributes.maxrows)+1

if (isdefined("attributes.form_submitted")){
	type_comp = createObject("component","V16.settings.cfc.subscriptionPaymentPlanImportType");
  types = type_comp.GET_IMPORT_TYPE(keyword:attributes.keyword);
}else{
	types.recordcount = 0;
}
</cfscript>
<cfset contract_cmp = createObject("component","V16.sales.cfc.subscription_contract")>
<cfset gsa = createObject("component","V16.objects.cfc.subscriptionNauthority")/>
<cfset GET_SUBSCRIPTION_AUTHORITY= gsa.SelectAuthority()/>
<cfset GET_SUBSCRIPTION_TYPE = contract_cmp.GET_SUBSCRIPTION_TYPE(dsn3:dsn3,IS_SUBSCRIPTION_AUTHORITY:get_subscription_authority.IS_SUBSCRIPTION_AUTHORITY)>


<cfform name="import_type" action="#request.self#?fuseaction=#url.fuseaction#">
	<input type="hidden" name="form_submitted" id="form_submitted" value="1" />
	<cf_big_list_search title="Ödeme Planı Aktarım Tipleri">
		<cf_big_list_search_area>
			<cfoutput>
				<div class="row form-inline">
					<div class="form-group">
						<div class="input-group x-12">
							<input type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('main',48)#">
						</div>
					</div>
					<div class="form-group">
						<cf_wrk_search_button>
						<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
					</div>
				</div>
			</cfoutput>
		</cf_big_list_search_area>
	</cf_big_list_search>
</cfform>
<cf_big_list>
	<thead>
		<tr>
			<th width="35"><cf_get_lang_main no='1165.Sıra'></th> 
			<th><cf_get_lang dictionary_id='58233.Tanım'></th>
			<th><cf_get_lang_main no ='74.kategori'></th>
			<!-- sil -->
			<th class="header_icn_none">
				<a href="<cfoutput>#request.self#?fuseaction=#url.fuseaction#&event=add</cfoutput>" class="tableyazi">
					<img src="/images/plus_list.gif" title="<cf_get_lang_main no='170.Ekle'>">
				</a>
			</th>
			<!-- sil -->
		</tr>
	</thead>
	<tbody>
		<cfif types.recordcount>
			<cfoutput query="types">
				<tr>
					<td width="35">#currentrow#</td>
					<td>#IMPORT_TYPE_NAME#</td>
					<td>
						<cfif len(SUBSCRIPTION_TYPE_ID)>
							<cfquery name="sub_type_name" dbtype="query">
								SELECT SUBSCRIPTION_TYPE FROM GET_SUBSCRIPTION_TYPE WHERE SUBSCRIPTION_TYPE_ID = #SUBSCRIPTION_TYPE_ID#
							</cfquery>
							#sub_type_name.SUBSCRIPTION_TYPE#
						</cfif>
					</td>
					<!-- sil -->
					<td width="15"><a href="#request.self#?fuseaction=#url.fuseaction#&event=upd&IMPORT_TYPE_ID=#IMPORT_TYPE_ID#" class="tableyazi"><img src="images/update_list.gif" title="<cf_get_lang_main no='52.Güncelle'>"></a></td>
					<!-- sil -->
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="6">
					<cfif not isdefined("attributes.form_submitted")><cf_get_lang_main no='289.Filtre Ediniz'> !<cfelse><cf_get_lang_main no='72.Kayıt Yok'> !</cfif>
				</td>
			</tr>
		</cfif>
	</tbody>
</cf_big_list>