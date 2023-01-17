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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'gdpr.data_officer';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'AddOns/Devonomy/GDPR/display/data_officer.cfm';	
	
		if(IsDefined("attributes.event") && attributes.event is 'upd')
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'gdpr.data_officer';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'AddOns/Devonomy/GDPR/form/data_officer.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'AddOns/Devonomy/GDPR/query/data_officer.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextevent'] = 'gdpr.data_officer&event=upd&id=';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
		}

		if(IsDefined("attributes.event") && attributes.event is 'committee')
		{
			WOStruct['#attributes.fuseaction#']['committee'] = structNew();
			WOStruct['#attributes.fuseaction#']['committee']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['committee']['fuseaction'] = 'gdpr.data_officer';
			WOStruct['#attributes.fuseaction#']['committee']['filePath'] = 'AddOns/Devonomy/GDPR/form/data_officer_committee.cfm';
			WOStruct['#attributes.fuseaction#']['committee']['queryPath'] = 'AddOns/Devonomy/GDPR/query/data_officer_committee.cfm';
			WOStruct['#attributes.fuseaction#']['committee']['nextevent'] = 'gdpr.data_officer&event=upd&id=#attributes.data_officer_id#';
		}
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'gdpr.data_officer';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'AddOns/Devonomy/GDPR/form/data_officer.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'AddOns/Devonomy/GDPR/query/data_officer.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextevent'] = 'gdpr.data_officer&event=det&id=';

		WOStruct['#attributes.fuseaction#']['det'] = structNew();
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'gdpr.data_officer';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'AddOns/Devonomy/GDPR/display/data_officer_detail.cfm';
		//WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'AddOns/Devonomy/GDPR/query/data_officer.cfm';
		//WOStruct['#attributes.fuseaction#']['det']['nextevent'] = 'gdpr.data_officer&event=upd&id=';
	
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=gdpr.data_officer";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = "#getLang('main',170)#";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";	
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-cube']['text'] = 'Detay';
			//tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['update']['href'] = "#request.self#?fuseaction=gdpr.data_officer&event=upd&id=#attributes.id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-cube']['href'] = "#request.self#?fuseaction=gdpr.data_officer&event=det&id=#attributes.id#";	
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=gdpr.data_officer";	
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = 'Ekle';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=gdpr.data_officer&event=add";	
				
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#','woc')";

		}
		else if(caller.attributes.event is 'det')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['det'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['text'] = 'Kurul';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=gdpr.data_officer&event=committee&data_officer_id=#attributes.id#')";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][1]['text'] = 'Veri Envanteri';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][1]['href'] = "#request.self#?fuseaction=gdpr.data_inventory&data_officer_id=#attributes.id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][2]['text'] = 'Veri Sınıflandırma';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][2]['href'] = "#request.self#?fuseaction=gdpr.data_classification&data_officer_id=#attributes.id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['text'] = 'Güncelle';
			//tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['update']['href'] = "#request.self#?fuseaction=gdpr.data_officer&event=upd&id=#attributes.id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=gdpr.data_officer&event=upd&id=#attributes.id#";		
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=gdpr.data_officer";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = 'Ekle';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=gdpr.data_officer&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#','woc')";
	

			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

</cfscript>
<!--- <cfscript>
	if(attributes.tabMenuController eq 0){
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();	
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'gdpr.welcome';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'AddOns/Devonomy/GDPR/display/dashboard.cfm';	

		
	}
</cfscript> --->