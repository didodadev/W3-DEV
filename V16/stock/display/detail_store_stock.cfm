<!---
	1- Id
	2- Product_id
	3- Department_Id
	 #request.self#?fuseaction=stock.detail_store_stock_popup&id=#get_stocks_all.stock_id#&epartment=#store#&product_id=#url.pid# 	
--->
<!--- <cfinclude template="../query/get_location.cfm"> --->
<cf_xml_page_edit>
<cfinclude template="../query/get_stores.cfm">
<cfparam name="attributes.is_amount_order" default="0">
<cfparam name="attributes.stok_turu" default="2">
<cfparam name="attributes.modal_id" default="">
<cfquery name="get_location" datasource="#dsn2#">
	SELECT
		SUM(STOCK_IN-STOCK_OUT) AS TOTAL_STOCK,
		SL.COMMENT,
		STORE,
		STORE_LOCATION,
		DEPARTMENT_HEAD,
		SL.STATUS
	FROM
		STOCKS_ROW SR,
		#dsn_alias#.STOCKS_LOCATION SL,
		#dsn_alias#.DEPARTMENT D
	WHERE
		PROCESS_TYPE IS NOT NULL
		<cfif isdefined("attributes.department") and len(attributes.department)>
			AND SL.DEPARTMENT_ID = #attributes.department#
		</cfif>
		<cfif xml_dsp_pasive_location eq 0>
			AND SL.STATUS = 1
		</cfif>
		<cfif isdefined("attributes.stock_id")>
			AND SR.STOCK_ID =#attributes.stock_id#
		<cfelse>
			AND SR.PRODUCT_ID =#attributes.pid#
		</cfif>
		AND SL.DEPARTMENT_ID = D.DEPARTMENT_ID
		AND SR.STORE=SL.DEPARTMENT_ID
		AND SR.STORE_LOCATION=SL.LOCATION_ID	
	GROUP BY
		STORE,
		STORE_LOCATION,
		DEPARTMENT_HEAD,
		COMMENT,
		SL.STATUS
	<cfif xml_filter_stock_amount eq 1 and attributes.stok_turu eq 2>
		HAVING
			SUM(STOCK_IN-STOCK_OUT) > 0
	</cfif>
	<cfif not (xml_filter_stock_amount eq 1 and attributes.stok_turu eq 2)>
		UNION ALL
		SELECT 
			0 AS TOTAL_STOCK,
			SL.COMMENT,
			SL.DEPARTMENT_ID AS STORE,
			SL.LOCATION_ID AS STORE_LOCATION ,
			DEPARTMENT_HEAD,
			SL.STATUS
		FROM
			#dsn_alias#.STOCKS_LOCATION SL,
			#dsn_alias#.DEPARTMENT D
		WHERE
			SL.DEPARTMENT_ID = D.DEPARTMENT_ID
			<cfif xml_dsp_pasive_location eq 0>
				AND SL.STATUS = 1
			</cfif>
			<cfif isdefined("attributes.department") and len(attributes.department)>
				AND SL.DEPARTMENT_ID = #attributes.department#
			</cfif>
			<cfif isdefined("attributes.stock_id")>
				AND SL.DEPARTMENT_ID NOT IN(SELECT SRR.STORE FROM STOCKS_ROW SRR WHERE SRR.STOCK_ID =#attributes.stock_id# AND SRR.STORE IS NOT NULL)
			<cfelse>
				AND SL.DEPARTMENT_ID NOT IN(SELECT SRR.STORE FROM STOCKS_ROW SRR WHERE SRR.PRODUCT_ID =#attributes.pid# AND SRR.STORE IS NOT NULL)
			</cfif>
			AND SL.DEPARTMENT_ID IN(#valuelist(stores.department_id)#)
	</cfif>
	<cfif isdefined ("attributes.is_amount_order") and attributes.is_amount_order eq 1>
		ORDER BY TOTAL_STOCK DESC
	<cfelse>
		ORDER BY DEPARTMENT_HEAD
	</cfif>
</cfquery>
<cfif isdefined('xml_dsp_stock_reserve_info') and xml_dsp_stock_reserve_info eq 1>
	<cfquery name="GET_LOCATION_SALE_RESERVE_INFO" datasource="#DSN3#">
		SELECT
			SUM(OR_R.QUANTITY-CANCEL_AMOUNT) AS RESERVE_SALE_ORDER_STOCK,
			ORR.PRODUCT_ID,
			ORR.STOCK_ID,
			ISNULL(OR_R.DELIVER_DEPT,ORDS.DELIVER_DEPT_ID) DEPARTMENT_ID,
			ISNULL(OR_R.DELIVER_LOCATION,ORDS.LOCATION_ID) LOCATION_ID
		FROM
			GET_ORDER_ROW_RESERVED ORR, 
			ORDERS ORDS,
			ORDER_ROW OR_R
		WHERE
			ORDS.RESERVED = 1
            AND OR_R.RESERVE_TYPE <> -4 
			AND ((ORDS.PURCHASE_SALES = 1 AND ORDS.ORDER_ZONE = 0) OR (ORDS.PURCHASE_SALES = 0 AND ORDS.ORDER_ZONE = 1))
			AND ORDS.ORDER_STATUS = 1	
			AND ORDS.DELIVER_DEPT_ID IS NOT NULL
			AND ORDS.LOCATION_ID IS NOT NULL
			AND OR_R.ORDER_ID = ORDS.ORDER_ID
			<cfif isdefined("attributes.stock_id")>
				AND ORR.STOCK_ID = #attributes.stock_id#
				AND OR_R.STOCK_ID = #attributes.stock_id#
			<cfelse>
				AND ORR.PRODUCT_ID = #attributes.pid#
				AND OR_R.PRODUCT_ID = #attributes.pid#
			</cfif>
			<cfif isdefined("attributes.department") and len(attributes.department)>          
				AND ISNULL(OR_R.DELIVER_DEPT,ORDS.DELIVER_DEPT_ID) = #attributes.department#
			</cfif>
			AND ORR.ORDER_ID = ORDS.ORDER_ID          
			AND ((RESERVE_STOCK_IN-STOCK_IN)>0 OR (RESERVE_STOCK_OUT-STOCK_OUT)>0)
		GROUP BY
			ORR.PRODUCT_ID,
			ORR.STOCK_ID,
			ISNULL(OR_R.DELIVER_DEPT,ORDS.DELIVER_DEPT_ID),
			ISNULL(OR_R.DELIVER_LOCATION,ORDS.LOCATION_ID)
		ORDER BY
			ISNULL(OR_R.DELIVER_DEPT,ORDS.DELIVER_DEPT_ID),
			ISNULL(OR_R.DELIVER_LOCATION,ORDS.LOCATION_ID)
	</cfquery>
	<cfquery name="GET_LOCATION_PUR_RESERVE_INFO" datasource="#DSN3#">
		SELECT
			SUM(OR_R.QUANTITY-CANCEL_AMOUNT) AS RESERVE_PURCHASE_ORDER_STOCK,
			ORR.PRODUCT_ID,
			ORR.STOCK_ID,
			ISNULL(OR_R.DELIVER_DEPT,ORDS.DELIVER_DEPT_ID) DEPARTMENT_ID,
			ISNULL(OR_R.DELIVER_LOCATION,ORDS.LOCATION_ID) LOCATION_ID
		FROM
			GET_ORDER_ROW_RESERVED ORR, 
			ORDERS ORDS,
			ORDER_ROW OR_R
		WHERE
			ORDS.RESERVED = 1
			AND ORDS.PURCHASE_SALES = 0 
			AND ORDS.ORDER_ZONE = 0
			AND ORDS.ORDER_STATUS = 1
            AND OR_R.RESERVE_TYPE <> -3 
            AND OR_R.ORDER_ROW_CURRENCY NOT IN(-9,-10,-8) 	
			AND ORDS.DELIVER_DEPT_ID IS NOT NULL
			AND ORDS.LOCATION_ID IS NOT NULL
			AND OR_R.ORDER_ID = ORDS.ORDER_ID
			<cfif isdefined("attributes.stock_id")>
				AND ORR.STOCK_ID = #attributes.stock_id#
				AND OR_R.STOCK_ID = #attributes.stock_id#
			<cfelse>
				AND ORR.PRODUCT_ID = #attributes.pid#
				AND OR_R.PRODUCT_ID = #attributes.pid#
			</cfif>
			<cfif isdefined("attributes.department") and len(attributes.department)>
				AND ISNULL(OR_R.DELIVER_DEPT,ORDS.DELIVER_DEPT_ID) = #attributes.department#
			</cfif>
			AND ORR.ORDER_ID = ORDS.ORDER_ID 
			AND  (ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) > 0 
		GROUP BY
			ORR.PRODUCT_ID,
			ORR.STOCK_ID,
			ISNULL(OR_R.DELIVER_DEPT,ORDS.DELIVER_DEPT_ID),
			ISNULL(OR_R.DELIVER_LOCATION,ORDS.LOCATION_ID)
		ORDER BY
			ISNULL(OR_R.DELIVER_DEPT,ORDS.DELIVER_DEPT_ID),
			ISNULL(OR_R.DELIVER_LOCATION,ORDS.LOCATION_ID)
	</cfquery>
	<cfif GET_LOCATION_SALE_RESERVE_INFO.RECORDCOUNT>
		<cfscript>
			for(prod_ii=1;prod_ii lte GET_LOCATION_SALE_RESERVE_INFO.recordcount; prod_ii=prod_ii+1)
			{
				if(len(evaluate('GET_LOCATION_SALE_RESERVE_INFO.DEPARTMENT_ID[prod_ii]')))
				'stock_sale_reserve_amount_#GET_LOCATION_SALE_RESERVE_INFO.DEPARTMENT_ID[prod_ii]#_#GET_LOCATION_SALE_RESERVE_INFO.LOCATION_ID[prod_ii]#' = 0;				
		    }
			for(prod_ii=1;prod_ii lte GET_LOCATION_SALE_RESERVE_INFO.recordcount; prod_ii=prod_ii+1)
			{
				if(len(evaluate('GET_LOCATION_SALE_RESERVE_INFO.DEPARTMENT_ID[prod_ii]')))
				'stock_sale_reserve_amount_#GET_LOCATION_SALE_RESERVE_INFO.DEPARTMENT_ID[prod_ii]#_#GET_LOCATION_SALE_RESERVE_INFO.LOCATION_ID[prod_ii]#' = evaluate('stock_sale_reserve_amount_#GET_LOCATION_SALE_RESERVE_INFO.DEPARTMENT_ID[prod_ii]#_#GET_LOCATION_SALE_RESERVE_INFO.LOCATION_ID[prod_ii]#') + GET_LOCATION_SALE_RESERVE_INFO.RESERVE_SALE_ORDER_STOCK[prod_ii];
			}
		</cfscript>
	</cfif>
	<cfif GET_LOCATION_PUR_RESERVE_INFO.RECORDCOUNT>
		<cfscript>
			for(prod_ii=1;prod_ii lte GET_LOCATION_PUR_RESERVE_INFO.recordcount; prod_ii=prod_ii+1)
			{
				if(len(evaluate('GET_LOCATION_PUR_RESERVE_INFO.DEPARTMENT_ID[prod_ii]')))
				'stock_purchase_reserve_amount_#GET_LOCATION_PUR_RESERVE_INFO.DEPARTMENT_ID[prod_ii]#_#GET_LOCATION_PUR_RESERVE_INFO.LOCATION_ID[prod_ii]#' = 0;
		    }
			for(prod_ii=1;prod_ii lte GET_LOCATION_PUR_RESERVE_INFO.recordcount; prod_ii=prod_ii+1)
			{
				if(len(evaluate('GET_LOCATION_PUR_RESERVE_INFO.DEPARTMENT_ID[prod_ii]')))
				'stock_purchase_reserve_amount_#GET_LOCATION_PUR_RESERVE_INFO.DEPARTMENT_ID[prod_ii]#_#GET_LOCATION_PUR_RESERVE_INFO.LOCATION_ID[prod_ii]#' =evaluate('stock_purchase_reserve_amount_#GET_LOCATION_PUR_RESERVE_INFO.DEPARTMENT_ID[prod_ii]#_#GET_LOCATION_PUR_RESERVE_INFO.LOCATION_ID[prod_ii]#') + GET_LOCATION_PUR_RESERVE_INFO.RESERVE_PURCHASE_ORDER_STOCK[prod_ii];
			}
		</cfscript>
	</cfif>
	<!--- Depolara göre üretim rezerveler,view haline getirmedim ama ilerde view yapılabilir..hatta rezerveleri getiren view düzenlenebilir... --->
    <cfquery name="get_product_rezerv_loc" datasource="#dsn3#">    	
		SELECT
            SUM(STOCK_ARTIR) STOCK_ARTIR,
            SUM(STOCK_AZALT) STOCK_AZALT,
            S.STOCK_ID,
            S.PRODUCT_ID,
            EXIT_DEP_ID AS DEPARTMENT_ID,
            EXIT_LOC_ID AS LOCATION_ID,
            PRODUCTION_DEP_ID,
			PRODUCTION_LOC_ID
        FROM
            (
          	 SELECT
                    (QUANTITY) AS STOCK_ARTIR,
                    0 AS STOCK_AZALT,
                    STOCK_ID,
                    EXIT_DEP_ID,
                    EXIT_LOC_ID,
                    PRODUCTION_DEP_ID,
                    PRODUCTION_LOC_ID
                    
                FROM
                    PRODUCTION_ORDERS
                WHERE
                    IS_STOCK_RESERVED = 1 AND
                    IS_DEMONTAJ=0 AND
                    SPEC_MAIN_ID IS NOT NULL
                    AND STATUS=1
					<cfif isdefined("attributes.stock_id")>
						AND STOCK_ID = #attributes.stock_id#
					<cfelse>
						AND (SELECT TOP 1 SS.PRODUCT_ID FROM STOCKS SS WHERE SS.STOCK_ID = PRODUCTION_ORDERS.STOCK_ID) = #attributes.pid#
					</cfif>
            UNION ALL
                SELECT
                    0 AS STOCK_ARTIR,
                    (QUANTITY) AS STOCK_AZALT,
                    STOCK_ID,
                    EXIT_DEP_ID,
                    EXIT_LOC_ID,
                    PRODUCTION_DEP_ID,
                    PRODUCTION_LOC_ID
                FROM
                    PRODUCTION_ORDERS
                WHERE
                    IS_STOCK_RESERVED = 1 AND
                    IS_DEMONTAJ=1 AND
                    SPEC_MAIN_ID IS NOT NULL
                    AND STATUS=1
                    <cfif isdefined("attributes.stock_id")>
						AND STOCK_ID = #attributes.stock_id#
					<cfelse>
						AND (SELECT TOP 1 SS.PRODUCT_ID FROM STOCKS SS WHERE SS.STOCK_ID = PRODUCTION_ORDERS.STOCK_ID) = #attributes.pid#
					</cfif>
            UNION ALL
              SELECT
					0 AS STOCK_ARTIR,
                   CASE WHEN ISNULL((SELECT
											SUM(POR_.AMOUNT)
										FROM
											PRODUCTION_ORDER_RESULTS_ROW POR_,
											PRODUCTION_ORDER_RESULTS POO
										WHERE
											POR_.PR_ORDER_ID = POO.PR_ORDER_ID
											AND POO.P_ORDER_ID = PO.P_ORDER_ID
											AND POR_.STOCK_ID = POS.STOCK_ID
											AND POO.IS_STOCK_FIS = 1
										),0) > (ISNULL(PO.RESULT_AMOUNT,0))
										
						THEN
						(
							(
                            SELECT 
								SUM(AMOUNT) AMOUNT
							FROM
								PRODUCTION_ORDERS_STOCKS
							WHERE
								P_ORDER_ID = PO.P_ORDER_ID 
                                AND STOCK_ID = POS.STOCK_ID
                            )
                            /
                            (
							SELECT 
								QUANTITY 
							FROM 
								PRODUCTION_ORDERS
							WHERE 
                            P_ORDER_ID = PO.P_ORDER_ID
                            )
                            )*(ISNULL(PO.QUANTITY,0) - ISNULL(PO.RESULT_AMOUNT,0))
						 ELSE 									
                         (((POS.AMOUNT*(ISNULL(PO.QUANTITY,0) - ISNULL(PO.RESULT_AMOUNT,0)))/(ISNULL(NULLIF(PO.QUANTITY,0),1)))) END AS STOCK_AZALT,
					POS.STOCK_ID,
					EXIT_DEP_ID,
                    EXIT_LOC_ID,
                    PRODUCTION_DEP_ID,
                    PRODUCTION_LOC_ID
				FROM
					PRODUCTION_ORDERS PO,
					PRODUCTION_ORDERS_STOCKS POS
				WHERE
					PO.IS_STOCK_RESERVED = 1 AND
					POS.P_ORDER_ID = PO.P_ORDER_ID AND
					PO.IS_DEMONTAJ=0 AND
					ISNULL(POS.STOCK_ID,0)>0 AND
					POS.IS_SEVK <> 1 AND
					ISNULL(IS_FREE_AMOUNT,0) = 0
                    AND PO.STATUS=1
					<cfif isdefined("attributes.stock_id")>
                 	   AND POS.STOCK_ID = #attributes.stock_id#
					<cfelse>
                 	   AND POS.PRODUCT_ID = #attributes.pid#
					</cfif>
            UNION ALL
				SELECT
					POS.AMOUNT AS STOCK_ARTIR,
					0 AS STOCK_AZALT,
					POS.STOCK_ID,
					EXIT_DEP_ID,
                    EXIT_LOC_ID,
                    PRODUCTION_DEP_ID,
                    PRODUCTION_LOC_ID
				FROM
					PRODUCTION_ORDERS PO,
					PRODUCTION_ORDERS_STOCKS POS
				WHERE
					PO.IS_STOCK_RESERVED = 1 AND
					POS.P_ORDER_ID = PO.P_ORDER_ID AND
					PO.IS_DEMONTAJ=1 AND
					ISNULL(POS.STOCK_ID,0)>0 AND
					POS.IS_SEVK <> 1 AND
					ISNULL(IS_FREE_AMOUNT,0) = 0
                    AND PO.STATUS=1
					<cfif isdefined("attributes.stock_id")>
                 	   AND POS.STOCK_ID = #attributes.stock_id#
					<cfelse>
                 	   AND POS.PRODUCT_ID = #attributes.pid#
					</cfif>
            UNION ALL
                SELECT
                    (P_ORD_R_R.AMOUNT)*-1 AS  STOCK_ARTIR,
                    0 AS STOCK_AZALT,
                    P_ORD_R_R.STOCK_ID,
                    P_ORD_R.EXIT_DEP_ID,
                    P_ORD_R.EXIT_LOC_ID,
                    P_ORD_R.PRODUCTION_DEP_ID,
                    P_ORD_R.PRODUCTION_LOC_ID
                FROM
                    PRODUCTION_ORDER_RESULTS P_ORD_R,
                    PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R,
                    PRODUCTION_ORDERS P_ORD
                WHERE
                    P_ORD.IS_STOCK_RESERVED=1 AND
                    P_ORD.SPEC_MAIN_ID IS NOT NULL AND
                    P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                    P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                    P_ORD_R_R.TYPE=1 AND
                    P_ORD_R.IS_STOCK_FIS=1 AND
                    P_ORD_R_R.IS_SEVKIYAT IS NULL
                    AND P_ORD.STATUS=1
                    <cfif isdefined("attributes.stock_id")>
                 	   AND P_ORD_R_R.STOCK_ID = #attributes.stock_id#
					<cfelse>
                 	   AND P_ORD_R_R.PRODUCT_ID = #attributes.pid#
					</cfif>
            <!---UNION ALL
                SELECT 
                    0 AS STOCK_ARTIR,
                    (P_ORD_R_R.AMOUNT)*-1 AS STOCK_AZALT,
                    P_ORD_R_R.STOCK_ID,
                    P_ORD_R.EXIT_DEP_ID,
                    P_ORD_R.EXIT_LOC_ID,
                    P_ORD_R.PRODUCTION_DEP_ID,
                    P_ORD_R.PRODUCTION_LOC_ID
                FROM 
                    PRODUCTION_ORDER_RESULTS P_ORD_R,
                    PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R,
                    PRODUCTION_ORDERS P_ORD
                WHERE
                    P_ORD.IS_STOCK_RESERVED=1 AND
                    P_ORD.SPEC_MAIN_ID IS NOT NULL AND
                    P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                    P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                    P_ORD_R_R.TYPE IN(2,3) AND
                    P_ORD_R.IS_STOCK_FIS=1 AND
                    P_ORD_R_R.IS_SEVKIYAT <> 1
					AND P_ORD.STATUS=1
                    <cfif isdefined("attributes.stock_id")>
                 	   AND P_ORD_R_R.STOCK_ID = #attributes.stock_id#
					<cfelse>
                 	   AND P_ORD_R_R.PRODUCT_ID = #attributes.pid#
					</cfif>--->
        ) T1,
        #dsn1_alias#.STOCKS S
        WHERE
            S.STOCK_ID=T1.STOCK_ID
        GROUP BY 
            S.STOCK_ID,
            S.PRODUCT_ID,
            T1.EXIT_DEP_ID,
            T1.EXIT_LOC_ID,
            T1.PRODUCTION_DEP_ID,
            T1.PRODUCTION_LOC_ID
    </cfquery>
	<cfif get_product_rezerv_loc.RECORDCOUNT>
        <cfscript>
			  for(prod_jj=1;prod_jj lte get_product_rezerv_loc.recordcount; prod_jj=prod_jj+1){
				if(len(evaluate('get_product_rezerv_loc.DEPARTMENT_ID[prod_jj]')))
                'stock_prod_rezerve_#get_product_rezerv_loc.DEPARTMENT_ID[prod_jj]#_#get_product_rezerv_loc.LOCATION_ID[prod_jj]#' = 0;
				if(len(evaluate('get_product_rezerv_loc.PRODUCTION_DEP_ID[prod_jj]')))
				'stock_prod_beklenen_#get_product_rezerv_loc.PRODUCTION_DEP_ID[prod_jj]#_#get_product_rezerv_loc.PRODUCTION_LOC_ID[prod_jj]#' = 0;
		    }
            for(prod_jj=1;prod_jj lte get_product_rezerv_loc.recordcount; prod_jj=prod_jj+1){
				if(len(evaluate('get_product_rezerv_loc.DEPARTMENT_ID[prod_jj]')))
                'stock_prod_rezerve_#get_product_rezerv_loc.DEPARTMENT_ID[prod_jj]#_#get_product_rezerv_loc.LOCATION_ID[prod_jj]#' = evaluate('stock_prod_rezerve_#get_product_rezerv_loc.DEPARTMENT_ID[prod_jj]#_#get_product_rezerv_loc.LOCATION_ID[prod_jj]#') +  get_product_rezerv_loc.STOCK_AZALT[prod_jj];
				if(len(evaluate('get_product_rezerv_loc.PRODUCTION_DEP_ID[prod_jj]')))
				'stock_prod_beklenen_#get_product_rezerv_loc.PRODUCTION_DEP_ID[prod_jj]#_#get_product_rezerv_loc.PRODUCTION_LOC_ID[prod_jj]#' = evaluate('stock_prod_beklenen_#get_product_rezerv_loc.PRODUCTION_DEP_ID[prod_jj]#_#get_product_rezerv_loc.PRODUCTION_LOC_ID[prod_jj]#')+ get_product_rezerv_loc.STOCK_ARTIR[prod_jj];
		    }
        </cfscript>
    </cfif>
</cfif>
<cfquery name="GET_PRODUCT_" datasource="#DSN3#">
	SELECT 
		PU.MAIN_UNIT,
		P.PRODUCT_NAME,
		S.PROPERTY
	FROM
		PRODUCT_UNIT PU,
		PRODUCT P,
		STOCKS S
	WHERE
		S.PRODUCT_ID = P.PRODUCT_ID AND
		 <cfif isdefined("attributes.stock_id")>
			S.STOCK_ID = #attributes.stock_id# AND
			PU.PRODUCT_ID = #attributes.product_id# AND
		<cfelse>
			S.PRODUCT_ID = #attributes.pid# AND
		</cfif>
		P.PRODUCT_ID = PU.PRODUCT_ID
</cfquery>
<cfset url_new = ''>
<cfif isdefined("attributes.stock_id")>
	<cfset url_new = "&stock_id=#attributes.stock_id#">
	<cfset url_new = "#url_new#&product_id=#attributes.product_id#">
<cfelse>
	<cfset url_new = "&pid=#attributes.pid#">
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('stock',44)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="search_detail_store_stock" action="#request.self#?fuseaction=stock.detail_store_stock_popup#url_new#">
			<cf_box_search more="0">
				<div class="form-group" id="item-is_amount_order">
					<label><input type="checkbox" name="is_amount_order" id="is_amount_order" value="1"  <cfif isdefined ('attributes.is_amount_order') and attributes.is_amount_order eq 1>Checked</cfif>><cf_get_lang dictionary_id='45612.Miktara Göre Sırala'></label>
				</div>
				<cfif xml_filter_stock_amount eq 1>
					<div class="form-group" id="item-stok_turu">
						<select name="stok_turu" id="stok_turu">
							<option value="1" <cfif attributes.stok_turu eq 1>selected</cfif>><cf_get_lang dictionary_id='58081.Hepsi'></option>
							<option value="2" <cfif attributes.stok_turu eq 2> selected </cfif>><cf_get_lang dictionary_id='45183.Stoğu Olanlar'></option>									
						</select>
					</div>
				</cfif>
				<div class="form-group" id="item-department">
					<select name="department" id="department">
						<option value=""><cf_get_lang dictionary_id='45910.Tüm Depolar'></option>
						<cfoutput query="stores"> 
							<option value="#stores.department_id#"<cfif isDefined("attributes.department") and (attributes.department eq stores.department_id)>selected</cfif>>#stores.department_head# </option>
						</cfoutput> 
					</select>
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_detail_store_stock' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
		<cf_grid_list>
			<thead>
				<tr> 
					<th colspan="<cfif isdefined('xml_dsp_stock_reserve_info') and xml_dsp_stock_reserve_info eq 1>6<cfelse>2</cfif>"><cf_get_lang dictionary_id='57657.ürün'>: <cfoutput>#get_product_.product_name#- #get_product_.property#</cfoutput></td>
				</tr>
				<tr> 
					<th><cf_get_lang dictionary_id='30031.Lokasyon'><cfif xml_dsp_shelf_stock eq 1> / <cf_get_lang dictionary_id='29944.Raflar'></cfif></th>
					<th><cf_get_lang dictionary_id='57635.Miktar'></th>
					<cfif isdefined('xml_dsp_stock_reserve_info') and xml_dsp_stock_reserve_info eq 1>
						<th><cf_get_lang dictionary_id='40224.Alınan Sipariş'> <cf_get_lang dictionary_id='29750.Rezerve'></th>
						<th><cf_get_lang dictionary_id='45243.Verilen Sipariş Bekleyen'></th>
						<th><cf_get_lang dictionary_id='45388.Üretim Emirleri'>/<cf_get_lang dictionary_id='29750.Rezerve'></th>
						<th><cf_get_lang dictionary_id='45388.Üretim Emirleri'>/<cf_get_lang dictionary_id='58119.Beklenen'></th>
					</cfif>
				</tr>
			</thead>
			<tbody>
				<cfif get_location.recordcount eq 0>
					<tr>
						<td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>	
					</tr>	
				</cfif>
				<cfoutput query="get_location">
					<tr>
						<td><cfif status eq 0><font color="FF0000"></cfif>#department_head# - #comment#<cfif status eq 0></font></cfif></td>
						<td style="text-align:right;">
							<cfif TOTAL_STOCK LT 0 and TOTAL_STOCK neq 0>
								<font color="##FF0000">#tlformat(total_stock)#</font>
							<cfelse>
								#tlformat(total_stock)#
							</cfif>
							#get_product_.main_unit#
						</td>
						<cfif isdefined('xml_dsp_stock_reserve_info') and xml_dsp_stock_reserve_info eq 1>
							<td style="text-align:right;">
								<cfif isdefined('stock_sale_reserve_amount_#STORE#_#STORE_LOCATION#') and len(evaluate('stock_sale_reserve_amount_#STORE#_#STORE_LOCATION#'))>
									#AmountFormat(evaluate('stock_sale_reserve_amount_#STORE#_#STORE_LOCATION#'))#
								</cfif>
							</td>
							<td style="text-align:right;">
								<cfif isdefined('stock_purchase_reserve_amount_#STORE#_#STORE_LOCATION#') and len(evaluate('stock_purchase_reserve_amount_#STORE#_#STORE_LOCATION#'))>
									#AmountFormat(evaluate('stock_purchase_reserve_amount_#STORE#_#STORE_LOCATION#'))#
								</cfif>
							</td>
							<td style="text-align:right;">
								<cfif isdefined('stock_prod_rezerve_#STORE#_#STORE_LOCATION#') and len(evaluate('stock_prod_rezerve_#STORE#_#STORE_LOCATION#'))>
									#AmountFormat(evaluate('stock_prod_rezerve_#STORE#_#STORE_LOCATION#'))#
								</cfif>
							</td>
							<td style="text-align:right;">
								<cfif isdefined('stock_prod_beklenen_#STORE#_#STORE_LOCATION#') and len(evaluate('stock_prod_beklenen_#STORE#_#STORE_LOCATION#'))>
									#AmountFormat(evaluate('stock_prod_beklenen_#STORE#_#STORE_LOCATION#'))#
								</cfif>
							</td>
						</cfif>
					</tr>
					<cfif xml_dsp_shelf_stock eq 1>
						<cfquery name="get_shelfes" datasource="#dsn2#">
							SELECT
								SUM(STOCK_IN-STOCK_OUT) AS TOTAL_STOCK,
								PP.SHELF_CODE,
								SHELF.SHELF_NAME SHELF_TYPE
							FROM 
								STOCKS_ROW SR,
								#dsn3_alias#.PRODUCT_PLACE PP LEFT JOIN #dsn_alias#.SHELF ON SHELF.SHELF_ID = PP.SHELF_TYPE
							WHERE
								PROCESS_TYPE IS NOT NULL AND
								SR.SHELF_NUMBER = PP.PRODUCT_PLACE_ID AND
								PP.STORE_ID = #get_location.store# AND
								PP.LOCATION_ID = #get_location.store_location#
								<cfif isdefined("attributes.stock_id")>
									AND SR.STOCK_ID =#attributes.stock_id#
								<cfelse>
									AND SR.PRODUCT_ID = #attributes.pid#
								</cfif>
							GROUP BY
								PP.SHELF_CODE,
								SHELF.SHELF_NAME
							<cfif xml_filter_stock_amount eq 1 and attributes.stok_turu eq 2>
								HAVING
									SUM(STOCK_IN-STOCK_OUT) > 0
							</cfif>
						</cfquery>
						<cfif get_shelfes.recordcount>
							<cfloop query="get_shelfes">
								<tr>
									<td>#shelf_code# #SHELF_TYPE#</td>
									<td style="text-align:right">#tlformat(total_stock)#</td>
									<cfif isdefined('xml_dsp_stock_reserve_info') and xml_dsp_stock_reserve_info eq 1>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
									</cfif>
								</tr>
							</cfloop>
						</cfif>
					</cfif>
				</cfoutput>
			</tbody>
		</cf_grid_list>
	</cf_box>
</div>
<cfsetting showdebugoutput="yes">
