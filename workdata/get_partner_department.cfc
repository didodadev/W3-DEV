<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_PARTNER_DEPARTMENT" datasource="#dsn#">
                SELECT * FROM  SETUP_PARTNER_DEPARTMENT
            </cfquery>
          <cfreturn GET_PARTNER_DEPARTMENT>
    </cffunction>
</cfcomponent>

