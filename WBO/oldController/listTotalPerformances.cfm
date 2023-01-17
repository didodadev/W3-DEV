<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'list')>
	<cfset search_year = year(#now()#)>
    <cfparam name="attributes.position_cat_id" default='0'>
    <cfparam name="attributes.emp_status" default='1'>
    <cfparam name="attributes.search_tarih" default='#search_year#'>
    <cfparam name="attributes.keyword" default="">
    <cfif isdefined("attributes.form_submitted")>
        <cfinclude template="../hr/query/get_total_perf_results.cfm">
    <cfelse>
        <cfset get_total_perf_results.recordcount=0>
    </cfif>
    <cfset url_str = "">
    
    <cfif len(attributes.keyword)>
        <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
    </cfif>
    <cfif isdefined("attributes.department_id")>
      <cfset url_str = "#url_str#&department_id=#attributes.department_id#">
    </cfif>
    <cfif isdefined("attributes.position_cat_id")>
      <cfset url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#">
    </cfif>
    <cfif isdefined("attributes.attenders")>
      <cfset url_str = "#url_str#&attenders=#attributes.attenders#">
    </cfif>
    <cfif isdefined('emp_status')>
      <cfset url_str = '#url_str#&emp_status=#attributes.emp_status#'>
    </cfif>
    <cfinclude template="../hr/query/get_positions_notempty.cfm">
    <cfinclude template="../hr/query/get_position_cats.cfm">
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default=#get_total_perf_results.recordcount#>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfinclude template="../hr/query/get_all_departments.cfm">
    <cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
        <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
    </cfif> 
<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>    
	<cfif isdefined("attributes.event") and attributes.event is 'add'>
        <cfparam name="attributes.start_date" default="">
        <cfparam name="attributes.finish_date" default="">
        <cfset firstdate = attributes.start_date>
        <cfset lastdate = attributes.finish_date>
        <cf_date tarih=firstdate>
        <cf_date tarih=lastdate>
        <cfquery name="GET_TARIH" datasource="#DSN#">
            SELECT
                START_DATE,
                FINISH_DATE
            FROM	
                EMPLOYEE_TOTAL_PERFORMANCE
            WHERE
                START_DATE = #firstdate# AND FINISH_DATE = #lastdate# AND EMP_ID = #attributes.employee_id#
        </cfquery>
        
        <cfif get_tarih.recordcount>
            <script type="text/javascript">
                alert("Aynı Döneme Birden Fazla Performans Formu Eklenemez !");
                history.back();
            </script>
        </cfif>
    <!---    <cfinclude template="../hr/query/get_total_perf_quizs.cfm">
        <cfinclude template="../hr/query/get_total_perf_targets.cfm">
        <cffunction name="GETEMPNAME">
          <cfargument name="empid" type="numeric" required="true">
            <cfquery name="GET_EMP_NAME" datasource="#dsn#">
                SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #EMPID#
            </cfquery>
          <cfreturn GET_EMP_NAME>
        </cffunction>
        <cfinclude template="../hr/query/get_positions_notempty.cfm">--->
    <cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
        <cfinclude template="../hr/query/get_total_performance.cfm">
        <cfset attributes.employee_id = get_total_performance.EMP_ID>
        <cfset employee_id = get_total_performance.EMP_ID>
        <cfset firstdate = dateformat(get_total_performance.start_date,'dd/mm/yyyy')>
        <cfset lastdate = dateformat(get_total_performance.finish_date,'dd/mm/yyyy')>
        <cf_date tarih = 'firstdate'>
        <cf_date tarih = 'lastdate'>
    <!---    <cfinclude template="../hr/query/get_total_perf_quizs.cfm">
        <cfinclude template="../hr/query/get_total_perf_targets.cfm">
        <cffunction name="GETEMPNAME">
          <cfargument name="empid" type="numeric" required="true">
              <cfquery name="GET_EMP_NAME" datasource="#dsn#">
                SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #EMPID#
              </cfquery>
          <cfreturn get_emp_name>
        </cffunction>--->
        <cffunction name="GETPOSNAME">
          <cfargument name="posid" type="numeric" required="true">
              <cfquery name="GET_POS_NAME" datasource="#dsn#">
                SELECT POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #POSID#
              </cfquery>
          <cfreturn get_pos_name>
        </cffunction>
        <cfinclude template="../hr/query/get_emp_chiefs.cfm">
        <!---<cfinclude template="../hr/query/get_positions_notempty.cfm">--->
        <cfif len(GET_TOTAL_PERFORMANCE.RECORD_KEY)>
			<cfif Left(GET_TOTAL_PERFORMANCE.RECORD_KEY,1) IS "e">
                <cfset isim = #GETEMPNAME(Right(GET_TOTAL_PERFORMANCE.RECORD_KEY,len(Trim(GET_TOTAL_PERFORMANCE.RECORD_KEY))-2)).EMPLOYEE_NAME#>
                <cfset soyisim = #GETEMPNAME(Right(GET_TOTAL_PERFORMANCE.RECORD_KEY,len(Trim(GET_TOTAL_PERFORMANCE.RECORD_KEY))-2)).EMPLOYEE_SURNAME#>
            <cfelseif Left(GET_TOTAL_PERFORMANCE.RECORD_KEY,1) IS "p">
                <cfquery DATASOURCE="#DSN#" NAME="GET_EVALUATOR">
                    SELECT COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME FROM
                    COMPANY_PARTNER WHERE PARTNER_ID = #RIGHT(GET_TOTAL_PERFORMANCE.RECORD_KEY,LEN(TRIM(GET_TOTAL_PERFORMANCE.RECORD_KEY))-2)#
                </cfquery>
                <cfset isim = GET_EVALUATOR.COMPANY_PARTNER_NAME>
                <cfset soyisim = GET_EVALUATOR.COMPANY_PARTNER_SURNAME>
            </cfif>
        </cfif>
        <cfif len(GET_TOTAL_PERFORMANCE.UPDATE_KEY)>
            <cfif left(GET_TOTAL_PERFORMANCE.UPDATE_KEY,1) IS "e">
                <cfset isim2 = #GETEMPNAME(right(GET_TOTAL_PERFORMANCE.UPDATE_KEY,len(trim(GET_TOTAL_PERFORMANCE.UPDATE_KEY))-2)).EMPLOYEE_NAME#>
                <cfset soyisim2 = #GETEMPNAME(right(GET_TOTAL_PERFORMANCE.UPDATE_KEY,len(trim(GET_TOTAL_PERFORMANCE.UPDATE_KEY))-2)).EMPLOYEE_SURNAME#>
            <cfelseif left(GET_TOTAL_PERFORMANCE.UPDATE_KEY,1) IS "p">
                <cfquery DATASOURCE="#DSN#" NAME="GET_EVALUATOR">
                    SELECT COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME FROM
                    COMPANY_PARTNER WHERE PARTNER_ID = #RIGHT(GET_TOTAL_PERFORMANCE.UPDATE_KEY,LEN(TRIM(GET_TOTAL_PERFORMANCE.UPDATE_KEY))-2)#
                </cfquery>
                <cfset isim2 = GET_EVALUATOR.COMPANY_PARTNER_NAME>
                <cfset soyisim2 = GET_EVALUATOR.COMPANY_PARTNER_SURNAME>
            </cfif>
        </cfif>
  	</cfif>
    <cfinclude template="../hr/query/get_total_perf_quizs.cfm">
    <cfinclude template="../hr/query/get_total_perf_targets.cfm">
    <cffunction name="GETEMPNAME">
      <cfargument name="empid" type="numeric" required="true">
        <cfquery name="GET_EMP_NAME" datasource="#dsn#">
            SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #EMPID#
        </cfquery>
      <cfreturn GET_EMP_NAME>
    </cffunction>
    <cfinclude template="../hr/query/get_positions_notempty.cfm">
</cfif>           	
<script type="text/javascript">
	<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'list')>
		$(document).ready(function(){
			document.getElementById('keyword').focus();	 
		});
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_total_performances';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_total_performances.cfm';
	
	WOStruct['#attributes.fuseaction#']['listOther'] = structNew();
	WOStruct['#attributes.fuseaction#']['listOther']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['listOther']['fuseaction'] = 'hr.form_add_total_performance_info';
	WOStruct['#attributes.fuseaction#']['listOther']['filePath'] = 'hr/form/add_total_performance_info.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.form_add_total_performance';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/form_add_total_performance.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/add_total_performance.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_total_performances';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.form_upd_total_performance';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/form/form_upd_total_performance.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/query/upd_total_performance.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_total_performances';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'performance_id=##attributes.performance_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.PERFORMANCE_ID##';

</cfscript>
