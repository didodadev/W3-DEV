<cfinclude template="../query/get_sales_prod_discount_detail.cfm">
<cfinclude template="../query/get_paymethods.cfm">
<thead>
	<tr>
		<th><cf_get_lang dictionary_id='57457.Müşteri'></th>
		<th><cf_get_lang dictionary_id='58964.Fiyat Listesi'></th>
		<th><cf_get_lang dictionary_id='37235.Geçerlilik'></th>
		<th colspan="5"><cf_get_lang dictionary_id='57641.İskonto'></th>
		<th><cf_get_lang dictionary_id='37451.Teslim'><cf_get_lang dictionary_id='57490.Gün'></th>
		<th><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></th>
		<th width="20"><i class="fa fa-pencil"></i></th>
	</tr>
</thead>
<tbody>
	<cfset C_S_PROD_DISCOUNT_ID_LIST = ValueList(get_sales_prod_discount_detail.C_S_PROD_DISCOUNT_ID,',')>
	<cfif listlen(C_S_PROD_DISCOUNT_ID_LIST)>
		<cfquery name="GET_PRODUCT_SALES_DISCOUNT_PRICE_CAT_ALL" datasource="#dsn3#">
			SELECT
				CSPPL.PRICE_CAT_ID,
				CSPPL.C_S_PROD_DISCOUNT_ID,
				(SELECT PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT.PRICE_CATID = CSPPL.PRICE_CAT_ID) AS PRICE_CAT
			FROM 
				CONTRACT_SALES_PROD_PRICE_LIST CSPPL
			WHERE  
				C_S_PROD_DISCOUNT_ID IN (#C_S_PROD_DISCOUNT_ID_LIST#)
		</cfquery>
		<cfset price_cat_id_list = ValueList(GET_PRODUCT_SALES_DISCOUNT_PRICE_CAT_ALL.PRICE_CAT_ID,',')>
		<cfset price_cat_id_list = listdeleteduplicates(price_cat_id_list)>
	</cfif>	
	<cfoutput query="get_sales_prod_discount_detail">
		<cfset _C_S_PROD_DISCOUNT_ID_ = C_S_PROD_DISCOUNT_ID>
		<tr>
			<td>
				<cfif ListLen(ListSort(company_id,'numeric')) is 1>
					<cfset attributes.company_id = ListFirst(ListSort(company_id,'numeric'))>
					<cfinclude template="../query/get_company_name.cfm">
				<cfif get_company_name.recordCount>
					#get_company_name.nickname#
				</cfif>
				<cfelseif Len(company_id)>
					<cfset attributes.company_id = company_id>
					<cfinclude template="../query/get_company_name.cfm">
				<cfif get_company_name.recordCount>
					#get_company_name.nickname#
				</cfif>
				</cfif>
			</td>
			<td>
				<cfset 'price_cat_id_list_#C_S_PROD_DISCOUNT_ID#_' = ''>
				<cfif isdefined('GET_PRODUCT_SALES_DISCOUNT_PRICE_CAT_ALL')>
					<cfloop query="GET_PRODUCT_SALES_DISCOUNT_PRICE_CAT_ALL">
						<cfif _C_S_PROD_DISCOUNT_ID_ eq C_S_PROD_DISCOUNT_ID>
							<cfset 'price_cat_id_list_#C_S_PROD_DISCOUNT_ID#_' =  ListAppend(Evaluate('price_cat_id_list_#C_S_PROD_DISCOUNT_ID#_'),PRICE_CAT_ID,',')>
							<li>#price_cat#<br/> 
						</cfif>
					</cfloop>
				</cfif>
			</td>
			<td>
				<cfif len(start_date)>
					#dateformat(start_date,dateformat_style)# <cfif len(finish_date)>- #dateformat(finish_date,dateformat_style)#</cfif>
				<cfelseif DateFormat(start_date,dateformat_style) neq '01/01/1900'>
					#DateFormat(start_date,dateformat_style)# - #DateFormat(finish_date,dateformat_style)#
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
					<cfif paymethod_idpaymethod_id is get_paymethods.paymethod_id>
						#get_paymethods.paymethod#
					</cfif>
				</cfloop>
			</td>
			<cfif len(start_date)>
				<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=product.popup_upd_purchase_sales_condition&discount_id=#C_S_PROD_DISCOUNT_ID#&pid=#attributes.pid#&type=2&price_cat_id_list=#Evaluate('price_cat_id_list_#C_S_PROD_DISCOUNT_ID#_')#','project');"><i class="fa fa-pencil"></i></a></td>
			<cfelse>
				<td></td>
			</cfif>				
		</tr>
	</cfoutput>
</tbody>
