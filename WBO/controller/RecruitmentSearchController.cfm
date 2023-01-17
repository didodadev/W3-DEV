<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'searchForm';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
		WOStruct['#attributes.fuseaction#']['searchForm'] = structNew();
		WOStruct['#attributes.fuseaction#']['searchForm']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['searchForm']['fuseaction'] = 'hr.search_app';
		WOStruct['#attributes.fuseaction#']['searchForm']['filePath'] = 'V16/hr/display/search_app.cfm';
		WOStruct['#attributes.fuseaction#']['searchForm']['queryPath'] = '/V16/hr/display/list_search_app.cfm';
		WOStruct['#attributes.fuseaction#']['searchForm']['nextEvent'] = 'hr.search_app&event=list';
		
		WOStruct['#attributes.fuseaction#']['searchlist'] = structNew();
		WOStruct['#attributes.fuseaction#']['searchlist']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['searchlist']['fuseaction'] = 'hr.list_search_app';
		WOStruct['#attributes.fuseaction#']['searchlist']['filePath'] = 'V16/hr/display/list_search_app.cfm';
	}
	
	else
    {
        fuseactController = caller.attributes.fuseaction;
        getLang = caller.getLang;

        tabMenuStruct = StructNew();
        tabMenuStruct['#fuseactController#'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();


        if (caller.attributes.event is 'searchlist') 
        {

			tabMenuStruct['#fuseactController#']['tabMenus']['list-ul']['icons']['fa fa-search']['text'] = '#getLang('','Ara',57565)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['list-ul']['icons']['fa fa-search']['href'] = "#request.self#?fuseaction=hr.search_app";
          
            tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
        }

    }
</cfscript>
