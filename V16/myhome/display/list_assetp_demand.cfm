<cfinclude template="../query/get_assetp_demand.cfm">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='31131.Varlık Taleplerim'></cfsavecontent>
<cf_box title="#message#" closable="0" add_href="openBoxDraggable('#request.self#?fuseaction=myhome.list_assetp&event=add')">
	<cf_ajax_list>
		<div class="extra_list">
			<thead>
				<tr>
					<cfoutput>
						<th width="10"><cf_get_lang dictionary_id='58577.Sıra'></th>
						<th width="150"><cf_get_lang dictionary_id='31186.Varlık Kategorisi'></th>
						<th width="150"><cf_get_lang dictionary_id='30829.Talep Eden'></th>
						<th width="150"><cf_get_lang dictionary_id='31020.Kullanım Amacı'></th>		
						<th width="100"><cf_get_lang dictionary_id='31023.Talep Tarihi'></th>	
						<th width="100"><cf_get_lang dictionary_id='57482.Aşama'></th>
						<th></th>
		<!--- 				<th class="header_icn_none"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popup_add_assetp_demand','list','popup_add_assetp_demand')"><img src="/images/plus_list.gif" title="<cf_get_lang_main no='170.Ekle'>"></a></td>
		 --->			</cfoutput>
				</tr>
			</thead>
			<tbody>
				<cfif get_assetp_demand.recordcount>          
					<cfoutput query="get_assetp_demand">
						<tr>
							<td>#currentrow#</td>
							<td>#assetp_cat#</td>
							<td><a href="javascript://" class="tableyazi" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#');">#employee_name# #employee_surname#</a></td>
							<td>#usage_purpose#</td>
							<td>#dateformat(request_date,dateformat_style)#</td>
							<td>#stage#</td>
							<cfset demand_id_ = demand_id>
							<td width="15" style="text-align:center"><a href="#request.self#?fuseaction=myhome.list_assetp&event=upd&demand_id=#demand_id_#"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="7"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'> !</td>
					</tr>
				</cfif>
			</tbody>
		</div>
	</cf_ajax_list>
</cf_box>

<!--- <cf_box title="#getLang('myhome',693)#" closable="0"> 
	<div class="ListContent">
		<table class="ajax_list">
			<tr>
				<cfoutput>
					<th width="25"><cf_get_lang_main no='1165.Sıra'></th>
					<th width="150"><cf_get_lang no='429.Varlık Kategorisi'></th>
					<th width="150"><cf_get_lang no='72.Talep Eden'></th>
					<th width="150"><cf_get_lang no='263.Kullanım Amacı'></th>		
					<th width="100"><cf_get_lang no='266.Talep Tarihi'></th>	
					<th width="100"><cf_get_lang_main no='70.Aşama'></th>
					<th class="header_icn_none"></th>
				</cfoutput>
			</tr>
			<cfif get_assetp_demand_valid.recordcount>          
				<cfoutput query="get_assetp_demand_valid">
					<tr>
						<td>#currentrow#</td>
						<td>#assetp_cat#</td>
						<td><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium','popup_emp_det');">#employee_name# #employee_surname#</a></td>
						<td>#usage_purpose#</td>
						<td>#dateformat(request_date,dateformat_style)#</td>
						<td>#stage#</td>
						<cfif fusebox.circuit eq 'myhome'>
							<cfset demand_id_ = contentEncryptingandDecodingAES(isEncode:1,content:demand_id,accountKey:'wrk')>
						<cfelse>
							<cfset demand_id_ = demand_id>
						</cfif>
						<td width="15" style="text-align:center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popup_form_upd_assetp_demand&demand_id=#demand_id_#','page','popup_assetp_demand')"><img src="/images/update_list.gif" alt="<cf_get_lang_main no='52.Güncelle'>" title="<cf_get_lang_main no='52.Güncelle'>"></a></td>
					</tr>
				</cfoutput>
				<cfelse>
					<tr>
						<td colspan="7"><cf_get_lang_main no='72.Kayit Bulunamadi'> !</td>
					</tr>
			</cfif>
		</table>
	</div>
</cf_box> --->