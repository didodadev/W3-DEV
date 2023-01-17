<cfinclude template="../query/get_history_product_tree.cfm">
<cfquery name="add_sub" datasource="#dsn3#">
	DELETE FROM PRODUCT_TREE WHERE PRODUCT_TREE_ID = #attributes.PRODUCT_TREE_ID#
    DELETE FROM ALTERNATIVE_PRODUCTS WHERE PRODUCT_TREE_ID = #attributes.PRODUCT_TREE_ID#
</cfquery>
<script>
	location.href = document.referrer;
</script>
<!--- <cfif isdefined('attributes.related_tree_id') >
	<script type="text/javascript">
		window.location.href='<cfoutput>#request.self#?fuseaction=prod.list_product_tree&event=upd&product_tree_id=#attributes.related_tree_id#</cfoutput>';
	</script>
<cfelse>
	<script type="text/javascript">
		window.location.href='<cfoutput>#request.self#?fuseaction=prod.list_product_tree&event=upd&stock_id=#attributes.main_stock_id#</cfoutput>';
	</script>
</cfif> --->