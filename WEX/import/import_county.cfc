<!---
File: WEX/import/city_county.cfc
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Date: 16.09.2021
Controller: -
Description: İllere göre ilçeleri alan wex service

--->
<cfcomponent extends="WEX.dataservices.cfc.dataservices_functions">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="control_importCounty" access="remote" returntype="string" returnFormat="json">
        <cfargument name="extra_param" default="">
        
        <cfset country_code = ListGetAt(arguments.extra_param,1)>
        <cfset country_id =  ListGetAt(arguments.extra_param,2)>
        <cfset city_id =  ListGetAt(arguments.extra_param,3)>
        <cfset city_plate_code =  ListGetAt(arguments.extra_param,4)>
        
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
                FROM   
                    SETUP_CITY 
                WHERE
                    COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CONTROL_COUNTRY.COUNTRY_ID#">
                    AND PLATE_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#city_plate_code#">
            </cfquery>
           
           <cfquery name="GET_COUNTY" datasource="#dsn#">
                SELECT
                    COUNTY_ID
                    ,COUNTY_NAME
                    ,#city_id# CITY
                    ,SPECIAL_STATE_CAT_ID
                    ,RECORD_DATE
                    ,RECORD_EMP
                    ,RECORD_IP
                    ,UPDATE_DATE
                    ,UPDATE_EMP
                    ,UPDATE_IP
                FROM   
                    SETUP_COUNTY 
                WHERE
                    CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CITY.CITY_ID#">
            </cfquery>
            

            <cfset this.initialize(   
                type: "add", 
                tableName: "SETUP_COUNTY",
                whereColumn: "COUNTY_NAME", 
                identityColumn : "COUNTY_ID", 
                whereColumnParamtype: "nvarchar"
            )/>

            <cfset this.returnResult( 
                status: true, 
                dataservices_name: 'control_importCounty', 
                message: "success", 
                errorMessage: "",
                data: GET_COUNTY
            ) />
            <cfcatch type="any">
                <cfset this.returnResult( 
                    status: false, 
                    dataservices_name: 'control_importCounty', 
                    message: "", 
                    errorMessage: cfcatch
                ) />
            </cfcatch>
        </cftry>
    </cffunction>
   
</cfcomponent>