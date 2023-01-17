<!---
    File: WEX/dataservices/cfc/control_gtipCodesChapter.cfc 
    Author: Workcube-Yunus Cem Özay
    Date: 11.05.2021
    Description: WEX'te tanımlı data servis
    gtipCodesChapter WEX Control
--->
<cfcomponent extends="dataservices_functions">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = application.systemParam.systemParam().dsn&"_product">
    <!--- Gtip Codes Chapter WEX Control--->
    <cffunction name="control_gtipCodes" access="remote"  returntype="string" returnFormat="json">
        <cfargument name="version" type="any" default="">
        <cftry>
            <cfquery name="get_gtipCodesChapter" datasource="#dsn1#">
                SELECT
                    *
                FROM
                    HSCODE_CHAPTER
            </cfquery>
            
            <cfset this.initialize(
                type: "add",
                tableName: "HSCODE_CHAPTER",
                whereColumn: "HSCHAPTER_NO",
                identityColumn : "HSCHAPTER_ID",
                whereColumnParamtype: "integer",
                dsn: "#dsn1#"
            )/>
            <cfset this.returnResult(
                status: true,
                dataservices_name: 'gtipCodesChapter',
                message: "success",
                errorMessage: "",
                data: get_gtipCodesChapter
            ) />
        <cfcatch type="any">
            <cfdump var="#cfcatch#">
            <cfset this.returnResult(
                status: false,
                dataservices_name: 'gtipCodesChapter',
                message: "",
                errorMessage: cfcatch
            ) />
        </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>