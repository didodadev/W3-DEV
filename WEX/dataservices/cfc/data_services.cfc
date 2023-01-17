<!---
    File: WEX\dataservices\cfc\data_services.cfc
    Author: Workcube-Esma Uysal <esmauysal@workcube.com>
    Date: 18.03.2021
    Description: WEX'te tanımlı data servis

    Not : Eğer Data service tipinde bir fonksiyon yazılacaksa contol_#rest_name# Şeklinde yazılamlıdır.
--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    
    <!--- Aktif ve Data servis olan wex'leri alır --->
    <cffunction  name="get_dataservice" access="remote">
        <cfquery name="get_dataservice_" datasource="#dsn#">
            SELECT
                *
            FROM 
                WRK_WEX
            WHERE
                IS_DATASERVICE = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                AND IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            ORDER BY
                HEAD
        </cfquery>

        <cfif get_dataservice_.recordcount>
            <cfset return_data = this.return_json(data : get_dataservice_)>
            <cfreturn return_data>
        <cfelse>
            <cfreturn "[]">
        </cfif>
        <cfreturn "[]">
    </cffunction>

    <!--- Aktif ve Data servis olan ve version kotnrolleri yapılan wex'ler db ye kayıt atılır --->
    <cffunction  name="add_dataservice" access="remote">
        <cfargument  name="result_data">
        <cfargument  name="from_cfc" default="0">
        <cfset return_val = "">

        <cfloop array="#result_data#" index="data">
            <!--- Bu versiyonda wex kaydı var mı --->
            <cfset get_wex = this.get_wex_fnc(wex_id : data.wex_id, main_version : data.main_version, version : data.version)>
            
            <!--- Daha önce kaydı yoksa kayıt atar --->
            <cfif get_wex.recordcount eq 0>
                <cfquery name="add_dataservice_" datasource="#dsn#">
                    INSERT INTO 
                    WRK_DATA_SERVICE
                    (
                        HEAD,
                        DETAIL,
                        ZONE,
                        AUTHOR,
                        RECORD_DATE,
                        IS_WORK,
                        VERSION,
                        WEX_ID,
                        MAIN_VERSION,
                        RECORD_IP,
                        RECORD_EMP,
                        PUBLISHING_DATE
                        <cfif arguments.from_cfc eq 1>
                            ,UPDATE_DATE
                            ,UPDATE_IP
                            ,UPDATE_EMP
                        </cfif>
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#data.head#">,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#data.detail#">,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="tr">,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#data.author#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfif arguments.from_cfc eq 1><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
                        <cfif arguments.from_cfc eq 1><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#data.version#"><cfelse><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#data.main_version#"></cfif>,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#data.wex_id#">,
                        <cfif arguments.from_cfc eq 1><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#data.main_version#"><cfelse><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#data.version#"></cfif>,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#CGI.REMOTE_ADDR#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#data.publishing_date#">
                        <cfif arguments.from_cfc eq 1>
                            ,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                            ,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#CGI.REMOTE_ADDR#">
                            ,<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
                        </cfif>
                    )
                </cfquery>
                <cfset return_val = listAppend(return_val,data.wex_id)>
            </cfif>
        </cfloop>
        <cfreturn return_val>
    </cffunction>

    <cffunction  name="get_wex_fnc" access="public">
        <cfargument  name="wex_id">
        <cfargument  name="main_version">
        <cfargument  name="version">
        <cfargument  name="is_work" default="0">
        <cfquery name="get_wex_fnc" datasource="#dsn#">
            SELECT 
                * 
            FROM 
                WRK_DATA_SERVICE 
            WHERE 
                WEX_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wex_id#"> 
                AND VERSION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.main_version#">
                AND MAIN_VERSION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.version#">
                <cfif arguments.is_work neq 0>
                    AND IS_WORK = 1
                </cfif>
        </cfquery>

        <cfreturn get_wex_fnc>
    </cffunction>
    
    <cffunction  name="getDataServiceHistory" access="public">
        <cfargument  name="wex_id">

        <cfquery name="getDataServiceHistory" datasource="#dsn#">
            SELECT 
                * 
            FROM 
                WRK_DATA_SERVICE
            WHERE 
                WEX_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wex_id#">
            ORDER BY   
                RECORD_DATE DESC,
                UPDATE_DATE DESC
        </cfquery>

        <cfreturn getDataServiceHistory>
    </cffunction>

    <cffunction  name="get_release_info" access="public">

        <cfquery name="get_release_info" datasource="#dsn#">
            SELECT TOP 2 * FROM WRK_LICENSE ORDER BY RELEASE_DATE DESC
        </cfquery>

        <cfreturn get_release_info>
    </cffunction>
    
    <cffunction  name="set_returnTrue" access="remote">
        <cfargument  name="row_id">
        <!--- TODO: ıs_work = 1 ise yeni kayıt atılacak --->
        <cfquery name="get_returnTrue"  datasource="#dsn#">
            SELECT * FROM WRK_DATA_SERVICE WHERE WRK_DATA_SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.row_id#"> AND IS_WORK = 1
        </cfquery>

        <cfif get_returnTrue.recordcount neq 0>
            <cfset return_data = this.return_json(data : get_returnTrue)>
            <cfset result_data = deserializeJSON(return_data)>
           <cfset add_dataservice = this.add_dataservice(result_data : result_data, from_cfc : 1)>
        <cfelse>
            <cfquery name="set_returnTrue" datasource="#dsn#">
                UPDATE 
                    WRK_DATA_SERVICE 
                SET 
                    IS_WORK = 1,
                    UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#CGI.REMOTE_ADDR#">,
                    UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
                WHERE 
                    WRK_DATA_SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.row_id#">
            </cfquery>
        </cfif>

        
        <cfreturn Replace(SerializeJSON(1),"//","")>
    </cffunction>
    <!--- Return Json Function --->
    <cffunction  name="return_json" access="public">
        <cfargument  name="data">
        <cfset result = arrayNew(1)>
        <cfloop from="1" to="#data.recordcount#" index="i">
            <cfset arrayAppend(result, queryGetRow(data, i))>
        </cfloop>
        <cfreturn replace(serializeJSON(result), "//", "")>
    </cffunction>
</cfcomponent>