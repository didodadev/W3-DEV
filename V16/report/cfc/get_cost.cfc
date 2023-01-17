<!--- 
File: additional_cost_detail_report.cfm
Author:  Esma Uysal <esmauysal@workcube.com>
Date: 06.09.2019
Controller: -
Description: Maliyet Raporları querylerinin bulunduğu cfc'dir.
--->
<cfcomponent displayname="Board"  hint="ColdFusion Component for Kullanicilar">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3 = dsn & '_' & session.ep.company_id>
    <!--- 20190905ERU Ek Maliyet Detay Query'si --->
    <cffunction name="EXTRA_COST_DETAIL" returntype="query">
        <cfargument name="product_id" default="">
        <cfargument name="station_id" default="">
        <cfargument name="expense_center_id" default="">
        <cfargument name="product_cat_id" default="">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="">
        <cfargument name="acc_code_1" default="">
        <cfargument name="acc_code_2" default="">
        <cfquery name="EXTRA_COST_DETAIL" datasource="#dsn3#">
            SELECT DISTINCT
                EC.EXPENSE,
                PECD.AMOUNT,            
                PC.START_DATE,
                AP.ACCOUNT_NAME,	
                PECD.PRODUCT_ID,
                PECD.ACCOUNT_ID,			
                PORR.NAME_PRODUCT,
                PECD.EXPENSE_SHIFT,	     
                PC.PRODUCT_COST_ID,
                ISNULL(PC.PURCHASE_NET,0) PURCHASE_NET,
                ISNULL(PC.PURCHASE_NET_MONEY,0) PURCHASE_NET_MONEY,
                ISNULL(PC.PURCHASE_NET_SYSTEM,0) PURCHASE_NET_SYSTEM,
                ISNULL(PC.PURCHASE_NET_LOCATION,0) PURCHASE_NET_LOCATION,
                ISNULL(PC.PURCHASE_NET_DEPARTMENT,0) PURCHASE_NET_DEPARTMENT,		
                ISNULL(PC.PURCHASE_NET_SYSTEM_MONEY,0) PURCHASE_NET_SYSTEM_MONEY,
                ISNULL(PC.PURCHASE_NET_MONEY_LOCATION,0) PURCHASE_NET_MONEY_LOCATION,
                ISNULL(PC.PURCHASE_NET_MONEY_DEPARTMENT,0) PURCHASE_NET_MONEY_DEPARTMENT
            FROM	
                PRODUCT P,		
                PRODUCT_COST PC ,		
                PRODUCTION_ORDER_RESULTS POR,
                PRODUCTION_ORDER_RESULTS_ROW PORR,			
                PRODUCT_EXTRA_COST_DETAIL PECD 
                    LEFT JOIN #dsn2#.EXPENSE_CENTER EC ON EC.EXPENSE_ID = PECD.EXPENSE_ID
                    LEFT JOIN #dsn2#.ACCOUNT_PLAN AP ON AP.ACCOUNT_CODE = PECD.ACCOUNT_ID   
            WHERE 
                PORR.PR_ORDER_ID = POR.PR_ORDER_ID AND
                PC.PRODUCT_ID = PORR.PRODUCT_ID AND
                PECD.PRODUCT_ID = PC.PRODUCT_ID AND
                P.PRODUCT_ID = PECD.PRODUCT_ID
                <cfif len(arguments.product_id)>
                    AND	PECD.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer"  value="#arguments.product_id#">
                </cfif>
                <cfif len(arguments.station_id)>
                    AND PECD.STATION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer"  value="#arguments.station_id#" list = "yes">)
                </cfif>
                <cfif len(arguments.expense_center_id)>
                    AND EC.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer"  value="#arguments.expense_center_id#">
                </cfif>
                <cfif len(arguments.product_cat_id)>
                    AND P.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer"  value="#arguments.product_cat_id#">
                </cfif>
                <cfif len(arguments.acc_code_1)>
                    AND PECD.ACCOUNT_ID <= <cfqueryparam cfsqltype="cf_sql_integer"  value="#arguments.acc_code_1#">
                </cfif>
                <cfif len(arguments.acc_code_2)>
                    AND PECD.ACCOUNT_ID >= <cfqueryparam cfsqltype="cf_sql_integer"  value="#arguments.acc_code_2#">
                </cfif>
                <cfif len(arguments.start_date)>
                    AND PC.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date"  value="#arguments.start_date#">
                </cfif>
                <cfif len(arguments.finish_date)>
                    AND PC.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date"  value="#arguments.finish_date#">                 
                </cfif>
            ORDER BY 
                PECD.PRODUCT_ID,
                PORR.NAME_PRODUCT			
        </cfquery>
        <cfreturn EXTRA_COST_DETAIL>
    </cffunction>	
    <cffunction name="EXPENCE_CENTER" returntype="query">
        <cfargument name="expense_center_id" default="">
        <cfquery name="EXPENCE_CENTER" datasource="#dsn2#">
            SELECT EXPENSE,EXPENSE_ID FROM EXPENSE_CENTER 
        </cfquery>
        <cfreturn EXPENCE_CENTER>
    </cffunction>
</cfcomponent>


