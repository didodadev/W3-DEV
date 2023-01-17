<cfquery name="GET_ACTION_BILL" datasource="#DSN2#">
	SELECT
		INVOICE_NUMBER
	FROM
		INVOICE
	<!---WHERE
		INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#bill_id#"> --->
</cfquery>
