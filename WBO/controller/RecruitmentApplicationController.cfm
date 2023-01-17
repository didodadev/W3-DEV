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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.apps';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/display/list_app.cfm';
		WOStruct['#attributes.fuseaction#']['list']['addButton'] = 0;
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.popup_add_app_pos';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/hr/form/add_app_pos.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/hr/query/add_app_pos.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.apps&event=upd&';

	
		if(isdefined("attributes.app_pos_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.upd_app_pos';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/form/upd_app_pos.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/hr/query/upd_app_pos.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.app_pos_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.apps&event=upd&app_pos_id=#attributes.app_pos_id#&empapp_id=#attributes.empapp_id#';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "window.location.href='#request.self#?fuseaction=hr.list_cv&event=upd&empapp_id=#attributes.empapp_id#'";
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.apps";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
		else if(caller.attributes.event is 'upd')
		{
			get_app.empapp_id = caller.get_app.empapp_id;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onclick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&iid=#app_pos_id#&print_type=171','WOC');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.apps";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=app_pos_id&action_id=#app_pos_id#','Workflow')";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('','İlişkili Seçim Listeleri',63749)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_select_list_empapp&empapp_id=#get_app.empapp_id#&app_pos_id=#app_pos_id#&type=2');";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['text'] = '#getLang('','CV',29767)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['href'] = "#request.self#?fuseaction=hr.list_cv&event=upd&empapp_id=#get_app.empapp_id#";		
		}
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);	
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'EMPLOYEES_APP_POS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'APP_POS_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-app_date','item-notice_head','item-position_cat','item-app_position','item-app_date']";
</cfscript>
<!---
<table class="dph">
	<tr>
		<td class="dpht">
            <cf_get_lang no='31.Başvuru'>:
            <cfif IsDefined('get_empapp') and get_empapp.recordcount>
				<cfoutput><a href="">#get_empapp.name# #get_empapp.surname#</a></cfoutput>
            </cfif>
		</td>
		<td class="dphb">
            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_select_list_empapp&empapp_id=#get_app.empapp_id#&app_pos_id=#app_pos_id#</cfoutput>','medium');"> <img src="/images/file.gif" title="Başvurunun Bulunduğu Seçim Listeleri" border="0"></a>
            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&iid=#app_pos_id#&print_type=171</cfoutput>','page','workcube_print');"><img src="/images/print.gif" title="<cf_get_lang_main no='62.Yazdır'>" border="0"></a>
		</td>
	</tr>
</table>
--->
