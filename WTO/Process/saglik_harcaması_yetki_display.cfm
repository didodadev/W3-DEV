<!---
    IK sağlık harcaması onayında onay verildiğinde işlem kategorisi muhasebe yapacak şekilde düzenleniyor ve kontrol ediliyor
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
</cfif>

<script type="text/javascript">
	/*function process_cat_dsp_function()
	{
		var get_process_sql = wrk_safe_query('prc_get_process','dsn',0,document.all.process_stage.value);
		var process_all_employee = wrk_safe_query('prc_process_all_employee','dsn',0,document.all.process_stage.value);
		if(get_process_sql.recordcount == 0 && process_all_employee.recordcount == 0)
		{
			alert('Belgenin Bu Aşamasında Yetkiniz Yok!');
			return false;
		}
		return true;
	}*/
    $(document).ready(function(){
		//Belge aşamasına yetki yok ise butonlar pasif
         if($("#process_stage").val() != '' && $("#process_stage").val() != undefined){
            var get_process_sql = wrk_safe_query('prc_get_process','dsn',0,$("#process_stage").val());
            var process_all_employee = wrk_safe_query('prc_process_all_employee','dsn',0,$("#process_stage").val());
            if(get_process_sql.recordcount == 0 && process_all_employee.recordcount == 0)
            {
                alert('Belgenin Bu Aşamasında Yetkiniz Yok!');
                
                document.getElementById("wrk_submit_button").disabled = "false";
                document.getElementById("wrk_delete_button").disabled = "false";
            }
		}
		if($("#ch_company").length == 0){//anlaşmasız kurum
			var process_cat_id_ = 180; //muhasebe işlemi yapacak işlem kategori id 10
			var process_id_ = 168; // onay işlemi süreç id 11
			var process_id_2_ = 167; // onay işlemi süreç id 11
		}else{//anlaşmalı kurum
		   var process_cat_id_ = 181; //muhasebe işlemi yapacak işlem kategori id 10
		   var process_id_ = 168; // onay işlemi süreç id 11
		   var process_id_2_ = 167; // onay işlemi süreç id 11
		}
        if (window.location.href.indexOf("hr.health_expense_approve") > -1) {
            $("#process_stage" ).change(function() {
                if($("#process_stage").val() == process_id_ || $("#process_stage").val() == process_id_2_){
                    if($("#process_cat option[value='"+process_cat_id_+"']").length > 0)
                        $("#process_cat").val(process_cat_id_)
				}
            });
        
          /*  $("#process_cat" ).change(function() {
                if($("#process_cat").val() == process_cat_id_){
                    if($("#process_stage option[value='"+process_id_+"']").length > 0)
                        $("#process_stage").val(process_id_);
				}
            });
			*/
        }

        <cfif caller.attributes.fuseaction eq 'hr.health_expense_approve'>
            <cfif isdefined("caller.attributes.event") and caller.attributes.event eq "upd">
                status = <cfoutput>#control#</cfoutput>;
                health_id = <cfoutput>#caller.attributes.health_id#</cfoutput>;
                is_admin = <cfoutput>#session.ep.admin#</cfoutput>;
                get_control = wrk_safe_query('control_expense_account_card','dsn2',0,health_id);
                if(status == 0 && get_control.recordcount && is_admin != 1){
                    $('#wrk_submit_button').prop("disabled", true);
                    $('#wrk_delete_button').prop("disabled", true);
                }
            </cfif>
        </cfif>

    });
</script>
