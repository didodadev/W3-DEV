<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'sales.tariff';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/sales/display/list_tariff.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'sales.tariff';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/sales/form/add_tariff.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/sales/query/add_tariff.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'sales.tariff&event=upd&tariff_id=';



		if(isdefined("attributes.event") and listFind('del,upd',attributes.event))
			{	
				WOStruct['#attributes.fuseaction#']['upd'] = structNew();
				WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
				WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'sales.tariff';
				WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/sales/form/upd_tariff.cfm';
				WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/sales/query/upd_tariff.cfm';
				WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'sales.tariff&event=upd&tariff_id=';
				WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.tariff_id#';
				WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'tariff_id=##attributes.id##';

				WOStruct['#attributes.fuseaction#']['del'] = structNew();
				WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,".")#.tariff&tariff_id=#attributes.tariff_id#';
				WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/sales/query/del_tariff.cfm';
				WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/sales/query/del_tariff.cfm';
				WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'sales.tariff';
			}
    }
    else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		if((isdefined("attributes.event") and attributes.event is 'add') or (isdefined("attributes.event") and attributes.event is 'upd'))
        {
			if(attributes.event is 'upd'){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170,'ekle')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=sales.tariff&event=add";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=sales.tariff";

        }
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>