<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_PERFORM_CATS" datasource="#dsn#">
                SELECT * FROM SETUP_PERFORM_CATS
            </cfquery>
          <cfreturn GET_PERFORM_CATS>
    </cffunction>
</cfcomponent>

