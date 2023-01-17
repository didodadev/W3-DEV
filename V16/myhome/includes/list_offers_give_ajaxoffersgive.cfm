
<!--- Verilen Teklifler, Satis Teklifleri --->
<cfsetting showdebugoutput="no">

<cfset control_purchase_sales = 1>
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
			<th style="text-align:right; width:125px;"><cf_get_lang_main no="2227.KDV siz"></th>
			<th style="text-align:right;width:125px;"><cfoutput>#session.ep.money#</cfoutput></th>
			<th style="text-align:right;width:125px;"><cf_get_lang_main no="2227.KDV siz"><cf_get_lang_main no="265.Döviz"></th>
			<th style="text-align:right;width:125px;"><cf_get_lang_main no="265.Döviz"></th>
		</tr>
	</thead>
	<tbody>
		<cfset total_nettotal_ = 0>
		<cfset total_grosstotal_ = 0>
		<cfset kur_ = 0>
		<cfquery name="get_money_type" datasource="#dsn#">
			SELECT DISTINCT MONEY FROM SETUP_MONEY
		</cfquery>
		<cfloop query="get_money_type">
			<cfset 'total_other_money_value_#money#' = 0>
			<cfset 'total_other_money_value_kdvsiz_#money#' = 0>
		</cfloop>
		<cfoutput query="get_offer_list" startrow="#attributes.startrow#" maxrows="#session.ep.maxrows#">
			<tr>
				<td><a href="#request.self#?fuseaction=sales.list_offer&event=upd&offer_id=#offer_id#" class="tableyazi">#offer_number#</a></td>
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
				<td style="text-align:right;">#TLFormat(get_offer_list.price-get_offer_list.taxprice)# #session.ep.money#</td>
				<td style="text-align:right;">#TLFormat(get_offer_list.price)# #session.ep.money#</td>
				<td style="text-align:right;">
					<cfif get_offer_list.other_money_value neq 0>
						<cfset kur_ =  get_offer_list.price/get_offer_list.other_money_value>
					<cfelse>
						<cfset kur_ = 1>
					</cfif>
					#TLFormat(get_offer_list.other_money_value-(get_offer_list.taxprice/kur_))# #other_money#
				</td>
				<td style="text-align:right;">#TLFormat(get_offer_list.other_money_value)# #other_money#</td>
                <cfif len(get_offer_list.price)>
					<cfset total_nettotal_ = total_nettotal_ + get_offer_list.price>
                </cfif>
				<cfset total_grosstotal_ = total_grosstotal_ + (get_offer_list.price-taxprice)>
				<cfset 'total_other_money_value_#other_money#' = evaluate('total_other_money_value_#other_money#') + get_offer_list.other_money_value>
				<cfset 'total_other_money_value_kdvsiz_#other_money#' = evaluate('total_other_money_value_kdvsiz_#other_money#') + get_offer_list.other_money_value-(get_offer_list.taxprice/kur_)>

			</tr>
		</cfoutput>
	</tbody>
	<tfoot>
		<tr>
			<td colspan="2" style="text-align:right"><cf_get_lang_main no='80.Toplam'></td>
			<td style="text-align:right"><cfoutput>#TLFormat(total_grosstotal_)# #session.ep.money#</cfoutput></td>
			<td style="text-align:right"><cfoutput>#TLFormat(total_nettotal_)# #session.ep.money#</cfoutput></td>
			<td style="text-align:right" valign="top">
				<cfoutput query="get_money_type" group="money">
					<cfif evaluate('total_other_money_value_kdvsiz_#money#') gt 0>
						#Tlformat(evaluate('total_other_money_value_kdvsiz_#money#'))# #money#<br/>
					</cfif>
				</cfoutput>
			</td>
			<td style="text-align:right" valign="top">
				<cfoutput query="get_money_type" group="money">
					<cfif evaluate('total_other_money_value_#money#') gt 0>
						#Tlformat(evaluate('total_other_money_value_#money#'))# #money#<br/>
					</cfif>
				</cfoutput>
			</td>		
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