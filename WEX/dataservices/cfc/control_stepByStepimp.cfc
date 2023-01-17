<!---
    File: WEX\dataservices\cfc\control_stepbystepimp.cfc 
    Author: Workcube-Fatih Kara <fatih.kara@workcube.com>
    Date: 16.10.2021
    Description: WEX'te tanımlı data servis
    stepByStepimp WEX Control
--->
<cfcomponent extends="dataservices_functions">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <!--- Stepbystep WEX Control--->
    <cffunction name="control_stepByStepimp" access="remote"  returntype="string" returnFormat="json">
        <cfargument name="version" type="any" default="">
        <cftry>
            <cfquery name="get_stepByStepimp" datasource="#dsn#">
                SELECT
                    *
                FROM
                    WRK_IMPLEMENTATION_STEP
            </cfquery>
            <cfset this.initialize(
                type: "add", 
                tableName: "WRK_IMPLEMENTATION_STEP", 
                whereColumn: "WRK_IMPLEMENTATION_TASK", 
                identityColumn : "WRK_IMPLEMENTATION_STEP_ID", 
                whereColumnParamtype: "integer"
            )/>
            <cfset this.returnResult( 
                status: true, 
                dataservices_name: 'stepByStepimp', 
                message: "success", 
                errorMessage: "",
                data: get_stepByStepimp            
            ) />
        <cfcatch type="any">
            <cfdump var="#cfcatch#">
            <cfset this.returnResult( 
                status: false, 
                dataservices_name: 'stepByStepimp', 
                message: "", 
                errorMessage: cfcatch
            ) />
        </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>