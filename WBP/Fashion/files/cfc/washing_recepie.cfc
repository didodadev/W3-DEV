<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn3="#dsn#_#session.ep.company_id#">
	<cfset dsn1="#dsn#_product">
    <cfset dsn2="#dsn#_#session.ep.period_year#_#session.ep.company_id#">

    <cffunction name="list_recepie_head" access="public">
        <cfargument name="employee_id">
        <cfargument name="station_id">
        <cfargument name="start_date">
        <cfargument name="finish_date">
        <cfargument name="result_id">
        <cfquery name="query_list_recepie_head" datasource="#dsn3#">
            SELECT head.*, wrk.STATION_NAME, rsl.RESULT_NO, pps.PROJECT_HEAD
            FROM TEXTILE_WASHING_RECEPIE_HEAD head 
            LEFT JOIN PRODUCTION_ORDER_RESULTS rsl ON head.RESULT_ID = rsl.PR_ORDER_ID
            LEFT JOIN WORKSTATIONS wrk ON head.STATION_ID = wrk.STATION_ID
            LEFT JOIN #dsn#.PRO_PROJECTS pps ON head.PROJECT_ID = pps.PROJECT_ID
            WHERE 1=1
            <cfif isDefined('arguments.employee_id') and len(arguments.employee_id)>
                AND head.EMPLOYEE_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.employee_id#'>
            </cfif>
            <cfif isDefined('arguments.station_id') and len(arguments.station_id)>
                AND head.STATION_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.station_id#'>
            </cfif>
            <cfif isDefined('arguments.result_id') and len(arguments.result_id)>
                AND head.RESULT_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.result_id#'>
            </cfif>
            <cfif isDefined('arguments.start_date') and len(arguments.start_date)>
                AND head.RECORD_DATE >= <cfqueryparam cfsqltype='CF_SQL_DATE' value='#arguments.start_date#'>
            </cfif>
            <cfif isDefined('arguments.finish_date') and len(arguments.finish_date)>
                AND head.RECORD_DATE <= dateAdd('d', 1, <cfqueryparam cfsqltype='CF_SQL_DATE' value='#arguments.finish_date#'>)
            </cfif>
        </cfquery>
        <cfreturn query_list_recepie_head>
    </cffunction>

    <cffunction name="simple_recepie_head" access="public">
        <cfargument name="term">
        <cfquery name="query_simple_recepie_head" datasource="#dsn3#">
            SELECT WASHING_RECEPIE_ID FROM TEXTILE_WASHING_RECEPIE_HEAD
        </cfquery>
        <cfreturn query_simple_recepie_head>
    </cffunction>

    <cffunction name="get_recepie_head" access="public">
        <cfargument name="washing_recepie_id">
        <cfquery name="query_get_recepie_head" datasource="#dsn3#">
            SELECT head.*, wrk.STATION_NAME, rsl.RESULT_NO, CONCAT(emp.EMPLOYEE_NAME, ' ', emp.EMPLOYEE_SURNAME) AS EMP_NAME, pps.PROJECT_HEAD
            FROM TEXTILE_WASHING_RECEPIE_HEAD head 
            LEFT JOIN PRODUCTION_ORDER_RESULTS rsl ON head.RESULT_ID = rsl.PR_ORDER_ID
            LEFT JOIN WORKSTATIONS wrk ON head.STATION_ID = wrk.STATION_ID
            LEFT JOIN #dsn#.EMPLOYEES emp ON head.RECORD_EMP = emp.EMPLOYEE_ID
            LEFT JOIN #dsn#.PRO_PROJECTS pps ON head.PROJECT_ID = pps.PROJECT_ID
            WHERE WASHING_RECEPIE_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.washing_recepie_id#'>
        </cfquery>
        <cfreturn query_get_recepie_head>
    </cffunction>

    <cffunction name="add_recepie_head" access="public">
        <cfargument name="order_no">
        <cfargument name="project_id">
        <cfargument name="station_id">
        <cfargument name="employee_id">
        <cfargument name="result_id">
        <cfargument name="approved">
        <cfargument name="status">
        <cfquery name="query_add_recepie_head" datasource="#dsn3#" result="result_add_recepie_head">
            INSERT INTO TEXTILE_WASHING_RECEPIE_HEAD (
                ORDER_ID, PROJECT_ID, STATION_ID, EMPLOYEE_ID, RESULT_ID, APPROVED, STATUS, RECORD_DATE, RECORD_EMP, RECORD_IP
            ) VALUES (
                <cfif isDefined('arguments.order_no') and len(arguments.order_no)>
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.order_no#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' null='true'>
                </cfif>
                ,<cfif isDefined('arguments.project_id') and len(arguments.project_id)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.project_id#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null='true'>
                </cfif>
                ,<cfif isDefined('arguments.station_id') and len(arguments.station_id)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.station_id#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null='true'>
                </cfif>
                ,<cfif isDefined('arguments.employee_id') and len(arguments.employee_id)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.employee_id#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null='true'>
                </cfif>
                ,<cfif isDefined('arguments.result_id') and len(arguments.result_id)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.result_id#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null='true'>
                </cfif>
                ,<cfif isDefined('arguments.approved') and len(arguments.approved)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.approved#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null='true'>
                </cfif>
                ,<cfif isDefined('arguments.status') and len(arguments.status)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.status#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null='true'>
                </cfif>
                ,#now()#
                ,#session.ep.userid#
                ,'#cgi.REMOTE_ADDR#'
            )
        </cfquery>
        <cfreturn result_add_recepie_head>
    </cffunction>

    <cffunction name="upd_recepie_head" access="public">
        <cfargument name="washing_recepie_id">
        <cfargument name="approved">
        <cfargument name="status">
        <cfquery name="upd_recepie_head" datasource="#dsn3#">
            UPDATE TEXTILE_WASHING_RECEPIE_HEAD SET 
            UPDATE_DATE = #now()#,
            UPDATE_EMP = #session.ep.userid#,
            UPDATE_IP = '#cgi.REMOTE_ADDR#'
            <cfif isDefined("arguments.approved") and len(arguments.approved)>
                ,APPROVED = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.approved#'>
            </cfif>
            <cfif isDefined("arguments.status") and len(arguments.status)>
                ,APPROVED = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.status#'>
            </cfif>
            WHERE WASHING_RECEPIE_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.washing_recepie_id#'>
        </cfquery>
    </cffunction>

    <cffunction name="get_recepie_rows" access="public">
        <cfargument name="washing_recepie_id">
        <cfquery name="query_get_recepie_rows" datasource="#dsn3#">
            SELECT rws.*
            FROM TEXTILE_WASHING_RECEPIE_ROW rws
            WHERE WASHING_RECEPIE_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.washing_recepie_id#'>
        </cfquery>
        <cfreturn query_get_recepie_rows>
    </cffunction>

    <cffunction name="add_recepie_row" access="public">
        <cfargument name="washing_recepie_id">
        <cfargument name="stock_id">
        <cfargument name="amount">
        <cfquery name="query_add_recepie_row" datasource="#dsn3#">
            INSERT INTO TEXTILE_WASHING_RECEPIE_ROW (
                WASHING_RECEPIE_ID, STOCK_ID, AMOUNT
            ) VALUES (
                <cfif isDefined('arguments.washing_recepie_id') and len(arguments.washing_recepie_id)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.washing_recepie_id#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null='true'>
                </cfif>
                ,<cfif isDefined('arguments.stock_id') and len(arguments.stock_id)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.stock_id#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null='true'>
                </cfif>
                ,<cfif isDefined('arguments.amount') and len(arguments.amount)>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#arguments.amount#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null='true'>
                </cfif>
                
            )
        </cfquery>
    </cffunction>

    <cffunction name="copy_recepie_row" access="public">
        <cfargument name="pr_order_id">
        <cfargument name="washing_recepie_id">
        <cfquery name="query_copy_recepie_row" datasource="#dsn3#">
            INSERT INTO TEXTILE_WASHING_RECEPIE_ROW (
                WASHING_RECEPIE_ID, STOCK_ID, AMOUNT, PRODUCT_NAME
            )
            SELECT #arguments.washing_recepie_id# AS idt, r1.STOCK_ID, r1.AMOUNT / SUM(r2.AMOUNT) as AMOUNTS, r1.NAME_PRODUCT
            FROM [PRODUCTION_ORDER_RESULTS_ROW] r1
            LEFT JOIN [PRODUCTION_ORDER_RESULTS_ROW] r2 ON r1.PR_ORDER_ID = r2.PR_ORDER_ID
            WHERE  r1.TYPE = 2 AND 1 = r2.TYPE AND r1.PR_ORDER_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.pr_order_id#'>
            GROUP BY r1.STOCK_ID, r1.AMOUNT, r1.NAME_PRODUCT
        </cfquery>
    </cffunction>

    <cffunction name="copy_recepie_head" access="public">
        <cfargument name="pr_order_id">
        <cfargument name="approved">
        <cfquery name="query_copy_recepie" datasource="#dsn3#">
            SELECT rsl.ORDER_NO AS ORDER_ID, por.PROJECT_ID, rsl.STATION_ID, rsl.PR_ORDER_ID
            FROM PRODUCTION_ORDER_RESULTS rsl
            INNER JOIN PRODUCTION_ORDERS por ON rsl.P_ORDER_ID = por.P_ORDER_ID OR rsl.PARTY_ID = por.PARTY_ID
            WHERE rsl.PR_ORDER_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.pr_order_id#'>
        </cfquery>
        <cfset result = this.add_recepie_head( query_copy_recepie.ORDER_ID, query_copy_recepie.PROJECT_ID, query_copy_recepie.STATION_ID, session.ep.userid, arguments.pr_order_id, arguments.approved, 1 )>
        <cfreturn result>
    </cffunction>

</cfcomponent>