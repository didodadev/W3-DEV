<!--- Özgeçmişim \ Kimlik ve İletişim Bilgileri (Stage : 1) --->
<cfif not isdefined("session.cp.userid")>
  <cflocation url="#request.self#?fuseaction=objects2.kariyer_login" addtoken="no">
</cfif>

<cfset get_components = createObject("component", "V16.objects2.career.cfc.data_career")>
<cfset get_id_card_cats = get_components.get_id_card_cats()>
<cfset get_country = get_components.get_country()>
<cfset get_city = get_components.get_city()>
<cfset get_app = get_components.get_app()>
<cfset get_mobilcat = get_components.get_mobilcat()>
<cfset get_app_identy = get_components.get_app_identy()>
<cfset get_im = get_components.get_im()>

<cfparam name="attributes.stage" default="1">
<!--- hangi sayfa olduğunu belirleyen değer--->
<cfform name="employe_detail" method="post">
	<input type="hidden" name="stage" id="stage" value="<cfoutput>#attributes.stage#</cfoutput>">
	<div class="row">
		<div class="col-md-12">
			<cfinclude template="../display/add_sol_menu.cfm">
		</div>
	</div>
	<div class="row">
		<div class="col-md-12">
			<p class="font-weight-bold"><cf_get_lang dictionary_id='35124.Özgeçmişim'> \ <cf_get_lang dictionary_id='56130.Kimlik ve İletişim Bilgileri'></p>
		</div>
	</div>	
<div class="row">
	<div class="col-md-6">		
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='57631.Ad'> *</label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-5">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='34540.Lütfen adınızı giriniz!'></cfsavecontent>
				<cfinput type="text" class="form-control" name="emp_name" id="emp_name" value="#get_app.name#" maxlength="50" required="yes" message="#message#">
			</div>
		</div>
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58726.Soyad'> *</label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-5">
				<cfsavecontent variable="message2"><cf_get_lang dictionary_id='33643.Lütfen Soyad Giriniz'></cfsavecontent>
					<cfinput type="text" class="form-control" name="emp_surname" id="emp_surname" value="#get_app.surname#"  maxlength="50" required="yes" message="#message2#">
			</div>
		</div>
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='55439.Şifre (karakter duyarlı)'></label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-5">
				<input type="password" class="form-control" name="empapp_password" id="empapp_password" value="" maxlength="16" tabindex="6">
			</div>
		</div>
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='57428.E-posta'></label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-5">
				<cfinput type="text" class="form-control" name="email" id="email" value="#get_app.email#" readonly>
			</div>
		</div>
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58814.Ev Telefonu'></label>
			<div class="col-3 col-md-3 col-lg-2 col-xl-2 pr-0">
				<input type="text" class="form-control" name="hometelcode" id="hometelcode" value="<cfoutput>#trim(get_app.hometelcode)#</cfoutput>" onkeyup="isNumber(this);" maxlength="3"  tabindex="11">	
			</div>
			<div class="col-9 col-md-5 col-lg-4 col-xl-3">
				<input type="text" class="form-control" name="hometel" id="hometel" value="<cfoutput>#trim(get_app.hometel)#</cfoutput>" onkeyup="isNumber(this);" maxlength="7" tabindex="12">	
			</div>
		</div>
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='34534.Ev Adresi'></label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-5">
				<textarea name="homeaddress" id="homeaddress" class="form-control" maxlength="50" tabindex="14" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);"><cfoutput>#get_app.homeaddress#</cfoutput></textarea>
			</div>
		</div>
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='56131.Oturduğunuz Ev'></label>
			<div class="col-md-8 col-xl-8 mt-1 pt-1 pl-0">
				<div class="col-xl-4">
					<input type="radio" name="home_status" id="home_status" value="1" tabindex="18" <cfif get_app.home_status eq 1>checked</cfif>>&nbsp;<cf_get_lang dictionary_id='34653.Kendinizin'>
				</div>
				<div class="col-xl-4">
					<input type="radio" name="home_status" id="home_status" value="2" tabindex="19" <cfif get_app.home_status eq 2>checked</cfif>>&nbsp;<cf_get_lang dictionary_id='34654.Ailenizin'>
				</div>
				<div class="col-xl-4">
					<input type="radio" name="home_status" id="home_status" value="3" tabindex="20" <cfif get_app.home_status eq 3>checked</cfif>>&nbsp;<cf_get_lang dictionary_id='34655.Kira'>
				</div>
			</div>
		</div>
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='35352.Anlık Mesaj'></label>
			<div class="col-5 col-md-5 col-lg-4 col-xl-3 pr-0">
				<select name="imcat_id" class="form-control" id="imcat_id" tabindex="21">
					<cfoutput query="get_im">
						<option value="#imcat_id#" <cfif get_app.imcat_id eq imcat_id>selected</cfif>>#imcat# 
					</cfoutput>
				</select>
			</div>
			<div class="col-7 col-md-3 col-xl-3">
				<input type="text" class="form-control" name="im" id="im" maxlength="30" value="<cfoutput>#get_app.im#</cfoutput>" tabindex="22">
			</div>		
		</div>
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='34528.Fotoğraf'></label>
			<div class="col-5">
				<input type="file" name="photo" id="photo"  tabindex="24">
			</div>
		</div>
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58727.Doğum Tarihi'></label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-5">
				<cfsavecontent variable="message3"><cf_get_lang dictionary_id='52364.Lütfen Doğum Tarihi Formatını Doğru Giriniz'></cfsavecontent>
				<cfinput type="text" class="form-control" name="birth_date" id="birth_date" value="#dateformat(get_app_identy.birth_date,'dd/mm/yyyy')#"  tabindex="26" validate="eurodate" message="#message#" maxlength="10">
				<cf_wrk_date_image date_field="birth_date">
			</div>
		</div>
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='30502.Uyruğu'></label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-5">
				<select class="form-control" name="nationality" id="nationality" tabindex="28">
					<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
					<cfoutput query="get_country">
						<option value="#country_id#" <cfif (get_country.country_id eq get_app.nationality) or (get_country.is_default eq 1)>selected</cfif>>#country_name#</option>
					</cfoutput>
				</select>
			</div>
		</div>
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='34621.Kimlik Kartı Tipi'></label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-5">
				<select class="form-control" name="identycard_cat" id="identycard_cat" tabindex="29">
					<cfoutput query="get_id_card_cats">
						<option value="#identycat_id#" <cfif get_app.identycard_cat eq identycat_id>selected</cfif>>#identycat# 
					</cfoutput>
				</select>
			</div>
		</div>
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='34623.Nüfusa Kayıtlı Olduğu İl'></label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-5">
				<cfinput type="text" class="form-control" name="city" id="city" maxlength="100" tabindex="31" value="#get_app_identy.city#">
			</div>
		</div>		
	</div>
	<div class="col-md-6">
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31648.Direkt Tel'></label>
			<div class="col-4 col-md-3 col-lg-2 col-xl-2 pr-0">
				<input type="text" class="form-control" name="worktelcode" id="worktelcode" value="<cfoutput>#get_app.worktelcode#</cfoutput>" maxlength="3" tabindex="2" onKeyUp="isNumber(this);">
			</div>
			<div class="col-8 col-md-5 col-lg-4 col-xl-3">
				<input type="text" class="form-control" name="worktel" id="worktel" value="<cfoutput>#get_app.worktel#</cfoutput>" maxlength="7" tabindex="3" onKeyUp="isNumber(this);">
			</div>
		</div>
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31650.Dahili Tel'></label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-5">
				<input type="text" class="form-control" name="extension" id="extension" value="<cfoutput>#get_app.extension#</cfoutput>" maxlength="5" tabindex="5" onKeyUp="isNumber(this);">					
			</div>
		</div>
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58482.Mobil Tel'></label>
			<div class="col-4 col-md-3 col-lg-3 col-xl-2 pr-0">
				<select class="form-control" name="mobilcode" id="mobilcode" tabindex="7">
					<option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
					<cfoutput query="get_mobilcat">
						<option value="#mobilcat#" <cfif get_app.mobilcode eq mobilcat>selected</cfif>>#mobilcat#</option>
					</cfoutput>
				</select>				
			</div>
			<div class="col-8 col-md-5 col-lg-3 col-xl-3">
				<input type="text" class="form-control" name="mobil" id="mobil" value="<cfoutput>#trim(get_app.mobil)#</cfoutput>" onKeyUp="isNumber(this);" maxlength="7" tabindex="8">
			</div>		
		</div>
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58482.Mobil Tel'> 2</label>
			<div class="col-4 col-md-3 col-lg-3 col-xl-2 pr-0">
				<select class="form-control" name="mobilcode2" id="mobilcode2" tabindex="7">
					<option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
					<cfoutput query="get_mobilcat">
						<option value="#mobilcat#"  <cfif get_app.mobilcode2 eq mobilcat>selected</cfif>>#mobilcat#</option>
					</cfoutput>
				</select>			
			</div>
			<div class="col-8 col-md-5 col-lg-3 col-xl-3">
				<input type="text" class="form-control" name="mobil2" id="mobil2" value="<cfoutput>#trim(get_app.mobil2)#</cfoutput>" onkeyup="isNumber(this);" maxlength="7"  tabindex="10">
			</div>		
		</div>
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-5">
				<input type="text" class="form-control" name="homepostcode" id="homepostcode" value="<cfoutput>#get_app.homepostcode#</cfoutput>" onkeyup="isNumber(this);" maxlength="10" tabindex="13">					
			</div>
		</div>
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58219.Ülke'></label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-5">
				<select class="form-control" name="homecountry" id="homecountry" tabindex="15" onChange="LoadCity(this.value,'homecity','homecounty',0)">
					<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
					<cfoutput query="get_country">
						<option value="#get_country.country_id#" <cfif get_country.country_id eq get_app.homecountry>selected</cfif>>#get_country.country_name#</option>
					</cfoutput>
				</select>
			</div>
		</div>
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='57971.Şehir'></label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-5">
				<cfif len(get_app.homecity)>
					<cfquery name="GET_HOMECITY" dbtype="query">
					  SELECT CITY_NAME FROM GET_CITY WHERE CITY_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.homecity#">
					</cfquery>
				  </cfif>
				  <select class="form-control" name="homecity" id="homecity" tabindex="16" onChange="LoadCounty(this.value,'homecounty')">
					  <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
					  <cfquery name="GET_CITY" datasource="#DSN#">
						  SELECT CITY_ID, CITY_NAME FROM SETUP_CITY <cfif len(get_app.homecountry)>WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.homecountry#"></cfif>
					  </cfquery>
					  <cfoutput query="get_city">
						  <option value="#city_id#" <cfif get_app.homecity eq city_id>selected</cfif>>#city_name#</option>
					  </cfoutput>
				  </select>
			</div>
		</div>
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58638.İlçe'></label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-5">
				<select class="form-control" name="homecounty" id="homecounty" tabindex="17" >
					<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
					<cfquery name="GET_COUNTY" datasource="#DSN#">
						SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY <cfif len(get_app.homecity)>WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.homecity#"></cfif>
					</cfquery>
					<cfoutput query="get_county">
						<option value="#county_id#" <cfif get_app.homecounty eq county_id>selected</cfif>>#county_name#</option>
					</cfoutput>
				</select>
			</div>
		</div>
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58762.Vergi Dairesi'></label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-5">
				<input type="text" class="form-control" name="tax_office" id="tax_office" maxlength="50" value="<cfoutput>#get_app.tax_office#</cfoutput>" tabindex="23">
			</div>
		</div>
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='57752.Vergi No'></label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-5">
				<input type="text" class="form-control" name="tax_number" id="tax_number" maxlength="50"  tabindex="25" value="<cfoutput>#get_app.tax_number#</cfoutput>">
			</div>
		</div>
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31657.Doğum Yeri(İlçe / İl)'></label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-5">
				<input type="text" class="form-control" name="birth_place" id="birth_place" value="<cfoutput>#get_app_identy.birth_place#</cfoutput>" maxlength="100" tabindex="27">
			</div>
		</div>
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='34622.Kimlik Kartı No'></label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-5">
				<cfinput type="text" class="form-control" name="identycard_no" id="identycard_no" maxlength="50"  tabindex="30" value="#get_app.identycard_no#">
			</div>
		</div>	
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58025.TC Kimlik No'></label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-5">
				<cf_wrkTcNumber fieldId="tc_identy_no" class="form-control" tc_identity_number="#get_app_identy.tc_identy_no#" tc_identity_required="0" width_info='150' is_verify='1' consumer_name='emp_name' consumer_surname='emp_surname' birth_date='birth_date'>
			</div>
		</div>		
	</div>
</div>
<div class="form-group">
	<div class="col-12 d-flex justify-content-start">
		<cfsavecontent variable="alert"><cf_get_lang dictionary_id ='35495.Kaydet ve İlerle'></cfsavecontent>
		<!--- <cf_workcube_buttons is_upd='0' insert_info='#alert#' add_function='kontrol()' is_cancel='0'> --->
		<cf_workcube_buttons is_insert='1'	data_action="/V16/objects2/career/cfc/data_career:add_cv_1" next_page="#request.self#" add_function='kontrol()'>
	</div>
</div>
</cfform>


<script type="text/javascript">
function kontrol()
{   
	var tarih_ = fix_date_value(document.employe_detail.birth_date.value);
	if(tarih_.substr(6,4) < 1900)
	{
		alert("<cf_get_lang_main no='370.Tarih Değerini Kontrol Ediniz'>!");
		return false;
	}
	if(!(document.employe_detail.home_status[0].status || document.employe_detail.home_status[1].status || document.employe_detail.home_status[2].status))
	{
		alert('Lütfen Oturduğunuz Ev Alanında Seçim Yapınız!');
		return false;
	} 
	if (document.employe_detail.homeaddress.value.length == 0)
	{
		alert("<cf_get_lang no='812.Adresinizi Girmelisiniz'> !");
		document.employe_detail.homeaddress.focus();
		return false;
	}
	
	if(document.employe_detail.nationality.value.length==0)
	{
		alert("<cf_get_lang no='813.Uyruğunuzu Seçmelisiniz'>!");
		document.employe_detail.nationality.focus();
		return false;
	}
	if(document.employe_detail.hometel.value<1000000 && document.employe_detail.mobil.value<1000000 && document.employe_detail.mobil2.value<1000000 && document.employe_detail.worktel.value<1000000)
	{
		alert("<cf_get_lang no='814.En Az Bir Telefon Numarası Girmelisiniz'>!");
		document.employe_detail.hometel.focus();
		return false;
	}
	return true;
}
</script>
