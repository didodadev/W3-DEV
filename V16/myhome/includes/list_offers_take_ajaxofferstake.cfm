<!--- Alinan Teklifler --->
<cfsetting showdebugoutput="no">

<cfset control_purchase_sales = 0>
<cfset control_offer_zone = 0>
<cfinclude template="get_offer_list.cfm">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="20">
<cfparam name="attributes.totalrecords" default="#get_offer_list.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_flat_list>
<cfif get_offer_list.recordcount>
	<thead>
		<tr>
			<th style="width:70px;"><cf_get_lang_main no="75.No"></th>
			<th><cf_get_lang_main no="107.Cari Hesap"></th>
			<th style="text-align:right;width:125px;"><cfoutput>#session.ep.money#</cfoutput></th>
			<th style="text-align:right;width:125px;"><cf_get_lang_main no="265.Döviz"></th>
		</tr>
	</thead>
	<tbody>
		<cfset total_nettotal_ = 0>
		<cfoutput query="get_offer_list" startrow="#attributes.startrow#" maxrows="#session.ep.maxrows#">
			<tr>
				<td><a href="#request.self#?fuseaction=purchase.list_offer&event=upd&offer_id=#offer_id#" class="tableyazi">#offer_number#</a></td>
				<td><cfif Len(consumer_id)>
						<cfset attributes.consumer_id = consumer_id>
						<cfinclude template="get_consumer_name.cfm">
						#get_consumer_name.company# - <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#attributes.consumer_id#','medium');" class="tableyazi">#get_consumer_name.consumer_name# #get_consumer_name.consumer_surname#</a>
					<cfelseif len(partner_id)>
						<cfset attributes.partner_id = partner_id>
						<cfinclude template="get_partner_name.cfm">
						<a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_partner_name.company_id#','medium');">#get_partner_name.NICKNAME#</a> - 
						<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#attributes.partner_id#','medium');" class="tableyazi">#get_partner_name.COMPANY_PARTNER_NAME# #get_partner_name.COMPANY_PARTNER_SURNAME#</a>
					</cfif>
				</td>
				<td style="text-align:right;">#TLFormat(get_offer_list.price)# #session.ep.money#</td>
				<td style="text-align:right;">#TLFormat(get_offer_list.other_money_value)# #other_money#</td>
				<cfset total_nettotal_ = total_nettotal_ + get_offer_list.price>
			</tr>
		</cfoutput>
	</tbody>
	<tfoot>
		<tr class="txtbold">
			<td colspan="2" style="text-align:right"><cf_get_lang_main no='80.Toplam'></td>
			<td style="text-align:right"><cfoutput>#TLFormat(total_nettotal_)# #session.ep.money#</cfoutput></td>
			<td style="text-align:right">&nbsp;</td>
		</tr>
	</tfoot>
	<cfelse>
	<tbody>
		<tr>
			<td><cf_get_lang_main no='72.Kayıt Yok'>!</td>
		</tr>
	</tbody>
</cfif>
</cf_flat_list>
<!--- 
<cf_ajax_list>
	<tbody>
		<cfif get_offer_list.recordcount>
			<cfoutput query="get_offer_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td width="30%"><a href="#request.self#?fuseaction=purchase.detail_offer_ptv&OFFER_ID=#offer_id#" class="tableyazi">#offer_number#</a></td>
					<td>
						<cfif LEN(GET_OFFER_LIST.PARTNER_ID)>
						<cfquery name="GET_RESP" datasource="#dsn#">
						SELECT 
							COMPANY_PARTNER.COMPANY_PARTNER_NAME,
							COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
							COMPANY.NICKNAME,
							COMPANY.COMPANY_ID
						FROM 
							COMPANY_PARTNER,
							COMPANY
						WHERE 
							COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
							COMPANY_PARTNER.PARTNER_ID = #GET_OFFER_LIST.PARTNER_ID#
						</cfquery>
						<a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_resp.company_id#','medium');">#get_resp.nickname#</a> - 
						<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#GET_OFFER_LIST.PARTNER_ID#','medium');" class="tableyazi">#get_resp.company_partner_name#&nbsp;#get_resp.company_partner_surname#</a>
						</cfif>
					</td>
					<td width="65">#dateformat(RECORD_DATE,dateformat_style)#</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_ajax_list>
 --->
