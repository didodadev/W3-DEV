<cfquery name="get_product_detail" datasource="#DSN3#">
	SELECT 
		P.PRODUCT_ID,
		P.PRODUCT_NAME,
		P.BRAND_ID,
		S.PROPERTY,
		PRODUCT_UNIT.ADD_UNIT
	FROM 
		PRODUCT P, 
		PRODUCT_UNIT,
		STOCKS S,
		GET_STOCK_BARCODES
	WHERE  
		P.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID AND
		GET_STOCK_BARCODES.PRODUCT_ID = P.PRODUCT_ID AND
		S.PRODUCT_UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID
		AND GET_STOCK_BARCODES.BARCODE='#attributes.barcod#'
		AND GET_STOCK_BARCODES.STOCK_ID = S.STOCK_ID
</cfquery>
<table  cellpadding="0" cellspacing="0" border="0" style="height:85mm;">
<tr>
<td>
<cfif get_product_detail.recordcount>	
	<cfset fullname = "#ucase(get_product_detail.product_name)#">
	<cfif get_product_detail.property is not "-"><cfset fullname = "#fullname# - #get_product_detail.property#"></cfif>
	<table cellpadding="0" cellspacing="0" align="center" border="0">
		<cfloop from="1" to="4" index="y">
		<tr>		
		<td valign="top">
			<table border="0" cellpadding="0" cellspacing="0" style="width:40mm; height:20mm;">
			<tr>
				<td class="printbold" valign="bottom"><cfoutput>#Left(fullname,35)#</cfoutput></td>			
			</tr>				
			<tr>
				<td valign="top">
				<cfif isdefined('attributes.barcod')>
					<cfset barcod = attributes.barcod>
				<cfelse>
					<cfset barcod = attributes.barcode>
				</cfif>
				<!--- ic 20050714
					ersanin 9,10 ve 11 haneli barkodlu ürünlerini basabilmek için sonlarina 12 ye tammamlamaak adina sifirlar eklendi
				--->
				<cfif get_product_detail.add_unit neq "kg">
					<cfif (len(barcod) eq 13) or (len(barcod) eq 12)>
						<cf_barcode type="EAN13" barcode="#barcod#" extra_height="0"> <cfif len(errors)><cfoutput>#errors#</cfoutput></cfif>
					<cfelseif (len(barcod) eq 8) or (len(barcod) eq 7)>
						<cf_barcode type="EAN8" barcode="#barcod#" extra_height="0"> <cfif len(errors)><cfoutput>#errors#</cfoutput></cfif>
					<cfelseif (len(barcod) eq 9)>
						<cf_barcode type="EAN13" barcode="#barcod#000" extra_height="0"> <cfif len(errors)><cfoutput>#errors#</cfoutput></cfif>
					<cfelseif (len(barcod) eq 10)>
						<cf_barcode type="EAN13" barcode="#barcod#00" extra_height="0"> <cfif len(errors)><cfoutput>#errors#</cfoutput></cfif>
					<cfelseif (len(barcod) eq 11)>
						<cf_barcode type="EAN13" barcode="#barcod#0" extra_height="0"> <cfif len(errors)><cfoutput>#errors#</cfoutput></cfif>
					</cfif>
				<cfelseif len(barcod) eq 7>
					<cf_barcode type="EAN13" barcode="#barcod#010000" extra_height="0"> <cfif len(errors)><cfoutput>#errors#</cfoutput></cfif>
				</cfif>

				</td> 	
			</tr>	
			</table>						
		</td>
		</tr>
		</cfloop>
		</table>	
</cfif>
</td>
</tr>
</table>
