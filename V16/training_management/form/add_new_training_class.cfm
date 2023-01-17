<cf_popup_box title="#getLang('main',64)#">
	<cfform method="POST" name="add_class" action="#request.self#?fuseaction=training_management.emptypopup_add_new_training_class">
		<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#attributes.class_id#</cfoutput>">
		<div class="row">
			<div class="col col-5 col-sm-12 col-xs-12">
				<div class="col col-12 col-sm-12 col-xs-12">
					<div class="form-group col col-12" id="item-class_name">
						<div class="col col-2 col-sm-12 col-xs-12 "><cf_get_lang_main no='7.Eğitim'>*</div>
						<div class="col col-10 col-sm-12 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1408.başlık'></cfsavecontent>
							<cfinput type="text" name="class_name" style="width:355px;" required="Yes" message="#message#" maxlength="100">
						</div>
					</div>
				</div>
				<div class="col col-12 col-sm-12 col-xs-12">
					<div class="form-group col col-6" id="item-start_date">
						<div class="col col-4 col-sm-12 col-xs-12"><cf_get_lang_main no='89.başlama'></div>
						<div class="col col-8 col-sm-12 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='641.başlangıç tarihi'></cfsavecontent>
								<cfinput  validate="#validate_style#" message="#message#" type="text" name="start_date" style="width:150px;" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
							</div>
						</div>
					</div>
					<div class="form-group col col-6" id="item-event_start_clock">
						<div class="col col-4 col-sm-12 col-xs-12"><cf_get_lang no='119.saat / dk'></div>
						<div class="col col-4 col-sm-6 col-xs-12">
							<select name="event_start_clock" id="event_start_clock" style="width:54px;">
								<option value="0" selected><cf_get_lang_main no='79.Saat'></option>
								<cfloop from="7" to="30" index="i">
									<cfset saat=i mod 24>
									<option value="<cfoutput>#saat#</cfoutput>"><cfoutput>#saat#</cfoutput></option>
								</cfloop>
							</select>&nbsp;
						</div>
						<div class="col col-4 col-sm-6 col-xs-12">
							<select name="event_start_minute" id="event_start_minute" style="width:54px;">
								<option value="00" selected>00</option>
								<option value="05">05</option>
								<option value="10">10</option>
								<option value="15">15</option>
								<option value="20">20</option>
								<option value="25">25</option>
								<option value="30">30</option>
								<option value="35">35</option>
								<option value="40">40</option>
								<option value="45">45</option>
								<option value="50">50</option>
								<option value="55">55</option>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-12 col-sm-12 col-xs-12">
					<div class="form-group col col-6" id="item-finish_date">
						<div class="col col-4 col-sm-12 col-xs-12"><cf_get_lang_main no='90.bitis'></div>
						<div class="col col-8 col-sm-12 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='288.bitis tarihi'></cfsavecontent>
								<cfinput type="text" name="finish_date" style="width:150px;"  message="#message#" validate="#validate_style#" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
							</div>
						</div>
					</div>
					<div class="form-group col col-6" id="item-event_finish_clock">			
						<div class="col col-4 col-sm-12 col-xs-12"><cf_get_lang no='119.saat / dk'></div>
						<div class="col col-4 col-sm-6 col-xs-12">
							<select name="event_finish_clock" id="event_finish_clock" style="width:54px;">
								<option value="0" selected><cf_get_lang_main no='79.Saat'></option>
								<cfloop from="7" to="30" index="i">
									<cfset saat=i mod 24>
									<option value="<cfoutput>#saat#</cfoutput>"><cfoutput>#saat#</cfoutput></option>
								</cfloop>
							</select>&nbsp; 
						</div>
						<div class="col col-4 col-sm-6 col-xs-12">
							<select name="event_finish_minute" id="event_finish_minute" style="width:54px;">
								<option value="00" selected>00</option>
								<option value="05">05</option>
								<option value="10">10</option>
								<option value="15">15</option>
								<option value="20">20</option>
								<option value="25">25</option>
								<option value="30">30</option>
								<option value="35">35</option>
								<option value="40">40</option>
								<option value="45">45</option>
								<option value="50">50</option>
								<option value="55">55</option>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-12 col-sm-12 col-xs-12">
					<div class="form-group col col-6" id="item-emp_par_name">
						<div class="col col-4 col-sm-12 col-xs-12"><cf_get_lang no='23.Eğitimci'></div>
						<div class="col col-8 col-sm-12 col-xs-12">
							<div class="input-group">
									<input type="hidden" name="emp_id" id="emp_id" value="">
									<input type="hidden" name="par_id" id="par_id" value="">
									<input type="hidden" name="cons_id" id="cons_id" value="">
									<input type="hidden" name="member_type" id="member_type" value="">
									<input type="text" name="emp_par_name" id="emp_par_name" value="" style="width:150;" readonly>
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_class.emp_id&field_name=add_class.emp_par_name&field_type=add_class.member_type&field_partner=add_class.par_id&field_consumer=add_class.cons_id&select_list=1<cfif get_module_user(4)>,2,8</cfif></cfoutput>','list');"></span>
							</div>
						</div>
					</div>	
					<div class="form-group col col-6" id="item-period">		
						<div class="col col-4 col-sm-12 col-xs-12"><cf_get_lang_main no="1447.Süreç"></div>
						<div class="col col-8 col-sm-12 col-xs-12"><cf_workcube_process is_upd='0' process_cat_width='111' is_detail='0'></div> 
					</div>
				</div>
			</div>
		</div>
		<cf_popup_box_footer><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cf_popup_box_footer>
	</cfform>
</cf_popup_box>
<script type="text/javascript">
function kontrol()
{
	if (!process_cat_control()) return false;
}
</script>
