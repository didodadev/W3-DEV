<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_SPECIAL_STATE_CAT" datasource="#dsn#">
                SELECT * FROM SETUP_SPECIAL_STATE_CAT
            </cfquery>
          <cfreturn GET_SPECIAL_STATE_CAT>
    </cffunction>
</cfcomponent>

