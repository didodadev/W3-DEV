<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_STOCKBOND_TYPE" datasource="#dsn#">
                SELECT 
                    STOCKBOND_TYPE_ID,
                    #dsn#.Get_Dynamic_Language(STOCKBOND_TYPE_ID,'#session.ep.language#','SETUP_STOCKBOND_TYPE','STOCKBOND_TYPE',NULL,NULL,STOCKBOND_TYPE) AS STOCKBOND_TYPE,
                    DETAIL,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP,
                    UPDATE_DATE,
                    UPDATE_EMP,
                    UPDATE_IP
                FROM 
                    SETUP_STOCKBOND_TYPE
            </cfquery>
          <cfreturn GET_STOCKBOND_TYPE>
    </cffunction>
</cfcomponent>

