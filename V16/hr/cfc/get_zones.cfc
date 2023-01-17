<cfcomponent>
<cffunction name="get_zone" access="public" returntype="query">
        <cfquery name="get_zones" datasource="#this.dsn#">
            SELECT 
            	ZONE_ID,
                ZONE_NAME
            FROM 
            	ZONE 
             WHERE 
             	ZONE_STATUS = 1
             ORDER BY 
             	ZONE_NAME        
        </cfquery>
  <cfreturn get_zones>
</cffunction>
</cfcomponent>
