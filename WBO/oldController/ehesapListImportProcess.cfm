<cfif (isdefined("attributes.event") and (attributes.event is 'list' or attributes.event is 'add')) or not isdefined("attributes.event")>
	<cfinclude template="../hr/ehesap/query/get_our_comp_and_branchs.cfm">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		<cfparam name="attributes.keyword" default="">
		<cfparam name="attributes.page" default=1>
		<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
		<cfscript>
			attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
			url_str = "";
			if (isdefined("attributes.branch_id") and len(attributes.branch_id))
				url_str = "#url_str#&branch_id=#attributes.branch_id#";
			if (isdefined("attributes.import_type") and len(attributes.import_type))
				url_str = "#url_str#&import_type=#attributes.import_type#";
			if (isdefined("attributes.form_submit") and len(attributes.form_submit))
				url_str = '#url_str#&form_submit=#attributes.form_submit#';
		</cfscript>
		<cfif isdefined('attributes.form_submit')>
			<cfquery name="get_imports" datasource="#dsn#">
				SELECT 
					EPF.PROCESS_TYPE,
					EPF.BRANCH_ID,
					EPF.RECORD_EMP,
					EPF.RECORD_DATE,
					EPF.FILE_NAME,
					EPF.FILE_SERVER_ID,
					EPF.ISLEM_ID,
					B.BRANCH_NAME,
					E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS RECORD_NAME
				FROM 
					EMPLOYEES_PUANTAJ_FILES EPF
					LEFT JOIN BRANCH B ON B.BRANCH_ID = EPF.BRANCH_ID
					LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EPF.RECORD_EMP
				WHERE
					1=1
					<cfif not session.ep.ehesap>
						AND EPF.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
					</cfif>
					<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
						AND EPF.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
					</cfif>
					<cfif isdefined("attributes.import_type") and len(attributes.import_type)>
						AND EPF.PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.import_type#">
					</cfif>
				ORDER BY 
					EPF.RECORD_DATE DESC
			</cfquery>
		<cfelse>
			<cfset get_imports.recordcount = 0>
		</cfif>
		<cfparam name="attributes.totalrecords" default="#get_imports.recordcount#">
	<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
		<cf_get_lang_set module_name="ehesap">
		<cfparam name="attributes.related_company" default="">
		<cfif month(now()) eq 1>
			<cfparam name="attributes.sal_mon" default="1">
		<cfelse>
			<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
		</cfif>	
		<cfparam name="attributes.process_type" default="1">
		<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
		<cfquery name="get_related_company" datasource="#dsn#">
			SELECT DISTINCT
				RELATED_COMPANY
			FROM 
				BRANCH
			WHERE
				BRANCH_ID IS NOT NULL
				<cfif not session.ep.ehesap>
					AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
				</cfif>
			ORDER BY 
				RELATED_COMPANY
		</cfquery>
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif isdefined("attributes.event") and attributes.event is 'add'>
		function import_et()
		{
			if($('#branch_id').val() == "" && $('#related_company').val() == "" && list_find("2,3,4,5",$('#process_type').val()))
			{
				alert("<cf_get_lang no ='1105.Lütfen Şube veya İlgili Şirket Seçiniz'> !");
				return false;
			}
			if($('#uploaded_file').val() == "")
			{
				alert("<cf_get_lang no ='1106.Lütfen İmport Edilecek Belge Giriniz'> !");
				return false;
			}
			
			//windowopen('','small','cc_paym');
			<!---if (list_find("2,3,4",document.getElementById('process_type').value))
				import_worktimes.action='<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_import_payments</cfoutput>';
			else if (document.getElementById('process_type').value == 5)
				import_worktimes.action='<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_import_worktimes</cfoutput>';
			else if (document.getElementById('process_type').value == 6)
				import_worktimes.action='<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_add_ext_worktime_import_2</cfoutput>';
			else if (document.getElementById('process_type').value == 8)
				import_worktimes.action='<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_add_ext_worktime_import_3</cfoutput>';
			else if (document.getElementById('process_type').value == 7)
			{
				import_worktimes.action='<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_add_offtime_import</cfoutput>';}--->
			return true;
		}
		function formatGoster(type,text)
		{
			document.getElementById('tdImport').innerHTML = "";
			document.getElementById('tdImport').innerHTML = "<strong>" + text + ":</strong><br /><br />";
		
			if (type == "")
				document.getElementById('tdImport').innerHTML = "";
			else if (type == 2)
				document.getElementById('tdImport').innerHTML += document.getElementById('td2').innerHTML;
			else if (type == 3)
				document.getElementById('tdImport').innerHTML += document.getElementById('td3').innerHTML;
			else if (type == 4)
				document.getElementById('tdImport').innerHTML += document.getElementById('td4').innerHTML;
			else if (type == 5)
				document.getElementById('tdImport').innerHTML += document.getElementById('td5').innerHTML;
			else if (type == 6)
				document.getElementById('tdImport').innerHTML += document.getElementById('td6').innerHTML;
			else if (type == 8)
				document.getElementById('tdImport').innerHTML += document.getElementById('td8').innerHTML;
			else if (type == 7)
				document.getElementById('tdImport').innerHTML += document.getElementById('td7').innerHTML;
		}
		function type_gizle()
		{
			if ($('#process_type').val() == 5)
				$('#is_mesai_type').css('display','');
			else
				$('#is_mesai_type').css('display','none');
			if ($('#process_type').val() == 5 || $('#process_type').val() == 6 || $('#process_type').val() == 8)
				$('#is_sal_show').css('display','');
			else
				$('#is_sal_show').css('display','none');
			if ($('#process_type').val() == 6 || $('#process_type').val() == 7)
			{
				$('#is_related_company').css('display','none');
				$('#is_branch_id').css('display','none');
				$('#is_file_format').css('display','');
			}
			else
			{
				$('#is_related_company').css('display','');
				$('#is_branch_id').css('display','');
				$('#is_file_format').css('display','none');
			}
			if ($('#process_type').val() == 7)
			{
				$('#is_process').css('display','');
				$('#is_valid').css('display','');
				$('#is_validator_position').css('display','');
				$('#is_puantaj').css('display','');
			}
			else
			{
				$('#is_process').css('display','none');
				$('#is_valid').css('display','none');
				$('#is_validator_position').css('display','none');
				$('#is_puantaj').css('display','none');
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_import_process';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_import_process.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.import_payments';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/display/import_payments.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/import_payments.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_import_process&event=upd';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ehesap.emptypopup_del_import_payments';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_import_payments.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_import_payments.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.import_payments';
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'ehesapListImportProcess.cfm';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EMPLOYEES_PUANTAJ_FILES';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-process_type','item-uploaded_file']";
</cfscript>
