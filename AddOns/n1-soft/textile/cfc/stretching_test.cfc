<cfcomponent>
    <cfproperty name="dsn3" type="string">
    <cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn3="#dsn#_#session.ep.company_id#">
    <cfset dsn2="#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cffunction name="list_stretching_test" access="public" returntype="query">
        <cfargument name="opp_id" default="">
        <cfargument name="project_id" default="">
        <cfargument name="author_id" default="">
        <cfargument name="test_date_start" default="">
        <cfargument name="test_date_end" default="">
        <cfargument name="purchasing_id" default="">
        <cfquery name="query_stretching_test" datasource="#dsn3#">
            SELECT 
				TEXTILE_STRETCHING_TEST.STRETCHING_TEST_ID, 
				TEXTILE_STRETCHING_TEST.TEST_DATE, 
				TEXTILE_STRETCHING_TEST.AUTHOR_ID, 
				AUTHORS.EMPLOYEE_NAME AS AUTHOR_NAME, 
				AUTHORS.EMPLOYEE_SURNAME AS AUTHOR_SURNAME, 
				TEXTILE_STRETCHING_TEST.PROJECT_ID, TEXTILE_STRETCHING_TEST.EMPLOYEE_ID, 
				TEXTILE_STRETCHING_TEST.FABRIC_ARRIVAL_DATE, 
				TEXTILE_STRETCHING_TEST.PURCHASING_ID, 
				COMPANY.FULLNAME, 
				PRO_PROJECTS.PROJECT_NUMBER,
                PRO_PROJECTS.PROJECT_HEAD
            FROM TEXTILE_STRETCHING_TEST
            INNER JOIN #dsn#.PRO_PROJECTS ON TEXTILE_STRETCHING_TEST.PROJECT_ID = PRO_PROJECTS.PROJECT_ID 
            INNER JOIN #dsn#.EMPLOYEES AS AUTHORS ON TEXTILE_STRETCHING_TEST.AUTHOR_ID = AUTHORS.EMPLOYEE_ID
            LEFT JOIN #this.dsn3#.ORDERS ord ON TEXTILE_STRETCHING_TEST.ORDER_ID = ord.ORDER_ID
            LEFT JOIN #dsn#.COMPANY ON ord.COMPANY_ID = COMPANY.COMPANY_ID
            <cfif isDefined("arguments.opp_id") or isDefined("arguments.author_id") or isDefined("arguments.project_id") or isDefined("arguments.test_date")>
                WHERE 1 = 1
                <cfif len(arguments.author_id)>
                    AND TEXTILE_STRETCHING_TEST.AUTHOR_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.author_id#">
                </cfif>
                <cfif len(arguments.opp_id)>
                    AND TEXTILE_STRETCHING_TEST.STRETCHING_TEST_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.opp_id#">
                </cfif>
                <cfif len(arguments.project_id)>
                    AND TEXTILE_STRETCHING_TEST.PROJECT_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.project_id#">
                </cfif>
                <cfif len(arguments.test_date_start)>
                    AND DATEDIFF('DAY', <cfqueryparam cfsqltype="CF_SQL_DATE" value="#arguments.test_date_start#">, TEXTILE_STRETCHING_TEST.TEST_DATE) >= 0
                </cfif>
                <cfif len(arguments.test_date_end)>
                    AND DATEDIFF('DAY', TEXTILE_STRETCHING_TEST.TEST_DATE, <cfqueryparam cfsqltype="CF_SQL_DATE" value="#arguments.test_date_end#">) >= 0
                </cfif>
                <cfif len(arguments.purchasing_id)>
                    AND TEXTILE_STRETCHING_TEST.PURCHASING_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.purchasing_id#'>
                </cfif>
            </cfif>
        </cfquery>
        <cfreturn query_stretching_test>
    </cffunction>

    <cffunction name="get_stretching_test_by_opp" access="public" returntype="any">
        <cfargument name="project_id">
        <cfargument name="order_id">
        <cfargument name="purchasing_id">

        <cfquery name="query_get" datasource="#dsn2#">
            SELECT TOP 1 test.*, projects.PROJECT_HEAD, ord.ORDER_HEAD, prc.SHIP_NUMBER AS PURCHASE_HEAD
            FROM #dsn3#.TEXTILE_STRETCHING_TEST test
            INNER JOIN #dsn#.PRO_PROJECTS projects ON test.PROJECT_ID = projects.PROJECT_ID
            LEFT JOIN #dsn3#.ORDERS ord ON test.ORDER_ID = ord.ORDER_ID
            LEFT JOIN #dsn2#.SHIP prc ON test.PURCHASING_ID = prc.SHIP_ID
            WHERE 1=1
            <cfif arguments.project_id gt 0>
                AND test.PROJECT_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.project_id#'>
            </cfif>
            <cfif isDefined("arguments.order_id") and arguments.order_id gt 0>
                AND test.ORDER_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.order_id#'>
            </cfif>
            <cfif arguments.purchasing_id gt 0>
                AND test.PURCHASING_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.purchasing_id#'>
            </cfif>
        </cfquery>
        <cfreturn query_get>
    </cffunction>

    <cffunction name="get_stretching_test" access="public" returntype="any">
        <cfargument name="test_id">
        
        <cfquery name="query_get" datasource="#dsn3#">
            SELECT TOP 1 test.*, projects.PROJECT_HEAD, O.ORDER_NUMBER, prc.SHIP_NUMBER AS PURCHASE_HEAD,prc.SHIP_ID,O.ORDER_ID
            FROM TEXTILE_STRETCHING_TEST test
            INNER JOIN #dsn#.PRO_PROJECTS projects ON test.PROJECT_ID = projects.PROJECT_ID
            LEFT JOIN #dsn3#.ORDERS O ON test.ORDER_ID = O.ORDER_ID
            LEFT JOIN #dsn2#.SHIP prc ON test.PURCHASING_ID = prc.SHIP_ID
            WHERE test.STRETCHING_TEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.test_id#'>
        </cfquery>

        <cfreturn query_get>
    </cffunction>

    <cffunction name="add_stretching_test" access="public" returntype="any">
        <cfargument name="test_date" type="date">
        <cfargument name="author_id" type="numeric">
        <cfargument name="project_id" type="any">
        <cfargument name="opportunity_id" type="any">
        <cfargument name="order_id" type="any">
        <cfargument name="employee_id" type="numeric">
        <cfargument name="purchasing_id" type="any">
        <cfargument name="fabric_arrival_date" type="any">
        <cflock name="#createUUID()#" timeout="20">
        <cftransaction>
        <cfquery name="add_stretching_test" datasource="#dsn2#" result="query_result">
            INSERT INTO #dsn3#.TEXTILE_STRETCHING_TEST
                (TEST_DATE
                ,AUTHOR_ID
                ,PROJECT_ID
                ,OPPORTUNITY_ID
                ,ORDER_ID
                ,EMPLOYEE_ID
                ,PURCHASING_ID
                ,FABRIC_ARRIVAL_DATE)
            VALUES
                (
                <cfqueryparam cfsqltype="CF_SQL_DATE" value="#arguments.test_date#">           
                ,<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.author_id#">
                
                <cfif isDefined("arguments.project_id") and len(arguments.project_id)>
                ,<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.project_id#">
                <cfelse>
                ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' null="yes">
                </cfif>

                <cfif isDefined("arguments.opportunity_id") and len(arguments.opportunity_id)>
                ,<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.opportunity_id#">
                <cfelse>
                ,<cfqueryparam cfsqltype='CF_SQL_' null="yes">
                </cfif>

                <cfif isDefined("arguments.order_id") and len(arguments.order_id)>
					,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.order_id#'>
                <cfelse>
					,<cfqueryparam cfsqltype='CF_SQL_INTEGER' null="yes">
                </cfif>

                ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.employee_id#'>

                <cfif isDefined("arguments.purchasing_id") and len(arguments.purchasing_id)>
					,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.purchasing_id#'>
                <cfelse>
					,<cfqueryparam cfsqltype='CF_SQL_INTEGER' null="yes">
                </cfif>

                <cfif isDefined("arguments.fabric_arrival_date") and len(arguments.fabric_arrival_date)>
                ,<cfqueryparam cfsqltype='CF_SQL_DATE' value='#arguments.fabric_arrival_date#'>
                <cfelse>
                ,<cfqueryparam cfsqltype='CF_SQL_DATE' null="yes">
                </cfif>
                )
        </cfquery>
        </cftransaction>
        </cflock>
        <cfreturn query_result>
    </cffunction>

    <cffunction name="update_stretching_test" access="public" returntype="any">
        <cfargument name="stretching_test_id" type="int">
        <cfargument name="test_date" type="date">
        <cfargument name="author_id" type="numeric">
        <cfargument name="project_id" type="any">
        <cfargument name="opportunity_id" type="any">
        <cfargument name="order_id" type="any">
        <cfargument name="employee_id" type="numeric">
        <cfargument name="fabric_arrival_date" type="any">
        <cfargument name="purchasing_id" type="any">
        <cflock name="#createUUID()#" timeout="20">
        <cftransaction>
        <cfquery name="query_stretching_test" datasource="#dsn#" result="query_result">
            UPDATE TEXTILE_STRETCHING_TEST SET
                TEST_DATE = <cfqueryparam cfsqltype="CF_SQL_DATE" value="#arguments.test_date#">
                ,AUTHOR_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.author_id#">
                
                <cfif isDefined("arguments.project_id") and len(arguments.project_id)>
                ,PROJECT_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.project_id#">
                </cfif>
                
                <cfif isDefined("arguments.opportunity_id") and len(arguments.opportunity_id)>
                ,OPPORTUNITY_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.opportunity_id#">
                </cfif>

                <cfif isDefined("arguments.order_id") and len(arguments.order_id)>
                ,ORDER_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.order_id#'>
                </cfif>

                ,EMPLOYEE_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.employee_id#'>

                <cfif isDefined("arguments.fabric_arrival_date") and len(arguments.fabric_arrival_date)>
                ,FABRIC_ARRIVAL_DATE = <cfqueryparam cfsqltype='CF_SQL_DATE' value='#arguments.fabric_arrival_date#'>
                </cfif>

                <cfif isDefined("arguments.purchasing_id") and len(arguments.purchasing_id)>
                ,PURCHASING_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.purchasing_id#'>
                </cfif>

                WHERE STRETCHING_TEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.stretching_test_id#'>
        </cfquery>
        </cftransaction>
        </cflock>
        <cfreturn query_result>
    </cffunction>

</cfcomponent>