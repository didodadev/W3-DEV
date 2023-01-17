<cf_xml_page_edit fuseact="myhome.list_my_trainings">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset url_str="keyword=#attributes.keyword#">
<cfinclude template="../myhome/query/get_emp_training.cfm">
<cfif get_tra_dep.recordcount>
	<cfoutput query="get_tra_dep">
		<cfquery name="GET_TRAIN_CLASS_DT" datasource="#dsn#">
		  SELECT 
			  TCADT.ATTENDANCE_MAIN,
			  TCADT.IS_EXCUSE_MAIN,
			  TCADT.EXCUSE_MAIN,
			  TCA.START_DATE
		  FROM
			  TRAINING_CLASS_ATTENDANCE TCA,
			  TRAINING_CLASS_ATTENDANCE_DT TCADT
		  WHERE
			  TCA.CLASS_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#"> AND
			  TCADT.EMP_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#emp_id#"> AND
			  TCADT.IS_TRAINER = 0 AND
			  TCA.CLASS_ATTENDANCE_ID=TCADT.CLASS_ATTENDANCE_ID
		</cfquery>
		<cfquery datasource="#dsn#" name="GET_TRAIN_CLASS_RESULTS">
		  SELECT
			  PRETEST_POINT,
			  FINALTEST_POINT
		  FROM
			  TRAINING_CLASS_RESULTS
		  WHERE
			  CLASS_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#"> AND
			  EMP_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#emp_id#">
		</cfquery>
		<cfif x_is_maliyet>
			<cfquery name="GET_TRAIN_CLASS_COST" datasource="#DSN#">
				SELECT
					 SUM(TCR.GERCEKLESEN_BIRIM) as GERCEKLESEN
				FROM
					TRAINING_CLASS_COST TC,
					TRAINING_CLASS_COST_ROWS TCR
				WHERE
					TC.TRAINING_CLASS_COST_ID = TCR.TRAINING_CLASS_COST_ID
					AND TC.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLASS_ID#">
			</cfquery>
		</cfif>
	</cfoutput>
<cfelse>
	<cfset colspan_ = 8>
	<cfif x_is_maliyet>
		<cfset colspan_ = colspan_ + 1>
	</cfif>
</cfif>
<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.list_my_tranings';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/list_my_trainings.cfm';
	
/*	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_form_add_expense_cat';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/form_add_budget_expense_cat.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_budget_expense_cat.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_expense_cat&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_form_upd_expense_cat';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/form_upd_budget_expense_cat.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/ehesap/query/upd_budget_expense_cat.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_expense_cat&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'cat_id=##attributes.cat_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_expense_cat.expense_cat_name##';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ehesap.emptypopup_del_expense_cat';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_budget_expense_cat.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_budget_expense_cat.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_expense_cat';
	}
	
	if(attributes.event is 'upd')
	{
		include "../hr/ehesap/query/get_expense_item_static_cat.cfm";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.list_expense_cat&event=add";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}*/
</cfscript>
