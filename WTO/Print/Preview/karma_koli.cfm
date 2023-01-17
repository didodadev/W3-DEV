<cfquery name="GET_KARMA_PRODUCT" datasource="#dsn1#">
	SELECT 
		KP.PRODUCT_NAME,
		KP.UNIT,
		KP.PRODUCT_AMOUNT,
		S.STOCK_CODE,
		S.STOCK_ID,
		S.PROPERTY,
		S.IS_PRODUCTION,
		SP.PROPERTY_ID,
		SP.PROPERTY_DETAIL_ID,
		P.BARCOD,
		P.TAX,
		P.PRODUCT_CODE,
		P.BRAND_ID,
		PB.BRAND_NAME
	FROM 
		KARMA_PRODUCTS AS KP
		LEFT JOIN #DSN3#.PRODUCT AS P ON P.PRODUCT_ID=KP.KARMA_PRODUCT_ID
		LEFT JOIN #DSN3#.PRODUCT_BRANDS AS PB ON PB.BRAND_ID=P.BRAND_ID
		LEFT JOIN #dsn3#.STOCKS S ON S.STOCK_ID=KP.STOCK_ID
		LEFT JOIN STOCKS_PROPERTY SP ON SP.STOCK_ID =KP.STOCK_ID AND SP.PROPERTY_ID=1<!--- renk için --->
	WHERE
		KP.KARMA_PRODUCT_ID = <cfqueryparam value = "#attributes.iid#" CFSQLType = "cf_sql_integer">
	ORDER BY 
		ENTRY_ID
</cfquery>
<cfquery name="GET_PRICE_SS" datasource="#DSN3#"> <!--- standart satis --->
	SELECT	
		PS.PRICE,
		PS.PRICE_KDV,
		PS.IS_KDV,
		PS.ROUNDING,
		PS.MONEY,
		PU.PACKAGES,
		SPT.PACKAGE_TYPE,
		CASE
			WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
			ELSE PU.ADD_UNIT
		END AS ADD_UNIT
	FROM 
		PRICE_STANDART AS PS,
		PRODUCT_UNIT AS PU
		LEFT JOIN #DSN#.SETUP_PACKAGE_TYPE AS SPT ON SPT.PACKAGE_TYPE_ID=PU.PACKAGES
		LEFT JOIN #DSN#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PU.UNIT_ID
		AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="UNIT">
		AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_UNIT">
		AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
	WHERE 
		PS.PRODUCT_ID = <cfqueryparam value = "#attributes.iid#" CFSQLType = "cf_sql_integer"> AND 
		PS.PURCHASESALES = 1 AND 
		PS.PRICESTANDART_STATUS = 1 AND 
		PU.PRODUCT_ID = PS.PRODUCT_ID AND 
		PS.UNIT_ID = PU.PRODUCT_UNIT_ID
	ORDER BY
		PU.PRODUCT_UNIT_ID
</cfquery>
<cfquery name="CHECK" datasource="#DSN#">
	SELECT
	    COMPANY_NAME,
		TEL_CODE,
		TEL,
		TEL2,
		TEL3,
		TEL4,
		FAX,
		ADDRESS,
		WEB,
		EMAIL,
		ASSET_FILE_NAME3,
		ASSET_FILE_NAME3_SERVER_ID,
		TAX_OFFICE,
		TAX_NO
	FROM
	   OUR_COMPANY
	WHERE
	<cfif isDefined("SESSION.EP.COMPANY_ID")>
	    COMP_ID =  <cfqueryparam value = "#SESSION.EP.COMPANY_ID#" CFSQLType = "cf_sql_integer">
	<cfelseif isDefined("SESSION.PP.COMPANY")>	
	    COMP_ID = <cfqueryparam value = "#session.pp.company_id#" CFSQLType = "cf_sql_integer">
	</cfif> 
</cfquery>


<cfif GET_KARMA_PRODUCT.recordcount>
	<cfoutput>
		<table  style="width:80mm;height:90mm;margin:5mm;" >
			<tr>
				<td>
					<div class="col col-12"style="text-align:left;">
						<label class="td-label"style="text-align:left;font-size:12px;color:##000000;" >#GET_KARMA_PRODUCT.PRODUCT_CODE#</label>
					</div>
					<div class="col col-12"style="text-align:left;">
						<label class="td-label"style="text-align:left;font-size:16px;font-weight: bold;color:##000000;padding-buttom:5px;">#get_product_name(attributes.iid)#</label>
					</div>
					<cfif len(GET_KARMA_PRODUCT.BARCOD)>
						<div class="col col-12">
							<label class="td-label">
								<cf_workcube_barcode type="code39" show="1" value="#GET_KARMA_PRODUCT.BARCOD#" height="60">
							</label>
						</div>
						<div class="col col-12" >
							<label class="td-label"style="text-align:left;font-size:8px;letter-spacing:2mm;line-height: 1px !important;padding-buttom:10px;" >
								#GET_KARMA_PRODUCT.BARCOD#
							</label>
						</div>
					</cfif>
					<div class="col col-12" style="text-align:left;">
						<label class="td-label"style="text-align:left;font-weight: bold;color:##000000;font-size:13px;"><cf_get_lang dictionary_id='65463.Koli İçeriği'></label>
					</div>
					<div class="form-group" >
						<cfloop query="GET_KARMA_PRODUCT">
							<div class="col col-7"style="text-align:left;">
								<label style="text-align:left;font-family: sans-serif;font-size:11px;line-height:5px;margin-left:3px;color:##000000;">#GET_KARMA_PRODUCT.product_name# #GET_KARMA_PRODUCT.STOCK_CODE#</label>
							</div>
							<div class="col col-5" >
								<label style="font-family: sans-serif;font-size:11px;line-height:5px;margin-left:3px;color:##000000;">#product_amount# #UNIT#</label>
							</div>
						</cfloop>
					</div>
					<cfif len(GET_PRICE_SS.PRICE_KDV)>
						<div class="col col-12" style="text-align:left;">
							<br>
							<br>
							<label class="td-label"style="text-align:left;font-size:19px;font-weight: bold;color:##000000;">#TLFormat(GET_PRICE_SS.PRICE_KDV,2)# #GET_PRICE_SS.money#</label>
						</div>
						<div class="col col-12" style="text-align:left;">
							<label class="td-label"style="text-align:left;font-size:10px;font-weight: bold;line-height: 2px !important;color:##000000;" >%#GET_KARMA_PRODUCT.tax# KDV Dahildir</label>
						</div>
					</cfif>
					<cfif len(GET_PRICE_SS.PACKAGE_TYPE)>
						<div class="col col-12" style="text-align:left;">
							<br>
							<label class="td-label"style="text-align:left;font-weight: bold;font-size:12px;color:##000000;">#GET_PRICE_SS.PACKAGE_TYPE#</label>
						</div>
					</cfif>
					<cfif len(GET_KARMA_PRODUCT.BRAND_NAME)>
						<div class="col col-12" style="text-align:left;">
							<label class="td-label"style="text-align:left;font-weight: bold;font-size:12px;color:##000000;line-height: 2px !important;color:##000000;">#GET_KARMA_PRODUCT.BRAND_NAME#</label>
						</div>
					</cfif>
					<cfif len(CHECK.asset_file_name3) and len(CHECK.asset_file_name3_server_id)>
						<div class="col col-12" style="text-align:left;">
							<br>
							<br>
							<cf_get_server_file output_file="settings/#CHECK.asset_file_name3#" output_server="#CHECK.asset_file_name3_server_id#" output_type="5">
							<br>
						</div>
					</cfif>
				</td>
			</tr>
		</table>
		<div style="page-break-after:always"></div>
	</cfoutput>
<cfelse>
	<script language="JavaScript">
		alert("<cf_get_lang dictionary_id='30029.Gönderilen veriler ile bu şablon kullanılamaz.'>!");
		history.back();
	</script>
	<cfabort> 
</cfif>
