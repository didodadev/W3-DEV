
<cfscript>
    if (attributes.tabMenuController eq 0)
    {

        WOStruct = structNew();

        WOStruct['#attributes.fuseaction#'] = structNew();

        WOStruct['#attributes.fuseaction#']['default'] = 'upd';
       
      
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = '';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'gdpr.decleration_text';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'AddOns/Devonomy/GDPR/display/gdpr_decleration.cfm';
			
		
	}
    else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		getLang = caller.getLang;
         if(isdefined("attributes.event") and attributes.event is 'upd')
		{
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['text'] = '#getLang('','gdpr tarihçe','64697')#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['onclick'] = "openBoxDraggable('#request.self#?fuseaction=gdpr.decleration_history')";
        }
        tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		
	}
	
</cfscript>