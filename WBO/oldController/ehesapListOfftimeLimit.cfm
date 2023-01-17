<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfquery name="get_parameters" datasource="#dsn#">
		SELECT
	    	LIMIT_ID,
	        STARTDATE, 
	        FINISHDATE,
	        DEFINITION_TYPE,
	        PUANTAJ_GROUP_IDS
	    FROM 
		    SETUP_OFFTIME_LIMIT
	</cfquery>
	
	<cfquery name="get_puantaj_groups" datasource="#dsn#">
		SELECT 
	    	GROUP_ID, 
	    	GROUP_NAME 
	   	FROM 
	    	EMPLOYEES_PUANTAJ_GROUP
	</cfquery>
<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
	<cf_get_lang_set module_name="ehesap">
</cfif>

<script type="text/javascript">
	<cfif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
		function kontrol()
		{
			if($('#definition_type').val() == 1)
			{
				if($('#limit2').val() == '' || $('#limit3').val() == '' || $('#limit4').val() == '')
				{
					alert("<cf_get_lang no='268.Limit girmelisiniz'>");
					return false;
				}
				if($('#limit_2_days').val() == '' || $('#limit_3_days').val() == '' || $('#limit_4_days').val() == '')
				{
					alert("<cf_get_lang no='270.aya kadar girmelisiniz'>");
					return false;
				}
			}
			return true;
		}
		function change_page(i)
		{
			if (i == 0)
			{
				$('#item-limit_2').css('display','none');
				$('#item-limit_3').css('display','none');
				$('#item-limit_4').css('display','none');
				$('#limit1_yil_td').text("<cf_get_lang_main no='1312.Ay'>");
			}
			else
			{
				$('#item-limit_2').css('display','');
				$('#item-limit_3').css('display','');
				$('#item-limit_4').css('display','');
				$('#limit1_yil_td').text("<cf_get_lang no='269.aya kadar'>");
			}
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_offtime_limit';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_offtime_limit.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_form_add_offtime_limit';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/form_add_offtime_limit.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_offtime_limit.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_offtime_limit&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_form_upd_offtime_limit';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/form_upd_offtime_limit.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/ehesap/query/upd_offtime_limit.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_offtime_limit&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'limit_id=##attributes.limit_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.limit_id##';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ehesap.list_offtime_limit';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_offtime_limit.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_offtime_limit.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_offtime_limit';
	}
	
	if(attributes.event is 'upd' or attributes.event is 'add')
	{
		cmp = createObject("component","hr.ehesap.cfc.employee_puantaj_group");
		cmp.dsn = dsn;
		get_groups = cmp.get_groups();
		
		if (attributes.event is 'upd')
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.list_offtime_limit&event=add";
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
			
			include "../hr/ehesap/query/get_offtime_limit.cfm";
		}
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'ehesapListOfftimeLimit.cfm';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SETUP_OFFTIME_LIMIT';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-startdate','item-limit_1','item-limit_2','item-limit_3','item-limit_4','item-min_max_days']";
</cfscript>
