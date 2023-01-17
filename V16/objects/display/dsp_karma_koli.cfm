<cfquery name="GET_KARMA_PRODUCT" datasource="#DSN1#">
	SELECT 
		PRODUCT_NAME,
		PRODUCT_AMOUNT
	FROM 
		KARMA_PRODUCTS
	WHERE
		KARMA_PRODUCT_ID = #attributes.pid#
	ORDER BY 
		ENTRY_ID
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='34010.Karma Koli'></cfsavecontent>
<cf_box title="#message#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_grid_list>
		<thead>
			<tr>
				<th width="25" align="center"><cf_get_lang dictionary_id="57487.No"></th>
				<th width="180"><cf_get_lang dictionary_id="58221.Ürün Adı"></th>
				<th width="50" align="center"><cf_get_lang dictionary_id="57635.Miktar"></th>
			</tr>
			</thead>
			<tbody>
			<cfoutput query="get_karma_product">
			<tr>
				<td align="center">#currentrow#</td>
				<td>#product_name#</td>
				<td align="center">#product_amount#</td>
			</tr>
			</cfoutput>
		</tbody>
	</cf_grid_list>
</cf_box>
