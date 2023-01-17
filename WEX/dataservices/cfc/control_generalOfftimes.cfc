<!---
    File: WEX\dataservices\cfc\control_offtimes.cfc
    Author: Workcube-Alper Çitmen <alpercitmen@workcube.com>
    Date: 14.07.2021
    Description: WEX'te tanımlı data servis
    Offtimes WEX Control
--->
<cfcomponent extends="dataservices_functions">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <!--- Offtimes WEX Control--->
    <cffunction name="control_generalOfftimes" access="remote"  returntype="string" returnFormat="json">
        <cfargument name="version" type="any" default="">
        <cftry>
            <cfquery name="get_offtimes" datasource="#dsn#">
                SELECT
                    *
                FROM
                    SETUP_GENERAL_OFFTIMES
                ORDER BY
                    START_DATE DESC, 
                    FINISH_DATE DESC
            </cfquery>

            <cfset this.initialize(
                type: "change", 
                tableName: "SETUP_GENERAL_OFFTIMES", 
                whereColumn: "OFFTIME_ID", 
                identityColumn : "OFFTIME_ID", 
                finishDateColumn : 'FINISH_DATE', 
                startDateColumn: 'START_DATE',
                whereColumnParamtype: "integer"
            )/>

            <cfset this.returnResult( 
                status: true, 
                dataservices_name: 'generalOfftimes', 
                message: "success", 
                errorMessage: "",
                data: get_offtimes               
            ) />
        <cfcatch type="any">
            <cfdump var="#cfcatch#">
            <cfset this.returnResult( 
                status: false, 
                dataservices_name: 'generalOfftimes', 
                message: "", 
                errorMessage: cfcatch
            ) />
        </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>