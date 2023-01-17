<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
     <cfset dsn3 ="#dsn#_#session.ep.company_id#">
     <cfset dsn1 ="#dsn#_product">
    <cfset predefined_table = "TEXTILE_PREDEFINED_PROC">
    <cfset predefined_row_table = "TEXTILE_PREDEFINED_PROC_ROW">

    <!---
    <cffunction name="get_stations" access="public" returntype="query">
        <cfquery name="query_stations" datasource="#dsn#">
            SELECT DISTINCT STATION_ID FROM HY_TEXTILE_STATION_PROCESS
        </cfquery>
        <cfreturn query_stations>
    </cffunction>

    <cffunction name="get_process_cat" access="public" returntype="query">
        <cfquery name="query_process_cat" datasource="#dsn#">
            SELECT STATION_ID, PROCESS_CAT FROM HY_TEXTILE_STATION_PROCESS
            GROUP BY STATION_ID, PROCESS_CAT
        </cfquery>
        <cfreturn query_process_cat>
    </cffunction>

    <cffunction name="get_process" access="public" returntype="query">
        <cfquery name="query_process" datasource="#dsn#">
            SELECT * FROM HY_TEXTILE_STATION_PROCESS
            WHERE ACTIVE = 1
        </cfquery>
        <cfreturn query_process>
    </cffunction>
    --->
<cffunction name="getOperation">
        <cfquery name="GET_OPERATION" datasource="#dsn#_#session.ep.company_id#">
				select 
					OPERATION_TYPE_ID,
					OPERATION_TYPE
				from OPERATION_TYPES
                where OPERATION_STATUS = 1
				order by OPERATION_TYPE
        </cfquery>
		<cfreturn GET_OPERATION>
    </cffunction>
<cffunction name="getOperationCustomOrder">
        <cfquery name="GET_OPERATION" datasource="#dsn#_#session.ep.company_id#">
				select * from (
                select 
					OPERATION_TYPE_ID,
					OPERATION_TYPE,
                    CASE OPERATION_TYPE_ID
                        WHEN 12 THEN 1
                        WHEN 1 THEN 2
                        WHEN 5 THEN 3
                        WHEN 6 THEN 4
                        WHEN 2 THEN 5
                        WHEN 3 THEN 6
                        WHEN 7 THEN 7
                        WHEN 4 THEN 8
                        WHEN 10 THEN 9
                        ELSE 999
                        END
                    AS ORD 
				from OPERATION_TYPES
                where OPERATION_STATUS = 1 AND OPERATION_TYPE_ID IN (12,1,5,6,2,3,7,4,10)
                ) Tord
				order by ORD
        </cfquery>
		<cfreturn GET_OPERATION>
    </cffunction>
    <cffunction name="get_stations" access="public" returntype="query">
        <cfargument name="dsn3" type="string"> 
        <cfquery name="query_stations" datasource="#dsn3#">
            SELECT STATION_ID, STATION_NAME FROM WORKSTATIONS ORDER BY STATION_NAME
        </cfquery>
        <cfreturn query_stations>
    </cffunction>

    <cffunction name="get_predefineds" access="public" returntype="query">
     <cfargument name="req_id" type="any" default="">
     <cfargument name="order_id" type="any" default="">
     <cfargument name="main_operation_id" type="any" default="">
        <cfquery name="query_predefined" datasource="#dsn3#">
           <!--- SELECT * FROM #predefined_table# WHERE PREDEFINED_STATUS = 1 and REQUEST_ID=#arguments.req_id#--->
				select
					TEXTILE_SAMPLE_REQUEST.*,
					ORDERS.*,
					TEXTILE_PRODUCTION_OPERATION_MAIN.*,
                    ISNULL(ORDER_MAIN.PARTY_ID,0) IS_ORDER
				from 
					TEXTILE_SAMPLE_REQUEST
					LEFT JOIN TEXTILE_PRODUCTION_OPERATION_MAIN ON TEXTILE_PRODUCTION_OPERATION_MAIN.REQUEST_ID=TEXTILE_SAMPLE_REQUEST.REQ_ID
					LEFT JOIN ORDERS ON ORDERS.ORDER_ID=TEXTILE_PRODUCTION_OPERATION_MAIN.ORDER_ID
                    LEFT JOIN TEXTILE_PRODUCTION_ORDERS_MAIN ORDER_MAIN ON ORDER_MAIN.MAIN_OPERATION_ID=TEXTILE_PRODUCTION_OPERATION_MAIN.MAIN_OPERATION_ID
				WHERE
                <cfif len(arguments.main_operation_id)>
                    TEXTILE_PRODUCTION_OPERATION_MAIN.MAIN_OPERATION_ID=#arguments.main_operation_id#
                <cfelse>
                    TEXTILE_SAMPLE_REQUEST.REQ_ID=(#arguments.req_id#) AND 
                    ORDERS.ORDER_ID=#arguments.order_id#
                </cfif>
					
        </cfquery>
        <cfreturn query_predefined>
    </cffunction>

    <cffunction name="get_predefined_byname" access="public" returntype="query">
        <cfargument name="title" type="string">
        <cfquery name="query_predefined" datasource="#dsn3#">
            SELECT * FROM #predefined_table# WHERE PREDEFINED_TITLE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.title#'>
        </cfquery>
        <cfreturn query_predefined>
    </cffunction>

    <cffunction name="insert_predefined" access="public" returntype="any">
		 <cfargument name="req_id" type="any">
		 <cfargument name="order_id" type="any" default="">
         <cfargument name="amount" type="any" default="">
         <cfargument name="proclist" type="any" default="">
         <cfargument name="page_type" type="any" default="">
         <cfargument name="marj" type="any" default="">
        <cftransaction>
                <cfquery name="query_predefined" datasource="#dsn3#" result="result_predefined">
                        INSERT INTO [TEXTILE_PRODUCTION_OPERATION_MAIN]
                        (
                         [REQUEST_ID]
                        ,[ORDER_ID]
                        ,[AMOUNT]
                        ,[RECORD_EMP]
                        ,[RECORD_DATE]
                        ,IS_SEND
                        ,MARJ
                        )
                    VALUES
                        (
                            <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.order_id#'>
                            ,<cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.amount#'>
                            ,#session.ep.userid#
                            ,#now()#
                            ,#arguments.page_type#
                            ,#arguments.marj#
                            )
                </cfquery>
            <cfset sayac=0>
            <cfloop list="#arguments.proclist#" index="p">
                <cfset sayac=sayac+1>
                    <cfquery name="query_predefined_row" datasource="#dsn3#">
                        INSERT INTO [TEXTILE_PRODUCTION_OPERATION]
                        (
                            [REQUEST_ID]
                            ,[P_ORDER_ID]
                            ,[AMOUNT]
                            ,[STATION_ID]
                            ,[OPERATION_TYPE_ID]
                            ,[STAGE]
                            ,[RECORD_EMP]
                            ,[RECORD_DATE]
                            ,[MAIN_OPERATION_ID]
                            ,LINE
                            ,MARJ
                            ,IS_FINISH_LINE
                    )
                    VALUES
                            (
                            <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>
                            ,<cfif IsDefined("arguments.p_order_id") and len(arguments.p_order_id)>#arguments.p_order_id#<cfelse>NULL</cfif>
                            ,<cfif IsDefined("arguments.amount") and len(arguments.amount)>#arguments.amount#<cfelse>NULL</cfif>
                            ,<cfif IsDefined("arguments.station_id") and len(arguments.station_id)>#arguments.station_id#<cfelse>NULL</cfif>
                            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#p#'>
                            ,<cfif IsDefined("arguments.stage_id") and len(arguments.stage_id)>#arguments.stage_id#<cfelse>NULL</cfif>
                            ,#session.ep.userid#
                            ,#now()#
                            ,#result_predefined["GENERATEDKEY"]#
                            ,#sayac#
                            ,#arguments.marj#
                            ,<cfif sayac eq ListLen(arguments.proclist)>1<cfelse>0</cfif>
                        )
                    </cfquery>
            </cfloop>
        </cftransaction>

        <cfreturn result_predefined["GENERATEDKEY"]>
    </cffunction>

    <cffunction name="update_predefined" access="public">
        <cfargument name="main_operation_id" type="any">
        <cfargument name="req_id" type="any">
        <cfargument name="order_id" type="any" default="">
        <cfargument name="amount" type="any" default="">
        <cfargument name="proclist" type="any" default="">
        <cfargument name="page_type" type="any" default="">
        <cfargument name="marj" type="any" default="">
         <cftransaction>
            <cfquery name="query_predefined" datasource="#dsn3#" result="result_predefined">
                    UPDATE [TEXTILE_PRODUCTION_OPERATION_MAIN]
                    set 
                         [AMOUNT]=<cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.amount#'>,
                         UPDATE_EMP=#session.ep.userid#,
                         UPDATE_DATE=#now()#,
                         IS_SEND=#arguments.page_type#,
                         MARJ=#arguments.marj#
                    where
                        MAIN_OPERATION_ID=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.main_operation_id#'>
            </cfquery>
        <cfset sayac=0>
        <cfloop list="#arguments.proclist#" index="p">
            <cfset sayac=sayac+1>
                    <cfquery name="get_op" datasource="#dsn3#">
                        select *from TEXTILE_PRODUCTION_OPERATION
                        where 
                            MAIN_OPERATION_ID=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.main_operation_id#'>
                            AND [OPERATION_TYPE_ID]=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#p#'>
                    </cfquery> 
                    <cfif get_op.recordcount> 
                        <cfquery name="query_predefined_row" datasource="#dsn3#">
                        UPDATE [TEXTILE_PRODUCTION_OPERATION]
                        SET
                        MAIN_OPERATION_ID=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.main_operation_id#'>
                                <cfif IsDefined("arguments.p_order_id") and len(arguments.p_order_id)>,[P_ORDER_ID]=#arguments.p_order_id#</cfif>
                                <cfif IsDefined("arguments.amount") and len(arguments.amount)>,AMOUNT=#arguments.amount#</cfif>
                                <cfif IsDefined("arguments.stage_id") and len(arguments.stage_id)>,[STAGE]=#arguments.stage_id#</cfif>
                                ,UPDATE_EMP=#session.ep.userid#
                                ,UPDATE_DATE=#now()#
                                ,LINE=#sayac#
                                ,MARJ=#arguments.marj#
                                ,IS_FINISH_LINE=<cfif sayac eq ListLen(arguments.proclist)>1<cfelse>0</cfif>
                            where
                                MAIN_OPERATION_ID=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.main_operation_id#'>
                                AND [OPERATION_TYPE_ID]=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#p#'>
                        </cfquery>
                    <cfelse>
                            <cfquery name="query_predefined_row" datasource="#dsn3#">
                                        INSERT INTO [TEXTILE_PRODUCTION_OPERATION]
                                        (
                                            [REQUEST_ID]
                                            ,[P_ORDER_ID]
                                            ,[AMOUNT]
                                            ,[STATION_ID]
                                            ,[OPERATION_TYPE_ID]
                                            ,[STAGE]
                                            ,[RECORD_EMP]
                                            ,[RECORD_DATE]
                                            ,[MAIN_OPERATION_ID]
                                            ,LINE
                                            ,MARJ
                                            ,IS_FINISH_LINE
                                        )
                                        VALUES
                                                (
                                                <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>
                                                ,<cfif IsDefined("arguments.p_order_id") and len(arguments.p_order_id)>#arguments.p_order_id#<cfelse>NULL</cfif>
                                                ,<cfif IsDefined("arguments.amount") and len(arguments.amount)>#arguments.amount#<cfelse>NULL</cfif>
                                                ,<cfif IsDefined("arguments.station_id") and len(arguments.station_id)>#arguments.station_id#<cfelse>NULL</cfif>
                                                ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#p#'>
                                                ,<cfif IsDefined("arguments.stage_id") and len(arguments.stage_id)>#arguments.stage_id#<cfelse>NULL</cfif>
                                                ,#session.ep.userid#
                                                ,#now()#
                                                ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.main_operation_id#'>
                                                ,#sayac#
                                                ,#arguments.marj#
                                                ,<cfif sayac eq ListLen(arguments.proclist)>1<cfelse>0</cfif>
                                            )
                            </cfquery>
                    </cfif>
        </cfloop>
    </cftransaction> 
    
    </cffunction>

    <cffunction name="get_predefined_rows" access="public" returntype="query">
        <cfargument name="dsn3" type="string">
        <cfargument name="main_operation_id" type="any" default="">
        <cfquery name="query_predefined_rows" datasource="#dsn3#">			
				select 
					TEXTILE_PRODUCTION_OPERATION.*,
					OPERATION_TYPES.OPERATION_TYPE
				from 
					#arguments.dsn3#.TEXTILE_PRODUCTION_OPERATION,
					#arguments.dsn3#.OPERATION_TYPES
				WHERE
					TEXTILE_PRODUCTION_OPERATION.OPERATION_TYPE_ID=OPERATION_TYPES.OPERATION_TYPE_ID
                    <cfif len(arguments.main_operation_id)>
                        AND TEXTILE_PRODUCTION_OPERATION.MAIN_OPERATION_ID=#arguments.main_operation_id#
                    </cfif>
                    order BY LINE
        </cfquery>
        <cfreturn query_predefined_rows>
    </cffunction>

    <cffunction name="insert_predefined_row" access="public">
        <cfargument name="main_operation_id" type="any">
        <cfargument name="operation_type_id" type="any">
		<cfargument name="req_id" type="any">
		<cfargument name="amount" type="any">
        <cfquery name="query_predefined_row" datasource="#dsn3#">
           <!--- INSERT INTO #predefined_row_table#(PREDEFINED_ID, STATION_ID) VALUES(<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.PREDEFINED_ID#'>, <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#STATION_ID#'>)--->
			INSERT INTO [TEXTILE_PRODUCTION_OPERATION]
           (
			   [REQUEST_ID]
			   ,[P_ORDER_ID]
			   ,[AMOUNT]
			   ,[STATION_ID]
			   ,[OPERATION_TYPE_ID]
			   ,[STAGE]
			   ,[RECORD_EMP]
			   ,[RECORD_DATE]
			   ,[MAIN_OPERATION_ID]
		)
		 VALUES
			   (
			   #arguments.req_id#
			   ,<cfif IsDefined("arguments.p_order_id") and len(arguments.p_order_id)>#arguments.p_order_id#<cfelse>NULL</cfif>
			   ,<cfif IsDefined("arguments.amount") and len(arguments.amount)>#arguments.amount#<cfelse>NULL</cfif>
			   ,<cfif IsDefined("arguments.station_id") and len(arguments.station_id)>#arguments.station_id#<cfelse>NULL</cfif>
			   ,<cfif IsDefined("arguments.operation_type_id") and len(arguments.operation_type_id)>#arguments.operation_type_id#<cfelse>NULL</cfif>
			   ,<cfif IsDefined("arguments.stage_id") and len(arguments.stage_id)>#arguments.stage_id#<cfelse>NULL</cfif>
			   ,#session.ep.userid#
			   ,#now()#
			   ,1<!----#arguments.main_operation_id#--->
		   )
		</cfquery>
    </cffunction>

    <cffunction name="upate_predefined_row" access="public">
        <cfargument name="PREDEFINED_ROW_ID" type="numeric">
        <cfargument name="PREDEFINED_ID" type="numeric">
        <cfargument name="STATION_ID" type="numeric">
        <cfquery name="query_predefined_row" datasource="#dsn3#">
            UPDATE #predefined_row_table# SET PREDEFINED_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.PREDEFINED_ID#'>, STATION_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.STATION_ID#'> WHERE PREDEFINED_ROW_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.PREDEFINED_ROW_ID#'>
        </cfquery>
    </cffunction>

    <cffunction name="clear_predefined_rows" access="public">
        <cfargument name="main_operation_id" type="any">
        <cfquery name="query_predefined_row" datasource="#dsn3#">
            DELETE FROM TEXTILE_PRODUCTION_OPERATION WHERE MAIN_OPERATION_ID = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.main_operation_id#'>
        </cfquery>
    </cffunction>
    <cffunction name="clear_predefined" access="public">
        <cfargument name="main_operation_id" type="any">
        <cftransaction>
            <cfquery name="query_predefined_row" datasource="#dsn3#">
                DELETE FROM TEXTILE_PRODUCTION_OPERATION WHERE MAIN_OPERATION_ID = <cfqueryparam cfsqltype='CF_SQL_INT' value='#arguments.main_operation_id#'>
            </cfquery>
            <cfquery name="query_predefined" datasource="#dsn3#">
                DELETE FROM TEXTILE_PRODUCTION_OPERATION_MAIN WHERE MAIN_OPERATION_ID = <cfqueryparam cfsqltype='CF_SQL_INT' value='#arguments.main_operation_id#'>
            </cfquery>
        </cftransaction>
    </cffunction>
    <cffunction name="get_operation_row_detail" returntype="query">
        <cfargument name="main_operation_id" type="any">
        <cfargument name="operation_type_id" type="any">
        <cfargument name="p_operation_id" type="any">
        <cfargument name="line" type="any">
		<cfargument name="req_id" type="any">
        <cfargument name="amount" type="any">
    

        <cfif len(arguments.line) and arguments.line gt 1><cfset previous=arguments.line-1><cfelseif len(arguments.line) and arguments.line eq 1><cfset previous=arguments.line></cfif>
        

		<cfquery name="get_row_detail" datasource="#DSN3#">
					select
						TEXTILE_SAMPLE_REQUEST.*,
						ORDERS.*,
						TEXTILE_PRODUCTION_OPERATION_MAIN.*,
						TEXTILE_PRODUCTION_OPERATION.*,
						PRODUCT_UNIT.*,
						PRODUCT.*,
						0 IS_STAGE,
						OPERATION_TYPES.OPERATION_TYPE,
                        RENK.PROPERTY_DETAIL AS RENK_,
				        BEDEN.PROPERTY_DETAIL AS BEDEN_,
				        BOY.PROPERTY_DETAIL AS BOY_,
                        STOCKS.PROPERTY, 
                        CASE WHEN STOCKS.STOCK_CODE = '' THEN '_' ELSE ISNULL(STOCKS.STOCK_CODE,'_') END AS STOCK_CODE,
                        ORR.UNIT2,
                        ORR.AMOUNT2,
						ORR.AMOUNT2,
						ORR.QUANTITY ORDER_ROW_AMOUNT,
                        ORR.ORDER_ROW_ID,
                        ORR.DELIVER_DATE AS ROW_DELIVER_DATE,
                        STOCKS.STOCK_ID,
                        STOCKS.PRODUCT_NAME,				
                        STOCKS.STOCK_CODE_2,
                        ISNULL(RESULT_.ORDER_AMOUNT,0) ORDER_AMOUNT,
                        ISNULL(RESULT_.RESULT_AMOUNT,0) RESULT_AMOUNT,
                        ISNULL(RESULT_PREVIOUS.ORDER_AMOUNT,0) PREVIOUS_ORDER_AMOUNT,
                        ISNULL(RESULT_PREVIOUS.RESULT_AMOUNT,0) PREVIOUS_RESULT_AMOUNT,
                        TEXTILE_PRODUCTION_OPERATION.LINE AS THIS_LINE,
                        RESULT_PREVIOUS.OPERATION_TYPE_ID AS PREVIOUS_OPERATION_TYPE_ID
					from 
						TEXTILE_SAMPLE_REQUEST
						JOIN TEXTILE_PRODUCTION_OPERATION_MAIN ON TEXTILE_PRODUCTION_OPERATION_MAIN.REQUEST_ID=TEXTILE_SAMPLE_REQUEST.REQ_ID
						JOIN TEXTILE_PRODUCTION_OPERATION ON TEXTILE_PRODUCTION_OPERATION_MAIN.MAIN_OPERATION_ID=TEXTILE_PRODUCTION_OPERATION.MAIN_OPERATION_ID
						JOIN OPERATION_TYPES ON OPERATION_TYPES.OPERATION_TYPE_ID=TEXTILE_PRODUCTION_OPERATION.OPERATION_TYPE_ID
						JOIN ORDERS ON ORDERS.ORDER_ID=TEXTILE_PRODUCTION_OPERATION_MAIN.ORDER_ID
                        JOIN ORDER_ROW ORR ON ORDERS.ORDER_ID=ORR.ORDER_ID
                        JOIN STOCKS ON STOCKS.STOCK_ID=ORR.STOCK_ID
                        OUTER APPLY(
                            select 
                                SUM(ISNULL(PRODUCTION_ORDERS.QUANTITY,0)) ORDER_AMOUNT,
                                SUM(ISNULL(PRODUCTION_ORDER_RESULTS_ROW.AMOUNT,0)) RESULT_AMOUNT
                            from 
                                PRODUCTION_ORDERS_ROW,
                                PRODUCTION_ORDERS
                                LEFT JOIN PRODUCTION_ORDER_RESULTS_ROW ON PRODUCTION_ORDER_RESULTS_ROW.P_ORDER_ID=PRODUCTION_ORDERS.P_ORDER_ID AND PRODUCTION_ORDER_RESULTS_ROW.TYPE=1
                            where
                                PRODUCTION_ORDERS.P_ORDER_ID=PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
                                AND PRODUCTION_ORDERS_ROW.ORDER_ROW_ID=ORR.ORDER_ROW_ID
                                AND PRODUCTION_ORDERS_ROW.PLAN_ID=TEXTILE_PRODUCTION_OPERATION.P_OPERATION_ID
                                AND PRODUCTION_ORDERS_ROW.ORDER_ID=ORDERS.ORDER_ID
                        ) AS RESULT_
                        OUTER APPLY(
                            select 
                                SUM(ISNULL(PRODUCTION_ORDERS.QUANTITY,0)) ORDER_AMOUNT,
                                SUM(ISNULL(PRODUCTION_ORDER_RESULTS_ROW.AMOUNT,0)) RESULT_AMOUNT,
                                TPOP.OPERATION_TYPE_ID
                            from 
                                PRODUCTION_ORDERS_ROW,
                                PRODUCTION_ORDERS
            LEFT JOIN PRODUCTION_ORDER_RESULTS_ROW ON PRODUCTION_ORDER_RESULTS_ROW.P_ORDER_ID=PRODUCTION_ORDERS.P_ORDER_ID AND PRODUCTION_ORDER_RESULTS_ROW.TYPE=1
                                ,TEXTILE_PRODUCTION_OPERATION TPOP
                            where
                                PRODUCTION_ORDERS.P_ORDER_ID=PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
                                AND PRODUCTION_ORDERS_ROW.ORDER_ROW_ID=ORR.ORDER_ROW_ID
                                AND PRODUCTION_ORDERS_ROW.ORDER_ID=ORDERS.ORDER_ID
                                AND PRODUCTION_ORDERS_ROW.PLAN_ID=TPOP.P_OPERATION_ID
                                AND TPOP.MAIN_OPERATION_ID=TEXTILE_PRODUCTION_OPERATION.MAIN_OPERATION_ID
                                AND TPOP.LINE=#previous#
                            GROUP BY
                            TPOP.OPERATION_TYPE_ID
                        ) AS RESULT_PREVIOUS
                        OUTER APPLY
                                (
                                    SELECT 
                                        PRP.PROPERTY_ID,PRP.PROPERTY,PRP.PROPERTY_SIZE,PRP.PROPERTY_CODE,PRP.IS_ACTIVE,
                                        PPD.PROPERTY_DETAIL,PPD.PROPERTY_DETAIL_ID ,PPD.PRPT_ID
                                    FROM
                                        #dsn1#.PRODUCT_PROPERTY_DETAIL PPD,
                                        #dsn1#.PRODUCT_PROPERTY PRP,
                                        STOCKS_PROPERTY SP
                                    WHERE
                                        PRP.PROPERTY_ID = PPD.PRPT_ID AND
                                        SP.PROPERTY_DETAIL_ID = PPD.PROPERTY_DETAIL_ID AND 
                                        PRP.PROPERTY_COLOR = 1 AND 
                                        SP.STOCK_ID = STOCKS.STOCK_ID 
                                ) AS RENK
                                OUTER APPLY
                                (
                                    SELECT 
                                        PRP.PROPERTY_ID,PRP.PROPERTY,PRP.PROPERTY_SIZE,PRP.PROPERTY_CODE,PRP.IS_ACTIVE,
                                        PPD.PROPERTY_DETAIL,PPD.PROPERTY_DETAIL_ID ,PPD.PRPT_ID
                                    FROM
                                        #dsn1#.PRODUCT_PROPERTY_DETAIL PPD,
                                        #dsn1#.PRODUCT_PROPERTY PRP,
                                        STOCKS_PROPERTY SP
                                    WHERE
                                        PRP.PROPERTY_ID = PPD.PRPT_ID AND
                                        SP.PROPERTY_DETAIL_ID = PPD.PROPERTY_DETAIL_ID AND 
                                        PRP.PROPERTY_SIZE = 1 AND 
                                        SP.STOCK_ID = STOCKS.STOCK_ID 
                                ) AS BEDEN
                                OUTER APPLY
                                (
                                    SELECT 
                                        PRP.PROPERTY_ID,PRP.PROPERTY,PRP.PROPERTY_SIZE,PRP.PROPERTY_CODE,PRP.IS_ACTIVE,
                                        PPD.PROPERTY_DETAIL,PPD.PROPERTY_DETAIL_ID ,PPD.PRPT_ID
                                    FROM
                                        #dsn1#.PRODUCT_PROPERTY_DETAIL PPD,
                                        #dsn1#.PRODUCT_PROPERTY PRP,
                                        STOCKS_PROPERTY SP
                                    WHERE
                                        PRP.PROPERTY_ID = PPD.PRPT_ID AND
                                        SP.PROPERTY_DETAIL_ID = PPD.PROPERTY_DETAIL_ID AND 
                                        PRP.PROPERTY_LEN = 1 AND 
                                        SP.STOCK_ID = STOCKS.STOCK_ID 
                                ) AS Boy
						JOIN PRODUCT ON PRODUCT.PRODUCT_ID=TEXTILE_SAMPLE_REQUEST.PRODUCT_ID
						JOIN PRODUCT_UNIT ON PRODUCT.PRODUCT_ID=PRODUCT_UNIT.PRODUCT_ID
                    WHERE
                        TEXTILE_PRODUCTION_OPERATION_MAIN.MAIN_OPERATION_ID=#arguments.main_operation_id# AND
                        TEXTILE_PRODUCTION_OPERATION.OPERATION_TYPE_ID=#arguments.operation_type_id# AND
                        TEXTILE_PRODUCTION_OPERATION.P_OPERATION_ID=#arguments.p_operation_id# AND
                        ORR.ORDER_ROW_CURRENCY = -5

		</cfquery>
		<cfreturn get_row_detail>
    </cffunction>
    <cffunction name="getOperationMain" returntype="query">
        <cfargument name="product_id" default="">
        <cfargument name="product_name" default="">
        <cfargument name="related_product_id" default="">
		<cfargument name="related_stock_id" default="">
		<cfargument name="related_product_name" default="">
		<cfargument name="production_stage" default="">
		<cfargument name="position_code" default="">
		<cfargument name="position_name" default="">
		<cfargument name="product_cat" default="">
        <cfargument name="product_cat_code" default="">
		<cfargument name="product_catid" default="">
		<cfargument name="spect_main_id" default="">
		<cfargument name="spect_name" default="">
		<cfargument name="short_code_id" default="">
		<cfargument name="short_code_name" default="">
		<cfargument name="keyword" default="">
		<cfargument name="result" default="">
		<cfargument name="sales_partner" default="">
		<cfargument name="sales_partner_id" default="">
		<cfargument name="order_employee" default="">
		<cfargument name="order_employee_id" default="">
		<cfargument name="project_head" default="">
		<cfargument name="project_id" default="">
		<cfargument name="member_type" default="">
		<cfargument name="member_name" default="">
		<cfargument name="company_id" default="">
		<cfargument name="consumer_id" default="">
		<cfargument name="status" default="">
		<cfargument name="fuseaction_" default="">
		<cfargument name="is_show_result_amount" default="">
		<cfargument name="operation_type_id" default="">
		<cfargument name="operation_type" default="">
		<cfargument name="station_id" default="">
		<cfargument name="authority_station_id_list" default="">
		<cfargument name="related_orders" default="">
        <cfargument name="station_list" default="">
        <cfargument name="opplist" default="">
        <cfargument name="startrow" default="">
        <cfargument name="maxrows" default="">
        <cfargument name="start_date" default="">
		<cfargument name="start_date_2" default="">
		<cfargument name="finish_date" default="">
		<cfargument name="finish_date_2" default="">
		<cfargument name="prod_order_stage" default="">
		<cfargument name="oby" default="">
        <cfargument name="P_ORDER_NO1" default="">
        <cfargument name="DEMAND_NO1" default="">
        <cfargument name="LOT_NO1" default="">
        <cfargument name="REQ_NO1" default="">
        <cfargument name="REFERENCE_NO1" default="">
        <cfargument name="ORDER_NUMBER1" default="">
        <cfargument name="PRODUCT_NAME1" default="">
        <cfargument name="is_excel" default="">
        <cfargument name="sample_request_ids" default="">
        
        <cfif len(arguments.P_ORDER_NO1) or len(arguments.DEMAND_NO1) or len(arguments.LOT_NO1) or len(arguments.REFERENCE_NO1) or len(arguments.ORDER_NUMBER1) or len(arguments.PRODUCT_NAME1) >
        
		<cfelse>
        	<cfset arguments.P_ORDER_NO1 = 1 >
            <cfset arguments.DEMAND_NO1 = 1 >
            <cfset arguments.LOT_NO1 = 1 >
            <cfset arguments.REQ_NO1 = 1 >
            <cfset arguments.REFERENCE_NO1 = 1 >
            <cfset arguments.ORDER_NUMBER1 = 1 >
            <cfset arguments.PRODUCT_NAME1 = 1 >
        </cfif>
		<cfquery name="get_operation_main" datasource="#this.DSN3#">
					select
						TEXTILE_SAMPLE_REQUEST.*,
						ORDERS.*,
                        TEXTILE_PRODUCTION_OPERATION.*,
						TEXTILE_PRODUCTION_OPERATION_MAIN.*,
						PRODUCT_UNIT.*,
						PRODUCT.*,
						0 IS_STAGE,
						OPERATION_TYPES.OPERATION_TYPE,
                        ISNULL(RESULT_.ORDER_AMOUNT,0) ORDER_AMOUNT,
                        ISNULL(RESULT_.RESULT_AMOUNT,0) RESULT_AMOUNT,
                        PRO_PROJECTS.PROJECT_HEAD,
                        ASSET.ASSET_ID,
					    ASSET.ASSETCAT_ID,
					    ASSET.ASSET_FILE_NAME
					from 
						TEXTILE_SAMPLE_REQUEST
						JOIN TEXTILE_PRODUCTION_OPERATION_MAIN ON TEXTILE_PRODUCTION_OPERATION_MAIN.REQUEST_ID=TEXTILE_SAMPLE_REQUEST.REQ_ID
						JOIN TEXTILE_PRODUCTION_OPERATION ON TEXTILE_PRODUCTION_OPERATION_MAIN.MAIN_OPERATION_ID=TEXTILE_PRODUCTION_OPERATION.MAIN_OPERATION_ID
						JOIN OPERATION_TYPES ON OPERATION_TYPES.OPERATION_TYPE_ID=TEXTILE_PRODUCTION_OPERATION.OPERATION_TYPE_ID
						JOIN ORDERS ON ORDERS.ORDER_ID=TEXTILE_PRODUCTION_OPERATION_MAIN.ORDER_ID
						JOIN PRODUCT ON PRODUCT.PRODUCT_ID=TEXTILE_SAMPLE_REQUEST.PRODUCT_ID
						JOIN PRODUCT_UNIT ON PRODUCT.PRODUCT_ID=PRODUCT_UNIT.PRODUCT_ID
                        OUTER APPLY(
                            select 
                                SUM(ISNULL(PRODUCTION_ORDERS.QUANTITY,0)) ORDER_AMOUNT,
                                SUM(ISNULL(PRODUCTION_ORDER_RESULTS_ROW.AMOUNT,0)) RESULT_AMOUNT
                            from 
                                PRODUCTION_ORDERS_ROW,
                                PRODUCTION_ORDERS
                                LEFT JOIN PRODUCTION_ORDER_RESULTS_ROW ON PRODUCTION_ORDER_RESULTS_ROW.P_ORDER_ID=PRODUCTION_ORDERS.P_ORDER_ID AND PRODUCTION_ORDER_RESULTS_ROW.TYPE=1
                            where
                                PRODUCTION_ORDERS.P_ORDER_ID=PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
                                AND PRODUCTION_ORDERS_ROW.PLAN_ID=TEXTILE_PRODUCTION_OPERATION.P_OPERATION_ID
                                AND PRODUCTION_ORDERS_ROW.ORDER_ID=ORDERS.ORDER_ID
                        ) AS RESULT_
                        OUTER APPLY(
                            select
                                TOP 1 
                                ASSET_ID,
                                ASSETCAT_ID,
                                ASSET_FILE_NAME
                            FROM
                                #DSN#.ASSET
                                where
                                    ACTION_SECTION='REQ_ID' AND 
                                    ACTION_ID=TEXTILE_SAMPLE_REQUEST.REQ_ID AND
                                    IS_IMAGE=1 AND
                                    MODULE_NAME='textile'
                                    ORDER BY ASSET_ID
                        ) ASSET
                        LEFT JOIN #dsn#.PRO_PROJECTS ON PRO_PROJECTS.PROJECT_ID=ORDERS.PROJECT_ID
                    where
                         TEXTILE_PRODUCTION_OPERATION_MAIN.IS_SEND=1
                         <cfif len(arguments.sample_request_ids)>
                            AND TEXTILE_SAMPLE_REQUEST.REQ_ID IN (#arguments.sample_request_ids#)
                        </cfif>
                         <cfif isdefined('arguments.result') and len(arguments.result)>
							<cfif arguments.result eq 1>
								and RESULT_.RESULT_AMOUNT>0
							<cfelseif arguments.result eq 0>
								and ISNULL(RESULT_.RESULT_AMOUNT,0)<=0
							</cfif>
                         </cfif>
                         <cfif len(arguments.product_id) and len(arguments.product_name)>
                		AND PRODUCT.PRODUCT_ID = #arguments.product_id#
                    </cfif>
					<!---<cfif isdefined("arguments.related_product_id") and len(arguments.related_stock_id) and len(arguments.related_product_id) and len(arguments.related_product_name)>
						AND (
							TEXTILE_PRODUCTION_OPERATION_MAIN.PARTY_ID IN (
												SELECT PRODUCTION_ORDERS.PARTY_ID 
												FROM 
														PRODUCTION_ORDERS_STOCKS,
														PRODUCTION_ORDERS
												WHERE 
												PRODUCTION_ORDERS_STOCKS.P_ORDER_ID=PRODUCTION_ORDERS.P_ORDER_ID AND
												PRODUCTION_ORDERS_STOCKS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.related_stock_id#">
										)
						)
						
					</cfif>--->
					<cfif isDefined("arguments.position_code") and len(arguments.position_code) and len(arguments.position_name)>
						AND PRODUCT.PRODUCT_CATID IN(SELECT 
														PC2.PRODUCT_CATID
													FROM 
														PRODUCT_CAT PC1,
														PRODUCT_CAT PC2 
													WHERE 
														PC1.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">
														AND (PC2.HIERARCHY LIKE PC1.HIERARCHY+'.%' OR PC1.HIERARCHY LIKE PC2.HIERARCHY+'.%' OR PC1.PRODUCT_CATID=PC2.PRODUCT_CATID)
													)
					</cfif>
					<cfif isdefined('arguments.product_cat') and  len(arguments.product_cat) and len(arguments.product_catid)>
						AND PRODUCT.PRODUCT_CATID IN(SELECT 
														PC1.PRODUCT_CATID
													FROM 
														PRODUCT_CAT PC1,
														PRODUCT_CAT PC2 
													WHERE 
														PC2.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_catid#">
														AND (PC2.HIERARCHY LIKE PC1.HIERARCHY+'.%' OR PC1.HIERARCHY LIKE PC2.HIERARCHY+'.%' OR PC1.PRODUCT_CATID=PC2.PRODUCT_CATID)
													)
					</cfif>
					<cfif isdefined('arguments.spect_main_id') and isdefined('arguments.spect_name') and len(arguments.spect_name)>
						AND 
						TEXTILE_PRODUCTION_OPERATION_MAIN.ORDER_ID IN (
							SELECT ORDER_ID FROM ORDER_ROW
							ORDER_ROW.SPECT_VAR_ID IN(SELECT SPECT_VAR_ID FROM SPECTS WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.spect_main_id#">)
							AND ORDER_ROW.ORDER_ID=TEXTILE_PRODUCTION_OPERATION_MAIN.ORDER_ID						
						)
					</cfif>
					<cfif isdefined("arguments.short_code_id") and len(arguments.short_code_id) and len(arguments.short_code_name)>
						AND	PRODUCT.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.short_code_id#">
                    </cfif>
                    <cfif isdefined('arguments.sales_partner') and len(arguments.sales_partner) and len(arguments.sales_partner_id)>
						AND TEXTILE_PRODUCTION_OPERATION_MAIN.ORDER_ID IN(
											SELECT 
											   ORDER_ID
											FROM
												ORDERS
											WHERE
                                                ORDERS.ORDER_ID=TEXTILE_PRODUCTION_OPERATION_MAIN.ORDER_ID
												AND ORDERS.SALES_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sales_partner_id#">
										)			
					</cfif>
					<cfif isdefined('arguments.order_employee') and len(arguments.order_employee) and len(arguments.order_employee_id)>
						AND TEXTILE_PRODUCTION_OPERATION_MAIN.ORDER_ID  IN(
											SELECT 
                                                ORDER_ID
											FROM
												ORDERS
											WHERE
												ORDERS.ORDER_ID=TEXTILE_PRODUCTION_OPERATION_MAIN.ORDER_ID
												AND ORDERS.ORDER_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_employee_id#">
										)		
					</cfif>
					<cfif isdefined('arguments.project_head') and len(arguments.project_head) and len(arguments.project_id)>
						AND TEXTILE_PRODUCTION_OPERATION_MAIN.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
					</cfif>
					<cfif isdefined("arguments.member_type") and (arguments.member_type is 'partner') and len(arguments.member_name) and len(arguments.company_id)>
						AND TEXTILE_PRODUCTION_OPERATION_MAIN.ORDER_ID IN(
											SELECT 
                                                ORDER_ID
											FROM
												ORDERS
											WHERE
                                                ORDERS.ORDER_ID=TEXTILE_PRODUCTION_OPERATION_MAIN.ORDER_ID
												AND ORDERS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
										)
					</cfif>
					<cfif isdefined("arguments.member_type") and (arguments.member_type is 'consumer') and len(arguments.member_name) and len(arguments.consumer_id)>
						AND TEXTILE_PRODUCTION_OPERATION_MAIN.ORDER_ID IN(
											SELECT 
                                                ORDER_ID
											FROM
												ORDERS
											WHERE
                                                ORDERS.ORDER_ID=TEXTILE_PRODUCTION_OPERATION_MAIN.ORDER_ID
												AND ORDERS.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
										)
                    </cfif>
                    <cfif isdefined('arguments.opplist') and len(arguments.opplist)>
				        and OPERATION_TYPES.OPERATION_TYPE_ID IN(#arguments.opplist#)
                    </cfif>

                    
                    
                            <cfif isdefined('arguments.start_date') and isdate(arguments.start_date)>
                                AND ORDER_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
                            </cfif>
                            <cfif isdefined('arguments.start_date_2') and isdate(arguments.start_date_2)>
                                AND ORDER_DATE < #DATEADD('d',1,arguments.start_date_2)#
                            </cfif>
                    <cfif isdefined('arguments.station_id') and len(arguments.station_id)>
                            AND TEXTILE_PRODUCTION_OPERATION.P_OPERATION_ID
                                IN(
                                    SELECT P_OPERATION_ID FROM TEXTILE_PRODUCTION_ORDERS_MAIN
                                    WHERE 
                                        MAIN_OPERATION_ID=TEXTILE_PRODUCTION_OPERATION_MAIN.MAIN_OPERATION_ID AND
                                        STATION_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.station_id#">
                                )
				
					</cfif>
				<cfif isdefined('arguments.prod_order_stage') and len(arguments.prod_order_stage)>
				AND PROD_ORDER_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prod_order_stage#">
				</cfif>
                         <cfif isdefined('arguments.keyword') and len(arguments.keyword)>         
                                        <cfif ListLen(arguments.keyword,',') gt 1>
                                            AND
                                            (
                                            <cfset p_sayac = 0>
                                            <cfloop list="#arguments.keyword#" delimiters="," index="p_or_no">
                                            <cfset p_sayac = p_sayac+1>
                                            ( <!---PARTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#p_or_no#">  OR---> REQ_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#p_or_no#"> OR LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#p_or_no#">) <cfif ListLen(arguments.keyword,',') gt p_sayac>OR </cfif>
                                            </cfloop>
                                            )
                                        <cfelse><!--- tek bir tane ise like ile baksın.. --->
                                            AND 
                                            (
                                                (1=2)   
                                               <!--- <cfif len(arguments.P_ORDER_NO1)>
                                                    OR
                                                    (PARTY_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">) 
                                                </cfif>--->
                                                <cfif len(arguments.REQ_NO1)>
                                                    OR 
                                                    (REQ_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">) 
                                                </cfif>
                                                <cfif len(arguments.REFERENCE_NO1)>
                                                    OR 
                                                    (REF_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)
                                                </cfif>
                                                <cfif len(arguments.LOT_NO1)>
                                                    OR
                                                    (LOT_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)
                                                </cfif>
                                                <cfif len(arguments.ORDER_NUMBER1)>
                                                    OR
                                                    (
                                                        ORDERS.ORDER_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                                                     )
                                                </cfif>
                                                <cfif len(arguments.PRODUCT_NAME1)>
                                                    OR
                                                    (PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)
                                                </cfif>
                                            
                                            )
                                    </cfif>
                                </cfif>
						ORDER BY
						<cfif arguments.oby eq 1>
								ORDERS.ORDER_NUMBER DESC
						<cfelseif arguments.oby eq 2>
								ORDERS.ORDER_NUMBER
						<cfelseif arguments.oby eq 3>
								ORDERS.ORDER_DATE DESC
						<cfelseif arguments.oby eq 4>
								ORDERS.ORDER_DATE
						<cfelse>
								ORDERS.ORDER_NUMBER DESC
						</cfif>
					
		</cfquery>
		<cfreturn get_operation_main>
    </cffunction>
    <cffunction name="getWorkStation" returntype="query">
		<cfargument name="local" default="">
                <cfquery name="GET_W" datasource="#dsn#">
                    SELECT 
                        STATION_ID,
                        STATION_NAME,
                        ISNULL(EXIT_DEP_ID,0) AS EXIT_DEP_ID,
                        ISNULL(EXIT_LOC_ID,0) AS EXIT_LOC_ID,
                        ISNULL(PRODUCTION_DEP_ID,0) AS PRODUCTION_DEP_ID,
                        ISNULL(PRODUCTION_LOC_ID,0) AS PRODUCTION_LOC_ID
                    FROM 
                        #dsn3#.WORKSTATIONS 
                    WHERE 
                        DEPARTMENT IN (SELECT DEPARTMENT.DEPARTMENT_ID FROM DEPARTMENT,EMPLOYEE_POSITION_BRANCHES WHERE DEPARTMENT.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID AND EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# ) 
						<cfif arguments.local eq 1>
							AND OUTSOURCE_PARTNER IS NOT NULL
						<cfelseif arguments.local eq 2>
							AND OUTSOURCE_PARTNER IS NULL
						</cfif>
                    ORDER BY 
                        STATION_NAME ASC
                </cfquery>
                <cfreturn GET_W>
  </cffunction>

</cfcomponent>