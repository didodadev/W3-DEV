<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'worknet.productexportwex';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/worknet/form/popup_product_export_wex.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'worknet.productexportwex';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/worknet/form/popup_product_export_wex.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/worknet/query/product_export_add_xml.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'worknet.productexportwex&event=upd&xml_file_id=';


       
		if(isdefined("attributes.event") and listFind('del,upd',attributes.event))
		{	
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=worknet.productexportwex&xml_id=#attributes.xml_file_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/worknet/query/product_export_del_xml.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/worknet/query/product_export_del_xml.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'worknet.productexportwex';
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
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=worknet.productexportwex&event=add";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=worknet.productexportwex";

        }
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>