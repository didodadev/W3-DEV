<!---
    File: WEX\dataservices\cfc\control_gtipCodes.cfc 
    Author: Workcube-Yunus Cem Özay
    Date: 09.05.2021
    Description: WEX'te tanımlı data servis
    gtipCodes WEX Control
--->
<cfcomponent extends="dataservices_functions">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = application.systemParam.systemParam().dsn&"_product">
    <!--- Gtip Codes WEX Control--->
    <cffunction name="control_gtipCodes" access="remote"  returntype="string" returnFormat="json">
        <cfargument name="version" type="any" default="">
        <cftry>
            <cfquery name="get_gtipCodes" datasource="#dsn1#">
                SELECT
                    *
                FROM
                    HSCODE
            </cfquery>
            
            <cfset this.initialize(
                type: "add",
                tableName: "HSCODE",
                whereColumn: "HSCODE_",
                identityColumn : "HSCODE_ID",
                whereColumnParamtype: "nvarchar",
                dsn: "#dsn1#"
            )/>
            <cfset this.returnResult(
                status: true,
                dataservices_name: 'gtipCodes',
                message: "success",
                errorMessage: "",
                data: get_gtipCodes
            ) />
        <cfcatch type="any">
            <cfdump var="#cfcatch#">
            <cfset this.returnResult(
                status: false,
                dataservices_name: 'gtipCodes',
                message: "",
                errorMessage: cfcatch
            ) />
        </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>