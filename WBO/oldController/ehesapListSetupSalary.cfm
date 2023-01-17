<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.salary_year" default="#session.ep.period_year#">
	<cfif isdefined('attributes.form_submit')>
		<cfquery name="GET_SETUP_SALARIES" datasource="#dsn#">
			SELECT
				SU.*
			FROM
				SALARY_UPDATE SU
			WHERE
				SU.UPDATE_ID IS NOT NULL
				<cfif isdefined("attributes.salary_year") and len(attributes.salary_year)>
					AND SU.UPDATE_ID IN (SELECT SUY.UPDATE_ID FROM SALARY_UPDATE_YEARS SUY WHERE SUY.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.salary_year#">)
				</cfif>
		</cfquery>
	<cfelse>
		<cfset get_setup_salaries.recordcount = 0>
	</cfif>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.totalrecords" default = '#get_setup_salaries.recordcount#'>
	<cfscript>
		attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
		url_str = "";
		if (isdefined("attributes.form_submit") and len(attributes.form_submit))
			url_str = "#url_str#&form_submit=#attributes.form_submit#";
		if (isdefined("attributes.salary_year") and len(attributes.salary_year))
			url_str = "#url_str#&salary_year=#attributes.salary_year#";
	</cfscript>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cf_get_lang_set module_name="ehesap">
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cf_get_lang_set module_name="ehesap">
	<cfquery name="get_setup_salary" datasource="#dsn#">
		SELECT
			CHANGE_ALL,
			CONTROL_FINISHDATE,
			METHOD_TYPE,
			RECORD_DATE,
			RECORD_EMP,
			SAL_MON,
			SALARY_TYPE,
			UPDATE_DATE,
			UPDATE_EMP,
			UPDATE_PERCENT,
			VALID,
			VALID_DATE,
			VALID_EMP,
			VALIDATOR_POSITION,
			WORK_FINISH_DATE,
			WORK_START_DATE
		FROM 
			SALARY_UPDATE 
		WHERE 
			UPDATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#update_id#">
	</cfquery>
	<cfquery name="get_setup_salary_years" datasource="#dsn#">
		SELECT SAL_YEAR FROM SALARY_UPDATE_YEARS WHERE UPDATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#update_id#">
	</cfquery>
	<cfquery name="get_setup_salary_companies" datasource="#dsn#">
		SELECT OUR_COMPANY_ID FROM SALARY_UPDATE_COMPANIES WHERE UPDATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#update_id#">
	</cfquery>
	<cfquery name="get_setup_salary_position_cats" datasource="#dsn#">
		SELECT POSITION_CAT_ID FROM SALARY_UPDATE_POSITION_CATS WHERE UPDATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#update_id#">
	</cfquery>
	<cfset company_list = valuelist(get_setup_salary_companies.our_company_id,",")>
	<cfset position_cat_list = valuelist(get_setup_salary_position_cats.position_cat_id,",")>
	<cfset year_list = "#year(now())#,#year(now())+1#,#year(now())+2#,#valuelist(get_setup_salary_years.sal_year)#">
	<cfset year_list = ListDeleteDuplicates(ListSort(year_list,"Numeric","Asc"))>
</cfif>

<script type="text/javascript">
	<cfif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
		function form_chk()
		{
			/*ŞİRKET SEÇİLMELİ*/
			if(!$('#our_company_id').val())
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='162.Şirket'>");
				return false;
			}
			/*yüzde seçilmeli*/
			if(!$('#percent').val())
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang no='189.Yüzde'>");
				return false;
			}
			/*İşe Giriş Tarihi*/
			if(!$('#work_start_date').val())
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang no='402.İşe giriş tarihi'>");
				return false;
			}
			/*YIL SEÇİLMELİ*/
			flag = 0;
			for (i=0;i <document.getElementsByName('sal_year').length;i++)
				if (upd_salary.sal_year[i].checked) flag = 1;
			if (!flag)
			{
				alert("<cf_get_lang no ='1089.En az bir yıl seçmelisiniz'> !");
				return false;
			}
			$('#percent').val(filterNum($('#percent').val(),1));
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_setup_salary';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_setup_salary.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_form_add_setup_salary';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/add_setup_salary.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_setup_salary.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_setup_salary&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_form_upd_setup_salary';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/upd_setup_salary.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/ehesap/query/upd_setup_salary.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_setup_salary&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'update_id=##attributes.update_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.update_id##';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ehesap.emptypopup_del_setup_salary';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_setup_salary.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_setup_salary.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_setup_salary';
	}
	
	if(attributes.event is 'upd')
	{
		/*tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.list_setup_salary&event=add";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);*/
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'ehesapListSetupSalary';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SALARY_UPDATE';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-our_company_id','item-sal_year','item-work_start_date','item-work_finish_date','item-percent']";
</cfscript>
