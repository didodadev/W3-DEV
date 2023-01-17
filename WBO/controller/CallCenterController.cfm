<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************	
Description :
	Banka Para Çekme Objesi
----------------------------------------------------------------------->
<cfsavecontent  variable="woc"><cf_get_lang dictionary_id='61577.WOC'></cf_get_lang> </cfsavecontent>
<cfsavecontent variable="icerik"><cf_get_lang dictionary_id="58142.Içerik Ekle"></cfsavecontent>
<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		if(not isDefined("attributes.event"))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
			
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'call.list_service';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/callcenter/display/list_service.cfm';	
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'call.add_service';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/callcenter/form/add_service.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/callcenter/query/add_service.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'call.list_service&event=upd&service_id=';
		
		if(isdefined("attributes.service_id")){
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'call.upd_service';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/callcenter/form/upd_service.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/callcenter/query/upd_service.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'call.list_service&event=upd&service_id=';
			if(isdefined("attributes.service_no")){
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.service_no#';
			}
			else
			{
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.service_id#';	
			}
			
		}
		
		if(isdefined("attributes.service_history_id")){
			WOStruct['#attributes.fuseaction#']['upd_history'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd_history']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['upd_history']['fuseaction'] = 'call.popup_upd_service_history_detail';
			WOStruct['#attributes.fuseaction#']['upd_history']['filePath'] = 'V16/callcenter/form/upd_service_history_detail.cfm';
			WOStruct['#attributes.fuseaction#']['upd_history']['queryPath'] = 'V16/callcenter/query/upd_service_history_detail.cfm';
			WOStruct['#attributes.fuseaction#']['upd_history']['nextEvent'] = '';
			WOStruct['#attributes.fuseaction#']['upd_history']['Identity'] = '#attributes.service_history_id#';
		}
			
		if(isdefined("attributes.service_id") and len(attributes.service_id))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=call.emptypopup_del_service&service_id=#attributes.service_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/callcenter/query/del_service.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/callcenter/query/del_service.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'call.list_service';
		}
	}
	else
	{
		getLang = caller.getLang;
		
		if(attributes.event is 'upd')
		{
			get_service_detail 	= caller.get_service_detail;
			denied_pages		= caller.denied_pages;
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
			
			i = 0;
			if(len(get_service_detail.service_company_id) and len(get_service_detail.service_partner_id))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('call',25)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=myhome.mytime_management&event=add&service_id=#attributes.service_id#&comp_id=#get_service_detail.service_company_id#&partner_id=#get_service_detail.service_partner_id#&subscription_id=#get_service_detail.subscription_id#&is_call_service=1;";
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['target'] = '_blank';
				i = i + 1;
			}
			else if(len(get_service_detail.service_consumer_id))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('call',25)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=myhome.mytime_management&event=add&service_id=#attributes.service_id#&cons_id=#get_service_detail.service_consumer_id#&subscription_id=#get_service_detail.subscription_id#&is_call_service=1;";
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['target'] = '_blank';
				i = i + 1;
			}
	
			if(not listfindnocase(denied_pages,'call.popup_list_similar_services'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('call',123)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "open_apply('#request.self#?fuseaction=call.popup_list_similar_services&keyword=#URLEncodedFormat(get_service_detail.service_head)#&id=#attributes.service_id#','simlar_apply');";
				i = i + 1;
			}
			if(not listfindnocase(denied_pages,'call.popup_add_service_plus'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('call',59)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=call.popup_add_service_plus&service_id=#attributes.service_id#&plus_type=service','medium');";
				i = i + 1;
			}
			if(session.ep.our_company_info.sms)
			{
				member_type = '';
				member_id = '';
				if(len(get_service_detail.service_partner_id))
				{
					member_type = 'partner';
					member_id 	=  get_service_detail.service_partner_id;
				}
				else if(len(get_service_detail.service_company_id))
				{
					member_type = 'company';
					member_id 	=  get_service_detail.service_company_id;
				}
				else if(len(get_service_detail.service_consumer_id))
				{
					member_type = 'consumer';
					member_id 	=  get_service_detail.service_consumer_id;
				}
				else if(len(get_service_detail.service_employee_id))
				{
					member_type = 'employee';
					member_id 	=  get_service_detail.service_employee_id;
				}
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',1178)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_form_send_sms&member_type=#member_type#&member_id=#member_id#&paper_type=6&paper_id=#attributes.service_id#&sms_action=#fuseaction#','small');";
				i = i + 1;
			}
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',244)# #getlang('call',96)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=service.list_service&event=add&call_service_id=#attributes.service_id#";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['target'] = '_blank';
			i = i + 1;
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',1077)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=sales.list_opportunity&event=add&service_id=#attributes.service_id#";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['target'] = '_blank';
			i = i + 1;
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#getlang('main',170)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=call.list_service&event=add";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=call.list_service";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=call.list_service&event=add&service_id=#attributes.service_id#";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = '_blank';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#woc#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&print_type=461&action_id=#attributes.service_id#','page');";			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=service_id&action_id=#attributes.service_id#','Workflow')";
			if(not listfindnocase(denied_pages,'call.popup_service_history'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-history']['text'] = '#getlang('main',61)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-history']['onClick'] = "open_apply('#request.self#?fuseaction=call.popup_service_history&service_id=#attributes.service_id#','history')";
			}
			
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
		else if (attributes.event is 'add' || attributes.event is 'upd_history' )
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=call.list_service";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	
			
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}		
	}
	
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'G_SERVICE';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'SERVICE_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-member_name','item-priority_id','item-process','item-appcat_id','item-apply_date','item-start_date','item-service_head','item-service_detail']";
	
</cfscript>

<!---
	<cfoutput>
		<cf_online id="#attributes.employee_id#" zone="ep">
	</cfoutput>
--->