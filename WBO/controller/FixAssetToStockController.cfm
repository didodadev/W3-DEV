<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'invent.add_invent_stock_fis_return';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/inventory/form/add_invent_stock_fis_return.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/inventory/query/add_invent_stock_fis_return.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'invent.add_invent_stock_fis_return&event=upd&fis_id=';	
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('invent_stock_fis_return','invent_stock_fis_return_bask');";
		
		if(isdefined("attributes.fis_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'invent.upd_invent_stock_fis_return';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/inventory/form/upd_invent_stock_fis_return.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/inventory/query/upd_invent_stock_fis_return.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.fis_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'invent.add_invent_stock_fis_return&event=upd&fis_id=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('invent_stock_fis_return','invent_stock_fis_return_bask');";
		}
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'STOCK_FIS';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'FIS_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-fis_number','item-start_date','item-giris_depo','item-deliver_get']";

		if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=invent.emptypopup_del_invent_stock_fis&fis_id=#attributes.fis_id#&head=##caller.get_fis_det.fis_number##&old_process_type=##caller.get_fis_det.fis_type##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/inventory/query/del_invent_stock_fis.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/inventory/query/del_invent_stock_fis.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'invent.list_actions';
		}
		
	}else
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=invent.list_actions";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			get_fis_det = caller.get_fis_det;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=invent.add_invent_stock_fis_return";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=invent.list_actions";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
						
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('main',1040)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.fis_id#&process_cat='+upd_invent.old_process_type.value,'page');";
			
			i = 1;
			if(session.ep.our_company_info.guaranty_followup){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',305)# - #getLang('main',306)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&belge_no=#get_fis_det.fis_number#&process_cat_id=#get_fis_det.fis_type#&process_id=#attributes.fis_id#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = '_blank';
				
				i = i + 1;
			}
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>

<!---<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent> listeleme maxrows
<cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'></cfsavecontent> ekleme tarih
<cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'></cfsavecontent> update tarih
--->
<!---add

<table class="dph">
    <tr>
        <td class="dpht"><a href="javascript:gizle_goster_ikili('budget_plan','budget_plan_bask');">&raquo;</a><cf_get_lang_main no='788.Gelir/Gider Planı'></td>
        <td class="dphb">
            <a href="javascript://" onclick="open_file();"><img src="images/file.gif" alt="CSV İmport" border="0" title="CSV İmport"></a>
            <div id="budget_file" style="display:none;z-index:99; position:absolute; width:100%; float:right; left:0;"></div>
        </td>
    </tr>
</table>--->