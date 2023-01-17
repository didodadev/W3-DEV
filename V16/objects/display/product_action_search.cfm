<cfparam name="attributes.date_1" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.date_2" default="#dateformat(now(),dateformat_style)#">
<cfif isdefined('attributes.pid') and len(attributes.pid)>
	<cfquery name="GET_PRODUCT_NAME" datasource="#DSN3#">
		SELECT PRODUCT_ID, PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID = #attributes.pid#
	</cfquery>
	<cfset attributes.product_name = get_product_name.product_name>
	<cfset attributes.product_id = get_product_name.product_id>
</cfif>
<cfif len(attributes.product_id) and len(attributes.product_name)>
	<cfif len(attributes.date_1)><cf_date tarih='attributes.date_1'></cfif>
	<cfif len(attributes.date_2)><cf_date tarih='attributes.date_2'></cfif>
	<cfquery name="GET_CATALOG_PRODUCT" datasource="#dsn3#" maxrows="#session.ep.maxrows#">
		SELECT 
			CATALOG_PROMOTION_PRODUCTS.*,
			CATALOG.STARTDATE,
			CATALOG.FINISHDATE,
			CATALOG.KONDUSYON_DATE,
			CATALOG.KONDUSYON_FINISH_DATE,
			CATALOG.CAT_PROM_NO,
			CATALOG.IS_APPLIED
		FROM 
			CATALOG_PROMOTION_PRODUCTS  AS CATALOG_PROMOTION_PRODUCTS,
			CATALOG_PROMOTION AS CATALOG
		WHERE	
			CATALOG_PROMOTION_PRODUCTS.PRODUCT_ID = #attributes.pid# AND
			CATALOG.CATALOG_ID = CATALOG_PROMOTION_PRODUCTS.CATALOG_ID 
		ORDER BY
			CATALOG.CATALOG_ID DESC
	</cfquery>
	<cfif get_catalog_product.recordcount>
		<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
			SELECT 
				PRICE_CAT.PRICE_CAT,
				CATALOG_PROMOTION.CATALOG_ID
			FROM
				PRICE_CAT,
				CATALOG_PRICE_LISTS,
				CATALOG_PROMOTION,
				CATALOG_PROMOTION_PRODUCTS
			WHERE
				CATALOG_PROMOTION.CATALOG_ID = CATALOG_PROMOTION_PRODUCTS.CATALOG_ID AND
				CATALOG_PROMOTION.CATALOG_ID = CATALOG_PRICE_LISTS.CATALOG_PROMOTION_ID AND
				CATALOG_PRICE_LISTS.PRICE_LIST_ID = PRICE_CAT.PRICE_CATID AND 
				CATALOG_PROMOTION_PRODUCTS.PRODUCT_ID = #attributes.pid#
		</cfquery>
	</cfif>	
		<thead>
			<tr>
				<th colspan="4">&nbsp;</th>
				<th colspan="4" class="text-center"><cf_get_lang dictionary_id='33137.Standart'></th>
				<th colspan="10" class="text-center"><cf_get_lang dictionary_id='33048.İskonto'></th>
				<th colspan="2" class="text-center"><cf_get_lang dictionary_id='58258.Maliyet'></th>
				<th colspan="2" class="text-center"><cf_get_lang dictionary_id='57639.kdv'></th>
				<th colspan="4" class="text-center"><cf_get_lang dictionary_id='33140.Aksiyon Fiyat'></th>
				<th colspan="2">&nbsp;</th>
			</tr>
			<tr>
				<th width="20"><cf_get_lang dictionary_id='57487.No'></th>
				<th style="min-width:75px"><cf_get_lang dictionary_id='42412.Aksiyon No'></th>
				<th style="min-width:120px"><cf_get_lang dictionary_id='33136.Geç Tarihi'><br/><cf_get_lang dictionary_id ='33941.Kondisyon Tarihi'></th>
				<th><cf_get_lang dictionary_id='57636.Birim'></th>
				<th style="min-width:60px"><cf_get_lang dictionary_id='57489.Para Br'></th>
				<th><cf_get_lang dictionary_id='58176.Alış'></th>
				<th><cf_get_lang dictionary_id='57448.satış'></th>
				<th style="min-width:40px"><cf_get_lang dictionary_id='45944.S Mrj'></th>
				<th>1</th>
				<th>2</th>
				<th>3</th>
				<th>4</th>
				<th>5</th>
				<th>6</th>
				<th>7</th>
				<th>8</th>
				<th>9</th>
				<th>10</th>
				<th width="70"><cf_get_lang dictionary_id='58083.Net'></th>
				<th width="70"><cf_get_lang dictionary_id='58716.KDV li'></th>
				<th><cf_get_lang dictionary_id='58176.Alış'></th> 
				<th><cf_get_lang dictionary_id='57448.satış'></th>
				<th style="min-width:40px"><cf_get_lang dictionary_id='33141.A Mrj'></th>
				<th><cf_get_lang dictionary_id='58716.KDV Dahil'></th>
				<th><cf_get_lang dictionary_id='57640.Vade'></th>
				<th style="min-width:50px"><cf_get_lang dictionary_id='33142.Raf Tipi'></th>
				<th><cf_get_lang dictionary_id='57453.Şube'></th>
				<th><cf_get_lang dictionary_id='33940.Fiyat Oluşturuldu'></th>
			</tr>
		</thead>
		<tbody>
			<cfset catalog_id_list = ''>
			<cfset catalog_id_list2 = ''>
			<cfoutput query="get_catalog_product">
				<cfif len(catalog_id) and not listfind(catalog_id_list,catalog_id)>
					<cfset catalog_id_list = listappend(catalog_id_list,catalog_id)>
				</cfif>
			</cfoutput>
			<cfif len(catalog_id_list)>
				<cfquery name="get_catalog" datasource="#dsn3#">
					SELECT DISTINCT CATALOG_ID FROM CATALOG_PROMOTION_PRODUCTS WHERE CATALOG_ID IN (#catalog_id_list#) ORDER BY CATALOG_ID
				</cfquery>
			<cfset catalog_id_list = listsort(listdeleteduplicates(valuelist(get_catalog.catalog_id,',')),'numeric','ASC',',')>
				<cfquery name="get_catalog1" dbtype="query">
					SELECT CATALOG_ID,PRICE_CAT FROM GET_PRICE_CAT WHERE CATALOG_ID IN (#catalog_id_list#) ORDER BY CATALOG_ID
				</cfquery>
			<cfset catalog_id_list2 = listsort(listdeleteduplicates(valuelist(get_catalog1.catalog_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfoutput query="get_catalog_product">
				<tr>
					<td width="20">#currentrow#</td>
					<td><a href="#request.self#?fuseaction=product.form_upd_catalog_promotion&id=#get_catalog.catalog_id[listfind(catalog_id_list,catalog_id,',')]#" target="_blank">#CAT_PROM_NO#</a></td>
					<td>
						#dateformat(startdate,dateformat_style)# - #dateformat(finishdate,dateformat_style)#<br/>
						#dateformat(KONDUSYON_DATE,dateformat_style)# - #dateformat(KONDUSYON_FINISH_DATE,dateformat_style)#
					</td>
					<td>#unit#</td>
					<td>#MONEY#</td>
					<td class="moneybox">#TLFormat(purchase_price,4)#</td>
					<td class="moneybox">#TLFormat(sales_price)#</td>
					<td class="moneybox">#TLFormat(profit_margin)#</td>
					<td class="moneybox">#TLFormat(discount1)#</td>
					<td class="moneybox">#TLFormat(discount2)#</td>
					<td class="moneybox">#TLFormat(discount3)#</td>
					<td class="moneybox">#TLFormat(discount4)#</td>
					<td class="moneybox">#TLFormat(discount5)#</td>
					<td class="moneybox">#TLFormat(discount6)#</td>
					<td class="moneybox">#TLFormat(discount7)#</td>
					<td class="moneybox">#TLFormat(discount8)#</td>
					<td class="moneybox">#TLFormat(discount9)#</td>
					<td class="moneybox">#TLFormat(discount10)#</td>
					<td class="moneybox">#TLFormat(row_nettotal,4)#</td>
					<td class="moneybox">#TLFormat(row_total,4)#</td>
					<td class="moneybox">#TLFormat(tax_purchase,4)#</td>
					<td class="moneybox">#TLFormat(tax)#</td>
					<td class="moneybox">#TLFormat(action_profit_margin)#</td>
					<td class="moneybox">#TLFormat(action_price)#</td>
					<td>#duedate#</td>
					<cfif len(shelf_id)>
						<cfquery name="GET_SHELF_NAME" datasource="#dsn#">
							SELECT SHELF_NAME FROM SHELF WHERE SHELF_MAIN_ID = #shelf_id#
						</cfquery>
					</cfif>
					<td nowrap><cfif len(shelf_id)>#get_shelf_name.shelf_name#</cfif></td>
					<td align="center"><i class="fa fa-building" title="#get_catalog1.price_cat[listfind(catalog_id_list2,catalog_id,',')]#"></td>
					<td><cfif IS_APPLIED is 1><cf_get_lang dictionary_id ='57495.Evet'><cfelse><cf_get_lang dictionary_id ='57496.Hayır'></cfif></td>
				</tr>
			</cfoutput>
		</tbody>
</cfif>
