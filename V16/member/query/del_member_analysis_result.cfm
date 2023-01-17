<cfquery name="DEL_QUESTION" datasource="#DSN#">
	DELETE FROM 
		MEMBER_ANALYSIS_RESULTS 
	WHERE 
		RESULT_ID = #attributes.result_id#
</cfquery>
<cfquery name="DEL_QUESTION" datasource="#DSN#">
	DELETE FROM 
		MEMBER_ANALYSIS_RESULTS_DETAILS 
	WHERE 
		RESULT_ID = #attributes.result_id#
</cfquery>

<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=member.list_analysis&event=det&analysis_id=#attributes.analysis_id#</cfoutput>';
</script>

