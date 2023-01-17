<cfquery name="del_report" datasource="#dsn#">
	DELETE FROM
		REPORTS
	WHERE
		REPORT_ID = #attributes.REPORT_ID#
</cfquery>
		
<cfquery name="del_report" datasource="#dsn#">
	DELETE FROM
		REPORTS_QUERIES
	WHERE
		REPORT_ID = #attributes.REPORT_ID#
</cfquery>
		
<cflocation url="#request.self#?fuseaction=report.list_reports" addtoken="no">



