<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_ASSET_TAKE_SUPPORT_CAT" datasource="#dsn#">
                SELECT * FROM ASSET_TAKE_SUPPORT_CAT
            </cfquery>
          <cfreturn GET_ASSET_TAKE_SUPPORT_CAT>
    </cffunction>
</cfcomponent>

