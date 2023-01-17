<cfquery name="get_saved_report" datasource="#dsn#">
	SELECT FILE_NAME,FILE_SERVER_ID FROM SAVED_REPORTS WHERE SR_ID = #attributes.SR_ID#
</cfquery>

<!--- <cftry>
	<cffile action="delete" file="#upload_folder##dir_seperator#report#dir_seperator#saved#dir_seperator##get_saved_report.file_name#">
	<cfcatch type="any"></cfcatch>
</cftry>
 --->
 <cf_del_server_file output_file="report/saved/#get_saved_report.file_name#" output_server="#get_saved_report.file_server_id#">
<cfquery name="del_saved_report" datasource="#dsn#">
	DELETE FROM SAVED_REPORTS WHERE SR_ID = #attributes.SR_ID#
</cfquery>

<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		opener.location.reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		location.reload();
	</cfif>
</script>
