<cfset attributes.company_id = url.compid>
<cfinclude template="../query/get_company.cfm">
<cfinclude template="../query/get_company_cat.cfm">
<cfinclude template="../query/get_im.cfm">
<cfinclude template="../query/get_mobilcat.cfm">
<cfinclude template="../query/get_language.cfm">
<cfinclude template="../query/get_partner_positions.cfm">
<cfinclude template="../query/get_partner_departments.cfm">
<cfinclude template="../query/get_country.cfm">
<cfquery name="GET_COMPANY_BRANCH" datasource="#DSN#">
	SELECT 
		COMPBRANCH_ID,
		COMPBRANCH__NAME 
	FROM 
		COMPANY_BRANCH 
	WHERE 
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.compid#">
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='32892.Kişi Ekle'></cfsavecontent>
	<cf_box title="#message#:#get_company.fullname#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="form_add_partner" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_partner">
			<cf_box_elements>
				<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#url.compid#</cfoutput>">
				<input type="hidden" name="companycat_id" id="companycat_id" value="<cfoutput>#get_company.companycat_id#</cfoutput>">
				<div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57631.Ad'>*</label>
						<div class="col col-8 col-xs-12">	
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='32401.Adı girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="name" required="yes" message="#message#" maxlength="20" style="width:150px;">
						</div>
					</div>
					<div class="form-group" id="item-soyad">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58726.Soyad'>*</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='29503.Soyad Girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="soyad" required="yes" message="#message#" maxlength="20" style="width:150px;">
						</div>
					</div>
					<div class="form-group" id="item-username">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57551.Kullanıcı Adı'></label>
						<div class="col col-8 col-xs-12">
							<cfinput  type="text" name="username" maxlength="8" style="width:150px;">
						</div>
					</div>
					<div class="form-group" id="item-password">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57552.Şifre'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="Password" name="password" maxlength="16" style="width:150px;">
						</div>
					</div>
					<div class="form-group" id="item-department">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
						<div class="col col-8 col-xs-12">
							<select name="department" id="department" style="width:150px;">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_partner_departments">
								<option value="#partner_department_id#">#partner_department#</option>
							</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-mission">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57573.Görev'></label>
						<div class="col col-8 col-xs-12">
							<select name="mission" id="mission" style="width:150px;">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_partner_positions">
								<option value="#partner_position_id#">#partner_position#</option>
							</cfoutput>
							</select>			
						</div>
					</div>
					<div class="form-group" id="item-title">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57571.Ünvan'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="title" id="title" maxlength="50" style="width:150px;">
						</div>
					</div>
					<div class="form-group" id="item-compbranch_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
						<div class="col col-8 col-xs-12">
							<select name="compbranch_id" id="compbranch_id" style="width:150px;" onchange="kontrol_et(this.value);">
							<option value="0"><cf_get_lang dictionary_id='32980.Merkez Ofis'></option>
							<cfoutput query="get_company_branch">
								<option value="#compbranch_id#">#compbranch__name#</option>
							</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-language_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58996.Dil'>*</label>
						<div class="col col-8 col-xs-12">
							<select name="language_id" id="language_id" style="width:150px;">
							<cfoutput query="get_language">
								<option value="#language_short#">#language_set#</option>
							</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-photo">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32896.Fotoğraf Ekle'></label>
						<div class="col col-8 col-xs-12">
							<input type="file" name="photo" id="photo" style="width:150px;">
						</div>
					</div>
					<div class="form-group" id="item-sex">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32872.Cinsiyeti'></label>
						<div class="col col-8 col-xs-12">		
							<select name="sex" id="sex" style="width:150px;">
								<option value="1"><cf_get_lang dictionary_id='58959.Erkek'></option>
								<option value="0"><cf_get_lang dictionary_id='58958.Kadın'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-adres">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58723.Adres'></label>
						<div class="col col-8 col-xs-12"> 
							<textarea name="adres" id="adres" style="width:150px;height:50;"><cfoutput>#get_company.company_address#</cfoutput></textarea>
						</div>
					</div>
				</div>
				<div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-imcat_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32891.Instant Message'></label>
							<div class="col col-3 col-xs-12">	
								<select name="imcat_id" id="imcat_id" style="width:60px;">
									<option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_im">
									<option value="#imcat_id#">#imcat#</option>
								</cfoutput>
								</select>
							</div>
						<div class="col col-5 col-xs-12">	
							<input type="text" name="im" id="im" maxlength="50" style="width:85px;">
						</div>
					</div>
					<div class="form-group" id="item-telcod">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32851.Kod/ Telefon'></label>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='32438.Kod/ Telefon girmelisiniz'></cfsavecontent>
						<div class="col col-3 col-xs-12">
							<cfinput type="text" name="telcod" value="#get_company.company_telcode#" validate="integer" message="#message#" maxlength="6" style="width:60px;">
						</div>
						<div class="col col-5 col-xs-12">
							<cfinput type="text" name="tel" value="#get_company.company_tel1#" validate="integer" message="#message#" maxlength="9" style="width:86px;">
						</div>
					</div>
						<div class="form-group" id="item-tel_local" cellpadding="0" cellspacing="0">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32894.Dahili Telefon'></label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='32439.Dahili Telefon Girmelisiniz'></cfsavecontent>
								<cfinput validate="integer" message="#message#" type="text" name="tel_local" maxlength="5" style="width:86px;">
							</div>
						</div>
						<div class="form-group" id="item-password" cellpadding="0" cellspacing="0">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57488.Fax'></label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='32442.Fax Girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="fax" value="#get_company.company_fax#" validate="integer" message="#message#" maxlength="9" style="width:86px;">
							</div>
						</div> 
						<div class="form-group" id="item-mobilcat_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58482.Mobil Kod/Mobil'></label>
							<div class="col col-3 col-xs-12">
								<select name="mobilcat_id" id="mobilcat_id"  style="width:60px;">
								<option value=""><cf_get_lang dictionary_id='57734.Seç'>
								<cfoutput query="get_mobilcat">
									<option value="#mobilcat#">#mobilcat#</option>
								</cfoutput>
								</select>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58482.Mobil Kod/Mobil Girmelisiniz'></cfsavecontent>
							</div>
							<div class="col col-5 col-xs-12">	
								<cfinput type="text" name="mobiltel"  value="" validate="integer" message="#message#" maxlength="9" style="width:86px;">
							</div>
						</div>
						<div class="form-group" id="item-email">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57428.e-mail'></label>
							<div class="col col-8 col-xs-12">
								<input  type="text" name="email" id="email" maxlength="50" style="width:150px;">
							</div>
						</div>	
						
						<div class="form-group" id="item-homepage">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32481.İnternet'></label>
							<div class="col col-8 col-xs-12">
								<cfinput  type="text" name="homepage" value="#get_company.homepage#" maxlength="50" style="width:150px;">
							</div>
						</div>
						<div class="form-group" id="item-postcod">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
							<div class="col col-8 col-xs-12">
								<cfinput type="text" name="postcod" value="#get_company.company_postcode#" maxlength="15" style="width:150px;">
							</div>
						</div>
						<div class="form-group" id="item-semt">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58132.Semt'></label>
							<div class="col col-8 col-xs-12">
								<cfinput type="text" name="semt" value="#get_company.semt#" maxlength="45" style="width:150px;">
							</div>
						</div>	
						<div class="form-group" id="item-county_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58638.Ilce'></label>
							<div class="col col-8 col-xs-12">
								<select name="county_id" id="county_id" style="width:150px;" onChange="LoadDistrict(this.value,'district_id');">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfquery name="GET_COUNTY" datasource="#DSN#">
											SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY <cfif len(get_company.city)>WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.city#"></cfif>
										</cfquery>
										<cfoutput query="get_county">
									<option value="#county_id#" <cfif get_company.county eq county_id>selected</cfif>>#county_name#</option>
										</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-city_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57971.Şehir'></label>
							<div class="col col-8 col-xs-12">
								<select name="city_id" id="city_id" style="width:150px;" onchange="LoadCounty(this.value,'county_id','telcod')">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfquery name="GET_CITY" datasource="#DSN#">
										SELECT CITY_ID,CITY_NAME FROM SETUP_CITY <cfif len(get_company.country)>WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.country#"></cfif>
									</cfquery>
									<cfoutput query="GET_CITY">
										<option value="#city_id#" <cfif get_company.city eq city_id>selected</cfif>>#city_name#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-city_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
							<div class="col col-8 col-xs-12">
								<select name="country" id="country" style="width:150px;" onchange="LoadCity(this.value,'city_id','county_id',0)">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_country">
									<option value="#country_id#" <cfif get_company.country eq country_id>selected</cfif>>#country_name#</option>
								</cfoutput>
								</select>
							</div>
						</div>
				</div>
			</cf_box_elements>
			
			<cf_box_footer>
				<cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function remove_adress(parametre)
{
	if(parametre==1)
	{
		document.form_add_partner.city_id.value = '';
		document.form_add_partner.city.value = '';
		document.form_add_partner.county_id.value = '';
		document.form_add_partner.county.value = '';
		document.form_add_partner.telcod.value = '';
	}
	else
	{
		document.form_add_partner.county_id.value = '';
		document.form_add_partner.county.value = '';
	}	
}
/*
function pencere_ac(no)
{
	x = document.form_add_partner.country.selectedIndex;
	if (document.form_add_partner.country[x].value == "")
	{
		alert("<cf_get_lang no='679.İlk Olarak Ülke Seçiniz'>.");
	}	
	else if(document.form_add_partner.city_id.value == "")
	{
		alert("<cf_get_lang no='786.İl Seçiniz'> !");
	}
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=form_add_partner.county_id&field_name=form_add_partner.county&city_id=' + document.form_add_partner.city_id.value,'small');
		return remove_adress();
	}
}

function pencere_ac_city()
{
	x = document.form_add_partner.country.selectedIndex;
	if (document.form_add_partner.country[x].value == "")
	{
		alert("<cf_get_lang no='679.İlk Olarak Ülke Seçiniz'>.");
	}	
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=form_add_partner.city_id&field_name=form_add_partner.city&field_phone_code=form_add_partner.telcod&country_id=' + document.form_add_partner.country.value,'small');
	}
	return remove_adress('2');
}
*/
/*function reset_level()
{
	if (td_group.style.display == "none")
	{
		form_add_partner.GROUP_ID.selectedIndex = 0;
	}
}*/


function kontrol_et(compbranch_id)
	{
		if(compbranch_id == 0)
		{
			get_comp_branch = wrk_safe_query("mr_get_comp_branch","dsn",0,document.form_add_partner.company_id.value);
			if(get_comp_branch.COUNTRY != '')
			{
				document.form_add_partner.country.value = get_comp_branch.COUNTRY;
				LoadCity(get_comp_branch.COUNTRY,'city_id','county_id',0);
			}
			else
				document.form_add_partner.country.value = '';
			if(get_comp_branch.CITY != '')
			{
				document.form_add_partner.city_id.value = get_comp_branch.CITY;
				LoadCounty(get_comp_branch.CITY,'county_id');
			}
			else
				document.form_add_partner.city_id.value = '';
			if(get_comp_branch.COUNTY != '')
				document.form_add_partner.county_id.value = get_comp_branch.COUNTY;
			else
				document.form_add_partner.county_id.value = '';	
			if(get_comp_branch.COMPANY_ADDRESS != '')
				document.form_add_partner.adres.value = get_comp_branch.COMPANY_ADDRESS;
			else
				document.form_add_partner.adres.value = '';
			if(get_comp_branch.COMPANY_POSTCODE != '')
				document.form_add_partner.postcod.value = get_comp_branch.COMPANY_POSTCODE;
			else
				document.form_add_partner.postcod.value = '';
			if(get_comp_branch.SEMT != '')
				document.form_add_partner.semt.value = get_comp_branch.SEMT;
			else
				document.form_add_partner.semt.value = '';
			if(get_comp_branch.COMPANY_TELCODE != '')
				document.form_add_partner.telcod.value = get_comp_branch.COMPANY_TELCODE;
			else
				document.form_add_partner.telcod.value = '';
			if(get_comp_branch.COMPANY_TEL1 != '')
				document.form_add_partner.tel.value = get_comp_branch.COMPANY_TEL1;
			else
				document.form_add_partner.tel.value = '';
			if(get_comp_branch.COMPANY_FAX != '')
				document.form_add_partner.fax.value = get_comp_branch.COMPANY_FAX;
			else
				document.form_add_partner.fax.value = '';
		}
		else
		{
			get_company_branch = wrk_safe_query("mr_get_company_branch","dsn",0,compbranch_id);
			if(get_company_branch.COUNTRY_ID != '')
			{
				document.form_add_partner.country.value = get_company_branch.COUNTRY_ID;
				LoadCity(get_company_branch.COUNTRY_ID,'city_id','county_id',0);
			}
			else
				document.form_add_partner.country.value = '';
			if(get_company_branch.CITY_ID != '')
			{
				document.form_add_partner.city_id.value = get_company_branch.CITY_ID;
				LoadCounty(get_company_branch.CITY_ID,'county_id',0);
			}
			else
				document.form_add_partner.city_id.value = '';
			if(get_company_branch.COUNTY_ID != '')
				document.form_add_partner.county_id.value = get_company_branch.COUNTY_ID;
			else
				document.form_add_partner.county_id.value = '';	
			if(get_company_branch.COMPBRANCH_ADDRESS != '')
				document.form_add_partner.adres.value = get_company_branch.COMPBRANCH_ADDRESS;
			else
				document.form_add_partner.adres.value = '';
			if(get_company_branch.COMPBRANCH_POSTCODE != '')
				document.form_add_partner.postcod.value = get_company_branch.COMPBRANCH_POSTCODE;
			else
				document.form_add_partner.postcod.value = '';
			if(get_company_branch.SEMT != '')
				document.form_add_partner.semt.value = get_company_branch.SEMT;
			else
				document.form_add_partner.semt.value = get_company_branch.SEMT;
			if(get_company_branch.COMPBRANCH_TELCODE != '')
				document.form_add_partner.telcod.value = get_company_branch.COMPBRANCH_TELCODE;
			else
				document.form_add_partner.telcod.value = '';
			if(get_company_branch.COMPBRANCH_TEL1 != '')
				document.form_add_partner.tel.value = get_company_branch.COMPBRANCH_TEL1;
			else
				document.form_add_partner.tel.value = '';
			if(get_company_branch.COMPBRANCH_FAX != '')
				document.form_add_partner.fax.value = get_company_branch.COMPBRANCH_FAX;
			else
				document.form_add_partner.fax.value = '';
		}
	}


function kontrol ()
{

	x = document.form_add_partner.language_id.selectedIndex;
	if (document.form_add_partner.language_id[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='33413.Kullanıcı İçin Dil Seçmediniz'> !");
		return false;
	}

	x = (100 - document.form_add_partner.adres.value.length);
	if ( x < 0)
	{ 
		alert ("<cf_get_lang dictionary_id='58723.Adres'> "+ ((-1) * x) +" <cf_get_lang dictionary_id='29538.Karakter Uzun'> !");
		return false;
	}
	
	x = (document.form_add_partner.password.value.length);
	if ((document.form_add_partner.password.value != '')  && ( x < 4 ))
	{ 
		alert ("<cf_get_lang dictionary_id='33417.Şifreniz En Az Dört Karakter Olmalıdır'>");
		return false;
	}
	
	var obj =  document.form_add_partner.photo.value;
	if ((obj != "") && !((obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'jpg')   || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4) == 'gif').toLowerCase() || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'png'))){
	alert("<cf_get_lang dictionary_id='52293.Lütfen bir resim dosyası(gif,jpg veya png) giriniz'>!!");        
	return false;
	}	
	
	if (confirm("<cf_get_lang dictionary_id='33420.Girdiğiniz Blgileri Kaydetmek Üzeresiniz'>, <cf_get_lang dictionary_id='33422.Lütfen Yeni Üye Kaydını Onaylayın'> ! ")) return true; else return false;
}
</script>
