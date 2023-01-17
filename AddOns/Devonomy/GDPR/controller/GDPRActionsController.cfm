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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'gdpr.welcome';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'AddOns/Devonomy/GDPR/display/dashboard.cfm';	

		WOStruct['#attributes.fuseaction#']['list2'] = structNew();
		WOStruct['#attributes.fuseaction#']['list2']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list2']['fuseaction'] = 'gdpr.welcome';
		WOStruct['#attributes.fuseaction#']['list2']['filePath'] = 'AddOns/Devonomy/GDPR/display/classification.cfm';	
	
		if(IsDefined("attributes.event") && attributes.event is 'upd')
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'gdpr.welcome';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'AddOns/Devonomy/GDPR/form/classification.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'AddOns/Devonomy/GDPR/query/classification.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextevent'] = 'gdpr.welcome&event=upd&id=';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
		}

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'gdpr.welcome';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'AddOns/Devonomy/GDPR/form/classification.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'AddOns/Devonomy/GDPR/query/classification.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextevent'] = 'gdpr.classification&event=upd&id=';

		WOStruct['#attributes.fuseaction#']['explorer'] = structNew();
		WOStruct['#attributes.fuseaction#']['explorer']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['explorer']['fuseaction'] = 'gdpr.welcome';
		WOStruct['#attributes.fuseaction#']['explorer']['filePath'] = 'AddOns/Devonomy/GDPR/display/classification_explorer.cfm';
		WOStruct['#attributes.fuseaction#']['explorer']['queryPath'] = 'AddOns/Devonomy/GDPR/query/classification_explorer.cfm';
		WOStruct['#attributes.fuseaction#']['explorer']['nextevent'] = 'gdpr.welcome&event=explorer&id=';
		
	}
</cfscript> 