<script type="text/javascript">
	function input_control2()
	{
		if ( (search_product.product_id.value == '' || search_product.product_name.value == '') && (search_product.get_company_id.value == '' || search_product.get_company.value == '') &&  (search_product.employee_id.value == '' || search_product.employee.value == '') && (search_product.price_rec_date.value == '') )
		{
			alert("<cf_get_lang_main no='1538.En az bir alanda filtre etmelisiniz'>!");
			return false;
		}
		return true;
	}
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_profit_margins';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'product/display/list_profit_margins.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;

</cfscript>
