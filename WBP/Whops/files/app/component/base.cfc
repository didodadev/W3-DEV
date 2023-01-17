<cfcomponent>
    <cffunction name = "getSystemParam" returnType="any">
        <cfreturn application.systemParam.systemParam() />
    </cffunction>
    <cffunction name = "getWo" returnType="query">
        <cfargument name="wo" type="string" required="yes">
        <cfquery name="get_wo" datasource="#this.getSystemParam().dsn#">
            SELECT
                WINDOW,
                FILE_PATH,
                DICTIONARY_ID,
                CASE WHEN ADDOPTIONS_CONTROLLER_FILE_PATH IS NOT NULL THEN ADDOPTIONS_CONTROLLER_FILE_PATH ELSE CONTROLLER_FILE_PATH END AS CONTROLLER_FILE_PATH,
                MODULE_NO,
                FRIENDLY_URL,
                IS_LEGACY,
                ISNULL(LICENCE,1) AS LICENCE,
                HEAD,
                DISPLAY_BEFORE_PATH,
                DISPLAY_AFTER_PATH,
                ACTION_BEFORE_PATH,
                ACTION_AFTER_PATH,
                DATA_CFC,
                TYPE,
                SECURITY,
                XML_PATH
            FROM
                WRK_OBJECTS
            WHERE
                FULL_FUSEACTION = <cfqueryparam value = "#arguments.wo#" CFSQLType = "cf_sql_nvarchar">
        </cfquery>
        <cfreturn get_wo />
    </cffunction>
</cfcomponent>