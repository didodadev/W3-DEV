<cf_get_lang_set module_name="hr">
<cfif not isdefined("attributes.event") or isdefined("attributes.event") and attributes.event is 'list'>
    <cfif not isdefined('attributes.keyword')>
        <cfset arama_yapilmali = 1>
    <cfelse>
        <cfset arama_yapilmali = 0>
    </cfif>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.branch_id" default="">
    <cfparam name="attributes.ACC_TYPE_ID" default="">
    <cfparam name="attributes.startdate" default="#dateformat(date_add('m',-1,CreateDate(year(now()),month(now()),1)),'dd/mm/yyyy')#">
    <cfparam name="attributes.finishdate" default="#dateformat(CreateDate(year(now()),month(now()),DaysInMonth(now())),'dd/mm/yyyy')#"> 
    <cfinclude template="../hr/ehesap/query/get_branch_name.cfm">
    <cfinclude template="../hr/ehesap/query/get_work_accident_type.cfm">
	<cfif isdefined('arama_yapilmali')>
        <cfinclude template="../hr/ehesap/query/get_fees.cfm">
    <cfelse>
    	<cfset GET_FEES.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default=#GET_FEES.recordcount#>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined('attributes.event') and (attributes.event is 'add' or attributes.event is 'upd')>
	<cfinclude template="../hr/ehesap/query/get_accident_securities.cfm">
    <cfinclude template="../hr/ehesap/query/get_work_accident_type.cfm">
	<cfif isdefined('attributes.event') and attributes.event is 'upd'>
        <cfquery name="get_fee" datasource="#dsn#">
            SELECT 
                ESF.*,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME 
            FROM 
                EMPLOYEES_SSK_FEE ESF,
                EMPLOYEES E 
            WHERE 
                ESF.FEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.FEE_ID#"> AND
                ESF.EMPLOYEE_ID = E.EMPLOYEE_ID
        </cfquery>
    
    </cfif>
</cfif>

<script type="text/javascript">
	<cfif not isdefined("attributes.event") or isdefined("attributes.event") and attributes.event is 'list'>
		$( document ).ready(function() {
			document.getElementById('keyword').focus();
		});
	<cfelseif isdefined('attributes.event') and listfind('add,upd',attributes.event,',')>
		<cfif attributes.event is 'add'>
			$( document ).ready(function() {
				gizle(work);
			});
		<cfelseif attributes.event is 'upd'>
			<cfoutput query="GET_FEE">
				<cfif accident eq 0>
					$( document ).ready(function() {
						gizle(work);
					});
				</cfif>
			</cfoutput>
		</cfif>
		
		function kontrol()
		{
			if (document.getElementById('emp_name').value == "")
				{
				alert("<cf_get_lang no='679.Çalışan Seçiniz'>!");
						return false;
				}
			return true;
		}
		function illness_kaldir()
		{
			if(document.getElementById('illness').checked==true)
			{
				document.getElementById('continuationcheck').checked=false;
				document.getElementById('workcheck').checked=false;
				document.getElementById('relativecheck').checked=false;
				gizle(work);
			}
			return true;
		}
		function work_kaldir()
		{
			if(document.getElementById('workcheck').checked==true)
			{
				document.getElementById('continuationcheck').checked=false;
				document.getElementById('illness').checked=false;
				document.getElementById('relativecheck').checked=false;
				goster(work);
			}
			return true;
		}
		function relative_kaldir()
		{
			if(document.getElementById('relativecheck').checked==true)
			{
				document.getElementById('continuationcheck').checked=false;
				document.getElementById('illness').checked=false;
				document.getElementById('workcheck').checked=false;
				gizle(work);
			}
			return true;
		}
		function continuation_kaldir()
		{
			if(document.getElementById('continuationcheck').checked==true)
			{
				document.getElementById('relativecheck').checked=false;
				document.getElementById('illness').checked=false;
				document.getElementById('workcheck').checked=false;
				gizle(work);
			}
			return true;
		}
	</cfif>
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_visited';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_visited.cfm';

	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.list_visited&event=add';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/ssk_fee_self.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_ssk_fee_self.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_visited';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.list_visited';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/upd_ssk_fee_self.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/ehesap/query/upd_ssk_fee_self.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_visited&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'fee_id=##attributes.fee_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.fee_id##';
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.del_ssk_fee_self&fee_id=#attributes.fee_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_ssk_fee_self.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_ssk_fee_self.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_visited';
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=#fusebox.circuit#.popup_ssk_fee_self";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=#fusebox.circuit#.popup_ssk_fee_self_print&fee_id=#attributes.fee_id#&employee_id=#get_fee.employee_id#','page')";
		if (GET_FEE.accident is 1)
		{			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array.item[1150]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.popup_ssk_fee_self_report_print&fee_id=#attributes.FEE_ID#','page');";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[1157]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.popup_ssk_fee_self_report_print_form&fee_id=#attributes.FEE_ID#','page');";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array.item[1158]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.popup_ssk_fee_self_report_print_record&fee_id=#attributes.FEE_ID#','page');";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);


	}

	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'listVisitedController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EMPLOYEES_SSK_FEE';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-emp_name','item-DATE','item-DATEOUT']";
</cfscript>
