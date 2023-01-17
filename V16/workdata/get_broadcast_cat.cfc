<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_BROADCAST_CAT" datasource="#dsn#">
                SELECT * FROM BROADCAST_CAT
            </cfquery>
          <cfreturn GET_BROADCAST_CAT>
    </cffunction>
</cfcomponent>

