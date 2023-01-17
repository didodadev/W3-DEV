<cfif (isdefined("attributes.event") and (attributes.event is 'list' or attributes.event is 'add' or attributes.event is 'upd')) or not isdefined("attributes.event")>
	<cfinclude template="../hr/ehesap/query/get_moneys.cfm">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		<cfscript>
			if (not isdefined('attributes.salary_year'))
				attributes.salary_year = year(now());
			if (not isdefined('attributes.salary_mon'))
				attributes.salary_mon = month(now());
			if (isdefined("attributes.is_submit"))
				include "../hr/ehesap/query/get_salary_moneys.cfm";
			else
				get_salary_moneys.recordcount = 0;
				
			url_str = "";
			if (isdefined("attributes.keyword") and len(attributes.keyword))
				url_str = "#url_str#&keyword=#attributes.keyword#";
			if (isdefined("attributes.salary_year") and len(attributes.salary_year))
				url_str = "#url_str#&salary_year=#attributes.salary_year#";
			if (isdefined("attributes.salary_mon") and len(attributes.salary_mon))
				url_str = "#url_str#&salary_mon=#attributes.salary_mon#";
			if (isdefined("attributes.salary_money") and len(attributes.salary_money))
				url_str = "#url_str#&salary_money=#attributes.salary_money#";
			if (isdefined("attributes.is_submit") and len(attributes.is_submit))
				url_str = "#url_str#&is_submit=#attributes.is_submit#";
		</cfscript>
		<!---<cfquery name="get_xml_zone_control" datasource="#dsn#">
			SELECT
				PROPERTY_VALUE,
				PROPERTY_NAME
			FROM
				FUSEACTION_PROPERTY
			WHERE
				OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
				FUSEACTION_NAME = 'ehesap.popup_form_add_salary_money' AND
				PROPERTY_NAME = 'xml_zone_control'
		</cfquery>--->
		<cfparam name="attributes.page" default=1>
		<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
		<cfparam name="attributes.totalrecords" default='#get_salary_moneys.recordcount#'>
		<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
		<cfif attributes.event is 'add'>
			<cfparam name="attributes.salary_year" default="#session.ep.period_year#">
		</cfif>
		<cfquery name="get_zones" datasource="#dsn#">
			SELECT ZONE_NAME,ZONE_ID FROM ZONE WHERE ZONE_STATUS = 1 ORDER BY ZONE_NAME
		</cfquery>
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
		function unformat_fields()
		{
			<cfoutput query="get_moneys">
				add_salary_money.worth_#money#.value = filterNum(add_salary_money.worth_#money#.value,8);
			</cfoutput>
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_salary_money';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_salary_money.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_form_add_salary_money';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/add_salary_money.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_salary_money.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_salary_money&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_form_upd_salary_money';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/upd_salary_money.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/ehesap/query/add_salary_money.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_salary_money&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'salary_year=##salary_year##&salary_month=##salary_month##&zone_id=##zone_id##';
	
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.list_salary_money&event=add";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'ehesapListSalaryMoney.cfm';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EMPLOYEES_SALARY_CHANGE';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
</cfscript>
