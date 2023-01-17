<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_VISIT_TYPES" datasource="#dsn#">
                SELECT * FROM SETUP_VISIT_TYPES
            </cfquery>
          <cfreturn GET_VISIT_TYPES>
    </cffunction>
</cfcomponent>

