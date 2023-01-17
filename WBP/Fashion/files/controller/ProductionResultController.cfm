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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'textile.list_results';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'WBP/Fashion/files/production/display/list_prod_order_results.cfm';
		
		if(attributes.event is 'add')
		{
			WOStruct['#attributes.fuseaction#']['add'] = structNew();
			WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'textile.upd_prod_order_result';
			WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'WBP/Fashion/files/production/form/add_prod_order_result.cfm';
			WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'WBP/Fashion/files/production/query/add_prod_order_result.cfm';
			WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'textile.list_results&event=upd&party_id=#attributes.party_id#&pr_order_id=';
			WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('order_result','order_result_bask');";
		}
		
		if(isdefined("attributes.party_id") and isdefined("attributes.pr_order_id"))
		{
			
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'prod.upd_prod_order_result';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'WBP/Fashion/files/production/form/upd_prod_order_result.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'WBP/Fashion/files/production/query/upd_prod_order_result.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.pr_order_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'textile.list_results&event=upd&party_id=#attributes.party_id#&pr_order_id=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('order_result','order_result_bask');";
				
		}
		
		if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=prod.emptypopup_upd_prod_order_result_act_tex&event=del&is_demontaj=##caller.get_detail.is_demontaj##&process_stage=##caller.get_detail.prod_ord_result_stage##&del_pr_order_id=#attributes.pr_order_id#&production_order_no=##caller.get_detail.production_order_no##&old_process_type=##caller.get_detail.process_id##&process_cat=##caller.get_detail.process_id##&finish_date=##caller.get_detail.finish_date##&pr_order_id=#attributes.pr_order_id#&party_id=#attributes.party_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'WBP/Fashion/files/production/query/upd_prod_order_result.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'WBP/Fashion/files/production/query/upd_prod_order_result.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'textile.list_results';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=prod.list_results";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
		if(caller.attributes.event is 'upd')
		{
			Product_cat_List = caller.Product_cat_List;
			get_detail.finish_date =caller.get_detail.finish_date;
			get_detail.party_id = caller.get_detail.party_id;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=prod.list_results_tex";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.pr_order_id#&iid=#attributes.party_id#&print_type=280','page')";
			
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			i=0;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('prod',672)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=prod.popup_add_prod_pause&Product_cat_List=#Product_cat_List#&action_id=#attributes.pr_order_id#&action_date=#get_detail.finish_date#','list');";
			i=i+1;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('myhome',67)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=myhome.mytime_management&event=add&p_order_result_id=#attributes.pr_order_id#&is_p_order_result=1";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "blank_";
			i=i+1;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('prod',637)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=prod.popup_add_prod_result_asset&id=#attributes.pr_order_id#','list');";
			i=i+1;
			
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',1040)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.pr_order_id#&process_cat='+form_basket.old_process_type.value,'page','upd_prod_order_result');";
			i=i+1;
			
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=prod.upd_prod_order_result&action_name=party_id&action_id=#attributes.party_id#&action_name2=pr_order_id&action_id2=#attributes.pr_order_id#&relation_papers_type=P_ORDER_ID','list');";
			i=i+1;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',2252)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=prod.order_tex&event=upd&party_id=#get_detail.party_id#";
			i=i+1;
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'PRODUCTION_ORDER_RESULTS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PR_ORDER_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-production_order_no','item-order_no','item-start_date','item-finish_date','item-station_name','item-','item-']";
</cfscript>

<!--- Catalyst Header daki arama yapma formu için eski header

<table class="dph">
    <tr>
        <td class="dpht"><a href="javascript:gizle_goster_ikili('order_result','order_result_bask');">&raquo;</a><cf_get_lang_main no='1854.Üretim Sonucu'>:<cfoutput>#get_detail.p_order_no#</cfoutput></td>
        <cfform name="other_po_result" method="post" action="#request.self#?fuseaction=prod.emptypopup_locat_production_orders_detail">
            <td class="dphb">
                <table align="right">
                    <tr>
                        <td>
                            <cfsavecontent variable="aler_prod_ord"><cf_get_lang no='449.Sonuç No'> <cf_get_lang_main no='1134.Yok'></cfsavecontent>
                            <cfinput type="text" name="search_production_result_no" id="search_production_result_no" required="yes" message="#aler_prod_ord#">
                            <cf_wrk_search_button is_excel='0'>
                        </td>
                        <td>
                            <cfoutput>
                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=prod.popup_add_prod_pause&Product_cat_List=#Product_cat_List#&action_id=#attributes.pr_order_id#&action_date=#get_detail.finish_date#','list');"><img src="/images/time.gif" align="absbottom" title="Duraklamalar" border="0" /></a>
                                <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=service.popup_add_timecost&p_order_result_id=#attributes.pr_order_id#&is_p_order_result=1</cfoutput>','page_horizantal');"><img src="/images/kum.gif" border="0"  align="absbottom"  title="<cf_get_lang no='280.Zaman Harcaması Ekle'>" /></a>
                                <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_add_prod_result_asset&id=#attributes.pr_order_id#</cfoutput>','list');" ><img src="/images/asset.gif"  title="<cf_get_lang_main no ='2207.Fiziki Varlıklar'>" border="0"  align="absbottom"  /></a>
                                <cfif get_module_user(22)>
                                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.pr_order_id#&process_cat='+form_basket.old_process_type.value</cfoutput>,'page','upd_prod_order_result');"><img src="/images/extre.gif" align="absbottom"   border="0" title="<cf_get_lang_main no='1040.Mahsup Fişi'>" /></a>
                                </cfif>
                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=prod.upd_prod_order_result&action_name=p_order_id&action_id=#attributes.p_order_id#&action_name2=pr_order_id&action_id2=#attributes.pr_order_id#&relation_papers_type=P_ORDER_ID','list');"><img src="/images/uyar.gif" align="absbottom" title="<cf_get_lang_main no='345.Uyarılar'>" border="0" /></a>
                                <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.pr_order_id#&iid=#attributes.p_order_id#&print_type=280','page');"><img src="/images/barcode_print.gif" align="absbottom" title="<cf_get_lang_main no='62.Yazdır'>" border="0"></a><!--- |#get_detail.lot_no# --->
                                <a href="#request.self#?fuseaction=prod.form_upd_prod_order&upd=#get_detail.p_order_id#"><img src="/images/action_plus.gif" border="0" align="absbottom"  title="<cf_get_lang_main no='2252.Üretim Emri'>" /></a>
                            </cfoutput>
                        </td>
                    </tr>
                </table>
            </td>
        </cfform>
    </tr>
</table>
--->