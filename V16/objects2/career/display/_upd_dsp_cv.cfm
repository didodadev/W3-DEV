<cfif not isnumeric(attributes.empapp_id)>
	<cfset hata = 10>
	<cfinclude template="../../dsp_hata.cfm">
</cfif>
<cfset xfa.del= "objects2emptypopup_del_cv">
<cfquery name="GET_APP" datasource="#DSN#">
	SELECT * FROM EMPLOYEES_APP WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#EMPAPP_ID#">
</cfquery>
<cfif not get_app.recordcount>
	<script type="text/javascript">
		alert('Özgeçmişin kaydı bulunamıyor kayıt silinmiş olabilir!');
		history.go(-1);
	</script>
	<cfabort>
</cfif>
	<cfinclude template="../query/get_app_identy.cfm">
	<cfinclude template="../query/get_know_levels.cfm">
	<cfinclude template="../query/get_moneys.cfm">
	<cfinclude template="../query/get_edu_level.cfm">
	<cfquery name="IM_CATS" datasource="#dsn#">
		SELECT * FROM SETUP_IM
	</cfquery>
	<cfquery name="GET_ID_CARD_CATS" datasource="#dsn#">
		SELECT * FROM SETUP_IDENTYCARD
	</cfquery>
	<cfquery name="MOBIL_CATS" datasource="#dsn#">
		SELECT * FROM SETUP_MOBILCAT ORDER BY MOBILCAT
	</cfquery>
	<cfquery name="GET_COMMETHODS" datasource="#dsn#">
		SELECT * FROM SETUP_COMMETHOD ORDER BY COMMETHOD
	</cfquery>
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

<cfform name="employe_detail" action="#request.self#?fuseaction=objects2.emptypopup_upd_cv" method="post" enctype="multipart/form-data">
	<input type="Hidden" name="empapp_id" id="empapp_id" value="<cfoutput>#empapp_id#</cfoutput>">
	<input type="Hidden" name="old_photo" id="old_photo" value="<cfoutput>#get_app.photo#</cfoutput>">
	<input type="hidden" name="counter" id="counter" value="">
	<input type="hidden" name="rowCount" id="rowCount" value="0">
	<cfif not len(get_app.valid)>
		<input type="Hidden" name="valid" id="valid" value="">
	</cfif>
	<table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td class="headbold">CV: <cfoutput>#get_app.name# #get_app.surname#</cfoutput></td>
			<td width="60%" align="center" id="upload_status"> <font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b><cf_get_lang no='1025.Resim Upload Ediliyor'></b></font> </td>
		</tr>
	</table>
	<table width="98%" cellpadding="0" cellspacing="0" border="0">
	<tr>
	<td valign="top">
	<table width="100%" align="center" cellpadding="2" cellspacing="1" border="0" class="color-border">
	<!--- kişisel--->
	<tr>
		<td class="color-row">
			<table>
				<tr>
					<td class="color-row" colspan="4"><strong><cf_get_lang no='296.Kimlik ve İletişim Bilgileri'></strong></td>
				</tr>
				<tr>
					<cfoutput>
					<td><cf_get_lang_main no='75.No'></td>
					<td>#get_app.empapp_id#</td>
					<td><cf_get_lang_main no='81.Aktif'></td>
					<td><input type="checkbox" name="app_status" id="app_status" value="1" <cfif get_app.app_status eq 1>checked</cfif>></td>
					</cfoutput>
				</tr>
				<tr>
					<td><cf_get_lang_main no='219.Ad'>*</td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang no='219.İsim Girmelisiniz'></cfsavecontent>
						<cfinput type="text" value="#get_app.name#" name="name" style="width:150px;" maxlength="50" required="Yes" message="#message#">
					</td>
					<td><cf_get_lang no='955.Direkt Tel'></td>
					<td><cfsavecontent variable="message"><cf_get_lang no='22.direkt tel girmelisiniz'></cfsavecontent>
						<cfinput value="#get_app.worktelcode#" type="text" name="worktelcode" style="width:48px;" maxlength="3" validate="integer" message="#message#">
						<cfinput value="#get_app.worktel#" type="text" name="worktel" style="width:99px;" maxlength="7" validate="integer" message="#message#">
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='1314.Soyad'>*</td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang no='237.Soyad girmelisiniz'></cfsavecontent>
						<cfinput value="#get_app.surname#" type="text" name="surname" style="width:150px;" maxlength="50" required="Yes" message="#message#">
					</td>
					<td><cf_get_lang no='231.Dahili Tel'></td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang no ='1156.Dahili tel girmelisiniz'></cfsavecontent>
						<cfinput value="#get_app.extension#" type="text" name="extension" style="width:150px;" maxlength="5" validate="integer" message="#message#">
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='140.Şifre'> (key sensitive)</td>
					<td><cfinput value="" type="password" name="empapp_password" style="width:150px;" maxlength="16"></td>
					<td><cf_get_lang_main no='1070.Mobil Tel'></td>
					<td><select name="mobilcode" id="mobilcode" style="width:48px;">
						<cfoutput query="mobil_cats">
						<option value="#mobilcat#" <cfif get_app.mobilcode eq mobilcat>selected</cfif>>#mobilcat# </cfoutput>
						</select>
						<cfsavecontent variable="message"><cf_get_lang no ='1160.Mobil Telefon Girmelisiniz'></cfsavecontent>
						<cfinput value="#get_app.mobil#" type="text" name="mobil" style="width:99px;" maxlength="7" validate="integer" message="#message#">
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='16.webmail'></td>
					<td><cfinput type="text" name="email" style="width:150px;" maxlength="100" value="#get_app.email#">
					</td>
					<td><cf_get_lang_main no='1070.Mobil Tel'> 2</td>
					<td><select name="mobilcode2" id="mobilcode2" style="width:48px;">
						<cfoutput query="mobil_cats">
						<option value="#mobilcat#" <cfif get_app.mobilcode2 eq mobilcat>selected</cfif>>#mobilcat# </cfoutput>
						</select>
						<cfsavecontent variable="message"><cf_get_lang no ='1160.Mobil Telefon Girmelisiniz'></cfsavecontent>
						<cfinput value="#get_app.mobil2#" type="text" name="mobil2" style="width:99px;" maxlength="7" validate="integer" message="#message#">
					</td>
				</tr>
				<tr>
					<td width="115"><cf_get_lang no='226.Ev Tel'></td>
					<td width="190">
						<cfsavecontent variable="message"><cf_get_lang no='297.Ev telefonu girmelisiniz'></cfsavecontent>
						<cfinput value="#get_app.hometelcode#" type="text" name="hometelcode" style="width:40px;" maxlength="3" validate="integer" message="#message#">
						<cfinput value="#get_app.hometel#" type="text" name="hometel" style="width:107px;"  maxlength="7"validate="integer" message="#message#">
					</td>
					<td width="110"><cf_get_lang_main no='60.Posta Kodu'></td>
					<td><cfinput type="text" name="homepostcode" style="width:150px;" maxlength="10" value="#get_app.homepostcode#">
					</td>
			</tr>
			<tr>
				<td rowspan="3" valign="top"><cf_get_lang no='213.Ev Adresi'></td>
				<cfsavecontent variable="message1"><cf_get_lang_main no='1687.FAzla karakter sayısı'></cfsavecontent>
				<td rowspan="3"><textarea name="homeaddress" id="homeaddress" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>" style="width:150px;height:60px;"><cfoutput>#get_app.homeaddress#</cfoutput></textarea></td>
				<td height="26"><cf_get_lang_main no='580.Bölge'></td>
				<td><cfinput type="text" name="homecounty" style="width:150px;" maxlength="30" value="#get_app.homecounty#"></td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='559.Şehir'></td>
				<td>
				<cfif len(get_app.homecity)>
					<cfquery name="get_homecity" dbtype="query">
						SELECT CITY_NAME FROM get_city WHERE CITY_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.homecity#">
					</cfquery>
				</cfif>
				<input type="hidden" name="homecity" id="homecity" value="<cfoutput>#get_app.homecity#</cfoutput>">
				<input type="text" name="homecity_name" id="homecity_name" value="<cfif isdefined('get_homecity')><cfoutput>#get_homecity.city_name#</cfoutput></cfif>" style="width:150px;">
				<a href="javascript://" onClick="pencere_ac();" title="<cf_get_lang_main no='559.Şehir'> <cf_get_lang_main no='170.Ekle'>"><img src="/images/plus_list.gif" border="0" align="absmiddle" alt="<cf_get_lang_main no='559.Şehir'> <cf_get_lang_main no='170.Ekle'>" /></a>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='807.Ülke'></td>
				<td colspan="3">
				<select name="homecountry" id="homecountry" style="width:150px;">
					<option value=""><cf_get_lang_main no='322.SEÇİNİZ'></option>
					<cfoutput query="get_country">
					<option value="#get_country.country_id#" <cfif get_app.homecountry eq get_country.country_id>selected</cfif>>#get_country.country_name#</option>
					</cfoutput>
				</select>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no='298.Oturduğunuz Ev'></td>
				<td colspan="3">
					<input type="radio" name="home_status" id="home_status" value="1" <cfif get_app.home_status eq 1>checked</cfif>>&nbsp;<cf_get_lang no='332.Kendinizin'>
					<input type="radio" name="home_status" id="home_status" value="2" <cfif get_app.home_status eq 2>checked</cfif>>&nbsp;<cf_get_lang no='333.Ailenizin'>
					<input type="radio" name="home_status" id="home_status" value="3" <cfif get_app.home_status eq 3>checked</cfif>>&nbsp;<cf_get_lang no='334.Kira'>
				</td>
			</tr>
				<tr>
					<td><cf_get_lang no='1031.Instant Message'></td>
					<td><select name="imcat_ID" id="imcat_ID" style="width:48px;" >
						<cfoutput query="im_cats">
						<option value="#imcat_id#" <cfif get_app.imcat_id eq imcat_id>selected</cfif>>#imcat# 
						</cfoutput>
						</select>
						<cfinput type="text" name="im" style="width:99px;" maxlength="30" value="#get_app.im#">
					</td>
					<td><cf_get_lang_main no='1350.Vergi Dairesi'></td>
					<td><cfinput type="text" name="tax_office" style="width:150px;" maxlength="50" value="#get_app.tax_office#"></td>
				</tr>
				<tr>
					<td><cf_get_lang no='207.Fotoğraf'></td>
					<td><input type="file" name="photo" id="photo" style="width:150px;"></td>
					<td><cf_get_lang_main no='340.Vergi No'></td>
					<td><cfinput type="text" name="tax_number" style="width:150px;" maxlength="50" value="#get_app.tax_number#"></td>
				</tr>
				<tr>
					<td><cfif len(get_app.photo)><cf_get_lang no='208.fotoğrafı Sil'></cfif></td>
					<td><cfif len(get_app.photo)>
						<input type="Checkbox" name="del_photo" id="del_photo" value="1">
						<cf_get_lang_main no='83.Evet'>
						</cfif>
					</td> 
				</tr>
				<tr>
					<td width="115"><cf_get_lang_main no='1315.Doğum Tarihi'></td>
					<td width="185">
						<cfsavecontent variable="message"><cf_get_lang no='299.Doğum tarihi girmelisiniz'></cfsavecontent>
						<cfinput type="text" style="width:150px;" name="birth_date" value="#dateformat(get_app_identy.birth_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#">
						<cf_wrk_date_image date_field="birth_date"></td>
					<td width="110"><cf_get_lang_main no='378.Doğum Yeri'></td>
					<td><cfinput type="text" style="width:150px;" name="birth_place" maxlength="100" value="#get_app_identy.birth_place#">
				</tr>
				<tr>
					<td><cf_get_lang no='202.Uyruğu'></td>
					<td>
					<select name="nationality" id="nationality" style="width:150px;">
						<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
						<cfoutput query="get_country">
						<option value="#country_id#" <cfif get_country.country_id eq get_app.nationality>selected</cfif>>#country_name#</option>
						</cfoutput>
					</select>
					</td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<td width="115"><cf_get_lang no='300.Kimlik Kartı Tipi'></td>
					<td width="190">
						<select name="identycard_cat" id="identycard_cat" style="width:150px;" >
						<cfoutput query="get_id_card_cats">
						<option value="#identycat_id#" <cfif get_app.identycard_cat eq identycat_id>selected</cfif>>#identycat# </cfoutput>
						</select>
					</td>
					<td><cf_get_lang no='301.Kimlik Kartı No'></td>
					<td><cfinput type="text" name="identycard_no" style="width:150px;" maxlength="50" value="#get_app.identycard_no#"></td>
				</tr>
				<tr>
					<td><cf_get_lang no='302.Nüfusa Kayıtlı Olduğu İl'></td>
					<td>
					<cfinput type="text" name="CITY" style="width:150px;" maxlength="100" value="#get_app_identy.CITY#">
					</td>
					<td width="100"><cf_get_lang_main no='613.TC Kimlik No'></td>
					<td><cfinput type="text" name="TC_IDENTY_NO" style="width:150px;" maxlength="10" value="#get_app_identy.TC_IDENTY_NO#"></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr class="color-row">
		<td height="20" STYLE="cursor:pointer;" onClick="gizle_goster(gizli3);"><strong><cf_get_lang no='197.Kişisel Bilgiler'></strong></td>
	</tr>
	<tr STYLE="display:none;" ID="gizli3">
		<td class="color-row">
		<!--- Kişisel ---->
		<table>
			<tr>
				<tr>
					<td><cf_get_lang_main no='352.Cinsiyet'></td>
					<td>
						<input type="radio" name="sex" id="sex" value="1" <cfif get_app.sex eq 1>checked</cfif>><cf_get_lang_main no='1547.Erkek'>
						<input type="radio" name="sex" id="sex" value="0" <cfif get_app.sex eq 0>checked</cfif>><cf_get_lang_main no='1546.Kadin'>
					</td>
					<td><cf_get_lang no='201.Evlilik Durumu'></td>
					<td>
						<input type="radio" name="married" id="married" value="0" <cfif get_app_identy.married eq 0>checked</cfif>><cf_get_lang no ='816.Bekar'>
						<input type="radio" name="married" id="married" value="1" <cfif get_app_identy.married eq 1>checked</cfif>><cf_get_lang no='209.Evli'>
					</td>
				</tr>
				<td><cf_get_lang no='303.Eşinin Adı'></td>
				<td><cfinput type="text" name="partner_name" value="#get_app.partner_name#" maxlength="150" style="width:150px;">
				</td>
				<td><cf_get_lang no='304.Eşinin Ç Şirket'></td>
				<td><cfinput type="text" name="partner_company" maxlength="50" style="width:150px;" value="#get_app.partner_company#"></td>
			</tr>
			<tr>
				<td><cf_get_lang no='305.Eşinin Pozisyonu'></td>
				<td><cfinput type="text" name="partner_position" maxlength="50" style="width:150px;" value="#get_app.partner_position#"></td>
				<td><cf_get_lang no='206.Çocuk Sayısı'></td>                     
				<td><cfsavecontent variable="message"><cf_get_lang no ='817.Çocuk sayısı girmelisiniz'></cfsavecontent>
					<cfinput type="text" name="child" maxlength="2" style="width:150px;" value="#get_app.child#" validate="integer" message="#message#">
				</td>
			</tr>
			<tr>
				<td width="110"><cf_get_lang no='306.Sigara Kullanıyor mu'>?</td>
				<td width="185"><input type="radio" name="use_cigarette" id="use_cigarette" value="1" <cfif get_app.use_cigarette eq 1>checked</cfif>>
				<cf_get_lang_main no='83.Evet'>
				<input type="radio" name="use_cigarette" id="use_cigarette" value="0" <cfif get_app.use_cigarette eq 0 or not len(get_app.use_cigarette)>checked</cfif>>
				<cf_get_lang_main no='84.Hayır'> </td>
				<td>Ş<cf_get_lang no='307.ehit Yakını Misiniz'></td>
				<td><input type="radio" name="martyr_relative" id="martyr_relative" value="1" <cfif get_app.martyr_relative eq 1>checked</cfif>>
				<cf_get_lang_main no='83.Evet'>
				<input type="radio" name="martyr_relative" id="martyr_relative" value="0" <cfif get_app.martyr_relative eq 0 or not len(get_app.martyr_relative)>checked</cfif>>
				<cf_get_lang_main no='84.Hayır'>
				</td>
			</tr>
			<tr>
				<td width="110"><cf_get_lang no='308.Özürlü'></td>
				<td width="185">
				<input type="radio" name="defected" id="defected" value="1" onClick="seviye();" <cfif get_app.defected eq 1>checked</cfif>>
				<cf_get_lang_main no='83.Evet'>
				<input type="radio" name="defected" id="defected" value="0" onClick="seviye();" <cfif get_app.defected eq 0>checked</cfif>>
				<cf_get_lang_main no='84.Hayır'> &nbsp;&nbsp;&nbsp;
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
				<td><cf_get_lang no='309.Hüküm Giydi mi'></td>
				<td>
					<input type="radio" name="sentenced" id="sentenced" value="1" <cfif get_app.sentenced EQ 1>checked</cfif>>
					<cf_get_lang_main no='83.Evet'>
					<input type="radio" name="sentenced" id="sentenced" value="0" <cfif get_app.sentenced EQ 0>checked</cfif>>
					<cf_get_lang_main no='84.Hayır'>
				</td>
				<td><cf_get_lang no='310.Ehliyet Sınıf /Yıl'></td>
				<td>
				<cfquery name="GET_DRIVER_LIS" datasource="#DSN#">
					SELECT LICENCECAT_ID,LICENCECAT FROM SETUP_DRIVERLICENCE ORDER BY LICENCECAT
				</cfquery>
				  <select name="driver_licence_type" id="driver_licence_type" style="width:75;">
				  <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
				  <cfoutput query="get_driver_lis">
					  <option value="#licencecat_id#"<cfif licencecat_id eq get_app.licencecat_id> selected</cfif>>#licencecat#</option>
				  </cfoutput>
				  </select>
				<cfsavecontent variable="message_driver"><cf_get_lang_main no ='370.Tarih Değerinizi Kontrol Ediniz'></cfsavecontent>
				<cfinput type="text" name="licence_start_date" value="#DateFormat(get_app.licence_start_date,'dd/mm/yyyy')#" maxlength="10" validate="eurodate" message="#message_driver#" style="width:65px;" tabindex="15">
				<cf_wrk_date_image date_field="licence_start_date">

				</td>
			</tr>
			<tr>
				<td><cf_get_lang no='311.Göçmen'></td>
				<td>
				<input type="radio" name="immigrant" id="immigrant" value="1" <cfif get_app.immigrant EQ 1>checked</cfif>>
				<cf_get_lang_main no='83.Evet'>
				<input type="radio" name="immigrant" id="immigrant" value="0" <cfif get_app.immigrant EQ 0>checked</cfif>>
				<cf_get_lang_main no='84.Hayır'> </td>
				<td><cf_get_lang no='312.Ehliyet No'></td>
				<td><cfinput type="Text" name="driver_licence" maxlength="40" style="width:150px;" value="#get_app.driver_licence#"></td>
			</tr>
			<tr>
				<td colspan="3"><cf_get_lang no='313.Kaç yıldır aktif olarak araba kullanıyorsunuz'>?</td>
				<cfsavecontent variable="alert"><cf_get_lang no ='1157.Ehliyet Aktiflik Süresine Sayı Giriniz'></cfsavecontent>
				<td><cfinput type="text" name="driver_licence_actived" value="#get_app.driver_licence_actived#" maxlength="2"  style="width:150px;" validate="integer" message="#alert#"></td>
			</tr>
			<tr>
				<td colspan="3"><cf_get_lang no='335.Bir suç zannıyla tutuklandınız mı'>?</td>
				<td><input type="radio" name="defected_probability" id="defected_probability" value="1"  <cfif get_app.defected_probability eq 1>checked</cfif>>
					<cf_get_lang_main no='83.Evet'> &nbsp;
					<input type="radio" name="defected_probability" id="defected_probability" value="0" <cfif get_app.defected_probability eq 0>checked</cfif>>
					<cf_get_lang_main no='84.Hayır'>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no='314.Koğuşturma'></td>
				<td colspan="3"><cfinput type="text" name="investigation" value="#get_app.INVESTIGATION#" maxlength="150" style="width:150px;"></td>
			</tr>
			<tr>
				<td colspan="3"><cf_get_lang no='315.Devam eden bir hastalık veya bedeni sorununuz var mı'>?</td>
				<td><input type="radio" name="illness_probability" id="illness_probability" value="1" <cfif get_app.illness_probability eq 1>checked</cfif>>
				<cf_get_lang_main no='83.Evet'> &nbsp;
				<input type="radio" name="illness_probability" id="illness_probability" value="0" <cfif get_app.illness_probability eq 0>checked</cfif>>
				<cf_get_lang_main no='84.Hayır'>
				</td>
			</tr>
			<tr height="22">
				<td valign="top"><cf_get_lang no='316.Varsa nedir?'></td>
				<td><textarea name="illness_detail" id="illness_detail" style="width:150px;height:40px;"><cfoutput>#get_app.illness_detail#</cfoutput></textarea></td>
				<td valign="top"><cf_get_lang no='317.Geçirdiğiniz Ameliyat'></td>
				<td><textarea name="surgical_operation" id="surgical_operation" style="width:150px;" maxlength="150" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"><cfoutput>#get_app.SURGICAL_OPERATION#</cfoutput></textarea></td>
			</tr>
			<tr height="22">
				<td><cf_get_lang no='318.Askerlik'></td>
				<td colspan="3">
					<input type="radio" name="military_status" id="military_status" value="0" <cfif get_app.military_status eq 0>checked</cfif> onClick="tecilli_fonk(this.value)">
					<cf_get_lang no='319.Yapmadı'> &nbsp;&nbsp;&nbsp;
					<input type="radio" name="military_status" id="military_status" value="1" <cfif get_app.military_status eq 1>checked</cfif> onClick="tecilli_fonk(this.value)">
					<cf_get_lang no='320.Yaptı'>&nbsp;&nbsp;&nbsp;
					<input type="radio" name="military_status" id="military_status" value="2" <cfif get_app.military_status eq 2>checked</cfif> onClick="tecilli_fonk(this.value)">
					<cf_get_lang no='321.Muaf'>&nbsp;&nbsp;&nbsp;
					<input type="radio" name="military_status" id="military_status" value="3" <cfif get_app.military_status eq 3>checked</cfif> onClick="tecilli_fonk(this.value)">
					<cf_get_lang no='322.Yabancı'> &nbsp;&nbsp;&nbsp;
					<input type="radio" name="military_status" id="military_status" value="4" <cfif get_app.military_status eq 4>checked</cfif> onClick="tecilli_fonk(this.value)">
					<cf_get_lang no='323.Tecilli'>
				</td>
			</tr>
			<tr height="22" <cfif get_app.military_status neq 4>style="display:none"</cfif> id="Tecilli">
				<td><cf_get_lang no='324.Tecil Gerekçesi'></td>
				<td><cfinput type="text" name="military_delay_reason" style="width:150px;" maxlength="30" value="#get_app.military_delay_reason#"></td>
				<td><cf_get_lang no='325.Tecil Süresi'></td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang no='328.Tecil Süresi Girmelisiniz'></cfsavecontent>
					<cfinput type="text" style="width:150px;" name="military_delay_date" value="#dateformat(get_app.military_delay_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#">
					<cf_wrk_date_image date_field="military_delay_date">
				</td>
			</tr>
			<tr height="22" <cfif get_app.military_status neq 2>style="display:none"</cfif> id="Muaf">
				<td><cf_get_lang no='327.Muaf Olma Nedeni'></td>
				<td><input type="text" style="width:150px;" name="military_exempt_detail" id="military_exempt_detail" maxlength="100" value="<cfoutput>#get_app.military_exempt_detail#</cfoutput>">
				</td>
			</tr>
			<tr height="22" <cfif get_app.military_status neq 1>style="display:none"</cfif> id="Yapti">
				<td colspan="4">
				<table>
					<tr>
						<td width="110"><cf_get_lang no='326.Terhis Tarihi'></td>
						<td width="200">
							<cfsavecontent variable="message"><cf_get_lang no='328.Tecil Süresi Girmelisiniz'></cfsavecontent>
							<cfinput type="text" style="width:150px;" name="military_finishdate" value="#dateformat(get_app.military_finishdate,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#">
							<cf_wrk_date_image date_field="military_finishdate">
						</td>
						<td width="100" nowrap><cf_get_lang_main no='1716.Süresi'> (<cf_get_lang no='823.Ay Olarak Giriniz'>)</td>
						<td><cfsavecontent variable="message"><cf_get_lang no='329.Askerlik Süresini Girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="military_month" value="#get_app.military_month#" validate="integer" maxlength="2" message="#message#" style="width:150px;">
						</td>
					</tr>
					<tr>
						<td></td>
						<td><input type="radio" name="military_rank" id="military_rank" value="0" <cfif get_app.military_rank eq 0>checked</cfif>><cf_get_lang no ='1159.Er'> </td>
						<td></td>
						<td><input type="radio" name="military_rank" id="military_rank" value="1" <cfif get_app.military_rank eq 1>checked</cfif>> <cf_get_lang no='824.Yedek Subay'></td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<!--- kişisel bitti--->
	<tr class="color-row">
		<td colspan="4" STYLE="cursor:pointer;" onClick="gizle_goster(gizli1);"><STRONG><cf_get_lang no='330.Kimlik Detayları'></STRONG></td>
	</tr>
	<tr STYLE="display:none;"  ID="gizli1">
		<td class="color-row">
		<table>
			<tr>
				<td width="105"><cf_get_lang_main no='225.Seri/No'></td>
				<td width="185">
					<cfinput type="text" name="series" style="width:50px;" maxlength="20" value="#get_app_identy.series#">
					<cfinput type="text" name="number" style="width:98px;" maxlength="50" value="#get_app_identy.number#">
				</td>
				<td><cf_get_lang_main no='1029.Kan Grubu'></td>
				<td>
					<select name="BLOOD_TYPE" id="BLOOD_TYPE" style="width:150px;">
						<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
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
				<td><cf_get_lang_main no='621.Baba Adı'></td>
				<td><cfinput name="father" type="text" value="#get_app_identy.father#" maxlength="75" style="width:150px;"></td>
				<td><cf_get_lang no='336.Anne Adı'></td>
				<td><cfinput name="mother" type="text" value="#get_app_identy.mother#" maxlength="75" style="width:150px;"></td>
			</tr>
			<tr>
			<td><cf_get_lang no='337.Baba İş'></td>
			<td><cfinput type="text" name="father_job" value="#get_app_identy.father_job#" maxlength="50" style="width:150px;"></td>
			<td><cf_get_lang no='338.Anne İş'></td>
			<td><cfinput type="text" name="mother_job" value="#get_app_identy.mother_job#" maxlength="50" style="width:150px;"></td>
			</tr>
			<tr height="22">
				<td><cf_get_lang no='339.Önceki Soyadı'></td>
				<td><cfinput type="text" name="LAST_SURNAME" style="width:150px;" maxlength="100" value="#get_app_identy.LAST_SURNAME#"></td>
				<td><cf_get_lang no='340.Dini'></td>
				<td><cfinput type="text" name="religion" style="width:150px;" maxlength="50" value="#get_app_identy.religion#"></td>
			</tr>
			<tr height="22">
				<td colspan="4"><STRONG><cf_get_lang no='341.Nüfusa Kayıtlı Olduğu'></STRONG></td>
			</tr>
			<tr height="22">
				<td><cf_get_lang_main no='1226.İlçe'></td>
				<td><cfinput type="text" name="COUNTY" style="width:150px;" maxlength="100" value="#get_app_identy.COUNTY#"></td>
				<td><cf_get_lang no='342.Cilt No'></td>
				<td><cfinput type="text" name="BINDING" style="width:150px;" maxlength="20" value="#get_app_identy.BINDING#"></td>
			</tr>
			<tr height="22">
				<td><cf_get_lang_main no='1323.Mahalle'></td>
				<td><cfinput type="text" name="WARD" style="width:150px;" maxlength="100" value="#get_app_identy.WARD#"></td>
				<td><cf_get_lang no='344.Aile Sıra No'></td>
				<td><cfinput type="text" name="FAMILY" style="width:150px;" maxlength="20" value="#get_app_identy.FAMILY#"></td>
			</tr>
			<tr height="22">
				<td><cf_get_lang no='345.Köy'></td>
				<td><cfinput type="text" name="VILLAGE" style="width:150px;" maxlength="100" value="#get_app_identy.VILLAGE#"></td>
				<td><cf_get_lang no='346.Sıra No'></td>
				<td><cfinput type="text" name="CUE" style="width:150px;" maxlength="20" value="#get_app_identy.CUE#"></td>
			</tr>
			<tr height="22">
				<td colspan="4"><STRONG><cf_get_lang no='347.Cüzdanın'></STRONG></td>
			</tr>
			<tr height="22">
				<td><cf_get_lang no='348.Verildiği Yer'></td>
				<td><cfinput type="text" name="GIVEN_PLACE" style="width:150px;" maxlength="100" value="#get_app_identy.GIVEN_PLACE#"></td>
				<td><cf_get_lang no='349.Kayıt No'></td>
				<td><cfinput type="text" name="RECORD_NUMBER" style="width:150px;" maxlength="50" value="#get_app_identy.RECORD_NUMBER#"></td>
			</tr>
			<tr height="22">
				<td><cf_get_lang no='350.Veriliş Nedeni'></td>
				<td><cfinput type="text" name="GIVEN_REASON" style="width:150px;" maxlength="300" value="#get_app_identy.GIVEN_REASON#"></td>
				<td><cf_get_lang no='351.Veriliş Tarihi'></td>
				<td><cfsavecontent variable="message"><cf_get_lang no='351.Veriliş Tarihi'></cfsavecontent>
					<cfinput type="text" style="width:150px;" name="GIVEN_DATE" value="#dateformat(get_app_identy.GIVEN_DATE,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#">
					<cf_wrk_date_image date_field="GIVEN_DATE">
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<!--- Eğitim --->
	<tr>
		<td colspan="4" class="color-row" STYLE="cursor:pointer;" onClick="gizle_goster(gizli4);"><strong><cf_get_lang no='352.Eğitim ve Deneyim Bilgileri'></strong></td>
	</tr>
	<tr STYLE="display:none;" ID="gizli4">
		<td class="color-row"> 
		<table border="0">
			<tr>
				<td colspan="2" height="25" class="formbold"><cf_get_lang no='352.Eğitim ve Deneyim Bilgilerini Giriniz'></td>
			</tr>
			<cfquery name="get_edu_info" datasource="#DSN#">
				SELECT
					*
				FROM
					EMPLOYEES_APP_EDU_INFO
				WHERE
					<cfif isdefined("session.cp.userid")>
						EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">	
					<cfelse>
						EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
					</cfif>
			</cfquery>
			<tr>
				<td width="110"><cf_get_lang no='834.Eğitim Seviyesi'></td>
				<td>
					<select name="training_level" id="training_level" style="width:190px;">
						<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
						<cfloop query="get_edu_level">
						<option value="<cfoutput>#get_edu_level.edu_level_id#</cfoutput>" <cfif get_edu_level.edu_level_id eq get_app.training_level>selected</cfif>><cfoutput>#get_edu_level.education_name#</cfoutput></option>
						</cfloop>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="2">
				<cfif get_edu_info.recordcount>
				 <table id="table_edu_info" border="0" cellpadding="0" cellspacing="1">
				 <input type="hidden" name="row_edu" id="row_edu" value="<cfoutput>#get_edu_info.recordcount#</cfoutput>">
					<tr class="txtboldblue">
						<td style="width:75;"><cf_get_lang no='835.Okul Türü'></td>
						<td style="width:160;"><cf_get_lang no='520.Okul Adı'></td>
						<td style="width:10;">&nbsp;</td>
						<td style="width:65;"><cf_get_lang no='838.Başl Yılı'></td>
						<td style="width:65;"><cf_get_lang no='839.Bitiş Yılı'></td>
						<td style="width:65;"><cf_get_lang no='836.Not Ort'>.</td>
						<td style="width:85;"><cf_get_lang_main no='583.Bölüm'></td>
						<td>
							<input name="record_numb_edu" id="record_numb_edu" type="hidden" value="0"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_add_edu_info&ctrl_edu=0','small');" title="<cf_get_lang no ='889.Eğitim Bilgisi Ekle'>"><img src="/images/plus_list.gif" alt="<cf_get_lang no ='889.Eğitim Bilgisi Ekle'>" border="0" /></a>
						</td>
					</tr>
					<cfoutput query="get_edu_info">
					<tr id="frm_row_edu#currentrow#">
						<input type="hidden" class="boxtext" name="empapp_edu_row_id#currentrow#" id="empapp_edu_row_id#currentrow#" style="width:100%;" value="#empapp_edu_row_id#">
						<td>
							<input type="hidden" name="edu_type#currentrow#" id="edu_type#currentrow#" class="boxtext" value="#edu_type#" readonly>
							<cfif edu_type eq 1>
								<cfset edu_type_name = 'İlk Okul'>
							<cfelseif edu_type eq 2>
								<cfset edu_type_name = 'Orta Okul'>
							<cfelseif edu_type eq 3>
								<cfset edu_type_name = 'Lise'>
							<cfelseif edu_type eq 4>
								<cfset edu_type_name = 'Üniversite'>
							<cfelseif edu_type eq 5>
								<cfset edu_type_name = 'Yüksek Lisans'>
							<cfelseif edu_type eq 6>
								<cfset edu_type_name = 'Doktora'>
							</cfif>
							<input type="text" name="edu_type_name#currentrow#" id="edu_type_name#currentrow#" class="boxtext" value="#edu_type_name#" style="width:75;" readonly>
							</td>
						<td>
						<cfif len(edu_id) and edu_id neq -1>
							<cfif listfind('4,5,6',edu_type)>
								<cfquery name="get_unv_name" datasource="#dsn#">
									SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#edu_id#">
								</cfquery>
							</cfif>
							<cfset edu_name_degisken = get_unv_name.SCHOOL_NAME>
						<cfelse>
							<cfset edu_name_degisken = edu_name>
						</cfif>
							<input type="hidden" name="edu_id#currentrow#" id="edu_id#currentrow#" class="boxtext" value="<cfif len(edu_id)>#edu_id#</cfif>" readonly>
							<input type="text" style="width:160;" name="edu_name#currentrow#" id="edu_name#currentrow#" class="boxtext" value="#edu_name_degisken#" readonly>
						</td>
						<td style="width:10;">&nbsp;</td>
						<td>
							<input type="text" style="width:65;" name="edu_start#currentrow#" id="edu_start#currentrow#" class="boxtext" value="#edu_start#" readonly>
						</td>
						<td>
							<input type="text" style="width:65;" name="edu_finish#currentrow#" id="edu_finish#currentrow#" class="boxtext" value="#edu_finish#" readonly>
						</td>
						<td>
							<input type="text" style="width:65;" name="edu_rank#currentrow#" id="edu_rank#currentrow#" class="boxtext" value="#edu_rank#" readonly>
						</td>
						<td>
							<cfif (len(edu_part_id) and edu_part_id neq -1)>
								<cfif edu_type eq 3>
										<cfquery name="get_high_school_part_name" datasource="#dsn#">
											SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART WHERE HIGH_PART_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#edu_part_id#">
										</cfquery>
										<cfset edu_part_name_degisken = get_high_school_part_name.HIGH_PART_NAME>
								<cfelseif listfind('4,5',edu_type)>
										<cfquery name="get_school_part_name" datasource="#dsn#">
											SELECT PART_ID, PART_NAME FROM SETUP_SCHOOL_PART WHERE PART_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#edu_part_id#">
										</cfquery>
										<cfset edu_part_name_degisken = get_school_part_name.PART_NAME>
								</cfif>
							<cfelseif len(edu_part_name)>
									<cfset edu_part_name_degisken = edu_part_name>
							<cfelse>
									<cfset edu_part_name_degisken = "">
							</cfif>
							<input type="text" name="edu_part_name#currentrow#" id="edu_part_name#currentrow#" style="width:85;" class="boxtext" value="#edu_part_name_degisken#" readonly>
							<input type="hidden" name="edu_high_part_id#currentrow#" id="edu_high_part_id#currentrow#" class="boxtext" value="<cfif isdefined("edu_part_id") and len(edu_part_id) and edu_type eq 3>#edu_part_id#</cfif>">
							<input type="hidden" name="edu_part_id#currentrow#" id="edu_part_id#currentrow#" class="boxtext" value="<cfif listfind('4,5',edu_type) and isdefined("edu_part_id") and len(edu_part_id)>#edu_part_id#</cfif>">
							<input type="hidden" name="is_edu_continue#currentrow#" id="is_edu_continue#currentrow#" class="boxtext" value="#is_edu_continue#">
						</td>
						<td><a href="javascript://" onClick="gonder_upd_edu('#currentrow#');" title="<cf_get_lang no ='1158.Eğitim Bilgisi Güncelle'>"><img src="../../images/update_list.gif" alt="<cf_get_lang no ='1158.Eğitim Bilgisi Güncelle'>" border="0" /></a></td>
						<td><input  type="hidden" value="1" name="row_kontrol_edu#currentrow#" id="row_kontrol_edu#currentrow#"><a href="javascript://" onClick="sil_edu('#currentrow#');" title="<cf_get_lang_main no ='51.Sil'>"><img  src="images/delete_list.gif" border="0" alt="<cf_get_lang_main no ='51.Sil'>" /></a></td>				
					</tr>
					</cfoutput>
				</table>
				<cfelse>
				<table id="table_edu_info">
				 <input type="hidden" name="row_edu" id="row_edu" value="0">
				<tr class="txtboldblue">
					<td style="width:80;"><cf_get_lang no='835.Okul Türü'></td>
					<td style="width:185;"><cf_get_lang no='520.Okul Adı'></td>
					<td style="width:10;">&nbsp;</td>
					<td style="width:70;"><cf_get_lang no='838.Başl Yılı'></td>
					<td style="width:70;"><cf_get_lang no='839.Bitiş Yılı'></td>
					<td style="width:65;"><cf_get_lang no='836.Not Ort'>.</td>
					<td style="width:100;"><cf_get_lang_main no='583.Bölüm'></td>
					<td><input name="record_numb_edu" id="record_numb_edu" type="hidden" value="0"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_add_edu_info&ctrl_edu=0','medium');" title="<cf_get_lang no ='889.Eğitim Bilgisi Ekle'>"><img src="/images/plus_list.gif" alt="<cf_get_lang no ='889.Eğitim Bilgisi Ekle'>" border="0" /></a></td>
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
				</table>
				</cfif>
				</td>
			</tr>
			<!--- <tr>
				<td width="110"></td>
				<td class="txtboldblue">Okul Adı</td>
				<td class="txtboldblue">Giriş Yılı</td>
				<td class="txtboldblue">Mez Yılı</td>
				<td class="txtboldblue">Not Ort</td>
				<td class="txtboldblue">Bölüm</td>
			</tr>
			<tr>
				<td>İlköğretim</td>
				<td>
					<cfinput type="text" name="edu1" style="width:190px;" maxlength="75" value="#get_app.edu1#">
				</td>
				<td>
					<cfsavecontent variable="message">İlkokul Giriş tarihi girmelisiniz</cfsavecontent>
					<cfinput type="text" name="edu1_start" value="#get_app.edu1_start#" style="width:40px;" maxlength="4" validate="integer"  message="#message#" range="1900,">
				</td>
				<td>
					<cfsavecontent variable="message">İlkokul Bitiş tarihi girmelisiniz</cfsavecontent>
					<cfinput type="text" name="edu1_finish" value="#get_app.edu1_finish#" style="width:40px;" maxlength="4" validate="integer"  message="#message#" range="1900,">
				</td>
				<td>
					<cfinput type="text" name="edu1_rank" style="width:40px;" maxlength="75" value="#get_app.edu1_rank#">
				</td>
			</tr>
			<tr>
				<td>Ortaokul</td>
				<td>
					<cfinput type="text" name="edu2" style="width:190px;" maxlength="75" value="#get_app.edu2#">
				</td>
				<td>
					<cfsavecontent variable="message">Ortaokul Giriş Tarihi Girmelisiniz</cfsavecontent>
					<cfinput type="text" name="edu2_start" value="#get_app.edu2_start#" style="width:40px;" maxlength="4" validate="integer"  message="#message#" range="1900,">
				</td>
				<td>
					<cfsavecontent variable="message">Ortaokul Bitiş Tarihi Girmelisiniz</cfsavecontent>
					<cfinput type="text" name="edu2_finish" value="#get_app.edu2_finish#" style="width:40px;" maxlength="4" validate="integer"  message="#message#" range="1900,">
				</td>
				<td>
					<cfinput type="text" name="edu2_rank" style="width:40px;" maxlength="75" value="#get_app.edu2_rank#">
				</td>
			</tr>
			<tr>
				<td>Lise</td>
				<td>
					<cfinput type="text" name="edu3" style="width:190px;" maxlength="75" value="#get_app.edu3#">
				</td>
				<td>
					<cfsavecontent variable="message">Lise Giriş Tarihi Girmelisiniz</cfsavecontent>
					<cfinput type="text" name="edu3_start" value="#get_app.edu3_start#" style="width:40px;" maxlength="4"  validate="integer"  message="#message#" range="1900,">
				</td>
				<td>
					<cfsavecontent variable="message">Lise Bitiş Tarihi Girmelisiniz</cfsavecontent>
					<cfinput type="text" name="edu3_finish" value="#get_app.edu3_finish#" style="width:40px;" maxlength="4"  validate="integer"  message="#message#" range="1900,">
				</td>
				<td>
					<cfinput type="text" name="edu3_rank" style="width:40px;" maxlength="75" value="#get_app.edu3_rank#">
				</td>
				<td><select name="edu3_part" style="width:190px;">
						<option value="">Lise Bölümleri</option>
						<cfoutput query="get_high_school_part">
						<option value="#get_high_school_part.high_part_id#" <cfif get_high_school_part.high_part_id eq get_app.edu3_part>selected</cfif>>#get_high_school_part.high_part_name#</option>	
						</cfoutput>
					</select>
				</td>
			</tr>
			<tr>
				<td>Üniversite</td>
				<td><select name="edu4_id"  style="width:190px;">
						<option value="">Üniversiteler</option>
						<cfoutput query="get_unv">
						<option value="#get_unv.school_id#" <cfif get_app.edu4_id eq get_unv.school_id>selected</cfif>>#get_unv.school_name#</option>	
						</cfoutput>
					</select>
				</td>
				<td>
					<cfsavecontent variable="message">Üniversite Giriş Tarihi Girmelisiniz</cfsavecontent>
					<cfinput type="text" name="edu4_start" value="#get_app.edu4_start#" style="width:40px;" maxlength="4" validate="integer"  message="#message#" range="1900,">
				</td>
				<td>
					<cfinput type="text" name="edu4_finish" value="#get_app.edu4_finish#" style="width:40px;" maxlength="4" validate="integer"  message="#message#" range="1900,">
				</td>
				<td>
					<cfinput type="text" name="edu4_rank" style="width:40px;" maxlength="75" value="#get_app.edu4_rank#">
				</td>
				<td>
					<select name="edu4_part_id"  style="width:190px;">
						<option value="">Bölümler</option>
					<cfoutput query="get_school_part">
						<option value="#get_school_part.part_id#" <cfif get_app.edu4_part_id eq get_school_part.part_id>selected</cfif>>#get_school_part.part_name#</option>	
					</cfoutput>
					</select>
				</td>
			</tr>
			<tr>
				<td>Üniversite 2</td>
				<td>
					<select name="edu4_id_2"  style="width:190px;">
						<option value="">Seçiniz</option>
						<cfoutput query="get_unv">
						<option value="#get_unv.school_id#" <cfif get_app.edu4_id_2 eq get_unv.school_id>selected</cfif>>#get_unv.school_name#</option>	
						</cfoutput>
					</select>
				</td>
				<td>
					<cfsavecontent variable="message">Üniversite Giriş Tarihi Girmelisiniz</cfsavecontent>
					<cfinput type="text" name="edu4_start_2" value="#get_app.edu4_start_2#" style="width:40px;" maxlength="4" validate="integer"  message="#message#" range="1900,">
				</td>
				<td>
					<cfsavecontent variable="message">Üniversite Bitiş Tarihi Girmelisiniz</cfsavecontent>
					<cfinput value="#get_app.edu4_finish_2#" type="text" name="edu4_finish_2" style="width:40px;" maxlength="4" validate="integer"  message="#message#" range="1900,">
				</td>
				<td>
					<cfinput type="text" name="edu4_rank_2" style="width:40px;" maxlength="75" value="#get_app.edu4_rank_2#">
				</td>
				<td>
					<select name="edu4_part_id_2"  style="width:190px;">
						<option value="">Bölümler</option>
					<cfoutput query="get_school_part">
						<option value="#get_school_part.part_id#" <cfif get_app.edu4_part_id_2 eq get_school_part.part_id>selected</cfif>>#get_school_part.part_name#</option>	
					</cfoutput>
					</select>
				</td>
			</tr>
			<tr>
				<td>Diğer Üniversite</td>
				<td><cfinput type="text" name="edu4" style="width:190px;" maxlength="75" value="#get_app.edu4#"></td>
				<td colspan="3"></td>
				<td><cfinput type="text" name="edu4_part" style="width:190px;" maxlength="150" value="#get_app.edu4_part#"></td>
			</tr>
			<tr>
				<td>Yüksek Lisans</td>
				<td><cfinput type="text" name="edu5" style="width:190px;" maxlength="75" value="#get_app.edu5#"></td>
				<td><cfsavecontent variable="message">Yüksek Lisans Giriş Tarihi Girmelisini></cfsavecontent>
					<cfinput type="text" name="edu5_start" value="#get_app.edu5_start#" style="width:40px;" maxlength="4" validate="integer"  message="#message#" range="1900,">
				</td>
				<td><cfsavecontent variable="message">Yüksek Lisans Bitiş Tarihi Girmelisiniz</cfsavecontent>
					<cfinput type="text" name="edu5_finish" value="#get_app.edu5_finish#" style="width:40px;" maxlength="4" validate="integer"  message="#message#" range="1900,">
				</td>
				<td><cfinput type="text" name="edu5_rank" style="width:40px;" maxlength="75" value="#get_app.edu5_rank#"></td>
				<td><cfinput type="text" name="edu5_part" style="width:190px;" maxlength="100" value="#get_app.edu5_part#"></td>
			</tr>
			<tr>
				<td>Doktora</td>
				<td><cfinput type="text" name="edu7" value="#get_app.edu7#" style="width:190px;" maxlength="75"></td>
				<td><cfinput type="text" name="edu7_start" value="#get_app.edu7_start#" style="width:40px;" maxlength="4" validate="integer" message="#message#" range="1900,">
					<cfsavecontent variable="message">Okul Giriş yılı girmelisiniz</cfsavecontent>
				</td>
				<td><cfinput type="text" name="edu7_finish" value="#get_app.edu7_finish#" style="width:40px;" maxlength="4" validate="integer" message="#message#" range="1900,">
					<cfsavecontent variable="message">Okul Mezuniyet yılı girmelisiniz</cfsavecontent>
				</td>
				<td></td>
				<td><cfinput type="text" name="edu7_part" value="#get_app.edu7#" style="width:190px;" maxlength="75"></td>
			</tr> --->
		</table>
		<table>
			<tr>
				<td class="txtbold"><cf_get_lang_main no='1584.Dil'></td>
			</tr>
			<tr>
				<td width="110"></td>
				<td class="txtboldblue">><cf_get_lang_main no='1584.Dil'></td>
				<td class="txtboldblue"><cf_get_lang no='842.Konuşma'></td>
				<td class="txtboldblue"><cf_get_lang no='843.Anlama'></td>
				<td class="txtboldblue"><cf_get_lang no='844.Yazma'></td>
				<td class="txtboldblue"><cf_get_lang no='845.Öğrenildiği Yer'></td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='1584.Dil'> 1</td>
				<td>
					<select name="lang1" id="lang1" style="width:80px;">
						<option value=""><cf_get_lang_main no='322.Seçiniz'>
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
				<td><cf_get_lang_main no='1584.Dil'> 2</td>
				<td>
					<select name="lang2" id="lang2" style="width:80px;">
						<option value=""><cf_get_lang_main no='322.Seçiniz'><cfoutput query="get_languages">
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
				<td><cf_get_lang_main no='1584.Dil'> 3</td>
				<td>
					<select name="lang3" id="lang3" style="width:80px;">
					<option value=""><cf_get_lang_main no='322.Seçiniz'><cfoutput query="get_languages">
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
				<td><cf_get_lang_main no='1584.Dil'> 4</td>
				<td>
					<select name="lang4" id="lang4" style="width:80px;">
						<option value=""><cf_get_lang_main no='322.Seçiniz'><cfoutput query="get_languages">
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
				<td><cf_get_lang_main no='1584.Dil'> 5</td>
				<td>
					<select name="lang5" id="lang5" style="width:80px;">
						<option value=""><cf_get_lang_main no='322.Seçiniz'><cfoutput query="get_languages">
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
				<td class="txtbold" colspan="3"><cf_get_lang no='952.Kurs - Seminer ve Akademik Olmayan Programlar'></td>
			</tr>
			<tr>
				<td width="110"></td>
				<td class="txtboldblue"><cf_get_lang_main no='68.Konu'></td>
				<td class="txtboldblue"><cf_get_lang_main no='1043.Yıl'></td>
				<td class="txtboldblue"><cf_get_lang no='897.Yer'></td>
				<td class="txtboldblue"><cf_get_lang_main no='78.Gün'></td>
			</tr>
			<tr>
				<td height="26"><cf_get_lang_main no='68.Konu'></td>
				<td><cfinput type="text" name="kurs1" style="width:160px;" value="#get_app.KURS1#" maxlength="150"></td>
				<cfsavecontent variable="alert"><cf_get_lang no ='1163.Kurs 1 İçin Yılı Girin'></cfsavecontent>
				<td><cfinput type="text" name="kurs1_yil" style="width:75px;"  value="#dateformat(get_app.KURS1_YIL,'yyyy')#" maxlength="4" range="1900," validate="integer" message="!"></td>
				<td><cfinput type="text" name="kurs1_yer" style="width:160px;" value="#get_app.KURS1_YER#" maxlength="150"></td>
				<cfsavecontent variable="alert"><cf_get_lang no ='1164.Kurs 1 Gün Sayısını Girin'></cfsavecontent>
				<td><cfinput type="text" name="kurs1_gun" style="width:55px;" value="#get_app.KURS1_GUN#" validate="integer" message="#alert#"></td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='68.Konu'></td>  
				<td><cfinput type="text" name="kurs2" style="width:160px;" value="#get_app.KURS2#" maxlength="150"></td>
				<cfsavecontent variable="alert"><cf_get_lang no ='1165.Kurs 2 İçin Yılı Girin'></cfsavecontent>
				<td><cfinput type="text" name="kurs2_yil" style="width:75px;" value="#dateformat(get_app.KURS2_YIL,'yyyy')#" maxlength="4" range="1900," validate="integer" message="#alert#"></td>
				<td><cfinput type="text" name="kurs2_yer" style="width:160px;" value="#get_app.KURS2_YER#" maxlength="150"></td>
				<cfsavecontent variable="alert"><cf_get_lang no ='1166.Kurs 2 Gün Sayısını Girin'></cfsavecontent>
				<td><cfinput type="text" name="kurs2_gun" style="width:55px;" value="#get_app.KURS2_GUN#" validate="integer" message="#alert#"></td>
			</tr>  
			<tr>
				<td><cf_get_lang_main no='68.Konu'></td>  
				<td><cfinput type="text" name="kurs3" style="width:160px;" value="#get_app.KURS3#" maxlength="150"></td>
				<cfsavecontent variable="alert"><cf_get_lang no ='1167.Kurs3 İçin Yılı Girin'></cfsavecontent>
				<td><cfinput type="text" name="kurs3_yil" style="width:75px;" value="#dateformat(get_app.KURS3_YIL,'yyyy')#" maxlength="4" range="1900," validate="integer" message="#alert#"></td>
				<td><cfinput type="text" name="kurs3_yer" style="width:160px;" value="#get_app.KURS3_YER#" maxlength="150"></td>
				<cfsavecontent variable="alert"><cf_get_lang no ='1168.Kurs 3 Gün Sayısını Girin'></cfsavecontent>
				<td><cfinput type="text" name="kurs3_gun" style="width:55px;" value="#get_app.KURS3_GUN#" validate="integer" message="#alert#"></td>
			</tr>
			<tr>
				<td valign="top"><cf_get_lang no='847.Bilgisayar Bilgisi'></td>
				<td colspan="3">
					<textarea name="comp_exp" id="comp_exp" style="width:457px;height:60px;"><cfoutput>#get_app.COMP_EXP#</cfoutput></textarea>
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td colspan="4" class="color-row" STYLE="cursor:pointer;" onClick="gizle_goster(gizli2);"><strong><cf_get_lang no='850.Deneyim İş Tecrübesi'></strong></td>
	</tr>
	<tr STYLE="display:none;"  ID="gizli2">
		<td class="color-row" > 
			 <cfquery name="get_work_info" datasource="#DSN#">
				SELECT
					*
				FROM
					EMPLOYEES_APP_WORK_INFO
				WHERE
					<cfif isdefined("session.cp.userid")>
						EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">	
					<cfelse>
						EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
					</cfif>
			 </cfquery>			
			 <table id="table_work_info" border="0" cellpadding="0" cellspacing="1">
			 <input type="hidden" name="row_count" id="row_count" value="<cfoutput>#get_work_info.recordcount#</cfoutput>">
				<tr class="txtboldblue">
					<td><cf_get_lang no='851.Çalışılan Yer'></td>
					<td><cf_get_lang_main no='1085.Pozisyon'></td>
					<td><cf_get_lang_main no='167.Sektör'></td>
					<td><cf_get_lang_main no='159.Ünvan'></td>
					<td><cf_get_lang_main no='243.Başlama Tarihi'></td>
					<td><cf_get_lang_main no='288.Bitiş Tarihi'></td>
					<td><input name="record_num" id="record_num" type="hidden" value="0"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_upd_work_info&control=0</cfoutput>','medium');" title="<cf_get_lang no ='758.İş Tecrübesi Ekle'>"><img src="/images/button_gri.gif" alt="<cf_get_lang no ='758.İş Tecrübesi Ekle'>" border="0" /></a></td>
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
								SELECT SECTOR_CAT_ID,SECTOR_CAT FROM SETUP_SECTOR_CATS WHERE SECTOR_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#exp_sector_cat#">
							</cfquery>
						</cfif>
						<input type="text" name="exp_sector_cat_name#currentrow#" id="exp_sector_cat_name#currentrow#" class="boxtext" value="<cfif isdefined("exp_sector_cat") and len(exp_sector_cat) and get_sector_cat.recordcount>#get_sector_cat.sector_cat#</cfif>" readonly>
					</td>
					<td>
						<input type="hidden" name="exp_task_id#currentrow#" id="exp_task_id#currentrow#" class="boxtext" value="#exp_task_id#">
						<cfif isdefined("exp_task_id") and len(exp_task_id)>
							<cfquery name="get_exp_task_name" datasource="#dsn#">
								SELECT PARTNER_POSITION_ID,PARTNER_POSITION FROM SETUP_PARTNER_POSITION WHERE PARTNER_POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#exp_task_id#">
							</cfquery>
						</cfif>
						<input type="text" name="exp_task_name#currentrow#" id="exp_task_name#currentrow#" class="boxtext" value="<cfif isdefined("exp_task_id") and len(exp_task_id) and get_exp_task_name.recordcount>#get_exp_task_name.partner_position#</cfif>" readonly>
					</td>
					<td>
						<input type="text" name="exp_start#currentrow#" id="exp_start#currentrow#" class="boxtext" value="#dateformat(exp_start,'dd/mm/yyyy')#" readonly>
					</td>
					<td>
						<input type="text" name="exp_finish#currentrow#" id="exp_finish#currentrow#" class="boxtext" value="#dateformat(exp_finish,'dd/mm/yyyy')#" readonly>
					</td>
					<td><a href="javascript://" onClick="gonder_upd('#currentrow#');" title="<cf_get_lang no ='1162.İş Tecrübesi Güncelle'>"><img src="../../images/update_list.gif" alt="<cf_get_lang no ='1162.İş Tecrübesi Güncelle'>" border="0" /></a></td>
					<td><input  type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#"><a href="javascript://" onClick="sil('#currentrow#');" title="<cf_get_lang_main no ='51.Sil'>"><img  src="images/delete_list.gif" border="0" alt="<cf_get_lang_main no ='51.Sil'>" /></a></td>
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
		<!--- <table>
			<tr>
				<td valign="top" class="txtbold" colspan="4">Deneyim 1
					<cfif len(get_app.exp1_fark)>
						<cfoutput>: #round(get_app.exp1_fark/365)# yıl(#get_app.exp1_fark#)<cf_get_lang_main no='78.Gün'> </cfoutput>
					</cfif>
				</td>
			</tr>					
			<tr>
				<td width="115"><cf_get_lang_main no='162.Şirket'></td>
				<td width="175"><cfinput type="text" name="exp1" style="width:150px;" maxlength="50" value="#get_app.exp1#"></td>
				<td>Pozisyon</td>
				<td><cfinput type="text" name="exp1_position" style="width:150px;" maxlength="50" value="#get_app.exp1_position#">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='89.Başlangıç'></td>
				<td>
					<cfsavecontent variable="message">deneyim 1 başlangıç tarihi</cfsavecontent>
					<cfinput type="text" name="exp1_start" style="width:150px;" value="#dateformat(get_app.exp1_start,'dd/mm/yyyy')#" validate="eurodate" message="#message#">
					<cf_wrk_date_image date_field="exp1_start">
				</td>
				<td><cf_get_lang_main no='90.Bitiş'></td>
				<td>
					<cfsavecontent variable="message">Deneyim 1 Bitiş Tarihi girmelisiniz</cfsavecontent>
					<cfinput type="text" name="exp1_finish" style="width:150px;" value="#dateformat(get_app.exp1_finish,'dd/mm/yyyy')#" validate="eurodate" message="#message#">
					<cf_wrk_date_image date_field="exp1_finish">
				</td>
			</tr>
			<tr height="22">
				<td valign="top">Kod / Telefon</td>
				<td >
					<cfsavecontent variable="message">Telefon Kodu girmelisiniz</cfsavecontent>
					<cfinput value="#get_app.EXP1_TELCODE#" type="text" name="EXP1_TELCODE" style="width:48px;" validate="integer" message="#message#" maxlength="8">
					<cfsavecontent variable="message">Telefon girmelisiniz</cfsavecontent>
					<cfinput value="#get_app.EXP1_TEL#" type="text" name="EXP1_TEL" style="width:99px;" validate="integer" message="#message#" maxlength="10">
				</td>
				<td>Ücret (Son Ayın Net Ücreti)</td>
				<td>
					<cfinput type="text" name="exp1_salary" style="width:150px;" passThrough = "onkeyup=""return(FormatCurrency(this,event));""" value="#TLFormat(get_app.exp1_salary)#" class="moneybox">
				</td>
			</tr>
			<tr>
				<td>Ek Ödemeler</td>
				<td><input type="text" name="exp1_extra_salary" style="width:150px;" maxlength="75" value="<cfoutput>#get_app.exp1_extra_salary#</cfoutput>"></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			<tr height="22">
				<td valign="top">Ayrılma nedeni</td>
				<td colspan="3"><textarea name="exp1_reason" id="exp1_reason" style="width:457px;height:40px;" onChange="CheckLen(this,100)"><cfoutput>#get_app.exp1_reason#</cfoutput></textarea></td>
			</tr>
			<tr height="22">
				<td valign="top">Görev Sorumluluk ve Ek Açıklamalar</td>
				<td colspan="3"><textarea name="exp1_extra" id="exp1_extra" style="width:457px;height:40px;" onChange="CheckLen(this,100)"><cfoutput>#get_app.exp1_extra#</cfoutput></textarea></td>
			</tr>
			<tr>
				<td valign="top" class="txtbold" colspan="4">Deneyim 2
					<cfif len(get_app.exp2_fark)>
						<cfoutput>: #round(get_app.exp2_fark/365)# yıl(#get_app.exp2_fark#)<cf_get_lang_main no='78.Gün'></cfoutput>
					</cfif>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='162.Şirket'></td>
				<td width="175"><cfinput type="text" name="exp2" style="width:150px;" value="#get_app.exp2#" maxlength="50"></td>
				<td>Pozisyon</td>
				<td><cfinput type="text" name="exp2_position" style="width:150px;" value="#get_app.exp2_position#" maxlength="50"></td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='89.Başlangıç'></td>
				<td>
					<cfsavecontent variable="message">Deneyim 2 başlangıç tarihi</cfsavecontent>
					<cfinput type="text" name="exp2_start" style="width:150px;" value="#dateformat(get_app.exp2_start,'dd/mm/yyyy')#" validate="eurodate" message="#message#">
					<cf_wrk_date_image date_field="exp2_start">
				</td>
				<td><cf_get_lang_main no='90.Bitiş'></td>
				<td>
					<cfsavecontent variable="message">Deneyim 2 başlangıç tarihi</cfsavecontent>
					<cfinput type="text" name="exp2_finish" style="width:150px;" value="#dateformat(get_app.exp2_finish,'dd/mm/yyyy')#" validate="eurodate" message="#message#">
					<cf_wrk_date_image date_field="exp2_finish">
				</td>
			</tr>
			<tr>
				<td valign="top">Kod / Telefon</td>
				<td>
					<cfsavecontent variable="message">Telefon Kodu girmelisiniz</cfsavecontent>
					<cfinput value="#get_app.EXP2_TELCODE#" type="text" name="EXP2_TELCODE" style="width:48px;" validate="integer" message="#message#" maxlength="8">
					<cfsavecontent variable="message">Telefon girmelisiniz</cfsavecontent>
					<cfinput value="#get_app.EXP2_TEL#" type="text" name="EXP2_TEL" style="width:99px;" validate="integer" message="#message#" maxlength="10">
				</td>
				<td>Ücret (Son Ayın Net Ücreti)</td>
				<td>
					<cfinput type="text" name="exp2_salary" style="width:150px;" passThrough = "onkeyup=""return(FormatCurrency(this,event));""" value="#TLFormat(get_app.exp2_salary)#" class="moneybox">
				</td>
			</tr>
			<tr>
				<td>Ek Ödemeler</td>
				<td>
					<input type="text" name="exp2_extra_salary" style="width:150px;" maxlength="75" value="<cfoutput>#get_app.exp2_extra_salary#</cfoutput>">
				</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td valign="top">Ayrılma nedeni</td>
				<td colspan="3"><textarea name="exp2_reason" id="exp2_reason" style="width:457px;height:40px;" onChange="CheckLen(this,100)"><cfoutput>#get_app.exp2_reason#</cfoutput></textarea></td>
			</tr>
			<tr>
				<td valign="top">Görev Sorumluluk ve Ek Açıklamalar</td>
				<td colspan="3"><textarea name="exp2_extra" id="exp2_extra" style="width:457px;height:40px;" onChange="CheckLen(this,100)"><cfoutput>#get_app.exp2_extra#</cfoutput></textarea></td>
			</tr>
			<tr>
				<td valign="top" class="txtbold" colspan="4">Deneyim 3 
				<cfif len(get_app.exp3_fark)>
					<cfoutput>: #round(get_app.exp3_fark/365)# yıl (#get_app.exp3_fark#)<cf_get_lang_main no='78.Gün'></cfoutput>
				</cfif>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='162.Şirket'></td>
				<td width="175"><cfinput type="text" name="exp3" style="width:150px;" maxlength="50" value="#get_app.exp3#"></td>
				<td>Pozisyon</td>
				<td><cfinput type="text" name="exp3_position" style="width:150px;" maxlength="50" value="#get_app.exp3_position#"></td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='89.Başlangıç'></td>
				<td>
					<cfsavecontent variable="message">Deneyim 3 başlangıç tarihi girmelisiniz</cfsavecontent>
					<cfinput type="text" name="exp3_start" style="width:150px;" value="#dateformat(get_app.exp3_start,'dd/mm/yyyy')#" validate="eurodate" message="#message#">
					<cf_wrk_date_image date_field="exp3_start">
				</td>
				<td><cf_get_lang_main no='90.Bitiş'></td>
				<td>
					<cfsavecontent variable="message">Deneyim 3 bitiş tarihi girmelisiniz</cfsavecontent>
					<cfinput type="text" name="exp3_finish" style="width:150px;" value="#dateformat(get_app.exp3_finish,'dd/mm/yyyy')#" validate="eurodate" message="#message#">
					<cf_wrk_date_image date_field="exp3_finish">
				</td>
			</tr>
			<tr>
				<td>Kod / Telefon</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang no='22.Telefon Kodu girmelisiniz'></cfsavecontent>
					<cfinput value="#get_app.EXP3_TELCODE#" type="text" name="EXP3_TELCODE" style="width:48px;" validate="integer" message="#message#" maxlength="8">
					<cfsavecontent variable="message"><cf_get_lang no='21.Telefon girmelisiniz'></cfsavecontent>
					<cfinput value="#get_app.EXP3_TEL#" type="text" name="EXP3_TEL" style="width:99px;" validate="integer" message="#message#" maxlength="10">
				</td>
				<td>Ücret (Son Ayın Net Ücreti)</td>
				<td>
					<cfinput type="text" name="exp3_salary" style="width:150px;" passThrough = "onkeyup=""return(FormatCurrency(this,event));""" value="#TLFormat(get_app.exp3_salary)#" class="moneybox">
				</td>
			</tr>
			<tr>
				<td>Ek Ödemeler</td>
				<td>
					<input type="text" name="exp3_extra_salary" style="width:150px;" maxlength="75" value="<cfoutput>#get_app.exp3_extra_salary#</cfoutput>">
				</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>Ayrılma Nedeni</td>
				<td colspan="3"><textarea name="exp3_reason" id="exp3_reason" style="width:457px;height:40px;" onChange="CheckLen(this,100)"><cfoutput>#get_app.exp3_reason#</cfoutput></textarea></td>
			</tr>
				<td colspan="3"><textarea name="exp3_extra" id="exp3_extra" style="width:457px;height:40px;" onChange="CheckLen(this,100)"><cfoutput>#get_app.exp3_extra#</cfoutput></textarea></td>
			</tr>
			<tr>
				<td valign="top" class="txtbold" colspan="4">Deneyim 4
					<cfif len(get_app.exp4_fark)>
						<cfoutput>: #round(get_app.exp4_fark/365)# yıl(#get_app.exp4_fark#)<cf_get_lang_main no='78.Gün'></cfoutput>
					</cfif>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='162.Şirket'></td>
				<td width="175"><cfinput type="text" name="exp4" style="width:150px;" value="#get_app.exp4#" maxlength="50"></td>
				<td>Pozisyon</td>
				<td><cfinput type="text" name="exp4_position" style="width:150px;" value="#get_app.exp4_position#" maxlength="50"></td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='89.Başlangıç'></td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang no='724.deneyim 4 başlangıç tarihi'></cfsavecontent>
					<cfinput type="text" name="exp4_start" style="width:150px;" value="#dateformat(get_app.exp4_start,'dd/mm/yyyy')#" validate="eurodate" message="#message#">
					<cf_wrk_date_image date_field="exp4_start">
				</td>
				<td><cf_get_lang_main no='90.Bitiş'></td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang no='732.deneyim 4 başlangıç tarihi'></cfsavecontent>
					<cfinput type="text" name="exp4_finish" style="width:150px;" value="#dateformat(get_app.exp4_finish,'dd/mm/yyyy')#" validate="eurodate" message="#message#">
					<cf_wrk_date_image date_field="exp4_finish">
				</td>
			</tr>
			<tr>
				<td valign="top">Kod / Telefon</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang no='22.Telefon Kodu girmelisiniz'></cfsavecontent>
					<cfinput value="#get_app.EXP4_TELCODE#" type="text" name="EXP4_TELCODE" style="width:48px;" validate="integer" message="#message#" maxlength="8">
					<cfsavecontent variable="message"><cf_get_lang no='21.Telefon girmelisiniz'></cfsavecontent>
					<cfinput value="#get_app.EXP4_TEL#" type="text" name="EXP4_TEL" style="width:99px;" validate="integer" message="#message#" maxlength="10">
				</td>
				<td>Ücret (Son Ayın Net Ücreti)</td>
				<td>
					<cfinput type="text" name="exp4_salary" style="width:150px;" passThrough = "onkeyup=""return(FormatCurrency(this,event));""" value="#TLFormat(get_app.exp4_salary)#" class="moneybox">
				</td>
			</tr>
			<tr>
				<td>Ek Ödemeler</td>
				<td>
					<input type="text" name="exp4_extra_salary" style="width:150px;" maxlength="75" value="<cfoutput>#get_app.exp4_extra_salary#</cfoutput>">
				</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td valign="top">Ayrılma Nedeni</td>
				<td colspan="3"><textarea name="exp4_reason" id="exp4_reason" style="width:457px;height:40px;" onChange="CheckLen(this,100)"><cfoutput>#get_app.exp4_reason#</cfoutput></textarea></td>
			</tr>
			<tr>
				<td valign="top">Görev Sorumluluk ve Ek Açıklamalar</td>
				<td colspan="3"><textarea name="exp4_extra" id="exp4_extra" style="width:457px;height:40px;" onChange="CheckLen(this,100)"><cfoutput>#get_app.exp4_extra#</cfoutput></textarea></td>
			</tr>
		</table> --->
		</td>
	</tr>
	<!--- deneyim bitti --->
	<!---iletişim --->
	<tr>
		<td colspan="4" class="color-row" height="20" STYLE="cursor:pointer;" onClick="gizle_goster(gizli5);"><STRONG><cf_get_lang no='852.Referans Bilgileri'></STRONG></td>
	</tr>
	<tr STYLE="display:none;"  ID="gizli5">
		<td class="color-row">
		<table>
			<tr>
				<td class="txtbold" colspan="4"><cf_get_lang no='953.Grup İçi Referans'> 1 </td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='158.Ad Soyad'></td>
				<td><cfinput type="text" name="ref1_emp" style="width:150px;" maxlength="40" value="#get_app.ref1_emp#"></td>
				<td>&nbsp;</td>
				<td>&nbsp; </td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='162.Şirket'></td>
				<td><cfinput type="text" name="ref1_company_emp" style="width:150px;" maxlength="40" value="#get_app.ref1_company_emp#"></td>
				<td><cf_get_lang_main no='1085.Pozisyon'></td>
				<td><cfinput type="text" name="ref1_position_emp" style="width:150px;" maxlength="40" value="#get_app.ref1_position_emp#"></td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='87.Tel'></td>
				<td><cfsavecontent variable="message"><cf_get_lang no='22.Telefon girmelisiniz'></cfsavecontent>
					<cfinput value="#get_app.ref1_telcode_emp#" type="text" name="ref1_telcode_emp" style="width:40px;" maxlength="3" validate="integer" message="#message#" >
					<cfinput value="#get_app.ref1_tel_emp#" type="text" name="ref1_tel_emp" style="width:106px;" maxlength="7" validate="integer" message="#message#" >
				</td>
				<td><cf_get_lang_main no='16.webmail'></td>
				<td><cfinput type="text" name="ref1_email_emp" style="width:150px;" maxlength="40" value="#get_app.ref1_email_emp#"></td>
			</tr>
			<tr>
				<td class="txtbold" colspan="4"><cf_get_lang no='953.Grup İçi Referans'> 2 </td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='158.Ad Soyad'></td>
				<td><cfinput type="text" name="ref2_emp" style="width:150px;" maxlength="40" value="#get_app.ref2_emp#"></td>
				<td>&nbsp;</td>
				<td>&nbsp; </td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='162.Şirket'></td>
				<td><cfinput type="text" name="ref2_company_emp" style="width:150px;" maxlength="40" value="#get_app.ref2_company_emp#"></td>
				<td><cf_get_lang_main no='1085.Pozisyon'></td>
				<td><cfinput type="text" name="ref2_position_emp" style="width:150px;" maxlength="40" value="#get_app.ref2_position_emp#"></td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='87.Tel'></td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang no='22.Telefon girmelisiniz'></cfsavecontent>
					<cfinput value="#get_app.ref2_telcode_emp#" type="text" name="ref2_telcode_emp" style="width:40px;" maxlength="3" validate="integer" message="#message#" >
					<cfinput value="#get_app.ref2_tel_emp#" type="text" name="ref2_tel_emp" style="width:106px;" maxlength="7" validate="integer" message="#message#" >
				</td>
				<td><cf_get_lang_main no='16.webmail'></td>
				<td><cfinput type="text" name="ref2_email_emp" style="width:150px;" maxlength="40" value="#get_app.ref2_email_emp#"></td>
			</tr>
			
			<tr>
				<td class="txtbold" colspan="4"><cf_get_lang_main no='1372.Referans'> 1 </td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='158.Ad Soyad'></td>
				<td><cfinput type="text" name="ref1" style="width:150px;" maxlength="40" value="#get_app.ref1#"></td>
				<td>&nbsp;</td>
				<td>&nbsp; </td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='162.Şirket'></td>
				<td><cfinput type="text" name="ref1_company" style="width:150px;" maxlength="40" value="#get_app.ref1_company#"></td>
				<td><cf_get_lang_main no='1085.Pozisyon'></td>
				<td><cfinput type="text" name="ref1_position" style="width:150px;" maxlength="40" value="#get_app.ref1_position#"></td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='87.Tel'></td>
				<td>
					<cfsavecontent variable="message_kod"><cf_get_lang no='21.Lütfen Telefon Kodu Giriniz'></cfsavecontent>
				  	<cfsavecontent variable="message_tel"><cf_get_lang no='22.Lütfen Telefon Numarası Giriniz'></cfsavecontent>
					<cfinput value="#get_app.ref1_telcode#" type="text" name="ref1_telcode" style="width:40px;" maxlength="3" validate="integer" message="#message_kod#" >
					<cfinput value="#get_app.ref1_tel#" type="text" name="ref1_tel" style="width:106px;" maxlength="7" validate="integer" message="#message_tel#" >
				</td>
				<td><cf_get_lang_main no='16.webmail'></td>
				<td><cfinput type="text" name="ref1_email" style="width:150px;" maxlength="40" value="#get_app.ref1_email#"></td>
			</tr>
			<tr>
				<td class="txtbold" colspan="4"><cf_get_lang_main no='1372.Referans'> 2 </td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='158.Ad Soyad'></td>
				<td><cfinput type="text" name="ref2" style="width:150px;" maxlength="40" value="#get_app.ref2#"></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='162.Şirket'></td>
				<td><cfinput type="text" name="ref2_company" style="width:150px;" maxlength="40" value="#get_app.ref2_company#"></td>
				<td><cf_get_lang_main no='1085.Pozisyon'></td>
				<td><cfinput type="text" name="ref2_position" style="width:150px;" maxlength="40" value="#get_app.ref2_position#"></td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='87.Tel'></td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang no='22.Telefon girmelisiniz'></cfsavecontent>
					<cfinput value="#get_app.ref2_telcode#" type="text" name="ref2_telcode" style="width:40px;" maxlength="3" validate="integer" message="#message#" >
					<cfinput value="#get_app.ref2_tel#" type="text" name="ref2_tel" style="width:106px;" maxlength="7" validate="integer" message="#message#" >
				</td>
				<td><cf_get_lang_main no='16.webmail'></td>
				<td><cfinput type="text" name="ref2_email" style="width:150px;" maxlength="40" value="#get_app.ref2_email#"></td>
			</tr>
		</table>
		</td>
	</tr>
	<!---iletişim  bitti --->
	
	<!---hobi--->
	<tr>
		<td colspan="4" class="color-row" height="20" STYLE="cursor:pointer;" onClick="gizle_goster(gizli10);"><STRONG><cf_get_lang no='856.Özel İlgi Alanları'></STRONG></td>
	</tr>
	<tr STYLE="display:none;" id="gizli10">
		<td class="color-row">
		<table>

		<tr>
			<td valign="top"><cf_get_lang no='856.Özel İlgi Alanları'></td>
			<td valign="top" colspan="2"><textarea name="hobby" id="hobby" style="width:250px;" maxlength="150" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"><cfoutput>#get_app.hobby#</cfoutput></textarea></td>
		</tr>
		<tr>
			<td><cf_get_lang no='858.Üye Olunan Klüp Ve Dernekler'></td>
			<td><textarea name="club" id="club" style="width:250px;" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"><cfoutput>#get_app.club#</cfoutput></textarea></td>
		</tr>
		</table>
	</td>
</tr>
<!---//hobi--->
<!---çalışmak istediği dep--->
<td colspan="4" class="color-row" height="20" STYLE="cursor:pointer;" onClick="gizle_goster(gizli11);"><STRONG><cf_get_lang no='862.ÖÇalışmak İstediğiniz Birimler'></STRONG></td>
	<tr STYLE="display:none;"  ID="gizli11">
		<td class="color-row">
		<table>
		<tr><td colspan="2">&nbsp;&nbsp;(<cf_get_lang no='864.Öncelik sıralarını yandaki kutulara yazınız'>...)</td></tr>
		<cfquery name="get_cv_unit" datasource="#DSN#">
			SELECT * FROM SETUP_CV_UNIT
		</cfquery>
		<cfif get_cv_unit.recordcount>
		<tr class="txtbold">
		<cfquery name="get_app_unit" datasource="#dsn#"> 
			SELECT 
				UNIT_ID,UNIT_ROW
			FROM 
				EMPLOYEES_APP_UNIT
			WHERE 
				EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.empapp_id#">
		</cfquery>
		<cfset liste = valuelist(get_app_unit.unit_id)>
		<cfset liste_row = valuelist(get_app_unit.unit_row)>					
		<cfoutput query="get_cv_unit">
			<cfif get_cv_unit.currentrow-1 mod 3 eq 0><tr></cfif>
			  <td>#get_cv_unit.unit_name#</td>
			  <cfsavecontent variable="alert"><cf_get_lang no ='1161.Sayı Giriniz'></cfsavecontent>
			  <td><cfif listfind(liste,get_cv_unit.unit_id,',')>
				<cfinput type="text" name="unit#get_cv_unit.unit_id#" value="#ListGetAt(liste_row,listfind(liste,get_cv_unit.unit_id,','),',')#" validate="integer" maxlength="1" range="1,9" onchange="seviye_kontrol(this)" style="width:30px;" message="#alert#">
			  <cfelse>
				 <cfinput type="text" name="unit#get_cv_unit.unit_id#" value="" validate="integer" maxlength="1" range="1,9" onchange="seviye_kontrol(this)" style="width:30px;" message="#alert#">
			  </cfif>
			  </td>
			<cfif get_cv_unit.currentrow mod 3 eq 0 and get_cv_unit.currentrow-1 neq 0></tr></cfif>	  
		</cfoutput>
		<cfelse>
			<tr>
				<td><cf_get_lang no='865.Sisteme kayıtlı birim yok'>.</td>
			</tr>
		</cfif>
		</table>
	</td>
</tr>
<!---//calışmak istediği--->				
	<!--- araçlar --->
	<tr>
		<td colspan="4" class="color-row" height="20" STYLE="cursor:pointer;" onClick="gizle_goster(gizli6);"><STRONG><cf_get_lang no='870.Ek Bilgiler'></STRONG></td>
	</tr>
	<tr STYLE="display:none;"  ID="gizli6">
		<td width="280" valign="top" class="color-row">
		<table>
			<tr>
				<td height="25"><STRONG><cf_get_lang no='874.Çalışmak İstediğiniz Şehir'></STRONG></td>
			</tr>
			<tr>
				<td rowspan="2">
					<select name="prefered_city" id="prefered_city" style="width:150px;" multiple>
						<option value="" <cfif listfind(get_app.prefered_city,'',',') or not len(get_app.prefered_city)>selected</cfif>><cf_get_lang no='786.TÜM TÜRKİYE'></option>
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
						<td><strong><cf_get_lang no='875.Seyahat Edebilir misiniz'>?</strong></td>
						<td>
							<input type="radio" name="IS_TRIP" id="IS_TRIP" value="1" <cfif get_app.IS_TRIP IS 1>checked</cfif>><cf_get_lang_main no='83.Evet'>
							<input type="radio" name="IS_TRIP" id="IS_TRIP" value="0" <cfif get_app.IS_TRIP IS 0 OR get_app.IS_TRIP IS "">checked</cfif>><cf_get_lang_main no='84.Hayır'>
						</td>
					</tr>
					<tr>
						<td colspan="2"></td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td>&nbsp;<STRONG><cf_get_lang no='870.Eklemek İstedikleriniz'></STRONG></td>
			</tr>
			<tr>
				<td colspan="2">
					<textarea name="applicant_notes" id="applicant_notes" maxlength="300" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>"  style="width:500px;height:100px;"><cfoutput>#GET_APP.APPLICANT_NOTES#</cfoutput></textarea>
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<!--- araçlar bitti --->
	<tr>
		<td height="30" class="color-row" style="text-align:right;">
			<!---20050110 TolgaS Silme Kaldırıldı <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=#xfa.del#&empapp_id=#attributes.empapp_id#' add_function='kontrol()'> --->
			<cf_workcube_buttons is_upd='1' is_delete='0'>
		</td>
	</tr>
</table>
	</td>
	</tr>
</table>
</cfform>
<br/>
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
<br/>
<form name="form_edu_info" method="post" action="">
	<input type="hidden" name="edu_type_new" id="edu_type_new" value="">
	<input type="hidden" name="edu_id_new" id="edu_id_new" value="">
	<input type="hidden" name="edu_name_new" id="edu_name_new" value="">
	<input type="hidden" name="edu_start_new" id="edu_start_new" value="">
	<input type="hidden" name="edu_finish_new" id="edu_finish_new" value="">
	<input type="hidden" name="edu_rank_new" id="edu_rank_new" value="">
	<input type="hidden" name="edu_high_part_id_new" id="edu_high_part_id_new" value="">
	<input type="hidden" name="edu_part_id_new" id="edu_part_id_new" value="">
	<input type="hidden" name="edu_part_name_new" id="edu_part_name_new" value="">
	<input type="hidden" name="is_edu_continue_new" id="is_edu_continue_new" value="">
</form>
<script type="text/javascript">
document.employe_detail.upload_status.style.display = 'none';
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
		alert("<cf_get_lang no='31.İlk Olarak Ülke Seçiniz'> !");
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
		diger_nesne=eval("document.getElementById('unit"+j+"')");
		if(diger_nesne!=nesne)
		{
			if(nesne.value==diger_nesne.value && diger_nesne.value.length!=0)
			{
				alert("<cf_get_lang no='868.İki tane aynı seviye giremezsiniz'>!");
				diger_nesne.value='';
			}
		}
	}
}
/*function kontrol()
{
    var obj =  document.employe_detail.photo.value;
	if ((obj != "") && !((obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'jpg')   || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'gif') || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'png'))){
	     alert("Lütfen bir resim dosyası(gif,jpg veya png) giriniz!!");        
		return false;
	}
	document.employe_detail.exp1_salary.value = filterNum(document.employe_detail.exp1_salary.value);
	document.employe_detail.exp2_salary.value = filterNum(document.employe_detail.exp2_salary.value);
	document.employe_detail.exp3_salary.value = filterNum(document.employe_detail.exp3_salary.value);
	document.employe_detail.exp4_salary.value = filterNum(document.employe_detail.exp4_salary.value);
	return true;		
}*/

row_count=<cfoutput>#get_work_info.recordcount#</cfoutput>;
satir_say=0;
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
	form_work_info.action = '<cfoutput>#request.self#?fuseaction=objects2.popup_upd_work_info&my_count='+count+'&control=1</cfoutput>';
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
			var get_emp_cv_new = wrk_safe_query("obj2_get_emp_cv_new",'dsn',0,exp_sector_cat);
			/*if(get_emp_cv_new.recordcount)*/
				var exp_sector_cat_name = get_emp_cv_new.SECTOR_CAT;
		}
		else
			var exp_sector_cat_name = '';
		eval("employe_detail.exp_sector_cat_name"+my_count).value=exp_sector_cat_name;
		eval("employe_detail.exp_task_id"+my_count).value=exp_task_id;
		if(exp_task_id != '')
		{
			var get_emp_task_cv_new = wrk_safe_query("obj2_get_emp_task_cv_new",'dsn',0,exp_task_id);
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
		newRow = document.getElementById("table_work_info").insertRow(document.getElementById("table_work_info").rows.length);
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
			var get_emp_cv = wrk_safe_query("obj2_get_emp_cv_new",'dsn',0,exp_sector_cat);
			/*if(get_emp_cv.recordcount)*/
				var exp_sector_cat_name = get_emp_cv.SECTOR_CAT;
		}
		else
			var exp_sector_cat_name = '';
		new_Cell = new_Row.insertCell();
		new_Cell.innerHTML = '<input type="text" name="exp_sector_cat_name' + row_count + '" value="'+exp_sector_cat_name+'" class="boxtext" readonly>';
		if(exp_task_id != '')
		{
			var get_emp_task_cv = wrk_safe_query("obj2_get_emp_task_cv_new",'dsn',0,exp_task_id);
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
		new_Cell.innerHTML = '<a href="javascript://" onClick="gonder_upd('+row_count+');"><img src="/images/update_list.gif" alt="Güncelle" border="0" align="absbottom"></a>';
		new_Cell = new_Row.insertCell();
		new_Cell.innerHTML = '<input  type="hidden" value="1" name="row_kontrol' + row_count +'" ><a href="javascript://" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" alt="Sil" border="0"></a>';
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
	form_edu_info.action = '<cfoutput>#request.self#?fuseaction=objects2.popup_add_edu_info&count_edu='+count_new+'&ctrl_edu=1</cfoutput>';
	form_edu_info.submit();	
}

function gonder_edu(edu_type,ctrl_edu,count_edu,edu_id,edu_name,edu_start,edu_finish,edu_rank,edu_high_part_id,edu_part_id,edu_part_name,is_edu_continue)
{
	var edu_name_degisken = '';
	var edu_part_name_degisken = '';
	if(ctrl_edu == 1)
	{
		eval("employe_detail.edu_type"+count_edu).value=edu_type;
		if(eval("employe_detail.edu_type"+count_edu).value == 1)
			var edu_type_name = 'İlk Okul';
		else if(eval("employe_detail.edu_type"+count_edu).value == 2)
			var edu_type_name = 'Orta Okul';
		else if(eval("employe_detail.edu_type"+count_edu).value == 3)
			var edu_type_name = 'Lise';
		else if(eval("employe_detail.edu_type"+count_edu).value == 4)
			var edu_type_name = 'Üniversite';
		else if(eval("employe_detail.edu_type"+count_edu).value == 5)
			var edu_type_name = 'Yüksek Lisans';
		else if(eval("employe_detail.edu_type"+count_edu).value == 6)
			var edu_type_name = 'Doktora';
		else
			var edu_type_name = '';
		eval("employe_detail.edu_type_name"+count_edu).value=edu_type_name;
		eval("employe_detail.edu_id"+count_edu).value=edu_id;
		eval("employe_detail.edu_high_part_id"+count_edu).value=edu_high_part_id;
		eval("employe_detail.edu_part_id"+count_edu).value=edu_part_id;
		if(edu_id != '' && edu_id != -1)
		{
			var get_cv_edu_new = wrk_safe_query("obj2_get_cv_edu_new",'dsn',0,edu_id);
			if(get_cv_edu_new.recordcount)
				var edu_name_degisken = get_cv_edu_new.SCHOOL_NAME;
			eval("employe_detail.edu_name"+count_edu).value=edu_name_degisken;
		}
		else
		{
			eval("employe_detail.edu_name"+count_edu).value=edu_name;
		}
		eval("employe_detail.edu_start"+count_edu).value=edu_start;
		eval("employe_detail.edu_finish"+count_edu).value=edu_finish;
		eval("employe_detail.edu_rank"+count_edu).value=edu_rank;
		if(eval("employe_detail.edu_high_part_id"+count_edu) != undefined && eval("employe_detail.edu_high_part_id"+count_edu).value != '' && edu_high_part_id != -1 )
		{
			var get_cv_edu_high_part_id = wrk_safe_query("obj2_get_cv_edu_high_part_id",'dsn',0,edu_high_part_id);
			if(get_cv_edu_high_part_id.recordcount)
				var edu_part_name_degisken = get_cv_edu_high_part_id.HIGH_PART_NAME;
			eval("employe_detail.edu_part_name"+count_edu).value=edu_part_name_degisken;
		}
		else if(eval("employe_detail.edu_part_id"+count_edu) != undefined && eval("employe_detail.edu_part_id"+count_edu).value != '' && edu_part_id != -1)
		{
			var get_cv_edu_part_id = wrk_safe_query("obj2_get_cv_edu_part_id",'dsn',0,edu_part_id);
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
		new_Row_Edu.setAttribute("name","frm_rowt" + row_edu);
		new_Row_Edu.setAttribute("id","frm_rowt" + row_edu);		
		new_Row_Edu.setAttribute("NAME","frm_rowt" + row_edu);
		new_Row_Edu.setAttribute("ID","frm_rowt" + row_edu);
		if(edu_type == 1)
			var edu_type_name = 'İlk Okul';
		else if(edu_type == 2)
			var edu_type_name = 'Orta Okul';
		else if(edu_type == 3)
			var edu_type_name = 'Lise';
		else if(edu_type == 4)
			var edu_type_name = 'Üniversite';
		else if(edu_type == 5)
			var edu_type_name = 'Yüksek Lisans';
		else if(edu_type == 6)
			var edu_type_name = 'Doktora';
		else
			var edu_type_name = '';
		new_Cell_Edu = new_Row_Edu.insertCell();
		new_Cell_Edu.innerHTML = '<input style="width:75;" type="text" name="edu_type_name' + row_edu + '" value="'+ edu_type_name +'" class="boxtext" readonly>';
		if(edu_id != undefined && edu_id != '')
		{
			var get_cv_edu_new = wrk_safe_query("obj2_get_cv_edu_new",'dsn',0,edu_id);
			if(get_cv_edu_new.recordcount)
				var edu_name_degisken = get_cv_edu_new.SCHOOL_NAME;
			new_Cell_Edu = new_Row_Edu.insertCell();
			new_Cell_Edu.innerHTML = '<input  style="width:160;" type="text" name="edu_name' + row_edu + '" value="'+ edu_name_degisken +'" class="boxtext" readonly>';
		}
		else if(edu_name != undefined && edu_name != '')
		{
			new_Cell_Edu = new_Row_Edu.insertCell();
			new_Cell_Edu.innerHTML = '<input  style="width:160;" type="text" name="edu_name' + row_edu + '" value="'+ edu_name +'" class="boxtext" readonly>';
		}
		new_Cell_Edu = new_Row_Edu.insertCell();
		new_Cell_Edu.innerHTML = '<input style="width:10;" type="hidden" name="gizli' + row_edu + '" value="" class="boxtext" readonly>';
		new_Cell_Edu = new_Row_Edu.insertCell();
		new_Cell_Edu.innerHTML = '<input style="width:65;" type="text" name="edu_start' + row_edu + '" value="'+ edu_start +'" class="boxtext" readonly>';
		new_Cell_Edu = new_Row_Edu.insertCell();
		new_Cell_Edu.innerHTML = '<input style="width:65;" type="text" name="edu_finish' + row_edu + '" value="'+ edu_finish +'" class="boxtext" readonly>';
		new_Cell_Edu = new_Row_Edu.insertCell();
		new_Cell_Edu.innerHTML = '<input style="width:65;" type="text" name="edu_rank' + row_edu + '" value="'+ edu_rank +'" class="boxtext" readonly>';
		if(edu_high_part_id != undefined && edu_high_part_id != '' && edu_high_part_id != -1)
		{
			var get_cv_edu_high_part_id = wrk_safe_query("obj2_get_cv_edu_high_part_id",'dsn',0,edu_high_part_id);
			if(get_cv_edu_high_part_id.recordcount)
				var edu_part_name_degisken = get_cv_edu_high_part_id.HIGH_PART_NAME;
			new_Cell_Edu = new_Row_Edu.insertCell();
			new_Cell_Edu.innerHTML = '<input style="width:85;" type="text" name="edu_part_name' + row_edu + '" value="'+ edu_part_name_degisken +'" style="width:150px;" class="boxtext" readonly>';
		}
		else if(edu_part_id != undefined && edu_part_id != '' && edu_part_id != -1)
		{
			var get_cv_edu_part_id = wrk_safe_query("obj2_get_cv_edu_part_id",'dsn',0,edu_part_id);
			if(get_cv_edu_part_id.recordcount)
				var edu_part_name_degisken = get_cv_edu_part_id.PART_NAME;
			new_Cell_Edu = new_Row_Edu.insertCell();
			new_Cell_Edu.innerHTML = '<input style="width:85;" type="text" name="edu_part_name' + row_edu + '" value="'+ edu_part_name_degisken +'" style="width:150px;" class="boxtext" readonly>';
		}
		else
		{
		new_Cell_Edu = new_Row_Edu.insertCell();
		new_Cell_Edu.innerHTML = '<input style="width:85;" type="text" name="edu_part_name' + row_edu + '" value="'+ edu_part_name +'" class="boxtext" readonly>';
		}
		new_Cell_Edu = new_Row_Edu.insertCell();
		new_Cell_Edu.innerHTML = '<a href="javascript://" onClick="gonder_add_edu('+row_edu+');"><img src="/images/update_list.gif" alt="Güncelle" border="0" align="absbottom"></a>';
		new_Cell_Edu = new_Row_Edu.insertCell();
		new_Cell_Edu.innerHTML = '<input  type="hidden" value="1" name="row_kontrol_edu' + row_edu +'" ><a href="javascript://" onclick="sil_edu(' + row_edu + ');"><img  src="images/delete_list.gif" alt="Sil" border="0"></a>';
		new_Cell_Edu = new_Row_Edu.insertCell();
		new_Cell_Edu.innerHTML = '<input type="hidden" name="edu_type' + row_edu + '" value="'+ edu_type +'" class="boxtext" readonly>';
		new_Cell_Edu = new_Row_Edu.insertCell();
		new_Cell_Edu.innerHTML = '<input type="hidden" name="edu_id' + row_edu + '" value="'+ edu_id +'" class="boxtext" readonly>';
		new_Cell_Edu = new_Row_Edu.insertCell();
		new_Cell_Edu.innerHTML = '<input type="hidden" name="edu_high_part_id' + row_edu + '" value="'+ edu_high_part_id +'" style="width:150px;" class="boxtext" readonly>';
		new_Cell_Edu = new_Row_Edu.insertCell();
		new_Cell_Edu.innerHTML = '<input type="hidden" name="edu_part_id' + row_edu + '" value="'+ edu_part_id +'" style="width:150px;" class="boxtext" readonly>';
		new_Cell_Edu = new_Row_Edu.insertCell();
		new_Cell_Edu.innerHTML = '<input type="hidden" name="is_edu_continue' + row_edu + '" value="'+ is_edu_continue +'" style="width:150px;" class="boxtext" readonly>';
	}
}

/*Eğitim Bilgileri*/

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
</script>
