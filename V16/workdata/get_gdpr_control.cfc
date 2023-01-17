<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="CONTROL_GDPR" datasource="#dsn#">
            SELECT SENSITIVITY_LABEL_ID FROM GDPR_SENSITIVITY_LABEL
             WHERE SENSITIVITY_LABEL_ID  IN (<cfqueryparam cfsqltype='integer' value='#session.ep.dockphone#' list="yes">)  
        </cfquery>
          <cfreturn CONTROL_GDPR>
    </cffunction>
    <cffunction name="getComponentFunctionGDPR">
        <cfargument name="gdpr_" default="">
        <cfquery name="GET_GDPR" dbtype="query">
            SELECT SENSITIVITY_LABEL_ID FROM CONTROL_GDPR WHERE SENSITIVITY_LABEL_ID IN (<cfqueryparam cfsqltype='integer' value='#arguments.gdpr_#' list="yes">)
        </cfquery>
          <cfreturn GET_GDPR>
    </cffunction>
</cfcomponent>

