<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_TRANSPORT_TYPE" datasource="#dsn#">
                SELECT * FROM SETUP_TRANSPORT_TYPES
            </cfquery>
          <cfreturn GET_TRANSPORT_TYPE>
    </cffunction>
</cfcomponent>

