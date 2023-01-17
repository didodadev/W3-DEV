<cfsavecontent variable="message"><cf_get_lang dictionary_id="53453.İşten Ayrılma Bildirgesi"></cfsavecontent>
<cf_box title="#message#">
<cfform name="form_job_declaration" method="post" action="#request.self#?fuseaction=ehesap.popup_new_ssk_worker_out_self">
	<cf_box_elements>
		<div class="form-group" id="item-employee">
			<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
			<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
				<div class="input-group">
				<input type="hidden" name="employee_id" id="employee_id" value="">
				<input type="hidden" name="in_out_id" id="in_out_id" value="">
				<input type="hidden" name="branch_id" id="branch_id" value="">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='29498.çalışan girmelisiniz'></cfsavecontent>
				<cfinput type="text" name="employee" value="" style="width:150px;" required="Yes" message="#message#"  autocomplete="off" onFocus="AutoComplete_Create('employee','EMPLOYEE_NAME,EMPLOYEE_SURNAME,TC_IDENTY_NO,SOCIALSECURITY_NO,RETIRED_SGDP_NUMBER','FULLNAME,BRANCH_NAME','get_in_outs_autocomplete','','FULLNAME,EMPLOYEE_ID,IN_OUT_ID','employee,employee_id,in_out_id','form_job_declaration','3','300');">
				<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=form_job_declaration.in_out_id&field_emp_id=form_job_declaration.employee_id&field_emp_name=form_job_declaration.employee&field_branch_id=form_job_declaration.branch_id','list');"></cfoutput></span>
			</div>
			</div>
		</div>
	</cf_box_elements>
	<cf_box_footer>
		<cfsavecontent variable="button_name"><cf_get_lang dictionary_id ='54177.Bildirge Düzenle'></cfsavecontent>
			<cf_workcube_buttons is_upd='0' insert_info='#button_name#' is_cancel='0' insert_alert=''>
	</cf_box_footer>	
</cfform>
</cf_box>
