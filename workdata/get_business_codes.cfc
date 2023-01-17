<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_SETUP_BUSINESS_CODES" datasource="#dsn#">
                SELECT * FROM SETUP_BUSINESS_CODES
            </cfquery>
          <cfreturn GET_SETUP_BUSINESS_CODES>
    </cffunction>
</cfcomponent>

