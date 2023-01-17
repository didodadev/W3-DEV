<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		// Switch //
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ch.dsp_make_age';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/ch/display/dsp_make_age.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/ch/display/dsp_make_age.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ch.dsp_make_age';
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
		tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['print']['text'] = '#getLang('main',62)#';
		tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_send_print&module=dsp_make_age_div&trail=1&is_logo=0&show_datetime=0&special_module=1&iframe=1&is_ajax=1&noShow=noShow1&isAjaxPage=1','small','popup_send_print')";
		
		tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['text'] = '#getLang('main',1666)#';
		tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_mail&module=dsp_make_age_div&trail=1&special_module=1&is_ajax=1&noShow=noShow1&isAjaxPage=1','list','popup_mail');";
	
		tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][1]['text'] = '#getLang('main',1936)#';
		tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][1]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_convertpdf&module=dsp_make_age_div&ispdf=1&special_module=1&is_ajax=1&noShow=noShow1&isAjaxPage=1','medium','popup_convertpdf');";
	
		tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][2]['text'] = '#getLang('main',49)#';
		tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][2]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_documenter&module=dsp_make_age_div&special_module=1&is_ajax=1&noShow=noShow1&isAjaxPage=1','small','popup_documenter');";
	
		
		tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
	}
</cfscript>
