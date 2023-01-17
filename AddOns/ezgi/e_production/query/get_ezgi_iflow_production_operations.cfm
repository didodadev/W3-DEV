<cfquery name="get_production_operations" datasource="#dsn3#">
	SELECT        
    	E.IFLOW_P_ORDER_ID, 
        E.ACTION_TYPE, 
        E.PRODUCT_TYPE, 
        E.START_DATE, 
        E.FINISH_DATE, 
        E.PLANNING_DATE, 
        E.CUTTING_FINISH_DATE,
     	(SELECT MASTER_PLAN_NUMBER FROM EZGI_IFLOW_MASTER_PLAN WHERE MASTER_PLAN_ID = E.MASTER_PLAN_ID) AS MASTER_PLAN_NUMBER,
      	(SELECT P_ORDER_PARTI_NUMBER FROM EZGI_IFLOW_PRODUCTION_ORDERS_PARTI WHERE P_ORDER_PARTI_ID = E.REL_P_ORDER_ID) AS P_ORDER_PARTI_NUMBER, 
        EOM.LOT_NO, 
        EOM.P_ORDER_NO, 
        EOM.P_ORDER_ID,
        EOM.PRODUCTION_LEVEL, 
        EOM.IS_STAGE, 
        EOM.STOCK_CODE, 
      	EOM.STOCK_ID,
        EOM.PRODUCT_ID, 
        EOM.PRODUCT_NAME, 
        EOM.QUANTITY, 
        EOM.P_OPERATION_ID, 
        EOM.OPERATION_TYPE_ID, 
        EOM.OPERATION_CODE, 
        EOM.OPERATION_TYPE, 
        EOM.AMOUNT, 
     	EOM.STAGE, 
        EOM.REAL_TIME, 
        EOM.WAIT_TIME, 
        ISNULL(EOM.REAL_AMOUNT,0) REAL_AMOUNT, 
        EOM.LOSS_AMOUNT, 
        EOM.STATION_NAME O_STATION_NAME, 
        EOM.O_START_DATE, 
        EOM.O_STATION_IP, 
        EOM.O_TOTAL_PROCESS_TIME, 
    	EOM.IS_VIRTUAL, 
        EOM.OPERATION_GRUP_ID, 
        EOM.OPERATION_RESULT_ID, 
        EOM.OPERATION_GRUP_END_ID, 
        EOM.O_CURRENT_NUMBER,
        PO.STATION_ID,
        (SELECT STATION_NAME FROM WORKSTATIONS WHERE STATION_ID = PO.STATION_ID) STATION_NAME ,
        ISNULL((SELECT COUNT(P_ORDER_ID) AS SAY FROM PRODUCTION_OPERATION_RESULT WHERE REAL_AMOUNT = 0 AND LOSS_AMOUNT = 0 AND REAL_TIME = 0 AND OPERATION_ID = EOM.P_OPERATION_ID),0) SAY
	FROM            
    	PRODUCTION_ORDERS AS PO INNER JOIN
     	EZGI_IFLOW_PRODUCTION_ORDERS AS E ON PO.LOT_NO = E.LOT_NO INNER JOIN
		EZGI_OPERATION_M AS EOM ON PO.P_ORDER_ID = EOM.P_ORDER_ID
	WHERE        
    	1 = 1 
        <cfif isdefined('attributes.master_plan_id') and len(attributes.master_plan_id)>
        	AND E.MASTER_PLAN_ID = #attributes.master_plan_id#
     	</cfif>
    	<cfif isdefined('attributes.product_type') and len(attributes.product_type)>
         	AND E.PRODUCT_TYPE = #attributes.product_type#
     	</cfif>
     	<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
                AND 
                (
                	EOM.PRODUCT_NAME LIKE '%#attributes.keyword#%' OR
                    EOM.LOT_NO LIKE '%#attributes.keyword#%' OR
                    EOM.P_ORDER_NO LIKE '%#attributes.keyword#%'
               	)
     	</cfif>
     	<cfif isdefined('attributes.station_id') and len(attributes.station_id)>
         	AND PO.STATION_ID = #attributes.station_id#
     	</cfif>
        <cfif isdefined('attributes.operation_type_id') and len(attributes.operation_type_id)>
         	AND EOM.OPERATION_TYPE_ID = #attributes.operation_type_id#
     	</cfif>
      	<cfif isdefined('attributes.p_order_id_list') and len(attributes.p_order_id_list)>
         	AND PO.P_ORDER_ID IN (#attributes.p_order_id_list#)
      	</cfif>
        <cfif isdefined('attributes.durum_emir') and len(attributes.durum_emir)>
        	<cfif attributes.durum_emir eq 2>
            	AND EOM.STAGE IN (0,1)
            <cfelseif attributes.durum_emir eq 5>
            	AND ISNULL((SELECT COUNT(P_ORDER_ID) AS SAY FROM PRODUCTION_OPERATION_RESULT WHERE REAL_AMOUNT = 0 AND LOSS_AMOUNT = 0 AND REAL_TIME = 0 AND OPERATION_ID = EOM.P_OPERATION_ID),0) > 0
            <cfelse>
         		AND EOM.STAGE = #attributes.durum_emir#
           	</cfif>
      	</cfif>
 	ORDER BY 
		<cfif attributes.sort_type eq 0>
         	EOM.PRODUCT_NAME
       	<cfelseif attributes.sort_type eq 1>
        	EOM.PRODUCT_NAME desc
       	<cfelseif attributes.sort_type eq 2>
        	EOM.LOT_NO
    	<cfelseif attributes.sort_type eq 3>
       		EOM.LOT_NO desc
      	<cfelseif attributes.sort_type eq 4>
          	E.CUTTING_FINISH_DATE
      	<cfelseif attributes.sort_type eq 5>
         	E.CUTTING_FINISH_DATE desc
     	<cfelseif attributes.sort_type eq 10>
          	E.DP_ORDER_ID
    	</cfif>
 </cfquery>