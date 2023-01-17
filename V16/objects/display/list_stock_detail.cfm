<cf_xml_page_edit fuseact ="objects.popup_reserved_orders">
<cfsetting showdebugoutput="no">
<cfset body_class = "color-list">
<cfset table_class="color-border">
<cfset tr_class="color-list">
<cfset td_class="txtboldblue">
<cfquery name="get_alternative_stocks" datasource="#dsn3#">
	SELECT 
		SUM(GS.SALEABLE_STOCK) STOCK_AMOUNT,
		S.STOCK_ID,
		S.PRODUCT_NAME,
		S.PRODUCT_ID
	FROM
		ALTERNATIVE_PRODUCTS AP,
		STOCKS S,
		STOCKS S2,
		<cfif attributes.department_id gt 0>
			#dsn2_alias#.GET_STOCK_LAST_LOCATION GS
		<cfelse>
			#dsn2_alias#.GET_STOCK_LAST GS
		</cfif>
	WHERE 
		S.PRODUCT_ID = AP.ALTERNATIVE_PRODUCT_ID AND
		S2.STOCK_ID = #attributes.sid# AND
		AP.STOCK_ID IS NOT NULL AND
		S.STOCK_ID = GS.STOCK_ID AND
		S2.PRODUCT_ID = AP.PRODUCT_ID
		<cfif attributes.department_id gt 0>
			AND GS.DEPARTMENT_ID = #attributes.department_id#
		</cfif>
	GROUP BY
		S.STOCK_ID,
		S.PRODUCT_NAME,
		S.PRODUCT_ID
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='45311.Alternatif Ürünler.'></cfsavecontent>
<cf_box id="list_order_comp_det_#attributes.row_id#" closable="1" title="#message#" style="width:500px; margin-top:10px;">
	<cf_ajax_list>
		<thead width="100%" cellpadding="2" cellspacing="1" class="color-border" align="center">
			<tr>
				<th><cf_get_lang dictionary_id='57487.no'></th>
				<th><cf_get_lang dictionary_id='58221.Ürün'></th>
				<th style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_alternative_stocks.recordcount>
				<cfoutput query="get_alternative_stocks">
					<tr>
						<td>#currentrow#</td>
						<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=stock.list_stock&event=det&pid=#product_id#','wide');" class="tableyazi">#product_name#</a></td>
						<td style="text-align:right;">#numberformat(stock_amount)#</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="11"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</td>
				</tr>
			</cfif>
		</tbody>
	</cf_ajax_list>
</cf_box>
