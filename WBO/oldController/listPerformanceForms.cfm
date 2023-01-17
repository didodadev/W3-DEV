<cf_get_lang_set module_name="hr">
<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'list')>
    <cfparam name="attributes.is_form_submit" default="0">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.branch_id" default="">
    <cfparam name="attributes.department" default="">
    <cfparam name="attributes.process_stage" default="">
    <cfparam name="attributes.period" default="">
    <cfset url_str = "">
    <cfif attributes.is_form_submit>
        <cfset url_str = '#url_str#&is_form_submit=#attributes.is_form_submit#'>
        <cfif len(attributes.keyword)>
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif>
        <cfif len(attributes.branch_id)>
            <cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
        </cfif>
        <cfif len(attributes.department)>
            <cfset url_str = "#url_str#&department_id=#attributes.department#">
        </cfif>
        <cfif len(attributes.period)>
            <cfset url_str = "#url_str#&period=#attributes.period#">
        </cfif>
        <cfif len(attributes.process_stage)>
            <cfset url_str = "#url_str#&process_stage=#attributes.process_stage#">
        </cfif>
    </cfif>
    <cfif attributes.is_form_submit>
        <cfquery name="get_survey_participants" datasource="#dsn#">
            SELECT 
                SURVEY_MAIN.SURVEY_MAIN_ID,
                SURVEY_MAIN.SURVEY_MAIN_HEAD,
                SURVEY_MAIN.SURVEY_MAIN_DETAILS,
                SURVEY_MAIN_RESULT.SURVEY_MAIN_RESULT_ID,
                SURVEY_MAIN_RESULT.IS_CLOSED,
                SURVEY_MAIN_RESULT.START_DATE,
                SURVEY_MAIN_RESULT.FINISH_DATE,
                E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS CALISAN
            FROM 
                SURVEY_MAIN INNER JOIN SURVEY_MAIN_RESULT
                ON SURVEY_MAIN.SURVEY_MAIN_ID = SURVEY_MAIN_RESULT.SURVEY_MAIN_ID
                INNER JOIN EMPLOYEES E
                ON SURVEY_MAIN_RESULT.ACTION_ID = E.EMPLOYEE_ID
            WHERE 
                TYPE = 8<!--- performans tipi--->
                <cfif len(attributes.keyword)>
                    AND 
                    (SURVEY_MAIN.SURVEY_MAIN_HEAD LIKE '%#attributes.keyword#%' OR
                    E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%' OR E.EMPLOYEE_NO = '#attributes.keyword#')
                </cfif>
                <cfif len(attributes.branch_id)>
                    AND E.EMPLOYEE_ID IN(SELECT EP.EMPLOYEE_ID FROM EMPLOYEE_POSITIONS EP,DEPARTMENT D,BRANCH B WHERE EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND D.BRANCH_ID = B.BRANCH_ID AND B.BRANCH_ID = #attributes.branch_id#)
                </cfif>
                <cfif len(attributes.department)>
                    AND E.EMPLOYEE_ID IN(SELECT EP.EMPLOYEE_ID FROM EMPLOYEE_POSITIONS EP,DEPARTMENT D WHERE EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND D.DEPARTMENT_ID = #attributes.department#)
                </cfif>
                <cfif len(attributes.process_stage)>
                    AND SURVEY_MAIN_RESULT.PROCESS_ROW_ID = #attributes.process_stage#
                </cfif>
                <cfif len(attributes.period)>
                    AND YEAR(SURVEY_MAIN_RESULT.START_DATE) = #attributes.period#
                </cfif>
            ORDER BY 
                SURVEY_MAIN_RESULT_ID DESC
        </cfquery>
    <cfelse>
        <cfset get_survey_participants.recordcount = 0>
    </cfif>
    <cfquery name="get_branch" datasource="#dsn#">
        SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE BRANCH_STATUS = 1 ORDER BY BRANCH_NAME
    </cfquery>
    <cfquery name="get_process_stage" datasource="#dsn#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE AS PT INNER JOIN 
            PROCESS_TYPE_ROWS AS PTR ON PT.PROCESS_ID = PTR.PROCESS_ID
            INNER JOIN PROCESS_TYPE_OUR_COMPANY AS PTO ON PTO.PROCESS_ID = PT.PROCESS_ID
        WHERE
            PT.IS_ACTIVE = 1 AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.PROCESS_ID IN(SELECT DISTINCT PROCESS_ID FROM SURVEY_MAIN WHERE TYPE = 8 AND PROCESS_ID IS NOT NULL)
    </cfquery>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfparam name="attributes.totalrecords" default="#get_survey_participants.recordcount#">
    <cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
        <cfquery name="get_department" datasource="#dsn#">
            SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE BRANCH_ID = #attributes.branch_id# AND DEPARTMENT_STATUS =1 AND IS_STORE <> 1 ORDER BY DEPARTMENT_HEAD
        </cfquery>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
    <cfinclude template="../hr/query/get_quiz_info.cfm">
    <cfinclude template="../hr/query/get_emp_chiefs.cfm">
    <cfinclude template="../hr/query/get_employee.cfm">
    <cfquery name="GET_STANDBYS" datasource="#DSN#">
        SELECT
            EMPLOYEE_POSITIONS.POSITION_CODE,
            EMPLOYEE_POSITIONS.EMPLOYEE_ID,		
            EMPLOYEE_POSITIONS_STANDBY.CHIEF1_CODE,
            EMPLOYEE_POSITIONS_STANDBY.CHIEF2_CODE,
            EMPLOYEE_POSITIONS_STANDBY.CHIEF3_CODE
        FROM
            EMPLOYEE_POSITIONS_STANDBY,
            EMPLOYEE_POSITIONS,
            EMPLOYEES
        WHERE
            EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID AND
            EMPLOYEE_POSITIONS.POSITION_CODE = EMPLOYEE_POSITIONS_STANDBY.POSITION_CODE AND
            EMPLOYEE_POSITIONS_STANDBY.POSITION_CODE=#GET_EMP_CODES.POSITION_CODE#
    </cfquery>
   	<!---<cfinclude template="../hr/display/performance_quiz.cfm">
    <cfinclude template="../hr/query/act_quiz_perf_point.cfm">--->
    <cfquery name="get_training_cat" datasource="#dsn#">
        SELECT TRAINING_CAT_ID,TRAINING_CAT FROM TRAINING_CAT
    </cfquery>
</cfif>
<script language="javascript">
	<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'list')>
		$(document).ready(function(){
			document.getElementById('keyword').focus();
		});
		function showDepartment(branch_id)	
		{
			var branch_id = document.search.branch_id.value;
			if (branch_id != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
				AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'<cf_get_lang no="685.İlişkili Departmanlar">');
			}
			else
			document.search.department.value ="";
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'listOther'>
		function kontrol()
		{
			if(document.add_perf_emp_info.is_form_generators.value == 1)
			{
				add_perf_emp_info.action='<cfoutput>#request.self#?fuseaction=hr.emptypopup_add_survey_main_result&survey_main_id='+document.add_perf_emp_info.quiz_id.value+'&emp_id='+document.add_perf_emp_info.employee_id.value+'</cfoutput>';
			}
			if(document.add_perf_emp_info.quiz_id.value.length==0)
			{
				alert("<cf_get_lang no='211.Ölçme Değerlendirme Formu seçiniz'>");
				return false;
			}
			if(document.add_perf_emp_info.employee_id.value.length==0)
			{
				alert("<cf_get_lang_main no='1701.Çalışan seçiniz'>");
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_performance_forms';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_performance_forms.cfm';
	
	WOStruct['#attributes.fuseaction#']['listOther'] = structNew();
	WOStruct['#attributes.fuseaction#']['listOther']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['listOther']['fuseaction'] = 'hr.form_add_perf_emp_info';
	WOStruct['#attributes.fuseaction#']['listOther']['filePath'] = 'hr/form/add_perf_emp_info.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.form_add_perf_emp';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/add_perf_emp.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/add_perf_emp.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_total_performances';

</cfscript>
