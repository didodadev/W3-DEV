<!---
    Author: Workcube - Botan Kayğan <botankaygan@workcube.com>
    Date: 10.06.2020
    Description:
        Sağlık harcamalarında muhasebeleşmiş ve muhasebe işlem kısıtı tarihini 
        geçmiş kayıtların güncelle ve sil butonları pasife çekilir.
--->
<cfif caller.attributes.fuseaction eq 'hr.health_expense_approve' and (isdefined("caller.attributes.event") and caller.attributes.event eq "upd")>
    <cfset process_date = caller.get_expense.process_date>
    <cfset expense_date = caller.get_expense.expense_date>
    <cfif not len(process_date)>
        <cfif expense_date gte session.ep.period_date and expense_date lte session.ep.period_finish_date>
            <cfset control = 1>
        <cfelse>
            <cfset control = 0>
        </cfif>
    <cfelse>
        <cfif process_date gte session.ep.period_date and process_date lte session.ep.period_finish_date>
            <cfset control = 1>
        <cfelse>
            <cfset control = 0>
        </cfif>
    </cfif>
    <script type="text/javascript">
        $(document).ready(function(){
            status = <cfoutput>#control#</cfoutput>;
            health_id = <cfoutput>#caller.attributes.health_id#</cfoutput>;
            is_admin = <cfoutput>#session.ep.admin#</cfoutput>;
            get_control = wrk_safe_query('control_expense_account_card','dsn2',0,health_id);
            if(status == 0 && get_control.recordcount && is_admin != 1){
                $('#wrk_submit_button').prop("disabled", true);
                $('#wrk_delete_button').prop("disabled", true);
            }
        });
    </script>
</cfif>