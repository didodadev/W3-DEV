<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfquery name="get_parameters" datasource="#dsn#">
	    SELECT 
	        PARAMETER_ID, 
	        STARTDATE, 
	        FINISHDATE, 
	        PARAMETER_NAME 
	    FROM 
		    SETUP_PROGRAM_PARAMETERS 
	    ORDER BY 
	    	STARTDATE DESC
	</cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cf_xml_page_edit fuseact="ehesap.form_upd_program_parameters">
	<cfquery name="get_program_parameters" datasource="#dsn#">
		SELECT
			ACC_TYPE_ID,
			ACCOUNT_CODE,
			ACCOUNT_NAME,
			BRANCH_IDS,
			CAST_STYLE,
			COMPANY_ID,
			CONSUMER_ID,
			DENUNCIATION_1,
			DENUNCIATION_1_HIGH,
			DENUNCIATION_1_LOW,
			DENUNCIATION_2,
			DENUNCIATION_2_HIGH,
			DENUNCIATION_2_LOW,
			DENUNCIATION_3,
			DENUNCIATION_3_HIGH,
			DENUNCIATION_3_LOW,
			DENUNCIATION_4,
			DENUNCIATION_4_HIGH,
			DENUNCIATION_4_LOW,
			DENUNCIATION_5,
			DENUNCIATION_5_HIGH,
			DENUNCIATION_5_LOW,
			DENUNCIATION_6,
			DENUNCIATION_6_HIGH,
			DENUNCIATION_6_LOW,
			EMPLOYMENT_CONTINUE_TIME,
			EMPLOYMENT_START_DATE,
			ESKI_HUKUMLU_PERCENT,
			EX_TIME_LIMIT,
			EX_TIME_PERCENT,
			EX_TIME_PERCENT_HIGH,
			EXECUTION_ACC_TYPE_ID,
			EXECUTION_ACCOUNT_CODE,
			EXECUTION_ACCOUNT_NAME,
			EXECUTION_COMPANY_ID,
			EXECUTION_CONSUMER_ID,
			EXTRA_TIME_STYLE,
			FINISH_DATE_COUNT_TYPE,
			FINISHDATE,
			FULL_DAY,
			GROSS_COUNT_TYPE,
			GROUP_IDS,
			IS_ADD_4691_CONTROL,
			IS_ADD_5746_CONTROL,
			IS_ADD_VIRTUAL_ALL,
			IS_AGI_PAY,
			IS_AVANS_OFF,
			IS_NOT_SGK_WORK_DAYS_30,
			IS_SGK_CONTROL_EXT_SALARY,
			IS_SGK_KONTROL,
			IS_SURELI_IS_AKDI_OFF,
			LIMIT_PAYMENT_REQUEST,
			NIGHT_MULTIPLIER,
			OFFICIAL_MULTIPLIER,
			OFFTIME_COUNT_TYPE,
			OVERTIME_HOURS,
			OVERTIME_YEARLY_HOURS,
			PARAMETER_NAME,
			RECORD_DATE,
			RECORD_EMP,
			SAKAT_ALT,
			SAKAT_PERCENT,
			SSK_31_DAYS,
			SSK_DAYS_WORK_DAYS,
			STAMP_TAX_BINDE,
			STARTDATE,
			TAX_ACCOUNT_STYLE,
			TEROR_MAGDURU_PERCENT,
			UNPAID_PERMISSION_TODROP_THIRTY,
			UPDATE_DATE,
			UPDATE_EMP,
			WEEKEND_MULTIPLIER,
			YEARLY_PAYMENT_REQ_COUNT,
			YEARLY_PAYMENT_REQ_LIMIT
		FROM 
			SETUP_PROGRAM_PARAMETERS 
		WHERE 
			PARAMETER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.parameter_id#">
	</cfquery>
	<cfquery name="get_company" datasource="#dsn#">
		SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY WHERE COMP_STATUS = 1 ORDER BY NICK_NAME
	</cfquery>
	<cfset cmp = createObject("component","hr.ehesap.cfc.employee_puantaj_group")>
	<cfset cmp.dsn = dsn/>
	<cfset get_groups = cmp.get_groups()/>
<cfelseif isdefined("attributes.event") and attributes.event is 'copy'>
	<cfset attributes.base_parameter_id="">
	<cfset attributes.parameter_name="">
	<cfset attributes.startdate="">
	<cfset attributes.finishdate="">
	<cfif isdefined("attributes.parameter_id")>
		<cfquery name="get_program_parameters" datasource="#dsn#">
			SELECT 
	            SSK_DAYS_WORK_DAYS, 
	            FULL_DAY, 
	            SSK_31_DAYS,
	            STAMP_TAX_BINDE, 
	            DENUNCIATION_1_LOW,
	            DENUNCIATION_1_HIGH, 
	            DENUNCIATION_2_LOW,
	            DENUNCIATION_2_HIGH,
	            DENUNCIATION_3_LOW,
	            DENUNCIATION_3_HIGH,
	            DENUNCIATION_4_LOW,
	            DENUNCIATION_4_HIGH,
	            DENUNCIATION_1,
	            DENUNCIATION_2,
	            DENUNCIATION_3, 
	            DENUNCIATION_4,
	            OVERTIME_YEARLY_HOURS,
	            OVERTIME_HOURS, 
	            EX_TIME_PERCENT,
	            EX_TIME_LIMIT,
	            EX_TIME_PERCENT_HIGH,
	            USE_WORKTIMES,
	            SAKAT_ALT, 
	            SAKAT_PERCENT,
	            ESKI_HUKUMLU_PERCENT, 
	            TEROR_MAGDURU_PERCENT, 
	            PARAMETER_ID,
	            YEARLY_PAYMENT_REQ_LIMIT,
	            YEARLY_PAYMENT_REQ_COUNT,
	            STARTDATE,
	            FINISHDATE,
	            CAST_STYLE, 
	            WEEKEND_MULTIPLIER,
	            OFFICIAL_MULTIPLIER, 
	            EXTRA_TIME_STYLE, 
	            IS_AVANS_OFF,
	            UNPAID_PERMISSION_TODROP_THIRTY,
	            EMPLOYMENT_CONTINUE_TIME,
	            EMPLOYMENT_START_DATE, 
	             UPDATE_DATE,
	            UPDATE_IP,
	            UPDATE_EMP,
	            RECORD_DATE,
	            RECORD_IP,
	            RECORD_EMP,
	            IS_AGI_PAY,
	            PARAMETER_NAME,
	            GROSS_COUNT_TYPE,
	            IS_SURELI_IS_AKDI_OFF,
	            FINISH_DATE_COUNT_TYPE,
	            IS_ADD_VIRTUAL_ALL, 
	            COMPANY_ID,
	            ACCOUNT_CODE, 
	            ACCOUNT_NAME,
	            CONSUMER_ID,
	            ACC_TYPE_ID, 
	            LIMIT_PAYMENT_REQUEST,
	            NIGHT_MULTIPLIER, 
	            TAX_ACCOUNT_STYLE,
	            OFFTIME_COUNT_TYPE,
	            DENUNCIATION_5_LOW,
	            DENUNCIATION_5_HIGH,
	            DENUNCIATION_6_LOW,
	            DENUNCIATION_6_HIGH, 
	            DENUNCIATION_5, 
	            DENUNCIATION_6 
	        FROM 
		        SETUP_PROGRAM_PARAMETERS 
	        WHERE 
	        	PARAMETER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.parameter_id#">
		</cfquery>
		<cfset attributes.parameter_name="#get_program_parameters.parameter_name#">
		<cfset attributes.startdate="#dateformat(get_program_parameters.startdate,'dd/mm/yyyy')#">
		<cfset attributes.finishdate="#dateformat(get_program_parameters.finishdate,'dd/mm/yyyy')#">
	<cfelse>
		<cfset attributes.parameter_id="">
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif isdefined("attributes.event") and attributes.event is 'add'>
		<cfif not get_module_power_user(48)>
			$(document).ready(function() {
				alert("Yetki yok");
				history.go(-1);
			});
		</cfif>
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
		function control()
		{
			if($('#branch_id').val() == "")
			{
				alert("Şube Seçmelisiniz!");
				return false;
			}
			$('#weekend_multiplier').val(filterNum($('#weekend_multiplier').val()));
			$('#night_multiplier').val(filterNum($('#night_multiplier').val()));
			$('#official_multiplier').val(filterNum($('#official_multiplier').val()));
			$('#stamp_tax_binde').val(filterNum($('#stamp_tax_binde').val()));
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_program_parameters';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_program_parameters.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.form_add_program_parameters';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/add_program_parameters.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_program_parameters.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_program_parameters&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.form_upd_program_parameters';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/upd_program_parameters.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/ehesap/query/upd_program_parameters.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_program_parameters&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'parameter_id=##attributes.parameter_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_program_parameters.parameter_name##';
	
	WOStruct['#attributes.fuseaction#']['copy'] = structNew();
	WOStruct['#attributes.fuseaction#']['copy']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['copy']['fuseaction'] = 'ehesap.form_copy_program_parameters';
	WOStruct['#attributes.fuseaction#']['copy']['filePath'] = 'hr/ehesap/form/copy_program_parameters.cfm';
	WOStruct['#attributes.fuseaction#']['copy']['queryPath'] = 'hr/ehesap/query/copy_program_parameters.cfm';
	WOStruct['#attributes.fuseaction#']['copy']['nextEvent'] = 'ehesap.list_program_parameters&event=upd';
	WOStruct['#attributes.fuseaction#']['copy']['parameters'] = 'parameter_id=##attributes.parameter_id##';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ehesap.emptypopup_del_program_parameters';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_program_parameters.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_program_parameters.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_program_parameters';
	}
	
	if (isdefined("attributes.event") and listfind('add,upd,copy',attributes.event))
	{
		WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
		WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'ehesapListProgramParameters.cfm';
		WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SETUP_PROGRAM_PARAMETERS';
		WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
		if (attributes.event is 'add')
		{
			WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add';
			WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-parameter_name']";
		}
		else if(attributes.event is 'upd')
		{
			include "../hr/ehesap/query/get_ssk_offices.cfm";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=ehesap.list_program_parameters&event=copy&parameter_id=#attributes.parameter_id#";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.list_program_parameters&event=add";
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
			
			WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'upd';
			WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-branch_id','item-parameter_name','item-startdate','item-stamp_tax_binde','item-denunciation_1','item-denunciation_2','item-denunciation_3','item-denunciation_4','item-denunciation_5','item-extra_time_style','item-ex_time_percent','item-overtime_yearly_hours','item-overtime_hours','item-yearly_payment_count','item-yearly_payment_limit','item-sakat_alt','item-sakat_percent','item-eski_hukumlu_percent','item-teror_magduru_percent']";
		}
		else if(attributes.event is 'copy')
		{
			WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'copy';
			WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-parameter_name','item-startdate']";
		}
	}
</cfscript>
