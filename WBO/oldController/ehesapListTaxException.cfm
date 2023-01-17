<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfscript>
		if (isdefined("attributes.is_submit"))
			include "../hr/ehesap/query/get_tax_exc.cfm";
		else
			get_tax_exc.recordcount = 0;
		url_str = "";
		if (isdefined("attributes.keyword") and len(attributes.keyword))
			url_str = "#url_str#&keyword=#attributes.keyword#";
		if (isdefined("attributes.sal_year") and len(attributes.sal_year))
			url_str = "#url_str#&sal_year=#attributes.sal_year#";
		if (isdefined("attributes.is_submit") and len(attributes.is_submit))
			url_str = "#url_str#&is_submit=#attributes.is_submit#";
		if (isdefined("attributes.status") and len(attributes.status))
			url_str = "#url_str#&status=#attributes.status#";
		attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
	</cfscript>
	<cfparam name="attributes.totalrecords" default='#get_tax_exc.recordcount#'>
	<cfparam name="attributes.keyword" default="">
<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>	
	<cfquery name="get_money" datasource="#dsn#">
        SELECT 
            MONEY_ID, 
            MONEY
        FROM 
            SETUP_MONEY	
        WHERE 
        	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
    </cfquery>
	<cfif isdefined("attributes.event") and attributes.event is 'upd'>
		<cfquery name="get_tax_exc" datasource="#dsn#">
		    SELECT 
		        TAX_EXCEPTION_ID, 
		        TAX_EXCEPTION, 
		        START_MONTH, 
		        FINISH_MONTH, 
		        AMOUNT, 
		        DETAIL, 
		        MONEY_ID, 
		        CALC_DAYS, 
		        YUZDE_SINIR, 
		        IS_ALL_PAY, 
		        RECORD_DATE, 
		        RECORD_EMP, 
		        RECORD_IP,
		        UPDATE_EMP, 
		        UPDATE_DATE,
		        UPDATE_IP, 
		        IS_ISVEREN,
		        IS_SSK,
		        EXCEPTION_TYPE ,
				STATUS
		    FROM
		        TAX_EXCEPTION 
		    WHERE 
		        TAX_EXCEPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.tax_exception_id#">
		</cfquery>
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
	<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
		function form_chk()
		{
			$('#amount').val(filterNum($('#amount').val()));
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_tax_exception';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_tax_exception.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_add_tax_exception';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/add_tax_exception.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_tax_exception.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_tax_exception&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_upd_tax_exception';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/upd_tax_exception.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/ehesap/query/upd_tax_exception.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_tax_exception&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'tax_exception_id=##attributes.tax_exception_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_tax_exc.tax_exception##';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ehesap.emptypopup_del_tax_exception';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_tax_exception.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_tax_exception.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_tax_exception';
	}
	
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.list_tax_exception&event=add";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'ehesapListTaxException.cfm';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'TAX_EXCEPTION';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-tax_exc_head','item-yuzde_sinir']";
</cfscript>
