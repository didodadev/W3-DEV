<!---
    File: WEX\dataservices\cfc\control_salaryFactorDefinaciton.cfc
    Author: Workcube-Esma Uysal <esmauysal@workcube.com>
    Date: 18.03.2021
    Description: WEX'te tanımlı data servis
    Salary Factor Definaciton WEX Control
--->
<cfcomponent extends="dataservices_functions">

    <cfset dsn = application.systemParam.systemParam().dsn>
    <!--- Salary Factor Definaciton WEX Control--->
    <cffunction  name="control_salaryFactorDefinaciton" access="remote"  returntype="string" returnFormat="json">
        <cfargument name="version" type="any" default="">
        <cftry>
            <cfquery name="get_salaryFactorDefinaciton" datasource="#dsn#">
                SELECT 
                    TOP 1
                    *
                FROM
                    SALARY_FACTOR_DEFINITION
                ORDER BY
                    STARTDATE DESC, 
                    FINISHDATE DESC
            </cfquery>
            
            <cfset this.initialize(
                type: "change", 
                tableName: "SALARY_FACTOR_DEFINITION", 
                whereColumn: "ID", 
                identityColumn : "ID", 
                finishDateColumn : 'FINISHDATE', 
                startDateColumn: 'STARTDATE', 
                whereColumnParamtype: "timestamp"
            )/>
            
            <cfset this.returnResult( 
                status: true, 
                dataservices_name: 'salaryFactorDefinaciton', 
                message: "success", 
                errorMessage: "",
                data: get_salaryFactorDefinaciton
            ) />
        <cfcatch type="any">
            <cfdump var="#cfcatch#">
            <cfset this.returnResult( 
                status: false, 
                dataservices_name: 'salaryFactorDefinaciton', 
                message: "", 
                errorMessage: cfcatch
            ) />
        </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>