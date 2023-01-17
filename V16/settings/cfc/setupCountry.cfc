<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="addCountry" access="public" returntype="any">
		<cfargument name="country_name" type="string" required="no">
		<cfargument name="country_phone_code" type="string" required="no" default="">
		<cfargument name="country_code" type="string" required="no" default="">
		<cfargument name="is_default" type="numeric" required="no" default="0">
		
		<cfif arguments.is_default eq 1><!---default secili ise oncelikle diger is_defaulttu kaldiriyor--->
			<cfquery name="upd_country_def" datasource="#dsn#">
				UPDATE SETUP_COUNTRY SET IS_DEFAULT=0 WHERE IS_DEFAULT = 1
			</cfquery>
		</cfif>
		<cfquery name="INSERT_COUNTRY" datasource="#DSN#"> 
			INSERT INTO 
				SETUP_COUNTRY
			(
				COUNTRY_NAME,
				COUNTRY_PHONE_CODE,
				COUNTRY_CODE,
				IS_DEFAULT,
				RECORD_IP,
				RECORD_DATE,
				RECORD_EMP
			) 
			VALUES 
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.country_name#">,
				<cfif len(arguments.country_phone_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.country_phone_code#"><cfelse>NULL</cfif>,
				<cfif len(arguments.country_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.country_code#"><cfelse>NULL</cfif>,
				#arguments.is_default#,
				'#cgi.remote_addr#',
				#now()#,
				#session.ep.userid#
			)
		</cfquery>
		
	</cffunction>

	<cffunction name="updCountry" access="public" returntype="any">
		<cfargument name="country_id" type="numeric" required="yes">
		<cfargument name="country_name" type="string" required="no">
		<cfargument name="country_phone_code" type="string" required="no" default="">
		<cfargument name="country_code" type="string" required="no" default="">
		<cfargument name="is_default" type="numeric" required="no" default="0">
		
		<cfif arguments.is_default eq 1><!---default secili ise oncelikle diger is_defaulttu kaldiriyor--->
			<cfquery name="upd_country_def" datasource="#dsn#">
				UPDATE SETUP_COUNTRY SET IS_DEFAULT=0 WHERE IS_DEFAULT = 1
			</cfquery>
		</cfif>
		<cfquery name="UPDATE_COUNTRY" datasource="#DSN#">
			UPDATE 
				SETUP_COUNTRY
			SET 
				COUNTRY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.country_name#">,
				COUNTRY_PHONE_CODE = <cfif len(arguments.country_phone_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.country_phone_code#"><cfelse>NULL</cfif>,
				COUNTRY_CODE = <cfif len(arguments.country_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.country_code#"><cfelse>NULL</cfif>,
				IS_DEFAULT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_default#">,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> 
			WHERE 
				COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.country_id#">
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="getCountry" access="public" returntype="query">
		<cfargument name="country_id" type="numeric" required="yes" default="0">
		<cfargument name="sortdir" type="string" required="no" default="ASC">
		<cfargument name="sortfield" type="string" required="no" default="COUNTRY_NAME">
		<cfquery name="get_country_list" datasource="#dsn#">
			SELECT 
				COUNTRY_ID,
				CASE
					WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
					ELSE COUNTRY_NAME
				END AS COUNTRY_NAME,
				COUNTRY_PHONE_CODE,
				COUNTRY_CODE,
				IS_DEFAULT
			FROM 
				SETUP_COUNTRY
				LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_COUNTRY.COUNTRY_ID
				AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="COUNTRY_NAME">
				AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_COUNTRY">
				AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
			<cfif arguments.country_id gt 0>
				WHERE
					COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.country_id#">
			</cfif>
			ORDER BY 
				#arguments.sortfield# #arguments.sortdir# 
		</cfquery>
		<cfreturn get_country_list>
	</cffunction>
</cfcomponent>
