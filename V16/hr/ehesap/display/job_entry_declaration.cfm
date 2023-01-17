<cfsavecontent variable="message"><cf_get_lang dictionary_id="53452.İşe Giriş Bildirgesi"></cfsavecontent>
<cf_box title="#message#">
<cfform name="emp_puantaj" method="post" action="#request.self#?fuseaction=ehesap.popup_ssk_start_work">
	<cf_box_elements>
	<div class="form-group" id="item-employee">
		<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
		<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
			<div class="input-group">
			<input type="hidden" name="employee_id" value="" id="employee_id">
			<input type="hidden" name="in_out_id" value="" id="in_out_id">
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='29498.çalışan girmelisiniz'></cfsavecontent>
			<cfinput type="text" name="employee_name" id="employee_name" value="" required="yes" message="#message#" style="width:150px;" autocomplete="off" onFocus="AutoComplete_Create('employee_name','EMPLOYEE_NAME,EMPLOYEE_SURNAME,TC_IDENTY_NO,SOCIALSECURITY_NO,RETIRED_SGDP_NUMBER','FULLNAME,BRANCH_NAME','get_in_outs_autocomplete','','FULLNAME,EMPLOYEE_ID,IN_OUT_ID','employee_name,employee_id,in_out_id','emp_puantaj','3','300');">
			<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=emp_puantaj.in_out_id&field_emp_id=emp_puantaj.employee_id&field_emp_name=emp_puantaj.employee_name','list');"></span>
		</div>
	</div>
</cf_box_elements>
<cf_box_footer>
	<cfsavecontent variable="button_name"><cf_get_lang dictionary_id ='54177.Bildirge Düzenle'></cfsavecontent>
	<cf_workcube_buttons is_upd='0' insert_info='#button_name#' is_cancel='0' insert_alert=''>
</cf_box_footer>
</cfform>
</cf_box>
