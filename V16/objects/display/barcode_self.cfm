<cfinclude template="../functions/barcode.cfm">
<cfquery name="get_product_detail" datasource="#DSN3#">
	SELECT 
		P.PRODUCT_ID,
		P.PRODUCT_NAME,
		P.BRAND_ID,
		PRODUCT_UNIT.ADD_UNIT,
		STOCKS.STOCK_CODE,
		STOCKS.STOCK_ID,
		STOCKS.PRODUCT_UNIT_ID,
		STOCKS.TAX,
		STOCKS.TAX_PURCHASE
	FROM 
		PRODUCT P, 
		PRODUCT_UNIT,
		STOCKS,
		GET_STOCK_BARCODES
	WHERE  
		P.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID AND
		GET_STOCK_BARCODES.PRODUCT_ID = P.PRODUCT_ID AND
		STOCKS.PRODUCT_UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND 
		GET_STOCK_BARCODES.BARCODE = '#attributes.barcod#' AND 
		GET_STOCK_BARCODES.STOCK_ID = STOCKS.STOCK_ID
</cfquery>
<cfif get_product_detail.recordcount>
	<cfoutput>
	<table cellpadding="0" cellspacing="0" style="width:4in;height:2in;">
		<tr>
			<td valign="top">
			<table width="100%">
		 		<tr>
					<td class="txtbold" style="font-size:17px;font-family:tahoma;" height="25" valign="bottom" colspan="2">
						&nbsp;&nbsp;	
						#ucase(get_product_detail.product_name)#
					</td>			
				</tr>		
				<tr>
					<td colspan="2">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formbold">
						<tr>
							<td>&nbsp;</td>
							<td  style="text-align:right;">&nbsp;</td>
						</tr>
					</table>
					</td>
				</tr>					
				<tr>
				  	<td>
					<cfif isdefined('attributes.barcod')>
						<cfset barcod = attributes.barcod>
					<cfelse>
						<cfset barcod = attributes.barcode>
					</cfif>
					<cfif get_product_detail.add_unit neq "kg">
						<cfif (len(barcod) eq 13) or (len(barcod) eq 12)>
							<cf_barcode type="EAN13" barcode="#barcod#" extra_height="0"> <cfif len(errors)>#errors#</cfif>
						<cfelseif (len(barcod) eq 8) or (len(barcod) eq 7)>
							<cf_barcode type="EAN8" barcode="#barcod#" extra_height="0"> <cfif len(errors)>#errors#</cfif>
						</cfif>
					<cfelseif len(barcod) eq 7>
						<cf_barcode type="EAN13" barcode="#barcod#010000" extra_height="0"> <cfif len(errors)>#errors#</cfif>
					</cfif>
					</td> 
					<td style="text-align:right;" valign="bottom" style="font-size:30px;font-family:tahoma;">&nbsp; </td>
				</tr>	
				<tr>
					<td class="print"></td>
					<td class="formbold" align="center">&nbsp;</td>
				</tr>							  
			</table>
			</td>
		</tr>		
	</table> 
	</cfoutput>
</cfif>	
<script type="text/javascript">
function waitfor()
{
  window.close();
}	
setTimeout("waitfor()",3000);  		
window.print();	
</script>
