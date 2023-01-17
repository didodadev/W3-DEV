<cfquery name="get_invoice_products" datasource="#dsn2#">
	SELECT 
		INVOICE_ROW.NAME_PRODUCT,
		INVOICE_ROW.EXTRA_COST,
		INVOICE_ROW.PRODUCT_ID,
		INVOICE_ROW.AMOUNT,
		INVOICE_ROW.INVOICE_ROW_ID,
		INVOICE.INVOICE_DATE
	FROM 
		INVOICE_ROW,
		INVOICE
	WHERE 
		INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID AND
		INVOICE_ROW.INVOICE_ID = #attributes.iid#
	ORDER BY
		INVOICE_ROW.INVOICE_ROW_ID
</cfquery>
<cfquery name="get_products_cost" datasource="#dsn1#">
	SELECT DISTINCT
		PC.PRODUCT_COST_ID,
		PCR.ACTION_ID,
		PCR.AMOUNT,
		PC.PRODUCT_ID
	FROM 
		PRODUCT_COST PC,
		#dsn2_alias#.PRODUCT_COST_REFERENCE PCR,
		#dsn2_alias#.INVOICE_ROW IR
	WHERE 
		PC.PRODUCT_COST_ID = PCR.PRODUCT_COST_ID AND
		IR.INVOICE_ID = PCR.ACTION_ID AND
		IR.INVOICE_ID = #attributes.iid# AND
		PC.ACTION_TYPE = 1 AND	<!--- 1: FATURA; 2: ÜRETİM ÇIKIŞI --->	
		PCR.ACTION_TYPE = 1 	<!--- 1: FATURA; 2: ÜRETİM ÇIKIŞI --->				
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="58133.Fatura No"> : <cf_get_lang dictionary_id="57020.Ürün Ek Maliyetleri"></cfsavecontent>
<cf_popup_box title="#message#">
<cf_medium_list>
	<thead>
		<tr>
			<th width="30"><cf_get_lang dictionary_id="57487.No"></th>
			<th><cf_get_lang dictionary_id="57657.Ürün"></th>
			<th><cf_get_lang dictionary_id="57635.Miktar"></th>
			<th><cf_get_lang dictionary_id="58258.Maliyet"> <cf_get_lang dictionary_id="58527.ID"></th>
			<th width="100" style="text-align:right;"><cf_get_lang dictionary_id="57175.Ek Maliyet"></th>
			<th width="15"></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_invoice_products.recordcount>
			<cfoutput query="get_invoice_products">
				<cfquery dbtype="query" name="get_p_cost">
					SELECT * FROM get_products_cost WHERE PRODUCT_ID = #PRODUCT_ID#
				</cfquery>
				<cfif get_p_cost.recordcount>
				<cfloop query="get_p_cost">
					<tr>
						<td>#get_invoice_products.currentrow#</td>			  
						<td>#get_invoice_products.NAME_PRODUCT[get_invoice_products.currentrow]#</td>
						<td>#get_p_cost.AMOUNT#</td>
						<td>#get_p_cost.PRODUCT_COST_ID#</td>
						<td style="text-align:right;">#tlformat(get_invoice_products.EXTRA_COST[get_invoice_products.currentrow],4)#</td>
						<td width="15" align="center">
							<cfif not get_p_cost.recordcount>
								<cfif not listfindnocase(denied_pages,'product.popup_product_cost')>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=product.list_product_cost&event=det&pid=#get_invoice_products.PRODUCT_ID#&act_id=#attributes.iid#&act_type=1&period_id=#session.ep.period_id#&cost_date=#dateformat(get_invoice_products.INVOICE_DATE,dateformat_style)#','wide2');"><img src="/images/plus_list.gif" title="<cf_get_lang dictionary_id='37522.Maliyet Ekle'>" border='0'></a>
								</cfif>
							<cfelse>
								<cfif not listfindnocase(denied_pages,'product.popup_form_upd_product_cost')>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=product.list_product_cost&event=det&pid=#get_invoice_products.PRODUCT_ID#&act_id=#attributes.iid#&act_type=1&period_id=#session.ep.period_id#&cost_date=#dateformat(get_invoice_products.INVOICE_DATE,dateformat_style)#','wide2');windowopen('#request.self#?fuseaction=product.popup_form_upd_product_cost&pcid=#get_p_cost.PRODUCT_COST_ID#','wide');"><img src="/images/update_list.gif" title="<cf_get_lang dictionary_id='37525.Maliyet Güncelle'>" border="0"></a>
								</cfif>
							</cfif>
						</td>
					</tr>
				</cfloop>
				<cfelse>
					<tr>
						<td>#get_invoice_products.currentrow#</td>			  
						<td>#get_invoice_products.NAME_PRODUCT[get_invoice_products.currentrow]#</td>
						<td>#get_invoice_products.AMOUNT[get_invoice_products.currentrow]#</td>
						<td></td>
						<td style="text-align:right;">#tlformat(get_invoice_products.EXTRA_COST[get_invoice_products.currentrow],4)#</td>
						<td width="15" align="center">
						<cfif not get_p_cost.recordcount>
							<cfif not listfindnocase(denied_pages,'product.popup_product_cost')>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=product.list_product_cost&event=det&pid=#get_invoice_products.PRODUCT_ID[get_invoice_products.currentrow]#&act_id=#attributes.iid#&act_type=1&period_id=#session.ep.period_id#&cost_date=#dateformat(get_invoice_products.INVOICE_DATE[get_invoice_products.currentrow],dateformat_style)#','wide2');"><img src="/images/plus_list.gif" title="<cf_get_lang dictionary_id='37522.Maliyet Ekle'>" border='0'></a>
							</cfif>
						<cfelse>
							<cfif not listfindnocase(denied_pages,'product.popup_form_upd_product_cost')>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=product.list_product_cost&event=det&pid=#get_invoice_products.PRODUCT_ID[get_invoice_products.currentrow]#&act_id=#attributes.iid#&act_type=1&period_id=#session.ep.period_id#&cost_date=#dateformat(get_invoice_products.INVOICE_DATE[get_invoice_products.currentrow],dateformat_style)#','wide2');windowopen('#request.self#?fuseaction=product.popup_form_upd_product_cost&pcid=#get_p_cost.PRODUCT_COST_ID#','wide');"><img src="/images/update_list.gif" title="<cf_get_lang dictionary_id='37525.Maliyet Güncelle'>" border="0"></a>
							</cfif>
						</cfif>
						</td>
					</tr>
				</cfif>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
			</tr>
		</cfif>
	</tbody>
	</cf_medium_list>
</cf_popup_box>