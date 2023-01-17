<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'worknet.form_list_company';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/worknet/display/list_company.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'worknet.form_list_company';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/worknet/form/add_member_company.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/worknet/query/add_member_company.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'worknet.form_list_company&event=upd&cpid=';


       
		if(isdefined("attributes.event") and listFind('del,upd,popup_addWorknetRelation',attributes.event))
		{	
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'worknet.form_list_company';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/worknet/form/detail_company.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/worknet/query/upd_member_company.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'worknet.form_list_company&event=upd&cpid=';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.cpid#';
	
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,".")#.form_list_company&cpid=#attributes.cpid#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/worknet/query/del_company.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/worknet/query/del_company.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'worknet.form_list_company';

			WOStruct['#attributes.fuseaction#']['popup_addWorknetRelation'] = structNew();
			WOStruct['#attributes.fuseaction#']['popup_addWorknetRelation']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['popup_addWorknetRelation']['fuseaction'] = 'worknet.form_list_company';
			WOStruct['#attributes.fuseaction#']['popup_addWorknetRelation']['filePath'] = 'V16/worknet/form/add_company_relation_worknet.cfm';
			WOStruct['#attributes.fuseaction#']['popup_addWorknetRelation']['queryPath'] = 'V16/worknet/query/add_company_relation_worknet.cfm';
			WOStruct['#attributes.fuseaction#']['popup_addWorknetRelation']['nextEvent'] = 'worknet.form_list_company&event=upd&cpid=';
			WOStruct['#attributes.fuseaction#']['popup_addWorknetRelation']['Identity'] = '#attributes.cpid#';
		} 
    }
    else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		if((isdefined("attributes.event") and attributes.event is 'add') or (isdefined("attributes.event") and attributes.event is 'upd'))
        {
			if(attributes.event is 'upd'){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170,'ekle')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=worknet.form_list_company&event=add";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=worknet.form_list_company";

        }
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>