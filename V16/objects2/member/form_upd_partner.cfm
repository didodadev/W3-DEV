<cfset attributes.cpid = session.pp.company_id>
<cfquery name="GET_PARTNER" datasource="#DSN#">
	SELECT 
		C.COMPANY_ID,
		C.SEMT,
		C.HOMEPAGE,
        C.MANAGER_PARTNER_ID,
		C.FULLNAME,
		CP.COUNTY,
		CP.PARTNER_ID,
		CP.COMPANY_PARTNER_NAME,
		CP.COMPANY_PARTNER_SURNAME,
		CP.COMPANY_PARTNER_STATUS,
		CP.IMCAT_ID,
		CP.IM,
		CP.COMPANY_PARTNER_TELCODE,
		CP.COMPANY_PARTNER_TEL,
		CP.COMPANY_PARTNER_USERNAME,
		CP.COMPANY_PARTNER_TEL_EXT,
		CP.COMPANY_PARTNER_FAX,
		CP.TITLE,
		CP.MOBIL_CODE,
		CP.MOBILTEL,
		CP.MISSION,
		CP.COMPANY_PARTNER_EMAIL,
		CP.DEPARTMENT,
		CP.COMPANY_PARTNER_ADDRESS,
		CP.LANGUAGE_ID,
		CP.COMPANY_PARTNER_POSTCODE,
		CP.SEX,
		CP.CITY,
		CP.COUNTRY,
		CP.COUNTY,
		CP.RECORD_MEMBER,
		CP.RECORD_PAR,
		CP.UPDATE_MEMBER,
		CP.PHOTO_SERVER_ID,
		CP.PHOTO,
		CP.COMPBRANCH_ID  
	FROM 
		COMPANY_PARTNER CP, 
		COMPANY C
	WHERE 
		CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#"> AND
		CP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.pid#"> AND
		CP.COMPANY_ID = C.COMPANY_ID
	ORDER BY 
		CP.COMPANY_PARTNER_NAME
</cfquery>
<cfif isdefined('attributes.is_self_info') and (attributes.is_self_info eq 0 or (attributes.is_self_info eq 1 and session.pp.userid neq get_partner.manager_partner_id))>
	<cfif url.pid neq session.pp.userid>
		<script>
			alert("<cf_get_lang_main no='120.Bu Sayfaya Yetkili Değilsiniz'>");
			history.back(-1);
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfquery name="GET_PARTNER_DETAIL" datasource="#DSN#">
	SELECT 
		BIRTHDATE,
		BIRTHPLACE
	FROM 
		COMPANY_PARTNER_DETAIL
	WHERE 
		PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.pid#">
</cfquery>
<cfquery name="GET_MY_SETTINGS_" datasource="#DSN#">
	SELECT TIMEOUT_LIMIT FROM MY_SETTINGS_P WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
</cfquery>
<cfquery name="GET_COMPANYCAT" datasource="#DSN#">
	SELECT 
    	COMPANYCAT_ID,
        COMPANYCAT 
    FROM 
    	COMPANY_CAT,
        CATEGORY_SITE_DOMAIN
	WHERE
		COMPANY_CAT.COMPANYCAT_ID = CATEGORY_SITE_DOMAIN.CATEGORY_ID AND
		CATEGORY_SITE_DOMAIN.MENU_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.menu_id#"> AND
		CATEGORY_SITE_DOMAIN.MEMBER_TYPE = 'COMPANY'
</cfquery>
<cfquery name="GET_IM" datasource="#DSN#">
	SELECT IMCAT_ID,IMCAT FROM SETUP_IM
</cfquery>
<cfquery name="GET_MOBILCAT" datasource="#DSN#">
	SELECT MOBILCAT_ID, MOBILCAT FROM SETUP_MOBILCAT ORDER BY MOBILCAT  ASC
</cfquery>
<cfquery name="GET_LANGUAGE" datasource="#DSN#">
	SELECT LANGUAGE_SHORT, LANGUAGE_SET FROM SETUP_LANGUAGE
</cfquery>
<cfquery name="GET_PARTNER_POSITIONS" datasource="#DSN#">
	SELECT PARTNER_POSITION_ID, PARTNER_POSITION FROM SETUP_PARTNER_POSITION ORDER BY PARTNER_POSITION
</cfquery>
<cfquery name="GET_PARTNER_DEPARTMENTS" datasource="#DSN#">
	SELECT PARTNER_DEPARTMENT_ID, PARTNER_DEPARTMENT FROM SETUP_PARTNER_DEPARTMENT ORDER BY PARTNER_DEPARTMENT 
</cfquery>
<cfquery name="GET_COUNTRY" datasource="#DSN#">
	SELECT COUNTRY_ID,COUNTRY_NAME,IS_DEFAULT FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
</cfquery>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT 
		B.COMPBRANCH_ID, 
		B.ZONE_ID, 
		B.COMPBRANCH__NAME, 
		B.COMPBRANCH_STATUS, 
		B.COMPBRANCH__NICKNAME
	FROM 
		COMPANY_BRANCH B, 
		COMPANY_PARTNER CP
	WHERE 
		CP.COMPANY_ID = B.COMPANY_ID AND
		CP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
	ORDER BY
		B.COMPBRANCH__NAME 
</cfquery>
<table border="0" align="center" cellpadding="0" cellspacing="0" style="width:100%">
 	<tr>
		<td style="width:250px; vertical-align:top">
			<!--- fotoğraf --->
			<table cellspacing="1" cellpadding="2" border="0" class="color-border" align="center" style="width:98%;">
			  	<tr class="color-header" style="height:22px;">
					<td class="form-title">&nbsp;<cf_get_lang no='207.Fotoğraf'></td>
			  	</tr>
			  	<tr class="color-header" style="height:22px;">
					<td class="color-row" align="center">
					  	<cfif len(get_partner.photo)>
							<cfoutput>
							<cf_get_server_file output_file="member/#get_partner.photo#" output_server="#get_partner.photo_server_id#" output_type="0" image_width="125" image_height="150" image_link="1" alt="#getLang('main',668)#" title="#getLang('main',668)#">
							</cfoutput>
			   	    <cfelse>
							<cf_get_lang_main no='1083.Fotoğraf Girilmemiş'> !
					  	</cfif>
				 	</td>
			  	</tr>
			</table>
		</td>
		<td style="vertical-align:top">
        	<cfform name="upd_partner" method="post" action="#request.self#?fuseaction=objects2.emptypopup_upd_partner" enctype="multipart/form-data">
			<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_partner.company_id#</cfoutput>">
			<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_partner.partner_id#</cfoutput>">
			<table cellspacing="1" cellpadding="2" align="center" style="width:100%">
			  	<tr class="color-row">
					 <td>
						<table cellspacing="1" cellpadding="2" align="center" class="color-row" style="width:100%">
							<tr>
								<td><cf_get_lang_main no='518.Kullanıcı'></td>
								<td colspan="2" class="txtbold">
									<cfoutput>#get_partner.company_partner_name#&nbsp;#get_partner.company_partner_surname#/
										<a href="#request.self#?fuseaction=objects2.form_upd_my_company" class="txtboldblue">#get_partner.fullname#</a>
									</cfoutput>
								</td>
								<cfif isdefined('attributes.is_partner_denied') and attributes.is_partner_denied eq 1>
                                	<cfif get_partner.manager_partner_id eq session.pp.userid>
                                        <td style="text-align:right;">
                                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_denied_pages_partner&id=#url.pid#</cfoutput>','list');"><img src="/images/lock_buton.gif" title="Sayfa Kısıtı" border="0"></a>
                                        </td>
                                    </cfif>
								</cfif>
					  		</tr>
					  		<tr style="height:22px;">
								<td style="width:100px;"><cf_get_lang_main no='2218.Online'></td>
								<td class="color-row" style="width:185px;"><cf_online id="#get_partner.partner_id#" zone="pp"></td>
                                <cfif isdefined('attributes.is_partner_denied') and ((attributes.is_partner_denied neq 1) or (attributes.is_partner_denied eq 1 and get_partner.manager_partner_id eq session.pp.userid))>
                                    <td align="left"><cf_get_lang_main no='81.Aktif'></td>
                                    <td align="left"><input type="checkbox" name="company_partner_status" id="company_partner_status" <cfif get_partner.company_partner_status eq 1>checked</cfif>></td>
								<cfelse>
                                	<td colspan="2"></td>
                                </cfif>
						  	</tr>
						  	<tr style="height:22px;">
								<td style="width:75px;"><cf_get_lang_main no='219.Ad'> *</td>
								<td>
									<cfsavecontent variable="message"><cf_get_lang no='219.Üye Adı Giriniz'> !</cfsavecontent>
								  	<cfinput type="text" name="company_partner_name" id="company_partner_name" value="#get_partner.company_partner_name#" maxlength="20" required="yes" message="#message#" style="width:150px;"></td>
								<td style="width:100px;"><cf_get_lang no='1031.Instant Message'></td>
								<td>
								  	<select name="imcat_id" id="imcat_id" style="width:55px;">
								  		<option value=''><cf_get_lang_main no='322.Seçiniz'></option>
										<cfoutput query="get_im">
									  		<option value="#imcat_id#"<cfif imcat_id is get_partner.imcat_id>selected</cfif>>#imcat#</option> 
								  		</cfoutput>
								  	</select>
								  	<input type="text" name="im" id="im" value="<cfoutput>#get_partner.im#</cfoutput>" maxlength="50" style="width:92px;">
								</td>
						  	</tr>
						  	<tr style="height:22px;">
								<td><cf_get_lang_main no='1314.Soyad'> *</td>
								<td><cfsavecontent variable="message"><cf_get_lang no='237.Üye Soyadı Girmelisiniz'>!</cfsavecontent>
								  	<cfinput type="text" name="company_partner_surname" id="company_partner_surname" value="#get_partner.company_partner_surname#" required="yes" message="#message#" maxlength="20" style="width:150px;"></td>
								<td><cf_get_lang_main no='1173.Kod'>/ <cf_get_lang_main no='87.Telefon'></td>
								<td>
								  	<input type="text" name="company_partner_telcode" id="company_partner_telcode" value="<cfoutput>#get_partner.company_partner_telcode#</cfoutput>" onkeyup="isNumber(this);" maxlength="5" style="width:55px;">
								  	<input type="text" name="company_partner_tel" id="company_partner_tel" value="<cfoutput>#get_partner.company_partner_tel#</cfoutput>" onkeyup="isNumber(this);" maxlength="10" style="width:92px;">
								</td>
						  	</tr>
					  		<tr style="height:22px;">
								<td><cf_get_lang_main no='139.Kullanıcı Adı'></td>
								<td><input type="text" name="company_partner_username" id="company_partner_username" value="<cfoutput>#get_partner.company_partner_username#</cfoutput>" maxlength="8" style="width:150px;"></td>
								<td><cf_get_lang no='231.Dahili Telefon'></td>
								<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							  		<input type="text" name="company_partner_tel_ext" id="company_partner_tel_ext" value="<cfoutput>#get_partner.company_partner_tel_ext#</cfoutput>" onkeyup="isNumber(this);" maxlength="5" style="width:90px;">&nbsp;&nbsp;&nbsp;</td>
					  		</tr>
					  		<tr style="height:22px;">
								<td><cf_get_lang_main no='140.Şifre'></td>
								<td><input type="Password" name="company_partner_password" id="company_partner_password" value="" maxlength="16" style="width:150px;"></td> 
								<td><cf_get_lang_main no='76.Fax'></td>
								<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								  	<input type="text" name="company_partner_fax" id="company_partner_fax" value="<cfoutput>#get_partner.company_partner_fax#</cfoutput>" onkeyup="isNumber(this);" maxlength="10" style="width:90px;">
								</td> 
					  		</tr>
						  	<tr style="height:22px;">
								<td><cf_get_lang_main no='159.Ünvan'></td>
								<td><input type="text" name="title" id="title" value="<cfoutput>#get_partner.title#</cfoutput>" maxlength="50" style="width:150px;"></td>
								<td><cf_get_lang_main no='1070.Mobil Kod'></td>
								<td>
								  	<select name="mobilcat_id" id="mobilcat_id" style="width:55px;">
										<option selected value=""><cf_get_lang_main no='322.Seçiniz'> 
										<cfoutput query="get_mobilcat">
											<option value="#mobilcat#" <cfif mobilcat is get_partner.mobil_code>selected</cfif>>#mobilcat#</option>
										</cfoutput>
								  	</select>
								  	<input type="text" name="mobiltel" id="mobiltel" value="<cfoutput>#get_partner.mobiltel#</cfoutput>" onkeyup="isNumber(this);" maxlength="10" style="width:92px;">
								</td>
						  	</tr>
						  	<tr style="height:22px;">
								<td><cf_get_lang_main no='161.Görev'></td>
								<td>
								  	<select name="mission" id="mission" style="width:150px;">
									  	<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
									  	<cfoutput query="get_partner_positions">
											<option value="#partner_position_id#" <cfif get_partner.mission eq partner_position_id>selected</cfif>>#partner_position#</option>
									  	</cfoutput>
								  	</select>
								</td>
								<td><cf_get_lang_main no='16.E-mail'></td>
								<td><cfsavecontent variable="message"><cf_get_lang_main no='1072.Lütfen geçerli bir e-posta adresi giriniz!'></cfsavecontent>
									<cfinput type="text" name="company_partner_email" id="company_partner_email" value="#get_partner.company_partner_email#" maxlength="50" validate="email" message="#message#" style="width:150px;">
								</td>
						  	</tr> 
						  	<tr style="height:22px;">
								<td><cf_get_lang_main no='160.Departman'></td>
								<td>
								  	<select name="department" id="department" style="width:150px;">
									  	<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
									  	<cfoutput query="get_partner_departments">
											<option value="#partner_department_id#" <cfif get_partner.department eq partner_department_id>selected</cfif>>#partner_department#</option>
									  	</cfoutput>
								  	</select>
								</td>
								<td><cf_get_lang_main no='667.İnternet'></td>
								<td><input type="text" maxlength="50" name="homepage" id="homepage" value="<cfoutput>#get_partner.homepage#</cfoutput>" style="width:150px;"></td>
						  	</tr>
						  	<tr style="height:22px;">
								<td><cf_get_lang_main no='41.Şube'></td>
								<td>
								  	<select name="compbranch_id" id="compbranch_id" style="width:150px;">
								  		<option value="0"><cf_get_lang no='27.Merkez Ofis'>
								  		<cfoutput query="get_branch">
											<option value="#compbranch_id#" <cfif get_partner.compbranch_id eq compbranch_id>selected</cfif>>#compbranch__name#</option>
								  		</cfoutput>
								  	</select>
								</td>
								<td><cf_get_lang_main no='1311.Adres'></td>
								<td rowspan="2">
									<input type="hidden" name="counter" id="counter">
							  		<textarea name="company_partner_address" id="company_partner_address" style="width:150px;height:50px;"><cfoutput>#get_partner.company_partner_address#</cfoutput></textarea>
								</td>
							</tr>
					  		<tr style="height:22px;">
								<td><cf_get_lang_main no='1584.Dil'> *</td>
								<td>
								  	<select name="language_id" id="language_id" style="width:150px;">
										<cfoutput query="get_language">
											<option value="#language_short#" <cfif get_partner.language_id eq language_short> selected</cfif>>#language_set#</option>
										</cfoutput>
								  	</select>
								</td>
							</tr>
							<tr style="height:22px;">
								<td><cf_get_lang no='207.Fotoğraf'></td>
								<td><input type="file" name="photo" id="photo" style="width:150px;"></td> 
								<td><cf_get_lang_main no='60.Posta Kodu'></td>
								<td><input type="text" name="company_partner_postcode" id="company_partner_postcode" value="<cfoutput>#get_partner.company_partner_postcode#</cfoutput>" onkeyup="isNumber(this);" maxlength="15" style="width:150px;"></td>
							</tr>
							<tr>
								<td colspan="2"><cf_get_lang no='208.Fotoğrafı Sil'> <input  type="Checkbox" name="del_photo" id="del_photo" value="1">&nbsp;<cf_get_lang_main no='83.Evet'></td>
								<td><cf_get_lang_main no='720.Semt'></td>
								<td><input type="text" name="semt" id="semt" value="<cfoutput>#get_partner.semt#</cfoutput>" maxlength="45" style="width:150px;"></td>
							</tr>
							<tr style="height:22px;">
								<td><cf_get_lang_main no='352.Cinsiyet'></td>
								<td>
								  	<select name="sex" id="sex" style="width:150px;">
								  		<option value="1" <cfif get_partner.sex eq 1>selected</cfif>><cf_get_lang_main no='1547.Erkek'>
								  		<option value="2" <cfif get_partner.sex eq 2>selected</cfif>><cf_get_lang_main no='1546.Kadin'>
								  	</select>
								</td>
								<td><cf_get_lang_main no='1226.ilçe'></td>
								<td>
									<select name="county_id" id="county_id" style="width:150px;">
										<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
										<cfif len(get_partner.city)>
											<cfquery name="GET_COUNTY" datasource="#DSN#">
												SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_partner.city#">
											</cfquery>
											<cfoutput query="get_county">
												<option value="#county_id#" <cfif get_partner.county eq county_id>selected</cfif>>#county_name#</option>
											</cfoutput>
										</cfif>
									</select>
								</td>
							</tr>
							<tr>
								<td><cf_get_lang_main no='278.Doğum Yeri'></td>
								<td><input type="text" name="birthplace" id="birthplace" style="width:150px;" value="<cfoutput>#get_partner_detail.birthplace#</cfoutput>"></td>
								<td><cf_get_lang_main no='559.Şehir'></td>
								<td>
								 	<select name="city" id="city" style="width:150px;" onchange="LoadCounty(this.value,'county_id','company_partner_telcode');remove_adress(2)">
										<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
										<cfif len(get_partner.country)>
											<cfquery name="GET_CITY" datasource="#DSN#">
												SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_partner.country#"> ORDER BY CITY_NAME
											</cfquery>
											<cfoutput query="get_city">
												<option value="#city_id#"<cfif city_id eq get_partner.city>selected</cfif>>#city_name#</option>
											</cfoutput>
										</cfif>
								 	</select>
								</td>
							</tr>
							<tr>
								<td><cf_get_lang_main no='1315.Doğum Tarihi'></td>
								<td>
									<cfinput type="text" name="birthdate" id="birthdate" validate="eurodate" value="#dateformat(get_partner_detail.birthdate,'dd/mm/yyyy')#" style="width:150px;">
									<cf_wrk_date_image date_field="birthdate">
								</td>
								<td><cf_get_lang_main no='807.Ülke'></td>
								<td>
								  	<select name="country" id="country" onchange="LoadCity(this.value,'city','county_id',0);remove_adress('1');" style="width:150px;">
										<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
										<cfoutput query="get_country">
											<option value="#country_id#" <cfif get_partner.country eq country_id>selected</cfif>>#country_name#</option>
										</cfoutput>
								  	</select>
								</td>	
							</tr>
							<tr style="height:22px;">
								<td><cf_get_lang no='228.Timeout Süresi dk'></td>
								<td>
									<select name="timeout_limit" id="timeout_limit" style="width:150px;">
										<option value="15" <cfif get_my_settings_.timeout_limit is '15'>selected</cfif>>15 dk.</option>
										<option value="30" <cfif get_my_settings_.timeout_limit is '30'>selected</cfif>>30 dk.</option>
										<option value="45" <cfif get_my_settings_.timeout_limit is '45'>selected</cfif>>45 dk.</option>
										<option value="60" <cfif get_my_settings_.timeout_limit is '60'>selected</cfif>>60 dk.</option>
									</select>
								</td>
							</tr>
							<tr>
								<td colspan="3" class="txtbold">
									<cfoutput>
								  	<cf_get_lang_main no='71.Kayıt'>: 
								  	<cfif len(get_partner.record_member)>#get_emp_info(get_partner.record_member,0,0)# </cfif>
								  	<cfif len(get_partner.record_par)>#get_par_info(get_partner.record_par,1,1,0)# </cfif>
								  	</cfoutput>
								</td>
								<td rowspan="2">
								<cfif isdefined('attributes.is_self_info') and ((attributes.is_self_info eq 1 and session.pp.userid eq get_partner.manager_partner_id) or attributes.is_self_info eq 3 or (attributes.is_self_info eq 4 and session.pp.userid eq get_partner.partner_id))>
									<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
								</td>
								<!--- delete_page_url='#request.self#?fuseaction=member.del_member_popup&pid=#get_partner.partner_id#'  --->
								</cfif>
							</tr>
							<tr>
								<td colspan="3" class="txtbold">
									<cfoutput>
								  	<cfif len(get_partner.update_member)>
										<cf_get_lang_main no='291.Güncelleme'>: #get_emp_info(get_partner.update_member,0,0)#
								  	</cfif>
								  	</cfoutput>
								</td>
								<td></td>
							</tr>
						</table>
				 	</td>
			  	</tr>
			</table>
            </cfform>
		</td>
	</tr>
</table>

<script type="text/javascript">
	function remove_adress(parametre)
	{
		if(parametre==1)
		{
			//document.upd_partner.city_id.value = '';
			document.getElementById('city').value = '';
			document.getElementById('county_id').value = '';
			document.getElementById('county').value = '';
		}
		else
		{
			document.getElementById('county_id').value = '';
			document.getElementById('county').value = '';
		}	
	}
	
	function pencere_ac(no)
	{
		x = document.upd_partner.country.selectedIndex;
		if (document.upd_partner.country[x].value == "")
		{
			alert("<cf_get_lang no='31.İlk Olarak Ülke Seçiniz'>.");
		}	
		else if(document.getElementById('city').value == "")
		{
			alert("<cf_get_lang no='32.İl Seçiniz'> !");
		}
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_dsp_county&field_id=upd_partner.county_id&field_name=upd_partner.county&city_id=' + document.upd_partner.city.value,'small');
			document.getElementById('county_id').value = '';
			document.getElementById('county').value = '';
		}
	}
	
	function kontrol()
	{	
		x = document.upd_partner.compbranch_id.selectedIndex;
		if (document.upd_partner.compbranch_id[x].value == "")
		{ 
			alert ("Şube Seçmediniz !");
			return false;
		}
	
		x = document.upd_partner.language_id.selectedIndex;
		if (document.upd_partner.language_id[x].value == "")
		{ 
			alert ("<cf_get_lang no='517.Kullanıcı İçin Dil Seçmediniz'> !");
			return false;
		}
		
		x = (100 - document.upd_partner.company_partner_address.value.length);
		if ( x < 0)
		{ 
			alert ("Adres"+ ((-1) * x) +" Karakter Uzun !");
			return false;
		}
		x = (document.upd_partner.company_partner_password.value.length);
		if ((document.upd_partner.company_partner_password.value != '') && (x < 4 ))
		{ 
			alert ("<cf_get_lang no='516.Şifreniz En Az Dört Karakter Olmalıdır'>");
			return false;
		}
		
		var obj =  document.getElementById('photo').value;
		if ((obj != "") && !((obj.substring(obj.lastIndexOf('.')+1,obj.lastIndexOf('.') + 4).toLowerCase() == 'jpg')   || (obj.substring(obj.lastIndexOf('.')+1,obj.lastIndexOf('.') + 4).toLowerCase() == 'gif') || (obj.substring(obj.lastIndexOf('.')+1,obj.lastIndexOf('.') + 4).toLowerCase() == 'png')))
		{
			alert(obj.lastIndexOf('.') + 4);
			alert("<cf_get_lang no='515.Lütfen bir resim dosyası(gif,jpg veya png) giriniz'>!");        
			return false;
		}
		
		if (confirm("<cf_get_lang no='486.Girdiğiniz bilgileri kaydetmek üzeresiniz, lütfen değişiklikleri onaylayın'> !")) return true; else return false;	
	}
	document.getElementById('company_partner_name').focus();
</script>
