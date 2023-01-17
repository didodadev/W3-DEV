<cfcomponent>
	<cffunction name="get_period_year" access="public" returntype="query">		
        <cfquery name="get_period_year" datasource="#this.dsn#">
			SELECT PERIOD_YEAR FROM SETUP_PERIOD GROUP BY PERIOD_YEAR      
        </cfquery>
  		<cfreturn get_period_year>
	</cffunction>
</cfcomponent>
