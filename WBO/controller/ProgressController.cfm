<cfscript>
if(attributes.tabMenuController eq 0)
{
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();	
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
	attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'contract.list_progress';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/contract/display/list_progress.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'contract.add_progress_payment';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/contract/form/add_progress_payment.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/contract/form/add_progress_payment.cfm';

	if(isdefined("attributes.id"))
	{
		WOStruct['#attributes.fuseaction#']['det'] = structNew();
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'contract.popup_detail_progress';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/contract/display/detail_progress.cfm';
		WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.id#';
		WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'contract.list_progress';


		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=contract.emptypopup_del_progress_payment&progress_id=##caller.getProgress.progress_id##';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/contract/query/del_progress_payment.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/contract/query/del_progress_payment.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'contract.list_progress';
	}
}
else
{
	fuseactController = caller.attributes.fuseaction;
	getLang = caller.getLang;
	
	tabMenuStruct = StructNew();
	tabMenuStruct['#fuseactController#'] = structNew();
	tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();

	if(caller.attributes.event is 'det')
	{	
		getProgress =caller.getProgress;
		tabMenuStruct['#fuseactController#']['tabMenus']['det'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'] = structNew();

		if(#getProgress.progress_type# == 1)
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['text'] = '#getLang('invoice',13)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['href'] = "#request.self#?fuseaction=invoice.form_add_bill_purchase";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['target'] = "_blank";

		}

		tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('main',62)#';
		tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=481','page');";

	}
	tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
}
</cfscript>
