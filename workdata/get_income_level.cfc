<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_INCOME_LEVEL" datasource="#dsn#">
                SELECT 
                    INCOME_LEVEL_ID,
                    #dsn#.Get_Dynamic_Language(INCOME_LEVEL_ID,'#session.ep.language#','SETUP_INCOME_LEVEL','INCOME_LEVEL',NULL,NULL,INCOME_LEVEL) AS INCOME_LEVEL,
                    DETAIL,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP,
                    UPDATE_DATE,
                    UPDATE_EMP,
                    UPDATE_IP
                FROM 
                    SETUP_INCOME_LEVEL
            </cfquery>
          <cfreturn GET_INCOME_LEVEL>
    </cffunction>
</cfcomponent>

