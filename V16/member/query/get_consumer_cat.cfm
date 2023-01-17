<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT DISTINCT
		CASE
			WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
			ELSE CONSCAT
		END AS CONSCAT,
		CONSCAT_ID,
		HIERARCHY
	FROM
		GET_MY_CONSUMERCAT
		LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = GET_MY_CONSUMERCAT.CONSCAT_ID
		AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="CONSCAT">
		AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="CONSUMER_CAT">
		AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
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

