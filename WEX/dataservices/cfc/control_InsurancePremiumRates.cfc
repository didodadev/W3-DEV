<!---
    File: WEX\dataservices\cfc\control_InsurancePremiumRates.cfc
    Author: Workcube-Esma Uysal <esmauysal@workcube.com>
    Date: 18.03.2021
    Description: WEX'te tanımlı data servis
    Insurance Premium Rates WEX Control
--->
<cfcomponent extends="dataservices_functions">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <!--- Insurance Premium Rates WEX Control--->
    <cffunction  name="control_InsurancePremiumRates" access="remote"  returntype="string" returnFormat="json">
        <cfargument name="version" type="any" default="">
        <cftry>
            <cfquery name="get_InsurancePremiumRates" datasource="#dsn#">
                SELECT 
                    TOP 1
                    *
                FROM
                    INSURANCE_RATIO
                ORDER BY
                    STARTDATE DESC, 
                    FINISHDATE DESC
            </cfquery>

            <cfset this.initialize(
                type: "change", 
                tableName: "INSURANCE_RATIO", 
                whereColumn: "INS_RAT_ID", 
                identityColumn : "INS_RAT_ID", 
                finishDateColumn : "FINISHDATE", 
                startDateColumn: "STARTDATE", 
                whereColumnParamtype: "timestamp"
            )/>

            <cfset this.returnResult( 
                status: true, 
                dataservices_name: 'InsurancePremiumRates', 
                message: "success", 
                errorMessage: "",
                data: get_InsurancePremiumRates
            ) />
        <cfcatch type="any">
            <cfdump var="#cfcatch#">
            <cfset this.returnResult( 
                status: false, 
                dataservices_name: 'InsurancePremiumRates', 
                message: "", 
                errorMessage: cfcatch
            ) />
        </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>