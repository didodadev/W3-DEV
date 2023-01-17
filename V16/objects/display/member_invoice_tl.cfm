<cfquery name="GET_MAL_HIZMET_PURCHASE" datasource="#dsn2#">
	SELECT 
		SUM(GROSSTOTAL) AS TOTAL
	FROM 
		INVOICE
	WHERE 
		COMPANY_ID = #ATTRIBUTES.COMPANY_ID# AND
		PURCHASE_SALES = 0 AND
		INVOICE_CAT IN (59,60,64,65,68,690,691,591,592)
</cfquery>

<cfquery name="GET_MAL_HIZMET_SALE" datasource="#dsn2#">
	SELECT 
		SUM(GROSSTOTAL) AS TOTAL
	FROM 
		INVOICE
	WHERE 
		COMPANY_ID = #ATTRIBUTES.COMPANY_ID# AND
		PURCHASE_SALES = 1 AND
		INVOICE_CAT IN (52,53,56,66,67,531)
</cfquery>

<cfquery name="GET_FIYAT_FARK_PURCHASE" datasource="#dsn2#">
	SELECT 
		SUM(GROSSTOTAL) AS TOTAL
	FROM 
		INVOICE
	WHERE 
		COMPANY_ID = #ATTRIBUTES.COMPANY_ID# AND
		PURCHASE_SALES = 0 AND
		INVOICE_CAT IN (51,63)
</cfquery>
<cfquery name="GET_FIYAT_FARK_SALE" datasource="#dsn2#">
	SELECT 
		SUM(GROSSTOTAL) AS TOTAL
	FROM 
		INVOICE
	WHERE 
		COMPANY_ID = #ATTRIBUTES.COMPANY_ID# AND
		PURCHASE_SALES = 1 AND
		INVOICE_CAT IN (50,58)
</cfquery>
<cfquery name="GET_IADE_PURCHASE" datasource="#dsn2#">
	SELECT 
		SUM(GROSSTOTAL) AS TOTAL
	FROM 
		INVOICE
	WHERE 
		COMPANY_ID = #ATTRIBUTES.COMPANY_ID# AND
		PURCHASE_SALES = 0 AND
		INVOICE_CAT IN (54,55)
</cfquery>
<cfquery name="GET_IADE_SALE" datasource="#dsn2#">
	SELECT 
		SUM(GROSSTOTAL) AS TOTAL
	FROM 
		INVOICE
	WHERE 
		COMPANY_ID = #ATTRIBUTES.COMPANY_ID# AND
		PURCHASE_SALES = 1 AND
		INVOICE_CAT IN (62)
</cfquery>

<cfoutput>
<cf_seperator title="#getLang('','Sistem Para Birimi','33046')#:#session.ep.money#" id="system_currency">
	<cf_flat_list id="system_currency">
		<thead>
			<tr>
				<th width="125" class="bold"><cf_get_lang dictionary_id='58917.Faturalar'> <cf_get_lang dictionary_id="32998.KDV Hariç"></th>
				<th width="140" class="bold" style="text-align:right;"><cf_get_lang dictionary_id='57448.Satış'></th>
				<th width="140" class="bold" style="text-align:right;"><cf_get_lang dictionary_id='58176.Alış'></th>
			</tr>
		</thead>
		<tr>
			<td class="bold"><cf_get_lang dictionary_id='33047.Mal ve Hizmetler'></td>
			<td  style="text-align:right;">#TLFormat(GET_MAL_HIZMET_SALE.TOTAL)# #session.ep.money#</td>
			<td  style="text-align:right;">#TLFormat(GET_MAL_HIZMET_PURCHASE.TOTAL)# #session.ep.money#</td>
		</tr>
		<tr>
			<td class="bold"><cf_get_lang dictionary_id='33049.İadeler'></td>
			<td  style="text-align:right;">#TLFormat(GET_IADE_SALE.TOTAL)# #session.ep.money#</td>
			<td  style="text-align:right;">#TLFormat(GET_IADE_PURCHASE.TOTAL)# #session.ep.money#</td>
		</tr>
		<tr>
			<td class="bold"><cf_get_lang dictionary_id="33000.Fiyat ve Vade Farkları"></td>
			<td  style="text-align:right;">#TLFormat(GET_FIYAT_FARK_SALE.TOTAL)# #session.ep.money#</td>
			<td  style="text-align:right;">#TLFormat(GET_FIYAT_FARK_PURCHASE.TOTAL)# #session.ep.money#</td>
		</tr>
		<cfset total_purchase = iif(IsNumeric(GET_MAL_HIZMET_PURCHASE.TOTAL),GET_MAL_HIZMET_PURCHASE.TOTAL,0) + iif(IsNumeric(GET_FIYAT_FARK_PURCHASE.TOTAL),GET_FIYAT_FARK_PURCHASE.TOTAL,0) -  iif(IsNumeric(GET_IADE_PURCHASE.TOTAL),GET_IADE_PURCHASE.TOTAL,0)>
		<cfset total_sales = iif(IsNumeric(GET_MAL_HIZMET_SALE.TOTAL),GET_MAL_HIZMET_SALE.TOTAL,0) + iif(IsNumeric(GET_FIYAT_FARK_SALE.TOTAL),GET_FIYAT_FARK_SALE.TOTAL,0) -  iif(IsNumeric(GET_IADE_SALE.TOTAL),GET_IADE_SALE.TOTAL,0)>
		<tr>
			<td class="bold"><cf_get_lang dictionary_id='57492.Toplam'></td>
			<td  class="bold" style="text-align:right;">#TLFormat(total_sales)# #session.ep.money#</td>
			<td  class="bold" style="text-align:right;">#TLFormat(total_purchase)# #session.ep.money#</td>
		</tr>
		<cfset total_purchase_sales_diff = total_purchase - total_sales>
		<tr>
			<td class="bold"><cf_get_lang dictionary_id='33051.Alış Satış Farkı'></td>
				<cfif total_purchase_sales_diff gte 0>
				<td  class="bold" style="text-align:right;">&nbsp;</td>
				<td  class="bold" style="text-align:right;">#TLFormat(total_purchase_sales_diff)# #session.ep.money#</td>
				<cfelse>
				<td  class="bold" style="text-align:right;">#TLFormat(total_purchase_sales_diff)# #session.ep.money#</td>
				<td  class="bold" style="text-align:right;">&nbsp;</td>
				</cfif>
		</tr>
	</cf_flat_list>
</cfoutput>
