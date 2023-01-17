<cfquery name="ADD_CONTRACT" datasource="#dsn3#">
	DELETE 
		RELATED_CONTRACT
	WHERE 
		CONTRACT_ID = #attributes.contract_id#
</cfquery>
<cfquery name="DEL_EXCEPTIONS" datasource="#DSN3#">
	DELETE 
		PRICE_CAT_EXCEPTIONS
	WHERE 
		CONTRACT_ID = #attributes.contract_id#
</cfquery>
<cfif not isdefined("attributes.is_popup")>
	<cflocation addtoken="no" url="#request.self#?fuseaction=contract.list_related_contracts">	
<cfelse>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
</cfif>
