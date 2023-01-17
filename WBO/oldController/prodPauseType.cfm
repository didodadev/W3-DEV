<cfif not isdefined("attributes.event") or attributes.event is 'list'>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.is_active" default="0">
    <cfif isdefined("attributes.form_submitted")>
        <cfquery name="get_prod_pause_type" datasource="#dsn3#">
            SELECT 
                * 
            FROM 
                SETUP_PROD_PAUSE_TYPE
            WHERE
                1=1
                <cfif isdefined("attributes.is_active") and attributes.is_active eq 1>
                    AND IS_ACTIVE = 1
                <cfelseif  isdefined("attributes.is_active") and attributes.is_active eq 2>
                    AND IS_ACTIVE = 0
                <cfelse>
                    AND IS_ACTIVE IN (1,0)
                </cfif>
                <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
                    AND PROD_PAUSE_TYPE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                </cfif>
        </cfquery>
    <cfelse>
        <cfset get_prod_pause_type.recordcount = 0>
    </cfif>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default="#get_prod_pause_type.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
    <cfquery name="get_pauseType" datasource="#dsn3#">
        SELECT 
            IS_ACTIVE,
            PROD_PAUSE_CAT_ID,
            PROD_PAUSE_TYPE_CODE,
            PROD_PAUSE_TYPE,
            PAUSE_DETAIL,
            RECORD_EMP,
            RECORD_DATE,
            UPDATE_EMP,
            UPDATE_DATE
        FROM 
            SETUP_PROD_PAUSE_TYPE 
        WHERE 
            PROD_PAUSE_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prod_pause_type_id#">
    </cfquery>
    <cfquery name="get_productCat" datasource="#dsn3#">
        SELECT PROD_PAUSE_PRODUCTCAT_ID FROM SETUP_PROD_PAUSE_TYPE_ROW WHERE PROD_PAUSE_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#prod_pause_type_id#"> 
    </cfquery>
    <cfset Product_cat_List = ValueList(get_productCat.PROD_PAUSE_PRODUCTCAT_ID,',')>
</cfif>
<cfif (isdefined("attributes.event") and attributes.event is 'add') or (isdefined("attributes.event") and attributes.event is 'upd')>
	<cfquery name="get_pauseCat" datasource="#dsn3#">
        SELECT PROD_PAUSE_CAT_ID,PROD_PAUSE_CAT FROM SETUP_PROD_PAUSE_CAT WHERE IS_ACTIVE = 1
    </cfquery>
    <cfquery name="GET_PRODUCT_CATS" datasource="#DSN1#" cachedwithin="#fusebox.general_cached_time#">
        SELECT
            PC.PRODUCT_CATID,
            PC.HIERARCHY,
            PC.PRODUCT_CAT
        FROM
            PRODUCT_CAT PC,
            PRODUCT_CAT_OUR_COMPANY PCO
        WHERE 
            PC.PRODUCT_CATID IS NOT NULL AND
            PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
            PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        ORDER BY
            PC.HIERARCHY
    </cfquery>
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'prod.list_prod_pause_type';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'production_plan/display/list_prod_pause_type.cfm';
	WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'production_plan/display/list_prod_pause_type.cfm';
	WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = 'prod.list_prod_pause_type';

	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'prod.list_prod_pause_type&event=add';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'production_plan/display/add_prod_pause_type.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'production_plan/query/add_prod_pause_type.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'prod.list_prod_pause_type';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'prod.list_prod_pause_type&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'production_plan/display/upd_prod_pause_type.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'production_plan/query/upd_prod_pause_type.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'prod.list_prod_pause_type';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'prod_pause_type_id=##attributes.prod_pause_type_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.prod_pause_type_id##';
	
	if(attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['onClick'] = "windowopen('#request.self#?fuseaction=prod.list_prod_pause_type&event=add&window=popup','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'prodPauseType';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SETUP_PROD_PAUSE_TYPE';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-pauseCat','item-productCat','item-pauseType_code','item-pauseType']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.

</cfscript>
