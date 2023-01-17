<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_COMPANY_SIZE_CATS" datasource="#dsn#">
                SELECT * FROM  SETUP_COMPANY_SIZE_CATS
            </cfquery>
          <cfreturn GET_COMPANY_SIZE_CATS>
    </cffunction>
</cfcomponent>

