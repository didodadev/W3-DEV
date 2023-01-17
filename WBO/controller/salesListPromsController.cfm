<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'sales.list_proms';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/objects/display/list_proms.cfm';

		WOStruct['#attributes.fuseaction#']['det'] = structNew();
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'sales.list_proms';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = '/V16/objects/display/popup_detail_promotion.cfm';
		WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = '';
		WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'prom_id=##attributes.prom_id##';
		WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.prom_id##';
		WOStruct['#attributes.fuseaction#']['det']['formName'] = 'search';
	}
</cfscript>
