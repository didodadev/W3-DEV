<cfquery name="GET_MAL_HIZMET_PURCHASE_dovizli" datasource="#dsn2#">
	SELECT 
		SUM(OTHER_MONEY_GROSS_TOTAL) AS TOTAL
	FROM 
		INVOICE I,
		INVOICE_ROW IR
	WHERE 
		I.INVOICE_ID = IR.INVOICE_ID AND
		COMPANY_ID = #ATTRIBUTES.COMPANY_ID# AND
		I.PURCHASE_SALES = 0 AND
		INVOICE_CAT IN (59,60,64,65)
</cfquery>
<cfquery name="GET_MAL_HIZMET_SALE_dovizli" datasource="#dsn2#">
	SELECT 
		SUM(OTHER_MONEY_GROSS_TOTAL) AS TOTAL
	FROM 
		INVOICE I,
		INVOICE_ROW IR
	WHERE 
		I.INVOICE_ID = IR.INVOICE_ID AND
		COMPANY_ID = #ATTRIBUTES.COMPANY_ID# AND
		I.PURCHASE_SALES = 1 AND
		INVOICE_CAT IN (52,53,56)
</cfquery>
<cfquery name="GET_FIYAT_FARK_PURCHASE_dovizli" datasource="#dsn2#">
	SELECT 
		SUM(OTHER_MONEY_GROSS_TOTAL) AS TOTAL
	FROM 
		INVOICE I,
		INVOICE_ROW IR
	WHERE 
		I.INVOICE_ID = IR.INVOICE_ID AND
		COMPANY_ID = #ATTRIBUTES.COMPANY_ID# AND
		I.PURCHASE_SALES = 0 AND
		INVOICE_CAT IN (63)
</cfquery>
<cfquery name="GET_FIYAT_FARK_SALE_dovizli" datasource="#dsn2#">
	SELECT 
		SUM(OTHER_MONEY_GROSS_TOTAL) AS TOTAL
	FROM 
		INVOICE I,
		INVOICE_ROW IR
	WHERE 
		I.INVOICE_ID = IR.INVOICE_ID AND
		COMPANY_ID = #ATTRIBUTES.COMPANY_ID# AND
		I.PURCHASE_SALES = 1 AND
		INVOICE_CAT IN (58)
</cfquery>
<cfquery name="GET_ISKONTO_PURCHASE_dovizli" datasource="#dsn2#">
	SELECT 
		SUM(IR.OTHER_MONEY_GROSS_TOTAL-(IR.PRICE_OTHER/10000000000)*(100 - IR.DISCOUNT1)*(100 - IR.DISCOUNT2)*(100 - DISCOUNT3)*(100 - IR.DISCOUNT4)*(100 - IR.DISCOUNT5)) AS TOTAL
	FROM 
		INVOICE I,
		INVOICE_ROW IR
	WHERE 
		I.INVOICE_ID = IR.INVOICE_ID AND
		COMPANY_ID = #ATTRIBUTES.COMPANY_ID# AND
		I.PURCHASE_SALES = 0 AND
		INVOICE_CAT IN (51,54,55,59,60,61,63,64) AND
		IR.PRICE_OTHER IS NOT NULL AND
		IR.DISCOUNT1 IS NOT NULL AND
		IR.DISCOUNT2 IS NOT NULL AND
		IR.DISCOUNT3 IS NOT NULL AND
		IR.DISCOUNT4 IS NOT NULL AND
		IR.DISCOUNT5 IS NOT NULL
</cfquery>
<cfquery name="GET_ISKONTO_SALE_dovizli" datasource="#dsn2#">
	SELECT 
		SUM(IR.OTHER_MONEY_GROSS_TOTAL-(IR.PRICE_OTHER/10000000000)*(100 - IR.DISCOUNT1)*(100 - IR.DISCOUNT2)*(100 - DISCOUNT3)*(100 - IR.DISCOUNT4)*(100 - IR.DISCOUNT5)) AS TOTAL
	FROM 
		INVOICE I,
		INVOICE_ROW IR
	WHERE 
		I.INVOICE_ID = IR.INVOICE_ID AND
		COMPANY_ID = #ATTRIBUTES.COMPANY_ID# AND
		I.PURCHASE_SALES = 1 AND
		INVOICE_CAT IN (50,52,53,56,57,58,62) AND
		IR.PRICE_OTHER IS NOT NULL AND
		IR.DISCOUNT1 IS NOT NULL AND
		IR.DISCOUNT2 IS NOT NULL AND
		IR.DISCOUNT3 IS NOT NULL AND
		IR.DISCOUNT4 IS NOT NULL AND
		IR.DISCOUNT5 IS NOT NULL
</cfquery>
<cfquery name="GET_IADE_PURCHASE_dovizli" datasource="#dsn2#">
	SELECT 
		SUM(OTHER_MONEY_GROSS_TOTAL) AS TOTAL
	FROM 
		INVOICE I,
		INVOICE_ROW IR
	WHERE 
		I.INVOICE_ID = IR.INVOICE_ID AND
		COMPANY_ID = #ATTRIBUTES.COMPANY_ID# AND
		I.PURCHASE_SALES = 0 AND
		INVOICE_CAT IN (54,55)
</cfquery>
<cfquery name="GET_IADE_SALE_dovizli" datasource="#dsn2#">
	SELECT 
		SUM(OTHER_MONEY_GROSS_TOTAL) AS TOTAL
	FROM 
		INVOICE I,
		INVOICE_ROW IR
	WHERE 
		I.INVOICE_ID = IR.INVOICE_ID AND
		COMPANY_ID = #ATTRIBUTES.COMPANY_ID# AND
		I.PURCHASE_SALES = 1 AND
		INVOICE_CAT IN (62)
</cfquery>

<cfoutput>
<table width="99%" align="center">
  <tr class="color-list">
	<td colspan="3" class="txtbold"><cf_get_lang dictionary_id='57796.Dövizli'></td>
  </tr>
  <tr class="color-list">
	<td width="146" class="txtboldblue"><cf_get_lang dictionary_id='58917.Faturalar'></td>
	<td width="166" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='57448.Satış'></td>
	<td width="166" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='58176.Alış'></td>
  </tr>
  <tr class="color-list">
	<td><cf_get_lang dictionary_id='33047.Mal ve Hizmetler'></td>
	<td  style="text-align:right;">#TLFormat(GET_MAL_HIZMET_PURCHASE_dovizli.TOTAL)# #session.ep.money#</td>
	<td  style="text-align:right;">#TLFormat(GET_MAL_HIZMET_SALE_dovizli.TOTAL)# #session.ep.money#</td>
  </tr>
  <tr class="color-list">
	<td><cf_get_lang dictionary_id='33048.İskontolar'></td>
	<td  style="text-align:right;">#TLFormat(GET_ISKONTO_PURCHASE_dovizli.TOTAL)# #session.ep.money#</td>
	<td  style="text-align:right;">#TLFormat(GET_ISKONTO_SALE_dovizli.TOTAL)# #session.ep.money#</td>
  </tr>
  <tr class="color-list">
	<td><cf_get_lang dictionary_id='33049.İadeler'></td>
	<td  style="text-align:right;">#TLFormat(GET_IADE_PURCHASE_dovizli.TOTAL)# #session.ep.money#</td>
	<td  style="text-align:right;">#TLFormat(GET_IADE_SALE_dovizli.TOTAL)# #session.ep.money#</td>
  </tr>
  <tr class="color-list">
	<td><cf_get_lang dictionary_id='33050.Fiyat Farkları'></td>
	<td  style="text-align:right;">#TLFormat(GET_FIYAT_FARK_PURCHASE_dovizli.TOTAL)# #session.ep.money#</td>
	<td  style="text-align:right;">#TLFormat(GET_FIYAT_FARK_SALE_dovizli.TOTAL)# #session.ep.money#</td>
  </tr>
  <cfset total_purchase = iif(IsNumeric(GET_MAL_HIZMET_PURCHASE_dovizli.TOTAL),GET_MAL_HIZMET_PURCHASE_dovizli.TOTAL,0) + iif(IsNumeric(GET_FIYAT_FARK_PURCHASE_dovizli.TOTAL),GET_FIYAT_FARK_PURCHASE_dovizli.TOTAL,0) - iif(IsNumeric(GET_ISKONTO_PURCHASE_dovizli.TOTAL),GET_ISKONTO_PURCHASE_dovizli.TOTAL,0) - iif(IsNumeric(GET_IADE_PURCHASE_dovizli.TOTAL),GET_IADE_PURCHASE_dovizli.TOTAL,0)>
  <cfset total_sales = iif(IsNumeric(GET_MAL_HIZMET_SALE_dovizli.TOTAL),GET_MAL_HIZMET_SALE_dovizli.TOTAL,0) + iif(IsNumeric(GET_FIYAT_FARK_SALE_dovizli.TOTAL),GET_FIYAT_FARK_SALE_dovizli.TOTAL,0) - iif(IsNumeric(GET_ISKONTO_SALE_dovizli.TOTAL),GET_ISKONTO_SALE_dovizli.TOTAL,0) - iif(IsNumeric(GET_IADE_SALE_dovizli.TOTAL),GET_IADE_SALE_dovizli.TOTAL,0)>
  <tr class="color-list">
	<td class="txtboldblue"><cf_get_lang dictionary_id='57492.Toplam'></td>
	<td  class="txtboldblue" style="text-align:right;">#TLFormat(total_purchase)# #session.ep.money#</td>
	<td  class="txtboldblue" style="text-align:right;">#TLFormat(total_sales)# #session.ep.money#</td>
  </tr>
  <cfset total_purchase_sales_diff = total_purchase - total_sales>
  <tr class="color-list">
	<td class="txtboldblue"><cf_get_lang dictionary_id='33051.Alış Satış Farkı'></td>
		<cfif total_purchase_sales_diff gte 0>
		<td  class="txtboldblue" style="text-align:right;">#TLFormat(total_purchase_sales_diff)# #session.ep.money#</td>
		<td  class="txtboldblue" style="text-align:right;">&nbsp;</td>
		<cfelse>
		<td  class="txtboldblue" style="text-align:right;">&nbsp;</td>
		<td  class="txtboldblue" style="text-align:right;">#TLFormat(total_purchase_sales_diff)# #session.ep.money#</td>
		</cfif>
  </tr>
</table>
</cfoutput>
