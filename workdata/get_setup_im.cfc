<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_SETUP_IM" datasource="#dsn#">
                SELECT * FROM SETUP_IM
            </cfquery>
          <cfreturn GET_SETUP_IM>
    </cffunction>
</cfcomponent>

