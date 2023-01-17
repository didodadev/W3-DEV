<cfsetting showdebugoutput="no">
<cfinclude template="get_order_list.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default="20">
<cfparam name="attributes.totalrecords" default="#get_order_list.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_flat_list>
	<cfif get_order_list.recordcount>
		<thead>
			<tr>
				<th style="width:70px;"><cf_get_lang_main no="75.no"></th>
				<th><cf_get_lang_main no="107.cari hesap"></th>
				<th style="text-align:right; width:125px;"><cf_get_lang_main no="2227.KDV siz"></th>
				<th style="text-align:right; width:125px;"><cfoutput>#session.ep.money#</cfoutput></th>
				<th style="text-align:right; width:125px;"><cf_get_lang_main no="2227.KDV siz"> <cf_get_lang_main no="265.döviz"></th>
				<th style="text-align:right; width:125px;">2.<cf_get_lang_main no="265.döviz"></th>
			</tr>
		</thead>
		<tbody>
			<cfset total_nettotal_ = 0>
			<cfset total_grosstotal_ = 0>
			<cfset kur_ = 0>
			<cfquery name="GET_MONEY_TYPE" datasource="#DSN#">
				SELECT DISTINCT MONEY FROM SETUP_MONEY
			</cfquery>
			<cfloop query="get_money_type">
				<cfset 'total_other_money_value_#money#' = 0>
				<cfset 'total_other_money_value_kdvsiz_#money#' = 0>
			</cfloop>
			<cfoutput query="get_order_list" startrow="#attributes.startrow#" maxrows="#session.ep.maxrows#">
				<tr>
					<td>
					<cfif len(is_instalment)>
						<a href="#request.self#?fuseaction=sales.upd_fast_sale&order_id=#order_id#" class="tableyazi">#order_number#</a>
					<cfelse>
						<a href="#request.self#?fuseaction=sales.list_order&event=upd&order_id=#order_id#" class="tableyazi">#order_number#</a>
					</cfif>
					</td>
					<!--- Sirketi al --->
					<cfif len(partner_id)>
						<td><a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');">#nickname#</a> - <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#partner_id#','medium');" class="tableyazi">#company_partner_name# #company_partner_surname#</a></td>
					<cfelseif <!---isdefined("company") and---> len(consumer_id)>
						<td><!---#get_consumer_name.company[listfind(consumer_list,consumer_id,',')]# - ---><a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium');" class="tableyazi">#consumer_name# #consumer_surname#</a></td>
					<cfelse>
						<td></td>
					</cfif>
					<td style="text-align:right;">#TLFormat(get_order_list.nettotal-get_order_list.taxtotal)# #session.ep.money#</td>
					<td style="text-align:right;">#TLFormat(get_order_list.nettotal)# #session.ep.money#</td>
					<td style="text-align:right;">
						<cfif get_order_list.other_money_value neq 0 and get_order_list.nettotal neq 0>
							<cfset kur_ =  get_order_list.nettotal/get_order_list.other_money_value>
						<cfelse>
							<cfset kur_ = 1>
						</cfif>
						#TLFormat(get_order_list.other_money_value-(get_order_list.taxtotal/kur_))# #other_money#
					</td>
					<td style="text-align:right;">#TLFormat(get_order_list.other_money_value)# #other_money#</td>
					<cfset total_nettotal_ = total_nettotal_ + get_order_list.nettotal>
					<cfset total_grosstotal_ = total_grosstotal_ + get_order_list.nettotal-get_order_list.taxtotal>
					<cfset 'total_other_money_value_#other_money#' = evaluate('total_other_money_value_#other_money#') + get_order_list.other_money_value>
					<cfset 'total_other_money_value_kdvsiz_#other_money#' = evaluate('total_other_money_value_kdvsiz_#other_money#') + get_order_list.other_money_value-(get_order_list.taxtotal/kur_)>
				</tr>
			</cfoutput>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="2" style="text-align:right" valign="top"><cf_get_lang_main no='80.Toplam'></td>
					<td style="text-align:right" valign="top"><cfoutput>#TLFormat(total_grosstotal_)# #session.ep.money#</cfoutput></td>
					<td style="text-align:right" valign="top"><cfoutput>#TLFormat(total_nettotal_)# #session.ep.money#</cfoutput></td>
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
				<td><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
			</tr>
		</tbody>
	</cfif>
</cf_flat_list>