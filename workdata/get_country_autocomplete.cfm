<cffunction name="get_country_autocomplete" access="public" returnType="query" output="no">
	<cfargument name="country_name" required="yes" type="string">
	<cfquery name="get_country_autocomplete" datasource="#DSN#">
		SELECT
		    '' as CITY_ID,
			'' as CITY_NAME,
			'' as COUNTY_ID,
			'' aS COUNTY_NAME,
			COUNTRY_ID,
			COUNTRY_NAME
		FROM
		    SETUP_COUNTRY
		WHERE
		    COUNTRY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.country_name#%">
	 </cfquery>
	 <cfreturn get_country_autocomplete>
</cffunction>
			
