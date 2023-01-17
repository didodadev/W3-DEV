<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_PURCHASE_AUTHORITY" datasource="#dsn#">
                SELECT * FROM SETUP_PURCHASE_AUTHORITY
            </cfquery>
          <cfreturn GET_PURCHASE_AUTHORITY>
    </cffunction>
</cfcomponent>

