<cf_box title="#getLang('','Eğitimci',30935)# #getLang('','Ekle',44630)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_class_trainers" method="post" action="#request.self#?fuseaction=training_management.emptypopup_add_class_trainers">
		<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#class_id#</cfoutput>">
		<cf_box_elements>
	
				<div class="col col-6 col-xs-12 col-md-6 col-sm-6">
					<div class="form-group" id="item-emp_par_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30935.Eğitimci'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="emp_id" id="emp_id" value="">
								<input type="hidden" name="par_id" id="par_id" value="">
								<input type="hidden" name="cons_id" id="cons_id" value="">
								<input type="hidden" name="member_type" id="member_type" value="">
								<input type="text" name="emp_par_name" id="emp_par_name" value="" onFocus="AutoComplete_Create('emp_par_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2,3\',0,0,0','EMPLOYEE_ID,PARTNER_ID,CONSUMER_ID','emp_id,par_id,cons_id','add_class_trainers','3','110');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_class_trainers.emp_id&field_name=add_class_trainers.emp_par_name&field_type=add_class_trainers.member_type&field_partner=add_class_trainers.par_id&field_consumer=add_class_trainers.cons_id&select_list=1<cfif get_module_user(4)>,2,8</cfif></cfoutput>');"></span>
							</div>
						</div>
					</div>
				</div>
		
		</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' add_function="kontrol()">
				</cf_box_footer>
	</cfform>
	</cf_box>
	<script type="text/javascript">
		function kontrol()
		{
			if ($("#emp_id").val() == '' && $("#par_id").val() == '' && $("#cons_id").val() == '')
			{
				alert('<cf_get_lang dictionary_id='30935.Eğitimci'> <cf_get_lang dictionary_id='57734.Seçiniz'>!');
				return false;
			}
			return true;
		}
	</script>
	