<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getCompenentFunction">
        <cfargument name="keyword" default="">
        <cfquery name="getService_" datasource="#dsn#_#session.ep.company_id#">
                SELECT  
                    SERVICE_ID,
					SERVICE_NO,
					SERVICE_HEAD,
					CONVERT(VARCHAR(30), APPLY_DATE, 103)+' '+CONVERT(VARCHAR(30), APPLY_DATE, 108) APPLY_DATE
                FROM 
                    SERVICE
                WHERE 
					SERVICE_ID IS NOT NULL
				<cfif len(arguments.keyword)>
					AND (
						SERVICE.SERVICE_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
						SERVICE.SERVICE_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
						SERVICE.SERVICE_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
						SERVICE.SUBSCRIPTION_ID IN (
													SELECT 
														SUBSCRIPTION_ID
													FROM 
														SUBSCRIPTION_CONTRACT 
													WHERE 
													  SUBSCRIPTION_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
													)
						)
				</cfif>
        </cfquery>
        <cfreturn getService_>
    </cffunction>
</cfcomponent>

