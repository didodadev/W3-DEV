<!---
    File: ClassificationController.cfm
    Author: Devonomy - Tolga Sütlü
	Date: 14/09/2019
    Description: Veri sorumlusunun veri sınıflandırma verisi
		
--->
<cfscript>
	if(attributes.tabMenuController eq 0){
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();	
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];

		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'gdpr.data_classification';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'AddOns/Devonomy/GDPR/display/classification.cfm';	
		
		if(IsDefined("attributes.event") && listFind('del,upd',attributes.event))
		{
			if(not isdefined("attributes.data_officer_id"))attributes.data_officer_id=0;
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'gdpr.data_classification';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'AddOns/Devonomy/GDPR/form/classification.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'AddOns/Devonomy/GDPR/query/classification.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextevent'] = 'gdpr.data_classification&event=upd&data_officer_id=#attributes.data_officer_id#&id=';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.data_officer_id#';

			WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'gdpr.data_classification';
            WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'AddOns/Devonomy/GDPR/query/classification.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'AddOns/Devonomy/GDPR/query/classification.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextevent'] = 'gdpr.data_classification&event=upd&data_officer_id=#attributes.data_officer_id#';
		
		}
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'gdpr.data_classification';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'AddOns/Devonomy/GDPR/form/classification.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'AddOns/Devonomy/GDPR/query/classification.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextevent'] = 'gdpr.data_classification&event=upd&data_officer_id=#attributes.data_officer_id#&id=';

		WOStruct['#attributes.fuseaction#']['explorer'] = structNew();
		WOStruct['#attributes.fuseaction#']['explorer']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['explorer']['fuseaction'] = 'gdpr.data_classification';
		WOStruct['#attributes.fuseaction#']['explorer']['filePath'] = 'AddOns/Devonomy/GDPR/display/classification_explorer.cfm';

		
	
	}else{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'add')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			//tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = "#getLang('main',97)#";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=gdpr.data_classification&data_officer_id=#attributes.data_officer_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = "#getLang('main',170)#";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=gdpr.data_classification&event=add&data_officer_id=#attributes.data_officer_id#";		
			//tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=gdpr.data_classification&data_officer_id=#attributes.data_officer_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>