
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
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.form_add_payment_request';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/myhome/display/my_extre.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'myhome.form_add_payment_request';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/myhome/form/add_payment_request.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/myhome/query/add_payment_request.cfm';
		WOStruct['#attributes.fuseaction#']['add']['formName'] ='form_add_payment_request';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'myhome.form_add_payment_request';
        
        WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'myhome.popup_form_upd_payment_request';
        WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/myhome/form/upd_payment_request.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/myhome/query/upd_payment_request.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['formName'] ='form_upd_payment_request';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'myhome.popupform_upd_payment_request';
        
		
		
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		if (caller.attributes.event is 'add'){
			tabMenuStruct['#fuseactController#'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
			tabMenuStruct['#fuseactController#']['tabMenus']['add'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			//tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['print']['text'] = '#getLang('main',62)#';
            //tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['print']['onclick'] = "windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.is_installment#&print_type=310</cfoutput>','page');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=myhome.my_extre";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();			

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('','Yazdır','57474')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['href'] = '#request.self#?fuseaction=objects.popup_print_files&print_type=184&action_type=#attributes.id#&action_id=#attributes.id#';

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('','Uyarılar','57757')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['href'] = '#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=id&action_id=#attributes.id#';

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=myhome.my_extre";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=myhome.form_add_payment_request&event=add&is_installment=1";

			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	
	}
</cfscript>
