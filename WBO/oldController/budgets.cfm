<cf_get_lang_set module_name="budget">
<cfif not IsDefined("attributes.event") or(IsDefined("attributes.event") and attributes.event eq 'list')>
	<cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.search_year" default="#year(now())#">
    <cfparam name="attributes.search_company" default="">
    <cfparam name="attributes.process_stage_type" default="">
    <cfquery name="get_our_company" datasource="#dsn#"><!--- yetkili olunan sirketler --->
        SELECT DISTINCT
            OC.COMP_ID,
            OC.COMPANY_NAME
        FROM 
            SETUP_PERIOD SP,
            OUR_COMPANY OC
        WHERE
            SP.OUR_COMPANY_ID = OC.COMP_ID AND
            SP.PERIOD_ID IN (SELECT 
                                EPP.PERIOD_ID
                            FROM
                                EMPLOYEE_POSITIONS EP,
                                EMPLOYEE_POSITION_PERIODS EPP
                            WHERE
                                EP.POSITION_ID = EPP.POSITION_ID AND
                                EP.POSITION_CODE =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
        ORDER BY
            OC.COMPANY_NAME
    </cfquery>
    <cfif isdefined("attributes.form_submitted")>
        <cfquery name="GET_ALL_BUDGETS" datasource="#dsn#">
            SELECT 
                B.BUDGET_ID,
                B.BUDGET_NAME,
                B.RECORD_DATE,
                PTR.STAGE,
                C.COMPANY_NAME
            FROM 
                BUDGET B, 
                PROCESS_TYPE_ROWS PTR,
                OUR_COMPANY C
            WHERE
                B.BUDGET_ID IS NOT NULL AND
                PTR.PROCESS_ROW_ID = B.BUDGET_STAGE
                AND C.COMP_ID=B.OUR_COMPANY_ID
            <cfif len(attributes.keyword)>
                AND B.BUDGET_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
            </cfif>	
            <cfif len(attributes.search_year)>
                AND B.PERIOD_YEAR =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.search_year#">
            </cfif>
            <cfif len(attributes.search_company)>
                AND B.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.search_company#">
            <cfelse>
                AND B.OUR_COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#valuelist(get_our_company.comp_id,',')#">)
            </cfif>
            <cfif len(attributes.process_stage_type)>
                AND B.BUDGET_STAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process_stage_type#"> 
            </cfif>
        </cfquery>
    <cfelse> 
        <cfset GET_ALL_BUDGETS.recordcount = 0>
    </cfif>
    
    <cfquery name="get_service_stage" datasource="#dsn#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PTR.PROCESS_ID = PT.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%budget.list_budget%"> 
    </cfquery>
    <cfparam name="attributes.totalrecords" default='#get_all_budgets.recordcount#'>
    <cfparam name="attributes.page" default='1'>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <script type="text/javascript">
		$( document ).ready(function() {
			document.getElementById('keyword').focus();
		});
	</script>
</cfif>
<cfif IsDefined("attributes.event") and attributes.event eq 'upd'>
	<cfquery name="GET_BUDGET_DETAIL" datasource="#dsn#">
		SELECT
			BT.*,
			PTR.STAGE
		FROM
			BUDGET BT,
			PROCESS_TYPE_ROWS PTR
		WHERE
			BT.BUDGET_ID = #attributes.budget_id# AND
			BT.BUDGET_STAGE = PTR.PROCESS_ROW_ID		
	</cfquery>
	<cfquery name="GET_BUDGET_PLAN" datasource="#dsn#">
		SELECT BUDGET_PLAN_ID FROM BUDGET_PLAN WHERE BUDGET_ID = #attributes.budget_id#
	</cfquery>
	<cfquery name="get_our_company" datasource="#dsn#">
		SELECT DISTINCT
			OC.COMP_ID,
			OC.COMPANY_NAME
		FROM 
			SETUP_PERIOD SP,
			OUR_COMPANY OC
		WHERE
			SP.OUR_COMPANY_ID = OC.COMP_ID AND
			SP.PERIOD_ID IN (SELECT 
								EPP.PERIOD_ID
							FROM
								EMPLOYEE_POSITIONS EP,
								EMPLOYEE_POSITION_PERIODS EPP
							WHERE
								EP.POSITION_ID = EPP.POSITION_ID AND
								EP.POSITION_CODE = #session.ep.position_code#)
		ORDER BY
			OC.COMPANY_NAME
	</cfquery>
	<cfif len(GET_BUDGET_DETAIL.BRANCH_ID)>
        <cfquery name="GET_BRANCHES" datasource="#dsn#">
            SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = #GET_BUDGET_DETAIL.BRANCH_ID#
        </cfquery>
    </cfif>
    <cfif len(GET_BUDGET_DETAIL.DEPARTMENT_ID)>
        <cfquery name="GET_DEPARTMENT" datasource="#dsn#">
            SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = #GET_BUDGET_DETAIL.DEPARTMENT_ID#
        </cfquery>
   </cfif>
   <cfquery name="GET_WORKGROUPS" datasource="#dsn#">
        SELECT WORKGROUP_ID,WORKGROUP_NAME FROM WORK_GROUP WHERE STATUS = 1 AND IS_BUDGET = 1 ORDER BY WORKGROUP_ID
    </cfquery>	
    <cfif len(GET_BUDGET_DETAIL.PROJECT_ID)>
        <cfquery name="GET_PROJECT" datasource="#dsn#" >
            SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID=#GET_BUDGET_DETAIL.PROJECT_ID#
        </cfquery>	
    </cfif>
    <script type="text/javascript">
		function kontrol()
		{
			if (document.upd_budget.search_company.value == "")
			{ 
				alert("<cf_get_lang no='40.Şirket Seçiniz'>");
				return false;
			}
			if (document.upd_budget.search_year.value == "")
			{ 
				alert("<cf_get_lang no='92.Dönem Girmelisiniz'>");
				return false;
			}
			return process_cat_control();
			return true;
		}
	</script>

</cfif>
<cfif IsDefined("attributes.event") and attributes.event eq 'add'>
    <cfquery name="get_our_company" datasource="#dsn#">
        SELECT DISTINCT
            OC.COMP_ID,
            OC.COMPANY_NAME
        FROM 
            SETUP_PERIOD SP,
            OUR_COMPANY OC
        WHERE
            SP.OUR_COMPANY_ID = OC.COMP_ID AND
            SP.PERIOD_ID IN (SELECT 
                                EPP.PERIOD_ID
                            FROM
                                EMPLOYEE_POSITIONS EP,
                                EMPLOYEE_POSITION_PERIODS EPP
                            WHERE
                                EP.POSITION_ID = EPP.POSITION_ID AND
                                EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
        ORDER BY
            OC.COMPANY_NAME
    </cfquery>
     <cfquery name="GET_WORKGROUPS" datasource="#dsn#">
        SELECT WORKGROUP_ID,WORKGROUP_NAME FROM WORK_GROUP WHERE STATUS = 1 AND IS_BUDGET = 1 ORDER BY WORKGROUP_ID
    </cfquery>
		<script type="text/javascript">
    function kontrol()
    {
        if (document.add_budget.search_company.value == "")
        { 
            alert("<cf_get_lang no='40.Şirket Seçiniz'>");
            return false;
        }
        if (document.add_budget.search_year.value == "")
        { 
            alert("<cf_get_lang no='92.Dönem Girmelisiniz'>");
            return false;
        }
        return process_cat_control();
		return true;
    }
    function pencere_ac_branch()
	{
		windowopen('index.cfm?fuseaction=objects.popup_list_branches&field_branch_id=add_budget.branch_id&field_branch_name=add_budget.branch_name','list');
	}
	 function pencere_ac_department()
	{
		windowopen('index.cfm?fuseaction=objects.popup_list_departments&field_id=add_budget.department_id' +'&field_name=add_budget.department' ,'list');
	}
	 function pencere_ac_project()
	{
		windowopen('index.cfm?fuseaction=objects.popup_list_projects&project_head=add_budget.project_head&project_id=add_budget.project_id','list');
	}
    </script>
</cfif>
<cfif IsDefined("attributes.event") and attributes.event eq 'det'>
	<cfquery name="GET_BUDGET_DETAIL" datasource="#dsn#">
        SELECT
            BT.*,
            PTR.STAGE
        FROM
            BUDGET BT,
            PROCESS_TYPE_ROWS PTR
        WHERE
            BT.BUDGET_ID = #attributes.budget_id# AND
            BT.BUDGET_STAGE = PTR.PROCESS_ROW_ID		
    </cfquery>
    <cfif len(GET_BUDGET_DETAIL.BRANCH_ID)>
        <cfquery name="BRANCHES" datasource="#DSN#">
            SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = #GET_BUDGET_DETAIL.BRANCH_ID#
        </cfquery>
    </cfif>
    <cfif len(GET_BUDGET_DETAIL.PROJECT_ID)>
        <cfquery name="GET_PROJECT" datasource="#DSN#">
            SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID=#GET_BUDGET_DETAIL.PROJECT_ID#
        </cfquery>
    </cfif>
    <cfif len(GET_BUDGET_DETAIL.DEPARTMENT_ID)>
        <cfquery name="DEPARTMENTS" datasource="#DSN#">
            SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = #GET_BUDGET_DETAIL.DEPARTMENT_ID#
        </cfquery>
        <cfif len(GET_BUDGET_DETAIL.WORKGROUP_ID)>
            <cfquery name="GET_WORKGROUP" datasource="#dsn#">
                SELECT WORKGROUP_NAME FROM WORK_GROUP WHERE WORKGROUP_ID = #GET_BUDGET_DETAIL.WORKGROUP_ID#
            </cfquery>
        </cfif>
    </cfif>
    <cfquery name="GET_BUDGET_PLAN" datasource="#dsn#">
        SELECT
            ISNULL(INCOME_TOTAL,0) INCOME_TOTAL,
            ISNULL(EXPENSE_TOTAL,0) EXPENSE_TOTAL,
            ISNULL(DIFF_TOTAL,0) DIFF_TOTAL,
            ISNULL(INCOME_TOTAL_2,0) INCOME_TOTAL_2,
            ISNULL(EXPENSE_TOTAL_2,0) EXPENSE_TOTAL_2,
            ISNULL(DIFF_TOTAL_2,0) DIFF_TOTAL_2,
            *,
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME
        FROM
            BUDGET_PLAN
            LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = BUDGET_PLAN.BUDGET_PLANNER_EMP_ID
        WHERE
            BUDGET_ID = #attributes.budget_id#
        ORDER BY
            BUDGET_PLAN_DATE
    </cfquery>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'budget.list_budgets';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'budget/display/list_budgets.cfm';
	
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'budget.list_budgets';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'budget/display/detail_budget.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'budget/display/detail_budget.cfm';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'budget/display/detail_budget.cfm';
	WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'budget_id=##attributes.budget_id##';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.budget_id##';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'budget.list_budgets';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'budget/form/add_budget.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'budget/query/add_budget.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'budget.list_budgets&event=det';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'budget.list_budgets';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'budget/form/upd_budget.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'budget/query/upd_budget.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'budget.list_budgets&event=det';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'budget_id=##attributes.budget_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.budget_id##';
	
	if(IsDefined("attributes.event") and attributes.event is 'det')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['text'] = '#lang_array_main.item[13]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=budget.detail_budget&action_name=budget_id&action_id=#attributes.budget_id#','page','add_process')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][1]['text'] = 'Butce Raporu';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=budget.detail_budget_report&general_budget_id=#attributes.budget_id#','page','add_process')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][2]['text'] = '#lang_array_main.item[52]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=budget.list_budgets&event=upd&budget_id=#attributes.budget_id#','page','add_process')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][3]['text'] = '#lang_array_main.item[788]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=budget.list_plan_rows&event=add&budget_id=#attributes.budget_id#','page','add_process')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][4]['text'] = '#lang_array_main.item[2150]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][4]['onClick'] = "windowopen('#request.self#?fuseaction=budget.list_budget_plan_row&budget_id=#attributes.budget_id#','page','add_process')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=budget.list_budgets&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.budget_id#&print_type=330','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	} 
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'budgets';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'BUDGET';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = '';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item1','item2','item3','item4']"; 
</cfscript>

