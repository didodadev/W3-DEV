<cfcomponent extends="cfc.queryJSONConverter">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>
    
    <cfset functions = createObject('component','WMO.functions') />
    <cfset filterNum = functions.filterNum />
    <cfset wrk_round = functions.wrk_round />

    <cffunction name="addRows" access="remote" returntype="any" returnformat="JSON">
        <cfset response = structNew()>
        <cfset uuid = createUUID() >
        <cftransaction>
            <cftry>
                <cfloop from="1" to="#arguments.num_row#" index="i">
                    <cfif isdefined("arguments.row_control_#i#") and evaluate("arguments.row_control_#i#") eq 1>
                        <cfquery name="ORDER_PRE_ROWS" datasource="#DSN3#">
                            INSERT INTO
                                ORDER_PRE_ROWS
                                (
                                    PRODUCT_ID,
                                    PRODUCT_NAME,
                                    QUANTITY,
                                    PRICE,
                                    PRICE_KDV,
                                    PRICE_MONEY,
                                    TAX,
                                    STOCK_ID,
                                    PRODUCT_UNIT_ID,
                                    ORDER_ID,
                                    <cfif len(arguments.company_id)>
                                    TO_COMP,
                                    <cfelse>
                                    TO_CONS,
                                    </cfif>
                                    RECORD_EMP,
                                    RECORD_IP,
                                    RECORD_DATE,
                                    UNIQUE_ID
                                )
                                VALUES
                                (
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("arguments.product_id_#i#")#">,
                                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate("arguments.product_name_#i#")#">,
                                    <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(evaluate("arguments.amount_#i#"))#">,
                                    <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(evaluate("arguments.price_#i#"))#">,
                                    <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(evaluate("arguments.price_#i#")) * (1 + (filterNum(evaluate("arguments.tax_#i#") / 100)))#">,
                                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate("arguments.price_money_#i#")#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("arguments.tax_#i#")#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("arguments.stock_id_#i#")#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("arguments.product_unit_id_#i#")#">,
                                    <cfif len(arguments.list_ord_id)>
                                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.list_ord_id#">,
                                    <cfelse>
                                        NULL,
                                    </cfif>
                                    <cfif len(arguments.company_id)>
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">,
                                    <cfelse>
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">,
                                    </cfif>
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                                    <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#uuid#">
                                )
                        </cfquery>
                    </cfif>
                </cfloop>
                <cfset response.success = 1 >
            <cfcatch type="any">
                <cfset response.success = 0 >
                <cfset response.message = cfcatch.message >
            </cfcatch>
            </cftry>
        </cftransaction>
        <cfreturn Replace(SerializeJson(response),"//","") >
    </cffunction>

    <cffunction name="getRows" access="remote" returntype="any" returnformat="JSON">
        <cfquery name="getRows" datasource="#dsn3#">
            SELECT * FROM ORDER_PRE_ROWS WHERE UNIQUE_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.unique_id#">
        </cfquery>
        <cfset getJSON = returnData(serializeJSON(getRows))>
        <cfreturn Replace(serializeJSON(getJSON),'//','') />
    </cffunction>

    <cffunction name="getCompanyRows" access="remote" returntype="any" returnformat="JSON">
        <cfquery name="getCompanyRows" datasource="#dsn3#">
            SELECT * FROM ORDER_PRE_ROWS WHERE TO_COMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
        </cfquery>
        <cfset getJSON = returnData(serializeJSON(getCompanyRows))>
        <cfreturn Replace(serializeJSON(getJSON),'//','') />
    </cffunction>
    <cffunction name="GET_ONLINE_SALES_ALL" access="remote" returntype="any">
        <cfquery name="GET_ONLINE_SALES_ALL" datasource="#DSN3#">
            SELECT
                OPR.UNIQUE_ID,
                OPR.ORDER_ID,
                OPR.RECORD_EMP,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME
            FROM
                ORDER_PRE_ROWS OPR
                LEFT JOIN #dsn#.COMPANY AS C ON C.COMPANY_ID = OPR.TO_COMP
                LEFT JOIN #dsn#.EMPLOYEES AS E ON E.EMPLOYEE_ID = OPR.RECORD_EMP 
            WHERE
                OPR.RECORD_DATE >= #arguments.start_date# AND
                OPR.RECORD_DATE <= #arguments.finish_date#
                <cfif isdefined("arguments.member_name") and len(arguments.member_name) and arguments.member_type is 'partner' and len(arguments.company_id)>
                    AND C.COMPANY_ID = #arguments.company_id#
                <cfelseif isdefined("arguments.member_name") and len(arguments.member_name) and arguments.member_type is 'consumer' and len(arguments.consumer_id)>
                    AND OPR.TO_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
                </cfif>
                <cfif len(arguments.order_id_listesi) and len(arguments.order_id_form)>
                    <cfset k=1>
                    AND
                    ( 
                    <cfloop from="1" to="#listlen(arguments.order_id_listesi)#" index="i">
                        OPR.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#"> <cfif k neq listlen(arguments.order_id_listesi)> OR </cfif>
                        <cfset k++>
                    </cfloop>
                    )
                </cfif>
                AND UNIQUE_ID IS NOT NULL
            GROUP BY
                OPR.UNIQUE_ID,
                OPR.ORDER_ID,
                OPR.RECORD_EMP,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME
            ORDER BY
                UNIQUE_ID,
                ORDER_ID,
                RECORD_EMP
        </cfquery>
        <cfreturn GET_ONLINE_SALES_ALL>
    </cffunction>

</cfcomponent>