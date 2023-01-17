
<cfquery name="GET_DETAIL" datasource="#dsn3#">
	SELECT 
		PRODUCTION_ORDERS.P_ORDER_NO,
		PRODUCTION_ORDERS.SPECT_VAR_ID,
		PRODUCTION_ORDERS.SPECT_VAR_NAME,
		PRODUCTION_ORDERS.ORDER_ID,
		PRODUCTION_ORDER_RESULTS.*
	FROM
		PRODUCTION_ORDERS,
		PRODUCTION_ORDER_RESULTS
	WHERE
		PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
		PRODUCTION_ORDERS.P_ORDER_ID = PRODUCTION_ORDER_RESULTS.P_ORDER_ID
</cfquery>
<cfquery name="GET_ROW_ENTER" datasource="#dsn3#">
    SELECT PORR.*,
    S.STOCK_CODE 
	
     FROM PRODUCTION_ORDER_RESULTS_ROW AS PORR
     LEFT JOIN STOCKS AS S ON S.STOCK_ID=PORR.STOCK_ID
	 LEFT JOIN #DSN1#.PRODUCT AS P ON P.PRODUCT_ID=S.PRODUCT_ID
	
     WHERE PORR.PR_ORDER_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.pr_order_id#"> AND PORR.TYPE = 1 and
	 PORR.STOCK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
</cfquery>
<cfif get_row_enter.recordcount>
	<cfoutput query="get_row_enter">
		<table  style="width:60mm;height:80mm;margin:5mm">
			<cfquery name="GET_PRICE_SS" datasource="#DSN3#"> <!--- standart satis --->
				SELECT	
					PS.PRICE,
					PS.PRICE_KDV,
					PS.IS_KDV,
					PS.ROUNDING,
					PS.MONEY,
					P.TAX,
					S.PROPERTY,
					CASE
						WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
						ELSE PU.ADD_UNIT
					END AS ADD_UNIT
				FROM 
					PRICE_STANDART AS PS,
					STOCKS AS S,
					PRODUCT AS P,
					PRODUCT_UNIT AS PU
					
					LEFT JOIN #DSN#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PU.UNIT_ID
					AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="UNIT">
					AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_UNIT">
					AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
				WHERE 
					S.STOCK_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#get_row_enter.stock_id#"> AND
					PS.PRODUCT_ID = S.PRODUCT_ID AND
					P.PRODUCT_ID=S.PRODUCT_ID AND
					PS.PURCHASESALES = 1 AND 
					PS.PRICESTANDART_STATUS = 1 AND 
					PU.PRODUCT_ID = PS.PRODUCT_ID AND 
					PS.UNIT_ID = PU.PRODUCT_UNIT_ID 
			</cfquery>
			<cfquery name="GET_ICON" datasource="#dsn1#">
				select
					PDP.PRODUCT_ID,
						PP.PROPERTY_SIZE, 
						PP.PROPERTY_COLOR,
						PP.PROPERTY_LEN,
						PPD.PROPERTY_DETAIL,
						PPD.ICON_PATCH
					FROM
						PRODUCT_DT_PROPERTIES AS  PDP
						LEFT JOIN #DSN1#.PRODUCT AS P ON P.PRODUCT_ID = PDP.PRODUCT_ID
						LEFT JOIN  #DSN1#.PRODUCT_PROPERTY as PP ON  PP.PROPERTY_ID = PDP.PROPERTY_ID 
						LEFT JOIN #DSN1#.PRODUCT_PROPERTY_DETAIL as PPD ON PDP.VARIATION_ID = PPD.PROPERTY_DETAIL_ID
					WHERE
						PDP.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#"> AND
						PP.PROPERTY_LEN =0 AND PP.PROPERTY_COLOR=0 AND  PP.PROPERTY_SIZE=0 AND PDP.IS_EXIT=1
				</cfquery>
			<tr >
				<td>
					<div class="col col-12">
						<label class="td-label"  style="text-align:left;" >#STOCK_CODE#</label>
					</div>
					<div class="col col-12">
						<label class="td-label"  style="text-align:left;font-size:18px;font-weight: bold;color:black;">#name_product#</label>
					</div>
					<cfif len(get_row_enter.BARCODE)>
						<div class="col col-12">
							<label class="td-label"  style="text-align:center;margin-left:20px;" >
								<cf_workcube_barcode type="code39" show="1" value="#get_row_enter.BARCODE#"  width="50" height="60">
							</label>
						</div>
						<div class="col col-12">
							<label class="td-label"  style="text-align:center;font-size:8px;letter-spacing:2mm;line-height: 1px !important;margin-left:20px;" >
								#get_row_enter.BARCODE#
							</label>
						</div>
					</cfif>
					<cfif len(GET_PRICE_SS.PRICE_KDV)>
						<div class="col col-12">
							<br>
							<label class="td-label"  style="text-align:left;font-size:24px;font-weight: bold;color:black;">#tlformat(GET_PRICE_SS.PRICE_KDV,2)# #GET_PRICE_SS.money#</label>
						</div>
						
						<cfif len(GET_PRICE_SS.tax)>
							<div class="col col-12">
								<label class="td-label"  style="text-align:left;font-size:9px;font-weight: bold;color:black;line-height: 3px !important;margin-left:7px;" >%#GET_PRICE_SS.tax#  <cf_get_lang dictionary_id='64382.KDV Dahil Fiyat'></label>
							</div>
						</cfif>
					</cfif>
					
					<div class="col col-12">
						<div class="col col-4" style="text-align:left;margin-left:-12px;">
						<cf_workcube_barcode show="1" type="qrcode" width="70" height="70" value="#get_detail.result_no#">
						</div>
						<cfif LEN(GET_ICON.ICON_PATCH)>
							<cfloop query="GET_ICON">
								<div class="col col-2" style="text-align:left;">
									<img src="/css/assets/icons/catalyst-icon-svg/#GET_ICON.ICON_PATCH#.svg" width="30" height="80">
								</div>
							</cfloop>
						</cfif>
					</div>
					<div class="col col-12" style="text-align:left;">
						<div class="col col-7">
							<label class="td-label"  style="text-align:left;font-size:10px;line-height: 1px !important;" ><cf_get_lang dictionary_id='29474.Emir No'>:</label><label class="td-label"  style="text-align:left;font-weight: bold;font-size:10px;color:black;line-height: 1px !important;">#get_detail.production_order_no#</label>
						</div>
						<div class="col col-5">
							<label class="td-label"  style="text-align:left;font-size:10px;line-height: 1px !important;"><cf_get_lang dictionary_id='45498.Lot No'>:</label>  <label class="td-label"  style="text-align:left;font-weight: bold;font-size:10px;color:black;line-height: 1px !important;">#get_detail.lot_no#</label>
						</div>
						
					</div>
					<div class="col col-12" style="text-align:left;">
						<div class="col col-6">
							<label class="td-label"  style="text-align:left;font-size:10px;line-height: 1px !important;" >U.T:</label>  <label class="td-label"  style="text-align:left;font-weight: bold;font-size:10px;color:black;line-height: 1px !important;">#dateformat(get_detail.start_date,dateformat_style)#</label>
						</div>
					</div>
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
