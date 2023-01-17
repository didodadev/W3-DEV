<cfset HealthExpense = createObject("component","V16.myhome.cfc.health_expense") />
<cfset get_expense_process = HealthExpense.GET_EXPENSE_PROCESS(health_id : attributes.health_id) />
<cfform name="form_upd_health_process" method="post" action="#request.self#?fuseaction=hr.emptypopup_upd_health_expense_process_query">
    <cfinput type="hidden" name="health_id" id="health_id" value="#attributes.health_id#">
    <cfinput type="hidden" name="paper_number" id="paper_number" value="#get_expense_process.PAPER_NO#">
    <div class="form-group" id="item-health_process_label">
        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
    </div>
    <div class="form-group" id="item-health_process_stage">
        <div class="col col-12 col-xs-12">
            <cf_workcube_process is_upd='0' is_detail='1' select_value='#get_expense_process.EXPENSE_STAGE#' fuseaction='hr.health_expense_approve'>
        </div>
    </div>
    <div class="row formContentFooter">
        <cf_workcube_buttons is_upd='1' is_delete='0'>
    </div>
</cfform>