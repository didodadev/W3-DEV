<cf_get_lang_set module_name="budget">
<cfparam name="attributes.is_production" default="">
<cfparam name="attributes.is_general" default="">
<cfparam name="attributes.expense" default="">
<cfparam name="attributes.expense_branch_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.fullname" default="">
<cfparam name="attributes.workgroup_id" default="">
<cfparam name="attributes.workgroup_name" default="">
<cfparam name="attributes.RESPONSIBLE1" default="">
<cfparam name="attributes.RESPONSIBLE2" default="">
<cfparam name="attributes.RESPONSIBLE3" default="">
<cfparam name="attributes.detail" default="">
<cfparam name="attributes.expense_active" default="">
<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event eq 'list')>
	<cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.process_type" default="">
    <cfparam name="attributes.form_exist" default="0">
    <cfif attributes.form_exist>
        <cfquery name="GET_EXPENSE" datasource="#dsn2#">
            SELECT
                *,
                EP.EMPLOYEE_NAME,
                EP.EMPLOYEE_SURNAME,
                EP.POSITION_CODE
            FROM
                EXPENSE_CENTER
                LEFT JOIN #dsn_alias#.EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = EXPENSE_CENTER.RESPONSIBLE1
            WHERE	
                EXPENSE_ID IS NOT NULL
                <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                    AND
                    (
                        EXPENSE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                        DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                        EXPENSE_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                    )
                </cfif>
                <cfif len(attributes.process_type) and attributes.process_type eq 1>
                    AND EXPENSE_ACTIVE = 1
                <cfelseif len(attributes.process_type) and attributes.process_type eq 0>
                    AND EXPENSE_ACTIVE = 0
                </cfif>
            ORDER BY
                EXPENSE_CODE
        </cfquery>
    <cfelse>
        <cfset get_expense.recordcount=0>
    </cfif>
    <cfparam name="attributes.page" default='1'>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfparam name="attributes.totalrecords" default='#get_expense.recordcount#'>
    <script type="text/javascript">
		$( document ).ready(function() {
			document.getElementById('keyword').focus();
		});
	</script>
</cfif>
<cfif IsDefined("attributes.event")>
	<cfquery name="GET_EXPENSE" datasource="#dsn2#">
        SELECT
            *
        FROM
            EXPENSE_CENTER
        <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
            WHERE
                EXPENSE LIKE '%#attributes.keyword#%' OR
                DETAIL LIKE '%#attributes.keyword#%' OR
                EXPENSE_CODE LIKE '%#attributes.keyword#%'
        </cfif>
        <cfif isdefined("attributes.EXPENSE_ID")>
            WHERE 
                EXPENSE_ID <> #attributes.EXPENSE_ID#
        </cfif>
        ORDER BY
            EXPENSE_CODE
    </cfquery>
    <cfquery name="GET_BRANCH" datasource="#dsn#">
        SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
    </cfquery>
    <script type="text/javascript">
		function kontrol()
		{ 
			if(document.getElementById('exp_code').value == '')
			{
				alert("<cf_get_lang no='45.Masraf/Gelir Merkezi Kodu Girmelisiniz'>!");
				return false;
			}
			return true;
		}
		function LoadDepartmen(branch_id_)
		{
			var get_position_department_name = wrk_safe_query('bdg_get_position_department_name','dsn',0,branch_id_);
			document.add_expense.department.options.length = 0;
			document.add_expense.department.options[0]=new Option('<cf_get_lang_main no="1424.Lutfen Departman Seçiniz">','0')
			if(get_position_department_name.recordcount != 0)
				for(var xx=0;xx<get_position_department_name.recordcount;xx++)
					document.add_expense.department.options[xx+1]=new Option(get_position_department_name.DEPARTMENT_HEAD[xx],get_position_department_name.DEPARTMENT_ID[xx]);
		}
	</script>
    <cfif attributes.event eq 'upd'>
    	<cfquery name="EXPENSE" datasource="#dsn2#">
            SELECT
                *
            FROM
                EXPENSE_CENTER
            WHERE
                EXPENSE_ID = #attributes.EXPENSE_ID#
        </cfquery>
        <cfparam name="attributes.department" default="">
        <cfquery name="GET_HIER" datasource="#dsn2#">
            SELECT 
                EXPENSE_ID
            FROM 
                EXPENSE_CENTER 
            WHERE 
                EXPENSE_CODE LIKE '#expense.EXPENSE_CODE#.%'
        </cfquery>
        <cfquery name="GET_DEPARTMENT" datasource="#DSN#">
            SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1
            <cfif len(expense.expense_branch_id)>AND BRANCH_ID = #expense.expense_branch_id#</cfif>
        </cfquery>
        <cfif len(expense.company_id)>
            <cfquery name="GET_COMPANY_NAME" datasource="#dsn#">
                SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = #expense.company_id#
            </cfquery>
        </cfif>
        <cfif len(expense.workgroup_id)>
            <cfquery name="GET_WORKGROUP" datasource="#dsn#">
                SELECT WORKGROUP_NAME FROM WORK_GROUP WHERE WORKGROUP_ID = #expense.workgroup_id#
            </cfquery>
        </cfif>
         <cfquery name="GET_EXPENSE_ITEM_ROWS" datasource="#dsn2#">
            SELECT EXPENSE_CENTER_ID FROM EXPENSE_ITEMS_ROWS WHERE EXPENSE_CENTER_ID = #attributes.EXPENSE_ID#
        </cfquery>
    </cfif>
</cfif>
<cfif isdefined('attributes.event') and attributes.event eq 'upd'>
	<cfset attributes.is_production = expense.is_production>
    <cfset attributes.is_general = expense.is_general>
    <cfset attributes.expense =expense.expense>
    <cfset attributes.expense_branch_id =expense.expense_branch_id>
    <cfif len(expense.company_id)>
	    <cfset attributes.company_id =expense.company_id>
	    <cfset attributes.fullname =get_company_name.fullname>
    </cfif>
    <cfif len(expense.workgroup_id)>
	    <cfset attributes.workgroup_id =expense.workgroup_id>
	    <cfset attributes.workgroup_name =get_workgroup.workgroup_name>
    </cfif>
    <cfset attributes.RESPONSIBLE1 =expense.RESPONSIBLE1>
    <cfset attributes.RESPONSIBLE2 =expense.RESPONSIBLE2>
    <cfset attributes.RESPONSIBLE3 =expense.RESPONSIBLE3>
    <cfset attributes.detail = expense.detail>
    <cfset attributes.expense_active = expense.expense_active>
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'budget.list_expense_center';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'budget/display/list_expense_center.cfm';
		
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'budget.list_expense_center';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'budget/form/add_expense_center.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'budget/query/add_expense_center.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'budget.list_expense_center';
	
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'budget.list_expense_center';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'budget/form/add_expense_center.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'budget/query/upd_expense_center.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'budget.list_expense_center';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'obj=1';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'expense_id=##attributes.expense_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.expense_id##';
	
	if(IsDefined("attributes.event") and  (attributes.event is 'upd' or attributes.event is 'del') )
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'budget.emptypopup_del_expense_center&expense_id=#attributes.expense_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'budget/query/del_expense_center.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'budget/query/del_expense_center.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'budget.list_expense_center';
	}
	if(IsDefined("attributes.event") && attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=budget.list_expense_center&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	} 
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'expenseCenter';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EXPENSE_CENTER';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item1','item2']"; 
</cfscript>
