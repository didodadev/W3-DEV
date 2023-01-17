<!--- Hızlı Özgeçmişim --->
<cfset get_components = createObject("component", "V16.objects2.career.cfc.data_career")>
<cfset get_app = get_components.get_app()>

<cfif get_app.recordcount>
	<cfset get_app_identy = get_components.get_app_identy()>
	<cfset GET_APP_LANG = get_components.GET_APP_LANG()>
	<cfset GET_APP_EDU_UNIV = get_components.GET_EDU_INFO()>
	<cfset GET_EMP_REFERENCE = get_components.GET_EMP_REFERENCE()>
	<cfset GET_APP_EDU_LISE = get_components.GET_EDU_INFO(type : 3)>
	<cfset GET_TEACHER_INFO = get_components.GET_TEACHER_INFO()>
	<cfset GET_ADD_INFO = get_components.GET_ADD_INFO()>
	<cfset GET_ASSET = get_components.GET_ASSET()>
	<cfset MOBIL_CATS = get_components.MOBIL_CATS()>
	<cfset get_city = get_components.get_city()>
	<cfset get_country = get_components.get_country()>
	<cfset GET_EDU_LEVEL = get_components.GET_EDU_LEVEL()>
	<cfset GET_UNV = get_components.GET_SCHOOL()>
	<cfset GET_SCHOOL_PART = get_components.GET_SCHOOL_PART()>
	<cfset GET_HIGH_SCHOOL_PART = get_components.GET_HIGH_SCHOOL_PART()>
	<cfset GET_WORK_INFO = get_components.GET_WORK_INFO()>
	<cfset GET_SECTOR = get_components.GET_SECTOR()>
	<cfset GET_TASK = get_components.GET_TASK()>
	<cfset GET_BRANCH = get_components.GET_BRANCH()>
	<cfset GET_APP_UNIT = get_components.GET_APP_UNIT()>
	<cfset GET_CV_UNIT = get_components.GET_CV_UNIT()>
	<cfset GET_CV_UNIT_MAX = get_components.GET_CV_UNIT_MAX()>
	<cfset GET_COMPUTER_INFO = get_components.GET_COMPUTER_INFO()>
	<cfset FIRE_REASONS = get_components.FIRE_REASONS()>
	<cfset GET_BRANCHES = get_components.GET_BRANCHES()>
	<cfset get_languages = get_components.get_languages()>
	<cfset know_levels = get_components.know_levels()>

	<cfform name="employe_fastcv_detail" method="post" enctype="multipart/form-data">
		<input type="hidden" name="old_photo" id="old_photo" value="<cfoutput>#get_app.photo#</cfoutput>">
		<input type="hidden" name="teacher_info_record" id="teacher_info_record" value="<cfoutput>#get_teacher_info.recordcount#</cfoutput>">
		<div class="row">
			<div class="col-md-12">
				<p class="font-weight-bold float-left"><cf_get_lang dictionary_id='35125.Hızlı Özgeçmiş Oluştur'></p>
				<p class="float-right"><cf_get_lang dictionary_id='35225.30 dakika içinde formu doldurmanız gerekmektedir'>!</p>
			</div>
		</div>
		<p class="font-weight-bold"><cf_get_lang dictionary_id='30236.Kişisel Bilgiler'></p>
		<div class="row">
			<div class="col-md-6">
				<div class="form-group row">
					<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='35206.Özgeçmiş Başlığı'></label>
					<div class="col-12 col-md-8 col-lg-7 col-xl-5">
						<input type="text" class="form-control" name="head_cv" id="head_cv" maxlength="50" value="<cfoutput>#get_app.head_cv#</cfoutput>">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58025.TC Kimlik No'> *</label>
					<div class="col-12 col-md-8 col-lg-7 col-xl-5">
						<cfsavecontent variable="message_tc"><cf_get_lang dictionary_id='31325.TC Kimlik No Girmelisiniz'> !</cfsavecontent>
						<cfinput type="text" class="form-control" name="tc_identy_no" id="tc_identy_no" value="#get_app_identy.tc_identy_no#" maxlength="11" message="#message_tc#" required="yes" onKeyUp="isNumber(this);">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='57631.Ad'> *</label>
					<div class="col-12 col-md-8 col-lg-7 col-xl-5">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='34540.Lütfen adınızı giriniz!'> !</cfsavecontent>
						<cfinput type="text" class="form-control" name="emp_name" id="emp_name" value="#get_app.name#" maxlength="50" required="Yes" message="#message#">						
					</div>
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58726.Soyad'> *</label>
					<div class="col-12 col-md-8 col-lg-7 col-xl-5">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='34558.Lütfen soyadınızı giriniz!'></cfsavecontent>
						<cfinput type="text" class="form-control" name="emp_surname" id="emp_surname" value="#get_app.surname#" maxlength="50" required="Yes" message="#message#">						
					</div>
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='57790.Doğum Yeri'> / <cf_get_lang dictionary_id='58727.Doğum Tarihi'></label>
					<div class="col-6 col-md-4 col-lg-4 col-xl-3">
						<input type="text" class="form-control" name="birth_place" id="birth_place" value="<cfoutput>#get_app_identy.birth_place#</cfoutput>" maxlength="100">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='30390.Doğum Tarihi Girmelisiniz'>!</cfsavecontent>
					</div>
					<div class="col-6 col-md-4 col-lg-3 col-xl-2 pl-0">
						<cfinput type="text" class="form-control" name="birth_date" id="birth_date" value="#dateformat(get_app_identy.birth_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes">
						<cf_wrk_date_image date_field="birth_date">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='57764.Cinsiyet'>*</label>
					<div class="col-12 col-md-8 col-lg-6 col-xl-5 mt-2">
						<input type="radio" name="sex" id="sex" value="1" <cfif get_app.sex eq 1>checked</cfif>> <cf_get_lang dictionary_id='58959.Erkek'>
						<input type="radio" name="sex" id="sex" value="0" <cfif get_app.sex eq 0>checked</cfif>> <cf_get_lang dictionary_id='58958.Kadın'>
					</div>
				</div>				
				<div class="form-group row">
					<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31203.Medeni Durum'> *</label>
					<div class="col-12 col-md-8 col-lg-6 col-xl-5 mt-2">
						<input type="radio" name="married" id="married" value="0" <cfif get_app_identy.married eq 0>checked</cfif>>
						<cf_get_lang dictionary_id='30694.Bekar'>
						<input type="radio" name="married" id="married" value="1" <cfif get_app_identy.married eq 1>checked</cfif>>
						<cf_get_lang dictionary_id='30501.Evli'>							
					</div>
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='35140.Fiziksel Engeli Var mı?'>?</label>
					<div class="col-6 col-md-4 col-lg-4 col-xl-3 mt-2 pr-0">
						<input type="radio" name="defected" id="defected" value="1" onClick="seviye(1);" <cfif get_app.defected eq 1>checked</cfif>> <cf_get_lang dictionary_id='57495.Evet'>
						<input type="radio" name="defected" id="defected" value="0" onClick="seviye(0);" <cfif get_app.defected eq 0 or not len(get_app.defected)>checked</cfif>> <cf_get_lang dictionary_id='57496.Hayır'>							
					</div>
					<div class="col-6 col-md-4 col-lg-3 col-xl-2">
						<select class="form-control" name="defected_level" id="defected_level" <cfif get_app.defected eq 0 or not len(get_app.defected)>disabled</cfif>>
							<option value="0" <cfif get_app.defected_level eq 0>selected</cfif>>%0</option>
							<option value="10" <cfif get_app.defected_level eq 10>selected</cfif>>%10</option>
							<option value="20" <cfif get_app.defected_level eq 20>selected</cfif>>%20</option>
							<option value="30" <cfif get_app.defected_level eq 30>selected</cfif>>%30</option>
							<option value="40" <cfif get_app.defected_level eq 40>selected</cfif>>%40</option>
							<option value="50" <cfif get_app.defected_level eq 50>selected</cfif>>%50</option>
							<option value="60" <cfif get_app.defected_level eq 60>selected</cfif>>%60</option>
							<option value="70" <cfif get_app.defected_level eq 70>selected</cfif>>%70</option>
							<option value="80" <cfif get_app.defected_level eq 80>selected</cfif>>%80</option>
							<option value="90" <cfif get_app.defected_level eq 90>selected</cfif>>%90</option>
							<option value="100" <cfif get_app.defected_level eq 100>selected</cfif>>%100</option>
					  </select>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31661.Ehliyet Sınıf / Yıl'></label>
					<div class="col-6 col-md-4 col-lg-3 col-xl-2">
						<cfset GET_DRIVER_LIS = get_components.GET_DRIVER_LIS()>
						<select class="form-control" name="driver_licence_type" id="driver_licence_type">
							  <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							  <cfoutput query="get_driver_lis">
								  <option value="#licencecat_id#" <cfif licencecat_id eq get_app.licencecat_id> selected</cfif>>#licencecat#</option>
							  </cfoutput>
						</select>
					</div>
					<div class="col-6 col-md-4 col-lg-4 col-xl-3 pl-0">
						<cfsavecontent variable="message_driver"><cf_get_lang_main no ='370.Tarih Değerinizi Kontrol Ediniz'></cfsavecontent>
						<cfinput type="text" class="form-control" name="licence_start_date" id="licence_start_date" value="#DateFormat(get_app.licence_start_date,'dd/mm/yyyy')#" maxlength="10" validate="eurodate" message="#message_driver#">
						<cf_wrk_date_image date_field="licence_start_date">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='35141.Askerlik Durumu'></label>
					<div class="col-12 col-md-8 col-lg-6 col-xl-5 mt-2">
						<input type="radio" name="military_status" id="military_status" value="1" <cfif get_app.military_status eq 1>checked</cfif>>
						<cf_get_lang dictionary_id='46546.Yaptı'>
						<input type="radio" name="military_status" id="military_status" value="2" <cfif get_app.military_status eq 2>checked</cfif>>
						<cf_get_lang dictionary_id='34642.Muaf'>
						<input type="radio" name="military_status" id="military_status" value="4" <cfif get_app.military_status eq 4>checked</cfif>>
						<cf_get_lang dictionary_id='31214.Tecilli'>
					</div>
				</div>
			</div>
			<div class="col-md-6">
				<div class="row">
					<label class="col-md-12 col-form-label font-weight-bold"><cf_get_lang dictionary_id='30243.Fotoğraf'></label>
					<div class="col-md-12">
						<input type="file" name="photo" id="photo">
					</div>
					<cfif len(get_app.photo)>
					<div class="col-md-12">
						<img src="<cfoutput>#file_web_path#hr/#get_app.photo#</cfoutput>" title="<cf_get_lang dictionary_id='30243.Fotoğraf'>" alt="<cf_get_lang dictionary_id='30243.Fotoğraf'>" border="0" width="120" height="140" align="center" />
						<input type="checkbox" name="del_photo" id="del_photo" value="1"><cf_get_lang dictionary_id='30274.Fotoğrafı Sil'>
					</div>
					</cfif>
				</div>
				<div class="row mt-5">
					<label class="col-md-12 col-form-label font-weight-bold"><cf_get_lang dictionary_id='57515.Dosya Ekle'></label>
					<label class="col-md-12 col-form-label"><cf_get_lang dictionary_id='35208.Eklemek istediğiniz bir önyazıyı ya da kendi hazırladığınız özgeçmişi Dosya Ekle aracılığıyla ekleyebilirsiniz'>.</label>
					<cfif get_asset.recordcount>
						<div class="col-md-12">							
							<cfoutput query="get_asset">
								<input type="hidden" name="old_asset_file" id="old_asset_file" value="#asset_file_name#">
								<cf_get_lang dictionary_id='35194.Dosyanız'>: <a href="javascript://" onClick="windowopen('#file_web_path#hr/#asset_file_name#','small')" title="#asset_detail#" class="tableyazi">#asset_name#</a>
								<input type="checkbox" name="del_asset_file" id="del_asset_file" value="#get_asset.asset_id#"> <cf_get_lang dictionary_id='35193.Dosyayı Sil'>
							</cfoutput>
						</div>
					<cfelse>						
						<div class="col-md-4">
							<cf_get_lang dictionary_id='29800.Dosya Adı'>:
						</div>
						<div class="col-md-8 col-lg-7 col-xl-5">
							<input type="text" class="form-control" name="asset_file_name" id="asset_file_name" maxlength="50">
						</div>
					
						<div class="col-md-4 mt-3">
							<cf_get_lang dictionary_id='57691.Dosya'>:
						</div>
						<div class="col-md-6 col-lg-7 col-xl-6 mt-3">
							<input type="file" name="asset_file" id="asset_file">
						</div>												
					</cfif>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12">
				<p class="font-weight-bold"><cf_get_lang dictionary_id='30422.İletişim Bilgileri'></p>	
			</div>
		</div>
		<div class="row">
			<div class="col-md-6">		
				<div class="form-group row">
					<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58813.Cep Telefonu'> *</label>
					<div class="col-5 col-md-4 col-lg-3 col-xl-2">
						<select class="form-control" name="mobilcode" id="mobilcode">
							<cfoutput query="mobil_cats">
								<option value="#mobilcat#" <cfif get_app.mobilcode eq mobilcat>selected</cfif>>#mobilcat#</option>
							</cfoutput>
						</select>
					</div>
					<div class="col-7 col-md-4 col-lg-4 col-xl-3">
						<cfsavecontent variable="message"><cf_get_lang no ='1160.Mobil Telefon Girmelisiniz'></cfsavecontent>
						<cfinput type="text" class="form-control" name="mobil" id="mobil" value="#get_app.mobil#" maxlength="7" onKeyUp="isNumber(this);" message="#message#" required="yes">				
					</div>
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58814.Ev Telefonu'> *</label>
					<div class="col-5 col-md-4 col-lg-3 col-xl-2">
						<cfsavecontent variable="tel_message"><cf_get_lang dictionary_id='31673.Ev Telefonu girmelisiniz'>!</cfsavecontent>
						<cfinput type="text" class="form-control" name="hometelcode" id="hometelcode" value="#get_app.hometelcode#" maxlength="3" required="yes" message="#tel_message#" onKeyUp="isNumber(this);">					
					</div>
					<div class="col-7 col-md-4 col-lg-4 col-xl-3">
						<cfinput type="text" class="form-control" name="hometel" id="hometel" value="#get_app.hometel#" maxlength="7" required="yes" message="#tel_message#" onKeyUp="isNumber(this);">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='57428.E-posta'> *</label>
					<div class="col-12 col-md-8 col-lg-7 col-xl-5">
						<cfsavecontent variable="message_email"><cf_get_lang_main no='1072.Lütfen geçerli bir e-posta adresi giriniz'>!</cfsavecontent>
						<cfinput type="text" class="form-control" name="email" id="email" value="#get_app.email#" validate="email" maxlength="100" message="#message_email#" required="yes">
					</div>					
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='30606.Ev Adresi'></label>
					<div class="col-12 col-md-8 col-lg-7 col-xl-5">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla Karakter Sayısı'></cfsavecontent>
						<textarea class="form-control" name="homeaddress" id="homeaddress" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#get_app.homeaddress#</cfoutput></textarea>
					</div>					
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58219.Ülke'> *</label>
					<div class="col-12 col-md-8 col-lg-7 col-xl-5">
						<select class="form-control" name="homecountry" id="homecountry" onChange="LoadCity(this.value,'homecity','homecounty',0);remove_adress('1');">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_country">
								<option value="#country_id#" <cfif get_app.homecountry eq country_id>selected</cfif>>#country_name#</option>
							</cfoutput>
						</select>
					</div>					
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='57971.Şehir'> *</label>
					<div class="col-12 col-md-8 col-lg-7 col-xl-5">
						<select class="form-control" name="homecity" id="homecity" onChange="LoadCounty(this.value,'homecounty','hometelcode')">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfif len(get_app.homecountry)>
								<cfset GET_CITY = get_components.GET_CITY(country_id : get_app.homecountry)>
								<cfoutput query="get_city">
									<option value="#city_id#" <cfif get_app.homecity eq city_id>selected</cfif>>#get_city.city_name#</option>
								</cfoutput>
							</cfif> 
						</select>
					</div>					
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58638.İlçe'> *</label>
					<div class="col-12 col-md-8 col-lg-7 col-xl-5">
						<select class="form-control" name="homecounty" id="homecounty">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfif len(get_app.homecity)>
								<cfset GET_COUNTY = get_components.GET_COUNTY(city : get_app.homecity)>
								<cfoutput query="get_county">
									<option value="#county_id#" <cfif get_app.homecounty eq county_id>selected</cfif>>#county_name#</option>
								</cfoutput>
							</cfif> 
						</select>
					</div>					
				</div>
			</div>
		</div>
		<p class="font-weight-bold"><cf_get_lang dictionary_id='30644.Eğitim Bilgileri'></p>
		<div class="row">
			<div class="col-md-6">
				<div class="form-group row">
					<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='35155.Eğitim Seviyesi'></label>
					<div class="col-12 col-md-8 col-lg-7 col-xl-5">
						<select class="form-control" name="training_level" id="training_level">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_edu_level">
								<option value="#edu_level_id#" <cfif get_app.training_level eq edu_level_id>selected</cfif>>#education_name#</option>
							</cfoutput>
						</select>
					</div>					
				</div>
			</div>
		</div>
		<!--- <div class="table-responsive-xl">
			<table class="table table-borderless">					
				<tr>
					<td colspan="2"> --->
						<cfif get_app_edu_univ.recordcount>
							<cfset edu_id_var = "">
							<cfset edu_part_id_var = "">
							<cfoutput query="get_app_edu_univ">
								<cfif edu_id eq -1><cfset edu_id_var = 1><cfelse><cfset edu_id_var = 0></cfif>
								<cfif edu_part_id eq -1><cfset edu_part_id_var = 1><cfelse><cfset edu_part_id_var = 0></cfif>
							</cfoutput>
							<div class="table-responsive-xl">
							<table id="table_edu_info" class="table table-borderless">
								<input type="hidden" name="row_edu" id="row_edu" value="<cfoutput>#get_app_edu_univ.recordcount#</cfoutput>">
								<tr>
									<td colspan="4"><b><cf_get_lang dictionary_id='29755.Üniversite'></b></td>
								</tr>
								<tr class="main-bg-color">
									<td><cf_get_lang dictionary_id='31551.Okul Türü'></td>
									<td><cf_get_lang dictionary_id='30645.Okul Adı'></td>
									<td id="tr_eduname_" <cfif len(edu_id_var) and edu_id_var eq 1>style="display:;"<cfelse>style="display:none;"</cfif>><cf_get_lang dictionary_id='35280.Diğer Okul Adı'></td>
									<td><cf_get_lang dictionary_id='57995.Bölüm'></td>
									<td id="tr_edupartname_" <cfif len(edu_part_id_var) and edu_part_id_var eq 1>style="display:;"<cfelse>style="display:none;"</cfif>><cf_get_lang dictionary_id='35279.Diğer Bölüm Adı'></td>
									<td><cf_get_lang dictionary_id='31556.Giriş Yılı'></td>
									<td><cf_get_lang dictionary_id='31481.Mez. Yılı'></td>
									<td><input type="hidden" name="record_numb_edu" id="record_numb_edu" value="0"></td>
									<td></td>         
								</tr>
								<cfoutput query="get_app_edu_univ">
									<tr id="frm_row_edu#currentrow#">
										<input type="hidden" name="empapp_edu_row_id#currentrow#" id="empapp_edu_row_id#currentrow#" value="#empapp_edu_row_id#">
										<td>
											<select class="form-control" name="edu_type#currentrow#" id="edu_type#currentrow#">
												<option value="4" <cfif len(edu_type) and edu_type eq 4>selected</cfif>><cf_get_lang dictionary_id='29755.Üniversite'></option>
												<option value="5" <cfif len(edu_type) and edu_type eq 5>selected</cfif>><cf_get_lang dictionary_id='30483.Yüksek Lisans'></option>
												<option value="6" <cfif len(edu_type) and edu_type eq 6>selected</cfif>><cf_get_lang dictionary_id='31293.Doktora'></option>
											</select>
										</td>
										<td>
											<select class="form-control" name="edu_id#currentrow#" id="edu_id#currentrow#" onchange="eduname_goster(#currentrow#);">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfloop query="get_unv">
													<option value="#get_unv.school_id#" <cfif len(get_app_edu_univ.edu_id) and get_unv.school_id eq get_app_edu_univ.edu_id>selected</cfif>>#get_unv.school_name#</option>	
												</cfloop>
												<option value="-1" <cfif len(get_app_edu_univ.edu_id) and -1 eq get_app_edu_univ.edu_id>selected</cfif>><cf_get_lang dictionary_id='58156.Diğer'></option>
											</select>
										</td>
										<td id="tr_eduname#currentrow#" <cfif edu_id eq -1>style="display:;"<cfelse>style="display:none;"</cfif>>
											<input type="text" class="form-control" name="edu_name#currentrow#" id="edu_name#currentrow#" value="#edu_name#">
										</td>
										<td id="tr_bosluk#currentrow#" <cfif len(edu_id_var) and edu_id_var eq 1 and edu_id neq -1>style="display:;"<cfelse>style="display:none;"</cfif>>
											<input type="hidden" name="bosluk#currentrow#" id="bosluk#currentrow#" value="">
										</td>
										<td>
											<select class="form-control" name="edu_part_id#currentrow#" id="edu_part_id#currentrow#" onchange="edu_partname_goster(#currentrow#)">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfloop query="get_school_part">
													<option value="#get_school_part.part_id#" <cfif len(get_app_edu_univ.edu_part_id) and get_school_part.part_id eq get_app_edu_univ.edu_part_id>selected</cfif>>#get_school_part.part_name#</option>	
												</cfloop>
												<option value="-1" <cfif len(get_app_edu_univ.edu_part_id) and -1 eq get_app_edu_univ.edu_part_id>selected</cfif>><cf_get_lang dictionary_id='58156.Diğer'></option>
											</select>
										</td>
										<td id="tr_edu_partname#currentrow#" <cfif edu_part_id eq -1>style="display:;"<cfelse>style="display:none;"</cfif>>
											<input type="text" class="form-control" name="edu_part_name#currentrow#" id="edu_part_name#currentrow#" value="#edu_part_name#">
										</td>
										<td id="tr_partbosluk#currentrow#"<cfif len(edu_id_var) and edu_id_var eq 1 and edu_part_id neq -1>style="display:;"<cfelse> style="display:none;"</cfif>>
											<input type="hidden" name="partbosluk#currentrow#" id="partbosluk#currentrow#" value="" style="width:100px;">
										</td>
										<td><input type="text" class="form-control" name="edu_start#currentrow#" id="edu_start#currentrow#" value="#edu_start#" maxlength="4" validate="integer" range="1900," onKeyUp="isNumber(this);"></td>
										<td><input type="text" class="form-control" name="edu_finish#currentrow#" id="edu_finish#currentrow#" value="#edu_finish#" maxlength="4"  validate="integer" range="1900," onKeyUp="isNumber(this);"></td>
										<td id="sil_edu_#currentrow#"><input  type="hidden" name="row_kontrol_edu#currentrow#" id="row_kontrol_edu#currentrow#" value="1"><a href="javascript://" title="<cf_get_lang dictionary_id='57463.Sil'>" onClick="sil_edu('#currentrow#');"><img alt="<cf_get_lang dictionary_id='57463.Sil'>" src="images/delete_list.gif" border="0" /></a></td>				
									</tr>
								</cfoutput>
							</table>
							</div>
						<cfelse>
							<div class="table-responsive-xl">
							<table id="table_edu_info" class="table table-borderless">
								<input type="hidden" name="row_edu" id="row_edu" value="0">
								<tr>
									<td colspan="4"><b><cf_get_lang dictionary_id='29755.Üniversite'></b></td>
								</tr>
								<tr>
									<td><cf_get_lang dictionary_id='31551.Okul Türü'></td>
									<td><cf_get_lang dictionary_id='30645.Okul Adı'></td>
									<td id="tr_eduname_" style="display:none;"><cf_get_lang dictionary_id='35280.Diğer Okul Adı'>&nbsp;</td>
									<td><cf_get_lang dictionary_id='57995.Bölüm'></td>
									<td id="tr_edupartname_" style="display:none;"><cf_get_lang dictionary_id='35279.Diğer Bölüm Adı'>&nbsp;</td> 
									<td><cf_get_lang dictionary_id='31556.Giriş Yılı'></td>
									<td><cf_get_lang dictionary_id='31481.Mez. Yılı'></td>
									<td><input type="hidden" name="record_numb_edu" id="record_numb_edu" value="0"></td>
								</tr>
								<input type="hidden" name="edu_type" id="edu_type" value="">
								<input type="hidden" name="edu_id" id="edu_id" value="">
								<input type="hidden" name="edu_name" id="edu_name" value="">
								<input type="hidden" name="edu_part_id" id="edu_part_id" value="">
								<input type="hidden" name="edu_part_name" id="edu_part_name" value="">
								<input type="hidden" name="edu_start" id="edu_start" value="">
								<input type="hidden" name="edu_finish" id="edu_finish" value="">
							</table>
							</div>
						</cfif>
					<!--- </td>
				</tr>
				<tr>
					<td colspan="4"> --->
						<cfif get_app_edu_lise.recordcount>
							<table class="table table-borderless">
								<tr>
									<td colspan="5"><b><cf_get_lang dictionary_id='56517.Lise Adı'></b></td>
								</tr>
								<tr class="main-bg-color">
									<td><cf_get_lang dictionary_id='30645.Okul Adı'></td>
									<td><cf_get_lang dictionary_id='57995.Bölüm'></td>
									<td id="bolum_adi" <cfif get_app_edu_lise.edu_part_id eq -1>style="display:;"<cfelse>style="display:none;"</cfif>>&nbsp;</td>
									<td><cf_get_lang dictionary_id='31556.Giriş Yılı'></td>
									<td><cf_get_lang dictionary_id='31481.Mez. Yılı'></td>
									<td align="left"></td>
								</tr>
								<cfoutput query="get_app_edu_lise">
									<tr>
										<input type="hidden" name="empapp_edu_row_id_lise" id="empapp_edu_row_id_lise" value="#empapp_edu_row_id#">
										<td>
											<input type="hidden" name="edu_id_lise" id="edu_id_lise" value="#edu_id#">
											<input type="text" class="form-control" name="edu_name_lise" id="edu_name_lise" value="#edu_name#" maxlength="75">
										</td>
										<td>
											<select class="form-control" name="edu_part_id_lise" id="edu_part_id_lise" onChange="lise_adi_ac()">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfloop query="get_high_school_part">
													<option value="#get_high_school_part.high_part_id#" <cfif get_app_edu_lise.edu_part_id eq get_high_school_part.high_part_id>selected</cfif>>#get_high_school_part.high_part_name#</option>	
												</cfloop>
												<option value="-1" <cfif get_app_edu_lise.edu_part_id eq -1>selected</cfif>><cf_get_lang dictionary_id='58156.Diğer'></option>
											</select>
										</td>
										<td id="edu_part" style="<cfif get_app_edu_lise.edu_part_id eq -1>display:;<cfelse>display:none;</cfif>">
											<input type="text" class="form-control" name="edu_part_name_lise" id="edu_part_name_lise" value="#get_app_edu_lise.edu_part_name#">
										</td>
										<td><input type="text" class="form-control" name="edu_start_lise" id="edu_start_lise" value="#get_app_edu_lise.edu_start#" maxlength="4" validate="integer" range="1900," onKeyUp="isNumber(this);"></td>
										<td><input type="text" class="form-control" name="edu_finish_lise" id="edu_finish_lise" value="#get_app_edu_lise.edu_finish#" maxlength="4" validate="integer" range="1900," onKeyUp="isNumber(this);"></td>
										<td id="sil_edu_lise"><a href="javascript://" title="<cf_get_lang dictionary_id='57463.Sil'>" onClick="sil_edu_lise_();"><img  src="images/delete_list.gif" alt="<cf_get_lang dictionary_id='57463.Sil'>" border="0" /></a></td>
									</tr>
								</cfoutput>
							</table>
						<cfelseif get_app_edu_lise.recordcount eq 0>
							<table class="table table-borderless">
								<tr>
									<td colspan="5"><b><cf_get_lang dictionary_id='56517.Lise Adı'></b></td>
								</tr>
								<tr>
									<td><cf_get_lang dictionary_id='30645.Okul Adı'></td>
									<td><cf_get_lang dictionary_id='57995.Bölüm'></td>
									<td id="bolum_adi" style="display:none">&nbsp;</td>
									<td><cf_get_lang dictionary_id='31556.Giriş Yılı'></td>
									<td><cf_get_lang dictionary_id='31481.Mez. Yılı'></td>
								</tr>
								<tr>
									<td align="left">
										<input type="hidden" name="edu_id_lise" id="edu_id_lise" value="-1">
										<input type="text" class="form-control" name="edu_name_lise" id="edu_name_lise" value="" maxlength="75">
									</td>
									<td>
										<select class="form-control" name="edu_part_id_lise" id="edu_part_id_lise" onChange="lise_adi_ac()">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfoutput query="get_high_school_part">
												<option value="#high_part_id#">#high_part_name#</option>	
											</cfoutput>
											<option value="-1"><cf_get_lang dictionary_id='58156.Diğer'></option>
										</select>
									</td>
									<td id="edu_part" style="display:none">
										<input type="text" class="form-control" name="edu_part_name_lise" id="edu_part_name_lise" value="">
									</td>
									<td><input type="text" class="form-control" name="edu_start_lise" id="edu_start_lise" value="" maxlength="4" validate="integer" range="1900," onKeyUp="isNumber(this);"></td>
									<td><input type="text" class="form-control" name="edu_finish_lise" id="edu_finish_lise" value="" maxlength="4" validate="integer" range="1900," onKeyUp="isNumber(this);"></td>
								</tr>
							</table>
						</cfif>
					<!--- </td>
				</tr>
			</table>
		</div> --->
		<cfif isdefined("attributes.is_teacher_info") and attributes.is_teacher_info eq 1>
			<div class="table-responsive-xl">			
				<table class="table table-borderless">
					<tr>
						<td colspan="2" class="font-weight-bold"><cf_get_lang dictionary_id='58565.Branş'> *</td>
					</tr>
					<input type="hidden" name="branch_row_count" id="branch_row_count" value="<cfoutput>#get_branches.recordcount#</cfoutput>">
					<cfif get_branches.recordcount>
						<cfoutput query="get_branches">
								<cfquery name="GET_BRANCHES_INFO" dbtype="query">
								SELECT * FROM GET_ADD_INFO WHERE BRANCHES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#branches_id#">
							</cfquery>
							<cfquery name="GET_BRANCHES_INFO_OTHER" dbtype="query">
								SELECT * FROM GET_ADD_INFO WHERE BRANCHES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#branches_id#"> AND BRANCHES_ROW_ID = -1
							</cfquery>
							<cfset row_id_list = valuelist(get_branches_info.branches_row_id)>
							<input type="hidden" name="branches_id_#currentrow#" id="branches_id_#currentrow#" value="#branches_id#">
							<cfset GET_BRANCHES_ROWS = get_components.GET_BRANCHES_ROWS(branches_id : branches_id)>
							<tr>
								<td>#branches_name#</td>
								<cfif branches_row_type eq 0>
									<td>
										<cfloop query="get_branches_rows">
											<input type="checkbox" name="emp_app_info_#get_branches.branches_id#" id="emp_app_info_#get_branches.branches_id#" value="#branches_row_id#" <cfif listfind(row_id_list,branches_row_id,',')>checked</cfif>>
											#get_branches_rows.branches_name_row#
										</cfloop>
									</td>
								<cfelseif branches_row_type eq 1>
									<td <cfif listfind(row_id_list,-1,',')></cfif>>
										<select class="form-control" name="emp_app_info_#get_branches.branches_id#" id="emp_app_info_#get_branches.branches_id#" style="width:220px; height:100px;" onchange="show_other_types('#get_branches.branches_id#')" multiple>
											<cfloop query="get_branches_rows">
												<option value="#branches_row_id#" <cfif listfind(row_id_list,branches_row_id,',')>selected</cfif>>#get_branches_rows.branches_name_row#</option>
											</cfloop>
											<option value="-1" <cfif listfind(row_id_list,-1,',')>selected</cfif>><cf_get_lang dictionary_id='58156.Diğer'></option>
										</select>
									</td>
									<td id="other_branches_#get_branches.branches_id#" <cfif listfind(row_id_list,-1,',')>style="width:51%;display:;"<cfelse>style="width:51%;display:none"</cfif>>
										<textarea class="form-control" name="other_branches_name_#get_branches.branches_id#" id="other_branches_name_#get_branches.branches_id#" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" style="width:200px;height:95;">#get_branches_info_other.branches_row_other#</textarea>
									</td>
								</cfif>
							</tr>
						</cfoutput>		
					</cfif>					
					<tr>
						<td colspan="4" class="font-weight-bold"><cf_get_lang dictionary_id='35501.Öğretmen Adaylar İçin'>;</td>
					</tr>
					<tr>
						<td colspan="4">
							<table class="table">
								<tr>
									<td><cf_get_lang dictionary_id='35502.Staj'></td>
									<td>
										<input type="radio" name="internship" id="internship" value="1" <cfif get_teacher_info.recordcount and len(get_teacher_info.internship) and get_teacher_info.internship eq 1>checked</cfif>>
										<cf_get_lang dictionary_id='31336.Aday'>
										<input type="radio" name="internship" id="internship" value="2" <cfif get_teacher_info.recordcount and len(get_teacher_info.internship) and get_teacher_info.internship eq 2>checked</cfif>>
										<cf_get_lang dictionary_id='31403.Asıl'>											
									</td>
									<td></td>
									<td><cf_get_lang dictionary_id='58563.Formasyon'></td>
									<td>
										<input type="radio" name="formation" id="formation" value="1" onclick="goster_();" <cfif get_teacher_info.recordcount and len(get_teacher_info.is_formation) and get_teacher_info.is_formation eq 1>checked</cfif>> <cf_get_lang dictionary_id='58564.Var'>
										<input type="radio" name="formation" id="formation" value="0" onclick="goster_();" <cfif get_teacher_info.recordcount and len(get_teacher_info.is_formation) and get_teacher_info.is_formation eq 0>checked</cfif>> <cf_get_lang dictionary_id='58546.Yok'>											
									</td>
									<td rowspan="2" id="formation_type" <cfif (get_teacher_info.recordcount and len(get_teacher_info.is_formation) and get_teacher_info.is_formation eq 1)>style="display:; vertical-align:top;"<cfelseif (get_teacher_info.recordcount and not len(get_teacher_info.is_formation)) or (get_teacher_info.recordcount and len(get_teacher_info.is_formation) and get_teacher_info.is_formation eq 0) or (get_teacher_info.recordcount eq 0)>style="display:none; vertical-align:top;"</cfif>>
										<select class="form-control" name="formation_typee" id="formation_typee" multiple style="width:190px; height:60px;">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<option value="1" <cfif get_teacher_info.recordcount and len(get_teacher_info.formation_type) and listfind(get_teacher_info.formation_type,1,',')>selected</cfif>><cf_get_lang dictionary_id='35505.Anaokul'></option>
											<option value="2" <cfif get_teacher_info.recordcount and len(get_teacher_info.formation_type) and listfind(get_teacher_info.formation_type,2,',')>selected</cfif>><cf_get_lang dictionary_id='30647.İlköğretim'></option>
											<option value="3" <cfif get_teacher_info.recordcount and len(get_teacher_info.formation_type) and listfind(get_teacher_info.formation_type,3,',')>selected</cfif>><cf_get_lang dictionary_id='30480.Lise'></option>
										</select>											
									</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>				
		</cfif>
			
		<div class="table-responsive-xl">
			<table class="table table-borderless">
				<tr>
					<td colspan="5">
						<p class="font-weight-bold"><cf_get_lang dictionary_id='35474.Çalışmak İstenilen Birim'></p>
						<p>(<cf_get_lang dictionary_id='35185.Öncelik Sıralarını Yandaki Kutulara Yazınız'>... 1,2,3 gibi)</p>					
					</td>
				</tr>
				<cfif get_cv_unit.recordcount>
					<tr class="font-weight-bold">
					<cfset liste = valuelist(get_app_unit.unit_id)>
					<cfset liste_row = valuelist(get_app_unit.unit_row)>					
					<cfoutput query="get_cv_unit">
						<cfif get_cv_unit.currentrow-1 mod 3 eq 0><tr></cfif>
							
							<td>#unit_name#</td>
							<td><cfif listfind(liste,unit_id,',')>
								<input type="text" class="form-control" name="unit#unit_id#" id="unit#unit_id#" value="#listgetat(liste_row,listfind(liste,unit_id,','),',')#" maxlength="1" style="width:50px;" onchange="seviye_kontrol(this);" onBlur="isNumber(this);">
						<cfelse>
								<input type="text" class="form-control" name="unit#unit_id#" id="unit#unit_id#" value="" maxlength="1" style="width:50px;"  onchange="seviye_kontrol(this);" onBlur="isNumber(this);">
						</cfif>
						</td>
					<cfif get_cv_unit.currentrow mod 3 eq 0 and get_cv_unit.currentrow-1 neq 0></tr></cfif>	  
					</cfoutput>
				<cfelse>
					<tr><td><cf_get_lang dictionary_id='31702.Sisteme kayıtlı birim yok'>.</td></tr>
				</cfif>
			</table>
		</div>						
		<div class="table-responsive-xl">
			<table class="table table-borderless">
				<tr>
					<td class="font-weight-bold"><cf_get_lang dictionary_id='35226.İş Tecrübeleri'></td>
				</tr>
				<!--- <tr>
					<td> --->
						<input type="hidden" name="row_count" id="row_count" value="3">
						<cfif get_work_info.recordcount>
							<table id="table_work_info" class="table">
								<tr class="main-bg-color">
									<td><cf_get_lang dictionary_id='31549.Çalışılan Yer'></td>
									<td><cf_get_lang dictionary_id='57579.Sektör'></td>
									<td><cf_get_lang dictionary_id='57571.Ünvan'></td>
									<td><cf_get_lang dictionary_id='57655.Başlama Tarihi'></td>
									<td><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></td>
									<td><cf_get_lang dictionary_id='31530.Ayrılma Nedeni'></td>
									<td><cf_get_lang dictionary_id='31529.Hala Çalışıyorum'></td>
									<td><input type="hidden" name="record_num" id="record_num" value="0"></td>
								</tr>
								<cfoutput query="get_work_info">
									<tr id="frm_row#currentrow#"> 
										<input type="hidden" name="empapp_row_id#currentrow#" id="empapp_row_id#currentrow#" value="#empapp_row_id#" class="boxtext">
										<td><input type="text" class="form-control" name="exp_name#currentrow#" id="exp_name#currentrow#" value="#exp#"></td>
										<td>
											<select class="form-control" name="exp_sector_cat#currentrow#" id="exp_sector_cat#currentrow#">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfloop query="get_sector">
													<option value="#sector_cat_id#" <cfif len(get_work_info.exp_sector_cat) and sector_cat_id eq get_work_info.exp_sector_cat>selected</cfif>>#sector_cat#</option>
												</cfloop>
											</select>
										</td>
										<td>
											<select class="form-control" name="exp_task_id#currentrow#" id="exp_task_id#currentrow#">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfloop query="get_task">
													<option value="#partner_position_id#" <cfif len(get_work_info.exp_task_id) and partner_position_id eq get_work_info.exp_task_id>selected</cfif>>#partner_position#</option>
												</cfloop>
											</select>
										</td>
										<td>
											<cfinput type="text" class="form-control" name="exp_start#currentrow#" id="exp_start#currentrow#" value="#dateformat(exp_start,'dd/mm/yyyy')#">
											<cf_wrk_date_image date_field="exp_start#currentrow#">
										</td>
										<td>
											<cfinput type="text" class="form-control" name="exp_finish#currentrow#" id="exp_finish#currentrow#" value="#dateformat(exp_finish,'dd/mm/yyyy')#">
											<cf_wrk_date_image date_field="exp_finish#currentrow#">
										</td>
										<td>
											<select class="form-control" name="exp_reason_id#currentrow#" id="exp_reason_id#currentrow#">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfloop query="fire_reasons">
													<option value="#reason_id#" <cfif  len(get_work_info.exp_reason_id) and get_work_info.exp_reason_id eq reason_id>selected</cfif>>#reason#</option>
												</cfloop>
											</select>
										</td>
										<td><input type="checkbox" name="is_cont_work#currentrow#" id="is_cont_work#currentrow#" value="1" <cfif get_work_info.is_cont_work eq 1>checked</cfif>></td>
										<td id="sil_#currentrow#"><a href="javascript://" onClick="sil('#currentrow#');" title="<cf_get_lang dictionary_id='57463.Sil'>"><img  src="images/delete_list.gif" border="0" alt="<cf_get_lang dictionary_id='57463.Sil'>" /></a></td>
										<input  type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
									</tr> 
								</cfoutput> 
							</table>
						<cfelse>
							<table id="table_work_info" class="table table-borderless">
								<tr>
									<td><cf_get_lang dictionary_id='31549.Çalışılan Yer'></td>
									<td><cf_get_lang dictionary_id='57579.Sektör'></td>
									<td><cf_get_lang dictionary_id='57571.Ünvan'></td>
									<td><cf_get_lang dictionary_id='57655.Başlama Tarihi'></td>
									<td><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></td>
									<td><cf_get_lang dictionary_id='31530.Ayrılma Nedeni'></td>
									<td><cf_get_lang dictionary_id='31529.Hala Çalışıyorum'></td>
									<td><input type="hidden" name="record_numb" id="record_numb" value="0"></td>
								</tr>
								<input type="hidden" name="exp_name" id="exp_name" value="">
								<input type="hidden" name="exp_sector_cat" id="exp_sector_cat" value="">
								<input type="hidden" name="exp_task_id" id="exp_task_id" value="">
								<input type="hidden" name="exp_start" id="exp_start" value="">
								<input type="hidden" name="exp_finish" id="exp_finish" value="">
								<input type="hidden" name="exp_reason_id" id="exp_reason_id" value="">
								<input type="hidden" name="is_cont_work" id="is_cont_work" value="">
							</table>
						</cfif>
					<!--- </td>
				</tr> --->
				<cfset frst_row = #get_work_info.recordcount# + 1>
				<cfloop from="#frst_row#" to="3" index="i">
					<tr>
						<cfoutput>
						<input type="hidden" name="empapp_row_id#i#" id="empapp_row_id#i#" value="" class="boxtext">
						<td>
							<input type="text" class="form-control" name="exp_name#i#" id="exp_name#i#" value="">
							<select class="form-control" name="exp_sector_cat#i#" id="exp_sector_cat#i#">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfloop query="get_sector">
									<option value="#sector_cat_id#">#sector_cat#</option>
								</cfloop>
							</select>
							<select class="form-control" name="exp_task_id#i#" id="exp_task_id#i#">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfloop query="get_task">
									<option value="#partner_position_id#">#partner_position#</option>
								</cfloop>
							</select>
							<cfinput class="form-control" type="text" name="exp_start#i#" id="exp_start#i#" value="">
							<cf_wrk_date_image date_field="exp_start#i#">
							<cfinput class="form-control" type="text" name="exp_finish#i#" id="exp_finish#i#" value="">
							<cf_wrk_date_image date_field="exp_finish#i#">
							<select class="form-control" name="exp_reason_id#i#" id="exp_reason_id#i#">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfloop query="fire_reasons">
									<option value="#reason_id#">#reason#</option>
								</cfloop>
							</select>
							<input type="checkbox" name="is_cont_work#i#" id="is_cont_work#i#" value="1">
						</td>
						<td id="sil_#i#"><a href="javascript://" onClick="sil('#i#');" title="<cf_get_lang dictionary_id='57463.Sil'>"><img  src="images/delete_list.gif" alt="<cf_get_lang dictionary_id='57463.Sil'>"  border="0" /></a></td>
							<input type="hidden" name="row_kontrol#i#" id="row_kontrol#i#" value="1">
						</td> 
						</cfoutput>
					</tr>  
				</cfloop>				
			</table>
		</div>					
		<div class="table-responsive-xl">
			<table class="table table-borderless">
				<tr>
					<td>
						<p class="font-weight-bold"><cf_get_lang dictionary_id='33172.Yabancı Dil'></p>
					</td>
				</tr>
				<tr class="main-bg-color">						
					<td><cf_get_lang dictionary_id='58996.Dil'></td>
					<td><cf_get_lang dictionary_id='35163.Konuşma'></td>
					<td><cf_get_lang dictionary_id='35164.Anlama'></td>
					<td><cf_get_lang dictionary_id='31306.Yazma'></td>
					<td><cf_get_lang dictionary_id='31307.Öğrenildiği Yer'></td>
				</tr>
				<cfloop query="get_app_lang">
					<tr>
						<input type="hidden" name="lang_id<cfoutput>#currentrow#</cfoutput>" id="lang_id<cfoutput>#currentrow#</cfoutput>" value="<cfoutput>#id#</cfoutput>">
						<td><select class="form-control" name="lang<cfoutput>#currentrow#</cfoutput>" id="lang<cfoutput>#currentrow#</cfoutput>">
								<option value=""><cf_get_lang dictionary_id='35167.Dil Seçiniz'>
								<cfoutput query="get_languages">
									<option value="#language_id#" <cfif get_languages.language_id eq get_app_lang.lang_id>selected</cfif>>#language_set# 
								</cfoutput>
							</select>
						</td>
						<td><select class="form-control" name="lang<cfoutput>#currentrow#</cfoutput>_speak" id="lang<cfoutput>#currentrow#</cfoutput>_speak">
								<cfoutput query="know_levels">
									<option value="#knowlevel_id#" <cfif get_app_lang.lang_speak eq knowlevel_id>selected</cfif>>#knowlevel# 
								</cfoutput>
							</select>
						</td>
						<td><select class="form-control" name="lang<cfoutput>#currentrow#</cfoutput>_mean" id="lang<cfoutput>#currentrow#</cfoutput>_mean">
								<cfoutput query="know_levels">
									<option value="#knowlevel_id#" <cfif get_app_lang.lang_mean eq knowlevel_id>selected</cfif>>#knowlevel#
								</cfoutput>
							</select>
						</td>
						<td><select class="form-control" name="lang<cfoutput>#currentrow#</cfoutput>_write" id="lang<cfoutput>#currentrow#</cfoutput>_write">
								<cfoutput query="know_levels">
									<option value="#knowlevel_id#" <cfif get_app_lang.lang_write eq knowlevel_id>selected</cfif>>#knowlevel# 
								</cfoutput>
							</select>
						</td>
						<td><input type="text" class="input_1 form-control" name="lang<cfoutput>#currentrow#</cfoutput>_where"  id="lang<cfoutput>#currentrow#</cfoutput>_where" value="<cfoutput>#get_app_lang.lang_where#</cfoutput>" maxlength="50"></td>
					</tr>
				</cfloop>
				<cfloop from="#get_app_lang.recordcount+1#" to="5" index="i">
					<tr>
						<input type="hidden" name="lang_id<cfoutput>#i#</cfoutput>" id="lang_id<cfoutput>#i#</cfoutput>" value="">
						<td><select class="form-control" name="lang<cfoutput>#i#</cfoutput>" id="lang<cfoutput>#i#</cfoutput>">
								<option value=""><cf_get_lang dictionary_id='35167.Dil Seçiniz'>
								<cfoutput query="get_languages">
									<option value="#language_id#">#language_set# 
								</cfoutput>
							</select>
						</td>
						<td><select class="form-control" name="lang<cfoutput>#i#</cfoutput>_speak" id="lang<cfoutput>#i#</cfoutput>_speak">
								<cfoutput query="know_levels">
									<option value="#knowlevel_id#">#knowlevel#
								</cfoutput>
							</select>
						</td>
						<td><select class="form-control" name="lang<cfoutput>#i#</cfoutput>_mean" id="lang<cfoutput>#i#</cfoutput>_mean">
								<cfoutput query="know_levels">
									<option value="#knowlevel_id#">#knowlevel#
								</cfoutput>
							</select>
						</td>
						<td><select class="form-control" name="lang<cfoutput>#i#</cfoutput>_write" id="lang<cfoutput>#i#</cfoutput>_write">
								<cfoutput query="know_levels">
									<option value="#knowlevel_id#">#knowlevel#
								</cfoutput>
							</select>
						</td>
						<td><input type="text" class="input_1 form-control"  name="lang<cfoutput>#i#</cfoutput>_where" id="lang<cfoutput>#i#</cfoutput>_where" value="" maxlength="50"></td>
					</tr>
				</cfloop>
			</table>
		</div>
				
		<cfif isdefined("attributes.is_useable_info") and attributes.is_useable_info eq 1>
			<div class="table-responsive-xl">
				<table class="table table-borderless">
					<tr>
						<td colspan="2" class="font-weight-bold"><cf_get_lang dictionary_id='31301.Bilgisayar Bilgisi'></td>
					</tr>
					<tr>						
						<td>
							<select class="form-control" name="computer_education" id="computer_education" onchange="goster_diger()" style="width:200px;height:95px;" multiple>
								<cfoutput query="get_computer_info">
									<option value="#computer_info_id#" <cfif get_teacher_info.recordcount and len(get_teacher_info.computer_education) and listfind(get_teacher_info.computer_education,computer_info_id,',')>selected</cfif>>#computer_info_name#</option>
								</cfoutput>
									<option value="-1" <cfif get_teacher_info.recordcount and len(get_teacher_info.computer_education) and listfind(get_teacher_info.computer_education,-1,',')>selected</cfif>><cf_get_lang dictionary_id='58156.Diğer'></option>
							</select>
						</td>
						<td id="diger" <cfif get_teacher_info.recordcount and len(get_teacher_info.computer_education) and listfind(get_teacher_info.computer_education,-1,',')>style="display:; vertical-align:top;"<cfelse>style="display:none; vertical-align:top;"</cfif>>
							<textarea class="form-control" name="comp_exp" id="comp_exp" style="width:200px;height:95px;"><cfoutput>#get_app.comp_exp#</cfoutput></textarea>
						</td>
					</tr>
				</table>
			</div>
		</cfif>	
		
		<div class="table-responsive-xl">
			<table class="table table-borderless">
				<tr>
					<td colspan="4"><p class="font-weight-bold"><cf_get_lang dictionary_id='31294.Kurs'> / <cf_get_lang dictionary_id='35216.Seminer'> / <cf_get_lang dictionary_id='35215.Sertifika'> / <cf_get_lang dictionary_id='35217.Sınav Bilgileri'></p></td>
				</tr>
				<tr class="main-bg-color">
					<td><cf_get_lang dictionary_id='57480.Konu'></td>
					<td><cf_get_lang dictionary_id='58455.Yıl'></td>
					<td><cf_get_lang dictionary_id='31296.Yer'></td>
					<td><cf_get_lang dictionary_id='57490.Gün'></td>
				</tr>
				<tr>
					<td><cfinput type="text" class="form-control" name="kurs1" id="kurs1" value="#get_app.kurs1#" maxlength="150"></td>
					<cfsavecontent variable="alert"><cf_get_lang no ='1163.Kurs 1 İçin Yılı Girin'></cfsavecontent>
					<td><cfinput type="text" class="form-control" name="kurs1_yil" id="kurs1_yil" value="#dateformat(get_app.kurs1_yil,'yyyy')#" onKeyUp="isNumber(this);" maxlength="4" range="1900," validate="integer" message="#alert#"></td>
					<td><cfinput type="text" class="form-control" name="kurs1_yer" id="kurs1_yer" value="#get_app.kurs1_yer#" maxlength="150"></td>
					<cfsavecontent variable="alert"><cf_get_lang no ='1164.Kurs 1 Gün Sayısını Girin'></cfsavecontent>
					<td><cfinput type="text" class="form-control" name="kurs1_gun" id="kurs1_gun" value="#get_app.kurs1_gun#" onKeyUp="isNumber(this);" validate="maxlength" message="#alert#" maxlength="50"></td>
				</tr>
				<tr> 
					<td><cfinput type="text" class="form-control" name="kurs2" id="kurs2" value="#get_app.kurs2#" maxlength="150"></td>
					<cfsavecontent variable="alert"><cf_get_lang no ='1165.Kurs 2 İçin Yılı Girin'></cfsavecontent>
					<td><cfinput type="text" class="form-control" name="kurs2_yil" id="kurs2_yil" value="#dateformat(get_app.kurs2_yil,'yyyy')#" onKeyUp="isNumber(this);" maxlength="4" range="1900," validate="integer" message="#alert#"></td>
					<td><cfinput type="text" class="form-control" name="kurs2_yer" id="kurs2_yer" value="#get_app.kurs2_yer#" maxlength="150"></td>
					<cfsavecontent variable="alert"><cf_get_lang no ='1166.Kurs 2 Gün Sayısını Girin'></cfsavecontent>
					<td><cfinput type="text" class="form-control" name="kurs2_gun" id="kurs2_gun" value="#get_app.kurs2_gun#" onKeyUp="isNumber(this);" validate="maxlength" message="#alert#" maxlength="50"></td>
				</tr>  
				<tr>  
					<td><cfinput type="text" class="form-control" name="kurs3" id="kurs3" value="#get_app.kurs3#" maxlength="150"></td>
					<cfsavecontent variable="alert"><cf_get_lang no ='1167.Kurs3 İçin Yılı Girin'></cfsavecontent>
					<td><cfinput type="text" class="form-control" name="kurs3_yil" id="kurs3_yil" value="#dateformat(get_app.kurs3_yil,'yyyy')#" maxlength="4" range="1900," validate="integer" message="#alert#"></td>
					<td><cfinput type="text" class="form-control" name="kurs3_yer" id="kurs3_yer" value="#get_app.kurs3_yer#" maxlength="150"></td>
					<cfsavecontent variable="alert"><cf_get_lang no ='1168.Kurs 3 Gün Sayısını Girin'></cfsavecontent>
					<td><cfinput type="text" class="form-control" name="kurs3_gun" id="kurs3_gun" value="#get_app.kurs3_gun#" validate="maxlength" message="#alert#" maxlength="50"></td>
				</tr>
			</table>
		</div>
			
		<div class="table-responsive-xl">
			<table id="ref_info" class="table table-borderless">
				<tr>
					<td colspan="4" class="font-weight-bold"><cf_get_lang dictionary_id='31695.Referans Bilgileri'></td>
				</tr>
				<tr>
					<td colspan="4"><cf_get_lang dictionary_id='35174.Hakkınızda Bilgi Edinebileceğimiz Kişiler'></td>
				</tr>
				<input type="hidden" name="add_ref_info" id="add_ref_info" value="<cfoutput>#get_emp_reference.recordcount#</cfoutput>">
				<tr class="main-bg-color">
					<td><cf_get_lang dictionary_id='31063.Referans Tipi'></td>
					<td><cf_get_lang dictionary_id='57570.Ad Soyad'></td>
					<td><cf_get_lang dictionary_id='57574.Şirket'></td>
					<td><cf_get_lang dictionary_id='48176.Telefon No'></td>
					<td><cf_get_lang dictionary_id='58497.Pozisyon'></td>
					<td><cf_get_lang dictionary_id='57428.E-posta'></td>
					<td><a style="cursor:hand; cursor:pointer;" onClick="add_ref_info_();"><img src="images/plus_list.gif" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></a></td>
				</tr>
				<input type="hidden" name="referance_info" id="referance_info" value="<cfoutput>#get_emp_reference.recordcount#</cfoutput>">
				<cfif isdefined("get_emp_reference")>
					<cfoutput query="get_emp_reference">
						<tr id="ref_info_#currentrow#">
							<td>
								<select class="form-control" name="ref_type#currentrow#" id="ref_type#currentrow#">
									<option value="">Referans Tipi</option>
									<option value="1"<cfif len(get_emp_reference.reference_type) and (get_emp_reference.reference_type eq 1)>selected</cfif>>Grup İçi</option>
									<option value="2"<cfif len(get_emp_reference.reference_type) and (get_emp_reference.reference_type eq 2)>selected</cfif>>Diğer</option>
								</select>
							</td>
							<td><input type="text" name="ref_name#currentrow#" id="ref_name#currentrow#" value="#reference_name#" class="input_1 form-control"></td>
							<td><input type="text" name="ref_company#currentrow#" id="ref_company#currentrow#" value="#reference_company#" class="input_1 form-control"></td>
							<td><input type="text" name="ref_telcode#currentrow#" id="ref_telcode#currentrow#" onKeyUp="isNumber(this);" value="#reference_telcode#" class="input_1 form-control" maxlength="3">
								<input type="text" name="ref_tel#currentrow#" id="ref_tel#currentrow#" onKeyUp="isNumber(this);" value="#reference_tel#" class="input_1 form-control" maxlength="7"></td>
							<td><input type="text" name="ref_position#currentrow#" id="ref_position#currentrow#" value="#reference_position#" class="input_1 form-control"></td>
							<td>
								<input type="text" name="ref_mail#currentrow#" id="ref_mail#currentrow#" value="#reference_email#" class="input_1 form-control">
								<input type="hidden" name="del_ref_info#currentrow#" id="del_ref_info#currentrow#" value="1">
							</td>	
							<td nowrap><a style="cursor:hand; cursor:pointer;" onClick="del_ref('#currentrow#');"><img  src="images/delete_list.gif" border="0"></a></td>
						</tr>
					</cfoutput>
				</cfif>
			</table>
		</div>
			
		<cfif isdefined("attributes.is_salary_info") and attributes.is_salary_info eq 1>
		<div class="table-responsive-xl">	
			<table class="table table-borderless">
				<tr>
					<td><cf_get_lang dictionary_id='35187.Çalışmak İstediği Şube'></td>
					<td>
						<select class="form-control" name="preference_branch" id="preference_branch" style="width:220px; height:100px;" multiple>
							<cfoutput query="get_branch">
								<option value="#branch_id#" <cfif listfind(get_app.preference_branch,branch_id,',')>selected</cfif>>#branch_name# - #branch_city#</option>
							</cfoutput>
						</select>
					</td>
					<td>
						<cf_get_lang dictionary_id='35219.Ücret Beklenti Aralığı'>
					</td>
					<td>
						<select class="form-control" name="salary_range" id="salary_range">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<option value="1" <cfif get_teacher_info.recordcount and len(get_teacher_info.salary_range) and listfind(get_teacher_info.salary_range,1,',')>selected</cfif>>250</option>
							<option value="2" <cfif get_teacher_info.recordcount and len(get_teacher_info.salary_range) and listfind(get_teacher_info.salary_range,2,',')>selected</cfif>>250-500</option>
							<option value="3" <cfif get_teacher_info.recordcount and len(get_teacher_info.salary_range) and listfind(get_teacher_info.salary_range,3,',')>selected</cfif>>500-1000</option>
							<option value="4" <cfif get_teacher_info.recordcount and len(get_teacher_info.salary_range) and listfind(get_teacher_info.salary_range,4,',')>selected</cfif>>1000-1500</option>
							<option value="5" <cfif get_teacher_info.recordcount and len(get_teacher_info.salary_range) and listfind(get_teacher_info.salary_range,5,',')>selected</cfif>>1500-2000</option>
							<option value="6" <cfif get_teacher_info.recordcount and len(get_teacher_info.salary_range) and listfind(get_teacher_info.salary_range,6,',')>selected</cfif>>2000-2500</option>
							<option value="7" <cfif get_teacher_info.recordcount and len(get_teacher_info.salary_range) and listfind(get_teacher_info.salary_range,7,',')>selected</cfif>>2500-3000</option>
							<option value="8" <cfif get_teacher_info.recordcount and len(get_teacher_info.salary_range) and listfind(get_teacher_info.salary_range,8,',')>selected</cfif>>3000-3500</option>
							<option value="9" <cfif get_teacher_info.recordcount and len(get_teacher_info.salary_range) and listfind(get_teacher_info.salary_range,9,',')>selected</cfif>>3500-4000</option>
							<option value="10" <cfif get_teacher_info.recordcount and len(get_teacher_info.salary_range) and listfind(get_teacher_info.salary_range,10,',')>selected</cfif>>4000-4500</option>
							<option value="11" <cfif get_teacher_info.recordcount and len(get_teacher_info.salary_range) and listfind(get_teacher_info.salary_range,11,',')>selected</cfif>>4500-5000</option>
							<option value="12" <cfif get_teacher_info.recordcount and len(get_teacher_info.salary_range) and listfind(get_teacher_info.salary_range,12,',')>selected</cfif>>5000-5500</option>
							<option value="13" <cfif get_teacher_info.recordcount and len(get_teacher_info.salary_range) and listfind(get_teacher_info.salary_range,13,',')>selected</cfif>>5500-6000</option>
							<option value="14" <cfif get_teacher_info.recordcount and len(get_teacher_info.salary_range) and listfind(get_teacher_info.salary_range,14,',')>selected</cfif>>6000-6500</option>
							<option value="15" <cfif get_teacher_info.recordcount and len(get_teacher_info.salary_range) and listfind(get_teacher_info.salary_range,15,',')>selected</cfif>>6500-7000</option>
							<option value="16" <cfif get_teacher_info.recordcount and len(get_teacher_info.salary_range) and listfind(get_teacher_info.salary_range,16,',')>selected</cfif>>7000-7500</option>
							<option value="17" <cfif get_teacher_info.recordcount and len(get_teacher_info.salary_range) and listfind(get_teacher_info.salary_range,17,',')>selected</cfif>>7500-8000</option>
							<option value="18" <cfif get_teacher_info.recordcount and len(get_teacher_info.salary_range) and listfind(get_teacher_info.salary_range,18,',')>selected</cfif>>8000-8500</option>
							<option value="19" <cfif get_teacher_info.recordcount and len(get_teacher_info.salary_range) and listfind(get_teacher_info.salary_range,19,',')>selected</cfif>>8500-9000</option>
							<option value="20" <cfif get_teacher_info.recordcount and len(get_teacher_info.salary_range) and listfind(get_teacher_info.salary_range,20,',')>selected</cfif>>9000-9500</option>
							<option value="21" <cfif get_teacher_info.recordcount and len(get_teacher_info.salary_range) and listfind(get_teacher_info.salary_range,21,',')>selected</cfif>>9500-10000</option>
						</select>
					</td>
				</tr>
			</table>
		</div>
		<cfelse>
		<div class="table-responsive-xl">
			<table class="table table-borderless">
				<tr>
					<td colspan="2" class="font-weight-bold"><cf_get_lang dictionary_id='35187.Çalışmak İstediği Şube'></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='29434.Şubeler'></td>
					<td><select class="form-control" name="preference_branch" id="preference_branch" style="width:200px; height:100px;" multiple>
							<cfoutput query="get_branch">
								<option value="#branch_id#" <cfif listfind(get_app.preference_branch,branch_id,',')>selected</cfif>>#branch_name# - #branch_city#</option>
							</cfoutput>
						</select>
					</td>
				</tr>
			</table>
		</div>
		</cfif>	
		<table class="table table-borderless">			
			<tr><cfsavecontent variable="alert"><cf_get_lang dictionary_id='57464.Güncelle'></cfsavecontent>
				<td colspan="4">
					<!--- <cf_workcube_buttons is_upd='0' insert_info='#alert#' add_function='kontrol_dosya()'> --->
					<cf_workcube_buttons is_insert='1' insert_info='#alert#'	data_action="/V16/objects2/career/cfc/data_career:fast_cv" next_page="#request.self#" add_function='kontrol_dosya()'>
				</td>
			</tr>
		</table>
	</cfform>
	<script type="text/javascript">
		<cfset edu_id_var_ = 0>
		<cfset edu_part_id_var_ = 0>
		
		<!---	<cfif isdefined('get_work_info') and (get_work_info.recordcount)>
			row_count=<cfoutput>#get_work_info.recordcount#</cfoutput>;
			satir_say=0;
		<cfelse>
			row_count=0;
			satir_say=0;
		</cfif>
		
		if(row_count == 0)
		{
			gonder();
			gonder();
			gonder();
		}
		else if(row_count == 1)
		{
			gonder();
			gonder();
		}
		else if(row_count == 2)
		{
			gonder();
		} --->
		
		<cfif isdefined('get_app_edu_univ') and (get_app_edu_univ.recordcount)>
			row_edu=<cfoutput>#get_app_edu_univ.recordcount#</cfoutput>;
			satir_say_edu=0;
			<cfoutput query="get_app_edu_univ">
				<cfif edu_id eq -1><cfset edu_id_var_ = 1></cfif>
				<cfif edu_part_id eq -1><cfset edu_part_id_var_ = 1></cfif>
			</cfoutput>
		<cfelse>
			row_edu=0;
			satir_say_edu=0;
		</cfif>
		
		if(row_edu == 0)
		{  
			gonder_edu();
			gonder_edu();
			gonder_edu();
		}
		else if(row_edu == 1)
		{
			gonder_edu();
			gonder_edu();
		}
		else if(row_edu == 2)
		{
			gonder_edu();
		}
		
		var homecountry_ = document.getElementById('homecountry').value;
		
		<cfif not len(get_app.homecity) and not len(get_app.homecounty)>
			LoadCity(homecountry_,'homecity','homecounty',0)
		</cfif>
		
		var homecity_ = document.getElementById('homecity').value;
		<cfif not len(get_app.homecounty)>
			if(homecity_.length)
				LoadCounty(homecity_,'homecounty')
		</cfif>
	
		var a = 0;
		<cfoutput>
			<cfif get_cv_unit_max.recordcount>
				unit_count=#get_cv_unit_max.max_id#;
			<cfelse>
				unit_count=0;
			</cfif>
		</cfoutput>
		
		function goster_()
		{
			if(document.employe_fastcv_detail.formation[0].checked == true) formation_type.style.display = '';
			if(document.employe_fastcv_detail.formation[1].checked == true)
			{
				formation_type.style.display = 'none';
				document.getElementById('formation_typee').value = 0;
			}
		}
		
		function sil(sy)
		{
			eval("document.getElementById('exp_name"+sy+"')").value = '';
			eval("document.getElementById('exp_sector_cat"+sy+"')").value = '';
			eval("document.getElementById('exp_task_id"+sy+"')").value = '';
			eval("document.getElementById('exp_start"+sy+"')").value = '';
			eval("document.getElementById('exp_finish"+sy+"')").value = '';
			eval("document.getElementById('exp_reason_id"+sy+"')").value = '';
			eval("document.getElementById('is_cont_work"+sy+"')").value = '';
			var my_element=eval("sil_"+sy);
			my_element.style.display="none";
		}
		
		function gonder(exp_name,exp_start,exp_finish,exp_sector_cat,exp_task_id,exp_reason_id,is_cont_work)
		{   
			if(exp_name == undefined)exp_name = '';
			if(exp_start == undefined)exp_start = '';
			if(exp_finish == undefined)exp_finish = '';
			if(exp_sector_cat == undefined)exp_sector_cat = '';
			if(exp_task_id == undefined)exp_task_id = '';
			if(exp_reason_id == undefined)exp_reason_id = '';
			if(is_cont_work == undefined)is_cont_work = '';
				row_count++;
				employe_fastcv_detail.row_count.value = row_count;
				satir_say++;
				var new_Row;
				var new_Cell;
				new_Row = document.getElementById("table_work_info").insertRow(document.getElementById("table_work_info").rows.length);
				new_Row.setAttribute("name","frm_row" + row_count);
				new_Row.setAttribute("id","frm_row" + row_count);		
				new_Row.setAttribute("NAME","frm_row" + row_count);
				new_Row.setAttribute("ID","frm_row" + row_count);		
				new_Cell = new_Row.insertCell(new_Row.cells.length);
				new_Cell.innerHTML = '<input type="text" name="exp_name' + row_count + '" id="exp_name' + row_count + '" value="'+ exp_name +'" style="width:85px;">';
				new_Cell = new_Row.insertCell(new_Row.cells.length);
				new_Cell.innerHTML = '<select name="exp_sector_cat'+ row_count +'" id="exp_sector_cat'+ row_count +'" style="width:90px;"><option value=""><cf_get_lang_main no ="322.Seçiniz"></option><cfif get_sector.recordcount><cfoutput query="get_sector"><option value="#sector_cat_id#">#sector_cat#</option></cfoutput></cfif></select>';
				new_Cell = new_Row.insertCell(new_Row.cells.length);
				new_Cell.innerHTML = '<select name="exp_task_id'+ row_count +'" id="exp_task_id'+ row_count +'" style="width:90px;"><option value=""><cf_get_lang_main no ="322.Seçiniz"></option><cfif get_task.recordcount><cfoutput query="get_task"><option value="#partner_position_id#">#partner_position#</option></cfoutput></cfif></select>';
				new_Cell = new_Row.insertCell(new_Row.cells.length);
				new_Cell.setAttribute("id","exp_start" + row_count + "_td");
				new_Cell.innerHTML = '<input type="text" name="exp_start' + row_count + '" id="exp_start' + row_count + '" value="'+ exp_start +'" style="width:67px;">';
				wrk_date_image('exp_start' + row_count);
				new_Cell = new_Row.insertCell(new_Row.cells.length);
				new_Cell.setAttribute("id","exp_finish" + row_count + "_td");
				new_Cell.innerHTML = '<input type="text" name="exp_finish' + row_count + '" id="exp_finish' + row_count + '" value="'+ exp_finish +'" style="width:67px;">';
				wrk_date_image('exp_finish' + row_count);
				new_Cell = new_Row.insertCell(new_Row.cells.length);
				new_Cell.innerHTML = '<select name="exp_reason_id'+ row_count +'" id="exp_reason_id'+ row_count +'" style="width:90px;"><option value=""><cf_get_lang_main no ="322.Seçiniz"></option><cfif fire_reasons.recordcount><cfoutput query="fire_reasons"><option value="#reason_id#">#reason#</option></cfoutput></cfif></select>';
				new_Cell = new_Row.insertCell(new_Row.cells.length);
				new_Cell.innerHTML = '<input type="checkbox" name="is_cont_work' + row_count + '" id="is_cont_work' + row_count + '" value="1">';
				new_Cell = new_Row.insertCell(new_Row.cells.length);
				new_Cell.innerHTML = '<input  type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" >';
		}
		
		
		/*Eğitim Bilgileri*/
		//lise sil
		function sil_edu_lise_()
		{
			document.getElementById('edu_id_lise').value = '';
			document.getElementById('edu_name_lise').value = '';
			document.getElementById('edu_part_id_lise').value = '';
			document.getElementById('edu_part_name_lise').value = '';
			document.getElementById('edu_start_lise').value = '';
			document.getElementById('edu_finish_lise').value = '';
			sil_edu_lise.style.display="none";
		}
				
		function sil_edu(sv)
		{
			eval("document.getElementById('edu_type"+sv+"')").value = '';
			eval("document.getElementById('edu_id"+sv+"')").value = '';
			eval("document.getElementById('edu_name"+sv+"')").value = '';
			eval("document.getElementById('edu_part_id"+sv+"')").value = '';
			eval("document.getElementById('edu_part_name"+sv+"')").value = '';
			eval("document.getElementById('edu_start"+sv+"')").value = '';
			eval("document.getElementById('edu_finish"+sv+"')").value = '';
			var my_element=eval("sil_edu_"+sv);
			my_element.style.display="none";
		}
		function gonder_edu(edu_type,edu_id,edu_name,edu_part_id,edu_part_name,edu_start,edu_finish/*,edu_rank*/)
		{  
			if (edu_type == undefined) edu_type = '';
			if (edu_id == undefined) edu_id = '';
			if (edu_name == undefined) edu_name = '';
			if (edu_part_id == undefined) edu_part_id = '';
			if (edu_part_name == undefined) edu_part_name = '';
			if (edu_start == undefined) edu_start = '';
			if (edu_finish == undefined) edu_finish = '';
		
				row_edu++;
				employe_fastcv_detail.row_edu.value = row_edu;
				satir_say_edu++;
				var new_Row_Edu;
				var new_Cell_Edu;
				new_Row_Edu = document.getElementById("table_edu_info").insertRow(document.getElementById("table_edu_info").rows.length);
				new_Row_Edu.setAttribute("name","frm_row_edu" + row_edu);
				new_Row_Edu.setAttribute("id","frm_row_edu" + row_edu);		
				new_Row_Edu.setAttribute("NAME","frm_row_edu" + row_edu);
				new_Row_Edu.setAttribute("ID","frm_row_edu" + row_edu);
				
				new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
				new_Cell_Edu.innerHTML = '<select name="edu_type'+ row_edu +'" id="edu_type'+ row_edu +'" style="width:80px;"><option value="4"><cf_get_lang_main no ="1958.Üniversite"></option><option value="5"><cf_get_lang no ="526.Yükseklisans"></option><option value="6"><cf_get_lang no ="840.Doktora"></option></select>';
				
				new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
				new_Cell_Edu.innerHTML = '<select name="edu_id'+ row_edu +'" id="edu_id'+ row_edu +'" style="width:120px;" onchange="eduname_goster('+ row_edu +')"><option value=""><cf_get_lang_main no="322.Seçiniz"></option><cfif get_unv.recordcount><cfoutput query="get_unv"><option value="#school_id#">#school_name#</option></cfoutput></cfif><option value="-1"><cf_get_lang_main no="744.Diğer"></option></select>';
				
				new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
				new_Cell_Edu.id = 'tr_eduname'+row_edu;
				new_Cell_Edu.style.display = 'none';
				new_Cell_Edu.innerHTML = '<input type="text" name="edu_name' + row_edu + '" id="edu_name' + row_edu + '" value="'+ row_edu +'" style="width:120px;">';
				
				new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
				new_Cell_Edu.id = 'tr_bosluk'+row_edu;
				if(<cfoutput> #edu_id_var_#!= 0 && #edu_id_var_# == 1</cfoutput>)new_Cell_Edu.style.display = ''; else new_Cell_Edu.style.display = 'none';
				new_Cell_Edu.innerHTML = '<input type="hidden" name="bosluk' + row_edu + '" id="bosluk' + row_edu + '" value="" style="width:120px;">';
				
				new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
				new_Cell_Edu.innerHTML = '<select name="edu_part_id'+ row_edu +'" id="edu_part_id'+ row_edu +'" style="width:120px;" onchange="edu_partname_goster('+ row_edu +')"><option value=""><cf_get_lang_main no="322.Seçiniz"></option><cfif get_school_part.recordcount><cfoutput query="get_school_part"><option value="#part_id#">#part_name#</option></cfoutput></cfif><option value="-1"><cf_get_lang_main no="744.Diğer"></option></select>';
				
				new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
				new_Cell_Edu.id = 'tr_edu_partname'+row_edu;
				new_Cell_Edu.style.display = 'none';
				new_Cell_Edu.innerHTML = '<inputtype="text" name="edu_part_name' + row_edu + '" id="edu_part_name' + row_edu + '" value="'+ edu_part_name +'" style="width:100px;" >';
				
				new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
				new_Cell_Edu.id = 'tr_partbosluk'+row_edu;
				if(<cfoutput>#edu_part_id_var_# != 0 && #edu_part_id_var_# == 1</cfoutput>)new_Cell_Edu.style.display = ''; else new_Cell_Edu.style.display = 'none';
				new_Cell_Edu.innerHTML = '<input type="hidden" name="partbosluk' + row_edu + '" id="partbosluk' + row_edu + '" value="" style="width:100;">';
				
				new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
				new_Cell_Edu.innerHTML = '<input type="text" name="edu_start' + row_edu + '" id="edu_start' + row_edu + '" value="'+ edu_start +'" onKeyUp="isNumber(this);" maxlength="4" validate="integer" range="1900," style="width:50px;">';
				
				new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
				new_Cell_Edu.innerHTML = '<input type="text" name="edu_finish' + row_edu + '" id="edu_finish' + row_edu + '" value="'+ edu_finish +'" onKeyUp="isNumber(this);" maxlength="4" validate="integer" range="1900," style="width:50px;">';
					
				new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
				new_Cell_Edu.innerHTML = '<input  type="hidden" name="row_kontrol_edu' + row_edu +'" id="row_kontrol_edu' + row_edu +'" value="1" >';
		}
	
		
		function eduname_goster(row_edu)
		{
			if(eval('document.getElementById("edu_id'+row_edu+'")').value == -1)
			{
				eval('tr_eduname'+row_edu).style.display='';
				eval('document.getElementById("edu_name'+row_edu+'")').value ='';
				eval('tr_bosluk'+row_edu).style.display='none';
				tr_eduname_.style.display='';
				for(i=1;i<=3;i++)
				{
					if(row_edu != i && eval('document.getElementById("edu_id'+i+'")').value != -1)
					{
						eval('tr_bosluk'+i).style.display='';
						eval('tr_eduname'+i).style.display='none';
					}
				}
			 }
			else
			{
				eval('tr_eduname'+row_edu).style.display='none';
				eval('tr_bosluk'+row_edu).style.display='';   
				if(eval('document.getElementById("edu_id'+1+'")').value != -1 && eval('document.getElementById("edu_id'+2+'")').value != -1 && eval('document.getElementById("edu_id'+3+'")').value != -1)
				{
					tr_eduname_.style.display='none';
					for(i=1;i<=3;i++)
					{
						eval('tr_bosluk'+i).style.display='none';
					}
				}
			}
			if(eval("document.getElementById('edu_id"+row_edu+"')") != undefined && eval("document.getElementById('edu_id"+row_edu+"')").value != '' && eval("document.getElementById('edu_id"+row_edu+"')").value != -1)
			{
				var get_cv_edu_id = wrk_safe_query("obj2_get_cv_edu_new",'dsn',0,eval("document.getElementById('edu_id"+row_edu+"')").value);
				if(get_cv_edu_id.recordcount)	
					eval("document.getElementById('edu_name"+row_edu+"')").value = get_cv_edu_id.SCHOOL_NAME;
			}
		}
		function edu_partname_goster(row_edu)
		{
			if(eval('document.getElementById("edu_part_id'+row_edu+'")').value == -1)
			{
				eval('tr_edu_partname'+row_edu).style.display='';
				eval('document.getElementById("edu_part_name'+row_edu+'")').value ='';
				eval('tr_partbosluk'+row_edu).style.display='none';
				tr_edupartname_.style.display='';
				for(i=1;i<=3;i++)
				{    
					if(row_edu != i && eval('document.getElementById("edu_part_id'+i+'")').value != -1)
					{
						eval('tr_partbosluk'+i).style.display='';
						eval('tr_edu_partname'+i).style.display='none';
					}
				}
			 }
			else
			{
				eval('tr_edu_partname'+row_edu).style.display='none';
				eval('tr_partbosluk'+row_edu).style.display=''; 
				if(eval('document.getElementById("edu_part_id'+1+'")').value != -1 && eval('document.getElementById("edu_part_id'+2+'")').value != -1 && eval('document.getElementById("edu_part_id'+3+'")').value != -1)
				{
					tr_edupartname_.style.display='none';   
					for(i=1;i<=3;i++)     
					{
						eval('tr_partbosluk'+i).style.display='none';
					}
				}
			}
			if(eval('document.getElementById("edu_part_id'+row_edu+'")') != undefined && eval('document.getElementById("edu_part_id'+row_edu+'")').value != '' && eval('document.getElementById("edu_part_id'+row_edu+'")').value != -1)
			{
				var cv_edu_part_id_sql = 'SELECT PART_ID, PART_NAME FROM SETUP_SCHOOL_PART WHERE PART_ID = '+eval('document.getElementById("edu_part_id'+row_edu+'")').value+'';
				var get_cv_edu_part_id = wrk_safe_query("obj2_get_cv_edu_part_id",'dsn',0,eval('document.getElementById("edu_part_id'+row_edu+'")').value);
				if(get_cv_edu_part_id.recordcount)
					eval('document.getElementById("edu_part_name'+row_edu+'")').value = get_cv_edu_part_id.PART_NAME;
			}
		}    
		function lise_adi_ac()
		{
			if(document.getElementById('edu_part_id_lise').value == -1)
			{
				edu_part.style.display = '';
				bolum_adi.style.display = '';
				document.getElementById('edu_part_name_lise').value = '';
			}
			else
			{
				edu_part.style.display = 'none';
				bolum_adi.style.display = 'none';
			}
		}
		function kontrol_dosya()
		{
			if(document.employe_fastcv_detail.asset_file != undefined && document.employe_fastcv_detail.asset_file.value != "" && document.employe_fastcv_detail.asset_file_name.value == "")
			{
				alert("<cf_get_lang no ='1178.Dosya Adını Boş Bırakamazsınız'>!");
				return false;
			}
			
			var tarih_ = fix_date_value(document.getElementById('birth_date').value);
			if(tarih_.substr(6,4) < 1900)
			{
				alert("<cf_get_lang_main no='370.Tarih Değerini Kontrol Ediniz'>!");
				return false;
			}
			
			if(document.employe_fastcv_detail.sex[0].checked == false && document.employe_fastcv_detail.sex[1].checked == false)
			{
				alert("<cf_get_lang no='565.Cinsiyet Alanı Zorunludur'>!");
				return false;
			}
			if(document.employe_fastcv_detail.married[0].checked == false && document.employe_fastcv_detail.married[1].checked == false)
			{
				alert("<cf_get_lang no='880.Medeni Durumunuzu Girmelisiniz'>!");
				return false;
			}
			x = document.employe_fastcv_detail.homecountry.selectedIndex;
			if (document.employe_fastcv_detail.homecountry[x].value == "")
			{ 
				alert ("<cf_get_lang no='509.Lütfen Ülke Seçiniz'> !");
				return false;
			}
			if(document.getElementById('homecity').value == "" && document.employe_fastcv_detail.homecountry[x].value == 1)
			{
				alert("<cf_get_lang no='32.Il Seçiniz'> !");
				return false;
			}
			if(document.getElementById('homecounty').value == "" && document.employe_fastcv_detail.homecountry[x].value == 1)
			{
				alert("<cf_get_lang no='1357.Lutfen Ilce Seciniz'>");
				return false;
			}
			return true;
		}
		function show_other_types(no)
		{
			var branches_id = eval("document.getElementById('emp_app_info_"+no+"')").options.length;	
			var branches_id_list = '';
			for(i=0;i<branches_id;i++)
				{
					if(eval("document.getElementById('emp_app_info_"+no+"')").options[i].selected && branches_id_list.length==0)
						branches_id_list = branches_id_list + eval("document.getElementById('emp_app_info_"+no+"')").options[i].value;
					else if(eval("document.getElementById('emp_app_info_"+no+"')").options[i].selected)
						branches_id_list = branches_id_list + ',' + eval("document.getElementById('emp_app_info_"+no+"')").options[i].value;
				}
			if(list_find(branches_id_list,-1))
				eval("other_branches_"+no).style.display = '';
			else
			{
				eval("other_branches_"+no).style.display = 'none';
				eval("document.getElementById('other_branches_name_"+no+"')").value = '';
			}	
		}
		function goster_diger()
		{
			var education_id = document.employe_fastcv_detail.computer_education.options.length;	
			var education_id_list = '';
			for(i=0;i<education_id;i++)
			{
				if(document.employe_fastcv_detail.computer_education.options[i].selected && education_id_list.length==0)
					education_id_list = education_id_list + document.employe_fastcv_detail.computer_education.options[i].value;
				else if(document.employe_fastcv_detail.computer_education.options[i].selected)
					education_id_list = education_id_list + ',' + document.employe_fastcv_detail.computer_education.options[i].value;
			}
			if(list_find(education_id_list,-1)) diger.style.display = '';
			else
			{
				diger.style.display = 'none';
				document.employe_fastcv_detail.comp_exp.value = '';
			}			
		}
		function seviye_kontrol(nesne)
		{
			for(var j=1;j<=unit_count;j++)
			{
				var diger_nesne=eval('document.getElementById("unit'+j+'")');
				if(diger_nesne!=undefined && diger_nesne!=nesne)
				{
					if(diger_nesne.value.length!=0 && nesne.value==diger_nesne.value)
					{
						alert("<cf_get_lang no='868.İki tane aynı seviye giremezsiniz'>!");
						diger_nesne.value='';
					}
				}
			}
		}
		
		function seviye(i)
		{
			if(i==1) document.getElementById('defected_level').disabled=false;
			else document.getElementById('defected_level').disabled=true;
		}
		
		function remove_adress(parametre)
		{
			if(parametre==1)
			{
				document.getElementById('homecity').value = '';
				document.getElementById('homecounty').value = '';
			}
			else
			{
				document.getElementById('homecounty').value = '';
			}	
		}
		
		var add_ref_info=<cfif isdefined("get_emp_reference")><cfoutput>#get_emp_reference.recordcount#</cfoutput><cfelse>0</cfif>;
		
		function add_ref_info_()
		{
			add_ref_info++;
			document.getElementById('add_ref_info').value = add_ref_info;
			var newRow;
			var newCell;
			newRow = document.getElementById("ref_info").insertRow(document.getElementById("ref_info").rows.length);
			newRow.setAttribute("name","ref_info_" + add_ref_info);
			newRow.setAttribute("id","ref_info_" + add_ref_info);
			document.getElementById('referance_info').value=add_ref_info;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="ref_type' + add_ref_info +'" id="ref_type' + add_ref_info +'" style="width:95px;"><option value="">Referans Tipi</option><option value="1">Gurup İçi</option><option value="2">Diğer</option></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<input type="text" class="input_1" name="ref_name' + add_ref_info +'" id="ref_name' + add_ref_info +'" style=" width:90px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<input type="text" class="input_1" name="ref_company' + add_ref_info +'" id="ref_company' + add_ref_info +'" style=" width:90px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<input type="text" class="input_1" name="ref_telcode' + add_ref_info +'" id="ref_telcode' + add_ref_info +'" onKeyUp="isNumber(this);" maxlength="3" style=" width:40px;">&nbsp;<input type="text" name="ref_tel' + add_ref_info +'" id="ref_tel' + add_ref_info +'" onKeyUp="isNumber(this);" maxlength="7" style=" width:90px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<input type="text" class="input_1" name="ref_position' + add_ref_info +'" id="ref_position' + add_ref_info +'" style=" width:90px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<input type="text" class="input_1" name="ref_mail' + add_ref_info +'" id="ref_mail' + add_ref_info +'" style=" width:90px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<input type="hidden" value="1" name="del_ref_info'+ add_ref_info +'" id="del_ref_info'+ add_ref_info +'"><a style="cursor:hand; cursor:pointer;" onclick="del_ref(' + add_ref_info + ');"><img  src="images/delete_list.gif" border="0" alt="<cf_get_lang_main no ="51.sil">"></a>';
		}
			
		function del_ref(dell){
			var my_emement1 = eval("document.getElementById('del_ref_info"+dell+"')")
			my_emement1.value=0;
			var my_element1=eval("ref_info_"+dell);
			my_element1.style.display="none";
		}
	</script>
</cfif>
