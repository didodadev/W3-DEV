<cfquery name="DEL_PRO_CAT" datasource="#dsn3#">
	DELETE FROM SETUP_PRODUCT_PERIOD_CAT WHERE PRO_CODE_CATID = #attributes.cat_id#
</cfquery>
<cf_add_log  log_type="-1" action_id="#attributes.cat_id#" action_name="#attributes.head#">
<script type="text/javascript">	
	window.location.href='<cfoutput>#request.self#?fuseaction=product.list_prod_code_cat</cfoutput>';
</script>
