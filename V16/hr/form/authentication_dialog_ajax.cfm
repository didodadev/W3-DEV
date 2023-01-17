<cf_xml_page_edit fuseact="hr.add_cv">
<cfinclude template="../query/get_id_card_cats.cfm">
<cfinclude template="../query/get_mobil_cats.cfm">
<cfinclude template="../query/get_edu_level.cfm">
<cfinclude template="../query/get_im_cats.cfm">
<cfinclude template="../ehesap/query/get_our_comp_and_branchs.cfm">
<cfparam name="attributes.homecity" default="">
<cfparam name="attributes.county_id" default="">
<cfparam name="attributes.homecounty" default="">
<cfparam name="attributes.branch_id" default="#listgetat(session.ep.USER_LOCATION,2,'-')#">
<cfquery name="get_unv" datasource="#dsn#">
	SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL ORDER BY SCHOOL_NAME
</cfquery>
<cfquery name="get_school_part" datasource="#dsn#">
	SELECT PART_ID, PART_NAME FROM SETUP_SCHOOL_PART ORDER BY PART_NAME
</cfquery>
<cfquery name="get_high_school_part" datasource="#dsn#">
	SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART ORDER BY HIGH_PART_NAME
</cfquery>
<cfquery name="get_cv_status" datasource="#dsn#">
	SELECT 
		STATUS_ID,
		ICON_NAME,
		STATUS
	FROM
		SETUP_CV_STATUS
</cfquery>
<cfquery name="get_reference_type" datasource="#dsn#">
	SELECT REFERENCE_TYPE_ID,REFERENCE_TYPE FROM SETUP_REFERENCE_TYPE
</cfquery>
<cfquery name="GET_LANGUAGES" datasource="#dsn#">
	SELECT LANGUAGE_ID,LANGUAGE_SET FROM SETUP_LANGUAGES ORDER BY LANGUAGE_SET
</cfquery>
<cfquery name="KNOW_LEVELS" datasource="#dsn#">
	SELECT KNOWLEVEL_ID,KNOWLEVEL FROM SETUP_KNOWLEVEL
</cfquery>
<cfquery name="get_city" datasource="#dsn#">
	SELECT CITY_ID, CITY_NAME FROM SETUP_CITY ORDER BY CITY_NAME
</cfquery>
<cfquery name="get_country" datasource="#dsn#">
	SELECT COUNTRY_ID,COUNTRY_NAME,IS_DEFAULT FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
</cfquery>
<cfquery name="get_branch" datasource="#dsn#">
	SELECT 
		BRANCH_ID,
		BRANCH_NAME,
		BRANCH_CITY
	FROM 
		BRANCH
	WHERE BRANCH_STATUS =1
	ORDER BY BRANCH_NAME
</cfquery>
<cfform name="employee_dt" method="post" action="#request.self#?fuseaction=hr.authentication_dialog_ajax">
	<!--- Kimlik ve iletişim--->
    <table id="gizli0">
        <tr>
            <td colspan="2">
                <input type="radio" value="0" name="cv_type" id="cv_type" checked="checked" onclick="referans_calistir();"> <cf_get_lang dictionary_id="38581.Güncel Cv">
                <input type="radio" value="1" name="cv_type" id="cv_type" onclick="referans_calistir();"> <cf_get_lang dictionary_id="38580.Referanslı Cv">
            </td>
        </tr>
        <tr id="referans_area" style="display:none;">
            <td><cf_get_lang dictionary_id="38625.Referans Adı Soyad"></td>
            <td><cfinput type="text" name="reference_name" id="reference_name" style="width:75px;"  maxlength="50"> <cfinput type="text" name="reference_surname" style="width:75px;"  maxlength="50"></td>
            <td><cf_get_lang dictionary_id="38624.Referans Görevi"></td>
            <td><cfinput type="text" name="reference_position" id="reference_position" style="width:150px;"  maxlength="100"></td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id ='58859.Süreç'></td>
            <td><cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0' fusepath="form_add_cv"></td>
            <td width="80"><cf_get_lang dictionary_id="37619.Giriş Yapan"></td>
            <td>
                <cfinput type="hidden" name="cv_recorder_emp_id" id="cv_recorder_emp_id" value="#session.ep.userid#">
                <cfinput type="text" name="cv_recorder_emp_name" id="cv_recorder_emp_name" style="width:150px;" value="#session.ep.name# #session.ep.surname#">
                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&select_list=1&field_name=employe_detail.cv_recorder_emp_name&field_emp_id=employe_detail.cv_recorder_emp_id','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id="41457.İlgili Şube"></td>
            <td colspan="3">
                <select name="branch_id" id="branch_id" style="width:480px;">
                  <option value=""><cf_get_lang dictionary_id="57453.Şube"></option>
                  <cfoutput query="get_our_comp_and_branchs">
                    <option value="#branch_id#"<cfif isdefined('attributes.branch_id') and (attributes.branch_id eq branch_id)> selected</cfif>>#BRANCH_NAME#</option>
                  </cfoutput>
                </select>
            </td>
        </tr>
        <tr>
          <td height="22" colspan="4" class="formbold"><cf_get_lang dictionary_id="31234.Kimlik Bilgileri"></td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='56135.Uyruğu'></td>
            <td><select name="nationality" id="nationality" style="width:150px;">
                    <cfoutput query="get_country">
                    <option value="#country_id#"<cfif get_country.is_default eq 1>selected</cfif>>#country_name#</option>
                    </cfoutput>
                </select>
            </td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='55649.TC Kimlik No'><cfif xml_is_tc_number eq 1>*</cfif></td>
            <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='31325.TC Kimlik No girmelisiniz'></cfsavecontent>
                <cfif xml_is_tc_number eq 1>
                    <cfinput type="text" name="TC_IDENTY_NO" id="TC_IDENTY_NO" style="width:150px;" validate="integer" message="#message#" maxlength="11" required="yes">
                <cfelse>
                    <cfinput type="text" name="TC_IDENTY_NO" id="TC_IDENTY_NO" style="width:150px;" validate="integer" maxlength="11">
                </cfif>
            </td>
        </tr>
        <tr>
            <td width="110"><cf_get_lang dictionary_id='57631.Ad'>*</td>
            <td width="200">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57631.Ad '> !</cfsavecontent>
                <cfinput type="text" name="name" id="name" style="width:150px;" maxlength="50" required="Yes" message="#message#">
            </td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='58726.Soyad'>*</td>
            <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58726.Soyad'></cfsavecontent>
                <cfinput type="text" name="surname" id="surname" style="width:150px;" maxlength="50" required="Yes" message="#message#">
            </td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='57790.Doğum Yeri'></td>
            <td><cfinput type="text" style="width:150px;" name="birth_place" id="birth_place" maxlength="100" value=""></td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='57790.Doğum Yeri'><cf_get_lang dictionary_id='58608.İl'></td>
            <td>
                <select name="birth_city" id="birth_city" style="width:150px;">
                    <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                    <cfoutput query="get_city">
                        <option value="#city_id#">#city_name#</option>
                    </cfoutput>
                </select>			
            </td>		
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='58727.Doğum Tarih'></td>
            <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='55788.Doğum Tarihi girmelisiniz'></cfsavecontent>
                <cfinput type="text" style="width:150px;" name="birth_date" id="birth_date" value="" validate="#validate_style#" maxlength="10" message="Doğum Tarihi !">
                <cf_wrk_date_image date_field="birth_date">
            </td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='57764.Cinsiyet'></td>
            <td><input type="radio" name="sex" id="sex" value="1" checked onclick="document.getElementById('trAskerlik').style.display='inline'; document.getElementById('military_status').checked = true;">
                <cf_get_lang dictionary_id='58959.Erkek'>
                <input type="radio" name="sex" id="sex" value="0" onclick="document.getElementById('trAskerlik').style.display = 'none'; document.getElementById('military_status').checked = false;">
                <cf_get_lang dictionary_id='55621.Kadın'>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='55654.Medeni Durum'></td>
            <td>
                <input type="radio" name="married" id="married" value="0" checked>
                <cf_get_lang dictionary_id='55744.Bekar'>
                <input type="radio" name="married" id="married" value="1">
                <cf_get_lang dictionary_id='55743.Evli'>
            </td>
        </tr>
        <tr>
          <td height="22" colspan="4" class="formbold"><cf_get_lang dictionary_id="35131.İletişim Bilgileri"></td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='58482.Mobil Tel'></td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='55454.Mobil Telefon girmelisiniz'></cfsavecontent>
                <cfinput type="text" name="mobilcode" id="mobilcode" style="width:40px;" maxlength="3" validate="integer" message="#message#">
                <cfinput type="text" name="mobil" id="mobil" style="width:107px;" maxlength="7" validate="integer" message="#message#">
            </td>
            <td><cf_get_lang dictionary_id='57428.e-mail'></td>
            <td><cfinput type="text" name="email" id="email" style="width:150px;" maxlength="100" validate="email" message="E-mail adresini giriniz!"></td>
        </tr>
        <tr>
            <td width="110"><cf_get_lang dictionary_id='55593.Ev Tel'></td>
            <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='55601.Ev Telefonu girmelisiniz'></cfsavecontent>
                <cfinput type="text" name="hometelcode" id="hometelcode" style="width:40px;" maxlength="3" validate="integer" message="#message#" >
                <cfinput type="text" name="hometel" id="hometel" style="width:107px;" maxlength="7" validate="integer" message="#message#" >
            </td>
            <td><cf_get_lang dictionary_id='58482.Mobil Tel'> 2</td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='55454.Mobil Telefon girmelisiniz'></cfsavecontent>
                <cfinput type="text" name="mobilcode2" id="mobilcode2" maxlength="3" validate="integer" message="#message#" style="width:40px;">
                <cfinput type="text" name="mobil2" id="mobil2" style="width:107px;" maxlength="7" validate="integer" message="#message#">
            </td>
        </tr>
        <tr>
            <td rowspan="4" valign="top"><cf_get_lang dictionary_id='55594.Ev Adresi'></td>
            <td width="200" rowspan="4">
                <cfsavecontent variable="message2"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                <textarea name="homeaddress" id="homeaddress"  style="width:150px;height:85px;" message="<cfoutput>#message2#</cfoutput>" maxlength="500" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);"></textarea>
            </td>
            <td><cf_get_lang dictionary_id='55595.Posta Kodu'></td>
            <td><cfinput type="text" name="homepostcode" id="homepostcode" style="width:150px;" maxlength="10"></td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='58219.Ülke'></td>
            <td>
                <select name="homecountry" id="homecountry" style="width:150px;" onChange="LoadCity(this.value,'homecity','county_id');">
                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <cfoutput query="get_country">
                    <option value="#get_country.country_id#" <cfif get_country.is_default eq 1>selected</cfif>>#get_country.country_name#</option>
                    </cfoutput>
                </select>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='57971.Şehir'></td>
            <td>
                <select name="homecity" id="homecity" style="width:150px;" onChange="LoadCounty(this.value,'county_id');">
                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <cfoutput query="get_city">
                        <option value="#get_city.city_id#"<cfif attributes.homecity eq get_city.city_id>selected</cfif>>#get_city.city_name#</option>
                    </cfoutput>
                </select>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='58638.İlçe'></td>
            <td>
                <select name="county_id" id="county_id" style="width:150px;">
                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <cfif isdefined('attributes.homecity') and len(attributes.homecity)>
                        <cfquery name="GET_COUNTY_NAME" datasource="#DSN#">
                            SELECT * FROM SETUP_COUNTY WHERE CITY = #attributes.homecity#
                        </cfquery>
                        <cfoutput query="get_county_name">
                            <option value="#county_id#" <cfif attributes.county_id eq county_id>selected</cfif>>#county_name#</option>
                        </cfoutput>
                    </cfif>
                </select>
            </td>
        </tr>
        <tr>
            <td width="120"><cf_get_lang dictionary_id='55445.Direkt Tel'></td>
            <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='55443.Direkt Telefon girmelisiniz'></cfsavecontent>
                <cfinput type="text" name="worktelcode" id="worktelcode" style="width:48px;" maxlength="3" validate="integer" message="#message#">
                <cfinput type="text" name="worktel" id="worktel" style="width:99px;" maxlength="7" validate="integer" message="#message#">
            </td>
            <td><cf_get_lang dictionary_id='55446.Dahili Tel'></td>
            <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='55453.Dahili Telefon girmelisiniz'></cfsavecontent>
                <cfinput type="text" name="extension" id="extension" style="width:150px;" maxlength="5" validate="integer" message="#message#">
            </td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='56131.Oturduğunuz Ev'></td>
            <td colspan="3">
                <select name="home_status" id="home_status" style="width:150px;">
                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <option value="1"><cf_get_lang dictionary_id='56132.Kendinizin'></option>
                    <option value="2"><cf_get_lang dictionary_id='56133.Ailenizin'></option>
                    <option value="3"><cf_get_lang dictionary_id='56134.Kira'></option>
                </select>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='55444.Instant Mesaj'></td>
            <td>
                <select name="imcat_id" id="imcat_id" style="width:48px;" >
                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                <cfoutput query="im_cats">
                <option value="#imcat_id#">#imcat# </option>
                </cfoutput>
                </select>
                <cfinput type="text" name="im" id="im" style="width:99px;" maxlength="30">
            </td>
            <td><cf_get_lang dictionary_id='58762.Vergi Dairesi'></td>
            <td><cfinput type="text" name="tax_office" id="tax_office" style="width:150px;" maxlength="50"></td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='55110.Fotoğraf'></td>
            <td><input type="file" name="photo" id="photo" style="width:150px;"></td>
            <td><cf_get_lang dictionary_id='57752.Vergi No'></td>
            <td><cfinput type="text" name="tax_number" id="tax_number" style="width:150px;" maxlength="50"></td>
        </tr>			
        <tr>
            <td><cf_get_lang dictionary_id='55902.Kimlik Kartı Tipi'></td>
            <td><cf_wrk_combo 
                     query_name="GET_IDENTYCARD" 
                     name="identycard_cat" 
                     option_value="identycat_id" 
                     option_name="identycat"
                     width=150>
            </td>
            <td><cf_get_lang dictionary_id='55903.Kimlik Kartı No'></td>
            <td><cfinput type="text" name="identycard_no" id="identycard_no" style="width:150px;" maxlength="50"></td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='55155.Nüfusa Kayıtlı Olduğu İl'></td>
            <td><cfinput type="text" name="CITY" id="CITY" style="width:150px;" maxlength="100" value=""></td>
            <td height="22" width="120"><cf_get_lang dictionary_id='55439.Şifre*(key sensitive)'></td>
            <td><cfinput value="" type="password" name="empapp_password" id="empapp_password" style="width:150px;" maxlength="16" message="Şifre"></td>
        </tr>
        <tr>
            <td colspan="4">
                <div style="float:left;">
                <input type="button" name="next_step" id="next_step" value="Bir Sonraki Adım" onclick="hepsini_gizle('Kişisel Bilgiler');goster(gizli1);" />&nbsp;
                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                </div>
            </td>
        </tr>
    </table>
    <!--- Kimlik Bilgileri --->
    <table id="gizli1" style="display:none;">
        <tr>
            <td><cf_get_lang dictionary_id='56136.Eşinin Adı'></td>
            <td><cfinput type="text" name="partner_name" id="partner_name" value="" maxlength="150" style="width:150px;"></td>
            <td><cf_get_lang dictionary_id='55618.Eşinin Ç Şirket'></td>
            <td><cfinput type="text" name="partner_company" id="partner_company" maxlength="50" style="width:150px;"></td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='55633.Eşinin Pozisyonu'></td>
            <td><cfinput type="text" name="partner_position" id="partner_position" maxlength="50" style="width:150px;"></td>
            <td><cf_get_lang dictionary_id='56137.Çocuk Sayısı'></td>
            <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='55942.çocuk sayısı girmelisiniz'></cfsavecontent>
                <cfinput type="text" name="child" id="child" maxlength="2" style="width:150px;" validate="integer" message="#message#">
            </td>
        </tr>
        <tr>
            <td width="110"><cf_get_lang dictionary_id='56138.Sigara Kullanıyor mu'></td>
            <td width="200"><input type="radio" name="use_cigarette" id="use_cigarette"  value="1">
                <cf_get_lang dictionary_id='57495.Evet'>
                <input type="radio" name="use_cigarette" id="use_cigarette" value="0" checked>
                <cf_get_lang dictionary_id='57496.Hayır'> </td>
            <td><cf_get_lang dictionary_id='56139.Şehit Yakını Misiniz'></td>
            <td><input type="radio" name="martyr_relative" id="martyr_relative" value="1">
                <cf_get_lang dictionary_id='57495.Evet'>
                <input type="radio" name="martyr_relative" id="martyr_relative" value="0" checked>
                <cf_get_lang dictionary_id='57496.Hayır'>
            </td>
        </tr>
        <tr>
            <td width="110"><cf_get_lang dictionary_id='55614.Özürlü'></td>
            <td width="200"><input type="radio" name="defected" id="defected" value="1" onClick="seviye();">
                <cf_get_lang dictionary_id='57495.Evet'>
                <input type="radio" name="defected" id="defected" value="0" checked onClick="seviye();">
                <cf_get_lang dictionary_id='57496.Hayır'> &nbsp;&nbsp;&nbsp;
                <select name="defected_level" id="defected_level"  disabled>
                    <option value="0">%0</option>
                    <option value="10">%10</option>
                    <option value="20">%20</option>
                    <option value="30">%30</option>
                    <option value="40">%40</option>
                    <option value="50">%50</option>
                    <option value="60">%60</option>
                    <option value="70">%70</option>
                    <option value="80">%80</option>
                    <option value="90">%90</option>
                    <option value="100">%100</option>
                </select>
            </td>
            <td><cf_get_lang dictionary_id="55136.Psikoteknik"></td> 
            <td><input type="radio" name="psikoteknik" id="psikoteknik" value="1">
                <cf_get_lang dictionary_id='57495.Evet'>
                <input type="radio" name="psikoteknik" id="psikoteknik" value="0" checked>
                <cf_get_lang dictionary_id='57496.Hayır'>
            </td>  
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='31670.Hüküm Giydi mi'></td>
            <td>
            <input type="radio" name="sentenced" id="sentenced" value="1">
            <cf_get_lang dictionary_id='57495.Evet'> 
            <input type="radio" name="sentenced" id="sentenced" value="0" checked>
            <cf_get_lang dictionary_id='57496.Hayır'></td>
            <td><cf_get_lang dictionary_id='55629.Ehliyet Sınıf / Yıl'></td>
            <td>
            <cfquery name="GET_DRIVER_LIS" datasource="#DSN#">
                SELECT LICENCECAT,LICENCECAT_ID FROM SETUP_DRIVERLICENCE ORDER BY LICENCECAT
            </cfquery>
                <select name="driver_licence_type" id="driver_licence_type" style="width:80px;">
                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                <cfoutput query="get_driver_lis">
                    <option value="#licencecat_id#">#licencecat#</option>
                </cfoutput>
                </select>
                <cfsavecontent variable="message_driver"><cf_get_lang dictionary_id='56601.Ehliyet Yılına Geçerli Bir Tarih Girmelisiniz'></cfsavecontent>
                <cfinput type="text" name="licence_start_date" id="licence_start_date" value="" maxlength="10" validate="#validate_style#" message="#message_driver#" style="width:66px;">
                <cf_wrk_date_image date_field="licence_start_date">
            </td>	
        </tr>
        <tr>  	
            <td><cf_get_lang dictionary_id='55432.Göçmen'></td>
            <td><input type="radio" name="immigrant" id="immigrant" value="1">
                <cf_get_lang dictionary_id='57495.Evet'>
                <input type="radio" name="immigrant" id="immigrant" value="0" checked>
                <cf_get_lang dictionary_id='57496.Hayır'>
            </td>
            <td><cf_get_lang dictionary_id='55630.Ehliyet No'></td>
            <td><cfinput type="Text" name="driver_licence" id="driver_licence" maxlength="40"  style="width:150px;"></td>
        </tr>
        <tr>
            <td colspan="3"><cf_get_lang dictionary_id='56140.Kaç yıldır aktif olarak araba kullanıyorsunuz'></td>
            <td><cfinput type="Text" name="driver_licence_actived" id="driver_licence_actived" maxlength="2"  style="width:150px;" validate="integer" message="Ehliyet Aktiflik Süresine Sayı Giriniz!"></td>
        </tr>
        <tr>
            <td colspan="3"><cf_get_lang dictionary_id='55343.Bir suç zannıyla tutuklandınız mı veya mahkumiyetiniz oldu mu'></td>
            <td><input type="radio" name="defected_probability" id="defected_probability" value="1"><cf_get_lang dictionary_id='57495.Evet'> &nbsp;
                <input type="radio" name="defected_probability" id="defected_probability" value="0" checked><cf_get_lang dictionary_id='57496.Hayır'>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='55341.Varsa nedir?'></td>
            <td colspan="3"><cfinput type="text" name="investigation" id="investigation" value="" maxlength="150" style="width:150px;"></td>
        </tr>
        <tr>
            <td colspan="3"><cf_get_lang dictionary_id='55342.Devam eden bir hastalık veya bedeni sorununuz var mı'></td>
            <td><input type="radio" name="illness_probability" id="illness_probability" value="1"><cf_get_lang dictionary_id='57495.Evet'> &nbsp;
                <input type="radio" name="illness_probability" id="illness_probability" value="0" checked><cf_get_lang dictionary_id='57496.Hayır'>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='55341.Varsa nedir?'></td>
            <td><textarea name="illness_detail" id="illness_detail" style="width:150px;"></textarea></td>
            <td><cf_get_lang dictionary_id='56142.Geçirdiğiniz Ameliyat'></td>
            <td>	
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                <textarea name="surgical_operation" id="surgical_operation" style="width:150px;" message="<cfoutput>#message#</cfoutput>" maxlength="150" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);"></textarea>
            </td>
        </tr>
        <tr height="22" id="trAskerlik">
            <td><cf_get_lang dictionary_id='55619.Askerlik'></td>
            <td colspan="3">
                <input type="radio" name="military_status" id="military_status" value="0" onClick="tecilli_fonk(this.value)" checked>
                <cf_get_lang dictionary_id='55624.Yapmadı'>&nbsp;&nbsp;&nbsp;
                <input type="radio" name="military_status" id="military_status" value="1" onClick="tecilli_fonk(this.value)">
                <cf_get_lang dictionary_id='55625.Yaptı'>&nbsp;&nbsp;&nbsp;
                <input type="radio" name="military_status" id="military_status" value="2" onClick="tecilli_fonk(this.value)">
                <cf_get_lang dictionary_id='55626.Muaf'>&nbsp;&nbsp;&nbsp;
                <input type="radio" name="military_status" id="military_status" value="3" onClick="tecilli_fonk(this.value)">
                <cf_get_lang dictionary_id='55627.Yabancı'> &nbsp;&nbsp;&nbsp;
                <input type="radio" name="military_status" id="military_status" value="4" onClick="tecilli_fonk(this.value)">
                <cf_get_lang dictionary_id='55340.Tecilli'>
            </td>
        </tr>
        <tr  height="22" style="display:none" id="Tecilli">
            <td><cf_get_lang dictionary_id='55339.Tecil Gerekçesi'></td>
            <td><cfinput type="text" name="military_delay_reason" id="military_delay_reason" style="width:150px;" maxlength="30"></td>
            <td><cf_get_lang dictionary_id='55338.Tecil Süresi'></td>
            <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='55796.Tecil Süresi girmelisiniz'></cfsavecontent>
                <cfinput type="text" style="width:150px;" name="military_delay_date" id="military_delay_date" value="" validate="#validate_style#" maxlength="10" message="#message#">
                <cf_wrk_date_image date_field="military_delay_date">
            </td>
        </tr>
        <tr height="22" style="display:none" id="Muaf">
            <td><cf_get_lang dictionary_id='56143.Muaf Olma Nedeni'></td>
            <td><input type="text" style="width:150px;" name="military_exempt_detail" id="military_exempt_detail" maxlength="100" value=""></td>
        </tr>
        <tr height="22" style="display:none" id="Yapti">
            <td colspan="4">
            <table border="0">
                <tr>
                    <td width="110"><cf_get_lang dictionary_id='56144.Terhis Tarihi'></td>
                    <td width="200"><cfsavecontent variable="message"><cf_get_lang dictionary_id='55796.Tecil Süresi Girmelisiniz'></cfsavecontent>
                        <cfinput type="text" style="width:150px;" name="military_finishdate" id="military_finishdate" value="" validate="#validate_style#" maxlength="10" message="#message#">
                        <cf_wrk_date_image date_field="military_finishdate">
                    </td>
                    <td width="100" nowrap><cf_get_lang dictionary_id='56145.Süresi'> (<cf_get_lang dictionary_id='56146.Ay Olarak Giriniz'>)</td>
                    <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='56147.Askerlik Süresi Girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="military_month" id="military_month" validate="integer" maxlength="2" message="#message#" style="width:150px;">
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td><input type="radio" name="military_rank" id="military_rank" value="0"> <cf_get_lang dictionary_id='56148.Er'></td>
                    <td></td>
                    <td><input type="radio" name="military_rank" id="military_rank" value="1"> <cf_get_lang dictionary_id='56149.Yedek Subay'></td>
                </tr>
                </table> 
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <div style="float:left;">
                    <input type="button" name="next_step" id="next_step" value="<cf_get_lang dictionary_id='38623.Bir Sonraki Adım'>" onclick="hepsini_gizle('Kimlik Detayları');goster(gizli2);" />&nbsp;
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                </div>
            </td>
       </tr>
    </table>
    <!--- Kimlik detayları--->
    <table id="gizli2" style="display:none;">
        <tr>
            <td>
                <table>
                    <tr>
                        <td width="110"><cf_get_lang dictionary_id='57637.Seri No'></td>
                        <td width="200">
                            <cfinput type="text" name="series" id="series" style="width:50px;" maxlength="20" value="">
                            <cfinput type="text" name="number" id="number" style="width:87px;" maxlength="50" value="">
                        </td>
                        <td width="100"><cf_get_lang dictionary_id='58441.Kan Grubu'></td>
                        <td>
                            <select name="BLOOD_TYPE" id="BLOOD_TYPE" style="width:140px;">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="0"><cf_get_lang dictionary_id="38622.0 Rh+"></option>
                                <option value="1"><cf_get_lang dictionary_id="38621.0 Rh-"></option>
                                <option value="2"><cf_get_lang dictionary_id="38618.A Rh+"></option>
                                <option value="3"><cf_get_lang dictionary_id="38617.A Rh-"></option>
                                <option value="4"><cf_get_lang dictionary_id="38616.B Rh+"></option>
                                <option value="5"><cf_get_lang dictionary_id="38615.B Rh-"></option>
                                <option value="6"><cf_get_lang dictionary_id="38613.AB Rh+"></option>
                                <option value="7"><cf_get_lang dictionary_id="38612.AB Rh-"></option>
                            </select>
                        </td>
                    </tr>
                    <tr height="22">
                        <td><cf_get_lang dictionary_id='58033.Baba Adı'></td>
                        <td><cfinput name="father" id="father" type="text" value="" maxlength="75" style="width:140px;"></td>
                        <td><cf_get_lang dictionary_id='58440.Ana Adı'></td>
                        <td><cfinput name="mother" id="mother" type="text" value="" maxlength="75" style="width:140px;"></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='56151.Baba İş'></td>
                        <td><cfinput type="text" name="father_job" id="father_job" value="" maxlength="50" style="width:140px;"></td>
                        <td><cf_get_lang dictionary_id='56152.Anne İş'></td>
                        <td><cfinput type="text" name="mother_job" id="mother_job" value="" maxlength="50" style="width:140px;"></td>
                    </TR>
                    <tr height="22">
                        <td><cf_get_lang dictionary_id='55640.Önceki Soyadı'></td>
                        <td><cfinput type="text" name="LAST_SURNAME" id="LAST_SURNAME" style="width:140px;" maxlength="100" value=""></td>
                        <td><cf_get_lang dictionary_id='55651.Dini'></td>
                        <td><cfinput type="text" name="religion" id="religion" style="width:140px;" maxlength="50" value="">
                        </td>
                    </tr>
                    <tr height="22">
                        <td colspan="4"><STRONG><cf_get_lang dictionary_id='55641.Nüfusa Kayıtlı Olduğu'></STRONG></td>
                    </tr>
                    <tr height="22">
                        <td><cf_get_lang dictionary_id='58638.İlçe'></td>
                        <td><cfinput type="text" name="COUNTY" id="COUNTY" style="width:140px;" maxlength="100" value="">
                        </td>
                        <td><cf_get_lang dictionary_id='55655.Cilt No'></td>
                        <td><cfinput type="text" name="BINDING" id="BINDING" style="width:140px;" maxlength="20" value="">
                        </td>
                    </tr>
                    <tr height="22">
                        <td><cf_get_lang dictionary_id='58735.Mahalle'></td>
                        <td><cfinput type="text" name="WARD" id="WARD" style="width:140px;" maxlength="100" value="">
                        </td>
                        <td><cf_get_lang dictionary_id='55656.Aile Sıra No'></td>
                        <td><cfinput type="text" name="FAMILY" id="FAMILY" style="width:140px;" maxlength="20" value="">
                        </td>
                    </tr>
                    <tr height="22">
                        <td><cf_get_lang dictionary_id='55645.Köy'></td>
                        <td><cfinput type="text" name="VILLAGE" id="VILLAGE" style="width:140px;" maxlength="100" value="">
                        </td>
                        <td><cf_get_lang dictionary_id='55657.Sıra No'></td>
                        <td><cfinput type="text" name="CUE" id="CUE" style="width:140px;" maxlength="20" value="">
                        </td>
                    </tr>
                    <tr height="22">
                        <td colspan="4"><STRONG><cf_get_lang dictionary_id='55646.Cüzdanın'></STRONG></td>
                    </tr>
                    <tr height="22">
                        <td><cf_get_lang dictionary_id='55647.Verildiği Yer'></td>
                        <td><cfinput type="text" name="GIVEN_PLACE" id="GIVEN_PLACE" style="width:140px;" maxlength="100" value="">
                        </td>
                        <td><cf_get_lang dictionary_id='55658.Kayıt No'></td>
                        <td><cfinput type="text" name="RECORD_NUMBER" id="RECORD_NUMBER" style="width:140px;" maxlength="50" value="">
                        </td>
                    </tr>
                    <tr height="22">
                        <td><cf_get_lang dictionary_id='55648.Veriliş Nedeni'></td>
                        <td><cfinput type="text" name="GIVEN_REASON" id="GIVEN_REASON" style="width:140px;" maxlength="300" value="">
                        </td>
                        <td><cf_get_lang dictionary_id='55659.Veriliş Tarihi'></td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='55790.Veriliş Tarihi girmelisiniz'></cfsavecontent>
                            <cfinput type="text" style="width:140px;" name="GIVEN_DATE" id="GIVEN_DATE" value="" validate="#validate_style#" maxlength="10" message="#message#">
                            <cf_wrk_date_image date_field="GIVEN_DATE">
                        </td>
                    </tr>
                </table>
                <div style="float:left;">
                    <input type="button" name="next_step" id="next_step" value="Bir Sonraki Adım" onclick="hepsini_gizle('Eğitim  Bilgileri');goster(gizli3);" />&nbsp;
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                </div>
            </td>
       </tr>
    </table>
    <!--- Eğitim --->
    <table style="display:none" id="gizli3">
        <tr>
            <td valign="top">
                <cf_form_list>
                    <thead>
                        <input type="hidden" name="row_edu" id="row_edu" value="0">
                        <tr>
                            <th width="40" style="text-align:center;" colspan="2"><input name="record_numb_edu" id="record_numb_edu" type="hidden" value="0"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_add_edu_info&ctrl_edu=0','medium');"><img src="/images/plus_list.gif" alt="Eğitim Bilgisi Ekle" border="0"></a></th>
                            <th style="width:100px;"><cf_get_lang dictionary_id ='56481.Okul Türü'></th>
                            <th style="width:100px;"><cf_get_lang dictionary_id ='56482.Okul Adı'></th>
                            <th style="width:50px;"><cf_get_lang dictionary_id ='56483.Başl Yılı'></th>
                            <th style="width:50px;"><cf_get_lang dictionary_id ='56484.Bitiş Yılı'></th>
                            <th style="width:100px;"><cf_get_lang dictionary_id ='56153.Not Ort'>.</th>
                            <th style="width:150px;"><cf_get_lang dictionary_id='57995.Bölüm'></th>
                        </tr>
                        <input type="hidden" name="edu_type" id="edu_type" value="">
                        <input type="hidden" name="edu_id" id="edu_id" value="">
                        <input type="hidden" name="edu_name" id="edu_name" value="">
                        <input type="hidden" name="edu_start" id="edu_start" value="">
                        <input type="hidden" name="edu_finish" id="edu_finish" value="">
                        <input type="hidden" name="edu_rank" id="edu_rank" value="">
                        <input type="hidden" name="edu_high_part_id" id="edu_high_part_id" value="">
                        <input type="hidden" name="edu_part_id" id="edu_part_id" value="">
                        <input type="hidden" name="edu_part_name" id="edu_part_name" value="">
                        <input type="hidden" name="is_edu_continue" id="is_edu_continue" value=""> 
                    </thead>
                    <tbody id="table_edu_info"></tbody>
                    <tfoot>
                        <tr>
                            <td width="110" colspan="8"><cf_get_lang dictionary_id='55337.Eğitim Seviyesi'>
                                <select name="training_level" id="training_level" style="width:190px;">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfloop query="get_edu_level">
                                    <option value="<cfoutput>#get_edu_level.edu_level_id#</cfoutput>"><cfoutput>#get_edu_level.education_name#</cfoutput></option>
                                    </cfloop>
                                </select>
                            </td>
                        </tr>
                    </tfoot>
                </cf_form_list>
                <cf_form_list>
                    <input type="hidden" name="add_lang_info" id="add_lang_info" value="">
                    <thead>
                        <tr>
                            <th style="width:15px; text-align:center;"><a href="javascript://" onClick="add_lang_info_();"><img src="images/plus_list.gif" title="Ekle"></a></th>
                            <th style="width:100px;"><cf_get_lang dictionary_id='58996.Dil'></th>
                            <th style="width:100px;"><cf_get_lang dictionary_id='56158.Konuşma'></th>
                            <th style="width:100px;"><cf_get_lang dictionary_id='56159.Anlama'></th>
                            <th style="width:100px;"><cf_get_lang dictionary_id='56160.Yazma'></th>
                            <th style="width:150px;"><cf_get_lang dictionary_id='56161.Öğrenildiği Yer'></th>
                        </tr>
                    </thead>
                    <input type="hidden" name="language_info" id="language_info" value="">
                    <tbody id="lang_info"></tbody>
                </cf_form_list>
                <table>
                    <tr>
                        <td class="formbold"><cf_get_lang dictionary_id='56162.Kurs - Seminer ve Akademik Olmayan Programlar'></td>
                    </tr>
                </table>
                <cf_form_list>
                    <thead>
                        <input type="hidden" name="extra_course" id="extra_course" value="0"> 
                        <input type="hidden" name="emp_course" id="emp_course" value="">
                        <tr>
                            <th style="text-align:center;width:15px;"><a style="cursor:pointer" onClick="add_row_course();"><img src="images/plus_list.gif" border="0" alt="Ekle"></a></th>
                            <th width="100"><cf_get_lang dictionary_id="30919.Eğitim Konusu"></th>
                            <th width="100"><cf_get_lang dictionary_id="37611.Eğitim Veren Kurum"></td>
                            <th width="100"><cf_get_lang dictionary_id='57629.Açıklama'></th>
                            <th width="100"><cf_get_lang dictionary_id='58455.Yıl'></th>
                            <th width="150"><cf_get_lang dictionary_id='29513.Sure'></th>
                        </tr>
                    </thead>
                    <tbody id="add_course_pro"></tbody>
                </cf_form_list>
                <table>
                    <tr>
                        <td><cf_get_lang dictionary_id='55957.Bilgisayar Bilgisi'></td>
                    </tr>
                    <tr>
                        <td><textarea name="comp_exp" id="comp_exp" style="width:600px;height:70px;"></textarea></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id="38610.Paket Program Bilgisi"></td>
                    </tr>
                    <tr>
                        <td><textarea name="comp_packet_pro" id="comp_packet_pro" style="width:600px;height:70px;"></textarea></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id="37597.Ofis Araçları Bilgisi"></td>
                    </tr>
                    <tr>
                        <td><textarea name="electronic_tools" id="electronic_tools" style="width:600px;height:70px;"></textarea></td>
                    </tr>
                     <tr>
                        <td colspan="2">
                            <div style="float:left;">
                                <input type="button" name="next_step" id="next_step" value="<cf_get_lang dictionary_id='38623.Bir Sonraki Adım'>" onclick="hepsini_gizle('İş Tecrübesi');goster(gizli4);" />&nbsp;
                                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                            </div>
                        </td>
                   </tr>
                </table>
            </td>
        </tr>
    </table>
    <!--- Deneyim --->
    <table id="gizli4" style="display:none;">
        <tr>    
            <td valign="top">
                <cf_form_list>
                    <thead>
                        <tr>
                            <th colspan="2" style="width:30px; text-align:center;"><input name="record_numb" id="record_numb" type="hidden" value="0"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_upd_work_info&control=0</cfoutput>','medium');"><img src="/images/plus_list.gif" alt="İş Tecrübesi Ekle" border="0"></a></th>
                            <th><cf_get_lang dictionary_id ='56485.Çalışılan Yer'></th>
                            <th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                            <th><cf_get_lang dictionary_id ='57579.Sektör'></th>
                            <th><cf_get_lang dictionary_id ='57571.Ünvan'></th>
                            <th><cf_get_lang dictionary_id ='57655.Başlama Tarihi'></th>
                            <th><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'></th>
                        </tr>
                        <input type="hidden" name="exp_name" id="exp_name" value="">
                        <input type="hidden" name="exp_position" id="exp_position" value="">
                        <input type="hidden" name="exp_sector_cat" id="exp_sector_cat" value="">
                        <input type="hidden" name="exp_task_id" id="exp_task_id" value="">
                        <input type="hidden" name="exp_start" id="exp_start" value="">
                        <input type="hidden" name="exp_finish" id="exp_finish" value="">
                        <input type="hidden" name="exp_telcode" id="exp_telcode" value="">
                        <input type="hidden" name="exp_tel" id="exp_tel" value="">
                        <input type="hidden" name="exp_salary" id="exp_salary" value="">
                        <input type="hidden" name="exp_extra_salary" id="exp_extra_salary" value="">
                        <input type="hidden" name="exp_extra" id="exp_extra" value="">
                        <input type="hidden" name="exp_reason" id="exp_reason" value="">
                        <input type="hidden" name="is_cont_work" id="is_cont_work" value="">
                    </thead>
                    <tbody id="table_work_info">
                    </tbody>
                <input type="hidden" name="row_count" id="row_count" value="0">
                </cf_form_list>
                <div style="float:left;">
                    <input type="button" name="next_step" id="next_step" value="Bir Sonraki Adım" onclick="hepsini_gizle('Referans Bilgileri');goster(gizli5);" />&nbsp;
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                </div>
            </td>
        </tr>
    </table>
    <!---referans --->
    <table id="gizli5" style="display:none;">
        <tr>    
            <td valign="top">
                <cf_form_list>
                <thead>
                    <input type="hidden" name="add_ref_info" id="add_ref_info" value="0">
                    <tr>
                        <th><a style="cursor:pointer" onClick="add_ref_info_();"><img src="images/plus_list.gif" alt="Ekle"></a></th>
                        <th width="90"><cf_get_lang dictionary_id='55240.Referans Tipi'></th>
                        <th width="100"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                        <th width="100"><cf_get_lang dictionary_id='57574.Sirket'></th>
                        <th width="100"><cf_get_lang dictionary_id='55920.Tel Kod'></th>
                        <th width="100"><cf_get_lang dictionary_id='55107.Telefon'></th>
                        <th width="100"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                        <th width="100"><cf_get_lang dictionary_id="32508.E-mail"></th>
                    </tr>
                    <input type="hidden" name="referance_info" id="referance_info" value="">
                </thead>
                <tbody id="ref_info"></tbody>
                </cf_form_list>
                <table width="100%">
                    <tr>
                        <td><cf_get_lang dictionary_id="37595.Grup şirketinde çalışan yakınınızın ismi"></td>
                        <td width="325"><cfinput type="text" name="related_ref_name" id="related_ref_name" style="width:180px;" maxlength="100" value=""></td>
                        <td><cf_get_lang dictionary_id="57574.Şirket"></td>
                        <td><cfinput type="text" name="related_ref_company" id="related_ref_company" style="width:180px;" maxlength="100" value=""></td>
                    </tr>
                </table>
                <div style="float:left;">
                    <input type="button" name="next_step" id="next_step" value="Bir Sonraki Adım" onclick="hepsini_gizle('Özel İlgi Alanları');goster(gizli6);" />
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                </div>
            </td>
        </tr>
    </table>
    <!---hobi--->
    <table id="gizli6" style="display:none;">
        <tr>
            <td valign="top" width="110"><cf_get_lang dictionary_id='56168.Özel İlgi Alanları'></td>
            <td colspan="2">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                <textarea name="hobby" id="hobby" style="width:250px;" message="<cfoutput>#message#</cfoutput>" maxlength="150" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);"></textarea>
            </td>
        </tr>
        <tr>
            <td width="110"><cf_get_lang dictionary_id='56169.Üye Olunan Klüp Ve Dernekler'></td>
            <td><textarea name="club" id="club" style="width:250px;" message="<cfoutput>#message#</cfoutput>" maxlength="250" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);"></textarea></td>
        </tr>
        <tr>
            <td colspan="2">
                <div style="float:left;">
                    <input type="button" name="next_step" id="next_step" value="Bir Sonraki Adım" onclick="hepsini_gizle('Aile Bilgileri');goster(gizli7);" />&nbsp;
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                </div>
            </td>
       </tr>
    </table>
    <!---aile bilgileri--->
    <table id="gizli7" style="display:none;">
        <tr>
            <td>
                <cf_form_list>
                <thead>
                    <tr>
                        <input type="hidden" name="rowCount" id="rowCount" value="0">
                        <th><input type="button" class="eklebuton" title="<cf_get_lang_main no ='170.Ekle'>" onClick="addRow();"></th>
                        <th><cf_get_lang dictionary_id='57631.Ad'></th>
                        <th><cf_get_lang dictionary_id='58726.Soyad'></th>
                        <th><cf_get_lang dictionary_id='56171.Yakınlık Derecesi'></th>
                        <th><cf_get_lang dictionary_id='58727.Doğum Tarihi'></th>
                        <th><cf_get_lang dictionary_id='57790.Doğum Yeri'></th>
                        <th><cf_get_lang dictionary_id='57419.Eğitim'></th>
                        <th><cf_get_lang dictionary_id='55494.Meslek'></th>
                        <th><cf_get_lang dictionary_id='57574.Şirket'></th>
                        <th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                      </tr>
                </thead>
                <tbody id="table_list"></tbody>
                </cf_form_list>
            </td>								
        </tr>
        <tr>
            <td colspan="2">
                <div style="float:left;">
                    <input type="button" name="next_step" id="next_step" value="Bir Sonraki Adım" onclick="hepsini_gizle('Çalışmak İstediğiniz Birimler');goster(gizli8);" />&nbsp;
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                </div>
            </td>
       </tr>
    </table>
    <!---çalışmak istediği birimler--->
    <table id="gizli8" style="display:none;">
        <tr height="25">
            <td colspan="4">(<cf_get_lang dictionary_id='56173.Öncelik sıralarını yandaki kutulara yazınız'>...)</td>
        </tr>
        <cfquery name="get_cv_unit" datasource="#DSN#">
            SELECT 
                * 
            FROM 
                SETUP_CV_UNIT
            WHERE 
                IS_ACTIVE=1
        </cfquery>
        <cfif get_cv_unit.recordcount>
            <tr class="txtbold">
                <cfoutput query="get_cv_unit">
                    <cfif get_cv_unit.currentrow-1 mod 3 eq 0><tr></cfif>
                      <td>#get_cv_unit.unit_name#</td>
                      <cfsavecontent variable="message"><cf_get_lang dictionary_id='55805.Sayı Giriniz!'>!</cfsavecontent>
                      <td><cfinput type="text" name="unit#get_cv_unit.unit_id#" id="unit#get_cv_unit.unit_id#" value="" validate="integer" message="#message#" maxlength="1" style="width:30px;" onchange="seviye_kontrol(this)"></td>
                    <cfif get_cv_unit.currentrow mod 3 eq 0 and get_cv_unit.currentrow-1 neq 0></tr></cfif>	  
                </cfoutput>
        <cfelse>
            <tr>
                <td><cf_get_lang dictionary_id='56174.Sisteme kayıtlı birim yok'></td>
            </tr>
        </cfif>
        <tr>
            <td colspan="2">
                <div style="float:left;">
                    <input type="button" name="next_step" id="next_step" value="Bir Sonraki Adım" onclick="hepsini_gizle('Şubeler');goster(gizli9);" />&nbsp;
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                </div>
            </td>
       </tr>
    </table>
    <!---Çalışılmak İstenen  Şubeler--->
    <table style="display:none;" id="gizli9">
        <tr>
            <td valign="top" width="60"><cf_get_lang dictionary_id='29434.Şubeler'></td>
            <td>
              <select name="preference_branch" id="preference_branch" style="width:220px; height:100px;" multiple>
                  <cfoutput query="get_branch">
                    <option value="#branch_id#">#branch_name# - #branch_city#</option>
                  </cfoutput>
              </select>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <div style="float:left;">
                    <input type="button" name="next_step" id="next_step" value="Bir Sonraki Adım" onclick="hepsini_gizle('Ek Bilgiler');goster(gizli10);" />&nbsp;
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                </div>
            </td>
       </tr>
    </table>
    <!---Ek Bilgiler --->
    <table id="gizli10" style="display:none;">
        <tr>
            <td><strong><cf_get_lang dictionary_id='55329.Çalışmak İstediğiniz Şehir'></strong></td>
            <td valign="top">
                <cfsavecontent variable="text"><cf_get_lang dictionary_id='56175.TÜM TÜRKİYE'></cfsavecontent>
                <cf_multiselect_check
                    name="prefered_city"
                    option_name="CITY_NAME"
                    option_value="CITY_ID"
                    table_name="SETUP_CITY"
                    is_option_text="1"
                    option_text="#text#"
                    >
            </td>
        </tr>
        <tr>
            <td><strong><cf_get_lang no='243.Seyahat Edebilir misiniz'>?</strong></td>
            <td>
                <input type="radio" name="IS_TRIP" id="IS_TRIP" value="1"><cf_get_lang dictionary_id='57495.Evet'>
                <input type="radio" name="IS_TRIP" id="IS_TRIP" value="0"><cf_get_lang dictionary_id='57496.Hayır'>
            </td>
        </tr>
        <tr>
            <td><strong><cf_get_lang no ='1404.İstenilen Ücret (Net)'></strong></td>
            <td>
                <cfinput type="text" name="expected_price" style="width:120px;" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
                  <select name="EXPECTED_MONEY_TYPE" id="EXPECTED_MONEY_TYPE" class="formselect" style="width:58px;">
                    <cfquery name="GET_MONEY" datasource="#dsn#">
                        SELECT
                            *
                        FROM
                            SETUP_MONEY
                        WHERE
                            PERIOD_ID = #SESSION.EP.PERIOD_ID#
                    </cfquery>
                    <cfoutput query="get_money">
                      <option value="#MONEY#">#MONEY#</option>
                    </cfoutput>
                  </select>
            </td>
        </tr>
        <tr>
            <td><strong><cf_get_lang dictionary_id="37582.Başlayabileceğiniz Tarih"></strong></td>
            <td>
                <cfinput type="text" style="width:120px;" name="work_start_date" value="" validate="#validate_style#" maxlength="10">
                <cf_wrk_date_image date_field="work_start_date">
            </td>
        </tr>
        <tr>
            <td><strong><cf_get_lang dictionary_id='55326.Eklemek İstedikleriniz'></strong></td>
            <td><textarea name="applicant_notes" id="applicant_notes" maxlength="300" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);" rows="4"  style="width:530px;"></textarea></td>
        </tr>
        <tr>
            <td><strong><cf_get_lang dictionary_id='55785.Mülakat Görüşü'></strong></td>
            <td><textarea name="interview_result" id="interview_result" style="width:530px;" maxlength="500" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);" rows="5"></textarea></td> 
        </tr>
        <tr>
            <td colspan="2"><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
        </tr>
    </table>
</cfform>
