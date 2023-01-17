<cfquery name="DEL_PREMIUM" datasource="#DSN3#">
	DELETE FROM MULTILEVEL_SALES_PREMIUM WHERE MULTILEVEL_PREMIUM_ID = #attributes.premium_id#
</cfquery>
<script>
	window.location.href="<cfoutput>#request.self#?fuseaction=settings.add_multilevel_sales_premium</cfoutput>"
</script>

