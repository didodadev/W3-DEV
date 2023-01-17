<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_IDENTYCARD" datasource="#dsn#">
                SELECT 
                    IDENTYCAT_ID,
                    #dsn#.Get_Dynamic_Language(IDENTYCAT_ID,'#session.ep.language#','SETUP_IDENTYCARD','IDENTYCAT',NULL,NULL,IDENTYCAT) AS IDENTYCAT,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP,
                    UPDATE_EMP,
                    UPDATE_DATE,
                    UPDATE_IP
                FROM 
                    SETUP_IDENTYCARD
            </cfquery>
          <cfreturn GET_IDENTYCARD>
    </cffunction>
</cfcomponent>

