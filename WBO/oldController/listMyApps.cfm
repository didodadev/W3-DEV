<cf_get_lang_set module_name="myhome">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfparam name="attributes.start_date" default="">
    <cfparam name="attributes.finish_date" default="">
    <cfparam name="attributes.keyword" default="">
    <cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
        <cf_date tarih = "attributes.finish_date">
    </cfif>
    <cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
        <cf_date tarih = "attributes.start_date">
    </cfif>
    <cfif isdefined("form_submitted")>
        <cfinclude template="../myhome/query/get_my_apps.cfm">
        <cfparam name="attributes.totalrecords" default="#get_apps.recordcount#">
    <cfelse>
        <cfparam name="attributes.totalrecords" default="0">
    </cfif>
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
    <cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
    <cfquery name="GET_NOTICESS" datasource="#DSN#">
      SELECT NOTICE_ID,NOTICE_HEAD,NOTICE_NO,STATUS FROM NOTICES ORDER BY NOTICE_HEAD
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
    <cfquery name="GET_APP" datasource="#dsn#">
        SELECT
            *
        FROM
            EMPLOYEES_APP
        WHERE
            EMPLOYEE_ID = #session.ep.userid#
    </cfquery>
    <cfquery name="GET_APP_POS" datasource="#dsn#">
        SELECT
            *
        FROM
            EMPLOYEES_APP_POS
        WHERE
            APP_POS_ID = #attributes.APP_POS_ID#
    </cfquery>
    <cfquery name="GET_MONEYS" datasource="#dsn#">
        SELECT
            MONEY_ID,
            MONEY
        FROM
            SETUP_MONEY
        WHERE
            PERIOD_ID = #session.ep.period_id#
    </cfquery>
    <cfparam name="attributes.app_id" default="">
    <cfquery name="GET_NOTICE" datasource="#dsn#">
        SELECT NOTICE_HEAD, NOTICE_NO FROM NOTICES WHERE NOTICE_ID = #attributes.notice_id#
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
    <cfquery name="GET_APP" datasource="#dsn#">
        SELECT
            *
        FROM
            EMPLOYEES_APP
        WHERE
            EMPLOYEE_ID = #session.ep.userid#
    </cfquery>
    <cfquery name="GET_MONEYS" datasource="#dsn#">
        SELECT
            MONEY_ID,
            MONEY
        FROM
            SETUP_MONEY
        WHERE
            PERIOD_ID = #session.ep.period_id#
    </cfquery>
    <cfquery name="GET_NOTICE" datasource="#dsn#">
        SELECT NOTICE_HEAD, NOTICE_NO FROM NOTICES WHERE NOTICE_ID = #attributes.notice_id#
    </cfquery>
</cfif>

<script type="text/javascript">
//Event : list
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	document.getElementById('keyword').focus();
<cfelseif isdefined("attributes.event") and attributes.event is 'upd' or  attributes.event is 'add'> 
	function kontrol()
	{
		document.add_app_pos.salary_wanted.value = filterNum(document.add_app_pos.salary_wanted.value);
		return true;
	}
</cfif>

</script>


<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.list_my_apps';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/list_my_apps.cfm';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'myhome.popup_upd_app_pos';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'myhome/form/form_upd_app_pos.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'myhome/query/upd_app_pos.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'myhome.list_my_apps&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.notice_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.notice_id##';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'myhome.popup_add_app_pos';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'myhome/form/form_add_app_pos.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'myhome/query/add_app_pos.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'myhome.list_my_apps&event=add';
	if(IsDefined("attributes.event") and attributes.event is 'upd')
	{	
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['onclick'] = "windowopen('#request.self#?fuseaction=myhome.list_my_apps&event=add&NOTICE_ID=#attributes.NOTICE_ID#','page');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
</cfscript>
