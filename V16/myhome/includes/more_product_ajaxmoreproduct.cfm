<cfsetting showdebugoutput="no">
<cfset attributes.gt_ =1>
<cfset attributes.maxrows=10>
<cfinclude template="get_product_stock_strategy.cfm">
<cf_flat_list>
	<cfif get_strategy.recordcount>
		<thead>
			<cfset stock_id_list_=valuelist(GET_STRATEGY.STOCK_ID)>
			<cfquery name="get_sales" datasource="#dsn2#">
				SELECT SUM(SATIS) AS TOTAL_SALE,STOCK_ID FROM STOCKS_SALES WHERE STOCK_ID IN (#stock_id_list_#) GROUP BY STOCK_ID ORDER BY STOCK_ID
			</cfquery>
			<cfset new_stock_id_list_=listsort(valuelist(get_sales.STOCK_ID),'numeric','asc')>
			<tr>
				<th><cf_get_lang_main no="245.ürün"></th>
				<th style="text-align:right;"><cf_get_lang_main no="36.satış"></th>
				<th style="text-align:right;"><cf_get_lang_main no="40.stok"></th>
			</tr>
		</thead>
		<tbody>
			<cfoutput query="get_strategy" maxrows="#attributes.maxrows#">
				<tr>
					<td><a href="#request.self#?fuseaction=product.list_product&event=det&pid=#get_strategy.product_id#" class="tableyazi">#get_strategy.product_name# #get_strategy.property#</a></td>
					<td style="text-align:right;" title="<cf_get_lang_main no='36.Satış'><cf_get_lang_main no='223.Miktar'>"><cfif len(get_sales.TOTAL_SALE[listfind(new_stock_id_list_,STOCK_ID,',')])>#TLFormat(get_sales.TOTAL_SALE[listfind(new_stock_id_list_,STOCK_ID,',')])#<cfelse>-</cfif></td>
					<td style="text-align:right;" title="<cf_get_lang_main no='40.Stok'><cf_get_lang_main no='223.Miktar'>">#TLFormat(get_strategy.product_total_stock)# #main_unit#</td>
				</tr>
			</cfoutput>
		</tbody>
	<cfelse>
		<tbody>
			<tr>
				<td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</tbody>
    </cfif>
</cf_flat_list>

