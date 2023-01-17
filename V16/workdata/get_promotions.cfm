<cffunction name="get_promotions" access="public" returntype="query" output="no">
	<cfargument name="promotion_head" required="yes" type="string">
    <cfquery name="get_promotion" datasource="#dsn3#">
    	SELECT
			PROM_ID,
            PROM_RELATION_ID,
            PROM_HEAD,
            PROM_NO,
            PROM_DETAIL
        FROM
            PROMOTIONS
        WHERE
            PROM_ID IS NOT NULL AND
            PROM_HEAD  LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.promotion_head#%">
       ORDER BY PROM_ID
    </cfquery>
    <cfreturn get_promotion>
</cffunction>

