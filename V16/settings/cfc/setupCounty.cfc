<cfcomponent>
	<cffunction name="ADD_COUNTY_FNC" access="public" returntype="any">
		<cfargument name="county_name" type="string" required="no">
		<cfargument name="city_id" type="numeric" required="no" default="0">
		<cfargument name="special_state" type="string" required="no" default="">
		<cfquery name="Add_County" datasource="#this.dsn#">
			INSERT INTO 
				SETUP_COUNTY
			(
				COUNTY_NAME,
				CITY,
				SPECIAL_STATE_CAT_ID,
				RECORD_IP,
				RECORD_DATE,
				RECORD_EMP		
			) 
			VALUES 
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.county_name#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.city_id#">,
				<cfif len(arguments.special_state)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.special_state#"><cfelse>NULL</cfif>,
				'#cgi.remote_addr#',
				#now()#,
				#session.ep.userid#
			)
		</cfquery>
	</cffunction>

	<cffunction name="UPD_COUNTY_FNC" access="public" returntype="any">
		<cfargument name="county_id" type="numeric" required="no" default="0">
		<cfargument name="county_name" type="string" required="no">
		<cfargument name="city_id" type="numeric" required="no" default="0">
		<cfargument name="special_state" type="string" required="no" default="">
		<cfquery name="UPD_COUNTY" datasource="#this.dsn#">
			UPDATE 
				SETUP_COUNTY
			SET 
				COUNTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.county_name#">,
				CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.city_id#">,
				SPECIAL_STATE_CAT_ID = <cfif len(arguments.special_state)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.special_state#"><cfelse>NULL</cfif>,
				UPDATE_IP = '#cgi.remote_addr#',
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#
			WHERE 
				COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.county_id#">
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="getCounty" access="public" returntype="query">
		<cfargument name="county_id" type="numeric" required="yes" default="0">
		<cfargument name="sortdir" type="string" required="no" default="ASC">
		<cfargument name="sortfield" type="string" required="no" default="COUNTY_NAME">
		
		<cfquery name="Get_County" datasource="#this.dsn#">
			SELECT 
				*
			FROM 
				SETUP_COUNTY
				<cfif arguments.county_id gt 0>
					WHERE
						COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.county_id#">
				</cfif>
			ORDER BY 
				#arguments.sortfield# #arguments.sortdir# 
		</cfquery>
		<cfreturn Get_County>
	</cffunction>
</cfcomponent>
