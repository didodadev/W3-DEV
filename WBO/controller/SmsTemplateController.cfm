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
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'settings.form_add_sms_template';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/settings/form/add_sms_template.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'settings.form_add_sms_template';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/settings/query/add_sms_template.cfm';

         WOStruct['#attributes.fuseaction#']['del'] = structNew();
        WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'settings.form_add_sms_template';
        WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/settings/query/del_sms_template.cfm';
        WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/settings/query/del_sms_template.cfm';
        WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'settings.form_add_sms_template';

		if(isdefined("attributes.sms_template_id")){
        WOStruct['#attributes.fuseaction#']['upd'] = structNew();
        WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'settings.form_add_sms_template';
        WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/settings/form/upd_sms_template.cfm';		
        WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/settings/query/upd_sms_template.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.sms_template_id#';
        WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'upd_digital_asset_group';
        WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'settings.form_add_sms_template&event=upd&sms_template_id=';}
		
		

	
	}
    else
    {
        fuseactController = caller.attributes.fuseaction;
        getLang = caller.getLang;
        
        tabMenuStruct = StructNew();
        tabMenuStruct['#fuseactController#'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();

        
    }						
</cfscript>

