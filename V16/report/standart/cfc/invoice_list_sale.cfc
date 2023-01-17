<!---Gülbahar Inan / Fatura Listesi Satışlar Raporu cfc sayfasıdır--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2= "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cffunction name="GET_SUBSCRIPTION_TYPE" access="remote" returntype="any">
        <cfquery name="get_subscription_type" datasource="#dsn3#">
			SELECT SST.SUBSCRIPTION_TYPE_ID,SST.SUBSCRIPTION_TYPE FROM SETUP_SUBSCRIPTION_TYPE SST LEFT JOIN SUBSCRIPTION_CONTRACT SC ON SC.SUBSCRIPTION_TYPE_ID=SST.SUBSCRIPTION_TYPE_ID GROUP BY SST.SUBSCRIPTION_TYPE_ID,SST.SUBSCRIPTION_TYPE
        </cfquery>
         <cfreturn GET_SUBSCRIPTION_TYPE>
    </cffunction>
    <cffunction name="GET_ALL_TAX" access="remote"  returntype="any">
        <cfquery name="get_all_tax" datasource="#dsn2#">
			SELECT DISTINCT TAX FROM SETUP_TAX
		</cfquery>
         <cfreturn GET_ALL_TAX>
    </cffunction>
    <cffunction name="GET_ALL_OTV" access="remote"  returntype="any">
        <cfquery name="get_all_otv" datasource="#dsn3#">
			SELECT DISTINCT TAX FROM SETUP_OTV WHERE PERIOD_ID = #session.ep.period_id#
		</cfquery>
         <cfreturn GET_ALL_OTV>
    </cffunction>
    <cffunction name="GET_ALL_BSMV" access="remote"  returntype="any">
        <cfquery name="get_all_bsmv" datasource="#dsn3#">
			SELECT DISTINCT TAX FROM SETUP_BSMV WHERE PERIOD_ID = #session.ep.period_id#
		</cfquery>
         <cfreturn GET_ALL_BSMV>
    </cffunction>
    <cffunction name="GET_ALL_OIV" access="remote" returntype="any">      
		<cfquery name="get_all_oiv" datasource="#dsn3#">
			SELECT DISTINCT TAX FROM SETUP_OIV WHERE PERIOD_ID = #session.ep.period_id#
		</cfquery>
         <cfreturn GET_ALL_OIV>
    </cffunction>
    <cffunction name="GET_SUBSCRIPTION_CAT" access="remote" returntype="any">   
        <cfquery name="get_subscription_cat" datasource="#dsn#">
            select IS_SUBSCRIPTION_CONTRACT from OUR_COMPANY_INFO where COMP_ID = #session.ep.company_id#
        </cfquery>
         <cfreturn GET_SUBSCRIPTION_CAT>
    </cffunction>
    <cffunction name="GET_EXPENSE_TEVK" access="remote" returntype="any">   
        <cfargument name="expense_id" type="any" default="">
        <cfquery name="get_expense_tevk" datasource="#dsn2#">
            SELECT TEVKIFAT_ORAN, KDV_TOTAL FROM EXPENSE_ITEM_PLANS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_id#">
        </cfquery>
        <cfreturn get_expense_tevk>
    </cffunction>
</cfcomponent>