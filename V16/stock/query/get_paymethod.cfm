<cfquery name="PAYMETHOD" datasource="#DSN#">
	SELECT
		PAYMETHOD_ID
	FROM
		SETUP_PAYMETHOD
	WHERE
		PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paymethod_id#">
</cfquery>
