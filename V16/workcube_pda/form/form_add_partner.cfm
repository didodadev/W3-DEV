<cfif isdefined('attributes.company_id')>
	<cfset attributes.cpid = attributes.company_id>
	<cfset my_type_url = 0>
<cfelse>
	<cfset my_type_url = 1>
</cfif>
<cfquery name="GET_COMPANY" datasource="#DSN#">
	SELECT 
		COMPANYCAT_ID, 
		COMPANY_TELCODE, 
		COMPANY_TEL1, 
		COMPANY_FAX, 
		HOMEPAGE, 
		COMPANY_ADDRESS, 
		COMPANY_POSTCODE, 
		SEMT, 
		COUNTRY, 
		COUNTY, 
		CITY 
	FROM 
		COMPANY 
	WHERE 
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">
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
		CATEGORY_SITE_DOMAIN._SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#"> AND
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

<table cellpadding="0" cellspacing="0" align="center" style="width:98%">
	<tr style="height:35px;">
		<td class="headbold">Partner Ekle</td>
	</tr>
</table>

<cfform name="add_partner" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=pda.emptypopup_add_partner">
	<table cellpadding="2" cellspacing="1" class="color-border" align="center" style="width:98%">
		<input type="hidden" name="companycat_id" id="companycat_id" value="<cfoutput>#get_company.companycat_id#</cfoutput>">
		<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.cpid#</cfoutput>">
		<input type="hidden" name="my_type_url" id="my_type_url" value="<cfoutput>#my_type_url#</cfoutput>">
		<tr>
			<td class="color-row">
				<table style="width:99%" align="center">
					<tr>
						<td class="infotag" style="width:30%"><cf_get_lang_main no='219.Ad'> *</td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no='219.Ad'></cfsavecontent>
							<cfinput type="text" name="name" id="name" value="" required="yes" message="#message#" maxlength="20" style="width:193px;">
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='1314.Soyad'> *</td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no='1314.Soyad'></cfsavecontent>
							<cfinput type="text" name="soyad" id="soyad" value="" required="yes" message="#message#" maxlength="20" style="width:193px;">
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='1173.Kod'>/ <cf_get_lang_main no='87.Telefon'> *</td>
						<td>
							<cfsavecontent variable="message_kod"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang no="115.Telefon Kodu"></cfsavecontent>
							<cfsavecontent variable="message_tel"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no="87.Telefon"></cfsavecontent>
							<cfinput type="text" name="telcod" id="telcod" value="" onKeyUp="isNumber(this);" onBlur="isNumber(this);" message="#message_kod#" maxlength="6" style="width:64px;" required="yes">
							<cfinput type="text" name="tel" id="tel" value="" onKeyUp="isNumber(this);" onBlur="isNumber(this);" message="#message_tel#" maxlength="10" style="width:118px;" required="yes">
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='139.Kullanıcı Ad'></td>
						<td><cfinput type="text" name="username" id="username" value="" maxlength="15" style="width:193px;"></td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='140.Şifre'></td>
						<td><input type="Password" name="password" id="password" value="" maxlength="16" style="width:193px;"></td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang no="1031.Anlık Mesaj"></td>
						<td>
							<select name="imcat_id" id="imcat_id" style="width:70px;">
								<option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
								<cfoutput query="get_im">
									<option value="#imcat_id#">#imcat#</option> 
								</cfoutput>
							</select>
							<input type="text" name="im" id="im" style="width:118px; vertical-align:top;" maxlength="50">
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='161.Görev'></td>
						<td>
							<select name="mission" id="mission" style="width:200px;">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfoutput query="get_partner_positions">
									<option value="#partner_position_id#">#partner_position#</option>
								</cfoutput>
							</select>
						</td>
					</tr>			
					<tr>
						<td class="infotag">Dahili</td>
						<td>
							<input type="text" name="tel_local" id="tel_local" value="" onKeyUp="isNumber(this);" onBlur="isNumber(this);" maxlength="5" style="margin-left:107px;width:86px;">
						</td>
					</tr>
					<tr>
						
						<td class="infotag"><cf_get_lang_main no='76.Fax'></td>
						<td>
							<input type="text" name="fax" id="fax" value="" onKeyUp="isNumber(this);" onBlur="isNumber(this);" maxlength="10" style="margin-left:107px;width:86px;">
						</td>
					</tr>
					<tr>
						
						<td class="infotag"><cf_get_lang_main no='1173.Kod'> /<cf_get_lang_main no='1070.Mobil Tel'></td>
						<td>
							<select name="mobilcat_id" id="mobilcat_id" style="width:70px;">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfoutput query="get_mobilcat">
									<option value="#mobilcat#">#mobilcat#</option>
								</cfoutput>
							</select>
							<input type="text" name="mobiltel" id="mobiltel" value="" onKeyUp="isNumber(this);" onBlur="isNumber(this);" maxlength="10" style="width:118px; vertical-align:top;">
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='159.Ünvan'></td>
						<td><input type="text" name="title" id="title" maxlength="50" style="width:193px;"></td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='16.e-mail'></td>
						<td><cfsavecontent variable="alert"><cf_get_lang_main no="65.Hatalı Veri"> : <cf_get_lang_main no='16.e-mail'></cfsavecontent>
							<cfinput type="text" name="email" id="email" maxlength="50" validate="email" message="#alert#" style="width:193px;">
						</td>
					</tr>
					<tr>              
						<td class="infotag"><cf_get_lang_main no='160.Departman'></td>
						<td>
							<select name="department" id="department" style="width:200px;">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfoutput query="get_partner_departments">
									<option value="#partner_department_id#">#partner_department#</option>
								</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='667.İnternet'></td>
						<td><cfinput type="text" name="homepage" id="homepage" value="#get_company.homepage#" maxlength="50" style="width:193px;"></td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='41.Şube'></td>
						<td>
							<cfquery name="GET_COMPANY_BRANCH" datasource="#DSN#">
								SELECT COMPBRANCH_ID, COMPBRANCH__NAME FROM COMPANY_BRANCH WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#"> ORDER BY COMPBRANCH__NAME
							</cfquery>
							<select name="compbranch_id" id="compbranch_id" style="width:200px;">
								<option value="0"><cf_get_lang no='27.Merkez Ofis'>
								<cfoutput query="get_company_branch">
									<option value="#compbranch_id#">#compbranch__name#</option> 
								</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='1311.Adres'></td>
						<td>
							<input type="hidden" name="counter" id="counter">
							<textarea name="adres" id="adres" style="width:193px;height:50;"><cfoutput>#get_company.company_address#</cfoutput></textarea>
						</td>
	
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='1584.Dil'>* </td>
						<td>
							<select name="language_id" id="language_id" style="width:200px;">
								<cfoutput query="get_language">
								  <option value="#language_short#">#language_set#</option>
								</cfoutput>
							</select>
					  </td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang no="207.Fotoğraf"></td>
						<td><input type="file" name="photo" id="photo" style="width:150px;"></td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='60.Posta Kodu'></td>
						<td><input type="text" name="postcod" id="postcod" style="width:193px;" onKeyUp="isNumber(this);" maxlength="15" value="<cfoutput>#get_company.company_postcode#</cfoutput>"></td>
	
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='352.Cinsiyet'> *</td>
						<td>
							<select name="sex" id="sex" style="width:200px;">
								<option value="1"><cf_get_lang_main no='1547.Erkek'>
								<option value="2"><cf_get_lang_main no='1546.Kadin'>
							</select>
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='720.Semt'></td>
						<td><input type="text" name="semt" id="semt" value="<cfoutput>#get_company.semt#</cfoutput>" maxlength="45" style="width:193px;"></td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='807.Ülke'></td>
						<td>
							<select name="country" id="country" onChange="LoadCity(this.value,'city','county_id',0);remove_adress('1');" style="width:200px;">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfoutput query="get_country">
									<option value="#country_id#" <cfif get_company.country eq country_id>selected</cfif>>#country_name#</option>
								</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='559.Şehir'></td>
						<td>
							<select name="city_id" id="city_id" style="width:200px;" onChange="LoadCounty(this.value,'county_id','telcod');">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfquery name="GET_CITY" datasource="#DSN#">
									SELECT CITY_ID,CITY_NAME FROM SETUP_CITY <cfif len(get_company.country)>WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.country#"></cfif>ORDER BY CITY_NAME
								</cfquery>
								<cfoutput query="get_city">
									<option value="#city_id#" <cfif get_company.city eq city_id>selected</cfif>>#city_name#</option>
								</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='1226.İlçe'></td>
						<td>
							<cfif len(get_company.county)>
								<cfquery name="GET_COUNTY" datasource="#DSN#">
									SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.county#">
								</cfquery>					
							</cfif>
							<select name="county_id" id="county_id" style="width:200px;">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfquery name="GET_COUNTY" datasource="#DSN#">
									SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY <cfif len(get_company.county)> WHERE  CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.city#"></cfif>
								</cfquery>
								<cfoutput query="get_county">
									<option value="#county_id#" <cfif get_company.county eq county_id>selected</cfif>>#county_name#</option>
								</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="2"><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<br/>
</cfform>

<script type="text/javascript">
	function remove_adress(parametre)
	{
		if(parametre==1)
		{
			document.getElementById('city').value = '';
			document.getElementById('county_id').value = '';
			document.getElementById('country').value = '';
			document.getElementById('telcod').value = '';
		}
		else
		{
			document.getElementById('county_id').value = '';
			document.getElementById('country').value = '';
		}	
	}
	
	function pencere_ac(no)
	{
		x = document.getElementById('country').selectedIndex;
		if (document.getElementById('country')[x].value == "")
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='807.Ülke'>");
		}	
		else if(document.getElementById('city').value)
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1196.İl'>");
		}
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_dsp_county&field_id=add_partner.county_id&field_name=add_partner.county&city_id=' + document.getElementById('city').value,'small');
			return remove_adress();
		}
	}
	
	function reset_level()
	{
		if (td_group.style.display == "none") add_partner.group_id.selectedIndex = 0;
	}
	
	function kontrol ()
	{
		x = (100 - document.getElementById('adres').value.length);
		if ( x < 0)
		{ 
			alert ("Adres Alanindaki Fazla Karakter Sayisi "+ ((-1) * x));
			return false;
		}
		
		
		if ((document.getElementById('password').value != '')  && ( y < 4 ))
		{ 
			alert ("Şifreniz En Az Dört Karakter Olmalıdır!");
			return false;
		}
		
		var obj =  document.getElementById('photo').value;
		if ((obj != "") && !((obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'jpg')   || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4) == 'gif').toLowerCase() || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'png')))
		{
			alert("Lütfen bir resim dosyası(gif,jpg veya png) giriniz!");
			return false;
		}	
		
		if (confirm("Girdiğiniz bilgileri kaydetmek üzeresiniz, Lütfen yeni üye kaydını onaylayın !")) return true; else return false;
	
	}
	document.getElementById('name').focus();
</script>
