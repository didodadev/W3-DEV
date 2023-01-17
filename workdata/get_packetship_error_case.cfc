<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="get_packetship_error_case" datasource="#DSN#">
                SELECT 
                    ERROR_CASE_ID,
                    #dsn#.Get_Dynamic_Language(ERROR_CASE_ID,'#session.ep.language#','PACKETSHIP_ERROR_CASE','ERROR_CASE_NAME',NULL,NULL,ERROR_CASE_NAME) AS ERROR_CASE_NAME,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP,
                    UPDATE_EMP,
                    UPDATE_DATE,
                    UPDATE_IP
                FROM 
                    PACKETSHIP_ERROR_CASE
            </cfquery>
          <cfreturn get_packetship_error_case>
    </cffunction>
</cfcomponent>

