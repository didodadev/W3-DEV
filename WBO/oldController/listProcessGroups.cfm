<cf_get_lang_set module_name="process">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfparam name="attributes.keyword" default="">
    <cfif isdefined("attributes.form_submitted")>
        <cfquery name="GET_PROCESS_TYPE" datasource="#dsn#">
            SELECT 
                * 
            FROM 
                PROCESS_TYPE_ROWS_WORKGRUOP
            WHERE
                PROCESS_ROW_ID IS NULL
                <cfif len(attributes.keyword)>AND WORKGROUP_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"></cfif>
            ORDER BY
                WORKGROUP_NAME
        </cfquery>
    <cfelse>
        <cfset get_process_type.recordcount=0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#get_process_type.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfset adres=''>
    <cfif isdefined("attributes.keyword")>
        <cfset adres = "#adres#&keyword=#attributes.keyword#">
    </cfif>
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')> 
    <cfquery name="GET_GROUP" datasource="#DSN#">
        SELECT RECORD_EMP,RECORD_DATE,UPDATE_EMP,UPDATE_DATE,WORKGROUP_NAME FROM PROCESS_TYPE_ROWS_WORKGRUOP WHERE WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.workgroup_id#">
    </cfquery>
    <cfquery name="GET_RELATED_PROCESS_ID" datasource="#DSN#">
        SELECT MAINWORKGROUP_ID FROM PROCESS_TYPE_ROWS_WORKGRUOP WHERE MAINWORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.workgroup_id#"> AND PROCESS_ROW_ID IS NOT NULL
    </cfquery>
</cfif>

<script type="text/javascript">
//Event : list
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	document.getElementById('keyword').focus();	
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
	function kontrol()
		{
			if(form_process_cat.grup_isim.value == "")
			{
				alert("<cf_get_lang no ='77.Lütfen Grup İsmi Giriniz'>!");
				return false;
			}
			return true;
		}
</cfif>
<cfif isdefined("attributes.event") and listfindnocase('add,upd',attributes.event)>
	function workcube_to_delRow_1(yer)
		{
			flag_custag=document.all.to_pos_ids_1.length;
	
			if(flag_custag > 0)
			{
				try{document.all.to_pos_ids_1[yer].value = '';}catch(e){}
				try{document.all.to_pos_codes_1[yer].value = '';}catch(e){}
				try{document.all.to_emp_ids_1[yer].value = '';}catch(e){}
				try{document.all.to_wgrp_ids_1[yer].value = '';}catch(e){}
			}
			else
			{
				try{document.all.to_pos_ids_1.value = '';}catch(e){}
				try{document.all.to_pos_codes_1.value = '';}catch(e){}
				try{document.all.to_emp_ids_1.value = '';}catch(e){}
				try{document.all.to_wgrp_ids_1.value = '';}catch(e){}
			}
			var my_element = eval('document.all.workcube_to_row_1' + yer);
			my_element.style.display = "none";
			my_element.innerText="";
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'process.list_process_groups';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'process/display/list_process_groups.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'process.list_process_groups';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'process/form/form_add_group.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'process/query/add_group.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'process.list_process_groups&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'process.list_process_groups';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'process/form/form_upd_group.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'process/query/upd_workgroup.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'process.list_process_groups&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'process_id=##attributes.workgroup_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.workgroup_id##';
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=process.emptypopup_del_process_workgroup&workgroup_id=#attributes.workgroup_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'process/query/del_process_workgroup.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'process/query/del_process_workgroup.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'process.list_process_groups';		
	}
	// Tab Menus //
	tabMenuStruct = StructNew();
	tabMenuStruct['#attributes.fuseaction#'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
	
	// Upd //	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
   

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "windowopen('#request.self#?fuseaction=process.popup_form_add_group','page');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
