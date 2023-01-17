<cfif listfirst(attributes.fuseaction,'.') is 'myhome' and not isNumeric(attributes.employee_id)>
	<cfset attributes.employee_id = contentEncryptingandDecodingAES(isEncode:0,content:employee_id,accountKey:'wrk')>
	<cfset attributes.relative_id = contentEncryptingandDecodingAES(isEncode:0,content:relative_id,accountKey:'wrk')>
<cfelse>
	<cfset attributes.employee_id = attributes.employee_id>
	<cfset attributes.relative_id = attributes.relative_id>
</cfif>

<cfif isDefined("form_submit") and len(attributes.form_submit)>
	<cfset attributes.employee_id = listFirst(attributes.employee_id)>
	<cfset attributes.relative_id = attributes.relative_id>
	<cfinclude template="../query/upd_relative.cfm">
</cfif>

<cfset get_component = createObject("component","V16.hr.ehesap.cfc.employees_in_out")>
<cfset get_ssk_officer = get_component.IN_OUT_OFFICER(employee_id: attributes.employee_id, use_ssk : 2 )>
<cfparam name="attributes.modal_id" default="">
<cfinclude template="../query/get_relative.cfm">
<!--- <cfinclude template="../query/get_relatives.cfm"> --->
<cfinclude template="../query/get_edu_level.cfm">
<cf_get_lang_set module_name="hr">
<cfif fuseaction eq "hr.employee_relative_ssk">
	<cfset relative_url_string = "&field_name=ssk_fee.ill_name&field_surname=ssk_fee.ill_surname&field_relative=ssk_fee.ill_relative&field_birth_date=ssk_fee.BIRTH_DATE&field_birth_place=ssk_fee.BIRTH_PLACE&field_tc_identy_no=ssk_fee.TC_IDENTY_NO&field_ill_sex=ssk_fee.ill_sex">
	<cfset ssk_ek = "_ssk">
<cfelseif fuseaction eq "hr.employee_relative" or fuseaction eq "myhome.employee_relative">
	<cfset relative_url_string = "">
	<cfset ssk_ek = "">
</cfif>
<body onLoad="YakinlikKontrol('RELATIVE_LEVEL');active_child_help();">
<script type="text/javascript"> /* oğlu ya da kızı seçili ve okuyor seçiliyse, okul bilgileri açık geliyor. */
    <cfif GET_RELATIVE.education_status eq 1 and (GET_RELATIVE.relative_level eq 4 or GET_RELATIVE.relative_level eq 5)>
        goster(trOkulBilgileri);
    <cfelse>
        gizle(trOkulBilgileri);
    </cfif>
    <cfif GET_RELATIVE.relative_level eq 4 or GET_RELATIVE.relative_level eq 5> /* oğlu ya da kızı seçiliyse, evli selectbox'ı aktif geliyor. */
        document.getElementById('is_married').removeAttribute("disabled");
    <cfelse>
        document.getElementById('is_married').setAttribute("disabled","disabled");
    </cfif>
	function YakinlikKontrol(GonderenNesne)
	{
		var Yakinlik = document.getElementById('RELATIVE_LEVEL');

		if (GonderenNesne == "education_status") {
			if (Yakinlik.options[Yakinlik.selectedIndex].value == 4 || Yakinlik.options[Yakinlik.selectedIndex].value == 5)
				gizle_goster(trOkulBilgileri);
		}
		else if (GonderenNesne == "RELATIVE_LEVEL") {
			if ((Yakinlik.options[Yakinlik.selectedIndex].value != 4 && Yakinlik.options[Yakinlik.selectedIndex].value != 5))
			{
				document.getElementById('is_married').setAttribute("disabled","disabled");//Evli checkbox'ı
				gizle(trOkulBilgileri);
				document.getElementById('kindergarden_support').setAttribute("disabled","disabled");
			}
			else if ((Yakinlik.options[Yakinlik.selectedIndex].value == 4 || Yakinlik.options[Yakinlik.selectedIndex].value == 5) || document.getElementById('education_status').checked == true)
			{
				document.getElementById('is_married').removeAttribute("disabled");//Evli checkbox'ı
				goster(trOkulBilgileri);
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
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55749.Çalışan Yakını Güncelle"></cfsavecontent>
<div class="col col-12 col-xs-12">
    <cf_box title="#message#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="upd_relative" id="upd_relative" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#&event=upd">
		<input type="hidden" name="EMPLOYEE_ID" id="EMPLOYEE_ID" value="<cfoutput>#attributes.EMPLOYEE_ID#</cfoutput>">
		<input type="hidden" name="RELATIVE_ID" id="RELATIVE_ID" value="<cfoutput>#attributes.RELATIVE_ID#</cfoutput>">
		<input type="hidden" name="form_submit" id="form_submit" value="1">
		<cf_box_elements>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<label class="col col-1 col-md-1 col-sm-2 col-xs-1">
					<input type="checkbox" name="education_status" id="education_status" onClick="YakinlikKontrol(this.id);" value="1"<cfif GET_RELATIVE.EDUCATION_STATUS eq 1>Checked</cfif>><cf_get_lang dictionary_id ='55483.Okuyor'>
				</label>
				<label class="col col-1 col-md-1 col-sm-2 col-xs-1">
					<input type="checkbox" name="work_status" id="work_status" value="1"<cfif GET_RELATIVE.WORK_STATUS eq 1>Checked</cfif>><cf_get_lang dictionary_id ='55755.Çalışıyor'>
				</label>
				<label class="col col-1 col-md-1 col-sm-2 col-xs-1">
					<input type="checkbox" name="discount_status" id="discount_status" value="1"<cfif GET_RELATIVE.DISCOUNT_STATUS eq 1>Checked</cfif>><cf_get_lang dictionary_id ='55670.Vergi İndirim'>
				</label>
				<label class="col col-1 col-md-1 col-sm-2 col-xs-1">
					<input type="checkbox" name="child_help" id="child_help" value="1" <cfif get_ssk_officer.recordcount eq 0>disabled</cfif>  <cfif GET_RELATIVE.child_help eq 1>Checked</cfif>><cf_get_lang dictionary_id ='46080.Çocuk Yardımı'> <!--- Eğer eş için kurum çalışanı seçildiyse --->
				</label>
				<label class="col col-1 col-md-1 col-sm-2 col-xs-1">
					<input type="checkbox" name="kindergarden_support" id="kindergarden_support" value="1" disabled <cfif GET_RELATIVE.kindergarden_support eq 1>Checked</cfif>><cf_get_lang dictionary_id ='59671.Kreş Yardımı'>
				</label>
				<label class="col col-1 col-md-1 col-sm-2 col-xs-1">
					<input type="checkbox" name="disabled_relative" id="disabled_relative" value="1" <cfif GET_RELATIVE.disabled_relative eq 1>Checked</cfif>><cf_get_lang dictionary_id ='56185.malül'><!--- Tüm Yakınlar İçin --->
				</label>
				<label class="col col-1 col-md-1 col-sm-2 col-xs-1">
					<input type="checkbox" name="is_married" id="is_married" value="1" disabled <cfif GET_RELATIVE.is_married eq 1>Checked</cfif>><cf_get_lang dictionary_id ='49420.Evli'><!--- Oğlu ve kızı için --->
				</label>
				<label class="col col-1 col-md-1 col-sm-2 col-xs-1">
					<input type="checkbox" name="corporation_employee" id="corporation_employee" value="1" onClick="active_child_help(this.id);" disabled <cfif GET_RELATIVE.corporation_employee eq 1>Checked</cfif>> <cf_get_lang dictionary_id ='56186.Kurum Çalışanı'> <!--- Yakını eşi seçildiyse --->
				</label>
				<label class="col col-1 col-md-1 col-sm-2 col-xs-1">
					<input type="checkbox" name="is_retired" id="is_retired" value="1" disabled <cfif GET_RELATIVE.is_retired eq 1>Checked</cfif>><cf_get_lang dictionary_id ='58541.Emekli'><!--- Anne, Baba ve Eş için --->
				</label>
				<label class="col col-1 col-md-1 col-sm-2 col-xs-1">
					<input type="checkbox" name="is_commitment_not_assurance" id="is_commitment_not_assurance" value="1" disabled <cfif GET_RELATIVE.is_commitment_not_assurance eq 1>Checked</cfif>> <cf_get_lang dictionary_id ='56359.Taahhütname'>
				</label>
				<label class="col col-1 col-md-1 col-sm-2 col-xs-1">
					<input type="checkbox" name="is_assurance_policy" id="is_assurance_policy" value="1" disabled <cfif GET_RELATIVE.is_assurance_policy eq 1>Checked</cfif>><cf_get_lang dictionary_id ='59672.Poliçe'>
				</label>
			</div>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group">
					<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
					<div class="col col-8 col-md-6 col-xs-12">
						<cf_workcube_process is_upd='0' process_cat_width='150' select_value='#get_relative.PROCESS_STAGE#' is_detail='1'>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57631.Ad'> *</label>
					<div class="col col-8 col-md-6 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57631.Ad '></cfsavecontent>
						<cfinput type="text" name="NAME" value="#GET_RELATIVE.NAME#" required="yes" message="#message#" maxlength="50">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='58726.Soyad'> *</label>
					<div class="col col-8 col-md-6 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58726.Soyad'></cfsavecontent>
						<cfinput type="text" name="SURNAME" value="#GET_RELATIVE.SURNAME#" required="yes" message="#message#" maxlength="50">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
					<div class="col col-4 col-md-4 col-xs-12">
						<input type="radio" name="sex" id="sex" value="1" <cfif get_relative.sex eq 1>checked</cfif>><cf_get_lang dictionary_id='58959.Erkek'>
					</div>
					<div class="col col-4 col-md-4 col-xs-12">
						<input type="radio" name="sex" id="sex" value="0" <cfif get_relative.sex eq 0>checked</cfif>><cf_get_lang dictionary_id='55621.Kadın'> 
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='55820.Yakınlık Derecesi'>*</label>
					<div class="col col-8 col-md-6 col-xs-12">
						<select name="RELATIVE_LEVEL" id="RELATIVE_LEVEL" onChange="YakinlikKontrol(this.id);">
							<option value="1"<cfif GET_RELATIVE.RELATIVE_LEVEL eq 1> selected</cfif>><cf_get_lang dictionary_id='55265.Baba'></option>
							<option value="2"<cfif GET_RELATIVE.RELATIVE_LEVEL eq 2> selected</cfif>><cf_get_lang dictionary_id='55470.Anne'></option>
							<option value="3"<cfif GET_RELATIVE.RELATIVE_LEVEL eq 3> selected</cfif>><cf_get_lang dictionary_id='55275.Eşi'></option>
							<option value="4"<cfif GET_RELATIVE.RELATIVE_LEVEL eq 4> selected</cfif>><cf_get_lang dictionary_id='55253.Oğlu'></option>
							<option value="5"<cfif GET_RELATIVE.RELATIVE_LEVEL eq 5> selected</cfif>><cf_get_lang dictionary_id='55234.Kızı'></option>
							<option value="6"<cfif GET_RELATIVE.RELATIVE_LEVEL eq 6> selected</cfif>><cf_get_lang dictionary_id="31449.Kardeşi"></option>
						</select>	
					</div>
				</div>
				<div class="form-group" style="display:none" id="is_date">
					<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='29911.Evlilik Tarihi'></label>
					<div class="col col-8 col-md-6 col-xs-12">
						<div class="input-group">
							<cfinput validate="#validate_style#" type="text" name="marriage_date" id="marriage_date" value="#dateformat(GET_RELATIVE.marriage_date,dateformat_style)#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="marriage_date"></span>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='58727.Doğum Tarihi'>*</label>
					<div class="col col-8 col-md-6 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='55788.doğum tarihi girmelisiniz'></cfsavecontent>
							<cfinput validate="#validate_style#" type="text" name="BIRTH_DATE" id="BIRTH_DATE" value="#DateFormat(GET_RELATIVE.BIRTH_DATE,dateformat_style)#" required="yes" message="#message#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="BIRTH_DATE" max_date="#dateformat(now(),'yyyymmdd')#"></span>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57790.Doğum Yeri'></label>
					<div class="col col-8 col-md-6 col-xs-12">
						<input type="text" name="BIRTH_PLACE" id="BIRTH_PLACE" value="<cfoutput>#GET_RELATIVE.BIRTH_PLACE#</cfoutput>">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id ='55649.Kimlik No'>*</label>
					<div class="col col-8 col-md-6 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='58687.Kimlik Numarası Girmelisiniz'>!</cfsavecontent>
						<cfinput type="text" name="TC_IDENTY_NO"  value="#GET_RELATIVE.TC_IDENTY_NO#" validate="integer" required="yes" message="#message#" maxlength="11">
					</div>
				</div>
			</div>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
				<div class="form-group">
					<div class="col col-2 col-md-2 col-xs-12"></div>
					<div class="col col-2 col-md-2 col-xs-12"></div>
					<div class="col col-2 col-md-2 col-xs-12"></div>
					<div class="col col-2 col-md-2 col-xs-12"></div>
					<div class="col col-2 col-md-2 col-xs-12"></div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='53561.Engellilik Derecesi'></label>
					<div class="col col-8 col-md-6 col-xs-12">
						<select name="DEFECTION_LEVEL" id="DEFECTION_LEVEL" onchange="use_tax_open(this.value)">
							<option value="0" <cfif GET_RELATIVE.DEFECTION_LEVEL eq 0 >selected</cfif>>0</option>
							<option value="1" <cfif GET_RELATIVE.DEFECTION_LEVEL eq 1 >selected</cfif>>1</option>
							<option value="2" <cfif GET_RELATIVE.DEFECTION_LEVEL eq 2 >selected</cfif>>2</option>
							<option value="3" <cfif GET_RELATIVE.DEFECTION_LEVEL eq 3 >selected</cfif>>3</option>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-defection_rate">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60217.Engelilik Oranı'></label>
					<div class="col col-8 col-xs-12">
						<cfinput type="text" id="defection_rate" name="defection_rate" value="#GET_RELATIVE.defection_rate#"  onkeyup='isNumber(this)'>
					</div>
				</div>
				<div class="form-group" id="item-defection_date">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64167.Engellilik Geçerlilik Tarihi'></label>
					<div class="col col-8 col-xs-12">
						<div class="col col-6 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='56704.Tarihi Hatalı'>!</cfsavecontent>
								<cfinput type="text" name="defection_startdate" value="#dateFormat(GET_RELATIVE.defection_startdate,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="defection_startdate"></span>
							</div>
						</div>
						<div class="col col-6 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='56704.Tarihi Hatalı'>!</cfsavecontent>
								<cfinput type="text" name="defection_finishdate" value="#dateFormat(GET_RELATIVE.defection_finishdate,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="defection_finishdate"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-xs-12"><input type="checkbox" name="use_tax" id="use_tax" value="1"<cfif GET_RELATIVE.use_tax eq 1>Checked</cfif>></label>
					<div class="col col-8 col-md-6 col-xs-12">
						<cf_get_lang dictionary_id='62776.Engeli nedeniyle vergi indirimi kullanıyor'>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='55495.Eğitim Durumu'></label>
					<div class="col col-8 col-md-6 col-xs-12">
						<select name="EDUCATION" id="EDUCATION">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_edu_level">
								<option value="#EDU_LEVEL_ID#"  <cfif GET_RELATIVE.EDUCATION eq EDU_LEVEL_ID >selected</cfif>>#EDUCATION_NAME#</option>							
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='55494.Meslek'></label>
					<div class="col col-8 col-md-6 col-xs-12"><input type="text" name="JOB" id="JOB" value="<cfoutput>#GET_RELATIVE.JOB#</cfoutput>" maxlength="30"></div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
					<div class="col col-8 col-md-6 col-xs-12"><input type="text" name="COMPANY" id="COMPANY" value="<cfoutput>#GET_RELATIVE.COMPANY#</cfoutput>" maxlength="500"></div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
					<div class="col col-8 col-md-6 col-xs-12"><input type="text" name="JOB_POSITION" id="JOB_POSITION" value="<cfoutput>#GET_RELATIVE.JOB_POSITION#</cfoutput>" maxlength="30"></div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id ='57629.Açıklama'></label>
					<div class="col col-8 col-md-6 col-xs-12"><input type="text" name="detail" id="detail" value="<cfoutput>#GET_RELATIVE.detail#</cfoutput>" maxlength="250"></div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='58624.Geçerlilik Tarihi'>*</label>
					<div class="col col-8 col-md-6 col-xs-12">
						<div class="input-group">
						<input type="hidden" name="old_validity_date" id="old_validity_date" value="<cfoutput>#DateFormat(get_relative.validity_date,dateformat_style)#</cfoutput>">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="37398.Geçerlilik Tarihi Girmelisiniz"> !</cfsavecontent>
						<cfinput validate="#validate_style#" type="text" name="validity_date" value="#DateFormat(get_relative.validity_date,dateformat_style)#" required="yes" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="validity_date"></span>
						</div>
					</div>
				</div>
			</div>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true" id="trOkulBilgileri" style="display:none;">
				<div class="form-group" id="item-education_info">
					<label class="col col-12 col-sm-12 bold"><cf_get_lang dictionary_id='31552.Okul bilgileri'></label>
				</div> 
				<div class="form-group">
					<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id ='57709.Okul'></label>
					<div class="col col-8 col-md-6 col-xs-12"><input type="text" name="EDUCATION_SCHOOL_NAME" id="EDUCATION_SCHOOL_NAME" maxlength="100" value="<cfoutput>#GET_RELATIVE.EDUCATION_SCHOOL_NAME#</cfoutput>"></div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='32326.Sınıf'></label>
					<div class="col col-8 col-md-6 col-xs-12"><input type="text" name="EDUCATION_CLASS_NAME" id="EDUCATION_CLASS_NAME" maxlength="100" value="<cfoutput>#GET_RELATIVE.EDUCATION_CLASS_NAME#</cfoutput>"></div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></label>
					<div class="col col-8 col-md-6 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="46163.Kayıt tarihini yandaki ikona tıklayarak seçiniz">!</cfsavecontent>
							<cfinput validate="#validate_style#" type="text" name="EDUCATION_RECORD_DATE" value="#DateFormat(GET_RELATIVE.EDUCATION_RECORD_DATE,dateformat_style)#" message="#message#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="EDUCATION_RECORD_DATE"></span>
						</div>
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_record_info query_name='get_relative'>
			<cf_workcube_buttons is_upd='1' insert_alert='' add_function="#iif(isdefined('attributes.draggable'),DE("loadPopupBox('upd_relative' , '#attributes.modal_id#')"),DE(''))#" delete_page_url='#request.self#?fuseaction=#listFirst(attributes.fuseaction,'.')#.employee_relative#ssk_ek#&event=del&employee_id=#attributes.employee_id#&relative_id=#attributes.relative_id#&head=#GET_RELATIVE.NAME##GET_RELATIVE.SURNAME#'>
		</cf_box_footer>
		</cfform>
		<!---<cfif GET_RELATIVES.recordcount>
			 <cfinclude template="../display/list_emp_relatives.cfm"> 
		</cfif>--->
	</cf_box>	
	
</div>
<script type="text/javascript">
	use_tax_open($("#DEFECTION_LEVEL").val());
	<cfif len(relative_url_string)>
		function add_pos(name,surname,relative,birth_date,birth_place,tc_identy_no)
		{
			<cfif isdefined("attributes.field_name")>
				<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_name#</cfoutput>.value = name;
			</cfif>
			<cfif isdefined("attributes.field_surname")>
				<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_surname#</cfoutput>.value = surname;
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
			<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
		}
	</cfif>
	function use_tax_open(i)
	{
        if (i == 1 || i == 2 || i == 3)
        {
            $('#form_ul_use_tax').css('display','');
            $('#item-defection_rate').css('display','');
            $('#item-defection_date').css('display','');
        }
		else if (i == 0)
		{
            $('#form_ul_use_tax').css('display','none');   
            $("#defection_rate").val('');
            $('#item-defection_rate').css('display','none');
            $('#item-defection_date').css('display','none');
		}
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->