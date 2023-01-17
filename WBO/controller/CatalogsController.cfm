<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'watalogy.catalog';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/worknet/display/list_catalog.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'watalogy.catalog';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/worknet/form/add_catalog.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/worknet/query/add_catalog.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'watalogy.catalog&event=upd&id=';


       
		if(isdefined("attributes.event") and listFind('del,upd,det',attributes.event))
			{	
				WOStruct['#attributes.fuseaction#']['det'] = structNew();
				WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
				WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'watalogy.catalog';
				WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/worknet/form/det_catalog.cfm';
				WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'V16/worknet/query/det_catalog.cfm';
				WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'watalogy.catalog&event=det&id=';
				WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.id#';

				WOStruct['#attributes.fuseaction#']['upd'] = structNew();
				WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
				WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'watalogy.catalog';
				WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/worknet/form/upd_catalog.cfm';
				WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/worknet/query/upd_catalog.cfm';
				WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'watalogy.catalog&event=det&id=';
				WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
     
				WOStruct['#attributes.fuseaction#']['del'] = structNew();
				WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=watalogy.catalog&id=#attributes.id#';
				WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/worknet/query/del_catalog.cfm';
				WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/worknet/query/del_catalog.cfm';
				WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'watalogy.catalog';
			} 
    }
    else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
			if(attributes.event is 'det'){
			
			}
			if(caller.attributes.event is 'add')
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();

				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=watalogy.catalog";
							
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			}
			if(caller.attributes.event is 'det')
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();

				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('main',170,'ekle')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=watalogy.catalog&event=add";
                
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=watalogy.catalog";
                
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['text'] = '#getLang('main',49)#';
			    tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['onClick'] = "buttonClickFunction()";

				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['text'] = '#getLang('main',49)#';
			    tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=objects.widget_loader&widget_load=catalogUpdate&isbox=1&id=#attributes.id#')";
			}
			

        
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>