<cf_box id="upd_partner_1" closable="0" collapsable="0">
	<table>
		<tr>
			<td class="txtboldblue" colspan="4" height="20"><cf_get_lang no='4.Kullanıcı Bilgileri'></td>
		</tr>
		<tr>
			<td></td>
			<td><cf_online id="#getPartner.partner_id#" zone="pp"></td>
			<td><cf_get_lang_main no='81.Aktif'></td>
			<td><input type="checkbox" name="company_partner_status" id="company_partner_status" <cfif getPartner.company_partner_status eq 1>checked</cfif>></td>
		</tr>
		<tr>
			<td style="width:100px;"><cf_get_lang_main no='219.Ad'>*</td>
			<td style="width:175px;">
				<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='219.Ad'></cfsavecontent>
				<cfinput type="text" name="name" id="name" required="yes" value="#getPartner.company_partner_name#" message="#message#" maxlength="20" style="width:150px;">
			</td>
			<td width="80"><cf_get_lang_main no='1314.Soyad'>*</td>
			<td>
				<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1314.Soyad'></cfsavecontent>
				<cfinput type="text" name="soyad" id="soyad" required="yes" value="#getPartner.company_partner_surname#" message="#message#" maxlength="20" style="width:150px;">
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='613.TC Kimlik No'><cfif is_tc_number eq 1> *</cfif></td>
			<td><cf_wrkTcNumber fieldId="tc_identity" tc_identity_required="#is_tc_number#" width_info='150' is_verify='0' consumer_name='name' consumer_surname='soyad' birth_date='birthdate' tc_identity_number='#getPartner.TC_IDENTITY#'></td>
			<td><cf_get_lang_main no='1315.Doğum Tarihi'></td>
			<td><cfinput type="text" name="birthdate" id="birthdate" maxlength="10" value="#DateFormat(getPartner.birthdate,dateformat_style)#" validate="#validate_style#" style="width:65px;" tabindex="5">
				<cf_wrk_date_image date_field="birthdate">
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='352.Cinsiyet'></td>
			<td>
				<select name="sex" id="sex" style="width:150px;">
					<option value="1" <cfif getPartner.sex eq 1> selected</cfif>><cf_get_lang_main no='1547.Erkek'>
					<option value="2" <cfif getPartner.sex eq 2> selected</cfif>><cf_get_lang_main no='1546.Kadın'>
				</select>
			</td>
			<td><cf_get_lang_main no='159.Ünvan'></td>
			<td><input type="text" name="title" id="title" value="<cfoutput>#getPartner.title#</cfoutput>" maxlength="50" style="width:150px;"></td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='161.Görev'></td>
			<td>
				<select name="mission" id="mission" style="width:150px;">
					<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
						<cfoutput query="getPartnerPositions">
							<option value="#partner_position_id#" <cfif getPartner.mission eq partner_position_id>selected</cfif>>#partner_position#</option>
						</cfoutput>
				</select>
			</td>
			<td><cf_get_lang_main no='160.Departman'></td>
			<td>
				<select name="department" id="department" style="width:150px;">
					<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
						<cfoutput query="getPartnerDepartments">
							<option value="#partner_department_id#" <cfif getPartner.department eq partner_department_id>selected</cfif>>#partner_department#</option>
						</cfoutput>
				</select>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='139.Kullanıcı Ad'></td>
			<td><cfinput  type="text" name="username" id="username" value="#getPartner.company_partner_username#" style="width:150px;"></td>
			<td><cf_get_lang_main no='140.Şifre'></td>
			<td><cfinput type="Password" name="password" id="password" style="width:150px;" maxlength="16"></td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='1584.Dil'>*</td>
			<td><select name="language_id" id="language_id" style="width:150px;">
					<cfoutput query="getLanguage">
						<option value="#language_short#" <cfif getPartner.language_id eq language_short> selected</cfif>>#language_set#</option>
					</cfoutput>
				</select>
			</td>
			<td><cf_get_lang no='125.Fotoğraf Ekle'></td>
			<td><input type="file" name="photo" id="photo" style="width:150px;" />
				&nbsp;<cf_get_lang no='136.Fotoğrafı Sil'>&nbsp;<input  type="Checkbox" name="del_photo" id="del_photo" value="1">
			</td>
		</tr>
	</table>
</cf_box>
<cf_box id="upd_partner_2" closable="0" collapsable="0">
	<table>
		<tr>
			<td class="txtboldblue" colspan="4" height="20"><cf_get_lang_main no="731.İletişim"></td>
		</tr>
		<tr> 
			<td width="100" valign="baseline"><cf_get_lang_main no='41.Şube'></td>
			<td width="175" valign="baseline">
				<select name="compbranch_id" id="compbranch_id" style="width:150px;" onChange="kontrol_et(this.value);">
					<option value="0"><cf_get_lang no='181.Merkez Ofis'> 
					<cfoutput query="getCompanyBranch">
						<option value="#compbranch_id#"<cfif getPartner.compbranch_id eq compbranch_id> selected</cfif>>#compbranch__name#</option>
					</cfoutput>
				</select>
			</td>
			<td><cf_get_lang_main no='16.e-mail'></td>
			<td><cfsavecontent variable="mesaj"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='16.E-mail'></cfsavecontent>
				<cfinput type="text" name="email" id="email" value="#getPartner.company_partner_email#" maxlength="100" validate="email" message="#mesaj#" style="width:150px;">
			</td>
		</tr>
		<tr>
			<cfif Len(getPartner.country)>
				<cfquery name="get_country_phone" dbtype="query">
					SELECT COUNTRY_PHONE_CODE FROM GETCOUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartner.country#">
				</cfquery>
			</cfif>
			<td><cf_get_lang_main no='87.Telefon'> <label id="load_phone"><cfif Len(getPartner.country) and len(get_country_phone.country_phone_code)>(<cfoutput>#get_country_phone.country_phone_code#</cfoutput>)</cfif></label><!--- Ulke Telefon Kodunu atiyor ---></td>
			<td>
				<cfsavecontent variable="message"><cf_get_lang no='178.Geçerli Bir Telefon kodu Giriniz !'></cfsavecontent>
				<cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='87.telefon'></cfsavecontent>
				<cfinput type="text" name="telcod" id="telcod" value="#getPartner.company_partner_telcode#" validate="integer" message="#message#" maxlength="5" style="width:60px;">
				<cfinput type="text" name="tel" id="tel" value="#getPartner.company_partner_tel#" validate="integer" message="#message#" maxlength="10" style="width:86px;">
			</td>
			<td width="80"><cf_get_lang no='121.Dahili'></td>
			<td>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no='121.dahili !'></cfsavecontent>
				<cfinput type="text" name="tel_local" id="tel_local" value="#getPartner.company_partner_tel_ext#" validate="integer" message="#message#" maxlength="5" style="width:86px;">
			</td>
		</tr>
		<tr>
			<td><cf_get_lang no='116.Kod /Mobil Tel'></td>
			<td>
				<!---<select name="mobilcat_id" id="mobilcat_id" style="width:60px;">
					<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
					<cfoutput query="getMobilcat">
						<option value="#mobilcat#" <cfif mobilcat is getPartner.mobil_code>selected</cfif>>#mobilcat#</option>
					</cfoutput>
				</select>--->
                <input maxlength="5" type="text" name="mobilcat_id" id="mobilcat_id" onKeyup="isNumber(this);" onblur="isNumber(this);" value="<cfoutput>#getPartner.mobil_code#</cfoutput>" style="width:60px;">
				<cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no='116.gsm No !'></cfsavecontent>
				<cfinput type="text" name="mobiltel" id="mobiltel" value="#getPartner.mobiltel#" validate="integer" message="#message#" maxlength="10" style="width:86px;">
			</td>
			<td><cf_get_lang_main no='76.Fax'></td>
			<td>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no='107.Fax No !'></cfsavecontent>
				<cfinput type="text" name="fax" id="fax" value="#getPartner.company_partner_fax#" validate="integer" message="#message#" maxlength="10" style="width:86px;">
			</td>
		</tr>
		<tr>
			<td><cf_get_lang no='41.İnternet'></td>
			<td><input type="text" name="homepage" id="homepage" value="<cfoutput>#getPartner.homepage#</cfoutput>" maxlength="50" style="width:150px;"></td>
		</tr>
		<tr>
			<td colspan="2"><cf_get_lang no="429.Mail Almak İstiyorum">&nbsp;<input type="checkbox" name="want_email" id="want_email" value="1" <cfif getPartner.want_email eq 1> checked</cfif>></td>
			<td colspan="2"><cf_get_lang no="180.SMS Almak İstiyorum">&nbsp;<input type="checkbox" name="want_sms" id="want_sms" value="1" <cfif getPartner.want_sms eq 1> checked</cfif>></td>
		</tr>
	</table>
</cf_box>
<cf_box id="upd_partner_3" closable="0" collapsable="0">
	<table>
		<tr>
			<td class="txtboldblue" colspan="4" height="20"><cf_get_lang_main no='1311.Adres'></td>
		</tr>
		<tr> 		
			<td width="100"><cf_get_lang_main no='807.Ülke'></td>
			<td width="175">
				<select name="country" id="country" style="width:150px;" onChange="LoadCity(this.value,'city_id','county_id',0)">
					<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
					<cfoutput query="getCountry">
						<option value="#country_id#" <cfif getPartner.country eq country_id>selected</cfif>>#country_name#</option>
					</cfoutput>
				</select>
			</td>
			<td width="80" rowspan="3" valign="top"><cf_get_lang_main no='1311.Adres'></td>
			<td rowspan="3" valign="top">
				<textarea name="adres" style="width:150px;height:65px;"><cfoutput>#getPartner.company_partner_address#</cfoutput></textarea>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='559.Şehir'></td>
			<td>
			   <select name="city_id" id="city_id" style="width:150px;" onChange="LoadCounty(this.value,'county_id','company_partner_telcode')">
					<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
					<cfquery name="GET_CITY" datasource="#DSN#">
						SELECT CITY_ID,CITY_NAME FROM SETUP_CITY <cfif len(getPartner.country)>WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartner.country#"></cfif>
					</cfquery>
					<cfoutput query="GET_CITY">
						<option value="#city_id#" <cfif getPartner.city eq city_id>selected</cfif>>#city_name#</option>
					</cfoutput>
				</select>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='1226.Ilce'></td>
			<td><cfquery name="GET_COUNTY" datasource="#DSN#">
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
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='720.Semt'></td>
			<td><input type="text" name="semt" id="semt" value="<cfoutput>#getPartner.semt#</cfoutput>" maxlength="45" style="width:150px;"></td>
			<td><cf_get_lang_main no='60.Posta Kodu'></td>
			<td><input type="text" name="postcod" id="postcod" style="width:150px;" maxlength="15" value="<cfoutput>#getPartner.company_partner_postcode#</cfoutput>"></td>
		</tr>
	</table>
</cf_box>
<cf_box id="upd_partner_3" closable="0" collapsable="0">
	<table>
		<tr>
			<td width="400">
				<cfoutput>
					<cf_get_lang_main no='71.Kayıt'> : 
					<cfif len(getPartner.record_member)> #get_emp_info(getPartner.record_member,0,0)# - </cfif>
					<cfif len(getPartner.record_par)>#get_par_info(getPartner.record_par,0,-1,0)# - </cfif>
					#dateformat(date_add('h',session.ep.time_zone,getPartner.record_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,getPartner.record_date),timeformat_style)#) &nbsp;
					<cfif len(getPartner.record_ip)> - #getPartner.record_ip#&nbsp;&nbsp;&nbsp;</cfif>
					<br/>
					<cfif len(getPartner.update_member)>
						<cf_get_lang_main no='291.Son Güncelleme'>: #get_emp_info(getPartner.update_member,0,0)# - 
						#dateformat(date_add('h',session.ep.time_zone,getPartner.update_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,getPartner.update_date),timeformat_style)#)
					</cfif>
					<cfif len(getPartner.update_ip)> - #getPartner.update_ip#</cfif>
				</cfoutput>
			</td>
			<td align="right"><cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'></td>
		</tr>
	</table>
</cf_box>
