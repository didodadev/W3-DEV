<cfquery name="GET_APP_IDENTY" datasource="#DSN#">
	SELECT
		BIRTH_DATE,
		BIRTH_PLACE,
		CITY,
		MARRIED,
		TC_IDENTY_NO
	FROM
		EMPLOYEES_IDENTY
	WHERE
		<cfif isdefined("session.cp.userid")>
			EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
		<cfelse>
			EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
		</cfif>	
</cfquery>
