<cfquery name="get_file" datasource="#dsn#">
	SELECT
		FILE_NAME,
		FILE_SERVER_ID
	FROM
		REPORTS
	WHERE
		REPORT_ID = #attributes.REPORT_ID#
</cfquery>
<cf_del_server_file output_file="report/#get_file.file_name#" output_server="#get_file.file_server_id#">
<cfquery name="del_report" datasource="#dsn#">
	DELETE FROM
		REPORTS
	WHERE
		REPORT_ID = #attributes.REPORT_ID#
</cfquery>
<cfquery name="del_access_rights" datasource="#dsn#">
	DELETE FROM
		REPORT_ACCESS_RIGHTS
	WHERE
		REPORT_ID = #attributes.REPORT_ID#
</cfquery>
<cfif CGI.HTTP_HOST is "ep.workcube" and isdefined("attributes.old_file_name")>
	<cfquery name="get_file_member" datasource="#dsn_dev#">
		SELECT
			DOC_NAME
		FROM
			CUSTOMER_FILES
		WHERE
			FILE_ID = #attributes.REPORT_ID#
	</cfquery>
<cftry> 
	<cfcatch type="any">
	   <CFFILE action="delete" file="#upload_folder##dir_seperator#member#dir_seperator##get_file_member.DOC_NAME#">
	</cfcatch> 
</cftry>
	<cfquery name="del_report_member" datasource="#dsn_dev#">
		DELETE FROM
			CUSTOMER_FILES
		WHERE
			FILE_ID = #attributes.REPORT_ID#
	</cfquery>
</cfif>

<cflocation url="#request.self#?fuseaction=report.list_reports" addtoken="no">
