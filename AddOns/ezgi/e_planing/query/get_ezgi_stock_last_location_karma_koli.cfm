﻿<cfquery name="get_department" datasource="#dsn#">
	SELECT DEPARTMENT_ID FROM DEPARTMENT WHERE BRANCH_ID = #ListGetAt(session.ep.user_location,2,'-')# AND IS_STORE = 3
</cfquery>
<cfset department_id_list = Valuelist(get_department.DEPARTMENT_ID)>
<cfparam name="attributes.department_id" default="#department_id_list#">
<cfquery name="GET_EZGI_STOCK_LAST_LOCATION_KARMA_KOLI" datasource="#DSN3#">
    SELECT        
        ISNULL(SUM(EZ_TBL_1.REAL_STOCK),0) AS REAL_STOCK, 
        ISNULL(SUM(EZ_TBL_1.PRODUCT_STOCK),0) AS PRODUCT_STOCK, 
        ISNULL(SUM(EZ_TBL_1.RESERVED_STOCK),0) AS RESERVED_STOCK, 
      	ISNULL(SUM(EZ_TBL_1.PURCHASE_PROD_STOCK),0) AS PURCHASE_PROD_STOCK, 
        ISNULL(SUM(EZ_TBL_1.RESERVED_PROD_STOCK),0) AS RESERVED_PROD_STOCK, 
     	ISNULL(SUM(EZ_TBL_1.RESERVE_SALE_ORDER_STOCK),0) AS RESERVE_SALE_ORDER_STOCK, 
        ISNULL(SUM(EZ_TBL_1.NOSALE_STOCK),0) AS NOSALE_STOCK, 
        ISNULL(SUM(EZ_TBL_1.BELONGTO_INSTITUTION_STOCK),0) AS BELONGTO_INSTITUTION_STOCK, 
        ISNULL(SUM(EZ_TBL_1.RESERVE_PURCHASE_ORDER_STOCK),0) AS RESERVE_PURCHASE_ORDER_STOCK, 
        ISNULL(SUM(EZ_TBL_1.PRODUCTION_ORDER_STOCK),0) AS PRODUCTION_ORDER_STOCK, 
        ISNULL(SUM(EZ_TBL_1.NOSALE_RESERVED_STOCK),0) AS NOSALE_RESERVED_STOCK, 
        ISNULL(SUM(EZ_TBL_1.SHIP_INTERNAL_STOCK),0) AS SHIP_INTERNAL_STOCK,
        <cfif isdefined('attributes.list_with_store')>
        ISNULL(SUM(EZ_TBL_1.REAL_STOCK),0) + ISNULL(SUM(EZ_TBL_1.RESERVED_STOCK),0) + ISNULL(SUM(EZ_TBL_1.TALEP),0) -  ISNULL(SUM(EZ_TBL_1.SHIP_INTERNAL_STOCK),0) AS SALEABLE_STOCK,
        <cfelse>
        ISNULL(SUM(EZ_TBL_1.REAL_STOCK),0) + ISNULL(SUM(EZ_TBL_1.RESERVED_STOCK),0) + ISNULL(SUM(EZ_TBL_1.TALEP),0) AS SALEABLE_STOCK,
        </cfif>
        ISNULL(SUM(EZ_TBL_1.TALEP),0) AS TALEP,
        S.STOCK_ID, 
        S.PRODUCT_NAME, 
        S.PRODUCT_CODE, 
        S.PRODUCT_ID,
        (SELECT TOP (1) UNIT_ID FROM PRODUCT_UNIT WHERE PRODUCT_ID = S.PRODUCT_ID AND PRODUCT_UNIT_STATUS = 1 AND IS_MAIN = 1) AS UNIT_ID,
        (SELECT MANUFACT_CODE FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = S.PRODUCT_ID) AS MANUFACT_CODE
	FROM            
    	(
        	SELECT        
            	KARMA_PRODUCT_ID, 
                ISNULL(MIN(TOPLAM),0) AS REAL_STOCK, 
                0 AS PRODUCT_STOCK, 
                0 AS RESERVED_STOCK, 
                0 AS PURCHASE_PROD_STOCK, 
                0 AS RESERVED_PROD_STOCK, 
               	0 AS RESERVE_SALE_ORDER_STOCK, 
                0 AS NOSALE_STOCK, 
                0 AS BELONGTO_INSTITUTION_STOCK, 
                0 AS RESERVE_PURCHASE_ORDER_STOCK, 
                0 AS PRODUCTION_ORDER_STOCK, 
              	0 AS NOSALE_RESERVED_STOCK,
                0 AS SHIP_INTERNAL_STOCK,
                0 AS TALEP
        	FROM            
            	(
                	SELECT        
                    	TBL.PRODUCT_ID, 
                        KP.KARMA_PRODUCT_ID, 
                        ISNULL(SUM(TBL.REAL_STOCK),0) AS TOPLAM
                  	FROM            
                    	(
                        	SELECT        
                                STOCK_IN - STOCK_OUT AS REAL_STOCK, 
                                PRODUCT_ID
                         	FROM            
                            	#dsn2_alias#.STOCKS_ROW
                        	WHERE        
                            	STORE IS NOT NULL AND 
                                STORE_LOCATION IS NOT NULL
								<cfif listLen(attributes.department_id)>
                                  AND   
                                  (
                                    <cfloop from="1" to="#listlen(attributes.department_id)#" index="k">
                                        STORE = #ListGetAt(ListGetAt(attributes.department_id,k),1,'-')# AND 
                                        STORE_LOCATION = #ListGetAt(ListGetAt(attributes.department_id,k),2,'-')#
                                        <cfif k neq listlen(attributes.department_id)>OR</cfif>
                                    </cfloop>
                                    )
                                </cfif>
                         	UNION ALL
                          	SELECT        
                                STOCK_IN - STOCK_OUT AS REAL_STOCK, 
                                PRODUCT_ID
                         	FROM            
                            	#dsn2_alias#.STOCKS_ROW AS SR
                          	WHERE        
                            	UPD_ID IS NULL AND 
                                STOCK_IN - STOCK_OUT > 0
								<cfif listLen(attributes.department_id)>
                                  AND   
                                  (
                                    <cfloop from="1" to="#listlen(attributes.department_id)#" index="k">
                                        STORE = #ListGetAt(ListGetAt(attributes.department_id,k),1,'-')# AND 
                                        STORE_LOCATION = #ListGetAt(ListGetAt(attributes.department_id,k),2,'-')#
                                        <cfif k neq listlen(attributes.department_id)>OR</cfif>
                                    </cfloop>
                                    )
                                </cfif>
                		) AS TBL RIGHT OUTER JOIN
                     	#dsn1_alias#.KARMA_PRODUCTS AS KP ON TBL.PRODUCT_ID = KP.PRODUCT_ID
              		GROUP BY 
                    	TBL.PRODUCT_ID, 
                        KP.KARMA_PRODUCT_ID
       			) AS TBL_1
        	GROUP BY 
            	KARMA_PRODUCT_ID
        	UNION ALL
         	SELECT        
            	KARMA_PRODUCT_ID, 
                0 AS REAL_STOCK, 
                ISNULL(MIN(TOPLAM),0) AS PRODUCT_STOCK, 
                0 AS RESERVED_STOCK, 
                0 AS PURCHASE_PROD_STOCK, 
                0 AS RESERVED_PROD_STOCK, 
              	0 AS RESERVE_SALE_ORDER_STOCK, 
                0 AS NOSALE_STOCK, 
                0 AS BELONGTO_INSTITUTION_STOCK, 
                0 AS RESERVE_PURCHASE_ORDER_STOCK, 
                0 AS PRODUCTION_ORDER_STOCK, 
              	0 AS NOSALE_RESERVED_STOCK,
                0 AS SHIP_INTERNAL_STOCK,
                0 AS TALEP
         	FROM            
            	(
                	SELECT        
                    	TBL_7.PRODUCT_ID, 
                        KP.KARMA_PRODUCT_ID, 
                        ISNULL(SUM(TBL_7.REAL_STOCK),0) AS TOPLAM
                	FROM            
                    	(
                        	SELECT        
                                SR.STOCK_IN - SR.STOCK_OUT AS REAL_STOCK, 
                                SR.PRODUCT_ID
                         	FROM            
                            	#dsn2_alias#.STOCKS_ROW AS SR INNER JOIN
                             	#dsn_alias#.STOCKS_LOCATION AS SL ON SR.STORE_LOCATION = SL.LOCATION_ID
                      		WHERE        
                            	SL.NO_SALE IS NULL 
                                <cfif listLen(attributes.department_id)>
                                  AND   
                                  (
                                    <cfloop from="1" to="#listlen(attributes.department_id)#" index="k">
                                        STORE = #ListGetAt(ListGetAt(attributes.department_id,k),1,'-')# AND 
                                        STORE_LOCATION = #ListGetAt(ListGetAt(attributes.department_id,k),2,'-')#
                                        <cfif k neq listlen(attributes.department_id)>OR</cfif>
                                    </cfloop>
                                    )
                                </cfif>
                         	UNION ALL
                          	SELECT        
                                - (1 * (SR.STOCK_IN - SR.STOCK_OUT)) AS REAL_STOCK, 
                                SR.PRODUCT_ID
                          	FROM            
                            	#dsn2_alias#.STOCKS_ROW AS SR INNER JOIN
                             	#dsn_alias#.STOCKS_LOCATION AS SL ON SR.STORE_LOCATION = SL.LOCATION_ID
                         	WHERE        
                            	ISNULL(SL.IS_SCRAP,0) = 1
                                <cfif listLen(attributes.department_id)>
                                  AND   
                                  (
                                    <cfloop from="1" to="#listlen(attributes.department_id)#" index="k">
                                        STORE = #ListGetAt(ListGetAt(attributes.department_id,k),1,'-')# AND 
                                        STORE_LOCATION = #ListGetAt(ListGetAt(attributes.department_id,k),2,'-')#
                                        <cfif k neq listlen(attributes.department_id)>OR</cfif>
                                    </cfloop>
                                    )
                                </cfif>
                    	) AS TBL_7 RIGHT OUTER JOIN
                     	#dsn1_alias#.KARMA_PRODUCTS AS KP ON TBL_7.PRODUCT_ID = KP.PRODUCT_ID
              		GROUP BY 
                    	TBL_7.PRODUCT_ID, 
                        KP.KARMA_PRODUCT_ID
         		) AS TBL_1_6
          	GROUP BY 
            	KARMA_PRODUCT_ID
          	UNION ALL
         	SELECT        
            	KARMA_PRODUCT_ID, 
                0 AS REAL_STOCK, 
                0 AS PRODUCT_STOCK, 
                0 AS RESERVED_STOCK, 
                0 AS PURCHASE_PROD_STOCK, 
                0 AS RESERVED_PROD_STOCK, 
                0 AS RESERVE_SALE_ORDER_STOCK, 
             	ISNULL(MIN(TOPLAM), 0) AS NOSALE_STOCK, 
                0 AS BELONGTO_INSTITUTION_STOCK, 
                0 AS RESERVE_PURCHASE_ORDER_STOCK, 
                0 AS PRODUCTION_ORDER_STOCK, 
              	0 AS NOSALE_RESERVED_STOCK,
                0 AS SHIP_INTERNAL_STOCK,
                0 AS TALEP
         	FROM            
            	(
                	SELECT        
                    	TBL_6.PRODUCT_ID, 
                        KP.KARMA_PRODUCT_ID, 
                        ISNULL(SUM(TBL_6.REAL_STOCK),0) AS TOPLAM
                	FROM            
                    	(
                        	SELECT        
                                SR.STOCK_IN - SR.STOCK_OUT AS REAL_STOCK, 
                                SR.PRODUCT_ID
                        	FROM            
                            	#dsn2_alias#.STOCKS_ROW AS SR INNER JOIN
                           		#dsn_alias#.STOCKS_LOCATION AS SL ON SR.STORE_LOCATION = SL.LOCATION_ID
                         	WHERE        
                            	SL.NO_SALE = 1
                                <cfif listLen(attributes.department_id)>
                                  AND   
                                  (
                                    <cfloop from="1" to="#listlen(attributes.department_id)#" index="k">
                                        STORE = #ListGetAt(ListGetAt(attributes.department_id,k),1,'-')# AND 
                                        STORE_LOCATION = #ListGetAt(ListGetAt(attributes.department_id,k),2,'-')#
                                        <cfif k neq listlen(attributes.department_id)>OR</cfif>
                                    </cfloop>
                                    )
                                </cfif>
                       	) AS TBL_6 RIGHT OUTER JOIN
                   		#dsn1_alias#.KARMA_PRODUCTS AS KP ON TBL_6.PRODUCT_ID = KP.PRODUCT_ID
               		GROUP BY 
                    	TBL_6.PRODUCT_ID, 
                        KP.KARMA_PRODUCT_ID
          		) AS TBL_1_5
          	GROUP BY 
            	KARMA_PRODUCT_ID
        	UNION ALL
       		SELECT        
            	KARMA_PRODUCT_ID, 
                0 AS REAL_STOCK, 
                0 AS PRODUCT_STOCK, 
                0 AS RESERVED_STOCK, 
                0 AS PURCHASE_PROD_STOCK, 
                0 AS RESERVED_PROD_STOCK, 
                0 AS RESERVE_SALE_ORDER_STOCK, 
             	0 AS NOSALE_STOCK, 
                ISNULL(MIN(TOPLAM), 0) AS BELONGTO_INSTITUTION_STOCK, 
                0 AS RESERVE_PURCHASE_ORDER_STOCK, 
                0 AS PRODUCTION_ORDER_STOCK, 
               	0 AS NOSALE_RESERVED_STOCK,
                0 AS SHIP_INTERNAL_STOCK,
                0 AS TALEP
       		FROM            
            	(
                	SELECT        
                    	TBL_5.PRODUCT_ID, 
                        KP.KARMA_PRODUCT_ID, 
                        ISNULL(SUM(TBL_5.REAL_STOCK),0) AS TOPLAM
                	FROM            
                    	(
                        	SELECT        
                                SR.STOCK_IN - SR.STOCK_OUT AS REAL_STOCK, 
                                SR.PRODUCT_ID
                        	FROM            
                            	#dsn2_alias#.STOCKS_ROW AS SR INNER JOIN
                           		#dsn_alias#.STOCKS_LOCATION AS SL ON SR.STORE_LOCATION = SL.LOCATION_ID
                          	WHERE        
                            	SL.BELONGTO_INSTITUTION = 1
                                <cfif listLen(attributes.department_id)>
                                  AND   
                                  (
                                    <cfloop from="1" to="#listlen(attributes.department_id)#" index="k">
                                        STORE = #ListGetAt(ListGetAt(attributes.department_id,k),1,'-')# AND 
                                        STORE_LOCATION = #ListGetAt(ListGetAt(attributes.department_id,k),2,'-')#
                                        <cfif k neq listlen(attributes.department_id)>OR</cfif>
                                    </cfloop>
                                    )
                                </cfif>
                     	) AS TBL_5 RIGHT OUTER JOIN
                    	#dsn1_alias#.KARMA_PRODUCTS AS KP ON TBL_5.PRODUCT_ID = KP.PRODUCT_ID
             		GROUP BY 
                    	TBL_5.PRODUCT_ID, 
                        KP.KARMA_PRODUCT_ID
           		) AS TBL_1_4
        	GROUP BY 
            	KARMA_PRODUCT_ID
         	UNION ALL
          	SELECT        
            	KARMA_PRODUCT_ID, 
                0 AS REAL_STOCK, 
                0 AS PRODUCT_STOCK, 
                ISNULL(MIN(TOPLAM),0) AS RESERVED_STOCK, 
                0 AS PURCHASE_PROD_STOCK, 
                0 AS RESERVED_PROD_STOCK, 
            	0 AS RESERVE_SALE_ORDER_STOCK, 
                0 AS NOSALE_STOCK, 
                0 AS BELONGTO_INSTITUTION_STOCK, 
                0 AS RESERVE_PURCHASE_ORDER_STOCK, 
                ISNULL(MIN(TOPLAM),0) AS PRODUCTION_ORDER_STOCK, 
              	0 AS NOSALE_RESERVED_STOCK,
                0 AS SHIP_INTERNAL_STOCK,
                0 AS TALEP
        	FROM            
            	(
                	SELECT        
                    	KP.KARMA_PRODUCT_ID, 
                        ISNULL(SUM(TBL_4.REAL_STOCK),0) AS TOPLAM, 
                   		KP.PRODUCT_ID
               		FROM            
                    	(
                        	SELECT        
                            	STOCK_ARTIR - STOCK_AZALT AS REAL_STOCK, 
                                PRODUCT_ID
                          	FROM            
                            	GET_PRODUCTION_RESERVED_LOCATION
                           	WHERE        
                            	STOCK_ARTIR - STOCK_AZALT > 0
                                <cfif listLen(attributes.department_id)>
                                  AND   
                                  (
                                    <cfloop from="1" to="#listlen(attributes.department_id)#" index="k">
                                        DEPARTMENT_ID = #ListGetAt(ListGetAt(attributes.department_id,k),1,'-')# AND 
                                        LOCATION_ID = #ListGetAt(ListGetAt(attributes.department_id,k),2,'-')#
                                        <cfif k neq listlen(attributes.department_id)>OR</cfif>
                                    </cfloop>
                                    )
                                </cfif>
                      	) AS TBL_4 RIGHT OUTER JOIN
                   		#dsn1_alias#.KARMA_PRODUCTS AS KP ON TBL_4.PRODUCT_ID = KP.PRODUCT_ID
               		GROUP BY 
                    	KP.KARMA_PRODUCT_ID, 
                     	KP.PRODUCT_ID
         		) AS TBL_1_3
        	GROUP BY 
            	KARMA_PRODUCT_ID
       		UNION ALL
         	SELECT        
            	KARMA_PRODUCT_ID, 
                0 AS REAL_STOCK, 
                0 AS PRODUCT_STOCK, 
                0 AS RESERVED_STOCK, 
                MIN(TOPLAM) AS PURCHASE_PROD_STOCK, 
                0 AS RESERVED_PROD_STOCK, 
             	0 AS RESERVE_SALE_ORDER_STOCK, 
                0 AS NOSALE_STOCK, 
                0 AS BELONGTO_INSTITUTION_STOCK, 
                0 AS RESERVE_PURCHASE_ORDER_STOCK, 
                0 AS PRODUCTION_ORDER_STOCK, 
              	0 AS NOSALE_RESERVED_STOCK,
                0 AS SHIP_INTERNAL_STOCK,
                0 AS TALEP
          	FROM            
            	(
                	SELECT        
                    	KP.KARMA_PRODUCT_ID, 
                        ISNULL(SUM(TBL_3.REAL_STOCK),0) AS TOPLAM, 
                		KP.PRODUCT_ID
               		FROM            
                    	(
                        	SELECT        
                            	STOCK_ARTIR AS REAL_STOCK, 
                                PRODUCT_ID
                       		FROM            
                            	GET_PRODUCTION_RESERVED_LOCATION AS GET_PRODUCTION_RESERVED_LOCATION_2
                       		WHERE        
                            	STOCK_ARTIR > 0
                                <cfif listLen(attributes.department_id)>
                                  AND   
                                  (
                                    <cfloop from="1" to="#listlen(attributes.department_id)#" index="k">
                                        DEPARTMENT_ID = #ListGetAt(ListGetAt(attributes.department_id,k),1,'-')# AND 
                                        LOCATION_ID = #ListGetAt(ListGetAt(attributes.department_id,k),2,'-')#
                                        <cfif k neq listlen(attributes.department_id)>OR</cfif>
                                    </cfloop>
                                    )
                                </cfif>
                     	) AS TBL_3 RIGHT OUTER JOIN
                     	#dsn1_alias#.KARMA_PRODUCTS AS KP ON TBL_3.PRODUCT_ID = KP.PRODUCT_ID
                 	GROUP BY 
                    	KP.KARMA_PRODUCT_ID, 
                        KP.PRODUCT_ID
        		) AS TBL_1_2
        	GROUP BY 
            	KARMA_PRODUCT_ID
         	UNION ALL
           	SELECT        
            	KARMA_PRODUCT_ID, 
                0 AS REAL_STOCK, 
                0 AS PRODUCT_STOCK, 
                0 AS RESERVED_STOCK, 
                0 AS PURCHASE_PROD_STOCK, 
                MIN(TOPLAM) AS RESERVED_PROD_STOCK, 
             	0 AS RESERVE_SALE_ORDER_STOCK, 
                0 AS NOSALE_STOCK, 
                0 AS BELONGTO_INSTITUTION_STOCK, 
                0 AS RESERVE_PURCHASE_ORDER_STOCK, 
                0 AS PRODUCTION_ORDER_STOCK, 
            	0 AS NOSALE_RESERVED_STOCK,
                0 AS SHIP_INTERNAL_STOCK,
                0 AS TALEP
      		FROM            
            	(
                	SELECT        
                    	KP.KARMA_PRODUCT_ID, 
                        ISNULL(SUM(TBL_2.REAL_STOCK), 0) AS TOPLAM, 
                      	KP.PRODUCT_ID
                 	FROM            
                    	(
                        	SELECT        
                            	STOCK_AZALT AS REAL_STOCK, 
                                PRODUCT_ID
                         	FROM            
                            	GET_PRODUCTION_RESERVED_LOCATION AS GET_PRODUCTION_RESERVED_LOCATION_1
                         	WHERE        
                            	STOCK_AZALT > 0
                                <cfif listLen(attributes.department_id)>
                                  AND   
                                  (
                                    <cfloop from="1" to="#listlen(attributes.department_id)#" index="k">
                                        DEPARTMENT_ID = #ListGetAt(ListGetAt(attributes.department_id,k),1,'-')# AND 
                                        LOCATION_ID = #ListGetAt(ListGetAt(attributes.department_id,k),2,'-')#
                                        <cfif k neq listlen(attributes.department_id)>OR</cfif>
                                    </cfloop>
                                    )
                                </cfif>
                      	) AS TBL_2 RIGHT OUTER JOIN
               			#dsn1_alias#.KARMA_PRODUCTS AS KP ON TBL_2.PRODUCT_ID = KP.PRODUCT_ID
              		GROUP BY KP.
                    	KARMA_PRODUCT_ID, 
                        KP.PRODUCT_ID
             	) AS TBL_1_1
         	GROUP BY 
            	KARMA_PRODUCT_ID
         	UNION ALL
         	SELECT        
            	ORR.PRODUCT_ID AS KARMA_PRODUCT_ID, 
                0 AS REAL_STOCK, 
                0 AS PRODUCT_STOCK, 
                0 AS RESERVED_STOCK, 
             	0 AS PURCHASE_PROD_STOCK, 
                0 AS RESERVED_PROD_STOCK, 
                0 AS RESERVE_SALE_ORDER_STOCK, 
                0 AS NOSALE_STOCK, 
             	0 AS BELONGTO_INSTITUTION_STOCK, 
                ORR.RESERVE_STOCK_IN - ORR.STOCK_IN AS RESERVE_PURCHASE_ORDER_STOCK, 
                0 AS PRODUCTION_ORDER_STOCK, 
              	0 AS NOSALE_RESERVED_STOCK,
                0 AS SHIP_INTERNAL_STOCK,
                0 AS TALEP
        	FROM            
            	GET_ORDER_ROW_RESERVED AS ORR INNER JOIN
              	ORDERS AS ORDS ON ORR.ORDER_ID = ORDS.ORDER_ID
     		WHERE        
                ORDS.RESERVED = 1 AND 
                ORDS.ORDER_STATUS = 1 AND 
                (ORR.RESERVE_STOCK_IN - ORR.STOCK_IN > 0 OR ORR.RESERVE_STOCK_OUT - ORR.STOCK_OUT > 0)
                <cfif listLen(attributes.department_id)>
              		AND   
                 	(
                   		<cfloop from="1" to="#listlen(attributes.department_id)#" index="k">
                         	ORDS.DELIVER_DEPT_ID  = #ListGetAt(ListGetAt(attributes.department_id,k),1,'-')# AND 
                         	ORDS.LOCATION_ID = #ListGetAt(ListGetAt(attributes.department_id,k),2,'-')#
                        	<cfif k neq listlen(attributes.department_id)>OR</cfif>
                     	</cfloop>
                 	)
              	</cfif>
       		UNION ALL
            SELECT
            	KARMA_PRODUCT_ID, 
                0 AS REAL_STOCK, 
                0 AS PRODUCT_STOCK, 
                ISNULL(MIN(RESERVE_SALE_ORDER_STOCK)*-1, 0) AS RESERVED_STOCK, 
             	0 AS PURCHASE_PROD_STOCK, 
                0 AS RESERVED_PROD_STOCK, 
                ISNULL(MIN(RESERVE_SALE_ORDER_STOCK), 0) AS RESERVE_SALE_ORDER_STOCK,
                0 AS NOSALE_STOCK, 
             	0 AS BELONGTO_INSTITUTION_STOCK, 
                0 AS RESERVE_PURCHASE_ORDER_STOCK, 
                0 AS PRODUCTION_ORDER_STOCK, 
              	0 AS NOSALE_RESERVED_STOCK,
                0 AS SHIP_INTERNAL_STOCK,
                0 AS TALEP
            FROM
            	(
            		SELECT        
                    	K.KARMA_PRODUCT_ID, 
                        K.STOCK_ID, 
                        ISNULL(TBL.RESERVE_SALE_ORDER_STOCK / K.PRODUCT_AMOUNT,0) AS RESERVE_SALE_ORDER_STOCK
                 	FROM            
                    	(
                        	SELECT        
                            	STOCK_ID, 
                                SUM(RESERVE_SALE_ORDER_STOCK) AS RESERVE_SALE_ORDER_STOCK
                          	FROM            
                            	EZGI_SALE_ORDER_RESERVED_LOCATION_DEMONTE
                          	WHERE   
                            	1=1
                            	<cfif listLen(attributes.department_id)>
                                    AND   
                                    (
                                        <cfloop from="1" to="#listlen(attributes.department_id)#" index="k">
                                            DELIVER_DEPT_ID  = #ListGetAt(ListGetAt(attributes.department_id,k),1,'-')# AND 
                                            LOCATION_ID = #ListGetAt(ListGetAt(attributes.department_id,k),2,'-')#
                                            <cfif k neq listlen(attributes.department_id)>OR</cfif>
                                        </cfloop>
                                    )
                                </cfif>
                         	GROUP BY 
                            	STOCK_ID
                      	) AS TBL RIGHT OUTER JOIN
                		#dsn1_alias#.KARMA_PRODUCTS AS K ON TBL.STOCK_ID = K.STOCK_ID
            	) AS TBL1
          	GROUP BY 
            	KARMA_PRODUCT_ID
          	UNION ALL
        	SELECT        
            	ORR.PRODUCT_ID AS KARMA_PRODUCT_ID, 
                0 AS REAL_STOCK, 0 AS PRODUCT_STOCK, 
                ORR.RESERVE_STOCK_IN - ORR.STOCK_IN AS RESERVED_STOCK, 
                0 AS PURCHASE_PROD_STOCK, 
             	0 AS RESERVED_PROD_STOCK, 
                0 AS RESERVE_SALE_ORDER_STOCK, 
                0 AS NOSALE_STOCK, 0 AS BELONGTO_INSTITUTION_STOCK, 
                0 AS RESERVE_PURCHASE_ORDER_STOCK, 
             	0 AS PRODUCTION_ORDER_STOCK, 
                0 AS NOSALE_RESERVED_STOCK,
                0 AS SHIP_INTERNAL_STOCK,
                0 AS TALEP
         	FROM            
            	#dsn_alias#.STOCKS_LOCATION AS SL INNER JOIN
            	ORDERS AS ORDS ON SL.DEPARTMENT_ID = ORDS.DELIVER_DEPT_ID AND SL.LOCATION_ID = ORDS.LOCATION_ID INNER JOIN
            	GET_ORDER_ROW_RESERVED AS ORR ON ORDS.ORDER_ID = ORR.ORDER_ID
       		WHERE  
            	ORDS.RESERVED = 1 AND 
                ORDS.ORDER_STATUS = 1 AND 
                SL.NO_SALE = 0 AND 
                ORDS.PURCHASE_SALES = 0 AND 
                ORDS.ORDER_ZONE = 0 AND 
             	ORR.RESERVE_STOCK_IN - ORR.STOCK_IN > 0
                <cfif listLen(attributes.department_id)>
              		AND   
                 	(
                   		<cfloop from="1" to="#listlen(attributes.department_id)#" index="k">
                         	ORDS.DELIVER_DEPT_ID  = #ListGetAt(ListGetAt(attributes.department_id,k),1,'-')# AND 
                         	ORDS.LOCATION_ID = #ListGetAt(ListGetAt(attributes.department_id,k),2,'-')#
                        	<cfif k neq listlen(attributes.department_id)>OR</cfif>
                     	</cfloop>
                 	)
              	</cfif>
       		UNION ALL
         	SELECT        
            	ORR.PRODUCT_ID AS KARMA_PRODUCT_ID, 
                0 AS REAL_STOCK, 
                0 AS PRODUCT_STOCK, 
                0 AS RESERVED_STOCK, 
                0 AS PURCHASE_PROD_STOCK, 
                0 AS RESERVED_PROD_STOCK, 
            	0 AS RESERVE_SALE_ORDER_STOCK, 
                0 AS NOSALE_STOCK, 
                0 AS BELONGTO_INSTITUTION_STOCK, 
                0 AS RESERVE_PURCHASE_ORDER_STOCK, 
                0 AS PRODUCTION_ORDER_STOCK, 
              	ORR.RESERVE_STOCK_IN - ORR.STOCK_IN AS NOSALE_RESERVED_STOCK,
                0 AS SHIP_INTERNAL_STOCK,
                0 AS TALEP
          	FROM            
            	#dsn_alias#.STOCKS_LOCATION AS SL INNER JOIN
              	ORDERS AS ORDS ON SL.DEPARTMENT_ID = ORDS.DELIVER_DEPT_ID AND SL.LOCATION_ID = ORDS.LOCATION_ID INNER JOIN
              	GET_ORDER_ROW_RESERVED AS ORR ON ORDS.ORDER_ID = ORR.ORDER_ID
  			WHERE        
            	ORDS.RESERVED = 1 AND 
                ORDS.ORDER_STATUS = 1 AND 
                SL.NO_SALE = 1 AND 
        		ORDS.PURCHASE_SALES = 0 AND 
                ORDS.ORDER_ZONE = 0 AND 
                ORR.RESERVE_STOCK_IN - ORR.STOCK_IN > 0
                <cfif listLen(attributes.department_id)>
              		AND   
                 	(
                   		<cfloop from="1" to="#listlen(attributes.department_id)#" index="k">
                         	ORDS.DELIVER_DEPT_ID  = #ListGetAt(ListGetAt(attributes.department_id,k),1,'-')# AND 
                         	ORDS.LOCATION_ID = #ListGetAt(ListGetAt(attributes.department_id,k),2,'-')#
                        	<cfif k neq listlen(attributes.department_id)>OR</cfif>
                     	</cfloop>
                 	)
              	</cfif>
          	UNION ALL
          	SELECT  
             	SIR.PRODUCT_ID AS KARMA_PRODUCT_ID, 
                0 AS REAL_STOCK, 
                0 AS PRODUCT_STOCK, 
                0 AS RESERVED_STOCK, 
                0 AS PURCHASE_PROD_STOCK, 
                0 AS RESERVED_PROD_STOCK, 
            	0 AS RESERVE_SALE_ORDER_STOCK, 
                0 AS NOSALE_STOCK, 
                0 AS BELONGTO_INSTITUTION_STOCK, 
                0 AS RESERVE_PURCHASE_ORDER_STOCK, 
                0 AS PRODUCTION_ORDER_STOCK, 
              	0 AS NOSALE_RESERVED_STOCK,   
             	SIR.AMOUNT AS SHIP_INTERNAL_STOCK,


                0 AS TALEP
			FROM            
            	#dsn2_alias#.SHIP_INTERNAL AS SI INNER JOIN
             	#dsn2_alias#.SHIP_INTERNAL_ROW AS SIR ON SI.DISPATCH_SHIP_ID = SIR.DISPATCH_SHIP_ID INNER JOIN
               	STOCKS AS S ON SIR.STOCK_ID = S.STOCK_ID LEFT OUTER JOIN
             	#dsn2_alias#.SHIP AS SH ON SI.DISPATCH_SHIP_ID = SH.DISPATCH_SHIP_ID
			WHERE        
             	SH.SHIP_ID IS NULL AND
                ISNULL(S.IS_KARMA,0) = 1
				<cfif listLen(attributes.department_id)>
              		AND   
                 	(
                   		<cfloop from="1" to="#listlen(attributes.department_id)#" index="k">
                         	SI.DEPARTMENT_OUT  = #ListGetAt(ListGetAt(attributes.department_id,k),1,'-')# AND 
                         	SI.LOCATION_OUT = #ListGetAt(ListGetAt(attributes.department_id,k),2,'-')#
                        	<cfif k neq listlen(attributes.department_id)>OR</cfif>
                     	</cfloop>
                 	)
              	</cfif>
        	UNION ALL
            SELECT 
            	TBL1_7.KARMA_PRODUCT_ID, 
                0 AS REAL_STOCK, 
                0 AS PRODUCT_STOCK, 
                0 AS RESERVED_STOCK, 
                0 AS PURCHASE_PROD_STOCK, 
                0 AS RESERVED_PROD_STOCK, 
            	0 AS RESERVE_SALE_ORDER_STOCK, 
                0 AS NOSALE_STOCK, 
                0 AS BELONGTO_INSTITUTION_STOCK, 
                0 AS RESERVE_PURCHASE_ORDER_STOCK, 
                0 AS PRODUCTION_ORDER_STOCK, 
              	0 AS NOSALE_RESERVED_STOCK,   
             	0 AS SHIP_INTERNAL_STOCK,  
             	TBL1_7.TALEP
        	FROM         
             	(
                	SELECT        
                        ISNULL(SUM(E.QUANTITY),0) - ISNULL(SUM(EPR.QUANTITY),0) AS TALEP, 
                        S.PRODUCT_ID AS KARMA_PRODUCT_ID
                    FROM            
                        STOCKS AS S INNER JOIN
                        EZGI_PRODUCTION_DEMAND_ROW AS E ON S.STOCK_ID = E.STOCK_ID INNER JOIN
                        EZGI_PRODUCTION_DEMAND AS EPD ON E.EZGI_DEMAND_ID = EPD.EZGI_DEMAND_ID LEFT OUTER JOIN
                        EZGI_IFLOW_PRODUCTION_ORDERS AS EPR ON E.EZGI_DEMAND_ROW_ID = EPR.ACTION_ID
                    WHERE
                        ISNULL(S.IS_KARMA,0) = 1
                        <cfif listLen(attributes.department_id)>
                            AND   
                            (
                                <cfloop from="1" to="#listlen(attributes.department_id)#" index="k">
                                    EPD.DEMAND_DEPARTMENT_ID  = #ListGetAt(ListGetAt(attributes.department_id,k),1,'-')#
                                    <cfif k neq listlen(attributes.department_id)>OR</cfif>
                                </cfloop>
                            )
                        </cfif>
                	GROUP BY 
                     	S.PRODUCT_ID
          		) AS TBL1_7
      	) AS EZ_TBL_1 RIGHT OUTER JOIN
   		STOCKS AS S ON EZ_TBL_1.KARMA_PRODUCT_ID = S.PRODUCT_ID
	WHERE        
    	ISNULL(S.IS_KARMA,0) = 1 AND
        S.PRODUCT_STATUS=1
        <cfif isdefined('attributes.product_code') and Len(attributes.product_code) and Len(attributes.product_cat)>
        	AND S.PRODUCT_CODE LIKE '#attributes.product_code#.%'
     	</cfif>
        <cfif len(attributes.keyword)>
          	AND (
					<cfif listlen(attributes.keyword,"+") gt 1>
						(
							<cfloop from="1" to="#listlen(attributes.keyword,'+')#" index="pro_index">
								S.PRODUCT_NAME LIKE 
								<cfif pro_index eq 1>
                                	<cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(attributes.keyword,pro_index,"+")#%">
                                <cfelse>
	                                <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ListGetAt(attributes.keyword,pro_index,"+")#%">
                                </cfif>
								<cfif pro_index neq listlen(attributes.keyword,'+')>AND</cfif>
							</cfloop>
						)		
					<cfelse>
						S.PRODUCT_NAME LIKE 
								<cfif len(attributes.keyword) eq 1>
                                	<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
                                <cfelse>
	                                <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                                </cfif> OR
						S.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#replace(attributes.keyword,'+','')#%"> OR
						S.BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
					</cfif>
           		)
     	</cfif>
	GROUP BY 
    	S.STOCK_ID, 
        S.PRODUCT_NAME, 
        S.PRODUCT_CODE, 
        S.PRODUCT_ID
 		
 	UNION ALL
    SELECT
    	ISNULL(SUM(REAL_STOCK),0) AS REAL_STOCK, 
        ISNULL(SUM(PRODUCT_STOCK),0) AS PRODUCT_STOCK, 
        ISNULL(SUM(RESERVED_STOCK),0) AS RESERVED_STOCK, 
      	ISNULL(SUM(PURCHASE_PROD_STOCK),0) AS PURCHASE_PROD_STOCK, 
        ISNULL(SUM(RESERVED_PROD_STOCK),0) AS RESERVED_PROD_STOCK, 
     	ISNULL(SUM(RESERVE_SALE_ORDER_STOCK),0) AS RESERVE_SALE_ORDER_STOCK, 
        ISNULL(SUM(NOSALE_STOCK),0) AS NOSALE_STOCK, 
        ISNULL(SUM(BELONGTO_INSTITUTION_STOCK),0) AS BELONGTO_INSTITUTION_STOCK, 

        ISNULL(SUM(RESERVE_PURCHASE_ORDER_STOCK),0) AS RESERVE_PURCHASE_ORDER_STOCK, 
        ISNULL(SUM(PRODUCTION_ORDER_STOCK),0) AS PRODUCTION_ORDER_STOCK, 
        ISNULL(SUM(NOSALE_RESERVED_STOCK),0) AS NOSALE_RESERVED_STOCK, 
        ISNULL(SUM(SHIP_INTERNAL_STOCK),0) AS SHIP_INTERNAL_STOCK,
        ISNULL(SUM(REAL_STOCK),0) + ISNULL(SUM(RESERVED_STOCK),0) + ISNULL(SUM(TALEP),0) AS SALEABLE_STOCK,
        ISNULL(SUM(TALEP),0) AS TALEP,
        STOCK_ID, 
        PRODUCT_NAME, 
        PRODUCT_CODE, 
        PRODUCT_ID,
        (SELECT TOP (1) UNIT_ID FROM PRODUCT_UNIT WHERE PRODUCT_ID = EZ_TBL_2.PRODUCT_ID AND PRODUCT_UNIT_STATUS = 1 AND IS_MAIN = 1) AS UNIT_ID,
        (SELECT MANUFACT_CODE FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = EZ_TBL_2.PRODUCT_ID) AS MANUFACT_CODE
  	FROM
    	(	
        SELECT        
            GS.REAL_STOCK, 
            GS.PRODUCT_STOCK, 
            GS.RESERVED_STOCK, 
            GS.PURCHASE_PROD_STOCK, 
            GS.RESERVED_PROD_STOCK, 
            GS.RESERVE_SALE_ORDER_STOCK, 
            GS.NOSALE_STOCK, 
            GS.BELONGTO_INSTITUTION_STOCK, 
            GS.RESERVE_PURCHASE_ORDER_STOCK, 
            GS.PRODUCTION_ORDER_STOCK, 
            GS.NOSALE_RESERVED_STOCK, 
            0 AS SHIP_INTERNAL_STOCK,
            GS.SALEABLE_STOCK,
            0 AS TALEP,
            GS.STOCK_ID, 
            S.PRODUCT_NAME, 
            S.PRODUCT_CODE, 
            S.PRODUCT_ID
        FROM            
            #dsn2_alias#.GET_STOCK_LAST_LOCATION AS GS INNER JOIN
            STOCKS AS S ON GS.STOCK_ID = S.STOCK_ID
        WHERE     
        	<!---S.IS_PRODUCTION = 1 AND  --->  
            ISNULL(S.IS_KARMA,0) = 0 AND 
            GS.PRODUCT_ID NOT IN
                                (
                                    SELECT        
                                        KP.PRODUCT_ID
                                    FROM            
                                        #dsn1_alias#.KARMA_PRODUCTS AS KP INNER JOIN
                                        #dsn1_alias#.PRODUCT AS P ON KP.KARMA_PRODUCT_ID = P.PRODUCT_ID
                                ) AND
        	S.PRODUCT_STATUS=1
            <cfif isdefined('attributes.product_code') and Len(attributes.product_code) and Len(attributes.product_cat)>
                AND S.PRODUCT_CODE LIKE '#attributes.product_code#.%'
            </cfif>
            
            <cfif len(attributes.keyword)>
                AND (
                        <cfif listlen(attributes.keyword,"+") gt 1>
                            (
                                <cfloop from="1" to="#listlen(attributes.keyword,'+')#" index="pro_index">
                                    S.PRODUCT_NAME LIKE 
                                    <cfif pro_index eq 1>
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(attributes.keyword,pro_index,"+")#%">
                                    <cfelse>
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ListGetAt(attributes.keyword,pro_index,"+")#%">
                                    </cfif>
                                    <cfif pro_index neq listlen(attributes.keyword,'+')>AND</cfif>
                                </cfloop>
                            )		
                        <cfelse>
                            S.PRODUCT_NAME LIKE 
                                    <cfif len(attributes.keyword) eq 1>
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
                                    <cfelse>
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                                    </cfif> OR
                            S.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#replace(attributes.keyword,'+','')#%"> OR
                            S.BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
                        </cfif>
                    )
            </cfif>
            <cfif listLen(attributes.department_id)>
            	AND   
              	(
                	<cfloop from="1" to="#listlen(attributes.department_id)#" index="k">
                     	GS.DEPARTMENT_ID  = #ListGetAt(ListGetAt(attributes.department_id,k),1,'-')# AND 
                      	GS.LOCATION_ID = #ListGetAt(ListGetAt(attributes.department_id,k),2,'-')#
                     	<cfif k neq listlen(attributes.department_id)>OR</cfif>
                	</cfloop>
              	)
         	</cfif>
        UNION ALL
        SELECT  
            0 AS REAL_STOCK, 
            0 AS PRODUCT_STOCK, 
            0 AS RESERVED_STOCK, 
            0 AS PURCHASE_PROD_STOCK, 
            0 AS RESERVED_PROD_STOCK, 
            0 AS RESERVE_SALE_ORDER_STOCK, 
            0 AS NOSALE_STOCK, 
            0 AS BELONGTO_INSTITUTION_STOCK, 
            0 AS RESERVE_PURCHASE_ORDER_STOCK, 
            0 AS PRODUCTION_ORDER_STOCK, 
            0 AS NOSALE_RESERVED_STOCK,   
            SIR.AMOUNT AS SHIP_INTERNAL_STOCK,
            0 AS SALEABLE_STOCK,
            0 AS TALEP,
            SIR.STOCK_ID,
            S.PRODUCT_NAME, 
            S.PRODUCT_CODE, 
            S.PRODUCT_ID
        FROM            
            #dsn2_alias#.SHIP_INTERNAL AS SI INNER JOIN
            #dsn2_alias#.SHIP_INTERNAL_ROW AS SIR ON SI.DISPATCH_SHIP_ID = SIR.DISPATCH_SHIP_ID INNER JOIN

            STOCKS AS S ON SIR.STOCK_ID = S.STOCK_ID LEFT OUTER JOIN
            #dsn2_alias#.SHIP AS SH ON SI.DISPATCH_SHIP_ID = SH.DISPATCH_SHIP_ID
        WHERE
        	<!---S.IS_PRODUCTION = 1 AND  --->       
            ISNULL(S.IS_KARMA,0) = 0 AND 
            S.PRODUCT_ID NOT IN
                                (
                                    SELECT        
                                        KP.PRODUCT_ID
                                    FROM            
                                        #dsn1_alias#.KARMA_PRODUCTS AS KP INNER JOIN
                                        #dsn1_alias#.PRODUCT AS P ON KP.KARMA_PRODUCT_ID = P.PRODUCT_ID
                                ) AND
        	S.PRODUCT_STATUS=1
            <cfif isdefined('attributes.product_code') and Len(attributes.product_code) and Len(attributes.product_cat)>
                AND S.PRODUCT_CODE LIKE '#attributes.product_code#.%'
            </cfif>
            <cfif len(attributes.keyword)>
                AND (
                        <cfif listlen(attributes.keyword,"+") gt 1>
                            (
                                <cfloop from="1" to="#listlen(attributes.keyword,'+')#" index="pro_index">
                                    S.PRODUCT_NAME LIKE 
                                    <cfif pro_index eq 1>
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(attributes.keyword,pro_index,"+")#%">
                                    <cfelse>
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ListGetAt(attributes.keyword,pro_index,"+")#%">
                                    </cfif>
                                    <cfif pro_index neq listlen(attributes.keyword,'+')>AND</cfif>
                                </cfloop>
                            )		
                        <cfelse>
                            S.PRODUCT_NAME LIKE 
                                    <cfif len(attributes.keyword) eq 1>
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
                                    <cfelse>
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                                    </cfif> OR
                            S.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#replace(attributes.keyword,'+','')#%"> OR
                            S.BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
                        </cfif>
                    )
            </cfif> 
            <cfif listLen(attributes.department_id)>
            	AND   
              	(
                	<cfloop from="1" to="#listlen(attributes.department_id)#" index="k">
                     	SI.DEPARTMENT_OUT  = #ListGetAt(ListGetAt(attributes.department_id,k),1,'-')# AND 
                      	SI.LOCATION_OUT = #ListGetAt(ListGetAt(attributes.department_id,k),2,'-')#
                     	<cfif k neq listlen(attributes.department_id)>OR</cfif>
                	</cfloop>
              	)
         	</cfif>
       	UNION ALL
      	SELECT 
          	0 AS REAL_STOCK, 
          	0 AS PRODUCT_STOCK, 
         	0 AS RESERVED_STOCK, 
           	0 AS PURCHASE_PROD_STOCK, 
          	0 AS RESERVED_PROD_STOCK, 
          	0 AS RESERVE_SALE_ORDER_STOCK, 
          	0 AS NOSALE_STOCK, 
           	0 AS BELONGTO_INSTITUTION_STOCK, 
          	0 AS RESERVE_PURCHASE_ORDER_STOCK, 
          	0 AS PRODUCTION_ORDER_STOCK, 
          	0 AS NOSALE_RESERVED_STOCK,   
          	0 AS SHIP_INTERNAL_STOCK, 
            0 AS SALEABLE_STOCK, 
          	TBL1_8.TALEP,
            S.STOCK_ID,
            S.PRODUCT_NAME, 
            S.PRODUCT_CODE, 
            S.PRODUCT_ID
     	FROM         
         	(
          		SELECT        
                	ISNULL(SUM(E.QUANTITY),0) - ISNULL(SUM(EPR.QUANTITY),0) AS TALEP, 
                    E.STOCK_ID
				FROM            
                	STOCKS AS S INNER JOIN
                  	EZGI_PRODUCTION_DEMAND_ROW AS E ON S.STOCK_ID = E.STOCK_ID INNER JOIN
                  	EZGI_PRODUCTION_DEMAND AS EPD ON E.EZGI_DEMAND_ID = EPD.EZGI_DEMAND_ID LEFT OUTER JOIN
                  	EZGI_IFLOW_PRODUCTION_ORDERS AS EPR ON E.EZGI_DEMAND_ROW_ID = EPR.ACTION_ID
              	WHERE
                	1=1 
                  	<cfif listLen(attributes.department_id)>
                        AND   
                        (
                            <cfloop from="1" to="#listlen(attributes.department_id)#" index="k">
                                EPD.DEMAND_DEPARTMENT_ID = #ListGetAt(ListGetAt(attributes.department_id,k),1,'-')#
                                <cfif k neq listlen(attributes.department_id)>OR</cfif>
                            </cfloop>
                        )
                    </cfif>
             	GROUP BY 
                	E.STOCK_ID
         	) AS TBL1_8 INNER JOIN
     		STOCKS AS S ON TBL1_8.STOCK_ID = S.STOCK_ID
    	 WHERE    
         	<!---S.IS_PRODUCTION = 1 AND --->   
            ISNULL(S.IS_KARMA,0) = 0 AND 
            S.PRODUCT_ID NOT IN
                                (
                                    SELECT        
                                        KP.PRODUCT_ID
                                    FROM            
                                        #dsn1_alias#.KARMA_PRODUCTS AS KP INNER JOIN
                                        #dsn1_alias#.PRODUCT AS P ON KP.KARMA_PRODUCT_ID = P.PRODUCT_ID
                                )  AND
        	S.PRODUCT_STATUS=1
		   <cfif isdefined('attributes.product_code') and Len(attributes.product_code) and Len(attributes.product_cat)>
                AND S.PRODUCT_CODE LIKE '#attributes.product_code#.%'
            </cfif>
            <cfif len(attributes.keyword)>
                AND (
                        <cfif listlen(attributes.keyword,"+") gt 1>
                            (
                                <cfloop from="1" to="#listlen(attributes.keyword,'+')#" index="pro_index">
                                    S.PRODUCT_NAME LIKE 
                                    <cfif pro_index eq 1>
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(attributes.keyword,pro_index,"+")#%">
                                    <cfelse>
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ListGetAt(attributes.keyword,pro_index,"+")#%">
                                    </cfif>
                                    <cfif pro_index neq listlen(attributes.keyword,'+')>AND</cfif>
                                </cfloop>
                            )		
                        <cfelse>
                            S.PRODUCT_NAME LIKE 
                                    <cfif len(attributes.keyword) eq 1>
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
                                    <cfelse>
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                                    </cfif> OR
                            S.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#replace(attributes.keyword,'+','')#%"> OR
                            S.BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
                        </cfif>
                    )
            </cfif> 
        ) AS EZ_TBL_2  
  	GROUP BY
    	STOCK_ID, 
        PRODUCT_NAME, 
        PRODUCT_CODE, 
        PRODUCT_ID 
  		 
   	ORDER BY
    	<cfif isdefined('attributes.sort_type') and attributes.sort_type eq 1>
        	PRODUCT_NAME
        <cfelseif isdefined('attributes.sort_type') and attributes.sort_type eq 2>
        	PRODUCT_CODE
        <cfelse>
            MANUFACT_CODE DESC,
            PRODUCT_NAME
        </cfif>
</cfquery>
<!---<cfdump var="#GET_EZGI_STOCK_LAST_LOCATION_KARMA_KOLI#">--->