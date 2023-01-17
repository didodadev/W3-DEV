<cf_box title="#getLang('','Eğitimi Öner',46020)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="form_add_suggest" id="form_add_suggest" method="post" action="#request.self#?fuseaction=training.emptypopup_add_suggested">
		<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#class_id#</cfoutput>">
		<cf_box_elements>
			<div class="col col-8 col-xs-8 col-md-8 col-sm-12">
				<div class="form-group" id="item-emp_par_name">
					<label class="col col-4 col-xs-4 col-md-4 col-sm-4"><cf_get_lang no='27.Önerilecek Kişi'>*</label>
					<div class="col col-8 col-xs-8 col-md-8 col-sm-8">
						<div class="input-group">
							<input type="hidden" name="emp_id" id="emp_id" value="">
							<input type="hidden" name="par_id" id="par_id" value="">
							<input type="hidden" name="cons_id" id="cons_id" value="">
							<input name="emp_par_name" id="emp_par_name" type="text" onFocus="AutoComplete_Create('emp_par_name','MEMBER_PARTNER_NAME3,MEMBER_NAME','MEMBER_PARTNER_NAME3,MEMBER_NAME','get_member_autocomplete','\'1,2,3\',\'\',\'0\',\'2\',\'2\',\'0\'','PARTNER_ID,CONSUMER_ID,EMPLOYEE_ID','par_id,cons_id,emp_id','','3','225');" value="<cfif isdefined("attributes.emp_par_name") and len(attributes.emp_par_name)>#emp_par_name#</cfif>" style="width:180px;">
							<span class="input-group-addon icon-ellipsis btnPointer"  href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=form_add_suggest.emp_id&field_name=form_add_suggest.emp_par_name&field_partner=form_add_suggest.par_id&field_consumer=form_add_suggest.cons_id&select_list=1<cfif get_module_user(4)>,2,8</cfif></cfoutput>','','ui-draggable-box-medium');"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-detail">
					<label class="col col-4 col-xs-4 col-md-4 col-sm-4"><cf_get_lang_main no='217.Açıklama'>*</label>
					<div class="col col-8 col-xs-8 col-md-8 col-sm-8">
						<textarea name="detail" id="detail" style="width:180px;height:80px;"></textarea>
					</div>
				</div>		
			</div>
		</cf_box_elements>
		<cf_box_footer><cf_workcube_buttons type_format="1" add_function="kontrol()"></cf_box_footer>
	</cfform>
</cf_box>
<script language="javascript">
	function kontrol()
	{
		if((document.getElementById('emp_id').value == "" && document.getElementById('par_id').value == "" && document.getElementById('cons_id').value == "" && document.getElementById('emp_par_name').value != ""))
		{
			alert("<cf_get_lang no='27.Önerilecek Kişi'>");
			return false;
		}
		if(document.getElementById('detail').value == "")
		{
			alert("<cf_get_lang_main no='217.Açıklama'>");
			return false;
		}
		<cfif isdefined("attributes.draggable")>
			loadPopupBox('form_add_suggest' , <cfoutput>#attributes.modal_id#</cfoutput>);
			return false;
		</cfif>
	}
</script>