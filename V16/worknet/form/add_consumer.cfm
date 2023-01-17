<cfparam name="attributes.is_tel_length_kontrol" default="">
<cfset cmp = createObject("component","V16.worknet.query.worknet_member") />
<!---<cfset getMobilcat = cmp.getMobilcat() />--->
<cfset getCountry = cmp.getCountry() />
<cfset getUnv = cmp.getUnv() />
<cfset getSchoolPart = cmp.getSchoolPart()>
<cfset getConsumerCat = cmp.getConsumerCat()>
<cfset kontrol_zone = 0>
	<cfform name="add_consumer" method="post" onsubmit="return kontrol();" action="#request.self#?fuseaction=worknet.emptypopup_add_consumer">
		<table class="text_table" height="100%" border="0" width="100%">
            <tr>
                <td>
                    <div class="td_kutu">
                        <div class="td_kutu_1"><h2>Akademi Üyesi</h2></div>
                            <div class="td_kutu_2">
                            <table>
                            <tr>
                            <td valign="top"><!---1.BÖLÜM --->
                                <table>
                                    <tr>
                                        <td nowrap="nowrap" width="100"><cf_get_lang_main no='219.Ad'> *</td>
                                        <td><cfsavecontent variable="message1">Lütfen Ad Giriniz</cfsavecontent>
                                            <cfinput type="text" name="consumer_name" id="consumer_name" style="width:150px;" required="yes" message="#message1#" maxlength="30">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap="nowrap"><cf_get_lang_main no='613.TC Kimlik No'> *</td>
                                        <td>
                                            <cf_wrkTcNumber fieldId="tc_identity_no" tc_identity_required="1" width_info='150'>
                                        </td>		
                                    </tr>
                                    <tr><td colspan="2">&nbsp;</td></tr>
                                    <tr><td colspan="2">&nbsp;</td></tr>
                                    <tr>
                                        <td nowrap="nowrap"><cf_get_lang_main no='16.E-Mail'> *</td>
                                        <td>
                                            <cfsavecontent variable="msg">E-Posta Girmelisiniz</cfsavecontent>
                                            <cfinput type="text" name="consumer_email" id="consumer_email" style="width:150px;" maxlength="100" validate="email" required="yes" message="#msg#" autocomplete="off">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap="nowrap"><cf_get_lang_main no='87.Telefon'></td>
                                        <td>
                                            <cfinput type="text"name="consumer_hometelcode" id="consumer_hometelcode" style="width:55px;" maxlength="5" >
                                            <cfinput type="text" name="consumer_hometel" id="consumer_hometel" validate="integer" style="width:90px;" maxlength="9">				
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap="nowrap"><cf_get_lang_main no='1070.Mobil Tel'></td>
                                        <td><!---<select name="mobilcat_id" id="mobilcat_id" style="width:55px;">
                                                <option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
                                                <cfoutput query="getMobilcat">
                                                    <option value="#mobilcat#"> #mobilcat# </option>
                                                </cfoutput>
                                            </select>--->
                                            <input maxlength="5" type="text" name="mobilcat_id" id="mobilcat_id" onKeyup="isNumber(this);" onblur="isNumber(this);" value="" style="width:55px;">
                                            <cfsavecontent variable="message2">Lütfen Geçerli Bir Mobil Telefon No Giriniz</cfsavecontent>
                                            &nbsp;<cfinput type="text" name="mobiltel" id="mobiltel" validate="integer" message="#message2#" maxlength="9" style="width:90px;">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><cf_get_lang_main no ='1958.Üniversite'></td>
                                        <td>
                                            <select name="edu4_id" id="edu4_id" style="width:150px;">
                                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                <cfoutput query="getUnv">
                                                <option value="#school_id#">#school_name#</option>	
                                                </cfoutput>
                                            </select>
                                        </td>
                                    </tr>
                                     <tr id="school_parts_div">
                                        <td><cf_get_lang_main no='727.Bölümler'></td>
                                        <td><select name="edu_part_id" id="edu_part_id" style="width:150px;">
                                                <option value=""><cf_get_lang_main no='727.Bölümler'></option>
                                                <cfoutput query="getSchoolPart">
                                                    <option value="#part_id#">#part_name#</option>	
                                                </cfoutput>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr><td colspan="2">&nbsp;</td></tr>
                                    <tr><td colspan="2">&nbsp;</td></tr>
                                    <tr>
                                        <td valign="top" nowrap="nowrap"><cf_get_lang_main no='1311.Adres'></td>
                                        <td valign="top"><textarea name="homeaddress" id="homeaddress" rows="6" style="width:150px"></textarea></td>
                                    </tr>
                                    <tr>
                                        <td nowrap="nowrap"><cf_get_lang_main no='60.Posta Kodu'></td>
                                        <td><input type="text" name="homepostcode" maxlength="43" id="homepostcode" value="" style="width:150px;" /></td>
                                    </tr>
                                </table>
                            </td>
                            <td valign="top" style="padding-left:20px;"><!--- 2.BÖLÜM--->
                                <table>
                                    <tr>
                                        <td nowrap="nowrap"><cf_get_lang_main no='1314.Soyad'>*</td>
                                        <td><cfsavecontent variable="message1">Lütfen Soyad Giriniz</cfsavecontent>
                                            <cfinput type="text" name="consumer_surname" id="consumer_surname" style="width:150px;" required="yes" message="#message1#" maxlength="30">
                                        </td>
                                    </tr>
                                        <tr>
                                            <td nowrap="nowrap"><cf_get_lang_main no='1315.Doğum Tarihi'></td>
                                            <td>
                                                <cfinput type="text" name="birthdate" id="birthdate" maxlength="10" style="width:65px; float:left; margin-right:5px;">
                                                <cf_wrk_date_image date_field="birthdate">
                                            </td>
                                        </tr>
                                    <tr><td colspan="2">&nbsp;</td></tr>
                                    <tr><td colspan="2">&nbsp;</td></tr>
                                    <cfif isdefined("attributes.is_activation")>
                                        <input type="hidden" name="is_activation" id="is_activation" value="1"/>
                                    </cfif>
                                    <tr>
                                        <td nowrap="nowrap"><cf_get_lang_main no='140.Şifre'> *</td>
                                        <td>
                                            <cfinput type="password" name="password1" id="password1" style="width:150px;"> (En az 6 karakter)
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><cf_get_lang_main no='162.Şirket'></td>
                                        <td><input type="text" name="company" id="company" tabindex="5" value="" maxlength="100" style="width:150px;"></td>
                                    </tr>
                                    <tr>
                                        <td><cf_get_lang_main no='159.Ünvan'></td>
                                        <td><input  type="text" name="title" id="title" maxlength="50" tabindex="5" value="" style="width:150px;"></td>
                                    </tr>
									<tr>
										<td><cf_get_lang_main no="1197.Üye Kategorisi"> *</td>
										<td>
											<select name="conscat_id" id="conscat_id" style="width:150px;">
											<cfoutput query="getConsumerCat">
												<option value="#conscat_id#">#conscat#</option>
											</cfoutput>
											</select>
										</td>
									</tr>
                                    <tr><td colspan="2">&nbsp;</td></tr>
                                    <tr><td colspan="2">&nbsp;</td></tr>
									<tr><td colspan="2">&nbsp;</td></tr>
                                    <tr>
                                        <td nowrap="nowrap"><cf_get_lang_main no='807.Ülke'></td>
                                        <td>
                                            <select name="home_country" id="home_country" style="width:150px;" tabindex="4" onChange="LoadCity(this.value,'home_city_id','home_county_id',<cfoutput>'#kontrol_zone#'</cfoutput>)">
                                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                <cfoutput query="getCountry">
                                                    <option value="#country_id#" <cfif is_default eq 1>selected</cfif>>#country_name#</option>
                                                </cfoutput>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap="nowrap"><cf_get_lang_main no='559.Şehir'></td>
                                        <td>
                                            <select name="home_city_id" id="home_city_id" style="width:150px;" onChange="LoadCounty(this.value,'home_county_id','consumer_hometelcode')">
                                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap="nowrap"><cf_get_lang_main no='1226.İlçe'></td>
                                        <td>
                                            <select name="home_county_id" id="home_county_id" style="width:150px;">
                                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            </select>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                        	<td colspan="2" style="text-align:right;">
                      	 	<cfsavecontent variable="message"><cf_get_lang_main no="49.Kaydet"></cfsavecontent>
							<input class="btn_1" type="submit" value="<cfoutput>#message#</cfoutput>" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </td>
	</tr>
</table>
</cfform>
<script type="text/javascript">
	if(document.getElementById('home_country') == undefined)
	{
		var country_control = wrk_safe_query("obj2_country_control",'dsn');
		LoadCity(country_control.COUNTRY_ID,'home_city_id','home_county_id',<cfoutput>'#kontrol_zone#'</cfoutput>);
	}
	else
	{
		var home_country_ = document.getElementById('home_country').value;
		if(home_country_.length)
			LoadCity(home_country_,'home_city_id','home_county_id',<cfoutput>'#kontrol_zone#'</cfoutput>);
	}
	function kontrol()
	{
		if(document.getElementById('birthdate') != undefined && document.getElementById('birthdate').value != '')
		{
			var tarih_ = fix_date_value(document.getElementById('birthdate').value);
			if(tarih_.substr(6,4) < 1900)
			{
			   alert("<cf_get_lang_main no='370.Tarih Değerini Kontrol Ediniz'>!");
			   return false;
			}
		}
		<cfif isdefined("attributes.is_tel_length_kontrol") and attributes.is_tel_length_kontrol eq 1>
			if(!form_warning('mobiltel','Cep Telefonu 7 Hane Olmalıdır !',7))return false;
			if(!form_warning('consumer_hometel','Ev Telefonu 7 Hane Olmalıdır !',7))return false;
			if(!form_warning('consumer_hometelcode','Ev Telefonu Kodu 3 Hane Olmalıdır !',3))return false;
		</cfif>
		if(document.getElementById('tc_identity_no') != undefined && document.getElementById('tc_identity_no').value != "")
		{
			var consumer_control = wrk_safe_query("obj2_consumer_control",'dsn',0,document.getElementById('tc_identity_no').value);
			if(consumer_control.recordcount > 0)
			{
				alert("Aynı TC Kimlik Numarası İle Kayıtlı Üye Var Lütfen Bilgilerinizi Kontrol Ediniz!");
				return false;
			}
		}
		if(document.getElementById('tc_identity_no').value == "")
		{
			alert("<cf_get_lang_main no='1275.Lütfen tc kimlik numaranızı giriniz'>!");
			return false;
		}
		if(document.getElementById('password1').value == '')
		{
			alert('<cf_get_lang_main no="140.Şifre">!');
			return false;
		}
		if(document.getElementById('password1').value.length > 0)
		{
			x = (document.getElementById('password1').value.length);
			if ( x < 6 )
			{ 
				alert ("Şifreniz En Az Altı Karakter Olmalıdır!");
				return false;
			}
		}
		if(document.getElementById('homeaddress') != undefined)
		{
			if (document.getElementById('homeaddress').value.length > 200)
			{
				alert("Adres alanı 200 karakteri aşamaz!");
				document.getElementById('homeaddress').focus();
				return false;
			}
		}
		return true;
	}
</script>
