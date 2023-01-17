<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_country.cfm">
<table align="center" cellpadding="2" cellspacing="1" border="0" class="color-border" style="width:100%; height:100%;">
	<tr>
		<td class="color-row">
        	<table>
            	<tr>
        			<td>
                        <table>
                            <tr>
                                <td width="150"><cf_get_lang no ='1346.Adres Adı'> *</td>
                                <td>
                                    <input type="text" name="contact_name" id="contact_name" maxlength="50" style="width:150px;">
                                </td>
                             </tr>
                             <tr>
                                <td><cf_get_lang_main no='1173.Kod'>/ <cf_get_lang_main no ='87.Telefon '>*</td>
                                <td>
                                    <input type="text" name="contact_telcode" id="contact_telcode" maxlength="5" style="width:50px;"> 
                                    <input type="text" name="contact_tel1" id="contact_tel1" maxlength="10" style="width:96px;"> 
                                </td>
                             </tr>
                             <tr>
                                <td><cf_get_lang_main no='87.Telefon'> 2</td>
                                <td><input type="text" name="contact_tel2" id="contact_tel2" maxlength="10" style="width:150px;"></td>
                             </tr>
                             <tr>
                                <td><cf_get_lang_main no='87.Telefon'> 3</td>
                                <td><input type="text" name="contact_tel3" id="contact_tel3" value="" maxlength="10" style="width:150px;"></td>
                             </tr>
                             <tr>
                                 <td><cf_get_lang_main no='76.Fax'></td>
                                 <td><input type="text" name="contact_fax" id="contact_fax" maxlength="10" style="width:150px;"></td>
                             </tr>
                             <tr>
                                <td><cf_get_lang_main no='16.E-mail'></td>
                                <td><input type="text" name="contact_email" id="contact_email" maxlength="50" style="width:150px;"></td>
                             </tr>
                             <tr>
                                 <td><cf_get_lang_main no='363.Teslim Alan'></td>
                                 <td><input type="text" name="contact_delivery_name" id="contact_delivery_name" maxlength="100" style="width:150px;"></td>
                             </tr>
                             <tr>
                                 <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                                 <td valign="top"><textarea name="contact_detail" id="contact_detail" style="width:150px;height:60px;"></textarea></td>
                             </tr>
                       </table>
            		</td>
           			<td>
                        <table>
                            <tr> 
                                <td width="150"><cf_get_lang_main no='81.Aktif'></td>
                                <td><input type="checkbox" name="contact_status" id="contact_status" value="1" checked="checked"></td>
                            </tr>
                            <tr> 
                                <cfif attributes.is_detail_adres eq 0>
                                    <td rowspan="3" valign="top"><cf_get_lang_main no='1311.Adres'></td>
                                    <td rowspan="3" valign="top"><textarea name="contact_address" id="contact_address" style="width:150px;height:65px;"></textarea></td>
                                <cfelse>
                                    <td><cf_get_lang_main no='60.Posta Kodu'></td>
                                    <td><input type="text" name="contact_postcode" id="contact_postcode" maxlength="5" style="width:150px;"></td>
                                </cfif>
                            </tr>
                            <cfif attributes.is_detail_adres eq 1>
                                <tr> 
                                    <td>Ülke</td>
                                    <td>
                                        <select name="country" id="country" style="width:150px;" onchange="LoadCity(this.value,'city_id','county_id',0<cfif is_residence_select eq 1>,'district_id'</cfif>)">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            <cfoutput query="get_country">
                                                <option value="#country_id#">#country_name#</option>
                                            </cfoutput>
                                        </select>
                                    </td>
                                </tr>
                             </cfif>
                             <cfif attributes.is_detail_adres eq 1>
                                <tr> 
                                    <td><cf_get_lang_main no ='559.Şehir'></td>
                                    <td>
                                        <select name="city_id" id="city_id" style="width:150px;" onchange="LoadCounty(this.value,'county_id','contact_telcode'<cfif is_residence_select eq 1>,'district_id'</cfif>)">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        </select>
                                    </td>
                                </tr>
                            </cfif>
                            <tr> 
                                <cfif attributes.is_detail_adres eq 0>
                                    <td><cf_get_lang_main no='60.Posta Kodu'></td>
                                    <td><input type="text" name="contact_postcode" id="contact_postcode" maxlength="5" style="width:155px;"></td>
                                <cfelse>
                                    <td><cf_get_lang_main no ='1226.İlçe'></td>
                                    <td>
                                        <select name="county_id" id="county_id" style="width:150px;" <cfif is_residence_select eq 1>onChange="LoadDistrict(this.value,'district_id');"</cfif>>
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        </select>
                                    </td>
                                </cfif>
                            </tr>
                            <tr> 
                                <cfif attributes.is_detail_adres eq 0>
                                    <td>Ülke</td>
                                    <td>
                                        <select name="country" id="country" style="width:155px;" onchange="LoadCity(this.value,'city_id','county_id',0)">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            <cfoutput query="get_country">
                                                <option value="#country_id#">#country_name#</option>
                                            </cfoutput>
                                        </select>
                                    </td>
                                <cfelse>
                                    <td><cf_get_lang_main no ='720.Semt'></td>
                                    <td><input type="text" name="contact_semt" id="contact_semt" maxlength="50" style="width:150px;"></td>
                                </cfif>
                            </tr>
                            <tr>
                                <cfif attributes.is_detail_adres eq 0>
                                    <td><cf_get_lang_main no ='559.Şehir'></td>
                                    <td>
                                        <select name="city_id" id="city_id" style="width:155px;" onchange="LoadCounty(this.value,'county_id','contact_telcode')">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        </select>
                                    </td>
                                <cfelse>
                                     <td><cf_get_lang_main no='1323.Mahalle'></td>
                                     <td>
                                        <cfif attributes.is_residence_select eq 0>
                                            <input type="text" name="district" id="district" style="width:150px;" value="">
                                        <cfelse>
                                            <select style="width:155px;" name="district_id" id="district_id">
                                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            </select>
                                        </cfif>
                                    </td>
                                </cfif>
                            </tr>
                            <tr>
                                <cfif attributes.is_detail_adres eq 0>
                                    <td><cf_get_lang_main no ='1226.İlçe'></td>
                                    <td>
                                        <select name="county_id" id="county_id" style="width:155px;">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        </select>
                                    </td>
                                <cfelse>
                                    <td><cf_get_lang no ='1335.Cadde'></td>
                                    <td><input type="text" name="main_street" id="main_street" style="width:150px;" maxlength="50"></td>
                                </cfif>
                            </tr>
                            <tr>
                                <cfif attributes.is_detail_adres eq 0>
                                    <td><cf_get_lang_main no ='720.Semt'></td>
                                    <td><input type="text" name="contact_semt" id="contact_semt" value="" maxlength="30" style="width:155px;" tabindex="4"></td>
                                <cfelse>
                                     <td><cf_get_lang no ='1334.Sokak'></td>
                                     <td><input type="text" name="street" id="street" style="width:150px;" maxlength="50"></td>
                                </cfif>
                            </tr>
                            <cfif attributes.is_detail_adres eq 1>
                                <tr>
                                    <td valign="top">Adres Detay</td>
                                    <td><textarea name="door_no" id="door_no" style="width:150px;" maxlength="200"></textarea></td>
                                </tr>
                            </cfif>
                        </table>
            		</td>
                </tr>
            </table>
		</td>
	</tr>
</table>
