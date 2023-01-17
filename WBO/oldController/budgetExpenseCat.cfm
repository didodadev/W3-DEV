<cfparam name="attributes.expense_cat_name" default="">
<cfparam name="attributes.expense_cat_code" default="">
<cfparam name="attributes.expense_cat_detail" default="">
<cfparam name="attributes.expence_is_hr" default="">
<cfparam name="attributes.expence_is_training" default="">
<cf_get_lang_set module_name="budget">
<cfif IsDefined("attributes.event")>
	<cfif  attributes.event eq 'upd'>
    	<cfquery name="get_expense_cat_list" datasource="#dsn2#">
            SELECT 
                *
            FROM
                EXPENSE_CATEGORY
            WHERE
                1=1
                <cfif isdefined("attributes.cat_id")>
                    AND EXPENSE_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cat_id#">
                </cfif>
                <cfif isdefined('attributes.keyword') and len(attributes.keyword)>
                    AND EXPENSE_CAT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
                </cfif>
                <cfif isdefined('attributes.kategory_secim') and len(attributes.kategory_secim) and kategory_secim is 'ik'>
                    AND EXPENCE_IS_HR = 1
                </cfif>
                <cfif isdefined('attributes.kategory_secim') and len(attributes.kategory_secim) and kategory_secim is 'eg'>
                    AND EXPENCE_IS_TRAINING = 1
                </cfif>
            ORDER BY
                EXPENSE_CAT_NAME
        </cfquery>
        <cfquery name="get_category_ids" datasource="#dsn2#">
            SELECT 
                EXPENSE_CAT_ID
            FROM
                EXPENSE_CATEGORY
            WHERE
                EXPENSE_CAT_ID IN (SELECT EXPENSE_CATEGORY_ID FROM EXPENSE_ITEMS WHERE EXPENSE_CATEGORY_ID = #url.cat_id#)
            ORDER BY
                EXPENSE_CAT_ID
        </cfquery>
    </cfif>
	<script type="text/javascript">
		function kontrol()
		{
			if(add_expense_cat.expense_cat_name.value =='')
			{
				alert("<cf_get_lang no='41.Kategori Girmelisiniz'> !");			
				return false;
			}
			if(add_expense_cat.expense_cat_code.value =='')
			{
				alert("<cf_get_lang dictionary_id='33952.Kod Girmelisiniz'>");			
				return false;
			}
			return true;
		}
    </script>
</cfif>

<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event eq 'list')>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.kategory_secim" default="">
    <cfparam name="attributes.form_exist" default="0">
    <cfif attributes.form_exist>
        <cfquery name="get_expense_cat_list" datasource="#dsn2#">
            SELECT 
                *
            FROM
                EXPENSE_CATEGORY
            WHERE
                1=1
                <cfif isdefined("attributes.cat_id")>
                    AND EXPENSE_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cat_id#">
                </cfif>
                <cfif isdefined('attributes.keyword') and len(attributes.keyword)>
                    AND EXPENSE_CAT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
                </cfif>
                <cfif isdefined('attributes.kategory_secim') and len(attributes.kategory_secim) and kategory_secim is 'ik'>
                    AND EXPENCE_IS_HR = 1
                </cfif>
                <cfif isdefined('attributes.kategory_secim') and len(attributes.kategory_secim) and kategory_secim is 'eg'>
                    AND EXPENCE_IS_TRAINING = 1
                </cfif>
            ORDER BY
                EXPENSE_CAT_NAME
        </cfquery>
	<cfelse>
        <cfset get_expense_cat_list.recordcount=0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#get_expense_cat_list.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <script type="text/javascript">
		$( document ).ready(function() {
			document.form.keyword.focus();
		});
	</script>
</cfif>
<cfif isdefined('attributes.event') and attributes.event eq 'upd'>
	<cfset attributes.expense_cat_name =get_expense_cat_list.expense_cat_name>
	<cfset attributes.expense_cat_code =get_expense_cat_list.expense_cat_code>
	<cfset attributes.expense_cat_detail =get_expense_cat_list.expense_cat_detail>
	<cfset attributes.expence_is_hr = get_expense_cat_list.expence_is_hr>
	<cfset attributes.expence_is_training = get_expense_cat_list.expence_is_training>
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'budget.list_expense_cat';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'budget/display/list_budget_expense_cat.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'budget.list_expense_cat';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'budget/form/add_budget_expense_cat.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'budget/query/add_budget_expense_cat.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'budget.list_expense_cat&event=upd';

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'budget.list_expense_cat';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'budget/form/add_budget_expense_cat.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'budget/query/upd_budget_expense_cat.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'budget.list_expense_cat&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'cat_id=##attributes.cat_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.cat_id##';
	
	if( attributes.event is 'upd' ||  attributes.event is 'del' )
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'budget.emptypopup_budget_expense_cat_del&expense_id=#attributes.cat_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'budget/query/del_budget_expense_cat.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'budget/query/del_budget_expense_cat.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'budget.list_expense_cat';
	}
		
	if(IsDefined("attributes.event") && attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=budget.list_expense_cat&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	} 
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'budgetExpenseCat';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EXPENSE_CATEGORY';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item1','item2']"; 
</cfscript>

