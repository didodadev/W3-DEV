<cfinclude template="../query/get_training_sec_names.cfm">
<cfinclude template="../query/get_training_eval_quizs.cfm">
<cfquery name="GET_TRAINING_SEC" datasource="#dsn#">
	SELECT TRAINING_SEC_ID,SECTION_NAME FROM TRAINING_SEC
</cfquery>
<cfquery name="GET_TRAINING_CAT" datasource="#dsn#">
	SELECT TRAINING_CAT_ID,TRAINING_CAT FROM TRAINING_CAT
</cfquery>
<cf_popup_box title="#getLang('training_management',220)#">
<cfform name="add_new_class" method="post" action="#request.self#?fuseaction=training_management.emptypopup_add_excused_class">
	<cfif isdefined("attributes.list_excused") and len(attributes.list_excused)>
		<input type="hidden" name="joiners" id="joiners" value="<cfoutput>#attributes.list_excused#</cfoutput>">
	</cfif>
	<cfif isdefined("attributes.list_excused_par") and len(attributes.list_excused_par)>
		<input type="hidden" name="joiners_par" id="joiners_par" value="<cfoutput>#attributes.list_excused_par#</cfoutput>">
	</cfif>
	<cfif isdefined("attributes.list_excused_con") and len(attributes.list_excused_con)>
		<input type="hidden" name="joiners_con" id="joiners_con" value="<cfoutput>#attributes.list_excused_con#</cfoutput>">
	</cfif>
	<div class="row">
		<div class="form-group">
			<label class="col col-2 col-xs-12"><cf_get_lang_main no='7.Eğitim'>*</label>
			<div class="col col-10 col-xs-12">
				<cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
				<cfinput type="text" name="class_name" required="Yes" message="#message#" maxlength="100">
			</div>
		</div>
		<div class = "col col-12 paddingNone">
			<div class = "col col-6 paddingNone">
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang_main no="1447.Süreç"></label>
					<div class="col col-8 col-xs-12">
						<cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
					</div>
				</div>
			</div>
			<div class = "col col-6 paddingNone">
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang no='23.Eğitimci'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="emp_id" id="emp_id" value="">
							<input type="hidden" name="par_id" id="par_id" value="">
							<input type="hidden" name="member_type" id="member_type" value="">
							<input type="text" name="emp_par_name" id="emp_par_name" value="" readonly>
							<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_new_class.emp_id&field_name=add_new_class.emp_par_name&field_type=add_new_class.member_type&field_partner=add_new_class.par_id&select_list=1,2</cfoutput>','list');"></span>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class = "col col-12 paddingNone">
			<div class = "col col-6 paddingNone">
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang_main no='74.Kategori'>*</label>
					<div class="col col-8 col-xs-12">
						<select name="training_cat_id" id="training_cat_id" onchange="showSection(this.value);">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="get_training_cat"> 
								<option value="#training_cat_id#">#TRAINING_CAT#</option>
							</cfoutput> 
						</select>
					</div>
				</div>
			</div>
			<div class = "col col-6 paddingNone">
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang_main no='583.Bölüm'>*</label>
					<div class="col col-8 col-xs-12" id="SECTION_PLACE">
						<select name="training_sec_id" id="training_sec_id">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="get_training_sec"> 
								<option value="#training_sec_id#">#section_name#</option>
							</cfoutput> 
						</select>
					</div>
				</div>
			</div>
		</div>
		<div class = "col col-12 paddingNone">
			<div class = "col col-6 paddingNone">
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang_main no='89.Başlangıç'></label>
					
					<div class = "col col-8">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='641.başlangıç tarihi'></cfsavecontent>
							<cfinput validate="#validate_style#" message="#message#" type="text" name="start_date" maxlength="10">
							<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
						</div>
					</div>
				</div>
			</div>
			<div class = "col col-6 paddingNone">
				<div class = "col col-4">
					<div class="form-group">
						<label><cf_get_lang no='119.saat / dk'></label>
					</div>
				</div>
				<div class = "col col-4">
					<div class="form-group">
						<select name="event_start_clock" id="event_start_clock">
							<option value="0" selected><cf_get_lang_main no='79.Saat'></option>
							<cfloop from="7" to="30" index="i">
								<cfset saat=i mod 24>
								<option value="<cfoutput>#saat#</cfoutput>"><cfoutput>#saat#</cfoutput></option>
							</cfloop>
						</select>
					</div>
				</div>
				<div class = "col col-4">
					<div class="form-group">
						<select name="event_start_minute" id="event_start_minute">
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
		</div>
		<div class = "col col-12 paddingNone">
			<div class = "col col-6 paddingNone">
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang_main no='90.Bitiş'></label>
					
					<div class = "col col-8">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='288.bitis tarihi'></cfsavecontent>
							<cfinput type="text" name="finish_date" message="#message#" validate="#validate_style#" maxlength="10">
							<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
						</div>
					</div>
				</div>
			</div>
			<div class = "col col-6 paddingNone">
				<div class = "col col-4">
					<div class="form-group">
						<label><cf_get_lang no='119.saat / dk'></label>
					</div>
				</div>
				<div class = "col col-4">
					<div class="form-group">
						<select name="event_finish_clock" id="event_finish_clock" style="width:73px;">
							<option value="0" selected><cf_get_lang_main no='79.Saat'></option>
							<cfloop from="7" to="30" index="i">
								<cfset saat=i mod 24>
								<option value="<cfoutput>#saat#</cfoutput>"><cfoutput>#saat#</cfoutput></option>
							</cfloop>
						</select>
					</div>
				</div>
				<div class = "col col-4">
					<div class="form-group">
						<select name="event_finish_minute" id="event_finish_minute" style="width:73px;">
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
		</div>
		<div class = "col col-12 paddingNone">
			<div class = "col col-6 paddingNone">
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang no='170.Toplam Saat'>*</label>
					<div class="col col-8 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='170.Toplam Saat'></cfsavecontent>
						<cfinput type="text" name="HOUR_NO" style="width:150px;" required="Yes" message="#message#" maxlength="100">
					</div>
				</div>
			</div>
			<div class = "col col-6 paddingNone">
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang no='169.Toplam Gün'> *</label>
					<div class="col col-8 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='169.toplam Gün'></cfsavecontent>
						<cfinput type="text" name="DATE_NO" style="width:150px;" required="Yes" message="#message#" maxlength="100">
					</div>
				</div>
			</div>
		</div>
	</div>
	<cf_popup_box_footer>
		<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
	</cf_popup_box_footer>
</cfform>
</cf_popup_box>
<script type="text/javascript">
function check()
{
	if ( (add_new_class.start_date.value != "") && (add_new_class.finish_date.value != "") )
		return time_check(add_new_class.start_date, add_new_class.event_start_clock, add_new_class.event_start_minute, add_new_class.finish_date,  add_new_class.event_finish_clock, add_new_class.event_finish_minute, "<cf_get_lang_main no='1450.Başlangıç tarihi bitiş tarihinden önce olmalıdır !'>");
	return true;
}
function showSection(cat_id)	
	{
		var cat_id = document.add_new_class.training_cat_id.value;
		if (cat_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.popup_ajax_list_section&cat_id="+cat_id;
			AjaxPageLoad(send_address,'SECTION_PLACE',1,'İlişkili Bölümler');
		}
	}
function kontrol()
{
	if (!process_cat_control()) return false;
	if(add_new_class.start_date.value == "")
	{
		alert("<cf_get_lang_main no='326.Başlangıç Tarihi Girmelisiniz'>");
		return false;
	}
	if(add_new_class.finish_date.value == "")
	{
		alert ("<cf_get_lang_main no='327.Bitiş Tarihi Girmelisiniz'>");
		return false;
	}
	if (document.add_new_class.training_cat_id.value =='' || document.add_new_class.training_cat_id.value == 0)
	{
		alert("<cf_get_lang_main no='1535.kategori seçiniz'>!");
		return false;
	}
	if (document.add_new_class.training_sec_id.value =='' || document.add_new_class.training_sec_id.value == 0)
	{
		alert("<cf_get_lang_main no='583.bölüm'>!");
		return false;
	}
	return check();
}
</script>

