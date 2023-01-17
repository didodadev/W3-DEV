<!---
    File: add_flexible_worktime.cfm
    Controller: FlexibleWorkTimeController.cfm
    Author: Esma R. UYSAL
    Date: 07/12/2019 
    Description:
        Esnek çalışma saatleri ekleme query sayfasıdır.
--->
<cfset flex_component = createObject("component","V16.myhome.cfc.flexible_worktime")>
<cf_date tarih="attributes.request_date">
<cfset add_flexible_worktime = flex_component.add_flexible_worktime(
        employee_id : (listLen(attributes.employee_id,"_")) ? listfirst(attributes.employee_id,"_") : attributes.employee_id,
        position_id : attributes.position_id,
        department_id : attributes.department_id,
        request_date : attributes.request_date,
        stage_id : attributes.process_stage,
        worktime_flexible_notice : attributes.worktime_flexible_notice,
        branch_id : attributes.branch_id
   )>
   <cfset flexible_worktime_id = Replace( add_flexible_worktime, '"', "","all" )>
<cfif attributes.row_count neq 0>
    <cfloop from="1" to="#attributes.row_count#" index="c">
        <cfif isdefined("attributes.work_date_row#c#") and len(Evaluate('attributes.work_date_row#c#'))>
            <cf_date tarih="attributes.work_date_row#c#">
        </cfif>
        <cfif isdefined("flexible_start_hour#c#")>
            <cfset add_flexible_worktime_rows = flex_component.ADD_FLEXIBLE_WORKTIME_ROWS(
                worktime_flexible_id : flexible_worktime_id,
                flexible_start_hour : len(Evaluate('attributes.flexible_start_hour#c#')) ? Evaluate('attributes.flexible_start_hour#c#') : "",
                flexible_start_min : len(Evaluate('attributes.flexible_start_min#c#')) ?  Evaluate('attributes.flexible_start_min#c#') : 0,
                flexible_finish_hour : len(Evaluate('attributes.flexible_finish_hour#c#')) ? Evaluate('attributes.flexible_finish_hour#c#') : "",
                flexible_finish_min : len(Evaluate('attributes.flexible_finish_min#c#')) ? Evaluate('attributes.flexible_finish_min#c#') : "",
                flexible_month : (isdefined("attributes.flexible_month#c#") and len(Evaluate('attributes.flexible_month#c#'))) ? Evaluate('attributes.flexible_month#c#') : "",
                flexible_day : (isdefined("attributes.flexible_day#c#") and len(Evaluate('attributes.flexible_day#c#'))) ? Evaluate('attributes.flexible_day#c#') : "",
                flexible_date : (isdefined("attributes.work_date_row#c#") and len(Evaluate('attributes.work_date_row#c#'))) ? Evaluate('attributes.work_date_row#c#') : "",
                flexible_year : (isdefined("attributes.period_years#c#") and len(Evaluate('attributes.period_years#c#'))) ? Evaluate('attributes.period_years#c#') : ""
                )>
        </cfif>
    </cfloop>
</cfif>
<cfif listfirst(attributes.fuseaction,'.') is 'myhome'>
    <cfset flexible_worktime_id_ = contentEncryptingandDecodingAES(isEncode:1,content:flexible_worktime_id,accountKey:'wrk')>
<cfelse>
    <cfset flexible_worktime_id_ = flexible_worktime_id>
</cfif>
<cfif listfirst(attributes.fuseaction,'.') is 'myhome'>
    <cfset action_page_ = "flexible_worktime_approve&event=upd&flexible_id=#flexible_worktime_id_#">
<cfelse>
    <cfset action_page_ = "flexible_worktime&event=upd&flexible_id=#flexible_worktime_id_#&emp_id=#attributes.employee_id#">
</cfif>
<cf_workcube_process 
        is_upd='1' 
        old_process_line='0'
        process_stage='#attributes.process_stage#' 
        record_member='#session.ep.userid#' 
        record_date='#now()#'
        action_table='WORKTIME_FLEXIBLE'
        action_column='WORKTIME_FLEXIBLE_ID'
        action_id='#flexible_worktime_id#'
        action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.#action_page_#' 
        warning_description='#getLang("service",158)#'>
<script type="text/javascript">
    <cfif listfirst(attributes.fuseaction,'.') is 'myhome'>
        window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.flexible_worktime&event=upd&flexible_id=#flexible_worktime_id_#</cfoutput>";
    <cfelse>
        window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.flexible_worktime&event=upd&flexible_id=#flexible_worktime_id_#&emp_id=#attributes.employee_id#</cfoutput>";
    </cfif>
</script>