<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cf_get_lang_set module_name="ehesap">
	<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
	<cfparam name="attributes.page" default="1">
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfscript>
		url_str = "";
		if (isdefined("attributes.form_submit"))
			url_str = "#url_str#&form_submit=1";
		if (len(attributes.sal_year))
			url_str = "#url_str#&sal_year=#attributes.sal_year#";
		attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
	</cfscript>
	<cfif isdefined('attributes.form_submit')>
		<cfquery name="get_rates" datasource="#dsn#">
			SELECT
				PA.MONTH,
				PA.PROJECT_RATE_ID,
				PA.YEAR,
				SS.DEFINITION
			FROM 
				PROJECT_ACCOUNT_RATES PA
				INNER JOIN SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF SS ON PA.ACCOUNT_BILL_TYPE = SS.PAYROLL_ID
			<cfif len(attributes.sal_year)>
				WHERE
					PA.YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
			</cfif>
		</cfquery>
	<cfelse>
		<cfset get_rates.recordcount = 0>
	</cfif>
	<cfparam name="attributes.totalrecords" default="#get_rates.recordcount#">
<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
	<cf_get_lang_set module_name="ehesap">
	<cfinclude template="../hr/ehesap/query/get_code_cat.cfm">
	<cfif attributes.event is 'upd'>
		<cfquery name="get_project_rate" datasource="#dsn#">
			SELECT 
				ACCOUNT_BILL_TYPE,
				MONTH,
				RECORD_DATE,
				RECORD_EMP,
				UPDATE_DATE,
				UPDATE_EMP,
				YEAR
			FROM 
				PROJECT_ACCOUNT_RATES 
			WHERE 
				PROJECT_RATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_rate_id#">
		</cfquery>
		<cfquery name="get_project_rate_rows" datasource="#dsn#">
			SELECT 
				(SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PRO_PROJECTS.PROJECT_ID=PAR.PROJECT_ID) PROJECT_HEAD,
				PAR.PROJECT_ID,
				PAR.RATE
			FROM 
				PROJECT_ACCOUNT_RATES_ROW PAR
			WHERE 
				PAR.PROJECT_RATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_rate_id#">
		</cfquery>
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
		<cfif attributes.event is 'add'>
			$(document).ready(function() {
				row_count=0;
			});
		<cfelseif attributes.event is 'upd'>
			$(document).ready(function() {
				row_count=<cfoutput>#get_project_rate_rows.recordcount#</cfoutput>;
			});
		</cfif>
		
		function sil(sy)
		{
			$('#row_kontrol_'+sy).val(0);
			$('#my_row_'+sy).css('display','none');
		}
		function add_row()
		{
			row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);	
			newRow.setAttribute("name","my_row_" + row_count);
			newRow.setAttribute("id","my_row_" + row_count);		
			newRow.setAttribute("NAME","my_row_" + row_count);
			newRow.setAttribute("ID","my_row_" + row_count);
			$('#record_num').val(row_count);		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" id="row_kontrol_'+ row_count + '" name="row_kontrol_'+ row_count +'" value="1" /><a style="cursor:pointer" onclick="sil(' + row_count + ');" ><img src="images/delete_list.gif" border="0"></a>';	
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input type="hidden" name="project_id'+ row_count +'" id="project_id'+ row_count +'" value=""><input type="text" style="width:460px;" name="project_head'+ row_count +'" id="project_head'+ row_count +'" onFocus="autocomp_project('+row_count+');" value="" class="boxtext"><a href="javascript://" onClick="pencere_ac_project('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0" alt="<cf_get_lang_main no="322.Seçiniz">"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="rate' + row_count +'" id="rate' + row_count +'" value="" onkeyup="return(FormatCurrency(this,event,2));" style="width:100%;" class="box">';
		}
		function pencere_ac_project(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=accounts.project_id' + no +'&project_head=accounts.project_head' + no +'','list');
		}
		function autocomp_project(no)
		{
			AutoComplete_Create("project_head"+no,"PROJECT_HEAD","PROJECT_HEAD","get_project","","PROJECT_ID","project_id"+no,"",3,200);
		}
		function kontrol()
		{
			$('#record_num').val(row_count);
			if($('#period_code_cat').val() == '')
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang no='1171.Muhasebe Kod Grubu'>");
				return false;
			}
			if(row_count == 0)
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='71.Kayıt'>");
				return false;
			}
			for(var j=1;j<=row_count;j++)
			{
				if($('#row_kontrol_'+j).val() == 1)
				{
					if($('#project_id'+j).val() == '' || $('#project_head'+j).val() == '')
					{
						alert('<cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no="4.Proje">');
						return false;
					}
					if($('#rate'+j).val() == '')
					{
						alert('<cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no="1044.Oran">');
						return false;
					}
				}
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_project_rates';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_project_rates.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_add_project_rates';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/add_project_rates.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_project_rates.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_project_rates&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_upd_project_rates';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/upd_project_rates.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/ehesap/query/upd_project_rates.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_project_rates&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'project_rate_id=##attributes.project_rate_id##';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ehesap.emptypopup_del_project_rates';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_project_rates.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_project_rates.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_project_rates';
	}
	
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.list_project_rates&event=add";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'ehesapListProjectRates.cfm';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'PROJECT_ACCOUNT_RATES';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-period_code_cat']";	
</cfscript>
