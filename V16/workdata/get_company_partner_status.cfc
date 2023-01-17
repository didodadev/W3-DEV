<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_COMPANY_PARTNER_STATUS" datasource="#dsn#">
                SELECT * FROM  COMPANY_PARTNER_STATUS
            </cfquery>
          <cfreturn GET_COMPANY_PARTNER_STATUS>
    </cffunction>
</cfcomponent>

