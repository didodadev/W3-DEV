<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_CREDIT_TYPE" datasource="#dsn#">
                SELECT 
                    CREDIT_TYPE_ID,
                    #dsn#.Get_Dynamic_Language(CREDIT_TYPE_ID,'#session.ep.language#','SETUP_CREDIT_TYPE','CREDIT_TYPE',NULL,NULL,CREDIT_TYPE) AS CREDIT_TYPE,
                    RECORD_EMP,
                    RECORD_IP,
                    RECORD_DATE,
                    UPDATE_EMP,
                    UPDATE_IP,
                    UPDATE_DATE
                FROM 
                    SETUP_CREDIT_TYPE
            </cfquery>
          <cfreturn GET_CREDIT_TYPE>
    </cffunction>
</cfcomponent>

