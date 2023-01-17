<cfset module_name="prod">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.oby" default="2">
<cfparam name="attributes.list_type" default="1">
<cfparam name="attributes.list_tur" default="1">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.price_cat" default="-1">
<cfparam name="attributes.department_id" default="">
	<cfquery name="get_money" datasource="#dsn2#">
		SELECT MONEY, RATE1, RATE2 FROM SETUP_MONEY
    </cfquery>
    <cfset _t1_fiyat = 0>
    <cfset t1_fiyat = 0>
    <cfset t1_fiyat0 = 0>
    <cfoutput query="get_money">
        <cfset 't1_fiyat#MONEY#'=0>
    </cfoutput>
<cfquery name="get_department" datasource="#dsn#">
        	SELECT        
            	DEPARTMENT_ID, 
                DEPARTMENT_HEAD
			FROM            
            	DEPARTMENT
			WHERE        
            	DEPARTMENT_STATUS = 1 AND 
                IS_PRODUCTION = 1
        </cfquery>
<cfif isdefined('is_form_submitted')>
	<cfif isdefined('attributes.p_order_id_list')>
    	<cfquery name="get_sub_product_id" datasource="#dsn3#">
            SELECT        
                P_ORDER_ID
            FROM            
                (
                    SELECT        
                        PPO2.P_ORDER_ID
                    FROM        
                   		PRODUCTION_ORDERS AS PPO1 LEFT OUTER JOIN
                    	PRODUCTION_ORDERS AS PPO2 ON PPO1.P_ORDER_ID = PPO2.PO_RELATED_ID
                WHERE        
                    PPO1.P_ORDER_ID IN (#attributes.p_order_id_list#)
                UNION ALL
                SELECT        
                    PPO3.P_ORDER_ID
                FROM            
                  	PRODUCTION_ORDERS AS PPO3 RIGHT OUTER JOIN
                   	PRODUCTION_ORDERS AS PPO2 ON PPO3.PO_RELATED_ID = PPO2.P_ORDER_ID RIGHT OUTER JOIN
                  	PRODUCTION_ORDERS AS PPO1 ON PPO2.PO_RELATED_ID = PPO1.P_ORDER_ID
                WHERE        
                    PPO1.P_ORDER_ID IN (#attributes.p_order_id_list#)
                UNION ALL
                SELECT        
                    PPO4.P_ORDER_ID
                FROM            
                    PRODUCTION_ORDERS AS PPO1 LEFT OUTER JOIN
                	PRODUCTION_ORDERS AS PPO2 LEFT OUTER JOIN
                	PRODUCTION_ORDERS AS PPO3 LEFT OUTER JOIN
                 	PRODUCTION_ORDERS AS PPO4 ON PPO3.P_ORDER_ID = PPO4.PO_RELATED_ID ON PPO2.P_ORDER_ID = PPO3.PO_RELATED_ID ON 
                         PPO1.P_ORDER_ID = PPO2.PO_RELATED_ID
                WHERE        
                    PPO1.P_ORDER_ID IN (#attributes.p_order_id_list#)
                UNION ALL
                SELECT        
                    PPO5.P_ORDER_ID
                FROM            
               		PRODUCTION_ORDERS AS PPO1 LEFT OUTER JOIN
             		PRODUCTION_ORDERS AS PPO2 LEFT OUTER JOIN
                 	PRODUCTION_ORDERS AS PPO3 LEFT OUTER JOIN
                  	PRODUCTION_ORDERS AS PPO5 RIGHT OUTER JOIN
                  	PRODUCTION_ORDERS AS PPO4 ON PPO5.PO_RELATED_ID = PPO4.P_ORDER_ID ON PPO3.P_ORDER_ID = PPO4.PO_RELATED_ID ON PPO2.P_ORDER_ID = PPO3.PO_RELATED_ID ON 
                         PPO1.P_ORDER_ID = PPO2.PO_RELATED_ID
                WHERE        
                    PPO1.P_ORDER_ID IN (#attributes.p_order_id_list#) 
                ) AS TBL
            WHERE        
                NOT (P_ORDER_ID IS NULL)
      	</cfquery>
        <cfset sub_p_order_id = ValueList(get_sub_product_id.P_ORDER_ID)>
        <cfif ListLen(sub_p_order_id)>
        	<cfset sub_p_order_id = '#attributes.p_order_id_list#,#sub_p_order_id#'>
		<cfelse>
        	<cfset sub_p_order_id = attributes.p_order_id_list>
        </cfif>
    </cfif>
    <cfif isdefined('attributes.master_plan_id') and len(attributes.master_plan_id)>
        <cfquery name="get_department" datasource="#dsn#">
            SELECT        
            	D.DEPARTMENT_ID
			FROM            
            	SETUP_SHIFTS AS SS INNER JOIN
             	DEPARTMENT AS D ON SS.BRANCH_ID = D.BRANCH_ID
			WHERE        
            	SS.SHIFT_ID = (SELECT MASTER_PLAN_CAT_ID FROM #dsn3_alias#.EZGI_IFLOW_MASTER_PLAN WHERE MASTER_PLAN_ID = #attributes.master_plan_id#)
        </cfquery>
        <cfset attributes.department_id = ValueList(get_department.DEPARTMENT_ID)>
        <cfquery name="get_master_plan_info" datasource="#dsn3#">
            SELECT * FROM EZGI_IFLOW_MASTER_PLAN WHERE MASTER_PLAN_ID = #attributes.master_plan_id#
        </cfquery>
    </cfif>
	
    <cfif (isdefined('attributes.iid') and listlen(attributes.iid)) or (isdefined('attributes.p_order_id_list') and ListLen(attributes.p_order_id_list))>
    	<cfif attributes.list_type eq 3>
        	<cfquery name="get_total_material" datasource="#dsn3#">
        		SELECT        
                	EDPR.PIECE_DETAIL, 
                    S.STOCK_ID, 
                    S.PRODUCT_ID, 
                    S.PROPERTY, 
                    S.PRODUCT_NAME, 
                    S.PRODUCT_CODE, 
                    PU.MAIN_UNIT, 
                    SUM(EPO.QUANTITY * ISNULL(EDPR.AGIRLIK, 1)) AS ADET, 
               		SUM(EPO.QUANTITY * EDPR.PIECE_AMOUNT) AS AMOUNT
                    <cfif isdefined('attributes.is_lot_group')>
                    ,EPO.LOT_NO
                    </cfif>
				FROM            
                	EZGI_DESIGN_MAIN_ROW AS EDMR INNER JOIN
                 	EZGI_DESIGN_PIECE_ROWS AS EDPR ON EDMR.DESIGN_MAIN_ROW_ID = EDPR.DESIGN_MAIN_ROW_ID INNER JOIN
                  	EZGI_IFLOW_PRODUCTION_ORDERS AS EPO ON EDMR.MAIN_SPECT_RELATED_ID = EPO.SPECT_MAIN_ID INNER JOIN
                	STOCKS AS S ON EDPR.PIECE_RELATED_ID = S.STOCK_ID INNER JOIN
                 	PRODUCT_UNIT AS PU ON S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
				WHERE        
                	EPO.IFLOW_P_ORDER_ID IN (#attributes.iid#) AND 
                    S.PRODUCT_CODE LIKE N'01.150%'
                    <cfif len(attributes.keyword)>
                        AND
                        (
                            S.PRODUCT_NAME LIKE '%#attributes.keyword#%' OR
                            S.PRODUCT_CODE LIKE '%#attributes.keyword#%' OR
                            S.PRODUCT_CODE_2 LIKE '%#attributes.keyword#%'
                        )
                    </cfif> 
                    <cfif attributes.list_type eq 1><!--- MRP Ürünler İse--->
                        AND ISNULL(S.IS_LIMITED_STOCK,0) = 0
                    <cfelseif attributes.list_type eq 2><!--- Kanban Ürünler İse--->
                        AND S.IS_LIMITED_STOCK = 1
                    </cfif>
              	GROUP BY
                	EDPR.PIECE_DETAIL, 
                    S.STOCK_ID, 
                    S.PRODUCT_ID, 
                    S.PROPERTY, 
                    S.PRODUCT_NAME, 
                    S.PRODUCT_CODE, 
                    S.PRODUCT_CODE_2,
                    S.IS_LIMITED_STOCK,
                    PU.MAIN_UNIT
                    <cfif isdefined('attributes.is_lot_group')>
                    ,EPO.LOT_NO
                    </cfif>
             	ORDER BY
                	<cfif isdefined('attributes.is_lot_group')>
                    EPO.LOT_NO,
                    </cfif>
                    S.IS_LIMITED_STOCK,
               		<cfif attributes.oby eq 1>
                  		S.PRODUCT_CODE
                    <cfelse>
                        S.PRODUCT_NAME
                    </cfif>
          	</cfquery>
        <cfelse>
            <cfquery name="get_total_material" datasource="#dsn3#">
                SELECT        
                    POS.STOCK_ID, 
                    S.PRODUCT_ID, 
                    S.PROPERTY, 
                    S.PRODUCT_NAME, 
                    S.PRODUCT_CODE, 
                    S.IS_LIMITED_STOCK, 
                    (SELECT MAIN_UNIT FROM #dsn1_alias#.PRODUCT_UNIT WHERE PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS MAIN_UNIT,
                    <cfif isdefined('attributes.real_material')>
                        SUM(POS.AMOUNT*ISNULL((PO.QUANTITY - TBL.AMOUNT) / PO.QUANTITY, 1)) AS AMOUNT
                    <cfelse>
                        SUM(POS.AMOUNT) AS AMOUNT
                    </cfif>
                    <cfif isdefined('attributes.is_lot_group')>
                    ,PO.LOT_NO
                    </cfif>
                FROM            
                    PRODUCTION_ORDERS AS PO INNER JOIN
                    PRODUCTION_ORDERS_STOCKS AS POS ON PO.P_ORDER_ID = POS.P_ORDER_ID INNER JOIN
                    STOCKS AS S ON POS.STOCK_ID = S.STOCK_ID LEFT OUTER JOIN
                    (
                        SELECT        
                            POR.P_ORDER_ID, SUM(PORR.AMOUNT) AS AMOUNT
                        FROM            
                            PRODUCTION_ORDER_RESULTS AS POR INNER JOIN
                            PRODUCTION_ORDER_RESULTS_ROW AS PORR ON POR.PR_ORDER_ID = PORR.PR_ORDER_ID
                        WHERE        
                            PORR.TYPE = 1 AND 
                            POR.IS_STOCK_FIS = 1
                        GROUP BY POR.P_ORDER_ID
                    ) AS TBL ON PO.P_ORDER_ID = TBL.P_ORDER_ID
                WHERE  
                    <cfif isdefined('attributes.p_order_id_list')>
                        PO.P_ORDER_ID IN (#sub_p_order_id#) AND
                    <cfelseif isdefined('attributes.iid')>     
                        PO.LOT_NO IN
                                    (
                                        SELECT 
                                            LOT_NO
                                        FROM 
                                            EZGI_IFLOW_PRODUCTION_ORDERS E 
                                        WHERE 
                                            IFLOW_P_ORDER_ID IN (#attributes.iid#)
                                    ) AND
                    </cfif>
                    S.IS_PURCHASE = 1 AND 
                    S.IS_PRODUCTION = 0
                    <cfif len(attributes.keyword)>
                        AND
                        (
                            PRODUCT_NAME LIKE '%#attributes.keyword#%' OR
                            PRODUCT_CODE LIKE '%#attributes.keyword#%' OR
                            PRODUCT_CODE_2 LIKE '%#attributes.keyword#%'
                        )
                    </cfif> 
                    <cfif attributes.list_type eq 1><!--- MRP Ürünler İse--->
                        AND ISNULL(S.IS_LIMITED_STOCK,0) = 0
                    <cfelseif attributes.list_type eq 2><!--- Kanban Ürünler İse--->
                        AND S.IS_LIMITED_STOCK = 1
                    </cfif>
                GROUP BY 
                    POS.STOCK_ID, 
                    S.PRODUCT_ID, 
                    S.PROPERTY, 
                    S.PRODUCT_NAME, 
                    S.PRODUCT_CODE, 
                    S.IS_LIMITED_STOCK
                    <cfif isdefined('attributes.is_lot_group')>
                    ,PO.LOT_NO
                    </cfif>
                ORDER BY
                <cfif isdefined('attributes.is_lot_group')>
                    PO.LOT_NO,
                    </cfif>
                    S.IS_LIMITED_STOCK,
                    <cfif attributes.oby eq 1>
                        S.PRODUCT_CODE
                    <cfelse>
                        S.PRODUCT_NAME
                    </cfif>
            </cfquery>
        </cfif>
        <cfif isdefined('attributes.is_lot_group')>
            	<cfset lot_no_list = ValueList(get_total_material.LOT_NO)>
                <cfset lot_no_list = ListDeleteDuplicates(lot_no_list,',')>
                <cfquery name="get_lot_order" datasource="#dsn3#">
                	SELECT  
                    	CASE
                            WHEN O.COMPANY_ID IS NOT NULL THEN
                           (
                            SELECT     
                                NICKNAME
                            FROM         
                                #dsn_alias#.COMPANY
                            WHERE     
                                COMPANY_ID = O.COMPANY_ID
                            )
                            WHEN O.CONSUMER_ID IS NOT NULL THEN      
                            (	
                            SELECT     
                                CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS ISIM
                            FROM         
                                #dsn_alias#.CONSUMER
                            WHERE     
                                CONSUMER_ID = O.CONSUMER_ID
                            )
                            WHEN O.EMPLOYEE_ID IS NOT NULL THEN
                            (
                            SELECT     
                                EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS ISIM
                            FROM         
                                #dsn_alias#.EMPLOYEES
                            WHERE     
                                EMPLOYEE_ID = O.EMPLOYEE_ID
                            )
                    	END AS UNVAN ,     
                    	PO.LOT_NO, 
                        O.ORDER_NUMBER
					FROM            
                   		PRODUCTION_ORDERS AS PO INNER JOIN
                      	PRODUCTION_ORDERS_ROW AS PORR ON PO.P_ORDER_ID = PORR.PRODUCTION_ORDER_ID INNER JOIN
                      	ORDERS AS O ON PORR.ORDER_ID = O.ORDER_ID
					WHERE        
                    	PO.LOT_NO IN (#lot_no_list#) AND 
                        PO.PRODUCTION_LEVEL = '0'
                </cfquery>
                <cfoutput query="get_lot_order">
                	<cfset "UNVAN_#Replace(LOT_NO,' ','','All')#" = UNVAN>
                    <cfset "ORDER_NUMBER_#Replace(LOT_NO,' ','','All')#" = ORDER_NUMBER>
                </cfoutput>
   		</cfif>
    <cfelse>
        <cfset get_total_material.recordcount = 0>
    </cfif>	
    <cfif get_total_material.recordcount>
        <cfset stock_id_list= ValueList( get_total_material.STOCK_ID, ", " )>
		<cfset stock_id_list = listdeleteduplicates(stock_id_list)>
        <!--- DEPOLAR BAZINDA GERÇEK STOKLAR--->
   		<cfquery name="GET_STOCKS_ALL" datasource="#DSN2#">
					SELECT 
						SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_STOCK,
						SR.STOCK_ID,
						SR.STORE AS DEPARTMENT_ID
					FROM 
						STOCKS_ROW SR
					WHERE
						SR.STORE_LOCATION NOT IN (SELECT SL.LOCATION_ID FROM #dsn_alias#.STOCKS_LOCATION SL WHERE SL.IS_SCRAP = 1 AND SL.DEPARTMENT_ID =SR.STORE) AND
						SR.STORE IN (#attributes.DEPARTMENT_ID#) AND
                        SR.STOCK_ID IN (#stock_id_list#)
					GROUP BY
						SR.STOCK_ID,
						SR.STORE
    	</cfquery>
        <cfoutput query="GET_STOCKS_ALL">
            <cfset 'PRODUCT_STOCK_#STOCK_ID#'= PRODUCT_STOCK>
        </cfoutput>
		<!--- DEPOLAR BAZINDA GERÇEK STOKLAR BİTTİ--->
        
    	<!--- DEPOLARA GÖRE ÜRETİM EMİRLERİ REZERVELER --->
      	<cfquery name="get_product_rezerv_dep" datasource="#dsn3#">
           	SELECT    
            	S1.STOCK_ID,
             	S1.PRODUCT_ID,
            	PO.EXIT_DEP_ID,    
              	<cfif isdefined('attributes.real_material')>
                	SUM(POS.AMOUNT*ISNULL((PO.QUANTITY - TBL.AMOUNT) / PO.QUANTITY, 1)) AS STOCK_AZALT
             	<cfelse>
                 	SUM(POS.AMOUNT) AS STOCK_AZALT
              	</cfif>
          	FROM            
            	PRODUCTION_ORDERS AS PO INNER JOIN
              	PRODUCTION_ORDERS_STOCKS AS POS ON PO.P_ORDER_ID = POS.P_ORDER_ID INNER JOIN
             	STOCKS AS S1 ON POS.STOCK_ID = S1.STOCK_ID LEFT OUTER JOIN
             	(
                	SELECT        
                  		POR.P_ORDER_ID, SUM(PORR.AMOUNT) AS AMOUNT
                 	FROM            
                    	PRODUCTION_ORDER_RESULTS AS POR INNER JOIN
                    	PRODUCTION_ORDER_RESULTS_ROW AS PORR ON POR.PR_ORDER_ID = PORR.PR_ORDER_ID
                 	WHERE        
                     	PORR.TYPE = 1 AND 
                      	POR.IS_STOCK_FIS = 1
                 	GROUP BY POR.P_ORDER_ID
            	) AS TBL ON PO.P_ORDER_ID = TBL.P_ORDER_ID
        	WHERE
            	PO.IS_STOCK_RESERVED = 1 AND
              	PO.P_ORDER_ID = POS.P_ORDER_ID AND
             	PO.IS_DEMONTAJ=0 AND
              	ISNULL(POS.STOCK_ID,0)>0 AND
              	POS.IS_SEVK <> 1 AND
				ISNULL(IS_FREE_AMOUNT,0) = 0 AND
            	PO.EXIT_DEP_ID IN (#attributes.DEPARTMENT_ID#) AND
            	POS.STOCK_ID IN (#stock_id_list#)
       		GROUP BY 
            	S1.STOCK_ID,
             	S1.PRODUCT_ID,
            	PO.EXIT_DEP_ID
      	</cfquery>
        <cfoutput query="get_product_rezerv_dep">
            <cfset 'PRODUCTION_STOCK_AZALT_#STOCK_ID#'= STOCK_AZALT>
        </cfoutput>
		<!--- DEPOLARA GÖRE ÜRETİM EMİRLERİ REZERVELER BİTTİ--->
        
        <!--- DEPOLARA GÖRE STRATEJİLERDEN MIN STOCK --->
     	<cfquery name="GET_STOCT_STR_DEP" datasource="#DSN3#">
					SELECT 
                    	DEPARTMENT_ID,
                        ISNULL(MINIMUM_STOCK,0) AS MINIMUM_STOCK,
                        ISNULL(REPEAT_STOCK_VALUE,0) AS REPEAT_STOCK_VALUE,
                        ISNULL(PROVISION_TIME,0) AS PROVISION_TIME,
                        ISNULL(MINIMUM_ORDER_STOCK_VALUE,0) AS MINIMUM_ORDER_STOCK_VALUE,
                        ISNULL(STRATEGY_ORDER_TYPE,1) AS STRATEGY_ORDER_TYPE,
                        STOCK_ID 
					FROM 
                    	STOCK_STRATEGY 
					WHERE 
                    	STOCK_ID IN (#stock_id_list#)
      	</cfquery>
        <cfoutput query="GET_STOCT_STR_DEP">
            <cfset 'MINIMUM_STOCK_#STOCK_ID#'=MINIMUM_STOCK>
            <cfset 'REPEAT_STOCK_VALUE_#STOCK_ID#'=REPEAT_STOCK_VALUE>
            <cfset 'PROVISION_TIME_#STOCK_ID#'=PROVISION_TIME>
            <cfset 'MINIMUM_ORDER_STOCK_VALUE_#STOCK_ID#'=MINIMUM_ORDER_STOCK_VALUE>
            <cfset 'STRATEGY_ORDER_TYPE_#STOCK_ID#'=STRATEGY_ORDER_TYPE>
        </cfoutput>
        <!--- DEPOLARA GÖRE STRATEJİLERDEN MIN STOCK bitti --->
        
         <!--- ÜRÜN FİYATLAR --->
   		<cfquery name="GET_PRICE" datasource="#DSN3#">
         	SELECT
             	P.MONEY,
              	P.PRICE,
              	S.STOCK_ID
          	FROM
				<cfif attributes.price_cat eq -1>
					PRICE_STANDART P,
				<cfelse>
					PRICE P,
				</cfif>
           		STOCKS S  
         	WHERE
            	S.PRODUCT_ID = P.PRODUCT_ID AND
             	S.STOCK_ID IN (#stock_id_list#) AND
				<cfif attributes.price_cat eq -1>
					P.PRICESTANDART_STATUS = 1 AND
					P.PURCHASESALES = 0
				<cfelse>
					ISNULL(P.STOCK_ID,0)=0 AND
					ISNULL(P.SPECT_VAR_ID,0)=0 AND
					P.STARTDATE <= #now()# AND
					(P.FINISHDATE >= #now()# OR P.FINISHDATE IS NULL) AND
					P.PRICE_CATID = #attributes.price_cat#
				</cfif>
       	</cfquery>
        <cfoutput query="GET_PRICE">
            <cfset 'PRICE_#STOCK_ID#'=PRICE>
            <cfset 'MONEY_#STOCK_ID#'=MONEY> 
        </cfoutput>  
        <!--- ÜRÜN FİYATLAR BİTTİ --->
        
        <!--- SATIALMA SİPARİŞ REZERVELER ---> 
        <cfquery name="GET_STOCK_RESERVED" datasource="#DSN3#"><!--- siparisler stoktan dusulecek veya eklenecekse toplamını alalım--->
			SELECT
				STOCK_ID,
				SUM(STOCK_ARTIR) AS ARTAN
			FROM
				GET_STOCK_RESERVED_ROW_LOCATION
			WHERE 
				STOCK_ID IN (#stock_id_list#) AND 
				DEPARTMENT_ID IN (#attributes.DEPARTMENT_ID#)
			GROUP BY 
            	STOCK_ID  
      	</cfquery> 
        <cfoutput query="GET_STOCK_RESERVED">
            <cfset 'PURCHASE_ORDER_ARTAN_#STOCK_ID#'=ARTAN>
        </cfoutput> 
        <!--- SATIALMA SİPARİŞ REZERVELER BİTTİ---> 
        <cfif attributes.list_tur eq 1>
			<!--- AÇIK İÇ TALEPLER --->
           <cfquery name="GET_INTERNALDEMAND" datasource="#dsn3#">
                SELECT        
                    IR.STOCK_ID, 
                    IR.QUANTITY - ISNULL((
                                            SELECT        
                                                SUM(QUANTITY) AS QUANTITY
                                            FROM            
                                                ORDER_ROW
                                            WHERE        
                                               
                                                RELATED_INTERNALDEMAND_ROW_ID = IR.I_ROW_ID
                                        ), 0) AS IC_TALEP
                FROM            
                    INTERNALDEMAND AS I INNER JOIN
                    INTERNALDEMAND_ROW AS IR ON I.INTERNAL_ID = IR.I_ID
                WHERE        
                    IR.STOCK_ID IN (#stock_id_list#)
            </cfquery>
            <cfoutput query="GET_INTERNALDEMAND">
                <cfset 'IC_TALEP_#STOCK_ID#'= IC_TALEP>
            </cfoutput> 
            <cfif isdefined('attributes.is_net_demand')>
                <cfquery name="GET_INTERNALDEMAND_MASTER_PLAN" datasource="#dsn3#">
                    SELECT        
                        IR.STOCK_ID, 
                        SUM(IR.QUANTITY )AS IC_TALEP
                    FROM            
                        INTERNALDEMAND AS I INNER JOIN
                        INTERNALDEMAND_ROW AS IR ON I.INTERNAL_ID = IR.I_ID
                    WHERE        
                        IR.STOCK_ID IN (#stock_id_list#)
                        <cfif isdefined('attributes.master_plan_id') and len(attributes.master_plan_id)> 
                            AND I.REF_NO = '#get_master_plan_info.MASTER_PLAN_NUMBER#'
                        <cfelse>
                            AND I.REF_NO = '-1'
                        </cfif>
                    GROUP BY
                        IR.STOCK_ID	
                </cfquery>
                <cfoutput query="GET_INTERNALDEMAND_MASTER_PLAN">
                    <cfset 'IC_TALEP_MASTER_PLAN_#STOCK_ID#'= IC_TALEP>
                </cfoutput>
            </cfif> 
            <!--- AÇIK İÇ TALEPLER BITTI--->
      	<cfelse>
        	<!--- AMBAR FİŞLERİ --->
         	<cfquery name="get_period" datasource="#dsn#">
                SELECT     
                    TOP (2)
                    PERIOD_YEAR
                FROM         
                    SETUP_PERIOD
                WHERE     
                    OUR_COMPANY_ID = #session.ep.company_id#
                ORDER BY
                    PERIOD_YEAR desc      
            </cfquery>
            <cfset our_company_years = Valuelist(get_period.PERIOD_YEAR)>
            <cfif isdefined('attributes.is_net_demand')>
                <cfquery name="get_ambar_fis" datasource="#dsn3#">
                    SELECT
                        SUM(STOCK_IN) AS AMBAR_STOCK,
                        STOCK_ID
                    FROM
                        (      
                        <cfloop list="#our_company_years#" index="comp_ii">
                            SELECT     
                                SR.STOCK_IN,
                                SR.STOCK_ID
                            FROM         
                                #dsn#_#comp_ii#_#session.ep.company_id#.STOCK_FIS AS SF INNER JOIN
                                #dsn#_#comp_ii#_#session.ep.company_id#.STOCKS_ROW AS SR ON SF.FIS_ID = SR.UPD_ID
                            WHERE     
                                SF.FIS_TYPE = 113 AND 
                                SF.REF_NO = '#get_master_plan_info.MASTER_PLAN_NUMBER#' AND 
                                SR.STOCK_IN > 0 AND 
                                SR.STOCK_ID IN (#stock_id_list#)
                                <cfif listlen(our_company_years) neq 1 and comp_ii neq listlast(our_company_years,',')> UNION ALL </cfif>
                        </cfloop>
                        ) AS TBL
                    GROUP BY
                        STOCK_ID
                </cfquery>
                <cfoutput query="get_ambar_fis">
                    <cfset 'AMBAR_STOCK_#STOCK_ID#' = AMBAR_STOCK>
                </cfoutput>
           	</cfif>
            <!--- AMBAR FİŞLERİ BİTTİ--->
            
        </cfif>
    </cfif>
	<cfset arama_yapilmali = 0>
<cfelse>
	<cfset get_total_material.recordcount = 0>
	<cfset arama_yapilmali = 1>
</cfif>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_total_material.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="list_meterials" method="post" action="#request.self#?fuseaction=#url.fuseaction#" enctype="multipart/form-data">
	<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
    <cfif isdefined('attributes.iid')>
    	<cfinput type="hidden" name="iid" value="#attributes.iid#">
    <cfelseif isdefined('attributes.p_order_id_list')>
    	<cfinput type="hidden" name="p_order_id_list" value="#attributes.p_order_id_list#">
    </cfif>
    <cfif isdefined('attributes.master_plan_id') and len(attributes.master_plan_id)>
    	<cfinput type="hidden" name="master_plan_id" value="#attributes.master_plan_id#">
    </cfif>
   	<cf_big_list_search title="#getLang('main',3242)#" collapsed="1">
		<cf_big_list_search_area>
            <table>
                <tr height="20px">
                    <td><cf_get_lang_main no='48.Filtre'></td>
                    <td><cfinput type="text" name="keyword" id="keyword" style="width:90px;" value="#attributes.keyword#" maxlength="500"></td>
                    <td width="170px">
                    	<cf_get_lang_main no='3243.Kalan Üretim İçin Hesapla'>
                        <input type="checkbox" name="real_material" value="1" <cfif isdefined('attributes.real_material')>checked</cfif>>
                    </td>
                    <td width="170px">
                    	<cf_get_lang_main no='3244.İç Talebi MRP Hesapla'>
                        <input type="checkbox" name="demand_type" value="1" <cfif isdefined('attributes.demand_type')>checked</cfif>>
                    </td>
                    <td width="150px">
                    	<cf_get_lang_main no='3467.Lot Grupla'>
                        <input type="checkbox" name="is_lot_group" value="1" <cfif isdefined('attributes.is_lot_group')>checked</cfif>>
                    </td>
                    <td width="150px">
                    	<cf_get_lang_main no='3418.Gerçek İhtiyaç'>
                        <input type="checkbox" name="is_net_demand" value="1" <cfif isdefined('attributes.is_net_demand')>checked</cfif>>
                    </td>
                    <!---<td>Sıralama</td>
                    <td width="100px">
                    	<select name="oby" style="width:90px; height:20px">
                            <option value="1" <cfif attributes.oby eq 1>selected</cfif>>Ürün Koduna Göre</option>
                            <option value="2" <cfif attributes.oby eq 2>selected</cfif>>Ürün Adına Göre</option>
                        </select>
                    </td>--->
                    <td width="160px">
                    	<cf_get_lang_main no='1675.Yöntem'>&nbsp;
                    	<select name="list_type" id="list_type" style="width:80px; height:20px" onchange="chng_list_type()">
                            <option value="1" <cfif attributes.list_type eq 1>selected</cfif>>MRP</option>
                            <option value="2" <cfif attributes.list_type eq 2>selected</cfif>>Kanban</option>
                            <option value="3" <cfif attributes.list_type eq 3>selected</cfif>><cf_get_lang_main no='1373.Detaylı'></option>
                        </select>
                    </td>
                    <td width="160px" id="list_tur_td">
                    	<cf_get_lang_main no='97.Liste'>&nbsp;
                    	<select name="list_tur" id="list_tur" style="width:90px; height:20px">
                            <option value="1" <cfif attributes.list_tur eq 1>selected</cfif>><cf_get_lang_main no='1386.İç Talep'></option>
                            <option value="2" <cfif attributes.list_tur eq 2>selected</cfif>><cf_get_lang_main no='1833.Ambar Fişi'></option>
                        </select>
                    </td>
                    <cfif not (isdefined('attributes.master_plan_id') and len(attributes.master_plan_id))>
                    	<td width="160px">
                        	<select name="department_id" style="width:150px; height:20px">
                            	<cfoutput query="get_department">
                                	<option value="#DEPARTMENT_ID#" <cfif ListFind(attributes.department_id,DEPARTMENT_ID)>selected</cfif>>#DEPARTMENT_HEAD#</option>
                                </cfoutput>
                            </select>
                        </td>
                    </cfif>
                    <td><cf_wrk_search_button search_function='input_control()'></td>

				</tr>
			</table>
        </cf_big_list_search_area>
	</cf_big_list_search>
	<cf_big_list id="list_product_big_list">
    	<cfif attributes.list_type eq 1><!--- MRP Ürünler İse--->
            <thead>
                <tr valign="middle">
                    <th rowspan="2" style=" text-align:center; width:20px; height:20px">No</th>
                    <cfif isdefined('attributes.is_lot_group')>
                    	<th rowspan="2" style=" text-align:center; width:20px; height:20px"><cf_get_lang no='385.Lot No'></th>
                    </cfif>
                    <th rowspan="2" style=" text-align:center; width:90px"><cf_get_lang_main no='106.Stok Kodu'></th>
                    <th rowspan="2" style=" text-align:center;"><cf_get_lang_main no='809.Ürün Adı'></th>
                    <th rowspan="2" style=" text-align:center; width:60px">Plan<br /><cf_get_lang_main no='3245.İhtiyacı'></th>
                    <th rowspan="2" style=" text-align:center; width:30px"><cf_get_lang_main no='224.Birim'></th>
                    <th rowspan="2" style=" text-align:center; width:50px"><cf_get_lang_main no='672.Fiyat'></th>
                    <th rowspan="2" style=" text-align:center; width:20px">&nbsp;</th>
                    <th rowspan="2" style=" text-align:center; width:60px"><cf_get_lang_main no='261.Tutar'></th>
                    <th rowspan="2" style=" text-align:center; width:20px">&nbsp;</th>
                    <th colspan="3" style=" text-align:center;"><cf_get_lang_main no='2029.Artan'></th>
                    <th colspan="2" style=" text-align:center;"><cf_get_lang_main no='2030.Azalan'></th>
                    <th rowspan="2" style=" text-align:center; width:50px" title="<cf_get_lang_main no='3246.Malzeme İhtiyacı'>"><cf_get_lang_main no='3247.Malzeme'><br /><cf_get_lang_main no='3245.İhtiyacı'></th>
                    <th rowspan="2" style=" text-align:center; width:50px" title="<cfif attributes.list_tur eq 1>İç Talepler<cfelse>Ambar Fişi</cfif>">
						<cfif attributes.list_tur eq 1>
                        	<cf_get_lang_main no='1149.İç'><br /><cf_get_lang_main no='115.Talepler'>
                        <cfelse>
                        	<cf_get_lang_main no='3248.Ambar'><br /><cf_get_lang_main no='3249.Fişi'>
                        </cfif>
                    </th>
                    <!---<th rowspan="2" style=" text-align:center; width:50px" title="Minimum Sipariş Miktarı">Minimum<br />Sipariş</th>--->
                    <th rowspan="2" style=" text-align:center; width:50px" title="Gönderilecek İç Talep"><cf_get_lang_main no='2500.Satınalma'><br /><cf_get_lang_main no='3250.Talebi'></th>
                    <!-- sil -->
                    <th rowspan="2" style=" text-align:center; width:25px" >
                    	
                    </th>
                    <!-- sil -->
                </tr>
                <tr>
                    <th style=" text-align:center; width:50px; height:10px" title="<cf_get_lang_main no='708.Gerçek Stok'>"><cf_get_lang_main no='3257.G.Stok'></th>
                    <th style=" text-align:center; width:50px" title="<cf_get_lang_main no='1305.Açık'> <cf_get_lang_main no='2211.Satınalma Siparişleri'>">		<cf_get_lang_main no='3251.S. Rezerve'> </th>
                    <th style=" text-align:center; width:50px" title="<cf_get_lang_main no='80.Toplam'> <cf_get_lang_main no='1305.Açık'> <cf_get_lang_main no='3253.İç Talepler'>"><cf_get_lang_main no='3252.A.İç Talep'></th>
                    <th style=" text-align:center; width:50px" title="<cf_get_lang_main no='1305.Açık'> <cf_get_lang_main no='3254.Üretim Planları'>"><cf_get_lang_main no='3255.Ü.Rezerve'></th>
                    <th style=" text-align:center; width:50px" title="<cf_get_lang_main no='3256.Yeniden Sipariş Noktası'>">Minimum <cf_get_lang_main no='40.Stok'></th>
                </tr>
            </thead>
       	<cfelseif attributes.list_type eq 2><!--- Kanban Ürünler İse--->
        	<thead>
                <tr valign="middle">
                    <th rowspan="2" style=" text-align:center; width:20px; height:20px">No</th>
                    <cfif isdefined('attributes.is_lot_group')>
                    	<th rowspan="2" style=" text-align:center; width:20px; height:20px"><cf_get_lang no='385.Lot No'></th>
                    </cfif>
                    <th rowspan="2" style=" text-align:center; width:90px"><cf_get_lang_main no='106.Stok Kodu'></th>
                    <th rowspan="2" style=" text-align:center;"><cf_get_lang_main no='809.Ürün Adı'></th>
                    <th rowspan="2" style=" text-align:center; width:60px">Plan<br /><cf_get_lang_main no='3245.İhtiyacı'></th>
                    <th rowspan="2" style=" text-align:center; width:30px"><cf_get_lang_main no='224.Birim'></th>
                    <th rowspan="2" style=" text-align:center; width:50px"><cf_get_lang_main no='672.Fiyat'></th>
                    <th rowspan="2" style=" text-align:center; width:20px">&nbsp;</th>
                    <th rowspan="2" style=" text-align:center; width:60px"><cf_get_lang_main no='261.Tutar'></th>
                    <th rowspan="2" style=" text-align:center; width:20px">&nbsp;</th>
                    <th colspan="3" style=" text-align:center;"><cf_get_lang_main no='2029.Artan'></th>
                    <th colspan="2" style=" text-align:center;"><cf_get_lang_main no='2030.Azalan'></th>
                    <th rowspan="2" style=" text-align:center; width:50px" title="<cf_get_lang_main no='3246.Malzeme İhtiyacı'>"><cf_get_lang_main no='3247.Malzeme'><br /><cf_get_lang_main no='3245.İhtiyacı'></th>
                    <th rowspan="2" style=" text-align:center; width:50px" title="Minimum Sipariş Miktarı">Minimum<br /><cf_get_lang_main no='199.Sipariş'></th>
                    <th rowspan="2" style=" text-align:center; width:50px" title="Gönderilecek İç Talep"><cf_get_lang_main no='2500.Satınalma'><br /><cf_get_lang_main no='3250.Talebi'></th>
                    <!-- sil -->
                    <th rowspan="2" style=" text-align:center; width:25px"></th>
                    <!-- sil -->
                </tr>
                <tr>
                    <th style=" text-align:center; width:50px; height:10px" title="<cf_get_lang_main no='708.Gerçek Stok'>"><cf_get_lang_main no='3257.G.Stok'></th>
                    <th style=" text-align:center; width:50px" title="<cf_get_lang_main no='1305.Açık'> <cf_get_lang_main no='2211.Satınalma Siparişleri'>"><cf_get_lang_main no='3251.S. Rezerve'></th>
                    <th style=" text-align:center; width:50px" title="<cf_get_lang_main no='80.Toplam'> <cf_get_lang_main no='1305.Açık'> <cf_get_lang_main no='3253.İç Talepler'>"><cf_get_lang_main no='3252.A.İç Talep'></th>
                    <th style=" text-align:center; width:50px" title="<cf_get_lang_main no='1305.Açık'> <cf_get_lang_main no='3254.Üretim Planları'>"><cf_get_lang_main no='3255.Ü.Rezerve'></th>
                    <th style=" text-align:center; width:50px" title="<cf_get_lang_main no='3256.Yeniden Sipariş Noktası'>">Minimum <cf_get_lang_main no='40.Stok'></th>
                </tr>
            </thead>
       	<cfelseif attributes.list_type eq 3><!--- Detaylı İse--->
        	<thead>
                <tr valign="middle">
                    <th style=" text-align:center; width:20px; height:20px">No</th>
                    <cfif isdefined('attributes.is_lot_group')>
                    <th style=" text-align:center; width:20px; height:20px"><cf_get_lang no='385.Lot No'></th>
                    </cfif>
                    <th style=" text-align:center; width:90px"><cf_get_lang_main no='106.Stok Kodu'></th>
                    <th style=" text-align:center;"><cf_get_lang_main no='809.Ürün Adı'></th>
                    <th style=" text-align:center; width:60px">Plan<br /><cf_get_lang_main no='3245.İhtiyacı'></th>
                    <th style=" text-align:center; width:30px"><cf_get_lang_main no='224.Birim'></th>
                    <th style=" text-align:center; width:50px"><cf_get_lang_main no='672.Fiyat'></th>
                    <th style=" text-align:center; width:20px">&nbsp;</th>
                    <th style=" text-align:center; width:60px"><cf_get_lang_main no='261.Tutar'></th>
                    <th style=" text-align:center; width:20px">&nbsp;</th>
                    <th style=" text-align:center; width:150px"><cf_get_lang_main no='359.Detay'></th>
                    <th rowspan="2" style=" text-align:center; width:50px" title="<cfif attributes.list_tur eq 1>İç Talepler<cfelse>Ambar Fişi</cfif>">
						<cfif attributes.list_tur eq 1>
                        	<cf_get_lang_main no='1149.İç'><br /><cf_get_lang_main no='115.Talepler'>
                        <cfelse>
                        	<cf_get_lang_main no='3248.Ambar'><br /><cf_get_lang_main no='3249.Fişi'>
                        </cfif>
                    </th>
                   	<th style=" text-align:center; width:50px"><cf_get_lang_main no='2500.Satınalma'><br /><cf_get_lang_main no='3250.Talebi'></th>
                    <!-- sil -->
                    <th rowspan="2" style=" text-align:center; width:25px"></th>
                    <!-- sil -->
                </tr>
            </thead>
        
        </cfif>
        <tbody>
			<cfif get_total_material.recordcount> 
                <cfloop query="get_total_material">
                	<cfif attributes.list_type eq 1>
						<cfoutput>
                            <tr> 
                                <td style="text-align:right; height:15px">#currentrow#&nbsp;</td>
                                <cfif isdefined('attributes.is_lot_group')>
                                	<td title="<cfif isdefined("ORDER_NUMBER_#Replace(LOT_NO,' ','','All')#")>#Evaluate("ORDER_NUMBER_#Replace(LOT_NO,' ','','All')#")#</cfif> - <cfif isdefined("UNVAN_#Replace(LOT_NO,' ','','All')#")>#Evaluate("UNVAN_#Replace(LOT_NO,' ','','All')#")#</cfif>">&nbsp;#get_total_material.LOT_NO#</td>
                                </cfif>
                                <td>
                                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#&sid=#stock_id#</cfoutput>','wide');"  class="tableyazi">
                                    	&nbsp;#get_total_material.PRODUCT_CODE#
                                   	</a>
                                </td>
                                <td title="#get_total_material.PRODUCT_NAME#">&nbsp;#Left(get_total_material.PRODUCT_NAME,45)#<cfif len(get_total_material.PRODUCT_NAME) gt 45>...</cfif></td>
                                <td title="Master Plan <cf_get_lang_main no='3258.Üretim İhtiyacı'>" style="text-align:right; font-weight:bold">
                                	<cfif (isdefined('attributes.iid') and listlen(attributes.iid))>
                                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_upd_ezgi_production_material&pid=#product_id#&sid=#stock_id#&iid=#attributes.iid#&total=#get_total_material.AMOUNT#</cfoutput>','small');"  class="tableyazi">
                                            #TlFormat(get_total_material.AMOUNT,2)#
                                        </a>
                                    <cfelse>
                                    	#TlFormat(get_total_material.AMOUNT,2)#
                                    </cfif>
                               	</td>
                                <td>&nbsp;#MAIN_UNIT#</td>
                                <td title="<cf_get_lang_main no='226.Birim Fiyat'>" style="text-align:right">
                                	<cfif isdefined('PRICE_#STOCK_ID#')>
                                    	#TlFormat(Evaluate('PRICE_#STOCK_ID#'),4)#
                                        <cfset row_price = Evaluate('PRICE_#STOCK_ID#')>
                                         <input type="hidden" name="row_price_unit_#stock_id#" id="row_price_unit_#stock_id#" value="#tlformat(row_price)#">
                                    <cfelse>
                                    <cfset row_price = 0>
                                    	#TlFormat(0,4)#
                                         <input type="hidden" name="row_price_unit_#stock_id#" id="row_price_unit_#stock_id#" value="#tlformat(0)#">
                                    </cfif>
                                </td>
                                <td title="<cf_get_lang_main no='265.Döviz'>">&nbsp;
                                	<cfif isdefined('MONEY_#STOCK_ID#')>
                                    	#Evaluate('MONEY_#STOCK_ID#')#
                                        <input type="hidden" name="row_stock_money_#stock_id#" id="row_stock_money_#stock_id#" value="#Evaluate('MONEY_#STOCK_ID#')#" />
                                    <cfelse>
                                    	<input type="hidden" name="row_stock_money_#stock_id#" id="row_stock_money_#stock_id#" value="#session.ep.money#" />
                                    	#session.ep.money#
                                    </cfif>
                                </td>
                                <td title="<cf_get_lang_main no='261.Tutar'>" style="text-align:right">
                                	<cfif isdefined('PRICE_#STOCK_ID#')>
                                    	#TlFormat(Evaluate('PRICE_#STOCK_ID#')*get_total_material.AMOUNT,2)#
                                    <cfelse>
                                    	#TlFormat(0,4)#
                                    </cfif>
                                </td>
                                <td title="<cf_get_lang_main no='265.Döviz'>">&nbsp;
                                	<cfif isdefined('MONEY_#STOCK_ID#')>
                                    	#Evaluate('MONEY_#STOCK_ID#')#
                                    <cfelse>
                                    	#session.ep.money#
                                    </cfif>
                                </td>
                                <cfset row_total_need = 0>
                                <td title="<cf_get_lang_main no='708.Gerçek Stok'>" style="text-align:right;background-color:LightCyan">
                                	<cfif isdefined('PRODUCT_STOCK_#STOCK_ID#')>
                                    	<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=stock.detail_store_stock_popup&stock_id=#stock_id#&product_id=#product_id#</cfoutput>','list');">
                                            <span style="<cfif Evaluate('PRODUCT_STOCK_#STOCK_ID#') lt 0>color:red</cfif>">
                                                #TlFormat(Evaluate('PRODUCT_STOCK_#STOCK_ID#'),2)#
                                            </span>
                                       	</a>
                                        <cfset row_total_need = row_total_need + Evaluate('PRODUCT_STOCK_#STOCK_ID#')>
                                   	<cfelse>
                                    	#TlFormat(0,2)#
                                    </cfif>
                                </td>
                                <td title="<cf_get_lang_main no='1305.Açık'> <cf_get_lang_main no='3259.Satınalma Siparişi'>" style="text-align:right;background-color:LightCyan">
                                	<cfif isdefined('PURCHASE_ORDER_ARTAN_#STOCK_ID#')>
                                    	<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_reserved_orders&taken=0&pid=#product_id#&nosale_order_location=0</cfoutput>','list');">
                                    	#TlFormat(Evaluate('PURCHASE_ORDER_ARTAN_#STOCK_ID#'),2)#
                                        <cfset row_total_need = row_total_need + Evaluate('PURCHASE_ORDER_ARTAN_#STOCK_ID#')>
                                   	<cfelse>
                                    	#TlFormat(0,2)#
                                    </cfif>
                                </td>
                                <td title="<cf_get_lang_main no='3260.Master Plana Özel İç Talepler'>" style="text-align:right;background-color:LightCyan">
                                	<cfif isdefined('IC_TALEP_#STOCK_ID#')>
                                    	#TlFormat(Evaluate('IC_TALEP_#STOCK_ID#'),2)#
                                        <cfset row_total_need = row_total_need + Evaluate('IC_TALEP_#STOCK_ID#')>
                                   	<cfelse>
                                    	#TlFormat(0,2)#
                                    </cfif>
                                </td>
                                <td title="<cf_get_lang_main no='3261.Tüm Açık Üretim Planları Rezerve'>" style="text-align:right;background-color:Seashell">
                                	<cfif isdefined('PRODUCTION_STOCK_AZALT_#STOCK_ID#')>
                                    	<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_reserved_production_orders&type=2&pid=#product_id#</cfoutput>','list');">
                                    		#TlFormat(Evaluate('PRODUCTION_STOCK_AZALT_#STOCK_ID#'),2)#
                                     	</a>
                                        <cfset row_total_need = row_total_need - Evaluate('PRODUCTION_STOCK_AZALT_#STOCK_ID#')>
                                   	<cfelse>
                                    	#TlFormat(0,2)#
                                    </cfif>
                                </td>
                                <td title="Minimum <cf_get_lang_main no='40.Stok'>" style="text-align:right;background-color:Seashell">
                                	<cfif isdefined('MINIMUM_STOCK_#STOCK_ID#')>
                                    	#TlFormat(Evaluate('MINIMUM_STOCK_#STOCK_ID#'),2)#
                                        <cfset row_total_need = row_total_need - Evaluate('MINIMUM_STOCK_#STOCK_ID#')>
                                   	<cfelse>
                                    	#TlFormat(0,2)#
                                    </cfif>
                                </td>
                                <td title="MRP" style="text-align:right;background-color:Gainsboro;font-weight:bold">
                                	#TlFormat(row_total_need*-1,2)#
                                </td>
                                <td title="<cf_get_lang_main no='3262.Plana Bağlı Açık Talepler'>" style="text-align:right">
                                	<cfif attributes.list_tur eq 1><!---İç Talep İse--->
										<cfif isdefined('attributes.demand_type')> <!---Klasik MRP İse--->
                                            <cfif isdefined('IC_TALEP_MASTER_PLAN_#STOCK_ID#')>
                                                #TlFormat(Evaluate('IC_TALEP_MASTER_PLAN_#STOCK_ID#'),2)#
                                                <cfset row_total_need = (row_total_need *-1)- Evaluate('IC_TALEP_MASTER_PLAN_#STOCK_ID#')>
                                            <cfelse>
                                                #TlFormat(0,2)#
                                                <cfset row_total_need = row_total_need *-1>
                                            </cfif>
                                        <cfelse><!---Ambar Fişi--->
                                            <cfset row_total_need = 0>
                                            <cfif isdefined('IC_TALEP_MASTER_PLAN_#STOCK_ID#')>
                                                #TlFormat(Evaluate('IC_TALEP_MASTER_PLAN_#STOCK_ID#'),2)#
                                                <cfset row_total_need = get_total_material.AMOUNT - Evaluate('IC_TALEP_MASTER_PLAN_#STOCK_ID#')>
                                            <cfelse>
                                                #TlFormat(0,2)#
                                                <cfset row_total_need = get_total_material.AMOUNT>
                                            </cfif>
                                        </cfif>
                                    <cfelse>
                                    	<cfif isdefined('attributes.demand_type')> <!---Klasik MRP İse--->
                                            <cfif isdefined('AMBAR_STOCK_#STOCK_ID#')>
                                                #TlFormat(Evaluate('AMBAR_STOCK_#STOCK_ID#'),2)#
                                                <cfset row_total_need = (row_total_need *-1)- Evaluate('AMBAR_STOCK_#STOCK_ID#')>
                                            <cfelse>
                                                #TlFormat(0,2)#
                                                <cfset row_total_need = row_total_need *-1>
                                            </cfif>
                                        <cfelse><!---Ambar Fişi--->
                                            <cfset row_total_need = 0>
                                            <cfif isdefined('AMBAR_STOCK_#STOCK_ID#')>
                                                #TlFormat(Evaluate('AMBAR_STOCK_#STOCK_ID#'),2)#
                                                <cfset row_total_need = get_total_material.AMOUNT - Evaluate('AMBAR_STOCK_#STOCK_ID#')>
                                            <cfelse>
                                                #TlFormat(0,2)#
                                                <cfset row_total_need = get_total_material.AMOUNT>
                                            </cfif>
                                        </cfif>
                                    </cfif>
                                </td>
                                <td title="Master Plan <cf_get_lang_main no='3258.Üretim İhtiyacı'> - <cf_get_lang_main no='1386.İç Talep'>" style="text-align:right">
                                	<cfif row_total_need lt 0><cfset row_total_need = 0></cfif>
                                	<input type="text" name="row_total_need_#stock_id#" id="row_total_need_#stock_id#" value="#tlformat(row_total_need,2)#" class="box" style="width:60px;" onKeyup="return(FormatCurrency(this,event));" onBlur="hesapla(#stock_id#);">
                                    <input type="hidden" name="row_price_#stock_id#" id="row_price_#stock_id#" value="#tlformat(row_total_need*row_price)#" class="box" style="width:60px;" onKeyup="return(FormatCurrency(this,event));">
                                </td>
                                <!-- sil -->
                                <td style="text-align:center">
                                	 <input type="checkbox" name="conversion_product_#stock_id#" value="#stock_id#" id="_conversion_product_#currentrow#">
                                </td>
                                <!-- sil -->
                            </tr>
                            <cfif isdefined('PRICE_#STOCK_ID#')>
                              	<cfset "t1_fiyat#Evaluate('MONEY_#STOCK_ID#')#" = Evaluate("t1_fiyat#Evaluate('MONEY_#STOCK_ID#')#") + (Evaluate('PRICE_#STOCK_ID#')*get_total_material.AMOUNT)>
                           	</cfif>
                        </cfoutput>
                    </cfif>
                </cfloop>
                <cfloop query="get_total_material">
                	<cfif attributes.list_type eq 2>
						<cfoutput>
                            <tr> 
                                <td style="text-align:right; height:15px">#currentrow#&nbsp;</td>
                                <cfif isdefined('attributes.is_lot_group')>
                                	<td title="#Evaluate("ORDER_NUMBER_#Replace(LOT_NO,' ','','All')#")# - #Evaluate("UNVAN_#Replace(LOT_NO,' ','','All')#")#">&nbsp;#get_total_material.LOT_NO#</td>
                                </cfif>
                                <td>
                                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#&sid=#stock_id#</cfoutput>','wide');"  class="tableyazi">
                                    	&nbsp;#get_total_material.PRODUCT_CODE#
                                   	</a>
                                </td>
                                <td title="#get_total_material.PRODUCT_NAME#">&nbsp;#Left(get_total_material.PRODUCT_NAME,45)#<cfif len(get_total_material.PRODUCT_NAME) gt 45>...</cfif></td>
                                <td title="Master Plan <cf_get_lang_main no='3258.Üretim İhtiyacı'>" style="text-align:right; font-weight:bold">#TlFormat(get_total_material.AMOUNT,2)#</td>
                                <td>&nbsp;#MAIN_UNIT#</td>
                                <td title="<cf_get_lang_main no='226.Birim Fiyat'>" style="text-align:right">
                                	<cfif isdefined('PRICE_#STOCK_ID#')>
                                    	#TlFormat(Evaluate('PRICE_#STOCK_ID#'),4)#
                                        <cfset row_price = Evaluate('PRICE_#STOCK_ID#')>
                                         <input type="hidden" name="row_price_unit_#stock_id#" id="row_price_unit_#stock_id#" value="#tlformat(row_price)#">
                                    <cfelse>
                                    <cfset row_price = 0>
                                    	#TlFormat(0,4)#
                                         <input type="hidden" name="row_price_unit_#stock_id#" id="row_price_unit_#stock_id#" value="#tlformat(0)#">
                                    </cfif>
                                </td>
                                <td title="<cf_get_lang_main no='265.Döviz'>">&nbsp;
                                	<cfif isdefined('MONEY_#STOCK_ID#')>
                                    	#Evaluate('MONEY_#STOCK_ID#')#
                                        <input type="hidden" name="row_stock_money_#stock_id#" id="row_stock_money_#stock_id#" value="#Evaluate('MONEY_#STOCK_ID#')#" />
                                    <cfelse>
                                    	<input type="hidden" name="row_stock_money_#stock_id#" id="row_stock_money_#stock_id#" value="#session.ep.money#" />
                                    	#session.ep.money#
                                    </cfif>
                                </td>
                                <td title="<cf_get_lang_main no='261.Tutar'>" style="text-align:right">
                                	<cfif isdefined('PRICE_#STOCK_ID#')>
                                    	#TlFormat(Evaluate('PRICE_#STOCK_ID#')*get_total_material.AMOUNT,2)#
                                    <cfelse>
                                    	#TlFormat(0,4)#
                                    </cfif>
                                </td>
                                <td title="<cf_get_lang_main no='265.Döviz'>">&nbsp;
                                	<cfif isdefined('MONEY_#STOCK_ID#')>
                                    	#Evaluate('MONEY_#STOCK_ID#')#
                                    <cfelse>
                                    	#session.ep.money#
                                    </cfif>
                                </td>
                                <cfset row_total_need = 0>
                                <td title="<cf_get_lang_main no='708.Gerçek Stok'>" style="text-align:right;background-color:LightCyan">
                                	<cfif isdefined('PRODUCT_STOCK_#STOCK_ID#')>
                                    	<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=stock.detail_store_stock_popup&stock_id=#stock_id#&department=#attributes.department_id#&product_id=#product_id#</cfoutput>','list');">
                                            <span style="<cfif Evaluate('PRODUCT_STOCK_#STOCK_ID#') lt 0>color:red</cfif>">
                                                #TlFormat(Evaluate('PRODUCT_STOCK_#STOCK_ID#'),2)#
                                            </span>
                                       	</a>
                                        <cfset row_total_need = row_total_need + Evaluate('PRODUCT_STOCK_#STOCK_ID#')>
                                   	<cfelse>
                                    	#TlFormat(0,2)#
                                    </cfif>
                                </td>
                                <td title="<cf_get_lang_main no='1305.Açık'> <cf_get_lang_main no='3259.Satınalma Siparişi'>" style="text-align:right;background-color:LightCyan">
                                	<cfif isdefined('PURCHASE_ORDER_ARTAN_#STOCK_ID#')>
                                    	<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_reserved_orders&taken=0&pid=#product_id#&nosale_order_location=0</cfoutput>','list');">
                                    	#TlFormat(Evaluate('PURCHASE_ORDER_ARTAN_#STOCK_ID#'),2)#
                                        <cfset row_total_need = row_total_need + Evaluate('PURCHASE_ORDER_ARTAN_#STOCK_ID#')>
                                   	<cfelse>
                                    	#TlFormat(0,2)#
                                    </cfif>
                                </td>
                                <td title="<cf_get_lang_main no='3260.Master Plana Özel İç Talepler'>" style="text-align:right;background-color:LightCyan">
                                	<cfif isdefined('IC_TALEP_#STOCK_ID#')>
                                    	#TlFormat(Evaluate('IC_TALEP_#STOCK_ID#'),2)#
                                        <cfset row_total_need = row_total_need + Evaluate('IC_TALEP_#STOCK_ID#')>
                                   	<cfelse>
                                    	#TlFormat(0,2)#
                                    </cfif>
                                </td>
                                <td title="<cf_get_lang_main no='3261.	Tüm Açık Üretim Planları Rezerve'>" style="text-align:right;background-color:Seashell">
                                	<cfif isdefined('PRODUCTION_STOCK_AZALT_#STOCK_ID#')>
                                    	<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_reserved_production_orders&type=2&pid=#product_id#</cfoutput>','list');">
                                    		#TlFormat(Evaluate('PRODUCTION_STOCK_AZALT_#STOCK_ID#'),2)#
                                     	</a>
                                        <cfset row_total_need = row_total_need - Evaluate('PRODUCTION_STOCK_AZALT_#STOCK_ID#')>
                                   	<cfelse>
                                    	#TlFormat(0,2)#
                                    </cfif>
                                </td>
                                <td title="Minimum <cf_get_lang_main no='40.Stok'>" style="text-align:right;background-color:Seashell">
                                	<cfif isdefined('MINIMUM_STOCK_#STOCK_ID#')>
                                    	#TlFormat(Evaluate('MINIMUM_STOCK_#STOCK_ID#'),2)#
                                        <cfset row_total_need = row_total_need - Evaluate('MINIMUM_STOCK_#STOCK_ID#')>
                                   	<cfelse>
                                    	#TlFormat(0,2)#
                                    </cfif>
                                </td>
                                
                                <td title="MRP" style="text-align:right;background-color:Gainsboro;font-weight:bold">
                                	#TlFormat(row_total_need*-1,2)#
                                </td>
                                <td title="#getLang('product',664)#" style="text-align:right;background-color:white">
                                	<cfif isdefined('MINIMUM_ORDER_STOCK_VALUE_#STOCK_ID#')>
                                    	#TlFormat(Evaluate('MINIMUM_ORDER_STOCK_VALUE_#STOCK_ID#'),2)#
                                        <cfif isdefined('PRODUCT_STOCK_#STOCK_ID#') and isdefined('MINIMUM_STOCK_#STOCK_ID#') and Evaluate('PRODUCT_STOCK_#STOCK_ID#') lte Evaluate('MINIMUM_STOCK_#STOCK_ID#')>
                                        	<cfset row_total_need = Evaluate('MINIMUM_ORDER_STOCK_VALUE_#STOCK_ID#')>
                                       	<cfelse>
                                        	<cfset row_total_need = 0>
                                        </cfif>
                                   	<cfelse>
                                    	#TlFormat(0,2)#
                                    </cfif>
                                </td>
                                <td title="<cf_get_lang_main no='3263.Gerçek Stok Minimum Stoktan Küçükse Minimum Sipariş Miktarı'>" style="text-align:right">
                                	<cfif row_total_need lt 0><cfset row_total_need = 0></cfif>
                                	<input type="text" name="row_total_need_#stock_id#" id="row_total_need_#stock_id#" value="#tlformat(row_total_need,2)#" class="box" style="width:60px;" onKeyup="return(FormatCurrency(this,event));" onBlur="hesapla(#stock_id#);">
                                    <input type="hidden" name="row_price_#stock_id#" id="row_price_#stock_id#" value="#tlformat(row_total_need*row_price)#" class="box" style="width:60px;" onKeyup="return(FormatCurrency(this,event));">
                                    
                                </td>
                                <!-- sil -->
                                <td style="text-align:center">
                                	 <input type="checkbox" name="conversion_product_#stock_id#" value="#stock_id#" id="_conversion_product_#currentrow#"><!--- onClick="aktif_yap();" --->
                                </td>
                                <!-- sil -->
                            </tr>
                            <cfif isdefined('PRICE_#STOCK_ID#')>
                              	<cfset "t1_fiyat#Evaluate('MONEY_#STOCK_ID#')#" = Evaluate("t1_fiyat#Evaluate('MONEY_#STOCK_ID#')#") + (Evaluate('PRICE_#STOCK_ID#')*get_total_material.AMOUNT)>
                           	</cfif>
                        </cfoutput>
                    </cfif>
                </cfloop>
                <cfloop query="get_total_material">
                	<cfif attributes.list_type eq 3>
                    	<cfoutput>
                            <tr> 
                                <td style="text-align:right; height:15px">#currentrow#&nbsp;</td>
                                <cfif isdefined('attributes.is_lot_group')>
                                	<td title="#Evaluate("ORDER_NUMBER_#Replace(LOT_NO,' ','','All')#")# - #Evaluate("UNVAN_#Replace(LOT_NO,' ','','All')#")#">&nbsp;#get_total_material.LOT_NO#</td>
                                </cfif>
                                <td>
                                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#&sid=#stock_id#</cfoutput>','wide');"  class="tableyazi">
                                    	&nbsp;#get_total_material.PRODUCT_CODE#
                                   	</a>
                                </td>
                                <td title="#get_total_material.PRODUCT_NAME#">&nbsp;#Left(get_total_material.PRODUCT_NAME,45)#<cfif len(get_total_material.PRODUCT_NAME) gt 45>...</cfif></td>
                                <td title="Master Plan <cf_get_lang_main no='3258.Üretim İhtiyacı'>" style="text-align:right; font-weight:bold">#TlFormat(get_total_material.AMOUNT,2)#</td>
                                <td>&nbsp;#MAIN_UNIT#</td>
                                <td title="<cf_get_lang_main no='226.Birim Fiyat'>" style="text-align:right">
                                	<cfif isdefined('PRICE_#STOCK_ID#')>
                                    	#TlFormat(Evaluate('PRICE_#STOCK_ID#'),4)#
                                        <cfset row_price = Evaluate('PRICE_#STOCK_ID#')>
                                         <input type="hidden" name="row_price_unit_#stock_id#" id="row_price_unit_#stock_id#" value="#tlformat(row_price)#">
                                    <cfelse>
                                    <cfset row_price = 0>
                                    	#TlFormat(0,4)#
                                         <input type="hidden" name="row_price_unit_#stock_id#" id="row_price_unit_#stock_id#" value="#tlformat(0)#">
                                    </cfif>
                                </td>
                                <td title="<cf_get_lang_main no='265.Döviz'>">&nbsp;
                                	<cfif isdefined('MONEY_#STOCK_ID#')>
                                    	#Evaluate('MONEY_#STOCK_ID#')#
                                        <input type="hidden" name="row_stock_money_#stock_id#" id="row_stock_money_#stock_id#" value="#Evaluate('MONEY_#STOCK_ID#')#" />
                                    <cfelse>
                                    	<input type="hidden" name="row_stock_money_#stock_id#" id="row_stock_money_#stock_id#" value="#session.ep.money#" />
                                    	#session.ep.money#
                                    </cfif>
                                </td>
                                <td title="<cf_get_lang_main no='261.Tutar'>" style="text-align:right">
                                	<cfif isdefined('PRICE_#STOCK_ID#')>
                                    	#TlFormat(Evaluate('PRICE_#STOCK_ID#')*get_total_material.AMOUNT,2)#
                                    <cfelse>
                                    	#TlFormat(0,4)#
                                    </cfif>
                                </td>
                                <td title="<cf_get_lang_main no='265.Döviz'>">&nbsp;
                                	<cfif isdefined('MONEY_#STOCK_ID#')>
                                    	#Evaluate('MONEY_#STOCK_ID#')#
                                    <cfelse>
                                    	#session.ep.money#
                                    </cfif>
                                </td>
                                <cfif len(PIECE_DETAIL)>
                                	<cfset detail = '#PIECE_DETAIL# - #ADET# #getLang('main',670)#'>
                               	<cfelse>
                                	<cfset detail = ''>
                                </cfif>
                                <td title="<cf_get_lang_main no='359.Detay'>">&nbsp;
                                	#detail#
                                </td>
                                <cfset row_total_need = 0>
                                <td title="<cf_get_lang_main no='3262.Plana Bağlı Açık Talepler'>" style="text-align:right">
                                	<cfif attributes.list_tur eq 1><!---İç Talep İse--->
                                     	<cfif isdefined('IC_TALEP_MASTER_PLAN_#STOCK_ID#')>
                                         	#TlFormat(Evaluate('IC_TALEP_MASTER_PLAN_#STOCK_ID#'),2)#
                                      		<cfset row_total_need = get_total_material.AMOUNT - Evaluate('IC_TALEP_MASTER_PLAN_#STOCK_ID#')>
                                    	<cfelse>
                                        	#TlFormat(0,2)#
                                            <cfset row_total_need = get_total_material.AMOUNT>
                                      	</cfif>
                                    <cfelse><!---Ambar Fişi İse--->
                                     	<cfif isdefined('AMBAR_STOCK_#STOCK_ID#')>
                                       		#TlFormat(Evaluate('AMBAR_STOCK_#STOCK_ID#'),2)#
                                        	<cfset row_total_need = get_total_material.AMOUNT - Evaluate('AMBAR_STOCK_#STOCK_ID#')>
                                     	<cfelse>
                                        	#TlFormat(0,2)#
                                            <cfset row_total_need = get_total_material.AMOUNT>
                                    	</cfif>
                                    </cfif>
                                </td>
                                 <td title="<cf_get_lang_main no='3263.Gerçek Stok Minimum Stoktan Küçükse Minimum Sipariş Miktarı'>" style="text-align:right">
                                	<cfif row_total_need lt 0><cfset row_total_need = 0></cfif>
                                	<input type="text" name="row_total_need_#stock_id#" id="row_total_need_#stock_id#" value="#tlformat(row_total_need,2)#" class="box" style="width:60px;" onKeyup="return(FormatCurrency(this,event));" onBlur="hesapla(#stock_id#);">
                                    <input type="hidden" name="row_price_#stock_id#" id="row_price_#stock_id#" value="#tlformat(row_total_need*row_price)#" class="box" style="width:60px;" onKeyup="return(FormatCurrency(this,event));">
                                </td>
                                <!-- sil -->
                                <td style="text-align:center">
                                	 <input type="checkbox" name="conversion_product_#stock_id#" value="#stock_id#" id="_conversion_product_#currentrow#">
                                </td>
                                <!-- sil -->
                    		</tr>
                      	</cfoutput>
                    </cfif>
              	</cfloop>
            <cfelse>
                <tr> 
                    <td colspan="19" height="20"><cfif arama_yapilmali eq 1><cf_get_lang_main no='289.Filtre Ediniz'> !<cfelse><cf_get_lang_main no='72.Kayıt Yok'>!</cfif></td>
                </tr>
            </cfif>
            <tfoot>
            	<tr>
                    <td colspan="<cfif isdefined('attributes.is_lot_group')>6<cfelse>5</cfif>" style="text-align:left; height:10px">
                    	&nbsp;&nbsp;<strong><cf_get_lang_main no='268.Genel Toplam'></strong> &nbsp;&nbsp; <cfoutput>#get_total_material.recordcount#</cfoutput>    <cf_get_lang_main no='670.Adet'> <cf_get_lang_main no='245.Ürün'>
                    </td>
                    <td style="text-align:right">
                  		<strong>
                            <cfoutput query="get_money">
                                <cfif evaluate('t1_fiyat#money#') gt 0>
                                    #TlFormat(evaluate('t1_fiyat#money#'),2)#<br>
                                    <cfset _t1_fiyat = _t1_fiyat + (evaluate('t1_fiyat#money#')*RATE2)>
                                </cfif>      	            
                            </cfoutput>
                     	</strong>
                    </td>
                    <td style="text-align:left">
                    	<strong>
                            <cfoutput query="get_money">
                                <cfif evaluate('t1_fiyat#money#') gt 0>
                                    &nbsp;#money#<br>
                                </cfif>       	            
                            </cfoutput>
                      	</strong>
                    </td>
                    <td style="text-align:right"><strong><cfoutput>#TlFormat(_t1_fiyat,2)#</cfoutput></strong></td>
                    <td style="text-align:left"><strong><cfoutput>&nbsp;#session.ep.money#</cfoutput></strong></td>
                    <td colspan="<cfif attributes.list_type eq 3>3<cfelse>8</cfif>" style="text-align:right" >
                    	<cfif attributes.list_tur eq 1>
                        	<input type="button" value="<cfoutput>#getLang('correspondence','73')#</cfoutput>" name="satin_alma_talebi" id="satin_alma_talebi" onClick="kota_kontrol(3);" style="width:140px;">
                        <cfelse>
                        	<input type="button" value="<cfoutput>#getLang('main','1833')#</cfoutput>" name="ambar_fisi" id="ambar_fisi" onClick="kota_kontrol(2);" style="width:140px;">
                        </cfif>
                    	
                    </td>
                    <td title="<cf_get_lang_main no='3009.Hepsini Seç'>" style="text-align:center"><cfif (isdefined("attributes.is_form_submitted") eq 1)><input type="checkbox" name="all_conv_product" id="all_conv_product" onClick="javascript: all_select_control('all_conv_product','_conversion_product_',<cfoutput>#get_total_material.recordcount#</cfoutput>);"></cfif></td>
                </tr>
            </tfoot>
        </tbody>
	</cf_big_list>
</cfform>  
<form name="aktar_form" method="post">
    <input type="hidden" name="list_price" id="list_price" value="0">
    <input type="hidden" name="price_cat" id="price_cat" value="">
    <input type="hidden" name="CATALOG_ID" id="CATALOG_ID" value="">
    <input type="hidden" name="NUMBER_OF_INSTALLMENT" id="NUMBER_OF_INSTALLMENT" value="">
    <input type="hidden" name="convert_stocks_id" id="convert_stocks_id" value="">
	<input type="hidden" name="convert_amount_stocks_id" id="convert_amount_stocks_id" value="">
	<input type="hidden" name="convert_price" id="convert_price" value="">
	<input type="hidden" name="convert_price_other" id="convert_price_other" value="">
	<input type="hidden" name="convert_money" id="convert_money" value="">
</form>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function input_control()
	{
		return true;	
	}
	function chng_list_type()
	{
		if(document.getElementById('list_type').value==2)
		{
			document.getElementById('list_tur').value =1;
			document.getElementById('list_tur_td').style.display = 'none';
		}
		else
		{
			document.getElementById('list_tur_td').style.display = '';
		}
	}
	function kota_kontrol(type)
		/*
		___Type__
		1:Sevk İrsaliyesi
		2:Ambar Fişi
		3:Satın Alma Talebi
		*/
	{
		 var convert_list ="";
		 var convert_list_amount ="";
		 var convert_list_price ="";
		 var convert_list_price_other="";
		 var convert_list_money ="";
		 //
		 <cfif isdefined("attributes.is_form_submitted")>
			 <cfoutput query="get_total_material">
				 if(document.all.conversion_product_#stock_id#.checked && filterNum(document.getElementById('row_total_need_#stock_id#').value) > 0)
				 {
					convert_list += "#stock_id#,";
					convert_list_amount += filterNum(document.getElementById('row_total_need_#stock_id#').value)+',';
					convert_list_price_other += filterNum(document.getElementById('row_price_unit_#stock_id#').value,4)+',';
					convert_list_price += list_getat(document.getElementById('row_stock_money_#stock_id#').value,2,',')*filterNum(document.getElementById('row_price_unit_#stock_id#').value,4)+',';
					convert_list_money += list_getat(document.getElementById('row_stock_money_#stock_id#').value,1,',')+',';
				 }
			 </cfoutput>
		</cfif>
		document.getElementById('convert_stocks_id').value=convert_list;
		document.getElementById('convert_amount_stocks_id').value=convert_list_amount;
		document.getElementById('convert_price').value=convert_list_price;
		document.getElementById('convert_price_other').value=convert_list_price_other;
		document.getElementById('convert_money').value=convert_list_money;
		if(convert_list)//Ürün Seçili ise
		{
			 if(type==1)
			 {
				 aktar_form.action="<cfoutput>#request.self#</cfoutput>?fuseaction=stock.add_ship_dispatch&type=convert";
				 document.getElementById('sevk_irsaliyesi').disabled=true;
				 aktar_form.target='_blank';
			 }
			 if(type==2)
			 {
				 aktar_form.action="<cfoutput>#request.self#?fuseaction=stock.form_add_fis&type=convert<cfif isdefined('is_form_submitted') and isdefined('attributes.master_plan_id') and len(attributes.master_plan_id)>&ref_no=#get_master_plan_info.MASTER_PLAN_NUMBER#</cfif></cfoutput>";
				 document.getElementById('ambar_fisi').disabled=true;
				 aktar_form.target='_blank';
			 }
			 if(type==3)
			 {
				sor=confirm('<cf_get_lang_main no='3264.Seçilen Ürünler İçin Talep Oluşturulacaktır'>');
				if(sor==true)
				{
					aktar_form.action="<cfoutput>#request.self#?fuseaction=purchase.list_internaldemand&event=add&type=convert<cfif isdefined('is_form_submitted') and isdefined('attributes.master_plan_id') and len(attributes.master_plan_id)>&ref_no=#get_master_plan_info.MASTER_PLAN_NUMBER#</cfif></cfoutput>";
					document.getElementById('satin_alma_talebi').disabled=true;
					aktar_form.target='_blank';
				}
				else
				return false;
				
			 }
			 aktar_form.submit();
		 }
		 else
		 	alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='245.Ürün'>.");
	}
	function all_select_control(all_conv_product,_conversion_product_,number)
	{
		for(var cl_ind=1; cl_ind <= number; cl_ind++)
		{
			if(document.getElementById(all_conv_product).checked == true)
			{
				if(document.getElementById('_conversion_product_'+cl_ind) != undefined && document.getElementById('_conversion_product_'+cl_ind).checked == false)
					document.getElementById('_conversion_product_'+cl_ind).checked = true;
			}
			else
			{
				if(document.getElementById('_conversion_product_'+cl_ind) != undefined && document.getElementById('_conversion_product_'+cl_ind).checked == true)
					document.getElementById('_conversion_product_'+cl_ind).checked = false;
			}
		}
	}
	function hesapla(stock_id)
	{
		document.getElementById('row_price_'+stock_id+'').value = commaSplit(parseFloat(document.getElementById('row_price_unit_'+stock_id+'').value*filterNum(document.getElementById('row_total_need_'+stock_id+'').value)));
	}
</script>