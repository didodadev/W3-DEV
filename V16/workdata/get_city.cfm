<cffunction name="get_city" access="public" returnType="query" output="no">
	<cfargument name="city_name" required="yes" type="string">
	<cfquery name="get_city" datasource="#DSN#">
		SELECT
			'' as COUNTY_NAME,
			'' as COUNTY_ID, 
			CO.COUNTRY_ID,
			CO.COUNTRY_NAME,
			CITY_ID,
			CITY_NAME
		FROM
			SETUP_CITY CI,
			SETUP_COUNTRY CO
		WHERE
		    CI.COUNTRY_ID = CO.COUNTRY_ID AND
			CITY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.city_name#%">
	</cfquery>
	<cfreturn get_city>
</cffunction> 
			
