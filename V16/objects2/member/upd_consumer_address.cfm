<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_country.cfm">
<cfquery name="GET_CONTACT" datasource="#DSN#">
	SELECT 
		CONSUMER.CONSUMER_NAME,
		CONSUMER.CONSUMER_SURNAME,
		CONSUMER_BRANCH.STATUS,
        CONSUMER_BRANCH.CONTACT_NAME,
        CONSUMER_BRANCH.CONTACT_TELCODE,
        CONSUMER_BRANCH.CONTACT_TEL1,
        CONSUMER_BRANCH.CONTACT_TEL3,
        CONSUMER_BRANCH.CONTACT_POSTCODE,
        CONSUMER_BRANCH.CONTACT_ADDRESS,
        CONSUMER_BRANCH.CONTACT_DISTRICT_ID,
        CONSUMER_BRANCH.CONTACT_DISTRICT,
        CONSUMER_BRANCH.CONTACT_TEL2,
        CONSUMER_BRANCH.CONTACT_FAX,
        CONSUMER_BRANCH.CONTACT_POSTCODE,
        CONSUMER_BRANCH.CONTACT_COUNTRY_ID,
        CONSUMER_BRANCH.CONTACT_CITY_ID,
        CONSUMER_BRANCH.CONTACT_COUNTY_ID,
        CONSUMER_BRANCH.CONTACT_POSTCODE,
        CONSUMER_BRANCH.CONTACT_EMAIL,
        CONSUMER_BRANCH.CONTACT_SEMT,
        CONSUMER_BRANCH.CONTACT_DETAIL,
        CONSUMER_BRANCH.CONTACT_STREET,
        CONSUMER_BRANCH.CONTACT_MAIN_STREET,
        CONSUMER_BRANCH.CONTACT_DOOR_NO,
        CONSUMER_BRANCH.CONTACT_DELIVERY_NAME                
	FROM
		CONSUMER,
		CONSUMER_BRANCH
	WHERE
		CONSUMER_BRANCH.CONSUMER_ID = CONSUMER.CONSUMER_ID AND
		CONSUMER_BRANCH.CONTACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.address_id#">
</cfquery>
<table align="center" cellpadding="2" cellspacing="1" border="0" class="color-border" style="width:100%;">
    <tr> 
		<td class="color-row">				 
			<table>
				<tr style="height:22px;"> 
					<td style="width:25%;"><cf_get_lang no ='1346.Adres Adı'> *</td>
					<td colspan="2" class="color-row" style="width:25%;">
						<input type="text" name="contact_name<cfoutput>#attributes.row_id#</cfoutput>" id="contact_name<cfoutput>#attributes.row_id#</cfoutput>" value="<cfoutput>#get_contact.contact_name#</cfoutput>" maxlength="50" style="width:150px;">
					</td>
                    <td style="width:25%;"><cf_get_lang_main no='81.Aktif'></td>
                    <td class="color-row"><input type="checkbox" name="contact_status<cfoutput>#attributes.row_id#</cfoutput>" id="contact_status<cfoutput>#attributes.row_id#</cfoutput>" <cfif get_contact.status eq 1>checked</cfif>></td>
				</tr>
                <tr style="height:22px;"> 
                    <td><cf_get_lang_main no ='1173.Kod'>/<cf_get_lang_main no='87.Telefon'>1 *</td>
                    <td class="color-row">
                      <input type="text" name="contact_telcode<cfoutput>#attributes.row_id#</cfoutput>" id="contact_telcode<cfoutput>#attributes.row_id#</cfoutput>" value="<cfoutput>#get_contact.contact_telcode#</cfoutput>" maxlength="5" style="width:45px;">
                    </td>
                    <td class="color-row"> 
                      <input type="text" name="contact_tel1<cfoutput>#attributes.row_id#</cfoutput>" id="contact_tel1<cfoutput>#attributes.row_id#</cfoutput>" value="<cfoutput>#get_contact.contact_tel1#</cfoutput>"  maxlength="10" style="width:98px;"> 
                    </td>
                    <cfif len(get_contact.contact_district_id)>
                        <cfquery name="GET_HOME_DIST" datasource="#DSN#">
                            SELECT DISTRICT_NAME FROM SETUP_DISTRICT WHERE DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_contact.contact_district_id#">
                        </cfquery>
                        <cfset dis_name = '#get_home_dist.district_name# '>
                    <cfelse>
                        <cfset dis_name = ''>
                    </cfif>
                    <cfif attributes.is_detail_adres eq 0>
                        <td rowspan="3" style="vertical-align:top;"><cf_get_lang_main no='1311.Adres'></td>
                        <td rowspan="3" style="vertical-align:top;"><textarea name="contact_address<cfoutput>#attributes.row_id#</cfoutput>" id="contact_address<cfoutput>#attributes.row_id#</cfoutput>" style="width:150px;height:65px;"><cfoutput>#dis_name# #get_contact.contact_address#</cfoutput></textarea></td>
                    <cfelse>
                        <td><cf_get_lang_main no='60.Posta Kodu'></td>
                        <td><input type="text" name="contact_postcode<cfoutput>#attributes.row_id#</cfoutput>" id="contact_postcode<cfoutput>#attributes.row_id#</cfoutput>" value="<cfoutput>#get_contact.contact_postcode#</cfoutput>" maxlength="15" style="width:150px;"></td>
                    </cfif>
                </tr>
                <tr style="height:22px;"> 
                    <td><cf_get_lang_main no='87.Telefon'> 2</td>
                    <td class="color-row"></td>
                    <td class="color-row">
                      <input type="text" name="contact_tel2<cfoutput>#attributes.row_id#</cfoutput>" id="contact_tel2<cfoutput>#attributes.row_id#</cfoutput>" value="<cfoutput>#get_contact.contact_tel2#</cfoutput>" maxlength="10" style="width:98px;">
                     </td>
                     <cfif attributes.is_detail_adres eq 1>
                        <td><cf_get_lang_main no='807.Ülke'></td>
                        <td><select name="country<cfoutput>#attributes.row_id#</cfoutput>" id="country<cfoutput>#attributes.row_id#</cfoutput>" style="width:150px;" tabindex="6" onchange="LoadCity(this.value,'city_id<cfoutput>#attributes.row_id#</cfoutput>','county_id<cfoutput>#attributes.row_id#</cfoutput>',0<cfif attributes.is_residence_select eq 1>,'district_id<cfoutput>#attributes.row_id#</cfoutput>'</cfif>)">
                                <option value=""><cf_get_lang no='180.seçiniz'></option>
                                <cfoutput query="get_country">
                                    <option value="#country_id#" <cfif get_contact.contact_country_id eq country_id>selected</cfif>>#country_name#</option>
                                </cfoutput>
                            </select>				
                        </td>
                    </cfif>
                </tr>
                <tr style="height:22px;"> 
                    <td><cf_get_lang_main no='87.Telefon'> 3</td>
                    <td class="color-row"></td>
                    <td><input type="text" name="contact_tel3<cfoutput>#attributes.row_id#</cfoutput>" id="contact_tel3<cfoutput>#attributes.row_id#</cfoutput>" value="<cfoutput>#get_contact.contact_tel3#</cfoutput>" maxlength="10" style="width:98px;"></td>
                    <cfif attributes.is_detail_adres eq 1>
                        <td><cf_get_lang_main no ='559.Şehir'></td>
                        <td>
                            <select name="city_id<cfoutput>#attributes.row_id#</cfoutput>" id="city_id<cfoutput>#attributes.row_id#</cfoutput>" onchange="LoadCounty(this.value,'county_id<cfoutput>#attributes.row_id#</cfoutput>','contact_telcode<cfoutput>#attributes.row_id#</cfoutput>','0'<cfif attributes.is_residence_select eq 1>,'district_id<cfoutput>#attributes.row_id#</cfoutput>'</cfif>);" style="width:150px;">
                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfif len(get_contact.contact_city_id) and len(get_contact.contact_country_id)>
                                    <cfquery name="GET_CITY_WORK" datasource="#DSN#">
                                        SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_contact.contact_country_id#">
                                    </cfquery>
                                    <cfoutput query="get_city_work">
                                        <option value="#city_id#"<cfif get_contact.contact_city_id eq city_id>selected</cfif>>#city_name#</option>	
                                    </cfoutput>
                                </cfif>
                            </select>
                        </td>
                    </cfif>
                </tr>
                <tr style="height:22px;"> 
                    <td><cf_get_lang_main no='76.Fax'></td>
                    <td class="color-row"></td>
                    <td class="color-row"><input type="text" name="contact_fax<cfoutput>#attributes.row_id#</cfoutput>" id="contact_fax<cfoutput>#attributes.row_id#</cfoutput>" value="<cfoutput>#get_contact.contact_fax#</cfoutput>" maxlength="10" style="width:98px;"></td>
                    <cfif attributes.is_detail_adres eq 0>
                        <td><cf_get_lang_main no='60.Posta Kodu'></td>
                        <td class="color-row"><input type="text" name="contact_postcode<cfoutput>#attributes.row_id#</cfoutput>" id="contact_postcode<cfoutput>#attributes.row_id#</cfoutput>" value="<cfoutput>#get_contact.contact_postcode#</cfoutput>" maxlength="5" style="width:150px;"></td>
                    <cfelse>
                        <td><cf_get_lang_main no='1226.İlçe'></td>
                        <td>										
                            <select name="county_id<cfoutput>#attributes.row_id#</cfoutput>" id="county_id<cfoutput>#attributes.row_id#</cfoutput>" style="width:150px;" <cfif attributes.is_residence_select eq 1>onChange="LoadDistrict(this.value,'district_id<cfoutput>#attributes.row_id#</cfoutput>');"</cfif>>
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfif len(get_contact.contact_county_id)>
                                    <cfquery name="GET_COUNTY_WORK" datasource="#DSN#">
                                        SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_contact.contact_city_id#">
                                    </cfquery>		
                                    <cfoutput query="get_county_work">
                                        <option value="#county_id#" <cfif get_contact.contact_county_id eq county_id>selected</cfif>>#county_name#</option>
                                    </cfoutput>
                                </cfif>
                            </select>
                        </td>
                    </cfif>
                </tr>
                <tr style="height:22px;"> 
                    <td><cf_get_lang_main no='16.E-mail'></td>
                    <td colspan="2" class="color-row"><input type="text" name="contact_email<cfoutput>#attributes.row_id#</cfoutput>" id="contact_email<cfoutput>#attributes.row_id#</cfoutput>" value="<cfoutput>#get_contact.contact_email#</cfoutput>" maxlength="50" style="width:150px;"></td>
                    <cfif attributes.is_detail_adres eq 0>
                        <td><cf_get_lang_main no='807.Ülke'></td>
                        <td>
                            <select name="country<cfoutput>#attributes.row_id#</cfoutput>" id="country<cfoutput>#attributes.row_id#</cfoutput>" style="width:150px;" tabindex="6" onchange="LoadCity(this.value,'city_id<cfoutput>#attributes.row_id#</cfoutput>','county_id<cfoutput>#attributes.row_id#</cfoutput>',0)">
                                <option value=""><cf_get_lang no='180.seçiniz'></option>
                                <cfoutput query="get_country">
                                    <option value="#country_id#" <cfif get_contact.contact_country_id eq country_id>selected</cfif>>#country_name#</option>
                                </cfoutput>
                            </select>				
                        </td>
                    <cfelse>
                        <td><cf_get_lang_main no='720.Semt'></td>
                        <td><input type="text" name="contact_semt<cfoutput>#attributes.row_id#</cfoutput>" id="contact_semt<cfoutput>#attributes.row_id#</cfoutput>" value="<cfoutput>#get_contact.contact_semt#</cfoutput>" maxlength="50" style="width:150px;"></td>
                    </cfif>
                </tr>
                <tr style="height:22px;"> 
                    <td><cf_get_lang_main no='363.Teslim Alan'></td>
                    <td colspan="2"><input type="text" name="contact_delivery_name<cfoutput>#attributes.row_id#</cfoutput>" id="contact_delivery_name<cfoutput>#attributes.row_id#</cfoutput>" maxlength="100" style="width:150px;" value="<cfoutput>#get_contact.contact_delivery_name#</cfoutput>"></td>
                    <cfif attributes.is_detail_adres eq 0>
                        <td><cf_get_lang_main no ='559.Şehir'></td>
                        <td>
                            <select name="city_id<cfoutput>#attributes.row_id#</cfoutput>" id="city_id<cfoutput>#attributes.row_id#</cfoutput>" onchange="LoadCounty(this.value,'county_id<cfoutput>#attributes.row_id#</cfoutput>','<cfoutput>#attributes.row_id#</cfoutput>');" style="width:150px;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfif len(get_contact.contact_city_id) and len(get_contact.contact_country_id)>
                                    <cfquery name="GET_CITY_WORK" datasource="#DSN#">
                                        SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_contact.contact_country_id#">
                                    </cfquery>
                                    <cfoutput query="GET_CITY_WORK">
                                        <option value="#city_id#"<cfif get_contact.contact_city_id eq city_id>selected</cfif>>#city_name#</option>	
                                    </cfoutput>
                                </cfif>
                            </select>
                        </td>
                    <cfelse>
                        <td><cf_get_lang_main no='1323.Mahalle'></td>
                        <td>
                            <cfif attributes.is_residence_select eq 0>
                                <input type="text" name="district<cfoutput>#attributes.row_id#</cfoutput>" id="district<cfoutput>#attributes.row_id#</cfoutput>" style="width:150px;" value="<cfif len(get_contact.contact_district)><cfoutput>#get_contact.contact_district#</cfoutput><cfelse><cfoutput>#dis_name#</cfoutput></cfif>">
                            <cfelse>
                                 <select name="district_id<cfoutput>#attributes.row_id#</cfoutput>" id="district_id<cfoutput>#attributes.row_id#</cfoutput>" style="width:150px;">
                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                    <cfif len(get_contact.contact_district_id)>
                                        <cfquery name="GET_DISTRICT_NAME" datasource="#DSN#">
                                            SELECT DISTRICT_ID, DISTRICT_NAME FROM SETUP_DISTRICT WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_contact.contact_county_id#">
                                        </cfquery>										
                                        <cfoutput query="get_district_name">
                                            <option value="#district_id#" <cfif get_contact.contact_district_id eq district_id>selected</cfif>>#district_name#</option>
                                        </cfoutput>
                                    </cfif>
                                </select>
                            </cfif>
                        </td>									
                    </cfif>				
                </tr>
                <tr>
                    <td rowspan="3" style="vertical-align:top;"><cf_get_lang_main no='217.Açıklama'></td>
                    <td colspan="2" rowspan="3" style="vertical-align:top;"><textarea name="contact_detail<cfoutput>#attributes.row_id#</cfoutput>" id="contact_detail<cfoutput>#attributes.row_id#</cfoutput>" style="width:150px;height:60px;"><cfoutput>#get_contact.contact_detail#</cfoutput></textarea></td>
                    <cfif attributes.is_detail_adres eq 0>
                        <td><cf_get_lang_main no='1226.İlçe'></td>
                        <td>										
                            <select name="county_id<cfoutput>#attributes.row_id#</cfoutput>" id="county_id<cfoutput>#attributes.row_id#</cfoutput>" style="width:150px;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfif len(get_contact.contact_county_id)>
                                    <cfquery name="GET_COUNTY_WORK" datasource="#DSN#">
                                        SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_contact.contact_city_id#">
                                    </cfquery>		
                                    <cfoutput query="get_county_work">
                                        <option value="#county_id#" <cfif get_contact.contact_county_id eq county_id>selected</cfif>>#county_name#</option>
                                    </cfoutput>
                                </cfif>
                            </select>
                        </td>
                    <cfelse>
                        <td><cf_get_lang no ='1335.Cadde'></td>
                        <td><input type="text" name="main_street<cfoutput>#attributes.row_id#</cfoutput>" id="main_street<cfoutput>#attributes.row_id#</cfoutput>" style="width:150px;" value="<cfoutput>#get_contact.contact_main_street#</cfoutput>"></td>
                    </cfif>
                </tr>
                <tr>
                    <cfif attributes.is_detail_adres eq 0>	
                        <td><cf_get_lang_main no='720.Semt'></td>
                        <td><input type="text" name="contact_semt<cfoutput>#attributes.row_id#</cfoutput>" id="contact_semt<cfoutput>#attributes.row_id#</cfoutput>" value="<cfoutput>#get_contact.contact_semt#</cfoutput>" maxlength="30" style="width:150px;"></td>
                    <cfelse>
                        <td><cf_get_lang no ='1334.Sokak'></td>
                        <td><input type="text" name="street<cfoutput>#attributes.row_id#</cfoutput>" id="street<cfoutput>#attributes.row_id#</cfoutput>" style="width:150px;" value="<cfoutput>#get_contact.contact_street#</cfoutput>"></td>
                    </cfif>
                </tr>
                <cfif attributes.is_detail_adres eq 1>
                    <tr>
                        <td style="vertical-align:top;"><cf_get_lang no='1638.Adres Detay'></td>
                        <td><textarea name="door_no<cfoutput>#attributes.row_id#</cfoutput>" id="door_no<cfoutput>#attributes.row_id#</cfoutput>" style="width:150px;"  maxlength="200"><cfoutput>#get_contact.contact_door_no#</cfoutput></textarea></td>
                    </tr>
                </cfif>
			</table>
		</td>
    </tr>
</table>
<cfabort>
