<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_INTERACTION_CATS" datasource="#dsn#">
                SELECT * FROM SETUP_INTERACTION_CAT
            </cfquery>
          <cfreturn GET_INTERACTION_CATS>
    </cffunction>
</cfcomponent>

