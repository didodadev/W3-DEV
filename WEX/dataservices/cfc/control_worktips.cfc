<!---
    File: WEX\dataservices\cfc\control_worktips.cfc
    Author: Workcube-Esma Uysal <esmauysal@workcube.com>
    Date: 18.03.2021
    Description: WEX'te tanımlı data servis
    Worktipsler Wex Control
--->
<cfcomponent extends="dataservices_functions">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <!--- Worktipsler Wex Control--->
    <cffunction  name="control_worktips" access="remote"  returntype="string" returnFormat="json">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date"  default="">
        <cftry>
            <!--- TODO: URL Değiştirilecek. record_date value Önce tabloda is_work tarihine bakılacak. geri döüş yoksa versiyon tarihinden sonrakine bakılacak--->
            <cfquery name="get_worktips" datasource="#dsn#">
                SELECT 
                    *
                FROM
                    HELP_DESK
                <cfif isDefined("arguments.start_date") and len(arguments.start_date)>
                    WHERE
                        (
                            UPDATE_DATE IS NULL AND RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
                        )
                        OR
                        UPDATE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
                </cfif>
            </cfquery>

            <cfset this.initialize(   
                type: "add", 
                tableName: "HELP_DESK",
                whereColumn: "HELP_HEAD", 
                identityColumn : "HELP_ID", 
                whereColumnParamtype: "nvarchar"
            )/>

            <cfset this.returnResult( 
                status: true, 
                dataservices_name: 'worktips', 
                message: "success", 
                errorMessage: "",
                data: get_worktips
            ) />
        <cfcatch type="any">
            <cfset this.returnResult( 
                status: false, 
                dataservices_name: 'worktips', 
                message: "", 
                errorMessage: cfcatch
            ) />
        </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>