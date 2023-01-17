<cfsetting showdebugoutput="no">
<!---History Bilgsini tutmak için EÖZ20120710--->
	<cfinclude template="../query/get_history_product_tree.cfm">
<!---History--->
<cfquery name="upd_prod_tree" datasource="#dsn3#">
	UPDATE PRODUCT_TREE SET IS_PHANTOM = <cfif attributes.is_phantom eq 1>1<cfelse>0</cfif> WHERE PRODUCT_TREE_ID = #attributes.tree_id#
</cfquery>
<script type="text/javascript">
	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=prod.emptypopupajax_function_product_tree&pro_tree_id=#attributes.pro_tree_id#&stock_id=#attributes.stock_id#<cfif isdefined("attributes.main_stock_id")>&main_stock_id=#attributes.main_stock_id#</cfif></cfoutput>','SHOW_PRODUCT_TREE',1);
</script>
