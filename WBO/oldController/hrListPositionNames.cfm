<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	
	<cfscript>
		attributes.startrow = ((attributes.page - 1) * attributes.maxrows) + 1;
		if (isdefined("attributes.form_submitted"))
		{
			cmp_pos_name = createObject("component","hr.cfc.get_position_names");
			cmp_pos_name.dsn = dsn;
			get_pos_name = cmp_pos_name.get_position_name(
				keyword: attributes.keyword,
				maxrows: attributes.maxrows,
				startrow: attributes.startrow
			);
		}
		else
			get_pos_name.query_count = 0;
		
		url_string = "";
		if (len(attributes.keyword))
			url_string = "#url_string#&keyword=#attributes.keyword#";
		if (isdefined("attributes.form_submitted") and len(attributes.form_submitted))
			url_string = "#url_string#&form_submitted=#attributes.form_submitted#";
	</cfscript>
	<cfparam name="attributes.totalrecords" default="#get_pos_name.query_count#">
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cfinclude template="../hr/query/get_position_names.cfm">
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_position_names';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_position_names.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.popup_add_position_name';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/add_position_name.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/add_position_name.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_position_names&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.popup_upd_position_name';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/form/upd_position_name.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/query/upd_position_name.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_position_names&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	
    if(isdefined("attributes.event") and(attributes.event is 'upd' or attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.emptypopup_del_position_name&id=#attributes.id#&head=#get_pos_name.position_name#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/query/del_position_name.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/query/del_position_name.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_position_names';
	}

	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'hrListPositionNames';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EMPLOYEE_POSITION_NAMES';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-position_name']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>
