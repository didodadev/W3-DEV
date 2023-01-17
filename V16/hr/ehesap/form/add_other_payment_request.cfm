<cf_catalystHeader>
<cfparam name="attributes.sal_mon" default="1"> 
<cfinclude template="../query/get_setup_moneys.cfm">
<cfquery name="get_in_out" datasource="#dsn#">
	SELECT IN_OUT_ID FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>
<div class="col col-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=ehesap.emptypopup_add_other_payment_request" name="form_add_payment_request" method="POST" onsubmit="UnformatFields();">
            <input type="hidden" name="odkes_id" id="odkes_id" value="">
            <input type="hidden" name="is_inst_avans" id="is_inst_avans" value="1">
            <input type="hidden" name="periyod_get" id="periyod_get" value="">
            <input type="hidden" name="method_get" id="method_get" value="">
            <input type="hidden" name="from_salary" id="from_salary" value="">
            <input type="hidden" name="show" id="show" value="">
            <input type="hidden" name="term" id="term" value="">
            <input type="hidden" name="start_sal_mon" id="start_sal_mon" value="">
            <input type="hidden" name="end_sal_mon" id="end_sal_mon" value="">
            <input type="hidden" name="calc_days" id="calc_days" value="">
            <input type="hidden" name="form_add_request" id="form_add_request" value="0">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-process_stage">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='58859.Süreç'></label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>	
                        </div>
                    </div>
                    <div class="form-group" id="item-pos_code_emp">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57576.Calışan'>*</label>
                           <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="in_out_id" id="in_out_id" value="<cfoutput>#get_in_out.in_out_id#</cfoutput>">
                                    <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
                                    <input name="emp_name" type="text" id="emp_name"  value="<cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>" readonly>
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=form_add_payment_request.in_out_id&field_emp_id=form_add_payment_request.employee_id&field_emp_name=form_add_payment_request.emp_name&select_list=1','list');"></span>
                                </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-comment_get">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31578.Avans Tipi'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="comment_get" id="comment_get" value="" readonly >
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_list_kesinti_taksitli','medium')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-AMOUNT_GET">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="AMOUNT_GET" id="AMOUNT_GET" value=""  onkeyup="return(FormatCurrency(this,event));" class="moneybox">
                        </div>
                    </div>
                    <div class="form-group" id="item-taksit">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54064.Taksit Sayısı'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="taksit" id="taksit">
                                <cfloop from="1" to="36" index="i">
                                    <cfoutput>
                                    <option value="#i#">#i#</option>
                                    </cfoutput>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-sal_mon">
						<label class="col col-4 col-xs-12"><cf_get_lang  dictionary_id="53132.Başlangıç Ay"></label>     
						<div class="col col-8 col-xs-12">
							<select name="sal_mon" id="sal_mon" >
								<cfloop from="1" to="12" index="i">
									<cfoutput><option value="#i#" <cfif attributes.sal_mon is i>selected</cfif> >#listgetat(ay_list(),i,',')#</option></cfoutput>
								</cfloop>
							</select>
						</div>  
					</div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="detail" id="detail"></textarea>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-12">
                    <cf_workcube_buttons is_upd='0' add_function = 'kontrol()'>
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
function add_row(from_salary, show, comment_pay, period_pay, method_pay, term, start_sal_mon, end_sal_mon, amount_pay, calc_days,odkes_id)
{
	document.form_add_payment_request.odkes_id.value=odkes_id;
	document.form_add_payment_request.from_salary.value=from_salary;
    document.form_add_payment_request.show.value=show;
    document.form_add_payment_request.comment_get.value=comment_pay;
	document.form_add_payment_request.periyod_get.value=period_pay;
	document.form_add_payment_request.method_get.value=method_pay;
	document.form_add_payment_request.term.value=term;
	document.form_add_payment_request.start_sal_mon.value=start_sal_mon;
	document.form_add_payment_request.end_sal_mon.value=end_sal_mon;
	document.form_add_payment_request.calc_days.value=calc_days;
	return true;
}
function UnformatFields()
{
	document.getElementById('AMOUNT_GET').value = filterNum(document.getElementById('AMOUNT_GET').value);
}
function kontrol()
{
	if (document.getElementById('AMOUNT_GET').value =='' || document.getElementById('AMOUNT_GET').value ==0)
		{
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57673.Tutar'>");
			return false;		
		}
return true;
}
</script>
