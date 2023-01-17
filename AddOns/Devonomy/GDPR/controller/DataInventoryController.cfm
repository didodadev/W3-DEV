<!---
    File: 
    Author: 
	Date: 
    Description:
		
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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'gdpr.data_inventory';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'AddOns/Devonomy/GDPR/display/data_inventory.cfm';	
	
		if(IsDefined("attributes.event") && attributes.event is 'upd')
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'gdpr.data_inventory';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'AddOns/Devonomy/GDPR/form/data_inventory.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'AddOns/Devonomy/GDPR/query/data_inventory.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextevent'] = 'gdpr.data_inventory&event=upd&data_officer_id=#attributes.data_officer_id#&id=';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
		}
		if(IsDefined("attributes.event") && attributes.event is 'det')
		{
			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'gdpr.data_inventory';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'AddOns/Devonomy/GDPR/display/data_inventory_detail.cfm';
			WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'AddOns/Devonomy/GDPR/query/data_inventory.cfm';
			WOStruct['#attributes.fuseaction#']['det']['nextevent'] = 'gdpr.data_inventory&event=det&data_officer_id=#attributes.data_officer_id#&id=';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.id#';
		}
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'gdpr.data_inventory';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'AddOns/Devonomy/GDPR/form/data_inventory.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'AddOns/Devonomy/GDPR/query/data_inventory.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextevent'] = 'gdpr.data_inventory&event=upd&data_officer_id=#attributes.data_officer_id#&id=';
	
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=gdpr.data_inventory&data_officer_id=#attributes.data_officer_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = "#getLang('main',170)#";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=gdpr.data_inventory&event=add&data_officer_id=#attributes.data_officer_id#";		
			//tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=gdpr.data_inventory&data_officer_id=#attributes.data_officer_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
		}
	tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
}
</cfscript>