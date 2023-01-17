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
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.collacted_product_prices';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/product/form/add_collacted_product_prices.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/product/query/add_collacted_product_prices_amount.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.collacted_product_prices';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'form_add_product_property';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('product_prices','product_prices_bask');";

		WOStruct['#attributes.fuseaction#']['upd-mix'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd-mix']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd-mix']['fuseaction'] = 'product.upd_price_mix_product';
		WOStruct['#attributes.fuseaction#']['upd-mix']['filePath'] = '/V16/product/form/upd_price_mix_product.cfm';
		WOStruct['#attributes.fuseaction#']['upd-mix']['queryPath'] = '/V16/product/query/upd_price_mix_product.cfm';
		WOStruct['#attributes.fuseaction#']['upd-mix']['nextEvent'] = 'product.collacted_product_prices&event=upd-mix&p_product_id=';
		WOStruct['#attributes.fuseaction#']['upd-mix']['formName'] = 'form_add_price';
		WOStruct['#attributes.fuseaction#']['upd-mix']['js'] = "javascript:gizle_goster_ikili('product_prices','product_prices_bask');";

		WOStruct['#attributes.fuseaction#']['add-total'] = structNew();
		WOStruct['#attributes.fuseaction#']['add-total']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add-total']['fuseaction'] = 'product.collacted_product_prices_total';
		WOStruct['#attributes.fuseaction#']['add-total']['filePath'] = '/V16/product/form/add_collacted_product_prices_total.cfm';
		WOStruct['#attributes.fuseaction#']['add-total']['queryPath'] = '/V16/product/query/add_collacted_product_prices_amount_total.cfm';
		WOStruct['#attributes.fuseaction#']['add-total']['nextEvent'] = 'product.collacted_product_prices';
		WOStruct['#attributes.fuseaction#']['add-total']['formName'] = 'form_add_price';
		WOStruct['#attributes.fuseaction#']['add-total']['js'] = "javascript:gizle_goster_ikili('prices_total_','prices_total_bask_');";
	
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.list_price_cat";

			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['text'] = '#getLang('product',456)# #getLang('product',379)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['href'] = "#request.self#?fuseaction=product.collacted_product_prices&event=upd-mix";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][1]['text'] = '#getLang('main',620)# #getLang('product',379)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][1]['href'] = "#request.self#?fuseaction=product.collacted_product_prices&event=add-total";
			if (isDefined("form.form_varmi"))
			{	tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['print']['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['print']['text'] = '#getLang('main',62)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['print']['href'] = "#request.self#?fuseaction=objects.popup_print_files&print_type=220#caller.page_code#'";
			}
		}
		else if(caller.attributes.event is 'upd-mix')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd-mix']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd-mix']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd-mix']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd-mix']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.list_price_cat";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd-mix']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd-mix']['menus'][0]['text'] = '#getLang('main',620)# #getLang('product',379)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd-mix']['menus'][0]['href'] = "#request.self#?fuseaction=product.collacted_product_prices&event=add-total";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd-mix']['menus'][1]['text'] = '#getLang('product',379)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd-mix']['menus'][1]['href'] = "#request.self#?fuseaction=product.collacted_product_prices";
			if (isDefined("form.form_varmi"))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd-mix']['icons']['print']['text'] = '#getLang('main',62)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd-mix']['icons']['print']['href'] = "#request.self#?fuseaction=objects.popup_print_files&print_type=220#caller.page_code#'";
			}
		}
		else if(caller.attributes.event is 'add-total')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['add-total']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add-total']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add-total']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add-total']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.list_price_cat";

			tabMenuStruct['#fuseactController#']['tabMenus']['add-total']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add-total']['menus'][0]['text'] = '#getLang('product',379)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add-total']['menus'][0]['href'] = "#request.self#?fuseaction=product.collacted_product_prices";
			tabMenuStruct['#fuseactController#']['tabMenus']['add-total']['menus'][1]['text'] = '#getLang('product',456)# #getLang('product',379)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add-total']['menus'][1]['href'] = "#request.self#?fuseaction=product.collacted_product_prices&event=upd-mix";
			if (isDefined("form.form_varmi"))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['add-total']['icons']['print']['text'] = '#getLang('main',62)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['add-total']['icons']['print']['href'] = "#request.self#?fuseaction=objects.popup_print_files&print_type=220#caller.page_code#'";
			}
		}
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
</cfscript>
<!--- add tabmenu
<table class="dph">
	<tr>
		<td class="dphb">
			<cfif isDefined("form.form_varmi")><cfoutput><a href="javascript://" onclick=""><img src="/images/print.gif" border="0" title="<cf_get_lang_main no='62.Yazdır'>"></a></cfoutput></cfif>
		</td>	
	</tr>
</table>
--->
<!--- upd-mix tabmenu
<table class="dph">
	<tr>
		<td class="dphb">
			<cfif isDefined("form.form_varmi")><cfoutput><a href="javascript://" onclick=""><img src="/images/print.gif" border="0" title="<cf_get_lang_main no='62.Yazdır'>"></a></cfoutput></cfif>
		</td>	
	</tr>
</table>
--->
<!--- add-total tabmenu
<cf_workcube_file_action pdf='1' mail='1' doc='1' print='0'>
<table align="right">
	<tr>
		<td>
			<cfif isDefined("form.form_submit")><cfoutput><a href="javascript://" onClick=""><img src="/images/print.gif" border="0" title="<cf_get_lang_main no='62.Yazdır'>"></a></cfoutput></cfif>
		</td>
	</tr>
</table>
--->