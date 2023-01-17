<cf_get_lang_set module_name="hr">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	
	<cfscript>
		attributes.startrow = ((attributes.page - 1) * attributes.maxrows) + 1;
		if (isdefined("attributes.form_submitted"))
		{
			cmp_pos_auth = createObject("component","hr.cfc.get_positions_authority");
			cmp_pos_auth.dsn = dsn;
			get_positions_authority = cmp_pos_auth.get_pos_auth(
				keyword: attributes.keyword,
				status: '#iif(isdefined("attributes.status") and len(attributes.status),"attributes.status",DE(""))#',
				maxrows: attributes.maxrows,
				startrow: attributes.startrow
			);
		}
		else
			get_positions_authority.query_count=0;
			
		if (fuseaction contains "popup")
			is_popup=1;
		else
			is_popup=0;
			
		url_str = '';
		if (isdefined("attributes.keyword") and len(attributes.keyword))
			url_str = '#url_str#&keyword=#attributes.keyword#';
		if (isdefined("attributes.status") and len(attributes.status))
			url_str = '#url_str#&status=#attributes.status#';
		if (isdefined("attributes.form_submitted") and len(attributes.form_submitted))
			url_str = '#url_str#&form_submitted=#attributes.form_submitted#';
	</cfscript>
	<cfparam name="attributes.totalrecords" default="#get_positions_authority.query_count#">
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
    <cfquery name="GET_AUTHORITY" datasource="#dsn#">
        SELECT
        	AUTHORITY_DETAIL,
        	AUTHORITY_HEAD,
        	RECORD_DATE,
        	RECORD_MEMBER,
        	STATUS,
        	UPDATE_DATE,
        	UPDATE_MEMBER
        FROM 
        	EMPLOYEE_AUTHORITY 
        WHERE 
        	AUTHORITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.authority_id#">
    </cfquery>
    <cfquery name="GET_NAMES" datasource="#dsn#">
        SELECT POSITION_CAT_ID FROM EMPLOYEE_POSITIONS_AUTHORITY WHERE AUTHORITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.authority_id#">
    </cfquery>
    <cfset pos_cat_list=''>
    <cfloop query="GET_NAMES">
        <cfif len(pos_cat_list)>
            <cfset pos_cat_list='#pos_cat_list#,#position_cat_id#'>
        <cfelse>
            <cfset pos_cat_list='#position_cat_id#'>
        </cfif>
    </cfloop>
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
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_contents';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_contents.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.form_add_content';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/form_add_content.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/add_position_cat_content.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_contents&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.form_upd_content';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/form/form_upd_content.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/query/upd_position_cat_content.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_contents&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'authority_id=##attributes.authority_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.authority_id##';
	
	if( isdefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.emptypopup_del_content&authority_id=#attributes.authority_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/query/del_position_cat_content.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/query/del_position_cat_content.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_contents';
	}
	
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_contents&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.authority_id#&print_type=181','page');";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'hrListContents';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EMPLOYEE_AUTHORITY';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-CONTENT_HEAD']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>
