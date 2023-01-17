<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_TARGET_CAT" datasource="#dsn#">
                SELECT * FROM TARGET_CAT
            </cfquery>
          <cfreturn GET_TARGET_CAT>
    </cffunction>
</cfcomponent>

