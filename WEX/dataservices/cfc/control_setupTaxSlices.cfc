<!---
    File: WEX\dataservices\cfc\control_setupTaxSlices.cfc
    Author: Workcube-Esma Uysal <esmauysal@workcube.com>
    Date: 18.03.2021
    Description: WEX'te tanımlı data servis
    Setup Tax Slices WEX Control
--->
<cfcomponent extends="dataservices_functions">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <!--- Setup Tax Slices WEX Control--->
    <cffunction  name="control_setupTaxSlices" access="remote"  returntype="string" returnFormat="json">
        <cfargument name="version" type="any" default="">
        <cftry>
            <cfquery name="get_setupTaxSlices" datasource="#dsn#">
                SELECT 
                    TOP 1
                    *
                FROM
                    SETUP_TAX_SLICES
                ORDER BY
                    STARTDATE DESC, 
                    FINISHDATE DESC
            </cfquery>

            <cfset this.initialize(
                type: "change", 
                tableName: "SETUP_TAX_SLICES", 
                whereColumn: "TAX_SL_ID", 
                identityColumn : "TAX_SL_ID", 
                finishDateColumn : 'FINISHDATE', 
                startDateColumn: 'STARTDATE',
                whereColumnParamtype: "timestamp"
            )/>

            <cfset this.returnResult( 
                status: true, 
                dataservices_name: 'setupTaxSlices', 
                message: "success", 
                errorMessage: "",
                data: get_setupTaxSlices               
            ) />
        <cfcatch type="any">
            <cfdump var="#cfcatch#">
            <cfset this.returnResult( 
                status: false, 
                dataservices_name: 'setupTaxSlices', 
                message: "", 
                errorMessage: cfcatch
            ) />
        </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>