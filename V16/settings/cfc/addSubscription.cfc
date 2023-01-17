<!--- 
    File: addSubscription.cfc
    Author: Botan KAYĞAN <botankaygan@workcube.com>
    Date: 05.09.2019
    Controller: -
    Description: Yeni abone kaydı gerçekleştiren servis.
--->

<cfcomponent>
    <cfproperty name="dsn">
    <cfproperty name="dsn3">

    <cffunction name="init" access="public">
        <cfscript>
            this.dsn = application.SystemParam.SystemParam().dsn;
            this.dsn3 = "#this.dsn#_1";
        </cfscript>
    </cffunction>

    <cffunction name="addSubscriptions" access="public" returntype="any">
        <cfargument name="addSubscription" default="">
        <cfquery name="addSubscription" datasource="#this.dsn3#" result="ID">
            INSERT INTO
                SUBSCRIPTION_CONTRACT
                (
                    SUBSCRIPTION_HEAD
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.subscription_head#">
                )
        </cfquery>
        <cfreturn ID.IDENTITYCOL>
    </cffunction>
</cfcomponent>