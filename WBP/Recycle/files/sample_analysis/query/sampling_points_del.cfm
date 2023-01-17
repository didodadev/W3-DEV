<cfquery name="del_date" datasource="#DSN#">
    DELETE FROM SAMPLING_POINTS WHERE SAMPLING_ID = #attributes.id#
</cfquery>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=recycle.sampling_points</cfoutput>';
</script>