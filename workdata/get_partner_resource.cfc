<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_PARTNER_RESOURCE" datasource="#dsn#">
                SELECT 
					RESOURCE_ID,
					<cfif isdefined('session.ep.userid') and isDefined('session.ep.language')>
						#dsn#.Get_Dynamic_Language(RESOURCE_ID,'#session.ep.language#','COMPANY_PARTNER_RESOURCE','RESOURCE',NULL,NULL,RESOURCE) AS RESOURCE,
					<cfelseif isdefined('session.pda.userid')>
						#dsn#.Get_Dynamic_Language(RESOURCE_ID,'#session.pda.language#','COMPANY_PARTNER_RESOURCE','RESOURCE',NULL,NULL,RESOURCE) AS RESOURCE,					
					</cfif>
					DETAIL 
				FROM  
					COMPANY_PARTNER_RESOURCE 
				ORDER BY 
					RESOURCE
            </cfquery>
          <cfreturn GET_PARTNER_RESOURCE>
    </cffunction>
</cfcomponent>

