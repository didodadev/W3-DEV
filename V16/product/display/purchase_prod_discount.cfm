<cfinclude template="../query/get_purchase_prod_discount_detail.cfm">
<cfinclude template="../query/get_paymethods.cfm">
<thead>
	<tr>
		<th><cf_get_lang dictionary_id='58585.Kod'>-<cf_get_lang dictionary_id='29533.Tedarikçi'></th>
		<th><cf_get_lang dictionary_id='37235.Geçerlilik'></th>
		<th colspan="5"><cf_get_lang dictionary_id='57641.İskonto'></th>
		<th><cf_get_lang dictionary_id='37451.Teslim'> <cf_get_lang dictionary_id='57490.Gün'></th>
		<th><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></th>
		<th width="20"><i class="fa fa-pencil"></i></th>
	</tr>
</thead>
<tbody>
	<cfoutput query="get_purchase_prod_discount_detail">
		<tr>
			<td>
			<cfif listLen(ListSort(company_id,'numeric')) is 1>
				<cfset attributes.company_id = ListFirst(ListSort(company_id,'numeric'))>
				<cfinclude template="../query/get_company_name.cfm">
				<cfif get_company_name.recordCount>#get_company_name.member_code#- #get_company_name.fullname#</cfif>
			<cfelseif len(company_id)>
				<cfset attributes.company_id = company_id>
				<cfinclude template="../query/get_company_name.cfm">
				<cfif get_company_name.recordCount>#get_company_name.member_code#- #get_company_name.fullname#</cfif>
			</cfif>
			</td>
			<td>
				<cfif len(start_date)>
					#dateformat(start_date,dateformat_style)# <cfif len(finish_date)>- #dateformat(finish_date,dateformat_style)#</cfif>
				</cfif>
			</td>
			<td width="20"><cfif len(discount1) and discount1 gt 0>#TLFormat(discount1)#</cfif></td>
			<td width="20"><cfif len(discount2) and discount2 gt 0>#TLFormat(discount2)#</cfif></td>
			<td width="20"><cfif len(discount3) and discount3 gt 0>#TLFormat(discount3)#</cfif></td>
			<td width="20"><cfif len(discount4) and discount4 gt 0>#TLFormat(discount4)#</cfif></td>
			<td width="20"><cfif len(discount5) and discount5 gt 0>#TLFormat(discount5)#</cfif></td>
			<td>#delivery_dateno#</td>
			<td>
				<cfset paymethod_idpaymethod_id = paymethod_id>
				<cfloop query="get_paymethods">
					<cfif paymethod_idpaymethod_id is get_paymethods.paymethod_id>#get_paymethods.paymethod#</cfif>
				</cfloop>
			</td>
			<cfif len(start_date)>
				<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=product.popup_upd_purchase_sales_condition&discount_id=#C_P_PROD_DISCOUNT_ID#&pid=#attributes.pid#&type=1','project');"><i class="fa fa-pencil"></i></a></td>
			<cfelse>
				<td></td>
			</cfif>				
		</tr>
	</cfoutput> 
</tbody>
