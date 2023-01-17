<cfinclude template="../query/get_employees_overtime.cfm">
<cfset xfa.del = "#request.self#?fuseaction=ehesap.emptypopup_del_overtime&overtime_id=#attributes.overtime_id#">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="30965.Toplu Fazla Mesai Güncelle"></cfsavecontent>
<cf_box title="#message#">
	<cfform name="upd_overtime" action="#request.self#?fuseaction=ehesap.emptypopup_upd_all_overtime" method="post">
		<cfoutput>
			<input type="hidden" name="overtime_id" value="#attributes.overtime_id#">
			<cf_box_elements>	
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
				</div>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12" style="text-align:left;" type="column" index="1" sort="true">
					<div class="form-group" id="item-employee">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'>*</label>
						<div class="col col-8 col-md-6 col-xs-12" style="margin-bottom:5px;">
							<div class="input-group">
							<input type="hidden" name="employee_id" id="employee_id" value="#get_overtime.employee_id#">
						<input type="hidden" name="in_out_id" id="in_out_id" value="#get_overtime.in_out_id#">
						<cfsavecontent variable="message"><cf_get_lang dictionary_idno="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57576.Çalışan'></cfsavecontent>
						<cfinput name="EMPLOYEE" id="EMPLOYEE" type="text" style="width:150px;" required="yes" message="#message#" readonly="yes" value="#get_emp_info(get_overtime.employee_id,0,0)#">
						<span class="input-group-addon icon-ellipsis btnPointer" onclick="javascript:windowopen('#request.self#?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=upd_overtime.in_out_id&field_emp_name=upd_overtime.EMPLOYEE&field_emp_id=upd_overtime.employee_id','list');"><img src="/images/plus_thin.gif" border="0"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-term" >
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58472.Dönem'></label>
						<div class="col col-8 col-md-6 col-xs-12" style="margin-bottom:5px;">
							<select name="term" id="term" style="width:80px;">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfloop from="#session.ep.period_year-1#" to="#session.ep.period_year+2#" index="j">
									<option value="#j#" <cfif get_overtime.overtime_period eq j>selected</cfif>>#j#</option>
								</cfloop>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-mon">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58724.Ay'></label>
						<div class="col col-8 col-md-6 col-xs-12" style="margin-bottom:5px;">
							<select name="start_mon" id="start_mon" style="width:80px;">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfloop from="1" to="12" index="j">
								<option value="#j#"<cfif get_overtime.overtime_month eq j>selected</cfif>>#listgetat(ay_list(),j,',')#</option>
							</cfloop>
						</select>
						</div>
					</div>
					<div class="form-group" id="item-overtime_value0">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='53014.Normal Gün'></label>
						<div class="col col-8 col-md-6 col-xs-12" style="margin-bottom:5px;">
							<input type="text" name="overtime_value0" id="overtime_value0" style="width:80px;" class="moneybox" value="#TLFormat(get_overtime.OVERTIME_VALUE_0,2)#" onkeyup="return(FormatCurrency(this,event,2));">
						</div>
					</div>
					<div class="form-group" id="item-overtime_value1">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='53015.Hafta Sonu'></label>
						<div class="col col-8 col-md-6 col-xs-12" style="margin-bottom:5px;">
							<input type="text" name="overtime_value1" id="overtime_value1" style="width:80px;" class="moneybox" value="#TLFormat(get_overtime.OVERTIME_VALUE_1,2)#" onkeyup="return(FormatCurrency(this,event,2));">
						</div>
					</div>
					<div class="form-group" id="item-overtime_value2">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='53016.Resmi Tatil'></label>
						<div class="col col-8 col-md-6 col-xs-12" style="margin-bottom:5px;">
							<input type="text" name="overtime_value2" id="overtime_value2" style="width:80px;" class="moneybox" value="#TLFormat(get_overtime.OVERTIME_VALUE_2,2)#" onkeyup="return(FormatCurrency(this,event,2));">
						</div>
					</div>
					<div class="form-group" id="item-overtime_value3">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='54251.Gece Çalışması'></label>
						<div class="col col-8 col-md-6 col-xs-12" style="margin-bottom:5px;">
							<input type="text" name="overtime_value3" id="overtime_value3" style="width:80px;" class="moneybox" value="#TLFormat(get_overtime.OVERTIME_VALUE_3,2)#" onkeyup="return(FormatCurrency(this,event,2));">
						</div>
					</div>
				</div>
			
			</cf_box_elements>
			<cf_box_footer>
				<cf_record_info query_name="get_overtime">
				<cf_workcube_buttons is_upd='1' delete_page_url='#xfa.del#' delete_alert='#getlang('','Kaydı Siliyorsunuz.Emin misiniz?',33700)#' add_function='check_()'>
			</cf_box_footer>
		</cfoutput>
	</cfform>
</cf_box>
<script type="text/javascript">
function check_()
{
	if(document.getElementById('term').value == "")
	{
		alert('<cf_get_lang dictionary_id="58472.Dönem">');
		return false;
	}
	if(document.getElementById('start_mon').value == "")
	{
		alert('<cf_get_lang dictionary_id="58724.Ay">');
		return false;
	}
	document.getElementById('overtime_value0').value = filterNum(document.getElementById('overtime_value0').value,4);
	document.getElementById('overtime_value1').value = filterNum(document.getElementById('overtime_value1').value,4);
	document.getElementById('overtime_value2').value = filterNum(document.getElementById('overtime_value2').value,4);
	document.getElementById('overtime_value3').value = filterNum(document.getElementById('overtime_value3').value,4);
	return true;
}
</script>
