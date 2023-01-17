<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="getComponentFunction">
        <cfquery name="GET_PUNISHMENT_TYPE" datasource="#dsn#">
            SELECT * FROM SETUP_PUNISHMENT_TYPE
        </cfquery>
        <cfreturn GET_PUNISHMENT_TYPE>        
    </cffunction>
</cfcomponent>
