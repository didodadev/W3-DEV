<cfset attributes.COMMANDMENT_ID= attributes.id>

<cfquery name="get_doc" datasource="#dsn#">
	SELECT
		*
	FROM
		COMMANDMENT
	WHERE
		COMMANDMENT_ID = #attributes.COMMANDMENT_ID#
</cfquery>

<cfset upload_folder = "#upload_folder#ehesap#dir_seperator#">

<cfquery name="add_penalty" datasource="#dsn#" result="get_max">
	DELETE
		COMMANDMENT
	WHERE
		COMMANDMENT_ID = #attributes.COMMANDMENT_ID#
</cfquery>
<cfif len(get_doc.COMMANDMENT_FILE)>
	<cffile action="delete" file="#upload_folder##get_doc.COMMANDMENT_FILE#">
</cfif>
<script type="text/javascript">
	window.location.href = '<cfoutput>index.cfm?fuseaction=ehesap.list_executions</cfoutput>';
</script>