<cffunction name="get_county" access="public" returnType="query" output="no">
	<cfargument name="county_name" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="-1">
	<cfargument name="city_id" required="no" type="string" default="">
	<cfquery name="get_county" datasource="#DSN#">
		SELECT 
			CI.CITY_NAME,
			CI.CITY_ID,
			COUN.COUNTRY_NAME,
			COUN.COUNTRY_ID,
			COUNTY_ID,
			co.COUNTY_NAME
		FROM
			SETUP_COUNTRY COUN,
			SETUP_COUNTY CO,
			SETUP_CITY CI
		WHERE
		    COUN.COUNTRY_ID=CI.COUNTRY_ID AND
			CO.CITY=CI.CITY_ID AND
			 <cfif Len(arguments.city_id)>
				CI.CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.city_id#"> AND
			</cfif> 
			(
				COUNTY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.county_name#%"> OR
				CITY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.county_name#%">
			)
	</cfquery>
	<cfreturn get_county>
</cffunction>
			  
