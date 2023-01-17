upd_flexible_worktime_approve<!---
    File: add_flexible_worktime.cfm
    Controller: FlexibleWorkTimeController.cfm
    Author: Esma R. UYSAL
    Date: 07/12/2019 
    Description:
        Esnek çalışma saatleri güncelleme query sayfasıdır.
--->
<cfset flex_component = createObject("component","V16.myhome.cfc.flexible_worktime")>
<cf_date tarih="attributes.request_date">
<cfset upd_flexible_worktime = flex_component.upd_flexible_worktime(
        employee_id : attributes.employee_id,
        position_id : attributes.position_id,
        department_id : len(attributes.department_id) ? attributes.department_id : "",
        request_date : attributes.request_date,
        stage_id : attributes.process_stage,
        worktime_flexible_notice : attributes.worktime_flexible_notice,
        branch_id : attributes.branch_id,
        flexible_id : attributes.flexible_id
   )>
<cfset del_flexible = flex_component.DEL_FLEXIBLE_ROW(worktime_flexible_id : attributes.flexible_id)>
<cfloop from="1" to="#attributes.row_count#" index="c">
    
    <cfif isdefined("attributes.current_id#c#")>
        <cfif isdefined("attributes.flexible_start_hour#c#")>
            <cfif isdefined("attributes.work_date_row#c#") and len(Evaluate('attributes.work_date_row#c#'))>
                <cf_date tarih="attributes.work_date_row#c#">
            </cfif>
            <cfset currentrow_id = Evaluate('attributes.current_id#c#')>
            <cfset upd_flexible_worktime_rows = flex_component.UPD_FLEXIBLE_WORKTIME_ROW(
                currentrow_id : currentrow_id,
                worktime_flexible_id : attributes.flexible_id,
                flexible_start_hour : len(Evaluate('attributes.flexible_start_hour#c#')) ? Evaluate('attributes.flexible_start_hour#c#') : "",
                flexible_start_min : len(Evaluate('attributes.flexible_start_min#c#')) ?  Evaluate('attributes.flexible_start_min#c#') : "",
                flexible_finish_hour : len(Evaluate('attributes.flexible_finish_hour#c#')) ? Evaluate('attributes.flexible_finish_hour#c#') : "",
                flexible_finish_min : len(Evaluate('attributes.flexible_finish_min#c#')) ? Evaluate('attributes.flexible_finish_min#c#') : "",
                flexible_month : (isdefined("attributes.flexible_month#c#") and len(Evaluate('attributes.flexible_month#c#'))) ? Evaluate('attributes.flexible_month#c#') : "",
                flexible_day :  (isdefined("attributes.flexible_day#c#") and len(Evaluate('attributes.flexible_day#c#'))) ? Evaluate('attributes.flexible_day#c#') : "",
                flexible_date : (isdefined("attributes.work_date_row#c#") and len(Evaluate('attributes.work_date_row#c#'))) ? Evaluate('attributes.work_date_row#c#') : "",
                flexible_year :  (isdefined("attributes.period_years#c#") and len(Evaluate('attributes.period_years#c#'))) ? Evaluate('attributes.period_years#c#') : "",
                is_del : Evaluate('attributes.is_del#c#'),
                is_approve : (currentrow_id neq -1 and isdefined("attributes.is_approve#currentrow_id#")) ? Evaluate('attributes.is_approve#currentrow_id#') : 0
                )>
        </cfif>
     </cfif>
</cfloop>
<cfif listfirst(attributes.fuseaction,'.') is 'myhome'>
    <cfset flexible_worktime_id_ = contentEncryptingandDecodingAES(isEncode:1,content:attributes.flexible_id,accountKey:'wrk')>
<cfelse>
    <cfset flexible_worktime_id_ = attributes.flexible_id>
</cfif>
<cfset action_id_ = "flexible_worktime_approve&event=upd&flexible_id=#flexible_worktime_id_#">
<cf_workcube_process 
        is_upd='1' 
        old_process_line='0'
        process_stage='#attributes.process_stage#' 
        record_member='#session.ep.userid#' 
        record_date='#now()#'
        action_table='WORKTIME_FLEXIBLE'
        action_column='WORKTIME_FLEXIBLE_ID'
        action_id='#attributes.flexible_id#'
        action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.#action_id_#' 
        warning_description='#getLang("service",158)#'>
<script type="text/javascript">
        window.location.href="<cfoutput>#request.self#?fuseaction=myhome.flexible_worktime_approve&event=upd&flexible_id=#flexible_worktime_id_#</cfoutput>";
</script>