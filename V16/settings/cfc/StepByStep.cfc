<cfcomponent>

<cfset dsn = application.systemParam.systemParam().dsn>
<cfset download_folder = application.systemParam.systemParam().download_folder>

<cffunction name="upd_task_step" access="remote" returntype="any" returnformat="json" hint="Update Step Task Complete">
    <cfargument name="compId" required="yes" type="numeric">
    <cfargument name="stepId" required="yes" type="numeric">
    <cfset result = structNew()>
    <cfset result.STATUS = true>
    <cftry>
        <cfquery name="upd_task_step" datasource="#dsn#">
            UPDATE WRK_IMPLEMENTATION_STEP SET WRK_IMPLEMENTATION_TASK_COMPLETE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.compId#"> WHERE WRK_IMPLEMENTATION_STEP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stepId#">
        </cfquery>
        <cfcatch>
            <cfset result.STATUS = false>
        </cfcatch>
    </cftry>
    <cfreturn replace(serializeJson(result),'//','')>
</cffunction>

<cffunction name="import_implementation_steps" access="remote" returntype="any" returnformat="JSON">
    
    <cfset returnData = structNew()>
    <cfset returnData.status = 1>

    <cftry>
        <cffile action="read" file="#download_folder#WBP/FactorySettings/data_library/main/implementation_step.txt" variable="dosya" charset="utf-8">
        <cfcatch>
            <cfset returnData.status = -1>
            <cfreturn replace(serializeJson(returnData),'//','')>
            <cfabort>
        </cfcatch>
    </cftry>

    <cfscript>
        CRLF = Chr(13) & Chr(10);
        dosya = Replace(dosya,';;','; ;','all');
        dosya = Replace(dosya,';;','; ;','all');
        dosya = ListToArray(dosya,CRLF);
        line_count = ArrayLen(dosya);
    </cfscript>

    <cfset returnData.rows = line_count>

    <cftry>
        <cftransaction>
            <cfquery name="DEL_DATA" datasource="#dsn#">
                TRUNCATE TABLE WRK_IMPLEMENTATION_STEP
            </cfquery>
            <cfloop from="1" to="#line_count#" index="i">
                <cfset str_sql = "SET IDENTITY_INSERT WRK_IMPLEMENTATION_STEP ON " & dosya[i] & " SET IDENTITY_INSERT WRK_IMPLEMENTATION_STEP OFF">
                <cfscript>
                    queryObj = new Query(
                        name="ADD_DATA_ROW",
                        datasource=dsn,
                        sql = str_sql
                    );
                    queryObj.execute();
                </cfscript>
            </cfloop>
        </cftransaction>
        <cfcatch>
            <cfset returnData.status = 0>
            <cfreturn replace(serializeJson(returnData),'//','')>
            <cfabort>
        </cfcatch>
    </cftry>

    <cfreturn replace(serializeJson(returnData),'//','')>
</cffunction>

</cfcomponent>
