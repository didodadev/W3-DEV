<cfif isdefined("attributes.ship_id_list")>
	<cfquery name="GET_SHIP_PACKAGE_LIST" datasource="#dsn1#">
		SELECT 
			SUM(SR.AMOUNT) AMOUNT, 
			ISNULL(SRP.AMOUNT,0) REMAINING_AMOUNT,
			S.SHIP_NUMBER,
			SR.STOCK_ID,
			SR.SHIP_ID,
			SR.UNIT_ID,
			SR.UNIT,	
			P.PRODUCT_CODE,
			P.PRODUCT_NAME	
		FROM 
			#dsn2_alias#.SHIP S,
			#dsn2_alias#.SHIP_ROW SR
			LEFT JOIN 
				(SELECT SUM(AMOUNT) AMOUNT, STOCK_ID,SHIP_ID FROM #dsn2_alias#.SHIP_RESULT_PACKAGE_PRODUCT GROUP BY STOCK_ID,SHIP_ID) SRP ON SR.SHIP_ID = SRP.SHIP_ID AND SR.STOCK_ID = SRP.STOCK_ID,
			#dsn1_alias#.PRODUCT P
		WHERE 
			S.SHIP_ID = SR.SHIP_ID AND
			SR.PRODUCT_ID = P.PRODUCT_ID AND	
			SR.SHIP_ID IN (#attributes.ship_id_list#) 
		GROUP BY
			S.SHIP_NUMBER,
			SR.STOCK_ID,
			SR.SHIP_ID,
			SR.UNIT_ID,
			SR.UNIT,	
			P.PRODUCT_CODE,
			P.PRODUCT_NAME,
			SRP.AMOUNT
		ORDER BY 
			SR.SHIP_ID,
			SR.STOCK_ID		
	</cfquery>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='58942.Ürün Listesi'></cfsavecontent>
	<cf_popup_box title="#message#">
	<form name="list_packetship_product" method="post" action="<cfoutput>#request.self#?fuseaction=objects.emptypopup_add_packetship_product</cfoutput>">
	<input type="hidden" id="record_num_other" name="record_num_other" value="<cfoutput>#get_ship_package_list.recordcount#</cfoutput>">
	<input type="hidden" id="ship_result_package_id" name="ship_result_package_id" value="<cfoutput>#attributes.ship_result_package_id#</cfoutput>">
	<input type="hidden" id="ship_id_list" name="ship_id_list" value="<cfoutput>#attributes.ship_id_list#</cfoutput>">
	<cf_medium_list>
		<thead>
			<tr>
				
				<th><cf_get_lang dictionary_id='57773.irsaliye'></th>
				<th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
				<th><cf_get_lang dictionary_id='33902.Stok Adı'></th>
				<th colspan="2"><cf_get_lang dictionary_id='57635.Miktar'></th>
				<th><cf_get_lang dictionary_id='33101.Sevk Edilen Miktar'></th>
				<th width="100"><cf_get_lang dictionary_id='33105.Sevk Edilecek'></th>
			</tr>
		</thead>
		<tbody>
			<cfoutput query="GET_SHIP_PACKAGE_LIST">
			<tr id="row#STOCK_ID#" height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				
				<td>#ship_number#</td>
				<td>#product_code#</td>
				<td>
					#PRODUCT_NAME#
					<input type="hidden" id="stock_id#currentrow#" name="stock_id#currentrow#" value="#stock_id#">
					<input type="hidden" id="ship_id#currentrow#" name="ship_id#currentrow#" value="#ship_id#">
				</td>
				<td style="text-align:right">#Tlformat(amount,2)#</td>
				<td width="10">#unit#</td>
				<td style="text-align:right">#Tlformat(remaining_amount,2)#</td>
				<td nowrap="nowrap">
					<input type="hidden" name="control_amount#currentrow#" id="control_amount#currentrow#" value="#amount-remaining_amount#">
					<input type="text" name="amount#currentrow#" id="amount#currentrow#" value="#Tlformat(0,2)#" class="box" style="width:100; color:FF0000;">
				</td>
			</tr>
			</cfoutput>
		</tbody>
		
		</cf_medium_list>
	
		<cf_popup_box_footer>
			<table style="text-align:right;">
				<tr>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57535.Kaydetmek İstediğinizden Eminmisiniz'></cfsavecontent>
					<td><input type="button" value="<cf_get_lang dictionary_id='57461.Kaydet'>" onClick="if(confirm(<cfoutput>#message#</cfoutput>)) kontrol(); else return false;"></td>
				</tr>
			</table>
		</cf_popup_box_footer>
	</form>
	</cf_popup_box>
	<script type="text/javascript">
	function kontrol()
	{
		
		for(r=1;r<=<cfoutput>#get_ship_package_list.recordcount#</cfoutput>;r++)
		{
			deger_control_amount = document.getElementById("control_amount"+r).value;
			deger_amount = filterNum(document.getElementById("amount"+r).value);
	
			if(parseFloat(deger_control_amount) < parseFloat(deger_amount))
			{
				alert(r +"<cf_get_lang dictionary_id='45687.Satırdaki Ürün Miktarını Kontrol Ediniz'> !");
				return false;
			}
		}	
		
		document.list_packetship_product.submit();
	}		
	</script>
<cfelse>
<cfquery name="GET_SHIP_PACKAGE_LIST" datasource="#DSN2#">
	SELECT 
		P.PRODUCT_NAME,
		SP.AMOUNT,
        S.STOCK_CODE, 
	FROM 
		SHIP_RESULT_PACKAGE_PRODUCT SP,
		#dsn1_alias#.STOCKS S,
		#dsn1_alias#.PRODUCT P
	WHERE 
		SP.SHIP_RESULT_PACKAGE_ID = #attributes.ship_result_package_id# AND 
		S.STOCK_ID = SP.STOCK_ID AND
		S.PRODUCT_ID = P.PRODUCT_ID
	ORDER BY 
		SP.STOCK_ID	
</cfquery>	
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='58942.Ürün Listesi'></cfsavecontent>
	<cf_popup_box title='#message#'>
	<cf_medium_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='58577.Sıra'></th>
                <th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
				<th><cf_get_lang dictionary_id='33902.Stok Adı'></th>
				<th><cf_get_lang dictionary_id='57635.Miktar'></th>
			</tr>
		</thead>
		<tbody>
		<cfif get_ship_package_list.recordcount>
			<cfoutput query="GET_SHIP_PACKAGE_LIST">
			<tr>
				<td>#currentrow#</td>
                <td>#STOCK_CODE#</td>
				<td>#PRODUCT_NAME#</td>
				<td style="text-align:right">#Tlformat(amount,2)#</td>
			</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td>
			</tr>
		</cfif>
		</tbody>
		</cf_medium_list>
	</cf_popup_box>
</cfif>
