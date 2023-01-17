<cf_get_lang_set module_name = 'hr'>
<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'list')>
    <cfparam name="attributes.hierarchy" default="">
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfscript>
        attributes.startrow = ((attributes.page-1) * attributes.maxrows) + 1;
        url_str = "";
        if (isdefined("attributes.hierarchy") and len(attributes.hierarchy))
            url_str = "#url_str#&hierarchy=#attributes.hierarchy#";
        if (isdefined("attributes.department") and len(attributes.department))
            url_str = "#url_str#&department=#attributes.department#";
        if (isdefined('positions') and len(positions))
            url_str = '#url_str#&positions=#positions#';
        if (isdefined("attributes.branch_id") and len(attributes.branch_id))
            url_str='#url_str#&branch_id=#attributes.branch_id#';
        if (isdefined("attributes.keyword") and len(attributes.keyword))
            url_str='#url_str#&keyword=#attributes.keyword#';
        include "../hr/query/get_emp_codes.cfm";
        if (isdefined("attributes.keyword"))
        {
            cmp_standby = createObject("component","hr.cfc.get_standbys");
            cmp_standby.dsn = dsn;
            get_standbys = cmp_standby.get_standby(
                positions: '#iif(isdefined("attributes.positions") and len(attributes.positions),"attributes.positions",DE(""))#',
                branch_id: '#iif(isdefined("attributes.branch_id") and len(attributes.branch_id),"attributes.branch_id",DE(""))#',
                department: '#iif(isdefined("attributes.department") and len(attributes.department),"attributes.department",DE(""))#',
                keyword: '#iif(isdefined("attributes.keyword") and len(attributes.keyword),"attributes.keyword",DE(""))#',
                fusebox_dynamic_hierarchy: fusebox.dynamic_hierarchy,
                emp_code_list: emp_code_list,
                database_type: database_type,
                maxrows: attributes.maxrows,
                startrow: attributes.startrow
            );
        }
        else
        {
            filtrele = 1;
            get_standbys.query_count = 0;
        }
        
        if (fuseaction contains "popup")
            is_popup = 1;
        else
            is_popup = 0;
        
        cmp_company = createObject("component","hr.cfc.get_our_company");
        cmp_company.dsn = dsn;
        get_company = cmp_company.get_company();
        
        cmp_quiz = createObject("component","hr.cfc.get_quizes");
        cmp_quiz.dsn = dsn;
        get_quizs = cmp_quiz.get_quiz(
            relation_action: 3,
            is_active: 1,
            is_education: 0,
            is_trainer: 0,
            form_year: session.ep.period_year
        );
        
        cmp_dep_branch = createObject("component","hr.cfc.get_department_branch");
        cmp_dep_branch.dsn = dsn;
        all_branches = cmp_dep_branch.get_department_branch();
        
        if (isdefined('attributes.branch_id') and isnumeric(attributes.branch_id))
        {
            cmp_department = createObject("component","hr.cfc.get_departments");
            cmp_department.dsn = dsn;
            get_department = cmp_department.get_department(branch_id: attributes.branch_id);
        }
    </cfscript>
    <cfquery name="get_branches" dbtype="query">
        SELECT DISTINCT BRANCH_NAME, BRANCH_ID FROM all_branches
    </cfquery>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.totalrecords" default="#get_standbys.query_count#">
    <cfif get_standbys.query_count>
        <cfoutput query="get_standbys">
            <cfset position_cat_id_ = position_cat_id>
            <cfset position_id=get_standbys.position_id>
            <cfquery name="get_position_quiz" dbtype="query">
                SELECT 
                    QUIZ_HEAD,
                FORM_OPEN_TYPE,
                    POSITION_ID
                FROM 
                    get_quizs
                WHERE 
                    POSITION_ID IS NOT NULL AND
                    POSITION_ID LIKE '%,#position_id#,%' 
            </cfquery>
            <cfif not get_position_quiz.recordcount>
                <cfquery name="get_emp_quizs" dbtype="query">
                    SELECT QUIZ_HEAD,FORM_OPEN_TYPE,QUIZ_ID FROM get_quizs WHERE POSITION_CAT_ID IS NOT NULL AND POSITION_CAT_ID =#position_cat_id_# ORDER BY QUIZ_ID DESC
                </cfquery>
            </cfif>
        </cfoutput>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cfif isdefined("attributes.position_id")>
        <cfquery name="GET_POSITION" datasource="#dsn#">
            SELECT
                EMPLOYEE_POSITIONS.DEPARTMENT_ID,
                DEPARTMENT.DEPARTMENT_HEAD,
                EMPLOYEE_POSITIONS.POSITION_ID,
                EMPLOYEE_POSITIONS.POSITION_CODE,
                EMPLOYEE_POSITIONS.POSITION_NAME,
                EMPLOYEE_POSITIONS.EMPLOYEE_ID,
                EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
                EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
                EMPLOYEES.EMPLOYEE_EMAIL
            FROM
                EMPLOYEE_POSITIONS,
                EMPLOYEES,
                DEPARTMENT
            WHERE
                EMPLOYEE_POSITIONS.POSITION_ID = #attributes.POSITION_ID#
                AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
                AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID
                AND EMPLOYEE_POSITIONS.POSITION_STATUS = 1
        </cfquery>				
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cfinclude template="../hr/query/get_standby.cfm">
</cfif>
<script type="text/javascript">
	<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'list')>
		$(document).ready(function(){
			document.getElementById('keyword').focus();
		});
		function showDepartment(branch_id)	
		{
			var branch_id = document.getElementById('branch_id').value;
			if (branch_id != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
				AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'<cf_get_lang no="685.İlişkili Departmanlar">');
			}
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'add' or attributes.event is 'upd'>
		function control()
		{	
			if (add_standby.chief1_name.value == '')
			{
				alert("1.<cf_get_lang no='986.Amiri Seçmelisiniz'>");
				return false;
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_standby';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_standby.cfm';
	
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.list_standby';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/form_add_standby.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/add_standby.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_standby&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.list_standby';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/form/form_upd_standby.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/query/upd_standby.cfm'; 
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_standby&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'SB_ID =##attributes.SB_ID##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.SB_ID##';
	
	if(IsDefined("attributes.event") and attributes.event is "upd" or attributes.event is "del")
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.list_standby';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/query/del_standby.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/query/del_standby.cfm';
		WOStruct['#attributes.fuseaction#']['del']['parameters'] = 'SB_ID =##attributes.SB_ID##';
		WOStruct['#attributes.fuseaction#']['del']['Identity'] = '##attributes.SB_ID##';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_standby';
	}
	
	if(not IsDefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'list'))
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'] = structNew();

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['text'] = '#lang_array.item[1498]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['href'] = "#request.self#?fuseaction=hr.popup_chief_positions";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][1]['text'] = '#lang_array.item[1499]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][1]['href'] = "#request.self#?fuseaction=hr.popup_all_chief_positions";
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{	
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_standby&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'hrListStandby';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EMPLOYEE_POSITIONS_STANDBY';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-position_emp','item-chief1_emp','item-chief2_emp']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.

</cfscript>