<cfquery name="del_visitor" datasource="#DSN#">
    DELETE FROM REFINERY_VISITOR_REGISTER WHERE REFINERY_VISITOR_REGISTER_ID = #attributes.id#
</cfquery>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=recycle.facility_visitor</cfoutput>';
</script>