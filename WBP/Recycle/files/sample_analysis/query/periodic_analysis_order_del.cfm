<cfquery name="del_date" datasource="#DSN#">
    DELETE FROM SAMPLE_POINTS WHERE SAMPLE_POINTS_ID = #attributes.id#
</cfquery>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=recycle.periodic_analysis_order</cfoutput>';
</script>