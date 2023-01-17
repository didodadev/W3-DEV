<cfcomponent>
	<cffunction name="get_notice" access="public" returntype="query">
        <cfquery name="get_notice_" datasource="#this.dsn#">
			SELECT 
				NOTICE_CAT_ID,
				NOTICE_ID,
				NOTICE_HEAD,
				NOTICE_NO,
				STATUS 
			FROM 
				NOTICES 
			ORDER BY 
				NOTICE_HEAD        
        </cfquery>
  		<cfreturn get_notice_>
	</cffunction>
</cfcomponent>
