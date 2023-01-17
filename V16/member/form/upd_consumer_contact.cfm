<cf_xml_page_edit fuseact="member.add_consumer_contact" is_multi_page="1">
<cf_get_lang_set module_name="member">
<cfinclude template="../query/get_country.cfm">
<cfquery name="GET_CONTACT" datasource="#DSN#">
	SELECT 
		CONSUMER.CONSUMER_NAME,
		CONSUMER.CONSUMER_SURNAME,
		CONSUMER_BRANCH.IS_COMPANY,
		CONSUMER_BRANCH.*
	FROM
		CONSUMER,
		CONSUMER_BRANCH
	WHERE
		CONSUMER_BRANCH.CONSUMER_ID = CONSUMER.CONSUMER_ID AND
		CONSUMER_BRANCH.CONTACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.contactid#">	
</cfquery>
<cfsavecontent variable="right_">
	<cf_np tablename="CONSUMER_BRANCH"
		primary_key="CONTACT_ID"
		pointer="contactid=#url.contactid#,CID=#attributes.cid#"
		where="CONSUMER_ID=#attributes.cid#">
</cfsavecontent>
<cf_form_box title="Diğer Adres: #get_contact.consumer_name# #get_contact.consumer_surname# / #get_contact.contact_name#" right_images="#right_#">
	<cfform name="upd_consumer_contact" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_upd_contact">
		<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.cid#</cfoutput>">
		<input type="hidden" name="contact_id" id="contact_id" value="<cfoutput>#attributes.contactid#</cfoutput>">				 
		<table border="0" width="100%">
			<tr>
				<td width="90%">
					<table>
						<tr height="22"> 
							<td width="100"><cf_get_lang dictionary_id='29532.Şube Adı'> *</td>
							<td width="185" class="color-row" style="text-align:right">
								<cfsavecontent variable="message2"><cf_get_lang dictionary_id='32300.Adres Adı Girmelisiniz'> !</cfsavecontent>
								<cfinput type="text" name="contact_name" value="#get_contact.contact_name#" required="yes" message="#message2#" maxlength="50" style="width:155px;">
							</td>
							<td rowspan="14" width="20"></td>
							<td colspan="2"  class="color-row">
								<cf_get_lang dictionary_id='57493.Aktif'>&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="checkbox" name="contact_status" id="contact_status" value="1" <cfif get_contact.status eq 1>checked="checked"</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;
								<cf_get_lang dictionary_id='32402.Kurumsal'>&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="checkbox" name="is_company" id="is_company" value="1" <cfif get_contact.is_company eq 1>checked="checked"</cfif> onClick="dis_buttons();">
							</td>
						</tr>
						<tr height="22"> 
							<td><cf_get_lang dictionary_id='30174.Kod/ Telefon'> 1 *</td>
							<td width="55" style="text-align:right" class="color-row">
								<cfinput type="text" name="contact_telcode" value="#get_contact.contact_telcode#" maxlength="5" onKeyUp="isNumber(this);" style="width:55px;">
								<cfinput type="text" name="contact_tel1" value="#get_contact.contact_tel1#" maxlength="10" onKeyUp="isNumber(this);" style="width:90px;">
							</td>
							<cfif len(get_contact.contact_district_id)>
								<cfquery name="GET_HOME_DIST" datasource="#DSN#">
									SELECT DISTRICT_NAME FROM SETUP_DISTRICT WHERE DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_contact.contact_district_id#">
								</cfquery>
								<cfset dis_name = '#get_home_dist.district_name# '>
							<cfelse>
								<cfset dis_name = ''>
							</cfif>
							<td width="100"><cf_get_lang dictionary_id='58762.Vergi Dairesi'> </td>
							<td>
								<cfsavecontent variable="alert"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>: <cf_get_lang dictionary_id='58762.Vergi Dairesi'></cfsavecontent>
								<cfinput type="text" name="tax_office" id="tax_office" maxlength="50" style="width:150px;" tabindex="8" message="#alert#" value="#get_contact.tax_office#">
							</td>
						</tr>
						<tr height="22"> 
							<td><cf_get_lang dictionary_id='57499.Telefon'> 2</td>
							<td style="text-align:right" class="color-row">
								<input type="text" name="contact_tel2" id="contact_tel2" value="<cfoutput>#get_contact.contact_tel2#</cfoutput>" maxlength="10" onKeyUp="isNumber(this);" style="width:90px;">
							</td>
							<td><cf_get_lang dictionary_id='57752.Vergi No'> </td>
							<td><cfsavecontent variable="message1"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57752.Vergi No!'></cfsavecontent>
								<cfinput type="text" name="tax_no" validate="integer" message="#message1#" tabindex="8" maxlength="11" onKeyUp="isNumber(this);" style="width:150px;" value="#get_contact.tax_no#">
							</td>
						</tr>
						<tr height="22"> 
							<td><cf_get_lang dictionary_id='57499.Telefon'> 3</td>
							<td style="text-align:right"><input type="text" name="contact_tel3" id="contact_tel3" value="<cfoutput>#get_contact.contact_tel3#</cfoutput>" maxlength="10" onKeyUp="isNumber(this);" style="width:90px;"></td>
							<cfif is_adres_detail eq 0>
								<td rowspan="3" valign="top"><cf_get_lang dictionary_id='58723.Adres'></td>
								<td rowspan="3" valign="top"><textarea name="contact_address" id="contact_address" style="width:150px;height:65px;"><cfoutput>#dis_name# #get_contact.contact_address#</cfoutput></textarea></td>
							<cfelse>
								<td><cf_get_lang dictionary_id='57472.Posta Kodu'></td>
								<td><input type="text" name="contact_postcode" id="contact_postcode" value="<cfoutput>#get_contact.contact_postcode#</cfoutput>" maxlength="15" onKeyUp="isNumber(this);" style="width:150px;"></td>
							</cfif>
							
						</tr>
						<tr height="22"> 
							<td><cf_get_lang dictionary_id='57488.Fax'></td>
							<td class="color-row" style="text-align:right"><input type="text" name="contact_fax" id="contact_fax" value="<cfoutput>#get_contact.contact_fax#</cfoutput>" maxlength="10" onKeyUp="isNumber(this);" style="width:90px;"></td>
			
							<cfif is_adres_detail eq 1>
								<td><cf_get_lang dictionary_id='58219.Ülke'></td>
								<td>
									<select name="country" id="country"  style="width:150px;" tabindex="6" onChange="LoadCity(this.value,'city_id','county_id',0<cfif is_residence_select eq 1>,'district_id'</cfif>)">
									<option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
									<cfoutput query="get_country">
										<option value="#country_id#" <cfif get_contact.contact_country_id eq country_id>selected</cfif>>#country_name#</option>
									</cfoutput>
									</select>				
								</td>
							</cfif>
						</tr>
						<tr height="22"> 
							<td><cf_get_lang dictionary_id='57428.E-mail'></td>
							<td class="color-row" style="text-align:right"><input type="text" name="contact_email" id="contact_email" value="<cfoutput>#get_contact.contact_email#</cfoutput>" maxlength="100" style="width:150px;"></td>
							<cfif is_adres_detail eq 1>
								<td><cf_get_lang dictionary_id='57971.Şehir'><cfif xml_adres_detail_required eq 1>*</cfif></td>
								<td>
									<select style="width:150px;" name="city_id" id="city_id" onChange="LoadCounty(this.value,'county_id','contact_telcode','0'<cfif is_residence_select eq 1>,'district_id'</cfif>);">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfif len(get_contact.contact_city_id) and len(get_contact.contact_country_id)>
										<cfquery name="GET_CITY_WORK" datasource="#DSN#">
											SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_contact.contact_country_id#">
										</cfquery>
										<cfoutput query="get_city_work">
											<option value="#city_id#"<cfif get_contact.contact_city_id eq city_id> selected</cfif>>#city_name#</option>	
										</cfoutput>
									</cfif>
									</select>
								</td>
							</cfif>
						</tr>
						<tr height="22"> 
							<td><cf_get_lang dictionary_id='57775.Teslim Alan'></td>
							<td width="150" style="text-align:right;"><input type="text" name="contact_delivery_name" id="contact_delivery_name" maxlength="100" style="width:150px;" value="<cfoutput>#get_contact.contact_delivery_name#</cfoutput>"></td>
						
							<cfif is_adres_detail eq 0>
								<td><cf_get_lang dictionary_id='57472.Posta Kodu'></td>
								<td class="color-row"><input type="text" name="contact_postcode" id="contact_postcode" value="<cfoutput>#get_contact.contact_postcode#</cfoutput>" maxlength="5" style="width:150px;"></td>
							<cfelse>
								<td><cf_get_lang dictionary_id='58638.Ilce'><cfif xml_adres_detail_required eq 1> *</cfif></td>
								<td>										
									<select style="width:150px;" name="county_id" id="county_id" <cfif is_residence_select eq 1>onChange="LoadDistrict(this.value,'district_id');"</cfif>>
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfif len(get_contact.contact_county_id)>
										<cfquery name="GET_COUNTY_WORK" datasource="#DSN#">
											SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_contact.contact_city_id#">
										</cfquery>		
										<cfoutput query="get_county_work">
											<option value="#county_id#" <cfif get_contact.contact_county_id eq county_id> selected</cfif>>#county_name#</option>
										</cfoutput>
									</cfif>
									</select>
								</td>
							</cfif>	
						</tr>
						<tr>
							<td rowspan="3" valign="top"><cf_get_lang dictionary_id='57629.Açıklama'></td>
							<td rowspan="3" valign="top" style="text-align:right"><textarea name="contact_detail" id="contact_detail" style="width:150px;height:60px;"><cfoutput>#get_contact.contact_detail#</cfoutput></textarea></td>
							
							<cfif is_adres_detail eq 0>
								<td><cf_get_lang dictionary_id='58219.Ülke'></td>
								<td>
									<select name="country" id="country" style="width:150px;" tabindex="6" onChange="LoadCity(this.value,'city_id','county_id',0)">
									<option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
										<cfoutput query="get_country">
											<option value="#country_id#" <cfif get_contact.contact_country_id eq country_id> selected</cfif>>#country_name#</option>
										</cfoutput>
									</select>				
								</td>
							<cfelse>
								<td><cf_get_lang dictionary_id='58132.Semt'></td>
								<td><input type="text" name="contact_semt" id="contact_semt" value="<cfoutput>#get_contact.contact_semt#</cfoutput>" maxlength="50" style="width:150px;"></td>
							</cfif>
						</tr>
						<tr>
							
							<cfif is_adres_detail eq 0>
								<td><cf_get_lang dictionary_id='57971.Şehir'><cfif xml_adres_detail_required eq 1> *</cfif></td>
								<td style="text-align:right">
									<select style="width:150px;" name="city_id" id="city_id"  onChange="LoadCounty(this.value,'county_id','contact_telcode');">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfif len(get_contact.contact_city_id) and len(get_contact.contact_country_id)>
										<cfquery name="GET_CITY_WORK" datasource="#DSN#">
											SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_contact.contact_country_id#">
										</cfquery>
									<cfoutput query="get_city_work">
										<option value="#city_id#"<cfif get_contact.contact_city_id eq city_id> selected</cfif>>#city_name#</option>	
									</cfoutput>
									</cfif>
									</select>
								</td>
							<cfelse>
								<td><cf_get_lang dictionary_id='58735.Mahalle'><cfif xml_adres_detail_required eq 1> *</cfif></td>
								<td style="text-align:left">
									<cfif is_residence_select eq 0>
										<input type="text" name="district" id="district" style="width:150px;" value="<cfif len(get_contact.contact_district)><cfoutput>#get_contact.contact_district#</cfoutput><cfelse><cfoutput>#dis_name#</cfoutput></cfif>">
									<cfelse>
										<select style="width:150px;" name="district_id" id="district_id">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfif len(get_contact.contact_district_id)>
											<cfquery name="GET_DISTRICT_NAME" datasource="#DSN#">
												SELECT DISTRICT_ID,DISTRICT_NAME FROM SETUP_DISTRICT WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_contact.contact_county_id#">
											</cfquery>										
											<cfoutput query="get_district_name">
												<option value="#district_id#" <cfif get_contact.contact_district_id eq district_id> selected</cfif>>#district_name#</option>
											</cfoutput>
										</cfif>
										</select>
									</cfif>
								</td>									
							</cfif>	
						</tr>
						<tr>
			
							<cfif is_adres_detail eq 0>
								<td><cf_get_lang dictionary_id='58638.Ilce'><cfif xml_adres_detail_required eq 1>*</cfif></td>
								<td style="text-align:right">										
									<select style="width:150px;" name="county_id" id="county_id">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfif len(get_contact.contact_county_id)>
										<cfquery name="GET_COUNTY_WORK" datasource="#DSN#">
											SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_contact.contact_city_id#">
										</cfquery>		
										<cfoutput query="get_county_work">
											<option value="#county_id#" <cfif get_contact.contact_county_id eq county_id> selected</cfif>>#county_name#</option>
										</cfoutput>
									</cfif>
									</select>
								</td>
							<cfelse>
								<td><cf_get_lang dictionary_id='30629.Cadde'></td>
								<td><input type="text" name="main_street" id="main_street" value="<cfoutput>#get_contact.contact_main_street#</cfoutput>" maxlength="50" style="width:150px;"></td>
							</cfif>
						</tr>
						<tr>
							<cfif is_adres_detail eq 1>
								<td valign="top" rowspan="2"><cf_get_lang dictionary_id='30215.Adres Detay'></td>
								<td style="text-align:right" rowspan="2"><textarea name="door_no" id="door_no" style="width:150px;" maxlength="200"><cfoutput>#get_contact.contact_door_no#</cfoutput></textarea></td>
							</cfif>
							<cfif is_adres_detail eq 0>	
								<td><cf_get_lang_main no='720.Semt'></td>
								<td style="text-align:right"><input type="text" name="contact_semt" id="contact_semt" tabindex="6" value="<cfoutput>#get_contact.contact_semt#</cfoutput>" maxlength="30" style="width:150px;"></td>
							<cfelse>
								<td><cf_get_lang dictionary_id='59267.Sokak'></td>
								<td style="text-align:right"><input type="text" name="street" id="street" style="width:150px;" value="<cfoutput>#get_contact.contact_street#</cfoutput>"></td>
							</cfif>
						</tr>
						<tr>
							<td valign="top"><cf_get_lang dictionary_id='58485.Şirket Adı'> </td>
							<td style="text-align:right">
								<cfinput type="text" name="company_name"  id="company_name" style="width:150px;" maxlength="200" value="#get_contact.company_name#"/>
							</td>
			
						</tr>	
					</table>
				</td>
				<td rowspan="10" valign="top" style="text-align:right" width="300"><cf_get_workcube_note action_section='CONSUMER_CONTACT_ID' action_id='#attributes.contactid#'></td>
			</tr>
		</table>
		<cf_form_box_footer>
			<cf_record_info query_name="get_contact">
			<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
		</cf_form_box_footer>	
	</cfform>
</cf_form_box>
<script type="text/javascript">
	<cfif not len(get_contact.contact_county_id)>
		var city_= document.upd_consumer_contact.city_id.value
		if(city_.length)
			LoadCounty(city_,'county_id')
	</cfif>
 	<cfif len(get_contact.contact_country_id) and not len(get_contact.contact_city_id) >
		var country_ = document.upd_consumer_contact.country.value;
		if(country_.length)
			LoadCity(country_,'city_id','county_id',0);
	</cfif>
	function dis_buttons()
	{
		if(document.getElementById('is_company').checked == false)
		{
			document.getElementById('company_name').disabled = true;
			document.getElementById('tax_office').disabled = true;
			document.getElementById('tax_no').disabled = true;
		}
		else
		{
			document.getElementById('company_name').disabled = false;
			document.getElementById('tax_office').disabled = false;
			document.getElementById('tax_no').disabled = false;
		}
	}
	function kontrol()
	{
		if(document.getElementById('is_company').checked == true)
		{
			if(document.getElementById('company_name').value ==  '')
			{
				alert('<cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id="58485.Şirket Adı">');
				return false;
			}
			if(document.getElementById('tax_office').value ==  '')
			{
				alert('<cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id="58762.Vergi Dairesi">');
				return false;
			}
			if(document.getElementById('tax_no').value ==  '')
			{
				alert('<cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id="57752.Vergi No">');
				return false;
			}
		}
		<cfif xml_adres_detail_required eq 1>
			if(document.upd_consumer_contact.city_id[document.upd_consumer_contact.city_id.selectedIndex].value == "") 
			{
				alert("<cf_get_lang dictionary_id ='30499.İl Seçiniz!'>");
				return false;
			}
			if(document.upd_consumer_contact.county_id[document.upd_consumer_contact.county_id.selectedIndex].value == "")
			{
				alert("<cf_get_lang dictionary_id ='30538.İlçe Giriniz!'>");
				return false;
			}
			<cfif is_residence_select eq 0>
			if(document.upd_consumer_contact.district.value == "")
			{
				alert("<cf_get_lang dictionary_id ='30731.Mahalle Giriniz!'>");
				return false;
			}
			<cfelseif is_adres_detail eq 1>
			if(document.upd_consumer_contact.district_id[document.upd_consumer_contact.district_id.selectedIndex].value == "")
			{
				alert("<cf_get_lang dictionary_id ='30731.Mahalle Giriniz!'>");
				return false;
			}
			</cfif>
		</cfif>
		if(document.upd_consumer_contact.contact_address != undefined)
		{
			z = (200 - document.upd_consumer_contact.contact_address.value.length);
			if ( z < 0 )
			{ 
				alert ("<cf_get_lang dictionary_id='58723.Adres'><cf_get_lang dictionary_id='58210.Alanindaki Fazla Karakter Sayisi'>"+ ((-1) * z));
				return false;
			}
		}
		
		z = (100 - document.upd_consumer_contact.contact_detail.value.length);
		if ( z < 0 )
		{ 
			alert ("<cf_get_lang dictionary_id='36199.Açıklama'> "+ ((-1) * z) +" <cf_get_lang dictionary_id='29538.Karakter Uzun'> !");
			return false;
		}
		return true;
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
