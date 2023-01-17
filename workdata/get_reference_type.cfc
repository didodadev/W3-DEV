<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_REFERENCE_TYPE" datasource="#dsn#">
                SELECT * FROM SETUP_REFERENCE_TYPE
            </cfquery>
          <cfreturn GET_REFERENCE_TYPE>
    </cffunction>
</cfcomponent>

