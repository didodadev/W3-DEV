<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_CREDITCARD" datasource="#dsn#">
                SELECT * FROM SETUP_CREDITCARD
            </cfquery>
          <cfreturn GET_CREDITCARD>
    </cffunction>
</cfcomponent>

