<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT DISTINCT
		CONSCAT_ID,
		CONSCAT,
		HIERARCHY
	FROM
		GET_MY_CONSUMERCAT
	WHERE
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	<!--- Ekleme sayfasından geliyorsa kategorinin aktiflik durumuna bakıyor --->	
	<cfif isdefined("attributes.is_active_consumer_cat")>
		AND IS_ACTIVE = 1
	</cfif>
	ORDER BY
		CONSCAT	
</cfquery>
