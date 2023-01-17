<cfset HealthExpense = createObject("component","V16.myhome.cfc.health_expense") />
<cfset get_expense_process = HealthExpense.UPDATE_EXPENSE_PROCESS(
    health_id : attributes.health_id,
    process_stage : iIf(isdefined("attributes.process_stage") and len(attributes.process_stage),"attributes.process_stage",DE(""))
) />
<cfsavecontent variable="healthExpense"><cf_get_lang dictionary_id = "33706.Sağlık Harcaması"></cfsavecontent>
<cf_workcube_process
    is_upd='1'
    fuseaction='hr.health_expense_approve'
    data_source='#dsn2#'
    old_process_line='#attributes.old_process_line#'
    process_stage='#attributes.process_stage#'
    record_member='#session.ep.userid#'
    record_date='#now()#'
    action_table='EXPENSE_ITEM_PLAN_REQUESTS'
    action_column='EXPENSE_ID'
    action_id='#attributes.health_id#'
    action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.health_expense_approve&event=upd&health_id=#attributes.health_id#'
    warning_description='#healthExpense# : #attributes.paper_number#'>

<script type="text/javascript">
    window.location.href = "<cfoutput>#request.self#?fuseaction=hr.health_expense_approve&event=upd&health_id=#attributes.health_id#</cfoutput>";
</script>