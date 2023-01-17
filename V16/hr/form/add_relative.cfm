<cfif listfirst(attributes.fuseaction,'.') is 'myhome' and not isNumeric(attributes.employee_id)>
	<cfset attributes.employee_id = contentEncryptingandDecodingAES(isEncode:0,content:employee_id,accountKey:'wrk')>
</cfif>
<cfif isDefined("form_submit") and len(attributes.form_submit)>
	<cfset attributes.employee_id = listFirst(attributes.employee_id)>
	<cfinclude template="../query/add_relative.cfm">
</cfif>
<!--- sayfanin en altinda kapanisi var --->
<cf_get_lang_set module_name="hr">
<cfif fuseaction eq "hr.employee_relative_ssk" or fuseaction eq "myhome.employee_relative_ssk">
 	<cfset relative_url_string = "&field_name=ssk_fee.ill_name&field_surname=ssk_fee.ill_surname&field_rel_name=ssk_fee.relative_name&field_rel_id=ssk_fee.relative_id&field_relative=ssk_fee.ill_relative&field_birth_date=ssk_fee.BIRTH_DATE&field_birth_place=ssk_fee.BIRTH_PLACE&field_tc_identy_no=ssk_fee.TC_IDENTY_NO&field_ill_sex=ssk_fee.ill_sex"> 
	<cfset ssk_ek = "_ssk">
<cfelseif fuseaction eq "hr.employee_relative" or fuseaction eq "myhome.employee_relative">
	<cfset relative_url_string = "">
	<cfset ssk_ek = "">
</cfif>
<cfset get_component = createObject("component","V16.hr.ehesap.cfc.employees_in_out")>
<cfset get_ssk_officer = get_component.IN_OUT_OFFICER(employee_id: attributes.employee_id, use_ssk : 2 )>
<cfif attributes.fuseaction neq 'hr.employee_relative_ssk' and attributes.fuseaction neq 'myhome.employee_relative_ssk'>
<body onLoad="YakinlikKontrol('RELATIVE_LEVEL')">
</cfif>
<script type="text/javascript">
	function YakinlikKontrol(GonderenNesne)
	{
		var Yakinlik = document.getElementById('RELATIVE_LEVEL');

		if (GonderenNesne == "education_status") {
			if (Yakinlik.options[Yakinlik.selectedIndex].value == 4 || Yakinlik.options[Yakinlik.selectedIndex].value == 5)
				gizle_goster(trOkulBilgileri);
		}
		else if (GonderenNesne == "RELATIVE_LEVEL") 
		{			
			if ((Yakinlik.options[Yakinlik.selectedIndex].value != 4 && Yakinlik.options[Yakinlik.selectedIndex].value != 5))
			{
				gizle(trOkulBilgileri);
				document.getElementById('is_married').setAttribute("disabled","disabled");//Evli checkbox'ı
				document.getElementById('kindergarden_support').setAttribute("disabled","disabled");
			}
			else if ((Yakinlik.options[Yakinlik.selectedIndex].value == 4 && Yakinlik.options[Yakinlik.selectedIndex].value == 5) || document.getElementById('education_status').checked == true)
			{
				goster(trOkulBilgileri);
				document.getElementById('is_married').removeAttribute("disabled");//Evli checkbox'ı
			}
			else if (Yakinlik.options[Yakinlik.selectedIndex].value == 4 || Yakinlik.options[Yakinlik.selectedIndex].value == 5)
			{
				document.getElementById('is_married').removeAttribute("disabled");//Evli checkbox'ı
				document.getElementById('kindergarden_support').removeAttribute("disabled");
			}
			else
				document.getElementById('is_married').setAttribute("disabled","disabled");//Evli checkbox'ı
			if(Yakinlik.options[Yakinlik.selectedIndex].value == 3)
			{
				document.getElementById('is_commitment_not_assurance').removeAttribute("disabled");
				document.getElementById('is_assurance_policy').removeAttribute("disabled");
				document.getElementById('is_date').style.display = '';
				document.getElementById('corporation_employee').removeAttribute("disabled");//Kurum Çalışanı checkbox'ı
			}
			else 
			{
				document.getElementById('is_commitment_not_assurance').setAttribute("disabled","disabled");
				document.getElementById('is_assurance_policy').setAttribute("disabled","disabled");
				document.getElementById('is_date').style.display = 'none';
				document.getElementById('marriage_date').value = '';
				document.getElementById('corporation_employee').setAttribute("disabled","disabled");//Kurum Çalışanı checkbox'ı
				document.getElementById('is_retired').setAttribute("disabled","disabled");//Emekli
			}
			if(Yakinlik.options[Yakinlik.selectedIndex].value == 1 || Yakinlik.options[Yakinlik.selectedIndex].value == 2 || Yakinlik.options[Yakinlik.selectedIndex].value == 3)
			{
				document.getElementById('is_retired').removeAttribute("disabled");//Emekli
			}else{				
				document.getElementById('is_retired').setAttribute("disabled","disabled");//Emekli
			}

		}
	}
	function active_child_help(){
		<cfif get_ssk_officer.recordcount eq 0>
			if(document.getElementById("corporation_employee").checked)//Kurum çalışanı ise
				document.getElementById('child_help').removeAttribute("disabled");//Çocuk Yardımı
			else
				document.getElementById('child_help').setAttribute("disabled","disabled");//Çocuk Yardımı
		</cfif>
	}
</script>
<cfinclude template="../query/get_edu_level.cfm">
<cfsavecontent variable="right">
	<input type="button" value="<cf_get_lang dictionary_id='56358.Aile Durumu Bildirimi'>" onClick="windowopen('<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.popup_print_relative&employee_id=#employee_id#</cfoutput>','wide');">
	<cfif fusebox.circuit is not 'myhome' and attributes.fuseaction neq 'hr.employee_relative_ssk'>
		<input type="button" value="<cf_get_lang dictionary_id='56359.Taahhütname'>" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_print_relative_verify&employee_id=#employee_id#</cfoutput>','wide');"> 
	</cfif>
</cfsavecontent>
<div class="col col-12" style="width:50%;">
	<cfif attributes.fuseaction neq 'hr.employee_relative_ssk' and  attributes.fuseaction neq 'myhome.employee_relative_ssk'>
		<cf_box title="#getLang('','Çalışan Yakınları',31276)# : #get_emp_info(attributes.employee_id,0,0)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" right_images="#right#">
			<cfform name="add_relative" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#&event=add">
				<input type="hidden" name="EMPLOYEE_ID" id="EMPLOYEE_ID" value="<cfoutput>#EMPLOYEE_ID#</cfoutput>">
				<input type="hidden" name="form_submit" id="form_submit" value="1">
				<input type="hidden" name="pageFuseaction" id="pageFuseaction" value="<cfoutput>#attributes.fuseaction#</cfoutput>">
				<cf_box_elements>
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
						<label class="col col-1 col-md-1 col-sm-2 col-xs-1">
							<input type="checkbox" name="education_status" id="education_status" value="1" onClick="YakinlikKontrol(this.id);"><cf_get_lang dictionary_id='64225.Okuyor'>
						</label>
						<label class="col col-1 col-md-1 col-sm-2 col-xs-1">
							<input type="checkbox" name="work_status" id="work_status" value="1"><cf_get_lang dictionary_id ='55755.Çalışıyor'>
						</label>
						<label class="col col-1 col-md-1 col-sm-2 col-xs-1">
							<input type="checkbox" name="discount_status" id="discount_status" value="1"> <cf_get_lang dictionary_id ='55670.Vergi İndirim'>
						</label>
						<label class="col col-1 col-md-1 col-sm-2 col-xs-1">
							<input type="checkbox" name="child_help" id="child_help" value="1" <cfif get_ssk_officer.recordcount eq 0>disabled</cfif>><cf_get_lang dictionary_id ='46080.Çocuk Yardımı'> <!--- Eğer eş için kurum çalışanı seçildiyse --->
						</label>
						<label class="col col-1 col-md-1 col-sm-2 col-xs-1">
							<input type="checkbox" name="kindergarden_support" id="kindergarden_support" value="1" disabled><cf_get_lang dictionary_id ='59671.Kreş Yardımı'>
						</label>
						<label class="col col-1 col-md-1 col-sm-2 col-xs-1">
							<input type="checkbox" name="disabled_relative" id="disabled_relative" value="1"><cf_get_lang dictionary_id ='56185.malül'><!--- Tüm Yakınlar İçin --->
						</label>
						<label class="col col-1 col-md-1 col-sm-2 col-xs-1">
							<input type="checkbox" name="is_married" id="is_married" value="1" disabled><cf_get_lang dictionary_id ='49420.Evli'><!--- Oğlu ve kızı için --->
						</label>
						<label class="col col-1 col-md-1 col-sm-2 col-xs-1">
							<input type="checkbox" name="corporation_employee" id="corporation_employee" value="1" onClick="active_child_help(this.id);" disabled><cf_get_lang dictionary_id ='56186.Kurum Çalışanı'> <!--- Yakını eşi seçildiyse --->
						</label>
						<label class="col col-1 col-md-1 col-sm-2 col-xs-1">
							<input type="checkbox" name="is_retired" id="is_retired" value="1" disabled><cf_get_lang dictionary_id ='58541.Emekli'><!--- Anne, Baba ve Eş için --->
						</label>
						<label class="col col-1 col-md-1 col-sm-2 col-xs-1">
							<input type="checkbox" name="is_commitment_not_assurance" id="is_commitment_not_assurance" value="1" disabled><cf_get_lang dictionary_id ='56359.Taahhütname'>
						</label>
						<label class="col col-1 col-md-1 col-sm-2 col-xs-1">
							<input type="checkbox" name="is_assurance_policy" id="is_assurance_policy" value="1" disabled>  <cf_get_lang dictionary_id ='59672.Poliçe'>
						</label>
					</div>
					<div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-process_stage">
							<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
							</div>                
						</div> 
						<div class="form-group" id="item-process_stage">
							<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57631.Ad'>*</label>
							<div class="col col-8 col-md-6 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57631.Ad '>!</cfsavecontent>
								<cfinput type="text" name="NAME" value="" required="yes" message="#message#" maxlength="50">
							</div>                
						</div>
						<div class="form-group" id="item-process_stage">
							<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='58726.Soyad'> *</label>
							<div class="col col-8 col-md-6 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58726.Soyad'>!</cfsavecontent>
								<cfinput type="text" name="SURNAME" value="" required="yes" message="#message#" maxlength="50">
							</div>                
						</div>
						<div class="form-group" id="item-process_stage">
							<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<label><input type="radio" name="sex" id="sex" value="1" checked><cf_get_lang dictionary_id='58959.Erkek'></label>
								<label><input type="radio" name="sex" value="0" id="sex"><cf_get_lang dictionary_id='55621.Kadın'></label>
							</div>                
						</div>
						<div class="form-group" id="item-process_stage">
							<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='55820.Yakınlık Derecesi'>*</label>
							<div class="col col-8 col-md-6 col-xs-12">
								<select name="RELATIVE_LEVEL" id="RELATIVE_LEVEL" onChange="YakinlikKontrol(this.id);">
									<option value="1"><cf_get_lang dictionary_id='55265.Baba'></option>
									<option value="2"><cf_get_lang dictionary_id='55470.Anne'></option>
									<option value="3"><cf_get_lang dictionary_id='55275.Eşi'></option>
									<option value="4"><cf_get_lang dictionary_id='55253.Oğlu'></option>
									<option value="5"><cf_get_lang dictionary_id='55234.Kızı'></option>
									<option value="6"><cf_get_lang dictionary_id='56360.Kardeşi'></option>
								</select>
							</div>                
						</div>
						<div class="form-group" style="display:none" id="is_date">
							<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='29911.Evlilik Tarihi'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<div class="input-group">
									<cfinput validate="#validate_style#" type="text" name="marriage_date" id="marriage_date" value="">
									<span class="input-group-addon"><cf_wrk_date_image date_field="marriage_date"></span>
								</div>
							</div>                
						</div>
						<div class="form-group">
							<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='58727.Doğum Tarihi'>*</label>
							<div class="col col-8 col-md-6 col-xs-12">
								<div class="input-group">
									<cfinput validate="#validate_style#" type="text" name="BIRTH_DATE" id="BIRTH_DATE" value="" required="yes" message="#getLang('','Doğum Tarihi girmelisiniz',55788)#!">
									<span class="input-group-addon"><cf_wrk_date_image date_field="BIRTH_DATE" max_date="#dateformat(now(),'yyyymmdd')#"></span>
								</div>
							</div>                
						</div>
						<div class="form-group">
							<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57790.Doğum Yeri'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<input type="text" name="BIRTH_PLACE" id="BIRTH_PLACE" maxlength="50" value="">
							</div>                
						</div>
						<div class="form-group">
							<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id ='55649.Kimlik No'>*</label>
							<div class="col col-8 col-md-6 col-xs-12">
								<cfinput type="text" name="TC_IDENTY_NO" validate="integer" value="" required="yes" message="#getLang('','Kimlik Numarası Girmelisiniz',56357)#!" maxlength="11">
							</div>                
						</div>
					</div>
					<div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="item-process_stage">
							<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang no='410.Eğitim Durumu'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<select name="EDUCATION" id="EDUCATION">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_edu_level">
										<option value="#EDU_LEVEL_ID#" >#EDUCATION_NAME#</option>							
									</cfoutput>
								</select>
							</div>                
						</div>
						<div class="form-group" id="item-process_stage">
							<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='55494.Meslek'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<input type="text" name="JOB" id="JOB" value="" maxlength="30">
							</div>                
						</div>
						<div class="form-group" id="item-process_stage">
							<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<input type="text" name="COMPANY" id="COMPANY" value="" maxlength="500">
							</div>                
						</div>
						<div class="form-group" id="item-process_stage">
							<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<input type="text" name="JOB_POSITION" id="JOB_POSITION" value="" maxlength="30">
							</div>                
						</div>
						<div class="form-group" id="item-process_stage">
							<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id ='57629.Açıklama'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<input type="text" name="detail" id="detail" value="" maxlength="250">
							</div>                
						</div>
						<div class="form-group" id="item-process_stage">
							<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='58624.Geçerlilik Tarihi'>*</label>
							<div class="col col-8 col-md-6 col-xs-12">
								<div class="input-group">
									<cfinput validate="#validate_style#" type="text" name="validity_date" id="validity_date" value="" required="yes" message="#getLang('','Geçerlilik Tarihi Girmelisiniz',37398)#!">
									<span class="input-group-addon"><cf_wrk_date_image date_field="validity_date"></span>
								</div>
							</div>                
						</div>
					</div>
					<div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true" id="trOkulBilgileri" style="display:none;">
						<div class="form-group" id="item-education_info">
							<label class="col col-12 col-sm-12 bold"><cf_get_lang dictionary_id='31552.Okul bilgileri'></label>
						</div> 
						<div class="form-group" id="item-education_school_name">
							<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id ='57709.Okul'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<input type="text" name="EDUCATION_SCHOOL_NAME" id="EDUCATION_SCHOOL_NAME" maxlength="100">
							</div>                
						</div> 
						<div class="form-group" id="item-education_class_name">
							<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='32326.Sınıf'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<input type="text" name="EDUCATION_CLASS_NAME" id="EDUCATION_CLASS_NAME" maxlength="100">
							</div>                
						</div> 
						<div class="form-group" id="item-education_record_date">
							<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<div class="input-group">
									<cfinput validate="#validate_style#" type="text" name="EDUCATION_RECORD_DATE" value="" message="#getLang('','Kayıt tarihini yandaki ikona tıklayarak seçiniz',46163)#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="EDUCATION_RECORD_DATE"></span>
								</div>
							</div>                
						</div> 
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0' insert_alert='' add_function="loadPopupBox('add_relative')">
				</cf_box_footer>
			</cfform>
		</cf_box>
	<cfelse>
		<cfinclude template="../display/list_emp_relatives.cfm">
		<!--- <cf_get_lang dictionary_id='64650.Çalışan Yakınınız Bulunmamaktadır'>! --->
	</cfif>
</div>
<cfif len(relative_url_string)>
	<script type="text/javascript">
	function add_pos(name,surname,relative_name,relative_id,relative,birth_date,birth_place,tc_identy_no,ill_sex)
	{
		<cfif isdefined("attributes.field_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_name#</cfoutput>.value = name;
		</cfif>
		<cfif isdefined("attributes.field_surname")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_surname#</cfoutput>.value = surname;
		</cfif>
		<cfif isdefined("attributes.field_rel_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_rel_name#</cfoutput>.value = relative_name;
		</cfif>
		<cfif isdefined("attributes.field_rel_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_rel_id#</cfoutput>.value = relative_id;
		</cfif>
		<cfif isdefined("attributes.field_relative")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_relative#</cfoutput>.value = relative;
		</cfif>
		<cfif isdefined("attributes.field_birth_date")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_birth_date#</cfoutput>.value = birth_date;
		</cfif>
		<cfif isdefined("attributes.field_birth_place")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_birth_place#</cfoutput>.value = birth_place;
		</cfif>
		<cfif isdefined("attributes.field_tc_identy_no")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_tc_identy_no#</cfoutput>.value = tc_identy_no;
		</cfif>
		<cfif isdefined("attributes.field_ill_sex")>
			if(ill_sex == '1')
				<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_ill_sex#</cfoutput>[0].checked = true;
			else
				<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_ill_sex#</cfoutput>[1].checked = true;
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
	</script>
</cfif>
<cfif not get_edu_level.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='56356.Lütfen Ayarlar Menüsünden Eğitim Seviyesi Tanımlayınız'>!");
		<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">