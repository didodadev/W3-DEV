<cfsetting showdebugoutput="no">
<cfquery name="GET_PRODUCT_NAME" datasource="#DSN3#">
	SELECT DISTINCT
		(SHIP_ROW.PRICE/AMOUNT) PRICE,
		SHIP_ROW.UNIT,
		SHIP_ROW.UNIT_ID,
		S.STOCK_ID,
		S.PRODUCT_NAME,
		S.PROPERTY,
		S.PRODUCT_ID
	FROM 
		SERVICE_GUARANTY_NEW SGN,
		STOCKS S,
		#dsn2_alias#.SHIP_ROW,
		#dsn2_alias#.SHIP
	WHERE 
		S.STOCK_ID = SGN.STOCK_ID AND 
		SHIP_ROW.SHIP_ID = SHIP.SHIP_ID AND
        SHIP_ROW.STOCK_ID = S.STOCK_ID AND
		SGN.SERIAL_NO = '#attributes.serial_no#' AND
        SGN.PROCESS_ID = SHIP.SHIP_ID AND 
		SHIP.SHIP_STATUS = 1
</cfquery>
<cfoutput>
	<div id="_search_fuseaction_" style="position:absolute;width:355px;height:200px;z-index:1;overflow:auto; z-index:9999;background-color: #colorrow#; border: 1px outset cccccc;">
</cfoutput>
<table width="100%" align="left" border="0" cellpadding="0" cellspacing="0" class="color-border">
	<tr class="color-list" height="20">
	 	<td><cfoutput><b>#attributes.serial_no#</b> ile ilgili sonuçlar...</cfoutput></td>
		<td align="right" style="text-align:right;" width="15"><a href="##" onClick="div_gizle();"  class="tableyazi"><img src="../images/pod_close.gif" alt="Gizle" border="0"></a></td> 
	</tr>
	<cfif get_product_name.recordcount>
		<cfoutput query="get_product_name">
		<tr valign="top" height="20" class="color-row">
			<td colspan="2"><a href="javascript://" onClick="set_stock('#STOCK_ID#','#PRODUCT_ID#','#PRODUCT_NAME#','#tlformat(PRICE)#','#UNIT#','#UNIT_ID#')" class="tableyazi">#PRODUCT_NAME# - #PROPERTY# - #UNIT# - #tlformat(PRICE)#</a></td>
		</tr>
		</cfoutput>
	<cfelse>
	<tr>
		<td colspan="2">Kayıt Bulunamadı</td>
	</tr>
	</cfif>
</table>
<script type="text/javascript">
function div_gizle()
{
	<cfoutput>document.getElementById('check_product_layer'+#attributes.row_number#).style.display='none';</cfoutput>
	<cfoutput>document.getElementById('frm_row_'+#attributes.row_number#).style.display='none';</cfoutput>
}
function set_stock(stock_id,product_id,product_name,price,unit,unit_id)
{
	<cfoutput>
	document.getElementById('price#attributes.row_number#').value = price;
	document.getElementById('total_price#attributes.row_number#').value = price;
	document.getElementById('stock_id#attributes.row_number#').value = stock_id;
	document.getElementById('product_id#attributes.row_number#').value = product_id;
	document.getElementById('product#attributes.row_number#').value = product_name;
	document.getElementById('unit_name#attributes.row_number#').value = unit;
	document.getElementById('unit_id#attributes.row_number#').value = unit_id;
	document.getElementById('amount#attributes.row_number#').value = 1;
	document.getElementById('serial_no_#attributes.row_number#').value = '#attributes.serial_no#';
	</cfoutput> 
	div_gizle();

}
</script>
