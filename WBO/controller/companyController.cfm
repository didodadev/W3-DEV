<cfsavecontent  variable="woc"><cf_get_lang dictionary_id='61577.WOC'></cf_get_lang> </cfsavecontent>
<cfscript>
	// Switch // 
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'member.form_list_company';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/member/display/list_company.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'member.form_add_company';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/member/form/form_add_company.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/member/query/add_company.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'member.form_list_company&event=upd';
	
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'form_add_company';
		WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
		WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'kontrol()';
		
		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'member.detail_company';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/member/display/detail_company.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/member/query/upd_company.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'member.form_list_company&event=upd&cpid=';
		WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'cpid=##attributes.company_id##';
		if(isdefined("attributes.cpid"))
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.cpid#';
		WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_company';
		WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'form_upd_company';
		
		WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'kontrol()';
		
		WOStruct['#attributes.fuseaction#']['det'] = structNew();
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'member.detail_company';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/member/display/detail_company.cfm';
		WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'V16/member/query/upd_company.cfm';
		WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'member.form_list_company&event=det&cpid=';
		if(isdefined("attributes.cpid"))
		WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.cpid#';
		
		/* WOStruct['#attributes.fuseaction#']['updPartner'] = structNew();
		WOStruct['#attributes.fuseaction#']['updPartner']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['updPartner']['fuseaction'] = 'member.detail_partner';
		WOStruct['#attributes.fuseaction#']['updPartner']['filePath'] = 'V16/member/display/detail_partner.cfm';
		WOStruct['#attributes.fuseaction#']['updPartner']['queryPath'] = 'V16/member/query/upd_partner.cfm';
		WOStruct['#attributes.fuseaction#']['updPartner']['nextEvent'] = 'member.form_list_company&event=updPartner&pid=';
		WOStruct['#attributes.fuseaction#']['updPartner']['Identity'] = '##attributes.pid##'; */
		
		
	/* 	WOStruct['#attributes.fuseaction#']['addPartner'] = structNew();
		WOStruct['#attributes.fuseaction#']['addPartner']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['addPartner']['fuseaction'] = 'member.form_add_partner';
		WOStruct['#attributes.fuseaction#']['addPartner']['filePath'] = 'V16/member/form/form_add_partner.cfm';
		WOStruct['#attributes.fuseaction#']['addPartner']['queryPath'] = 'V16/member/query/add_partner.cfm';
		WOStruct['#attributes.fuseaction#']['addPartner']['nextEvent'] = 'member.form_list_company&event=updPartner&pid=';
		WOStruct['#attributes.fuseaction#']['addPartner']['Identity'] = '##attributes.pid##';
		WOStruct['#attributes.fuseaction#']['addPartner']['parameters'] = 'comp_cat=##attributes.company_id##';
		WOStruct['#attributes.fuseaction#']['addPartner']['Identity'] = '##attributes.compid##'; */
		
		WOStruct['#attributes.fuseaction#']['updBranch'] = structNew();
		WOStruct['#attributes.fuseaction#']['updBranch']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['updBranch']['fuseaction'] = 'member.form_upd_branch';
		WOStruct['#attributes.fuseaction#']['updBranch']['filePath'] = 'V16/member/form/form_upd_branch.cfm';
		WOStruct['#attributes.fuseaction#']['updBranch']['queryPath'] = 'V16/member/query/upd_branch.cfm';
		WOStruct['#attributes.fuseaction#']['updBranch']['nextEvent'] = 'member.form_list_company&event=updBranch&brid=';
		if(isdefined("attributes.brid"))
		WOStruct['#attributes.fuseaction#']['updBranch']['Identity'] = '#attributes.brid#'; 

		
		
		WOStruct['#attributes.fuseaction#']['addBranch'] = structNew();
		WOStruct['#attributes.fuseaction#']['addBranch']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['addBranch']['fuseaction'] = 'member.form_add_branch';
		WOStruct['#attributes.fuseaction#']['addBranch']['filePath'] = 'V16/member/form/form_add_branch.cfm';
		WOStruct['#attributes.fuseaction#']['addBranch']['queryPath'] = 'V16/member/query/add_branch.cfm';
		WOStruct['#attributes.fuseaction#']['addBranch']['nextEvent'] = 'member.form_list_company&event=updBranch&brid=';
		if(isdefined("attributes.cpid"))
		WOStruct['#attributes.fuseaction#']['addBranch']['Identity'] = '#attributes.cpid#';
		
		WOStruct['#attributes.fuseaction#']['openPopup'] = structNew();
		WOStruct['#attributes.fuseaction#']['openPopup']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['openPopup']['fuseaction'] = 'objects.popup_form_add_company';
		WOStruct['#attributes.fuseaction#']['openPopup']['filePath'] = 'V16/member/form/form_add_company.cfm';
		WOStruct['#attributes.fuseaction#']['openPopup']['queryPath'] = 'V16/member/query/add_company.cfm';
		
		WOStruct['#attributes.fuseaction#']['openMap'] = structNew();
		WOStruct['#attributes.fuseaction#']['openMap']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['openMap']['fuseaction'] = 'member.form_list_company';
		WOStruct['#attributes.fuseaction#']['openMap']['filePath'] = 'V16/member/form/form_openmap_company.cfm';

		
		
		if(attributes.event is 'add' or attributes.event is 'det')
		{
			WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
			WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,det';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'COMPANY';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'COMPANY_ID';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-fullname','item-companycat_id','item-name_','item-soyad','item-related_brand_id','item-city_id','item-county_id']";
		}
		/* else if(attributes.event is 'addPartner' or attributes.event is 'updPartner')
		{
			WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
			WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'addPartner,updPartner';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'COMPANY_PARTNER';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PARTNER_ID';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-company_partner_name','item-company_partner_surname','item-mission','item-language_id']";
		} */
		else if(attributes.event is 'addBranch' or attributes.event is 'updBranch')
		{
			WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
			WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'addBranch,updBranch';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'COMPANY_BRANCH';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'COMPBRANCH_ID';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-compbranch__name','item-compbranch_telcode','item-city_id','item-county_id']";
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=member.form_list_company";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
	/* 	if(caller.attributes.event is 'addPartner')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['addPartner']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['addPartner']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['addPartner']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addPartner']['icons']['list-ul']['href'] = "#request.self#?fuseaction=member.form_list_company";
			tabMenuStruct['#fuseactController#']['tabMenus']['addPartner']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addPartner']['icons']['check']['onClick'] = "buttonClickFunction()";
		} */
		
		if(caller.attributes.event is 'addBranch')
		{	
			tabMenuStruct['#fuseactController#']['tabMenus']['addBranch'] = structNew();		
			tabMenuStruct['#fuseactController#']['tabMenus']['addBranch']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['addBranch']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['addBranch']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addBranch']['icons']['list-ul']['href'] = "#request.self#?fuseaction=member.form_list_company";
			tabMenuStruct['#fuseactController#']['tabMenus']['addBranch']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addBranch']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
		if(isdefined("attributes.event") and (attributes.event is 'updBranch'))
		{
		  	tabMenuStruct['#fuseactController#']['tabMenus']['updBranch'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['updBranch']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['updBranch']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updBranch']['icons']['add']['href'] = "#request.self#?fuseaction=member.form_list_company&event=addBranch&cpid=#url.cpid#";
			tabMenuStruct['#fuseactController#']['tabMenus']['updBranch']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['updBranch']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['updBranch']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updBranch']['icons']['list-ul']['href'] = "#request.self#?fuseaction=member.form_list_company";
			tabMenuStruct['#fuseactController#']['tabMenus']['updBranch']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updBranch']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
/* 		if(isdefined("attributes.event") and (attributes.event is 'updPartner'))
		{

			getLang = caller.getLang;
			denied_pages = caller.denied_pages;
			fusebox.circuit = caller.fusebox.circuit;
			get_partner = caller.get_partner;
			get_company = caller.get_company;
			
			
			
			tabMenuStruct['#fuseactController#']['tabMenus']['updPartner'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['updPartner']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['updPartner']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updPartner']['icons']['add']['href'] = "#request.self#?fuseaction=member.form_list_company&event=addPartner&compid=#get_partner.company_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['updPartner']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['updPartner']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['updPartner']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updPartner']['icons']['list-ul']['href'] = "#request.self#?fuseaction=member.form_list_company";
			tabMenuStruct['#fuseactController#']['tabMenus']['updPartner']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updPartner']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['updPartner']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updPartner']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#url.pid#&print_type=421','print_page','workcube_print');";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det_partner']['menus'] = structNew();
			i=0;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['updPartner']['menus'][i]['text'] = '#getlang('main',1709)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updPartner']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_password_maker&partner_id=#attributes.pid#','list','popup_list_password_maker');";
			i = i + 1;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['updPartner']['menus'][i]['text'] = '#getlang('member',425)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updPartner']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=settings.popup_denied_pages_partner&id=#url.pid#','list','popup_denied_pages_partner');";
			i = i + 1;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['updPartner']['menus'][i]['text'] = '#getlang('member',81)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updPartner']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#url.pid#&type_id=-3','list','popup_list_comp_add_info');";
			i = i + 1;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['updPartner']['menus'][i]['text'] = '#getlang('main',173)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updPartner']['menus'][i]['href'] = "#request.self#?fuseaction=member.form_list_company&event=det&cpid=#get_partner.company_id#";
			i = i + 1;
			
			if (not listfindnocase(denied_pages,'member.popup_list_partner_surveys'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['updPartner']['menus'][i]['text'] = '#getlang('main',535)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['updPartner']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=#fusebox.circuit#.popup_list_partner_surveys&partner_id=#url.pid#&company_id=#get_partner.company_id#&COMPANYCAT_ID=#get_partner.COMPANYCAT_ID#','list','popup_list_partner_surveys');";
				i = i + 1;
			}
			
			if (not listfindnocase(denied_pages,'member.popup_form_add_upd_partner_detail'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['updPartner']['menus'][i]['text'] = '#getlang('member',98)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['updPartner']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=#fusebox.circuit#.popup_form_add_upd_partner_detail&pid=#url.pid#','medium','popup_form_add_upd_partner_detail');";
				i = i + 1;
			}
			
			if (not listfindnocase(denied_pages,'member.popup_upd_company_partner_hobbies'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['updPartner']['menus'][i]['text'] = '#getlang('member',371)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['updPartner']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=#fusebox.circuit#.popup_upd_company_partner_hobbies&pid=#get_partner.partner_id#&TYPE_ID=-3','small','popup_upd_company_partner_hobbies');";
				i = i + 1;
			}
			
		} */
		
		if(isdefined("attributes.event") and (attributes.event is 'det' or attributes.event is 'upd'))
		{
			getLang = caller.getLang;
			get_company = caller.get_company;
			get_module_user = caller.get_module_user;
			denied_pages = caller.denied_pages;
			fusebox.use_period = caller.fusebox.use_period;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det'] = structNew();
			
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'] = structNew();
			
			i = 0;
			if(get_module_user(33) and not listfindnocase(denied_pages,'report.bsc_company') and fusebox.use_period)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('report',340)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = '#request.self#?fuseaction=report.popup_bsc_company&member_type=partner&company_id=#attributes.cpid#&member_name=#GET_COMPANY.fullname#&finance=1&is_popup=1';
				i = i + 1;
			}
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('main',163)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=call.list_callcenter&event=det&cpid=#attributes.cpid#";
			i = i + 1;
			if(not listfindnocase(denied_pages,'contract.detail_contract_company'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('member',68)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=contract.list_contracts&event=upd&company_id=#url.cpid#";
				i = i + 1;
			}
			if(not listfindnocase(denied_pages,'objects.popup_list_comp_extre'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('main',397)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = '#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=partner&member_id=#attributes.cpid#';
				i = i + 1;
			}
			if(get_module_user(22))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('','MUhasebe Çalışma Dönemleri','30220')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_list_periods&cpid=#attributes.cpid#')";
				i = i + 1;
			}
			if((len(get_company.is_buyer) and get_company.is_buyer) or (len(get_company.is_seller) and get_company.is_seller))
			{

				if(get_module_user(16) and not listfindnocase(denied_pages,'member.popup_list_securefund'))
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('','Teminatlar','57676')#';
					tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=member.popup_list_securefund&company_id=#url.cpid#')";
					i = i + 1;
				}
			}
			if((len(get_company.is_buyer) and get_company.is_buyer) or (len(get_company.is_seller) and get_company.is_seller) and get_module_user(11) and session.ep.our_company_info.subscription_contract eq 1)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('','Abone','58832')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=member.popup_list_subscription_contract&cpid=#url.cpid#&member_name=#get_company.fullname#')";
				i = i + 1;
			}			
			if(not listfindnocase(denied_pages,'member.popup_upd_company_req_type'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('','Yetkinlikler','57907')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=member.popup_upd_company_partner_req_type&cpid=#attributes.cpid#')";
				i = i + 1;
			}


			if(not listfindnocase(denied_pages,'member.popup_list_comp_agenda'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('member',328)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=member.popup_list_comp_agenda&company_id=#attributes.cpid#&partner_id=#get_company.manager_partner_id#')";
				i = i + 1;
			}
			if(not listfindnocase(denied_pages,'member.popup_list_company_surveys'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('','Anketler','57947')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=member.popup_list_company_surveys&company_id=#attributes.cpid#&COMPANYCAT_ID=#GET_COMPANY.COMPANYCAT_ID#')";
				i = i + 1;
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('','Verdiği Eğitimler','46389')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_training_trainer&company_id=#attributes.cpid#')";
			i = i + 1;
			
			/* tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('member',293)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = '#request.self#?fuseaction=member.popup_member_schema&cpid=#attributes.cpid#';
			i = i + 1; */
			
			if(get_module_user(26) and not listfindnocase(denied_pages,'member.popup_list_workstations'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('','İş İstasyonları','30632')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=member.popup_list_workstations&cpid=#attributes.cpid#')";
				i = i + 1;
			}

			if(not listfindnocase(denied_pages,'member.form_add_partner'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('','Şirkete Çalışan Ekle','30227')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=member.list_contact&event=add&comp_cat=#get_company.companycat_id#&compid=#url.cpid#";
				i = i + 1;
			}
			if(not listfindnocase(denied_pages,'member.popup_form_add_worker'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('','Kurumsal Üye Ekibi','30199')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=member.popup_form_upd_worker&company_id=#url.cpid#')";
				i = i + 1;
			}
			if(not listfindnocase(denied_pages,'member.form_add_branch'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('','Adres/Şube Ekle','30191')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=member.form_list_company&event=addBranch&cpid=#url.cpid#";
				i = i + 1;
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('','Workcube Data Service','30197')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=member.popup_workxml_service&company_id=#url.cpid#')";
			i = i + 1;
			if(isDefined("denied_page.recordcount") and not denied_page.recordcount and get_module_user(7))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('member',332)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=settings.partner_user_denied&company_id=#url.cpid#";
				i = i + 1;
			}
			else if(isDefined("denied_page.recordcount") and  get_module_user(7))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('member',332)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=settings.upd_partner_user_denied&id=#denied_page.denied_page_id#&faction=#denied_page.denied_page#";
				i = i + 1;
			}
		
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=member.form_list_company&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=member.form_list_company";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#woc#';
      		tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&id=#attributes.cpid#&print_type=127','page');";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=cpid&action_id=#attributes.cpid#','Workflow')";
		
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-history']['text'] = '#getLang('','Tarihçe','57473')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-history']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=member.popup_member_history&member_type=company&member_id=#attributes.cpid#')";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-info-circle']['text'] = '#getLang('','Ek Bilgiler','30219')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-info-circle']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.cpid#&type_id=-1')";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
	}
</cfscript>
