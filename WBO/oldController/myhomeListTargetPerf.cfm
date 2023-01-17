<cf_get_lang_set module_name='#fusebox.circuit#'>
<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'list')>
    <cfparam name="attributes.position_cat_id" default=''>
    <cfparam name="attributes.emp_status" default=1>
    <cfparam name="attributes.eval_date" default="">
    <cfparam name="attributes.period_year" default="#session.ep.period_year#">
    <cfparam name="attributes.department_id" default="">
    <cfparam name="attributes.department_name" default="">
    <cfparam name="attributes.branch_id" default="">
    <cfparam name="attributes.branch_name" default="">
    <cfparam name="attributes.hierarchy" default="">
    <cfparam name="attributes.is_form_submit" default="0">
    <cfparam name="attributes.keyword" default="">
    <cfif len(attributes.eval_date)>
        <cf_date tarih = "attributes.eval_date">
    </cfif>
    <cfscript>
        if (not len(attributes.period_year) and attributes.is_form_submit)
            attributes.period_year = session.ep.period_year;
        url_str = "";
        if (attributes.is_form_submit)
            url_str = '#url_str#&is_form_submit=#attributes.is_form_submit#';
        if (len(attributes.keyword))
            url_str = "#url_str#&keyword=#attributes.keyword#";
        if (len(attributes.department_id))
            url_str = "#url_str#&department_id=#attributes.department_id#";
        if (len(attributes.department_name))
            url_str = "#url_str#&department_name=#attributes.department_name#";
        if (len(attributes.branch_name))
            url_str="#url_str#&branch_name=#attributes.branch_name#";
        if (len(attributes.branch_id))
            url_str="#url_str#&branch_id=#attributes.branch_id#";
        if (isdefined("attributes.position_cat_id"))
            url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#";
        if (len(attributes.eval_date) gt 9)
            url_str = "#url_str#&eval_date=#dateformat(attributes.eval_date,'dd/mm/yyyy')#";
        if (isdefined("attributes.period_year"))
            url_str = "#url_str#&period_year=#attributes.period_year#";
        if (isdefined("attributes.attenders"))
            url_str = "#url_str#&attenders=#attributes.attenders#";
        if (isdefined('emp_status'))
            url_str = '#url_str#&emp_status=#attributes.emp_status#';
    </cfscript>
    <cfinclude template="../myhome/query/get_position_cats.cfm">
    <cfif attributes.is_form_submit>
        <cfquery name="get_emp_pos" datasource="#dsn#">
            SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
        </cfquery>
        <cfset position_list=valuelist(get_emp_pos.position_code,',')>
        <cfinclude template="../myhome/query/get_emp_codes.cfm">
        <cfquery name="get_performans" datasource="#dsn#">
        SELECT
            EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
            EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
            EMPLOYEE_POSITIONS.POSITION_CAT_ID,
            EMPLOYEE_POSITIONS.DEPARTMENT_ID,
            EP.*
        FROM 
            EMPLOYEE_PERFORMANCE_TARGET EPT,
            EMPLOYEE_PERFORMANCE EP,
            EMPLOYEE_POSITIONS
        WHERE
            EMPLOYEE_POSITIONS.EMPLOYEE_ID=EP.EMP_ID AND
            EMPLOYEE_POSITIONS.POSITION_CODE=EP.POSITION_CODE AND 
            EP.PER_ID=EPT.PER_ID AND
            (EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> OR EPT.FIRST_BOSS_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> OR
            EPT.SECOND_BOSS_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
            <cfif len(attributes.period_year)>AND YEAR(START_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_year#"></cfif>
            <cfif len(attributes.department_id)>AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"></cfif>
            <cfif len(attributes.position_cat_id)>AND EMPLOYEE_POSITIONS.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#"></cfif>
            <cfif len(attributes.eval_date)>AND EVAL_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.eval_date#"></cfif>
            <cfif len(attributes.keyword)>AND (EMPLOYEE_POSITIONS.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)</cfif>
        </cfquery>
    <cfelse>
        <cfset get_performans.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfparam name="attributes.totalrecords" default='#get_performans.recordcount#'>
    <cfif get_performans.recordcount>
        <cfoutput query="get_performans">
            <cfif fusebox.circuit eq 'myhome'>
                <cfset PER_ID_ = contentEncryptingandDecodingAES(isEncode:1,content:PER_ID,accountKey:'wrk')>
            <cfelse>
                <cfset PER_ID_ = PER_ID>
            </cfif> 
        </cfoutput>
    </cfif> 
</cfif>
<script type="text/javascript">
	<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'list')> 
		$(document).ready(function(){
			document.getElementById('keyword').focus();
		});
		function kontrol(){
			if(document.search.branch_name.value.length==0)
				document.search.branch_id.value="";
			if(document.search.department_name.value.length==0
				)document.search.department_id.value="";
			return true;
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'add'> 
		function kontrol()
		{
			if(document.add_perf_emp_info.emp_name.value.length==0)
			{
				alert("<cf_get_lang no='426.Calisan seciniz'>");
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
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.list_target_perf';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/list_target_perf.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'myhome.list_target_perf';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'myhome/form/target_plan_forms_info.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'myhome/query/add_target_plan_forms_info.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_target_perf&event=upd';
</cfscript>
