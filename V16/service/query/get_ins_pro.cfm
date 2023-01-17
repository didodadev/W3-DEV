<cfquery name="get_ins_pro" datasource="#dsn3#">
	SELECT
		*
	FROM
		SERVICE_INS_PRODUCT
	WHERE
		SERVICE_ID = #attributes.service_id#
</cfquery>
