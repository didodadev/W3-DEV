<cf_get_lang_set module = "product">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.keyword" default="">
	<cfif isdefined("attributes.form_submitted")>
        <cfinclude template="../product/query/get_code_cat.cfm">
    <cfelse>
        <cfset get_code_cat.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default="#get_code_cat.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and listFindNoCase('add,upd',attributes.event)>
	<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
		SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 ORDER BY EXPENSE_ITEM_NAME
    </cfquery>
    <cfquery name="GET_EXPENSE_INCOME" datasource="#dsn2#">
        SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE INCOME_EXPENSE = 1 ORDER BY EXPENSE_ITEM_NAME
    </cfquery>
    <cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
        SELECT EXPENSE_ID, EXPENSE FROM EXPENSE_CENTER ORDER BY  EXPENSE
    </cfquery>
    <cfquery name="GET_EXPENSE_TEMPLATE" datasource="#dsn2#">
        SELECT TEMPLATE_ID, TEMPLATE_NAME,IS_INCOME FROM EXPENSE_PLANS_TEMPLATES ORDER BY TEMPLATE_NAME
    </cfquery>
    <cfquery name="GET_EXPENSE_TEMPLATE_EXPENSE" dbtype="query">
        SELECT TEMPLATE_ID, TEMPLATE_NAME FROM GET_EXPENSE_TEMPLATE WHERE IS_INCOME<>1 ORDER BY TEMPLATE_NAME
    </cfquery>
    <cfquery name="GET_EXPENSE_TEMPLATE_INCOME" dbtype="query">
        SELECT TEMPLATE_ID, TEMPLATE_NAME FROM GET_EXPENSE_TEMPLATE WHERE IS_INCOME=1 ORDER BY TEMPLATE_NAME
    </cfquery>
    <cfquery name="GET_ACTIVITY_TYPES" datasource="#dsn#">
        SELECT ACTIVITY_ID, ACTIVITY_NAME FROM SETUP_ACTIVITY ORDER BY ACTIVITY_NAME
    </cfquery>
    
	<cfif isDefined('attributes.cat_id') and len(attributes.cat_id)>
		<cfquery name="GET_CAT_DETAIL" datasource="#dsn3#">
			SELECT INVENTORY_CAT_ID,* FROM SETUP_PRODUCT_PERIOD_CAT WHERE PRO_CODE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cat_id#">
		</cfquery>
        <cfif (isdefined("attributes.event") and attributes.event is 'upd')>
        	<cfinclude template="../product/query/get_product_account_function.cfm">
        </cfif>
	 </cfif>
     
     <cfif (isdefined("attributes.event") and attributes.event is 'upd')>
     	<cfif len(GET_CAT_DETAIL.INVENTORY_CAT_ID)>
            <cfquery name="GET_INV_CAT" datasource="#dsn3#">
                SELECT INVENTORY_CAT FROM SETUP_INVENTORY_CAT WHERE INVENTORY_CAT_ID = #get_cat_detail.INVENTORY_CAT_ID#
            </cfquery>
       		<cfset inv_cat = GET_INV_CAT.INVENTORY_CAT>
        <cfelse>
            <cfset inv_cat = "">
        </cfif>
    <cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
    		<cfif isdefined("get_cat_detail")><cfset inventory_cat_id = get_cat_detail.INVENTORY_CAT_ID><cfelse><cfset inventory_cat_id = ''></cfif>
			<cfif len(inventory_cat_id)>
                <cfquery name="GET_INV_CAT" datasource="#dsn3#">
                    SELECT INVENTORY_CAT FROM SETUP_INVENTORY_CAT WHERE INVENTORY_CAT_ID = #inventory_cat_id#
                </cfquery>
                <cfset inv_cat = GET_INV_CAT.INVENTORY_CAT>
            <cfelse>
                <cfset inv_cat = "">
            </cfif>
     </cfif>
</cfif>

<cfif isdefined("attributes.event") and listFindNoCase('add,upd',attributes.event)>

	<script type="text/javascript">	
		function pencere_ac(isim)
		{
			temp_account_code = eval('document.pro_period_cat.'+isim);
			if (temp_account_code.value.length >= 3)
				windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_id=pro_period_cat.'+isim+'&account_code=' + temp_account_code.value +'&is_title=1'</cfoutput>, 'list');
			else
				windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_id=pro_period_cat.'+isim+'&is_title=1'</cfoutput>, 'list');
		}
		function kontrol(degerid)
		{
			if(degerid == 1)
			{
				document.pro_period_cat.exp_template_id.selectedIndex = 0;
			}
			else
			{
				document.pro_period_cat.exp_center_id.selectedIndex = 0;
				document.pro_period_cat.exp_item_id.selectedIndex = 0;
				document.pro_period_cat.exp_activity_type_id.selectedIndex = 0;
			}
		}
		function kontrol2(degerid)
		{
			if(degerid == 1)
			{
				document.pro_period_cat.inc_template_id.selectedIndex = 0;
			}
			else
			{
				document.pro_period_cat.inc_center_id.selectedIndex = 0;
				document.pro_period_cat.inc_item_id.selectedIndex = 0;
				document.pro_period_cat.inc_activity_type_id.selectedIndex = 0;
			}
		}
	</script>
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_prod_code_cat';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'product/display/list_prod_code_cat.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;	
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.list_prod_code_cat';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'product/form/add_prod_code_cat.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'product/query/add_prod_code_cat.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_prod_code_cat&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'window';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.list_prod_code_cat';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'product/form/upd_prod_code_cat.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'product/query/upd_prod_code_cat.cfm';	
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'cat_id=##attributes.cat_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.cat_id##';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_prod_code_cat&event=upd';
	
	WOStruct['#attributes.fuseaction#']['del'] = structNew();
	WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
	WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=product.emptypopup_del_pro_per_cat&event=del';
	WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'product/query/del_prod_code_cat.cfm';
	WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'product/query/del_prod_code_cat.cfm';
	WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'product.list_prod_code_cat';
	WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'cat_id&head';
	
	if(attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=product.list_prod_code_cat&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=product.list_prod_code_cat&event=add&cat_id=#attributes.cat_id#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		
	}
	
</cfscript>
