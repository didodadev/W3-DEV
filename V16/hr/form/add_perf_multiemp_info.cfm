<cfsavecontent variable="message"><cf_get_lang dictionary_id="55119.Ölçme Değerlendirme Formları"></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#message#"popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="add_perf_emp_info" method="post" action="#request.self#?fuseaction=hr.form_add_perf_emp">
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<input type="hidden" name="is_form_generators" id="is_form_generators" value="<cfif isdefined("attributes.is_form_generators")><cfoutput>#attributes.is_form_generators#</cfoutput></cfif>">
					<div class="form-group" id="item-date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58472.Dönem'>*</label>
						<div class="col col-8 col-xs-12">
							<div class="col col-6 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57655.Başlangıç Tarihi'></cfsavecontent>
									<cfinput required="Yes" message="#message#" type="text" name="start_date" validate="#validate_style#" value="01/01/#session.ep.period_year#" style="width:80px;">
									<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
								</div>
							</div>
							<div class="col col-6 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
									<cfinput required="Yes" message="#message#" type="text" name="finish_date" validate="#validate_style#" value="31/12/#session.ep.period_year#" style="width:77px;">
									<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"></span>
								</div>
							</div>				
						</div>
					</div>
					<div class="form-group" id="item-date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55119.Ölçme Değerlendirme Formu'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="quiz_id" id="quiz_id" value="">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='55296.Ölçme Değerlendirme Formu seçiniz'></cfsavecontent>
								<cfinput type="text" name="quiz_name" value="" required="yes" message="#message#" readonly="true" style="width:180px;">
								<cfif isdefined("attributes.is_form_generators")>
									<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_form_generators&type=8&is_form_generators=1&field_id=add_perf_emp_info.quiz_id&field_name=add_perf_emp_info.quiz_name</cfoutput>');"> </span>
								<cfelse>
									<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_quiz&field_id=add_perf_emp_info.quiz_id&field_name=add_perf_emp_info.quiz_name</cfoutput>)"> </span>
								</cfif>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-pro">
						<cfsavecontent variable="txt_2"><cf_get_lang dictionary_id='58875.Çalışanlar'></cfsavecontent>
						<cf_workcube_to_cc is_update="0" to_dsp_name="#txt_2#" form_name="add_perf_emp_info" str_list_param="1" data_type="1"> 
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' insert_alert='' add_function='kontrol()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function kontrol()
{
	if(document.add_perf_emp_info.is_form_generators.value == 1)
	{
		add_perf_emp_info.action='<cfoutput>#request.self#?fuseaction=hr.emptypopup_add_survey_main_result_multiemp&survey_main_id='+document.add_perf_emp_info.quiz_id.value+'</cfoutput>';
	}
	if(document.add_perf_emp_info.quiz_id.value.length==0)
	{
		alert("<cf_get_lang dictionary_id='55296.Ölçme Değerlendirme Formu seçiniz'>");
		return false;
	}
//	if(document.add_perf_emp_info.employee_id.value.length==0)
//	{
//		alert("<cf_get_lang_main no='1701.Çalışan seçiniz'>");
//		return false;
//	}
	return true;
}
</script>
