<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_RISK_SEGMANTATION" datasource="#dsn#">
                SELECT * FROM SETUP_RISK_SEGMANTATION
            </cfquery>
          <cfreturn GET_RISK_SEGMANTATION>
    </cffunction>
</cfcomponent>

