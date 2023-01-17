<cfif isdefined('attributes.company_id')>
	<cfset attributes.cpid = attributes.company_id>
	<cfset my_type_url = 0>
<cfelse>
	<cfif isDefined("session.pp")>
		<cfset attributes.cpid = session.pp.company_id>
	<cfelseif isDefined("session.ww")>
		<cfset attributes.cpid = session.ww.company_id>
	</cfif>
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
<cfquery name="GET_COMPANY_BRANCH" datasource="#DSN#">
	SELECT COMPBRANCH_ID, COMPBRANCH__NAME FROM COMPANY_BRANCH WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#"> ORDER BY COMPBRANCH__NAME
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
<cfquery name="GET_COUNTY" datasource="#DSN#">
	SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY <cfif len(get_company.county)> WHERE  CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.city#"></cfif>
</cfquery>
<cfquery name="GET_CITY" datasource="#DSN#">
	SELECT CITY_ID,CITY_NAME FROM SETUP_CITY <cfif len(get_company.country)>WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.country#"></cfif>ORDER BY CITY_NAME
</cfquery>

<cfform name="add_partner" class="mb-0" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=objects2.emptypopup_add_partner">
	<input type="hidden" name="is_popup" id="is_popup" value="<cfif attributes.fuseaction contains 'popup'>1<cfelse>0</cfif>" />	
	<input type="hidden" name="companycat_id" id="companycat_id" value="<cfoutput>#get_company.companycat_id#</cfoutput>">
	<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.cpid#</cfoutput>">
	<input type="hidden" name="my_type_url" id="my_type_url" value="<cfoutput>#my_type_url#</cfoutput>">
	<div class="card border-0 shadow mt-5">
		<div class="card-body">
			<h6 class="mb-3 header-color"><cf_get_lang dictionary_id='29470.Kullanıcı ekle'></h6>
			<div class="row mx-auto mt-3">
				<div class="col-md-4">
					<div class="form-group mb-3">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='30304.Ad Girmelisiniz'></cfsavecontent>
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57631.Ad'> *</label>
						<cfinput type="text" name="name" id="name" class="form-control" required="yes" message="#message#" maxlength="20">
					</div>
					<div class="form-group mb-3">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='30297.Soyad Girmelisiniz'> !</cfsavecontent>
						<label class="font-weight-bold"><cf_get_lang dictionary_id='58726.Soyad'> *</label>
						<cfinput type="text" name="soyad" id="soyad" class="form-control" required="yes" message="#message#" maxlength="20">
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57551.Kullanıcı Ad'></label>
						<cfinput class="form-control" type="text" name="username" id="username" maxlength="15">
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57552.Şifre'></label>
						<input class="form-control" type="Password" name="password" id="password" maxlength="16">
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57573.Görev'></label>
						<select class="form-control" name="mission" id="mission">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_partner_positions">
								<option value="#partner_position_id#">#partner_position#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57571.Ünvan'></label>
						<input class="form-control" type="text" name="title" id="title" maxlength="50">
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57572.Departman'></label>
						<select class="form-control" name="department" id="department">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_partner_departments">
								<option value="#partner_department_id#">#partner_department#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57453.Şube'></label>
						<select class="form-control" name="compbranch_id" id="compbranch_id">
							<option value="0"><cf_get_lang dictionary_id='34348.Merkez Ofis'>
							<cfoutput query="get_company_branch">
								<option value="#compbranch_id#">#compbranch__name#</option> 
							</cfoutput>
						</select>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='34528.Fotoğraf'></label>
						<input class="form-control" type="file" name="photo" id="photo">
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
						<select class="form-control" name="sex" id="sex">
							<option value="1"><cf_get_lang dictionary_id='58959.Erkek'></option>
							<option value="2"><cf_get_lang dictionary_id='58958.Kadin'></option>
						</select>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='58219.Ülke'></label>
						<select class="form-control" name="country" id="country" onChange="LoadCity(this.value,'city_id','county_id',0);">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_country">
								<option value="#country_id#" <cfif get_company.country eq country_id>selected</cfif>>#country_name#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57971.Şehir'></label>
						<select class="form-control" name="city_id" id="city_id" onChange="LoadCounty(this.value,'county_id','telcod');">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_city">
								<option value="#city_id#" <cfif get_company.city eq city_id>selected</cfif>>#city_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="col-md-4">
					<label class="font-weight-bold"><cf_get_lang dictionary_id='35352.Anlık Mesaj'></label>
					<div class="form-row">
						<div class="form-group mb-3 col-md-6">
							<select class="form-control" name="imcat_id" id="imcat_id">
								<option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_im">
									<option value="#imcat_id#">#imcat#</option> 
								</cfoutput>
							</select>
						</div>
						<div class="form-group col-md-6">
							<input type="text" name="im" id="im" class="form-control" maxlength="50">
						</div>
					</div>
					<label class="font-weight-bold"><cf_get_lang dictionary_id='58585.Kod'>/ <cf_get_lang dictionary_id='57499.Telefon'> *</label>
					<div class="form-row">
						<div class="form-group mb-3 col-md-3">
							<cfsavecontent variable="message_kod"><cf_get_lang dictionary_id='55106.Lütfen Telefon Kodu Giriniz'> !</cfsavecontent>
							<cfinput class="form-control" type="text" name="telcod" id="telcod" value="#get_company.company_telcode#" onKeyUp="isNumber(this);" message="#message_kod#" maxlength="6" required="yes">
						</div>
						<div class="form-group mb-3 col-md-9">
							<cfsavecontent variable="message_tel"><cf_get_lang dictionary_id='34343.Lütfen Telefon Numarası Giriniz'> !</cfsavecontent>
							<cfinput class="form-control" type="text" name="tel" id="tel" value="#get_company.company_tel1#" onKeyUp="isNumber(this);" message="#message_tel#" maxlength="10" required="yes">
						</div>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='34552.Dahili'></label>
						<input class="form-control" type="text" name="tel_local" id="tel_local" onKeyUp="isNumber(this);" maxlength="5" style="width:86px;">
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57488.Fax'></label>
						<input class="form-control" type="text" name="fax" id="fax" value="<cfoutput>#get_company.company_fax#</cfoutput>" onKeyUp="isNumber(this);" maxlength="10">
					</div>
					<label class="font-weight-bold"><cf_get_lang dictionary_id='58585.Kod'> /<cf_get_lang dictionary_id='58482.Mobil Tel'></label>
					<div class="form-row">
						<div class="form-group mb-3 col-md-3">
							<select class="form-control" name="mobilcat_id" id="mobilcat_id">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_mobilcat">
									<option value="#mobilcat#">#mobilcat#</option>
								</cfoutput>
							</select>
						</div>
						<div class="form-group mb-3 col-md-9">
							<input class="form-control" type="text" name="mobiltel" id="mobiltel" value="" onKeyUp="isNumber(this);" maxlength="10">
						</div>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57428.e-mail'></label>
						<cfsavecontent variable="alert"><cf_get_lang dictionary_id='58484.Lütfen geçerli bir e-posta giriniz'> !</cfsavecontent>
						<cfinput class="form-control" type="text" name="email" id="email" maxlength="50" validate="email" message="#alert#">
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='58079.İnternet'></label>
						<cfinput class="form-control" type="text" name="homepage" id="homepage" value="#get_company.homepage#" maxlength="50">
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='58723.Adres'></label>
						<input type="hidden" name="counter" id="counter">
						<textarea class="form-control" name="adres" id="adres"><cfoutput>#get_company.company_address#</cfoutput></textarea>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
						<input class="form-control" type="text" name="postcod" id="postcod" onKeyUp="isNumber(this);" maxlength="15" value="<cfoutput>#get_company.company_postcode#</cfoutput>">
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='58132.Semt'></label>
						<input class="form-control" type="text" name="semt" id="semt" value="<cfoutput>#get_company.semt#</cfoutput>" maxlength="45">
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='58638.İlçe'></label>
						<select class="form-control" name="county_id" id="county_id">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_county">
								<option value="#county_id#" <cfif get_company.county eq county_id>selected</cfif>>#county_name#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='58996.Dil'>*</label>
						<select class="form-control" name="language_id" id="language_id">
							<cfoutput query="get_language">
								<option value="#language_short#">#language_set#</option>
							</cfoutput>
						</select>
					</div>
				</div>
			</div>
			<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
		</div>
	</div>
</cfform>

<script type="text/javascript">
	
	function kontrol()
	{
		x = (100 - document.getElementById('adres').value.length);
		if ( x < 0)
		{ 
			alert ("<cf_get_lang dictionary_id='58723.Adres'><cf_get_lang dictionary_id='58210.Alanindaki Fazla Karakter Sayisi'>"+ ((-1) * x));
			return false;
		}
		
		y = document.getElementById('password').value.length;
		if ((document.getElementById('password').value == '') || ((document.getElementById('password').value != '') && ( y < 4 )))
		{
			alert ("<cf_get_lang dictionary_id='34837.Şifreniz En Az Dört Karakter Olmalıdır'>");
			return false;
		}
		
		var obj =  document.getElementById('photo').value;
		if ((obj != "") && !((obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'jpg')   || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4) == 'gif').toLowerCase() || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'png')))
		{
			alert("<cf_get_lang dictionary_id='34836.Lütfen bir resim dosyası(gif,jpg veya png) giriniz'>!");
			return false;
		}
		
		if (confirm("<cf_get_lang dictionary_id='34849.Girdiğiniz bilgileri kaydetmek üzeresiniz, Lütfen yeni üye kaydını onaylayın'> !")) return true; else return false;
	
	}

	document.getElementById('name').focus();
</script>
