<div class="row">
	<div class="col col-12 uniqueRow" id="content">
		<div class="portBox portBottom">
			<div class="portHeadLight font-green-sharp">
				<span><cf_get_lang no='4.Kullanıcı Bilgileri'></span>
			</div>
			<div class="portBoxBodyStandart">
				<div class="col col-12 uniqueRow">
					<div class="row formContent">
						<div class="row" type="row">
							<!--- col 1 --->
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
								<div class="form-group" id="item-online">
									<label class="col col-4 col-xs-12">Online</label>
									<div class="col col-8 col-xs-12">
										<cf_online id="#getPartner.partner_id#" zone="pp">
									</div>
								</div>
								<div class="form-group" id="item-birthdate">
									<label class="col col-4 col-xs-12"><cf_get_lang_main no='1315.Doğum Tarihi'></label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<cfinput type="text" name="birthdate" id="birthdate" maxlength="10" value="#DateFormat(getPartner.birthdate,'dd/mm/yyyy')#" validate="eurodate" style="width:65px;" tabindex="5">
											<div class="input-group-addon">
												<cf_wrk_date_image date_field="birthdate">
											</div>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-department">
									<label class="col col-4 col-xs-12"><cf_get_lang_main no='160.Departman'></label>
									<div class="col col-8 col-xs-12">
										<select name="department" id="department" style="width:150px;">
											<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
											<cfoutput query="getPartnerDepartments">
												<option value="#partner_department_id#" <cfif getPartner.department eq partner_department_id>selected</cfif>>#partner_department#</option>
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group" id="item-photo">
									<label class="col col-4 col-xs-12"><cf_get_lang no='125.Fotoğraf Ekle'></label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<input type="file" name="photo" id="photo" style="width:150px;" />
											<div class="input-group-addon">
												Sil
											</div>
											<div class="input-group-addon">
												<input  type="Checkbox" name="del_photo" id="del_photo" value="1">
											</div>
										</div>
									</div>
								</div>
							</div>
							<!--- col 2 --->
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
								<div class="form-group" id="item-nameless">
									<label class="col col-4 col-xs-12"><cf_get_lang_main no='219.Ad'>*</label>
									<div class="col col-8 col-xs-12">
										<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='219.Ad'></cfsavecontent>
										<cfinput type="text" name="nameless" id="nameless" required="yes" value="#getPartner.company_partner_name#" message="#message#" maxlength="20" style="width:150px;">										
									</div>
								</div>
								<div class="form-group" id="item-sex">
									<label class="col col-4 col-xs-12"><cf_get_lang_main no='352.Cinsiyet'></label>
									<div class="col col-8 col-xs-12">
										<select name="sex" id="sex" style="width:150px;">
											<option value="1" <cfif getPartner.sex eq 1> selected</cfif>><cf_get_lang_main no='1547.Erkek'>
											<option value="2" <cfif getPartner.sex eq 2> selected</cfif>><cf_get_lang_main no='1546.Kadın'>
										</select>
									</div>
									<div class="form-group">
										<label class="col col-4 col-xs-12"><cf_get_lang_main no='139.Kullanıcı Ad'></label>
										<div class="col col-8 col-xs-12">
											<cfinput  type="text" name="username" id="username" value="#getPartner.company_partner_username#" style="width:150px;">
										</div>
									</div>
								</div>
							</div>
							<!--- col 3 --->
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
								<div class="form-group" id="item-soyad">
									<label class="col col-4 col-xs-12"><cf_get_lang_main no='1314.Soyad'>*</label>
									<div class="col col-8 col-xs-12">
										<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1314.Soyad'></cfsavecontent>
										<cfinput type="text" name="soyad" id="soyad" required="yes" value="#getPartner.company_partner_surname#" message="#message#" maxlength="20" style="width:150px;">
									</div>
								</div>
								<div class="form-group" id="item-title">
									<label class="col col-4 col-xs-12"><cf_get_lang_main no='159.Ünvan'></label>
									<div class="col col-8 col-xs-12">
										<input type="text" name="title" id="title" value="<cfoutput>#getPartner.title#</cfoutput>" maxlength="50" style="width:150px;">
									</div>
								</div>
								<div class="form-group">
									<label class="col col-4 col-xs-12"><cf_get_lang_main no='140.Şifre'></label>
									<div class="col col-8 col-xs-12">
										<cfinput type="Password" name="password" id="password" style="width:150px;" maxlength="16">
									</div>
								</div>
							</div>
							<!--- col 4 --->
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
								<div class="form-group" id="item-tc_identity">
									<label class="col col-4 col-xs-12"><cf_get_lang_main no='613.TC Kimlik No'><cfif is_tc_number eq 1> *</cfif></label>
									<div class="col col-8 col-xs-12">
										<cf_wrkTcNumber fieldId="tc_identity" tc_identity_required="#is_tc_number#" width_info='150' is_verify='0' consumer_name='name' consumer_surname='soyad' birth_date='birthdate' tc_identity_number='#getPartner.TC_IDENTITY#'>
									</div>
								</div>
								<div class="form-group" id="item-mission">
									<label class="col col-4 col-xs-12"><cf_get_lang_main no='161.Görev'></label>
									<div class="col col-8 col-xs-12">
										<select name="mission" id="mission" style="width:150px;">
											<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
											<cfoutput query="getPartnerPositions">
												<option value="#partner_position_id#" <cfif getPartner.mission eq partner_position_id>selected</cfif>>#partner_position#</option>
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group" id="item-language_id">
									<label class="col col-4 col-xs-12"><cf_get_lang_main no='1584.Dil'>*</label>
									<div class="col col-8 col-xs-12">
										<select name="language_id" id="language_id" style="width:150px;">
											<cfoutput query="getLanguage">
												<option value="#language_short#" <cfif getPartner.language_id eq language_short> selected</cfif>>#language_set#</option>
											</cfoutput>
										</select>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="portBox portBottom">
			<div class="portHeadLight font-green-sharp">
				<span><cf_get_lang_main no="731.İletişim"></span>
			</div>
			<div class="portBoxBodyStandart">
				<div class="col col-12 uniqueRow">
					<div class="row formContent">
						<div class="row" type="row">
							<!--- col 5 --->
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="5" sort="true">
								<div class="form-group" id="item-compbranch_id">
									<label class="col col-4 col-xs-12"><cf_get_lang_main no='41.Şube'></label>
									<div class="col col-8 col-xs-12">
										<select name="compbranch_id" id="compbranch_id" style="width:150px;" onChange="kontrol_et(this.value);">
											<option value="0"><cf_get_lang no='181.Merkez Ofis'> 
											<cfoutput query="getCompanyBranch">
												<option value="#compbranch_id#"<cfif getPartner.compbranch_id eq compbranch_id> selected</cfif>>#compbranch__name#</option>
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group" id="item-mobiltel">
									<label class="col col-4 col-xs-12"><cf_get_lang no='116.Kod /Mobil Tel'></label>
									<div class="col col-3 col-xs-5">
										<input maxlength="5" type="text" name="mobilcat_id" id="mobilcat_id" onKeyup="isNumber(this);" onblur="isNumber(this);" value="<cfoutput>#getPartner.mobil_code#</cfoutput>" style="width:60px;">
									</div>
									<div class="col col-5 col-xs-7">
										<cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no='116.gsm No !'></cfsavecontent>
										<cfinput type="text" name="mobiltel" id="mobiltel" value="#getPartner.mobiltel#" validate="integer" message="#message#" maxlength="10" style="width:86px;">
									</div>
								</div>
								<div class="form-group" id="item-want_sms">
									<label class="col col-4 col-xs-12"><cf_get_lang no="180.SMS Almak İstiyorum"></label>
									<div class="col col-8 col-xs-12">
										<input type="checkbox" name="want_sms" id="want_sms" value="1" <cfif getPartner.want_sms eq 1> checked</cfif>>
									</div>
								</div>
							</div>
							<!--- col 6 --->
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="6" sort="true">
								<div class="form-group" id="item-email">
									<label class="col col-4 col-xs-12"><cf_get_lang_main no='16.e-mail'></label>
									<div class="col col-8 col-xs-12">
										<cfsavecontent variable="mesaj"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='16.E-mail'></cfsavecontent>
										<cfinput type="text" name="email" id="email" value="#getPartner.company_partner_email#" maxlength="100" validate="email" message="#mesaj#" style="width:150px;">
									</div>
								</div>
								<div class="form-group" id="item-fax">
									<label class="col col-4 col-xs-12"><cf_get_lang_main no='76.Fax'></label>
									<div class="col col-8 col-xs-12">
										<cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no='107.Fax No !'></cfsavecontent>
										<cfinput type="text" name="fax" id="fax" value="#getPartner.company_partner_fax#" validate="integer" message="#message#" maxlength="10" style="width:86px;">
									</div>
								</div>

							</div>
							<!--- col 7 --->
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="7" sort="true">
								<div class="form-group" id="item-tel">
									<cfif Len(getPartner.country)>
										<cfquery name="get_country_phone" dbtype="query">
											SELECT COUNTRY_PHONE_CODE FROM GETCOUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartner.country#">
										</cfquery>
									</cfif>
									<label class="col col-4 col-xs-12"><cf_get_lang_main no='87.Telefon'> <label id="load_phone"><cfif Len(getPartner.country) and len(get_country_phone.country_phone_code)>(<cfoutput>#get_country_phone.country_phone_code#</cfoutput>)</cfif></label></label>
									<div class="col col-3 col-xs-5">
										<cfsavecontent variable="message"><cf_get_lang no='178.Geçerli Bir Telefon kodu Giriniz !'></cfsavecontent>
										<cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='87.telefon'></cfsavecontent>
										<cfinput type="text" name="telcod" id="telcod" value="#getPartner.company_partner_telcode#" validate="integer" message="#message#" maxlength="5" style="width:60px;">
									</div>
									<div class="col col-5 col-xs-7">
										<cfinput type="text" name="tel" id="tel" value="#getPartner.company_partner_tel#" validate="integer" message="#message#" maxlength="10" style="width:86px;">
									</div>
								</div>
								<div class="form-group">
									<label class="col col-4 col-xs-12"><cf_get_lang no='41.İnternet'></label>
									<div class="col col-8 col-xs-12">
										<input type="text" name="homepage" id="homepage" value="<cfoutput>#getPartner.homepage#</cfoutput>" maxlength="50" style="width:150px;">
									</div>
								</div>
							</div>
							<!--- col 8 --->
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="8" sort="true">
								<div class="form-group" id="item-tel_local">
									<label class="col col-4 col-xs-12"><cf_get_lang no='121.Dahili'></label>
									<div class="col col-8 col-xs-12">
										<cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no='121.dahili !'></cfsavecontent>
										<cfinput type="text" name="tel_local" id="tel_local" value="#getPartner.company_partner_tel_ext#" validate="integer" message="#message#" maxlength="5" style="width:86px;">
									</div>
								</div>
								<div class="form-group" id="item-want_email">
									<label class="col col-4 col-xs-12"><cf_get_lang no="429.Mail Almak İstiyorum"></label>
									<div class="col col-8 col-xs-12">
										<input type="checkbox" name="want_email" id="want_email" value="1" <cfif getPartner.want_email eq 1> checked</cfif>>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="portBox portBottom">
			<div class="portHeadLight font-green-sharp">
				<span><cf_get_lang_main no='1311.Adres'></span>
			</div>
			<div class="portBoxBodyStandart">
				<div class="col col-12 uniqueRow">
					<div class="row formContent">
						<div class="row" type="row">
							<!--- col 9 --->
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="9" sort="true">
								<div class="form-group" id="item-country">
									<label class="col col-4 col-xs-12"><cf_get_lang_main no='807.Ülke'></label>
									<div class="col col-8 col-xs-12">
										<select name="country" id="country" style="width:150px;" onChange="LoadCity(this.value,'city_id','county_id',0)">
											<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
											<cfoutput query="getCountry">
												<option value="#country_id#" <cfif getPartner.country eq country_id>selected</cfif>>#country_name#</option>
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-4 col-xs-12"><cf_get_lang_main no='60.Posta Kodu'></label>
									<div class="col col-8 col-xs-12">
										<input type="text" name="postcod" id="postcod" style="width:150px;" maxlength="15" value="<cfoutput>#getPartner.company_partner_postcode#</cfoutput>">
									</div>
								</div>
							</div>
							<!--- col 10 --->
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="10" sort="true">
								<div class="form-group" id="item-city_id">
									<label class="col col-4 col-xs-12"><cf_get_lang_main no='559.Şehir'></label>
									<div class="col col-8 col-xs-12">
										<select name="city_id" id="city_id" style="width:150px;" onChange="LoadCounty(this.value,'county_id','company_partner_telcode')">
											<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
											<cfquery name="GET_CITY" datasource="#DSN#">
												SELECT CITY_ID,CITY_NAME FROM SETUP_CITY <cfif len(getPartner.country)>WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartner.country#"></cfif>
											</cfquery>
											<cfoutput query="GET_CITY">
												<option value="#city_id#" <cfif getPartner.city eq city_id>selected</cfif>>#city_name#</option>
											</cfoutput>
										</select>
									</div>
								</div>
							</div>
							<!--- col 11 --->
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="11" sort="true">
								<div class="form-group" id="item-county_id">
									<label class="col col-4 col-xs-12"><cf_get_lang_main no='1226.Ilce'></label>
									<div class="col col-8 col-xs-12">
										<cfquery name="GET_COUNTY" datasource="#DSN#">
											SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY <cfif len(getPartner.city)>WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartner.city#"></cfif>
										</cfquery>
										<select name="county_id" id="county_id" style="width:150px;">
											<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
											<cfquery name="GET_COUNTY" datasource="#DSN#">
												SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY <cfif len(getPartner.city)>WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartner.city#"></cfif>
											</cfquery>
											<cfoutput query="get_county">
												<option value="#county_id#" <cfif getPartner.county eq county_id>selected</cfif>>#county_name#</option>
											</cfoutput>
										</select> 
									</div>
								</div>	
							</div>
							<!--- col 12 --->
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="12" sort="true">
								<div class="form-group" id="item-semt">
									<label class="col col-4 col-xs-12"><cf_get_lang_main no='720.Semt'></label>
									<div class="col col-8 col-xs-12">
										<input type="text" name="semt" id="semt" value="<cfoutput>#getPartner.semt#</cfoutput>" maxlength="45" style="width:150px;">
									</div>
								</div>
							</div>
						</div>
						<div class="row" type="row">
							<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="13" sort="true">
								<div class="form-group" id="item-adres">
									<label class="col col-2 col-xs-12"><cf_get_lang_main no='1311.Adres'></label>
									<div class="col col-10 col-xs-12">
										<textarea name="adres" id="adres" style="width:150px;height:65px;"><cfoutput>#getPartner.company_partner_address#</cfoutput></textarea>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col col-12 uniqueRow">
				<div class="row formContent">
					<div class="row" type="row">
						<div class="col col-6 col-xs-12" type="column" index="14" sort="true">
							<div class="form-group">
								<div class="col col-12">
									<cfoutput>
										<cf_get_lang_main no='71.Kayıt'> : 
										<cfif len(getPartner.record_member)> #get_emp_info(getPartner.record_member,0,0)# - </cfif>
										<cfif len(getPartner.record_par)>#get_par_info(getPartner.record_par,0,-1,0)# - </cfif>
										#dateformat(date_add('h',session.ep.time_zone,getPartner.record_date),"dd/mm/yyyy")# (#timeformat(date_add('h',session.ep.time_zone,getPartner.record_date),"HH:MM")#) &nbsp;
										<cfif len(getPartner.record_ip)> - #getPartner.record_ip#&nbsp;&nbsp;&nbsp;</cfif>
										<br/>
										<cfif len(getPartner.update_member)>
											<cf_get_lang_main no='291.Son Güncelleme'>: #get_emp_info(getPartner.update_member,0,0)# - 
											#dateformat(date_add('h',session.ep.time_zone,getPartner.update_date),"dd/mm/yyyy")# (#timeformat(date_add('h',session.ep.time_zone,getPartner.update_date),"HH:MM")#)
										</cfif>
										<cfif len(getPartner.update_ip)> - #getPartner.update_ip#</cfif>
									</cfoutput>
								</div>
							</div>
						</div>
						<div class="col col-6 col-xs-12" type="column" index="15" sort="true">
							<div class="form-group">
								<div class="col col-12">
									<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
