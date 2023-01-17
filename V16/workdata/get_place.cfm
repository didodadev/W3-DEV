<!--- 
	amac            : CITY_NAME,COUNTY_NAME,COUNTRY_NAME vererek CITY_ID,COUNTY_ID,COUNTRY_ bilgisini getirmek
	parametre adi   : city_name
	ayirma isareti  : YOK
	kullanim        : get_place('Afyon',20,2,3) 
	Yazan           : Barbaros KUZ
	Tarih           : 08.08.2007
	Guncelleme      : 
 --->
<cffunction name="get_place" access="public" returnType="query" output="no">
	<cfargument name="place_name" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="">
	<cfargument name="is_type" required="yes" type="string" default="">
	<cfargument name="extra2" required="no" type="string" default="">

	<cfif len(arguments.maxrows)>
		<cfquery name="GET_PLACE" datasource="#DSN#" maxrows="#arguments.maxrows#">
			<cfif arguments.is_type eq 2>
				SELECT
					CITY_ID PLACE_ID,
					CITY_NAME PLACE_NAME
				FROM
					SETUP_CITY
				WHERE
					CITY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.place_name#%">
					<cfif len(arguments.extra2)>
					AND COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.extra2#">
					</cfif>
				ORDER BY
					PLACE_NAME
			<cfelseif arguments.is_type eq 3>
				SELECT
					COUNTY_ID PLACE_ID,
					COUNTY_NAME PLACE_NAME
				FROM
					SETUP_COUNTY
				WHERE
					COUNTY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.place_name#%">
					<cfif len(arguments.extra2)>
					AND CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.extra2#">
					</cfif>
				ORDER BY
					PLACE_NAME		
			<cfelseif arguments.is_type eq 1>
				SELECT
					COUNTRY_ID PLACE_ID,
					COUNTRY_NAME PLACE_NAME
				FROM
					SETUP_COUNTRY
				WHERE
					COUNTRY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.place_name#%">
				ORDER BY
					PLACE_NAME		
			</cfif>
		</cfquery>
	<cfelse>
		<cfquery name="GET_PLACE" datasource="#DSN#">
			<cfif arguments.is_type eq 2>
				SELECT
					CITY_ID PLACE_ID,
					CITY_NAME PLACE_NAME
				FROM
					SETUP_CITY
				WHERE
					CITY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.place_name#%">
				ORDER BY
					PLACE_NAME
			<cfelseif arguments.is_type eq 3>
				SELECT
					COUNTY_ID PLACE_ID,
					COUNTY_NAME PLACE_NAME
				FROM
					SETUP_COUNTY
				WHERE
					COUNTY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.place_name#%">
					<cfif len(arguments.extra2)>
					AND CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.extra2#">
					</cfif>
				ORDER BY
					PLACE_NAME		
			<cfelseif arguments.is_type eq 1>
				SELECT
					COUNTRY_ID PLACE_ID,
					COUNTRY_NAME PLACE_NAME
				FROM
					SETUP_COUNTRY
				WHERE
					COUNTRY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.place_name#%">
				ORDER BY
					PLACE_NAME		
			</cfif>
		</cfquery>
	</cfif>
	<cfreturn get_place>
</cffunction>

