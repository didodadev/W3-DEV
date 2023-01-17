<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_VOCATION_TYPE" datasource="#dsn#">
                SELECT 
                    DETAIL, 
                    FORWARD_SALE_LIMIT,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP,
                    UPDATE_DATE,
                    UPDATE_EMP,
                    UPDATE_IP,
                    VOCATION_TYPE_ID,
                    #dsn#.Get_Dynamic_Language(VOCATION_TYPE_ID,'#session.ep.language#','SETUP_VOCATION_TYPE','VOCATION_TYPE',NULL,NULL,VOCATION_TYPE) AS VOCATION_TYPE 
                FROM SETUP_VOCATION_TYPE
            </cfquery>
          <cfreturn GET_VOCATION_TYPE>
    </cffunction>
</cfcomponent>

