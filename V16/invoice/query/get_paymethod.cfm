<cfquery name="GET_PAYMETHOD" datasource="#DSN#">
	SELECT PAYMETHOD,PAYMETHOD_ID,PAYMENT_VEHICLE,DUE_DAY FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paymethod_id#">
</cfquery>
