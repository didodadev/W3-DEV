<cf_get_lang_set module_name="ehesap">
<cfif isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1 and isdefined('attributes.event')>
	 <cfif attributes.event eq 'add'>
		<cfif len(attributes.date)>
            <cf_date tarih="attributes.date">
        </cfif>
  	<cfelseif attributes.event eq 'upd' or attributes.event eq 'det'>
    	<cfif len(attributes.date)>
            <cf_date tarih="attributes.date">
        </cfif>
        <cfif len(attributes.apology_date)>
            <cf_date tarih="attributes.apology_date">
        </cfif>
    </cfif>
</cfif>

<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.startdate" default="1/#month(now())#/#session.ep.period_year#">
	<cfparam name="attributes.finishdate" default="#DaysInMonth(CreateDate(year(now()),month(now()),1))#/#month(now())#/#session.ep.period_year#">
	<cfparam name="attributes.apol_startdate" default="">
	<cfparam name="attributes.apol_finishdate" default="">
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.decision_no" default="">
	<cfparam name="attributes.is_active" default="1">
	<cfparam name="attributes.department_id" default="">
	<cfparam name="attributes.cautionto_employee_id" default="">
	<cfparam name="attributes.cautionto_employee_name" default="">
	<cfif len(attributes.startdate) and isdate(attributes.startdate) >
		<cf_date tarih="attributes.startdate">
	<cfelse>
		<cfset attributes.startdate = "">
	</cfif>
	<cfif len(attributes.finishdate) and isdate(attributes.finishdate)>
		<cf_date tarih="attributes.finishdate">
	<cfelse>
		<cfset attributes.finishdate="">
	</cfif>
	<cfif len(attributes.apol_startdate) and isdate(attributes.apol_startdate) >
		<cf_date tarih="attributes.apol_startdate">
	<cfelse>
		<cfset attributes.apol_startdate = "">
	</cfif>
	<cfif len(attributes.apol_finishdate) and isdate(attributes.apol_finishdate)>
		<cf_date tarih="attributes.apol_finishdate">
	<cfelse>
		<cfset attributes.apol_finishdate="">
	</cfif>
	<cfquery name="get_caution_type" datasource="#DSN#">
		SELECT CAUTION_TYPE_ID, CAUTION_TYPE FROM SETUP_CAUTION_TYPE ORDER BY CAUTION_TYPE
	</cfquery>
	<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
		SELECT
			PTR.STAGE,
			PTR.PROCESS_ROW_ID 
		FROM
			PROCESS_TYPE_ROWS PTR,
			PROCESS_TYPE_OUR_COMPANY PTO,
			PROCESS_TYPE PT
		WHERE
			PT.IS_ACTIVE = 1 AND
			PT.PROCESS_ID = PTR.PROCESS_ID AND
			PT.PROCESS_ID = PTO.PROCESS_ID AND
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
			PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%ehesap.list_caution%">
	</cfquery>
	<cfquery name="get_department" datasource="#dsn#">
	    SELECT DEPARTMENT_HEAD,DEPARTMENT_ID FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND IS_STORE <> 1 ORDER BY DEPARTMENT_HEAD
	</cfquery>
	<cfif isdefined('attributes.form_submit')>
		<cfinclude template="../hr/ehesap/query/get_cautions.cfm">
	<cfelse>
		<cfset get_caution.recordcount = 0>
	</cfif>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.totalrecords" default="#get_caution.recordcount#">
	<cfscript>
		attributes.startrow = ((attributes.page-1) * attributes.maxrows) + 1;
		url_str = "";
		if (isdefined('attributes.form_submit'))
			url_str = "&form_submit=#attributes.form_submit#";
		if (len(attributes.keyword))
			url_str = "#url_str#&keyword=#attributes.keyword#";
		if (isdefined('attributes.caution_type') and len(attributes.caution_type))
			url_str = "#url_str#&caution_type=#attributes.caution_type#";
		if (isdefined('attributes.is_active') and len(attributes.is_active))
			url_str = "#url_str#&is_active=#attributes.is_active#";
		if (isdefined('attributes.process_stage') and len(attributes.process_stage))
			url_str = "#url_str#&process_stage=#attributes.process_stage#";
		if (isdefined('attributes.department_id') and len(attributes.department_id))
			url_str = "#url_str#&department_id=#attributes.department_id#";
		if (isdefined('attributes.decision_no') and len(attributes.decision_no))
			url_str = "#url_str#&decision_no=#attributes.decision_no#";
		if (len(attributes.cautionto_employee_id) and len(attributes.cautionto_employee_name))
			url_str = "#url_str#&cautionto_employee_id=#attributes.cautionto_employee_id#";
		if (len(attributes.cautionto_employee_name))
			url_str = "#url_str#&cautionto_employee_name=#attributes.cautionto_employee_name#";
		if (isdefined("attributes.startdate"))
			url_str = "#url_str#&startdate=#dateformat(attributes.startdate,'dd/mm/yyyy')#";
		if (isdefined("attributes.finishdate"))
			url_str = "#url_str#&finishdate=#dateformat(attributes.finishdate,'dd/mm/yyyy')#";
		if (len(attributes.apol_startdate) and isdate(attributes.apol_startdate))
			url_str = "#url_str#&apol_startdate=#dateformat(attributes.apol_startdate,'dd/mm/yyyy')#";
		if (len(attributes.apol_finishdate) and isdate(attributes.apol_finishdate))
			url_str = "#url_str#&apol_finishdate=#dateformat(attributes.apol_finishdate,'dd/mm/yyyy')#";
	</cfscript>
<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd' or attributes.event is 'det')>
	<cfquery name="get_caution_type" datasource="#dsn#">
		SELECT 
			CAUTION_TYPE_ID, 
			CAUTION_TYPE, 
			DETAIL,
			RECORD_EMP, 
			RECORD_DATE, 
			RECORD_IP, 
			UPDATE_DATE, 
			UPDATE_EMP, 
			UPDATE_IP 	
		FROM 
			SETUP_CAUTION_TYPE 
		WHERE
			IS_ACTIVE = 1
		ORDER BY
			CAUTION_TYPE
	</cfquery>
	<cfquery name="GET_SPECIAL_DEFINITION" datasource="#dsn#">
	    SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 11
	</cfquery>
	<cfif attributes.event is 'upd' or attributes.event is 'det'>
		<cfinclude template="../hr/ehesap/query/get_caution.cfm">
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function(){
			$('#keyword').focus();
		});
	</cfif>
</script>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();	
	WOStruct['#attributes.fuseaction#']['systemObject']['processStage'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn;
			
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,det';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'EMPLOYEES_CAUTION';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'CAUTION_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-warner','item-caution_to','item-caution_head']"; 
	
	if(attributes.event contains 'upd' or attributes.event is 'det')
		WOStruct['#attributes.fuseaction#']['systemObject']['processStageSelected'] = get_caution.stage;
	else
		WOStruct['#attributes.fuseaction#']['systemObject']['processStageSelected'] = '';

	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_caution';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_caution.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.list_caution';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/form_add_caution.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_caution.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_caution&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_caution';
	
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'validate().check()';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.list_caution';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/form_upd_caution.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/ehesap/query/upd_caution.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_caution&event=upd&caution_id=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'caution_id=##attributes.caution_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.caution_id##';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'upd_caution';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_caution';
	
	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'validate().check()';
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;	
			
	WOStruct['#attributes.fuseaction#']['det']['pageParams'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['pageParams']['size'] = '9-3';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'hr/ehesap/query/upd_caution.cfm';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'ehesap.list_caution&event=det&caution_id=';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.caution_id##';
	
	if( isdefined('attributes.event') && (attributes.event is 'det' or attributes.event is 'del' or attributes.event is 'upd'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ehesap.emptypopup_del_caution&caution_id=#attributes.caution_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_caution.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_caution.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_caution&event=add';
	}
	
	if(not isdefined('attributes.formSubmittedController'))
	{
		// type'lar include,box,custom tag şekline dönüşecek.
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'ehesap.list_caution';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'hr/ehesap/form/form_upd_caution.cfm';
		WOStruct['#attributes.fuseaction#']['det']['pageObjects'] = structNew();
		
		if(isdefined("attributes.event") and (attributes.event eq 'upd' or attributes.event eq 'det'))
		{
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['type'] = 0; // Include
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['referenceController']  = 'ehesapListCaution.cfm';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['referenceEvent']  = 'upd';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['type'] = 1; // Custom Tag
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['file'] = '<cf_get_workcube_asset asset_cat_id="-8" module_id="48" action_section="CAUTION_ID" action_id="##attributes.caution_id##">';
		}
	
		if(attributes.event is 'upd') //#attributes.event#
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[61]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.popup_caution_history&caution_id=#attributes.caution_id#','wide');";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.list_caution&event=add";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "";
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
	}
</cfscript>