<cfparam name="attributes.status" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset url_str="keyword=#attributes.keyword#&status=#attributes.status#">
<cfinclude template="../query/get_payment_lists.cfm">
<!--- <cfdump var=#get_requests#> --->
<cfif get_requests.recordcount eq 0><cfset get_requests = { recordcount : 0 }></cfif>
<cfif get_other_requests.recordcount eq 0><cfset get_other_requests = { recordcount : 0 }></cfif>
<cfif get_reserve_requests.recordcount eq 0><cfset get_reserve_requests = { recordcount : 0 }></cfif>
<cfif get_reserve_other_requests.recordcount eq 0><cfset get_reserve_other_requests = { recordcount : 0 }></cfif>
<cfif get_info_requests.recordcount eq 0><cfset get_info_requests = { recordcount : 0 }></cfif>
<cfparam name="attributes.totalrecords" default="#get_requests.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfsavecontent  variable="message"><cf_get_lang dictionary_id="30826.avans taleplerim">
</cfsavecontent>
<div class="row">
<cf_box id="payment1" title="#message#" add_href="#request.self#?fuseaction=myhome.form_add_payment_request&event=add&is_installment=1" closable="0">
	<cf_ajax_list>
		<thead>
			<tr>
				<th width="15"><cf_get_lang dictionary_id='58577.Sıra'></th>
				<th><cf_get_lang dictionary_id='57480.Konu'></th>
				<th width="210" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
				<th width="210" style="text-align:center;"><cf_get_lang dictionary_id='57756.Durum'></th>
				<th width="210" style="text-align:center;"><cf_get_lang dictionary_id='57742.Tarih'></th>
				<th width="20" class="header_icn_none">
					<a  href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.form_add_payment_request&event=add&&is_installment=1" target="_blank"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='30827.Avans Talebi Ekle'>"></i></a>
				</th>
			</tr>
		</thead>
		<tbody>
			<cfif get_requests.recordcount>
				<cfif not isdefined("attributes.page")>
					<cfset attributes.page=1>
				</cfif>
				<cfoutput query="get_requests" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif fusebox.circuit eq 'myhome'>
						<cfset ID_ = contentEncryptingandDecodingAES(isEncode:1,content:ID,accountKey:'wrk')>
						<cfelse>
						<cfset ID_ = ID>
					</cfif>
					<tr>
						<td>#currentrow#</td>
						<cfif not (len(valid_1) or len(valid_2) or len(status))>
							<td><a href="#request.self#?fuseaction=myhome.form_add_payment_request&event=upd&id=#ID_#"target="_blank" >#subject#</a></td>
						<cfelse>
							<td><a href="#request.self#?fuseaction=myhome.form_add_payment_request&event=upd&id=#ID_#" target="_blank">#subject#</a></td>
						</cfif>
						<td style="text-align:right;">#TLFormat(amount)# #money#</td>
						<td style="text-align:center;">
							<cfif status eq 1>
							<cf_get_lang dictionary_id='57616.Onaylı'>
						<cfelseif status eq 0>
							<cf_get_lang dictionary_id='57617.Reddedildi'>
						<cfelse>
							<cf_get_lang dictionary_id='31112.Bekliyor'>
						</cfif>
						</td>
						<td style="text-align:center;">#dateformat(duedate,dateformat_style)#</td>
						<!-- sil -->
						<cfif  not (len(valid_1) or len(valid_2) or len(status))>
							<td><a href="#request.self#?fuseaction=myhome.form_add_payment_request&event=upd&id=#ID_#" target="_blank"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
						<cfelseif  (len(valid_1) or len(valid_2) or len(status))>
							<td><a href="#request.self#?fuseaction=myhome.form_add_payment_request&event=upd&id=#ID_#" target="_blank"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
						<cfelse>

						</cfif>
						<!-- sil -->
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="7"><cfif not isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'></cfif></td>
				</tr>
			</cfif>
		</tbody>
	</cf_ajax_list>
</cf_box>
</div>
<cfsavecontent  variable="message"><cf_get_lang dictionary_id="31478.Taksitli Avans Taleplerim">
</cfsavecontent>
<cf_box title="#message#" add_href="#request.self#?fuseaction=myhome.form_add_payment_request&event=add&is_installment=2" closable="0">
	<cf_ajax_list>
		<thead>
			<tr>
				<th width="15"><cf_get_lang dictionary_id='58577.Sıra'></th>
				<th><cf_get_lang dictionary_id='57480.Konu'></th>
				<th width="210" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
				<th width="210" style="text-align:center;"><cf_get_lang dictionary_id='57756.Durum'></th>
				<th width="210" style="text-align:center;"><cf_get_lang dictionary_id='57742.Tarih'></th>
				<!-- sil -->
				<th width="20" class="header_icn_none">		 
				<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.form_add_payment_request&event=add&&is_installment=2" target="_blank"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57981.Taksitli'><cf_get_lang dictionary_id='30827.Avans Talebi Ekle'>"></i></a></th>
				<!-- sil -->
			</tr>
		</thead>
		<tbody>
			<cfif get_other_requests.recordcount>
				<cfoutput query="get_other_requests" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif fusebox.circuit eq 'myhome'>
						<cfset SPGR_ID_ = contentEncryptingandDecodingAES(isEncode:1,content:SPGR_ID,accountKey:'wrk')>
					<cfelse>
						<cfset SPGR_ID_ = SPGR_ID>
					</cfif>
					<tr>
						<td>#currentrow#</td>
						<cfif  not (len(valid_1) or len(valid_2) or len(is_valid))>
							<td><a href="javascript://"  onClick="openBoxDraggable('#request.self#?fuseaction=myhome.popupform_upd_other_payment_request&id=#SPGR_ID_#','','ui-draggable-box-medium');">#detail#</a></td>
						<cfelse>
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popupform_upd_other_payment_request_valid&id=#SPGR_ID_#','small');">#detail#</a></td>
						</cfif>
						<td  style="text-align:right;">#TLFormat(AMOUNT_GET)# #session.ep.money#</td>
						<td  style="text-align:center;">
							<cfif is_valid eq 1>
								<cf_get_lang dictionary_id='57616.Onaylı'>
							<cfelseif is_valid eq 0>
								<cf_get_lang dictionary_id='57617.Reddedildi'>
							<cfelse>
								<cf_get_lang dictionary_id='31112.Bekliyor'>
							</cfif>
						</td>
						<td style="text-align:center;">#dateformat(record_date,dateformat_style)#</td>
						<!-- sil -->
						<td>
							<cfif  not (len(valid_1) or len(valid_2) or len(is_valid))>
								<a href="javascript://"  onClick="openBoxDraggable('#request.self#?fuseaction=myhome.popupform_upd_other_payment_request&id=#SPGR_ID_#','','ui-draggable-box-medium');" ><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
							<cfelse>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popupform_upd_other_payment_request_valid&id=#SPGR_ID_#','small');" ><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
							</cfif>
						</td>
						<!-- sil -->
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="7"><cfif not isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'></cfif></td>
				</tr>
			</cfif>
		</tbody>
	</cf_ajax_list>
</cf_box>
