<cfset attributes.is_tc_number_required = 1>
<cfset cmp = createObject("component","V16.worknet.query.worknet_member") />
<!---<cfset getMobilcat = cmp.getMobilcat() />--->
<cfset getCountry = cmp.getCountry() />
<cfset getUnv = cmp.getUnv() />
<cfset getSchoolPart = cmp.getSchoolPart()>
<cfset getConsumerCat = cmp.getConsumerCat()>
<cfset attributes.consumer_id = attributes.consumer_id>
<cfset getConsumer = cmp.getConsumer(consumer_id:attributes.consumer_id)>
<cfset kontrol_zone = 0>
	<cfform name="upd_consumer" method="post" onsubmit="return kontrol();" action="#request.self#?fuseaction=worknet.emptypopup_upd_consumer">
	<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#getConsumer.consumer_id#</cfoutput>">
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
                                            <cfinput type="text" name="consumer_name" id="consumer_name" value="#getConsumer.consumer_name#" style="width:150px;" required="yes" message="#message1#" maxlength="30">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap="nowrap"><cf_get_lang_main no='613.TC Kimlik No'> *</td>
                                        <td>
                                            <cf_wrkTcNumber fieldId="tc_identity_no" tc_identity_number="#getConsumer.TC_IDENTY_NO#" tc_identity_required="1" width_info='150'>
                                        </td>		
                                    </tr>
                                    <tr><td colspan="2">&nbsp;</td></tr>
                                    <tr><td colspan="2">&nbsp;</td></tr>
                                    <tr>
                                        <td nowrap="nowrap"><cf_get_lang_main no='16.E-Mail'> *</td>
                                        <td>
                                            <cfsavecontent variable="msg">E-Posta Girmelisiniz</cfsavecontent>
                                            <cfinput type="text" name="consumer_email" id="consumer_email" style="width:150px;" value="#getConsumer.consumer_email#" maxlength="100" validate="email" required="yes" message="#msg#" autocomplete="off">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap="nowrap"><cf_get_lang_main no='87.Telefon'></td>
                                        <td>
                                            <cfinput type="text"name="consumer_hometelcode" id="consumer_hometelcode" value="#getConsumer.CONSUMER_HOMETELCODE#" style="width:55px;" maxlength="5">
                                            <cfinput type="text" name="consumer_hometel" id="consumer_hometel" value="#getConsumer.CONSUMER_HOMETEL#" validate="integer" style="width:90px;" maxlength="9">				
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap="nowrap"><cf_get_lang_main no='1070.Mobil Tel'></td>
                                        <td>
                                            <!---<select name="mobilcat_id" id="mobilcat_id" style="width:55px;">
                                                <option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
                                                <cfoutput query="getMobilcat">
                                                    <option value="#mobilcat#" <cfif getConsumer.mobil_code eq mobilcat>selected</cfif>>#mobilcat#</option>
                                                </cfoutput>
                                            </select>--->
					                        <input maxlength="5" type="text" name="mobilcat_id" id="mobilcat_id" onKeyup="isNumber(this);" onblur="isNumber(this);" value="<cfoutput>#getConsumer.mobil_code#</cfoutput>" style="width:60px;">
                                            <cfsavecontent variable="message2">Lütfen Geçerli Bir Mobil Telefon No Giriniz</cfsavecontent>
                                            &nbsp;<cfinput type="text" name="mobiltel" id="mobiltel" value="#getConsumer.mobiltel#" validate="integer" message="#message2#" maxlength="9" style="width:90px;">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><cf_get_lang_main no ='1958.Üniversite'></td>
                                        <td>
                                            <select name="edu4_id" id="edu4_id" style="width:150px;">
                                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                <cfoutput query="getUnv">
                                                    <option value="#school_id#" <cfif isdefined("getConsumer.edu4_id") and len("getConsumer.edu4_id") and getConsumer.edu4_id eq school_id>selected</cfif>>#school_name#</option>	
                                                </cfoutput>
                                            </select>
                                        </td>
                                    </tr>
									<tr>
										<td><cf_get_lang_main no='727.Bölümler'></td>
										<td><select name="edu_part_id" id="edu_part_id" style="width:150px;">
												<option value=""><cf_get_lang_main no='727.Bölümler'></option>
												<cfoutput query="getSchoolPart">
													<option value="#part_id#" <cfif isdefined("getConsumer.edu4_part_id") and getConsumer.edu4_part_id eq part_id>selected</cfif>>#part_name#</option>	
												</cfoutput>
											</select>
										</td>
									</tr>
                                    <tr><td colspan="2">&nbsp;</td></tr>
                                    <tr><td colspan="2">&nbsp;</td></tr>
                                    <tr>
                                        <td valign="top" nowrap="nowrap"><cf_get_lang_main no='1311.Adres'></td>
                                        <td valign="top"><textarea name="homeaddress" id="homeaddress" rows="6" style="width:150px"><cfoutput>#getConsumer.homeaddress#</cfoutput></textarea></td>
                                    </tr>
                                    <tr>
                                        <td nowrap="nowrap"><cf_get_lang_main no='60.Posta Kodu'></td>
                                        <td><input type="text" name="homepostcode" id="homepostcode" value="<cfoutput>#getConsumer.HOMEPOSTCODE#</cfoutput>" style="width:150px;" /></td>
                                    </tr>
                                </table>
                            </td>
                            <td valign="top" style="padding-left:20px;"><!--- 2.BÖLÜM--->
                                <table border="0">
                                    <tr>
                                        <td nowrap="nowrap"><cf_get_lang_main no='1314.Soyad'>*</td>
                                        <td><cfsavecontent variable="message1">Lütfen Soyad Giriniz</cfsavecontent>
                                            <cfinput type="text" name="consumer_surname" id="consumer_surname" style="width:150px;" value="#getConsumer.consumer_surname#" required="yes" message="#message1#" maxlength="30">
                                        </td>
                                    </tr>
                                        <tr>
                                            <td nowrap="nowrap"><cf_get_lang_main no='1315.Doğum Tarihi'></td>
                                            <td>
                                                <cfinput type="text" name="birthdate" id="birthdate" value="#dateformat(getConsumer.birthdate,dateformat_style)#" maxlength="10" style="width:65px; float:left; margin-right:5px;">
                                                <cf_wrk_date_image date_field="birthdate">
                                            </td>
                                        </tr>
                                    <tr><td colspan="2">&nbsp;</td></tr>
                                    <tr><td colspan="2">&nbsp;</td></tr>
                                    <tr>
                                        <td nowrap="nowrap"><cf_get_lang_main no='140.Şifre'> *</td>
                                        <td>
                                            <cfinput type="password" name="password1" id="password1" style="width:150px;"> (En az 6 karakter)
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><cf_get_lang_main no='162.Şirket'></td>
                                        <td><input type="text" name="company" id="company" tabindex="5" value="<cfoutput>#getConsumer.COMPANY#</cfoutput>" maxlength="100" style="width:150px;"></td>
                                    </tr>
                                    <tr>
                                        <td><cf_get_lang_main no='159.Ünvan'></td>
                                        <td><input  type="text" name="title" id="title" maxlength="50" tabindex="5" value="<cfoutput>#getConsumer.TITLE#</cfoutput>" style="width:150px;"></td>
                                    </tr>
									<tr>
										<td><cf_get_lang_main no="1197.Üye Kategorisi"> *</td>
										<td>
											<select name="conscat_id" id="conscat_id" style="width:150px;">
											<cfoutput query="getConsumerCat">
												<option value="#conscat_id#" <cfif getConsumer.consumer_cat_id eq conscat_id>selected</cfif>>#conscat#</option>
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
                                                    <option value="#country_id#" <cfif getConsumer.HOME_COUNTRY_ID eq country_id>selected</cfif>>#country_name#</option>
                                                </cfoutput>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap="nowrap"><cf_get_lang_main no='559.Şehir'></td>
                                        <td>
                                            <select name="home_city_id" id="home_city_id" style="width:150px;" onChange="LoadCounty(this.value,'home_county_id','consumer_hometelcode')">
                                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                    <cfquery name="GET_CITY_HOME" datasource="#DSN#">
                                                        SELECT
                                                            CITY_ID,
                                                            CITY_NAME 
                                                        FROM 
                                                            SETUP_CITY 
                                                        WHERE 
                                                            COUNTRY_ID = #getConsumer.home_country_id#
                                                        <cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1 and kontrol_zone neq 0>
                                                            AND CITY_ID IN(#kontrol_zone#)
                                                        </cfif>
                                                    </cfquery>
                                                    <cfoutput query="get_city_home">
                                                        <option value="#city_id#" <cfif getConsumer.HOME_CITY_ID eq city_id> selected</cfif>>#city_name#</option>	
                                                    </cfoutput>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap="nowrap"><cf_get_lang_main no='1226.İlçe'></td>
                                        <td>
                                            <select name="home_county_id" id="home_county_id" style="width:150px;">
                                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
												<cfif len(getConsumer.home_city_id) and len(getConsumer.home_county_id)>
													<cfquery name="GET_COUNTY_HOME" datasource="#DSN#">
														SELECT 
															COUNTY_ID,
															COUNTY_NAME
														FROM 
															SETUP_COUNTY 
														WHERE 
															CITY = #getConsumer.home_city_id#
														<cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1 and kontrol_zone neq 0>
															AND CITY IN(#kontrol_zone#)
														</cfif>
													</cfquery>
													<cfoutput query="get_county_home">
														<option value="#county_id#" <cfif getConsumer.home_county_id eq county_id>selected="selected"</cfif>>#county_name#</option>
													</cfoutput>
												</cfif>
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
	function kontrol()
	{
		if(document.getElementById('tc_identity_no').value == "")
		{
			alert("<cf_get_lang_main no='1275.Lütfen tc kimlik numaranızı giriniz'>!");
			return false;
		}
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
			if(!form_warning('mobiltel_2','Cep Telefonu 2 7 Hane Olmalıdır !',7))return false;
			if(!form_warning('consumer_hometel','Ev Telefonu 7 Hane Olmalıdır !',7))return false;
			if(!form_warning('consumer_hometelcode','Ev Telefonu Kodu 3 Hane Olmalıdır !',3))return false;
		</cfif>
					
		if(document.getElementById('password1') != undefined && document.getElementById('password1').value.length>0)
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
