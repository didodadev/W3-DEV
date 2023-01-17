<!--- <cfif len(attributes.old_brand_logo)>
	<cf_del_server_file output_file="product/#attributes.old_brand_logo#" output_server="#attributes.old_brand_logo_server_id#">
</cfif> --->
<cflock timeout="20">
	<cftransaction>
	<cfquery name="DEL_PRODUCT_BRANDS" datasource="#DSN1#">
		DELETE FROM
			PRODUCT_BRANDS
		WHERE
			BRAND_ID = #attributes.ID#
	</cfquery>
	<cfquery name="DEL_PRODUCT_BRANDS" datasource="#DSN1#">
		DELETE FROM
			PRODUCT_BRANDS_OUR_COMPANY
		WHERE
			BRAND_ID = #attributes.ID#
	</cfquery>
	<cf_add_log  log_type="-1" action_id="#attributes.id#" action_name="#attributes.head#" data_source="#dsn1#">
	</cftransaction>
</cflock>
<script type="text/javascript">
		window.location.href = "<cfoutput>#request.self#?fuseaction=product.list_product_brands</cfoutput>";
</script>
