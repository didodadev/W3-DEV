<!---<cfset xfa.del = "#request.self#?fuseaction=myhome.emptypopup_del_offtime">--->
<cf_xml_page_edit fuseact='ehesap.form_add_offtime_popup'>
<cfset attributes.offtime_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.offtime_id,accountKey:'wrk') />
<cfif (isDefined('attributes.offtime_id') and (not len(attributes.offtime_id)))>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='58943.Boyle Bir Kayıt Bulunmamaktadir'>!");
		window.close(); 
	</script>
	<cfabort>
</cfif>
<cfset xfa.upd = "#request.self#?fuseaction=myhome.emptypopup_upd_offtime_emp">
<cfinclude template="../query/get_offtime.cfm">
<cfset pageHead = #getLang('myhome',166)#>
<cfparam name="attributes.employee_id" default="#get_offtime.employee_id#">

<cf_catalystHeader>
<div class="col col-8 col-md-8 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="offtime_request" method="post" action="#xfa.upd#">
			<input type="hidden" name="offtime_id" id="offtime_id" value="<cfoutput>#get_offtime.offtime_id#</cfoutput>">
			<input type="hidden" name="valid" id="valid" value="">
			<cfif len(get_offtime.startdate)>
				<cfset start_=date_add('h',session.ep.time_zone,get_offtime.startdate)>
			<cfelse>
				<cfset start_="">
			</cfif>
			<cfif len(get_offtime.finishdate)>
				<cfset end_=date_add('h',session.ep.time_zone,get_offtime.finishdate)>
			<cfelse>
				<cfset end_="">
			</cfif>
			<cfif len(get_offtime.work_startdate)>
				<cfset work_startdate=date_add('h',session.ep.time_zone,get_offtime.work_startdate)>
			<cfelse>
				<cfset work_startdate="">
			</cfif>
			<cf_box_elements>
				<div class="col col-6 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-emp_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57576.Calışan'></label>
						<div class="col col-8 col-xs-12"> 
							<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_offtime.employee_id#</cfoutput>">	
							<input type="hidden" name="in_out_id" id="in_out_id" value="<cfoutput>#get_offtime.in_out_id#</cfoutput>">		
							<cfoutput>#get_emp_info(get_offtime.employee_id,0,0)#</cfoutput>
						</div>
					</div>
					<cfinclude template="../query/get_offtime_cats.cfm">
					<cfif get_offtime.record_emp eq session.ep.userid and (not len(get_offtime.update_emp) or get_offtime.update_emp eq session.ep.userid) and not len(get_offtime.valid) and not len(get_offtime.valid_1) and not len(get_offtime.valid_2)><!--- izin talebi onaylanana kadar kisi guncelleme yapabilir ---->
						<div class="form-group" id="item-process">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58859.Süreç'></label>
							<div class="col col-8 col-xs-12"> 
								<cf_workcube_process is_upd='0' select_value='#get_offtime.offtime_stage#' process_cat_width='188' is_detail='1'>
							</div>
						</div>
						<div class="form-group" id="item-GET_OFFTIME_CATS">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'> *</label>
							<div class="col col-8 col-xs-12"> 
								<select name="offtimecat_id" id="offtimecat_id" onchange="sub_category();">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_offtime_cats">
										<option value="#offtimecat_id#"<cfif get_offtime.offtimecat_id eq offtimecat_id> selected</cfif>>#offtimecat#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<!---Alt Kategori 20191009ERU--->
						<div class="form-group" id="item-sub_offtimecat_id" <cfif not len(get_offtime.sub_offtimecat_id) or get_offtime.sub_offtimecat_id eq 0> style="display:none"</cfif>>
							<cfset setup_offtime = createObject("component","V16.settings.cfc.setup_offtime")>
							<cfset get_sub_offtime = setup_offtime.get_setupofftime(upper_offtimecat_id : get_offtime.offtimecat_id)>
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49193.Alt Kategori'></label>
							<div class="col col-8 col-xs-12"> 
								<select name="sub_offtimecat_id" id="sub_offtimecat_id">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_sub_offtime">
										<option value="#offtimecat_id#"<cfif get_offtime.sub_offtimecat_id eq offtimecat_id> selected</cfif>>#offtimecat#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-startdate">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57501.Başlama'> *</label>
							<div class="col col-8 col-xs-12"> 
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
									<cfinput type="text" name="startdate" id="startdate" value="#dateformat(start_,dateformat_style)#" validate="#validate_style#" message="#message#" required="yes" maxlength="10">
									<span class="input-group-addon"><cf_wrk_date_image date_field="startdate" call_function="shift_control" call_parameter="1"></span>
									<span class="input-group-addon no-bg"></span>
									<cf_wrkTimeFormat name="start_clock" value="#timeformat(start_,'HH')#">
									<span class="input-group-addon no-bg"></span>
									<select name="start_minute" id="start_minute">
										<cfloop from="0" to="59" index="a" step="1">
											<cfoutput><option value="#Numberformat(a,00)#" <cfif timeformat(start_,'MM') eq a> selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
										</cfloop>
									</select>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-finishdate">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş'> *</label>
							<div class="col col-8 col-xs-12"> 
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
									<cfinput type="text" name="finishdate" id="finishdate" value="#dateformat(end_,dateformat_style)#" validate="#validate_style#" message="#message#" required="yes" maxlength="10">							 
									<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate" call_function="shift_control" call_parameter="2"></span>
									<span class="input-group-addon no-bg"></span>
									<cf_wrkTimeFormat name="finish_clock" value="#timeformat(end_,'HH')#">
									<span class="input-group-addon no-bg"></span>
									<select name="finish_minute" id="finish_minute">
										<cfloop from="0" to="59" index="a" step="1">
											<cfoutput><option value="#Numberformat(a,00)#" <cfif timeformat(end_,'MM') eq a> selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
										</cfloop>
									</select>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-work_startdate">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31153.İşe Başlama'> *</label>
							<div class="col col-8 col-xs-12"> 
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='31153.İşe Başlama'></cfsavecontent>
									<cfinput type="text" name="work_startdate" id="work_startdate" value="#dateformat(work_startdate,dateformat_style)#" validate="#validate_style#" message="#message#" required="yes" maxlength="10"> 
									<span class="input-group-addon"><cf_wrk_date_image date_field="work_startdate" call_function="shift_control" call_parameter="3"></span>
									<span class="input-group-addon no-bg"></span>
									<cf_wrkTimeFormat name="work_start_clock" value="#timeformat(work_startdate,'HH')#">
									<span class="input-group-addon no-bg"></span>
									<select name="work_start_minute" id="work_start_minute">
										<cfloop from="0" to="59" index="a" step="1">
											<cfoutput><option value="#Numberformat(a,00)#" <cfif timeformat(work_startdate,'MM') eq a> selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
										</cfloop>
									</select>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-tel_no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31154.İzinde Ulaşılacak Telefon'></label>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57499.Telefon'></cfsavecontent>								
							<div class="col col-2 col-xs-2">
								<cfinput type="text" value="#get_offtime.tel_code#" name="tel_code" id="tel_code" validate="integer" message="#message#">
							</div>
							<div class="col col-6 col-xs-10">
								<cfinput type="text" value="#get_offtime.tel_no#" name="tel_no" id="tel_no" validate="integer" message="#message#">
							</div>
						</div>
						<div class="form-group" id="item-address">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31155.İzinde Geçirilecek Adres'></label>
							<div class="col col-8 col-xs-12"> 
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
								<textarea name="address" id="address" style="width:188px;height:60px;" maxlength="300" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#get_offtime.address#</cfoutput></textarea>
							</div>
						</div>
						<div class="form-group" id="item-detail">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-8 col-xs-12"> 
								<textarea name="detail" id="detail" style="width:188px;height:60px;" rows="2"><cfoutput>#get_offtime.detail#</cfoutput></textarea>
							</div>
						</div>
					<cfelse>
						<div class="form-group" id="item-GET_OFFTIME_CATS">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
							<div class="col col-8 col-xs-12"> 
								<cfoutput query="get_offtime_cats"> 
									<cfif get_offtime.offtimecat_id eq offtimecat_id>
										#offtimecat#
									</cfif>
								</cfoutput>
							</div>
						</div>
						<div class="form-group" id="item-startdate">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57501.Başlama'></label>
							<div class="col col-8 col-xs-12"> 
								<cfif len(start_)><cfoutput>#dateformat(start_,dateformat_style)# (#timeformat(start_,timeformat_style)#)</cfoutput></cfif>
							</div>
						</div>
						<div class="form-group" id="item-finishdate">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş'></label>
							<div class="col col-8 col-xs-12"> 
								<cfif len(end_)><cfoutput>#dateformat(end_,dateformat_style)# (#timeformat(end_,timeformat_style)#)</cfoutput></cfif>
							</div>
						</div>
						<div class="form-group" id="item-work_startdate">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31153.İşe Başlama'></label>
							<div class="col col-8 col-xs-12"> 
								<cfif len(work_startdate)><cfoutput>#dateformat(work_startdate,dateformat_style)# (#timeformat(work_startdate,timeformat_style)#)</cfoutput></cfif>
							</div>
						</div>
						<div class="form-group" id="item-tel_no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31154.İzinde Ulaşılacak Telefon'></label>
							<div class="col col-8 col-xs-12">
								<cfoutput>#get_offtime.tel_code# #get_offtime.tel_no#</cfoutput>
							</div>
						</div>
						<div class="form-group" id="item-address">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31155.İzinde Geçirilecek Adres'></label>
							<div class="col col-8 col-xs-12"> 
								<cfoutput>#get_offtime.address#</cfoutput>
							</div>
						</div>
						<div class="form-group" id="item-detail">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-8 col-xs-12"> 
								<cfoutput>#get_offtime.detail#</cfoutput>
							</div>
						</div>
					</cfif>
					<div class="form-group" id="item-document" class="item-document">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57691.Dosya'></label>
						<div class="col col-8 col-xs-12">
							<input type="file" name="template_file" id="template_file" onchange="checkExDocument()">
							<cfif (isDefined("get_offtime.file_name") and (len(get_offtime.file_name)))>
								<a href="javascript://" onclick="windowopen('<cfoutput>/documents/hr/offtime/#get_offtime.file_name#</cfoutput>','medium');"><cf_get_lang dictionary_id='843.Yüklü Dosyayı Görüntüle'></a>
							</cfif>
							<input type="hidden" name="ex_doc_name" id="ex_doc_name" value="<cfoutput>#get_offtime.file_name#</cfoutput>">
							<input type="hidden" name="doc_req" id="doc_req" value="<cfoutput>#get_offtime.is_document_required#</cfoutput>">
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<div class="col col-6"><cf_record_info query_name="get_offtime"></div>
				<div class="col col-6">
					<cfif get_offtime.record_emp eq session.ep.userid and (not len(get_offtime.update_emp) or get_offtime.update_emp eq session.ep.userid) and not len(get_offtime.valid) and not len(get_offtime.valid_1) and not len(get_offtime.valid_2)>
						<cf_workcube_buttons is_upd='1' is_delete="1" add_function='check()' delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_offtime&OFFTIME_ID=#get_offtime.OFFTIME_ID#' >
					</cfif>	
				</div>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<div class="col col-4 col-md-4 col-sm-12 col-xs-12">
	<cf_box title="#getLang('contract',344,'İzin Hakedişleri')# #getLang('','Dönem',58472)# #session.ep.period_year#" closable="0" collapsable="0">
		<cfinclude template="../display/offtimes_dashboard.cfm">
	</cf_box>
</div>
<script type="text/javascript">
// Eski dosya kontrol
function checkExDocument(){
	document.getElementById("ex_doc_name").value = '';
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
	}
	function check()
	{
		if (document.offtime_request.finish_clock.value =='' || document.offtime_request.finish_minute.value=='' || document.offtime_request.start_clock.value =='' || document.offtime_request.start_minute.value =='' || document.offtime_request.work_start_clock.value =='' ||document.offtime_request.work_start_minute.value =='')
		{
			alert("<cf_get_lang dictionary_id='65492.Lütfen saat ve dakikaları doldurunuz'>");
			return false;
		}
		if(($("#doc_req").val() == 1) && $("#ex_doc_name").val() == ""){
			// belge ekleme zorunluluğu kontrolü
			if($("#template_file").val() == ""){
				alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : " + "<cf_get_lang dictionary_id='63750.Belge Zorunludur'>");	
				return false
			}
		}
		if ($('#offtimecat_id').val().length == 0)
		{
			alert("<cf_get_lang dictionary_id='58947.Kategori Seçmelisiniz'>!");
			return false;
		}
		if ((offtime_request.startdate.value.length != 0) && (offtime_request.finishdate.value.length != 0))
			if(!time_check(offtime_request.startdate,offtime_request.start_clock,offtime_request.start_minute,offtime_request.finishdate,offtime_request.finish_clock,offtime_request.finish_minute,"<cf_get_lang dictionary_id ='31924.Başlangıç Tarihi Bitiş Tarihinden Küçük olmalıdır'> !")) return false;
		
		if ((offtime_request.work_startdate.value.length != 0) && (offtime_request.finishdate.value.length != 0))
		{
		
			tarih1_ = offtime_request.finishdate.value.substr(6,4) + offtime_request.finishdate.value.substr(3,2) + offtime_request.finishdate.value.substr(0,2);
			tarih2_ = offtime_request.work_startdate.value.substr(6,4) + offtime_request.work_startdate.value.substr(3,2) + offtime_request.work_startdate.value.substr(0,2);
			
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
					//console.log(jData);
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
							$("#start_clock").val("<cfoutput>#timeformat(start_,'HH')#</cfoutput>");
							$("#start_minute").val("<cfoutput>#timeformat(start_,'MM')#</cfoutput>");
						}
						else if(type == 2)
						{
							$("#finish_clock").val("<cfoutput>#timeformat(end_,'HH')#</cfoutput>");
							$("#finish_minute").val("<cfoutput>#timeformat(end_,'mm')#</cfoutput>");
						}
						else
						{
							$("#work_start_clock").val("<cfoutput>#timeformat(work_startdate,'HH')#</cfoutput>");
							$("#work_start_minute").val("<cfoutput>#timeformat(work_startdate,'MM')#</cfoutput>");
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