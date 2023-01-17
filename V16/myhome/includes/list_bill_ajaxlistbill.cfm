<cfsetting showdebugoutput="no">
<cfset attributes.purchase=0>
<cfset attributes.maxrows=10>
<cfinclude template="get_bill.cfm">
<cf_flat_list>
	<tbody>
		<cfif get_bill.recordcount>
			<cfparam name="attributes.page" default=1>
			<cfparam name="attributes.totalrecords" default=#get_bill.recordcount#>
			<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
			<cfoutput query="get_bill" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td width="10%">
						<cfif invoice_cat eq 65>
							<a href="#request.self#?fuseaction=invent.add_invent_purchase&event=upd&invoice_id=#get_bill.invoice_id#" class="tableyazi">#GET_BILL.INVOICE_NUMBER#</a>
						<cfelse>
							<a href="#request.self#?fuseaction=invoice.form_add_bill_purchase&event=upd&iid=#get_bill.invoice_id#" class="tableyazi">#GET_BILL.INVOICE_NUMBER#</a>
						</cfif>
					</td>
					<td width="45%">
						<cfif len(GET_BILL.PARTNER_ID)>
							#get_par_info(GET_BILL.PARTNER_ID,0,0,1)#
						<cfelseif len(GET_BILL.COMPANY_ID)>
							#get_par_info(GET_BILL.COMPANY_ID,1,1,1)# 
						<cfelse>
							#get_cons_info(GET_BILL.CONSUMER_ID,1,1)#
						</cfif>
					</td>
					<td width="40%" style="text-align:right;">#TLFormat(get_bill.NETTOTAL)# #session.ep.money#</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_flat_list>

