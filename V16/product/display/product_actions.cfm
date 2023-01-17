<cfparam name="attributes.date_1" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.date_2" default="#dateformat(now(),dateformat_style)#">
<cfif isdefined("attributes.pid") and len(attributes.pid)>
	<cfquery name="GET_PRODUCT_NAME" datasource="#DSN3#">
		SELECT PRODUCT_ID, PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
	</cfquery>
	<cfset attributes.product_name = get_product_name.product_name>
	<cfset attributes.product_id = get_product_name.product_id>
</cfif>
<cfif len(attributes.product_id) and len(attributes.product_name)>
	<cfif len(attributes.date_1)><cf_date tarih='attributes.date_1'></cfif>
	<cfif len(attributes.date_2)><cf_date tarih='attributes.date_2'></cfif>
	<cfquery name="GET_CATALOG_PRODUCT" datasource="#DSN3#" maxrows="#session.ep.maxrows#">
		SELECT
			CATALOG_PROMOTION_PRODUCTS.*,
			CATALOG.STARTDATE,
			CATALOG.FINISHDATE,
			CATALOG.KONDUSYON_DATE,
			CATALOG.KONDUSYON_FINISH_DATE,
			CATALOG.IS_APPLIED
		FROM 
			CATALOG_PROMOTION_PRODUCTS,
			CATALOG_PROMOTION CATALOG
		WHERE
			CATALOG_PROMOTION_PRODUCTS.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND
			CATALOG.CATALOG_ID = CATALOG_PROMOTION_PRODUCTS.CATALOG_ID
		ORDER BY
			CATALOG.CATALOG_ID DESC
	</cfquery>
	<thead>			
		<tr>
			<th></th>
			<th></th>
			<th></th>
			<th colspan="4"><cf_get_lang dictionary_id='37227.Standart'></th>
			<th colspan="5"><cf_get_lang dictionary_id='57641.İskonto'></th>
			<th colspan="2" style="text-align:right;"><cf_get_lang dictionary_id='58258.Maliyet'></th>
			<th colspan="2"><cf_get_lang dictionary_id='57639.kdv'></th>
			<th colspan="3"><cf_get_lang dictionary_id='37049.Aksiyon Fiyat'></th>
			<th ></th>
			<th ></th>
		</tr>
		<tr>
			<th><cf_get_lang dictionary_id='57487.No'></th>
			<th><cf_get_lang dictionary_id='58624.Gecerlilik Tarihi'>/<cf_get_lang dictionary_id='37577.Kond Tarihi'></th>
			<th><cf_get_lang dictionary_id='57636.Birim'></th>
			<th width="50"><cf_get_lang dictionary_id='57489.Para Br'></th>
			<th style="text-align:right;"><cf_get_lang dictionary_id='58176.Alış'></th>
			<th style="text-align:right;"><cf_get_lang dictionary_id='57448.satış'></th>
			<th><cf_get_lang dictionary_id='37313.S Mrj'></th>
			<th style="text-align:right;">1</th>
			<th style="text-align:right;">2</th>
			<th style="text-align:right;">3</th>
			<th style="text-align:right;">4</th>
			<th style="text-align:right;">5</th>
			<th width="70" style="text-align:right;"><cf_get_lang dictionary_id='58083.Net'></th>
			<th width="60"style="text-align:right;"><cf_get_lang dictionary_id='58716.KDV li'></th>
			<th style="text-align:right;"><cf_get_lang dictionary_id='58176.Alış'></th> 
			<th><cf_get_lang dictionary_id='57448.satış'></th>
			<th style="text-align:right;"><cf_get_lang dictionary_id='37048.A Mrj'></th>
			<th width="60"style="text-align:right;"><cf_get_lang dictionary_id='37365.KDV Dahil'></th>
			<th style="text-align:right;"><cf_get_lang dictionary_id='57640.Vade'></th>
			<th><cf_get_lang dictionary_id='37110.Raf Tipi'></th>
			<th><cf_get_lang dictionary_id ='37372.Fiyat Yetkisi'></th>
		</tr>
	</thead>
	<tbody>
		<cfoutput query="get_catalog_product">
			<tr>
				<td>#currentrow#</td>
				<td>
					#dateformat(startdate,dateformat_style)# - #dateformat(finishdate,dateformat_style)#<br/>
					#dateformat(kondusyon_date,dateformat_style)# - #dateformat(kondusyon_finish_date,dateformat_style)#
				</td>
				<td>#unit#</td>
				<td>#money#</td>
				<td>#TLFormat(purchase_price,4)#</td>
				<td>#TLFormat(sales_price)#</td>
				<td>#TLFormat(profit_margin)#</td>
				<td>#TLFormat(discount1)#</td>
				<td>#TLFormat(discount2)#</td>
				<td>#TLFormat(discount3)#</td>
				<td>#TLFormat(discount4)#</td>
				<td>#TLFormat(discount5)#</td>
				<td>#TLFormat(row_nettotal,4)#</td>
				<td>#TLFormat(row_total,4)#</td>
				<td>#TLFormat(tax_purchase,4)#</td>
				<td>#TLFormat(tax)#</td>
				<td>#TLFormat(action_profit_margin)#</td>
				<td>#TLFormat(action_price)#</td>
				<td>#duedate#</td>
				<cfif len(shelf_id)>
					<cfquery name="GET_SHELF_NAME" datasource="#DSN#">
						SELECT SHELF_NAME FROM SHELF WHERE SHELF_MAIN_ID = #shelf_id#
					</cfquery>
				</cfif>
				<td><cfif len(shelf_id)>#get_shelf_name.shelf_name#</cfif></td>
				<td><cfif is_applied is 1><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif></td>
			</tr>
		</cfoutput>
	</tbody>
</cfif>
