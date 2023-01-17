<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_ALLOCATE_REASON" datasource="#dsn#">
                SELECT * FROM SETUP_ALLOCATE_REASON
            </cfquery>
          <cfreturn GET_ALLOCATE_REASON>
    </cffunction>
</cfcomponent>

