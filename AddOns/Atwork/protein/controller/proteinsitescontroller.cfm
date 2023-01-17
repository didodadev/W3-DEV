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
			  WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'protein.sites';
			  WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'AddOns/Atwork/protein/view/sites.cfm';	
			
			if(IsDefined("attributes.event") && attributes.event is 'upd')
			{
				WOStruct['#attributes.fuseaction#']['upd'] = structNew();
				WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
				WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'protein.form_upd_main_menu';
				WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'AddOns/Atwork/protein/form/upd_main_menu.cfm';
				WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'AddOns/Atwork/protein/query/upd_main_menu.cfm';
				WOStruct['#attributes.fuseaction#']['upd']['nextevent'] = 'protein.sites&event=upd&menu_id=';
			}
			
			
				WOStruct['#attributes.fuseaction#']['add'] = structNew();
				WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
				WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'protein.form_add_main_menu';
				WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'AddOns/Atwork/protein/form/add_main_menu.cfm';
				WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'AddOns/Atwork/protein/query/add_main_menu.cfm';
				WOStruct['#attributes.fuseaction#']['add']['nextevent'] = 'protein.sites&event=upd&menu_id=';
			
	  }
	</cfscript>