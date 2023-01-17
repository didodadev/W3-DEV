<cf_xml_page_edit fuseact="objects.popup_list_order_history">
<cfquery name="GET_ORDER_ROWS" datasource="#DSN3#">
	SELECT
		P.PRODUCT_NAME,
		S.PROPERTY,
		ORD.*
	FROM
		ORDER_ROW_HISTORY ORD,
		PRODUCT P,
		STOCKS S
	WHERE
		ORD.PRODUCT_ID=P.PRODUCT_ID AND
		ORD.STOCK_ID=S.STOCK_ID AND
	<cfif len(str)>
		ORD.ORDER_HISTORY_ID IN (#str#)	
	<cfelse>
		ORD.ORDER_HISTORY_ID=-1
	</cfif>	
	ORDER BY 
		ORD.STOCK_ID,
		ORD.ORDER_ROW_ID
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='33552.Değişiklikler'></cfsavecontent>
<cf_medium_list_search title="#message#"></cf_medium_list_search>
<cf_medium_list>
<thead>
        <tr height="20"> 
			<th width="40"><cf_get_lang dictionary_id='57487.no'></th>
			<th width="120"><cf_get_lang dictionary_id='57657.Ürün'></th>
			<th><cf_get_lang dictionary_id='58084.Fiyat'></th>
			<th width="159"><cf_get_lang dictionary_id ='33828.Satış Aşaması'></th>
            <cfset colspan_info = 2>
            <cfloop list="#ListDeleteDuplicates(x_is_discount)#" index="xlr">
				<cfswitch expression="#xlr#">
                	<cfcase value="1">
						<cfset colspan_info = colspan_info + 1>
						<th><cf_get_lang dictionary_id='57641.İndirim'> 1</th>
					</cfcase>
                    <cfcase value="2">
						<cfset colspan_info = colspan_info + 1>
						<th><cf_get_lang dictionary_id='57641.İndirim'> 2</th>
					</cfcase>
                    <cfcase value="3">
						<cfset colspan_info = colspan_info + 1>
						<th><cf_get_lang dictionary_id='57641.İndirim'> 3</th>
					</cfcase>
                    <cfcase value="4">
						<cfset colspan_info = colspan_info + 1>
						<th><cf_get_lang dictionary_id='57641.İndirim'> 4</th>
					</cfcase>
                    <cfcase value="5">
						<cfset colspan_info = colspan_info + 1>
						<th><cf_get_lang dictionary_id='57641.İndirim'> 5</th>
					</cfcase>
                    <cfcase value="6">
						<cfset colspan_info = colspan_info + 1>
						<th><cf_get_lang dictionary_id='57641.İndirim'> 6</th>
					</cfcase>
                    <cfcase value="7">
						<cfset colspan_info = colspan_info + 1>
						<th><cf_get_lang dictionary_id='57641.İndirim'> 7</th>
					</cfcase>
                    <cfcase value="8">
						<cfset colspan_info = colspan_info + 1>
						<th><cf_get_lang dictionary_id='57641.İndirim'> 8</th>
					</cfcase>
                    <cfcase value="9">
						<cfset colspan_info = colspan_info + 1>
						<th><cf_get_lang dictionary_id='57641.İndirim'> 9</th>
					</cfcase>
                    <cfcase value="10">
						<cfset colspan_info = colspan_info + 1>
						<th><cf_get_lang dictionary_id='57641.İndirim'> 10</th>
					</cfcase>
              </cfswitch>
			</cfloop>      				  
            <th width="120"><cf_get_lang dictionary_id='57639.KDV'></th>
            <th width="159"><cf_get_lang dictionary_id='57635.Miktar'></th>
			<th width="159"><cf_get_lang dictionary_id='57673.Tutar'></th>
        </tr>
	</thead>
    <tbody>
		<cfif GET_ORDER_ROWS.recordcount>
			<cfoutput QUERY="GET_ORDER_ROWS">
				<tr>
					<td>#ORDER_ROW_ID#</td>
					<td>#PRODUCT_NAME#&nbsp;#PROPERTY#</td>
					<td style="text-align:right;">#TLFormat(PRICE)# #SESSION.EP.MONEY#</td>
					<td>
						<cfif Len(ORDER_ROW_CURRENCY)>
							<cfswitch expression = "#ORDER_ROW_CURRENCY#">
								<cfcase value="-10"><cf_get_lang dictionary_id="29746.Kapatıldı">(<cf_get_lang dictionary_id="58500.Manuel">)</cfcase>
								<cfcase value="-9"><cf_get_lang dictionary_id="58506.İptal"></cfcase>
								<cfcase value="-8"><cf_get_lang dictionary_id="29749.Fazla Teslimat"></cfcase>
								<cfcase value="-7"><cf_get_lang dictionary_id="29748.Eksik Teslimat"></cfcase>
								<cfcase value="-6"><cf_get_lang dictionary_id="58761.Sevk"></cfcase>
								<cfcase value="-5"><cf_get_lang dictionary_id="57456.Üretim"></cfcase>
								<cfcase value="-4"><cf_get_lang dictionary_id="29747.Kısmi Üretim"></cfcase>
								<cfcase value="-3"><cf_get_lang dictionary_id="29746.Kapatıldı"></cfcase>
								<cfcase value="-2"><cf_get_lang dictionary_id="29745.Tedarik"></cfcase>
								<cfcase value="-1"><cf_get_lang dictionary_id="58717.Açık"></cfcase>
							</cfswitch>
						</cfif>
					</td>
                    <cfloop list="#ListDeleteDuplicates(x_is_discount)#" index="xlr">
						<cfswitch expression="#xlr#">
							<cfcase value="1">
								<td style="text-align:right;">#TLFormat(DISCOUNT_1)# %</td>
							</cfcase>
                            <cfcase value="2">
								<td style="text-align:right;">#TLFormat(DISCOUNT_2)# %</td>
							</cfcase>
                            <cfcase value="3">
								<td style="text-align:right;">#TLFormat(DISCOUNT_3)# %</td>
							</cfcase>
                            <cfcase value="4">
								<td style="text-align:right;">#TLFormat(DISCOUNT_4)# %</td>
							</cfcase>
                            <cfcase value="5">
								<td style="text-align:right;">#TLFormat(DISCOUNT_5)# %</td>
							</cfcase>
                            <cfcase value="6">
								<td style="text-align:right;">#TLFormat(DISCOUNT_6)# %</td>
							</cfcase>
                            <cfcase value="7">
								<td style="text-align:right;">#TLFormat(DISCOUNT_7)# %</td>
							</cfcase>
                            <cfcase value="8">
								<td style="text-align:right;">#TLFormat(DISCOUNT_8)# %</td>
							</cfcase>
                            <cfcase value="9">
								<td style="text-align:right;">#TLFormat(DISCOUNT_9)# %</td>
							</cfcase>
                            <cfcase value="10">
								<td style="text-align:right;">#TLFormat(DISCOUNT_10)# %</td>
							</cfcase>
						</cfswitch>
					</cfloop>						  
				    <td>#TAX#</td>
					<td>#QUANTITY# #UNIT#</td>
					<td>#TLFormat(OTHER_MONEY_VALUE)# #OTHER_MONEY#</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
			  <td colspan="9"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_medium_list>
