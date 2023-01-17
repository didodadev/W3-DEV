<!---
File: get_wage_scale.cfc
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Date:24.09.2019
Controller: -
Description: Temel Ücret Skalası Fonksiyonları;  
Ekleme, Güncelleme, Pozisyon tipi skalası, Pozisyon tipi skalası JSON formatı
--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="GET_WAGE_SCALE" access="public" returntype="query"><!---Pozisyon Tipine Ait Temel Ücret Skalası--->
        <cfargument name="position_id" default="">
        <cfargument name="year" default="">  
        <cfargument name="min_salary" default="">
        <cfargument name="max_salary" default="">  
        <cfargument name="maxrows" default="1">
		<cfargument name="startrow" default="1">
        <cfquery name="GET_WAGE_SCALE" datasource="#dsn#">
            SELECT 
                * 
            FROM 
                POSITION_WAGE_SCALE 
            WHERE 
                1 = 1
                <cfif isdefined("arguments.position_id") and len(arguments.position_id)>
                    AND POSITION_ID = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#arguments.position_id#" >
                </cfif>
                <cfif isdefined("arguments.year") and len(arguments.year)>
                    AND YEAR = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#arguments.year#" >
                </cfif>
                <cfif isdefined("arguments.min_salary") and len(arguments.min_salary)>
                    AND MIN_SALARY >= <cfqueryparam cfsqltype = "cf_sql_float" value = "#arguments.min_salary#" >
                </cfif>
                <cfif isdefined("arguments.max_salary") and len(arguments.max_salary)>
                    AND MAX_SALARY <= <cfqueryparam cfsqltype = "cf_sql_float" value = "#arguments.max_salary#" >
                </cfif> 
        </cfquery>
        <cfreturn GET_WAGE_SCALE>
    </cffunction>
    <cffunction name="SAVE_WAGE_SCALE" access="remote" returntype="any"><!---Pozisyon Tipine Ait Temel Ücret Skalası Ekleme--->
        <cfargument name="position_id" default="">
        <cfargument name="min_salary" default="">
        <cfargument name="max_salary" default="">
        <cfargument name="money" default="">
        <cfargument name="year" default="">
        <cfquery name="SAVE_WAGE_SCALE" datasource="#dsn#">
            INSERT INTO
                POSITION_WAGE_SCALE
                (
                    POSITION_ID,
                    MIN_SALARY,
                    MAX_SALARY,
                    MONEY,
                    YEAR, 
                    GROSS_NET,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP
                )
                VALUES
                (
                    <cfqueryparam cfsqltype = "cf_sql_integer" value = "#arguments.position_id#">,
                    <cfqueryparam cfsqltype = "cf_sql_float" value = "#arguments.min_salary#">,
                    <cfqueryparam cfsqltype = "cf_sql_float" value = "#arguments.max_salary#" >,
                    <cfqueryparam cfsqltype = "cf_sql_varchar" value = "#arguments.money#" >,
                    <cfqueryparam cfsqltype = "cf_sql_integer" value = "#arguments.year#">,
                    <cfif isdefined("arguments.gross_net") and len(arguments.gross_net)>#arguments.gross_net#<cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
                )
        </cfquery>
        <cfreturn 1>
    </cffunction>
    <cffunction name="UPDATE_WAGE_SCALE" access="remote" returntype="any"><!---Pozisyon Tipine Ait Temel Ücret Skalası Güncelleme--->
        <cfargument name="position_id" default="">
        <cfargument name="min_salary" default="">
        <cfargument name="max_salary" default="">
        <cfargument name="money" default="">
        <cfargument name="year" default="">
        <cfquery name="UPDATE_WAGE_SCALE" datasource="#dsn#">
            UPDATE
                POSITION_WAGE_SCALE
            SET
                MIN_SALARY = <cfqueryparam cfsqltype = "cf_sql_float" value = "#arguments.min_salary#">,
                MAX_SALARY = <cfqueryparam cfsqltype = "cf_sql_float" value = "#arguments.max_salary#" >,
                MONEY = <cfqueryparam cfsqltype = "cf_sql_varchar" value = "#arguments.money#" >,
                GROSS_NET = <cfif isdefined("arguments.gross_net") and len(arguments.gross_net)>#arguments.gross_net#<cfelse>NULL</cfif>,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
            WHERE
                POSITION_ID = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#arguments.position_id#">
                AND YEAR = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#arguments.year#">
        </cfquery>
        <cfreturn 1>
    </cffunction>
    <cffunction name="WAGE_SCALE_JSON" access="remote" returnFormat="json" returntype="any"><!---Pozisyon Tipine Ait Temel Ücret Skalası(return JSON)--->
        <cfargument name="position_id" default="">
        <cfargument name="year" default="">
        <cfquery name="WAGE_SCALE_JSON" datasource="#dsn#">
            SELECT 
                * 
            FROM 
                POSITION_WAGE_SCALE 
            WHERE 
                POSITION_ID = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#arguments.position_id#" > AND
                YEAR = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#arguments.year#" >
        </cfquery>
        <cfreturn  Replace( serializeJSON(WAGE_SCALE_JSON), "//", "" )>
    </cffunction>
    <cffunction name="GET_POSITION_CAT" access="remote" returntype="any"><!---Pozisyon Tipine Ait Temel Ücret Skalası Güncelleme--->
        <cfargument name="position_id" default="">
        <cfquery name="GET_POSITION_CAT" datasource="#dsn#">
            SELECT 
                POSITION_CAT_ID,
                POSITION_CAT 
            FROM 
                SETUP_POSITION_CAT 
            WHERE 
                1=1
                <cfif isdefined("arguments.position_id") and len(arguments.position_id)>
                    AND POSITION_CAT_ID = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#arguments.position_id#" >
                </cfif>
        </cfquery>
        <cfreturn  GET_POSITION_CAT>
    </cffunction>
</cfcomponent>