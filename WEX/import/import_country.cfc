<!---
File: WEX\import\import_country.cfc
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Date: 16.09.2021
Controller: -
Description: Ülke'leri alan WEX dosyası

--->
<cfcomponent extends="WEX.dataservices.cfc.dataservices_functions">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="CONTROL_IMPORTCOUNTRY" access="remote" returntype="string" returnFormat="json">
        <cftry>
            <cfquery name="CONTROL_IMPORTCOUNTRY" datasource="#dsn#">
                SELECT
                *
                FROM   
                    SETUP_COUNTRY
            </cfquery>

            <cfset this.initialize(   
                    type: "add", 
                    tableName: "SETUP_COUNTRY",
                    whereColumn: "COUNTRY_CODE", 
                    identityColumn : "COUNTRY_ID", 
                    whereColumnParamtype: "nvarchar"
                )/>

                <cfset this.returnResult( 
                    status: true, 
                    dataservices_name: 'importCountry', 
                    message: "success", 
                    errorMessage: "",
                    data: CONTROL_IMPORTCOUNTRY
                ) />
            <cfcatch type="any">
                <cfset this.returnResult( 
                    status: false, 
                    dataservices_name: 'importCountry', 
                    message: "", 
                    errorMessage: cfcatch
                ) />
            </cfcatch>
        </cftry>
    </cffunction>
   
</cfcomponent>