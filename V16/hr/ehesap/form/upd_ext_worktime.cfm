<!--- Fazla mesai xml --->
<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
<cfset get_day_control = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.list_ext_worktimes',
    property_name : 'is_day_control'
    )
>

<!--Muzaffer Bas-->
<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
    <cfset Akdi_Gun_FM = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.form_upd_program_parameters',
    property_name : 'x_akdi_day_work'
    )>
	<cfset x_akdi_day_work = Akdi_Gun_FM.PROPERTY_VALUE>

	<cfset Hafta_tatili_FM = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.form_upd_program_parameters',
    property_name : 'x_weekly_day_work'
    )>
	<cfset x_weekly_day_work = Hafta_tatili_FM.PROPERTY_VALUE>

	<cfset Resmi_Tatil_Gun = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.form_upd_program_parameters',
    property_name : 'x_official_day_work'
    )>
	<cfset x_official_day_work = Resmi_Tatil_Gun.PROPERTY_VALUE>

	<cfset Arefe_Gun_FM = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.form_upd_program_parameters',
    property_name : 'x_Arefe_day_work'
    )>
	<cfset x_Arefe_day_work = Arefe_Gun_FM.PROPERTY_VALUE>

	<cfset Dini_Gun_FM = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.form_upd_program_parameters',
    property_name : 'x_Dini_day_work'
    )>
	<cfset x_Dini_day_work = Dini_Gun_FM.PROPERTY_VALUE>
<!--Muzaffer Bit-->
<cfif get_day_control.recordcount>
	<cfset is_day_control = get_day_control.property_value>
<cfelse>
	<cfset is_day_control = 0>
</cfif>
<cfset fuseaction = listFirst(attributes.fuseaction,".")>
<cfif fuseaction eq 'myhome'>
	<cfset attributes.ewt_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.ewt_id,accountKey:'wrk')>
<cfelse>
	<cfset attributes.ewt_id = attributes.ewt_id>
</cfif>
 <cf_catalystHeader>
<cfinclude template="../query/get_ext_worktime.cfm">
<cfif fusebox.circuit neq 'myhome'>
    <cfsavecontent variable="img">
    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_dsp_employees_ext_worktimes_history&ewt_id=#attributes.ewt_id#</cfoutput>','wide');"><img src="/images/history.gif"  alt="<cf_get_lang_main no='61.Tarihçe'>"></a>
    <a href="<cfoutput>#request.self#?fuseaction=ehesap.popup_form_add_ext_worktime"></cfoutput><img src="/images/plus1.gif" title="<cf_get_lang dictionary_id='53018.Çalışan Fazla Mesai Süresi Ekle'>"></a></cfsavecontent>
<cfelse>
	<cfsavecontent variable="img"><a href="<cfoutput>#request.self#?fuseaction=myhome.form_add_ext_worktime_popup"></cfoutput><img src="/images/plus1.gif" title="<cf_get_lang dictionary_id='53018.Çalışan Fazla Mesai Süresi Ekle'>"></a></cfsavecontent>
</cfif>
<cfif not get_ext_worktime.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'>!</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../../dsp_hata.cfm">
<cfelse>
<div class="col col-12 col-xs-12">
		<cfsavecontent variable="title"><cf_get_lang dictionary_id='38224.Fazla Mesai'><cf_get_lang dictionary_id='57703.Güncelleme'></cfsavecontent>
		<cfif fusebox.circuit neq 'myhome'>
			<cfset list="#request.self#?fuseaction=ehesap.list_ext_worktimes">
		<cfelse>
			<cfset list="#request.self#?fuseaction=myhome.list_my_extra_times">
		</cfif>
		<cf_box>
			<cfform name="add_worktime" action="#request.self#?fuseaction=ehesap.emptypopup_upd_ext_worktime" method="post">
				<input type="hidden" name="ewt_id" id="ewt_id" value="<cfoutput>#attributes.ewt_id#</cfoutput>">
				<cf_box_elements>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-employee_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="in_out_id" id="in_out_id" value="<cfoutput>#get_ext_worktime.IN_OUT_ID#</cfoutput>">
									<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_ext_worktime.EMPLOYEE_ID#</cfoutput>">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='29498.çalışan girmelisiniz'></cfsavecontent>
									<cfinput name="EMPLOYEE" id="EMPLOYEE" type="text" style="width:150px;" required="yes" message="#message#" value="#get_ext_worktime.employee_name# #get_ext_worktime.employee_surname#">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=add_worktime.in_out_id&field_emp_name=add_worktime.EMPLOYEE&field_emp_id=add_worktime.employee_id&is_active=1');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-process_stage">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
							<div class="col col-8 col-xs-12">
								<cf_workcube_process is_upd='0' select_value='#get_ext_worktime.process_stage#' process_cat_width='150' is_detail='1'>	
							</div>
						</div>
						<div class="form-group" id="item-Shift_Status">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30866.Mesai'><cf_get_lang dictionary_id='42004.Karşılığı'></label>
							<div class="col col-8 col-xs-12">                  
								<select name="Shift_Status"  onchange="tik();" id="Shift_Status" style="width:150px;">
									<option value=""><cf_get_lang Dictionary_id='57734.Seçiniz'></option>
									<option value="1" <cfif get_ext_worktime.WORKTIME_WAGE_STATU eq 1>selected</cfif>><cf_get_lang dictionary_id='63585.Serbest Zaman'></option>
									<option value="2" <cfif get_ext_worktime.WORKTIME_WAGE_STATU eq 2>selected</cfif>><cf_get_lang dictionary_id='59683.Ucret eklensin'></option>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-Working_Location">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32327.Çalışma'></label>
							<div class="col col-8 col-xs-12">                    
								<select name="Working_Location" id="Working_Location" style="width:150px;">
									<option value=""><cf_get_lang Dictionary_id='57734.Seçiniz'></option>
									<option value="1" <cfif get_ext_worktime.WORKING_SPACE eq 1>selected</cfif>><cf_get_lang dictionary_id='38672.Kurum İçi'></option>
									<option value="2" <cfif get_ext_worktime.WORKING_SPACE eq 2>selected</cfif>><cf_get_lang dictionary_id='38449.Kurum Dışı'>-<cf_get_lang dictionary_id='38447.Şehir İçi'></option>
									<option value="3" <cfif get_ext_worktime.WORKING_SPACE eq 3>selected</cfif>><cf_get_lang dictionary_id='38449.Kurum Dışı'>-<cf_get_lang dictionary_id='38448.Yurt İçi'></option>
									<option value="4" <cfif get_ext_worktime.WORKING_SPACE eq 4>selected</cfif>><cf_get_lang dictionary_id='38449.Kurum Dışı'>-<cf_get_lang dictionary_id='39476.Yurt Dışı'></option>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-work_startdate">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55753.Çalışma Günü'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='55753.Çalışma Günü'></cfsavecontent>
									<cfinput type="text" name="work_startdate" id="work_startdate" style="width:150px;" value="#dateformat(get_ext_worktime.work_start_time,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" required="yes">
									<span class="input-group-addon">
										<cfif is_day_control eq 1>
											<cf_wrk_date_image date_field="work_startdate" call_function="control">
										<cfelse>
											<cf_wrk_date_image date_field="work_startdate">
										</cfif>
									</span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-startdate">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60723.Bordro Tarihi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.başlama girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="startdate" id="startdate" style="width:150px;" value="#dateformat(get_ext_worktime.start_time,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" required="yes">
									<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-start_hour">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57501.Başlangıç'></label>
							<div class="col col-4 col-xs-12">
								<cfif len(get_ext_worktime.start_time) and timeformat(get_ext_worktime.start_time,'HH')>
									<cf_wrkTimeFormat name="start_hour" value="#timeformat(get_ext_worktime.start_time,'HH')#">
								<cfelse>
									<cf_wrkTimeFormat name="start_hour" value="0">
								</cfif>
							</div>
							<div class="col col-4 col-xs-12">
								<select name="start_min" id="start_min">
									<option value="0"><cf_get_lang dictionary_id='58827.Dk'></option>
									<cfloop from="1" to="59" index="i">
										<cfoutput><option value="#i#" <cfif timeformat(get_ext_worktime.start_time,'MM') eq i>selected</cfif>>#i#</option></cfoutput>
									</cfloop>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-end_hour">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş'></label>
							<div class="col col-4 col-xs-12">
								<cfif len(get_ext_worktime.end_time) and timeformat(get_ext_worktime.end_time,'HH')>
									<cf_wrkTimeFormat name="end_hour" value="#timeformat(get_ext_worktime.end_time,'HH')#">
								<cfelse>
									<cf_wrkTimeFormat name="end_hour" value="0">
								</cfif>
							</div>
							<div class="col col-4 col-xs-12">
								<select name="end_min" id="end_min">
									<option value="0"><cf_get_lang dictionary_id='58827.Dk'></option>
									<cfloop from="1" to="59" index="i">
										<cfoutput><option value="#i#" <cfif timeformat(get_ext_worktime.end_time,'MM') eq i>selected</cfif>>#i#</option></cfoutput>
									</cfloop>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-day_type">
							<label class="col col-4 col-xs-12">&nbsp;</label>
							<div class="col col-8 col-xs-12">
								<label><input type="radio" name="day_type" id="day_type" value="0"<cfif get_ext_worktime.DAY_TYPE EQ 0> checked</cfif>> <cfif fusebox.circuit eq 'myhome'><cf_get_lang dictionary_id='53727.Çalışma Günü'><cfelse><cf_get_lang dictionary_id='53727.Çalışma Günü'></cfif></label>
								<label><input type="radio" name="day_type" id="day_type" value="1"<cfif get_ext_worktime.DAY_TYPE EQ 1> checked</cfif>> <cfif fusebox.circuit eq 'myhome'><cf_get_lang dictionary_id='58867.Hafta Tatili'><cfelse><cf_get_lang dictionary_id='58867.Hafta Tatili'></cfif></label>
								<label><input type="radio" name="day_type" id="day_type" value="2"<cfif get_ext_worktime.DAY_TYPE EQ 2> checked</cfif>> <cfif fusebox.circuit eq 'myhome'><cf_get_lang dictionary_id='31473.Resmi Tatil'><cfelse><cf_get_lang dictionary_id='31473.Resmi Tatil'></cfif></label>
								<label><input type="radio" name="day_type" id="day_type" value="3"<cfif get_ext_worktime.DAY_TYPE EQ 3> checked</cfif>> <cfif fusebox.circuit eq 'myhome'><cf_get_lang dictionary_id='54251.Gece Çalışması'><cfelse><cf_get_lang dictionary_id='54251.Gece Çalışması'></cfif></label>
								<!---Muzaffer Bas--->	
								<cfif x_weekly_day_work eq 1>
									<label><input type="radio" name="day_type" id="day_type" value="-8"<cfif get_ext_worktime.DAY_TYPE EQ -8> checked</cfif>> <cfif fusebox.circuit eq 'myhome'>Hafta Tatili-Gün<cfelse>Hafta Tatili-Gün</cfif></label>
								</cfif>
								<cfif x_akdi_day_work eq 1>
									<label><input type="radio" name="day_type" id="day_type" value="-9"<cfif get_ext_worktime.DAY_TYPE EQ -9> checked</cfif>> <cfif fusebox.circuit eq 'myhome'>Akdi Tatil-Gün<cfelse>Akdi Tatil-Gün</cfif></label>
								</cfif>
							    <cfif x_Arefe_day_work eq 1>
									<label><input type="radio" name="day_type" id="day_type" value="-11"<cfif get_ext_worktime.DAY_TYPE EQ -11> checked</cfif>> <cfif fusebox.circuit eq 'myhome'>Arefe Tatil-Gün <cfelse>Arefe Tatil-Gün</cfif></label>
								</cfif>
								<cfif x_official_day_work eq 1>
									<label><input type="radio" name="day_type" id="day_type" value="-10"<cfif get_ext_worktime.DAY_TYPE EQ -10> checked</cfif>> <cfif fusebox.circuit eq 'myhome'>Resmi Tatil-Gün <cfelse>Resmi Tatil-Gün</cfif></label>
								</cfif>
								
								<cfif x_Dini_day_work eq 1>
									<label><input type="radio" name="day_type" id="day_type" value="-12"<cfif get_ext_worktime.DAY_TYPE EQ -12> checked</cfif>> <cfif fusebox.circuit eq 'myhome'>Dini Bayram-Gün <cfelse>Dini Bayram-Gün</cfif></label>
								</cfif>
							<!---Muzaffer Bit--->
							</div>
						</div>
						<cfif get_ext_worktime.is_from_pdks eq 1>
						<div class="form-group" id="item-onaylandı">
							<label class="col col-4 col-xs-12"><cfoutput>#getLang('main',88)#</cfoutput> 1</label>
							<div class="col col-8 col-xs-12">
								<cfif len(get_ext_worktime.validator_position_code_1)>
									<cfset pos_temp_1 = "#get_emp_info(get_ext_worktime.validator_position_code_1,1,0)#">
								<cfelse>
									<cfset pos_temp_1 = "">
								</cfif> 
								<cfif get_ext_worktime.valid_1 EQ 1>
										<cf_get_lang dictionary_id="58699.Onaylandı"> !
										<cfoutput>#pos_temp_1#</cfoutput><br/>
										<strong><cfoutput>#get_ext_worktime.valid_1_detail#</cfoutput></strong>
								<cfelseif get_ext_worktime.valid_1 EQ 0>
										<cf_get_lang dictionary_id='57617.Reddedildi'> !
										<cfoutput>#pos_temp_1#</cfoutput><br/>
										<strong><cfoutput>#get_ext_worktime.valid_1_detail#</cfoutput></strong>
								<cfelse>
										<cf_get_lang dictionary_id="57615.Onay Bekliyor"> !
										<cfoutput>#pos_temp_1#</cfoutput>
								</cfif>
							</div>
						</div>
						<div class="form-group" id="item-onaybekle">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57500.Onay"> 2</label>
							<div class="col col-8 col-xs-12">
								<cfif len(get_ext_worktime.validator_position_code_2)>
									<cfset pos_temp_2 = "#get_emp_info(get_ext_worktime.validator_position_code_2,1,0)#">
								<cfelse>
									<cfset pos_temp_2 = "">
								</cfif> 
								<cfif len(get_ext_worktime.validator_position_code_2) and (get_ext_worktime.valid_1 eq 1)>
									<cfif get_ext_worktime.valid_2 EQ 1>
										<cf_get_lang dictionary_id="58699.Onaylandı"> !
											<cfoutput>#pos_temp_2#</cfoutput>
											<br/>
											<strong><cfoutput>#get_ext_worktime.valid_2_detail#</cfoutput></strong>
									<cfelseif get_ext_worktime.valid_2 EQ 0>
											<cf_get_lang dictionary_id='57617.Reddedildi'> !
											<cfoutput>#pos_temp_2#</cfoutput>
											<br/>
											<strong><cfoutput>#get_ext_worktime.valid_2_detail#</cfoutput></strong>
									<cfelseif get_ext_worktime.validator_position_code_2 eq session.ep.position_code>
										<cf_get_lang dictionary_id="57615.Onay Bekliyor"> !
										<cfoutput>#pos_temp_2#</cfoutput>
									<cfelse>
										<cf_get_lang dictionary_id="57615.Onay Bekliyor"> !
										<cfoutput>#pos_temp_2#</cfoutput>
									</cfif>
									<cfelseif len(get_ext_worktime.validator_position_code_2) and (get_ext_worktime.valid_1 eq 0)>
										<cfoutput>#get_emp_info(get_ext_worktime.validator_position_code_2,1,0)#</cfoutput>
									</cfif>
							</div>
						</div>
						</cfif>
						<div class="form-group" id="item-valid_detail">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-8 col-xs-12">
								<textarea name="valid_detail" id="valid_detail" style="width:150px;height:60px;"><cfoutput>#get_ext_worktime.valid_detail#</cfoutput></textarea>
							</div>
						</div>
						<cfif fusebox.circuit neq 'myhome'>
							<div class="form-group" id="item-is_puantaj_off">
								<label class="col col-4 col-xs-12">&nbsp;</label>
								<div class="col col-8 col-xs-12">
									<input type="checkbox" value="1" id="is_puantaj_off" name="is_puantaj_off" <cfif get_ext_worktime.is_puantaj_off eq 1>checked</cfif>><cf_get_lang no ='716.Puantajda Görüntülenmesin'>
								</div>
							</div>
						<cfelse>
							<input type="hidden" value="<cfoutput>#get_ext_worktime.is_puantaj_off#</cfoutput>" name="is_puantaj_off" id="is_puantaj_off">
						</cfif>
						<cfif len(get_ext_worktime.valid) and fusebox.circuit neq 'myhome'><!---20131026 GSO--->
							<div class="form-group" id="item-onay">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57500.Onay'></label>
								<div class="col col-8 col-xs-12">
									<cfif get_ext_worktime.valid EQ 1>
										<cf_get_lang dictionary_id='58699.Onaylandı'> !
										<cfoutput>
										#get_emp_info(get_ext_worktime.VALID_EMPLOYEE_ID,0,0)# 
										#dateformat(date_add('h',session.ep.time_zone,get_ext_worktime.validdate),dateformat_style)#
										(#timeformat(date_add('h',session.ep.time_zone,get_ext_worktime.validdate),timeformat_style)#)
										</cfoutput>
									<cfelseif get_ext_worktime.valid EQ 0>
										<cf_get_lang dictionary_id='57617.Reddedildi'>!
										<cfoutput>#get_emp_info(get_ext_worktime.VALID_EMPLOYEE_ID,0,0)# 
										#dateformat(date_add('h',session.ep.time_zone,get_ext_worktime.validdate),dateformat_style)#
										(#timeformat(date_add('h',session.ep.time_zone,get_ext_worktime.validdate),timeformat_style)#)
										</cfoutput>
									</cfif>
								</div>
							</div>
						</cfif>
					</div>
				</cf_box_elements>
				<cfsavecontent variable="deletealert"><cf_get_lang dictionary_id="41830.Fazla Mesai Siliyorsunuz! Emin misiniz?"></cfsavecontent>
				<cf_box_footer>	
					<cf_record_info query_name="get_ext_worktime">
					<cfif attributes.fuseaction neq 'ehesap.list_ext_worktimes'>
						<cfif get_ext_worktime.record_emp eq session.ep.userid and  not len(get_ext_worktime.valid) and not len(get_ext_worktime.valid_1) and not len(get_ext_worktime.valid_2)>
							<cf_workcube_buttons is_upd='1' is_delete='0' add_function='check_()' delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_ext_worktime&EWT_ID=#attributes.EWT_ID#' delete_alert='#deletealert#'>
						</cfif>
					<cfelse>
						<cf_workcube_buttons is_upd='1' is_delete='1' add_function='check_()' delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_ext_worktime&EWT_ID=#attributes.EWT_ID#' delete_alert='#deletealert#'>
					</cfif>
				</cf_box_footer>
			</cfform>
		</cf_box>
</div>			
<script type="text/javascript">
	function myfisherdatefixer(date) { let d = date.split('/'); return d[1]+'/'+d[0]+'/'+d[2]; } 
	function control()
	{
		startdate = $("#work_startdate").val();
		parameters = startdate;
		
		//Hafta Sonu Kontrolü
		startdate_format = myfisherdatefixer( $("#work_startdate").val());
		date_format = new Date(startdate_format);
		dayofweek = date_format.getDay();

		//Vardiya Kontrolü
        is_shift_holiday = 0;
        employee_id = $("#employee_id").val();
        startdate = $("#work_startdate").val();
        finishdate = $("#work_startdate").val();
        is_shift_holiday = shift_holiday_control(employee_id, startdate,finishdate);

		//Resmi Tatil Kontrolü
		get_shift_conflict = wrk_safe_query('get_general_offtimes','dsn',0,parameters);
		if(get_shift_conflict.recordcount > 0)
		{
			$("input[name=day_type][value=2]").prop("checked", true);
		}
		else if(((dayofweek == 6 || dayofweek == 0) && is_shift_holiday == 0) || is_shift_holiday == 1)
		{
			$("input[name=day_type][value=1]").prop("checked", true);
		}
		else
		{
			$("input[name=day_type][value=0]").prop("checked", true);
		}     
	}
	function tik()
	{
		<cfif fusebox.circuit neq 'myhome'>
			if (document.getElementById('Shift_Status').value == 1)
			{  
				document.getElementById('is_puantaj_off').checked = true;
			}
			else
			{
				document.getElementById('is_puantaj_off').checked = false;
			}
		<cfelse>
			if (document.getElementById('Shift_Status').value == 1)
			{  
				document.getElementById('is_puantaj_off').value = 1;
			}
			else
			{
				document.getElementById('is_puantaj_off').value = 0;
			}
		</cfif>
		
	}
	function check_()
	{
		if (document.getElementById('start_hour').value > document.getElementById('end_hour').value)
		{
			<cfif fusebox.circuit eq 'myhome'>
				alert("<cf_get_lang dictionary_id='31409.Başlangıç Saati Bitiş saatinden büyük olamaz'> !");
			<cfelse>
				alert("<cf_get_lang dictionary_id='31409.Başlangıç Saati Bitiş saatinden büyük olamaz'> !");
			</cfif>
			return false;
		}
		else if ((document.getElementById('start_hour').value == document.getElementById('end_hour').value) && (document.getElementById('start_min').value >= document.getElementById('end_min').value))
		{
			<cfif fusebox.circuit eq 'myhome'>
				alert("<cf_get_lang dictionary_id='53595.Başlangıç Saati Bitiş saatinden büyük veya eşit olamaz'> !");
			<cfelse>
				alert("<cf_get_lang dictionary_id='53595.Başlangıç Saati Bitiş saatinden büyük veya eşit olamaz'> !");
			</cfif>
			return false;
		}
		<cfif attributes.fuseaction neq 'ehesap.list_ext_worktimes'>
		return process_cat_control();
		<cfelse>
		return true;
		</cfif>
	}
</script>
</cfif>
