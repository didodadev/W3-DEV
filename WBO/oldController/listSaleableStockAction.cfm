<cf_get_lang_set module_name="product">
<cfif not IsDefined("attributes.event") or IsDefined("attributes.event") and attributes.event is 'list'>
	<cfif isdefined('attributes.form_submit') and len(attributes.form_submit)>
        <cfquery name="GET_SALEABLE_STOCK_ACTION" datasource="#DSN3#">
            SELECT
                STOCK_ACTION_ID,
                STOCK_ACTION_NAME,
                STOCK_ACTION_TYPE
            FROM
                SETUP_SALEABLE_STOCK_ACTION
            <cfif isdefined('attributes.keyword') and len(attributes.keyword)>
            WHERE
                STOCK_ACTION_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
            </cfif>
        </cfquery>
    </cfif>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfif isdefined('attributes.form_submit') and len(attributes.form_submit)>
        <cfparam name="attributes.totalrecords" default="#GET_SALEABLE_STOCK_ACTION.RECORDCOUNT#">
    <cfelse>
        <cfparam name="attributes.totalrecords" default="0">
    </cfif>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif IsDefined("attributes.event") and attributes.event is 'upd'>
    <cfquery name="GET_SALEABLE_STOCK_ACTION" datasource="#DSN3#">
        SELECT
            *
        FROM
            SETUP_SALEABLE_STOCK_ACTION
        WHERE
            STOCK_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_char" value="#attributes.stock_action_id#">
    </cfquery>    
</cfif>

<script type="application/javascript">
	<cfif not IsDefined("attributes.event") or IsDefined("attributes.event") and attributes.event is 'list'>
		(document).ready(function(){
			$('#keyword').focus();
		});
	</cfif>
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();	
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_saleable_stock_action';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'product/display/list_saleable_stock_action.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.popup_add_saleable_stock_action';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'product/form/add_saleable_stock_action.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'product/query/add_saleable_stock_action.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_saleable_stock_action&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.popup_upd_saleable_stock_action';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'product/form/upd_saleable_stock_action.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'product/query/upd_saleable_stock_action.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_saleable_stock_action&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'stock_action_id=##attributes.stock_action_id##';
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'listSaleableStockAction';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SETUP_SALEABLE_STOCK_ACTION';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-stock_action_name']";
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{  
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[261]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=product.popup_add_saleable_stock_action";		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";	
				 		  
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
</cfscript>