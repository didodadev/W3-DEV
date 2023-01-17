<cfscript>

	if(attributes.tabMenuController eq 0) {

		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
		WOStruct['#attributes.fuseaction#']['list']					= structNew();
		WOStruct['#attributes.fuseaction#']['list']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction']	= 'dev.data_import_library';
		WOStruct['#attributes.fuseaction#']['list']['filePath']		= 'WDO/modalDataImportLibrary.cfm';
		WOStruct['#attributes.fuseaction#']['list']['queryPath']	= 'WDO/modalDataImportLibrary.cfm';
	
		WOStruct['#attributes.fuseaction#']['add']					= structNew();
		WOStruct['#attributes.fuseaction#']['add']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction']	= 'dev.data_import_library';
		WOStruct['#attributes.fuseaction#']['add']['filePath']		= 'WDO/modalDataImportLibraryAdd.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath']		= 'WDO/development/query/add_data_import_library.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] 	= 'dev.data_import_library&event=upd&data_import_id=';
		
		if(isdefined("attributes.data_import_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd']					= structNew();
	  		WOStruct['#attributes.fuseaction#']['upd']['window']		= 'normal';
	  		WOStruct['#attributes.fuseaction#']['upd']['fuseaction']	= 'dev.data_import_library';
	  		WOStruct['#attributes.fuseaction#']['upd']['filePath']		= 'WDO/modalDataImportLibraryUpd.cfm';
	  		WOStruct['#attributes.fuseaction#']['upd']['queryPath']		= 'WDO/development/query/upd_data_import_library.cfm';
	  		WOStruct['#attributes.fuseaction#']['upd']['nextEvent']		= 'dev.data_import_library&event=upd&data_import_id=';
			WOStruct['#attributes.fuseaction#']['upd']['Identity']		= '#attributes.data_import_id#';

			WOStruct['#attributes.fuseaction#']['del']					= structNew();
	  		WOStruct['#attributes.fuseaction#']['del']['window']		= 'emptypopup';
	  		WOStruct['#attributes.fuseaction#']['del']['fuseaction']	= 'dev.data_import_library';
	  		WOStruct['#attributes.fuseaction#']['del']['filePath']		= 'WDO/development/query/del_data_import_library.cfm';
	  		WOStruct['#attributes.fuseaction#']['del']['queryPath']		= 'WDO/development/query/del_data_import_library.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent']		= 'dev.data_import_library';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=dev.data_import_library";	
        }

		if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('dictionary_id','Ekle',57582)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=dev.data_import_library&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('dictionary_id','Liste',57509)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=dev.data_import_library";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('dictonary_id','Güncelle',57464)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

</cfscript>