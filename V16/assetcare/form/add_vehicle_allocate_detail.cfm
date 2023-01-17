<cfinclude template="../query/get_reasons.cfm">
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','Araç Tahsis Arama',48052)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<!--- <cf_box title="#getLang('','Araç Tahsis Arama',48052)#"> --->
	<cfform name="add_allocate" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_add_allocate">
<cf_box_elements>
		
			<div class="col col-6 col-md-5 col-xs-12" type="column" index="1" sort="true">
				<input type="hidden" name="is_detail" id="is_detail" value="1">
				<div class="form-group">
					<label class="col col-4  col-xs-12"><cf_get_lang_main no='1656.Plaka'>*</label>
						<div class="col col-8  col-xs-12">
						<div class="input-group">
							<input type="hidden" name="assetp_id" id="assetp_id" value=""> 
							<cfsavecontent variable="message1"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1656.Plaka'>!</cfsavecontent>
							<cfinput type="text" name="assetp_name" readonly value="" maxlength="50" required="yes" message="#message1#" style="width:166px;"> 
							<span class="input-group-addon icon-ellipsis" title="<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1656.Plaka'>" border="0" align="absmiddle" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=add_allocate.assetp_id&field_name=add_allocate.assetp_name&field_pre_km=add_allocate.pre_km&list_select=2&is_active=1&is_from_km_kontrol=1','list','popup_list_ship_vehicles');"></span>
							
							</div>
					</div>
				</div>	
				<div class="form-group">
					<label class="col col-4  col-xs-12"><cf_get_lang no='479.Tahsis Edilen Şube'>*</label>
					<input type="hidden" name="department_id" id="department_id" value="">
					<div class="col col-8  col-xs-12">
						<div class="input-group">
							<input type="text" name="department" id="department" readonly style="width:166px"> 
							<span class="input-group-addon icon-ellipsis" title="<cf_get_lang no='479.Tahsis Edilen Şube'>" align="absmiddle" border="0" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_name=add_allocate.department&field_id=add_allocate.department_id','list','popup_list_departments')"></span> 
						</div>
					</div>
				</div>	
				<div class="form-group">
					<label class="col col-4  col-xs-12"><cf_get_lang no='480.Tahsis Edilen'>*</label>
						<div class="col col-8  col-xs-12">
						<div class="input-group">
							<input type="hidden" name="employee_id" id="employee_id" value="">
							<cfsavecontent variable="message2"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='480.Tahsis Edilen'>!</cfsavecontent>
							<cfinput type="text" name="employee_name" value="" readonly required="yes" message="#message2#" style="width:166px;"> 
							<span class="input-group-addon icon-ellipsis" title="<cf_get_lang no='480.Tahsis Edilen'>" align="absmiddle" border="0" href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_allocate.employee_id&field_name=add_allocate.employee_name&select_list=1</cfoutput>','list','popup_list_positions');"></span>
						</div>
					</div>
				</div>		
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang no='482.Tahsis Tipi'></label>
					<div class="col col-8  col-xs-12">
						<select name="allocate_reason_id" id="allocate_reason_id" style="width:167px;">
							<option ""></option>
							<cfoutput query="get_reasons"> 
								<option value="#reason_id#" selected>#allocate_reason#</option>
							</cfoutput> 
						</select>
					</div>
				</div>

				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang_main no='243.Baş Tarihi'>*</label>
					<div class="col col-8  col-xs-12">
						<div class="col col-6 col-md-6 col-xs-6">
							<div class="input-group ">
								<cfsavecontent variable="message1"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='641.Başlangıç Tarihi !'></cfsavecontent> 
								<cfinput type="text" name="start_date" maxlength="10" validate="#validate_style#" message="#message1#" required="yes" style="width:65px"> 
								<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
							</div>
						</div>
							<div class="col col-3 col-md-3 col-xs-3">	
								<cf_wrkTimeFormat  name="start_hour" id="start_hour" value="#NumberFormat('0','00')#">
							</div>
						<div class="col col-3 col-md-3 col-xs-3">	
							<select name="start_min" id="start_min">
								<cfloop from="0" to="55" index="i" step="5">
									<option value=<cfoutput>"#i#"</cfoutput>><cfoutput>#NumberFormat(i,'00')#</cfoutput></option>
								</cfloop>
							</select>
						</div>
					</div>
				</div>


				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang_main no='288.Bit Tarihi'></label>
					<div class="col col-8  col-xs-12">
						<div class="col col-6 col-md-6 col-xs-6">

							<div class="input-group">
								<cfsavecontent variable="message2"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no ='330.Tarih'>!</cfsavecontent>
								<cfinput type="text" name="finish_date" maxlength="10" validate="#validate_style#" message="#message2#" style="width:65px"> 
								<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
							</div>
						</div>	
						<div class="col col-3 col-md-3 col-xs-3">
							<cf_wrkTimeFormat name="finish_hour" id="finish_hour" value="#NumberFormat('0','00')#">
						</div>	
						<div class="col col-3 col-md-3 col-xs-3">	
							<select name="finish_min" id="finish_min">
								<cfloop from="0" to="55" index="i" step="5">
									<option value=<cfoutput>"#i#"</cfoutput>><cfoutput>#NumberFormat(i,'00')#</cfoutput></option>
								</cfloop>
							</select>
						</div>
					</div>	

				</div>
			</div>	
			<div class="col col-6 col-md-5 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang no='231.Başlangıç KM'>*</label>
						<div class="col col-8  col-xs-12">
							<input type="text" name="start_km" id="start_km" style="width:170px" value="" onKeyUp="FormatCurrency(this,event);"> 
							<input type="hidden" name="pre_km" id="pre_km" value="0">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
						<div class="col col-8  col-xs-12">
						<textarea name="detail" id="detail" style="width:170px;height:50px;"></textarea>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang no='358.DevamMesai Dışı'></label>
						<div class="col col-8  col-xs-12">
						<input type="checkbox" name="is_offtime" id="is_offtime" value="1">
					</div>
				</div>
			</div>
	</cf_box_elements>

		<cf_box_footer>
			<cf_workcube_buttons type_format='1' is_upd='0' is_cancel='0'add_function='kontrol()' search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_allocate' , #attributes.modal_id#)"),DE(""))#">
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">

function kontrol()
{
	if(document.add_allocate.assetp_name.value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1656.Plaka'>!");
		return false;
	}
	if(document.add_allocate.employee_name.value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='132.Sorumlu !'>");
		return false;
	}
	
	x = (50 - add_allocate.detail.value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang_main no='217.Açıklama'> "+ ((-1) * x) +"<cf_get_lang_main no='1741.Karakter Uzun'>");
		return false;
	}
	console.log("1:",document.add_allocate.pre_km.value, document.add_allocate.start_km.value)

	if(document.add_allocate.pre_km.value == "")
	{

		alert("<cf_get_lang no='573.Bu Araca Ait Sonlandırılmamış Bir Tahsis Kaydı Var'>!");
		return false;
	}
	var x = filterNum(document.add_allocate.start_km.value);
	var y = filterNum(document.add_allocate.pre_km.value);
	if(document.add_allocate.pre_date != "")
	{
		return (global_date_check_value(document.add_allocate.pre_date.value,document.add_allocate.start_date.value,"<cf_get_lang_main no='574.Başlangıç Tarihi Son Tahsis Bitiş Tarihinden Küçük Olamaz'>!"));
	}
		
	if(document.add_allocate.finish_date.value.length != 0)
	{
		if(!date_check(document.add_allocate.start_date,document.add_allocate.finish_date,"<cf_get_lang_main no='571.Tarih Aralığını Kontrol Ediniz'>!"))
		{
			return false;
		}
	}
	if(parseFloat(x) < parseFloat(y))
	{
		alert("<cf_get_lang_main no='575.KM Değerini Kontrol Ediniz'>!");
		return false;
	}
	document.add_allocate.start_km.value = filterNum(document.add_allocate.start_km.value);
	document.add_allocate.pre_km.value = filterNum(document.add_allocate.pre_km.value);

}

</script>


