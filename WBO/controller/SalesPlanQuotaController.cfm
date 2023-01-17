
<cfscript>
	// Switch //
	if(attributes.tabMenuController eq 0)
	{	
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'salesplan.list_sales_quotas';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/salesplan/display/list_sales_quotas.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'salesplan.add_sales_quota';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/salesplan/form/add_sales_quota.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/salesplan/query/add_sales_quota.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'salesplan.list_sales_quotas&event=upd';	
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('sales_quota','sales_quota_bask');";
		
		if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
		{
	  		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	  		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	  		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'salesplan.upd_sales_quota';
	  		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/salesplan/form/upd_sales_quota.cfm';
	  		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/salesplan/query/upd_sales_quota.cfm';
	  		WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'salesplan.list_sales_quotas&event=upd&q_id=';
	  		WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.q_id##';
	  		WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('sales_quota','sales_quota_bask');";
		
		
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=salesplan.emptypopup_del_sales_quota&quota_id=##caller.attributes.q_id##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = '/V16/salesplan/query/del_sales_quota.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '/V16/salesplan/query/del_sales_quota.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'salesplan.list_sales_quotas';
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
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main','Liste',57509)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=salesplan.list_sales_quotas";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main','Kaydet',57461)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();	
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['fa fa-download']['text'] = '#getlang('main','CSV İmport',59030)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['fa fa-download']['id'] = 'satis_kota_planlama_file';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['fa fa-download']['onClick'] = "open_file();";
		}
		
		else if(caller.attributes.event is 'upd')
		{
			GET_SALES_QUOTAS = caller.GET_SALES_QUOTAS;
			x_period_type = caller.x_period_type; 
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main','Ekle',57582)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=salesplan.list_sales_quotas&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('','WOC',61577)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.q_id#');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main','Liste',57509)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=salesplan.list_sales_quotas";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main','Kaydet',57461)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getlang('main','Kopyala',57476)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=salesplan.list_sales_quotas&event=add&q_id=#attributes.q_id#";
			
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#getlang('salesplan','Kota Hedefleri',41600)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['id'] = 'open_page_1';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=salesplan.popup_targets_quota&q_id=#attributes.q_id#&purchase_sales=#GET_SALES_QUOTAS.IS_SALES_PURCHASE#&x_period_type=#x_period_type#&sub_category=1');";	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#getLang('main',1966)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['customTag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-26' module_id='41' action_section='SALES_QUOTA_ID' action_id='#attributes.q_id#'>";			
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main','Uyarılar',57757)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['onclick'] ="window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=offer_id&action_id=#attributes.q_id#&wrkflow=1','Workflow')";
		}
		
	tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,list';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SALES_QUOTAS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'SALES_QUOTA_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-paper_no','item-start_date','item-finish_date','item-quota_type']";
</cfscript>
<!--- 
<table class="dph">
    <tr>
         <td class="dpht"><a href="javascript:gizle_goster_ikili('sales_quota','detail_sales_quota');">&raquo;</a><cf_get_lang no='151.Kota Planlama'></td>
    	 <td class="dphb">
			<cfoutput>
                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=salesplan.popup_targets_quota&q_id=#attributes.q_id#&purchase_sales=#GET_SALES_QUOTAS.IS_SALES_PURCHASE#&x_period_type=#x_period_type#<cfif x_product_cat_sub_category eq 1>&sub_category=1</cfif>','horizantal');"><img src="/images/target.gif" title="<cf_get_lang no='155.Kota Hedefleri'>"></a>
                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=salesplan.upd_sales_quota&action_name=q_id&action_id=#attributes.q_id#','list');"><img src="/images/uyar.gif" title="<cf_get_lang_main no='345.Uyarılar'>"></a>
                <a href="#request.self#?fuseaction=salesplan.add_sales_quota"><img src="/images/plus1.gif" title="<cf_get_lang_main no='170.Ekle'>"></a>
                <a href="#request.self#?fuseaction=salesplan.add_sales_quota&q_id=#attributes.q_id#"><img src="/images/plus.gif" title="<cf_get_lang_main no='64.Kopyala'>"></a>
                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.q_id#&print_type=340','page');"><img src="/images/print.gif" title="<cf_get_lang_main no='62.Yazdır'>"></a>
            </cfoutput>
		 </td>
	</tr>
</table> 
--->