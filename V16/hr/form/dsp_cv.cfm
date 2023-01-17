<cfif not isnumeric(attributes.empapp_id)>
	<cfset hata = 10>
	<cfinclude template="../../dsp_hata.cfm">
</cfif>
<cfset xfa.upd= "hr.emptypopup_upd_cv">
<cfset xfa.del= "hr.emptypopup_del_cv">
<cfinclude template="../query/get_app.cfm">
<cfif not get_app.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='38683.Özgeçmişin kaydı bulunamıyor kayıt silinmiş olabilir'>!");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
	<cfinclude template="../query/get_app_identy.cfm">
	<cfinclude template="../query/get_im_cats.cfm">
	<cfinclude template="../query/get_id_card_cats.cfm">
	<cfinclude template="../query/get_know_levels.cfm">
	<cfinclude template="../query/get_mobil_cats.cfm">
	<cfinclude template="../query/get_commethods.cfm">
	<cfinclude template="../query/get_moneys.cfm">
	<cfinclude template="../query/get_edu_level.cfm">
	<cfquery name="get_languages" datasource="#dsn#">
		SELECT LANGUAGE_ID,LANGUAGE_SET FROM SETUP_LANGUAGES
	</cfquery>
	<cfquery name="get_unv" datasource="#dsn#">
		SELECT SCHOOL_ID,SCHOOL_NAME FROM SETUP_SCHOOL
	</cfquery>
	<cfquery name="get_school_part" datasource="#dsn#">
		SELECT PART_ID,PART_NAME FROM SETUP_SCHOOL_PART
	</cfquery>
	<cfquery name="get_country" datasource="#dsn#">
		SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
	</cfquery>
	<cfquery name="get_high_school_part" datasource="#dsn#">
		SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART ORDER BY HIGH_PART_NAME
	</cfquery>
	<cfquery name="get_city" datasource="#dsn#">
		SELECT CITY_ID, CITY_NAME, PHONE_CODE, COUNTRY_ID FROM SETUP_CITY ORDER BY CITY_NAME
	</cfquery>
	<cfquery name="get_reference" datasource="#dsn#">
		SELECT * FROM EMPLOYEES_REFERENCE WHERE EMPAPP_ID = #EMPAPP_ID#
	</cfquery>
	
	<cfquery name="get_extra_course" datasource="#dsn#">
		SELECT * FROM EMPLOYEES_COURSE WHERE EMPAPP_ID = #EMPAPP_ID#
	</cfquery>
	<cfquery name="get_reference_type" datasource="#dsn#">
		SELECT REFERENCE_TYPE_ID,REFERENCE_TYPE FROM SETUP_REFERENCE_TYPE
	</cfquery>
    <cfsavecontent variable="txt">
        <cf_get_lang dictionary_id="29767.CV"> : <cfoutput>#get_app.name# #get_app.surname#</cfoutput>
        <div id="upload_status"> <font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b><cf_get_lang dictionary_id='55578.Resim Upload Ediliyor'></b></font></div>
    </cfsavecontent>
    <cf_form_box title="#txt#">
    <cfform name="employe_detail" action="#request.self#?fuseaction=#xfa.upd#" method="post" enctype="multipart/form-data">
	<input type="Hidden" name="empapp_id" id="empapp_id" value="<cfoutput>#empapp_id#</cfoutput>">
	<input type="Hidden" name="old_photo" id="old_photo" value="<cfoutput>#get_app.photo#</cfoutput>">
	<input type="hidden" name="counter" id="counter" value="">
	<input type="hidden" name="rowCount" id="rowCount" value="0">
	<cfif not len(get_app.valid)>
		<input type="Hidden" name="valid" id="valid" value="">
	</cfif>
        <!--- Kimlik ve İletişim Bilgileri--->
        <cfsavecontent variable="message"><cf_get_lang dictionary_id="56130.Kimlik ve İletişim Bilgileri"></cfsavecontent>
		<cf_seperator id="kisisel_bilgiler" header="#message#" is_closed="1">
        <table id="kisisel_bilgiler" style="display:none;">
            <tr>
                <cfoutput>
                <td><cf_get_lang dictionary_id='57487.No'></td>
                <td>#get_app.empapp_id#</td>
                <td><cf_get_lang dictionary_id='57493.Aktif'></td>
                <td><input type="checkbox" name="app_status" id="app_status" value="1" <cfif get_app.app_status eq 1>checked</cfif>></td>
                </cfoutput>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='57631.Ad'>*</td>
                <td>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58939.Ad Girmelisiniz'></cfsavecontent>
                    <cfinput type="text" value="#get_app.name#" name="name" style="width:150px;" maxlength="50" required="Yes" message="#message#">
                </td>
                <td><cf_get_lang dictionary_id='55445.Direkt Tel'></td>
                <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='55443.direkt tel girmelisiniz'></cfsavecontent>
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
                <td><cf_get_lang dictionary_id='55439.Şifre (karakter duyarlı)'></td>
                <td><cfinput value="" type="password" name="empapp_password" style="width:150px;" maxlength="16"></td>
                <td><cf_get_lang dictionary_id='58482.Mobil Tel'></td>
                <td><select name="mobilcode" id="mobilcode" style="width:48px;">
                    <cfoutput query="mobil_cats">
                    <option value="#mobilcat#" <cfif get_app.mobilcode eq mobilcat>selected</cfif>>#mobilcat# </cfoutput>
                    </select>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='55454.Mobil Telefon Girmelisiniz'></cfsavecontent>
                    <cfinput value="#get_app.mobil#" type="text" name="mobil" style="width:99px;" maxlength="7" validate="integer" message="#message#">
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='57428.webmail'></td>
                <td><cfinput type="text" name="email" style="width:150px;" maxlength="100" value="#get_app.email#">
                </td>
                <td><cf_get_lang dictionary_id='58482.Mobil Tel'>2</td>
                <td><select name="mobilcode2" id="mobilcode2" style="width:48px;">
                    <cfoutput query="mobil_cats">
                    <option value="#mobilcat#" <cfif get_app.mobilcode2 eq mobilcat>selected</cfif>>#mobilcat# </cfoutput>
                    </select>
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
                <td><cfinput type="text" name="homepostcode" style="width:150px;" maxlength="10" value="#get_app.homepostcode#">
                </td>
            </tr>
            <tr>
                <td rowspan="3" valign="top"><cf_get_lang dictionary_id='55594.Ev Adresi'></td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                <td rowspan="3"><textarea name="homeaddress" id="homeaddress" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>" style="width:150px;height:60px;"><cfoutput>#get_app.homeaddress#</cfoutput></textarea></td>
                <td><cf_get_lang dictionary_id='57992.Bölge'></td>
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
                    <select name="homecity" id="home_city" style="width:150px;" onChange="LoadCounty(this.value,'homecounty')">
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
                <select name="homecountry" id="homecountry" style="width:150px;" onChange="LoadCity(this.value,'homecity','homecounty',0)">
                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <cfoutput query="get_country">
                        <option value="#get_country.country_id#" <cfif get_app.homecountry eq country_id>selected</cfif>>#country_name#</option>
                    </cfoutput>
                </select>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='56131.Oturduğunuz Ev'></td>
                <td colspan="3">
                    <input type="radio" name="home_status" id="home_status" value="1" <cfif get_app.home_status eq 1>checked</cfif>>&nbsp;<cf_get_lang dictionary_id='56132.Kendinizin'>
                    <input type="radio" name="home_status" id="home_status" value="2" <cfif get_app.home_status eq 2>checked</cfif>>&nbsp;<cf_get_lang dictionary_id='56133.Ailenizin'>
                    <input type="radio" name="home_status" id="home_status" value="3" <cfif get_app.home_status eq 3>checked</cfif>>&nbsp;<cf_get_lang dictionary_id='56134.Kira'>
                </td>
            </tr>
                <tr>
                    <td><cf_get_lang dictionary_id='55444.Instant Mesaj'></td>
                    <td><select name="imcat_ID" id="imcat_ID" style="width:48px;" >
                        <cfoutput query="im_cats">
                        <option value="#imcat_id#" <cfif get_app.imcat_id eq imcat_id>selected</cfif>>#imcat# 
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
                        <cf_wrk_date_image date_field="birth_date"></td>
                    <td width="110"><cf_get_lang dictionary_id='57790.Doğum Yeri'></td>
                    <td><cfinput type="text" style="width:150px;" name="birth_place" maxlength="100" value="#get_app_identy.birth_place#">
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
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td width="115"><cf_get_lang dictionary_id='55902.Kimlik Kartı Tipi'></td>
                    <td width="190">
                        <select name="identycard_cat" id="identycard_cat" style="width:150px;" >
                        <cfoutput query="get_id_card_cats">
                        <option value="#identycat_id#" <cfif get_app.identycard_cat eq identycat_id>selected</cfif>>#identycat# </cfoutput>
                        </select>
                    </td>
                    <td><cf_get_lang dictionary_id='55903.Kimlik Kartı No'></td>
                    <td><cfinput type="text" name="identycard_no" style="width:150px;" maxlength="50" value="#get_app.identycard_no#"></td>
                </tr>
                <tr>
                    <td><cf_get_lang dictionary_id='55155.Nüfusa Kayıtlı Olduğu İl'></td>
                    <td>
                    <cfinput type="text" name="CITY" style="width:150px;" maxlength="100" value="#get_app_identy.CITY#">
                    </td>
                    <td width="100"><cf_get_lang dictionary_id='55649.TC Kimlik No'></td>
                    <td><cfinput type="text" name="TC_IDENTY_NO" style="width:150px;" maxlength="11" value="#get_app_identy.TC_IDENTY_NO#"></td>
                </tr>
            </table>
        <cfsavecontent variable="message"><cf_get_lang dictionary_id="55126.Kişisel Bilgiler"></cfsavecontent>
        <cf_seperator id="kisisel" header="#message#" is_closed="1">
        <table id="kisisel" style="display:none;">
            <tr>
                <td><cf_get_lang dictionary_id='57764.Cinsiyet'></td>
                <td>
                    <input type="radio" name="sex" id="sex" value="1" <cfif get_app.sex eq 1>checked</cfif>>
                    <cf_get_lang dictionary_id='58959.Erkek'>
                    <input type="radio" name="sex" id="sex" value="0" <cfif get_app.sex eq 0>checked</cfif>>
                    <cf_get_lang dictionary_id='55621.Kadın'> 
                </td>
                <td><cf_get_lang dictionary_id='55654.Medeni Durum'></td>
                <td>
                    <input type="radio" name="married" id="married" value="0" <cfif get_app_identy.married eq 0>checked</cfif>>
                    <cf_get_lang dictionary_id='55744.Bekar'>
                    <input type="radio" name="married" id="married" value="1" <cfif get_app_identy.married eq 1>checked</cfif>>
                    <cf_get_lang dictionary_id='55743.Evli'> 
                </td>
            </tr>
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
                <td width="115"><cf_get_lang dictionary_id='56138.Sigara Kullanıyor mu'>?</td>
                <td width="185"><input type="radio" name="use_cigarette" id="use_cigarette" value="1" <cfif get_app.use_cigarette eq 1>checked</cfif>>
                <cf_get_lang dictionary_id='57495.Evet'>
                <input type="radio" name="use_cigarette" id="use_cigarette" value="0" <cfif get_app.use_cigarette eq 0 or not len(get_app.use_cigarette)>checked</cfif>>
                <cf_get_lang dictionary_id='57496.Hayır'> </td>
                <td><cf_get_lang dictionary_id='56139.Şehit Yakını Misiniz'></td>
                <td><input type="radio" name="martyr_relative" id="martyr_relative" value="1" <cfif get_app.martyr_relative eq 1>checked</cfif>>
                <cf_get_lang dictionary_id='57495.Evet'>
                <input type="radio" name="martyr_relative" id="martyr_relative" value="0" <cfif get_app.martyr_relative eq 0 or not len(get_app.martyr_relative)>checked</cfif>>
                <cf_get_lang dictionary_id='57496.Hayır'>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='55614.Engelli'> </td>
                <td width="185">
                <input type="radio" name="defected" id="defected" value="1" onClick="seviye();" <cfif get_app.defected eq 1>checked</cfif>>
                <cf_get_lang dictionary_id='57495.Evet'>
                <input type="radio" name="defected" id="defected" value="0" onClick="seviye();" <cfif get_app.defected eq 0>checked</cfif>>
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
                <td colspan="2"></td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='55615.Eski Hukumlu'></td>
                <td>
                    <input type="radio" name="sentenced" id="sentenced" value="1" <cfif get_app.sentenced eq 1>checked</cfif>>
                    <cf_get_lang dictionary_id='57495.Evet'>
                    <input type="radio" name="sentenced" id="sentenced" value="0" <cfif get_app.sentenced eq 0>checked</cfif>>
                    <cf_get_lang dictionary_id='57496.Hayır'>
                </td>
                <td><cf_get_lang dictionary_id='55629.Ehliyet Tip/Yıl'></td>
                <td>
                <cfquery name="GET_DRIVER_LIS" datasource="#DSN#">
                    SELECT
                        *
                    FROM
                        SETUP_DRIVERLICENCE
                    ORDER BY
                        LICENCECAT
                </cfquery>
                    <select name="driver_licence_type" id="driver_licence_type" style="width:75;">
                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <cfoutput query="get_driver_lis">
                        <option value="#licencecat_id#"<cfif licencecat_id eq get_app.licencecat_id> selected</cfif>>#licencecat#</option>
                    </cfoutput>
                    </select>
                    <cfsavecontent variable="message_driver"><cf_get_lang dictionary_id='56704.Tarih Hatalı'></cfsavecontent>
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
                <cf_get_lang dictionary_id='57496.Hayır'> </td>
                <td><cf_get_lang dictionary_id='55630.Ehliyet No'></td>
                <td><cfinput type="Text" name="driver_licence" maxlength="40" style="width:150px;" value="#get_app.driver_licence#"></td>
            </tr>
            <tr>
                <td colspan="3"><cf_get_lang dictionary_id='56140.Kaç yıldır aktif olarak araba kullanıyorsunuz'>?</td>
                <td><cfinput type="text" name="driver_licence_actived" value="#get_app.driver_licence_actived#" maxlength="2"  style="width:150px;" validate="integer" message="Ehliyet Aktiflik Süresine Sayı Giriniz!"></td>
            </tr>
            <tr>
                <td colspan="3"><cf_get_lang dictionary_id='55343.Bir suç zannıyla tutuklandınız mı'>?</td>
                <td><input type="radio" name="defected_probability" id="defected_probability" value="1"  <cfif get_app.defected_probability eq 1>checked</cfif>>
                    <cf_get_lang dictionary_id='57495.Evet'> &nbsp;
                    <input type="radio" name="defected_probability" id="defected_probability" value="0" <cfif get_app.defected_probability eq 0>checked</cfif>>
                    <cf_get_lang dictionary_id='57496.Hayır'>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='56141.Kovuşturma'></td>
                <td colspan="3"><cfinput type="text" name="investigation" value="#get_app.INVESTIGATION#" maxlength="150" style="width:150px;"></td>
            </tr>
            <tr>
                <td colspan="3"><cf_get_lang dictionary_id='55342.Devam eden bir hastalığınız veya bedensel sorununuz var mı ?'></td>
                <td><input type="radio" name="illness_probability" id="illness_probability" value="1" <cfif get_app.illness_probability eq 1>checked</cfif>>
                <cf_get_lang dictionary_id='57495.Evet'> &nbsp;
                <input type="radio" name="illness_probability" id="illness_probability" value="0" <cfif get_app.illness_probability eq 0>checked</cfif>>
                <cf_get_lang dictionary_id='57496.Hayır'>
                </td>
            </tr>
            <tr>
                <td valign="top"><cf_get_lang dictionary_id='55341.Varsa nedir?'></td>
                <td><textarea name="illness_detail" id="illness_detail" style="width:150px;height:40px;"><cfoutput>#get_app.illness_detail#</cfoutput></textarea></td>
                <td valign="top"><cf_get_lang dictionary_id='56142.Geçirdiğiniz Ameliyat'></td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter syaısı'></cfsavecontent>
                <td><textarea name="surgical_operation" id="surgical_operation" style="width:150px;" maxlength="150" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#get_app.SURGICAL_OPERATION#</cfoutput></textarea></td>
            </tr>
            <tr>
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
            <tr <cfif get_app.military_status neq 4>style="display:none"</cfif> id="Tecilli">
                <td><cf_get_lang dictionary_id='55339.Tecil Gerekçesi'></td>
                <td><cfinput type="text" name="military_delay_reason" style="width:150px;" maxlength="30" value="#get_app.military_delay_reason#"></td>
                <td><cf_get_lang dictionary_id='55338.Tecil Süresi'></td>
                <td>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='55796.Tecil Süresi Girmelisiniz'></cfsavecontent>
                    <cfinput type="text" style="width:150px;" name="military_delay_date" value="#dateformat(get_app.military_delay_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
                    <cf_wrk_date_image date_field="military_delay_date">
                </td>
            </tr>
            <tr <cfif get_app.military_status neq 2>style="display:none"</cfif> id="Muaf">
                <td><cf_get_lang dictionary_id='56143.Muaf Olma Nedeni'></td>
                <td>
                    <input type="text" style="width:150px;" name="military_exempt_detail" id="military_exempt_detail" maxlength="100" value="<cfoutput>#get_app.military_exempt_detail#</cfoutput>">
                </td>
            </tr>
            <tr <cfif get_app.military_status neq 1>style="display:none"</cfif> id="Yapti">
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
                        <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='56147.Askerlik Süresi Girmelisiniz'></cfsavecontent>
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
        <cfsavecontent variable="message"><cf_get_lang dictionary_id="56150.Diğer Kimlik Detayları"></cfsavecontent>
		<cf_seperator id="kimlik_" header="#message#" is_closed="1">
       	<table id="kimlik_" style="display:none;">
            <tr>
                <td width="115"><cf_get_lang dictionary_id='57637.Seri/No'></td>
                <td width="185"><cfinput type="text" name="series" style="width:50px;" maxlength="20" value="#get_app_identy.series#">
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
            <tr>
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
            <tr>
                <td><cf_get_lang dictionary_id='55640.Önceki Soyadı'></td>
                <td><cfinput type="text" name="LAST_SURNAME" style="width:150px;" maxlength="100" value="#get_app_identy.LAST_SURNAME#"></td>
                <td><cf_get_lang dictionary_id='55651.Dini'></td>
                <td><cfinput type="text" name="religion" style="width:150px;" maxlength="50" value="#get_app_identy.religion#"></td>
            </tr>
            <tr>
                <td colspan="4"><STRONG><cf_get_lang dictionary_id='55641.Nüfusa Kayıtlı Olduğu'></STRONG></td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='58638.İlçe'></td>
                <td><cfinput type="text" name="COUNTY" style="width:150px;" maxlength="100" value="#get_app_identy.COUNTY#"></td>
                <td><cf_get_lang dictionary_id='55655.Cilt No'></td>
                <td><cfinput type="text" name="BINDING" style="width:150px;" maxlength="20" value="#get_app_identy.BINDING#"></td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='58735.Mahalle'></td>
                <td><cfinput type="text" name="WARD" style="width:150px;" maxlength="100" value="#get_app_identy.WARD#"></td>
                <td><cf_get_lang dictionary_id='55656.Aile Sıra No'></td>
                <td><cfinput type="text" name="FAMILY" style="width:150px;" maxlength="20" value="#get_app_identy.FAMILY#"></td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='55645.Köy'></td>
                <td><cfinput type="text" name="VILLAGE" style="width:150px;" maxlength="100" value="#get_app_identy.VILLAGE#"></td>
                <td><cf_get_lang dictionary_id='55657.Sıra No'></td>
                <td><cfinput type="text" name="CUE" style="width:150px;" maxlength="20" value="#get_app_identy.CUE#"></td>
            </tr>
            <tr>
                <td colspan="4"><STRONG><cf_get_lang dictionary_id='55646.Cüzdanın'></STRONG></td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='55647.Verildiği Yer'></td>
                <td><cfinput type="text" name="GIVEN_PLACE" style="width:150px;" maxlength="100" value="#get_app_identy.GIVEN_PLACE#"></td>
                <td><cf_get_lang dictionary_id='55658.Kayıt No'></td>
                <td><cfinput type="text" name="RECORD_NUMBER" style="width:150px;" maxlength="50" value="#get_app_identy.RECORD_NUMBER#"></td>
            </tr>
            <tr>
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
        <cfsavecontent variable="message"><cf_get_lang dictionary_id="55739.Eğitim Bilgileri"></cfsavecontent>
        <cf_seperator id="egitim" header="#message#" is_closed="1">
        <cfquery name="get_edu_info" datasource="#DSN#">
            SELECT
                *
            FROM
                EMPLOYEES_APP_EDU_INFO
            WHERE
                EMPAPP_ID=#attributes.empapp_id#
        </cfquery>
        <table id="egitim" style="display:none;">
        	<tr>
            	<td>
                <cf_form_list>
                     <input type="hidden" name="row_edu" id="row_edu" value="<cfoutput>#get_edu_info.recordcount#</cfoutput>">
                     <thead>
                        <tr>
                            <th colspan="2" style="width:35px; text-align:center;"><input name="record_numb_edu" id="record_numb_edu" type="hidden" value="0"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_add_edu_info&ctrl_edu=0','medium');"><img src="/images/plus_list.gif" title="<cf_get_lang no ='798.Egitim Bilgisi Ekle'>" border="0"></a></th>
                            <th style="width:80px;"><cf_get_lang dictionary_id='31551.Okul Türü'></th>
                            <th style="width:185px;"><cf_get_lang dictionary_id='31285.Okul Adi'></th>
                            <th style="width:70px;"><cf_get_lang dictionary_id='31553.Basl Yili'></th>
                            <th style="width:70px;"><cf_get_lang dictionary_id='31554.Bitis Yili'></th>
                            <th style="width:65px;"><cf_get_lang dictionary_id='31482.Not Ort'></th>
                            <th style="width:190px;"><cf_get_lang dictionary_id='57995.Bölüm'></th>
                        </tr>
                        </thead>
                        <tbody id="table_edu_info">
                        <cfoutput query="get_edu_info">
                        <tr id="frm_row_edu#currentrow#">
                            <td colspan="2"></td>
                            <input type="hidden" class="boxtext" name="empapp_edu_row_id#currentrow#" id="empapp_edu_row_id#currentrow#" style="width:100%;" value="#empapp_edu_row_id#">
                            <td>
                                <input type="hidden" name="edu_type#currentrow#" id="edu_type#currentrow#" class="boxtext" value="#edu_type#" readonly>
                                <cfif len(edu_type)>
                                    <cfquery name="get_education_level_name" datasource="#dsn#">
                                        SELECT EDU_LEVEL_ID,EDUCATION_NAME FROM SETUP_EDUCATION_LEVEL WHERE EDU_LEVEL_ID =#edu_type#
                                    </cfquery>
                                    <cfset edu_type_name=get_education_level_name.education_name>											
                                </cfif>												
                                <input type="text" name="edu_type_name#currentrow#" id="edu_type_name#currentrow#" class="boxtext" value="<cfif len(edu_type)>#edu_type_name#</cfif>" readonly>
                            </td>
                            <td>
                            <cfif len(edu_id) and edu_id neq -1>
                                <!---<cfif listfind('4,5,6',edu_type)>--->
                                    <cfquery name="get_unv_name" datasource="#dsn#">
                                        SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_ID = #edu_id#
                                    </cfquery>
                                    <cfset edu_name_degisken = get_unv_name.SCHOOL_NAME>
                                <!---</cfif>--->
                            <cfelse>
                                <cfset edu_name_degisken = edu_name>
                            </cfif>
                                <input type="hidden" name="edu_id#currentrow#" id="edu_id#currentrow#" class="boxtext" value="<cfif len(edu_id)>#edu_id#</cfif>" readonly>
                                <input type="text" style="width:185px;" name="edu_name#currentrow#" id="edu_name#currentrow#" class="boxtext" value="#edu_name_degisken#" readonly>
                            </td>
                            <td><input type="text" style="width:70px;" name="edu_start#currentrow#" id="edu_start#currentrow#" class="boxtext" value="#edu_start#" readonly></td>
                            <td><input type="text" style="width:70px;" name="edu_finish#currentrow#" id="edu_finish#currentrow#" class="boxtext" value="#edu_finish#" readonly></td>
                            <td><input type="text" style="width:65px;" name="edu_rank#currentrow#" id="edu_rank#currentrow#" class="boxtext" value="#edu_rank#" readonly></td>
                            <td><cfif (len(edu_part_id) and edu_part_id neq -1)>
                                    <cfif edu_type eq 3>
                                            <cfquery name="get_high_school_part_name" datasource="#dsn#">
                                                SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART WHERE HIGH_PART_ID = #edu_part_id#
                                            </cfquery>
                                            <cfset edu_part_name_degisken = get_high_school_part_name.HIGH_PART_NAME>
                                    <cfelseif listfind('4,5',edu_type)>
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
                                <input type="text" name="edu_part_name#currentrow#" id="edu_part_name#currentrow#" class="boxtext" value="<cfif isdefined("edu_part_name_degisken")>#edu_part_name_degisken#</cfif>" readonly>
                                <input type="hidden" name="edu_high_part_id#currentrow#" id="edu_high_part_id#currentrow#" class="boxtext" value="<cfif isdefined("edu_part_id") and len(edu_part_id) and edu_type eq 3>#edu_part_id#</cfif>">
                                <input type="hidden" name="edu_part_id#currentrow#" id="edu_part_id#currentrow#" class="boxtext" value="<cfif listfind('4,5',edu_type) and isdefined("edu_part_id") and len(edu_part_id)>#edu_part_id#</cfif>">
                                <input type="hidden" name="is_edu_continue#currentrow#" id="is_edu_continue#currentrow#" class="boxtext" value="#is_edu_continue#">
                            </td>
                        </tr>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="8" class="txtbold"><cf_get_lang dictionary_id='31686.Egitim Seviyesi'>
                                <select name="training_level" id="training_level" style="width:190px;">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfloop query="get_edu_level">
                                        <option value="<cfoutput>#get_edu_level.edu_level_id#</cfoutput>" <cfif get_edu_level.edu_level_id eq get_my_profile.training_level>selected</cfif>><cfoutput>#get_edu_level.education_name#</cfoutput></option>
                                        </cfloop>
                                    </select>
                                </td>
                            </tr>
                        </tfoot>
                        </cfoutput>
                    </cf_form_list>
				<!---<cfif get_edu_info.recordcount>
                	<cf_form_list>
                    	<thead>
                            <input type="hidden" name="row_edu" value="<cfoutput>#get_edu_info.recordcount#</cfoutput>">
                            <tr>
                                <th>
                                    <input name="record_numb_edu" type="hidden" value="0"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_add_edu_info&ctrl_edu=0','medium');"><img src="/images/plus_list.gif" title="Eğitim Bilgisi Ekle" border="0"></a>
                                </th>
                                <th style="width:75px;">Okul Türü</th>
                                <th style="width:160px;">Okul Adı</th>
                                <th style="width:10px;">&nbsp;</th>
                                <th style="width:65px;">Başl. Yılı</th>
                                <th style="width:65px;">Bitiş Yılı</th>
                                <th style="width:65px;">Not Ort.</th>
                                <th style="width:85px;">Bölüm</th>
                            </tr>
                        </thead>
                        <tbody id="table_edu_info">
                        	<cfoutput query="get_edu_info">
                            <tr id="frm_row_edu#currentrow#">
                                <td><a href="javascript://" onClick="gonder_upd_edu('#currentrow#');"><img src="../../images/update_list.gif" title="Eğitim Bilgisi Güncelle" border="0"></a></td>
                                <td><input  type="hidden" value="1" name="row_kontrol_edu#currentrow#"><a href="javascript://" onClick="sil_edu('#currentrow#');"><img  src="images/delete_list.gif" border="0"></a></td>				
                                <input type="hidden" class="boxtext" name="empapp_edu_row_id#currentrow#" style="width:100%;" value="#empapp_edu_row_id#">
                                <td>
                                    <input type="hidden" name="edu_type#currentrow#" class="boxtext" value="#edu_type#" readonly>
                                    <cfif edu_type eq 1>
                                        <cfset edu_type_name = 'İlkÖgretim'>
                                    <cfelseif edu_type eq 2>
                                        <cfset edu_type_name = 'Lise'>
                                    <cfelseif edu_type eq 3>
                                        <cfset edu_type_name = 'Üniversite'>
                                    <cfelseif edu_type eq 4>
                                        <cfset edu_type_name = 'Yüksek Okul'>
                                    <cfelseif edu_type eq 5>
                                        <cfset edu_type_name = 'Yüksek Lisans'>
                                    <cfelseif edu_type eq 6>
                                        <cfset edu_type_name = 'Doktora'>
                                    <cfelse>
                                        <cfset edu_type_name = 'Diğer'>
                                    </cfif>
                                    <input type="text" name="edu_type_name#currentrow#" class="boxtext" value="#edu_type_name#" style="width:75px;" readonly>
                                    </td>
                                <td>
                                <cfif len(edu_id) and edu_id neq -1>
                                    <cfif edu_id eq 2>
                                        <cfquery name="get_unv_name" datasource="#dsn#">
                                            SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_ID = #edu_id#
                                        </cfquery>
                                        <cfset edu_name_degisken = get_unv_name.SCHOOL_NAME>
                                    <cfelse>
                                        <cfset edu_name_degisken = edu_name>
                                    </cfif>
                                    <cfelse>
                                    <cfset edu_name_degisken = ''>
                                </cfif>
                                    <input type="hidden" name="edu_id#currentrow#" class="boxtext" value="<cfif len(edu_id)>#edu_id#</cfif>" readonly>
                                    <input type="text" style="width:160;" name="edu_name#currentrow#" class="boxtext" value="#edu_name_degisken#" readonly>
                                </td>
                                <td style="width:10;">&nbsp;</td>
                                <td>
                                    <input type="text" style="width:65;" name="edu_start#currentrow#" class="boxtext" value="#edu_start#" readonly>
                                </td>
                                <td>
                                    <input type="text" style="width:65;" name="edu_finish#currentrow#" class="boxtext" value="#edu_finish#" readonly>
                                </td>
                                <td>
                                    <input type="text" style="width:65;" name="edu_rank#currentrow#" class="boxtext" value="#edu_rank#" readonly>
                                </td>
                                <td>
                                    <cfif (len(edu_part_id) and edu_part_id neq -1)>
                                        <cfif edu_type eq 1>
                                                <cfquery name="get_high_school_part_name" datasource="#dsn#">
                                                    SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART WHERE HIGH_PART_ID = #edu_part_id#
                                                </cfquery>
                                                <cfset edu_part_name_degisken = get_high_school_part_name.HIGH_PART_NAME>
                                        <cfelseif edu_type eq 3>
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
                                    <input type="text" name="edu_part_name#currentrow#" style="width:85;" class="boxtext" value="<cfif isdefined('edu_part_name_degisken') and len(edu_part_name_degisken)>#edu_part_name_degisken#</cfif>" readonly>
                                    <input type="hidden" name="edu_high_part_id#currentrow#" class="boxtext" value="<cfif isdefined("edu_part_id") and len(edu_part_id) and edu_type eq 3>#edu_part_id#</cfif>">
                                    <input type="hidden" name="edu_part_id#currentrow#" class="boxtext" value="<cfif listfind('4,5',edu_type) and isdefined("edu_part_id") and len(edu_part_id)>#edu_part_id#</cfif>">
                                    <input type="hidden" name="is_edu_continue#currentrow#" class="boxtext" value="#is_edu_continue#">
                                </td>
                            </tr>
                            </cfoutput>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="2"><cf_get_lang no='252.Eğitim Seviyesi'></td>
                                <td colspan="6">
                                    <select name="training_level" style="width:190px;">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfloop query="get_edu_level">
                                        <option value="<cfoutput>#get_edu_level.edu_level_id#</cfoutput>" <cfif get_edu_level.edu_level_id eq get_app.training_level>selected</cfif>><cfoutput>#get_edu_level.education_name#</cfoutput></option>
                                        </cfloop>
                                    </select>
                                </td>
                            </tr>
                        </tfoot>
                    </cf_form_list>
                <cfelse>
                	<cf_form_list>
                    <thead>
                    	<input type="hidden" name="row_edu" value="0">
                        <tr>
                            <th><input name="record_numb_edu" type="hidden" value="0"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_add_edu_info&ctrl_edu=0','medium');"><img src="/images/plus_list.gif" title="Eğitim Bilgisi Ekle" border="0"></a></th>
                            <th style="width:80px;">Okul Türü</th>
                            <th style="width:185px;">Okul Adı</th>
                            <th style="width:10px;">&nbsp;</th>
                            <th style="width:70px;">Başl. Yılı</th>
                            <th style="width:70px;">Bitiş Yılı</th>
                            <th style="width:65px;">Not Ort.</th>
                            <th style="width:100px;">Bölüm</th>
                        </tr>
                            <input type="hidden" name="edu_type" value="">
                            <input type="hidden" name="edu_id" value="">
                            <input type="hidden" name="edu_name" value="">
                            <input type="hidden" name="edu_start" value="">
                            <input type="hidden" name="edu_finish" value="">
                            <input type="hidden" name="edu_rank" value="">
                            <input type="hidden" name="edu_high_part_id" value="">
                            <input type="hidden" name="edu_part_id" value="">
                            <input type="hidden" name="edu_part_name" value="">
                            <input type="hidden" name="is_edu_continue" value="">
                    </thead>
                    <tbody id="table_edu_info">
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="2"><cf_get_lang no='252.Eğitim Seviyesi'></td>
                            <td colspan="6">
                                <select name="training_level" style="width:190px;">
                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                    <cfloop query="get_edu_level">
                                    <option value="<cfoutput>#get_edu_level.edu_level_id#</cfoutput>" <cfif get_edu_level.edu_level_id eq get_app.training_level>selected</cfif>><cfoutput>#get_edu_level.education_name#</cfoutput></option>
                                    </cfloop>
                                </select>
                            </td>
                        </tr>
                    </tfoot>
                </cf_form_list>
                </cfif> --->
                <table>
                    <tr>
                        <td class="txtbold"><cf_get_lang dictionary_id='58996.Dil'></td>
                    </tr>
                    <tr>
                        <td width="110"></td>
                        <td class="txtboldblue"><cf_get_lang dictionary_id='58996.Dil'></td>
                        <td class="txtboldblue"><cf_get_lang dictionary_id='56158.Konuşma'></td>
                        <td class="txtboldblue"><cf_get_lang dictionary_id='56159.Anlama'></td>
                        <td class="txtboldblue"><cf_get_lang dictionary_id='56160.Yazma'></td>
                        <td class="txtboldblue"><cf_get_lang dictionary_id='56161.Öğrenildiği Yer'></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='58996.Dil'> 1</td>
                        <td>
                            <select name="lang1" id="lang1" style="width:80px;">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'> 
                                <cfoutput query="get_languages">
                                <option value="#language_id#" <cfif get_languages.language_id eq get_app.lang1>selected</cfif>>#language_set# 
                                </cfoutput>
                            </select>
                        </td>
                        <td>
                            <select name="LANG1_SPEAK" id="LANG1_SPEAK" style="width:80px;">
                                <cfoutput query="know_levels">
                                <option value="#knowlevel_id#" <cfif get_app.LANG1_SPEAK eq knowlevel_id>selected</cfif>>#knowlevel# 
                                </cfoutput>
                            </select>
                        </td>
                        <td>
                            <select name="LANG1_MEAN" id="LANG1_MEAN" style="width:80px;">
                                <cfoutput query="know_levels">
                                <option value="#knowlevel_id#" <cfif get_app.LANG1_MEAN eq knowlevel_id>selected</cfif>>#knowlevel#
                                </cfoutput>
                            </select>
                        </td>
                        <td>
                            <select name="LANG1_WRITE" id="LANG1_WRITE" style="width:80px;">
                                <cfoutput query="know_levels">
                                <option value="#knowlevel_id#" <cfif get_app.LANG1_WRITE eq knowlevel_id>selected</cfif>>#knowlevel# 
                                </cfoutput>
                            </select>
                        </td>
                        <td>
                            <input type="text" name="lang1_where" id="lang1_where" value="<cfoutput>#get_app.lang1_where#</cfoutput>" maxlength="50">
                        </td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='58996.Dil'> 2</td>
                        <td>
                            <select name="lang2" id="lang2" style="width:80px;">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'> 
                                <cfoutput query="get_languages">
                                <option value="#language_id#" <cfif get_languages.language_id eq get_app.lang2>selected</cfif>>#language_set# 
                                </cfoutput>
                            </select>
                        </td>
                        <td>
                            <select name="LANG2_SPEAK" id="LANG2_SPEAK" style="width:80px;">
                                <cfoutput query="know_levels">
                                <option value="#knowlevel_id#" <cfif get_app.LANG2_SPEAK eq knowlevel_id>selected</cfif>>#knowlevel#
                                </cfoutput>
                            </select>
                        </td>
                        <td>
                            <select name="LANG2_MEAN" id="LANG2_MEAN" style="width:80px;">
                                <cfoutput query="know_levels">
                                <option value="#knowlevel_id#" <cfif get_app.LANG2_MEAN eq knowlevel_id>selected</cfif>>#knowlevel#
                                </cfoutput>
                            </select>
                        </td>
                        <td>
                            <select name="LANG2_WRITE" id="LANG2_WRITE" style="width:80px;">
                                <cfoutput query="know_levels">
                                <option value="#knowlevel_id#" <cfif get_app.LANG2_WRITE eq knowlevel_id>selected</cfif>>#knowlevel#
                                </cfoutput>
                            </select>
                        </td>
                        <td>
                            <input type="text" name="lang2_where" id="lang2_where" value="<cfoutput>#get_app.lang2_where#</cfoutput>" maxlength="50">
                        </td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='58996.Dil'> 3</td>
                        <td>
                            <select name="lang3" id="lang3" style="width:80px;">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'> 
                                <cfoutput query="get_languages">
                                <option value="#language_id#" <cfif get_languages.language_id eq get_app.lang3>selected</cfif>>#language_set# 
                                </cfoutput>
                            </select>
                        </td>
                        <td>
                            <select name="LANG3_SPEAK" id="LANG3_SPEAK" style="width:80px;">
                                <cfoutput query="know_levels">
                                <option value="#knowlevel_id#" <cfif get_app.LANG3_SPEAK eq knowlevel_id>selected</cfif>>#knowlevel#
                                </cfoutput>
                            </select>
                        </td>
                        <td>
                            <select name="LANG3_MEAN" id="LANG3_MEAN" style="width:80px;">
                                <cfoutput query="know_levels">
                                <option value="#knowlevel_id#" <cfif get_app.LANG3_MEAN eq knowlevel_id>selected</cfif>>#knowlevel#
                                </cfoutput>
                            </select>
                        </td>
                        <td>
                            <select name="LANG3_WRITE" id="LANG3_WRITE" style="width:80px;">
                                <cfoutput query="know_levels">
                                <option value="#knowlevel_id#" <cfif get_app.LANG3_WRITE eq knowlevel_id>selected</cfif>>#knowlevel#
                                </cfoutput>
                            </select>
                        </td>
                        <td>
                            <input type="text" name="lang3_where" id="lang3_where" value="<cfoutput>#get_app.lang3_where#</cfoutput>" maxlength="50">
                        </td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='58996.Dil'> 4</td>
                        <td>
                            <select name="lang4" id="lang4" style="width:80px;">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'> 
                                <cfoutput query="get_languages">
                                <option value="#language_id#" <cfif get_languages.language_id eq get_app.lang4>selected</cfif>>#language_set# 
                                </cfoutput>
                            </select>
                        </td>
                        <td>
                            <select name="LANG4_SPEAK" id="LANG4_SPEAK" style="width:80px;">
                                <cfoutput query="know_levels">
                                <option value="#knowlevel_id#" <cfif get_app.LANG4_SPEAK eq knowlevel_id>selected</cfif>>#knowlevel#
                                </cfoutput>
                            </select>
                        </td>
                        <td>
                            <select name="LANG4_MEAN" id="LANG4_MEAN" style="width:80px;">
                                <cfoutput query="know_levels">
                                <option value="#knowlevel_id#" <cfif get_app.LANG4_MEAN eq knowlevel_id>selected</cfif>>#knowlevel#
                                </cfoutput>
                            </select>
                        </td>
                        <td>
                            <select name="LANG4_WRITE" id="LANG4_WRITE" style="width:80px;">
                                <cfoutput query="know_levels">
                                <option value="#knowlevel_id#" <cfif get_app.LANG4_WRITE eq knowlevel_id>selected</cfif>>#knowlevel#
                                </cfoutput>
                            </select>
                        </td>
                        <td>
                            <input type="text" name="lang4_where" id="lang4_where" value="<cfoutput>#get_app.lang4_where#</cfoutput>" maxlength="50">
                        </td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='58996.Dil'> 5</td>
                        <td>
                            <select name="lang5" id="lang5" style="width:80px;">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'>
                                <cfoutput query="get_languages">
                                <option value="#language_id#" <cfif get_languages.language_id eq get_app.lang5>selected</cfif>>#language_set# 
                                </cfoutput>
                            </select>					  
                        </td>
                        <td>
                            <select name="LANG5_SPEAK" id="LANG5_SPEAK" style="width:80px;">
                                <cfoutput query="know_levels">
                                <option value="#knowlevel_id#" <cfif get_app.LANG5_SPEAK eq knowlevel_id>selected</cfif>>#knowlevel#
                                </cfoutput>
                            </select>
                        </td>
                        <td>
                            <select name="LANG5_MEAN" id="LANG5_MEAN" style="width:80px;">
                                <cfoutput query="know_levels">
                                <option value="#knowlevel_id#" <cfif get_app.LANG5_MEAN eq knowlevel_id>selected</cfif>>#knowlevel#
                                </cfoutput>
                            </select>
                        </td>
                        <td>
                            <select name="LANG5_WRITE" id="LANG5_WRITE" style="width:80px;">
                                <cfoutput query="know_levels">
                                <option value="#knowlevel_id#" <cfif get_app.LANG5_WRITE eq knowlevel_id>selected</cfif>>#knowlevel#
                                </cfoutput>
                            </select>
                        </td>
                        <td>
                            <input type="text" name="lang5_where" id="lang5_where" value="<cfoutput>#get_app.lang5_where#</cfoutput>" maxlength="50">
                        </td>
                    </tr>
                </table>
                <table>
                    <tr>
                        <td class="txtbold" colspan="4"><cf_get_lang dictionary_id='56162.Kurs - Seminer ve Akademik Olmayan Programlar'></td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <table width="100%" id="add_course_pro" border="0">
                                <input type="hidden" name="extra_course" id="extra_course" value="<cfoutput>#get_extra_course.recordcount#</cfoutput>">
                                <tr>
                                    <td class="txtboldblue" width="115"><cf_get_lang dictionary_id='57480.Konu'></td>
                                    <td class="txtboldblue" width="115"><cf_get_lang dictionary_id='57629.Açıklama'></td>
                                    <td class="txtboldblue" width="115"><cf_get_lang dictionary_id='58455.Yıl'></td>
                                    <td class="txtboldblue" width="115"><cf_get_lang dictionary_id='55956.Yer'></td>
                                    <td class="txtboldblue" width="115"><cf_get_lang dictionary_id='29513.Sure'></td>
                                    <td style="width:2;"><a style="cursor:pointer" onClick="add_row_course();"><img src="images/plus_list.gif" title="Ekle"></a></td>
                                </tr>
                                <cfif isdefined("get_extra_course")>
                                    <cfoutput query="get_extra_course">
                                        <tr id="pro_course#currentrow#">
                                            <td><input type="text" name="kurs1_#currentrow#" id="kurs1_#currentrow#" value="#COURSE_SUBJECT#" style="width:115px;"></td>
                                            <td><input type="text" name="kurs1_exp#currentrow#" id="kurs1_exp#currentrow#" value="#COURSE_EXPLANATION#" style="width:115px;"  maxlength="200"></td>
                                            <td><input type="text" name="kurs1_yil#currentrow#" id="kurs1_yil#currentrow#" value="#left(course_year,4)#" style="width:115px;"></td>
                                            <td><input type="text" name="kurs1_yer#currentrow#" id="kurs1_yer#currentrow#" value="#course_location#" style="width:115px;"></td>
                                            <td>
                                                <input type="text" name="kurs1_gun#currentrow#" id="kurs1_gun#currentrow#" value="#course_period#" style="width:115px;">
                                                <input type="hidden" name="del_course_prog#currentrow#" id="del_course_prog#currentrow#" value="1">
                                            </td>
                                            <td nowrap><a style="cursor:pointer" onClick="sil_('#currentrow#');"><img  src="images/delete_list.gif" border="0"></a></td>
                                        </tr>
                                    </cfoutput>
                                </cfif>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="txtbold"><cf_get_lang dictionary_id='55957.Bilgisayar Bilgisi'></td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <textarea name="comp_exp" id="comp_exp" style="width:237px;height:60px;"><cfoutput>#get_app.COMP_EXP#</cfoutput></textarea>
                        </td>
                    </tr>
                </table>
                </td>
            </tr>
        </table>
        <cfsavecontent variable="message"><cf_get_lang dictionary_id="55307.İş Tecrübesi"></cfsavecontent>
        <cf_seperator id="is_tecrubesi" header="#message#" is_closed="1">
        <table id="is_tecrubesi" style="display:none;">
            <tr>
                <td> 
                <cfquery name="get_work_info" datasource="#DSN#">
                    SELECT
                        *
                    FROM
                        EMPLOYEES_APP_WORK_INFO
                    WHERE
                        EMPAPP_ID=#attributes.empapp_id#
                </cfquery>
                <cfif get_work_info.recordcount>
                    <table id="table_work_info" border="0" cellpadding="0" cellspacing="1">
                     <input type="hidden" name="row_count" id="row_count" value="<cfoutput>#get_work_info.recordcount#</cfoutput>">
                        <tr class="txtboldblue">
                            <td><cf_get_lang dictionary_id="31549.Çalışılan Yer"></td>
                            <td><cf_get_lang dictionary_id="58497.Pozisyon"></td>
                            <td><cf_get_lang dictionary_id="57579.Sektör"></td>
                            <td><cf_get_lang dictionary_id="57571.Ünvan"></td>
                            <td><cf_get_lang dictionary_id="57655.Başlama Tarihi"></td>
                            <td><cf_get_lang dictionary_id="57700.Bitiş Tarihi"></td>
                            <td><input name="record_num" id="record_num" type="hidden" value="0"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_upd_work_info&control=0</cfoutput>','medium');"><img src="/images/button_gri.gif" title="İş Tecrübesi Ekle" border="0"></a></td>
                        </tr>
                        <cfoutput query="get_work_info">
                        <tr id="frm_row#currentrow#"  onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                            <input type="hidden" class="boxtext" name="empapp_row_id#currentrow#" id="empapp_row_id#currentrow#" style="width:100%;" value="#empapp_row_id#">
                            <td><input type="text" name="exp_name#currentrow#" id="exp_name#currentrow#" class="boxtext" value="#exp#" readonly></td>
                            <td><input type="text" name="exp_position#currentrow#" id="exp_position#currentrow#" class="boxtext" value="#exp_position#" readonly></td>
                            <td>
                                <input type="hidden" name="exp_sector_cat#currentrow#" id="exp_sector_cat#currentrow#" class="boxtext" value="#exp_sector_cat#">
                                <cfif isdefined("exp_sector_cat") and len(exp_sector_cat)>
                                    <cfquery name="get_sector_cat" datasource="#dsn#">
                                        SELECT SECTOR_CAT_ID,SECTOR_CAT FROM SETUP_SECTOR_CATS WHERE SECTOR_CAT_ID = #exp_sector_cat#
                                    </cfquery>
                                </cfif>
                                <input type="text" name="exp_sector_cat_name#currentrow#" id="exp_sector_cat_name#currentrow#" class="boxtext" value="<cfif isdefined("exp_sector_cat") and len(exp_sector_cat) and get_sector_cat.recordcount>#get_sector_cat.sector_cat#</cfif>" readonly>
                            </td>
                            <td>
                                <input type="hidden" name="exp_task_id#currentrow#" id="exp_task_id#currentrow#" class="boxtext" value="#exp_task_id#">
                                <cfif isdefined("exp_task_id") and len(exp_task_id)>
                                    <cfquery name="get_exp_task_name" datasource="#dsn#">
                                        SELECT PARTNER_POSITION_ID,PARTNER_POSITION FROM SETUP_PARTNER_POSITION WHERE PARTNER_POSITION_ID = #exp_task_id#
                                    </cfquery>
                                </cfif>
                                <input type="text" name="exp_task_name#currentrow#" id="exp_task_name#currentrow#" class="boxtext" value="<cfif isdefined("exp_task_id") and len(exp_task_id) and get_exp_task_name.recordcount>#get_exp_task_name.partner_position#</cfif>" readonly>
                            </td>
                            <td>
                                <input type="text" name="exp_start#currentrow#" id="exp_start#currentrow#" class="boxtext" value="#dateformat(exp_start,dateformat_style)#" readonly>
                            </td>
                            <td>
                                <input type="text" name="exp_finish#currentrow#" id="exp_finish#currentrow#" class="boxtext" value="#dateformat(exp_finish,dateformat_style)#" readonly>
                            </td>
                            <td><a href="javascript://" onClick="gonder_upd('#currentrow#');"><img src="../../images/update_list.gif" title="İş Tecrübesi Güncelle" border="0"></a></td>
                            <td><input  type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#"><a href="javascript://" onClick="sil('#currentrow#');"><img  src="images/delete_list.gif" border="0"></a></td>
                            <input type="hidden" name="exp_telcode#currentrow#" id="exp_telcode#currentrow#" class="boxtext" value="#exp_telcode#">
                            <input type="hidden" name="exp_tel#currentrow#" id="exp_tel#currentrow#" class="boxtext" value="#exp_tel#">
                            <input type="hidden" name="exp_salary#currentrow#" id="exp_salary#currentrow#" class="boxtext" value="#exp_salary#">
                            <input type="hidden" name="exp_extra_salary#currentrow#" id="exp_extra_salary#currentrow#" class="boxtext" value="#exp_extra_salary#">
                            <input type="hidden" name="exp_extra#currentrow#" id="exp_extra#currentrow#" class="boxtext" value="#exp_extra#">
                            <input type="hidden" name="exp_reason#currentrow#" id="exp_reason#currentrow#" class="boxtext" value="#exp_reason#">
                            <input type="hidden" name="is_cont_work#currentrow#" id="is_cont_work#currentrow#" class="boxtext" value="#is_cont_work#">
                        </tr>
                        </cfoutput>
                    </table>
                <cfelse>
                    <table id="table_work_info">
                        <tr height="25">
                            <td colspan="2" class="formbold"><cf_get_lang dictionary_id="56615.Deneyim"></td>
                        </tr>
                     <input type="hidden" name="row_count" id="row_count" value="0">
                        <tr class="txtboldblue">
                            <td><cf_get_lang dictionary_id="31549.Çalışılan Yer"></td>
                            <td><cf_get_lang dictionary_id="58497.Pozisyon"></td>
                            <td><cf_get_lang dictionary_id="57579.Sektör"></td>
                            <td><cf_get_lang dictionary_id="57571.Ünvan"></td>
                            <td><cf_get_lang dictionary_id="57655.Başlama Tarihi"></td>
                            <td><cf_get_lang dictionary_id="57700.Bitiş Tarihi"></td>
                            <td><input name="record_numb" id="record_numb" type="hidden" value="0"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_upd_work_info&control=0</cfoutput>','medium');"><img src="/images/button_gri.gif" title="İş Tecrübesi Ekle" border="0"></a></td>
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
                    </table>
                </cfif>
                </td>
            </tr>
         </table>
         <cf_seperator id="referans" header="#getLang('hr',167)#" is_closed="1"><!---Referans Bilgileri--->
         <table id="referans" style="display:none;">	
            <tr>
                <td class="txtbold" colspan="4"><cf_get_lang dictionary_id='56167.Grup İçi Referans'> </td>
            </tr>
            <tr>
                <td colspan="4">
                    <table width="100%" id="ref_info">
                        <input type="hidden" name="add_ref_info" id="add_ref_info" value="<cfoutput>#get_reference.recordcount#</cfoutput>">
                        <tr>
                            <td class="txtboldblue" width="75"><cf_get_lang dictionary_id="31063.Referans Tipi"></td>
                            <td class="txtboldblue" width="100"><cf_get_lang dictionary_id="57570.Ad Soyad"></td>
                            <td class="txtboldblue" width="100"><cf_get_lang dictionary_id="57574.Şirket"></td>
                            <td class="txtboldblue" width="100"><cf_get_lang dictionary_id="32407.Tel.Kod"></td>
                            <td class="txtboldblue" width="100"><cf_get_lang dictionary_id="57499.Telefon"></td>
                            <td class="txtboldblue" width="100"><cf_get_lang dictionary_id="58497.Pozisyon"></td>
                            <td class="txtboldblue" width="100"><cf_get_lang dictionary_id="42782.E-mail"></td>
                            <td style="width:2;" style="text-align:right;"><a style="cursor:pointer" onClick="add_ref_info_();"><img src="images/plus_list.gif" title="Ekle"></a></td>
                        </tr>
                        <input type="hidden" name="referance_info" id="referance_info" value="<cfoutput>#get_reference.recordcount#</cfoutput>">
                        <cfif isdefined("get_reference")>
                            <cfoutput query="get_reference">
                                <tr id="ref_info_#currentrow#">
                                    <td>
                                    <select name="ref_type#currentrow#" id="ref_type#currentrow#" style="width:75px;">
                                        <option value=""><cf_get_lang dictionary_id="31063.Referans Tipi"></option>
                                        <!---<option value="1"<cfif len(get_reference.REFERENCE_TYPE) and (get_reference.REFERENCE_TYPE eq 1)>selected</cfif>>Gurup İçi</option>
                                        <option value="2"<cfif len(get_reference.REFERENCE_TYPE) and (get_reference.REFERENCE_TYPE eq 2)>selected</cfif>>Diğer</option>
                                        --->
                                        <cfloop query="get_reference_type">
                                            <option value="#reference_type_id#"<cfif len(get_reference.REFERENCE_TYPE) and (get_reference.REFERENCE_TYPE eq reference_type_id)>selected</cfif>>#reference_type#</option>
                                        </cfloop>
                                    </select>
                                    <td><input type="text" name="ref_name#currentrow#" id="ref_name#currentrow#" value="#REFERENCE_NAME#" style="width:90px;"></td>
                                    <td><input type="text" name="ref_company#currentrow#" id="ref_company#currentrow#" value="#REFERENCE_COMPANY#" style="width:90px;"></td>
                                    <td><input type="text" name="ref_telcode#currentrow#" id="ref_telcode#currentrow#" value="#REFERENCE_TELCODE#" style="width:90px;"> </td>
                                    <td><input type="text" name="ref_tel#currentrow#" id="ref_tel#currentrow#" value="#REFERENCE_TEL#" style="width:90px;"></td>
                                    <td><input type="text" name="ref_position#currentrow#" id="ref_position#currentrow#" value="#REFERENCE_POSITION#" style="width:90px;"></td>
                                    <td>
                                        <input type="text" name="ref_mail#currentrow#" id="ref_mail#currentrow#" value="#REFERENCE_EMAIL#" style="width:90px;">
                                        <input type="hidden" name="del_ref_info#currentrow#" id="del_ref_info#currentrow#" value="1">
                                    </td>
                                    
                                    <td nowrap><a style="cursor:pointer" onClick="del_ref('#currentrow#');"><img  src="images/delete_list.gif" border="0"></a></td>
                                </tr>
                            </cfoutput>
                        </cfif>
                    </table>
                </td>
            </tr>
         </table>
         <cfsavecontent variable="message"><cf_get_lang dictionary_id="56168.Özel İlgi Alanları"></cfsavecontent>
         <cf_seperator id="ilgi_alanlari" header="#message#" is_closed="1"><!---hobi--->
		 <table id="ilgi_alanlari" style="display:none;">	
            <tr>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                <td valign="top"><cf_get_lang dictionary_id='56168.Özel İlgi Alanları'></td>
                <td valign="top" colspan="2"><textarea name="hobby" id="hobby" style="width:250px;" maxlength="150" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#get_app.hobby#</cfoutput></textarea></td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='56169.Üye Olunan Klüp Ve Dernekler'></td>
                <td><textarea name="club" id="club" style="width:250px;" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#get_app.club#</cfoutput></textarea></td>
            </tr>
         </table>
         <cfsavecontent message=""><cf_get_lang dictionary_id="56172.Çalışılmak İstenen Birimler"></cfsavecontent>
         <cf_seperator id="birimler" header="#message#" is_closed="1">
         <table id="birimler" style="display:none;">
            <tr><td colspan="2">&nbsp;&nbsp;(<cf_get_lang dictionary_id='56173.Öncelik sıralarını yandaki kutulara yazınız'>...)</td></tr>
            <cfquery name="get_cv_unit" datasource="#DSN#">
                SELECT 
                    * 
                FROM 
                    SETUP_CV_UNIT
            </cfquery>
            <cfif get_cv_unit.recordcount>
            <tr class="txtbold">
            <cfquery name="get_app_unit" datasource="#dsn#"> 
                SELECT 
                    UNIT_ID,UNIT_ROW
                FROM 
                    EMPLOYEES_APP_UNIT
                WHERE 
                    EMPAPP_ID=#attributes.empapp_id#
            </cfquery>
            <cfset liste = valuelist(get_app_unit.unit_id)>
            <cfset liste_row = valuelist(get_app_unit.unit_row)>					
            <cfoutput query="get_cv_unit">
                <cfif get_cv_unit.currentrow-1 mod 3 eq 0><tr></cfif>
                  <td>#get_cv_unit.unit_name#</td>
                  <td><cfif listfind(liste,get_cv_unit.unit_id,',')>
                    <cfinput type="text" name="unit#get_cv_unit.unit_id#" value="#ListGetAt(liste_row,listfind(liste,get_cv_unit.unit_id,','),',')#" validate="integer" maxlength="1" range="1,9" onchange="seviye_kontrol(this)" style="width:30px;" message="Sayı Giriniz!">
                  <cfelse>
                     <cfinput type="text" name="unit#get_cv_unit.unit_id#" value="" validate="integer" maxlength="1" range="1,9" onchange="seviye_kontrol(this)" style="width:30px;" message="Sayı Giriniz!">
                  </cfif>
                  </td>
                <cfif get_cv_unit.currentrow mod 3 eq 0 and get_cv_unit.currentrow-1 neq 0></tr></cfif>	  
            </cfoutput>
            <cfelse>
                <tr><td><cf_get_lang dictionary_id='56174.Sisteme kayıtlı birim yok'>.</td></tr>
            </cfif>
        </table>				
        <cfsavecontent variable="message"><cf_get_lang dictionary_id="55129.Ek Bilgiler"></cfsavecontent>
        <cf_seperator id="ek_bilgiler" header="#message#" is_closed="1">
        <table id="ek_bilgiler" style="display:none;">
            <tr>
                <td><STRONG><cf_get_lang dictionary_id='31703.Çalışmak İstediğiniz Şehir'></STRONG></td>
            </tr>
            <tr>
                <td rowspan="2">
                    <select name="prefered_city" id="prefered_city" style="width:150px;" multiple>
                        <option value="" <cfif listfind(get_app.prefered_city,'',',') or not len(get_app.prefered_city)>selected</cfif>>TÜM TÜRKİYE</option>
                        <cfoutput query="get_city">
                         <option value="#city_id#" <cfif listfind(get_app.prefered_city,city_id,',')>selected</cfif>>#city_name#
                         </option>
                        </cfoutput>
                    </select>
                </td>
            </tr>
            <tr>
                <td>
                <table>
                    <tr>
                        <td><strong><cf_get_lang dictionary_id='55328.Seyahat Edebilir misiniz'>?</strong></td>
                        <td>
                            <input type="radio" name="IS_TRIP" id="IS_TRIP" value="1" <cfif get_app.IS_TRIP IS 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'>
                            <input type="radio" name="IS_TRIP" id="IS_TRIP" value="0" <cfif get_app.IS_TRIP IS 0 OR get_app.IS_TRIP IS "">checked</cfif>><cf_get_lang dictionary_id='57496.Hayır'>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2"></td>
                    </tr>
                </table>
                </td>
            </tr>
            <tr>
                <td>&nbsp;<STRONG><cf_get_lang dictionary_id='55326.Eklemek İstedikleriniz'></STRONG></td>
            </tr>
            <tr>
                <td colspan="2">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla kararkter sayısı'></cfsavecontent>
                    <textarea name="applicant_notes" id="applicant_notes" maxlength="300" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>" style="width:500px;height:100px;"><cfoutput>#GET_APP.APPLICANT_NOTES#</cfoutput></textarea>
                </td>
            </tr>
        </table>
<cf_form_box_footer><cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'></cf_form_box_footer>					
</cfform>
<form name="form_work_info" method="post" action="">
	<input type="hidden" name="exp_name_new" id="exp_name_new" value="">
	<input type="hidden" name="exp_position_new" id="exp_position_new" value="">
	<input type="hidden" name="exp_sector_cat_new" id="exp_sector_cat_new" value="">
	<input type="hidden" name="exp_task_id_new" id="exp_task_id_new" value="">
	<input type="hidden" name="exp_start_new" id="exp_start_new" value="">
	<input type="hidden" name="exp_finish_new" id="exp_finish_new" value="">
	<input type="hidden" name="exp_telcode_new" id="exp_telcode_new" value="">
	<input type="hidden" name="exp_tel_new" id="exp_tel_new" value="">
	<input type="hidden" name="exp_salary_new" id="exp_salary_new" value="">
	<input type="hidden" name="exp_extra_salary_new" id="exp_extra_salary_new" value="">
	<input type="hidden" name="exp_extra_new" id="exp_extra_new" value="">
	<input type="hidden" name="exp_reason_new" id="exp_reason_new" value="">
	<input type="hidden" name="is_cont_work_new" id="is_cont_work_new" value="">
</form>
</cf_form_box>
<script type="text/javascript">
var add_ref_info=<cfif isdefined("get_reference")><cfoutput>#get_reference.recordcount#</cfoutput><cfelse>0</cfif>;
function del_ref(dell){
		var my_emement1=eval("employe_detail.del_ref_info"+dell);
		my_emement1.value=0;
		var my_element1=eval("ref_info_"+dell);
		my_element1.style.display="none";
}
function add_ref_info_(){
	add_ref_info++;
	employe_detail.add_ref_info.value=add_ref_info;
	var newRow;
	var newCell;
	newRow = document.getElementById("ref_info").insertRow(document.getElementById("ref_info").rows.length);
	newRow.setAttribute("name","ref_info_" + add_ref_info);
	newRow.setAttribute("id","ref_info_" + add_ref_info);
	document.employe_detail.referance_info.value=add_ref_info;
	newCell = newRow.insertCell();
	newCell.innerHTML = '<select name="ref_type' + add_ref_info +'" style="width:"60px;"><option value="">Referans Tipi</option><cfoutput query="get_reference_type"><option value="#reference_type_id#">#reference_type#</option></cfoutput>';
	newCell = newRow.insertCell();
	newCell.innerHTML ='<input type="text" name="ref_name' + add_ref_info +'" style=" width:90px;">';
	newCell = newRow.insertCell();
	newCell.innerHTML ='<input type="text" name="ref_company' + add_ref_info +'" style=" width:90px;">';
	newCell = newRow.insertCell();
	newCell.innerHTML ='<input type="text" name="ref_telcode' + add_ref_info +'" style=" width:90px;">';
	newCell = newRow.insertCell();
	newCell.innerHTML ='<input type="text" name="ref_tel' + add_ref_info +'" style=" width:90px;">';
	newCell = newRow.insertCell();
	newCell.innerHTML ='<input type="text" name="ref_position' + add_ref_info +'" style=" width:90px;">';
	newCell = newRow.insertCell();
	newCell.innerHTML ='<input type="text" name="ref_mail' + add_ref_info +'" style=" width:90px;">';
	newCell = newRow.insertCell();
	newCell.innerHTML ='<input type="hidden" value="1" name="del_ref_info'+ add_ref_info +'"><a style="cursor:pointer" onclick="del_ref(' + add_ref_info + ');"><img  src="images/delete_list.gif" border="0" alt="<cf_get_lang_main no ="51.sil">"></a>';
}

var extra_course = <cfif isdefined("get_extra_course")><cfoutput>'#get_extra_course.recordcount#'</cfoutput><cfelse>0</cfif>;
/*value="'+course_subject+'"value="'+course_year+'" value="'+course_location+'"value="'+course_period+'"*/
function sil_(del){
		var my_element_=eval("employe_detail.del_course_prog"+del);
		my_element_.value=0;
		var my_element_=eval("pro_course"+del);
		my_element_.style.display="none";

}
function add_row_course(){
	extra_course++;
	employe_detail.extra_course.value = extra_course;
	var newRow;
	var newCell;
		newRow = document.getElementById("add_course_pro").insertRow(document.getElementById("add_course_pro").rows.length);
		newRow.setAttribute("name","pro_course" + extra_course);
		newRow.setAttribute("id","pro_course" + extra_course);
		document.employe_detail.extra_course.value=extra_course;
		newCell = newRow.insertCell();
		newCell.innerHTML = '<input type="text" name="kurs1_' + extra_course +'" style="width:115px;">';
		newCell = newRow.insertCell();
		newCell.innerHTML = '<input type="text" name="kurs1_exp' + extra_course +'" style="width:115px;"  maxlength="200">';
		newCell = newRow.insertCell();
		newCell.innerHTML = '<input type="text" name="kurs1_yil' + extra_course +'"  style="width:115px;">';
		newCell = newRow.insertCell();
		newCell.innerHTML = '<input type="text" name="kurs1_yer' + extra_course +'" style="width:115px;">';
		newCell = newRow.insertCell();
		newCell.innerHTML = '<input type="text" name="kurs1_gun' + extra_course +'"  style="width:115px;">';
		newCell = newRow.insertCell();
		newCell.innerHTML = '<input  type="hidden" value="1" name="del_course_prog' + extra_course +'"><a style="cursor:pointer" onclick="sil_(' + extra_course + ');"><img  src="images/delete_list.gif" border="0" alt="<cf_get_lang_main no ='51.sil'>"></a>';
}

document.getElementById('upload_status').style.display = 'none';
	<!---özürlü seviyesi select pasif aktif yapma--->
	function seviye()
	{
		if(document.employe_detail.defected_level.disabled==true)
		{document.employe_detail.defected_level.disabled=false;}
		else
		{document.employe_detail.defected_level.disabled=true;}
	}
	

function pencere_ac()
{
	x = document.employe_detail.homecountry.selectedIndex;
	if (document.employe_detail.homecountry[x].value == "")
	{
		alert("<cf_get_lang dictionary_id='56176.İlk Olarak Ülke Seçiniz'> !");
	}
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=employe_detail.homecity&field_name=employe_detail.homecity_name&country_id=' + document.employe_detail.homecountry.value,'small');
	}
}

//departmanlar
<cfoutput>
	<cfif get_cv_unit.recordcount>
		unit_count=#get_cv_unit.recordcount#;
	<cfelse>
		unit_count=0;
	</cfif>
</cfoutput>
function seviye_kontrol(nesne)
{
	for(var j=1;j<=unit_count;j++)
	{
		diger_nesne=eval("document.employe_detail.unit"+j);
		if(diger_nesne!=nesne)
		{
			if(nesne.value==diger_nesne.value && diger_nesne.value.length!=0)
			{
				alert("<cf_get_lang dictionary_id='31645.İki tane aynı seviye giremezsiniz'>!");
				diger_nesne.value='';
			}
		}
	}
}
function kontrol()
{
    var obj =  document.employe_detail.photo.value;
	if ((obj != "") && !((obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'jpg')   || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'gif') || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'png'))){
	     alert("<cf_get_lang dictionary_id='52293.Lütfen bir resim dosyası(gif,jpg veya png) giriniz'>!");        
		return false;
	}
	/*document.employe_detail.exp1_salary.value = filterNum(document.employe_detail.exp1_salary.value);
	document.employe_detail.exp2_salary.value = filterNum(document.employe_detail.exp2_salary.value);
	document.employe_detail.exp3_salary.value = filterNum(document.employe_detail.exp3_salary.value);
	document.employe_detail.exp4_salary.value = filterNum(document.employe_detail.exp4_salary.value);*/
	return true;		
}

function tecilli_fonk(gelen)
{
	if (gelen == 4)
	{
		Tecilli.style.display='';
		Yapti.style.display='none';
		Muaf.style.display='none';
	}
	else if(gelen == 1)
	{
		Yapti.style.display='';
		Tecilli.style.display='none';
		Muaf.style.display='none';
	}
	else if(gelen == 2)
	{
		Muaf.style.display='';
		Tecilli.style.display='none';
		Yapti.style.display='none';
	}
	else
	{
		Tecilli.style.display='none';
		Yapti.style.display='none';
		Muaf.style.display='none';
	}
}
<cfif isdefined('get_work_info') and (get_work_info.recordcount)>
	row_count=<cfoutput>#get_work_info.recordcount#</cfoutput>;
	satir_say=0;
<cfelse>
	row_count=0;
	satir_say=0;
</cfif>
function sil(sy)
{
	var my_element=eval("employe_detail.row_kontrol"+sy);
	my_element.value=0;
	var my_element=eval("frm_row"+sy);
	my_element.style.display="none";
	satir_say--;
}
function gonder_upd(count)
{
	form_work_info.exp_name_new.value = eval("employe_detail.exp_name"+count).value;
	form_work_info.exp_position_new.value = eval("employe_detail.exp_position"+count).value;
	form_work_info.exp_sector_cat_new.value = eval("employe_detail.exp_sector_cat"+count).value;
	form_work_info.exp_task_id_new.value = eval("employe_detail.exp_task_id"+count).value;
	form_work_info.exp_start_new.value = eval("employe_detail.exp_start"+count).value;
	form_work_info.exp_finish_new.value = eval("employe_detail.exp_finish"+count).value;
	form_work_info.exp_telcode_new.value = eval("employe_detail.exp_telcode"+count).value;
	form_work_info.exp_tel_new.value = eval("employe_detail.exp_tel"+count).value;
	form_work_info.exp_salary_new.value = eval("employe_detail.exp_salary"+count).value;
	form_work_info.exp_extra_salary_new.value = eval("employe_detail.exp_extra_salary"+count).value;
	form_work_info.exp_extra_new.value = eval("employe_detail.exp_extra"+count).value;
	form_work_info.exp_reason_new.value = eval("employe_detail.exp_reason"+count).value;
	form_work_info.is_cont_work_new.value = eval("employe_detail.is_cont_work"+count).value;
	windowopen('','medium','kariyer_pop');
	form_work_info.target='kariyer_pop';
	form_work_info.action = '<cfoutput>#request.self#?fuseaction=hr.popup_upd_work_info&my_count='+count+'&control=1</cfoutput>';
	form_work_info.submit();	
}

function gonder(exp_name,exp_position,exp_start,exp_finish,exp_sector_cat,exp_task_id,exp_telcode,exp_tel,exp_salary,exp_extra_salary,exp_extra,exp_reason,control,my_count,is_cont_work)
{
	if(control == 1)
	{
		eval("employe_detail.exp_name"+my_count).value=exp_name;
		eval("employe_detail.exp_position"+my_count).value=exp_position;
		eval("employe_detail.exp_start"+my_count).value=exp_start;
		eval("employe_detail.exp_finish"+my_count).value=exp_finish;
		eval("employe_detail.exp_sector_cat"+my_count).value=exp_sector_cat;
		if(exp_sector_cat != '')
		{
			var get_emp_cv_new = wrk_safe_query('hr_get_emp_cv_new','dsn',0,exp_sector_cat);
			/*if(get_emp_cv_new.recordcount)*/
				var exp_sector_cat_name = get_emp_cv_new.SECTOR_CAT;
		}
		else
			var exp_sector_cat_name = '';
		eval("employe_detail.exp_sector_cat_name"+my_count).value=exp_sector_cat_name;
		eval("employe_detail.exp_task_id"+my_count).value=exp_task_id;
		if(exp_task_id != '')
		{
			var get_emp_task_cv_new = wrk_safe_query('hr_get_emp_task_cv_new','dsn',0,exp_task_id);
			/*if(get_emp_task_cv_new.recordcount)*/
				var exp_task_name = get_emp_task_cv_new.PARTNER_POSITION;
		}
		else
			var exp_task_name = '';
		eval("employe_detail.exp_task_name"+my_count).value=exp_task_name;
		eval("employe_detail.exp_telcode"+my_count).value=exp_telcode;
		eval("employe_detail.exp_tel"+my_count).value=exp_tel;
		eval("employe_detail.exp_salary"+my_count).value=exp_salary;
		eval("employe_detail.exp_extra_salary"+my_count).value=exp_extra_salary;
		eval("employe_detail.exp_extra"+my_count).value=exp_extra;
		eval("employe_detail.exp_reason"+my_count).value=exp_reason;
		eval("employe_detail.is_cont_work"+my_count).value=is_cont_work;
	}
	else
	{
		row_count++;
		employe_detail.row_count.value = row_count;
		satir_say++;
		var new_Row;
		var new_Cell;
		new_Row = document.getElementById("table_work_info").insertRow(document.getElementById("table_work_info").rows.length);
		new_Row.setAttribute("name","frm_row" + row_count);
		new_Row.setAttribute("id","frm_row" + row_count);		
		new_Row.setAttribute("NAME","frm_row" + row_count);
		new_Row.setAttribute("ID","frm_row" + row_count);		
		new_Cell = new_Row.insertCell();
		new_Cell.innerHTML = '<input type="text" name="exp_name' + row_count + '" value="'+ exp_name +'" class="boxtext" readonly>';
		new_Cell = new_Row.insertCell();
		new_Cell.innerHTML = '<input type="text" name="exp_position' + row_count + '" value="'+ exp_position +'" class="boxtext" readonly>';
		if(exp_sector_cat != '')
		{
		
			var get_emp_cv = wrk_safe_query('hr_get_emp_cv_new','dsn',0,exp_sector_cat);
			/*if(get_emp_cv.recordcount)*/
				var exp_sector_cat_name = get_emp_cv.SECTOR_CAT;
		}
		else
			var exp_sector_cat_name = '';
		new_Cell = new_Row.insertCell();
		new_Cell.innerHTML = '<input type="text" name="exp_sector_cat_name' + row_count + '" value="'+exp_sector_cat_name+'" class="boxtext" readonly>';
		if(exp_task_id != '')
		{
			var get_emp_task_cv = wrk_safe_query('hr_get_emp_task_cv_new','dsn',0,exp_task_id);
			/*if(get_emp_task_cv.recordcount)*/
				var exp_task_name = get_emp_task_cv.PARTNER_POSITION;
		}
		else
			var exp_task_name = '';
		new_Cell = new_Row.insertCell();
		new_Cell.innerHTML = '<input type="text" name="exp_task_name' + row_count + '" value="'+exp_task_name+'" class="boxtext" readonly>';
		new_Cell = new_Row.insertCell();
		new_Cell.innerHTML = '<input type="text" name="exp_start' + row_count + '" value="'+ exp_start +'" class="boxtext" readonly>';
		new_Cell = new_Row.insertCell();
		new_Cell.innerHTML = '<input type="text" name="exp_finish' + row_count + '" value="'+ exp_finish +'" class="boxtext" readonly>';
		new_Cell = new_Row.insertCell();
		new_Cell.innerHTML = '<a href="javascript://" onClick="gonder_upd('+row_count+');"><img src="/images/update_list.gif" border="0" align="absbottom"></a>';
		new_Cell = new_Row.insertCell();
		new_Cell.innerHTML = '<input  type="hidden" value="1" name="row_kontrol' + row_count +'" ><a href="javascript://" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a>';
		new_Cell = new_Row.insertCell();
		new_Cell.innerHTML = '<input type="hidden" name="exp_sector_cat' + row_count + '" value="'+ exp_sector_cat +'">';
		new_Cell = new_Row.insertCell();
		new_Cell.innerHTML = '<input type="hidden" name="exp_task_id' + row_count + '" value="'+ exp_task_id +'">';
		new_Cell = new_Row.insertCell();
		new_Cell.innerHTML = '<input type="hidden" name="exp_telcode' + row_count + '" value="'+ exp_telcode +'">';
		new_Cell = new_Row.insertCell();
		new_Cell.innerHTML = '<input type="hidden" name="exp_tel' + row_count + '" value="'+ exp_tel +'">';
		new_Cell = new_Row.insertCell();
		new_Cell.innerHTML = '<input type="hidden" name="exp_salary' + row_count + '" value="'+ exp_salary +'">';
		new_Cell = new_Row.insertCell();
		new_Cell.innerHTML = '<input type="hidden" name="exp_extra_salary' + row_count + '" value="'+ exp_extra_salary +'">';
		new_Cell = new_Row.insertCell();
		new_Cell.innerHTML = '<input type="hidden" name="exp_extra' + row_count + '" value="'+ exp_extra +'">';
		new_Cell = new_Row.insertCell();
		new_Cell.innerHTML = '<input type="hidden" name="exp_reason' + row_count + '" value="'+ exp_reason +'">';
		new_Cell = new_Row.insertCell();
		new_Cell.innerHTML = '<input type="hidden" name="is_cont_work' + row_count + '" value="'+ is_cont_work +'">';
	}
}

/*eğitim bilgileri*/
<cfif isdefined('get_edu_info') and (get_edu_info.recordcount)>
	row_edu=<cfoutput>#get_edu_info.recordcount#</cfoutput>;
	satir_say_edu=0;
<cfelse>
	row_edu=0;
	satir_say_edu=0;
</cfif>
function sil_edu(sv)
{
	var my_element_edu=eval("employe_detail.row_kontrol_edu"+sv);
	my_element_edu.value=0;
	var my_element_edu=eval("frm_row_edu"+sv);
	my_element_edu.style.display="none";
	satir_say_edu--;
}

function gonder_upd_edu(count_new)
{
	
	form_edu_info.edu_type_new.value = eval("employe_detail.edu_type"+count_new).value;//Okul Türü
	if(eval("employe_detail.edu_id"+count_new) != undefined && eval("employe_detail.edu_id"+count_new).value != '')//eğerki okul listeden seçiliyorsa seçilen okulun id si
		form_edu_info.edu_id_new.value = eval("employe_detail.edu_id"+count_new).value;
	else
		form_edu_info.edu_id_new.value = '';
	
	if(eval("employe_detail.edu_name"+count_new) != undefined && eval("employe_detail.edu_name"+count_new).value != '')
		form_edu_info.edu_name_new.value = eval("employe_detail.edu_name"+count_new).value;
	else
		form_edu_info.edu_name_new.value = '';
	
	form_edu_info.edu_start_new.value = eval("employe_detail.edu_start"+count_new).value;
	form_edu_info.edu_finish_new.value = eval("employe_detail.edu_finish"+count_new).value;
	form_edu_info.edu_rank_new.value = eval("employe_detail.edu_rank"+count_new).value;
	if(eval("employe_detail.edu_high_part_id"+count_new) != undefined && eval("employe_detail.edu_high_part_id"+count_new).value != '')
		form_edu_info.edu_high_part_id_new.value = eval("employe_detail.edu_high_part_id"+count_new).value;
	else
		form_edu_info.edu_high_part_id_new.value = '';
		
	if(eval("employe_detail.edu_part_id"+count_new) != undefined && eval("employe_detail.edu_part_id"+count_new).value != '')
		form_edu_info.edu_part_id_new.value = eval("employe_detail.edu_part_id"+count_new).value;
	else
		form_edu_info.edu_part_id_new.value = '';
		
	if(eval("employe_detail.edu_part_name"+count_new) != undefined && eval("employe_detail.edu_part_name"+count_new).value != '')
		form_edu_info.edu_part_name_new.value = eval("employe_detail.edu_part_name"+count_new).value;
	else
		form_edu_info.edu_part_name_new.value = '';
	form_edu_info.is_edu_continue_new.value = eval("employe_detail.is_edu_continue"+count_new).value;
	windowopen('','medium','kryr_pop');
	form_edu_info.target='kryr_pop';
	form_edu_info.action = '<cfoutput>#request.self#?fuseaction=hr.popup_add_edu_info&count_edu='+count_new+'&ctrl_edu=1</cfoutput>';
	form_edu_info.submit();	
}

function gonder_edu(edu_type,ctrl_edu,count_edu,edu_id,edu_name,edu_start,edu_finish,edu_rank,edu_high_part_id,edu_part_id,edu_part_name,is_edu_continue)
{
	var edu_type = edu_type.split(';')[0];
	if(ctrl_edu == 1)
	{
		eval("employe_detail.edu_type"+count_edu).value=edu_type;
		if(edu_type != undefined && edu_type != '')
		{
			var get_edu_part_name_sql = wrk_safe_query('hr_get_edu_part_name','dsn',0,edu_type);
			if(get_edu_part_name_sql.recordcount)
				var edu_type_name = get_edu_part_name_sql.EDUCATION_NAME;
		}	
		eval("employe_detail.edu_type_name"+count_edu).value=edu_type_name;
		eval("employe_detail.edu_id"+count_edu).value=edu_id;
		eval("employe_detail.edu_high_part_id"+count_edu).value=edu_high_part_id;
		eval("employe_detail.edu_part_id"+count_edu).value=edu_part_id;
		if(edu_id != '' && edu_id != -1)
		{
			var get_cv_edu_new = wrk_safe_query('hr_get_cv_edu_new','dsn',0,edu_id);
			if(get_cv_edu_new.recordcount)
				var edu_name_degisken = get_cv_edu_new.SCHOOL_NAME;		
			eval("employe_detail.edu_name"+count_edu).value=edu_name_degisken;
		}
		else
		{
			var edu_name_degisken = edu_name;
			eval("employe_detail.edu_name"+count_edu).value=edu_name_degisken;
		}

		eval("employe_detail.edu_start"+count_edu).value=edu_start;
		eval("employe_detail.edu_finish"+count_edu).value=edu_finish;
		eval("employe_detail.edu_rank"+count_edu).value=edu_rank;
		if(eval("employe_detail.edu_high_part_id"+count_edu) != undefined && eval("employe_detail.edu_high_part_id"+count_edu).value != '' && edu_high_part_id != -1)
		{
			var get_cv_edu_high_part_id = wrk_safe_query('hr_cv_edu_high_part_id_q','dsn',0,edu_high_part_id); 
			if(get_cv_edu_high_part_id.recordcount)
				var edu_part_name_degisken = get_cv_edu_high_part_id.HIGH_PART_NAME;
			eval("employe_detail.edu_part_name"+count_edu).value=edu_part_name_degisken;
		}
		else if(eval("employe_detail.edu_part_id"+count_edu) != undefined && eval("employe_detail.edu_part_id"+count_edu).value != '' && edu_part_id != -1)
		{
			var get_cv_edu_part_id = wrk_safe_query('hr_cv_edu_part_id_q','dsn',0,edu_part_id);
			if(get_cv_edu_part_id.recordcount)
				var edu_part_name_degisken = get_cv_edu_part_id.PART_NAME;
			eval("employe_detail.edu_part_name"+count_edu).value=edu_part_name_degisken;
		}
		else
		{
			var edu_part_name_degisken = edu_part_name;
			eval("employe_detail.edu_part_name"+count_edu).value=edu_part_name_degisken;
		}
		eval("employe_detail.is_edu_continue"+count_edu).value=is_edu_continue;
	}
	else
	{
		row_edu++;
		employe_detail.row_edu.value = row_edu;
		satir_say_edu++;
		var new_Row_Edu;
		var new_Cell_Edu;
		new_Row_Edu = document.getElementById("table_edu_info").insertRow(document.getElementById("table_edu_info").rows.length);
		new_Row_Edu.setAttribute("name","frm_row_edu" + row_edu);
		new_Row_Edu.setAttribute("id","frm_row_edu" + row_edu);		
		new_Row_Edu.setAttribute("NAME","frm_row_edu" + row_edu);
		new_Row_Edu.setAttribute("ID","frm_row_edu" + row_edu);
		
		
		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML = '<a href="javascript://" onClick="gonder_upd_edu('+row_edu+');"><img src="/images/update_list.gif" border="0" align="absbottom"></a>';
		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML = '<input  type="hidden" value="1" name="row_kontrol_edu' + row_edu +'" ><a href="javascript://" onclick="sil_edu(' + row_edu + ');"><img  src="images/delete_list.gif" border="0"></a>';
		new_Cell_Edu.innerHTML += '<input type="hidden" name="edu_type' + row_edu + '" value="'+ edu_type +'">';
		new_Cell_Edu.innerHTML += '<input type="hidden" name="edu_id' + row_edu + '" value="'+ edu_id +'">';
		new_Cell_Edu.innerHTML += '<input type="hidden" name="edu_high_part_id' + row_edu + '" value="'+ edu_high_part_id +'">';
		new_Cell_Edu.innerHTML += '<input type="hidden" name="edu_part_id' + row_edu + '" value="'+ edu_part_id +'">';
		new_Cell_Edu.innerHTML += '<input type="hidden" name="is_edu_continue' + row_edu + '" value="'+ is_edu_continue +'">';
	
		if(edu_type != undefined && edu_type != '')
		{
			var get_edu_part_name_sql = wrk_safe_query('hr_get_edu_part_name','dsn',0,edu_type);
			if(get_edu_part_name_sql.recordcount)
				var edu_type_name = get_edu_part_name_sql.EDUCATION_NAME;
		}	
		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML = '<input style="width:80px;" type="text" name="edu_type_name' + row_edu + '" value="'+ edu_type_name +'" class="boxtext" readonly>';
		if(edu_id != '' && edu_id != -1)
		{
			var get_cv_edu_new = wrk_safe_query('hr_get_cv_edu_new','dsn',0,edu_id);
			if(get_cv_edu_new.recordcount)
				var edu_name_degisken = get_cv_edu_new.SCHOOL_NAME;
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input style="width:185px;" type="text" name="edu_name' + row_edu + '" value="'+ edu_name_degisken +'" class="boxtext" readonly>';
		}
		else
		{
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input style="width:185px;" type="text" name="edu_name' + row_edu + '" value="'+ edu_name +'" class="boxtext" readonly>';
		}
		new_Cell_Edu.innerHTML += '<input type="hidden" name="gizli' + row_edu + '" value="" class="boxtext" readonly>';
		
		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML = '<input style="width:70px;" type="text" name="edu_start' + row_edu + '" value="'+ edu_start +'" class="boxtext" readonly>';
		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML = '<input style="width:70px;" type="text" name="edu_finish' + row_edu + '" value="'+ edu_finish +'" class="boxtext" readonly>';
		new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
		new_Cell_Edu.innerHTML = '<input style="width:65px;" type="text" name="edu_rank' + row_edu + '" value="'+ edu_rank +'" class="boxtext" readonly>';
		if(edu_high_part_id != undefined && edu_high_part_id != '' && edu_high_part_id != -1)
		{
			var get_cv_edu_high_part_id = wrk_safe_query('hr_cv_edu_high_part_id_q','dsn',0,edu_high_part_id);
			if(get_cv_edu_high_part_id.recordcount)
			var edu_part_name_degisken = get_cv_edu_high_part_id.HIGH_PART_NAME;
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input type="text" name="edu_part_name' + row_edu + '" value="'+ edu_part_name_degisken +'" class="boxtext" readonly>';
		}
		else if(edu_part_id != undefined && edu_part_id != '' && edu_part_id != -1)
		{
			var get_cv_edu_part_id = wrk_safe_query('hr_cv_edu_part_id_q','dsn',0,edu_part_id);
			if(get_cv_edu_part_id.recordcount)
				var edu_part_name_degisken = get_cv_edu_part_id.PART_NAME;
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input type="text" name="edu_part_name' + row_edu + '" value="'+ edu_part_name_degisken +'" class="boxtext" readonly>';
		}
		else
		{
			new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
			new_Cell_Edu.innerHTML = '<input type="text" name="edu_part_name' + row_edu + '" value="'+ edu_part_name +'" class="boxtext" readonly>';
		}
	}
}
/*Eğitim Bilgileri*/
</script>
