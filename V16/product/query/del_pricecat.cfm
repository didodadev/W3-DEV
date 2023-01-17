<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="DEL_PRICE_CAT" datasource="#DSN3#">
			DELETE
				PRICE_CAT
			WHERE
				PRICE_CATID = #attributes.pcat_id#
		</cfquery>
		<cfquery name="DEL_PRICE" datasource="#DSN3#">
			DELETE
				PRICE 
			WHERE
				PRICE_CATID = #attributes.pcat_id#
		</cfquery>
		<cfquery name="DEL_PRICE_HISTORY" datasource="#DSN3#">
			DELETE
				PRICE_HISTORY
			WHERE
				PRICE_CATID = #attributes.pcat_id#
		</cfquery>
		<cfquery name="DEL_PRICE_CAT_ROWS" datasource="#DSN3#">
			DELETE
				PRICE_CAT_ROWS
			WHERE
				PRICE_CATID = #attributes.pcat_id#
		</cfquery>
	</cftransaction>
</cflock>
<cfset attributes.actionId = #attributes.pcat_id# >
<script type="text/javascript">
	window.location.href = "<cfoutput>#request.self#?fuseaction=product.list_price_cat</cfoutput>";
</script>
