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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'call.list_callcenter';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/callcenter/display/list_callcenter.cfm';
		
		if(isdefined("attributes.cid"))
		{
			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'myhome.my_consumer_details';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = '/V16/myhome/display/my_consumer_details.cfm';
			WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '/V16/myhome/query/upd_dsp_consumer.cfm';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.cid#';
		}
		if(isdefined("attributes.cpid"))
		{
			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'myhome.my_company_details';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = '/V16/myhome/display/my_company_details.cfm';
			WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '/V16/myhome/display/my_company_details.cfm';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.cpid#';
			WOStruct['#attributes.fuseaction#']['det']['js'] = "javascript:send_link()";
		}
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		if(caller.attributes.event is 'det' and isdefined("attributes.cid"))
		{			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=call.list_callcenter";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'] = structNew();

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['bell']['href'] = "#request.self#?fuseaction=objects.workflowpages&tab=3&action=myhome.my_consumer_details&action_name=cid&action_id=#attributes.cid#";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-dashboard']['text'] = '#getLang('myhome',1230)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-dashboard']['onclick']  = "windowopen('#request.self#?fuseaction=report.popup_bsc_company&member_type=consumer&consumer_id=#attributes.cid#&member_name=#caller.GET_CONSUMER.CONSUMER_NAME#','page_horizantal','popup_bsc_company');";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['text'] = '#getLang('main',397)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=consumer&member_id=#attributes.cid#','page','popup_list_comp_extre');";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['update']['text'] = '#getLang('main',52)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['update']['href'] = "#request.self#?fuseaction=member.consumer_list&event=det&cid=#attributes.cid#";
			
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
		else if(caller.attributes.event is 'det' and isdefined("attributes.cpid"))
		{		
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main','Liste','57509')#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=call.list_callcenter";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'] = structNew();

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['bell']['text'] = '#getlang('main','Uyarılar','57757')#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['bell']['href'] = "#request.self#?fuseaction=objects.workflowpages&tab=3&action=myhome.my_company_details&action_name=cpid&action_id=#attributes.cpid#";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-dashboard']['text'] = '#getLang('myhome','BSC Raporu','31988')#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-dashboard']['onclick']  = "windowopen('#request.self#?fuseaction=report.popup_bsc_company&member_type=partner&company_id=#attributes.cpid#&member_name=#caller.get_company.fullname#&finance=1&is_popup=1','wide')";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['text'] = '#getLang('main','Hesap Ekstresi','57809')#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=partner&member_id=#attributes.cpid#','list')";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-pencil']['text'] = '#getLang('main','Güncelle','57464')#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=member.form_list_company&event=det&cpid=#attributes.cpid#";
			
			i = 1;
			if(caller.get_module_user(16)){
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus']['#i#']['text'] = '#getLang('main','Finansal Özet','58085')#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus']['#i#']['onclick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_member_financial_analyse&company_id=#attributes.cpid#')";
			 	i = i+1;
			}
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus']['#i#']['target'] = "_blank";
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
		
	}
</cfscript>
