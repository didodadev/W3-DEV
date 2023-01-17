<cf_get_lang_set module_name="settings">
<cfquery name="GET_QUALITY_SUCCESS" datasource="#dsn3#">
    SELECT * FROM QUALITY_SUCCESS
</cfquery>	
<cfif isdefined("attributes.event") and attributes.event is 'upd'>
    <cfquery name="get_quality_success_det" datasource="#dsn3#">
        SELECT 
            SUCCESS_ID, 
            SUCCESS, 
            DETAIL, 
            QUALITY_COLOR, 
            RECORD_DATE, 
            RECORD_EMP, 
            RECORD_IP, 
            UPDATE_DATE, 
            UPDATE_EMP, 
            UPDATE_IP, 
            IS_SUCCESS_TYPE, 
            IS_DEFAULT_TYPE 
        FROM 
            QUALITY_SUCCESS 
        WHERE 
            SUCCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
    </cfquery>	
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'settings.add_production_quality_success';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'settings/form/add_production_quality_success.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'settings/query/add_quality_success.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'settings.add_production_quality_success';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'settings.add_production_quality_success&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'settings/form/upd_production_quality_success.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'settings/query/upd_production_quality.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'settings.add_production_quality_success&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=settings.add_production_quality_success";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'prodQualitySuccess';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'QUALITY_SUCCESS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-qua_success']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>
