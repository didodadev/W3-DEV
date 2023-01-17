<cfquery name="get_sales_imports" datasource="#DSN2#">
	SELECT
		FILE_NAME
	FROM
		SAYIMLAR
	WHERE
		GIRIS_ID = #attributes.file_id#
</cfquery>
<cfset file_name = #get_sales_imports.file_name#>
<cfset upload_folder = "#upload_folder#store#dir_seperator#">
	<cfset dosya_yolu = "#upload_folder##file_name#">
	<cffile action="read" file="#dosya_yolu#" variable="dosya">
<cfscript>
	CRLF = Chr(13)&Chr(10); // satır atlama karakteri
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
</cfscript>

<cfset barcod_list = "">
<cfloop from="1" to="#line_count#" index="kall">
	<cfif len(ListGetAt(dosya[kall],1,";"))>
		<cfset barcod_list = ListAppend(barcod_list,"'#ListGetAt(dosya[kall],1,";")#'")>
	</cfif>
</cfloop>
<cfquery name="get_product_main_all" datasource="#dsn3#">
		SELECT
			GSB.BARCODE,
			S.STOCK_ID,
			S.PRODUCT_ID,
			S.STOCK_CODE,
			S.PROPERTY,					
			P.PRODUCT_NAME,
			P.MANUFACT_CODE,
			PS.PRICE,
			PS.MONEY,
			PU.MAIN_UNIT,
			PS.PURCHASESALES,
			PS.PRICESTANDART_STATUS,
			PU.IS_MAIN
		FROM
			PRODUCT P,
			STOCKS AS S,
			GET_STOCK_BARCODES AS GSB,
			PRICE_STANDART AS PS,
			PRODUCT_UNIT AS PU
		WHERE
			GSB.BARCODE IN (#preservesinglequotes(barcod_list)#) AND
			PS.PURCHASESALES = 0 AND
			PS.PRICESTANDART_STATUS = 1 AND
			PU.IS_MAIN = 1 AND
			P.PRODUCT_ID = S.PRODUCT_ID AND
			S.STOCK_ID = GSB.STOCK_ID AND
			PS.PRODUCT_ID = P.PRODUCT_ID AND
			PS.UNIT_ID = PU.PRODUCT_UNIT_ID AND
			PU.PRODUCT_ID = P.PRODUCT_ID
</cfquery>


<!--- <cfparam name="attributes.file_header1" default="">
<cfparam name="attributes.file_header2" default="">
<cfparam name="attributes.file_header3" default="">
<cfloop from="1" to="4" index="kz">
	<cfset evaluate("attributes.file_header"&kz&" = '"&dosya[kz]&"'")>
</cfloop> --->
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
	<tr>
		<td width="100%" height="35" class="headbold"><cf_get_lang dictionary_id='36032.PHL Dökümanı İçeriği Maliyeti Sıfır (0) Olan Ürünler'></td>
	</tr>
</table>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr class="color-border">
	<td>
	  <table width="100%" cellpadding="2" cellspacing="1">
		<tr class="color-header" height="22">
			<td class="form-title" width="20"><cf_get_lang dictionary_id='58508.Satır'></td>
			<td class="form-title" width="70"><cf_get_lang dictionary_id='57633.Barkod'></td>
			<td class="form-title"><cf_get_lang dictionary_id='57518.Stok Kodu'></td>
			<td class="form-title"><cf_get_lang dictionary_id='57657.Ürün'></td>
			<td class="form-title"><cf_get_lang dictionary_id='57634.Üretici Kodu'></td>
			<td class="form-title"><cf_get_lang dictionary_id='57635.Miktar'></td>
			<td align="right" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='36080.Toplam Maliyet'></td>
		</tr>
		<cftry>
		<cfset net_total = 0>
		<cfset net_money = "">
		<cfloop from="1" to="#line_count#" index="k">
			<cfquery name="get_product_main" dbtype="query">
				SELECT
					BARCODE,
					STOCK_ID,
					PRODUCT_ID,
					STOCK_CODE,
					PROPERTY,					
					PRODUCT_NAME,
					MANUFACT_CODE,
					PRICE,
					MONEY,
					MAIN_UNIT
				FROM
					get_product_main_all
				WHERE
					BARCODE = '#ListGetAt(dosya[k],1,";")#'
			</cfquery>
			<cfif get_product_main.recordcount>
				<cfoutput query="get_product_main">
				<cfif MAIN_UNIT is "Kg">
					<cfset satir_toplam = (trim(ListGetAt(dosya[k],2,";")) * price) / 1000>
				<cfelse>
					<cfset satir_toplam = trim(ListGetAt(dosya[k],2,";")) * price>
				</cfif>
					<cfif satir_toplam eq 0>
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					  <td align="center">#k#</td>
					  <td>#barcode# #MAIN_UNIT#</td>
					  <td>#stock_code#</td>
					  <td>#product_name# #property#</td>
					  <td>#manufact_code#</td>
					  <td>#trim(ListGetAt(dosya[k],2,";"))#</td>
					  <td align="right" style="text-align:right;">#TLFormat(satir_toplam)# #money#</td>
					</tr>
					<cfset net_total = net_total + satir_toplam>
					<cfset net_money = "#money#">
					</cfif>
				</cfoutput>
			</cfif>
		</cfloop>
		<cfcatch>!!! <cf_get_lang dictionary_id='36135.DOSYA OKUMADA HATA VAR'> !!!</cfcatch>
		</cftry>
	  </table>
	</td>
  </tr>
</table>
<script type="text/javascript">
	window.print();
</script>
