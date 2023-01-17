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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'settings.imp_dashboard';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16\settings\display\imp_dashboard.cfm';
		
	}

	else
		{
			fuseactController = caller.attributes.fuseaction;
			getLang = caller.getLang;		
			tabMenuStruct = StructNew();
			tabMenuStruct['#fuseactController#'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();		

			if(caller.attributes.event is 'list') 
			{			
				i = 0;

				tabMenuStruct['#fuseactController#']['tabMenus']['list']['menus'][i]['text'] = '#getLang('','WorkCube Uygulama Bilgileri',42188)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['list']['menus'][i]['href'] = "#request.self#?fuseaction=settings.workcube_license";
				i=i+1;

				tabMenuStruct['#fuseactController#']['tabMenus']['list']['menus'][i]['text'] = '#getLang('','Alltogether Proje',65411)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['list']['menus'][i]['href'] = "https://alltogether.workcube.com";
				i=i+1;

				tabMenuStruct['#fuseactController#']['tabMenus']['list']['menus'][i]['text'] = '#getLang('','Adımlar',45823)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['list']['menus'][i]['href'] = "#request.self#?fuseaction=settings.imp_steps";
				i=i+1;

				tabMenuStruct['#fuseactController#']['tabMenus']['list']['menus'][i]['text'] = '#getLang('','Design',52943)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['list']['menus'][i]['href'] = "#request.self#?fuseaction=dev.imp_steps";
				i=i+1;
			}

			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);	
		}
</cfscript>