<cfcomponent>
    <cfset dsn_alias=dsn=application.systemParam.systemParam().dsn>
    <cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'> 
    <!--- bill no --->
    <cffunction  name="GET_BILL_NO"  returntype="any">
    <cfquery name="GET_BILL_NO" datasource="#DSN2#">
        SELECT
            *
        FROM
            BILLS
    </cfquery>
         <cfreturn GET_BILL_NO>
        </cffunction>
    <!--- caches --->
        <cffunction  name="GET_CACHES"  returntype="any">
        <cfquery name="GET_CACHES" datasource="#DSN2#">
            SELECT
               *
           FROM
               CASH_ACTIONS
           WHERE
               CASH_ACTIONS.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"> 
       </cfquery>
          <cfreturn GET_CACHES>
    </cffunction>
     <!--- caches update--->
    <cffunction  name="GET_CACHES_UPDATE"  returntype="any">
        <cfquery name="GET_CACHES_UPDATE" datasource="#dsn2#">
            SELECT 
                *
            FROM
                CASH
            WHERE
                CASH_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
                <cfif session.ep.isBranchAuthorization>
                    AND BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#
                </cfif>
            ORDER BY 
                CASH_NAME
        </cfquery>
          <cfreturn GET_CACHES_UPDATE>
    </cffunction>
         <!--- ACTION DETAIL--->
         <cffunction  name="select"  access = "public">
            <cfargument name="id" default="">
            <cfquery name="GET_ACTION_DETAIL" datasource="#dsn2#">
                SELECT
                    *
                FROM
                    CASH_ACTIONS
                WHERE
                    ACTION_ID = #arguments.id#
                <cfif session.ep.isBranchAuthorization>
                    AND
                    (
                            (CASH_ACTION_FROM_CASH_ID IN (SELECT CASH_ID FROM CASH WHERE BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)) OR
                            CASH_ACTION_TO_CASH_ID IN (SELECT CASH_ID FROM CASH WHERE BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)))
                    )
                </cfif>		
            </cfquery>       
            <cfreturn GET_ACTION_DETAIL>     
        </cffunction>
        <cffunction  name="get" access="public">
            <cfargument  name="id" default="">
             <cfreturn select(id=arguments.id)> 
        </cffunction> 
</cfcomponent>