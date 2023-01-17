<cf_get_lang_set module="product">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<script type="text/javascript">
		function control()
		{
			if(document.stock_strategy.uploaded_file.value.length == '')
			{
				alert('Bir Belge Seçmelisiniz');
				return false;
			}
			windowopen('','small','stockstrategyname');
			stock_strategy.action='<cfoutput>#request.self#?fuseaction=product.stock_strategy_import&event=add</cfoutput>';
			stock_strategy.target='stockstrategyname';
			stock_strategy.submit();
			return false;
		}
    </script>
</cfif>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.stock_strategy_import';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'product/display/stock_strategy_import.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'emptypopup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.stock_strategy_import';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'product/query/add_stock_strategy_import.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'product/query/add_stock_strategy_import.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.stock_strategy_import';

</cfscript>
