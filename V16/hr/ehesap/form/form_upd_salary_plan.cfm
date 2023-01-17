<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.in_out_id" default="">
<cfparam name="attributes.modal_id" default="">
<cfinclude template="../query/get_moneys.cfm">
<cfquery name="get_salary_plan" datasource="#dsn#">
	SELECT
		ESP.*,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM
		EMPLOYEES_SALARY_PLAN ESP,
		EMPLOYEES E
	WHERE
		ESP.SALARY_PLAN_ID = #attributes.SALARY_PLAN_ID#
		AND ESP.EMPLOYEE_ID = E.EMPLOYEE_ID
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="53541.Maaş Planla"></cfsavecontent>
<cf_box title="#getLang('','Maaş Planla',53541)# : #get_emp_info(get_salary_plan.employee_id,0,0)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform action="#request.self#?fuseaction=ehesap.emptypopup_upd_salary_plan" method="post" name="add_expense">
        <input type="hidden" name="salary_plan_id" id="salary_plan_id" value="<cfoutput>#attributes.salary_plan_id#</cfoutput>">
        <cf_box_elements>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58455.Yıl'></label>
                    <div class="col col-8 col-sm-12">
                        <select name="sal_year" id="sal_year">
                            <cfloop from="#YEAR(NOW())-1#" to="#YEAR(NOW())+2#" index="i">
                                <cfoutput><option value="#i#"<cfif get_salary_plan.PERIOD_YEAR eq i> selected</cfif>>#i#</option></cfoutput>
                            </cfloop>
                        </select>		
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57592.Ocak'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput onKeyup="if (FormatCurrency(this,event)) {return true;} else {upd_12(); return false;}" type="text" name="M1" style="width:100px;" value="#TLFormat(get_salary_plan.m1)#">		
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57593.Şubat'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput onkeyup="return(FormatCurrency(this,event));" type="text" name="M2" style="width:100px;" value="#TLFormat(get_salary_plan.m2)#">
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57594.Mart'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput onkeyup="return(FormatCurrency(this,event));"  type="text" name="M3" style="width:100px;" value="#TLFormat(get_salary_plan.m3)#">
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57595.Nisan'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput onkeyup="return(FormatCurrency(this,event));" type="text" name="M4" style="width:100px;" value="#TLFormat(get_salary_plan.m4)#">
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57596.Mayıs'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput onkeyup="return(FormatCurrency(this,event));" type="text" name="M5" style="width:100px;" value="#TLFormat(get_salary_plan.m5)#">
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57597.Haziran'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput onkeyup="return(FormatCurrency(this,event));" type="text" name="M6" style="width:100px;" value="#TLFormat(get_salary_plan.m6)#">
                    </div>
                </div>
            </div>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57489.Para Birimi'></label>
                    <div class="col col-8 col-sm-12">
                        <select name="money" id="money">
                            <cfoutput query="get_moneys">
                                <option value="#MONEY#" <cfif (len(get_salary_plan.money) and get_salary_plan.money is '#MONEY#') or (not len(get_salary_plan.money) and session.ep.money is '#MONEY#')>selected</cfif>>#MONEY#</option>
                            </cfoutput>
                        </select>	
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57598.Temmuz'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput onKeyup="if (FormatCurrency(this,event)) {return true;} else {upd_6(); return false;}" type="text" name="M7" style="width:100px;" value="#TLFormat(get_salary_plan.m7)#">
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57599.Ağustos'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput onkeyup="return(FormatCurrency(this,event));"  type="text" name="M8" style="width:100px;" value="#TLFormat(get_salary_plan.m8)#">
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57600.Eylül'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput onkeyup="return(FormatCurrency(this,event));" type="text" name="M9" style="width:100px;" value="#TLFormat(get_salary_plan.m9)#">
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57601.Ekim'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput onkeyup="return(FormatCurrency(this,event));" type="text" name="M10" style="width:100px;" value="#TLFormat(get_salary_plan.m10)#">
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57602.Kasım'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput onkeyup="return(FormatCurrency(this,event));" type="text" name="M11" style="width:100px;" value="#TLFormat(get_salary_plan.m11)#">
                    </div>
                </div>
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57603.Aralık'></label>
                    <div class="col col-8 col-sm-12">
                        <cfinput onkeyup="return(FormatCurrency(this,event));" type="text" name="M12" style="width:100px;" value="#TLFormat(get_salary_plan.m12)#">
                    </div>
                </div>
            </div>			
        </cf_box_elements>
        <cf_box_footer>
            <cf_record_info query_name="get_salary_plan">
            <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_salary_plan&SALARY_PLAN_ID=#attributes.salary_plan_id#' add_function="#iif(isdefined("attributes.draggable"),DE("upd_form() && loadPopupBox('add_expense' , #attributes.modal_id#)"),DE(""))#">
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
function upd_form()
{
	UnformatFields();
	if (add_expense.M1.value == '') add_expense.M1.value = 0;
	if (add_expense.M2.value == '') add_expense.M2.value = 0;
	if (add_expense.M3.value == '') add_expense.M3.value = 0;
	if (add_expense.M4.value == '') add_expense.M4.value = 0;
	if (add_expense.M5.value == '') add_expense.M5.value = 0;
	if (add_expense.M6.value == '') add_expense.M6.value = 0;
	if (add_expense.M7.value == '') add_expense.M7.value = 0;
	if (add_expense.M8.value == '') add_expense.M8.value = 0;
	if (add_expense.M9.value == '') add_expense.M9.value = 0;
	if (add_expense.M10.value == '') add_expense.M10.value = 0;
	if (add_expense.M11.value == '') add_expense.M11.value = 0;
	if (add_expense.M12.value == '') add_expense.M12.value = 0;
	return true;
}

function upd_12()
{
	add_expense.M2.value = add_expense.M1.value;
	add_expense.M3.value = add_expense.M1.value;
	add_expense.M4.value = add_expense.M1.value;
	add_expense.M5.value = add_expense.M1.value;
	add_expense.M6.value = add_expense.M1.value;
	add_expense.M7.value = add_expense.M1.value;
	add_expense.M8.value = add_expense.M1.value;
	add_expense.M9.value = add_expense.M1.value;
	add_expense.M10.value = add_expense.M1.value;
	add_expense.M11.value = add_expense.M1.value;
	add_expense.M12.value = add_expense.M1.value;
}

function upd_6()
{
	add_expense.M8.value = add_expense.M7.value;
	add_expense.M9.value = add_expense.M7.value;
	add_expense.M10.value = add_expense.M7.value;
	add_expense.M11.value = add_expense.M7.value;
	add_expense.M12.value = add_expense.M7.value;
}

function UnformatFields()
{
	add_expense.M1.value = filterNum(add_expense.M1.value);
	add_expense.M2.value = filterNum(add_expense.M2.value);
	add_expense.M3.value = filterNum(add_expense.M3.value);
	add_expense.M4.value = filterNum(add_expense.M4.value);
	add_expense.M5.value = filterNum(add_expense.M5.value);
	add_expense.M6.value = filterNum(add_expense.M6.value);
	add_expense.M7.value = filterNum(add_expense.M7.value);
	add_expense.M8.value = filterNum(add_expense.M8.value);
	add_expense.M9.value = filterNum(add_expense.M9.value);
	add_expense.M10.value = filterNum(add_expense.M10.value);
	add_expense.M11.value = filterNum(add_expense.M11.value);
	add_expense.M12.value = filterNum(add_expense.M12.value);
}
</script>
