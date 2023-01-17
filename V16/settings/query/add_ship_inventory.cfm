<!---
        <cfquery name="upd_inv" datasource="#kaynak_dsn2#">
            UPDATE
            	#dsn3_alias#.INVENTORY
            SET 
            	AMOUNT = ISNULL((
                SELECT 
					TOP 1 (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
				FROM 
					#dsn3_alias#.PRODUCT_COST PRODUCT_COST
				WHERE 
					PRODUCT_COST.PRODUCT_ID=SHIP_ROW.PRODUCT_ID AND
					PRODUCT_COST.PRODUCT_ID=INVENTORY_ROW2.PRODUCT_ID AND 
					ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=SHIP_ROW.SPECT_VAR_ID),0) AND
					PRODUCT_COST.START_DATE <= SHIP.SHIP_DATE 				
				ORDER BY
					PRODUCT_COST.START_DATE DESC,
					PRODUCT_COST.RECORD_DATE DESC,
					PRODUCT_COST.PURCHASE_NET_SYSTEM DESC)
                    ,0),
                    
                    AMOUNT_2 = ISNULL((
                     SELECT 
                        TOP 1 (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                    FROM 
                        #dsn3_alias#.PRODUCT_COST PRODUCT_COST
                    WHERE 
                        PRODUCT_COST.PRODUCT_ID=SHIP_ROW.PRODUCT_ID AND
                        PRODUCT_COST.PRODUCT_ID=INVENTORY_ROW2.PRODUCT_ID AND 
                        ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=SHIP_ROW.SPECT_VAR_ID),0) AND
                        PRODUCT_COST.START_DATE <= SHIP.SHIP_DATE 				
                    ORDER BY
                        PRODUCT_COST.START_DATE DESC,
                        PRODUCT_COST.RECORD_DATE DESC,
                        PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
				),0)/(SELECT RATE2 FROM SHIP_MONEY WHERE ACTION_ID = SHIP.SHIP_ID AND MONEY_TYPE = '#session.ep.money2#'),
            	AMORT_LAST_VALUE = ISNULL((
                     SELECT 
                        TOP 1 (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                    FROM 
                        #dsn3_alias#.PRODUCT_COST PRODUCT_COST
                    WHERE 
                        PRODUCT_COST.PRODUCT_ID=SHIP_ROW.PRODUCT_ID AND
                        PRODUCT_COST.PRODUCT_ID=INVENTORY_ROW2.PRODUCT_ID AND 
                        ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=SHIP_ROW.SPECT_VAR_ID),0) AND
                        PRODUCT_COST.START_DATE <= SHIP.SHIP_DATE 				
                    ORDER BY
                        PRODUCT_COST.START_DATE DESC,
                        PRODUCT_COST.RECORD_DATE DESC,
                        PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
				),0),
                LAST_INVENTORY_VALUE = ISNULL((
                          	SELECT 
                                TOP 1 (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                            FROM 
                                #dsn3_alias#.PRODUCT_COST PRODUCT_COST
                            WHERE 
                                PRODUCT_COST.PRODUCT_ID=SHIP_ROW.PRODUCT_ID AND
                                PRODUCT_COST.PRODUCT_ID=INVENTORY_ROW2.PRODUCT_ID AND 
                                ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=SHIP_ROW.SPECT_VAR_ID),0) AND
                                PRODUCT_COST.START_DATE <= SHIP.SHIP_DATE 				
                            ORDER BY
                                PRODUCT_COST.START_DATE DESC,
                                PRODUCT_COST.RECORD_DATE DESC,
                                PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
				),0),
                LAST_INVENTORY_VALUE_2 = ISNULL((
                     SELECT 
                        TOP 1 (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                    FROM 
                        #dsn3_alias#.PRODUCT_COST PRODUCT_COST
                    WHERE 
                        PRODUCT_COST.PRODUCT_ID=SHIP_ROW.PRODUCT_ID AND
                        PRODUCT_COST.PRODUCT_ID=INVENTORY_ROW2.PRODUCT_ID AND 
                        ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=SHIP_ROW.SPECT_VAR_ID),0) AND
                        PRODUCT_COST.START_DATE <= SHIP.SHIP_DATE 				
                    ORDER BY
                        PRODUCT_COST.START_DATE DESC,
                        PRODUCT_COST.RECORD_DATE DESC,
                        PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
				),0)/(SELECT RATE2 FROM SHIP_MONEY WHERE ACTION_ID = SHIP.SHIP_ID AND MONEY_TYPE = '#session.ep.money2#')
        	FROM
				####GET_INVOICE AS T  
			JOIN 
				SHIP ON SHIP.SHIP_ID = T.ACTION_ID  AND  T.IS_ADD_INVENTORY = 1  AND SHIP.SHIP_TYPE = 71
			JOIN
				SHIP_ROW ON SHIP_ROW.SHIP_ID = SHIP.SHIP_ID 
			JOIN
				STOCK_FIS ON STOCK_FIS.RELATED_SHIP_ID = SHIP.SHIP_ID AND FIS_TYPE = 118
			JOIN
				#dsn3_alias#.INVENTORY_ROW AS INVENTORY_ROW2 ON INVENTORY_ROW2.ACTION_ID = STOCK_FIS.FIS_ID  AND 
                                                                INVENTORY_ROW2.PROCESS_TYPE = STOCK_FIS.FIS_TYPE AND 
                                                                INVENTORY_ROW2.PERIOD_ID = #attributes.aktarim_kaynak_period# AND 
                                                                INVENTORY_ROW2.SUBSCRIPTION_ID = SHIP.SUBSCRIPTION_ID  AND 
                                                                INVENTORY_ROW2.PRODUCT_ID = SHIP_ROW.PRODUCT_ID 
			JOIN
				#dsn3_alias#.INVENTORY AS INVENTORY2 ON	INVENTORY2.INVENTORY_ID = INVENTORY_ROW2.INVENTORY_ID
        </cfquery>
      
        <cfquery name="upd_stock_fis" datasource="#kaynak_dsn2#">
            UPDATE 
				STOCK_FIS_ROW 
			SET
                PRICE = ISNULL((
				SELECT 
					TOP 1 (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
				FROM 
					#dsn3_alias#.PRODUCT_COST PRODUCT_COST
				WHERE 
					PRODUCT_COST.PRODUCT_ID=SHIP_ROW.PRODUCT_ID AND
					PRODUCT_COST.PRODUCT_ID=(SELECT TOP 1 S.PRODUCT_ID FROM #dsn3_alias#.STOCKS S WHERE S.STOCK_ID = STOCK_FIS_ROW2.STOCK_ID) AND
					ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=SHIP_ROW.SPECT_VAR_ID),0) AND
					PRODUCT_COST.START_DATE <= SHIP.SHIP_DATE 
				ORDER BY
					PRODUCT_COST.START_DATE DESC,
					PRODUCT_COST.RECORD_DATE DESC,
					PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
				),0)
            FROM
				####GET_INVOICE AS T  
			JOIN 
				SHIP ON SHIP.SHIP_ID = T.ACTION_ID  AND  T.IS_ADD_INVENTORY = 1  
			JOIN
				SHIP_ROW ON SHIP_ROW.SHIP_ID = SHIP.SHIP_ID  AND SHIP.SHIP_TYPE = 71
			JOIN
				STOCK_FIS ON STOCK_FIS.RELATED_SHIP_ID = SHIP.SHIP_ID AND FIS_TYPE = 118
			JOIN
				#dsn3_alias#.INVENTORY_ROW AS INVENTORY_ROW2 ON INVENTORY_ROW2.ACTION_ID = STOCK_FIS.FIS_ID  AND 
                                                                INVENTORY_ROW2.PROCESS_TYPE = STOCK_FIS.FIS_TYPE AND 
                                                                INVENTORY_ROW2.PERIOD_ID = #attributes.aktarim_kaynak_period# AND 
                                                                INVENTORY_ROW2.SUBSCRIPTION_ID = SHIP.SUBSCRIPTION_ID  AND 
                                                                INVENTORY_ROW2.PRODUCT_ID = SHIP_ROW.PRODUCT_ID 
			JOIN
            	STOCK_FIS_ROW AS STOCK_FIS_ROW2 ON  STOCK_FIS_ROW2.FIS_ID = STOCK_FIS.FIS_ID AND STOCK_FIS_ROW2.STOCK_ID = SHIP_ROW.STOCK_ID  
            JOIN
				#dsn3_alias#.INVENTORY AS INVENTORY2 ON	INVENTORY2.INVENTORY_ID = INVENTORY_ROW2.INVENTORY_ID
        </cfquery>
		<cfquery name="upd_stock_fis2" datasource="#kaynak_dsn2#">
			UPDATE 
				STOCK_FIS_ROW 
			SET
				PRICE_OTHER = STOCK_FIS_ROW2.PRICE,
				TOTAL = STOCK_FIS_ROW2.PRICE*STOCK_FIS_ROW2.AMOUNT,
				TOTAL_TAX = STOCK_FIS_ROW2.PRICE*STOCK_FIS_ROW2.AMOUNT*STOCK_FIS_ROW2.TAX/100,
				NET_TOTAL = (STOCK_FIS_ROW2.PRICE*STOCK_FIS_ROW2.AMOUNT)+(STOCK_FIS_ROW2.PRICE*STOCK_FIS_ROW2.AMOUNT*STOCK_FIS_ROW2.TAX/100)
            FROM
                ####GET_INVOICE AS T  
            JOIN 
                SHIP ON SHIP.SHIP_ID = T.ACTION_ID  AND  T.IS_ADD_INVENTORY = 1  
            JOIN
                SHIP_ROW ON SHIP_ROW.SHIP_ID = SHIP.SHIP_ID 
            JOIN
                STOCK_FIS ON STOCK_FIS.RELATED_SHIP_ID = SHIP.SHIP_ID  AND SHIP.SHIP_TYPE = 71
            JOIN
                #dsn3_alias#.INVENTORY_ROW AS INVENTORY_ROW2 ON INVENTORY_ROW2.ACTION_ID = STOCK_FIS.FIS_ID  AND 
                                                                INVENTORY_ROW2.PROCESS_TYPE = STOCK_FIS.FIS_TYPE AND 
                                                                INVENTORY_ROW2.PERIOD_ID = #attributes.aktarim_kaynak_period# AND 
                                                                INVENTORY_ROW2.SUBSCRIPTION_ID = SHIP.SUBSCRIPTION_ID  AND 
                                                                INVENTORY_ROW2.PRODUCT_ID = SHIP_ROW.PRODUCT_ID 
            JOIN
                STOCK_FIS_ROW AS STOCK_FIS_ROW2 ON  STOCK_FIS_ROW2.FIS_ID = STOCK_FIS.FIS_ID AND STOCK_FIS_ROW2.STOCK_ID = SHIP_ROW.STOCK_ID 
            JOIN
                #dsn3_alias#.INVENTORY AS INVENTORY2 ON	INVENTORY2.INVENTORY_ID = INVENTORY_ROW2.INVENTORY_ID
        </cfquery>
        
		<cfquery name="upd_stock_fis" datasource="#kaynak_dsn2#">
			UPDATE 
				STOCK_FIS_ROW 
			SET
            
            		PRICE= ISNULL(INVENTORY2.LAST_INVENTORY_VALUE,0)
         FROM
                ####GET_INVOICE AS T  
            JOIN 
                SHIP ON SHIP.SHIP_ID = T.ACTION_ID  AND  T.IS_ADD_INVENTORY = 1     AND SHIP.SHIP_TYPE <> 71
            JOIN
                SHIP_ROW ON SHIP_ROW.SHIP_ID = SHIP.SHIP_ID 
            JOIN
                STOCK_FIS ON STOCK_FIS.RELATED_SHIP_ID = SHIP.SHIP_ID AND FIS_TYPE = 1182
            JOIN
                #dsn3_alias#.INVENTORY_ROW AS INVENTORY_ROW2 ON INVENTORY_ROW2.ACTION_ID = STOCK_FIS.FIS_ID  AND 
                                                                INVENTORY_ROW2.PROCESS_TYPE = STOCK_FIS.FIS_TYPE AND 
                                                                INVENTORY_ROW2.PERIOD_ID = #attributes.aktarim_kaynak_period# AND 
                                                                INVENTORY_ROW2.SUBSCRIPTION_ID = SHIP.SUBSCRIPTION_ID  AND 
                                                                INVENTORY_ROW2.PRODUCT_ID = SHIP_ROW.PRODUCT_ID 
            JOIN
                STOCK_FIS_ROW AS STOCK_FIS_ROW2 ON  STOCK_FIS_ROW2.FIS_ID = STOCK_FIS.FIS_ID AND STOCK_FIS_ROW2.STOCK_ID = SHIP_ROW.STOCK_ID 
            JOIN
                #dsn3_alias#.INVENTORY AS INVENTORY2 ON	INVENTORY2.INVENTORY_ID = INVENTORY_ROW2.INVENTORY_ID
        </cfquery>
		<cfquery name="upd_stock_fis2" datasource="#kaynak_dsn2#">
			UPDATE 
				STOCK_FIS_ROW 
			SET
				PRICE_OTHER = STOCK_FIS_ROW2.PRICE,
				TOTAL = STOCK_FIS_ROW2.PRICE*STOCK_FIS_ROW2.AMOUNT,
				TOTAL_TAX = STOCK_FIS_ROW2.PRICE*STOCK_FIS_ROW2.AMOUNT*STOCK_FIS_ROW2.TAX/100,
				NET_TOTAL = (STOCK_FIS_ROW2.PRICE*STOCK_FIS_ROW2.AMOUNT)+(STOCK_FIS_ROW2.PRICE*STOCK_FIS_ROW2.AMOUNT*STOCK_FIS_ROW2.TAX/100)
        	FROM
                ####GET_INVOICE AS T  
            JOIN 
                SHIP ON SHIP.SHIP_ID = T.ACTION_ID  AND  T.IS_ADD_INVENTORY = 1   AND SHIP.SHIP_TYPE <> 71
            JOIN
                SHIP_ROW ON SHIP_ROW.SHIP_ID = SHIP.SHIP_ID 
            JOIN
                STOCK_FIS ON STOCK_FIS.RELATED_SHIP_ID = SHIP.SHIP_ID AND FIS_TYPE = 1182
            JOIN
                #dsn3_alias#.INVENTORY_ROW AS INVENTORY_ROW2 ON INVENTORY_ROW2.ACTION_ID = STOCK_FIS.FIS_ID  AND 
                                                                INVENTORY_ROW2.PROCESS_TYPE = STOCK_FIS.FIS_TYPE AND 
                                                                INVENTORY_ROW2.PERIOD_ID = #attributes.aktarim_kaynak_period# AND 
                                                                INVENTORY_ROW2.SUBSCRIPTION_ID = SHIP.SUBSCRIPTION_ID  AND 
                                                                INVENTORY_ROW2.PRODUCT_ID = SHIP_ROW.PRODUCT_ID 
            JOIN
                STOCK_FIS_ROW AS STOCK_FIS_ROW2 ON  STOCK_FIS_ROW2.FIS_ID = STOCK_FIS.FIS_ID AND STOCK_FIS_ROW2.STOCK_ID = SHIP_ROW.STOCK_ID 
            JOIN
                #dsn3_alias#.INVENTORY AS INVENTORY2 ON	INVENTORY2.INVENTORY_ID = INVENTORY_ROW2.INVENTORY_ID
        </cfquery>--->
        
        
        
        
        <cfquery name="upd_inv" datasource="#kaynak_dsn2#">
            UPDATE
            	#dsn3_alias#.INVENTORY
            SET 
            	    AMOUNT =ISNULL(XXX.MIKTAR,0) ,                    
                    AMOUNT_2 = ISNULL(XXX.MIKTAR,0)/(SELECT RATE2 FROM SHIP_MONEY WHERE ACTION_ID = SHIP.SHIP_ID AND MONEY_TYPE = '#session.ep.money2#'),
            	    AMORT_LAST_VALUE = ISNULL(XXX.MIKTAR,0),
                    LAST_INVENTORY_VALUE = ISNULL(XXX.MIKTAR,0),
                    LAST_INVENTORY_VALUE_2 = ISNULL(XXX.MIKTAR,0)/(SELECT RATE2 FROM SHIP_MONEY WHERE ACTION_ID = SHIP.SHIP_ID AND MONEY_TYPE = '#session.ep.money2#')
        	FROM
				####GET_INVENTORY AS T  
			JOIN 
				SHIP ON SHIP.SHIP_ID = T.ACTION_ID  AND  T.IS_ADD_INVENTORY = 1  AND SHIP.SHIP_TYPE = 71
			JOIN
				SHIP_ROW ON SHIP_ROW.SHIP_ID = SHIP.SHIP_ID 
			JOIN
				STOCK_FIS ON STOCK_FIS.RELATED_SHIP_ID = SHIP.SHIP_ID AND FIS_TYPE = 118
			JOIN
				#dsn3_alias#.INVENTORY_ROW AS INVENTORY_ROW2 ON INVENTORY_ROW2.ACTION_ID = STOCK_FIS.FIS_ID  AND 
                                                                INVENTORY_ROW2.PROCESS_TYPE = STOCK_FIS.FIS_TYPE AND 
                                                                INVENTORY_ROW2.PERIOD_ID = #attributes.aktarim_kaynak_period# AND 
                                                                INVENTORY_ROW2.SUBSCRIPTION_ID = SHIP.SUBSCRIPTION_ID  AND 
                                                                INVENTORY_ROW2.PRODUCT_ID = SHIP_ROW.PRODUCT_ID 
			JOIN
				#dsn3_alias#.INVENTORY AS INVENTORY2 ON	INVENTORY2.INVENTORY_ID = INVENTORY_ROW2.INVENTORY_ID


			OUTER APPLY 

				(

                             
                		SELECT 
					TOP 1 (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM) AS MIKTAR
				FROM 
					#dsn3_alias#.PRODUCT_COST PRODUCT_COST
				WHERE 
					PRODUCT_COST.PRODUCT_ID=SHIP_ROW.PRODUCT_ID AND
					PRODUCT_COST.PRODUCT_ID=INVENTORY_ROW2.PRODUCT_ID AND 
					ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=SHIP_ROW.SPECT_VAR_ID),0) AND
					PRODUCT_COST.START_DATE <= SHIP.SHIP_DATE 				
				ORDER BY
					PRODUCT_COST.START_DATE DESC,
					PRODUCT_COST.RECORD_DATE DESC,
					PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
                    
				) AS XXX

        </cfquery>
      
        <cfquery name="upd_stock_fis" datasource="#kaynak_dsn2#">
            UPDATE 
				STOCK_FIS_ROW 
			SET
                PRICE = ISNULL((
				SELECT 
					TOP 1 (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
				FROM 
					#dsn3_alias#.PRODUCT_COST PRODUCT_COST
				WHERE 
					PRODUCT_COST.PRODUCT_ID=SHIP_ROW.PRODUCT_ID AND
					PRODUCT_COST.PRODUCT_ID=(SELECT TOP 1 S.PRODUCT_ID FROM #dsn3_alias#.STOCKS S WHERE S.STOCK_ID = STOCK_FIS_ROW2.STOCK_ID) AND
					ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=SHIP_ROW.SPECT_VAR_ID),0) AND
					PRODUCT_COST.START_DATE <= SHIP.SHIP_DATE 
				ORDER BY
					PRODUCT_COST.START_DATE DESC,
					PRODUCT_COST.RECORD_DATE DESC,
					PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
				),0)
            FROM
				####GET_INVENTORY AS T  
			JOIN 
				SHIP ON SHIP.SHIP_ID = T.ACTION_ID  AND  T.IS_ADD_INVENTORY = 1  
			JOIN
				SHIP_ROW ON SHIP_ROW.SHIP_ID = SHIP.SHIP_ID  AND SHIP.SHIP_TYPE = 71
			JOIN
				STOCK_FIS ON STOCK_FIS.RELATED_SHIP_ID = SHIP.SHIP_ID AND FIS_TYPE = 118
			JOIN
				#dsn3_alias#.INVENTORY_ROW AS INVENTORY_ROW2 ON INVENTORY_ROW2.ACTION_ID = STOCK_FIS.FIS_ID  AND 
                                                                INVENTORY_ROW2.PROCESS_TYPE = STOCK_FIS.FIS_TYPE AND 
                                                                INVENTORY_ROW2.PERIOD_ID = #attributes.aktarim_kaynak_period# AND 
                                                                INVENTORY_ROW2.SUBSCRIPTION_ID = SHIP.SUBSCRIPTION_ID  AND 
                                                                INVENTORY_ROW2.PRODUCT_ID = SHIP_ROW.PRODUCT_ID 
			JOIN
            	STOCK_FIS_ROW AS STOCK_FIS_ROW2 ON  STOCK_FIS_ROW2.FIS_ID = STOCK_FIS.FIS_ID AND STOCK_FIS_ROW2.STOCK_ID = SHIP_ROW.STOCK_ID  
            JOIN
				#dsn3_alias#.INVENTORY AS INVENTORY2 ON	INVENTORY2.INVENTORY_ID = INVENTORY_ROW2.INVENTORY_ID
        </cfquery>
		<cfquery name="upd_stock_fis2" datasource="#kaynak_dsn2#">
			UPDATE 
				STOCK_FIS_ROW 
			SET
				PRICE_OTHER = STOCK_FIS_ROW2.PRICE,
				TOTAL = STOCK_FIS_ROW2.PRICE*STOCK_FIS_ROW2.AMOUNT,
				TOTAL_TAX = STOCK_FIS_ROW2.PRICE*STOCK_FIS_ROW2.AMOUNT*STOCK_FIS_ROW2.TAX/100,
				NET_TOTAL = (STOCK_FIS_ROW2.PRICE*STOCK_FIS_ROW2.AMOUNT)+(STOCK_FIS_ROW2.PRICE*STOCK_FIS_ROW2.AMOUNT*STOCK_FIS_ROW2.TAX/100)
            FROM
                ####GET_INVENTORY AS T  
            JOIN 
                SHIP ON SHIP.SHIP_ID = T.ACTION_ID  AND  T.IS_ADD_INVENTORY = 1  
            JOIN
                SHIP_ROW ON SHIP_ROW.SHIP_ID = SHIP.SHIP_ID 
            JOIN
                STOCK_FIS ON STOCK_FIS.RELATED_SHIP_ID = SHIP.SHIP_ID  AND SHIP.SHIP_TYPE = 71
            JOIN
                #dsn3_alias#.INVENTORY_ROW AS INVENTORY_ROW2 ON INVENTORY_ROW2.ACTION_ID = STOCK_FIS.FIS_ID  AND 
                                                                INVENTORY_ROW2.PROCESS_TYPE = STOCK_FIS.FIS_TYPE AND 
                                                                INVENTORY_ROW2.PERIOD_ID = #attributes.aktarim_kaynak_period# AND 
                                                                INVENTORY_ROW2.SUBSCRIPTION_ID = SHIP.SUBSCRIPTION_ID  AND 
                                                                INVENTORY_ROW2.PRODUCT_ID = SHIP_ROW.PRODUCT_ID 
            JOIN
                STOCK_FIS_ROW AS STOCK_FIS_ROW2 ON  STOCK_FIS_ROW2.FIS_ID = STOCK_FIS.FIS_ID AND STOCK_FIS_ROW2.STOCK_ID = SHIP_ROW.STOCK_ID 
            JOIN
                #dsn3_alias#.INVENTORY AS INVENTORY2 ON	INVENTORY2.INVENTORY_ID = INVENTORY_ROW2.INVENTORY_ID
        </cfquery>
        
		<cfquery name="upd_stock_fis" datasource="#kaynak_dsn2#">
			UPDATE 
				STOCK_FIS_ROW 
			SET
            
            		PRICE= ISNULL(INVENTORY2.LAST_INVENTORY_VALUE,0)
         FROM
                ####GET_INVENTORY AS T  
            JOIN 
                SHIP ON SHIP.SHIP_ID = T.ACTION_ID  AND  T.IS_ADD_INVENTORY = 1     AND SHIP.SHIP_TYPE <> 71
            JOIN
                SHIP_ROW ON SHIP_ROW.SHIP_ID = SHIP.SHIP_ID 
            JOIN
                STOCK_FIS ON STOCK_FIS.RELATED_SHIP_ID = SHIP.SHIP_ID AND FIS_TYPE = 1182
            JOIN
                #dsn3_alias#.INVENTORY_ROW AS INVENTORY_ROW2 ON INVENTORY_ROW2.ACTION_ID = STOCK_FIS.FIS_ID  AND 
                                                                INVENTORY_ROW2.PROCESS_TYPE = STOCK_FIS.FIS_TYPE AND 
                                                                INVENTORY_ROW2.PERIOD_ID = #attributes.aktarim_kaynak_period# AND 
                                                                INVENTORY_ROW2.SUBSCRIPTION_ID = SHIP.SUBSCRIPTION_ID  AND 
                                                                INVENTORY_ROW2.PRODUCT_ID = SHIP_ROW.PRODUCT_ID 
            JOIN
                STOCK_FIS_ROW AS STOCK_FIS_ROW2 ON  STOCK_FIS_ROW2.FIS_ID = STOCK_FIS.FIS_ID AND STOCK_FIS_ROW2.STOCK_ID = SHIP_ROW.STOCK_ID 
            JOIN
                #dsn3_alias#.INVENTORY AS INVENTORY2 ON	INVENTORY2.INVENTORY_ID = INVENTORY_ROW2.INVENTORY_ID
        </cfquery>
		<cfquery name="upd_stock_fis2" datasource="#kaynak_dsn2#">
			UPDATE 
				STOCK_FIS_ROW 
			SET
				PRICE_OTHER = STOCK_FIS_ROW2.PRICE,
				TOTAL = STOCK_FIS_ROW2.PRICE*STOCK_FIS_ROW2.AMOUNT,
				TOTAL_TAX = STOCK_FIS_ROW2.PRICE*STOCK_FIS_ROW2.AMOUNT*STOCK_FIS_ROW2.TAX/100,
				NET_TOTAL = (STOCK_FIS_ROW2.PRICE*STOCK_FIS_ROW2.AMOUNT)+(STOCK_FIS_ROW2.PRICE*STOCK_FIS_ROW2.AMOUNT*STOCK_FIS_ROW2.TAX/100)
        	FROM
                ####GET_INVENTORY AS T  
            JOIN 
                SHIP ON SHIP.SHIP_ID = T.ACTION_ID  AND  T.IS_ADD_INVENTORY = 1   AND SHIP.SHIP_TYPE <> 71
            JOIN
                SHIP_ROW ON SHIP_ROW.SHIP_ID = SHIP.SHIP_ID 
            JOIN
                STOCK_FIS ON STOCK_FIS.RELATED_SHIP_ID = SHIP.SHIP_ID AND FIS_TYPE = 1182
            JOIN
                #dsn3_alias#.INVENTORY_ROW AS INVENTORY_ROW2 ON INVENTORY_ROW2.ACTION_ID = STOCK_FIS.FIS_ID  AND 
                                                                INVENTORY_ROW2.PROCESS_TYPE = STOCK_FIS.FIS_TYPE AND 
                                                                INVENTORY_ROW2.PERIOD_ID = #attributes.aktarim_kaynak_period# AND 
                                                                INVENTORY_ROW2.SUBSCRIPTION_ID = SHIP.SUBSCRIPTION_ID  AND 
                                                                INVENTORY_ROW2.PRODUCT_ID = SHIP_ROW.PRODUCT_ID 
            JOIN
                STOCK_FIS_ROW AS STOCK_FIS_ROW2 ON  STOCK_FIS_ROW2.FIS_ID = STOCK_FIS.FIS_ID AND STOCK_FIS_ROW2.STOCK_ID = SHIP_ROW.STOCK_ID 
            JOIN
                #dsn3_alias#.INVENTORY AS INVENTORY2 ON	INVENTORY2.INVENTORY_ID = INVENTORY_ROW2.INVENTORY_ID
        </cfquery>


