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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'service.list_service';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/service/display/list_service.cfm';	
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'service.add_service';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/service/form/add_service.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/service/query/add_service.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'service.list_service&event=upd&service_id=';	
		
		if(isdefined("attributes.service_id") and not attributes.event is 'add')
		{
			
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'service.upd_service';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/service/form/upd_service.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/service/query/upd_service.cfm';
			if(isdefined("attributes.service_no")){
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.service_no#';
			}
			else
			{
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.service_id#';	
			}
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'service.list_service&event=upd&service_id=';
			
			
			service_head="##caller.get_service_detail.service_head## - ##caller.get_service_detail.service_no##";
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=service.emptypopup_del_service&service_id=#attributes.service_id#&service_head=#service_head#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/service/query/del_service.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/service/query/del_service.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'service.list_service';

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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['search']['text'] = '#getlang('main',153)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['search']['onclick'] = "openSearchForm('find_service_number','#getlang('main',244)# No','find_service_f')";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=service.list_service";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			get_service_detail = caller.get_service_detail;
			DENIED_PAGES = caller.DENIED_PAGES ;
			
			str_link = "&form_submitted=1&made_application=#get_service_detail.applicator_name#";
			i=0;
			if(len(get_service_detail.service_company_id) and len(get_service_detail.service_partner_id))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('service',280)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=myhome.mytime_management&event=add&service_id=#attributes.id#&comp_id=#get_service_detail.SERVICE_COMPANY_ID#&partner_id=#get_service_detail.service_partner_id#&is_service=1";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
				i = i +1;
			}
			else if(len(get_service_detail.service_consumer_id))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('service',280)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=service.popup_add_timecost&service_id=#attributes.id#&cons_id=#get_service_detail.SERVICE_CONSUMER_ID#&is_service=1','medium');";
				i = i + 1;
			}
			if (len(attributes.employee_id) and (attributes.employee_id neq 0))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',2242)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=service.list_service&employee_id_=#attributes.employee_id##str_link#";
				i = i + 1;
			}
			else if (len(attributes.partner_id) and (attributes.partner_id neq 0))
			{				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',2242)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=service.list_service&partner_id_=#attributes.partner_id##str_link#";
				i = i + 1;
			}
			else if (len(attributes.consumer_id) and (attributes.consumer_id neq 0))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',2242)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=service.list_service&consumer_id_=#attributes.consumer_id##str_link#";
				i = i + 1;
			}
			if (session.ep.our_company_info.sms eq 1)
			{
				if(len(get_service_detail.service_partner_id))
				{
					member_type='partner';
					member_id=get_service_detail.service_partner_id;
				}
				else if(len(get_service_detail.service_company_id))
				{
					member_type='company';
					member_id=get_service_detail.service_company_id;
				}
				else if(len(get_service_detail.service_consumer_id))
				{
					member_type='consumer';
					member_id=get_service_detail.service_consumer_id;
				}
				else if (len(get_service_detail.service_employee_id))
				{
					member_type='employee';
					member_id=get_service_detail.service_employee_id;
				}
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main','Sms Gönder',58590)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_form_send_sms&member_type=#member_type#&member_id=#member_id#&paper_id=#attributes.ID#&paper_type=7&sms_action=#fuseaction#','small');";
				i = i + 1;
			}
			if (not listfindnocase(denied_pages,'service.popup_list_similar_services'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('service',56)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=service.popup_list_similar_services&keyword=#URLEncodedFormat(get_service_detail.service_head)#&id=#attributes.id#&service_product_id=#get_service_detail.service_product_id#','medium');";
				i = i + 1;
			}
			if (not listfindnocase(denied_pages,'objects.popup_add_pursuits_documents_plus'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('service',104)#';
				
				if(len(get_service_detail.service_consumer_id))
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "&consumer_id=#get_service_detail.service_consumer_id#";
				}
				else if(len(get_service_detail.service_partner_id))
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "&partner_id=#get_service_detail.service_partner_id#";
				}
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_add_pursuits_documents_plus&action_id=#attributes.id#&header=upd_service.service_head&contact_person=#get_service_detail.applicator_name#&pursuit_type=is_service_application','list');";
				i = i + 1;
			}
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('service',279)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=service.popup_check_service_ships&service_id=#attributes.id#','wide');";
			i = i + 1;

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('service',278)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=stock.list_serial_operations&service_id=#attributes.id#&is_filtre=1";
			if (len(get_service_detail.service_consumer_id))
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "&consumer_id=#get_service_detail.service_consumer_id#";
			else if (len(get_service_detail.service_company_id))
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "&company_id=#get_service_detail.service_company_id#";

			i = i + 1;

			if (not listfindnocase(denied_pages,'product.popup_form_add_info_plus'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main','Ek Bilgi',57810)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.service_id#&type_id=-15','list');";
				i = i + 1;
			}
			if (session.ep.our_company_info.workcube_sector is 'it')
			{
				/* Kontrol edilecek.
				GetParks=cfquery(SQLString:'SELECT SR.SERVICE_ID FROM SHIP S,SHIP_ROW SR WHERE S.SHIP_ID = SR.SHIP_ID AND SR.SERVICE_ID = " & attributes.service_id & " AND S.SHIP_TYPE = 141',Datasource:'#dsn2#');
				
				queryService = new query();
				queryService.setDatasource("#DSN2#");
				queryService.setName("GetParks"); 
				queryService.addParam(name="state",value="#attributes.service_id#",cfsqltype="cf_sql_integer");
				queryService.addParam(value="141",cfsqltype="cf_sql_integer"); 
				result = queryService.execute(sql="SELECT SR.SERVICE_ID FROM SHIP S,SHIP_ROW SR WHERE S.SHIP_ID = SR.SHIP_ID AND SR.SERVICE_ID = :state and REGION = ? ORDER BY ParkName, State ");
				
				if (get_ship.recordcount)
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('service',277)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_cargo_information&cargo_type=2&service_no=#get_service_detail.service_no#','horizantal','popup_cargo_information');";
					i = i + 1;
				}*/
			}

			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['search']['text'] = '#getlang('main','Ara',57565)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['search']['onclick'] = "openSearchForm('find_service_number','#getlang('main','Servis',57656)# #getLang('','No',57487)#','find_service_f')";
			if (not listfindnocase(denied_pages,'service.popup_service_history'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['text'] = "#getLang('main','Tarihçe',57473)#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=service.popup_service_history&service_id=#attributes.id#')";
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main','Uyarılar',57757)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=service_id&action_id=#attributes.service_id#','Workflow')";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = "#getLang('main','Kopyala',57476)#";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=service.list_service&event=add&service_id=#attributes.id#";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = "#woc#";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#');";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#getlang('main','Ekle',57582)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=service.list_service&event=add";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main','Liste',57509)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=service.list_service";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main','Kaydet',57461)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SERVICE';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'SERVICE_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-member_name','item-appcat_id','item-priority_id','item-apply_date']";

</cfscript>
