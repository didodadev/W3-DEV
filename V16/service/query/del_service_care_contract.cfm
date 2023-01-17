<cfquery name="Get_Service_Care_Report" datasource="#dsn3#">
	SELECT FILE_NAME FROM SERVICE_CARE_REPORT WHERE CARE_REPORT_ID = #attributes.id#
</cfquery>
<cfif Len(Get_Service_Care_Report.File_Name) and FileExists("#upload_folder#service#dir_seperator##Get_Service_Care_Report.File_Name#")>
	<cffile action="delete" file="#upload_folder#service#dir_seperator##Get_Service_Care_Report.File_Name#">
</cfif>
<cfquery name="DEL_SERVICE_CARE_REPORT" datasource="#DSN3#">
	DELETE FROM SERVICE_CARE_REPORT WHERE CARE_REPORT_ID = #attributes.id#
</cfquery>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=service.list_service_report</cfoutput>';
</script>
