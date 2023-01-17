<cfif len(attributes.old_template_file)>
	<cfif FileExists("#upload_folder#invoice#dir_seperator##attributes.old_template_file#")>
		<cffile action="delete" file="#upload_folder#invoice#dir_seperator##attributes.old_template_file#">
	</cfif>	
</cfif>

<cfquery name="add_" datasource="#dsn3#">
	 DELETE FROM PRINTFORM_INVOICE WHERE FORM_ID = #ATTRIBUTES.FORM_ID#
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
