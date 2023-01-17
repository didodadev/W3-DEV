<cfscript>

	if(attributes.tabMenuController eq 0)
	{	
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'training_management.certificates';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/training_management/display/list_certificates.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'training_management.certificates';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/training_management/form/form_add_certificate.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/training_management/cfc/certificates.cfc';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'training_management.certificates&event=upd';
			
		if(isdefined("attributes.training_certificate_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	  		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	  		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'training_management.certificates';
	  		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/training_management/form/form_upd_certificate.cfm';
	  		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/training_management/cfc/certificates.cfc';
	  		WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'training_management.certificates&event=upd';
              WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.training_certificate_id#'; 
              
              WOStruct['#attributes.fuseaction#']['del'] = structNew();
              WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
              WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'training_management.certificates';
              WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/training_management/form/form_upd_certificate.cfm';
              WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/training_management/cfc/certificates.cfc';
              WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'training_management.certificates';
      
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=training_management.certificates";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=training_management.certificates&event=add";		
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=training_management.certificates";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BILLS_PROCESS_GROUP';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PROCESS_TYPE_GROUP_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_name','item-get_pro_cat']";
	
</cfscript>