<cfcomponent>


    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="generate">
        <cfargument name="maction" type="string">

        <cfquery name="query_model" datasource="#dsn#">
            SELECT MODELCOMPONENT FROM WRK_MODEL WHERE MODEL_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.maction#'>
        </cfquery>

        <cfreturn query_model.MODELCOMPONENT>
    </cffunction>

</cfcomponent>