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
	<cfif isdefined("attributes.barcode") and  len(attributes.barcode)>
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
				PRICE_STANDART.PRODUCT_ID = GET_STOCK_BARCODES.PRODUCT_ID AND
				PRICE_STANDART.PURCHASESALES = 1 AND
				PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
				STOCKS.STOCK_ID = GET_STOCK_BARCODES.STOCK_ID
		</cfquery>
	<cfelse>
		<cfset get_product_detail.recordCount=0>
	</cfif>
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
<cfset xxx = 0>
<cfif get_product_detail.recordcount>
	<cfoutput query="get_product_detail">
		<cfif xxx lte recordcount>
			<table cellpadding="0" align="center" width="100%" id="parent">
				<cfloop from="1" to="10" index="rw"><!--- row number --->
					<tr valign="top" height="120">
						<cfloop from="1" to="3" index="cl"><!--- column number --->
							<cfset xxx = xxx + 1>
							<cfif len(get_product_detail.BARCODE[xxx])>
								<td style="text-align:center" width="120">
									<table cellpadding="0" id="child" style="width:55mm;height:24mm;" border="2" bordercolor="##003366">
										<tr valign="top" style="text-align:center">
											<td style="font-size:14px;font-family:arial;text-align:center">
												#product_name[xxx]#<br/><br/>
												<cf_workcube_barcode type="ean13" show="1" value="#get_product_detail.BARCODE[xxx]#">
											</td>
										</tr>
									</table>
								</td>
							</cfif>
						</cfloop>
					</tr>
				</cfloop>
			</table>
			<div style="page-break-after:always"></div>
		</cfif>
		
	</cfoutput>
<cfelse>
	<script language="JavaScript">
		alert("<cf_get_lang dictionary_id='30029.Gönderilen veriler ile bu şablon kullanılamaz.'>!");
		history.back();
	</script>
	<cfabort> 
</cfif>
<script>
    $('.parent').css( {
    "display": "grid",
    "grid-template-columns":"repeat(4, 200px)",
    "grid-template-rows": "repeat(6, 200px)",
    "grid-column-gap": "10px",
    "grid-row-gap": "10px",
    })
</script>

