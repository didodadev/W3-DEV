<cfcomponent>
<cffunction name="get_business_code" access="public" returntype="query">
        <cfquery name="get_business_codes" datasource="#this.dsn#">
            SELECT	
				BUSINESS_CODE_ID,
				BUSINESS_CODE,
				BUSINESS_CODE_NAME 
			FROM 
				SETUP_BUSINESS_CODES 
			ORDER BY
				BUSINESS_CODE_NAME  
        </cfquery>
  <cfreturn get_business_codes>
</cffunction>
</cfcomponent>
