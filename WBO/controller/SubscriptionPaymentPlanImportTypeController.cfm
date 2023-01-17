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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'settings.subscription_payment_plan_import_type';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/settings/display/subscription_payment_plan_import_type.cfm';	
	
		if(IsDefined("attributes.event") && attributes.event is 'upd')
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'settings.subscription_payment_plan_import_type';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/settings/form/subscription_payment_plan_import_type.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/settings/query/subscription_payment_plan_import_type.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextevent'] = 'settings.subscription_payment_plan_import_type&event=upd&import_type_id=';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.IMPORT_TYPE_ID#';
		}
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'settings.subscription_payment_plan_import_type';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/settings/form/subscription_payment_plan_import_type.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/settings/query/subscription_payment_plan_import_type.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextevent'] = 'settings.subscription_payment_plan_import_type&event=upd&import_type_id=';
	
	}else{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	/* WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'GDPR_DATA_CATEGORIES_TYPE';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'DATA_CATEGORY_TYPE_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = ''; */
</cfscript>