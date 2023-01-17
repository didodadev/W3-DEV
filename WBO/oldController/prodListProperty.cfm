<cf_get_lang_set module_name="prod">
<cfif not isdefined("attributes.event") or isdefined("attributes.event") and attributes.event is 'list'>
    <cfquery name="GET_PROPERTY_CAT" datasource="#DSN1#">
        SELECT 
        	* 
        FROM 
        	PRODUCT_PROPERTY
        <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			WHERE
            PROPERTY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		</cfif>        
       	ORDER BY PROPERTY
    </cfquery>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default=#get_property_cat.recordcount#>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.currency" default="">
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cfset attributes.property_id = url.prpt_id>
    <cfinclude template="../production_plan/query/get_property_cat.cfm">
<cfelseif isdefined("attributes.event") and attributes.event is 'add_relation'>
    <cfinclude template="../production_plan/query/get_property_detail_1.cfm">
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'prod.list_property';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'production_plan/display/list_property.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'prod.list_property&event=add';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'production_plan/form/add_property_main.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'production_plan/query/add_property_main.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'prod.list_property';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'prod.list_property&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'production_plan/form/upd_property_main.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'production_plan/query/upd_property_main.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'prod.list_property';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = '&prpt_id=##attributes.prpt_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.prpt_id##';
	
	WOStruct['#attributes.fuseaction#']['add_relation'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_relation']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add_relation']['fuseaction'] = 'prod.list_property&event=add_relation';
	WOStruct['#attributes.fuseaction#']['add_relation']['filePath'] = 'production_plan/form/add_property.cfm';
	WOStruct['#attributes.fuseaction#']['add_relation']['queryPath'] = 'production_plan/query/add_property_act.cfm';
	WOStruct['#attributes.fuseaction#']['add_relation']['nextEvent'] = 'prod.list_property';
	WOStruct['#attributes.fuseaction#']['add_relation']['parameters'] = '&prpt_id=##attributes.prpt_id##&property=##attributes.property##';
	WOStruct['#attributes.fuseaction#']['add_relation']['Identity'] = '##attributes.property##';
	
	if(attributes.event is 'upd' or attributes.event is 'del')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=prod.emptypopup_del_property&property_id=#attributes.PRPT_ID#&head=#get_property_cat.PROPERTY#&event=del';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'production_plan/query/del_product_property_main.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'production_plan/query/del_product_property_main.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'prod.list_property';
	}
	
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array.item[326]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=prod.list_property&event=add&window=popup";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'prodListProperty';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'PRODUCT_PROPERTY';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'product';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-property','item-size_color']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.

	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'prodListProperty';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add_relation';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'PRODUCT_PROPERTY_DETAIL';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'product';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-prop']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.

</cfscript>
