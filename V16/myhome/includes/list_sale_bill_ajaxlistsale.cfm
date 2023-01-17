<cfsetting showdebugoutput="no">
<cfset attributes.purchase=1>
<cfinclude template="get_bill.cfm">
<cfparam name="attributes.maxrows" default=20>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default=#get_bill.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_flat_list>
	<thead>
		<tr>
			<th><cf_get_lang_main no="75.no"></th>
			<th><cf_get_lang_main no="107.cari hesap"></th>
			<th style="text-align:right; width:150px;"><cf_get_lang_main no="2227.KDV siz"></th>
			<th style="text-align:right; width:150px;">TL</th>
			<th style="text-align:right; width:150px;"><cf_get_lang_main no="2227.KDV siz"><cf_get_lang_main no="265.döviz"></th>
			<th style="text-align:right; width:150px;"><cf_get_lang_main no="265.döviz"></th>
		</tr>
	</thead>
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
	<tbody>
		<cfoutput query="get_bill" startrow="#attributes.startrow#" maxrows="#session.ep.maxrows#">
			<tr>
				<td width="70">
						<a href="#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#get_bill.invoice_id#" class="tableyazi">#get_bill.invoice_number#</a>
				</td>
				<td>
					<cfif len(GET_BILL.PARTNER_ID)>
						#get_par_info(GET_BILL.PARTNER_ID,0,0,1)#
					<cfelseif len(GET_BILL.COMPANY_ID)>
						#get_par_info(GET_BILL.COMPANY_ID,1,1,1)# 
					<cfelse>
						#get_cons_info(GET_BILL.CONSUMER_ID,1,1)#
					</cfif>					  
				</td>
				<td style="text-align:right; width:150px;">#TLFormat(get_bill.nettotal-get_bill.taxtotal)# #session.ep.money#</td>
				<td style="text-align:right; width:150px;">#TLFormat(get_bill.nettotal)# #session.ep.money#</td>
				<td style="text-align:right; width:150px;">
					<cfif get_bill.other_money_value neq 0>
						<cfset kur_ =  get_bill.nettotal/get_bill.other_money_value>
					<cfelse>
						<cfset kur_ = 1>
					</cfif>
					#TLFormat(get_bill.other_money_value-(get_bill.taxtotal/kur_))# #other_money#
				</td>
				<td style="text-align:right; width:150px;">#TLFormat(get_bill.other_money_value)# #other_money#</td>
			</tr>
			<cfset total_nettotal_ = total_nettotal_ + get_bill.NETTOTAL>
			<cfset total_grosstotal_ = total_grosstotal_ + get_bill.nettotal-get_bill.taxtotal>
			<cfset 'total_other_money_value_#other_money#' = evaluate('total_other_money_value_#other_money#') + get_bill.other_money_value>
			<cfset 'total_other_money_value_kdvsiz_#other_money#' = evaluate('total_other_money_value_kdvsiz_#other_money#') + get_bill.other_money_value-(get_bill.taxtotal/kur_)>
		</cfoutput>
		<cfif get_bill.recordcount>
		<tr>
			<td colspan="2" style="text-align:right" valign="top"><cf_get_lang dictionary_id='57492.Toplam'></td>
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
		</cfif>
		<cfif not get_bill.recordcount>
			<tr>
				<td colspan="8"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_flat_list>

