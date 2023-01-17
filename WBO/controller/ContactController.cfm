<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        
        WOStruct['#attributes.fuseaction#'] = structNew();
        
        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        
        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'member.list_contact';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/member/display/list_contact.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'member.list_contact';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/member/form/form_add_partner.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/member/query/add_partner.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'member.list_contact&event=upd&pid=';
        

       
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'member.list_contact';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/member/display/detail_partner.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/member/query/upd_partner.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'member.list_contact&event=upd&pid=';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.pid##';            
        

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
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main','Liste',57509)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=member.list_contact";
            
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main','Kaydet',57461)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()"; 
	
        }
		if(caller.attributes.event is 'upd')
		{
			denied_pages = caller.denied_pages;
			fusebox.circuit = caller.fusebox.circuit;
			get_partner = caller.get_partner;
			get_company = caller.get_company;
		    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main','Ekle',57582)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=member.list_contact&event=add&compid=#get_partner.company_id#";
            
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main','Liste',57509)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=member.list_contact";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main','Kaydet',57461)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main','Uyarılar',57757)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=pid&action_id=#attributes.pid#','Workflow')";   
            
            	
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main','Yazdır',57474)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#url.pid#&print_type=421','print_page','workcube_print');";
            	
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			i=0;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main','Kurumsal Üye',57585)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=member.form_list_company&event=det&cpid=#get_partner.company_id#";
			i = i + 1;
			
			if (not listfindnocase(denied_pages,'member.popup_list_partner_surveys'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main','Anketler',57947)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=#fusebox.circuit#.popup_list_partner_surveys&partner_id=#url.pid#&company_id=#get_partner.company_id#&COMPANYCAT_ID=#get_partner.COMPANYCAT_ID#');";
				i = i + 1;
			}
			
			if (not listfindnocase(denied_pages,'member.popup_form_add_upd_partner_detail'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('member','Kişisel Bilgiler',30236)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=#fusebox.circuit#.popup_form_add_upd_partner_detail&pid=#url.pid#','','ui-draggable-box-large');";
				i = i + 1;
			}
			
			if (not listfindnocase(denied_pages,'member.popup_upd_company_partner_hobbies'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('member','Hobi',30509)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=#fusebox.circuit#.popup_upd_company_partner_hobbies&pid=#get_partner.partner_id#&TYPE_ID=-3','','ui-draggable-box-small');";
				i = i + 1;
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('member','Ek Bilgiler',30219)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#url.pid#&type_id=-3','list','popup_list_comp_add_info');";
			i = i + 1;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('member','Sayfa Kısıtı',30563)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=settings.popup_denied_pages_partner&id=#url.pid#','','ui-draggable-box-small');";
			i = i + 1;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main','Şifrematik',29506)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_list_password_maker&partner_id=#attributes.pid#','','ui-draggable-box-small');";
			i = i + 1;
        }
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>