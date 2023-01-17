<cfif isdefined("attributes.pursuit_type") and attributes.pursuit_type is "is_sale_order">
 	<cfset database_name = dsn3>
	<cfset main_table_name = "ORDERS">
	<cfset plus_table_name = "ORDER_PLUS">
	<cfset main_column_name = "ORDER_ID">
	<cfset plus_column_name = "ORDER_PLUS_ID">
	<cfset head_column_name = ",ORDER_HEAD">
<cfelseif isdefined("attributes.pursuit_type") and attributes.pursuit_type is "is_sale_invoice">
	<cfset database_name = dsn2>
	<cfset main_table_name = "INVOICE">
	<cfset plus_table_name = "INVOICE_PURSUIT_PLUS">
	<cfset main_column_name = "INVOICE_ID">
	<cfset plus_column_name = "INVOICE_PLUS_ID">
	<cfset head_column_name = "">
<cfelseif isdefined("attributes.pursuit_type") and attributes.pursuit_type is "is_service_application">
	<cfset database_name = dsn3>
	<cfset main_table_name = "SERVICE">
	<cfset plus_table_name = "SERVICE_PLUS">
	<cfset main_column_name = "SERVICE_ID">
	<cfset plus_column_name = "SERVICE_PLUS_ID">
	<cfset head_column_name = ",SERVICE_HEAD">
</cfif>
<cfquery name="get_pursuit" datasource="#database_name#">
	SELECT
		COMPANY_ID,
		PARTNER_ID,
		CONSUMER_ID
		#head_column_name#
	FROM
		#main_table_name#
	WHERE
		#main_column_name# = #attributes.action_id#
</cfquery>
<cfquery name="get_pursuit_plus" datasource="#database_name#">
	SELECT
		#plus_column_name# ACTION_PLUS_NAME,
		*
	FROM
		#plus_table_name#
	WHERE
		#main_column_name# = #attributes.action_id#
</cfquery>

