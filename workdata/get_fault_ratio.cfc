<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_FAULT_RATIO" datasource="#dsn#">
                SELECT * FROM SETUP_FAULT_RATIO
            </cfquery>
          <cfreturn GET_FAULT_RATIO>
    </cffunction>
</cfcomponent>

