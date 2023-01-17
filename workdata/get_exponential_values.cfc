<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_EXPO" datasource="#DSN#_#session.ep.company_id#">
                SELECT * FROM ASSEMPTION_EXPONENTIAL_VALUES
            </cfquery>
          <cfreturn GET_EXPO>
    </cffunction>
</cfcomponent>

