<!---
File: WEX\import\import_country.cfc
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Date: 16.09.2021
Controller: -
Description: Ülke'leri alan WEX dosyası

--->
<cfcomponent extends="WEX.dataservices.cfc.dataservices_functions">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="control_importCity" access="remote" returntype="string" returnFormat="json">
        <cfargument name="extra_param" default="">
        
        <cfset country_code = listFirst(arguments.extra_param)>
        <cfset country_id =  listLast(arguments.extra_param)>
        
        <cftry>
            <!--- İlk Olarak Ülke Id si bulunur. --->
            <cfquery name="CONTROL_COUNTRY" datasource="#dsn#">
                SELECT
                    COUNTRY_ID
                FROM   
                    SETUP_COUNTRY 
                WHERE
                    COUNTRY_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#country_code#">
            </cfquery>
            
            <cfquery name="GET_CITY" datasource="#dsn#">
                SELECT
                    CITY_ID
                    ,CITY_NAME
                    ,PHONE_CODE
                    ,PLATE_CODE
                    ,#country_id# AS COUNTRY_ID
                    ,RECORD_DATE
                    ,RECORD_EMP
                    ,RECORD_IP
                    ,UPDATE_DATE
                    ,UPDATE_EMP
                    ,UPDATE_IP
                    ,PRIORITY
                FROM   
                    SETUP_CITY 
                WHERE
                    COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CONTROL_COUNTRY.COUNTRY_ID#">
            </cfquery>
           
            <cfset this.initialize(   
                type: "add", 
                tableName: "SETUP_CITY",
                whereColumn: "PLATE_CODE", 
                identityColumn : "CITY_ID", 
                whereColumnParamtype: "nvarchar"
            )/>

            <cfset this.returnResult( 
                status: true, 
                dataservices_name: 'importCity', 
                message: "success", 
                errorMessage: "",
                data: GET_CITY
            ) />
            <cfcatch type="any">
                <cfset this.returnResult( 
                    status: false, 
                    dataservices_name: 'importCity', 
                    message: "", 
                    errorMessage: cfcatch
                ) />
            </cfcatch>
        </cftry>
    </cffunction>
   
</cfcomponent>