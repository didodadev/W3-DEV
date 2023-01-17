<cffunction name="get_country" access="public" returnType="query" output="no">
	<cfargument name="country_name" required="yes" type="string">
	<cfargument name="city_name" required="yes" type="string">
	<cfquery name="get_country" datasource="#DSN#">
		SELECT 
		    '' as CITY_NAME,
			'' as CITY_ID,
			'' as COUNTY_NAME,
			'' as COUNTY_ID,
			CO.COUNTRY_ID  as COUNTRY,
			COUNTRY_NAME,
			CITY_NAME,
			COUNTY_NAME
		FROM
			SETUP_COUNTRY CO,
			SETUP_CITY CI,
			SETUP_COUNTY COUNTY
		WHERE
			CO.COUNTRY_ID=CI.COUNTRY_ID AND
			COUNTY.CITY=CI.CITY_ID AND
			(
				COUNTRY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.country_name#%"> OR
				CITY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.city_name#%">
			)
	</cfquery>
	<cfreturn get_country>
</cffunction>
				
