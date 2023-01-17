<cfparam name="attributes.budget_action_type" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.expense_center_name" default="">
<cfparam name="attributes.expense_item_id" default="">
<cfparam name="attributes.expense_item_name" default="">
<cfparam name="attributes.account_code" default="">
<cfparam name="attributes.income_exp" default="">
<cfparam name="attributes.search_date1" default="">
<cfparam name="attributes.search_date2" default="">
<cfif len(attributes.search_date1)>
	<cf_date tarih='attributes.search_date1'>
</cfif>
<cfif len(attributes.search_date2)>
	<cf_date tarih='attributes.search_date2'>
</cfif>
<cfquery name="get_process_cat" datasource="#dsn3#">
	SELECT PROCESS_CAT,PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (160,161)
</cfquery>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 ORDER BY MONEY_ID
</cfquery>
<cfif isdefined("attributes.form_addsubmitted")>
	<cfquery name="get_budget_plan" datasource="#dsn#">
		SELECT 
			BP.PAPER_NO,
			BP.PROCESS_CAT,
			BP.BUDGET_PLAN_ID,
			BP.OTHER_MONEY,
			BPR.PLAN_DATE DATE,
			BPR.DETAIL,
			BPR.EXP_INC_CENTER_ID,
			BPR.BUDGET_ITEM_ID,
			BPR.BUDGET_ACCOUNT_CODE,
			BPR.ROW_TOTAL_INCOME INCOME,
			BPR.ROW_TOTAL_EXPENSE EXPENSE,
			BPR.OTHER_ROW_TOTAL_INCOME OTHER_INCOME,
			BPR.OTHER_ROW_TOTAL_EXPENSE OTHER_EXPENSE,
			BPR.PROJECT_ID,
            SPC.PROCESS_CAT,
            SPC.PROCESS_CAT_ID,
            EC.EXPENSE, 
            EC.EXPENSE_ID,
            EI.EXPENSE_ITEM_NAME, 
            EI.EXPENSE_ITEM_ID,
            EI.ACCOUNT_CODE
		FROM
			BUDGET_PLAN BP
			LEFT JOIN BUDGET_PLAN_ROW BPR ON BP.BUDGET_PLAN_ID = BPR.BUDGET_PLAN_ID
            LEFT JOIN #dsn3_alias#.SETUP_PROCESS_CAT SPC ON SPC.PROCESS_CAT_ID = BP.PROCESS_CAT
            LEFT JOIN #dsn2_alias#.EXPENSE_CENTER EC ON EC.EXPENSE_ID= BPR.EXP_INC_CENTER_ID
            LEFT JOIN #dsn2_alias#.EXPENSE_ITEMS EI ON EI.EXPENSE_ITEM_ID = BPR.BUDGET_ITEM_ID
		WHERE
			BP.PROCESS_CAT IN (SELECT PROCESS_CAT_ID FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN(160,161)) AND
        	BP.PERIOD_ID = #session.ep.period_id# AND
			BP.OUR_COMPANY_ID = #session.ep.company_id#    
			<cfif len(attributes.budget_action_type)>
				AND BP.PROCESS_CAT = #attributes.budget_action_type#
			</cfif>
			<cfif len(attributes.expense_center_id) and len(attributes.expense_center_name)>
				AND BPR.EXP_INC_CENTER_ID = #attributes.expense_center_id#
			</cfif>
			<cfif len(attributes.expense_item_id) and len(attributes.expense_item_name)>
				AND BPR.BUDGET_ITEM_ID = #attributes.expense_item_id#
			</cfif>
			<cfif len(attributes.account_code)>
				AND BPR.BUDGET_ACCOUNT_CODE = '#attributes.account_code#'
			</cfif>
			<cfif len(attributes.money_type)>
				AND BP.OTHER_MONEY = '#attributes.money_type#'
			</cfif>
			<cfif len(attributes.search_date1)>
				AND BPR.PLAN_DATE >= #attributes.search_date1#
			</cfif>
			<cfif len(attributes.search_date2)>
				AND BPR.PLAN_DATE <= #attributes.search_date2#
			</cfif>
			<cfif len(attributes.income_exp) and attributes.income_exp eq 1>
				AND BPR.ROW_TOTAL_INCOME <> 0
			<cfelseif len(attributes.income_exp) and attributes.income_exp eq 2>
				AND BPR.ROW_TOTAL_EXPENSE <> 0
			</cfif>
		ORDER BY 
			BP.PAPER_NO
	</cfquery>
<cfelse>
	<cfset get_budget_plan.recordcount = 0>
</cfif>
<script type="text/javascript">
	<cfif isdefined("attributes.form_addsubmitted") and get_budget_plan.recordcount>
		document.getElementById('all_check').checked = true;
		check_all();
	</cfif>
	function check_all()
	{
		<cfif isdefined("get_budget_plan") and get_budget_plan.recordcount>
			if(document.getElementById('all_check').checked)
			{
				for (var i=1; i <= <cfoutput>#get_budget_plan.recordcount#</cfoutput>; i++)
				{
					if(document.getElementById('record_error'+i) == undefined)
					{
						var form_addfield = document.getElementById('row_check' + i);
						form_addfield.checked = true;
					}
				}
			}
			else
			{
				for (var i=1; i <= <cfoutput>#get_budget_plan.recordcount#</cfoutput>; i++)
				{
					form_addfield = document.getElementById('row_check' + i);
					form_addfield.checked = false;
				}				
			}
		</cfif>
	}
	function apply_row(no)
	{
		toplam = document.getElementById('record_num').value;
		for(var zz=1; zz<=toplam; zz++)
		{
			if(document.getElementById('row_check'+zz) != undefined && document.getElementById('row_check'+zz).checked == true)
			{
				if(no==2)
				{
					if(document.getElementById('main_acc_code').value != '')
						document.getElementById('tahakkuk_acc_code'+zz).value = document.getElementById('main_acc_code').value;
				}
				else if (no==1)
				{
					if(document.getElementById('acc_code').value != '')
						document.getElementById('account_code'+zz).value = document.getElementById('acc_code').value;
				}
			}
		}
	}
	function save_tahakkuk()
	{
		var total_record = 0;
		<cfif isdefined("get_budget_plan")>
			for (var i=1; i <= <cfoutput>#get_budget_plan.recordcount#</cfoutput>; i++)
			{		
				if(document.getElementById('row_check' +i).checked)	
					total_record += 1;
			}
			document.getElementById('total_record').value = total_record;
		</cfif>
		
		if(confirm("<cf_get_lang_main no='2585.Seçilen Kayıtlar Kaydedilecek ! Emin misiniz?'>"))
		{	
			document.getElementById('form_add').action='<cfoutput>#request.self#</cfoutput>?fuseaction=budget.list_plan_rows&event=add&from_plan_list&is_rapor=1';
			document.getElementById('form_add').target='blank';
			document.getElementById('form_add').submit();
		}
		else 
			return false;
	}
	function page_control()
	{
		document.getElementById('form_add').target = "";
		document.getElementById('form_add').action = "<cfoutput>#request.self#?fuseaction=budget.list_accrual_operations</cfoutput>";
	}
	function pencere_ac_muhasebe()
	{
		windowopen('index.cfm?fuseaction=objects.popup_account_plan&field_id=form_add.account_code','list');
	}
	function auto_complate_muhasebe()
	{
		AutoComplete_Create('account_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225');
	}
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'budget.list_accrual_operations';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'budget/display/list_accrual_operations.cfm';
	WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'budget/display/list_accrual_operations.cfm';
	WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = 'budget.list_accrual_operations';
</cfscript>

