<cfscript>

	if(attributes.tabMenuController eq 0) {

		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
		WOStruct['#attributes.fuseaction#']['list']					= structNew();
		WOStruct['#attributes.fuseaction#']['list']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction']	= 'settings.data_source';
		WOStruct['#attributes.fuseaction#']['list']['filePath']		= 'V16/settings/display/list_data_source.cfm';
		WOStruct['#attributes.fuseaction#']['list']['queryPath']	= 'V16/settings/display/list_data_source.cfm';
	
		WOStruct['#attributes.fuseaction#']['add']					= structNew();
		WOStruct['#attributes.fuseaction#']['add']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction']	= 'settings.data_source';
		WOStruct['#attributes.fuseaction#']['add']['filePath']		= 'V16/settings/form/add_data_source.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath']		= 'V16/settings/query/add_data_source.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] 	= 'settings.data_source&event=upd&data_source_id=';
		
		if(isdefined("attributes.data_source_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd']					= structNew();
	  		WOStruct['#attributes.fuseaction#']['upd']['window']		= 'normal';
	  		WOStruct['#attributes.fuseaction#']['upd']['fuseaction']	= 'settings.data_source';
	  		WOStruct['#attributes.fuseaction#']['upd']['filePath']		= 'V16/settings/form/upd_data_source.cfm';
	  		WOStruct['#attributes.fuseaction#']['upd']['queryPath']		= 'V16/settings/query/upd_data_source.cfm';
	  		WOStruct['#attributes.fuseaction#']['upd']['nextEvent']		= 'settings.data_source&event=upd&data_source_id=';
			WOStruct['#attributes.fuseaction#']['upd']['Identity']		= '#attributes.data_source_id#';

			WOStruct['#attributes.fuseaction#']['del']					= structNew();
	  		WOStruct['#attributes.fuseaction#']['del']['window']		= 'emptypopup';
	  		WOStruct['#attributes.fuseaction#']['del']['fuseaction']	= 'settings.data_source';
	  		WOStruct['#attributes.fuseaction#']['del']['filePath']		= 'V16/settings/query/del_data_source.cfm';
	  		WOStruct['#attributes.fuseaction#']['del']['queryPath']		= 'V16/settings/query/del_data_source.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent']		= 'settings.data_source';
		}

	}
	else {
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
        tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();

		if(caller.attributes.event is 'add')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('dictonary_id','Kaydet',57461)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('dictionary_id','Liste',57509)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=settings.data_source";	
        }

		if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('dictionary_id','Ekle',57582)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=settings.data_source&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('dictionary_id','Liste',57509)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=settings.data_source";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('dictonary_id','Güncelle',57464)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

</cfscript>