<cf_xml_page_edit fuseact='ehesap.form_add_offtime_popup'>
<cf_get_lang_set module_name="ehesap">
<cfquery name="GET_OFFTIME_CATS" datasource="#DSN#">
	SELECT OFFTIMECAT,OFFTIMECAT_ID,IS_PUANTAJ_OFF FROM SETUP_OFFTIME WHERE IS_ACTIVE = 1 AND UPPER_OFFTIMECAT_ID = 0 ORDER BY OFFTIMECAT_ID
</cfquery>
<cfquery name="get_top_puantaj" dbtype="query" maxrows="1">
	SELECT IS_PUANTAJ_OFF FROM GET_OFFTIME_CATS ORDER BY OFFTIMECAT_ID
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform name="offtime_request" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_add_offtime" enctype="multipart/form-data">
			<cfif isdefined('x_valid') and x_valid eq 1>
				<input type="hidden" name="valid" id="valid" value="<cfoutput>#x_valid#</cfoutput>">
			</cfif>
			<input type="hidden" name="x_day_control" id="x_day_control" value="<cfoutput>#x_day_control#</cfoutput>">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-is_puantaj_off">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='53662.Puantajda Görüntülenmesin'></label>
						<div class="col col-8 col-xs-12"> 
							<input type="checkbox" value="1" name="is_puantaj_off" id="is_puantaj_off" <cfif get_top_puantaj.is_puantaj_off eq 1>checked</cfif>>
						</div>
					</div>
					<input type="hidden" name="counter" id="counter">
						<div class="form-group" id="item-employee_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
							<div class="col col-8 col-xs-12"> 
								<cfif isDefined("attributes.employee_id")>
									<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
									<cfinclude template="../query/get_hr_name.cfm">
									<input type="hidden" name="emp_name" id="emp_name" value="<cfoutput>#get_hr_name.employee_name# #get_hr_name.employee_surname#</cfoutput>">
									<cfquery name="get_in_out" datasource="#dsn#">
										SELECT MAX(IN_OUT_ID) AS IN_OUT_ID FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
									</cfquery>
									<input type="hidden" name="in_out_id" value="<cfoutput>#get_in_out.in_out_id#</cfoutput>">
									<cfoutput>#get_hr_name.employee_name# #get_hr_name.employee_surname#</cfoutput>
								<cfelse>
									<cf_wrk_employee_in_out
										form_name="offtime_request"
										emp_id_fieldname="employee_id"
										in_out_id_fieldname="in_out_id"
										width="188"
										emp_name_fieldname="emp_name"
										call_function = "get_deserve_date()">
								</cfif>
							</div>
						</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58859.Süreç'></label>
						<div class="col col-8 col-xs-12"> 
							<cf_workcube_process is_upd='0' process_cat_width='188' is_detail='0'>
						</div>
					</div>
					<!---Alt Kategori 20191009ERU--->
					<div class="form-group" id="item-offtimecat_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
						<div class="col col-8 col-xs-12"> 
							<select name="offtimecat_id" id="offtimecat_id" onchange="sub_category();">
								<option value="" onclick="change_puantaj(0);"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_offtime_cats">
								<option value="#offtimecat_id#" onclick="change_puantaj(#is_puantaj_off#);">#offtimecat#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-sub_offtimecat_id" style="display:none">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49193.Alt Kategori'></label>
						<div class="col col-8 col-xs-12"> 
							<select name="sub_offtimecat_id" id="sub_offtimecat_id">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							</select>
						</div>
					</div>
					<!--- Kısa Çalışma Ödeneği Hesaplama Kuralları Esma R. Uysal 23.04.2020 --->
					<cfif isdefined("x_show_short_work") and x_show_short_work eq 1>
						<div class="form-group" id="item-short_working_rate" style="display:none">
							<cfif x_show_short_rate_select eq 0>
								<label class="col col-4 col-xs-12">Haftalık Çalışılacak Saat</label>
								<div class="col col-3 col-xs-12"> 
									<input type="text" name="short_working_hours" id="short_working_hours" value="" onkeyup="return(FormatCurrency(this,event,1))">
								</div>
							<cfelse>
								<label class="col col-4 col-xs-12">Haftalık Çalışma Süresi Oranı</label>
								<div class="col col-3 col-xs-12"> 
									<select name="short_working_rate" id="short_working_rate">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<option value="1">1/3</option>
										<option value="2">2/3</option>
										<option value="3">3/3</option>
										<option value="4">1/2</option>
									</select>
								</div>
							</cfif>
							<label class="col col-4 col-xs-12">İlk hafta gerçek maaş üzerinden hesaplansın mı?</label>
							<div class="col col-3 col-xs-12">
								<select name="first_week_calculation" id="first_week_calculation">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<option value="1">Evet</option>
									<option value="0">Hayır</option>
								</select>
							</div>
						</div>
					</cfif>
					<div class="form-group" id="item-offtime_deserve_date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53623.İzin Hakediş Tarihi'></label>
						<div class="col col-8 col-xs-12"> 
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='54338.Geçerli Hakediş Tarihi'></cfsavecontent>
								<cfinput type="text" name="offtime_deserve_date" id="offtime_deserve_date" value="" validate="#validate_style#" message="#message#" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="offtime_deserve_date"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-startdate">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57501.Başlangıç'>*</label>
						<div class="col col-4 col-xs-12"> 
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
								<cfinput type="text" name="startdate" id="startdate" value="" validate="#validate_style#" message="#message#" required="yes" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="startdate" call_function="shift_control" call_parameter="1"></span>
							</div>
						</div>
						<div class="col col-2 col-xs-12">
							<cf_wrkTimeFormat name="start_clock" value="#start_hour_info#">
						</div>
						<div class="col col-2 col-xs-12">
							<select name="start_minute" id="start_minute">
								<cfloop from="0" to="59" index="a" step="1">
									<cfoutput><option value="#Numberformat(a,00)#" <cfif Numberformat(a,00) eq start_min_info>selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
								</cfloop>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-finishdate">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş'>*</label>
						<div class="col col-4 col-xs-12"> 
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
								<cfinput type="text" name="finishdate" id="finishdate" value="" validate="#validate_style#" message="#message#" maxlength="10" required="yes">
								<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"  call_function="shift_control" call_parameter="2"></span>
							</div>
						</div>
						<div class="col col-2 col-xs-12">
							<cf_wrkTimeFormat name="finish_clock" value="#finish_hour_info#" >
						</div>
						<div class="col col-2 col-xs-12">
							<select name="finish_minute" id="finish_minute">
								<cfloop from="0" to="59" index="a" step="1">
									<cfoutput><option value="#Numberformat(a,00)#" <cfif Numberformat(a,00) eq finish_min_info>selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
								</cfloop>
							</select> 
						</div>
					</div>
					<div class="form-group" id="item-work_startdate">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53034.İşe Başlama'>*</label>
						<div class="col col-4 col-xs-12"> 
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='53034.İşe Başlama'></cfsavecontent>
								<cfinput type="text" name="work_startdate" id="work_startdate" value="" validate="#validate_style#" message="#message#" required="yes" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="work_startdate" call_function="shift_control" call_parameter="3"></span>								
							</div>
						</div>
						<div class="col col-2 col-xs-12">
							<cf_wrkTimeFormat name="work_start_clock" value="#work_start_hour_info#" >
						</div>
						<div class="col col-2 col-xs-12">
							<select name="work_start_minute" id="work_start_minute">
								<cfloop from="0" to="59" index="a" step="1">
									<cfoutput><option value="#Numberformat(a,00)#" <cfif Numberformat(a,00) eq work_start_min_info>selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
								</cfloop>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-tel_no">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53035.İzinde Ulaşılacak Telefon'></label>
						<div class="col col-2 col-xs-2">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57499.Telefon'></cfsavecontent>
							<cfinput type="text" value="" name="tel_code" id="tel_code" validate="integer" message="#message#">
						</div>
						<div class="col col-6 col-xs-10"> 
							<cfinput type="text" value="" name="tel_no" id="tel_no" validate="integer" message="#message#"> 
						</div>
					</div>
					<div class="form-group" id="item-address">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53036.İzinde Geçirilecek Adres'></label>
						<div class="col col-8 col-xs-12"> 
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
							<textarea name="address" id="address"  maxlength="300" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea>
						</div>
					</div>
					<div class="form-group" id="item-detail">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-8 col-xs-12"> 
							<textarea name="detail" id="detail" rows="2"></textarea>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_elements>
				<div class="col col-4 col-xs-12">
					<!--- Belge ekleme --->
					<div class="form-group" id="item-document" class="item-document">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='279.Dosya'></label>
						<div class="col col-8 col-xs-12">
							<input type="file" name="template_file" id="template_file" style="width:200px;">
							<input type="hidden" name="doc_req" id="doc_req">
						</div>
					</div>
					<!--- // Belge ekleme --->
				</div>
			</cf_box_elements>
			<cf_box_footer>	
				<div class="col col-12"><cf_workcube_buttons is_upd='0' add_function='check()'></div> 
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function check()
{
	if($("#doc_req").val() == 1){
		// belge ekleme zorunluluğu kontrolü
		if($("#template_file").val() == ""){
			alert("<cf_get_lang_main no='59.Eksik Veri'> : " + "<cf_get_lang dictionary_id='63750.Belge Zorunludur'>");	
			return false
		}
	}
	<cfif isdefined("x_show_short_work") and x_show_short_work eq 1 and x_show_short_rate_select eq 0>
		document.getElementById("short_working_hours").value=filterNum(document.getElementById("short_working_hours").value);
	</cfif>
	if (document.getElementById('employee_id').value.length == 0)
	{
		alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57576.Çalışan'>");
		return false;
	}
	if ($('#offtimecat_id').val().length == 0)
	{
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='57486.Kategori'>");
		return false;
	}
		
	if ((offtime_request.startdate.value.length != 0) && (offtime_request.finishdate.value.length != 0))
		if(!time_check(offtime_request.startdate,offtime_request.start_clock,offtime_request.start_minute,offtime_request.finishdate,offtime_request.finish_clock,offtime_request.finish_minute,"<cf_get_lang dictionary_id ='54148.Başlangıç Tarihi Bitiş Tarihinden Küçük olmalıdır'> !")) return false;
	
		if ((offtime_request.work_startdate.value.length != 0) && (offtime_request.finishdate.value.length != 0))
	{
	
		if(dateformat_style == 'dd/mm/yyyy'){
			tarih1_ = offtime_request.finishdate.value.substr(6,4) + offtime_request.finishdate.value.substr(3,2) + offtime_request.finishdate.value.substr(0,2);
			tarih2_ = offtime_request.work_startdate.value.substr(6,4) + offtime_request.work_startdate.value.substr(3,2) + offtime_request.work_startdate.value.substr(0,2);
		}
		else {
			tarih1_ = offtime_request.finishdate.value.substr(6,4) + offtime_request.finishdate.value.substr(0,2) +  offtime_request.finishdate.value.substr(3,2)
			tarih2_ = offtime_request.work_startdate.value.substr(6,4) + offtime_request.work_startdate.value.substr(0,2) + offtime_request.work_startdate.value.substr(3,2);
		}
		
		
		if (offtime_request.finish_clock.value.length < 2) saat1_ = '0' + offtime_request.finish_clock.value; else saat1_ = offtime_request.finish_clock.value;
		if (offtime_request.finish_minute.value.length < 2) dakika1_ = '0' + offtime_request.finish_minute.value; else dakika1_ = offtime_request.finish_minute.value;
		if (offtime_request.work_start_clock.value.length < 2) saat2_ = '0' + offtime_request.work_start_clock.value; else saat2_ = offtime_request.work_start_clock.value;
		if (offtime_request.work_start_minute.value.length < 2) dakika2_ = '0' + offtime_request.work_start_minute.value; else dakika2_ = offtime_request.work_start_minute.value;
	
		tarih1_ = tarih1_ + saat1_ + dakika1_;
		tarih2_ = tarih2_ + saat2_ + dakika2_;
		
		if (tarih1_ > tarih2_) 
		{
			alert("<cf_get_lang dictionary_id='54628.İşe Başlama Tarihi İzin Bitiş Tarihinden Küçük olmamalıdır'> !");
			offtime_request.work_startdate.focus();
			return false;
		}
	}
	return process_cat_control();
}
	function change_puantaj(i,up_catid)
	{
		if(i == 1)
			$("#is_puantaj_off").attr("checked",true);
		else
			$("#is_puantaj_off").attr("checked",false);
	
	}
	function sub_category(){//Alt Kategori 20191009ERU
		up_catid = $('#offtimecat_id').val();
		$('#sub_offtimecat_id').empty();
		$.ajax({ 
				type:'POST',  
				url:'V16/settings/cfc/setup_offtime.cfc?method=get_sub_setupofftime',  
				data: { 
				upper_offtimecat_id: up_catid,
				is_myhome:1
				},
				success: function (returnData) {  // alt kategori varsa burası çalışacak
						var jData = JSON.parse(returnData);  
						if(jData['DATA'].length != 0){
							document.getElementById("item-sub_offtimecat_id").style.display='';
							$("#doc_req").val(0);
						}else{ // alt kategori yoksa burası çalışacak
							document.getElementById("item-sub_offtimecat_id").style.display='none';

							$.ajax({ 
								type:'POST',  
								url:'V16/settings/cfc/setup_offtime.cfc?method=get_sub_setupofftime',  
								data: { 
								upper_offtimecat_id: 0
							},
							success: function (returnData) {  // üst kategori için belge zorunluluğunu kontrol ediyor
									var jData = JSON.parse(returnData);  
									for(var i = 0; i < jData['DATA'].length; i++){
										if(jData['DATA'][i][0] == up_catid){ 
											/*
												üst satır, V16\settings\cfc\setup_offtime.cfc dosyasından gelen veriye göre işlem yapıyor. 
												Değişiklik durumunda diğer dosyada da güncelleme yapınız.
											*/
											if(jData['DATA'][i][2] == true){
												$("#doc_req").val(1); // belge zorunluluğu varsa input'a 1 değeri atıyor
											}else{
												$("#doc_req").val(0);
											}
										}
									}
							},
								error: function () 
								{
									console.log('CODE:8 please, try again..');
									return false; 
								}
							}); 

						}
						$('<option>').attr({value:0})
								.append('<cfoutput>#getLang("main",322)#</cfoutput>').appendTo('#sub_offtimecat_id');  
						$.each( jData['DATA'], function( index ) {                       
								$('<option>').attr({value:this[0]})
								.append(this[1]).appendTo('#sub_offtimecat_id');       		                           
						});
				},
				error: function () 
				{
					console.log('CODE:8 please, try again..');
					return false; 
				}
		}); 
		//18 kısa çalışma ödeneği için Esma R. Uysal - 23.04.2020
		<cfif isdefined("x_show_short_work") and x_show_short_work eq 1>
			get_bildirge_type = wrk_safe_query('get_ebildirge_type','dsn',0,up_catid);
			if(get_bildirge_type.recordcount > 0)
			{
				document.getElementById("item-short_working_rate").style.display='';
			}else{
				document.getElementById("item-short_working_rate").style.display='none';
			}
		</cfif>
	}
	function get_deserve_date()
	{
		emp_id = $('#employee_id').val();
		$.ajax({
			type:"post",
			url: "/V16/hr/cfc/get_deserve_date.cfc?method=get_date&employee_id="+emp_id,
			success: function(dataread) {
				if (dataread)
					$('#offtime_deserve_date').val(dataread);
				else
					$('#offtime_deserve_date').val('');
			},
	        error: function(xhr, opt, err)
			{
				alert(err.toString());
			}
        });
	}
	$(document).ready(function(){
		if ($("#emp_name").val().length > 0 && $("#employee_id").val().length)
			get_deserve_date();
			
		$("#emp_name").blur(function() {
			if ($("#emp_name").val().length > 0 && $("#employee_id").val().length)
				get_deserve_date();
		});
	});
	//Vardiya kontrolu 15.09.2020 Esma R. Uysal
	function shift_control(type)
	{
		if($("#employee_name").val() == '')
		{
			alert("<cf_get_lang dictionary_id = '56320.Lütfen Çalışan Giriniz'>");
			return false;
		}
		if(type == 1)
			start_date = $("#startdate").val();
		else if(type == 2)
			start_date = $("#finishdate").val();
		else
			start_date = $("#work_startdate").val();
		employee_id = $("#employee_id").val();
		$.ajax({ 
				type:'POST',  
				url:'V16/hr/cfc/get_employee_shift.cfc?method=get_emp_shift_json',  
				data: { 
				start_date : start_date,
				finish_date : start_date,
				employee_id : employee_id
				},
				success: function (returnData) {
					var jData = JSON.parse(returnData);   
					if(jData['DATA'].length != 0)
					{
						if(type == 1)
						{
							if(jData['DATA'][0][0] < 10)
								start_val = '0'+jData['DATA'][0][0];
							else
								start_val = jData['DATA'][0][0];
							if(jData['DATA'][0][2] < 10)
								start_min = '0'+jData['DATA'][0][2];
							else
								start_min = jData['DATA'][0][2];
							$("#start_clock").val(start_val);
							$("#start_minute").val(start_min);
						}
						else if(type == 2){
							if(jData['DATA'][0][1] < 10)
								finish_val = '0'+jData['DATA'][0][1];
							else
								finish_val = jData['DATA'][0][1];
							
							if(jData['DATA'][0][3] < 10)
								finish_min = '0'+jData['DATA'][0][3];
							else
								finish_min = jData['DATA'][0][3];
							$("#finish_clock").val(finish_val);
							$("#finish_minute").val(finish_min);
						}
						else{
							if(jData['DATA'][0][0] < 10)
								start_val = '0'+jData['DATA'][0][0];
							else
								start_val = jData['DATA'][0][0];
							if(jData['DATA'][0][2] < 10)
								start_min = '0'+jData['DATA'][0][2];
							else
								start_min = jData['DATA'][0][2];
							$("#work_start_clock").val(start_val);
							$("#work_start_minute").val(start_min);
						}	
					}	
					else{
						if(type == 1)
						{
							$("#start_clock").val('<cfoutput>#start_hour_info#</cfoutput>');
							$("#start_minute").val('<cfoutput>#start_min_info#</cfoutput>');
						}
						else if(type == 2)
						{
							$("#finish_clock").val('<cfoutput>#finish_hour_info#</cfoutput>');
							$("#finish_minute").val('<cfoutput>#finish_min_info#</cfoutput>');
						}
						else
						{
							$("#work_start_clock").val('<cfoutput>#work_start_hour_info#</cfoutput>');
							$("#work_start_minute").val('<cfoutput>#work_start_min_info#</cfoutput>');
						}
					}				
				},
				error: function () 
				{
					console.log('CODE:1 please, try again..');
					return false; 
				}
		}); 
	}
</script>
<cf_get_lang_set module_name="#fusebox.circuit#">
