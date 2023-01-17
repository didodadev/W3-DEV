<!--- Malzeme ihtiyacları listeleme sayfasındaki ürünlerin, alternatif ürünlerini getirir. seçilen alternatif ürün, ilgili satırdaki sarfın yerine üretim emrine eklenir. hgul 20120207--->
<cfsetting showdebugoutput="no">
<cfquery name="get_product" datasource="#dsn3#">
	SELECT PRODUCT_ID,STOCK_ID FROM STOCKS WHERE STOCK_ID = #attributes.sid#
</cfquery>
<cfquery name="get_alternative" datasource="#dsn3#">
	SELECT 
		S.PRODUCT_NAME,
		S.STOCK_CODE,
		S.STOCK_ID,
		S.PRODUCT_ID,
		S.PRODUCT_UNIT_ID,
		PU.MAIN_UNIT
	FROM
		ALTERNATIVE_PRODUCTS AP,
		STOCKS S,
		PRODUCT_UNIT PU
	WHERE 
		S.PRODUCT_ID = AP.ALTERNATIVE_PRODUCT_ID AND
		AP.TREE_STOCK_ID IS NULL AND
		AP.PRODUCT_ID = #get_product.product_id# AND
		PU.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID
	ORDER BY ALTERNATIVE_PRODUCT_NO
</cfquery>
<cfif get_alternative.recordcount>
	<cfset stock_id_list = ''>
	<cfoutput query="get_alternative">
		<cfset stock_id_list = ListAppend(stock_id_list,stock_id)>
	</cfoutput>
	<cfif listlen(stock_id_list)>
		<cfquery name="get_stock_all" datasource="#dsn2#">
			SELECT 
				ISNULL(PRODUCT_STOCK,0) AS PRODUCT_STOCK,
				ISNULL(SALEABLE_STOCK,0) AS SALEABLE_STOCK,
				STOCK_ID
			FROM 
				(
				SELECT 
					ROUND(SUM(REAL_STOCK),4) REAL_STOCK,
					ROUND(SUM(PRODUCT_STOCK),4) PRODUCT_STOCK,
					ROUND(SUM(PRODUCT_STOCK+RESERVED_STOCK),4) SALEABLE_STOCK,
					ROUND(SUM(PURCHASE_ORDER_STOCK),4) PURCHASE_ORDER_STOCK,
					PRODUCT_ID, 
					STOCK_ID
				FROM
				(
					SELECT
						(SR.STOCK_IN - SR.STOCK_OUT) AS REAL_STOCK,
						0 AS PRODUCT_STOCK,
						0 AS RESERVED_STOCK,
						0 AS PURCHASE_ORDER_STOCK,
						SR.STOCK_ID,
						SR.PRODUCT_ID
					FROM
						STOCKS_ROW SR
				UNION ALL			
					SELECT
						0 AS REAL_STOCK,
						(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
						0 AS RESERVED_STOCK,
						0 AS PURCHASE_ORDER_STOCK,
						SR.STOCK_ID,
						SR.PRODUCT_ID
					FROM
						#dsn_alias#.STOCKS_LOCATION SL,
						STOCKS_ROW SR
					WHERE
						SR.STORE =SL.DEPARTMENT_ID
						AND SR.STORE_LOCATION=SL.LOCATION_ID
						AND SL.NO_SALE = 0
				UNION ALL
					SELECT
						0 AS REAL_STOCK,
						0 AS PRODUCT_STOCK,
						((RESERVE_STOCK_OUT-STOCK_OUT)*-1) AS RESERVED_STOCK,
						RESERVE_STOCK_IN AS PURCHASE_ORDER_STOCK,
						ORR.STOCK_ID,
						ORR.PRODUCT_ID
					FROM
						#dsn3_alias#.GET_ORDER_ROW_RESERVED ORR, 
						#dsn3_alias#.ORDERS ORDS
					WHERE
						ORDS.RESERVED = 1 AND 
						ORDS.ORDER_STATUS = 1 AND	
						ORR.ORDER_ID=ORDS.ORDER_ID AND 
						((RESERVE_STOCK_IN-STOCK_IN)>0 OR (RESERVE_STOCK_OUT-STOCK_OUT)>0)
				UNION ALL
					SELECT
						0 AS REAL_STOCK,
						0 AS PRODUCT_STOCK,
						(RESERVE_STOCK_IN-STOCK_IN) AS RESERVED_STOCK,
						0 AS PURCHASE_ORDER_STOCK,
						ORR.STOCK_ID,
						ORR.PRODUCT_ID
					FROM
						#dsn3_alias#.GET_ORDER_ROW_RESERVED ORR, 
						#dsn3_alias#.ORDERS ORDS,
						#dsn_alias#.STOCKS_LOCATION SL
					WHERE
						ORDS.RESERVED = 1 AND 
						ORDS.ORDER_STATUS = 1 AND	
						ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND 
						ORDS.LOCATION_ID=SL.LOCATION_ID AND 
						SL.NO_SALE = 0	 AND 
						ORR.ORDER_ID=ORDS.ORDER_ID AND 
						(RESERVE_STOCK_IN-STOCK_IN)>0
				UNION ALL			
					SELECT
						0 AS REAL_STOCK,
						0 AS PRODUCT_STOCK,
						((RESERVE_STOCK_IN-STOCK_IN) + ((RESERVE_STOCK_OUT-STOCK_OUT)*-1)) AS RESERVED_STOCK,
						0 AS PURCHASE_ORDER_STOCK,
						ORR.STOCK_ID,
						ORR.PRODUCT_ID
					FROM
						#dsn3_alias#.ORDER_ROW_RESERVED  ORR
					WHERE
						ORDER_ID IS NULL
						AND SHIP_ID IS NULL
						AND INVOICE_ID IS NULL
				UNION ALL
					SELECT
						0 AS REAL_STOCK,
						0 AS PRODUCT_STOCK,
						(STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
						0  AS PURCHASE_ORDER_STOCK,
						STOCK_ID,
						PRODUCT_ID
					FROM
						(
							SELECT
								SUM(STOCK_ARTIR) STOCK_ARTIR,
								SUM(STOCK_AZALT) STOCK_AZALT,
								S.STOCK_ID,
								S.PRODUCT_ID
							FROM
								(
									SELECT
										(QUANTITY) AS STOCK_ARTIR,
										0 AS STOCK_AZALT,
										STOCK_ID
									FROM
										#dsn3_alias#.PRODUCTION_ORDERS
									WHERE
										IS_STOCK_RESERVED = 1 AND
										IS_DEMONTAJ=0 AND
										SPEC_MAIN_ID IS NOT NULL
								UNION ALL
									SELECT
										0 AS STOCK_ARTIR,
										(QUANTITY) AS STOCK_AZALT,
										STOCK_ID
									FROM
										#dsn3_alias#.PRODUCTION_ORDERS
									WHERE
										IS_STOCK_RESERVED = 1 AND
										IS_DEMONTAJ=1 AND
										SPEC_MAIN_ID IS NOT NULL
								UNION ALL
									SELECT
										0 AS STOCK_ARTIR,
										POS.AMOUNT AS STOCK_AZALT,
										POS.STOCK_ID
									FROM
										#dsn3_alias#.PRODUCTION_ORDERS PO,
										#dsn3_alias#.PRODUCTION_ORDERS_STOCKS POS
									WHERE
										PO.IS_STOCK_RESERVED = 1 AND
										PO.P_ORDER_ID = POS.P_ORDER_ID AND
										PO.IS_DEMONTAJ=0 AND
										ISNULL(POS.STOCK_ID,0)>0 AND
										POS.IS_SEVK <> 1 AND
										ISNULL(IS_FREE_AMOUNT,0) = 0
								UNION ALL
									SELECT
										POS.AMOUNT AS STOCK_ARTIR,
										0 AS STOCK_AZALT,
										POS.STOCK_ID
									FROM
										#dsn3_alias#.PRODUCTION_ORDERS PO,
										#dsn3_alias#.PRODUCTION_ORDERS_STOCKS POS
									WHERE
										PO.IS_STOCK_RESERVED = 1 AND
										PO.P_ORDER_ID = POS.P_ORDER_ID AND
										PO.IS_DEMONTAJ=1 AND
										ISNULL(POS.STOCK_ID,0)>0 AND
										POS.IS_SEVK <> 1 AND
										ISNULL(IS_FREE_AMOUNT,0) = 0
								UNION ALL
									SELECT 
										(P_ORD_R_R.AMOUNT)*-1 AS  STOCK_ARTIR,
										0 AS STOCK_AZALT,
										P_ORD_R_R.STOCK_ID
									FROM
										#dsn3_alias#.PRODUCTION_ORDER_RESULTS P_ORD_R,
										#dsn3_alias#.PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R,
										#dsn3_alias#.PRODUCTION_ORDERS P_ORD
									WHERE
										P_ORD.IS_STOCK_RESERVED=1 AND
										P_ORD.SPEC_MAIN_ID IS NOT NULL AND
										P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
										P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
										P_ORD_R_R.TYPE=1 AND
										P_ORD_R.IS_STOCK_FIS=1 AND
										P_ORD_R_R.IS_SEVKIYAT IS NULL
								UNION ALL
									SELECT 
										0 AS STOCK_ARTIR,
										(P_ORD_R_R.AMOUNT)*-1 AS STOCK_AZALT,
										P_ORD_R_R.STOCK_ID
									FROM 
										#dsn3_alias#.PRODUCTION_ORDER_RESULTS P_ORD_R,
										#dsn3_alias#.PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R,
										#dsn3_alias#.PRODUCTION_ORDERS P_ORD
									WHERE
										P_ORD.IS_STOCK_RESERVED=1 AND
										P_ORD.SPEC_MAIN_ID IS NOT NULL AND
										P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
										P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
										P_ORD_R_R.TYPE=2 AND
										P_ORD_R.IS_STOCK_FIS=1 AND
										P_ORD_R_R.IS_SEVKIYAT <> 1
							) T1,
							#dsn3_alias#.STOCKS S
							WHERE
								S.STOCK_ID=T1.STOCK_ID
							GROUP BY 
								S.STOCK_ID,
								S.PRODUCT_ID
						)A1
				) T1
			GROUP BY
					PRODUCT_ID, 
					STOCK_ID
				) AS GET_STOCK_LAST
			WHERE
				STOCK_ID IN (#stock_id_list#)
		</cfquery>
		<cfoutput query="get_stock_all">
			<cfset "product_stock_#stock_id#" = get_stock_all.product_stock>
			<cfset "saleable_stock_#stock_id#" = get_stock_all.saleable_stock>
		</cfoutput>
	</cfif>
	<table cellspacing="1" cellpadding="2" width="100%" border="0" class="color-border">
		<tr height="22" class="color-list">
			<td class="txtbold">&nbsp;<cf_get_lang dictionary_id="36839.Alternatif Ürünler"></td>
		</tr>
		<tr>
			<td class="color-row" valign="top">
				<cfform name="alternative_stock_#attributes.crtrow#" id="alternative_stock_#attributes.crtrow#" method="post" action="#request.self#?fuseaction=prod.emptypopup_add_sub_product_fire&is_alternative=1">
					<cfoutput>
						<input type="hidden" name="sarf_product_id" id="sarf_product_id" value="#get_product.product_id#"/>
						<input type="hidden" name="sarf_stock_id" id="sarf_stock_id" value="#get_product.stock_id#"/>
						<input type="hidden" name="type" id="type" value="2">
						<input type="hidden" name="crtrow" id="crtrow" value="#attributes.crtrow#">
					</cfoutput>
					<table border="0" cellspacing="1" cellpadding="2">
						<tr class="txtbold" nowrap="nowrap">
							<td></td>
							<td class="txtboldblue"><cf_get_lang dictionary_id='57518.Stok Kodu'></td>
							<td class="txtboldblue"><cf_get_lang dictionary_id='57657.Ürün'></td>
							<td class="txtboldblue"><cf_get_lang dictionary_id='57636.Birim'></td>
							<td class="txtboldblue" style="text-align:right"><cf_get_lang dictionary_id='36857.Satılabilir Stok'></td>
						</tr>
						<cfoutput query="get_alternative">
							<tr nowrap="nowrap">
								<td>
									<input type="Radio" name="alter_product#attributes.crtrow#" id="alter_product#attributes.crtrow#" value="#STOCK_ID#-#PRODUCT_ID#-#PRODUCT_UNIT_ID#">
								</td>
								<td style="width:150px;">#stock_code#</td>
								<td style="width:200px;">#PRODUCT_NAME#</td>
								<td style="width:200px;">#MAIN_UNIT#</td>
								<td style="width:100px;text-align:right">#TLformat(evaluate('saleable_stock_#stock_id#'))#</td>
							</tr>
						</cfoutput>
						<tr class="color-row" id="show_info_#<cfoutput>#attributes.crtrow#</cfoutput>#">
							<td style="text-align:right" colspan="4"><div id="SHOW_INFO_<cfoutput>#attributes.crtrow#</cfoutput>"></div></td>
							<td><input type="button" value="<cf_get_lang dictionary_id ='57464.Güncelle'>" onClick="AjaxFormSubmit('alternative_stock_<cfoutput>#attributes.crtrow#', 'SHOW_INFO_#attributes.crtrow#'</cfoutput>,1,'<cf_get_lang dictionary_id ='29723.Güncelleniyor'>','<cf_get_lang dictionary_id ='29724.Güncellendi'>!');"></td>
						</tr>
					</table>
				</cfform>
			</td>
		</tr>
	</table>	
<cfelse>
	<cf_get_lang dictionary_id="58486.Kayıt Bulunamadı">!
</cfif>
