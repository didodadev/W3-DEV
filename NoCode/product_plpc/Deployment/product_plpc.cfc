<cfcomponent extends="WDO.catalogs.dataComponent">

<cfset dsn = application.systemParam.systemParam().dsn>
<cfset dsn1 = application.systemParam.systemParam().dsn & "_product">
<cfset dsn2 = application.systemParam.systemParam().dsn & "_" & session.ep.period_year & "_" & session.ep.company_id>
<cfset dsn3 = application.systemParam.systemParam().dsn & "_" & session.ep.company_id>

    <cffunction name="select_product_cat" access="remote" returntype="any">
        <cfargument name="product_cat_id_list" type="any" required="no">
        <cfquery name="select_product_cat" datasource="#dsn1#">
            SELECT
                *
            FROM
                PRODUCT_CAT
            WHERE 
                PRODUCT_CATID IS NOT NULL
                <cfif isDefined('arguments.product_cat_id_list') and len(arguments.product_cat_id_list)>
                    AND (PRODUCT_CATID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_cat_id_list#" list="true">))
                </cfif>
            ORDER BY 
            PRODUCT_CATID,
            PRODUCT_CAT
        </cfquery>    
        <cfreturn select_product_cat>
    </cffunction>

    <cffunction name="get_operation_type" access="remote" returntype="any">
        <cfargument name="operation_type_list" type="any">
        <cfquery name="get_operation_type" datasource="#dsn3#">
            SELECT
                O.*
            FROM
                OPERATION_TYPES O
            WHERE 
            O.OPERATION_STATUS = 1
            <cfif isdefined("arguments.operation_type_list") and len(arguments.operation_type_list)>
                AND O.OPERATION_TYPE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.operation_type_list#" list="true">)
            </cfif>
        </cfquery>
        <cfreturn get_operation_type>
    </cffunction>

    <cffunction name="GET_MONEY" access="remote" returntype="any">
        <cfquery name="GET_MONEY" datasource="#dsn#">
            SELECT * FROM SETUP_MONEY
            WHERE COMPANY_ID = #session.ep.company_id# AND PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1
        </cfquery>
        <cfreturn GET_MONEY>
    </cffunction>

    <cffunction name="get_packages_type" access="remote" returntype="any">
        <cfargument name="list_packages_id" type="any" required="no">
        <cfquery name="get_packages_type" datasource="#dsn#">
            SELECT 
                PACKAGE_TYPE_ID, 
                PACKAGE_TYPE, 
                CALCULATE_TYPE_ID, 
                DETAIL, 
                DIMENTION, 
                RECORD_DATE, 
                RECORD_EMP, 
                RECORD_IP, 
                UPDATE_DATE, 
                UPDATE_EMP, 
                UPDATE_IP 
            FROM 
                SETUP_PACKAGE_TYPE
            WHERE 
                1=1
            <cfif isdefined("arguments.list_packages_id") and len(arguments.list_packages_id)>
                AND PACKAGE_TYPE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.list_packages_id#" list="true">)
            </cfif>
        </cfquery>
        <cfreturn get_packages_type>
    </cffunction>
</cfcomponent>