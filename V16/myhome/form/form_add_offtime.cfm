<cf_xml_page_edit fuseact="ehesap.form_add_offtime_popup">
<cfquery name="get_position_detail" datasource="#dsn#">
	SELECT UPPER_POSITION_CODE,UPPER_POSITION_CODE2 FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_POSITIONS.EMPLOYEE_ID = #attributes.employee_id# AND IS_MASTER = 1
</cfquery>
<cfquery name="GET_OFFTIME_CATS" datasource="#dsn#">
	SELECT * FROM SETUP_OFFTIME WHERE IS_ACTIVE = 1 AND IS_REQUESTED = 1 AND UPPER_OFFTIMECAT_ID = 0 ORDER BY OFFTIMECAT
</cfquery>
<cfscript>
	Position_Assistant= createObject("component","V16.hr.ehesap.cfc.position_assistant");
	get_modules_no = Position_Assistant.GET_MODULES_NO(fuseaction:attributes.fuseaction);
</cfscript>
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform name="offtime_request" action="#request.self#?fuseaction=myhome.emptypopup_add_offtime" method="post" enctype="multipart/form-data">
			<input type="hidden" name="counter" id="counter">
			<input type="hidden" name="kalan_izin" id="kalan_izin" value="<cfoutput>#attributes.kalan_izin#</cfoutput>">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-emp_name">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57576.Calışan'></label>
						<div class="col col-9 col-xs-12"> 
							<div class="input-group">
							<cfquery name="get_in_out" datasource="#dsn#">
								SELECT MAX(IN_OUT_ID) AS IN_OUT_ID FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
							</cfquery>
							<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
							<input name="emp_name" type="text" id="emp_name" style="width:180px;" readonly="readonly" value="<cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>"><!--- onFocus="AutoComplete_Create('emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','offtime_request','3','140');" autocomplete="off"--->
							<input type="hidden" name="in_out_id" value="<cfoutput>#get_in_out.in_out_id#</cfoutput>">
							<cfif x_select_emp eq 1>
								<cfif x_select_emp_in_out eq 1>
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_emp_in_out&field_in_out_id=offtime_request.in_out_id&field_emp_name=offtime_request.emp_name&field_emp_id=offtime_request.employee_id&is_position_assistant=1&module_id=<cfoutput>#get_modules_no.module_no#</cfoutput>&upper_position_code=<cfoutput>#session.ep.position_code#</cfoutput>&show_rel_pos=1','list');"></span>
								<cfelse>
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&is_position_assistant=1&module_id=<cfoutput>#get_modules_no.module_no#</cfoutput>&field_emp_id=offtime_request.employee_id&field_name=offtime_request.emp_name&upper_pos_code=<cfoutput>#session.ep.position_code#</cfoutput>&select_list=1&show_rel_pos=1','list');"></span>
								</cfif>
							</cfif>
							</div>
						</div>
					</div>
					<cfif isDefined("attributes.employee_id")>
						<div class="form-group" id="item-process">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='58859.Süreç'></label>
							<div class="col col-9 col-xs-12"> 
								<cf_workcube_process is_upd='0' process_cat_width='180' is_detail='0'>
							</div>
						</div>
					</cfif>
					<div class="form-group" id="item-GET_OFFTIME_CATS">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'> *</label>
						<div class="col col-9 col-xs-12"> 
							<select name="offtimecat_id" id="offtimecat_id"  onchange="sub_category();">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="GET_OFFTIME_CATS">
									<option value="#offtimecat_id#">#offtimecat#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-sub_offtimecat_id" style="display:none">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='49193.Alt Kategori'></label>
						<div class="col col-9 col-xs-12"> 
							<select name="sub_offtimecat_id" id="sub_offtimecat_id" >
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-startdate">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57501.Başlama'> *</label>
							<div class="col col-5 col-xs-12"> 
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="startdate" id="startdate"  value="" validate="#validate_style#" message="#message#" required="yes" maxlength="10">
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
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş'> *</label>
							<div class="col col-5 col-xs-12"> 
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="finishdate" id="finishdate" value="" validate="#validate_style#" message="#message#" maxlength="10" required="yes">
									<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate" call_function="shift_control" call_parameter="2"></span>
								</div>
							</div>
							<div class="col col-2 col-xs-12">
								<cf_wrkTimeFormat name="finish_clock" value="#finish_hour_info#">
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
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='31153.İşe Başlama'> *</label>
							<div class="col col-5 col-xs-12">  
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='31182.İşe Başlama girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="work_startdate" style="width:65px;" value="" validate="#validate_style#" message="#message#" required="yes" maxlength="10">
									<span class="input-group-addon"><cf_wrk_date_image date_field="work_startdate" call_function="shift_control" call_parameter="3"></span>
								</div>
							</div>
							<div class="col col-2 col-xs-12">
								<cf_wrkTimeFormat name="work_start_clock" value="#work_start_hour_info#">
							</div>
							<div class="col col-2 col-xs-12">
								<select name="work_start_minute" id="work_start_minute">
									<cfloop from="0" to="59" step="1" index="a">
										<cfoutput><option value="#Numberformat(a,00)#" <cfif Numberformat(a,00) eq work_start_min_info>selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
									</cfloop>
								</select>
							</div>
					</div>
					<div class="form-group" id="item-tel_no">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='31154.İzinde Ulaşılacak Telefon'></label>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31569.Lütfen Geçerli Bir Telefon Numarası Giriniz'>!</cfsavecontent>
						<div class="col col-2 col-xs-2">
							<cfinput type="text" value="" name="tel_code" style="width:50px;" validate="integer" message="#message#" onKeyUp="isNumber(this)">
						</div>
						<div class="col col-7 col-xs-10">
							<cfinput type="text" value="" name="tel_no" style="width:125px;" validate="integer" message="#message#"  onKeyUp="isNumber(this)">
						</div>
					</div>
					<div class="form-group" id="item-address">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='31155.İzinde Geçirilecek Adres'></label>
						<div class="col col-9 col-xs-12"> 
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='50636.255 Karakterden Fazla Yazmayınız'></cfsavecontent>
							<textarea name="address" id="address" style="width:180px;height:60px;" maxlength="300" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea>
						</div>
					</div>
					<div class="form-group" id="item-detail">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-9 col-xs-12"> 
							<textarea name="detail" id="detail" style="width:180px;height:60px;" rows="2"></textarea>
						</div>
					</div>
					<!--- Belge ekleme --->
					<div class="form-group" id="item-document" class="item-document">
						<label class="col col-3 col-xs-12"><cf_get_lang_main no='279.Dosya'></label>
						<div class="col col-9 col-xs-12">
							<input type="file" name="template_file" id="template_file" style="width:200px;">
							<input type="hidden" name="doc_req" id="doc_req">
						</div>
					</div>
					<!--- // Belge ekleme --->
				</div>
			</cf_box_elements>	
			<cf_box_footer>	
				<div class="col col-12"><cf_workcube_buttons is_upd='0' type_format='1' add_function='check()'></div> 
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
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
}
function change_upper_pos_codes()
{
	var emp_upper_pos_code = wrk_query('SELECT UPPER_POSITION_CODE,UPPER_POSITION_CODE2,POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = '+document.offtime_request.employee_id.value,'dsn');
	var emp_upper_pos_name = wrk_query('SELECT E.EMPLOYEE_NAME FROM EMPLOYEE_POSITIONS EP,EMPLOYEES E WHERE E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_CODE = '+emp_upper_pos_code.UPPER_POSITION_CODE,'dsn');
	var emp_upper_pos_surname = wrk_query('SELECT E.EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS EP,EMPLOYEES E WHERE E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_CODE = '+emp_upper_pos_code.UPPER_POSITION_CODE,'dsn');
	var emp_upper_pos_name2 = wrk_query('SELECT E.EMPLOYEE_NAME  FROM EMPLOYEE_POSITIONS EP,EMPLOYEES E WHERE E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_CODE = '+emp_upper_pos_code.UPPER_POSITION_CODE2,'dsn');
	var emp_upper_pos_surname2 = wrk_query('SELECT E.EMPLOYEE_SURNAME  FROM EMPLOYEE_POSITIONS EP,EMPLOYEES E WHERE E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_CODE = '+emp_upper_pos_code.UPPER_POSITION_CODE2,'dsn');

	if(<cfoutput>#session.ep.userid#</cfoutput> != document.offtime_request.employee_id.value)
	{
		if(emp_upper_pos_code.UPPER_POSITION_CODE)
			document.getElementById('validator_position_code_1').value = emp_upper_pos_code.UPPER_POSITION_CODE;
		else
			document.getElementById('validator_position_code_1').value = '';
		if(emp_upper_pos_name.EMPLOYEE_NAME)
			document.getElementById('validator_position_1').value = emp_upper_pos_name.EMPLOYEE_NAME;
		else
			document.getElementById('validator_position_1').value = '';
		if(emp_upper_pos_surname.EMPLOYEE_SURNAME)
			document.getElementById('validator_position_1').value += ' ' + emp_upper_pos_surname.EMPLOYEE_SURNAME;
		else
			document.getElementById('validator_position_1').value = '';
		if(emp_upper_pos_code.UPPER_POSITION_CODE2)
			document.getElementById('validator_position_code_2').value = emp_upper_pos_code.UPPER_POSITION_CODE2;
		else
			document.getElementById('validator_position_code_2').value = '';
		if(emp_upper_pos_name2.EMPLOYEE_NAME)
			document.getElementById('validator_position_2').value = emp_upper_pos_name2.EMPLOYEE_NAME;
		else
			document.getElementById('validator_position_2').value = '';
		if(emp_upper_pos_surname2.EMPLOYEE_SURNAME)
			document.getElementById('validator_position_2').value += ' ' + emp_upper_pos_surname2.EMPLOYEE_SURNAME;
		else
			document.getElementById('validator_position_2').value = '';
	}
}

function check()
{	
	if($("#doc_req").val() == 1){
		// belge ekleme zorunluluğu kontrolü
		if($("#template_file").val() == ""){
			alert("<cf_get_lang_main no='59.Eksik Veri'> : " + "Belge Zorunludur");	
			return false
		}
	}
	if (offtime_request.employee_id.value.length == 0)
		{
		alert("<cf_get_lang dictionary_id='31183.Çalışan Seçiniz'>!");
		return false;
		}
	if ($('#offtimecat_id').val().length == 0)
	{
		alert("<cf_get_lang dictionary_id='58947.Kategori Seçmelisiniz'>!");
		return false;
	}
	/* if (offtime_request.validator_position_code_1.value.length == 0)
		{
		alert("<cf_get_lang no='427.Onaylayacak Seçiniz'>!");
		return false;
		} */
		
	if ((offtime_request.startdate.value.length != 0) && (offtime_request.finishdate.value.length != 0))
		if(!time_check(offtime_request.startdate,offtime_request.start_clock,offtime_request.start_minute,offtime_request.finishdate,offtime_request.finish_clock,offtime_request.finish_minute,"<cf_get_lang no ='1166.Başlangıç Tarihi Bitiş Tarihinden Küçük olmalıdır'> !")) return false;
	
	if ((offtime_request.work_startdate.value.length != 0) && (offtime_request.finishdate.value.length != 0))
	{
		date_format="<cfoutput>#dateformat_style#</cfoutput>";
		if(date_format == "dd/mm/yyyy"){
			tarih1_ = offtime_request.finishdate.value.substr(6,4) + offtime_request.finishdate.value.substr(3,2) + offtime_request.finishdate.value.substr(0,2);
			tarih2_ = offtime_request.work_startdate.value.substr(6,4) + offtime_request.work_startdate.value.substr(3,2) + offtime_request.work_startdate.value.substr(0,2);
		}else{
			tarih1_ = offtime_request.finishdate.value.substr(6,4) + offtime_request.finishdate.value.substr(0,2) + offtime_request.finishdate.value.substr(3,2) ;
			tarih2_ = offtime_request.work_startdate.value.substr(6,4) + offtime_request.work_startdate.value.substr(0,2) +offtime_request.work_startdate.value.substr(3,2);
		}
		if (offtime_request.finish_clock.value.length < 2) saat1_ = '0' + offtime_request.finish_clock.value; else saat1_ = offtime_request.finish_clock.value;
		if (offtime_request.finish_minute.value.length < 2) dakika1_ = '0' + offtime_request.finish_minute.value; else dakika1_ = offtime_request.finish_minute.value;
		if (offtime_request.work_start_clock.value.length < 2) saat2_ = '0' + offtime_request.work_start_clock.value; else saat2_ = offtime_request.work_start_clock.value;
		if (offtime_request.work_start_minute.value.length < 2) dakika2_ = '0' + offtime_request.work_start_minute.value; else dakika2_ = offtime_request.work_start_minute.value;
	
		tarih1_ = tarih1_ + saat1_ + dakika1_;
		tarih2_ = tarih2_ + saat2_ + dakika2_;
		
		if (tarih1_ > tarih2_) 
		{
			alert("<cf_get_lang dictionary_id='59995.İşe Başlama Tarihi İzin Bitiş Tarihinden Sonra Olmamalıdır'> !");
			offtime_request.work_startdate.focus();
			return false;
		}
	}
	return process_cat_control();
}
//Vardiya kontrolu 15.09.2020 Esma R. Uysal
function shift_control(type)
{
	if(type == 1)
		start_date = $("#startdate").val();
	else if(type == 2)
		start_date = $("#finishdate").val();
	else
		start_date = $("#work_startdate").val();
	employee_id = $("#employee_id").val();
	console.log(type);
	$.ajax({ 
			type:'POST',  
			url:'V16/hr/cfc/get_employee_shift.cfc?method=get_emp_shift_json',  
			data: { 
			start_date : start_date,
			finish_date : start_date,
			employee_id : employee_id
			},
			success: function (returnData) {  
				//console.log(returnData);
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