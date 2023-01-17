<!--- TOPLU BARKOD BASKI 20121023 ST--->
<cfsetting showdebugoutput="no">
<cfif not isdefined("attributes.barcode_count")>
	<cfset attributes.barcode_count = 1>
</cfif>
<cfif isdefined("attributes.price_catid") and (attributes.price_catid gt 0)>
	<cfquery name="get_product_detail" datasource="#dsn3#">
		SELECT
			PRICE.MONEY,
			PRICE.IS_KDV,
			PRICE.PRICE_KDV,
			PRICE.PRICE,
			GET_STOCK_BARCODES.*,
			STOCKS.STOCK_CODE,
			STOCKS.TAX,
			STOCKS.PRODUCT_NAME,
			STOCKS.BRAND_ID,
			STOCKS.PRODUCT_ID P_ID,
			STOCKS.PROPERTY
		FROM
			STOCKS,
			PRICE,
			GET_STOCK_BARCODES
		WHERE
			<cfif isdefined("attributes.startdate") and len(attributes.startdate) AND isdefined("attributes.finishdate") and len(attributes.finishdate)>
				PRICE.STARTDATE BETWEEN #attributes.startdate# AND #attributes.finishdate# AND
			<cfelseif isdefined("attributes.startdate") and len(attributes.startdate)>
				<cfset finishdate = dateadd("d",1,attributes.startdate)>
				PRICE.STARTDATE BETWEEN #attributes.startdate# AND #finishdate# AND
			<cfelseif isdefined("attributes.finishdate") and len(attributes.finishdate)><!--- sadece finish verirse boş döner --->
				1=2 AND
			<cfelse>
				PRICE.STARTDATE <= #now()# AND
				(PRICE.FINISHDATE >= #now()# OR PRICE.FINISHDATE IS NULL) AND
			</cfif>
			<cfif isdefined("attributes.barcode") and  len(attributes.barcode)>
			
				<cfif listlen(attributes.barcode) gt 1>
					(
					<cfset cont=0>
					<cfloop list="#attributes.barcode#" delimiters="," index="ind_list">
						(GET_STOCK_BARCODES.BARCODE = '#ind_list#' OR STOCKS.STOCK_CODE LIKE '%#ind_list#')
						<cfset cont=cont+1>
						<cfif cont lt listlen(attributes.barcode)>OR</cfif>
					</cfloop>
					
					) AND
				<cfelse>
					(GET_STOCK_BARCODES.BARCODE = '#attributes.barcode#' OR STOCKS.STOCK_CODE LIKE '%#attributes.barcode#') AND
				</cfif>
			</cfif>
			PRICE.PRICE_CATID = #attributes.price_catid# AND
			PRICE.PRODUCT_ID = GET_STOCK_BARCODES.PRODUCT_ID AND
			STOCKS.STOCK_ID = GET_STOCK_BARCODES.STOCK_ID
	</cfquery>
<cfelseif not isdefined("attributes.price_catid") or  isdefined("attributes.price_catid") and (attributes.price_catid eq -2)>
	<cfquery name="get_product_detail" datasource="#dsn3#">
		SELECT
			GET_STOCK_BARCODES.*,
			PRICE_STANDART.PRICE,
			PRICE_STANDART.PRICE_KDV,
			PRICE_STANDART.MONEY,
			STOCKS.STOCK_CODE,
			STOCKS.TAX,
			STOCKS.PRODUCT_NAME,
			STOCKS.BRAND_ID,
			STOCKS.PRODUCT_ID P_ID,
			STOCKS.PROPERTY
		FROM
			STOCKS,
			PRICE_STANDART,
			GET_STOCK_BARCODES
		WHERE
			<cfif isdefined("attributes.barcode") and  len(attributes.barcode)>
				<cfif listlen(attributes.barcode) gt 1>
					(
					<cfset cont=0>
					<cfloop list="#attributes.barcode#" delimiters="," index="ind_list">
						(GET_STOCK_BARCODES.BARCODE = '#ind_list#' OR STOCKS.STOCK_CODE LIKE '%#ind_list#')
						<cfset cont=cont+1>
						<cfif cont lt listlen(attributes.barcode)>OR</cfif>
					</cfloop>
					
					) AND
				<cfelse>
				(GET_STOCK_BARCODES.BARCODE = '#attributes.barcode#' OR STOCKS.STOCK_CODE LIKE '%#attributes.barcode#') AND
				</cfif>
			</cfif>
			PRICE_STANDART.PRODUCT_ID = GET_STOCK_BARCODES.PRODUCT_ID AND
			PRICE_STANDART.PURCHASESALES = 1 AND
			PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
			STOCKS.STOCK_ID = GET_STOCK_BARCODES.STOCK_ID
	</cfquery>
<cfelseif isdefined("attributes.price_catid") and (attributes.price_catid eq -1)>
	<cfquery name="get_product_detail" datasource="#dsn3#">
		SELECT
			GET_STOCK_BARCODES.*,
			PRICE_STANDART.PRICE,
			PRICE_STANDART.PRICE_KDV,
			PRICE_STANDART.MONEY,
			STOCKS.STOCK_CODE,
			STOCKS.TAX,
			STOCKS.PRODUCT_NAME,
			STOCKS.BRAND_ID,
			STOCKS.PRODUCT_ID P_ID,
			STOCKS.PROPERTY
		FROM
			STOCKS,
			PRICE_STANDART,
			GET_STOCK_BARCODES
		WHERE
			<cfif isdefined("attributes.barcode") and  len(attributes.barcode)>
				<cfif listlen(attributes.barcode) gt 1>
					(
					<cfset cont=0>
					<cfloop list="#attributes.barcode#" delimiters="," index="ind_list">
						(GET_STOCK_BARCODES.BARCODE = '#ind_list#' OR STOCKS.STOCK_CODE LIKE '%#ind_list#')
						<cfset cont=cont+1>
						<cfif cont lt listlen(attributes.barcode)>OR</cfif>
					</cfloop>
					
					) AND
				<cfelse>
				(GET_STOCK_BARCODES.BARCODE = '#attributes.barcode#' OR STOCKS.STOCK_CODE LIKE '%#attributes.barcode#') AND
				</cfif>
			</cfif>
			PRICE_STANDART.PRODUCT_ID = GET_STOCK_BARCODES.PRODUCT_ID AND
			PRICE_STANDART.PURCHASESALES = 0 AND
			PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
			STOCKS.STOCK_ID = GET_STOCK_BARCODES.STOCK_ID
	</cfquery>
</cfif>
<cfif get_product_detail.recordcount>
	<cfset sayac = 0>
	<cfoutput query="get_product_detail">
		<cfif isdefined("attributes.barcode_count")>
			<cfset aa=listfind(attributes.barcode,get_product_detail.barcode,',')>
			<cfif aa eq 0>
				<cfset aa=listfind(attributes.barcode,get_product_detail.STOCK_CODE	,',')>
				<cfif aa eq 0>
					<cfset aa=listfind(attributes.barcode,ListLast(get_product_detail.STOCK_CODE,'.'),',')> 
				</cfif>
			</cfif>
			<cfloop from="1" to="#listgetat(attributes.barcode_count,aa,',')#" index="i">
				<cfset sayac = sayac +1>
				<!--- <cfif (sayac mod 33) eq 1 or sayac eq 1>
				<table border="1" cellspacing="1" cellpadding="0" height="100%">
					<tr style="height:5mm;">
						<td colspan="6">&nbsp;</td>
					</tr>
				</cfif> YANYANA BASIYOR..--->
				<cfif (sayac mod 3) eq 1>
					<tr valign="top">
				</cfif>
					<td style="<cfif (sayac mod 3) eq 1>width:5mm;<cfelse>width:10mm;</cfif>">&nbsp;</td>
					<td valign="top">
                    <table cellpadding="0" cellspacing="0" style="width:55mm;height:24mm;border:0px solid ##000000;">
                        <tr>
                            <td style="text-align:center">
                                <table cellpadding="0" cellspacing="0" style="width:55mm;height:23mm;" border="2" bordercolor="##003366">
                                    <tr style="text-align:center">
                                        <td style="font-size:14px;font-family:arial;text-align:center">
                                            #product_name#<br/>
											<!---<CF_BarcodeGenerator BarCode="#BARCODE#" BarCodeType="8" ThickWidth="5" ThinWidth="#0.08 * (10 / 3.14)#" Height="45">--->
												<cf_workcube_barcode type="ean13" show="1" value="#BARCODE#">
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
					</td>
				<cfif (sayac mod 3) eq 0> 
					</tr>
				</cfif>
				<cfif (sayac mod 33) eq 0>
				</table>
				</cfif>
			</cfloop>
		</cfif>
	</cfoutput>
	<cfif isdefined("attributes.barcode_count") and (sayac mod 33) neq 0>
		<tr height="100%">
			<td colspan="6">&nbsp;</td>
		</tr>
	</cfif>
<cfelse>
	<script language="JavaScript">
		alert("<cf_get_lang_main no='2232.Gönderilen Veriler Ile Bu Sablon Kullanilamaz'>!");
		history.back();
	</script>
	<cfabort> 
</cfif>
