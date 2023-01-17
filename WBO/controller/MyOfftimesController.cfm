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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.my_offtimes';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/myhome/display/my_offtimes.cfm';

		if(isdefined("attributes.employee_id"))
		{
			WOStruct['#attributes.fuseaction#']['add'] = structNew();
			WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'myhome.form_add_offtime_popup';
			WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/myhome/form/form_add_offtime.cfm';
			WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/myhome/query/add_offtime.cfm';
			WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'myhome.my_offtimes';
			WOStruct['#attributes.fuseaction#']['add']['formName'] = 'offtime_request';
		}
		
		if(isdefined("attributes.offtime_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'myhome.form_upd_offtime_popup';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/myhome/form/form_upd_offtime.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/myhome/query/upd_offtime_emp.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#contentEncryptingandDecodingAES(isEncode:1,content:attributes.offtime_id,accountKey:'wrk')#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'myhome.my_offtimes&event=upd&offtime_id=';

			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_offtime&OFFTIME_ID=##caller.get_offtime.OFFTIME_ID##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = '/V16/myhome/query/del_offtime.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '/V16/myhome/query/del_offtime.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'myhome.my_offtimes';

			WOStruct['#attributes.fuseaction#']['info'] = structNew();
			WOStruct['#attributes.fuseaction#']['info']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['info']['fuseaction'] = 'myhome.popup_dsp_my_offtime';
			WOStruct['#attributes.fuseaction#']['info']['filePath'] = '/V16/myhome/display/dsp_my_offtime.cfm';
			WOStruct['#attributes.fuseaction#']['info']['Identity'] = '#attributes.offtime_id#';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=myhome.my_offtimes";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=myhome.my_offtimes&event=add&employee_id=#caller.get_offtime.employee_id#&kalan_izin=";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=myhome.my_offtimes";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#caller.get_offtime.offtime_id#&print_type=175','page');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=offtime_id&action_id=#attributes.offtime_id#','Workflow')";
		} 
		else if(caller.attributes.event is 'info')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['info']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['info']['icons']['list-ul']['href'] = "#request.self#?fuseaction=myhome.my_offtimes";
		}
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'OFFTIME';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'OFFTIME_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-offtimecat_id','item-startdate','item-finishdate','item-work_startdate', 'item-validator_position']";
	
</cfscript>

