<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_ACTIVITY_TYPES" datasource="#dsn#">
                SELECT * FROM SETUP_ACTIVITY_TYPES
            </cfquery>
          <cfreturn GET_ACTIVITY_TYPES>
    </cffunction>
</cfcomponent>

