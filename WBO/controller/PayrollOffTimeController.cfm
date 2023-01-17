<cfsavecontent  variable="woc"><cf_get_lang dictionary_id='61577.WOC'></cf_get_lang> </cfsavecontent>
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
		
		
		if(listgetat(attributes.fuseaction,1,'.')  is 'hr')
		{
			
			WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.list_offtimes';
			WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/hr/ehesap/display/list_offtimes.cfm';
		}
		else if (listgetat(attributes.fuseaction,1,'.')  is 'ehesap'){
			
			WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.offtimes';
			WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/hr/ehesap/display/list_offtimes.cfm';
		}
			

		if(listgetat(attributes.fuseaction,1,'.')  is 'ehesap')
		{
			WOStruct['#attributes.fuseaction#']['add'] = structNew();
			WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.form_add_offtime_popup';
			WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/hr/ehesap/form/add_offtime.cfm';
			WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/hr/ehesap/query/add_offtime.cfm';
			WOStruct['#attributes.fuseaction#']['add']['formName'] = 'offtime_request';
		}

		if(isdefined("attributes.offtime_id") && listgetat(attributes.fuseaction,1,'.')  is 'ehesap')
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.form_upd_offtime_popup';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/hr/ehesap/form/upd_offtime.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/hr/ehesap/query/upd_offtime.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.offtime_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.offtimes&event=upd&offtime_id=';

			if(isdefined("attributes.event") and (attributes.event is "upd" or attributes.event is "del"))
			{
				WOStruct['#attributes.fuseaction#']['del'] = structNew();
				WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=ehesap.emptypopup_del_offtime&OFFTIME_ID=#attributes.OFFTIME_ID#&head=##caller.get_offtime.employee_id##';
				WOStruct['#attributes.fuseaction#']['del']['filePath'] = '/V16/hr/ehesap/query/del_offtime.cfm';
				WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '/V16/hr/ehesap/query/del_offtime.cfm';
				WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.offtimes';
			}
		}
		
		WOStruct['#attributes.fuseaction#']['add-plan'] = structNew();
		WOStruct['#attributes.fuseaction#']['add-plan']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add-plan']['fuseaction'] = 'ehesap.popup_add_offtime_plan';
		WOStruct['#attributes.fuseaction#']['add-plan']['filePath'] = '/V16/hr/ehesap/form/add_offtime_plan.cfm';
		WOStruct['#attributes.fuseaction#']['add-plan']['queryPath'] = '/V16/hr/ehesap/query/add_offtime_plan.cfm';
		WOStruct['#attributes.fuseaction#']['add-plan']['nextEvent'] = 'ehesap.offtimes';
		WOStruct['#attributes.fuseaction#']['add-plan']['formName'] = 'add_offtime';

		WOStruct['#attributes.fuseaction#']['add-added'] = structNew();
		WOStruct['#attributes.fuseaction#']['add-added']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add-added']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.popup_add_added_offtimes';
		WOStruct['#attributes.fuseaction#']['add-added']['filePath'] = '/V16/hr/ehesap/form/add_added_offtime.cfm';
		WOStruct['#attributes.fuseaction#']['add-added']['queryPath'] = '/V16/hr/ehesap/query/add_added_offtime.cfm';
		WOStruct['#attributes.fuseaction#']['add-added']['formName'] = 'offtime_request';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.offtimes";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('','Kaydet','57461')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('','Ekle','44630')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.offtimes&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.offtimes";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#woc#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.offtime_id#&print_type=175','page');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('','Kaydet','57461')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['href'] = "#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=offtime_id&action_id=#attributes.offtime_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['target'] ="_blank";
		}
		else if(caller.attributes.event is 'add-plan')
		{
			if(listgetat(attributes.fuseaction,1,'.')  is 'ehesap')
			{
			tabMenuStruct['#fuseactController#']['tabMenus']['add-plan']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add-plan']['icons']['add']['text'] = '#getLang('','Ekle','44630')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add-plan']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.offtimes&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['add-plan']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add-plan']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.offtimes";
			tabMenuStruct['#fuseactController#']['tabMenus']['add-plan']['icons']['check']['text'] = '#getLang('','Kaydet','57461')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add-plan']['icons']['check']['onClick'] = "buttonClickFunction()";
			}
			if(listgetat(attributes.fuseaction,1,'.')  is 'hr')
			{
			tabMenuStruct['#fuseactController#']['tabMenus']['add-plan']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add-plan']['icons']['add']['text'] = '#getLang('','Ekle','44630')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add-plan']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_offtimes&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['add-plan']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add-plan']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_offtimes";
			tabMenuStruct['#fuseactController#']['tabMenus']['add-plan']['icons']['check']['text'] = '#getLang('','Kaydet','57461')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add-plan']['icons']['check']['onClick'] = "buttonClickFunction()";
			}

		}
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'OFFTIME';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'OFFTIME_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-offtimecat_id','item-startdate','item-finishdate','item-work_startdate', 'item-validator_position']";
	
</cfscript>

