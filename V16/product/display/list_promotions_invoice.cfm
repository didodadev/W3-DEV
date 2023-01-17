<!--- Promosyon tarihi araliginda promosyon kullanilarak faturada ne kadar islem yapilmis oldugunu veren rapor musteri bazinda Senay 20060516 --->
<cfquery name="get_promotions" datasource="#dsn3#">
	SELECT PROM_HEAD,STARTDATE,FINISHDATE FROM PROMOTIONS WHERE PROM_ID = #attributes.prom_id# 
</cfquery>
<cfquery name="get_list" datasource="#dsn2#">
	SELECT
		COUNT(I.INVOICE_ID) ADET,
		SUM(IR.AMOUNT*IR.PRICE) CIRO,
		SUM(IR.COST_PRICE) COST_PRICE,
		SUM(IR.EXTRA_COST) EXTRA_COST,
		SUM(IR.AMOUNT) AMOUNT,
		IR.NAME_PRODUCT,
		I.COMPANY_ID,
		I.CONSUMER_ID
	FROM 
		INVOICE_ROW IR,
		INVOICE I
	WHERE
		IR.INVOICE_ID = I.INVOICE_ID AND
		IR.PROM_ID = #attributes.prom_id# AND 
		I.INVOICE_DATE BETWEEN #createodbcdate(get_promotions.startdate)# AND #createodbcdate(get_promotions.finishdate)#
	GROUP BY
		I.COMPANY_ID,
		I.CONSUMER_ID,
		IR.NAME_PRODUCT
</cfquery>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default="#get_list.recordcount#">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='37590.Tarihler Arasındaki Fatura Hareketleri'></cfsavecontent>
<cf_box title="#message# : #get_promotions.prom_head#" popup_box="1">
	<cf_grid_list>
		<thead>
			<tr>
				<th width="70" height="25"><cf_get_lang dictionary_id='37591.İşlem Adedi'></th>
				<th><cf_get_lang dictionary_id='57635.Miktar'></th>
				<th width="90"><cf_get_lang dictionary_id='30010.Ciro'></th>
				<th width="75"><cf_get_lang dictionary_id='37358.Net Maliyet'></th>
				<th width="75"><cf_get_lang dictionary_id='37183.Ek Maliyet'></th>
				<th width="125"><cf_get_lang dictionary_id='57657.Ürün'></th>
				<th width="100"><cf_get_lang dictionary_id='57457.Müşteri'></th>
			</tr>
		</thead>
		<tbody>
			<cfset company_id_list = ''>
			<cfset consumer_id_list = ''>
			<cfoutput query="get_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(company_id) and not listfind(company_id_list,company_id)>
					<cfset company_id_list = listappend(company_id_list,company_id,',')>
				</cfif>
				<cfif len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
					<cfset consumer_id_list = listappend(consumer_id_list,consumer_id,',')>
				</cfif>	
			</cfoutput>
			<cfif len(company_id_list)>
				<cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
				<cfquery name="GET_COMPANY" datasource="#DSN#">
					SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
				</cfquery>
			</cfif>
			<cfif len(consumer_id_list)>
				<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
				<cfquery name="GET_CONSUMER" datasource="#DSN#">
					SELECT CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
				</cfquery>
			</cfif>
			<cfoutput query="get_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#adet#</td>
					<td style="text-align:right;">#amountformat(amount)#</td>
					<td style="text-align:right;">#TLFormat(ciro)#</td>
					<td style="text-align:right;">#TLFormat(cost_price)#</td>
					<td style="text-align:right;">#TLFormat(extra_cost)#</td>
					<td>#name_product#</td>
					<td>
						<cfif len(company_id)>#get_company.fullname[listfind(company_id_list,company_id,',')]#</cfif>
						<cfif len(consumer_id)>#get_consumer.consumer_name[listfind(consumer_id_list,consumer_id,',')]# #get_consumer.consumer_surname[listfind(consumer_id_list,consumer_id,',')]#</cfif>
					</td>
				</tr>
			</cfoutput>
		</tbody>
	</cf_grid_list>
<cf_box_footer>
<cfif attributes.totalrecords gt attributes.maxrows>
	<table width="98%">
		<tr>
			<td>
				<cfset adres="product.popup_list_promotions_invoice&prom_id=#attributes.prom_id#">
				<cf_pages page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="#adres#"> 
			</td>
			<td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57492.toplam'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
		</tr>
	</table>
</cfif>
</cf_box_footer>
</cf_box>

