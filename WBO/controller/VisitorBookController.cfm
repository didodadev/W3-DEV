<cfscript>
  if(attributes.tabMenuController eq 0)
  {
    WOStruct = StructNew()

    WOStruct['#attributes.fuseaction#'] = structNew();

    WOStruct['#attributes.fuseaction#']['default'] = 'list';

    if(not  isdefined('attributes.event'))
      attributes.event = WOStruct['#attributes.fuseaction#']['default'];
    
    WOStruct['#attributes.fuseaction#']['list'] = structNew();
    WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
    WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = "crm.visitorbook";
    WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/crm/display/visitorbook_list.cfm';

    WOStruct['#attributes.fuseaction#']['add'] = structNew();
    WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
    WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'crm.visitorbook';
    WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/crm/form/form_add_visitor.cfm';
    WOStruct['#attributes.fuseaction#']['add']['queryPath']= '/V16/crm/query/add_visitorbook.cfm';
    WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'crm.visitorbook&event=upd&visit_id=';
   
    if (isdefined("attributes.visit_id"))
    {
      WOStruct['#attributes.fuseaction#']['upd'] = structNew();
      WOStruct['#attributes.fuseaction#']['upd']['window']	= 'normal';
      WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'crm.visitorbook&event=upd&visit_id=';
      WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/crm/form/form_upd_visitor.cfm';
      WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/crm/query/upd_visitbook.cfm';
      WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.visit_id#';
      WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'crm.visitorbook&event=upd&visit_id=';

      WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
      WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=crm.visitorbook&visit_id=##caller.attributes.visit_id##&';
      WOStruct['#attributes.fuseaction#']['del']['filePath'] = '/V16/crm/query/del_visitorbook.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '/V16/crm/query/del_visitorbook.cfm';
      WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'crm.visitorbook';	

    }

  }
 
 else
 {
    fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;

		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
    
    if(caller.attributes.event is 'add')
		{	
      tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
      tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
      tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=crm.visitorbook";
      tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
      tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()"; 

    } 
    if (caller.attributes.event is 'upd')
    {
      tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();

      tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
      tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=crm.visitorbook&event=add";

      tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
      tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=crm.visitorbook";

      tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
      tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";

      tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
      tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&id=#attributes.visit_id#&print_type=123','page');";
    }
    

  	tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	
  
 }
 

</cfscript>

