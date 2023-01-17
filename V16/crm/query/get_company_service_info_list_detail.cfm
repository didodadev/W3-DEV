<cfquery name="get_company_service_info_list_detail" datasource="#DSN#">
	SELECT
		*
	FROM
		COMPANY_SERVICE_INFO
	WHERE
		COMPANY_ID = #attributes.cpid# AND 
		OUR_COMPANY_ID = #company_id#
</cfquery>
