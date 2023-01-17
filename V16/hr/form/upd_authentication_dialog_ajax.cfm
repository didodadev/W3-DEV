<!--- Kişisel bilgiler--->
<cfinclude template="../query/get_app_identy.cfm">
<cfinclude template="../ehesap/query/get_our_comp_and_branchs.cfm"> 
<cfinclude template="../query/get_app.cfm">
<cfinclude template="../query/get_im_cats.cfm">
<cfinclude template="../query/get_driverlicence.cfm">
<cfinclude template="../query/get_edu_level.cfm">
<cfquery name="get_country" datasource="#dsn#">
	SELECT COUNTRY_ID,COUNTRY_NAME,IS_DEFAULT FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
</cfquery>
<cfquery name="get_emp_course" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_COURSE WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.empapp_id#">
</cfquery>
<cfquery name="get_computer_info" datasource="#dsn#">
	SELECT * FROM SETUP_COMPUTER_INFO WHERE COMPUTER_INFO_STATUS = 1
</cfquery>
<cfquery name="get_teacher_info" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_APP_TEACHER_INFO WHERE EMPAPP_ID = #EMPAPP_ID#
</cfquery>
<cfform action="#request.self#?fuseaction=upd_authentication_dialog_ajax&empapp_id=#attributes.empapp_id#" name="detail_" method="post">
<table id="gizli0">
	<tr>
		<td colspan="2">
			<input type="radio" value="0" name="cv_type" id="cv_type" <cfif get_app.cv_type eq 0>checked</cfif> onclick="referans_calistir();"> <cf_get_lang dictionary_id="38581.Güncel Cv">
			<input type="radio" value="1" name="cv_type" id="cv_type" <cfif get_app.cv_type eq 1>checked</cfif> onclick="referans_calistir();"> <cf_get_lang dictionary_id="38580.Referanslı Cv">
		</td>
	</tr>
	<tr id="referans_area" style="display:none;">
		<td><cf_get_lang dictionary_id="38625.Referans Adı Soyad"></td>
		<td>
			<cfif isdefined("get_app.reference_name") and len(get_app.reference_name)>
				<cfinput type="text" name="reference_name" style="width:75px;" value="#get_app.reference_name#"  maxlength="50"> 
			<cfelse>
				<cfinput type="text" name="reference_name" style="width:75px;" value=" "  maxlength="50"> 
			</cfif>
			<cfif isdefined("get_app.reference_surname") and len(get_app.reference_surname)>
				<cfinput type="text" name="reference_surname" style="width:75px;" value="#get_app.reference_surname#"  maxlength="50">
			<cfelse>
				<cfinput type="text" name="reference_surname" style="width:75px;" value=" "  maxlength="50">
			</cfif>
		</td>
		<td><cf_get_lang dictionary_id="38624.Referans Görevi"></td>
		<td>
			<cfif isdefined("get_app.reference_position") and len(get_app.reference_position)>
				<cfinput type="text" name="reference_position" value="#get_app.reference_position#" style="width:150px;"  maxlength="100">
			<cfelse>
				<cfinput type="text" name="reference_position" style="width:150px;"   maxlength="100">
			</cfif>
		</td>
	</tr>
	<tr>
		<td><cf_get_lang dictionary_id ='58859.Süreç'></td>
		<td><cf_workcube_process is_upd='0' select_value='#get_app.cv_stage#' process_cat_width='153' is_detail='1'></td>
		<td><cf_get_lang dictionary_id="37619.Giriş Yapan"></td>
		<td>
			<cfinput type="hidden" name="cv_recorder_emp_id" value="#session.ep.userid#">
			<cfinput type="text" name="cv_recorder_emp_name" style="width:150px;" value="#session.ep.name# #session.ep.surname#">
			<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&select_list=1&field_name=employe_detail.cv_recorder_emp_name&field_emp_id=employe_detail.cv_recorder_emp_id','list');"><img src="/images/plus_thin.gif" align="absbottom" border="0"></a>
		</td>
	</tr>
	<tr>
		<td><cf_get_lang dictionary_id="41457.İlgili Şube"></td>
		<td colspan="3">
			<select name="branch_id" id="branch_id" style="width:465px;">
			  <option value=""><cf_get_lang dictionary_id="57453.Şube"></option>
			  <cfoutput query="get_our_comp_and_branchs">
				<option value="#branch_id#" <cfif isdefined("get_app.related_branch_id") and len(get_app.related_branch_id) and get_app.related_branch_id eq branch_id>selected</cfif>>#BRANCH_NAME#</option>
			  </cfoutput>
			</select>
		</td>
	</tr>							
	<tr>
	  <td height="22" colspan="4" class="formbold"><cf_get_lang dictionary_id="31234.Kimlik Bilgileri"></td>
	</tr>
	<tr>
		<cfoutput>
		<td><cf_get_lang dictionary_id='57487.No'></td>
		<td>#get_app.empapp_id#</td>
		</cfoutput>
	</tr>
	<tr>
		<td width="100"><cf_get_lang dictionary_id='55649.TC Kimlik No'></td>
		<td><cfinput type="text" name="TC_IDENTY_NO" style="width:150px;" maxlength="11" value="#get_app_identy.TC_IDENTY_NO#"></td>
		<td><cf_get_lang dictionary_id='57493.Aktif'></td>
		<td><input type="checkbox" name="app_status" id="app_status" value="1" <cfif get_app.app_status eq 1>checked</cfif>></td>
	</tr>
	<tr>
		<td><cf_get_lang dictionary_id='57631.Ad'>*</td>
		<td>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='58939.Ad Girmelisiniz'></cfsavecontent>
			<cfinput type="text" value="#get_app.name#" name="name" style="width:150px;" maxlength="50" required="Yes" message="#message#">
		</td>
		<td><cf_get_lang dictionary_id='55445.Direkt Tel'></td>
		<td>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='55443.direkt tel girmelisiniz'></cfsavecontent>
			<cfinput value="#get_app.worktelcode#" type="text" name="worktelcode" style="width:48px;" maxlength="3" validate="integer" message="#message#">
			<cfinput value="#get_app.worktel#" type="text" name="worktel" style="width:99px;" maxlength="7" validate="integer" message="#message#">
		</td>
	</tr>
	<tr>
		<td><cf_get_lang dictionary_id='58726.Soyad'>*</td>
		<td>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58726.Soyad'></cfsavecontent>
			<cfinput value="#get_app.surname#" type="text" name="surname" style="width:150px;" maxlength="50" required="Yes" message="#message#">
		</td>
		<td><cf_get_lang dictionary_id='55446.Dahili Tel'></td>
		<td>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='55453.dahili tel girmelisiniz'></cfsavecontent>
			<cfinput value="#get_app.extension#" type="text" name="extension" style="width:150px;" maxlength="5" validate="integer" message="#message#">
		</td>

	</tr>
	<tr>
		<td nowrap="nowrap"><cf_get_lang dictionary_id='55439.Şifre (karakter duyarlı)'></td>
		<td><cfinput value="" type="password" name="empapp_password" style="width:150px;" maxlength="16"></td>
		<td><cf_get_lang dictionary_id='58482.Mobil Tel'></td>
		<td>
			<cfinput type="text" name="mobilcode" value="#get_app.mobilcode#" style="width:48px;" maxlength="3" validate="integer" message="#message#">
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='55454.Mobil Telefon Girmelisiniz'></cfsavecontent>
			<cfinput value="#get_app.mobil#" type="text" name="mobil" style="width:99px;" maxlength="7" validate="integer" message="#message#">
		</td>
	</tr>
	<tr>
		<cfsavecontent variable="message2"><cf_get_lang dictionary_id="51939.Mail Adresini Giriniz!"></cfsavecontent>
		<td><cf_get_lang dictionary_id='57428.E-posta'></td>
		<td><cfinput type="text" name="email" value="#get_app.email#" validate="email" style="width:150px;" maxlength="100" message="#message2#"></td>
		<td><cf_get_lang dictionary_id='58482.Mobil Tel'>2</td>
		<td>
			<cfinput type="text" name="mobilcode2" value="#get_app.mobilcode2#" style="width:48px;" maxlength="3" validate="integer" message="#message#">
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='55454.Mobil Telefon Girmelisiniz'></cfsavecontent>
			<cfinput value="#get_app.mobil2#" type="text" name="mobil2" style="width:99px;" maxlength="7" validate="integer" message="#message#">
		</td>
	</tr>
	<tr>
		<td width="115"><cf_get_lang dictionary_id='55593.Ev Tel'></td>
		<td width="190">
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='55601.ev telefonu girmelisiniz'></cfsavecontent>
			<cfinput value="#get_app.hometelcode#" type="text" name="hometelcode" style="width:40px;" maxlength="3" validate="integer" message="#message#">
			<cfinput value="#get_app.hometel#" type="text" name="hometel" style="width:107px;"  maxlength="7"validate="integer" message="#message#">
		</td>
		<td width="110"><cf_get_lang dictionary_id='55595.Posta Kodu'></td>
		<td><cfinput type="text" name="homepostcode" style="width:150px;" maxlength="10" value="#get_app.homepostcode#"></td>
	</tr>
	<tr>
		<td rowspan="3" valign="top"><cf_get_lang dictionary_id='55594.Ev Adresi'></td>
		<td rowspan="3">
			<cfsavecontent variable="textmessage"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
			<textarea name="homeaddress" id="homeaddress" message="<cfoutput>#textmessage#</cfoutput>" maxlength="500" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);" style="width:150px;height:60px;"><cfoutput>#get_app.homeaddress#</cfoutput></textarea>
		</td>
		<td height="26"><cf_get_lang dictionary_id='58638.İlçe'></td>
		<td>
			<select name="homecounty" id="homecounty" style="width:150px;">
				<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
			<cfquery name="GET_COUNTY" datasource="#DSN#">
				SELECT * FROM SETUP_COUNTY <cfif len(get_app.homecity)>WHERE CITY = #get_app.homecity#</cfif>
			</cfquery>
			<cfoutput query="get_county">
				<option value="#county_id#" <cfif get_app.homecounty eq county_id>selected</cfif>>#county_name#</option>
			</cfoutput>
			</select>
		</td>
	</tr>
	<tr>
		<td><cf_get_lang dictionary_id='57971.Şehir'></td>
		<td>
			<cfif len(get_app.homecity)>
				<cfquery name="get_homecity" dbtype="query">
					SELECT CITY_NAME FROM get_city WHERE CITY_ID=#get_app.homecity#
				</cfquery>
			</cfif>
			<select name="homecity" id="homecity" style="width:150px;" onChange="LoadCounty(this.value,'homecounty')">
				<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
				<cfquery name="GET_CITY" datasource="#DSN#">
					SELECT CITY_ID, CITY_NAME FROM SETUP_CITY <cfif len(get_app.homecountry)>WHERE COUNTRY_ID = #get_app.homecountry#</cfif>
				</cfquery>
				<cfoutput query="get_city">
					<option value="#city_id#" <cfif get_app.homecity eq city_id>selected</cfif>>#city_name#</option>
				</cfoutput>
			</select>
		</td>
	</tr>
	<tr>
		<td><cf_get_lang dictionary_id='58219.Ülke'></td>
		<td colspan="3">
			<select name="homecountry"  id="homecountry" style="width:150px;" onChange="LoadCity(this.value,'homecity','homecounty')">
				<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
				<cfoutput query="get_country">
					<option value="#get_country.country_id#" <cfif get_app.homecountry eq country_id or (get_country.is_default eq 1)>selected</cfif>>#country_name#</option>
				</cfoutput>
			</select>
		</td>
	</tr>
	<tr>
		<td><cf_get_lang dictionary_id='56131.Oturduğunuz Ev'></td>
		<td colspan="3">
			 <select name="home_status" id="home_status" style="width:150px;">
				<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
				<option value="1" <cfif get_app.home_status eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id='56132.Kendinizin'>
				<option value="2" <cfif get_app.home_status eq 2>selected="selected"</cfif>><cf_get_lang dictionary_id='56133.Ailenizin'>
				<option value="3" <cfif get_app.home_status eq 3>selected="selected"</cfif>><cf_get_lang dictionary_id='56134.Kira'>
			</select>
		</td>
	</tr>
	<tr>
		<td><cf_get_lang dictionary_id='55444.Instant Mesaj'></td>
		<td>
			<select name="imcat_id" id="imcat_id" style="width:48px;">
			<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option> 
			<cfoutput query="im_cats">
				<option value="#imcat_id#" <cfif get_app.imcat_id eq imcat_id>selected</cfif>>#imcat# </option>
			</cfoutput>
			</select>
			<cfinput type="text" name="im" style="width:99px;" maxlength="30" value="#get_app.im#">
		</td>
		<td><cf_get_lang dictionary_id='58762.Vergi Dairesi'></td>
		<td><cfinput type="text" name="tax_office" style="width:150px;" maxlength="50" value="#get_app.tax_office#"></td>
	</tr>
	<tr>
		<td><cf_get_lang dictionary_id='55110.Fotoğraf'></td>
		<td><input type="file" name="photo" id="photo" style="width:150px;"></td>
		<td><cf_get_lang dictionary_id='57752.Vergi No'></td>
		<td><cfinput type="text" name="tax_number" style="width:150px;" maxlength="50" value="#get_app.tax_number#"></td>
	</tr>
	<tr>
		<td>
			<cfif len(get_app.photo)>
			<cf_get_lang dictionary_id='55660.fotoğrafı Sil'>
			</cfif>
		</td>
		<td>
			<cfif len(get_app.photo)>
			<input type="Checkbox" name="del_photo" id="del_photo" value="1">
			<cf_get_lang dictionary_id='57495.Evet'>
			</cfif>
		</td> 
	</tr>
	<tr>
		<td width="115"><cf_get_lang dictionary_id='58727.Doğum Tarihi'></td>
		<td width="185">
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='55788.Doğum tarihi girmelisiniz'></cfsavecontent>
			<cfinput type="text" style="width:150px;" name="birth_date" value="#dateformat(get_app_identy.birth_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
			<cf_wrk_date_image date_field="birth_date"> 
		</td>
		<td width="110"><cf_get_lang dictionary_id='57790.Doğum Yeri'></td>
		<td><cfinput type="text" style="width:150px;" name="birth_place" maxlength="100" value="#get_app_identy.birth_place#"></td>
	</tr>
	<tr>
		<td><cf_get_lang dictionary_id='57790.Doğum Yeri'><cf_get_lang dictionary_id='58608.İl'></td>
		<td>
			<select name="birth_city" id="birth_city" style="width:150px;">
				<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
				<cfoutput query="get_city">
					<option value="#city_id#"<cfif get_app_identy.birth_city eq city_id>selected</cfif>>#city_name#</option>
				</cfoutput>
			</select>			
		</td>		
	</tr>
	<tr>
		<td><cf_get_lang dictionary_id='56135.Uyruğu'></td>
		<td>
			<select name="nationality" id="nationality" style="width:150px;">
				<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
				<cfoutput query="get_country">
				<option value="#country_id#" <cfif get_country.country_id eq get_app.nationality>selected</cfif>>#country_name#</option>
				</cfoutput>
			</select>
		</td>
		<td nowrap="nowrap"><cf_get_lang dictionary_id='55155.Nüfusa Kayıtlı Olduğu İl'></td>
		<td><cfinput type="text" name="CITY" style="width:150px;" maxlength="100" value="#get_app_identy.CITY#"></td>
	</tr>
	<tr>
		<td width="115"><cf_get_lang dictionary_id='55902.Kimlik Kartı Tipi'></td>
		<td width="190">
			<cf_wrk_combo 
				 query_name="GET_IDENTYCARD" 
				 name="identycard_cat" 
				 value="#get_app.identycard_cat#"
				 option_value="identycat_id" 
				 option_name="identycat"
				 width=150>
		</td>
		<td><cf_get_lang dictionary_id='55903.Kimlik Kartı No'></td>
		<td><cfinput type="text" name="identycard_no" style="width:150px;" maxlength="50" value="#get_app.identycard_no#"></td>
	</tr>
</table>
<table style="display:none" id="gizli1">
	<tr>
		<td><cf_get_lang dictionary_id='57764.Cinsiyet'></td>
		<td>
			<input type="radio" name="sex" id="sex" onclick="visible_mil(this.value);" value="1" <cfif get_app.sex eq 1>checked</cfif>>
			<cf_get_lang dictionary_id='58959.Erkek'>
			<input type="radio" name="sex" id="sex" onclick="visible_mil(this.value);" value="0" <cfif get_app.sex eq 0>checked</cfif>>
			<cf_get_lang dictionary_id='58958.Kadın'> 
		</td>
		<td><cf_get_lang dictionary_id='55654.Medeni Durum'></td>
		<td>
			<input type="radio" name="married" id="married" value="0" <cfif get_app_identy.married eq 0>checked</cfif>>
			<cf_get_lang dictionary_id='55744.Bekar'>
			<input type="radio" name="married" id="married" value="1" <cfif get_app_identy.married eq 1>checked</cfif>>
			<cf_get_lang dictionary_id='55743.Evli'> 
		</td>
	</tr>
	<tr>
		<td><cf_get_lang dictionary_id='56136.Eşinin Adı'></td>
		<td><cfinput type="text" name="partner_name" value="#get_app.partner_name#" maxlength="150" style="width:150px;"></td>
		<td><cf_get_lang dictionary_id='55618.Eşinin Ç Şirket'></td>
		<td><cfinput type="text" name="partner_company" maxlength="50" style="width:150px;" value="#get_app.partner_company#"></td>
	</tr>
	<tr>
		<td><cf_get_lang dictionary_id='55633.Eşinin Pozisyonu'></td>
		<td><cfinput type="text" name="partner_position" maxlength="50" style="width:150px;" value="#get_app.partner_position#"></td>
		<td><cf_get_lang dictionary_id='56137.Çocuk Sayısı'></td>                     
		<td>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='55942.çocuk sayısı girmelisiniz'></cfsavecontent>
			<cfinput type="text" name="child" maxlength="2" style="width:150px;" value="#get_app.child#" validate="integer" message="#message#">
		</td>
	</tr>
	<tr>
		<td width="110"><cf_get_lang dictionary_id='56138.Sigara Kullanıyor mu'>?</td>
		<td width="185">
			<input type="radio" name="use_cigarette" id="use_cigarette" value="1" <cfif get_app.use_cigarette eq 1>checked</cfif>>
			<cf_get_lang dictionary_id='57495.Evet'>
			<input type="radio" name="use_cigarette" id="use_cigarette" value="0" <cfif get_app.use_cigarette eq 0 or not len(get_app.use_cigarette)>checked</cfif>>
			<cf_get_lang dictionary_id='57496.Hayır'> 
		</td>
		<td><cf_get_lang dictionary_id='56139.Şehit Yakını Misiniz'></td>
		<td>
			<input type="radio" name="martyr_relative" id="martyr_relative" value="1" <cfif get_app.martyr_relative eq 1>checked</cfif>>
			<cf_get_lang dictionary_id='57495.Evet'>
			<input type="radio" name="martyr_relative" id="martyr_relative" value="0" <cfif get_app.martyr_relative eq 0 or not len(get_app.martyr_relative)>checked</cfif>>
			<cf_get_lang dictionary_id='57496.Hayır'>
		</td>
	</tr>
	<tr>
		<td width="110"><cf_get_lang dictionary_id='55614.Engelli'> </td>
		<td width="185">
			<input type="radio" name="defected" id="defected" value="1" onClick="seviye();" <cfif get_app.defected eq 1>checked</cfif>>
			<cf_get_lang dictionary_id='57495.Evet'>
			<input type="radio" name="defected" id="defected" value="0" onClick="seviye();" <cfif get_app.defected eq 0 or not len(get_app.defected)>checked</cfif>>
			<cf_get_lang dictionary_id='57496.Hayır'> &nbsp;&nbsp;&nbsp;
			<select name="defected_level" id="defected_level" <cfif get_app.defected eq 0>disabled</cfif>>
				<option value="0" <cfif get_app.defected_level eq 0>selected</cfif>>%0</option>
				<option value="10" <cfif get_app.defected_level eq 10>selected</cfif>>%10</option>
				<option value="20" <cfif get_app.defected_level eq 20>selected</cfif>>%20</option>
				<option value="30" <cfif get_app.defected_level eq 30>selected</cfif>>%30</option>
				<option value="40" <cfif get_app.defected_level eq 40>selected</cfif>>%40</option>
				<option value="50" <cfif get_app.defected_level eq 50>selected</cfif>>%50</option>
				<option value="60" <cfif get_app.defected_level eq 60>selected</cfif>>%60</option>
				<option value="70" <cfif get_app.defected_level eq 70>selected</cfif>>%70</option>
				<option value="80" <cfif get_app.defected_level eq 80>selected</cfif>>%80</option>
				<option value="90" <cfif get_app.defected_level eq 90>selected</cfif>>%90</option>
				<option value="100" <cfif get_app.defected_level eq 100>selected</cfif>>%100</option>
			</select>
		</td>
		<td><cf_get_lang dictionary_id="55136.Psikoteknik"></td> 
		<td>
			<input type="radio" name="psikoteknik" id="psikoteknik" value="1" <cfif get_app.is_psicotechnic eq 1>checked</cfif>>
			<cf_get_lang dictionary_id='57495.Evet'>
			<input type="radio" name="psikoteknik" id="psikoteknik" value="0" <cfif get_app.is_psicotechnic eq 0>checked</cfif>>
			<cf_get_lang dictionary_id='57496.Hayır'>
		</td>  
	</tr>
	<tr>
		<td><cf_get_lang dictionary_id='31670.Hüküm Giydi mi'></td>
		<td>
			<input type="radio" name="sentenced" id="sentenced" value="1" <cfif get_app.sentenced EQ 1>checked</cfif>>
			<cf_get_lang dictionary_id='57495.Evet'>
			<input type="radio" name="sentenced" id="sentenced" value="0" <cfif get_app.sentenced EQ 0>checked</cfif>>
			<cf_get_lang dictionary_id='57496.Hayır'>
		</td>
		<td><cf_get_lang dictionary_id='55629.Ehliyet Sınıf /Yıl'></td>
		<td>
			<select name="driver_licence_type" id="driver_licence_type" style="width:82px;">
				<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
				<cfoutput query="get_driverlicence">
					<option value="#licencecat_id#" <cfif licencecat_id eq get_app.licencecat_id> selected</cfif>>#licencecat#</option>
				</cfoutput>
			</select>
			<cfsavecontent variable="message_driver"><cf_get_lang dictionary_id='56601.Ehliyet Yılına Geçerli Bir Tarih Girmelisiniz'></cfsavecontent>
			<cfinput type="text" name="licence_start_date" value="#DateFormat(get_app.licence_start_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message_driver#" style="width:65px;">
			<cf_wrk_date_image date_field="licence_start_date">
		</td>
	</tr>
	<tr>
		<td><cf_get_lang dictionary_id='55432.Göçmen'></td>
		<td>
			<input type="radio" name="immigrant" id="immigrant" value="1" <cfif get_app.immigrant EQ 1>checked</cfif>>
			<cf_get_lang dictionary_id='57495.Evet'>
			<input type="radio" name="immigrant" id="immigrant" value="0" <cfif get_app.immigrant EQ 0>checked</cfif>>
			<cf_get_lang dictionary_id='57496.Hayır'> 
		</td>
		<td><cf_get_lang dictionary_id='55630.Ehliyet No'></td>
		<td><cfinput type="Text" name="driver_licence" maxlength="40" style="width:150px;" value="#get_app.driver_licence#"></td>
	</tr>
	<tr>
		<td colspan="3"><cf_get_lang dictionary_id='56140.Kaç yıldır aktif olarak araba kullanıyorsunuz'>?</td>
		<td><cfinput type="text" name="driver_licence_actived" value="#get_app.driver_licence_actived#" maxlength="2"  style="width:150px;" validate="integer" message="Ehliyet Aktiflik Süresine Sayı Giriniz!"></td>
	</tr>
	<tr>
		<td colspan="3"><cf_get_lang dictionary_id='55343.Bir suç zannıyla tutuklandınız mı'></td>
		<td>
			<input type="radio" name="defected_probability" id="defected_probability" value="1"  <cfif get_app.defected_probability eq 1>checked</cfif>>
			<cf_get_lang dictionary_id='57495.Evet'> &nbsp;
			<input type="radio" name="defected_probability" id="defected_probability" value="0" <cfif get_app.defected_probability eq 0>checked</cfif>>
			<cf_get_lang dictionary_id='57496.Hayır'>
		</td>
	</tr>
	<tr>
		<td><cf_get_lang dictionary_id='55341.Varsa nedir?'></td>
		<td colspan="3"><cfinput type="text" name="investigation" value="#get_app.INVESTIGATION#" maxlength="150" style="width:150px;"></td>
	</tr>
	<tr>
		<td colspan="3"><cf_get_lang dictionary_id='55342.Devam eden bir hastalık veya bedeni sorununuz var mı'></td>
		<td>
			<input type="radio" name="illness_probability" id="illness_probability" value="1" <cfif get_app.illness_probability eq 1>checked</cfif>>
			<cf_get_lang dictionary_id='57495.Evet'> &nbsp;
			<input type="radio" name="illness_probability" id="illness_probability" value="0" <cfif get_app.illness_probability eq 0>checked</cfif>>
			<cf_get_lang dictionary_id='57496.Hayır'>
		</td>
	</tr>
	<tr height="22">
		<td valign="top"><cf_get_lang dictionary_id='55341.Varsa nedir?'></td>
		<td><textarea name="illness_detail" id="illness_detail" style="width:150px;height:40px;"><cfoutput>#get_app.illness_detail#</cfoutput></textarea></td>
		<td valign="top"><cf_get_lang dictionary_id='56142.Geçirdiğiniz Ameliyat'></td>
		<td><textarea name="surgical_operation" id="surgical_operation" style="width:150px;" message="<cfoutput>#textmessage#</cfoutput>" maxlength="150" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);"><cfoutput>#get_app.SURGICAL_OPERATION#</cfoutput></textarea></td>
	</tr>
	<tr height="22" id="military">
		<td><cf_get_lang dictionary_id='55619.Askerlik'></td>
		<td colspan="3">
			<input type="radio" name="military_status" id="military_status" value="0" <cfif get_app.military_status eq 0>checked</cfif> onClick="tecilli_fonk(this.value)">
			<cf_get_lang dictionary_id='55624.Yapmadı'> &nbsp;&nbsp;&nbsp;
			<input type="radio" name="military_status" id="military_status" value="1" <cfif get_app.military_status eq 1>checked</cfif> onClick="tecilli_fonk(this.value)">
			<cf_get_lang dictionary_id='55625.Yaptı'>&nbsp;&nbsp;&nbsp;
			<input type="radio" name="military_status" id="military_status" value="2" <cfif get_app.military_status eq 2>checked</cfif> onClick="tecilli_fonk(this.value)">
			<cf_get_lang dictionary_id='55626.Muaf'>&nbsp;&nbsp;&nbsp;
			<input type="radio" name="military_status" id="military_status" value="3" <cfif get_app.military_status eq 3>checked</cfif> onClick="tecilli_fonk(this.value)">
			<cf_get_lang dictionary_id='55627.Yabancı'> &nbsp;&nbsp;&nbsp;
			<input type="radio" name="military_status" id="military_status" value="4" <cfif get_app.military_status eq 4>checked</cfif> onClick="tecilli_fonk(this.value)">
			<cf_get_lang dictionary_id='55340.Tecilli'>
		</td>
	</tr>
	<tr height="22" <cfif get_app.military_status neq 4>style="display:none"</cfif> id="Tecilli">
		<td><cf_get_lang dictionary_id='55339.Tecil Gerekçesi'></td>
		<td><cfinput type="text" name="military_delay_reason" style="width:150px;" maxlength="30" value="#get_app.military_delay_reason#"></td>
		<td><cf_get_lang dictionary_id='55338.Tecil Süresi'></td>
		<td>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='55796.Tecil Süresi Girmelisiniz'></cfsavecontent>
			<cfinput type="text" style="width:150px;" name="military_delay_date" value="#dateformat(get_app.military_delay_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
			<cf_wrk_date_image date_field="military_delay_date">
		</td>
	</tr>
	<tr height="22" <cfif get_app.military_status neq 2>style="display:none"</cfif> id="Muaf">
		<td><cf_get_lang dictionary_id='56143.Muaf Olma Nedeni'></td>
		<td><input type="text" style="width:150px;" name="military_exempt_detail" id="military_exempt_detail" maxlength="100" value="<cfoutput>#get_app.military_exempt_detail#</cfoutput>"></td>
	</tr>
	<tr height="22" <cfif get_app.military_status neq 1>style="display:none"</cfif> id="Yapti">
		<td colspan="4">
			<table>
				<tr>
					<td width="110"><cf_get_lang dictionary_id='56144.Terhis Tarihi'></td>
					<td width="200">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='55796.Tecil Süresi Girmelisiniz'></cfsavecontent>
						<cfinput type="text" style="width:150px;" name="military_finishdate" value="#dateformat(get_app.military_finishdate,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
						<cf_wrk_date_image date_field="military_finishdate">
					</td>
					<td width="100" nowrap><cf_get_lang dictionary_id='56145.Süresi'> (<cf_get_lang dictionary_id='56146.Ay Olarak Giriniz'>)</td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='56147.Askerlik Süresi Girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="military_month" value="#get_app.military_month#" validate="integer" maxlength="2" message="#message#" style="width:150px;">
					</td>
				</tr>
				<tr>
					<td></td>
					<td><input type="radio" name="military_rank" id="military_rank" value="0" <cfif get_app.military_rank eq 0>checked</cfif>> <cf_get_lang dictionary_id='56148.Er'></td>
					<td></td>
					<td><input type="radio" name="military_rank" id="military_rank" value="1" <cfif get_app.military_rank eq 1>checked</cfif>> <cf_get_lang dictionary_id='56149.Yedek Subay'></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<!---Diğer Kimlik Detayları--->
<table style="display:none;" id="gizli2">
	<tr>
		<td width="105"><cf_get_lang dictionary_id='57637.Seri/No'></td>
		<td width="185">
			<cfinput type="text" name="series" style="width:50px;" maxlength="20" value="#get_app_identy.series#">
			<cfinput type="text" name="number" style="width:98px;" maxlength="50" value="#get_app_identy.number#">
		</td>
		<td><cf_get_lang dictionary_id='58441.Kan Grubu'></td>
		<td>
			<select name="BLOOD_TYPE" id="BLOOD_TYPE" style="width:150px;">
				<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
				<option value="0"<cfif len(get_app_identy.BLOOD_TYPE) and (get_app_identy.BLOOD_TYPE eq 0)>selected</cfif>>0 Rh+</option>
				<option value="1"<cfif len(get_app_identy.BLOOD_TYPE) and (get_app_identy.BLOOD_TYPE eq 1)>selected</cfif>>0 Rh-</option>
				<option value="2"<cfif len(get_app_identy.BLOOD_TYPE) and (get_app_identy.BLOOD_TYPE eq 2)>selected</cfif>>A Rh+</option>
				<option value="3"<cfif len(get_app_identy.BLOOD_TYPE) and (get_app_identy.BLOOD_TYPE eq 3)>selected</cfif>>A Rh-</option>
				<option value="4"<cfif len(get_app_identy.BLOOD_TYPE) and (get_app_identy.BLOOD_TYPE eq 4)>selected</cfif>>B Rh+</option>
				<option value="5"<cfif len(get_app_identy.BLOOD_TYPE) and (get_app_identy.BLOOD_TYPE eq 5)>selected</cfif>>B Rh-</option>
				<option value="6"<cfif len(get_app_identy.BLOOD_TYPE) and (get_app_identy.BLOOD_TYPE eq 6)>selected</cfif>>AB Rh+</option>
				<option value="7"<cfif len(get_app_identy.BLOOD_TYPE) and (get_app_identy.BLOOD_TYPE eq 7)>selected</cfif>>AB Rh-</option>
			</select>
		</td>
	</tr>
	<tr height="22">
		<td><cf_get_lang dictionary_id='58033.Baba Adı'></td>
		<td><cfinput name="father" type="text" value="#get_app_identy.father#" maxlength="75" style="width:150px;"></td>
		<td><cf_get_lang dictionary_id='58440.Ana Adı'></td>
		<td><cfinput name="mother" type="text" value="#get_app_identy.mother#" maxlength="75" style="width:150px;"></td>
	</tr>
	<tr>
		<td><cf_get_lang dictionary_id='56151.Baba İş'></td>
		<td><cfinput type="text" name="father_job" value="#get_app_identy.father_job#" maxlength="50" style="width:150px;"></td>
		<td><cf_get_lang dictionary_id='56152.Anne İş'></td>
		<td><cfinput type="text" name="mother_job" value="#get_app_identy.mother_job#" maxlength="50" style="width:150px;"></td>
	</tr>
	<tr height="22">
		<td><cf_get_lang dictionary_id='55640.Önceki Soyadı'></td>
		<td><cfinput type="text" name="LAST_SURNAME" style="width:150px;" maxlength="100" value="#get_app_identy.LAST_SURNAME#"></td>
		<td><cf_get_lang dictionary_id='55651.Dini'></td>
		<td><cfinput type="text" name="religion" style="width:150px;" maxlength="50" value="#get_app_identy.religion#"></td>
	</tr>
	<tr height="22">
		<td colspan="4"><STRONG><cf_get_lang dictionary_id='55641.Nüfusa Kayıtlı Olduğu'></STRONG></td>
	</tr>
	<tr height="22">
		<td><cf_get_lang dictionary_id='58638.İlçe'></td>
		<td><cfinput type="text" name="COUNTY" style="width:150px;" maxlength="100" value="#get_app_identy.COUNTY#"></td>
		<td><cf_get_lang dictionary_id='55655.Cilt No'></td>
		<td><cfinput type="text" name="BINDING" style="width:150px;" maxlength="20" value="#get_app_identy.BINDING#"></td>
	</tr>
	<tr height="22">
		<td><cf_get_lang dictionary_id='58735.Mahalle'></td>
		<td><cfinput type="text" name="WARD" style="width:150px;" maxlength="100" value="#get_app_identy.WARD#"></td>
		<td><cf_get_lang dictionary_id='55656.Aile Sıra No'></td>
		<td><cfinput type="text" name="FAMILY" style="width:150px;" maxlength="20" value="#get_app_identy.FAMILY#"></td>
	</tr>
	<tr height="22">
		<td><cf_get_lang dictionary_id='55645.Köy'></td>
		<td><cfinput type="text" name="VILLAGE" style="width:150px;" maxlength="100" value="#get_app_identy.VILLAGE#"></td>
		<td><cf_get_lang dictionary_id='55657.Sıra No'></td>
		<td><cfinput type="text" name="CUE" style="width:150px;" maxlength="20" value="#get_app_identy.CUE#"></td>
	</tr>
	<tr height="22">
		<td colspan="4"><STRONG><cf_get_lang dictionary_id='55646.Cüzdanın'></STRONG></td>
	</tr>
	<tr height="22">
		<td><cf_get_lang dictionary_id='55647.Verildiği Yer'></td>
		<td><cfinput type="text" name="GIVEN_PLACE" style="width:150px;" maxlength="100" value="#get_app_identy.GIVEN_PLACE#"></td>
		<td><cf_get_lang dictionary_id='55658.Kayıt No'></td>
		<td><cfinput type="text" name="RECORD_NUMBER" style="width:150px;" maxlength="50" value="#get_app_identy.RECORD_NUMBER#"></td>
	</tr>
	<tr height="22">
		<td><cf_get_lang dictionary_id='55648.Veriliş Nedeni'></td>
		<td><cfinput type="text" name="GIVEN_REASON" style="width:150px;" maxlength="300" value="#get_app_identy.GIVEN_REASON#"></td>
		<td><cf_get_lang dictionary_id='55659.Veriliş Tarihi'></td>
		<td>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='55790.veriliş tarihi'></cfsavecontent>
			<cfinput type="text" style="width:150px;" name="GIVEN_DATE" value="#dateformat(get_app_identy.GIVEN_DATE,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
			<cf_wrk_date_image date_field="GIVEN_DATE">
		</td>
	</tr>
</table>
<!---Eğitim Bilgileri --->
<table style="display:none;" id="gizli3">
	<tr>
		<td>
		<cfquery name="get_edu_info" datasource="#DSN#">
			SELECT * FROM EMPLOYEES_APP_EDU_INFO WHERE EMPAPP_ID = #attributes.empapp_id#
		</cfquery>
		<cf_form_list>
			<thead>
				<input type="hidden" name="row_edu" id="row_edu" value="<cfoutput>#get_edu_info.recordcount#</cfoutput>">
				<tr>
					<th colspan="2" style="text-align:center;;">
						<input name="record_numb_edu" id="record_numb_edu" type="hidden" value="0"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_add_edu_info&ctrl_edu=0','medium');"><img src="/images/plus_list.gif" alt="Eğitim Bilgisi Ekle" border="0"></a>
					</th>
					<th style="width:100px;"><cf_get_lang dictionary_id ='56481.Okul Türü'></th>
					<th style="width:100px;"><cf_get_lang dictionary_id ='56482.Okul Adı'></th>
					<th style="width:100px;"><cf_get_lang dictionary_id ='56483.Başl Yılı'></th>
					<th style="width:100px;"><cf_get_lang dictionary_id ='56484.Bitiş Yılı'></th>
					<th style="width:50px;"><cf_get_lang dictionary_id ='56153.Not Ort'>.</th>
					<th style="width:100px;"><cf_get_lang dictionary_id='57995.Bölüm'></th>
				</tr>
			</thead>
			<tbody id="table_edu_info">
				<cfoutput query="get_edu_info">
					<tr id="frm_row_edu#currentrow#">
						<input type="hidden" class="boxtext" name="empapp_edu_row_id#currentrow#" id="empapp_edu_row_id#currentrow#" style="width:100%;" value="#empapp_edu_row_id#">
						<td><a href="javascript://" onClick="gonder_upd_edu('#currentrow#');"><img src="../../images/update_list.gif" title="Eğitim Bilgisi Güncelle" border="0"></a></td>
						<td><input  type="hidden" value="1" name="row_kontrol_edu#currentrow#" id="row_kontrol_edu#currentrow#"><a href="javascript://" onClick="sil_edu('#currentrow#');"><img  src="images/delete_list.gif" border="0"></a></td>
						<td>
							<input type="hidden" name="edu_type#currentrow#" id="edu_type#currentrow#" class="boxtext" value="#edu_type#" readonly>
								<cfif len(edu_type)>
									<cfquery name="get_education_level_name" datasource="#dsn#">
										SELECT EDU_LEVEL_ID,EDUCATION_NAME,EDU_TYPE FROM SETUP_EDUCATION_LEVEL WHERE EDU_LEVEL_ID =#edu_type#
									</cfquery>
									<cfset edu_type_name=get_education_level_name.education_name>
									<cfset edu_type_ = get_education_level_name.EDU_TYPE>											
								</cfif>												
							<input type="text" name="edu_type_name#currentrow#" id="edu_type_name#currentrow#" class="boxtext" value="<cfif len(edu_type)>#edu_type_name#</cfif>" style="width:80px;" readonly>
						</td>
						<td>
							<cfif len(edu_id) and edu_id neq -1>
								<cfquery name="get_unv_name" datasource="#dsn#">
									SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_ID = #edu_id#
								</cfquery>
								<cfset edu_name_degisken = get_unv_name.SCHOOL_NAME>
							<cfelse>
								<cfset edu_name_degisken = edu_name>
							</cfif>
							<input type="hidden" name="edu_id#currentrow#" id="edu_id#currentrow#" class="boxtext" value="<cfif len(edu_id)>#edu_id#</cfif>" readonly>
							<input type="text" style="width:185px;" name="edu_name#currentrow#" id="edu_name#currentrow#" class="boxtext" value="#edu_name_degisken#" readonly>
						</td>
						<td><input type="text" style="width:70px;" name="edu_start#currentrow#" id="edu_start#currentrow#" class="boxtext" value="#edu_start#" readonly></td>
						<td><input type="text" style="width:70px;" name="edu_finish#currentrow#" id="edu_finish#currentrow#" class="boxtext" value="#edu_finish#" readonly></td>
						<td><input type="text" style="width:40px;" name="edu_rank#currentrow#" id="edu_rank#currentrow#" class="boxtext" value="#edu_rank#" readonly></td>
						<td>
							<cfif (len(edu_part_id) and edu_part_id neq -1)>
								<cfif get_education_level_name.edu_type eq 1> <!--- edu_type 0:İlköğretim,1:lise,2:üniversite--->
										<cfquery name="get_high_school_part_name" datasource="#dsn#">
											SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART WHERE HIGH_PART_ID = #edu_part_id#
										</cfquery>
										<cfset edu_part_name_degisken = get_high_school_part_name.HIGH_PART_NAME>
								<cfelse>
										<cfquery name="get_school_part_name" datasource="#dsn#">
											SELECT PART_ID, PART_NAME FROM SETUP_SCHOOL_PART WHERE PART_ID = #edu_part_id#
										</cfquery>
										<cfset edu_part_name_degisken = get_school_part_name.PART_NAME>
								</cfif>
							<cfelseif len(edu_part_name)>
									<cfset edu_part_name_degisken = edu_part_name>
							<cfelse>
									<cfset edu_part_name_degisken = "">
							</cfif>
							<input type="text" name="edu_part_name#currentrow#" id="edu_part_name#currentrow#" style="width:150;" class="boxtext" value="#edu_part_name_degisken#" readonly>
							<input type="hidden" name="edu_high_part_id#currentrow#" id="edu_high_part_id#currentrow#" class="boxtext" value="<cfif isdefined("edu_part_id") and len(edu_part_id) and edu_type_ eq 1>#edu_part_id#</cfif>">
							<input type="hidden" name="edu_part_id#currentrow#" id="edu_part_id#currentrow#" class="boxtext" value="<cfif edu_type_ eq 2 and isdefined("edu_part_id") and len(edu_part_id)>#edu_part_id#</cfif>">
							<input type="hidden" name="is_edu_continue#currentrow#" id="is_edu_continue#currentrow#" class="boxtext" value="#is_edu_continue#">
						</td>
					</tr>
				</cfoutput>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="8"><cf_get_lang dictionary_id='55337.Eğitim Seviyesi'>
						<select name="training_level" id="training_level">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfloop query="get_edu_level">
								<option value="<cfoutput>#get_edu_level.edu_level_id#</cfoutput>" <cfif get_app.training_level eq get_edu_level.edu_level_id>selected</cfif>><cfoutput>#get_edu_level.education_name#</cfoutput></option>
							</cfloop>
						</select>
					</td>
				</tr>
			</tfoot>
		</cf_form_list>
		<cf_form_list>
		<cfquery name="get_emp_language" datasource="#dsn#">
			SELECT 
				EMPAPP_ID,
				LANG_ID,
				LANG_SPEAK,
				LANG_WRITE,
				LANG_MEAN,
				LANG_WHERE 
			FROM 
				EMPLOYEES_APP_LANGUAGE
			WHERE
				EMPAPP_ID = #EMPAPP_ID#
		</cfquery>
		<input type="hidden" name="add_lang_info" id="add_lang_info" value="<cfoutput>#get_emp_language.recordcount#</cfoutput>">
		<thead>
			<tr>
				<th style="width:15px;"><a href="javascript://" onClick="add_lang_info_();"><img src="images/plus_list.gif" title="Ekle"></a></th>
				<th style="width:100px;"><cf_get_lang dictionary_id='58996.Dil'></th>
				<th style="width:100px;"><cf_get_lang dictionary_id='56158.Konuşma'></th>
				<th style="width:100px;"><cf_get_lang dictionary_id='56159.Anlama'></th>
				<th style="width:100px;"><cf_get_lang dictionary_id='56160.Yazma'></th>
				<th><cf_get_lang dictionary_id='56161.Öğrenildiği Yer'></th>
			</tr>
		</thead>
		<input type="hidden" name="language_info" id="language_info" value="">
		<tbody id="lang_info">
			<cfoutput query="get_emp_language">
				<tr id="lang_info_#currentrow#">
					<td><a style="cursor:pointer" onClick="del_lang('#currentrow#');"><img  src="images/delete_list.gif" border="0"></a></td>
					<td>
						<select name="lang#currentrow#" id="lang#currentrow#" style="width:100px;">
							<option value=""><cf_get_lang dictionary_id='58996.Dil'></option>
							<cfloop query="get_languages">
								<option value="#language_id#"<cfif language_id eq get_emp_language.LANG_ID>selected</cfif>>#language_set#</option>
							</cfloop>
						</select>
					</td>
					<td>
						<select name="lang_speak#currentrow#" id="lang_speak#currentrow#" style="width:100px;">
							<cfloop query="know_levels">
								<option value="#knowlevel_id#"<cfif knowlevel_id eq get_emp_language.lang_speak>selected</cfif>>#knowlevel#</option>
							</cfloop>
						</select>
					</td>
					<td>
						<select name="lang_mean#currentrow#" id="lang_mean#currentrow#" style="width:100px;">
							<cfloop query="know_levels">
								<option value="#knowlevel_id#"<cfif knowlevel_id eq get_emp_language.lang_mean>selected</cfif>>#knowlevel#</option>
							</cfloop>
						</select>
					</td>
					<td>
						<select name="lang_write#currentrow#" id="lang_write#currentrow#" style="width:100px;">
							<cfloop query="know_levels">
								<option value="#knowlevel_id#"<cfif knowlevel_id eq get_emp_language.lang_write>selected</cfif>>#knowlevel#</option>
							</cfloop>
						</select>
					</td>
					<td>
						<input type="text" name="lang_where#currentrow#" id="lang_where#currentrow#" value="#get_emp_language.lang_where#" style="width:150px;">
						<input type="hidden" name="del_lang_info#currentrow#" id="del_lang_info#currentrow#" value="1">
					</td>
				</tr>
			</cfoutput>
		</tbody>
		</cf_form_list>
		<table>
			<tr>
				<td class="txtbold" colspan="6"><cf_get_lang dictionary_id='56162.Kurs - Seminer ve Akademik Olmayan Programlar'></td>
			</tr>
		</table>
		<cf_form_list>
			<thead>
				<input type="hidden" name="extra_course" id="extra_course" value="<cfoutput>#get_emp_course.recordcount#</cfoutput>">
				<tr>
					<th style="width:15px;"><a style="cursor:pointer" onClick="add_row_course();"><img src="images/plus_list.gif" alt="Ekle"></a></th>
					<th width="115"><cf_get_lang dictionary_id="30919.Eğitim Konusu"></th>
					<th width="115"><cf_get_lang dictionary_id="37611.Eğitim Veren Kurum"></th>
					<th width="140"><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th width="115"><cf_get_lang dictionary_id='58455.Yıl'></th>
					<th width="115"><cf_get_lang dictionary_id='29513.Sure'></th>
				</tr>
			</thead>
			<tbody id="add_course_pro">
			<cfif isdefined("get_emp_course")>
				<cfoutput query="get_emp_course">
					<tr id="pro_course#currentrow#">
						<td><a style="cursor:pointer" onClick="sil_('#currentrow#');"><img  src="images/delete_list.gif" border="0"></a></td>
						<td><input type="text" name="kurs1_#currentrow#" id="kurs1_#currentrow#" value="#COURSE_SUBJECT#" style="width:115px;"></td>
						<td><input type="text" name="kurs1_yer#currentrow#" id="kurs1_yer#currentrow#" value="#course_location#" style="width:115px;"></td>
						<td><input type="text" name="kurs1_exp#currentrow#" id="kurs1_exp#currentrow#" value="#COURSE_EXPLANATION#" style="width:140px;"  maxlength="200"></td>
						<td><input type="text" name="kurs1_yil#currentrow#" id="kurs1_yil#currentrow#" value="#left(course_year,4)#" maxlength="4" onKeyup="isNumber(this);" style="width:115px;"></td>
						<td>
							<input type="text" name="kurs1_gun#currentrow#" id="kurs1_gun#currentrow#" value="#course_period#" style="width:115px;">
							<input type="hidden" name="del_course_prog#currentrow#" id="del_course_prog#currentrow#" value="1">
						</td>
					</tr>
				</cfoutput>
			</cfif>
			</tbody>
		</cf_form_list>
		<table>
			<tr>
				<td class="txtbold" colspan="6"><cf_get_lang dictionary_id='55957.Bilgisayar Bilgisi'></td>
			</tr>
		</table>
		<table>
			<tr>
				<td valign="top">
					<select name="computer_education" id="computer_education" style="width:220px; height:90px;" multiple>
						<cfoutput query="get_computer_info">
							<option value="#computer_info_id#" <cfif get_teacher_info.recordcount and len(get_teacher_info.computer_education) and listfind(get_teacher_info.computer_education,computer_info_id,',')>selected</cfif>>#computer_info_name#</option>
						</cfoutput>
						<option value="-1" <cfif get_teacher_info.recordcount and len(get_teacher_info.computer_education) and listfind(get_teacher_info.computer_education,-1,',')>selected</cfif>>Diğer</option>
					</select>
				</td>
				<td valign="top"><textarea name="comp_exp" id="comp_exp" style="width:310px;height:90px;"><cfoutput>#get_app.COMP_EXP#</cfoutput></textarea></td>
			</tr>
		</table>
		<table>
			<tr>
				<td colspan="2"><cf_get_lang dictionary_id="38610.Paket Program Bilgisi"></td>
			</tr>
			<tr>
				<td colspan="2"><textarea name="comp_packet_pro" id="comp_packet_pro" style="width:536px;height:70px;"><cfif isdefined("get_app.com_packet_pro") and len(get_app.com_packet_pro)><cfoutput>#get_app.com_packet_pro#</cfoutput></cfif></textarea></td>
			</tr>
			<tr>
				<td colspan="2"><cf_get_lang dictionary_id="37597.Ofis Araçları Bilgisi"></td>
			</tr>
			<tr>
				<td colspan="2"><textarea name="electronic_tools" id="electronic_tools" style="width:536px;height:70px;"><cfif isdefined("get_app.electronic_tools") and len(get_app.electronic_tools)><cfoutput>#get_app.electronic_tools#</cfoutput></cfif></textarea></td>
			</tr>
		</table>
		</td>
	 </tr>
</table>
<cfquery name="get_work_info" datasource="#DSN#">
    SELECT
        *
    FROM
        EMPLOYEES_APP_WORK_INFO
    WHERE
        EMPAPP_ID=#attributes.empapp_id#
</cfquery>
<cf_form_list style="display:none;" id="gizli4">
                                    <input type="hidden" name="row_count" id="row_count" value="<cfoutput>#get_work_info.recordcount#</cfoutput>">
                                    <thead>
                                        <tr>
                                            <th colspan="2" style="text-align:center; width:30px;"><input name="record_num" id="record_num" type="hidden" value="0"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_upd_work_info&control=0</cfoutput>','medium');"><img src="/images/plus_list.gif" alt="İş Tecrübesi Ekle" border="0"></a></th>
                                            <th width="120"><cf_get_lang dictionary_id='56485.Çalışılan Yer'></th>
                                            <th width="120"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                                            <th width="120"><cf_get_lang dictionary_id='57579.Sektör'></th>
                                            <th width="120"><cf_get_lang dictionary_id='57571.Ünvan'></th>
                                            <th width="120"><cf_get_lang dictionary_id='57655.Başlama Tarihi'></th>
                                            <th width="120"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
                                        </tr>
                                    </thead>
                                    <tbody id="table_work_info">
                                        <cfoutput query="get_work_info">
                                        <tr id="frm_row#currentrow#">
                                            <td><a href="javascript://" onClick="gonder_upd('#currentrow#');"><img src="../../images/update_list.gif" alt="İş Tecrübesi Güncelle" border="0"></a></td>
                                            <td>
                                                <input  type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#">
                                                <a href="javascript://" onClick="sil('#currentrow#');"><img  src="images/delete_list.gif" border="0"></a>
                                            </td>
                                            <input type="hidden" name="exp_telcode#currentrow#" id="exp_telcode#currentrow#" class="boxtext" value="#exp_telcode#">
                                            <input type="hidden" name="exp_tel#currentrow#" id="exp_tel#currentrow#" class="boxtext" value="#exp_tel#">
                                            <input type="hidden" name="exp_salary#currentrow#" id="exp_salary#currentrow#" class="boxtext" value="#exp_salary#">
                                            <input type="hidden" name="exp_extra_salary#currentrow#" id="exp_extra_salary#currentrow#" class="boxtext" value="#exp_extra_salary#">
                                            <input type="hidden" name="exp_extra#currentrow#" id="exp_extra#currentrow#" class="boxtext" value="#exp_extra#">
                                            <input type="hidden" name="exp_reason#currentrow#" id="exp_reason#currentrow#" class="boxtext" value="#exp_reason#">
                                            <input type="hidden" name="is_cont_work#currentrow#" id="is_cont_work#currentrow#" class="boxtext" value="#is_cont_work#">
                                            <input type="hidden" class="boxtext" name="empapp_row_id#currentrow#" id="empapp_row_id#currentrow#" value="#empapp_row_id#">
                                            <td><input type="text" name="exp_name#currentrow#" id="exp_name#currentrow#" class="boxtext" value="#exp#" readonly></td>
                                            <td><input type="text" name="exp_position#currentrow#" id="exp_position#currentrow#" class="boxtext" value="#exp_position#" readonly></td>
                                            <td>
                                                <input type="hidden" name="exp_sector_cat#currentrow#" id="exp_sector_cat#currentrow#" class="boxtext" value="#exp_sector_cat#">

                                                <cfif isdefined("exp_sector_cat") and len(exp_sector_cat)>
                                                    <cfquery name="get_sector_cat" datasource="#dsn#">
                                                        SELECT SECTOR_CAT_ID,SECTOR_CAT FROM SETUP_SECTOR_CATS WHERE SECTOR_CAT_ID = #exp_sector_cat#
                                                    </cfquery>
                                                </cfif>
                                                <input type="text" name="exp_sector_cat_name#currentrow#" id="exp_sector_cat_name#currentrow#" class="boxtext" value="<cfif isdefined("exp_sector_cat") and len(exp_sector_cat) and get_sector_cat.recordcount>#get_sector_cat.sector_cat#</cfif>" readonly="readonly">
                                            </td>
                                            <td>
                                                <input type="hidden" name="exp_task_id#currentrow#" id="exp_task_id#currentrow#" class="boxtext" value="#exp_task_id#">
                                                <cfif isdefined("exp_task_id") and len(exp_task_id)>
                                                    <cfquery name="get_exp_task_name" datasource="#dsn#">
                                                        SELECT PARTNER_POSITION_ID,PARTNER_POSITION FROM SETUP_PARTNER_POSITION WHERE PARTNER_POSITION_ID = #exp_task_id#
                                                    </cfquery>
                                                </cfif>
                                                <input type="text" name="exp_task_name#currentrow#" id="exp_task_name#currentrow#" style="width:100px;" class="boxtext" value="<cfif isdefined("exp_task_id") and len(exp_task_id) and get_exp_task_name.recordcount>#get_exp_task_name.partner_position#</cfif>" readonly="readonly">
                                            </td>
                                            <td><input type="text" name="exp_start#currentrow#" id="exp_start#currentrow#" style="width:70px;" class="boxtext" value="#dateformat(exp_start,dateformat_style)#" readonly="readonly"></td>
                                            <td><input type="text" name="exp_finish#currentrow#" id="exp_finish#currentrow#" style="width:70px;" class="boxtext" value="#dateformat(exp_finish,dateformat_style)#" readonly="readonly"></td>
                                        </tr>
                                        </cfoutput>
                                    </tbody>
                                </cf_form_list>
                                
                                
                                <!---Aile Bilgileri --->
								<cf_form_list  style="display:none;" id="gizli7">
                                    <thead>
                                        <tr>
                                            <input type="hidden" name="rowCount" id="rowCount" value="">
                                            <th><input type="button" class="eklebuton" title="Ekle" onClick="addRow()"></th>
                                            <th width="70"><cf_get_lang dictionary_id='57631.Ad'></th>
                                            <th width="70"><cf_get_lang dictionary_id='58726.Soyad'></th>
                                            <th width="70" nowrap="nowrap"><cf_get_lang dictionary_id='56171.Yakınlık Derecesi'></th>
                                            <th width="90" nowrap="nowrap"><cf_get_lang dictionary_id='58727.Doğum Tarihi'></th>
                                            <th width="80" nowrap="nowrap"><cf_get_lang dictionary_id='57790.Doğum Yeri'></th>
                                            <th width="120" nowrap="nowrap"><cf_get_lang dictionary_id='57419.Eğitim'></th>
                                            <th width="70"><cf_get_lang dictionary_id='55494.Meslek'></th>
                                            <th width="70"><cf_get_lang dictionary_id='57574.Şirket'></th>
                                            <th width="70"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                                        </tr>
                                    </thead>
                                    <tbody id="table_list">
                                        <cfquery name="get_relatives" datasource="#DSN#">
                                            SELECT
                                                *
                                            FROM
                                                EMPLOYEES_RELATIVES
                                            WHERE
                                                EMPAPP_ID=#attributes.empapp_id#
                                            ORDER BY
                                                BIRTH_DATE, NAME, SURNAME, RELATIVE_LEVEL
                                        </cfquery>
                                        <cfif get_relatives.recordcount>
                                            <cfoutput query="get_relatives">
                                                <input type="hidden" id="relative_id#currentrow#" name="relative_id#currentrow#" value="#get_relatives.relative_id#">
                                                <input type="hidden" id="relative_sil#currentrow#" name="relative_sil#currentrow#" value="0">
                                                <tr id="frm_row#currentrow#">
                                                    <td><a href="javascript://" onClick="relative_sil(#currentrow#);"><img src="../../images/delete_list.gif" border="0" alt="Sil"></a></td>
                                                    <td><input type="text" id="name_relative#currentrow#" name="name_relative#currentrow#" value="#get_relatives.name#" maxlength="50" style="width:75px;"></td>
                                                    <td><input type="text" id="surname_relative#currentrow#" name="surname_relative#currentrow#" value="#get_relatives.surname#" maxlength="50" style="width:75px;"></td>
                                                    <td>
                                                        <select name="relative_level#currentrow#" id="relative_level#currentrow#" style="width:105px;">
                                                            <option value="1" <cfif get_relatives.relative_level eq 1>selected</cfif>><cf_get_lang dictionary_id='55265.Baba'></option>
                                                            <option value="2" <cfif get_relatives.relative_level eq 2>selected</cfif>><cf_get_lang dictionary_id='55470.Anne'></option>
                                                            <option value="3" <cfif get_relatives.relative_level eq 3>selected</cfif>><cf_get_lang dictionary_id='55275.Eşi'></option>
                                                            <option value="4" <cfif get_relatives.relative_level eq 4>selected</cfif>><cf_get_lang dictionary_id='55253.Oğlu'></option>
                                                            <option value="5" <cfif get_relatives.relative_level eq 5>selected</cfif>><cf_get_lang dictionary_id='55234.Kızı'></option>
                                                            <option value="6" <cfif get_relatives.relative_level eq 6>selected</cfif>><cf_get_lang dictionary_id="31449.Kardeşi"></option>
                                                         </select>
                                                    </td>
                                                    <td nowrap="nowrap">
                                                        <cfinput type="text" id="birth_date_relative#currentrow#" name="birth_date_relative#currentrow#" value="#dateformat(get_relatives.birth_date,dateformat_style)#" validate="#validate_style#" maxlength="10" style="width:65px;">
                                                        <cf_wrk_date_image date_field="birth_date_relative#currentrow#">
                                                    </td>
                                                    <td><cfinput type="text" name="birth_place_relative#currentrow#" value="#get_relatives.birth_place#" style="width:75px;"></td>
                                                    <td nowrap="nowrap">
                                                        <select name="education_relative#currentrow#" id="education_relative#currentrow#" style="width:65px;">
                                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                            <cfloop query="get_edu_level">
                                                            <option value="#get_edu_level.edu_level_id#" <cfif get_edu_level.edu_level_id eq get_relatives.education>selected</cfif>>#get_edu_level.education_name#</option>
                                                            </cfloop>
                                                        </select>
                                                        <input type="checkbox" name="education_status_relative#currentrow#" id="education_status_relative#currentrow#" value="1" <cfif get_relatives.education_status eq 1>checked</cfif>><cf_get_lang dictionary_id="55483.Okuyor">
                                                    </td>
                                                    <td><cfinput type="text" name="job_relative#currentrow#" value="#get_relatives.job#" style="width:75px;" maxlength="30"></td>
                                                    <td><cfinput type="text" name="company_relative#currentrow#" value="#get_relatives.company#" style="width:75px;" maxlength="50"></td>
                                                    <td><cfinput type="text" name="job_position_relative#currentrow#" value="#get_relatives.job_position#" style="width:75px;" maxlength="30"></td>
                                                </tr>
                                            </cfoutput>
                                        </cfif>
                                    </tbody>
                                </cf_form_list>
</cfform>

