<!---
File: OrgCompanyController.cfm
Author: Canan Ebret <cananebret@workcube.com>
Controller: -
Description: Şirket Tanımları Controller Sayfasıdır.
--->
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
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'settings.form_add_our_company';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/settings/form/add_our_company.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/settings/query/add_our_company.cfm';


		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'settings.form_upd_our_company';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/settings/form/upd_our_company.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/settings/query/upd_our_company.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'settings.form_upd_our_company&event=upd&ourcompany_id=';
    }else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>