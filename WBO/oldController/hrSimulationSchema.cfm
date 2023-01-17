<cfif (isdefined("attributes.event") and listfind('list,add,upd,add_row,upd_row,del',attributes.event)) or not isdefined("attributes.event")>
	<cf_get_lang_set module_name="hr">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		<cfparam name="attributes.keyword" default="">
		<cfif isdefined("attributes.form_submitted")>
			<cfquery name="GET_SIMULATION" datasource="#dsn#">
				SELECT 
					ORGANIZATION_SIMULATION.SIMULATION_ID,
					ORGANIZATION_SIMULATION.SIMULATION_HEAD,
					ORGANIZATION_SIMULATION.RECORD_DATE,
					EMPLOYEES.EMPLOYEE_NAME,
					EMPLOYEES.EMPLOYEE_SURNAME,
					EMPLOYEE_POSITIONS.EMPLOYEE_NAME AS POS_NAME,
					EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME AS POS_SURNAME,
					EMPLOYEE_POSITIONS.POSITION_NAME
				FROM 
					ORGANIZATION_SIMULATION
					INNER JOIN EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = ORGANIZATION_SIMULATION.EMPLOYEE_ID
					INNER JOIN EMPLOYEE_POSITIONS ON EMPLOYEE_POSITIONS.POSITION_CODE = ORGANIZATION_SIMULATION.POSITION_CODE
				<cfif len(attributes.keyword)>
					WHERE
						ORGANIZATION_SIMULATION.SIMULATION_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				</cfif>
				ORDER BY 
					ORGANIZATION_SIMULATION.SIMULATION_ID 
				DESC
			</cfquery>
		<cfelse>
			<cfset get_simulation.recordcount=0>
		</cfif>
		
		<cfparam name="attributes.page" default='1'>
		<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
		<cfparam name="attributes.totalrecords" default='#get_simulation.recordcount#'>
		<cfscript>
			attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
			url_str = "";
			if (isdefined("attributes.start_date") and isdate(attributes.start_date))
				url_str = "#url_str#&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#";
			if (isdefined("attributes.finish_date") and isdate(attributes.finish_date))
				url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyyy')#";
			if (isdefined('attributes.form_submitted') and len(attributes.form_submitted))
				url_str = "#url_str#&form_submitted=#attributes.form_submitted#";
		</cfscript>
	<cfelseif attributes.event is 'upd'>
		<cfquery name="GET_SIMULATION" datasource="#dsn#">
			SELECT 
				ORGANIZATION_SIMULATION.RECORD_EMP,
				ORGANIZATION_SIMULATION.RECORD_DATE,
				ORGANIZATION_SIMULATION.UPDATE_EMP,
				ORGANIZATION_SIMULATION.UPDATE_DATE,
				ORGANIZATION_SIMULATION.SIMULATION_ID,
				ORGANIZATION_SIMULATION.SIMULATION_HEAD,
				ORGANIZATION_SIMULATION.RECORD_DATE,
				EMPLOYEES.EMPLOYEE_NAME,
				EMPLOYEES.EMPLOYEE_SURNAME,
				EMPLOYEE_POSITIONS.EMPLOYEE_NAME AS POS_NAME,
				EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME AS POS_SURNAME,
				EMPLOYEE_POSITIONS.POSITION_NAME,
				EMPLOYEE_POSITIONS.POSITION_ID,
				EMPLOYEE_POSITIONS.EMPLOYEE_ID,
				EMPLOYEE_POSITIONS.POSITION_CODE
			FROM 
				ORGANIZATION_SIMULATION
				INNER JOIN EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = ORGANIZATION_SIMULATION.EMPLOYEE_ID
				INNER JOIN EMPLOYEE_POSITIONS ON EMPLOYEE_POSITIONS.POSITION_CODE = ORGANIZATION_SIMULATION.POSITION_CODE
			WHERE
				ORGANIZATION_SIMULATION.SIMULATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.simulation_id#">
			ORDER BY 
				ORGANIZATION_SIMULATION.SIMULATION_ID 
			DESC
		</cfquery>
		
		<cfquery name="GET_ROW" datasource="#dsn#">
			SELECT 
				ORGANIZATION_SIMULATION_ROWS.HIERARCHY,
		        EMPLOYEE_POSITIONS.POSITION_ID,
				ORGANIZATION_SIMULATION_ROWS.ROW_ID,
				ORGANIZATION_SIMULATION_ROWS.POSITION_TYPE,
				ORGANIZATION_SIMULATION_ROWS.STAGE_ID,
				EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
				EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
				EMPLOYEE_POSITIONS.POSITION_NAME,
				SETUP_POSITION_CAT.POSITION_CAT,
				SETUP_ORGANIZATION_STEPS.ORGANIZATION_STEP_NAME
			FROM 
				ORGANIZATION_SIMULATION_ROWS
				INNER JOIN EMPLOYEE_POSITIONS ON ORGANIZATION_SIMULATION_ROWS.POSITION_CODE = EMPLOYEE_POSITIONS.POSITION_CODE
				LEFT JOIN SETUP_POSITION_CAT ON SETUP_POSITION_CAT.POSITION_CAT_ID = ORGANIZATION_SIMULATION_ROWS.POSITION_TYPE
				LEFT JOIN SETUP_ORGANIZATION_STEPS ON SETUP_ORGANIZATION_STEPS.ORGANIZATION_STEP_ID = ORGANIZATION_SIMULATION_ROWS.STAGE_ID
			WHERE 
				ORGANIZATION_SIMULATION_ROWS.SIMULATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.simulation_id#">
			ORDER BY
				ORGANIZATION_SIMULATION_ROWS.HIERARCHY
		</cfquery>
	<cfelseif listfind('add_row,upd_row',attributes.event)>
		<cfquery name="GET_ORGANIZATION_STEPS" datasource="#dsn#">
			SELECT ORGANIZATION_STEP_ID, ORGANIZATION_STEP_NAME FROM SETUP_ORGANIZATION_STEPS ORDER BY ORGANIZATION_STEP_NAME
		</cfquery>
		<cfquery name="GET_POSITION_CATS" datasource="#dsn#">
			SELECT * FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT 
		</cfquery>
		<cfif attributes.event is 'add_row'>
			<cfquery name="GET_POSITION" datasource="#dsn#">
		        SELECT POSITION_ID,POSITION_NAME,EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.up_position_id#">
		    </cfquery>
		<cfelseif isdefined("attributes.event") and attributes.event is 'upd_row'>
			<cfquery name="GET_ROW" datasource="#dsn#">
				SELECT * FROM ORGANIZATION_SIMULATION_ROWS WHERE ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.row_id#">
			</cfquery>
			<cfquery name="GET_POSITION" datasource="#dsn#">
		    	SELECT POSITION_ID, POSITION_NAME, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row.up_position_id#">
		    </cfquery>
		    <cfquery name="GET_NAME" datasource="#dsn#">
		        SELECT POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row.position_code#">
		    </cfquery>
		</cfif>
    </cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
	<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
		function control()
		{
			if(addsimulation.head.value == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1408.Başlık'>!");
				return false;
			}
			if(addsimulation.position_code.value == "")
			{
				alert("<cf_get_lang no ='1236.Lütfen Pozisyon Giriniz'>!");
				return false;
			}
			return true;
		}
		<cfif attributes.event is 'upd'>
			function kontrol()
			{
				windowopen('','project','cizim_ekrani_pozisyon');
				add_pos.action='<cfoutput>#request.self#?fuseaction=hr.popup_draw_simulation_hierarchy&simulation_id=#attributes.simulation_id#</cfoutput>';
				add_pos.target='cizim_ekrani_pozisyon';
				add_pos.submit();
			}
		</cfif>
	<cfelseif isdefined("attributes.event") and (attributes.event is 'add_row' or attributes.event is 'upd_row')>
		function kontrol()
		{	
			if(add_notes.position_name.value == "")
			{
				alert("<cf_get_lang no='1236.Lütfen Pozisyon Giriniz'> !");
				return false;
			}
			x = document.add_notes.position_cat_id.selectedIndex;
			if (document.add_notes.position_cat_id[x].value == "")
			{ 
				alert ("<cf_get_lang no='1238.Lütfen Pozisyon Tipi Seçiniz'> !");
				return false;
			}	
			x = document.add_notes.organization_step_id.selectedIndex;
			if (document.add_notes.organization_step_id[x].value == "")
			{ 
				alert ("<cf_get_lang no='1237.Lütfen Kademe Seçiniz'> !");
				return false;
			}
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.dsp_simulation_schema';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/dsp_simulation_schema.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.form_add_simulation';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/form_add_simulation.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/add_simulation.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.dsp_simulation_schema&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.form_upd_simulation';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/form/form_upd_simulation.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/query/upd_simulation.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.dsp_simulation_schema&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'simulation_id=##attributes.simulation_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#lang_array.item[17]#';
	
	WOStruct['#attributes.fuseaction#']['add_row'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_row']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add_row']['fuseaction'] = 'hr.popup_add_simulation_row';
	WOStruct['#attributes.fuseaction#']['add_row']['filePath'] = 'hr/form/add_simulation_row.cfm';
	WOStruct['#attributes.fuseaction#']['add_row']['queryPath'] = 'hr/query/add_simulation_row.cfm';
	WOStruct['#attributes.fuseaction#']['add_row']['nextEvent'] = 'hr.dsp_simulation_schema&event=upd';
	WOStruct['#attributes.fuseaction#']['add_row']['Identity'] = '#lang_array.item[85]#';
	
	WOStruct['#attributes.fuseaction#']['upd_row'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd_row']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd_row']['fuseaction'] = 'hr.popup_upd_simulation_row';
	WOStruct['#attributes.fuseaction#']['upd_row']['filePath'] = 'hr/form/upd_simulation_row.cfm';
	WOStruct['#attributes.fuseaction#']['upd_row']['queryPath'] = 'hr/query/upd_simulation_row.cfm';
	WOStruct['#attributes.fuseaction#']['upd_row']['nextEvent'] = 'hr.dsp_simulation_schema&event=upd';
	WOStruct['#attributes.fuseaction#']['upd_row']['parameters'] = 'row_id=##attributes.row_id##';
	WOStruct['#attributes.fuseaction#']['upd_row']['Identity'] = '#lang_array_main.item[164]# #lang_array_main.item[52]#';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.emptypopup_del_simulation_row';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/query/del_simulation_row.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/query/del_simulation_row.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.dsp_simulation_schema&event=upd';
	}
	
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.dsp_simulation_schema&event=add";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if(attributes.event is 'upd_row')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_row'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_row']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_row']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_row']['icons']['add']['onclick'] = "windowopen('#request.self#?fuseaction=hr.dsp_simulation_schema&event=add_row&simulation_id=#get_row.simulation_id#&up_position_id=#get_row.up_position_id#','page');";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
