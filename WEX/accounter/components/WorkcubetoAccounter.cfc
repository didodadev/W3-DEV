<!--
    -Hesap Planlarını ve Muhasebe Fişlerini belirlenen Adrese Gönderimini Sağlar
    -Hesap Plan Queryleri ve Muhasebeci İçerisinden Tetiklenir.
    -04112021
-->
<cfcomponent accessors="true">

    <cfproperty name="session_base" type="struct">
    <cfproperty name="dsn2" type="string">
    <cfproperty name="queryJSONConverter">

    <cfset dsn = application.systemParam.systemParam().dsn>

    
    <cffunction name = "init">
        <cfargument name="sessions" type="struct" required="true">
        <cfscript>
            setSession_base( arguments.sessions );
            setDsn2( "#dsn#_#getSession_base().period_year#_#getSession_base().company_id#" );
        </cfscript>
        <cfset this.queryJSONConverter = createObject("component","workcube.cfc.queryJSONConverter") />
        <cfreturn this />
    </cffunction>

    <cffunction name="GET_ACC_CARD" returntype="any" access="public" hint="Muhasebe Fişi Belge Bilgileri">
        <cfargument name="card_id" required="true">
        <cfquery name="GET_ACC_CARD" datasource="#getDsn2()#">
            SELECT * FROM ACCOUNT_CARD WHERE CARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.card_id#">
        </cfquery>
        <cfreturn this.queryJSONConverter.returnData( serializeJSON(GET_ACC_CARD) )>
    </cffunction>

    <cffunction name="GET_ACC_CARD_ROWS" returntype="any" access="public" hint="Muhasebe Fişi Satır Bilgileri">
        <cfargument name="card_id" required="true">
        <cfquery name="GET_ACC_CARD_ROWS" datasource="#getDsn2()#">
            SELECT * FROM ACCOUNT_CARD_ROWS WHERE CARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.card_id#">
        </cfquery>
        <cfreturn this.queryJSONConverter.returnData( serializeJSON(GET_ACC_CARD_ROWS) )>
    </cffunction>

    <cffunction name="GET_ACC_MONEY" returntype="any" access="public" hint="Muhasebe Fişi Kur Bilgileri">
        <cfargument name="card_id" required="true">
        <cfquery name="GET_ACC_MONEY" datasource="#getDsn2()#">
            SELECT MONEY_TYPE MONEY,RATE1,RATE2 FROM ACCOUNT_CARD_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.card_id#"> AND MONEY_TYPE <> '#getSession_base().money#'
        </cfquery>
        <cfreturn this.queryJSONConverter.returnData( serializeJSON(GET_ACC_MONEY) )>
    </cffunction>

    <cffunction name="GET_ACC_PLAN" returntype="any" access="public" hint="Hesap Plan Bilgileri">
        <cfargument name="account_code" required="true">
        <cfquery name="GET_ACC_PLAN" datasource="#getDsn2()#">
            SELECT * FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.account_code#">
        </cfquery>
        <cfreturn this.queryJSONConverter.returnData( serializeJSON(GET_ACC_PLAN) )>
    </cffunction>

    <cffunction name="COMP_INFO" returntype="any" access="public" hint="Domain - Lisans Key Bilgileri">
        <cfargument name="datasource_db" default="#getDsn2()#"> 
        <cfquery name="COMP_INFO" datasource="#datasource_db#">
            SELECT
                IS_ACCOUNTER_INTEGRATED,
                ACCOUNTER_DOMAIN,
                ACCOUNTER_KEY
            FROM
                #dsn#.OUR_COMPANY_INFO
            WHERE
                COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getSession_base().company_id#">
        </cfquery>
        <cfreturn COMP_INFO>
    </cffunction>

    <cffunction name="WRK_TO_ACCOUNTER" returnformat="JSON" returntype="any" access="public">
        <cfargument name="card_id" required="true">
        <cfset comp_info = this.COMP_INFO()>
        <cfset response = structNew()>
        
        <cfset response.paper = this.GET_ACC_CARD( card_id: arguments.card_id )>
        <cfset response.rows = this.GET_ACC_CARD_ROWS( card_id: arguments.card_id )>
        <cfset response.money = this.GET_ACC_MONEY( card_id: arguments.card_id )>
        <cfset response.api_key = comp_info.ACCOUNTER_KEY>
        <cfset response.period_year = getSession_base().period_year>
        <cfset response.event = ( isdefined("arguments.event") ) ? arguments.event : '' >
        <cfset response = replace( serializeJSON( response ), "//", "") >

        <cfhttp url="#comp_info.ACCOUNTER_DOMAIN#/wex.cfm/AccounterFromWorkcube/WRK_FROM_ACCOUNTER" 
                charset="utf-8"
                result="result"
                method="post">
            <cfhttpparam type="header" name="Content-Type" value="application/json; charset=UTF-8" />
            <cfhttpparam type="body" name="data" value="#trim(response)#" />
        </cfhttp>
        <cfreturn deserializeJSON(result.filecontent)>
    </cffunction>

    <cffunction name="WRK_PLAN_TO_ACCOUNTER" returnformat="JSON" returntype="any" access="public">
        <cfargument name="account_code" required="true">
        <cfset comp_info = this.COMP_INFO()>
        <cfset response = structNew()>
        
        <cfset response.acc_plan = this.GET_ACC_PLAN( account_code: arguments.account_code )>
        <cfset response.api_key = comp_info.ACCOUNTER_KEY>
        <cfset response.period_year = getSession_base().period_year>
        <cfset response.event = ( isdefined("arguments.event") ) ? arguments.event : '' >
        <cfset response = replace( serializeJSON( response ), "//", "") >

        <cfhttp url="#comp_info.ACCOUNTER_DOMAIN#/wex.cfm/AccounterFromWorkcube/WRK_PLAN_FROM_ACCOUNTER" 
                charset="utf-8"
                result="result"
                method="post">
            <cfhttpparam type="header" name="Content-Type" value="application/json; charset=UTF-8" />
            <cfhttpparam type="body" name="data" value="#trim(response)#" />
        </cfhttp>
        <cfdump var="#result#" abort>
        <cfreturn deserializeJSON(result.filecontent)>
    </cffunction>
</cfcomponent>