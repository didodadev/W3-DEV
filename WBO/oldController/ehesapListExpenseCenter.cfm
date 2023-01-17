<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.process_type" default="">
	<cfparam name="attributes.form_exist" default="0">
	<cfif attributes.form_exist>
		<cfquery name="GET_EXPENSE" datasource="#dsn2#">
			SELECT
				DETAIL,
				EXPENSE,
				EXPENSE_CODE,
				EXPENSE_ID
			FROM
				EXPENSE_CENTER
			WHERE	
				EXPENSE_ID IS NOT NULL
				<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
					AND EXPENSE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					EXPENSE_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				</cfif>
				<cfif len(attributes.process_type) and attributes.process_type eq 1>
					AND EXPENSE_ACTIVE = 1
				<cfelseif len(attributes.process_type) and attributes.process_type eq 0>
					AND EXPENSE_ACTIVE = 0
			   </cfif>
			ORDER BY
				EXPENSE_CODE
		</cfquery>
	<cfelse>
		<cfset get_expense.recordcount=0>
	</cfif>
	<cfparam name="attributes.page" default='1'>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.totalrecords" default='#get_expense.recordcount#'>
	<cfscript>
		attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
		url_str = '';
		if (isdefined("attributes.keyword") and len(attributes.keyword))
			url_str = '#url_str#&keyword=#attributes.keyword#';
		if (isdefined("attributes.form_exist") and len(attributes.form_exist))
			url_str = '#url_str#&form_exist=#attributes.form_exist#';
		if (isdefined("attributes.process_type") and len(attributes.process_type))
			url_str = '#url_str#&process_type=#attributes.process_type#';
	</cfscript>
<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
	<cfquery name="GET_MUCH_EXPENSE" datasource="#dsn2#">
		SELECT
			EXPENSE_CODE,
			EXPENSE
		FROM
			EXPENSE_CENTER
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			WHERE
				EXPENSE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
				DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
				EXPENSE_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		</cfif>
		<cfif isdefined("attributes.expense_id")>
			WHERE 
				EXPENSE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
		</cfif>
		ORDER BY
			EXPENSE_CODE
	</cfquery>
	<cf_get_lang_set module_name="ehesap">
	<!---<cfif attributes.event is 'upd'>
		<cfquery name="GET_HIER" datasource="#dsn2#">
			SELECT * FROM EXPENSE_CENTER WHERE EXPENSE_CODE LIKE '#GET_EXPENSE.EXPENSE_CODE#.%'
		</cfquery>
	</cfif>--->
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
	<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
		function kontrol()
		{
			if($('#expense').val() =='')
			{
				alert("<cf_get_lang no='1316.Lütfen Masraf alanını doldurunuz'> !");			
				return false;
			}
			if($('#expense_code').val() =='')
			{
				alert("<cf_get_lang no='1315.Lütfen kod alanını doldurunuz'> !");			
				return false;
			}
			return true;
		}
	</cfif>
</script>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_expense_center';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_expense_center.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_form_add_expense_center';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/form_add_expense_center.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_expense_center.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_expense_center&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_form_upd_expense_center';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/form_upd_expense_center.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/ehesap/query/upd_expense_center.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_expense_center&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'expense_id=##attributes.expense_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_expense.expense##';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ehesap.emptypopup_del_expense_center';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_expense_center.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_expense_center.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_expense_center';
	}
	
	if(attributes.event is 'upd')
	{
		include "../hr/ehesap/query/get_expense_center.cfm";
		include "../hr/ehesap/query/get_ssk_offices.cfm";
		obj=0;
		if (isdefined("attributes.obj"))
		{
			obj = attributes.obj;
			url_string = "";
			if (isdefined("field_id"))
				url_string = "#url_string#&field_id=#field_id#";
			if (isdefined("field_name"))
				url_string = "#url_string#&field_name=#field_name#";
			if (isdefined("code"))
				url_string = "#url_string#&code=#code#";
			listuzun = listlen(get_expense.expense_code,".");
			cat_code = listgetat(get_expense.expense_code,listuzun,".");
			ust_cat_code = listdeleteat(get_expense.expense_code,listuzun,".");
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array.item[1313]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.list_expense_center&event=add";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'ehesapListExpenseCenter.cfm';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EXPENSE_CENTER';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-head_exp_code','item-expense_name']";
</cfscript>
