<!---
    File: V16\settings\cfc\setup_working_type.cfc
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2021-10-28
    Description: Mesai türlerinin tanımlandığı cfc.
        
    History:
        
    To Do:

--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">

    <cfset fusebox.dynamic_hierarchy = application.systemParam.systemParam().fusebox.dynamic_hierarchy>
    <cfset fusebox.process_tree_control = application.systemParam.systemParam().fusebox.process_tree_control>

  
    <cffunction name="GET_SETUP_WORKING_TYPE" access="public" returntype="query">
        <cfparam name="working_type_id" default = "">
        <cfquery name="GET_SETUP_WORKING_TYPE" datasource="#DSN#">
            SELECT
                *
            FROM 
                SETUP_WORKING_TYPE
            <cfif isdefined("arguments.working_type_id") and len(arguments.working_type_id)>
                WHERE
                    WORKING_TYPE_ID = <cfqueryparam value = "#arguments.working_type_id#" CFSQLType = "cf_sql_integer">
            </cfif>
            ORDER BY
                WORKING_TYPE
        </cfquery>
        <cfreturn GET_SETUP_WORKING_TYPE>
    </cffunction>

    <cffunction name="GET_SETUP_OFFTIME" access="public" returntype="query">
        <cfquery name="GET_SETUP_OFFTIME" datasource="#DSN#">
            SELECT
                OFFTIMECAT,
                OFFTIMECAT_ID
            FROM 
                SETUP_OFFTIME
            WHERE
                IS_ACTIVE = 1
            ORDER BY
                OFFTIMECAT
        </cfquery>
        <cfreturn GET_SETUP_OFFTIME>
    </cffunction>

    <cffunction name="upd_setup_working_type" access="remote" returntype="any">
        <cfargument  name="working_type_id">
        <cfargument  name="working_type">
        <cfargument  name="working_abbreviation">
        <cfargument  name="detail">
        <cfargument  name="color_code">
        <cftry>
            <cfquery name="upd_setup_working_type" datasource="#DSN#">
                UPDATE 
                    SETUP_WORKING_TYPE
                SET 
                    WORKING_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.working_type#">
                    ,WORKING_ABBREVIATION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.working_abbreviation#">
                    ,DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#">
                    ,COLOR_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.color_code#">
                    ,UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    ,UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                    ,UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                WHERE 
                    WORKING_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.working_type_id#">
            </cfquery>
            <cfset responseStruct.message = "İşlem Başarılı">
                <cfset responseStruct.status = true>
                <cfset responseStruct.error = {}>
                <cfset responseStruct.identity = arguments.working_type_id>
            <cfcatch type="database">
                <cftransaction action="rollback">
                <cfset responseStruct.message = "İşlem Hatalı">
                <cfset responseStruct.status = false>
                <cfset responseStruct.error = cfcatch>
            </cfcatch>
            </cftry>
            <cfreturn responseStruct>
    </cffunction>

    <cffunction name="add_setup_working_type" access="remote" returntype="any">
        <cfargument  name="working_type">
        <cfargument  name="working_abbreviation">
        <cfargument  name="detail">
        <cfargument  name="color_code">
        <cftry>
            <cfset responseStruct = structNew()>
            <cfquery name="add_setup_working_type" datasource="#DSN#">
                INSERT INTO SETUP_WORKING_TYPE
                (
                    WORKING_TYPE
                    ,WORKING_ABBREVIATION
                    ,DETAIL
                    ,COLOR_CODE
                    ,RECORD_EMP
                    ,RECORD_IP
                    ,RECORD_DATE
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.working_type#">
                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.working_abbreviation#">
                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#">
                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.color_code#">
                    ,<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                    ,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                )
            </cfquery>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = ''>
        <cfcatch type="database">
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>

    <cffunction name="del_setup_working_type" access="remote" returntype="any">
        <cfargument  name="working_type_id">
        <cfquery name="del_setup_working_type" datasource="#DSN#">
            DELETE            
            FROM
                SETUP_WORKING_TYPE
            WHERE
                WORKING_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.working_type_id#">
        </cfquery>
    </cffunction>
</cfcomponent>
