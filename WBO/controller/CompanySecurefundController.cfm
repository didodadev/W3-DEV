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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'crm.list_company_securefund';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/crm/display/list_company_securefund.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'crm.list_company_securefund';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/crm/form/add_securefund.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/crm/query/add_securefund.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'crm.list_company_securefund&event=upd&securefund_id=';	
		
		if(isdefined("attributes.securefund_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'crm.list_company_securefund';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/crm/form/upd_securefund.cfm';
    		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/crm/query/upd_securefund.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.securefund_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'crm.list_company_securefund&event=upd&securefund_id=';

			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=crm.emptypopup_del_securefund&securefund_id=#attributes.securefund_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = '/V16/crm/query/del_securefund.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '/V16/crm/query/del_securefund.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'crm.list_company_securefund';
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
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=crm.list_company_securefund";
        }
        else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('','Ekle','57582')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=crm.list_company_securefund&event=add&is_page=1";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=crm.list_company_securefund";
           /*  tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-edit']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-edit']['text'] = '#getLang('','Müşteri Teminatları','52294')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-edit']['onclick'] = "openBoxDraggable('#request.self#?fuseaction=crm.popup_list_securefund_info&cpid=#get_sales.company_id#');";
		 */}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
