<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_COST_TYPE" datasource="#dsn#">
                SELECT * FROM SETUP_COST_TYPE
            </cfquery>
          <cfreturn GET_COST_TYPE>
    </cffunction>
</cfcomponent>

