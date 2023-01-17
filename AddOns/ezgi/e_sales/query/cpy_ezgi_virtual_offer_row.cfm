﻿<cftransaction>
    <cfquery name="cpy_virtual_offer_row" datasource="#dsn3#">
                INSERT INTO 
                    EZGI_VIRTUAL_OFFER_ROW
                    (
                        VIRTUAL_OFFER_ID, 
                        IS_STANDART, 
                        PRODUCT_ID, 
                        STOCK_ID, 
                        PRODUCT_NAME, 
                        STOCK_CODE, 
                        QUANTITY, 
                        UNIT, 
                        VIRTUAL_OFFER_ROW_CURRENCY, 
                        PRODUCT_NAME2, 
                        PRICE, 
                        OTHER_MONEY, 
                        DISCOUNT_1, 
                        DISCOUNT_2, 
                     	DISCOUNT_3, 
                    	DISCOUNT_COST, 
                      	COST,
                        PRODUCT_CODE_2, 
                        TAX,
                        BOY, 
                        EN, 
                        DERINLIK, 
                        YON,
                        PURCHASE_PRICE, 
                     	PURCHASE_PRICE_MONEY, 
                       	COST_PRICE, 
                       	COST_PRICE_MONEY,
                    	P_PURCHASE_PRICE, 
                     	P_PURCHASE_PRICE_MONEY, 
                      	P_DISCOUNT_1, 
                     	P_DISCOUNT_2, 
                    	P_DISCOUNT_3, 
                     	P_DISCOUNT_4, 
                     	P_DISCOUNT_5
                    )
                SELECT        
                    VIRTUAL_OFFER_ID,  
                    IS_STANDART, 
                    PRODUCT_ID, 
                    STOCK_ID, 
                    PRODUCT_NAME, 
                    STOCK_CODE, 
                    1 as QUANTITY, 
                    UNIT, 
                    1 as VIRTUAL_OFFER_ROW_CURRENCY,
                    PRODUCT_NAME2, 
                    PRICE, 
                  	OTHER_MONEY, 
                    DISCOUNT_1, 
                    DISCOUNT_2, 
                 	DISCOUNT_3, 
                  	DISCOUNT_COST, 
               		COST,
                    PRODUCT_CODE_2, 
                    TAX,
                    BOY, 
                    EN, 
                    DERINLIK, 
                    YON,
                    PURCHASE_PRICE, 
                  	PURCHASE_PRICE_MONEY, 
                   	COST_PRICE, 
                   	COST_PRICE_MONEY,
                  	P_PURCHASE_PRICE, 
                    P_PURCHASE_PRICE_MONEY, 
                  	P_DISCOUNT_1, 
                	P_DISCOUNT_2, 
               		P_DISCOUNT_3, 
                  	P_DISCOUNT_4, 
                 	P_DISCOUNT_5
                FROM            
                    EZGI_VIRTUAL_OFFER_ROW E
                WHERE        
                    VIRTUAL_OFFER_ROW_ID = #attributes.virtual_offer_row_id#
    </cfquery>
    <cfquery name="get_max_id" datasource="#dsn3#">
        SELECT MAX(VIRTUAL_OFFER_ROW_ID) AS MAX_ID FROM EZGI_VIRTUAL_OFFER_ROW
    </cfquery>
    <cfquery name="upd_ezgi_id" datasource="#dsn3#">
        UPDATE EZGI_VIRTUAL_OFFER_ROW SET EZGI_ID = VIRTUAL_OFFER_ROW_ID WHERE VIRTUAL_OFFER_ROW_ID = #get_max_id.MAX_ID#
    </cfquery>
    <cfquery name="get_ezgi_id" datasource="#dsn3#">
        SELECT EZGI_ID FROM  EZGI_VIRTUAL_OFFER_ROW	WHERE VIRTUAL_OFFER_ROW_ID = #attributes.virtual_offer_row_id#
    </cfquery>
    <cfquery name="add_row_detail" datasource="#dsn3#">
        INSERT INTO 
            EZGI_VIRTUAL_OFFER_ROW_DETAIL
            (
                EZGI_ID, 
                AMOUNT, 
                LAST_AMOUNT,
                SALES_PRICE, 
                SALES_PRICE_MONEY, 
                PURCHASE_PRICE, 
                PURCHASE_PRICE_MONEY, 
                COST_PRICE, 
                COST_PRICE_MONEY, 
                STOCK_ID, 
                PRODUCT_CODE, 
                PRODUCT_NAME, 
                MAIN_UNIT, 
                PIECE_ROW_ID, 
                PIECE_TYPE, 
                QUESTION_ID, 
                IS_AMOUNT_CHANGE, 
                IS_PRICE_CHANGE, 
                BOY_FORMUL, 
                EN_FORMUL, 
                AMOUNT_FORMUL, 
                NOT_STANDART_RATE, 
                DESIGN_EN, 
                DESIGN_BOY,
            	PRIVATE_PRICE_TYPE, 
              	PRIVATE_PRICE_MONEY, 
             	PRIVATE_PRICE
            )
        SELECT        
            #get_max_id.MAX_ID#, 
            AMOUNT, 
            LAST_AMOUNT,
            SALES_PRICE, 
            SALES_PRICE_MONEY, 
            PURCHASE_PRICE, 
            PURCHASE_PRICE_MONEY, 
            COST_PRICE, 
            COST_PRICE_MONEY, 
            STOCK_ID, 
            PRODUCT_CODE, 
            PRODUCT_NAME, 
            MAIN_UNIT, 
            PIECE_ROW_ID, 
            PIECE_TYPE, 
            QUESTION_ID, 
            IS_AMOUNT_CHANGE, 
            IS_PRICE_CHANGE, 
            BOY_FORMUL, 
            EN_FORMUL, 
            AMOUNT_FORMUL, 
            NOT_STANDART_RATE, 
            DESIGN_EN, 
            DESIGN_BOY,
           	PRIVATE_PRICE_TYPE, 
         	PRIVATE_PRICE_MONEY, 
          	PRIVATE_PRICE
        FROM            
            EZGI_VIRTUAL_OFFER_ROW_DETAIL
        WHERE        
            EZGI_ID = #get_ezgi_id.ezgi_id#
    </cfquery>
    <cfquery name="cpy_EZGI_VIRTUAL_OFFER_ROW_IMPORT" datasource="#dsn3#">
     	INSERT INTO              
         	EZGI_VIRTUAL_OFFER_ROW_IMPORT
        	(
              	EZGI_ID, 
              	POZ_ID, 
              	PACKAGE_ROW_ID, 
              	PIECE_ID, 
              	PIECE_ROW_ID, 
              	PIECE_TYPE, 
              	STOCK_ID, 
              	PRODUCT_NAME, 
              	AMOUNT, 
              	BOY, 
              	EN, 
              	KALINLIK,
              	YON, 
              	DETAY, 
              	PVC1, 
              	PVC2, 
              	PVC3, 
              	PVC4,
                CANAL_DETAIL, 
                COVER_MODEL, 
                HOLE_QUANTITY, 
                MATERIAL_MEASURE1, 
              	MATERIAL_MEASURE2, 
                MATERIAL_AMOUNT, 
                PACKAGE_DETAIL, 
                OPERATION_CODE1, 
                OPERATION_CODE2, 
                VIRTUAL_MATERIAL

        	)
   		SELECT
        	#get_max_id.MAX_ID#,
        	POZ_ID, 
        	PACKAGE_ROW_ID, 
          	PIECE_ID, 
         	PIECE_ROW_ID, 
        	PIECE_TYPE, 
        	STOCK_ID, 
         	PRODUCT_NAME, 
          	AMOUNT, 
         	BOY, 
        	EN, 
       		KALINLIK,
        	YON, 
        	DETAY, 
          	PVC1, 
        	PVC2, 
        	PVC3, 
        	PVC4,
            CANAL_DETAIL, 
          	COVER_MODEL, 
           	HOLE_QUANTITY, 
         	MATERIAL_MEASURE1, 
          	MATERIAL_MEASURE2, 
        	MATERIAL_AMOUNT, 
          	PACKAGE_DETAIL, 
          	OPERATION_CODE1, 
          	OPERATION_CODE2, 
          	VIRTUAL_MATERIAL
   		FROM
        	EZGI_VIRTUAL_OFFER_ROW_IMPORT
     	WHERE        
       	EZGI_ID = #get_ezgi_id.ezgi_id#      
  	</cfquery>
 	<cfquery name="cpy_EZGI_VIRTUAL_OFFER_ROW_IMPORT_ROTA" datasource="#dsn3#">
     	INSERT INTO 
          	EZGI_VIRTUAL_OFFER_ROW_IMPORT_ROTA
         	(
             	EZGI_ID, 
              	PIECE_ID, 
            	PIECE_ROW_ID, 
            	PIECE_TYPE, 
            	OPERATION_TYPE_ID, 
           		AMOUNT
         	)
      	SELECT
          	#get_max_id.MAX_ID#, 
        	PIECE_ID, 
          	PIECE_ROW_ID, 
        	PIECE_TYPE, 
         	OPERATION_TYPE_ID, 
       		AMOUNT
   		FROM
        	EZGI_VIRTUAL_OFFER_ROW_IMPORT_ROTA
       	WHERE        
        	EZGI_ID = #get_ezgi_id.ezgi_id# 
  	</cfquery>
    <cfquery name="cpy_EZGI_VIRTUAL_OFFER_ROW_IMPORT_FILE" datasource="#dsn3#">
    	INSERT INTO 
        	EZGI_VIRTUAL_OFFER_ROW_IMPORT_FILE
         	(
            	EZGI_ID, 
                FILE_TYPE_ID, 
                FILE_NAME
           	)
		SELECT        
        	#get_max_id.MAX_ID#, 
            FILE_TYPE_ID, 
            FILE_NAME
		FROM            
        	EZGI_VIRTUAL_OFFER_ROW_IMPORT_FILE
		WHERE        
        	EZGI_ID = #get_ezgi_id.ezgi_id#
   	</cfquery>
</cftransaction>
<cflocation url="#request.self#?fuseaction=prod.upd_ezgi_virtual_offer&virtual_offer_id=#attributes.virtual_offer_id#" addtoken="No">