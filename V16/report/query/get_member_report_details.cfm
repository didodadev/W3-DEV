<cfquery name="get_report_details" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		MEMBER_REPORTS 
	WHERE 
		REPORT_ID = #attributes.report_id#
</cfquery>
