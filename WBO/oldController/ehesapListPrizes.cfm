<cf_get_lang_set module="ehesap">
<cfif isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1 and isdefined('attributes.event') and listFind('add,upd',attributes.event)>

	<cfif isdefined("attributes.date") and len(attributes.date)>
        <cf_date tarih="attributes.date">
    </cfif>
</cfif>

<cfif (isdefined("attributes.event") and (attributes.event is 'list' or attributes.event is 'add' or attributes.event is 'upd')) or not isdefined("attributes.event")>
	<cfquery name="get_prize_type" datasource="#dsn#">
	    SELECT 
		    PRIZE_TYPE_ID, 
	        PRIZE_TYPE,
	        DETAIL 
	    FROM 
	    	SETUP_PRIZE_TYPE
		WHERE
			IS_ACTIVE = 1
		ORDER BY
			PRIZE_TYPE
	</cfquery>
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		<cfparam name="attributes.keyword" default="">
		<cfif isdefined('attributes.form_submit')>
			<cfinclude template="../hr/ehesap/query/get_prizes.cfm">
		<cfelse>
			<cfset get_prize.recordcount = 0>
		</cfif>
		<cfparam name="attributes.page" default=1>
		<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
		<cfparam name="attributes.totalrecords" default="#get_prize.recordcount#">
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
		<cfinclude template="../hr/ehesap/query/get_prize.cfm">
        <cfset prize_head= get_prize.prize_head >
        <cfset prize_type_cont = get_prize.prize_type_id >
        <cfset prize_date = dateformat(get_prize.prize_date,'dd/mm/yyyy') >
        <cfset prize_give_person_id = get_prize.prize_give_person >
        <cfset prize_give_person = get_emp_info(get_prize.prize_give_person,0,0) >
        <cfset prize_to_id = get_prize.prize_to >
        <cfset prize_to = get_emp_info(get_prize.prize_to,0,0) >
        <cfset prize_detail = get_prize.prize_detail >
        
	<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
    	<cfset prize_head= '' >
        <cfset prize_type_cont = '' >
        <cfset prize_date = '' >
        <cfset prize_give_person_id = '' >
        <cfset prize_give_person = '' >
        <cfset prize_to_id = '' >
        <cfset prize_to = '' >
        <cfset prize_detail = '' >
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
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
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn;
			
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'EMPLOYEES_PRIZE';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PRIZE_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-prize_head','item-prize_type','item-prize_give_person','item-prize_give_person_id','item-prize_to','item-prize_to_id']";
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_prizes';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_prizes.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.list_prizes';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/add_prize.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_prize.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_prizes&event=upd&prize_id=';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_prize';
	
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'validate().check()';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.list_prizes';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/add_prize.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/ehesap/query/upd_prize.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_prizes&event=upd&prize_id=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'prize_id=##attributes.prize_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_prize.prize_head##';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_prize';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'add_prize';
	
	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'validate().check()';
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1 ;
	
	if(isdefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ehesap.list_prizes&event=del&prize_id=#get_prize.prize_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_prize.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_prize.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_prizes';
	}
	
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.list_prizes&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);	
	}
	
	if ((isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event"))
	{
		attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1;
		url_str = "";
		if (len(attributes.keyword))
			url_str = "#url_str#&keyword=#attributes.keyword#";
		if (isdefined("attributes.prize_type") and len(attributes.prize_type))
			url_str = "#url_str#&prize_type=#attributes.prize_type#";
		if (isdefined("attributes.date") and len(attributes.date))
			url_str = "#url_str#&date=#dateformat(attributes.date,'dd/mm/yyyy')#";
		if (isdefined("attributes.form_submit") and len(attributes.form_submit))
			url_str = "#url_str#&form_submit=#attributes.form_submit#";
	}
</cfscript>
