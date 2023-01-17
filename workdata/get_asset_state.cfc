<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_ASSET_STATE" datasource="#dsn#">
                SELECT * FROM ASSET_STATE
            </cfquery>
          <cfreturn GET_ASSET_STATE>
    </cffunction>
</cfcomponent>

