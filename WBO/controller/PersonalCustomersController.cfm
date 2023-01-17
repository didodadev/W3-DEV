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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'member.consumer_list';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/member/display/list_consumer.cfm';	
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'member.form_add_consumer';
		WOStruct['#attributes.fuseaction#']['add']['xmlFuseaction'] = 'member.form_add_consumer';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/member/form/form_add_consumer.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/member/query/add_consumer.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'member.consumer_list&event=det&cid=';

		
		if(isdefined('attributes.cid') and len(attributes.cid))
		{
			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'member.detail_consumer';
			WOStruct['#attributes.fuseaction#']['det']['xmlFuseaction'] = 'member.form_add_consumer';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/member/form/form_upd_consumer.cfm';
			WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'V16/member/query/upd_consumer.cfm';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.cid#';
			WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'member.consumer_list&event=det&cid=';
			
			

			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] ='#request.self#?fuseaction=member.emptypopup_del_consumer&consumer_id=#attributes.cid#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/member/query/delete_consumer.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/member/query/delete_consumer.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'member.consumer_list';
		}
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,det,del';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'CONSUMER';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'CONSUMER_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['form_ul_process_stage','form_ul_consumer_name','form_ul_consumer_surname','form_ul_consumer_cat_id','form_ul_mobiltel']";

	}
	else{
		getLang = caller.getLang;
		fuseactController = caller.attributes.fuseaction;
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'add')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=member.consumer_list";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'det')
		{
			GET_CONSUMER=caller.GET_CONSUMER;
			GET_MODULE_USER=caller.GET_MODULE_USER;
			fusebox=caller.fusebox;
				
			i = 0;
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=member.consumer_list&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=member.consumer_list";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['onClick'] ="buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#woc#';
      		tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&id=#attributes.cid#&print_type=126','page');";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['text'] = '#getlang('','Uyarılar','57757')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['href'] = "#request.self#?fuseaction=objects.workflowpages&tab=3&action=myhome.my_extre&action_name=id&action_id=#attributes.cid#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['target'] ="_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-history']['text'] = '#getlang('','Tarihçe','57473')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-history']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=member.popup_member_history&member_type=consumer&member_id=#attributes.cid#');";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-info-circle']['text'] = '#getlang('','Ek Bilgi','57810')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-info-circle']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#url.cid#&type_id=-2');";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'] = structNew();
			if (caller.xml_secret_question is 1 and not listfindnocase(caller.denied_pages,'member.popup_member_secret_answer')){
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = "#getLang('member',137)#";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=member.popup_member_secret_answer&consumer_id=#url.cid#','small','popup_member_secret_answer');";
				i = i + 1;
			}
			
			if (caller.get_module_user(3) and not listfindnocase(caller.denied_pages,'report.bsc_company') and caller.fusebox.use_period){
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = "#getLang('member','BSC Raporu','30627')#";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=report.bsc_company&member_type=consumer&consumer_id=#url.cid#&member_name=#caller.consumer#";
				i = i + 1;
			}
				
				
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = "#getLang('','Eğitim','57419')#";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=member.popup_education_info&consumer_id=#attributes.cid#');";
				i = i + 1;

			if (not listfindnocase(caller.denied_pages,'objects.popup_list_mail_relation')){
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = "#getLang('','Üye Mailleri','29988')#";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_list_mail_relation&relation_type=CONSUMER_ID&relation_type_id=#attributes.cid#');";
				i = i + 1;
			}

			if (not listfindnocase(caller.denied_pages,'member.popup_upd_consumer_hobbies')){
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = "#getLang('','Hobi','30509')#";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=member.popup_upd_consumer_hobbies&consumer_id=#attributes.cid#');";
				i = i + 1;
			}


			if (not listfindnocase(caller.denied_pages,'member.popup_upd_consumer_req_type')){
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = "#getLang('','Yetkinlik','57907')#";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=member.popup_upd_consumer_req_type&consumer_id=#attributes.cid#');";
				i = i + 1;
			}
			
			if (not listfindnocase(caller.denied_pages,'member.popup_list_con_agenda')){
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = "#getLang('','Toplantılar','30466')#";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=member.popup_list_con_agenda&consumer_id=#attributes.cid#');";
				i = i + 1;
			}
			
			if (not listfindnocase(caller.denied_pages,'member.popup_list_consumer_surveys')){
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = "#getLang('','Anketler','57947')#";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=member.popup_list_consumer_surveys&consumer_id=#url.cid#&consumer_cat_id=#get_consumer.consumer_cat_id#');";
				i = i + 1;
			}
			
			if (get_module_user(22)){
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = "#getLang('','Muhasebe Çalışma Dönemleri','30220')#";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_list_consumer_periods&cpid=#url.cid#')";
				i = i + 1;
			}
			
			if (not listfindnocase(caller.denied_pages,'member.popup_list_securefund')){
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = "#getLang('','Teminatlar','57676')#";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=member.popup_list_securefund&consumer_id=#url.cid#');";
				i = i + 1;
			}
			
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = "#getLang('','Hesap Ekstresi','57809')#";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['target'] = "blank_";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=objects.list_comp_extre&member_type=consumer&member_id=#url.cid#";
				i = i + 1;
			
			if (not listfindnocase(caller.denied_pages,'contract.detail_contract_company')){
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = "#getLang('','Risk ve Çalışma Bilgileri','30206')#";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['target'] = "blank_";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=contract.list_contracts&event=upd&consumer_id=#url.cid#";
				i = i + 1;
			}
			
			if (not listfindnocase(caller.denied_pages,'member.add_consumer_contact')){
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = "#getLang('','Diğer Adres Ekle','30510')#";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=#fusebox.circuit#.add_consumer_contact&cid=#url.cid#')";
				i = i + 1;
			}
			
			if (get_module_user(11) and session.ep.our_company_info.subscription_contract is 1){
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = "#getLang('','Sistemler','30520')#";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=member.popup_list_subscription_contract&cpid=#url.cid#&member_name=#get_consumer.consumer_name#&nbsp;#get_consumer.consumer_surname#')";
				i = i + 1;
			}
			
			if (not listfindnocase(caller.denied_pages,'myhome.my_consumer_details')){
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = "#getLang('','Üye Bilgileri','57575')#";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['target'] = "blank_";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=call.list_callcenter&event=det&cid=#attributes.cid#";
				i = i + 1;
			}
			
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = "#getLang('','Verdiği Eğitimler','46389')#";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_training_trainer&consumer_id=#url.cid#')";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>


