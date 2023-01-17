<cfset attributes.purchase=0>
<cfset attributes.maxrows=10>
<cfinclude template="get_bill.cfm">
<table width="98%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
	<tr class="color-list" height="22">
		<td class="txtboldblue">
			<a href="javascript://" onclick="gizle_goster_img('list_bill_img1','list_bill_img2','list_bill_menu');"><img src="/images/listele_down.gif" title="<cf_get_lang no='116.Ayrıntıları Gizle'>" width="12" height="7" border="0" align="absmiddle" id="list_bill_img1" style="display:;cursor:pointer;"></a>
			<a href="javascript://" onclick="gizle_goster_img('list_bill_img1','list_bill_img2','list_bill_menu');"><img src="/images/listele.gif" title="<cf_get_lang no='337.Ayrıntıları Göster'>" width="7" height="12" border="0" align="absmiddle" id="list_bill_img2" style="display:none;cursor:pointer;"></a>
			<cf_get_lang no='117.Bugünkü Alış Faturaları'>
		</td>
	</tr>
	<tr class="color-row" id="list_bill_menu">
		<td>
		<table width="100%" cellspacing="0" cellpadding="0" border="0">
			<cfif get_bill.recordcount>
				<cfparam name="attributes.page" default=1>
				<cfparam name="attributes.totalrecords" default="#get_bill.recordcount#">
				<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
				<cfoutput query="get_bill" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<td width="10%" align="left">
							<cfif len(INVENTORY_ID)>
								<a href="#request.self#?fuseaction=invent.add_invent_purchase&event=upd&id=#get_bill.INVENTORY_ID#" class="tableyazi">#GET_BILL.INVOICE_ID#</a>
							<cfelse>
								<a href="#request.self#?fuseaction=invoice.form_add_bill_purchase&event=upd&iid=#get_bill.invoice_id#" class="tableyazi">#GET_BILL.INVOICE_number#</a>
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
						<td width="40%"  style="text-align:right;">#TLFormat(get_bill.NETTOTAL)# #session.ep.money#</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
				</tr>
			</cfif>
		</table>
		</td>
	</tr>
</table>
<br/>
