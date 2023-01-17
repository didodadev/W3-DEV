<cfscript>
	get_imcat = createObject("component","V16.hr.cfc.get_im");
	get_imcat.dsn = dsn;
	get_ims = get_imcat.get_im(
		empapp_id : get_my_profile.EMPAPP_ID
	);
</cfscript>
<cfform action="#request.self#?fuseaction=myhome.emptypopup_upd_cv" name="employe_detail" method="post" enctype="multipart/form-data">
	<input type="Hidden" name="empapp_id" id="empapp_id" value="<cfoutput>#get_my_profile.EMPAPP_ID#</cfoutput>">
	<input type="Hidden" name="old_photo" id="old_photo" value="<cfoutput>#get_my_profile.photo#</cfoutput>">
	<input type="Hidden" name="old_photo_server_id" id="old_photo_server_id" value="<cfoutput>#get_my_profile.photo_server_id#</cfoutput>">
	<input type="hidden" name="counter" id="counter" value="">
	<cfif not len(get_my_profile.valid)>
		<input type="Hidden" name="valid" id="valid" value="">
	</cfif>
	<cf_box title="#getLang('','CV Güncelle',30808)#" closable="0">
		<cf_seperator id="kimlik_bilgileri" header="#getLang('','Kimlik ve İletişim Bilgileri',31647)#" is_closed="1">
			<cf_box_elements id="kimlik_bilgileri" style="display:none;">
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57487.No'></label>
						<div class="col col-8 col-sm-12">
							<cfoutput>#get_my_profile.EMPAPP_ID#</cfoutput>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58025.TC Kimlik No'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="TC_IDENTY_NO" maxlength="11" value="#get_my_profile_identy.TC_IDENTY_NO#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57631.Ad'>*</label>
						<div class="col col-8 col-sm-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58939.Ad girmelisiniz'></cfsavecontent>
							<cfinput type="text" value="#get_my_profile.name#" name="name" id="name" maxlength="50" required="Yes" message="#message#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58726.Soyad'>*</label>
						<div class="col col-8 col-sm-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='29503.Soyad girmelisiniz'></cfsavecontent>
							<cfinput value="#get_my_profile.surname#" type="text" name="surname" maxlength="50" required="Yes" message="#message#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57552.Sifre'>(<cf_get_lang dictionary_id='52872.Key Sensitive'>)</label>
						<div class="col col-8 col-sm-12">
							<cfinput value="" type="password" name="empapp_password" maxlength="16">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57428.webmail'></label>
						<div class="col col-8 col-sm-12">
							<cfsavecontent variable="mesaj"><cf_get_lang dictionary_id ='31691.E mail adresini giriniz'></cfsavecontent>
							<cfinput type="text" name="email" value="#get_my_profile.email#" validate="email" maxlength="100" message="#mesaj#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31261.Ev Tel'></label>
						<div class="col col-2 col-sm-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='31673.Ev Telefonu girmelisiniz'></cfsavecontent>
							<cfinput value="#get_my_profile.hometelcode#" type="text" name="hometelcode" maxlength="3" validate="integer" message="#message#">
						</div>
						<div class="col col-6 col-sm-12">
							<cfinput value="#get_my_profile.hometel#" type="text" name="hometel" maxlength="7"validate="integer" message="#message#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31263.Ev Adresi'></label>
						<div class="col col-8 col-sm-12">
							<cfsavecontent variable="message1"><cf_get_lang dictionary_id='29484.Fazla karakter sayisi'></cfsavecontent>
							<textarea name="homeaddress" id="homeaddress" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>" style="width:150px;height:60px;"><cfoutput>#get_my_profile.homeaddress#</cfoutput></textarea>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31653.Oturdugunuz Ev'></label>
						<div class="col col-3 col-sm-12">
							<input type="radio" name="home_status" id="home_status" value="1" <cfif get_my_profile.home_status eq 1>checked</cfif>>&nbsp;<cf_get_lang dictionary_id='31654.Kendinizin'>
						</div>
						<div class="col col-3 col-sm-12">
							<input type="radio" name="home_status" id="home_status" value="2" <cfif get_my_profile.home_status eq 2>checked</cfif>>&nbsp;<cf_get_lang dictionary_id='31655.Ailenizin'>
						</div>
						<div class="col col-2 col-sm-12">
							<input type="radio" name="home_status" id="home_status" value="3" <cfif get_my_profile.home_status eq 3>checked</cfif>>&nbsp;<cf_get_lang dictionary_id='31656.Kira'>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31495.Fotograf'></label>
						<div class="col col-8 col-sm-12">
							<input type="file" name="photo" id="photo">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cfif len(get_my_profile.photo)><cf_get_lang dictionary_id ='31719.Fotografi Sil'></cfif></label>
						<div class="col col-8 col-sm-12">
							<cfif len(get_my_profile.photo)>
								<input type="Checkbox" name="del_photo" id="del_photo" value="1">
								<cf_get_lang dictionary_id='57495.Evet'>
							</cfif>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31226.Uyrugu'></label>
						<div class="col col-8 col-sm-12">
							<select name="nationality" id="nationality">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_country">
								<option value="#country_id#" <cfif get_country.country_id eq get_my_profile.nationality>selected</cfif>>#country_name#</option>
								</cfoutput>
							</select>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31658.Kimlik Karti Tipi'></label>
						<div class="col col-8 col-sm-12">
							<select name="identycard_cat" id="identycard_cat" >
								<cfoutput query="get_id_card_cats">
								<option value="#identycat_id#" <cfif get_my_profile.identycard_cat eq identycat_id>selected</cfif>>#identycat# </cfoutput>
							</select>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31659.Kimlik Karti No'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="identycard_no" maxlength="50" value="#get_my_profile.identycard_no#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31660.Nüfusa Kayitli Oldugu Il'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="CITY" maxlength="100" value="#get_my_profile_identy.CITY#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31229.Instant Mesaj'></label>
						<div class="col col-8 col-sm-12">
							<cf_flat_list>
								<thead>
									<input type="hidden" name="add_im_info" id="add_im_info" value="<cfoutput>#get_ims.recordcount#</cfoutput>">
									<tr>
										<th width="20"><a onClick="add_im_info_();"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='44630.Ekle'>"></i></a></th>
										<th width="120"><cf_get_lang dictionary_id='57630.Tip'></th>
										<th width="120"><cf_get_lang dictionary_id='55686.Mail Adresi'></th>
									</tr>
								</thead>
								<tbody id="im_info">
									<input type="hidden" name="instant_info" id="instant_info" value="<cfoutput>#get_ims.recordcount#</cfoutput>">
									<cfif isdefined("get_ims")>
										<cfoutput query="get_ims">
										<tr id="im_info_#currentrow#">
											<td nowrap><a onClick="del_im('#currentrow#');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
											<td>
												<select name="imcat_id#currentrow#" id="imcat_id#currentrow#">
													<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
													<cfloop query="IM_CATS">
														<option value="#imcat_id#" <cfif get_ims.IMCAT_ID eq imcat_id> selected </cfif>>#imcat#</option>
													</cfloop>
												</select>
											</td>
											<td>
												<input type="text" name="im#currentrow#" id="im#currentrow#" value="#IM_ADDRESS#">
												<input type="hidden" name="del_im_info#currentrow#" id="del_im_info#currentrow#" value="1">
											</td>
										</tr>
										</cfoutput>
									</cfif>
								</tbody>
							</cf_flat_list>
						</div>                
					</div>
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
						<div class="col col-8 col-sm-12">
							<input type="checkbox" name="app_status" id="app_status" value="1" <cfif get_my_profile.app_status eq 1>checked</cfif>>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
						<div class="col col-8 col-sm-12">
							<select name="homecountry" id="homecountry">
								<option value=""><cf_get_lang dictionary_id ='57734.SEÇINIZ'></option>
								<cfoutput query="get_country">
								<option value="#get_country.country_id#" <cfif (get_my_profile.homecountry eq get_country.country_id) or (get_country.is_default eq 1)>selected</cfif>>#get_country.country_name#</option>
								</cfoutput>
							</select>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57971.Sehir'></label>
						<div class="col col-8 col-sm-12">
							<cfif len(get_my_profile.homecity)>
								<cfquery name="get_homecity" dbtype="query">
									SELECT CITY_NAME FROM get_city WHERE CITY_ID=#get_my_profile.homecity#
								</cfquery>
							</cfif>
							<div class="input-group">
								<input type="hidden" name="homecity" id="homecity" value="<cfoutput>#get_my_profile.homecity#</cfoutput>">
								<input type="text" name="homecity_name" id="homecity_name" value="<cfif isdefined('get_homecity')><cfoutput>#get_homecity.city_name#</cfoutput></cfif>">
								<span class="input-group-addon icon-ellipsis" onClick="pencere_ac_city();"></span>
							</div>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58638.Ilçe'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<input type="hidden" name="county_id" id="county_id" value="">
								<input type="text" name="homecounty" id="homecounty" value="<cfoutput>#get_my_profile.homecounty#</cfoutput>"> 
								<span class="input-group-addon icon-ellipsis" onClick="pencere_ac();"></span>
							</div>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31648.Direkt Tel'></label>
						<div class="col col-2 col-sm-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='31649.Direkt Telefon girmelisiniz'></cfsavecontent>
							<cfinput value="#get_my_profile.worktelcode#" type="text" name="worktelcode" maxlength="3" validate="integer" message="#message#">
						</div>
						<div class="col col-6 col-sm-12">
							<cfinput value="#get_my_profile.worktel#" type="text" name="worktel" maxlength="7" validate="integer" message="#message#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31650.Dahili Tel'></label>
						<div class="col col-8 col-sm-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='31651.Dahili Telefon girmelisiniz'></cfsavecontent>
							<cfinput value="#get_my_profile.extension#" type="text" name="extension" maxlength="5" validate="integer" message="#message#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58482.Mobil Tel'></label>
						<div class="col col-2 col-sm-12">
							<select name="mobilcode" id="mobilcode">
								<cfoutput query="mobil_cats">
								<option value="#mobilcat#" <cfif get_my_profile.mobilcode eq mobilcat>selected</cfif>>#mobilcat# </cfoutput>
							</select>
						</div>
						<div class="col col-6 col-sm-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='31672.Mobil Telefon girmelisiniz'></cfsavecontent>
							<cfinput value="#get_my_profile.mobil#" type="text" name="mobil" maxlength="7" validate="integer" message="#message#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58482.Mobil Tel'>2</label>
						<div class="col col-2 col-sm-12">
							<select name="mobilcode2" id="mobilcode2">
								<cfoutput query="mobil_cats">
								<option value="#mobilcat#" <cfif get_my_profile.mobilcode2 eq mobilcat>selected</cfif>>#mobilcat# </cfoutput>
							</select>
						</div>
						<div class="col col-6 col-sm-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='31672.Mobil Telefon girmelisiniz'></cfsavecontent>
							<cfinput value="#get_my_profile.mobil2#" type="text" name="mobil2" maxlength="7" validate="integer" message="#message#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="homepostcode" maxlength="10" value="#get_my_profile.homepostcode#">
						</div>                
					</div>
					
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58762.Vergi Dairesi'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="tax_office" maxlength="50" value="#get_my_profile.tax_office#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57752.Vergi No'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="tax_number" maxlength="50" value="#get_my_profile.tax_number#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58727.Dogum Tarih'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='31240.Dogum Tarihi girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="birth_date" value="#dateformat(get_my_profile_identy.birth_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="birth_date"></span>
							</div>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31657.Dogum Yeri(Ilçe / Il)'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="birth_place" maxlength="100" value="#get_my_profile_identy.birth_place#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57790.Doğum Yeri'><cf_get_lang dictionary_id='58608.İl'></label>
						<div class="col col-8 col-sm-12">
							<select name="birth_city" id="birth_city">
								<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
								<cfoutput query="get_city">
									<option value="#city_id#"<cfif get_my_profile_identy.birth_city eq city_id>selected</cfif>>#city_name#</option>
								</cfoutput>
							</select>	
						</div>                
					</div>
				</div>
			</cf_box_elements>
		<cf_seperator id="kisisel_bilgileri" header="#getLang('','Kişisel Bilgiler',30236)#" is_closed="1">			
			<cf_box_elements id="kisisel_bilgileri" style="display:none;">
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_stage">
						<label class="col col-7 col-sm-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
						<div class="col col-5 col-sm-12">
							<div class="col col-4 col-sm-12">
								<input type="radio" name="sex" id="sex" value="1" <cfif get_my_profile.sex eq 1>checked</cfif>><cf_get_lang dictionary_id='58959.Erkek'>
							</div>
							<div class="col col-4 col-sm-12">
								<input type="radio" name="sex" id="sex" value="0" <cfif get_my_profile.sex eq 0>checked</cfif>><cf_get_lang dictionary_id='58958.Kadin'>
							</div>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31662.Esinin Ad'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="partner_name" value="#get_my_profile.partner_name#" maxlength="150">
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31664.Esinin Pozisyonu'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="partner_position" maxlength="50" value="#get_my_profile.partner_position#">
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-7 col-sm-12"><cf_get_lang dictionary_id='31667.Sigara Kullaniyor mu'></label>
						<div class="col col-5 col-sm-12">
							<div class="col col-4 col-sm-12">
								<input type="radio" name="use_cigarette" id="use_cigarette" value="1" <cfif get_my_profile.use_cigarette eq 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'>
							</div>
							<div class="col col-4 col-sm-12">
								<input type="radio" name="use_cigarette" id="use_cigarette" value="0" <cfif get_my_profile.use_cigarette eq 0 or not len(get_my_profile.use_cigarette)>checked</cfif>><cf_get_lang dictionary_id='57496.Hayir'>
							</div>
						</div>                
					</div>  
					<div class="form-group" id="item-process_stage">
						<label class="col col-7 col-sm-12"><cf_get_lang dictionary_id='31232.Özürlü'></label>
						<div class="col col-5 col-sm-12">
							<div class="col col-4 col-sm-12">
								<input type="radio" name="defected" id="defected" value="1" onClick="seviye();" <cfif get_my_profile.defected eq 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'>
							</div>
							<div class="col col-4 col-sm-12">
								<input type="radio" name="defected" id="defected" value="0" onClick="seviye1();" <cfif get_my_profile.defected eq 0 or not len(get_my_profile.defected)>checked</cfif>><cf_get_lang dictionary_id='57496.Hayir'>
							</div>
							<div class="col col-4 col-sm-12">
								<select name="defected_level" id="defected_level" <cfif get_my_profile.defected eq 0>disabled</cfif>>
									<option value="0" <cfif get_my_profile.defected_level eq 0>selected</cfif>>%0</option>
									<option value="10" <cfif get_my_profile.defected_level eq 10>selected</cfif>>%10</option>
									<option value="20" <cfif get_my_profile.defected_level eq 20>selected</cfif>>%20</option>
									<option value="30" <cfif get_my_profile.defected_level eq 30>selected</cfif>>%30</option>
									<option value="40" <cfif get_my_profile.defected_level eq 40>selected</cfif>>%40</option>
									<option value="50" <cfif get_my_profile.defected_level eq 50>selected</cfif>>%50</option>
									<option value="60" <cfif get_my_profile.defected_level eq 60>selected</cfif>>%60</option>
									<option value="70" <cfif get_my_profile.defected_level eq 70>selected</cfif>>%70</option>
									<option value="80" <cfif get_my_profile.defected_level eq 80>selected</cfif>>%80</option>
									<option value="90" <cfif get_my_profile.defected_level eq 90>selected</cfif>>%90</option>
									<option value="100" <cfif get_my_profile.defected_level eq 100>selected</cfif>>%100</option>
								</select>
							</div>
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-7 col-sm-12"><cf_get_lang dictionary_id='31670.Hüküm Giydi mi'></label>
						<div class="col col-5 col-sm-12">
							<div class="col col-4 col-sm-12">
								<input type="radio" name="sentenced" id="sentenced" value="1" <cfif get_my_profile.sentenced EQ 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'>
							</div>
							<div class="col col-4 col-sm-12">
								<input type="radio" name="sentenced" id="sentenced" value="0" <cfif get_my_profile.sentenced EQ 0>checked</cfif>><cf_get_lang dictionary_id='57496.Hayir'>
							</div>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-7 col-sm-12"><cf_get_lang dictionary_id='31675.Göçmen'></label>
						<div class="col col-5 col-sm-12">
							<div class="col col-4 col-sm-12">
								<input type="radio" name="immigrant" id="immigrant" value="1" <cfif get_my_profile.immigrant EQ 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'>
							</div>
							<div class="col col-4 col-sm-12">
								<input type="radio" name="immigrant" id="immigrant" value="0" <cfif get_my_profile.immigrant EQ 0>checked</cfif>><cf_get_lang dictionary_id='57496.Hayir'>
							</div>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31676.Kaç yildir aktif olarak araba kullaniyorsunuz'></label>
						<div class="col col-8 col-sm-12">
							<cfsavecontent variable="mesaj"><cf_get_lang dictionary_id ='31690.Ehliyet Aktiflik Süresine Sayi Giriniz'>!</cfsavecontent>
							<cfinput type="text" name="driver_licence_actived" value="#get_my_profile.driver_licence_actived#" maxlength="2"  validate="integer" message="#mesaj#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-7 col-sm-12"><cf_get_lang dictionary_id='31677.Bir suç zanniyla tutuklandiniz mi veya mahkumiyetiniz oldu mu'></label>
						<div class="col col-5 col-sm-12">
							<div class="col col-4 col-sm-12">
								<input type="radio" name="defected_probability" id="defected_probability" value="1"  <cfif get_my_profile.defected_probability eq 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'>
							</div>
							<div class="col col-4 col-sm-12">
								<input type="radio" name="defected_probability" id="defected_probability" value="0" <cfif get_my_profile.defected_probability eq 0>checked</cfif>><cf_get_lang dictionary_id='57496.Hayir'>
							</div>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31678.Kogusturma'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="investigation" value="#get_my_profile.INVESTIGATION#" maxlength="150">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-7 col-sm-12"><cf_get_lang dictionary_id='31679.Devam eden bir hastalik veya bedeni sorununuz var mi'></label>
						<div class="col col-5 col-sm-12">
							<div class="col col-4 col-sm-12">
								<input type="radio" name="illness_probability" id="illness_probability" value="1" <cfif get_my_profile.illness_probability eq 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'>
							</div>
							<div class="col col-4 col-sm-12">
								<input type="radio" name="illness_probability" id="illness_probability" value="0" <cfif get_my_profile.illness_probability eq 0>checked</cfif>><cf_get_lang dictionary_id='57496.Hayir'>
							</div>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31371.Varsa nedir?'></label>
						<div class="col col-8 col-sm-12">
							<textarea name="illness_detail" id="illness_detail" style="width:150px;height:40px;"><cfoutput>#get_my_profile.illness_detail#</cfoutput></textarea>
						</div>                
					</div>
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_stage">
						<label class="col col-7 col-sm-12"><cf_get_lang dictionary_id='31203.Medeni Durum'></label>
						<div class="col col-5 col-sm-12">
							<div class="col col-4 col-sm-12">
								<input type="radio" name="married" id="married" value="0" <cfif get_my_profile_identy.married eq 0>checked</cfif>><cf_get_lang dictionary_id='31205.Bekar'>
							</div>
							<div class="col col-4 col-sm-12">
								<input type="radio" name="married" id="married" value="1" <cfif get_my_profile_identy.married eq 1>checked</cfif>><cf_get_lang dictionary_id='31204.Evli'>
							</div>
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31663.Esinin Çls Sirket'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="partner_company" maxlength="50" value="#get_my_profile.partner_company#">
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31665.ÇocukSayisi'></label>
						<div class="col col-8 col-sm-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='31666.Çocuk sayisi girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="child" maxlength="2" value="#get_my_profile.child#" validate="integer" message="#message#">
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-7 col-sm-12"><cf_get_lang dictionary_id='31231.Sehit Yakini Misiniz'></label>
						<div class="col col-5 col-sm-12">
							<div class="col col-4 col-sm-12">
								<input type="radio" name="martyr_relative" id="martyr_relative" value="1" <cfif get_my_profile.martyr_relative eq 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'>
							</div>
							<div class="col col-4 col-sm-12">
								<input type="radio" name="martyr_relative" id="martyr_relative" value="0" <cfif get_my_profile.martyr_relative eq 0 or not len(get_my_profile.martyr_relative)>checked</cfif>><cf_get_lang dictionary_id='57496.Hayir'>
							</div>
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31661.Ehliyet Sinif / Yil'></label>
						<div class="col col-8 col-sm-12">
							<cfquery name="GET_DRIVER_LIS" datasource="#DSN#">
								SELECT
									LICENCECAT_ID,
									LICENCECAT
								FROM
									SETUP_DRIVERLICENCE
								ORDER BY
									LICENCECAT
							</cfquery>
							<div class="col col-4 col-sm-12">
								<select name="driver_licence_type" id="driver_licence_type">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_driver_lis">
									<option value="#licencecat_id#" <cfif licencecat_id eq get_my_profile.licencecat_id>selected</cfif>>#licencecat#</option>
									</cfoutput>
								</select>
							</div>
							<div class="col col-8 col-sm-12">
								<div class="input-group">
									<cfsavecontent variable="message_driver"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
									<cfinput type="text" name="licence_start_date" value="#DateFormat(get_my_profile.licence_start_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message_driver#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="licence_start_date"></span>
								</div>
							</div>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31228.Ehliyet No'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="Text" name="driver_licence" maxlength="40" value="#get_my_profile.driver_licence#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31680.Geçirdiginiz Ameliyat'></label>
						<div class="col col-8 col-sm-12">
							<textarea name="surgical_operation" id="surgical_operation" maxlength="150" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"><cfoutput>#get_my_profile.SURGICAL_OPERATION#</cfoutput></textarea>
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31209.Askerlik'></label>
						<div class="col col-8 col-sm-12">
							<div class="col col-2 col-sm-12">
								<cf_get_lang dictionary_id='31210.Yapmadi'>&nbsp;&nbsp;&nbsp;<input type="radio" name="military_status" id="military_status" value="0" <cfif get_my_profile.military_status eq 0>checked</cfif> onClick="tecilli_fonk(this.value)">
							</div>
							<div class="col col-2 col-sm-12">
								<cf_get_lang dictionary_id='31211.Yapti'>&nbsp;&nbsp;&nbsp;<input type="radio" name="military_status" id="military_status" value="1" <cfif get_my_profile.military_status eq 1>checked</cfif> onClick="tecilli_fonk(this.value)">	
							</div>
							<div class="col col-2 col-sm-12">
								<cf_get_lang dictionary_id='31212.Muaf'>&nbsp;&nbsp;&nbsp;<input type="radio" name="military_status" id="military_status" value="2" <cfif get_my_profile.military_status eq 2>checked</cfif> onClick="tecilli_fonk(this.value)">	
							</div>
							<div class="col col-2 col-sm-12">
								<cf_get_lang dictionary_id='31213.Yabanci'> &nbsp;&nbsp;&nbsp;<input type="radio" name="military_status" id="military_status" value="3" <cfif get_my_profile.military_status eq 3>checked</cfif> onClick="tecilli_fonk(this.value)">	
							</div>
							<div class="col col-2 col-sm-12">
								<cf_get_lang dictionary_id='31214.Tecilli'><input type="radio" name="military_status" id="military_status" value="4" <cfif get_my_profile.military_status eq 4>checked</cfif> onClick="tecilli_fonk(this.value)">	
							</div>
						</div>                
					</div>
					<div <cfif get_my_profile.military_status neq 4>style="display:none"</cfif> id="Tecilli">
						<div class="form-group">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31215.Tecil Gerekçesi'></label>
							<div class="col col-8 col-sm-12">
								<cfinput type="text" name="military_delay_reason" maxlength="30" value="#get_my_profile.military_delay_reason#">
							</div>                
						</div>
						<div class="form-group">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31216.Tecil Süresi'></label>
							<div class="col col-8 col-sm-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='31218.Tecil Süresi girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="military_delay_date" value="#dateformat(get_my_profile.military_delay_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="military_delay_date"></span>
								</div>
							</div>                
						</div>
					</div>
					<div class="form-group" <cfif get_my_profile.military_status neq 2>style="display:none"</cfif> id="Muaf">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31223.Muaf Olma Nedeni'></label>
						<div class="col col-8 col-sm-12">
							<input type="text" name="military_exempt_detail" id="military_exempt_detail" maxlength="100" value="<cfoutput>#get_my_profile.military_exempt_detail#</cfoutput>">
						</div>                
					</div>
					<div <cfif get_my_profile.military_status neq 1>style="display:none"</cfif> id="Yapti">
						<div class="form-group">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31217.Terhis Tarihi'></label>
							<div class="col col-8 col-sm-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='31218.Tecil Süresi Girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="military_finishdate" value="#dateformat(get_my_profile.military_finishdate,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="military_finishdate"></span>
								</div>
							</div>                
						</div>
						<div class="form-group">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31219.Süresi (Ay Olarak Giriniz)'></label>
							<div class="col col-8 col-sm-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='31220.Askerlik Süresi Girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="military_month" value="#get_my_profile.military_month#" validate="integer" maxlength="2" message="#message#">
							</div>                
						</div>
						<div class="form-group">
							<label class="col col-4 col-sm-12"></label>
							<div class="col col-4 col-sm-12">
								<input type="radio" name="military_rank" id="military_rank" value="0" <cfif get_my_profile.military_rank eq 0>checked</cfif>><cf_get_lang dictionary_id='31221.Er'>
							</div>
							<div class="col col-4 col-sm-12">
								<input type="radio" name="military_rank" id="military_rank" value="1" <cfif get_my_profile.military_rank eq 1>checked</cfif>><cf_get_lang dictionary_id='31222.Yedek Subay'>
							</div>                
						</div>
					</div>
				</div>
			</cf_box_elements>
		<cf_seperator id="kimlik_detaylari" header="#getLang('','Kimlik Detayları',31682)#" is_closed="1">	
			<cf_box_elements id="kimlik_detaylari" style="display:none;">
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57637.Seri/No'></label>
						<div class="col col-2 col-sm-12">
							<cfinput type="text" name="series" maxlength="20" value="#get_my_profile_identy.series#">
						</div>
						<div class="col col-6 col-sm-12">
							<cfinput type="text" name="number" maxlength="50" value="#get_my_profile_identy.number#">
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58441.Kan Grubu'></label>
						<div class="col col-8 col-sm-12">
							<select name="BLOOD_TYPE" id="BLOOD_TYPE">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<option value="0"<cfif len(get_my_profile_identy.BLOOD_TYPE) and (get_my_profile_identy.BLOOD_TYPE eq 0)>selected</cfif>>0 Rh+</option>
								<option value="1"<cfif len(get_my_profile_identy.BLOOD_TYPE) and (get_my_profile_identy.BLOOD_TYPE eq 1)>selected</cfif>>0 Rh-</option>
								<option value="2"<cfif len(get_my_profile_identy.BLOOD_TYPE) and (get_my_profile_identy.BLOOD_TYPE eq 2)>selected</cfif>>A Rh+</option>
								<option value="3"<cfif len(get_my_profile_identy.BLOOD_TYPE) and (get_my_profile_identy.BLOOD_TYPE eq 3)>selected</cfif>>A Rh-</option>
								<option value="4"<cfif len(get_my_profile_identy.BLOOD_TYPE) and (get_my_profile_identy.BLOOD_TYPE eq 4)>selected</cfif>>B Rh+</option>
								<option value="5"<cfif len(get_my_profile_identy.BLOOD_TYPE) and (get_my_profile_identy.BLOOD_TYPE eq 5)>selected</cfif>>B Rh-</option>
								<option value="6"<cfif len(get_my_profile_identy.BLOOD_TYPE) and (get_my_profile_identy.BLOOD_TYPE eq 6)>selected</cfif>>AB Rh+</option>
								<option value="7"<cfif len(get_my_profile_identy.BLOOD_TYPE) and (get_my_profile_identy.BLOOD_TYPE eq 7)>selected</cfif>>AB Rh-</option>
							</select>
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58033.Baba Adi'></label>
						<div class="col col-8 col-sm-12">
							<cfinput name="father" type="text" value="#get_my_profile_identy.father#" maxlength="75">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31683.Baba Is'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="father_job" value="#get_my_profile_identy.father_job#" maxlength="50">
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31244.Önceki Soyadi'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="LAST_SURNAME" maxlength="100" value="#get_my_profile_identy.LAST_SURNAME#">
						</div>                
					</div> 
					<b><cf_get_lang dictionary_id='31247.Nüfusa Kayitli Oldugu'></b>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58638.Ilçe'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="COUNTY" maxlength="100" value="#get_my_profile_identy.COUNTY#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58735.Mahalle'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="WARD" maxlength="100" value="#get_my_profile_identy.WARD#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31254.Köy'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="VILLAGE" maxlength="100" value="#get_my_profile_identy.VILLAGE#">
						</div>                
					</div>
					<b><cf_get_lang dictionary_id='31255.Cüzdanin'></b>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31256.Verildigi Yer'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="GIVEN_PLACE" maxlength="100" value="#get_my_profile_identy.GIVEN_PLACE#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31258.Verilis Nedeni'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="GIVEN_REASON" maxlength="300" value="#get_my_profile_identy.GIVEN_REASON#">
						</div>                
					</div>
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58440.Ana Adi'></label>
						<div class="col col-8 col-sm-12">
							<cfinput name="mother" type="text" value="#get_my_profile_identy.mother#" maxlength="75">
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31684.Anne Is'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="mother_job" value="#get_my_profile_identy.mother_job#" maxlength="50">
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31241.Dini'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="religion" maxlength="50" value="#get_my_profile_identy.religion#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31249.Cilt No'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="BINDING" maxlength="20" value="#get_my_profile_identy.BINDING#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31251.Aile Sira No'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="FAMILY" maxlength="20" value="#get_my_profile_identy.FAMILY#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31253.Sira No'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="CUE" maxlength="20" value="#get_my_profile_identy.CUE#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31257.Kayit No'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="RECORD_NUMBER" maxlength="50" value="#get_my_profile_identy.RECORD_NUMBER#">
						</div>                
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31165.Verilis Tarihi'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='31165.Verilis Tarihi'></cfsavecontent>
								<cfinput type="text" name="GIVEN_DATE" value="#dateformat(get_my_profile_identy.GIVEN_DATE,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="GIVEN_DATE"></span>
							</div>
						</div>                
					</div>
				</div>
			</cf_box_elements>
		<cf_seperator id="egitim_deneyim" header="#getLang('','Eğitim Bilgileri',30644)#" is_closed="1">	
		
			<cfquery name="get_edu_info" datasource="#DSN#">

				SELECT
					*
				FROM
					EMPLOYEES_APP_EDU_INFO
				WHERE
					EMPAPP_ID=#get_my_profile.EMPAPP_ID#
			</cfquery>
			
			<div id="egitim_deneyim" style="display:none;">
				<cf_grid_list>
					<input type="hidden" name="row_edu" id="row_edu" value="<cfoutput>#get_edu_info.recordcount#</cfoutput>">
					<thead>
						<tr>
							<th width="20">
								<input name="record_numb_edu" id="record_numb_edu" type="hidden" value="0">
								<a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_add_edu_info&ctrl_edu=0');">
									<i class="fa fa-plus" title="<cf_get_lang dictionary_id ='31555.Egitim Bilgisi Ekle'>"></i>
								</a>
							</th>
							<th><cf_get_lang dictionary_id='31551.Okul Türü'></th>
							<th><cf_get_lang dictionary_id='31285.Okul Adi'></th>
							<th><cf_get_lang dictionary_id='31553.Basl Yili'></th>
							<th><cf_get_lang dictionary_id='31554.Bitis Yili'></th>
							<th><cf_get_lang dictionary_id='31482.Not Ort'></th>
							<th><cf_get_lang dictionary_id='57995.Bölüm'></th>
							<th></th>
						</tr>
					</thead>
					<tbody id="table_edu_info">
						<cfoutput query="get_edu_info">
						<tr id="frm_row_edu#currentrow#">
							<td><input  type="hidden" value="1" name="row_kontrol_edu#currentrow#"><a onclick="sil_edu(#currentrow#);"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id ="57463.sil">"></i></a></td>
							<input type="hidden" class="boxtext" name="empapp_edu_row_id#currentrow#" id="empapp_edu_row_id#currentrow#" value="#empapp_edu_row_id#">
							<td>
								<input type="hidden" name="edu_type#currentrow#" id="edu_type#currentrow#" class="boxtext" value="#edu_type#" readonly>
								<cfif len(edu_type)>
									<cfquery name="get_education_level_name" datasource="#dsn#">
										SELECT EDU_LEVEL_ID,#DSN#.#dsn#.Get_Dynamic_Language(EDU_LEVEL_ID,'#session.ep.language#','SETUP_EDUCATION_LEVEL','EDUCATION_NAME',NULL,NULL,SETUP_EDUCATION_LEVEL.EDUCATION_NAME ) AS EDUCATION_NAME ,EDU_TYPE FROM SETUP_EDUCATION_LEVEL WHERE EDU_LEVEL_ID =#edu_type#
									</cfquery>
									<cfset edu_type_name=get_education_level_name.education_name>											
								</cfif>												
								<input type="text" name="edu_type_name#currentrow#" id="edu_type_name#currentrow#" class="boxtext" value="<cfif len(edu_type)>#edu_type_name#</cfif>" readonly>
							</td>
							<td>
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
							<td><input type="text" name="edu_start#currentrow#" id="edu_start#currentrow#" class="boxtext" value="#Dateformat(edu_start,dateformat_style)#" readonly></td>
							<td><input type="text" name="edu_finish#currentrow#" id="edu_finish#currentrow#" class="boxtext" value="#Dateformat(edu_finish,dateformat_style)#" readonly></td>
							<td><input type="text" name="edu_rank#currentrow#" id="edu_rank#currentrow#" class="boxtext" value="#edu_rank#" readonly></td>
							<td><cfif (len(edu_part_id) and edu_part_id neq -1)>
									<cfif get_education_level_name.edu_type eq 1><!--- edu_type 0:İlköğretim,1:lise,2:üniversite--->
											<cfquery name="get_high_school_part_name" datasource="#dsn#">
												SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART WHERE HIGH_PART_ID = #edu_part_id#
											</cfquery>
											<cfset edu_part_name_degisken = get_high_school_part_name.HIGH_PART_NAME>
									<cfelse> <!--- üniversite--->
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
								<input type="text" name="edu_part_name#currentrow#" id="edu_part_name#currentrow#" class="boxtext" value="<cfif isdefined("edu_part_name_degisken")>#edu_part_name_degisken#</cfif>" readonly>
								<input type="hidden" name="edu_high_part_id#currentrow#" id="edu_high_part_id#currentrow#" class="boxtext" value="<cfif isdefined("edu_part_id") and len(edu_part_id) and edu_type eq 3>#edu_part_id#</cfif>">
								<input type="hidden" name="edu_part_id#currentrow#" id="edu_part_id#currentrow#" class="boxtext" value="<cfif listfind('4,5',edu_type) and isdefined("edu_part_id") and len(edu_part_id)>#edu_part_id#</cfif>">
								<input type="hidden" name="is_edu_continue#currentrow#" id="is_edu_continue#currentrow#" class="boxtext" value="#is_edu_continue#">
							</td>
							<td><a onClick="gonder_upd_edu('#currentrow#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='31721.Eğitim Bilgisi Güncelle'>"></i></a></td>
						</tr>
					</tbody>
						</cfoutput>
				</cf_grid_list>
				<div class="form-group" id="item-name">
					<label class="col col-2 col-sm-12"><cf_get_lang dictionary_id='31686.Egitim Seviyesi'></label>
					<div class="col col-8 col-sm-12">
						<div class="input-group">
							<select name="training_level" id="training_level">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfloop query="get_edu_level">
									<option value="<cfoutput>#get_edu_level.edu_level_id#</cfoutput>" <cfif get_edu_level.edu_level_id eq get_my_profile.training_level>selected</cfif>><cfoutput>#get_edu_level.education_name#</cfoutput></option>
								</cfloop>
							</select>
						</div> 
					</div>                
				</div>
				<cf_grid_list>
					<thead>
						<th colspan="5"><cf_get_lang dictionary_id='31692.Kurs - Seminer ve Akademik Olmayan Programlar'></th>
						<tr>
							<th width="110"></th>
							<th class="txtboldblue"><cf_get_lang dictionary_id='57480.Konu'></th>
							<th class="txtboldblue"><cf_get_lang dictionary_id='58455.Yil'></th>
							<th class="txtboldblue"><cf_get_lang dictionary_id='31296.Yer'></th>
							<th class="txtboldblue"><cf_get_lang dictionary_id='57490.Gün'></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td height="26"><cf_get_lang dictionary_id='31294.Kurs'></td>
							<td><cfinput type="text" name="kurs1" value="#get_my_profile.KURS1#" maxlength="150"></td>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31861.Kurs1 Için Yili Girin'></cfsavecontent>
							<td><cfinput type="text" name="kurs1_yil" value="#dateformat(get_my_profile.KURS1_YIL,'yyyy')#" maxlength="4" range="1900," validate="integer" message="#message#"></td>
							<td><cfinput type="text" name="kurs1_yer" value="#get_my_profile.KURS1_YER#" maxlength="150"></td>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31862.Kurs 1 Gün Sayisini Girin'></cfsavecontent>
							<td><cfinput type="text" name="kurs1_gun" value="#get_my_profile.KURS1_GUN#" validate="maxlength" message="#message#" maxlength="50"></td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='31294.Kurs'></td>  
							<td><cfinput type="text" name="kurs2" value="#get_my_profile.KURS2#" maxlength="150"></td>
							<cfsavecontent variable="message2"><cf_get_lang dictionary_id='31864.Kurs2 Için Yili Girin'></cfsavecontent>
							<td><cfinput type="text" name="kurs2_yil" value="#dateformat(get_my_profile.KURS2_YIL,'yyyy')#" maxlength="4" range="1900," validate="integer" message="#message2#"></td>
							<td><cfinput type="text" name="kurs2_yer" value="#get_my_profile.KURS2_YER#" maxlength="150"></td>
							<cfsavecontent variable="message2"><cf_get_lang dictionary_id ='31865.Kurs 2 Gün Sayisini Girin'></cfsavecontent>
							<td><cfinput type="text" name="kurs2_gun" value="#get_my_profile.KURS2_GUN#" validate="maxlength" message="#message2#" maxlength="50"></td>
						</tr>  
						<tr>
							<td><cf_get_lang dictionary_id='31294.Kurs'></td>  
							<td><cfinput type="text" name="kurs3" value="#get_my_profile.KURS3#" maxlength="150"></td>
							<cfsavecontent variable="message3"><cf_get_lang dictionary_id ='31866.Kurs3 Için Yili Girin'></cfsavecontent>
							<td><cfinput type="text" name="kurs3_yil" value="#dateformat(get_my_profile.KURS3_YIL,'yyyy')#" maxlength="4" range="1900," validate="integer" message="#message3#"></td>
							<td><cfinput type="text" name="kurs3_yer" value="#get_my_profile.KURS3_YER#" maxlength="150"></td>
							<cfsavecontent variable="message3"><cf_get_lang dictionary_id ='31867.Kurs 3 Gün Sayisini Girin'></cfsavecontent>
							<td><cfinput type="text" name="kurs3_gun" value="#get_my_profile.KURS3_GUN#" validate="maxlength" message="#message3#" maxlength="50"></td>
						</tr>
						<tr>
							<td valign="top"><cf_get_lang dictionary_id='31301.Bilgisayar Bilgisi'></td>
							<td colspan="3">
								<textarea name="comp_exp" id="comp_exp" style="width:457px;height:60px;"><cfoutput>#get_my_profile.COMP_EXP#</cfoutput></textarea>
							</td>
						</tr>
					</tbody>
				</cf_grid_list>
			</div>
			<!--- Yabanci Diller --->
			<cf_seperator id="yabanci_diller" header="#getLang('','Diller',31303)#" is_closed="1">
				<cf_grid_list id="yabanci_diller" style="display:none;">
					<cfquery name="get_emp_language" datasource="#dsn#">
						SELECT 
							EMPAPP_ID,
							LANG_ID,
							LANG_SPEAK,
							LANG_WRITE,
							LANG_MEAN,
							LANG_WHERE 
						FROM 
							EMPLOYEES_APP_LANGUAGE
						WHERE
							EMPAPP_ID = #get_my_profile.EMPAPP_ID#
					</cfquery>
					<input type="hidden" name="add_lang_info" id="add_lang_info" value="<cfoutput>#get_emp_language.recordcount#</cfoutput>">
					<thead>
						<tr>
							<th width="20"><a href="javascript://" onClick="add_lang_info_();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='44630.Ekle'>"></i></a></th>
							<th><cf_get_lang dictionary_id='58996.Dil'></th>
							<th><cf_get_lang dictionary_id='31304.Konuşma'></th>
							<th><cf_get_lang dictionary_id='31305.Anlama'></th>
							<th><cf_get_lang dictionary_id='31306.Yazma'></th>
							<th><cf_get_lang dictionary_id='31307.Öğrenildiği Yer'></th>
						</tr>
					</thead>
					<input type="hidden" name="language_info" id="language_info" value="">
					<tbody id="lang_info">
						<cfoutput query="get_emp_language">
							<tr id="lang_info_#currentrow#">
								<td><a onClick="del_lang('#currentrow#');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
								<td>
									<select name="lang#currentrow#" id="lang#currentrow#">
										<option value=""><cf_get_lang dictionary_id='58996.Dil'></option>
										<cfloop query="get_languages">
											<option value="#language_id#"<cfif language_id eq get_emp_language.LANG_ID>selected</cfif>>#language_set#</option>
										</cfloop>
									</select>
								</td>
								<td>
									<select name="lang_speak#currentrow#" id="lang_speak#currentrow#">
										<cfloop query="know_levels">
											<option value="#knowlevel_id#"<cfif knowlevel_id eq get_emp_language.lang_speak>selected</cfif>>#knowlevel#</option>
										</cfloop>
									</select>
								</td>
								<td>
									<select name="lang_mean#currentrow#" id="lang_mean#currentrow#">
										<cfloop query="know_levels">
											<option value="#knowlevel_id#"<cfif knowlevel_id eq get_emp_language.lang_mean>selected</cfif>>#knowlevel#</option>
										</cfloop>
									</select>
								</td>
								<td>
									<select name="lang_write#currentrow#" id="lang_write#currentrow#">
										<cfloop query="know_levels">
											<option value="#knowlevel_id#"<cfif knowlevel_id eq get_emp_language.lang_write>selected</cfif>>#knowlevel#</option>
										</cfloop>
									</select>
								</td>
								<td>
									<input type="text" name="lang_where#currentrow#" id="lang_where#currentrow#" value="#get_emp_language.lang_where#">
									<input type="hidden" name="del_lang_info#currentrow#" id="del_lang_info#currentrow#" value="1">
								</td>
							</tr>
						</cfoutput>
					</tbody>
				</cf_grid_list>
			<!--- //Yabanci Diller --->
		<cf_seperator id="deneyim_" header="#getLang('','Deneyim Bilgileri',31527)#" is_closed="1"> 
			<cfquery name="get_work_info" datasource="#DSN#">
				SELECT
					*
				FROM
					EMPLOYEES_APP_WORK_INFO
				WHERE
					EMPAPP_ID=#get_my_profile.EMPAPP_ID#
			</cfquery>	
			<cf_grid_list id="deneyim_" style="display:none;">		
				<input type="hidden" name="row_count" id="row_count" value="<cfoutput>#get_work_info.recordcount#</cfoutput>">
				<input type="hidden" name="row_kontrol" id="row_kontrol" value="<cfoutput>#get_work_info.recordcount#</cfoutput>">
				<thead>
					<tr>
						<th width="20"><input name="record_num" id="record_num" type="hidden" value="0"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=myhome.popup_upd_work_info&control=0</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='31526.Is Tecrübesi Ekle'>"></i></a></th>
						<th><cf_get_lang dictionary_id='31549.Çalisilan Yer'></th>
						<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
						<th><cf_get_lang dictionary_id='57579.Sektör'></th>
						<th><cf_get_lang dictionary_id='57571.Ünvan'></th>
						<th><cf_get_lang dictionary_id='57655.Baslama Tarihi'></th>
						<th><cf_get_lang dictionary_id='57700.Bitis Tarihi'></th>
						<th></th>
					</tr>
				</thead>
				<tbody id="table_work_info">
				<cfoutput query="get_work_info">
					<tr id="frm_row#currentrow#">
						<td><input type="hidden" value="1" id="row_kontrol#currentrow#" name="row_kontrol#currentrow#"><a href="javascript://" onClick="sil('#currentrow#');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
						<input type="hidden" name="exp_telcode#currentrow#" id="exp_telcode#currentrow#" value="#exp_telcode#">
						<input type="hidden" name="exp_tel#currentrow#" id="exp_tel#currentrow#" value="#exp_tel#">
						<input type="hidden" name="exp_salary#currentrow#" id="exp_salary#currentrow#" class="boxtext" value="#exp_salary#">
						<input type="hidden" name="exp_extra_salary#currentrow#" id="exp_extra_salary#currentrow#" value="#exp_extra_salary#">
						<input type="hidden" name="exp_extra#currentrow#" id="exp_extra#currentrow#" value="#exp_extra#">
						<input type="hidden" name="exp_reason#currentrow#" id="exp_reason#currentrow#" value="#exp_reason#">
						<input type="hidden" name="is_cont_work#currentrow#" id="is_cont_work#currentrow#" value="#is_cont_work#">
						<input type="hidden" class="boxtext" name="empapp_row_id#currentrow#" id="empapp_row_id#currentrow#" value="#empapp_row_id#">
						<td><input type="text" name="exp_name#currentrow#" id="exp_name#currentrow#" class="boxtext" value="#exp#" readonly></td>
						<td><input type="text" name="exp_position#currentrow#" id="exp_position#currentrow#" class="boxtext" value="#exp_position#" readonly></td>
						<td><input type="hidden" name="exp_sector_cat#currentrow#" id="exp_sector_cat#currentrow#" class="boxtext" value="#exp_sector_cat#">
							<cfif isdefined("exp_sector_cat") and len(exp_sector_cat)>
								<cfquery name="get_sector_cat" datasource="#dsn#">
									SELECT SECTOR_CAT_ID,SECTOR_CAT FROM SETUP_SECTOR_CATS WHERE SECTOR_CAT_ID = #exp_sector_cat#
								</cfquery>
							</cfif>
							<input type="text" name="exp_sector_cat_name#currentrow#" id="exp_sector_cat_name#currentrow#" class="boxtext" value="<cfif isdefined("exp_sector_cat") and len(exp_sector_cat) and get_sector_cat.recordcount>#get_sector_cat.sector_cat#</cfif>" readonly>
						</td>
						<td><input type="hidden" name="exp_task_id#currentrow#" id="exp_task_id#currentrow#" class="boxtext" value="#exp_task_id#">
							<cfif isdefined("exp_task_id") and len(exp_task_id)>
								<cfquery name="get_exp_task_name" datasource="#dsn#">
									SELECT PARTNER_POSITION_ID,PARTNER_POSITION FROM SETUP_PARTNER_POSITION WHERE PARTNER_POSITION_ID = #exp_task_id#
								</cfquery>
							</cfif>
							<input type="text" name="exp_task_name#currentrow#" id="exp_task_name#currentrow#" class="boxtext" value="<cfif isdefined("exp_task_id") and len(exp_task_id) and get_exp_task_name.recordcount>#get_exp_task_name.partner_position#</cfif>" readonly>
						</td>
						<td><input type="text" name="exp_start#currentrow#" id="exp_start#currentrow#" class="boxtext" value="#dateformat(exp_start,dateformat_style)#" readonly></td>
						<td><input type="text" name="exp_finish#currentrow#" id="exp_finish#currentrow#" class="boxtext" value="#dateformat(exp_finish,dateformat_style)#" readonly></td>
						<td><a href="javascript://" onClick="gonder_upd('#currentrow#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='31694.Is Tecrübesi Güncelle'>"></i></a></td>
					</tr>
				</cfoutput>
				</tbody>
			</cf_grid_list>
		<cf_seperator id="referans" header="#getLang('','Referans Bilgileri',31695)#" is_closed="1">
			<cfquery name="get_emp_reference" datasource="#dsn#">
				SELECT * FROM EMPLOYEES_REFERENCE WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_my_profile.EMPAPP_ID#">
			</cfquery>
			<cf_grid_list id="referans" style="display:none;">
				<thead>
				<input type="hidden" name="add_ref_info" id="add_ref_info" value="<cfoutput>#get_emp_reference.recordcount#</cfoutput>">
					<tr>
						<th width="20"><a onClick="add_ref_info_();"><i class="fa fa-plus" alt="Ekle"></i></a></th>
						<th width="120"><cf_get_lang dictionary_id='31063.Referans Tipi'></th>
						<th width="100"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
						<th width="100"><cf_get_lang dictionary_id='57574.Şirket'></th>
						<th width="100"><cf_get_lang dictionary_id='30316.Telefon Kodu'></th>
						<th width="100"><cf_get_lang dictionary_id='57499.Telefon'></th>
						<th width="100"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
						<th width="100"><cf_get_lang dictionary_id='32508.E-mail'></th>
					</tr>
				</thead>
				<tbody id="ref_info">
					<input type="hidden" name="referance_info" id="referance_info" value="<cfoutput>#get_emp_reference.recordcount#</cfoutput>">
					<cfif isdefined("get_emp_reference")>
						<cfoutput query="get_emp_reference">
							<tr id="ref_info_#currentrow#">
								<td nowrap><a onClick="del_ref('#currentrow#');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
								<td>
									<div class="form-group">
										<select name="ref_type#currentrow#" id="ref_type#currentrow#">
											<option value=""><cf_get_lang dictionary_id='31063.Referans Tipi'></option>
											<cfloop query="get_reference_type">
												<option value="#reference_type_id#"<cfif len(get_emp_reference.REFERENCE_TYPE) and (get_emp_reference.REFERENCE_TYPE eq reference_type_id)>selected</cfif>>#reference_type#</option>
											</cfloop>
										</select>
									</div>
								<td><div class="form-group"><input type="text" name="ref_name#currentrow#" id="ref_name#currentrow#" value="#REFERENCE_NAME#"></div></td>
								<td><div class="form-group"><input type="text" name="ref_company#currentrow#" id="ref_company#currentrow#" value="#REFERENCE_COMPANY#"></div></td>
								<td><div class="form-group"><input type="text" name="ref_telcode#currentrow#" id="ref_telcode#currentrow#" value="#REFERENCE_TELCODE#"></div></td>
								<td><div class="form-group"><input type="text" name="ref_tel#currentrow#" id="ref_tel#currentrow#" value="#REFERENCE_TEL#"></div></td>
								<td><div class="form-group"><input type="text" name="ref_position#currentrow#" id="ref_position#currentrow#" value="#REFERENCE_POSITION#"></div></td>
								<td>
									<div class="form-group">
										<input type="text" name="ref_mail#currentrow#" id="ref_mail#currentrow#" value="#REFERENCE_EMAIL#">
										<input type="hidden" name="del_ref_info#currentrow#" id="del_ref_info#currentrow#" value="1">
									</div>
								</td>
							</tr>
						</cfoutput>
					</cfif>
				</tbody>
			</cf_grid_list>
		<cf_seperator id="hobi" header="#getLang('myhome','İlgi alanları ve üye olunan kulüpler',31299)#" is_closed="1">
			<cf_box_elements id="hobi" style="display:none;">
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31697.Özel Ilgi Alanlari'></label>
						<div class="col col-8 col-sm-12">
							<textarea name="hobby" id="hobby" style="width:250px;" maxlength="150" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"><cfoutput>#get_my_profile.hobby#</cfoutput></textarea>
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31300.Üye Olunan Klüp Ve Dernekler'></label>
						<div class="col col-8 col-sm-12">
							<textarea name="club" id="club" style="width:250px;" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"><cfoutput>#get_my_profile.club#</cfoutput></textarea>
						</div>                
					</div> 
				</div>
			</cf_box_elements>
		<cf_seperator id="aile_bilgileri" header="#getLang('','Aile Bilgileri',31698)#" is_closed="1">
			<cf_grid_list style="display:none;" id="aile_bilgileri">
				<thead>
					<tr>
						<input type="hidden" name="rowCount" id="rowCount" value="1" />
						<th width="20"><a onClick="addRow()"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a></th>
						<th width="100"><cf_get_lang dictionary_id='57631.Ad'></th>
						<th width="100"><cf_get_lang dictionary_id='58726.Soyad'></th>
						<th width="100"><cf_get_lang dictionary_id='31277.Yakinlik Derecesi'></th>
						<th width="200"><cf_get_lang dictionary_id='58727.Dogum Tarihi'></th>
						<th width="100"><cf_get_lang dictionary_id='57790.Dogum Yeri'></th>
						<th width="200"><cf_get_lang dictionary_id='57419.Egitim'></th>
						<th width="100"><cf_get_lang dictionary_id='31278.Meslek'></th>
						<th width="100"><cf_get_lang dictionary_id='57574.Sirket'></th>
						<th width="100"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
					</tr>
				</thead>
				<cfquery name="get_relatives" datasource="#DSN#">
					SELECT
						*
					FROM
						EMPLOYEES_RELATIVES
					WHERE
						EMPAPP_ID=#get_my_profile.EMPAPP_ID#
					ORDER BY
						BIRTH_DATE, NAME, SURNAME, RELATIVE_LEVEL
				</cfquery>
				<tbody id="table_list">
				<cfif get_relatives.recordcount>
					<cfoutput query="get_relatives">
						<input type="hidden" name="rowCount#currentrow#" id="rowCount#currentrow#" value="1">
						<input type="hidden" name="relative_id#currentrow#" id="relative_id#currentrow#" value="#get_relatives.relative_id#">
						<input type="hidden" name="relative_sil#currentrow#" id="relative_sil#currentrow#" value="0">
						<tr id="frm_row#currentrow#">
							<td><a href="javascript://" onClick="relative_sil(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id ='57463.Sil'>"></i></a></td>
							<td><div class="form-group"><input type="text" name="name_relative#currentrow#" id="name_relative#currentrow#" value="#get_relatives.name#" maxlength="50"></div></td>
							<td><div class="form-group"><input type="text" name="surname_relative#currentrow#" id="surname_relative#currentrow#" value="#get_relatives.surname#" maxlength="50"></td>
							<td>
								<div class="form-group">
									<select name="relative_level#currentrow#" id="relative_level#currentrow#">
										<option value="1" <cfif get_relatives.relative_level eq 1>selected</cfif>><cf_get_lang dictionary_id ='31327.Baba'></option>
										<option value="2" <cfif get_relatives.relative_level eq 2>selected</cfif>><cf_get_lang dictionary_id ='31328.Anne'></option>
										<option value="3" <cfif get_relatives.relative_level eq 3>selected</cfif>><cf_get_lang dictionary_id ='31329.Esi'></option>
										<option value="4" <cfif get_relatives.relative_level eq 4>selected</cfif>><cf_get_lang dictionary_id ='31330.Oglu'></option>
										<option value="5" <cfif get_relatives.relative_level eq 5>selected</cfif>><cf_get_lang dictionary_id ='31331.Kizi'></option>
										<option value="6" <cfif get_relatives.relative_level eq 6>selected</cfif>><cf_get_lang dictionary_id ='31449.Kardesi'></option>
									</select>
								</div>
							</td>
							<td>
								<div class="form-group">
									<div class="input-group">
										<cfinput type="text" name="birth_date_relative#currentrow#" value="#dateformat(get_relatives.birth_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
										<span class="input-group-addon"><cf_wrk_date_image date_field="birth_date_relative#currentrow#"></span>
									</div>
								</div>
							</td>
							<td><div class="form-group"><cfinput type="text" name="birth_place_relative#currentrow#" value="#get_relatives.birth_place#"></div></td>
							<td>
								<div class="form-group">
									<select name="education_relative#currentrow#" id="education_relative#currentrow#">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfloop query="get_edu_level">
										<option value="#get_edu_level.edu_level_id#" <cfif get_edu_level.edu_level_id eq get_relatives.education>selected</cfif>>#get_edu_level.education_name#</option>
										</cfloop>
									</select>
								
									<input type="checkbox" name="education_status_relative#currentrow#" id="education_status_relative#currentrow#" value="1" <cfif get_relatives.education_status eq 1>checked</cfif>><cf_get_lang dictionary_id ='31332.Okuyor'>
								</div>
							</td>
							<td><div class="form-group"><cfinput type="text" name="job_relative#currentrow#" value="#get_relatives.job#" maxlength="30"></div></td>
							<td><div class="form-group"><cfinput type="text" name="company_relative#currentrow#" value="#get_relatives.company#" maxlength="50"></div></td>
							<td><div class="form-group"><cfinput type="text" name="job_position_relative#currentrow#" value="#get_relatives.job_position#" maxlength="30"></div></td>
						</tr>
					</cfoutput>	
				</cfif>
				</tbody>
			</cf_grid_list> 
		<cf_seperator id="working_department" header="#getLang('','Çalışmak istediğiniz birimler',31699)#" is_closed="1">
			<cf_box_elements id="working_department" style="display:none;">
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<b><cf_get_lang dictionary_id='31700.Öncelik siralarini yandaki kutulara yaziniz'></b>
					<cfquery name="get_cv_unit" datasource="#dsn#">
						SELECT 
							* 
						FROM 
							SETUP_CV_UNIT
					</cfquery>
					<cfif get_cv_unit.recordcount>
						<cfquery name="get_my_profile_unit" datasource="#dsn#"> 
							SELECT 
								UNIT_ID,UNIT_ROW
							FROM 
								EMPLOYEES_APP_UNIT
							WHERE 
								EMPAPP_ID=#get_my_profile.EMPAPP_ID#
						</cfquery>
						<cfset liste = valuelist(get_my_profile_unit.unit_id)>
						<cfset liste_row = valuelist(get_my_profile_unit.unit_row)>					
						<cfoutput query="get_cv_unit">
							<div class="form-group">
								<label class="col col-4 col-sm-12">#get_cv_unit.unit_name#</label>
								<cfsavecontent variable="messages"><cf_get_lang dictionary_id ='31701.Sayi Giriniz'></cfsavecontent>
								<div class="col col-4 col-sm-12">
									<cfif listfind(liste,get_cv_unit.unit_id,',')>
										<cfinput type="text" name="unit#get_cv_unit.unit_id#" value="#ListGetAt(liste_row,listfind(liste,get_cv_unit.unit_id,','),',')#" validate="integer" maxlength="1" range="1,9" onchange="seviye_kontrol(this)" message="#messages#">
									<cfelse>
										<cfinput type="text" name="unit#get_cv_unit.unit_id#" value="" validate="integer" maxlength="1" range="1,9" onchange="seviye_kontrol(this)" message="#messages#">
									</cfif>
								</div>
							</div>  
						</cfoutput>
					<cfelse>
						<b><cf_get_lang dictionary_id='31702.Sisteme kayitli birim yok'>.</b>
					</cfif>
				</div>
			</cf_box_elements>
		<cf_seperator id="working_cities" header="#getLang('','Çalışmak istediğiniz şehir',31703)#" is_closed="1">
			<cf_box_elements id="working_cities" style="display:none;">
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57971.Şehir'></label>
						<div class="col col-8 col-sm-12">
							<select name="prefered_city" id="prefered_city" multiple>
								<option value="" <cfif listfind(get_my_profile.prefered_city,'',',') or not len(get_my_profile.prefered_city)>selected</cfif>><cf_get_lang dictionary_id='31704.TÜM TÜRKIYE'></option>
								<cfoutput query="get_city">
									<option value="#city_id#" <cfif listfind(get_my_profile.prefered_city,city_id,',')>selected</cfif>>#city_name#
									</option>
								</cfoutput>
							</select>
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31705.Seyahat Edebilir misiniz'></label>
						<div class="col col-4 col-sm-12">
							<input type="radio" name="IS_TRIP" id="IS_TRIP" value="1" <cfif get_my_profile.IS_TRIP IS 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'>
						</div>                
						<div class="col col-4 col-sm-12">
							<input type="radio" name="IS_TRIP" id="IS_TRIP" value="0" <cfif get_my_profile.IS_TRIP IS 0 OR get_my_profile.IS_TRIP IS "">checked</cfif>><cf_get_lang dictionary_id='57496.Hayir'>
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31706.Istenilen Ücret (Net)'></label>
						<div class="col col-6 col-sm-12">
							<cfinput type="text" name="expected_price"  value="#TLFormat(get_my_profile.expected_price)#" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
						</div>                
						<div class="col col-2 col-sm-12">
							<select name="EXPECTED_MONEY_TYPE" id="EXPECTED_MONEY_TYPE" class="formselect">
								<cfquery name="GET_MONEY" datasource="#dsn#">
									SELECT
										*
									FROM
										SETUP_MONEY
									WHERE
										PERIOD_ID = #SESSION.EP.PERIOD_ID#
								</cfquery>
								<cfoutput query="get_money">
									<option value="#MONEY#"<cfif money is get_my_profile.expected_money_type> selected</cfif>>#MONEY#</option>
								</cfoutput>
							</select>
						</div>                
					</div> 
				</div>
			</cf_box_elements>
		<cf_seperator id="applicant_notes" header="#getLang('','Eklemek istedikleriniz',31707)#" is_closed="1">
			<cf_box_elements id="applicant_notes" style="display:none;">
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_stage">
						<div class="col col-12 col-sm-12">
							<textarea name="applicant_notes" id="applicant_notes" maxlength="300" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"  style="width:600px;height:100px;"><cfoutput>#get_my_profile.APPLICANT_NOTES#</cfoutput></textarea>
						</div>                
					</div>
				</div>
			</cf_box_elements> 
		<cf_seperator id="ozgecmis_metni" header="#getLang('','Özgeçmiş Metni',63037)#" is_closed="1">
				<cf_box_elements id="ozgecmis_metni" style="display:none;">
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
						<cfmodule
							template="/fckeditor/fckeditor.cfm"
							toolbarSet="WRKContent"
							basePath="/fckeditor/"
							instanceName="resume_text"
							valign="top"
							value="#get_my_profile.resume_text#"
							width="100%"
							height="100">
					</div>
				</cf_box_elements> 
				<cf_box_footer>
					<cf_record_info query_name="get_my_profile">
					<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
				</cf_box_footer>
				<!--- <!---Fotoğraf--->
				<cfsavecontent variable="foto"><cf_get_lang dictionary_id ='738.Fotoğraf'></cfsavecontent>	
				<cf_box id="get_photo_box"
					box_page="#request.self#?fuseaction=hr.emptypopup_hr_photo_ajax&empapp_id=#get_my_profile.empapp_id#"
					title="#foto#"
					closable="0"
					unload_body="1">
					</cf_box>
				<!---Yazışmalar--->
				<cfsavecontent variable="yaz"><cf_get_lang dictionary_id ='47.Yazışmalar'></cfsavecontent>
				<cf_box 
					id="get_corresp_box" 
					box_page="#request.self#?fuseaction=hr.emptypopup_hr_correspon_ajax&empapp_id=#get_my_profile.empapp_id#"
					title="#yaz#"
					add_href="#request.self#?fuseaction=hr.popup_app_add_mail&empapp_id=#get_my_profile.empapp_id#"
					closable="0"
					unload_body="1">
					</cf_box>
				<cf_get_workcube_asset module_id=3 asset_cat_id="-8" action_section='EMPLOYEES_APP_ID' action_id='#get_my_profile.empapp_id#'> --->
	</cf_box>
</cfform>
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
<br/>
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
	/*yakınlar için*/
	<cfif get_relatives.recordcount gt 0>
		rowCount = <cfoutput>#get_relatives.recordcount#</cfoutput>;
		//document.getElementById('rowCount').value = rowCount_;
	<cfelse>
		rowCount=0;
	</cfif>
function relative_sil(sv)
	{
		var my_element=document.getElementById("rowCount"+sv);
		my_element.value=0;
		var my_element = document.getElementById('frm_row'+sv);
		my_element.style.display="none";
		satir_say--;
/*		alan=document.getElementById('relative_sil'+satir);
		alan.value=1;
		alan = document.getElementById('name_relative'+satir);
		alan.value="";
		alan = document.getElementById('surname_relative'+satir);
		alan.value="";
*/	}

function hepsini_gizle(id)
{
	//document.getElementById('handle_orta_box').innerHTML = id;
	for(var i=0;i<10;i++)
	{
		document.getElementById('gizli'+i).style.display='none';
	}
	
}
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

row_count=<cfoutput>#get_work_info.recordcount#</cfoutput>;
satir_say=0;

function sil(sy)
{
	var my_element= document.getElementById('row_kontrol'+sy);
	my_element.value=0;
	var my_element = document.getElementById('frm_row'+sy);
	my_element.style.display = "none";
	satir_say--;
}
var add_im_info=<cfif isdefined("get_ims")><cfoutput>#get_ims.recordcount#</cfoutput><cfelse>0</cfif>;
	function del_im(dell){
			var my_emement1=eval("employe_detail.del_im_info"+dell);
			my_emement1.value=0;
			var my_element1=eval("im_info_"+dell);
			my_element1.style.display="none";
	}
	function add_im_info_(){
		add_im_info++;
		employe_detail.add_im_info.value=add_im_info;
		var newRow;
		var newCell;
		newRow = document.getElementById("im_info").insertRow(document.getElementById("im_info").rows.length);
		newRow.setAttribute("name","im_info_" + add_im_info);
		newRow.setAttribute("id","im_info_" + add_im_info);
		document.employe_detail.instant_info.value=add_im_info;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="hidden" value="1" name="del_im_info'+ add_im_info +'"><a onclick="del_im(' + add_im_info + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id ="57463.sil">"></div></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="imcat_id' + add_im_info +'"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option><cfoutput query="im_cats"><option value="#imcat_id#">#imcat#</option></cfoutput>/select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<div class="form-group"><input type="text" name="im' + add_im_info +'"></div>';
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
	var form = $('form[name = form_work_info]');
	openBoxDraggable(decodeURIComponent('<cfoutput>#request.self#?fuseaction=myhome.popup_upd_work_info&my_count='+count+'&control=1</cfoutput>&'+form.serialize()).replaceAll("+", " "));
	/*windowopen('','medium','kariyer_pop');
	form_work_info.target='kariyer_pop';
	form_work_info.action = '<cfoutput>#request.self#?fuseaction=myhome.popup_upd_work_info&my_count='+count+'&control=1</cfoutput>';
	form_work_info.submit();	*/
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
			/*if(get_emp_cv_new.recordcount)*/
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
		employe_detail.row_kontrol.value = row_count;
		employe_detail.row_count.value = row_count;
		satir_say++;
		var new_Row;
		var new_Cell;
		new_Row = document.getElementById("table_work_info").insertRow(document.getElementById("table_work_info").rows.length);
		new_Row.setAttribute("name","frm_row" + row_count);
		new_Row.setAttribute("id","frm_row" + row_count);		
		new_Row.setAttribute("NAME","frm_row" + row_count);
		new_Row.setAttribute("ID","frm_row" + row_count);	
		
		new_Cell = new_Row.insertCell(new_Row.cells.length);
		new_Cell.innerHTML = '<input  type="hidden" value="1" id="row_kontrol' + row_count +'" name="row_kontrol' + row_count +'"><a href="javascript://" onclick="sil(' + row_count + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id ="57463.sil">"></i></a>';
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
			var get_emp_cv =  wrk_safe_query('hr_get_emp_cv_new','dsn',0,exp_sector_cat);
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
		new_Cell.innerHTML = '<a href="javascript://" onClick="gonder_upd('+row_count+');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='31694.Is Tecrübesi Güncelle'>"></i></a>';
	}
}

row_edu=<cfoutput>#get_edu_info.recordcount#</cfoutput>;
satir_say_edu=0;

function sil_edu(sv)
{
	var my_element_edu=eval("employe_detail.row_kontrol_edu"+sv);
	my_element_edu.value=0;
	var my_element_edu=eval("frm_row_edu"+sv);
	my_element_edu.style.display="none";
	satir_say_edu--;
}

function gonder_upd_edu(count_new)
{
	edu_type_ = eval("employe_detail.edu_type"+count_new).value;
	form_edu_info.edu_type_new.value = edu_type_.split(';')[0]; //Okul Türü
	if(form_edu_info.edu_type != undefined){
		form_edu_info.edu_type.value = edu_type_.split(';')[0];
	}
	if(employe_detail.edu_type != undefined){
		form_edu_info.edu_type_new.value = eval("employe_detail.edu_type"+count_new).value;//Okul Türü
	}
	if(eval("employe_detail.edu_id"+count_new) != undefined && eval("employe_detail.edu_id"+count_new).value != '')//egerki okul listeden seçiliyorsa seçilen okulun id si
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
	/* openBoxDraggable(decodeURIComponent('<cfoutput>#request.self#?fuseaction=myhome.popup_add_edu_info&count_edu='+count_new+'&ctrl_edu=1</cfoutput>&'+form.serialize()).replaceAll("+", " ")); */
	/*windowopen('','medium','kryr_pop');
	form_edu_info.target='kryr_pop';
	form_edu_info.submit();	*/
}

function gonder_edu(edu_type,ctrl_edu,count_edu,edu_id,edu_name,edu_start,edu_finish,edu_rank,edu_high_part_id,edu_part_id,edu_part_name,education_time,edu_lang,edu_lang_rate,is_edu_continue)
{
	var edu_type = edu_type.split(';')[0];
	if(ctrl_edu == 1)
	{
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
			var edu_name_degisken = edu_name;
			eval("employe_detail.edu_name"+count_edu).value=edu_name_degisken;
		}

		eval("employe_detail.edu_start"+count_edu).value=edu_start;
		eval("employe_detail.edu_finish"+count_edu).value=edu_finish;
		eval("employe_detail.edu_rank"+count_edu).value=edu_rank;
		if(eval("employe_detail.edu_high_part_id"+count_edu) != undefined && eval("employe_detail.edu_high_part_id"+count_edu).value != '' && edu_high_part_id != -1)
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
		new_Row_Edu.setAttribute("name","frm_row_edu" + row_edu);
		new_Row_Edu.setAttribute("id","frm_row_edu" + row_edu);		
		new_Row_Edu.setAttribute("NAME","frm_row_edu" + row_edu);
		new_Row_Edu.setAttribute("ID","frm_row_edu" + row_edu);
		
		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML = '<input  type="hidden" value="1" name="row_kontrol_edu' + row_edu +'" ><a href="javascript://" onclick="sil_edu(' + row_edu + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id ="57463.sil">"></i></a>';
		new_Cell_Edu.innerHTML += '<input type="hidden" name="edu_id' + row_edu + '" value="'+ edu_id +'">';
		new_Cell_Edu.innerHTML += '<input type="hidden" name="edu_high_part_id' + row_edu + '" value="'+ edu_high_part_id +'">';
		new_Cell_Edu.innerHTML += '<input type="hidden" name="edu_part_id' + row_edu + '" value="'+ edu_part_id +'">';
		new_Cell_Edu.innerHTML += '<input type="hidden" name="is_edu_continue' + row_edu + '" value="'+ is_edu_continue +'">';
		new_Cell_Edu.innerHTML += '<input type="hidden" id="education_time' + row_edu + '" name="education_time' + row_edu + '" value="'+ education_time +'">';
		new_Cell_Edu.innerHTML += '<input type="hidden" id="edu_lang' + row_edu + '" name="edu_lang' + row_edu + '" value="'+ edu_lang +'">';
		new_Cell_Edu.innerHTML += '<input type="hidden" id="edu_lang_rate' + row_edu + '" name="edu_lang_rate' + row_edu + '" value="'+ edu_lang_rate +'">';
		if(edu_type != undefined && edu_type != '')
		{
			var get_edu_part_name_sql = wrk_safe_query('hr_get_edu_part_name','dsn',0,edu_type);
			if(get_edu_part_name_sql.recordcount)
				var edu_type_name = get_edu_part_name_sql.EDUCATION_NAME;
		}	
		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML = '<input type="hidden" id="edu_type' + row_edu + '" name="edu_type' + row_edu + '" value="'+ edu_type +'"><input type="text" name="edu_type_name' + row_edu + '" value="'+ edu_type_name +'" class="boxtext" readonly>';
		if(edu_id != '' && edu_id != -1)
		{
			var get_cv_edu_new = wrk_safe_query('hr_get_cv_edu_new','dsn',0,edu_id);
			if(get_cv_edu_new.recordcount)
				var edu_name_degisken = get_cv_edu_new.SCHOOL_NAME;
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input type="text" name="edu_name' + row_edu + '" value="'+ edu_name_degisken +'" class="boxtext" readonly>';
		}
		else
		{
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input type="text" name="edu_name' + row_edu + '" value="'+ edu_name +'" class="boxtext" readonly>';
		}
		new_Cell_Edu.innerHTML += '<input type="hidden" name="gizli' + row_edu + '" value="" class="boxtext" readonly>';
		
		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML = '<input type="text" name="edu_start' + row_edu + '" value="'+ edu_start +'" class="boxtext" readonly>';
		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML = '<input type="text" name="edu_finish' + row_edu + '" value="'+ edu_finish +'" class="boxtext" readonly>';
		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML = '<input type="text" name="edu_rank' + row_edu + '" value="'+ edu_rank +'" class="boxtext" readonly>';
		if(edu_high_part_id != undefined && edu_high_part_id != '' && edu_high_part_id != -1)
		{
			var get_cv_edu_high_part_id = wrk_safe_query('hr_cv_edu_high_part_id_q','dsn',0,edu_high_part_id);
			if(get_cv_edu_high_part_id.recordcount)
			var edu_part_name_degisken = get_cv_edu_high_part_id.HIGH_PART_NAME;
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input type="text" name="edu_part_name' + row_edu + '" value="'+ edu_part_name_degisken +'" class="boxtext" readonly>';
		}
		else if(edu_part_id != undefined && edu_part_id != '' && edu_part_id != -1)
		{
			var get_cv_edu_part_id = wrk_safe_query('hr_cv_edu_part_id_q','dsn',0,edu_part_id);
			if(get_cv_edu_part_id.recordcount)
				var edu_part_name_degisken = get_cv_edu_part_id.PART_NAME;
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input type="text" name="edu_part_name' + row_edu + '" value="'+ edu_part_name_degisken +'" class="boxtext" readonly>';
		}
		else
		{
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input type="text" name="edu_part_name' + row_edu + '" value="'+ edu_part_name +'" class="boxtext" readonly>';
		}
		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML ='<a href="javascript://" onClick="gonder_upd_edu('+row_edu+');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='31721.Eğitim Bilgisi Güncelle'>"></i></a>';
	}
}
	/* Dil Bilgileri */
	var add_lang_info=<cfif isdefined("get_emp_language")><cfoutput>#get_emp_language.recordcount#</cfoutput><cfelse>0</cfif>;
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

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="hidden" value="1" name="del_lang_info'+ add_lang_info +'"><a onclick="del_lang(' + add_lang_info + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id ="57463.sil">"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="lang' + add_lang_info +'"><option value=""><cf_get_lang dictionary_id="58996.Dil"></option><cfoutput query="get_languages"><option value="#language_id#">#language_set#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="lang_speak' + add_lang_info +'"><cfoutput query="know_levels"><option value="#knowlevel_id#">#knowlevel#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="lang_mean' + add_lang_info +'"><cfoutput query="know_levels"><option value="#knowlevel_id#">#knowlevel#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="lang_write' + add_lang_info +'"><cfoutput query="know_levels"><option value="#knowlevel_id#">#knowlevel#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="lang_where' + add_lang_info + '" value="">';
	}
	/*Referans Bilgileri*/
	var add_ref_info=<cfif isdefined("get_emp_reference")><cfoutput>#get_emp_reference.recordcount#</cfoutput><cfelse>0</cfif>;
	function del_ref(dell){
			var my_emement1=eval("employe_detail.del_ref_info"+dell);
			my_emement1.value=0;
			var my_element1=eval("ref_info_"+dell);
			my_element1.style.display="none";
	}
	function add_ref_info_(){
		add_ref_info++;
		employe_detail.add_ref_info.value=add_ref_info;
		var newRow;
		var newCell;
		newRow = document.getElementById("ref_info").insertRow(document.getElementById("ref_info").rows.length);
		newRow.setAttribute("name","ref_info_" + add_ref_info);
		newRow.setAttribute("id","ref_info_" + add_ref_info);
		document.employe_detail.referance_info.value=add_ref_info;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="hidden" value="1" name="del_ref_info'+ add_ref_info +'"><a onclick="del_ref(' + add_ref_info + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id ="57463.sil">"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="ref_type' + add_ref_info +'"><option value=""><cf_get_lang dictionary_id='31063.Referans Tipi'></option><cfoutput query="get_reference_type"><option value="#reference_type_id#">#reference_type#</option></cfoutput></select></div>';
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
	
	
</script>				
