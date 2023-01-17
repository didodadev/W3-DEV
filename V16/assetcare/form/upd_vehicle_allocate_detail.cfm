<cfset attributes.is_detail = 1>
<cfparam name="attributes.modal_id" default="">
<cfinclude template="../query/get_allocate.cfm">
<cfinclude template="../query/get_reasons.cfm">
<cfquery name="get_km_finish" datasource="#dsn#">
	SELECT 
		MAX(KM_CONTROL_ID) AS MAX_ID 
	FROM 
		ASSET_P_KM_CONTROL
	WHERE 
		ASSETP_ID = #get_allocate.assetp_id#
	GROUP BY 
		ASSETP_ID
</cfquery>
<cf_box title="#getLang('','Araç Tahsis Arama',48052)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#"  add_href="#request.self#?fuseaction=assetcare.popup_add_allocate_detail" is_blank='0'>
 	<cfform name="upd_allocate" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_upd_allocate&km_control_id=#km_control_id#" onsubmit="return(unformat_fields());">
  		<input type="hidden" name="is_detail" id="is_detail" value="1">
		  <cf_box_elements>
				<div class="col col-6 col-md-5 col-xs-12" type="column" index="1" sort="true">
					<input type="hidden" name="is_detail" id="is_detail" value="1">
					<div class="form-group">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='1656.Plaka'>*</label>
						<div class="col col-8  col-xs-12">
							<div class="input-group">
								<input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#get_allocate.assetp_id#</cfoutput>"> 
								<cfsavecontent variable="message1"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1656.Plaka'>!</cfsavecontent> 
								<cfinput type="text" name="assetp_name" readonly value="#get_allocate.assetp#" maxlength="50" required="yes" message="#message1#" > 
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=upd_allocate.assetp_id&field_name=upd_allocate.assetp_name&list_select=2&is_active=1','list','popup_list_ship_vehicles');"></span>
							</div>
						</div>
					</div>	
					<div class="form-group">
						<label class="col col-4 col-xs-12"><cf_get_lang no='479.Tahsis Edilen Şube'>*</label>
						<div class="col col-8  col-xs-12">
							<div class="input-group">
								<input type="hidden" name="department_id" id="department_id" value="<cfoutput>#get_allocate.department_id#</cfoutput>">
								<input type="text" name="department" id="department" readonly  value="<cfoutput>#get_allocate.branch_name# - #get_allocate.department_head#</cfoutput>"> 
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_name=upd_allocate.department&field_id=upd_allocate.department_id','list','popup_list_departments')"></span>
							</div>
						</div>
					</div>	
					<div class="form-group">
						<label class="col col-4 col-xs-12"><cf_get_lang no='480.Tahsis Edilen'>*</label>
						<div class="col col-8  col-xs-12">
							<div class="input-group">
								<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_allocate.employee_id#</cfoutput>"> 
								<cfsavecontent variable="message2"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='480.Tahsis Edilen'>!</cfsavecontent>
								<cfinput type="text" name="employee_name" value="#get_allocate.employee_name# #get_allocate.employee_surname#" readonly required="yes" message="#message2#"> 
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=upd_allocate.employee_id&field_name=upd_allocate.employee_name&select_list=1</cfoutput>','list','popup_list_positions');"></span>
							</div>
						</div>
					</div>		
					<div class="form-group">
						<label class="col col-4 col-xs-12"><cf_get_lang no='482.Tahsis Tipi'></label>
						<div class="col col-8  col-xs-12">
							<select name="allocate_reason_id" id="allocate_reason_id" >
								<option ""></option>
								<cfoutput query="get_reasons"> 
									<option value="#reason_id#" <cfif get_allocate_reasons.allocate_reason_id eq reason_id>selected</cfif>>#allocate_reason#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='243.Baş Tarihi'>*</label>
						<div class="col col-8  col-xs-12">
						<div class="col col-6 col-md-6 col-xs-6">
							<div class="input-group">
								<cfsavecontent variable="message1"> <cf_get_lang_main no='326.Başlangıç Tarihi Girmelisiniz !'></cfsavecontent> 
								<cfinput type="text" name="start_date"  value="#dateFormat(get_allocate.start_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message1#" required="yes"  readonly> 
								<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
								<cfset saat = timeFormat(get_allocate.start_date,"HH")> <cfset dak = timeFormat(get_allocate.start_date,"MM")> 
							</div>
						</div>		
						<cfoutput>
							<div class="col col-3 col-md-3 col-xs-3">
								<cf_wrkTimeFormat  name="start_hour" id="start_hour"  disable="disabled" value="#NumberFormat(saat,'00')#">	
							</div>
							<div class="col col-3 col-md-3 col-xs-3">
								<select name="start_min" id="start_min" disabled>
									<cfloop from="0" to="55" index="j" step="5">
										<option value="#j#"<cfif j eq dak>selected</cfif>>#NumberFormat(j,'00')#</option>
									</cfloop>
								</select>
							</div>	
						</cfoutput>
					</div>		

					</div>	
					<div class="form-group">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='288.Bit Tarihi'></label>
						<div class="col col-8  col-xs-12">
						<div class="col col-6 col-md-6 col-xs-6">
							<div class="input-group">
								<cfsavecontent variable="message2"> <cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='288.Bitiş Tarihi !'></cfsavecontent> 
								<cfinput type="text" name="finish_date" maxlength="10" value="#dateFormat(get_allocate.finish_date,dateformat_style)#" validate="#validate_style#" message="#message2#" required="yes" > 
								<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
								<cfset saat2 = timeFormat(get_allocate.finish_date,"HH")> 
								<cfset dak2 = timeFormat(get_allocate.finish_date,"MM")>
							</div>
						</div>	

						<cfoutput>
							<div class="col col-3 col-md-3 col-xs-3">
								<cf_wrkTimeFormat   name="finish_hour" id="finish_hour" value="#NumberFormat(saat2,'00')#" disabled>
							</div>
							<div class="col col-3 col-md-3 col-xs-3">
								<select name="finish_min" id="finish_min">
									<cfloop from="0" to="55" index="l" step="5">
										<option value="#l#"<cfif l eq dak2>selected</cfif>>#NumberFormat(l,'00')#</option>
									</cfloop>
								</select>
							</div>	
						</cfoutput>
					</div>		

					</div>
				</div>	
				<div class="col col-6 col-md-5 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group">
						<label class="col col-4 col-xs-12"><cf_get_lang no='231.Başlangıç KM'>*</label>
						<div class="col col-8  col-xs-12">
							<input type="text" name="start_km" id="start_km"  value="<cfoutput>#tlFormat(get_allocate.km_start,0)#</cfoutput>" readonly="yes">
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-12"><cf_get_lang no='237.Bitiş KM'> *</label>
						<div class="col col-8  col-xs-12">
							<cfif get_km_finish.max_id gt attributes.km_control_id>
								<input type="text" name="finish_km" id="finish_km"  readonly="yes" value="<cfoutput>#tlFormat(get_allocate.km_finish,0)#</cfoutput>" onClick="uyari();">
							<cfelse>
								<cfinput type="text" name="finish_km"  onKeyUp="FormatCurrency(this,event);" value="#tlformat(get_allocate.km_finish)#" required="yes" message="Bitiş KM Girmelisiniz!">
							</cfif>
						</div>
					</div>	
					<div class="form-group">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
						<div class="col col-8  col-xs-12">
							<textarea name="detail" id="detail" style="width:170px;height:50px;"><cfoutput>#get_allocate.allocate_detail#</cfoutput></textarea>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-12"><cf_get_lang no='358.DevamMesai Dışı'></label>
						<div class="col col-8  col-xs-12">
							<div class="input-group">
								<input type="checkbox" name="is_offtime" id="is_offtime" value="1" <cfif get_allocate.is_offtime eq 1>checked</cfif>>
							</div>
						</div>
					</div>
				</div>

			</cf_box_elements>
		<cf_box_footer>

			<div class="col col-6">
			<cf_record_info query_name="get_allocate">
			</div>

			<div class="col col-6">

				<cfif get_km_finish.max_id gt attributes.km_control_id>
					<cf_workcube_buttons is_upd='1' is_cancel='0'add_function='kontrol()' is_delete='0' delete_page_url='#request.self#?fuseaction=assetcare.emptypopup_del_vehicle_allocate&km_control_id=#attributes.km_control_id#&is_detail=#attributes.is_detail#' search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('upd_allocate' , #attributes.modal_id#)"),DE(""))#">
				<cfelse>
					<cf_workcube_buttons is_upd='1' is_cancel='0'add_function='kontrol()' is_delete='1' delete_page_url='#request.self#?fuseaction=assetcare.emptypopup_del_vehicle_allocate&km_control_id=#attributes.km_control_id#&is_detail=#attributes.is_detail#' search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('upd_allocate' , #attributes.modal_id#)"),DE(""))#">
				</cfif>
			</div>

		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
	var fld = document.upd_allocate.start_km;
	var fld2 = document.upd_allocate.finish_km;
	function unformat_fields()
	{
		document.upd_allocate.start_km.value = filterNum(document.upd_allocate.start_km.value);
		document.upd_allocate.finish_km.value = filterNum(document.upd_allocate.finish_km.value);
		document.upd_allocate.start_hour.disabled = false;
		document.upd_allocate.start_min.disabled = false;
	}

	function kontrol()
	{
		unformat_fields();
		a = filterNum(fld.value);
		b = filterNum(fld2.value);
		if(document.upd_allocate.assetp_name.value == "")
		{
			alert("Plaka Seçmelisiniz!");
			return false;
		}
		if(a > b)
		{
			alert("KM Değerini Kontrol Ediniz!");
			return false;
		}
		if(document.upd_allocate.employee_name.value == "")
		{
			alert("Sorumlu Seçmelisiniz!");
			return false;
		}
		x = (50 - upd_allocate.detail.value.length);
		if ( x < 0 )
		{ 
			alert ("<cf_get_lang_main no='217.Açıklama'> "+ ((-1) * x) +" <cf_get_lang_main no='1741.Karakter Uzun'>");
			return false;
		}
		if(!date_check(document.upd_allocate.start_date,document.upd_allocate.finish_date,"Tarih Aralığını Kontrol Ediniz!"))
		{
			return false;
		}
		return true;
	}
	function uyari()
	{
		alert("Araçla İlgili Başka KM Kayıtları Olduğu İçin KM' yi Değiştiremezsiniz!");
	}
</script>
