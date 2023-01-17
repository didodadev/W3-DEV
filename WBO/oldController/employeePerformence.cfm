<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfif isdefined("attributes.form_submitted")>
        <cfquery name="GET_PERF_DEF" datasource="#dsn#">
            SELECT 
                ID,
                EMPLOYEE_PERFORM_WEIGHT,
                COMP_TARGET_WEIGHT,
                YEAR,
                COMP_PERFORM_RESULT,
                TITLE_ID,
                FUNC_ID
            FROM
                EMPLOYEE_PERFORMANCE_DEFINITION
             WHERE
                1=1
                <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
                    AND (EMPLOYEE_PERFORM_WEIGHT = #attributes.keyword# OR COMP_TARGET_WEIGHT = #attributes.keyword#)
                </cfif>
                <cfif isdefined("attributes.is_active") and len(attributes.is_active)>
                    AND IS_ACTIVE = #attributes.is_active#
                </cfif>
        </cfquery>
    <cfelse>
        <cfset GET_PERF_DEF.recordcount=0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default=#GET_PERF_DEF.recordcount#>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfset url_str = "">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.is_active" default="1">
    <cfif len(attributes.keyword)>
        <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
    </cfif>
    <cfif len(attributes.is_active)>
        <cfset url_str = "#url_str#&is_active=#attributes.is_active#">
    </cfif>
    <cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
        <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cfquery name="get_titles" datasource="#dsn#">
        SELECT TITLE, TITLE_ID FROM SETUP_TITLE WHERE IS_ACTIVE = 1 ORDER BY TITLE
    </cfquery>
    <cfquery name="get_units" datasource="#dsn#">
        SELECT UNIT_NAME, UNIT_ID FROM SETUP_CV_UNIT ORDER BY UNIT_NAME
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
    <cfquery name="GET_PERF_DEF" datasource="#dsn#">
        SELECT 
            EMPLOYEE_PERFORM_WEIGHT,
            EMPLOYEE_WEIGHT,
            CONSULTANT_WEIGHT,
            COMP_TARGET_WEIGHT,
            UPPER_POSITION_WEIGHT,
            MUTUAL_ASSESSMENT_WEIGHT,
            UPPER_POSITION2_WEIGHT,
            YEAR,
            TITLE_ID,
            FUNC_ID,
            COMP_PERFORM_RESULT,
            IS_ACTIVE,
            IS_STAGE,
            IS_EMPLOYEE,
            IS_CONSULTANT,
            IS_UPPER_POSITION,
            IS_MUTUAL_ASSESSMENT,
            IS_UPPER_POSITION2,
            ID
        FROM
            EMPLOYEE_PERFORMANCE_DEFINITION
        WHERE
            ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.weight_id#">
    </cfquery>
    <cfquery name="get_titles" datasource="#dsn#">
        SELECT TITLE, TITLE_ID FROM SETUP_TITLE WHERE IS_ACTIVE = 1 ORDER BY TITLE
    </cfquery>
    <cfquery name="get_units" datasource="#dsn#">
        SELECT UNIT_NAME, UNIT_ID FROM SETUP_CV_UNIT ORDER BY UNIT_NAME
    </cfquery>
</cfif>
<script language="javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function(){
			document.getElementById('keyword').focus();
		});
	<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
		
		<cfif isdefined("attributes.event") and attributes.event is 'upd'>
			$(document).ready(function(){
				degerlendirici_gizle_goster();
			});
		</cfif>
		
		function kontrol()
		{
			if(document.add_emp_perf.emp_perf_weight.value.length==0 || document.add_emp_perf.comp_targ_weight.value.length==0 || document.add_emp_perf.emp_perf_year.value.length==0 ||
				(document.add_emp_perf.is_employee.checked && document.add_emp_perf.employee_weight.value.length==0) || (document.add_emp_perf.is_consultant.checked && document.add_emp_perf.consultant_weight.value.length==0) ||
				(document.add_emp_perf.is_upper_position.checked && document.add_emp_perf.upper_position_weight.value.length==0) ||
				(document.add_emp_perf.is_mutual_assessment.checked && document.add_emp_perf.mutual_assessment_weight.value.length==0) ||
				(document.add_emp_perf.is_upper_position2.checked && document.add_emp_perf.upper_position2_weight.value.length==0))
			{
				alert('Alanları eksiksiz doldurduğunuzdan emin olunuz!');
				return false;
			}
			if (document.getElementById('comp_perf_result').value)
				document.getElementById('comp_perf_result').value=filterNum(document.getElementById('comp_perf_result').value);
			if (document.getElementById('emp_perf_weight').value)
				document.getElementById('emp_perf_weight').value=filterNum(document.getElementById('emp_perf_weight').value);
			if (document.getElementById('comp_targ_weight').value)
				document.getElementById('comp_targ_weight').value=filterNum(document.getElementById('comp_targ_weight').value);
			if (document.getElementById('employee_weight').value)
				document.getElementById('employee_weight').value=filterNum(document.getElementById('employee_weight').value);
			if (document.getElementById('consultant_weight').value)
				document.getElementById('consultant_weight').value=filterNum(document.getElementById('consultant_weight').value);
			if (document.getElementById('upper_position_weight').value)
				document.getElementById('upper_position_weight').value=filterNum(document.getElementById('upper_position_weight').value);
			if (document.getElementById('mutual_assessment_weight').value)
				document.getElementById('mutual_assessment_weight').value=filterNum(document.getElementById('mutual_assessment_weight').value);
			if (document.getElementById('upper_position2_weight').value)
				document.getElementById('upper_position2_weight').value=filterNum(document.getElementById('upper_position2_weight').value);
			return true;
		}
		function degerlendirici_gizle_goster()
		{
			if (document.getElementById('is_stage').checked)
			{
				document.getElementById('degerlendirici_hdr').style.display = '';
				document.getElementById('agirlik_hdr').style.display = '';
				document.getElementById('employee_chk').style.display = '';
				document.getElementById('employee_inp').style.display = '';
				document.getElementById('consultant_chk').style.display = '';
				document.getElementById('consultant_inp').style.display = '';
				document.getElementById('upper_position_chk').style.display = '';
				document.getElementById('upper_position_inp').style.display = '';
				document.getElementById('mutual_assessment_chk').style.display = '';
				document.getElementById('mutual_assessment_inp').style.display = '';
				document.getElementById('upper_position2_chk').style.display = '';
				document.getElementById('upper_position2_inp').style.display = '';
			} else {
				document.getElementById('degerlendirici_hdr').style.display = 'none';
				document.getElementById('agirlik_hdr').style.display = 'none';
				document.getElementById('employee_chk').style.display = 'none';
				document.getElementById('employee_inp').style.display = 'none';
				document.getElementById('consultant_chk').style.display = 'none';
				document.getElementById('consultant_inp').style.display = 'none';
				document.getElementById('upper_position_chk').style.display = 'none';
				document.getElementById('upper_position_inp').style.display = 'none';
				document.getElementById('mutual_assessment_chk').style.display = 'none';
				document.getElementById('mutual_assessment_inp').style.display = 'none';
				document.getElementById('upper_position2_chk').style.display = 'none';
				document.getElementById('upper_position2_inp').style.display = 'none';
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.emp_perf_definition';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/employee_performence.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.form_add_emp_perf';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/form_add_emp_perf.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/add_emp_perf_weight.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.emp_perf_definition';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.form_upd_emp_perf';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/form/form_upd_emp_perf.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/query/upd_emp_perf_weight.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.emp_perf_definition&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'weight_id=##attributes.weight_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.weight_id##';
	
	if(attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.emptypopup_del_emp_perf_weight&weight_id=#attributes.weight_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/query/del_emp_perf_weight.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/query/del_emp_perf_weight.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.emp_perf_definition';
	}
</cfscript>
