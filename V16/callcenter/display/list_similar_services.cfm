<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfinclude template="../query/get_similar_services.cfm">
<cfinclude template="../query/get_priority.cfm">
<cfinclude template="../query/get_service_appcat.cfm">
<cfparam name="attributes.totalrecords" default=#GET_SIMILAR_SERVICES.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('call',123)#" draggable="1" closable="1">
		<cfform name="search" action="#request.self#?fuseaction=call.popup_list_similar_services" method="post">
			<cf_box_search more="0">
				<div class="form-group" id="item-keyword">
					<cfinput type="text" name="keyword" style="width:200px;" placeholder="#getLang('main',48)#" value="#URLDecode(attributes.keyword)#" maxlength="255">
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cfif isdefined("attributes.id") and len(attributes.id)>
						<input type="hidden" value="<cfoutput>#attributes.id#</cfoutput>" name="id" id="id">
					</cfif>
				</div>
			</cf_box_search>
		</cfform>
		<cf_flat_list>
			<thead>
				<tr>
					<th><cf_get_lang no='112.Başvuru'></th>
					<th width="90"><cf_get_lang_main no='74.Kategori'></th>
					<th width="100"><cf_get_lang_main no='330.Tarih'></th>
				</tr>
			</thead>
			<cfif get_similar_services.recordcount>
				<tbody>
					<cfoutput query="get_similar_services">
						<tr>
							<td><a href="#request.self#?fuseaction=call.popup_detail_similar_service&service_id=#service_ID#" class="tableyazi"><font color="#COLOR#">#service_HEAD#</font></a> </td>
							<td>#serviceCAT#</td>
							<td>#dateformat(APPLY_DATE,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,APPLY_DATE),timeformat_style)#</td>
						</tr>
					</cfoutput>
				</tbody>
			<cfelse>
				<tr>
					<td td colspan="3"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
				</tr>
			</cfif>
		</cf_flat_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cf_paging page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="call.popup_list_similar_services&keyword=#attributes.keyword#"> 
		</cfif>
	</cf_box>
</div>