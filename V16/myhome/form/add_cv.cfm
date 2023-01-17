<cf_box title="#getLang('','CV Kayıt',31671)#" closable="0">
	<cfform name="employe_detail" method="post" action="#request.self#?fuseaction=myhome.emptypopup_add_cv" enctype="multipart/form-data">
		<cf_seperator id="kimlik_iletisim_bilgileri" header="#getLang('','Kimlik ve İletişim Bilgileri',31647)#" is_closed="1">
			<cf_box_elements id="kimlik_iletisim_bilgileri" style="display:none;">
				<div class="col col-5 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
						<div class="col col-8 col-sm-12">
							<cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
						</div>                
					</div> 
					<div class="form-group" id="item-name">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57631.Ad'>*</label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" value="#GET_HR.EMPLOYEE_NAME#" name="name" id="name" maxlength="50" required="Yes" message="#getLang('','Ad girmelisiniz',58939)# !">
						</div>                
					</div>
					<div class="form-group" id="item-surname">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58726.Soyad'>*</label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text"value="#GET_HR.EMPLOYEE_SURNAME#" name="surname" maxlength="50" required="Yes" message="#getLang('','Soyad girmelisiniz',29503)#">
						</div>                
					</div>
					<div class="form-group" id="item-empapp_password">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57552.Şifre'>(<cf_get_lang dictionary_id='52872.key sensitive'>) *</label>
						<div class="col col-8 col-sm-12">
							<cfinput value="" type="password" name="empapp_password" maxlength="16" message="Şifre">
						</div>                
					</div>
					<div class="form-group" id="item-email">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57428.email'></label>
						<div class="col col-8 col-sm-12">
							<cfsavecontent variable="mesaj"><cf_get_lang dictionary_id ='31691.E mail adresini giriniz'></cfsavecontent>
							<cfinput type="text" value="#get_hr.employee_email#" name="email" maxlength="100" validate="email" message="#mesaj#">
						</div>                
					</div>
					<div class="form-group" id="item-hometelcode">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31261.Ev Tel'></label>
						<div class="col col-3 col-sm-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='31673.Ev Telefonu girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="hometelcode" maxlength="3" validate="integer" message="#message#" >
						</div>
						<div class="col col-5 col-sm-12">
							<cfinput type="text" name="hometel" maxlength="7" validate="integer" message="#message#" >
						</div>                
					</div>
					<div class="form-group" id="item-homeaddress">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31263.Ev Adresi'></label>
						<div class="col col-8 col-sm-12">
							<cfsavecontent variable="message2"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
							<textarea name="homeaddress" id="homeaddress" style="width:150px;height:60px;" message="<cfoutput>#message2#</cfoutput>" maxlength="500" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);"><cfoutput>#get_hr_detail.homeaddress#</cfoutput></textarea>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31653.Oturduğunuz Ev'></label>
						<div class="col col-8 col-sm-12">
							<label><input type="radio" name="home_status" id="home_status" value="1" checked>&nbsp;<cf_get_lang dictionary_id='31654.Kendinizin'></label>
							<label><input type="radio" name="home_status" id="home_status" value="2">&nbsp;<cf_get_lang dictionary_id='31655.Ailenizin'></label>
							<label><input type="radio" name="home_status" id="home_status" value="3">&nbsp;<cf_get_lang dictionary_id='31656.Kira'></label>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31495.Fotoğraf'></label>
						<div class="col col-8 col-sm-12">
							<input type="file" name="photo" id="photo">
							<cfif len(get_hr.photo)>
							<input type="hidden" name="ex_photo" id="ex_photo" value="<cfoutput>#get_hr.photo#</cfoutput>">
							</cfif>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58727.Doğum Tarih'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<cfinput type="text" name="birth_date" value="#dateformat(get_emp_identy.birth_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#getLang('','Doğum Tarihi girmelisiniz',31240)#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="birth_date"></span>
							</div>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31226.Uyruğu'></label>
						<div class="col col-8 col-sm-12">
							<select name="nationality" id="nationality">
								<cfoutput query="get_country">
								<option value="#country_id#" <cfif get_country.country_id eq get_emp_identy.nationality>selected</cfif>>#country_name#</option>
								</cfoutput>
							</select>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31658.Kimlik Kartı Tipi'></label>
						<div class="col col-8 col-sm-12">
							<select name="identycard_cat" id="identycard_cat" >
								<cfoutput query="get_id_card_cats">
									<option value="#identycat_id#" <cfif get_hr_detail.identycard_cat eq identycat_id>selected</cfif>>#identycat# 
								</cfoutput>
							</select>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31660.Nüfusa Kayıtlı Olduğu İl'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="CITY" maxlength="100" value="#get_emp_identy.CITY#">
						</div>                
					</div>
				</div>
				<div class="col col-5 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31659.Kimlik Kartı No'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="identycard_no" maxlength="50" value="#get_hr_detail.identycard_no#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58025.TC Kimlik No'></label>
						<div class="col col-8 col-sm-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='31325.TC Kimlik No girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="TC_IDENTY_NO" value="#get_emp_identy.TC_IDENTY_NO#" validate="integer" message="#message#" maxlength="11">
						</div>                
					</div>
					<div class="form-group" id="item-worktelcode">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31648.Direkt Tel'></label>
						<div class="col col-3 col-sm-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='31649.Direkt Telefon girmelisiniz'></cfsavecontent>
							<cfinput type="text" value="#get_hr.direct_telcode#" name="worktelcode" maxlength="3" validate="integer" message="#message#">
						</div>
						<div class="col col-5 col-sm-12">
							<cfinput type="text" value="#get_hr.direct_tel#" name="worktel" maxlength="7" validate="integer" message="#message#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31650.Dahili Tel'></label>
						<div class="col col-8 col-sm-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='31651.Dahili Telefon girmelisiniz'></cfsavecontent>
							<cfinput type="text" value="#get_hr.extension#" name="extension" maxlength="5" validate="integer" message="#message#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58482.Mobil Tel'></label>
						<div class="col col-3 col-sm-12">
							<select name="mobilcode" id="mobilcode">
								<cfoutput query="mobil_cats">
								<option value="#mobilcat#" <cfif get_hr.mobilcode eq mobilcat>selected</cfif>>#mobilcat#
								</cfoutput>
							</select>
						</div>
						<div class="col col-5 col-sm-12">
							<cfinput value="#get_hr.mobiltel#" type="text" name="mobil" maxlength="7" validate="integer" message="#getLang('','Mobil Telefon girmelisiniz',31672)#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58482.Mobil Tel'> 2</label>
						<div class="col col-3 col-sm-12">
							<select name="mobilcode2" id="mobilcode2">
								<cfoutput query="mobil_cats">
									<option value="#mobilcat#">#mobilcat#
								</cfoutput>
							</select>
						</div>
						<div class="col col-5 col-sm-12">
							<cfinput type="text" name="mobil2" maxlength="7" validate="integer" message="#getLang('','Mobil Telefon girmelisiniz',31672)#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="homepostcode" maxlength="10">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<input type="hidden" name="county_id" id="county_id" value="">
								<input type="text" name="homecounty" id="homecounty" value=""> 
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac();"></span>
							</div>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57971.Şehir'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<input type="hidden" name="homecity" id="homecity" value="">
								<input type="text" name="homecity_name" id="homecity_name" value="">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_city();"></span>
							</div>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
						<div class="col col-8 col-sm-12">
							<select name="homecountry" id="homecountry">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_country">
								<option value="#get_country.country_id#" <cfif get_country.is_default eq 1>selected</cfif>>#get_country.country_name#</option>
								</cfoutput>
							</select>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58762.Vergi Dairesi'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="tax_office" maxlength="50" value="#get_emp_identy.tax_office#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57752.Vergi No'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="tax_number" value="#get_emp_identy.tax_number#" maxlength="50">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31657.Doğum Yeri(İlçe / İl)'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="birth_place" maxlength="100" value="#get_emp_identy.birth_place#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57790.Doğum Yeri'><cf_get_lang dictionary_id='58608.İl'></label>
						<div class="col col-8 col-sm-12">
							<select name="birth_city" id="birth_city">
								<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
								<cfoutput query="get_city">
									<option value="#city_id#"<cfif get_hr_detail.birth_city eq city_id>selected</cfif>>#city_name#</option>
								</cfoutput>
							</select>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31229.Instant Mesaj'></label>
						<div class="col col-8 col-sm-12">
							<cf_flat_list>
								<thead>
									<input type="hidden" name="add_im_info" id="add_im_info" value="0">
									<tr>
										<th width="20"><a onClick="add_im_info_();"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
										<th width="120"><cf_get_lang dictionary_id='57630.Tip'></th>
										<th width="120"><cf_get_lang dictionary_id='31109.Mail Adresi'></th>
									</tr>
									<input type="hidden" name="instant_info" id="instant_info" value="">
								</thead>
								<tbody id="im_info"></tbody>
							</cf_flat_list>
						</div>                
					</div>
				</div>
				<div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<cfif len(get_hr.photo)>
						<cf_get_server_file output_file="hr/#get_hr.photo#" output_server="#get_hr.photo_server_id#" output_type="0" image_width="120" image_height="160">
					</cfif>
			</cf_box_elements>

		<cf_seperator id="kisisel_bilgiler_" header="#getLang('','Kişisel Bilgilerinizi Giriniz',31674)#" is_closed="1">
			<cf_box_elements id="kisisel_bilgiler_" style="display:none;">
				<div class="col col-5 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
						<div class="col col-5 col-xs-12">
							<div class="col col-4 col-xs-12"><input type="radio" name="sex" id="sex" value="1"<cfif get_hr_detail.sex eq 1 or not len(get_hr_detail.sex)>checked</cfif>><cf_get_lang dictionary_id='58959.Erkek'></div>
							<div class="col col-4 col-xs-12"><input type="radio" name="sex" id="sex" value="0"<cfif get_hr_detail.sex eq 0>checked</cfif>><cf_get_lang dictionary_id='58958.Kadın'></div>
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31662.Eşinin Ad'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="partner_name" value="" maxlength="150">
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31664.Eşinin Pozisyonu'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="partner_position" maxlength="50">
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31667.Sigara Kullanıyor mu'>?</label>
						<div class="col col-5 col-xs-12">
							<div class="col col-4 col-xs-12"><input type="radio" name="use_cigarette" id="use_cigarette" value="1" <cfif get_hr_detail.use_cigarette eq 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'></div>
							<div class="col col-4 col-xs-12"><input type="radio" name="use_cigarette" id="use_cigarette" value="0"<cfif get_hr_detail.use_cigarette eq 0 or not len(get_hr_detail.use_cigarette)>checked</cfif>><cf_get_lang dictionary_id='57496.Hayır'></div>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31232.Özürlü'></label>
						<div class="col col-5 col-xs-12">
							<div class="col col-4 col-xs-12"><input type="radio" name="defected" id="defected" value="1"  onClick="seviye();" <cfif get_hr_detail.defected eq 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'></div>
							<div class="col col-4 col-xs-12"><input type="radio" name="defected" id="defected" value="0" onClick="seviye1();" <cfif get_hr_detail.defected eq 0 or not get_hr_detail.recordcount>checked</cfif>><cf_get_lang dictionary_id='57496.Hayır'></div>
						</div>                
						<div class="col col-3 col-xs-12">
							<select name="defected_level" id="defected_level" <cfif get_hr_detail.defected eq 0  or not get_hr_detail.recordcount>disabled</cfif>>
								<option value="0" <cfif get_hr_detail.defected_level eq 0>selected</cfif>>%0</option>
								<option value="10" <cfif get_hr_detail.defected_level eq 10>selected</cfif>>%10</option>
								<option value="20" <cfif get_hr_detail.defected_level eq 20>selected</cfif>>%20</option>
								<option value="30" <cfif get_hr_detail.defected_level eq 30>selected</cfif>>%30</option>
								<option value="40" <cfif get_hr_detail.defected_level eq 40>selected</cfif>>%40</option>
								<option value="50" <cfif get_hr_detail.defected_level eq 50>selected</cfif>>%50</option>
								<option value="60" <cfif get_hr_detail.defected_level eq 60>selected</cfif>>%60</option>
								<option value="70" <cfif get_hr_detail.defected_level eq 70>selected</cfif>>%70</option>
								<option value="80" <cfif get_hr_detail.defected_level eq 80>selected</cfif>>%80</option>
								<option value="90" <cfif get_hr_detail.defected_level eq 90>selected</cfif>>%90</option>
								<option value="100" <cfif get_hr_detail.defected_level eq 100>selected</cfif>>%100</option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31670.Hüküm Giydi mi'></label>
						<div class="col col-5 col-xs-12">
							<div class="col col-4 col-xs-12"><input type="radio" name="sentenced" id="sentenced" value="1" <cfif get_hr_detail.sentenced eq 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'></div>
							<div class="col col-4 col-xs-12"><input type="radio" name="sentenced" id="sentenced" value="0" <cfif get_hr_detail.sentenced eq 0 or get_hr_detail.sentenced eq "">checked</cfif>><cf_get_lang dictionary_id='57496.Hayır'></div>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31675.Göçmen'></label>
						<div class="col col-5 col-xs-12">
							<div class="col col-4 col-xs-12"><input type="radio" name="immigrant" id="immigrant" value="1"><cf_get_lang dictionary_id='57495.Evet'></div>
							<div class="col col-4 col-xs-12"><input type="radio" name="immigrant" id="immigrant" value="0" checked><cf_get_lang dictionary_id='57496.Hayır'></div>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31676.Kaç yıldır aktif olarak araba kullanıyorsunuz'> ?</label>
						<div class="col col-8 col-xs-12">
							<cfinput type="Text" name="driver_licence_actived" maxlength="2"  value="" validate="integer" message="#getLang('','Ehliyet Aktiflik Süresine Sayı Giriniz',31690)# !">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31677.Bir suç zannıyla tutuklandınız mı veya mahkumiyetiniz oldu mu'></label>
						<div class="col col-5 col-xs-12">
							<div class="col col-4 col-xs-12"><input type="radio" name="defected_probability" id="defected_probability" value="1" <cfif get_hr_detail.defected_probability eq 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'></div>
							<div class="col col-4 col-xs-12"><input type="radio" name="defected_probability" id="defected_probability" value="0" <cfif get_hr_detail.defected_probability eq 0 or get_hr_detail.defected_probability eq "">checked</cfif>><cf_get_lang dictionary_id='57496.Hayır'></div>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31678.Koğuşturma'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="investigation" value="" maxlength="150">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31679.Devam eden bir hastalık veya bedeni sorununuz var mı'>?</label>
						<div class="col col-5 col-xs-12">
							<div class="col col-4 col-xs-12"><input type="radio" name="illness_probability" id="illness_probability" value="1" <cfif get_hr_detail.illness_probability EQ 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'></div>
							<div class="col col-4 col-xs-12"><input type="radio" name="illness_probability" id="illness_probability" value="0" <cfif get_hr_detail.illness_probability EQ 0 or get_hr_detail.illness_probability eq "">checked</cfif>><cf_get_lang dictionary_id='57496.Hayır'></div>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31371.Varsa nedir?'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="illness_detail" id="illness_detail"><cfoutput>#get_hr_detail.illness_detail#</cfoutput></textarea>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31680.Geçirdiğiniz Ameliyat'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="surgical_operation" id="surgical_operation" message="<cfoutput>#message2#</cfoutput>" maxlength="150" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);"></textarea>
						</div>                
					</div>
				</div>
				<div class="col col-5 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31203.Medeni Durum'></label>
						<div class="col col-5 col-xs-12">
							<div class="col col-5 col-xs-12"><input type="radio" name="married" id="married" value="0" <cfif get_emp_identy.married EQ 0>checked</cfif>><cf_get_lang dictionary_id='31205.Bekar'></div>
							<div class="col col-5 col-xs-12"><input type="radio" name="married" id="married" value="1"<cfif get_emp_identy.married EQ 1>checked</cfif>><cf_get_lang dictionary_id='31204.Evli'></div>
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31663.Eşinin Çlş Şirket'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="partner_company" maxlength="50">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31665.ÇocukSayısı'></label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='31666.Çocuk sayısı girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="child" maxlength="2" validate="integer" message="#message#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31231.Şehit Yakını Misiniz'></label>
						<div class="col col-5 col-xs-12">
							<div class="col col-4 col-xs-12"><input type="radio" name="martyr_relative" id="martyr_relative" value="1" <cfif get_hr_detail.martyr_relative eq 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'></div>
							<div class="col col-4 col-xs-12"><input type="radio" name="martyr_relative" id="martyr_relative" value="0"<cfif get_hr_detail.martyr_relative eq 0 or not len(get_hr_detail.martyr_relative)>checked</cfif>><cf_get_lang dictionary_id='57496.Hayır'></div>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31661.Ehliyet Sınıf / Yıl'></label>
						<div class="col col-3 col-xs-12">
							<cfquery name="GET_DRIVER_LIS" datasource="#DSN#">
								SELECT
									LICENCECAT,LICENCECAT_ID
								FROM
									SETUP_DRIVERLICENCE
								ORDER BY
									LICENCECAT
							</cfquery>
							<select name="driver_licence_type" id="driver_licence_type">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_driver_lis">
								<option value="#licencecat_id#">#licencecat#</option>
								</cfoutput>
							</select>
						</div>
						<div class="col col-5 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="licence_start_date" value="" maxlength="10" validate="#validate_style#" message="#getLang('','Tarih Hatalı',56704)#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="licence_start_date"></span>
							</div>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31228.Ehliyet No'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="Text" name="driver_licence" maxlength="40"  value="">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31209.Askerlik'></label>
						<div class="col col-8 col-xs-12">
							<label><input type="radio" name="military_status" id="military_status" value="0" <cfif get_hr_detail.military_status eq 0>checked</cfif> onClick="tecilli_fonk(this.value)"><cf_get_lang dictionary_id='31210.Yapmadı'></label>
							<label><input type="radio" name="military_status" id="military_status" value="1" <cfif get_hr_detail.military_status eq 1>checked</cfif> onClick="tecilli_fonk(this.value)"><cf_get_lang dictionary_id='31211.Yaptı'></label>
							<label><input type="radio" name="military_status" id="military_status" value="2" <cfif get_hr_detail.military_status eq 2>checked</cfif> onClick="tecilli_fonk(this.value)"><cf_get_lang dictionary_id='31212.Muaf'></label>
							<label><input type="radio" name="military_status" id="military_status" value="3" <cfif get_hr_detail.military_status eq 3>checked</cfif> onClick="tecilli_fonk(this.value)"><cf_get_lang dictionary_id='31213.Yabancı'></label>
							<label><input type="radio" name="military_status" id="military_status" value="4" <cfif get_hr_detail.military_status eq 4>checked</cfif> onClick="tecilli_fonk(this.value)"><cf_get_lang dictionary_id='31214.Tecilli'></label>
						</div>                
					</div>
					<div style="display:none" id="Tecilli">
						<div class="form-group">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31215.Tecil Gerekçesi'></label>
							<div class="col col-8 col-xs-12">
								<cfinput type="text" name="military_delay_reason" value="#get_hr_detail.military_delay_reason#" maxlength="30">
							</div>                
						</div>
						<div class="form-group">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31216.Tecil Süresi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="military_delay_date" value="#dateformat(get_hr_detail.military_delay_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#getLang('','Tecil Süresi girmelisiniz',31218)#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="military_delay_date"></span>
								</div>
							</div>                
						</div>
					</div>
					<div class="form-group" style="display:none" id="Muaf">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31223.Muaf Olma Nedeni'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="military_exempt_detail" id="military_exempt_detail" maxlength="100" value="<cfoutput>#get_hr_detail.military_exempt_detail#</cfoutput>">
						</div>                
					</div>
					<div style="display:none" id="Yapti"> 
						<div class="form-group">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31217.Terhis Tarihi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='31218.Tecil Süresi Girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="military_finishdate" value="#dateformat(get_hr_detail.military_finishdate,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="military_finishdate"></span>
								</div>
							</div>                
						</div>
						<div class="form-group">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31219.Süresi (Ay Olarak Giriniz)'></label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='31220.Askerlik Süresi Girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="military_month" value="#get_hr_detail.military_month#" validate="integer" maxlength="2" message="#message#">
							</div>                
						</div>
						<div class="form-group">
							<label class="col col-4 col-xs-12"></label>
							<div class="col col-8 col-xs-12">
								<input type="radio" name="military_rank" id="military_rank" value="0" <cfif get_hr_detail.military_rank eq 0>checked</cfif>><cf_get_lang dictionary_id='31221.Er'>
							</div>                
						</div>
						<div class="form-group">
							<label class="col col-4 col-xs-12"></label>
							<div class="col col-8 col-xs-12">
								<input type="radio" name="military_rank" id="military_rank" value="1" <cfif get_hr_detail.military_rank eq 1>checked</cfif>><cf_get_lang dictionary_id='31222.Yedek Subay'>
							</div>                
						</div>
					</div>
				</div>
			</cf_box_elements>

		<cf_seperator id="kimlik_bilgiler_" header="#getLang('','Kimlik Detayları',31682)#" is_closed="1">
			<cf_box_elements id="kimlik_bilgiler_" style="display:none;">
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57637.Seri No'></label>
						<div class="col col-3 col-xs-12">
							<cfinput type="text" name="series" maxlength="20" value="#get_emp_identy.series#">
						</div>
						<div class="col col-5 col-xs-12">
							<cfinput type="text" name="number" maxlength="50" value="#get_emp_identy.number#">
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58441.Kan Grubu'></label>
						<div class="col col-8 col-xs-12">
							<select name="BLOOD_TYPE" id="BLOOD_TYPE">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<option value="0"<cfif LEN(get_emp_identy.BLOOD_TYPE) AND (get_emp_identy.BLOOD_TYPE EQ 0)>SELECTED</cfif>>0 Rh+</option>
								<option value="1"<cfif LEN(get_emp_identy.BLOOD_TYPE) AND (get_emp_identy.BLOOD_TYPE EQ 1)>SELECTED</cfif>>0 Rh-</option>
								<option value="2"<cfif LEN(get_emp_identy.BLOOD_TYPE) AND (get_emp_identy.BLOOD_TYPE EQ 2)>SELECTED</cfif>>A Rh+</option>
								<option value="3"<cfif LEN(get_emp_identy.BLOOD_TYPE) AND (get_emp_identy.BLOOD_TYPE EQ 3)>SELECTED</cfif>>A Rh-</option>
								<option value="4"<cfif LEN(get_emp_identy.BLOOD_TYPE) AND (get_emp_identy.BLOOD_TYPE EQ 4)>SELECTED</cfif>>B Rh+</option>
								<option value="5"<cfif LEN(get_emp_identy.BLOOD_TYPE) AND (get_emp_identy.BLOOD_TYPE EQ 5)>SELECTED</cfif>>B Rh-</option>
								<option value="6"<cfif LEN(get_emp_identy.BLOOD_TYPE) AND (get_emp_identy.BLOOD_TYPE EQ 6)>SELECTED</cfif>>AB Rh+</option>
								<option value="7"<cfif LEN(get_emp_identy.BLOOD_TYPE) AND (get_emp_identy.BLOOD_TYPE EQ 7)>SELECTED</cfif>>AB Rh-</option>
							</select>
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58033.Baba Adı'></label>
						<div class="col col-8 col-xs-12">
							<cfinput name="father" value="#get_emp_identy.father#" type="text" maxlength="75">
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58440.Ana Adı'></label>
						<div class="col col-8 col-xs-12">
							<cfinput name="mother" type="text" value="#get_emp_identy.mother#" maxlength="75">
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31683.Baba İş'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="father_job" value="" maxlength="50">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31684.Anne İş'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="mother_job" value="" maxlength="50">
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31244.Önceki Soyadı'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="LAST_SURNAME" maxlength="100" value="#get_emp_identy.LAST_SURNAME#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31241.Dini'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="religion" maxlength="50" value="#get_emp_identy.religion#">
						</div>                
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-process_stage">
						<label class="col col-12 col-xs-12"><b><cf_get_lang dictionary_id='31247.Nüfusa Kayıtlı Olduğu'></b></label>
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="COUNTY" maxlength="100" value="#get_emp_identy.COUNTY#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31249.Cilt No'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="BINDING" maxlength="20" value="#get_emp_identy.BINDING#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58735.Mahalle'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="WARD" maxlength="100" value="#get_emp_identy.WARD#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31251.Aile Sıra No'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="FAMILY" maxlength="20" value="#get_emp_identy.FAMILY#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31254.Köy'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="VILLAGE" maxlength="100" value="#get_emp_identy.VILLAGE#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31253.Sıra No'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="CUE" maxlength="20" value="#get_emp_identy.CUE#">
						</div>                
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-process_stage">
						<label class="col col-12 col-xs-12"><b><cf_get_lang dictionary_id='31255.Cüzdanın'></b></label>
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31256.Verildiği Yer'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="GIVEN_PLACE" maxlength="100" value="#get_emp_identy.GIVEN_PLACE#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31257.Kayıt No'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="RECORD_NUMBER" maxlength="50" value="#get_emp_identy.RECORD_NUMBER#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31258.Veriliş Nedeni'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="GIVEN_REASON" maxlength="300" value="#get_emp_identy.GIVEN_REASON#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31165.Veriliş Tarihi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="GIVEN_DATE" value="#dateformat(get_emp_identy.GIVEN_DATE,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#getLang('','Veriliş Tarihi girmelisiniz',55790)#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="GIVEN_DATE"></span>
							</div>
						</div>                
					</div>
				</div>
			</cf_box_elements>
		
		<cf_seperator id="egitim_deneyim" header="#getLang('','Eğitim ve Deneyim Bilgilerini Giriniz',31685)#" is_closed="1">
			<cfquery name="get_edu_info" datasource="#DSN#">
				SELECT
					EMPLOYEE_ID,
					EDU_TYPE,
					EDU_ID,
					EDU_START,
					EDU_FINISH,
					EDU_RANK,
					EDU_PART_ID,
					IS_EDU_CONTINUE,
					EMPAPP_EDU_ROW_ID,
					EDU_NAME,
					EDU_PART_NAME 
				FROM
					EMPLOYEES_APP_EDU_INFO
				WHERE
					EMPLOYEE_ID = #session.ep.userid#
			</cfquery>
			<div id="egitim_deneyim" style="display:none;">
				<cf_grid_list >
					<cfif get_edu_info.recordcount>
						<input type="hidden" name="row_edu" id="row_edu" value="<cfoutput>#get_edu_info.recordcount#</cfoutput>">
						<thead>
							<tr>
								<th width="20">
									<input name="record_numb_edu" id="record_numb_edu" type="hidden" value="0"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_add_edu_info&ctrl_edu=0');"><i class='fa fa-plus' title="<cf_get_lang dictionary_id ='31555.Eğitim Bilgisi Ekle'>" border="0"></i></a>
								</th>
								<th><cf_get_lang dictionary_id='31551.Okul Türü'></th>
								<th><cf_get_lang dictionary_id='31285.Okul Adı'></th>
								<th><cf_get_lang dictionary_id='31553.Başl Yılı'></th>
								<th><cf_get_lang dictionary_id='31554.Bitiş Yılı'></th>
								<th><cf_get_lang dictionary_id='31482.Not Ort'></th>
								<th><cf_get_lang dictionary_id='57995.Bölüm'></th>
								<th></th>
							</tr>
						</thead>
						<tbody id="table_edu_info">
							<cfoutput query="get_edu_info">
							<tr id="frm_rowt#currentrow#">
								<input type="hidden" class="boxtext" name="empapp_edu_row_id#currentrow#" id="empapp_edu_row_id#currentrow#" value="#empapp_edu_row_id#">
								<td><input  type="hidden" value="1" id="row_kontrol_edu#currentrow#" name="row_kontrol_edu#currentrow#"><a href="javascript://" onClick="sil_edu('#currentrow#');"><i class="fa fa-minus" border="0"></i></a></td>				
								<td><input type="hidden" name="edu_type#currentrow#" id="edu_type#currentrow#" class="boxtext" value="#edu_type#" readonly>
									<cfset edu_type_id_control = "">
									<cfif len(edu_type)>
											<cfquery name="get_education_level_name" datasource="#dsn#">
												SELECT EDU_TYPE,EDU_LEVEL_ID,EDUCATION_NAME FROM SETUP_EDUCATION_LEVEL WHERE EDU_LEVEL_ID =#edu_type#
											</cfquery>
											<cfset edu_type_name=get_education_level_name.education_name>	
											<cfset edu_type_id_control = get_education_level_name.EDU_TYPE>	
									</cfif>		
									<input type="text" name="edu_type_name#currentrow#" id="edu_type_name#currentrow#" class="boxtext" value="#edu_type_name#" readonly>
									</td>
								<td>
								<cfset edu_name_degisken = "">
								<cfif len(edu_id) and edu_id neq -1>
									<!---<cfif listfind('4,5,6',edu_type)>--->
										<cfquery name="get_unv_name" datasource="#dsn#">
											SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_ID = #edu_id#
										</cfquery>
										<cfset edu_name_degisken = get_unv_name.SCHOOL_NAME>
									<!---</cfif>--->
								<cfelse>
									<cfset edu_name_degisken = edu_name>
								</cfif>
									<input type="hidden" name="edu_id#currentrow#" id="edu_id#currentrow#" class="boxtext" value="<cfif len(edu_id)>#edu_id#</cfif>" readonly>
									<input type="text" name="edu_name#currentrow#" id="edu_name#currentrow#" class="boxtext" value="#edu_name_degisken#" readonly>
								</td>
								<td>
									<input type="text" name="edu_start#currentrow#" id="edu_start#currentrow#" class="boxtext" value="#Dateformat(edu_start,dateformat_style)#" readonly>
								</td>
								<td>
									<input type="text" name="edu_finish#currentrow#" id="edu_finish#currentrow#" class="boxtext" value="#DateFormat(edu_finish,dateformat_style)#" readonly>
								</td>
								<td>
									<input type="text" name="edu_rank#currentrow#" id="edu_rank#currentrow#" class="boxtext" value="#edu_rank#" readonly>
								</td>
								<td><cfset edu_part_name_degisken = "">
									<cfif (len(edu_part_id) and edu_part_id neq -1)>
										<cfif edu_type_id_control eq 1><!--- edu_type lise ise--->
												<cfquery name="get_high_school_part_name" datasource="#dsn#">
													SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART WHERE HIGH_PART_ID = #edu_part_id#
												</cfquery>
												<cfset edu_part_name_degisken = get_high_school_part_name.HIGH_PART_NAME>
										<!---<cfelseif listfind('3',edu_type)>--->
										<cfelseif listfind('2',edu_type_id_control)> <!--- üniversite ise--->
												<cfquery name="get_school_part_name" datasource="#dsn#">
													SELECT PART_ID, PART_NAME FROM SETUP_SCHOOL_PART WHERE PART_ID = #edu_part_id#
												</cfquery>
												<cfset edu_part_name_degisken = get_school_part_name.PART_NAME>
										</cfif>
									<cfelseif len(edu_part_name)>
											<cfset edu_part_name_degisken = edu_part_name>
									<cfelse>
											<cfset edu_part_name_degisken = "">
									</cfif>
									<input type="text" name="edu_part_name#currentrow#" id="edu_part_name#currentrow#" class="boxtext" value="#edu_part_name_degisken#" readonly>
									<input type="hidden" name="edu_high_part_id#currentrow#" id="edu_high_part_id#currentrow#" class="boxtext" value="<cfif isdefined("edu_part_id") and len(edu_part_id) and edu_type eq 3>#edu_part_id#</cfif>">
									<input type="hidden" name="edu_part_id#currentrow#" id="edu_part_id#currentrow#" class="boxtext" value="<cfif listfind('4,5',edu_type) and isdefined("edu_part_id") and len(edu_part_id)>#edu_part_id#</cfif>">
									<input type="hidden" name="is_edu_continue#currentrow#" id="is_edu_continue#currentrow#" class="boxtext" value="#is_edu_continue#">
								</td>
								<td><a href="javascript://" onClick="gonder_upd_edu('#currentrow#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='31721.Eğitim Bilgisi Güncelle'>" border="0"></i></a></td>
							</tr>
							</cfoutput>
						</tbody>
					<cfelse>
						<thead>
							<input type="hidden" name="row_edu" id="row_edu" value="0">
							<tr>
								<th colspan="2" width="20" class="text-center"><input name="record_numb_edu" id="record_numb_edu" type="hidden" value="0"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_add_edu_info&ctrl_edu=0');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='31555.Eğitim Bilgisi Ekle'>" border="0"></i></a></th>
								<th><cf_get_lang dictionary_id='31551.Okul Türü'></th>
								<th><cf_get_lang dictionary_id='31285.Okul Adı'></th>
								<th><cf_get_lang dictionary_id='31553.Başl Yılı'></th>
								<th><cf_get_lang dictionary_id='31554.Bitiş Yılı'></th>
								<th><cf_get_lang dictionary_id='31482.Not Ort'></th>
								<th><cf_get_lang dictionary_id='57995.Bölüm'></th>
							</tr>
						</thead>
						<tbody id="table_edu_info">
							<input type="hidden" name="edu_type" id="edu_type" value="">
							<input type="hidden" name="edu_id" id="edu_id" value="">
							<input type="hidden" name="edu_name" id="edu_name" value="">
							<input type="hidden" name="edu_start" id="edu_start" value="">
							<input type="hidden" name="edu_finish" id="edu_finish" value="">
							<input type="hidden" name="edu_rank" id="edu_rank" value="">
							<input type="hidden" name="edu_high_part_id" id="edu_high_part_id" value="">
							<input type="hidden" name="edu_part_id" id="edu_part_id" value="">
							<input type="hidden" name="edu_part_name" id="edu_part_name" value="">
							<input type="hidden" name="is_edu_continue" id="is_edu_continue" value="">
						</tbody>
					</cfif>	
				</cf_grid_list>
				<div class="form-group" id="item-name">
					<label class="col col-2 col-sm-12"><cf_get_lang dictionary_id='31686.Egitim Seviyesi'></label>
					<div class="col col-8 col-sm-12">
						<div class="input-group">
							<select name="training_level" id="training_level">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfloop query="get_edu_level">
									<option value="<cfoutput>#get_edu_level.edu_level_id#</cfoutput>"  <cfif GET_EDU_LEVEL.edu_level_id eq get_hr_detail.last_school>SELECTED</cfif>><cfoutput>#get_edu_level.education_name#</cfoutput></option>
								</cfloop>
							</select>
						</div> 
					</div>               
				</div>
				<cf_grid_list>
					<thead>
						<tr>
							<th colspan="5"><cf_get_lang dictionary_id='31692.Kurs - Seminer ve Akademik Olmayan Programlar'></th>
						</tr>
						<tr>
							<th>&nbsp;</th>
							<th><cf_get_lang dictionary_id='57480.Konu'></th>
							<th ><cf_get_lang dictionary_id='58455.Yıl'></th>
							<th><cf_get_lang dictionary_id='31296.Yer'></th>
							<th><cf_get_lang dictionary_id='57490.Gün'></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td height="26"><cf_get_lang dictionary_id='31294.Kurs'></td>
							<td><cfinput type="text" name="kurs1" value="#get_hr_detail.kurs1#"></td>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31861.Kurs 1 İçin Yılı Girin'></cfsavecontent>
							<td><cfinput type="text" name="kurs1_yil" value="#dateformat(get_hr_detail.kurs1_yil,'yyyy')#"  validate="integer" maxlength="4" range="1900," message="#message#"></td>
							<td><cfinput type="text" name="kurs1_yer" value="#get_hr_detail.kurs1_yer#" maxlength="150"></td>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31862.Kurs 1 Gün Sayısını Girin'></cfsavecontent>
							<td><cfinput type="text" name="kurs1_gun" value="#get_hr_detail.kurs1_gun#" validate="integer" message="#message#"></td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='31294.Kurs'></td>  
							<td><cfinput type="text" name="kurs2" value="#get_hr_detail.kurs2#"></td>
							<cfsavecontent variable="message2"><cf_get_lang dictionary_id='31864.Kurs2 İçin Yılı Girin'></cfsavecontent>
							<td><cfinput type="text" name="kurs2_yil" value="#dateformat(get_hr_detail.kurs2_yil,'yyyy')#" validate="integer" maxlength="4" range="1900," message="#message2#"></td>
							<td><cfinput type="text" name="kurs2_yer" value="#get_hr_detail.kurs2_YER#" maxlength="150"></td>
							<cfsavecontent variable="message2"><cf_get_lang dictionary_id='31865.Kurs 2 Gün Sayısını Girin'></cfsavecontent>
							<td><cfinput type="text" name="kurs2_gun" value="#get_hr_detail.kurs2_GUN#" validate="integer" message="#message2#"></td>
						</tr>  
						<tr>
							<td><cf_get_lang dictionary_id='31294.Kurs'></td>  
							<td><cfinput type="text" name="kurs3" value="#get_hr_detail.kurs3#"></td>
							<cfsavecontent variable="message3"><cf_get_lang dictionary_id ='31866.Kurs3 İçin Yılı Girin'></cfsavecontent>
							<td><cfinput type="text" name="kurs3_yil" value="#dateformat(get_hr_detail.kurs3_yil,'yyyy')#"  validate="integer" maxlength="4" range="1900," message="#message3#"></td>
							<td><cfinput type="text" name="kurs3_yer" value="#get_hr_detail.kurs3_yer#" maxlength="150"></td>
							<cfsavecontent variable="message3"><cf_get_lang dictionary_id ='31867.Kurs 3 Gün Sayısını Girin'></cfsavecontent>
							<td><cfinput type="text" name="kurs3_gun" value="#get_hr_detail.kurs3_gun#" validate="integer" message="#message3#"></td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='31301.Bilgisayar Bilgisi'></td>
							<td colspan="4">
								<cfsavecontent variable="message2"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
								<textarea name="comp_exp" id="comp_exp" style="width:250px;height:60px;"><cfoutput>#get_hr_detail.comp_exp#</cfoutput></textarea>
							</td>
						</tr>
					</tbody>
				</cf_grid_list>
			</div>

		<cf_seperator id="dil_bilgileri" header="#getLang('','Diller',31303)#" is_closed="1">
			<cf_grid_list id="dil_bilgileri" style="display:none;">
				<input type="hidden" name="add_lang_info" id="add_lang_info" value="">
				<thead>
					<tr>
						<th width="20"><a href="javascript://" onClick="add_lang_info_();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
						<th><cf_get_lang dictionary_id='58996.Dil'></th>
						<th><cf_get_lang dictionary_id='31304.Konuşma'></th>
						<th><cf_get_lang dictionary_id='31305.Anlama'></th>
						<th><cf_get_lang dictionary_id='31306.Yazma'></th>
						<th><cf_get_lang dictionary_id='31307.Öğrenildiği Yer'></th>
					</tr>
				</thead>
				<input type="hidden" name="language_info" id="language_info" value="">
				<tbody id="lang_info">
				</tbody>
			</cf_grid_list>

		<cf_seperator id="deneyim_bilgileri" header="#getLang('','Deneyim Bilgileri',31527)#" is_closed="1">
			<cfquery name="get_work_info" datasource="#DSN#">
				SELECT
					*
				FROM
					EMPLOYEES_APP_WORK_INFO
				WHERE
					EMPLOYEE_ID = #session.ep.userid#
			</cfquery>
			<cf_grid_list id="deneyim_bilgileri" style="display:none;">
				<cfif get_work_info.recordcount>
					<thead>
						<input type="hidden" name="row_count" id="row_count" value="<cfoutput>#get_work_info.recordcount#</cfoutput>">
						<tr>
							<th width="20" class="text-center"><input name="record_num" id="record_num" type="hidden" value="0"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=myhome.popup_upd_work_info&control=0</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='31526.İş Tecrübesi Ekle'>"></i></a></th>
							<th><cf_get_lang dictionary_id='31549.Çalışılan Yer'></th>
							<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
							<th><cf_get_lang dictionary_id='57579.Sektör'></th>
							<th><cf_get_lang dictionary_id='57571.Ünvan'></th>
							<th><cf_get_lang dictionary_id='57655.Başlama Tarihi'></th>
							<th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
							<th width="20"></th>
						</tr>
					</thead>
					<tbody id="table_work_info">
						<cfoutput query="get_work_info">
						<tr id="frm_row#currentrow#">
							<td><input  type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#"><a href="javascript://" onClick="sil_exp('#currentrow#');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id ='57463.sil'>" title="<cf_get_lang dictionary_id ='57463.sil'>"></i></a></td>
							<input type="hidden" name="exp_telcode#currentrow#" id="exp_telcode#currentrow#" class="boxtext" value="#exp_telcode#">
							<input type="hidden" name="exp_tel#currentrow#" id="exp_tel#currentrow#" class="boxtext" value="#exp_tel#">
							<input type="hidden" name="exp_salary#currentrow#" id="exp_salary#currentrow#" class="boxtext" value="#exp_salary#">
							<input type="hidden" name="exp_extra_salary#currentrow#" id="exp_extra_salary#currentrow#" class="boxtext" value="#exp_extra_salary#">
							<input type="hidden" name="exp_extra#currentrow#" id="exp_extra#currentrow#" class="boxtext" value="#exp_extra#">
							<input type="hidden" name="exp_reason#currentrow#" id="exp_reason#currentrow#" class="boxtext" value="#exp_reason#">
							<input type="hidden" name="is_cont_work#currentrow#" id="is_cont_work#currentrow#" class="boxtext" value="#is_cont_work#">
							<input type="hidden" class="boxtext" name="empapp_row_id#currentrow#" id="empapp_row_id#currentrow#" value="#empapp_row_id#">
							<td><input type="text" name="exp_name#currentrow#" id="exp_name#currentrow#" class="boxtext" value="#exp#" readonly></td>
							<td><input type="text" name="exp_position#currentrow#" id="exp_position#currentrow#" class="boxtext" value="#exp_position#" readonly></td>
							<td>
								<input type="hidden" name="exp_sector_cat#currentrow#" id="exp_sector_cat#currentrow#" class="boxtext" value="#exp_sector_cat#">
								<cfif isdefined("exp_sector_cat") and len(exp_sector_cat)>
									<cfquery name="get_sector_cat" datasource="#dsn#">
										SELECT SECTOR_CAT_ID,SECTOR_CAT FROM SETUP_SECTOR_CATS WHERE SECTOR_CAT_ID = #exp_sector_cat#
									</cfquery>
								</cfif>
								<input type="text" name="exp_sector_cat_name#currentrow#" id="exp_sector_cat_name#currentrow#" class="boxtext" value="<cfif isdefined("exp_sector_cat") and len(exp_sector_cat) and get_sector_cat.recordcount>#get_sector_cat.sector_cat#</cfif>" readonly>
							</td>
							<td>
								<input type="hidden" name="exp_task_id#currentrow#" id="exp_task_id#currentrow#" class="boxtext" value="#exp_task_id#">
								<cfif isdefined("exp_task_id") and len(exp_task_id)>
									<cfquery name="get_exp_task_name" datasource="#dsn#">
										SELECT PARTNER_POSITION_ID,PARTNER_POSITION FROM SETUP_PARTNER_POSITION WHERE PARTNER_POSITION_ID = #exp_task_id#
									</cfquery>
								</cfif>
								<input type="text" name="exp_task_name#currentrow#" id="exp_task_name#currentrow#" class="boxtext" value="<cfif isdefined("exp_task_id") and len(exp_task_id) and get_exp_task_name.recordcount>#get_exp_task_name.partner_position#</cfif>" readonly>
							</td>
							<td>
								<input type="text" name="exp_start#currentrow#" id="exp_start#currentrow#" class="boxtext" value="#dateformat(exp_start,dateformat_style)#" readonly>
							</td>
							<td>
								<input type="text" name="exp_finish#currentrow#" id="exp_finish#currentrow#" class="boxtext" value="#dateformat(exp_finish,dateformat_style)#" readonly>
							</td>
							<td><a href="javascript://" onClick="gonder_upd('#currentrow#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='31694.İş Tecrübesi Güncelle'>"></i></a></td>
						</tr>
					</cfoutput>
					</tbody>
				<cfelse>
					<input type="hidden" name="row_count" id="row_count" value="0">
					<thead>
						<tr>
							<th width="20" class="text-center"><input name="record_numb" id="record_numb" type="hidden" value="0"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=myhome.popup_upd_work_info&control=0</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='31526.İş Tecrübesi Ekle'>" alt="<cf_get_lang dictionary_id='31526.İş Tecrübesi Ekle'>"></i></a></th>
							<th><cf_get_lang dictionary_id='31549.Çalışılan Yer'></th>
							<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
							<th><cf_get_lang dictionary_id='57579.Sektör'></th>
							<th><cf_get_lang dictionary_id='57571.Ünvan'></th>
							<th><cf_get_lang dictionary_id='57655.Başlama Tarihi'></th>
							<th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
							<th></th>
						</tr>
					</thead>
					<tbody id="table_work_info">
						<input type="hidden" name="exp_name" id="exp_name" value="">
						<input type="hidden" name="exp_position" id="exp_position" value="">
						<input type="hidden" name="exp_sector_cat" id="exp_sector_cat" value="">
						<input type="hidden" name="exp_task_id" id="exp_task_id" value="">
						<input type="hidden" name="exp_start" id="exp_start" value="">
						<input type="hidden" name="exp_finish" id="exp_finish" value="">
						<input type="hidden" name="exp_telcode" id="exp_telcode" value="">
						<input type="hidden" name="exp_tel" id="exp_tel" value="">
						<input type="hidden" name="exp_salary" id="exp_salary" value="">
						<input type="hidden" name="exp_extra_salary" id="exp_extra_salary" value="">
						<input type="hidden" name="exp_extra" id="exp_extra" value="">
						<input type="hidden" name="exp_reason" id="exp_reason" value="">
						<input type="hidden" name="is_cont_work" id="is_cont_work" value="">
					</tbody>
				</cfif>
			</cf_grid_list>

		<cf_seperator id="referans" header="#getLang('','Referans Bilgileri',31695)#" is_closed="1">
			<cf_grid_list id="referans" style="display:none;">
				<thead>
					<input type="hidden" name="add_ref_info" id="add_ref_info" value="0">
					<tr>
						<th width="20"><a onClick="add_ref_info_();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
						<th width="90"><cf_get_lang dictionary_id='31063.Referans Tipi'></th>
						<th width="100"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
						<th width="100"><cf_get_lang dictionary_id='57574.Sirket'></th>
						<th width="100"><cf_get_lang dictionary_id='29429.Tel Kod'></th>
						<th width="100"><cf_get_lang dictionary_id='57499.Telefon'></th>
						<th width="100"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
						<th width="100"><cf_get_lang dictionary_id='32508.E-mail'></th>
					</tr>
					<input type="hidden" name="referance_info" id="referance_info" value="">
				</thead>
				<tbody id="ref_info">
				</tbody>
			</cf_grid_list>

		<cf_seperator id="hobiler" header="#getLang('','Özel İlgi Alanları - Üye Olunan Klüp Ve Dernekler',31696)#" is_closed="1">
			<cf_box_elements id="hobiler" style="display:none;">	
				<cfquery name="get_emp_hobbies" datasource="#dsn#"> 
					SELECT 
						EMPLOYEES_HOBBY.HOBBY_ID,
						SETUP_HOBBY.HOBBY_NAME
					FROM 
						EMPLOYEES_HOBBY,
						SETUP_HOBBY
					WHERE
						SETUP_HOBBY.HOBBY_ID=EMPLOYEES_HOBBY.HOBBY_ID AND 
						EMPLOYEE_ID = #session.ep.userid#
				</cfquery>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31697.Özel İlgi Alanları'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="hobby" id="hobby" style="width:250px;" message="<cfoutput>#message2#</cfoutput>" maxlength="150" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);"><cfoutput query="get_emp_hobbies">#get_emp_hobbies.hobby_name#,</cfoutput></textarea>
						</div>
					</div> 	
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31300.Üye Olunan Klüp Ve Dernekler'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="club" id="club" style="width:250px;" message="<cfoutput>#message2#</cfoutput>" maxlength="250" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);"><cfoutput>#get_hr_detail.club#</cfoutput></textarea>
						</div>
					</div> 		
				</div>
			</cf_box_elements>

		<cf_seperator id="aile_bilgileri" header="#getLang('','Aile Bilgileri',31698)#" is_closed="1">
			<cf_grid_list id="aile_bilgileri" style="display:none;">
				<thead>
					<tr>
						<input type="hidden" name="rowCount" id="rowCount" value="0">
						<th width="20"><a onClick="addRow_();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>" alt="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a></th>
						<th><cf_get_lang dictionary_id='57631.Ad'></th>
						<th><cf_get_lang dictionary_id='58726.Soyad'></th>
						<th><cf_get_lang dictionary_id='31277.Yakınlık Derecesi'></th>
						<th><cf_get_lang dictionary_id='58727.Doğum Tarihi'></th>
						<th><cf_get_lang dictionary_id='57790.Doğum Yeri'></th>
						<th><cf_get_lang dictionary_id='57419.Eğitim'></th>
						<th><cf_get_lang dictionary_id='31278.Meslek'></th>
						<th><cf_get_lang dictionary_id='57574.Şirket'></th>
						<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
					</tr>
				</thead>
				<tbody id="table_list"></tbody>
			</cf_grid_list>

		<cf_seperator id="calismak_istenilen_birimler" header="#getLang('','Çalışmak İstediğiniz Birimler',31699)#" is_closed="1">
			<cf_box_elements id="calismak_istenilen_birimler" style="display:none;">
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
					<label class="text-bold"><cf_get_lang dictionary_id='31700.Öncelik sıralarını yandaki kutulara yazınız'></label>
				</div>
				<cfquery name="get_cv_unit" datasource="#DSN#">
					SELECT 
						* 
					FROM 
						SETUP_CV_UNIT
				</cfquery>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<cfif get_cv_unit.recordcount>
						<cfoutput query="get_cv_unit">
							<div class="form-group">
								<label class="col col-4 col-xs-12">#get_cv_unit.unit_name#</label>
								<div class="col col-8 col-xs-12">
									<cfsavecontent variable="messages"><cf_get_lang dictionary_id ='31701.Sayı Giriniz'></cfsavecontent>
									<cfinput type="text" name="unit#get_cv_unit.unit_id#" value="" validate="integer" message="#messages#" maxlength="1" onchange="seviye_kontrol(this)">
								</div>
							</div>
						</cfoutput>
					<cfelse>
						<div class="form-group"><cf_get_lang dictionary_id='31702.Sisteme kayıtlı birim yok'></div>
					</cfif>
				</div>
			</cf_box_elements>

		<cf_seperator id="calismak_istenilen_sehir" header="#getLang('','Çalışmak İstediğiniz Şehir',31703)#" is_closed="1">
			<cf_box_elements id="calismak_istenilen_sehir" style="display:none;">
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-select">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31703.Çalışmak İstediğiniz Şehir'></label>
						<div class="col col-8 col-xs-12">
							<cf_wrk_MultiSelect
								name="prefered_city"
								option_name="CITY_NAME"
								option_value="CITY_ID"
								table_name="SETUP_CITY"
								is_option_text="1"
								option_text="#getLang('','TÜM TÜRKİYE',31704)#">
						</div>
					</div>
					<div class="form-group" id="item-IS_TRIP">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31705.Seyahat Edebilir misiniz'>?</label>
						<div class="col col-8 col-xs-12">
							<div class="col col-6 col-xs-12"><input type="radio" name="IS_TRIP" id="IS_TRIP" value="1"><cf_get_lang dictionary_id='57495.Evet'></div>
							<div class="col col-6 col-xs-12"><input type="radio" name="IS_TRIP" id="IS_TRIP" value="0" checked><cf_get_lang dictionary_id='57496.Hayır'></div>
						</div>
					</div>
					<div class="form-group" id="item-expected_price">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31706.İstenilen Ücret (Net)'></label>
						<div class="col col-6 col-xs-12">
							<cfinput type="Text" validate="float" name="expected_price"  value="" onkeyup="return(FormatCurrency(this,event));">
						</div>
						<div class="col col-2 col-xs-12">
							<select name="expected_money_type" id="expected_money_type" class="formselect">
								<cfquery name="GET_MONEY" datasource="#dsn#">
									SELECT
										*
									FROM
										SETUP_MONEY
									WHERE
										PERIOD_ID = #SESSION.EP.PERIOD_ID#
								</cfquery>
								<cfoutput query="get_money">
								<option value="#MONEY#">#MONEY#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-applicant_notes">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31707.Eklemek İstedikleriniz'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="applicant_notes" id="applicant_notes" style="width:600px;" id="applicant_notes" message="<cfoutput>#message2#</cfoutput>" maxlength="300" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);" cols="45" rows="5"></textarea>
						</div>
					</div>
				</div>
			</cf_box_elements>

		<cf_seperator id="ozgecmis_metni" header="#getLang('','Özgeçmiş Metni',63037)#" is_closed="1">
			<div id="ozgecmis_metni" style="display:none;">
				<cfmodule
					template="/fckeditor/fckeditor.cfm"
					toolbarSet="WRKContent"
					basePath="/fckeditor/"
					instanceName="resume_text"
					valign="top"
					value=""
					width="100%"
					height="100">
			</div>
		<cf_box_footer>
				<cf_workcube_buttons is_upd='0' add_function='control_last()'>
		</cf_box_footer>	
	</cfform>
</cf_box>
<form name="form_work_info" method="post" action="">
	<input type="hidden" name="exp_name_new" id="exp_name_new" value="">
	<input type="hidden" name="exp_position_new" id="exp_position_new" value="">
	<input type="hidden" name="exp_sector_cat_new" id="exp_sector_cat_new" value="">
	<input type="hidden" name="exp_task_id_new" id="exp_task_id_new" value="">
	<input type="hidden" name="exp_start_new" id="exp_start_new" value="">
	<input type="hidden" name="exp_finish_new" id="exp_finish_new" value="">
	<input type="hidden" name="exp_telcode_new" id="exp_telcode_new" value="">
	<input type="hidden" name="exp_tel_new" id="exp_tel_new" value="">
	<input type="hidden" name="exp_salary_new" id="exp_salary_new" value="">
	<input type="hidden" name="exp_extra_salary_new" id="exp_extra_salary_new" value="">
	<input type="hidden" name="exp_extra_new" id="exp_extra_new" value="">
	<input type="hidden" name="exp_reason_new" id="exp_reason_new" value="">
	<input type="hidden" name="is_cont_work_new" id="is_cont_work_new" value="">
</form>
<form name="form_edu_info" id="form_edu_info" method="post" action="">
	<input type="hidden" name="edu_type_new" id="edu_type_new" value="">
	<input type="hidden" name="edu_id_new" id="edu_id_new" value="">
	<input type="hidden" name="edu_name_new" id="edu_name_new" value="">
	<input type="hidden" name="edu_start_new" id="edu_start_new" value="">
	<input type="hidden" name="edu_finish_new" id="edu_finish_new" value="">
	<input type="hidden" name="edu_rank_new" id="edu_rank_new" value="">
	<input type="hidden" name="edu_high_part_id_new" id="edu_high_part_id_new" value="">
	<input type="hidden" name="edu_part_id_new" id="edu_part_id_new" value="">
	<input type="hidden" name="edu_part_name_new" id="edu_part_name_new" value="">
	<input type="hidden" name="is_edu_continue_new" id="is_edu_continue_new" value="">
	<input type="hidden" name="education_time_new" id="education_time_new" value="">
	<input type="hidden" name="edu_lang_new" id="edu_lang_new" value="">
	<input type="hidden" name="edu_lang_rate_new" id="edu_lang_rate_new" value="">
</form>
<script type="text/javascript">
function seviye()
{
	if(document.employe_detail.defected_level.disabled==true)
	{document.employe_detail.defected_level.disabled=false;}
}

function seviye1()
{
	if(document.employe_detail.defected_level.disabled==false)
	{document.employe_detail.defected_level.disabled=true;}
}

<cfif isdefined('get_work_info') and (get_work_info.recordcount)>
	row_count=<cfoutput>#get_work_info.recordcount#</cfoutput>;
	satir_say=0;
<cfelse>
	row_count=0;
	satir_say=0;
</cfif>

var add_im_info=0;
function del_im(dell){
		var my_emement1=eval("employe_detail.del_im_info"+dell);
		my_emement1.value=0;
		var my_element1=eval("im_info_"+dell);
		my_element1.style.display="none";
}
function add_im_info_(){
	add_im_info++;
	document.getElementById('add_im_info').value=add_im_info;
	var newRow;
	var newCell;
	newRow = document.getElementById("im_info").insertRow(document.getElementById("im_info").rows.length);
	newRow.setAttribute("name","im_info_" + add_im_info);
	newRow.setAttribute("id","im_info_" + add_im_info);
	document.getElementById('instant_info').value=add_im_info;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML ='<input type="hidden" value="1" name="del_im_info'+ add_im_info +'"><a onclick="del_im(' + add_im_info + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id ='57463.sil'>" title="<cf_get_lang dictionary_id ='57463.sil'>"></i></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<select name="imcat_id' + add_im_info +'"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option><cfoutput query="im_cats"><option value="#imcat_id#">#imcat#</option></cfoutput>/select>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML ='<input type="text" name="im' + add_im_info +'">';
}
function sil(sy)
{
	var my_element=eval("employe_detail.row_kontrol"+sy);
	my_element.value=0;
	var my_element=eval("frm_row"+sy);
	my_element.style.display="none";
	satir_say--;
}

function gonder_upd(count)
{
	form_work_info.exp_name_new.value = eval("employe_detail.exp_name"+count).value;
	form_work_info.exp_position_new.value = eval("employe_detail.exp_position"+count).value;
	form_work_info.exp_sector_cat_new.value = eval("employe_detail.exp_sector_cat"+count).value;
	form_work_info.exp_task_id_new.value = eval("employe_detail.exp_task_id"+count).value;
	form_work_info.exp_start_new.value = eval("employe_detail.exp_start"+count).value;
	form_work_info.exp_finish_new.value = eval("employe_detail.exp_finish"+count).value;
	form_work_info.exp_telcode_new.value = eval("employe_detail.exp_telcode"+count).value;
	form_work_info.exp_tel_new.value = eval("employe_detail.exp_tel"+count).value;
	form_work_info.exp_salary_new.value = eval("employe_detail.exp_salary"+count).value;
	form_work_info.exp_extra_salary_new.value = eval("employe_detail.exp_extra_salary"+count).value;
	form_work_info.exp_extra_new.value = eval("employe_detail.exp_extra"+count).value;
	form_work_info.exp_reason_new.value = eval("employe_detail.exp_reason"+count).value;
	form_work_info.is_cont_work_new.value = eval("employe_detail.is_cont_work"+count).value;
	windowopen('','medium','kariyer_pop');
	form_work_info.target='kariyer_pop';
	form_work_info.action = '<cfoutput>#request.self#?fuseaction=myhome.popup_upd_work_info&my_count='+count+'&control=1</cfoutput>';
	form_work_info.submit();	
}

function gonder_add(count)
{
	form_work_info.exp_name_new.value = eval("employe_detail.exp_name"+count).value;
	form_work_info.exp_position_new.value = eval("employe_detail.exp_position"+count).value;
	form_work_info.exp_sector_cat_new.value = eval("employe_detail.exp_sector_cat"+count).value;
	form_work_info.exp_task_id_new.value = eval("employe_detail.exp_task_id"+count).value;
	form_work_info.exp_start_new.value = eval("employe_detail.exp_start"+count).value;
	form_work_info.exp_finish_new.value = eval("employe_detail.exp_finish"+count).value;
	form_work_info.exp_telcode_new.value = eval("employe_detail.exp_telcode"+count).value;
	form_work_info.exp_tel_new.value = eval("employe_detail.exp_tel"+count).value;
	form_work_info.exp_salary_new.value = eval("employe_detail.exp_salary"+count).value;
	form_work_info.exp_extra_salary_new.value = eval("employe_detail.exp_extra_salary"+count).value;
	form_work_info.exp_extra_new.value = eval("employe_detail.exp_extra"+count).value;
	form_work_info.exp_reason_new.value = eval("employe_detail.exp_reason"+count).value;
	form_work_info.is_cont_work_new.value = eval("employe_detail.is_cont_work"+count).value;
	windowopen('','large','kariyer_pop');
	form_work_info.target='kariyer_pop';
	form_work_info.action = '<cfoutput>#request.self#?fuseaction=myhome.popup_upd_work_info&my_count='+count+'&control=1</cfoutput>';
	form_work_info.submit();	
}

function gonder(exp_name,exp_position,exp_start,exp_finish,exp_sector_cat,exp_task_id,exp_telcode,exp_tel,exp_salary,exp_extra_salary,exp_extra,exp_reason,control,my_count,is_cont_work)
{
	if(control == 1)
	{
		eval("employe_detail.exp_name"+my_count).value=exp_name;
		eval("employe_detail.exp_position"+my_count).value=exp_position;
		eval("employe_detail.exp_start"+my_count).value=exp_start;
		eval("employe_detail.exp_finish"+my_count).value=exp_finish;
		eval("employe_detail.exp_sector_cat"+my_count).value=exp_sector_cat;
		if(exp_sector_cat != '')
		{
			var get_emp_cv_new = wrk_safe_query('hr_get_emp_cv_new','dsn',0,exp_sector_cat);
			var exp_sector_cat_name = get_emp_cv_new.SECTOR_CAT;
		}
		else
			var exp_sector_cat_name = '';
		eval("employe_detail.exp_sector_cat_name"+my_count).value=exp_sector_cat_name;
		eval("employe_detail.exp_task_id"+my_count).value=exp_task_id;
		if(exp_task_id != '')
		{
			var get_emp_task_cv_new = wrk_safe_query('hr_get_emp_task_cv_new','dsn',0,exp_task_id);
			/*if(get_emp_task_cv_new.recordcount)*/
				var exp_task_name = get_emp_task_cv_new.PARTNER_POSITION;
		}
		else
			var exp_task_name = '';
		eval("employe_detail.exp_task_name"+my_count).value=exp_task_name;
		eval("employe_detail.exp_telcode"+my_count).value=exp_telcode;
		eval("employe_detail.exp_tel"+my_count).value=exp_tel;
		eval("employe_detail.exp_salary"+my_count).value=exp_salary;
		eval("employe_detail.exp_extra_salary"+my_count).value=exp_extra_salary;
		eval("employe_detail.exp_extra"+my_count).value=exp_extra;
		eval("employe_detail.exp_reason"+my_count).value=exp_reason;
		eval("employe_detail.is_cont_work"+my_count).value=is_cont_work;
	}
	else
	{
		row_count++;
		employe_detail.row_count.value = row_count;
		satir_say++;
		var new_Row;
		var new_Cell;
		get_emp_cv='';
		new_Row = document.getElementById("table_work_info").insertRow(document.getElementById("table_work_info").rows.length);
		new_Row.setAttribute("name","frm_row" + row_count);
		new_Row.setAttribute("id","frm_row" + row_count);
			
		
		new_Cell = new_Row.insertCell(new_Row.cells.length);
		new_Cell.innerHTML = '<input  type="hidden" value="1" id="row_kontrol' + row_count +'" name="row_kontrol' + row_count +'" ><a href="javascript://" onclick="sil_exp(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
		new_Cell.innerHTML += '<input type="hidden" name="exp_sector_cat' + row_count + '" value="'+ exp_sector_cat +'">';
		new_Cell.innerHTML += '<input type="hidden" name="exp_task_id' + row_count + '" value="'+ exp_task_id +'">';
		new_Cell.innerHTML += '<input type="hidden" name="exp_telcode' + row_count + '" value="'+ exp_telcode +'">';
		new_Cell.innerHTML += '<input type="hidden" name="exp_tel' + row_count + '" value="'+ exp_tel +'">';
		new_Cell.innerHTML += '<input type="hidden" name="exp_salary' + row_count + '" value="'+ exp_salary +'">';
		new_Cell.innerHTML += '<input type="hidden" name="exp_extra_salary' + row_count + '" value="'+ exp_extra_salary +'">';
		new_Cell.innerHTML += '<input type="hidden" name="exp_extra' + row_count + '" value="'+ exp_extra +'">';
		new_Cell.innerHTML += '<input type="hidden" name="exp_reason' + row_count + '" value="'+ exp_reason +'">';
		new_Cell.innerHTML += '<input type="hidden" name="is_cont_work' + row_count + '" value="'+ is_cont_work +'">';
		
		new_Cell = new_Row.insertCell(new_Row.cells.length);
		new_Cell.innerHTML = '<input type="text" name="exp_name' + row_count + '" value="'+ exp_name +'" class="boxtext" readonly>';
		new_Cell = new_Row.insertCell(new_Row.cells.length);
		new_Cell.innerHTML = '<input type="text" name="exp_position' + row_count + '" value="'+ exp_position +'" class="boxtext" readonly>';
		if(exp_sector_cat != '')
		{
			var get_emp_cv = wrk_safe_query('hr_get_emp_cv_new','dsn',0,exp_sector_cat);
			/*if(get_emp_cv.recordcount)*/
				var exp_sector_cat_name = get_emp_cv.SECTOR_CAT;
		}
		else
			var exp_sector_cat_name = '';
		new_Cell = new_Row.insertCell(new_Row.cells.length);
		new_Cell.innerHTML = '<input type="text" name="exp_sector_cat_name' + row_count + '" value="'+exp_sector_cat_name+'" class="boxtext" readonly>';
		if(exp_task_id != '')
		{
			var get_emp_task_cv = wrk_safe_query('hr_get_emp_task_cv_new','dsn',0,exp_task_id);
			/*if(get_emp_task_cv.recordcount)*/
				var exp_task_name = get_emp_task_cv.PARTNER_POSITION;
		}
		else
		{
			var exp_task_name = '';
		}
		new_Cell = new_Row.insertCell(new_Row.cells.length);
		new_Cell.innerHTML = '<input type="text" name="exp_task_name' + row_count + '" value="'+exp_task_name+'" class="boxtext" readonly>';
		new_Cell = new_Row.insertCell(new_Row.cells.length);
		new_Cell.innerHTML = '<input type="text" name="exp_start' + row_count + '" value="'+ exp_start +'" class="boxtext" readonly>';
		new_Cell = new_Row.insertCell(new_Row.cells.length);
		new_Cell.innerHTML = '<input type="text" name="exp_finish' + row_count + '" value="'+ exp_finish +'" class="boxtext" readonly>';
		new_Cell = new_Row.insertCell(new_Row.cells.length);
		new_Cell.innerHTML = '<a href="javascript://" onClick="gonder_add('+row_count+');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>';
	}
}

	<cfif isdefined('get_edu_info') and (get_edu_info.recordcount)>
		row_edu=<cfoutput>#get_edu_info.recordcount#</cfoutput>;
		satir_say_edu=0;
	<cfelse>
		row_edu=0;
		satir_say_edu=0;
	</cfif>

function sil_edu(sv)
{
	
	var my_element=document.getElementById("row_kontrol_edu"+sv);
	my_element.value=0;
	var my_element=document.getElementById("frm_rowt"+sv);
	my_element.style.display="none";
	satir_say_edu--;
}

function gonder_upd_edu(count_new)
{
	edu_type_ = eval("employe_detail.edu_type"+count_new).value;
	form_edu_info.edu_type_new.value = edu_type_.split(';')[0]; //Okul Türü
	if(form_edu_info.edu_type != undefined){
		form_edu_info.edu_type.value = edu_type_.split(';')[0];
	}
	if(eval("employe_detail.edu_id"+count_new) != undefined && eval("employe_detail.edu_id"+count_new).value != '')//eğerki okul listeden seçiliyorsa seçilen okulun id si
		form_edu_info.edu_id_new.value = eval("employe_detail.edu_id"+count_new).value;
	else
		form_edu_info.edu_id_new.value = '';
	
	if(eval("employe_detail.edu_name"+count_new) != undefined && eval("employe_detail.edu_name"+count_new).value != '')
		form_edu_info.edu_name_new.value = eval("employe_detail.edu_name"+count_new).value;
	else
		form_edu_info.edu_name_new.value = '';
	
	form_edu_info.edu_start_new.value = eval("employe_detail.edu_start"+count_new).value;
	form_edu_info.edu_finish_new.value = eval("employe_detail.edu_finish"+count_new).value;
	form_edu_info.edu_rank_new.value = eval("employe_detail.edu_rank"+count_new).value;
	if(eval("employe_detail.edu_high_part_id"+count_new) != undefined && eval("employe_detail.edu_high_part_id"+count_new).value != '')
		form_edu_info.edu_high_part_id_new.value = eval("employe_detail.edu_high_part_id"+count_new).value;
	else
		form_edu_info.edu_high_part_id_new.value = '';
		
	if(eval("employe_detail.edu_part_id"+count_new) != undefined && eval("employe_detail.edu_part_id"+count_new).value != '')
		form_edu_info.edu_part_id_new.value = eval("employe_detail.edu_part_id"+count_new).value;
	else
		form_edu_info.edu_part_id_new.value = '';
		
	if(eval("employe_detail.edu_part_name"+count_new) != undefined && eval("employe_detail.edu_part_name"+count_new).value != '')
		form_edu_info.edu_part_name_new.value = eval("employe_detail.edu_part_name"+count_new).value;
	else
		form_edu_info.edu_part_name_new.value = '';
	form_edu_info.is_edu_continue_new.value = eval("employe_detail.is_edu_continue"+count_new).value;
	form_edu_info.action = '<cfoutput>#request.self#?fuseaction=myhome.popup_add_edu_info&count_edu='+count_new+'&ctrl_edu=1</cfoutput>';
	openBoxDraggable("<cfoutput>#request.self#?fuseaction=myhome.popup_add_edu_info&count_edu="+count_new+"&ctrl_edu=1</cfoutput>","","",$("#form_edu_info"));
}
	
function gonder_edu(edu_type,ctrl_edu,count_edu,edu_id,edu_name,edu_start,edu_finish,edu_rank,edu_high_part_id,edu_part_id,edu_part_name,education_time,edu_lang,edu_lang_rate,is_edu_continue)
{
	var edu_name_degisken = '';
	var edu_part_name_degisken = '';
	if(ctrl_edu == 1)
	{
		
		var edu_type = edu_type.split(';')[0];
		eval("employe_detail.edu_type"+count_edu).value=edu_type;
		if(edu_type != undefined && edu_type != '')
			{
				var get_edu_part_name_sql = wrk_safe_query('hr_get_edu_part_name','dsn',0,edu_type);
				if(get_edu_part_name_sql.recordcount)
					var edu_type_name = get_edu_part_name_sql.EDUCATION_NAME;
			}	
		eval("employe_detail.edu_type_name"+count_edu).value=edu_type_name;
		eval("employe_detail.edu_id"+count_edu).value=edu_id;
		eval("employe_detail.edu_high_part_id"+count_edu).value=edu_high_part_id;
		eval("employe_detail.edu_part_id"+count_edu).value=edu_part_id;
		if(edu_id != '' && edu_id != -1)
		{
			var get_cv_edu_new = wrk_safe_query('hr_get_cv_edu_new','dsn',0,edu_id);
			if(get_cv_edu_new.recordcount)
				var edu_name_degisken = get_cv_edu_new.SCHOOL_NAME;
			eval("employe_detail.edu_name"+count_edu).value=edu_name_degisken;
		}
		else
		{
			eval("employe_detail.edu_name"+count_edu).value=edu_name;
		}
		eval("employe_detail.edu_start"+count_edu).value=edu_start;
		eval("employe_detail.edu_finish"+count_edu).value=edu_finish;
		eval("employe_detail.edu_rank"+count_edu).value=edu_rank;
		if(eval("employe_detail.edu_high_part_id"+count_edu) != undefined && eval("employe_detail.edu_high_part_id"+count_edu).value != '' && edu_high_part_id != -1 )
		{
			var get_cv_edu_high_part_id = wrk_safe_query('hr_cv_edu_high_part_id_q','dsn',0,edu_high_part_id);
			if(get_cv_edu_high_part_id.recordcount)
				var edu_part_name_degisken = get_cv_edu_high_part_id.HIGH_PART_NAME;
			eval("employe_detail.edu_part_name"+count_edu).value=edu_part_name_degisken;
		}
		else if(eval("employe_detail.edu_part_id"+count_edu) != undefined && eval("employe_detail.edu_part_id"+count_edu).value != '' && edu_part_id != -1)
		{
			var get_cv_edu_part_id = wrk_safe_query('hr_cv_edu_part_id_q','dsn',0,edu_part_id);
			if(get_cv_edu_part_id.recordcount)
				var edu_part_name_degisken = get_cv_edu_part_id.PART_NAME;
			eval("employe_detail.edu_part_name"+count_edu).value=edu_part_name_degisken;
		}
		else 
		{
			var edu_part_name_degisken = edu_part_name;
			eval("employe_detail.edu_part_name"+count_edu).value=edu_part_name_degisken;
		}

		if(eval("employe_detail.is_edu_continue"+count_edu) != undefined)
		{
			eval("employe_detail.is_edu_continue"+count_edu).value=is_edu_continue;
		}

		if(eval("employe_detail.education_time"+count_edu) != undefined)
		{
			eval("employe_detail.education_time"+count_edu).value=education_time;
		}

		if(eval("employe_detail.edu_lang"+count_edu) != undefined)
		{
			eval("employe_detail.edu_lang"+count_edu).value=edu_lang;
		}

		if(eval("employe_detail.edu_lang_rate"+count_edu) != undefined)
		{
			eval("employe_detail.edu_lang_rate"+count_edu).value=edu_lang_rate;
		}
	}
	else
	{
		row_edu++;
		employe_detail.row_edu.value = row_edu;
		satir_say_edu++;
		var new_Row_Edu;
		var new_Cell_Edu;
		new_Row_Edu = document.getElementById("table_edu_info").insertRow(document.getElementById("table_edu_info").rows.length);
		new_Row_Edu.setAttribute("name","frm_rowt" + row_edu);
		new_Row_Edu.setAttribute("id","frm_rowt" + row_edu);
		
		var edu_type = edu_type.split(';')[0];
		if(edu_type != undefined && edu_type != '')
			{
				var get_edu_part_name_sql = wrk_safe_query('hr_get_edu_part_name','dsn',0,edu_type);
				if(get_edu_part_name_sql.recordcount)
					var edu_type_name = get_edu_part_name_sql.EDUCATION_NAME;
			}	
		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML = '<input  type="hidden" value="1" id="row_kontrol_edu' + row_edu +'" name="row_kontrol_edu' + row_edu +'" ><a href="javascript://" onclick="sil_edu(' + row_edu + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id ='57463.sil'>" title="<cf_get_lang dictionary_id ='57463.sil'>"></i></a>';
		new_Cell_Edu.innerHTML += '<input type="hidden" id="edu_type' + row_edu + '" name="edu_type' + row_edu + '" value="'+ edu_type +'">';
		new_Cell_Edu.innerHTML += '<input type="hidden" id="edu_id' + row_edu + '" name="edu_id' + row_edu + '" value="'+ edu_id +'" class="boxtext" readonly>';
		new_Cell_Edu.innerHTML += '<input type="hidden" id="edu_high_part_id' + row_edu + '" name="edu_high_part_id' + row_edu + '" value="'+ edu_high_part_id +'">';
		new_Cell_Edu.innerHTML += '<input type="hidden" id="edu_part_id' + row_edu + '" name="edu_part_id' + row_edu + '" value="'+ edu_part_id +'">';
		new_Cell_Edu.innerHTML += '<input type="hidden" id="is_edu_continue' + row_edu + '" name="is_edu_continue' + row_edu + '" value="'+ is_edu_continue +'">';
		new_Cell_Edu.innerHTML += '<input type="hidden" id="education_time' + row_edu + '" name="education_time' + row_edu + '" value="'+ education_time +'">';
		new_Cell_Edu.innerHTML += '<input type="hidden" id="edu_lang' + row_edu + '" name="edu_lang' + row_edu + '" value="'+ edu_lang +'">';
		new_Cell_Edu.innerHTML += '<input type="hidden" id="edu_lang_rate' + row_edu + '" name="edu_lang_rate' + row_edu + '" value="'+ edu_lang_rate +'">';

			
		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML = '<input type="text" id="edu_type_name' + row_edu + '" name="edu_type_name' + row_edu + '" value="'+ edu_type_name +'" class="boxtext" readonly>';
		if(edu_id != undefined && edu_id != '')
		{
			var get_cv_edu_new = wrk_safe_query('hr_get_cv_edu_new','dsn',0,edu_id);
			if(get_cv_edu_new.recordcount)
				var edu_name_degisken = get_cv_edu_new.SCHOOL_NAME;
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input type="text" id="edu_name' + row_edu + '" name="edu_name' + row_edu + '" value="'+ edu_name_degisken +'" class="boxtext" readonly>';
		}
		else if(edu_name != undefined && edu_name != '')
		{
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input type="text" id="edu_name' + row_edu + '" name="edu_name' + row_edu + '" value="'+ edu_name +'" class="boxtext" readonly>';
		}
		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML += '<input type="hidden" id="gizli' + row_edu + '" name="gizli' + row_edu + '" value="" class="boxtext" readonly>';
		new_Cell_Edu.innerHTML = '<input type="text" id="edu_start' + row_edu + '" name="edu_start' + row_edu + '" value="'+ edu_start +'" class="boxtext" readonly>';
		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML = '<input type="text" id="edu_finish' + row_edu + '" name="edu_finish' + row_edu + '" value="'+ edu_finish +'" class="boxtext" readonly>';
		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML = '<input type="text" id="edu_rank' + row_edu + '" name="edu_rank' + row_edu + '" value="'+ edu_rank +'" class="boxtext" readonly>';
		if(edu_high_part_id != undefined && edu_high_part_id != '' && edu_high_part_id != -1)
		{
			var get_cv_edu_high_part_id = wrk_safe_query('hr_cv_edu_high_part_id_q','dsn',0,edu_high_part_id);
			if(get_cv_edu_high_part_id.recordcount)
				var edu_part_name_degisken = get_cv_edu_high_part_id.HIGH_PART_NAME;
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input type="text" id="edu_part_name' + row_edu + '" name="edu_part_name' + row_edu + '" value="'+ edu_part_name_degisken +'" class="boxtext" readonly>';
		}
		else if(edu_part_id != undefined && edu_part_id != '' && edu_part_id != -1)
		{
			var get_cv_edu_part_id = wrk_safe_query('hr_cv_edu_part_id_q','dsn',0,edu_part_id);
			if(get_cv_edu_part_id.recordcount)
				var edu_part_name_degisken = get_cv_edu_part_id.PART_NAME;
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input type="text" id="edu_part_name' + row_edu + '" name="edu_part_name' + row_edu + '" value="'+ edu_part_name_degisken +'" class="boxtext" readonly>';
		}
		else
		{
		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML = '<input type="text" id="edu_part_name' + row_edu + '" name="edu_part_name' + row_edu + '" value="'+ edu_part_name +'" class="boxtext" readonly>';
		}
		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML = '<a href="javascript://" onClick="gonder_add_edu('+row_edu+');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>';
	}
}

function gonder_add_edu(count_new)
{
	edu_type_ = eval("employe_detail.edu_type"+count_new).value;
	form_edu_info.edu_type_new.value = edu_type_.split(';')[0];//Okul Türü
	if(form_edu_info.edu_type != undefined){
		form_edu_info.edu_type.value = edu_type_.split(';')[0];
	}
	if(eval("employe_detail.edu_id"+count_new) != undefined && eval("employe_detail.edu_id"+count_new).value != '')//eğerki okul listeden seçiliyorsa seçilen okulun id si
		form_edu_info.edu_id_new.value = eval("employe_detail.edu_id"+count_new).value;
	else
		form_edu_info.edu_id_new.value = '';
	
	if(eval("employe_detail.edu_name"+count_new) != undefined && eval("employe_detail.edu_name"+count_new).value != '')
		form_edu_info.edu_name_new.value = eval("employe_detail.edu_name"+count_new).value;
	else
		form_edu_info.edu_name_new.value = '';
	
	form_edu_info.edu_start_new.value = eval("employe_detail.edu_start"+count_new).value;
	form_edu_info.edu_finish_new.value = eval("employe_detail.edu_finish"+count_new).value;
	form_edu_info.edu_rank_new.value = eval("employe_detail.edu_rank"+count_new).value;
	if(eval("employe_detail.edu_high_part_id"+count_new) != undefined && eval("employe_detail.edu_high_part_id"+count_new).value != '')
		form_edu_info.edu_high_part_id_new.value = eval("employe_detail.edu_high_part_id"+count_new).value;
	else
		form_edu_info.edu_high_part_id_new.value = '';
		
	if(eval("employe_detail.edu_part_id"+count_new) != undefined && eval("employe_detail.edu_part_id"+count_new).value != '')
		form_edu_info.edu_part_id_new.value = eval("employe_detail.edu_part_id"+count_new).value;
	else
		form_edu_info.edu_part_id_new.value = '';
		
	if(eval("employe_detail.edu_part_name"+count_new) != undefined && eval("employe_detail.edu_part_name"+count_new).value != '')
		form_edu_info.edu_part_name_new.value = eval("employe_detail.edu_part_name"+count_new).value;
	else
		form_edu_info.edu_part_name_new.value = '';

	if(eval("employe_detail.is_edu_continue"+count_new) != undefined)
	{
		form_edu_info.is_edu_continue_new.value = eval("employe_detail.is_edu_continue"+count_new).value;
	}

	if(eval("employe_detail.education_time_new"+count_new) != undefined)
	{
		form_edu_info.education_time_new.value = eval("employe_detail.education_time_new"+count_new).value;
	}

	if(eval("employe_detail.edu_lang_new"+count_new) != undefined)
	{
		form_edu_info.edu_lang_new.value = eval("employe_detail.edu_lang_new"+count_new).value;
	}

	if(eval("employe_detail.edu_lang_rate_new"+count_new) != undefined)
	{
		form_edu_info.edu_lang_rate_new.value = eval("employe_detail.edu_lang_rate_new"+count_new).value;
	}
	form_edu_info.action = '<cfoutput>#request.self#?fuseaction=myhome.popup_add_edu_info&count_edu='+count_new+'&ctrl_edu=1</cfoutput>';
	openBoxDraggable("<cfoutput>#request.self#?fuseaction=myhome.popup_add_edu_info&count_edu="+count_new+"&ctrl_edu=1</cfoutput>","","",$("#form_edu_info"));
}
	/* Dil Bilgileri */
	var add_lang_info=0;
	function del_lang(dell){
			var my_emement1=eval("employe_detail.del_lang_info"+dell);
			my_emement1.value=0;
			var my_element1=eval("lang_info_"+dell);
			my_element1.style.display="none";
	}
	function add_lang_info_()
	{
		add_lang_info++;
		employe_detail.add_lang_info.value=add_lang_info;
		var newRow;
		var newCell;
		newRow = document.getElementById("lang_info").insertRow(document.getElementById("lang_info").rows.length);
		newRow.setAttribute("name","lang_info_" + add_lang_info);
		newRow.setAttribute("id","lang_info_" + add_lang_info);
		employe_detail.language_info.value=add_lang_info;

		newCell = newRow.insertCell();
		newCell.innerHTML ='<input type="hidden" value="1" name="del_lang_info'+ add_lang_info +'"><a onclick="del_lang(' + add_lang_info + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
		newCell = newRow.insertCell();
		newCell.innerHTML = '<div class="form-group"><select name="lang' + add_lang_info +'"><option value=""><cf_get_lang dictionary_id="58996.Dil"></option><cfoutput query="get_languages"><option value="#language_id#">#language_set#</option></cfoutput></select></div>';
		newCell = newRow.insertCell();
		newCell.innerHTML = '<div class="form-group"><select name="lang_speak' + add_lang_info +'"><cfoutput query="know_levels"><option value="#knowlevel_id#">#knowlevel#</option></cfoutput></select></div>';
		newCell = newRow.insertCell();
		newCell.innerHTML = '<div class="form-group"><select name="lang_mean' + add_lang_info +'"><cfoutput query="know_levels"><option value="#knowlevel_id#">#knowlevel#</option></cfoutput></select></div>';
		newCell = newRow.insertCell();
		newCell.innerHTML = '<div class="form-group"><select name="lang_write' + add_lang_info +'"><cfoutput query="know_levels"><option value="#knowlevel_id#">#knowlevel#</option></cfoutput></select></div>';
		newCell = newRow.insertCell();
		newCell.innerHTML = '<div class="form-group"><input type="text" name="lang_where' + add_lang_info + '" value=""></div>';
	}
	/*Referans bilgileri */
	var add_ref_info=0;
	function del_ref(dell){
			var my_emement1=eval("employe_detail.del_ref_info"+dell);
			my_emement1.value=0;
			var my_element1=eval("ref_info_"+dell);
			my_element1.style.display="none";
	}
	function add_ref_info_(){
		add_ref_info++;
		document.getElementById('add_ref_info').value=add_ref_info;
		var newRow;
		var newCell;
		newRow = document.getElementById("ref_info").insertRow(document.getElementById("ref_info").rows.length);
		newRow.setAttribute("name","ref_info_" + add_ref_info);
		newRow.setAttribute("id","ref_info_" + add_ref_info);
		document.getElementById('referance_info').value=add_ref_info;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="hidden" value="1" name="del_ref_info'+ add_ref_info +'"><a onclick="del_ref(' + add_ref_info + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="ref_type' + add_ref_info +'"><option value=""><cf_get_lang dictionary_id="31063.Referans Tipi"></option><cfoutput query="get_reference_type"><option value="#reference_type_id#">#reference_type#</option></cfoutput>/select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<div class="form-group"><input type="text" name="ref_name' + add_ref_info +'"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<div class="form-group"><input type="text" name="ref_company' + add_ref_info +'"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<div class="form-group"><input type="text" name="ref_telcode' + add_ref_info +'"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<div class="form-group"><input type="text" name="ref_tel' + add_ref_info +'"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<div class="form-group"><input type="text" name="ref_position' + add_ref_info +'"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<div class="form-group"><input type="text" name="ref_mail' + add_ref_info +'"></div>';
	}
	/*Referans bilgileri */
</script>
