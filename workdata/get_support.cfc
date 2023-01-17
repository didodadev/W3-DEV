<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_SUPPORT" datasource="#dsn#">
                SELECT 
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP,
                    UPDATE_DATE,
                    UPDATE_EMP,
                    UPDATE_IP,
                    CASE
                        WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
                        ELSE SUPPORT_CAT
                    END AS SUPPORT_CAT,
                    SUPPORT_CAT_ID
                FROM 
                    SETUP_SUPPORT
                    LEFT JOIN #DSN#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_SUPPORT.SUPPORT_CAT_ID
                    AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SUPPORT_CAT">
                    AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_SUPPORT">
                    AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
            </cfquery>
          <cfreturn GET_SUPPORT>
    </cffunction>
</cfcomponent>

