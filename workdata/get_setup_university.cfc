<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_SETUP_UNIVERSITY" datasource="#dsn#">
                SELECT * FROM SETUP_UNIVERSITY
            </cfquery>
          <cfreturn GET_SETUP_UNIVERSITY>
    </cffunction>
</cfcomponent>

