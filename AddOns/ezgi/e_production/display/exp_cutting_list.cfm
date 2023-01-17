<cfquery name="get_orders" datasource="#dsn3#">
	SELECT DISTINCT 
    	EI.LOT_NO, 
        PO.P_ORDER_ID, 
        PO.STOCK_ID, 
        EPR.PIECE_NAME, 
        EPR.PIECE_TYPE
	FROM            
    	EZGI_IFLOW_PRODUCTION_ORDERS AS EI INNER JOIN
       	PRODUCTION_ORDERS AS PO ON EI.LOT_NO = PO.LOT_NO INNER JOIN
      	EZGI_DESIGN_PIECE_ROWS AS EPR ON PO.STOCK_ID = EPR.PIECE_RELATED_ID
	WHERE        
    	EI.MASTER_PLAN_ID = #attributes.master_plan_id# AND 
        EI.IFLOW_P_ORDER_ID IN (#attributes.iid#) AND 
        EPR.PIECE_TYPE = 1
	ORDER BY 
    	PO.STOCK_ID
</cfquery>
<cfif get_orders.recordcount>
	<cfset satirlar = queryNew("parca_adi, malzeme, boy, en, adet, bos1, bos2, yon, bos3, birim_adedi, emir_no, uretici_kod, tarih, pvc_ust, pvc_alt, pvc_sol, pvc_sag, paket, parca_kat, parca_rota, kaba_boy, kaba_en, net_boy, net_en, oval, operasyon_1, operasyon_sure_1, operasyon_2, operasyon_sure_2, operasyon_3, operasyon_sure_3, operasyon_4, operasyon_sure_4, operasyon_5, operasyon_sure_5, operasyon_6, operasyon_sure_6, operasyon_7, operasyon_sure_7, operasyon_8, operasyon_sure_8, operasyon_9, operasyon_sure_9, operasyon_10, operasyon_sure_10, malzeme_1, malzeme_mik_1, malzeme_2, malzeme_mik_2, malzeme_3, malzeme_mik_3, malzeme_4, malzeme_mik_4, malzeme_5, malzeme_mik_5, malzeme_6, malzeme_mik_6", "cf_sql_varchar, cf_sql_varchar, Decimal, Decimal, cf_sql_integer, cf_sql_varchar, cf_sql_varchar, cf_sql_varchar, cf_sql_varchar, cf_sql_integer, cf_sql_integer, cf_sql_varchar, date, cf_sql_varchar, cf_sql_varchar, cf_sql_varchar, cf_sql_varchar, cf_sql_integer, cf_sql_integer,cf_sql_varchar, Decimal, Decimal, Decimal, Decimal, cf_sql_varchar, cf_sql_varchar, cf_sql_integer, cf_sql_varchar, cf_sql_integer, cf_sql_varchar, cf_sql_integer, cf_sql_varchar, cf_sql_integer, cf_sql_varchar, cf_sql_integer, cf_sql_varchar, cf_sql_integer, cf_sql_varchar, cf_sql_integer, cf_sql_varchar, cf_sql_integer, cf_sql_varchar, cf_sql_integer, cf_sql_varchar, cf_sql_integer, cf_sql_varchar, Decimal, cf_sql_varchar, Decimal, cf_sql_varchar, Decimal, cf_sql_varchar, Decimal, cf_sql_varchar, Decimal, cf_sql_varchar, Decimal")> 
	<cfloop query="get_orders">
		<cfquery name="get_related_tree" datasource="#dsn3#">
            SELECT        
                2 AS TYPE,
                ISNULL(PO.PRINT_COUNT,0) PRINT_COUNT, 
                PO.STOCK_ID, 
                E1.PIECE_ROW_ID, 
                E1.PIECE_AMOUNT,
                PO.P_ORDER_ID, 
                PO.QUANTITY, 
                PO.P_ORDER_NO,
                E1.IS_FLOW_DIRECTION, 
                E1.PIECE_FLOOR, 
                E1.PIECE_PACKAGE_ROTA, 
                E1.PIECE_DETAIL AS DETAIL, 
                PO.LOT_NO,
                (
                    SELECT 
                        DISTINCT       
                        IMO.MASTER_PLAN_NUMBER
                    FROM      
                        EZGI_IFLOW_PRODUCTION_ORDERS AS IFO INNER JOIN
                        EZGI_IFLOW_MASTER_PLAN AS IMO ON IFO.MASTER_PLAN_ID = IMO.MASTER_PLAN_ID
                    WHERE        
                        IFO.LOT_NO = PO.LOT_NO
                ) AS MASTER_ALT_PLAN_NO
            FROM            
                EZGI_DESIGN_PIECE_ROWS AS E1 INNER JOIN
                PRODUCTION_ORDERS AS PO ON E1.PIECE_RELATED_ID = PO.STOCK_ID INNER JOIN
                EZGI_DESIGN_PIECE_ROW AS EDPR ON E1.PIECE_ROW_ID = EDPR.RELATED_PIECE_ROW_ID
            WHERE        
                PO.P_ORDER_ID = #get_orders.P_ORDER_ID# AND 
                <!---EDPR.SIRA_NO <> 1 AND --->
                E1.PIECE_TYPE = 1 AND 
                PO.IS_DEMONTAJ = 0
            UNION ALL
            SELECT        
                2 AS TYPE, 
                ISNULL(PO.PRINT_COUNT,0) PRINT_COUNT,
                PO.STOCK_ID, 
                E1.PIECE_ROW_ID, 
                E1.PIECE_AMOUNT,
                PO.P_ORDER_ID, 
                PO.QUANTITY, 
                PO.P_ORDER_NO,
                E1.IS_FLOW_DIRECTION, 
                E1.PIECE_FLOOR, 
                E1.PIECE_PACKAGE_ROTA, 
                E1.PIECE_DETAIL AS DETAIL, 
                PO.LOT_NO,
                (
                    SELECT 
                        DISTINCT       
                        IMO.MASTER_PLAN_NUMBER
                    FROM      
                        EZGI_IFLOW_PRODUCTION_ORDERS AS IFO INNER JOIN
                        EZGI_IFLOW_MASTER_PLAN AS IMO ON IFO.MASTER_PLAN_ID = IMO.MASTER_PLAN_ID
                    WHERE        
                        IFO.LOT_NO = PO.LOT_NO
                ) AS MASTER_ALT_PLAN_NO
            FROM            
                EZGI_DESIGN_PIECE_ROWS AS E1 INNER JOIN
                PRODUCTION_ORDERS AS PO ON E1.PIECE_RELATED_ID = PO.STOCK_ID LEFT OUTER JOIN
                EZGI_DESIGN_PIECE_ROW AS EDPR ON E1.PIECE_ROW_ID = EDPR.RELATED_PIECE_ROW_ID
            WHERE        
                PO.P_ORDER_ID = #get_orders.P_ORDER_ID# AND 
                E1.PIECE_TYPE = 1 AND 
                EDPR.PIECE_ROW_ROW_ID IS NULL AND 
                PO.IS_DEMONTAJ = 0
        </cfquery>
		<cfif get_related_tree.recordcount>
			<cfset attributes.design_piece_row_id = get_related_tree.PIECE_ROW_ID>
            <cfset attributes.product_quantity = get_related_tree.QUANTITY>
            <cfinclude template="/addOns/ezgi/e_design/query/get_ezgi_product_tree_creative_station_time.cfm">
            <cfif station_time_cal_group.recordcount>
                <cfquery name="egri_kenar_sub" dbtype="query">
                    SELECT STATION_ID FROM station_time_cal_group WHERE STATION_ID IN (5,7,8,9) 
                </cfquery>
                <cfif egri_kenar_sub.recordcount>
                    <cfset egri_kenar = 1>
                <cfelse>
                    <cfset egri_kenar = 0>
                </cfif>
            </cfif>
			<cfquery name="get_product" datasource="#dsn3#">
                    SELECT 
                        PIECE_ROW_ID,
                        PIECE_TYPE, 
                        PIECE_NAME, 
                        PIECE_CODE, 
                        PIECE_COLOR_ID, 
                        PIECE_DETAIL, 
                        PIECE_AMOUNT, 
                        TRIM_TYPE, 
                        TRIM_SIZE, 
                        IS_FLOW_DIRECTION, 
                        BOYU, 
                        ENI, 
                        KESIM_BOYU, 
                        KESIM_ENI, 
                        KALINLIK,
                        MATERIAL_ID,
                        (SELECT DESIGN_NAME FROM EZGI_DESIGN WHERE DESIGN_ID = EZGI_DESIGN_PIECE.DESIGN_ID) as DESIGN_MAIN_NAME,
                        (SELECT PACKAGE_NUMBER FROM EZGI_DESIGN_PACKAGE WHERE PACKAGE_ROW_ID = EZGI_DESIGN_PIECE.DESIGN_PACKAGE_ROW_ID) as PACKAGE_NUMBER,
                        (SELECT PROPERTY_DETAIL FROM #dsn1_alias#.PRODUCT_PROPERTY_DETAIL WHERE PRPT_ID = 2 AND PROPERTY_DETAIL_ID = EZGI_DESIGN_PIECE.KALINLIK) AS KALINLIK_
                    FROM 
                        EZGI_DESIGN_PIECE 
                    WHERE 
                        PIECE_ROW_ID = #attributes.design_piece_row_id#
         	</cfquery>
			<cfset product_cat_id_list = ''>
            <cfif get_product.recordcount>
            	<cfset product_cat_id_list = ValueList(get_product.MATERIAL_ID)>
            	<cfset product_cat_id_list = ListDeleteDuplicates(product_cat_id_list,',')>
                <cfif ListLen(product_cat_id_list)>
                    <cfquery name="get_malzeme" datasource="#dsn3#">
                    	SELECT        
                        	PT.STOCK_ID, 
                            S.PRODUCT_NAME
						FROM            
                       		PRODUCT_TREE AS PT INNER JOIN
                       		STOCKS AS S ON PT.RELATED_ID = S.STOCK_ID
						WHERE        
                        	PT.STOCK_ID IN (#product_cat_id_list#) AND 
                            PT.RELATED_ID IS NOT NULL
						GROUP BY 
                        	PT.STOCK_ID, 
                            S.PRODUCT_NAME
                    </cfquery>
                    <cfoutput query="get_malzeme">
                        <cfset 'PRODUCT_CAT_#STOCK_ID#' = PRODUCT_NAME>
                    </cfoutput>
                </cfif>
            </cfif>
            <cfquery name="get_product_stocks" datasource="#dsn3#">
                SELECT        
                	E.AMOUNT, 
                    S.PRODUCT_NAME, 
                    P.MAIN_UNIT
				FROM            
               		EZGI_DESIGN_PIECE_ROW AS E INNER JOIN
                	STOCKS AS S ON E.STOCK_ID = S.STOCK_ID INNER JOIN
                 	PRODUCT_UNIT AS P ON S.PRODUCT_UNIT_ID = P.PRODUCT_UNIT_ID
				WHERE        
                	E.PIECE_ROW_ID = #attributes.design_piece_row_id# AND 
                    E.PIECE_ROW_ROW_TYPE = 2 AND 
                    P.IS_MAIN = 1
				ORDER BY 
                	E.SIRA_NO
            </cfquery>
            <!---Ürün Ağacı Bilgilerinin Toplanması--->
        	<cfquery name="get_related_product" datasource="#dsn3#">
                    SELECT        
                        PO.STOCK_ID AS URETILEN_STOCK_ID, 
                        E1.PIECE_RELATED_ID AS SARFEDILEN_STOCK_ID, 
                        EPR.PIECE_ROW_ID AS URETILEN_PIECE_ROW_ID, 
                        E1.PIECE_ROW_ID AS SARFEDILEN_PIECE_ROW_ID
                    FROM            
                        PRODUCTION_ORDERS AS PO INNER JOIN
                        EZGI_DESIGN_PIECE AS E ON PO.STOCK_ID = E.PIECE_RELATED_ID INNER JOIN
                        EZGI_DESIGN_PIECE_ROW AS EPR ON E.PIECE_ROW_ID = EPR.PIECE_ROW_ID INNER JOIN
                        EZGI_DESIGN_PIECE AS E1 ON EPR.RELATED_PIECE_ROW_ID = E1.PIECE_ROW_ID
                    WHERE        
                        PO.P_ORDER_ID = #get_related_tree.P_ORDER_ID# AND 
                        E.PIECE_TYPE = 3 AND 
                        EPR.PIECE_ROW_ROW_TYPE = 4 AND 
                        EPR.SIRA_NO = 1 AND 
                        PO.IS_DEMONTAJ = 0
       		</cfquery>
            
			<cfif get_related_product.recordcount>
                    <cfset print_both = 1>
                    <cfset sarf_stock_id_list = Valuelist(get_related_product.URETILEN_STOCK_ID)>
                    <cfset sarf_stock_id_list = ListAppend(sarf_stock_id_list, get_related_product.SARFEDILEN_STOCK_ID)>
         	</cfif>
            <!---Operasyon Bilgilerinin Toplanması--->
            <cfquery name="get_operations" datasource="#dsn3#">
                SELECT     
                    EOS.P_OPERATION_ID, 
                    EOS.OPERATION_TYPE_ID, 
                    EOS.OPERATION_CODE, 
                    SUBSTRING(EOS.OPERATION_TYPE,1,30) OPERATION_TYPE, 
                    EOS.AMOUNT, 
                    EOS.REAL_TIME AS URETIM_TIME,
                    EOS.WAIT_TIME AS DURUS_TIME, 
                    EOS.REAL_AMOUNT AS RESULT_AMOUNT, 
                    EOS.LOSS_AMOUNT AS FIRE_AMOUNT,  
                    EOS.O_START_DATE, 
                    EOS.O_STATION_IP, 
                    EOS.O_TOTAL_PROCESS_TIME, 
                    EOS.P_ORDER_NO,
                    EOS.MASTER_ALT_PLAN_ID,
                    SUBSTRING(W.STATION_NAME, 1, 4) AS STATION_NAME,
                    (
                        SELECT 
                            DISTINCT       
                            IMO.MASTER_PLAN_NUMBER
                        FROM      
                            EZGI_IFLOW_PRODUCTION_ORDERS AS IFO INNER JOIN
                            EZGI_IFLOW_MASTER_PLAN AS IMO ON IFO.MASTER_PLAN_ID = IMO.MASTER_PLAN_ID
                        WHERE        
                            IFO.LOT_NO = EOS.LOT_NO
                    ) AS PLAN_NO
                FROM         
                    EZGI_OPERATION_S AS EOS INNER JOIN
                    WORKSTATIONS AS W ON EOS.O_STATION_IP = W.STATION_ID
                WHERE     
                    ISNULL(EOS.IS_VIRTUAL, 0) = 0 
                    AND
                    (
                    EOS.P_ORDER_ID = #get_related_tree.P_ORDER_ID#
                    )
                ORDER BY 
                    EOS.P_ORDER_ID,
                    EOS.P_OPERATION_ID      
            </cfquery>
            <cfif get_operations.recordcount>
                <cfset plan_no = get_operations.plan_no>
            <cfelse>
                <cfset plan_no = ''>
            </cfif>
            <cfquery name="get_operations_grup" dbtype="query">
                SELECT
                    P_ORDER_NO,
                    COUNT(*) AS SAYI
                FROM
                    get_operations
                GROUP BY
                    P_ORDER_NO
            </cfquery>
            <cfoutput query="get_operations_grup">
                <cfset 'SAYI#P_ORDER_NO#' = SAYI>
            </cfoutput>
            <cfquery name="get_pvc" datasource="#dsn3#">
            	SELECT        
                	EDPR.PIECE_ROW_ID, 
                    EDPR.SIRA_NO, 
                    S.PRODUCT_NAME
				FROM            
                	EZGI_DESIGN_PIECE_ROW AS EDPR INNER JOIN
                	EZGI_DESIGN_PIECE_ROWS AS EDP ON EDPR.PIECE_ROW_ID = EDP.PIECE_ROW_ID INNER JOIN
              		STOCKS AS S ON EDPR.STOCK_ID = S.STOCK_ID
				WHERE        
                	EDPR.PIECE_ROW_ROW_TYPE = 1 AND 
                    EDP.PIECE_ROW_ID = #attributes.design_piece_row_id#
				ORDER BY 
                	EDPR.PIECE_ROW_ID, 
                    EDPR.SIRA_NO
            </cfquery>
            <cfoutput query="get_pvc">
                <cfset 'renk_#PIECE_ROW_ID#_#SIRA_NO#' = PRODUCT_NAME>
            </cfoutput>
            <cfquery name="get_pvc" datasource="#dsn3#">
                SELECT        
                    EDPR.PIECE_ROW_ID, 
                    EDPR.SIRA_NO, 
                    PD.PROPERTY_DETAIL
                FROM            
                    EZGI_DESIGN_PIECE_ROW AS EDPR INNER JOIN
                    EZGI_DESIGN_PIECE_rows AS EDP ON EDPR.PIECE_ROW_ID = EDP.PIECE_ROW_ID INNER JOIN
                    STOCKS AS S ON EDPR.STOCK_ID = S.STOCK_ID INNER JOIN
                    #dsn1_alias#.PRODUCT_DT_PROPERTIES AS PDP ON S.PRODUCT_ID = PDP.PRODUCT_ID INNER JOIN
                    #dsn1_alias#.PRODUCT_PROPERTY_DETAIL AS PD ON PDP.VARIATION_ID = PD.PROPERTY_DETAIL_ID
                WHERE        
                    EDPR.PIECE_ROW_ROW_TYPE = 1 AND 
                    EDP.PIECE_ROW_ID =#attributes.design_piece_row_id# AND 
                    PD.PRPT_ID = 3
                ORDER BY 
                    EDPR.PIECE_ROW_ID, 
                    EDPR.SIRA_NO
            </cfquery>
            <cfoutput query="get_pvc">
                <cfset 'kenar_#PIECE_ROW_ID#_#SIRA_NO#' = PROPERTY_DETAIL>
            </cfoutput>
            <cfset net_en = ''>
			<cfset net_boy = ''> 
            <cfif isdefined('kenar_#get_related_tree.PIECE_ROW_ID#_1') and isdefined('kenar_#get_related_tree.PIECE_ROW_ID#_2')>
                <cfif Evaluate('kenar_#get_related_tree.PIECE_ROW_ID#_1') eq 0.5 and Evaluate('kenar_#get_related_tree.PIECE_ROW_ID#_2') neq 0.5>
                    <cfset net_en = get_product.ENI - Evaluate('kenar_#get_related_tree.PIECE_ROW_ID#_2') - 1>
                <cfelseif Evaluate('kenar_#get_related_tree.PIECE_ROW_ID#_1') neq 0.5 and Evaluate('kenar_#get_related_tree.PIECE_ROW_ID#_2') eq 0.5>
                    <cfset net_en = get_product.ENI - Evaluate('kenar_#get_related_tree.PIECE_ROW_ID#_1') - 1>
                <cfelse>
                    <cfset net_en = get_product.ENI - Evaluate('kenar_#get_related_tree.PIECE_ROW_ID#_1') - Evaluate('kenar_#get_related_tree.PIECE_ROW_ID#_2')>
                </cfif>  
            <cfelseif isdefined('kenar_#get_related_tree.PIECE_ROW_ID#_1') and not isdefined('kenar_#get_related_tree.PIECE_ROW_ID#_2')>
                <cfif Evaluate('kenar_#get_related_tree.PIECE_ROW_ID#_1') eq 0.5>
                    <cfset net_en = get_product.ENI - 1>
                <cfelse>
                    <cfset net_en = get_product.ENI - Evaluate('kenar_#get_related_tree.PIECE_ROW_ID#_1')>
                </cfif>
            <cfelseif not isdefined('kenar_#get_related_tree.PIECE_ROW_ID#_1') and isdefined('kenar_#get_related_tree.PIECE_ROW_ID#_2')>
                <cfif Evaluate('kenar_#get_related_tree.PIECE_ROW_ID#_2') eq 0.5>
                    <cfset net_en = get_product.ENI - 1>
                <cfelse>
                    <cfset net_en = get_product.ENI - Evaluate('kenar_#get_related_tree.PIECE_ROW_ID#_2')>	
                </cfif>
            </cfif>
            <cfif isdefined('kenar_#get_related_tree.PIECE_ROW_ID#_3') and isdefined('kenar_#get_related_tree.PIECE_ROW_ID#_4')>
                <cfif Evaluate('kenar_#get_related_tree.PIECE_ROW_ID#_3') eq 0.5 and Evaluate('kenar_#get_related_tree.PIECE_ROW_ID#_4') neq 0.5>
                    <cfset net_boy = get_product.BOYU - Evaluate('kenar_#get_related_tree.PIECE_ROW_ID#_4') - 1>
                <cfelseif Evaluate('kenar_#get_related_tree.PIECE_ROW_ID#_3') neq 0.5 and Evaluate('kenar_#get_related_tree.PIECE_ROW_ID#_4') eq 0.5>
                    <cfset net_boy = get_product.BOYU - Evaluate('kenar_#get_related_tree.PIECE_ROW_ID#_3') - 1>
                <cfelse>
                    <cfset net_boy = get_product.BOYU - Evaluate('kenar_#get_related_tree.PIECE_ROW_ID#_3') - Evaluate('kenar_#get_related_tree.PIECE_ROW_ID#_4')>
                </cfif>  
            <cfelseif isdefined('kenar_#get_related_tree.PIECE_ROW_ID#_3') and not isdefined('kenar_#get_related_tree.PIECE_ROW_ID#_4')>
                <cfif Evaluate('kenar_#get_related_tree.PIECE_ROW_ID#_3') eq 0.5>
                    <cfset net_boy = get_product.BOYU - 1>
                <cfelse>
                    <cfset net_boy = get_product.BOYU - Evaluate('kenar_#get_related_tree.PIECE_ROW_ID#_3')>
                </cfif>
            <cfelseif not isdefined('kenar_#get_related_tree.PIECE_ROW_ID#_3') and isdefined('kenar_#get_related_tree.PIECE_ROW_ID#_4')>
                <cfif Evaluate('kenar_#get_related_tree.PIECE_ROW_ID#_4') eq 0.5>
                    <cfset net_boy = get_product.BOYU - 1>
                <cfelse>
                    <cfset net_boy = get_product.BOYU - Evaluate('kenar_#get_related_tree.PIECE_ROW_ID#_4')>	
                </cfif>
            </cfif>
             <cfquery name="get_man_code" datasource="#dsn3#">
                SELECT        
                    S.MANUFACT_CODE
                FROM            
                    EZGI_IFLOW_PRODUCTION_ORDERS AS E INNER JOIN
                    STOCKS AS S ON E.STOCK_ID = S.STOCK_ID
                WHERE        
                    E.LOT_NO = '#get_related_tree.LOT_NO#'
            </cfquery>
            <cfquery name="get_master_plan_start_date" datasource="#dsn3#">
                SELECT        
                    EE.MASTER_PLAN_START_DATE
                FROM            
                    EZGI_IFLOW_PRODUCTION_ORDERS AS E INNER JOIN
                    EZGI_IFLOW_MASTER_PLAN AS EE ON E.MASTER_PLAN_ID = EE.MASTER_PLAN_ID
                WHERE        
                    E.LOT_NO = '#get_related_tree.LOT_NO#'
            </cfquery>
            <cfset queryAddRow(satirlar)> 
            <cfset querySetCell(satirlar, "bos1","")>
            <cfset querySetCell(satirlar, "bos2","")>
            <cfset querySetCell(satirlar, "bos3","")>
            <cfset querySetCell(satirlar, "emir_no", get_related_tree.P_ORDER_NO)>
            <cfset querySetCell(satirlar, "parca_adi", '#get_product.DESIGN_MAIN_NAME# #get_product.PIECE_NAME#')> 
            <cfset querySetCell(satirlar, "adet", get_related_tree.QUANTITY)>
            <cfset querySetCell(satirlar, "boy", Floor(get_product.BOYU))>
            <cfset querySetCell(satirlar, "en", Floor(get_product.ENI))>
            <cfset querySetCell(satirlar, "kaba_boy", Floor(get_product.KESIM_BOYU))>
            <cfset querySetCell(satirlar, "kaba_en", Floor(get_product.KESIM_ENI))>
            <cfset querySetCell(satirlar, "net_boy", net_boy)>
            <cfset querySetCell(satirlar, "net_en", net_en)>
            <cfset querySetCell(satirlar, "parca_kat", get_related_tree.PIECE_FLOOR)>
            <cfset querySetCell(satirlar, "paket", get_product.PACKAGE_NUMBER)>
            <cfset querySetCell(satirlar, "parca_rota", get_related_tree.PIECE_PACKAGE_ROTA)>
            <cfset querySetCell(satirlar, "birim_adedi", get_related_tree.PIECE_AMOUNT)>
            <cfif get_man_code.recordcount>
               <cfset querySetCell(satirlar, "uretici_kod", get_man_code.MANUFACT_CODE)>
         	<cfelse>
            	<cfset querySetCell(satirlar, "uretici_kod", "")>
            </cfif>
         	<cfif get_master_plan_start_date.recordcount>
            	<cfset querySetCell(satirlar, "tarih", get_master_plan_start_date.master_plan_start_date)>
            <cfelse>
            	<cfset querySetCell(satirlar, "tarih", "")>
           	</cfif>
            <cfif isdefined('renk_#get_related_tree.PIECE_ROW_ID#_1')>
                <cfset querySetCell(satirlar, "pvc_ust", Evaluate('renk_#get_related_tree.PIECE_ROW_ID#_1'))>
          	<cfelse>
              	<cfset querySetCell(satirlar, "pvc_ust", "")>
        	</cfif>
            <cfif isdefined('renk_#get_related_tree.PIECE_ROW_ID#_2')>
                <cfset querySetCell(satirlar, "pvc_alt", Evaluate('renk_#get_related_tree.PIECE_ROW_ID#_2'))>
          	<cfelse>
              	<cfset querySetCell(satirlar, "pvc_alt", "")>
        	</cfif>
            <cfif isdefined('renk_#get_related_tree.PIECE_ROW_ID#_3')>
                <cfset querySetCell(satirlar, "pvc_sol", Evaluate('renk_#get_related_tree.PIECE_ROW_ID#_3'))>
          	<cfelse>
              	<cfset querySetCell(satirlar, "pvc_sol", "")>
        	</cfif>
            <cfif isdefined('renk_#get_related_tree.PIECE_ROW_ID#_4')>
                <cfset querySetCell(satirlar, "pvc_sag", Evaluate('renk_#get_related_tree.PIECE_ROW_ID#_4'))>
          	<cfelse>
              	<cfset querySetCell(satirlar, "pvc_sag", "")>
        	</cfif>
            <cfif get_related_tree.IS_FLOW_DIRECTION eq 1>
            	<cfset querySetCell(satirlar, "yon", "Y")>
            <cfelse>
            	<cfset querySetCell(satirlar, "yon", "N")>
            </cfif>
			<cfif egri_kenar eq 1>
            	<cfset querySetCell(satirlar, "oval", "OVAL")>
            <cfelse>
            	<cfset querySetCell(satirlar, "oval", "")>
            </cfif>
            <cfif isdefined('PRODUCT_CAT_#get_product.MATERIAL_ID#')>
            	<cfset querySetCell(satirlar, "malzeme", Evaluate('PRODUCT_CAT_#get_product.MATERIAL_ID#'))>
            <cfelse>
            	<cfset querySetCell(satirlar, "malzeme", "")>
            </cfif>
            <cfif station_time_cal_group.recordcount gt 0>
             	<cfloop query="station_time_cal_group" startrow="1" endrow="10">
                	<cfset querySetCell(satirlar, "operasyon_#station_time_cal_group.currentrow#", station_time_cal_group.STATION_NAME)>
                    <cfset querySetCell(satirlar, "operasyon_sure_#station_time_cal_group.currentrow#", station_time_cal_group.TOTAL_STATION_TIME * attributes.product_quantity)>
                </cfloop>
          	</cfif>  
            <cfloop from="1" to="6" index="i">
            	<cfset querySetCell(satirlar, "malzeme_#i#", get_product_stocks.PRODUCT_NAME[i])>
            	<cfset querySetCell(satirlar, "malzeme_mik_#i#", get_product_stocks.AMOUNT[i])>
            </cfloop>
		</cfif>
	</cfloop>
    <cfset filename = expandPath("./myexcel.xls")> 
	<cfset s = spreadsheetNew()> <!--- Add header row ---> 
    <cfset spreadsheetAddRow(s, "parca_adi, malzeme, boy, en, adet, bos1, bos2, yon, bos3, birim_adedi, emir_no, uretici_kod, tarih, pvc_ust, pvc_alt, pvc_sol, pvc_sag, paket, parca_kat, parca_rota, kaba_boy, kaba_en, net_boy, net_en, oval, operasyon_1, operasyon_sure_1, operasyon_2, operasyon_sure_2, operasyon_3, operasyon_sure_3, operasyon_4, operasyon_sure_4, operasyon_5, operasyon_sure_5, operasyon_6, operasyon_sure_6, operasyon_7, operasyon_sure_7, operasyon_8, operasyon_sure_8, operasyon_9, operasyon_sure_9, operasyon_10, operasyon_sure_10, malzeme_1, malzeme_mik_1, malzeme_2, malzeme_mik_2, malzeme_3, malzeme_mik_3, malzeme_4, malzeme_mik_4, malzeme_5, malzeme_mik_5, malzeme_6, malzeme_mik_6")> 
    <!--- format header --->	
    <cfset spreadsheetFormatRow(s, { bold=true, fgcolor="lemon_chiffon", fontsize=11 }, 1)> 
    <!--- Add query ---> 
    <cfset spreadsheetAddRows(s, satirlar)> 
    <cfset spreadsheetWrite(s, filename, true)> 
    Dosyanız Hazırdır. İndirmek için <a href="myexcel.xls" class="tableyazi">Buraya Tıklayın</a>.
<cfelse>
	Listelenecek Parça Bulunamadı.
</cfif>
