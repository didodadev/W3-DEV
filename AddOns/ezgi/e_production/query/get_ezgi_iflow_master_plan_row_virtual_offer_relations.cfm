<cfquery name="get_rows" datasource="#dsn3#">
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
      	END AS UNVAN,
    	(SELECT PACKAGE_NAME FROM EZGI_DESIGN_PACKAGE_ROW WHERE PACKAGE_ROW_ID = EVORI.PACKAGE_ROW_ID) AS PACKAGE_NAME,   
    	EPO.SPECT_MAIN_ID, 
    	EPO.LOT_NO, 
        EPOP.P_ORDER_PARTI_NUMBER, 
        EPAP.MASTER_PLAN_NUMBER, 
        O.ORDER_NUMBER, 
        EVOR.BOY, 
        EVOR.EN, 
        EVORI.KALINLIK,
        EVOR.DERINLIK, 
        EVOR.YON, 
        EVOR.PRODUCT_NAME, 
        EVOR.PRODUCT_NAME2,
        EVORI.POZ_ID,
      	EVORI.PACKAGE_ROW_ID, 
        EVORI.PIECE_ID, 
        EVORI.PIECE_TYPE, 
        EVORI.OPERATION_CODE2, 
        EVORI.OPERATION_CODE1, 
        EVORI.PACKAGE_DETAIL, 
        EVORI.MATERIAL_AMOUNT, 
        EVORI.MATERIAL_MEASURE2, 
     	EVORI.MATERIAL_MEASURE1, 
        EVORI.COVER_MODEL, 
        EVORI.CANAL_DETAIL, 
        EVORI.DETAY, 
        EDPR.PIECE_CODE, 
        EDPR.KESIM_BOYU, 
        EDPR.KESIM_ENI, 
        EDPR.KALINLIK, 
        EDPR.PIECE_ROW_ID, 
     	EDPR.PIECE_NAME, 
        EDPR.PIECE_COLOR_ID, 
        EDPR.PIECE_DETAIL, 
        EDPR.PIECE_AMOUNT, 
        EDPR.IS_FLOW_DIRECTION, 
        EDPR.PIECE_FLOOR, 
        EDPR.PIECE_PACKAGE_ROTA,
        PO.QUANTITY
	FROM            
   		EZGI_DESIGN_PIECE_ROWS AS EDPR INNER JOIN
    	EZGI_DESIGN_MAIN_ROW AS EDMR ON EDPR.DESIGN_MAIN_ROW_ID = EDMR.DESIGN_MAIN_ROW_ID INNER JOIN
      	EZGI_IFLOW_PRODUCTION_ORDERS AS EPO INNER JOIN
     	EZGI_IFLOW_PRODUCTION_ORDERS_PARTI AS EPOP ON EPO.REL_P_ORDER_ID = EPOP.P_ORDER_PARTI_ID INNER JOIN
  		EZGI_IFLOW_MASTER_PLAN AS EPAP ON EPO.MASTER_PLAN_ID = EPAP.MASTER_PLAN_ID INNER JOIN
 		PRODUCTION_ORDERS AS PO ON EPO.LOT_NO = PO.LOT_NO INNER JOIN
   		PRODUCTION_ORDERS_ROW AS PORR ON PO.P_ORDER_ID = PORR.PRODUCTION_ORDER_ID INNER JOIN
      	ORDERS AS O ON PORR.ORDER_ID = O.ORDER_ID INNER JOIN
     	ORDER_ROW AS ORR ON PORR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
      	EZGI_VIRTUAL_OFFER_ROW AS EVOR ON ORR.WRK_ROW_RELATION_ID = EVOR.WRK_ROW_RELATION_ID INNER JOIN
     	EZGI_VIRTUAL_OFFER_ROW_IMPORT AS EVORI ON EVOR.EZGI_ID = EVORI.EZGI_ID INNER JOIN
  		OFFER_ROW AS OFR ON ORR.WRK_ROW_RELATION_ID = OFR.WRK_ROW_ID ON EDPR.PIECE_CODE = EVORI.PIECE_ID AND EDMR.WRK_ROW_RELATION_ID = OFR.WRK_ROW_ID
  	WHERE
    	EPO.IFLOW_P_ORDER_ID IN (#attributes.p_order_id_list#)
	GROUP BY 
    	EPO.SPECT_MAIN_ID, 
        EPO.LOT_NO, 
        EPOP.P_ORDER_PARTI_NUMBER, 
        EPAP.MASTER_PLAN_NUMBER, 
        O.ORDER_NUMBER, 
        EVOR.BOY, 
        EVOR.EN,
        EVORI.KALINLIK, 
        EVOR.DERINLIK, 
        EVOR.YON, 
        EVOR.PRODUCT_NAME, 
        EVOR.PRODUCT_NAME2,
        EVORI.POZ_ID,
     	EVORI.PACKAGE_ROW_ID, 
        EVORI.PIECE_ID, 
        EVORI.PIECE_TYPE, 
        EVORI.OPERATION_CODE2, 
        EVORI.OPERATION_CODE1, 
        EVORI.PACKAGE_DETAIL, 
        EVORI.MATERIAL_AMOUNT, 
        EVORI.MATERIAL_MEASURE2, 
      	EVORI.MATERIAL_MEASURE1, 
        EVORI.COVER_MODEL, 
        EVORI.CANAL_DETAIL, 
        EVORI.DETAY, 
        EDPR.PIECE_CODE, 
        EDPR.KESIM_BOYU, 
        EDPR.KESIM_ENI, 
        EDPR.KALINLIK, 
        EDPR.PIECE_ROW_ID, 
 		EDPR.PIECE_TYPE, 
        EDPR.PIECE_NAME, 
        EDPR.PIECE_COLOR_ID, 
        EDPR.PIECE_DETAIL, 
        EDPR.PIECE_AMOUNT, 
        EDPR.IS_FLOW_DIRECTION, 
        EDPR.PIECE_FLOOR, 
        EDPR.PIECE_PACKAGE_ROTA,
        PO.QUANTITY,
        O.COMPANY_ID,
        O.CONSUMER_ID,
        O.EMPLOYEE_ID
   	ORDER BY
    	EVORI.PACKAGE_ROW_ID
</cfquery>

<cfquery name="get_kesim_list" dbtype="query">
	SELECT * FROM get_rows WHERE PIECE_TYPE = 1
</cfquery>