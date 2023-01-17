<cfset Get_Country_Info = createObject("component","V16.settings.cfc.setupCountry")>
<cfset Get_Country_Info.dsn = dsn>
<cfset Get_City_Info = createObject("component","V16.settings.cfc.setupCity")>
<cfset Get_City_Info.dsn = dsn>
<cfset Get_County_Info = createObject("component","V16.settings.cfc.setupCounty")>
<cfset Get_County_Info.dsn = dsn>
<cfset Get_District_Info = createObject("component","V16.settings.cfc.setupDistrict")>
<cfset Get_District_Info.dsn = dsn>
<cfquery name="GET_CONSUMER" datasource="#DSN#">
	SELECT 
		CONSUMER.*,
		CONSUMER_CAT.CONSCAT,
		ISNULL(CONSUMER_CAT.IS_PREMIUM,0) IS_PREMIUM
	FROM 
		CONSUMER,
		CONSUMER_CAT
	WHERE 
		CONSUMER_ID = #attributes.cid# AND
		CONSUMER_CAT_ID = CONSCAT_ID
</cfquery>
<cfquery name="GET_CONSUMER_BRANCH" datasource="#DSN#">
	SELECT * FROM CONSUMER_BRANCH WHERE CONSUMER_ID = #attributes.cid# ORDER BY CONTACT_NAME
</cfquery>
	<cfform name="upd_dsp_consumer_address" id="upd_dsp_consumer_address" action="#request.self#?fuseaction=myhome.emptypopup_upd_dsp_consumer_address" method="post">
<cf_ajax_list>
		<table cellspacing="1" cellpadding="2" width="100%" border="0">
			<input type="hidden" name="cons_id" id="cons_id" value="<cfoutput>#attributes.cid#</cfoutput>">
			<tr id="member_adres">
				<td colspan="3">
					<table class="ajax_list">
						<tbody>
						<cfoutput>
						<cfif len(get_consumer.tax_adress)>
								<tr>
									<td width="10%"><b><cf_get_lang dictionary_id='32270.Fatura Adresi'></b></td>
									<td>: 
										<cfif len(get_consumer.tax_district_id)>
											<cfset Get_District = Get_District_Info.getDistrict(district_id:get_consumer.tax_district_id)>
											#Get_District.District_Name#
										</cfif>
										#get_consumer.tax_adress#
										#get_consumer.tax_semt# 
										#get_consumer.tax_postcode# 
										<cfif len(get_consumer.tax_county_id)>
											<cfset Get_County = Get_County_Info.getCounty(county_id:get_consumer.tax_county_id)>
											#Get_County.County_Name#
										</cfif>
										<cfif len(get_consumer.tax_city_id)>
											<cfset Get_City = Get_City_Info.getCity(city_id:get_consumer.tax_city_id)>
											#Get_City.City_Name#
										</cfif>
										<cfif len(get_consumer.tax_country_id)>
											<cfset Get_Country = Get_Country_Info.getCountry(country_id:get_consumer.tax_country_id)>
											#Get_Country.Country_Name#
										</cfif>
									</td>
									<td width="7%">&nbsp;</td>
								</tr>
						</cfif>
						<cfif len(get_consumer.homeaddress)>
								<tr>
									<td width="10%"><b><cf_get_lang dictionary_id='31263.Ev Adresi'>ffffff</b></td>
									<td>: 
										<cfif len(get_consumer.home_district_id)>
											<cfset Get_District = Get_District_Info.getDistrict(district_id:get_consumer.home_district_id)>
											#Get_District.District_Name#
										</cfif>
										#get_consumer.homeaddress#
										#get_consumer.homesemt# 
										#get_consumer.homepostcode# 
										<cfif len(get_consumer.home_county_id)>
											<cfset Get_County = Get_County_Info.getCounty(county_id:get_consumer.home_county_id)>
											#Get_County.County_Name#
										</cfif>
										<cfif len(get_consumer.home_city_id)>
											<cfset Get_City = Get_City_Info.getCity(city_id:get_consumer.home_city_id)>
											#Get_City.City_Name#
										</cfif>
										<cfif len(get_consumer.home_country_id)>
											<cfset Get_Country = Get_Country_Info.getCountry(country_id:get_consumer.home_country_id)>
											#Get_Country.Country_Name#
										</cfif>
									</td>
									<td width="7%" style="text-align:right;"><img src="/images/tel.gif" title="Tel:#get_consumer.consumer_hometelcode#-#get_consumer.consumer_hometel#"></td>
								</tr>
						</cfif>
						<cfif len(get_consumer.workaddress)>
								<tr>
									<td width="10%"><b><cf_get_lang dictionary_id='31991.İş Adresi'></b></td>
									<td>: 
										<cfif len(get_consumer.work_district_id)>
											<cfset Get_District = Get_District_Info.getDistrict(district_id:get_consumer.work_district_id)>
											#Get_District.District_Name#
										</cfif>
										#get_consumer.workaddress#
										#get_consumer.worksemt# 
										#get_consumer.workpostcode# 
										<cfif len(get_consumer.work_county_id)>
											<cfset Get_County = Get_County_Info.getCounty(county_id:get_consumer.work_county_id)>
											#Get_County.County_Name#
										</cfif>
										<cfif len(get_consumer.work_city_id)>
											<cfset Get_City = Get_City_Info.getCity(city_id:get_consumer.work_city_id)>
											#Get_City.City_Name#
										</cfif>
										<cfif len(get_consumer.work_country_id)>
											<cfset Get_Country = Get_Country_Info.getCountry(country_id:get_consumer.work_country_id)>
											#Get_Country.Country_Name#
										</cfif>
									</td>
									<td width="7%" style="text-align:right;"><img src="/images/tel.gif" title="Tel:#get_consumer.consumer_worktelcode#-#get_consumer.consumer_worktel#"></td>
								</tr>
						</cfif>
						</cfoutput>
						<cfoutput query="get_consumer_branch">
								<tr>
									<td width="10%"><b>#contact_name#</b></td>
									<td>: 
										<cfif len(get_consumer_branch.contact_district_id)>
											<cfset Get_District = Get_District_Info.getDistrict(district_id:get_consumer_branch.contact_district_id)>
											#Get_District.District_Name#
										</cfif>
										#get_consumer_branch.contact_address#
										#get_consumer_branch.contact_semt# 
										#get_consumer_branch.contact_postcode# 
										<cfif len(get_consumer_branch.contact_county_id)>
											<cfset Get_County = Get_County_Info.getCounty(county_id:get_consumer_branch.contact_county_id)>
											#Get_County.County_Name#
										</cfif>
										<cfif len(get_consumer_branch.contact_city_id)>
											<cfset Get_City = Get_City_Info.getCity(city_id:get_consumer_branch.contact_city_id)>
											#Get_City.City_Name#
										</cfif>
										<cfif len(get_consumer_branch.contact_country_id)>
											<cfset Get_Country = Get_Country_Info.getCountry(country_id:get_consumer_branch.contact_country_id)>
											#Get_Country.Country_Name#
										</cfif>
									</td>
									<td width="7%" style="text-align:right;">
										<cfif len(contact_email)><a href="mailto:#contact_email#"><img src="/images/mail.gif" title="E-mail:#contact_email#" border="0"></a></cfif>
										<img src="/images/tel.gif"  title="Tel:#contact_telcode#-#contact_tel1#"> &nbsp;
									</td>
								</tr>
						</cfoutput>
						</tbody>
					</table>
				</td>
			</tr>
			<tr id="add_address_t" style="display:none;">
				<td colspan="4">
					<cfoutput>
						<table>
							<tr>
								<td class="txtbold"><cf_get_lang dictionary_id='32299.Yeni Adres'></td>
							</tr>
							<tr> 
								<td><cf_get_lang dictionary_id='32298.Adres Adı'>*</td>
								<td width="185">
									<input type="text" name="contact_name" id="contact_name" maxlength="50" style="width:150px;">
								</td>
							</tr>
							<tr height="20">
								<td width="70"><cf_get_lang dictionary_id='58219.Ülke'></td>
								<td width="180">
									<cfset Get_Country = Get_Country_Info.getCountry()>
									<select name="contact_country" id="contact_country" style="width:150px;" tabindex="6" onChange="LoadCity(this.value,'contact_city_id','contact_county_id',0,'contact_district_id')">
										<option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
										<cfloop query="get_country">
											<option value="#get_country.country_id#" <cfif is_default eq 1>selected</cfif>>#get_country.country_name#</option>
										</cfloop>
									</select>				
								</td>
								<td width="70"><cf_get_lang dictionary_id='32307.Cadde'></td>
								<td width="170"><input type="text" name="contact_main_street" id="contact_main_street" style="width:150px;" value=""></td>
							</tr>
							<tr height="20">
								<td><cf_get_lang dictionary_id='58608.İl'></td>
								<td><select style="width:150px;" name="contact_city_id" id="contact_city_id" onChange="LoadCounty(this.value,'contact_county_id','contact_telcode','0','contact_district_id');">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									</select>
								</td>
								<td><cf_get_lang dictionary_id='32305.Sokak'></td>
								<td><input type="text" name="contact_street" id="contact_street" style="width:150px;" value=""></td>
							</tr>
							<tr height="20">
								<td><cf_get_lang dictionary_id='58638.İlçe'></td>
								<td><select style="width:150px;" name="contact_county_id" id="contact_county_id" onChange="LoadDistrict(this.value,'contact_district_id');">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									</select>
								</td>
								<td valign="top"><cf_get_lang dictionary_id='32306.Adres Detay'></td>
								<td><textarea name="contact_door_no" id="contact_door_no" style="width:150px;" maxlength="200"></textarea></td>
							</tr>
							<tr>
								<td><cf_get_lang dictionary_id='58132.Semt'></td>
								<td><input type="text" name="contact_semt" id="contact_semt" tabindex="6" value="" maxlength="30" style="width:150px;"></td>
								<td><cf_get_lang dictionary_id='57499.Telefon'></td>
								<td>
									<input type="text" tabindex="6" name="contact_telcode" id="contact_telcode" value="" maxlength="3" onkeyup="isNumber(this);" style="width:60px;">
									<input type="text" tabindex="6" name="contact_tel" id="contact_tel" value="" maxlength="7" onkeyup="isNumber(this);" style="width:87px;">
								</td>
							</tr>
							<tr height="20">
								<td><cf_get_lang dictionary_id='58735.Mahalle'></td>
								<td>
									 <select style="width:150px;" name="contact_district_id" id="contact_district_id">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									</select>
								</td>	
								<td colspan="2"><cf_workcube_buttons is_upd='0' is_cancel=0 add_function="kontrol_form()"></td>	
							</tr>
						</table>
					</cfoutput>
				</td>
			</tr>
		</table>
        </cf_ajax_list>
	</cfform>

<script type="text/javascript">
	if(document.upd_dsp_consumer_address.contact_country != undefined)
	{
		var contact_country_ = document.upd_dsp_consumer_address.contact_country.value;
		if(contact_country_.length)
			LoadCity(contact_country_,'contact_city_id','contact_county_id',0);
	}
	function sayfa_getir()
	{
		gizle_goster(add_address_t);
	}
	function kontrol_form()
	{
		if(document.getElementById('add_address_t').style.display == '')
		{
			if(document.upd_dsp_consumer_address.contact_name.value == '')
			{
				alert("<cf_get_lang dictionary_id='32300.Adres Adı Girmelisiniz'>!");
				return false;
			}	
			if(document.upd_dsp_consumer_address.contact_country.value == '')
			{
				alert("<cf_get_lang dictionary_id='32301.Ülke Seçmelisiniz'>!");
				return false;
			}	
			if(document.upd_dsp_consumer_address.contact_city_id.value == '')
			{
				alert("<cf_get_lang dictionary_id='32302.İl Seçmelisiniz'>!");
				return false;
			}
			if(document.upd_dsp_consumer_address.contact_county_id.value == '')
			{
				alert("<cf_get_lang dictionary_id='32303.İlçe Seçmelisiniz'>!");
				return false;
			}
			/*if(document.upd_dsp_consumer_address.contact_district_id.value == '')
			{
				alert("<cf_get_lang no='1546.Mahalle Seçmelisiniz'>!");
				return false;
			}*/
			if(document.upd_dsp_consumer_address.contact_main_street.value == '' && document.upd_dsp_consumer_address.contact_street.value == '')
			{
				alert("<cf_get_lang dictionary_id='32308.Cadde veya Sokak Bilgisi Girmelisiniz'>!");
				return false;
			}
			if(document.upd_dsp_consumer_address.contact_tel.value == '')
			{
				alert("<cf_get_lang dictionary_id='32309.Telefon Numarası Girmelisiniz'>!");
				return false;
			}
		}
	}
</script>
