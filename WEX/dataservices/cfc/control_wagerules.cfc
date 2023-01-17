<!---
    File: WEX\dataservices\cfc\control_wagerules.cfc
    Author: Workcube-Esma Uysal <esmauysal@workcube.com>
    Date: 18.03.2021
    Description: WEX'te tanımlı data servis
    Wage Rules Wex Control
--->
<cfcomponent extends="dataservices_functions">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <!--- Wage Rules Wex Control --->
    <cffunction  name="control_wagerules" access="remote"  returntype="string" returnFormat="json">
        <cfargument name="version" type="any" default="">
        <cftry>
            <cfquery name="get_insurance_payments" datasource="#dsn#">
                SELECT 
                    TOP 1
                    *
                FROM
                    INSURANCE_PAYMENT
                ORDER BY
                    STARTDATE DESC, 
                    FINISHDATE DESC
            </cfquery>

            <cfset this.initialize(   
                type: "change", 
                tableName: "INSURANCE_PAYMENT", 
                whereColumn: "INS_PAY_ID", 
                identityColumn : "INS_PAY_ID", 
                finishDateColumn : "FINISHDATE", 
                startDateColumn: "STARTDATE", 
                whereColumnParamtype: "timestamp"
            )/>
            
            <cfset this.returnResult( 
                status: true, 
                dataservices_name: 'wagerules', 
                message: "success", 
                errorMessage: "",
                data: get_insurance_payments
            ) />
        <cfcatch type="any">
            <cfdump var="#cfcatch#">
            <cfset this.returnResult( 
                status: false, 
                dataservices_name: 'wagerules', 
                message: "", 
                errorMessage: cfcatch
            ) />
        </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>