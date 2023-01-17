<cfif not isdefined("session.ww.userid")>
&nbsp;&nbsp;&nbsp;<cf_get_lang no='218.Üye Girişi Yapamalısınız'>!!
<cfexit method="exittemplate">
</cfif>
<cfinclude template="../query/get_consumer.cfm">
<cfif get_consumer.recordcount>
<cfinclude template="../query/get_mobilcat.cfm">
<cfinclude template="../query/get_consumer_cat.cfm">
<cfinclude template="../query/get_language.cfm">
<cfinclude template="../query/get_partner_positions.cfm">
<cfinclude template="../query/get_partner_departments.cfm">
<cfinclude template="../query/get_sector_cats.cfm">
<cfinclude template="../query/get_company_size_cats.cfm">
<cfinclude template="../query/get_vocation_type.cfm">
<cfinclude template="../query/get_country.cfm">
<cfinclude template="../query/get_edu_level.cfm">

<cfform name="upd_consumer" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=objects2.emptypopup_upd_consumer">
<table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td height="25" class="headbold" colspan="2"><cf_get_lang_main no='163.Üyelik Bilgilerim'>
		<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_upd_consumer_hobbies&consumer_id=#session.ww.userid#</cfoutput>','small');"><img src="/images/speak.gif" title="Hobi" border="0"></a></td>
	</tr>
</table>

 <!---kişisel--->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td>
 
<table width="98%" align="center" cellpadding="2" cellspacing="1" border="0" class="color-border">
	<tr class="color-row">
	<td>
		<table>
			<tr>
			  <td height="22" colspan="4"><STRONG><cf_get_lang_mains no ='719.Temel Bilgiler'></STRONG></td>
			</tr>
			<tr>
				<td width="110"><cf_get_lang_main no='219.Ad'>*</td>
				<td width="200">
					<cfsavecontent variable="message"><cf_get_lang no='219.Ad girmelisiniz'> !</cfsavecontent>
					<cfinput type="text" required="Yes" value="#get_consumer.consumer_name#" name="CONSUMER_name" style="width:150px;" maxlength="30" message="#message#">
				</td>
				<td width="100"><cf_get_lang_main no='16.E mail'></td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang no='238.E mail Girmelisiniz'>!</cfsavecontent>
					<cfinput type="text" name="CONSUMER_EMAIL" value="#get_consumer.consumer_email#" style="width:150px;" maxlength="40" required="yes" message="#message#">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='1314.Soyad'>*</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang no ='237.Soyad girmelisiniz'></cfsavecontent>
					<cfinput type="text" required="Yes" value="#get_consumer.consumer_surname#" name="consumer_surname" style="width:150px;" maxlength="30" message="#message#">
				</td>
				<td><cf_get_lang_main no='1070.Mobil Tel'></td>
				<td>
					<select name="mobilcat_id" id="mobilcat_id" style="width:65px;">
					  <option value="0"><cf_get_lang_main no='322.Seçiniz'>
					  <cfoutput query="get_mobilcat">
						<option value="#mobilcat#"<cfif mobilcat eq get_consumer.mobil_code>selected</cfif>>#mobilcat#</cfoutput>
					</select>
					<cfsavecontent variable="alert"><cf_get_lang no ='19.Geçerli GSM No Girmelisiniz'></cfsavecontent>
					<cfinput maxlength="9" validate="integer" value="#get_consumer.mobiltel#" message="#alert#" type="text" name="MOBILTEL" style="width:81px;">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='1197.Üye Kategorisi'></td>
				<td>
				<select name="CONSUMER_CAT_ID" id="CONSUMER_CAT_ID" style="width:150px;">
				  <cfoutput query="get_consumer_cat">
				  	<option value="#CONSCAT_ID#" <cfif conscat_id eq get_consumer.consumer_cat_id>selected</cfif>>#conscat#
				  </cfoutput>
				</select>
				</td>
				<td><cf_get_lang no='226.Ev Tel'></td>
				<td>
				  <cfsavecontent variable="message_kod"><cf_get_lang no='21.Lütfen Telefon Kodu Giriniz'></cfsavecontent>
				  <cfsavecontent variable="message_tel"><cf_get_lang no='22.Lütfen Telefon Numarası Giriniz'></cfsavecontent>
				  <cfinput type="text" name="home_telcode" value="#get_consumer.consumer_hometelcode#" maxlength="5" validate="integer" message="#message_kod#" style="width:65px;">
				  <cfinput type="text" name="home_tel" value="#get_consumer.consumer_hometel#" maxlength="9" validate="integer" message="#message_tel#" style="width:81px;">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='139.Kullanıcı Adı'></td>
				<td><cfinput type="text" name="consumer_username" value="#get_consumer.consumer_username#" maxlength="20" style="width:150px;"></td>
				<td><cf_get_lang no='227.İş Tel'></td>
				<td><cfsavecontent variable="message_kod"><cf_get_lang no='21.Lütfen Telefon Kodu Giriniz'></cfsavecontent>
					<cfsavecontent variable="message_tel"><cf_get_lang no='22.Lütfen Telefon Numarası Giriniz'></cfsavecontent>
					<cfinput name="work_telcode"  value="#get_consumer.consumer_worktelcode#" validate="integer" message="#message_kod#" maxlength="5" style="width:48px;">
					<cfinput name="work_tel" type="text" value="#get_consumer.consumer_worktel#" validate="integer" message="#message_tel#" style="width:99px;" maxlength="9">
				</td>
			</tr>
			<tr>
				<td width="110"><cf_get_lang_main no='140.Şifre'></td>
				<td><cfinput type="Password" name="consumer_password" value="" maxlength="10" style="width:150px;"></td>
				<td><cf_get_lang_main no='667.İnternet'></td>
				<td><input  type="text" name="homepage" id="homepage" value="<cfoutput>#get_consumer.homepage#</cfoutput>" maxlength="50" style="width:150px;"></td>
			</tr>
		</table>
	</td>
</tr>
<!--- Kisisel Bilgileri --->
<tr class="color-row">
	<td height="20" STYLE="cursor:pointer;" onClick="gizle_goster(gizli1);"><strong><cf_get_lang no ='197.Kişisel Bilgiler'></strong></td>
</tr>
<tr STYLE="display:none;" ID="gizli1">
	<td class="color-row">
		<table>
			<tr>
				<td width="110"><cf_get_lang_main no='378.Doğum Yeri'></td>
				<td width="200"><input type="text" name="birthplace" id="birthplace" style="width:150px;" value="<cfoutput>#get_consumer.birthplace#</cfoutput>" maxlength="30"></td>
				<td width="100"><cf_get_lang no='205.Eğitim Durumu'></td>
				<td><select name="education_level" id="education_level" style="width:150px;">
				  <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
				  <cfoutput query="get_edu_level">
					<option value="#edu_level_id#" <cfif get_consumer.education_id eq edu_level_id> selected</cfif>>#education_name#</option>
				  </cfoutput>
				  </select>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='1315.Doğum Tarihi'></td>
				<td><cfsavecontent variable="message"><cf_get_lang no='299.Doğum Tarihi Girmelisiniz'> !</cfsavecontent>
				  <cfinput validate="eurodate" message="#message#" type="text" name="birthdate" value="#dateformat(get_consumer.birthdate,'dd/mm/yyyy')#" style="width:150px;">
				  <cf_wrk_date_image date_field="birthdate">
	  			</td>
				<td><cf_get_lang_main no='1584.Dil'></td>
				<td><select name="language_id" id="language_id"  style="width:150px;">
					  <cfoutput query="get_language">
					  	<option value="#language_id#">#language_set#
					  </cfoutput>
					</select>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='352.Cinsiyet'></td>
				<td>
					<select name="sex" id="sex" style="width:150px;">
						<option value="1"<cfif get_consumer.sex eq 1> selected</cfif>><cf_get_lang_main no='1547.Erkek'>
						<option value="0"<cfif get_consumer.sex eq 0> selected</cfif>><cf_get_lang_main no='1546.Kadin'>
					</select>
				</td>
				<td><cf_get_lang_main no='613.TC Kimlik No'></td>
				<td><input type="text" name="tc_identy_no" id="tc_identy_no" value="<cfoutput>#get_consumer.tc_identy_no#</cfoutput>" maxlength="50" style="width:150px;"></td>
			</tr>
			<tr>
				<td><cf_get_lang no='201.Evlilik Durumu'></td>
				<td><input type="checkbox" name="married" id="married" value="checkbox" <cfif get_consumer.married eq 1>checked</cfif>>&nbsp;<cf_get_lang no ='209.Evli'></td>
				<td><cf_get_lang no ='202.Uyruğu'>'></td>
				<td>
				  <select name="nationality" id="nationality" style="width:150px;">
				  <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
				  <cfoutput query="get_country">
					<option value="#country_id#" <cfif get_country.country_id eq get_consumer.nationality>selected</cfif>>#country_name#</option>
				  </cfoutput>
				  </select>
				</td>
			</tr>
			<tr>  	
				<td><cf_get_lang no='206.Çocuk Sayısı'></td>
				<td><cfsavecontent variable="message"><cf_get_lang no ='817.Çocuk Sayısı Girmelisiniz'> !</cfsavecontent>
				  <cfinput type="text" name="child" value="#get_consumer.child#" validate="integer" message="#message#" maxlength="2" style="width:150px;">
				</td>
				<td><cf_get_lang no='207.Fotoğraf'></td>
				<td><input type="file" name="picture" id="picture" style="width:150px;"></td>
			</tr>
		</table>
	</td>
</tr>
<!--- kişisel bitti--->
<!--- İş Meslek Bilgileri --->
<tr class="color-row">
	<td height="20" STYLE="cursor:pointer;" onClick="gizle_goster(gizli2);"><strong><cf_get_lang no='217.İş Meslek Bilgileri'></strong></td>
</tr>
<tr STYLE="display:none;" ID="gizli2">	
	<td class="color-row">
		<table>
			<tr>
				<td width="110"><cf_get_lang_main no='162.Şirket'></td>
				<td width="200"><cfinput type="text" name="company"  value="#get_consumer.company#" style="width:150px;"></td>
				<td width="100"><cf_get_lang_main no='167.Sektör'></td>
				<td> <select name="sector_cat_id" id="sector_cat_id" style="width:150px;"  size="1">
					  <cfoutput query="get_sector_cats">
						<option value="#sector_cat_id#" <cfif sector_cat_id eq get_consumer.sector_cat_id>selected</cfif>>#sector_cat#</option>
					  </cfoutput>
					</select>
				</td>
			</tr>
			<tr>
			  <td><cf_get_lang_main no='159.Ünvan'></td>
			  <td><cfinput type="text" name="title" value="#get_consumer.title#" style="width:150px;"></td>
			  <td><cf_get_lang no='212.Meslek'></td>
			  <td><select name="vocation_type" id="vocation_type" style="width:150px;">
				  <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
				  <cfoutput query="get_vocation_type">
					<option value="#vocation_type_id#" <cfif get_consumer.vocation_type_id eq vocation_type_id> selected</cfif>>#vocation_type#</option>
				  </cfoutput>
				  </select>
			  </td>
			</tr>
			<tr>
				 <td><cf_get_lang_main no='161.Görev'></td>
				 <td><select name="mission" id="mission" style="width:150px;">
				   <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
				   <cfoutput query="get_partner_positions">
					 <option value="#partner_position_id#" <cfif get_consumer.mission eq partner_position_id>selected</cfif>>#partner_position#</option>
				   </cfoutput>
				 </select></td>
				<td><cf_get_lang no='16.Şirket Büyüklük'></td>
				<td>
				<select name="company_size_cat_id" id="company_size_cat_id" style="width:150px;" size="1">
				  <cfoutput query="get_company_size_cats">
					<option value="#company_size_cat_id#" <cfif company_size_cat_id eq get_consumer.company_size_cat_id>selected</cfif>>#company_size_cat#</option>
				  </cfoutput>
				</select>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='160.Departman'></td>
				<td><select name="department" id="department" style="width:150px;">
					  <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
					  <cfoutput query="get_partner_departments">
						<option value="#partner_department_id#" <cfif get_consumer.department eq partner_department_id>selected</cfif>>#partner_department#</option>
					  </cfoutput>
					</select>
				</td>
				<td></td>
				<td></td>
			</tr>
		</table>
	</td>
</tr>
<!--- İs Meslek Bilgileri  --->
<tr class="color-row">
	<td height="20" STYLE="cursor:pointer;" onClick="gizle_goster(gizli3);"><strong><cf_get_lang no='213.Ev Adresi'></strong></td>
</tr>
<tr STYLE="display:none;" ID="gizli3">
	<td valign="top" class="color-row">
		<table>
			<tr>
				<td><cf_get_lang_main no='1311.Adres'></td>
				<td rowspan="3">
					<textarea name="home_address" id="home_address" style="width:150px;height:75px;"><cfoutput>#get_consumer.homeaddress#</cfoutput></textarea>
				</td>
				<td><cf_get_lang_main no='807.Ülke'></td>
				<td>
				  <select name="home_country" id="home_country" onChange="remove_adress('1','home');" style="width:150px;">
					<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
					<cfoutput query="get_country">
					  <option value="#get_country.country_id#" <cfif get_consumer.home_country_id eq get_country.country_id>selected</cfif>>#get_country.country_name#</option>
					</cfoutput>
				  </select>	
				 </td>
			</tr>
			<tr>
				<td></td>
				<td><cf_get_lang_main no='559.Şehir'></td>
				<td>
				  <cfif len(get_consumer.home_city_id)>
					<cfquery name="GET_CITY_HOME" datasource="#DSN#">
						SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.home_city_id#">
					</cfquery>				  
					<input type="hidden" name="home_city_id" id="home_city_id" value="<cfoutput>#get_consumer.home_city_id#</cfoutput>">
					<input type="text" name="home_city" id="home_city" value="<cfoutput>#get_city_home.city_name#</cfoutput>" readonly style="width:150px;">
				  <cfelse>
					<input type="hidden" name="home_city_id" id="home_city_id" value="">
					<input type="text" name="home_city" id="home_city" value="" readonly style="width:150px;">				  
				  </cfif>
				  <a href="javascript://" onClick="pencere_ac_city('home');"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a></td>
			</tr>
			
			<tr>
				<td></td>
				<td><cf_get_lang_main no='1226.İlçe'></td>
				<td>
				  <cfif len(get_consumer.home_county_id)>
					<cfquery name="GET_COUNTY_HOME" datasource="#DSN#">
						SELECT * FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.home_county_id#">
					</cfquery>		
					<input type="hidden" name="home_county_id" id="home_county_id" value="<cfoutput>#get_consumer.home_county_id#</cfoutput>">
					<input type="text" name="home_county" id="home_county" value="<cfoutput>#get_county_home.county_name#</cfoutput>" readonly style="width:150px;">				  
				  <cfelse>
					<input type="hidden" name="home_county_id" id="home_county_id" value="">
					<input type="text" name="home_county" id="home_county" value="" readonly style="width:150px;">
				  </cfif>
				  <a href="javascript://" onClick="pencere_ac('home');"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>	</td>
			</tr>
			<tr>
				<td width="100"><cf_get_lang_main no='60.Posta Kodu'></td>
				<td><input type="text" name="home_postcode" id="home_postcode" maxlength="15" value="<cfoutput>#get_consumer.homepostcode#</cfoutput>" style="width:150px;"></td>
				<td><cf_get_lang_main no='720.Semt'></td>
				<td><input type="text" name="home_semt" id="home_semt" value="<cfoutput>#get_consumer.homesemt#</cfoutput>" maxlength="30" style="width:150px;"></td>				
			</tr>
		</table>
	</td>
</tr>
<tr class="color-row">
	<td height="20" STYLE="cursor:pointer;" onClick="gizle_goster(gizli4);"><strong><cf_get_lang no='216.İş Adresi'></strong></td>
</tr>
<tr STYLE="display:none;" ID="gizli4">
	<td valign="top" class="color-row">
		<table>
			<tr>
				<td><cf_get_lang_main no='1311.Adres'></td>
				<td rowspan="3">
					<textarea name="work_address" id="work_address" style="width:150px;height:75px;"><cfoutput>#get_consumer.workaddress#</cfoutput></textarea>
				</td>
				<td><cf_get_lang_main no='807.Ülke'></td>
				<td>
				  <select name="work_country" id="work_country" onChange="remove_adress('2','work');" style="width:150px;">
					<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
					<cfoutput query="get_country">
					  <option value="#get_country.country_id#" <cfif get_consumer.home_country_id eq get_country.country_id>selected</cfif>>#get_country.country_name#</option>
					</cfoutput>
				  </select></td>
			</tr>
			<tr>
				<td></td>
				<td><cf_get_lang_main no='559.Şehir'></td>
				<td>
				  <cfif len(get_consumer.work_city_id)>
					<cfquery name="GET_CITY_WORK" datasource="#DSN#">
						SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_city_id#">
					</cfquery>				  
					<input type="hidden" name="work_city_id" id="work_city_id" value="<cfoutput>#get_consumer.work_city_id#</cfoutput>">
					<input type="text" name="work_city" id="work_city" value="<cfoutput>#get_city_work.city_name#</cfoutput>" readonly style="width:150px;">
				  <cfelse>
					<input type="hidden" name="work_city_id" id="work_city_id" value="">
					<input type="text" name="work_city" id="work_city" value="" readonly style="width:150px;">				  
				  </cfif>
				  <a href="javascript://" onClick="pencere_ac_city('work');"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>  </td>
			</tr>
			<tr>
				<td></td>
				<td><cf_get_lang_main no='1226.İlçe'></td>
				<td>
				  <cfif len(get_consumer.work_county_id)>
					<cfquery name="GET_COUNTY_WORK" datasource="#DSN#">
						SELECT * FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_county_id#">
					</cfquery>		
					<input type="hidden" name="work_county_id" id="work_county_id" value="<cfoutput>#get_consumer.work_county_id#</cfoutput>">
					<input type="text" name="work_county" id="work_county" value="<cfoutput>#get_county_work.county_name#</cfoutput>" readonly style="width:150px;">
				  <cfelse>
					<input type="hidden" name="work_county_id" id="work_county_id" value="">
					<input type="text" name="work_county" id="work_county" value="" readonly style="width:150px;">
				  </cfif>
				  <a href="javascript://" onClick="pencere_ac('work');"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>	</td>
			</tr>
			<tr>
				<td width="100"><cf_get_lang_main no='60.Posta Kodu'></td>
				<td><input type="text" name="work_postcode" id="work_postcode" maxlength="15" value="<cfoutput>#get_consumer.workpostcode#</cfoutput>" style="width:150px;"></td>
				<td><cf_get_lang_main no='720.Semt'></td>
				<td><input type="text" name="work_semt" id="work_semt" value="<cfoutput>#get_consumer.worksemt#</cfoutput>" maxlength="30" style="width:150px;"></td>	
			</tr>
		</table>
	</td>
</tr>
<tr class="color-row">
	<td height="20" STYLE="cursor:pointer;" onClick="gizle_goster(gizli5);"><strong><cf_get_lang no='220.Fatura Adresi'></strong></td>
</tr>
<tr STYLE="display:none;" ID="gizli5">
	<td valign="top" class="color-row">
		<table>
			<tr>
				<td><cf_get_lang_main no='1350.Vergi Dairesi'></td>
				<td><input type="text" name="tax_office" id="tax_office" value="<cfoutput>#get_consumer.tax_office#</cfoutput>" maxlength="50" style="width:150px;"></td>
				<td><cf_get_lang_main no='340.Vergi No'></td>
				<td><cfsavecontent variable="message"><cf_get_lang no ='508.Vergi No Girmelisiniz'> !</cfsavecontent>
				  <cfinput type="text" name="tax_no" value="#get_consumer.tax_no#" validate="integer" message="#message#" maxlength="30" style="width:150px;">	</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='1311.Adres'></td>
				<td rowspan="3">
					<textarea name="tax_address" id="tax_address" style="width:150px;height:75px;"><cfoutput>#get_consumer.tax_adress#</cfoutput></textarea>
				</td>
				<td><cf_get_lang_main no='807.Ülke'></td>
				<td>
				  <select name="tax_country" id="tax_country" onChange="remove_adress('1','tax');" style="width:150px;">
					<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
					<cfoutput query="get_country">
					  <option value="#get_country.country_id#" <cfif get_consumer.tax_country_id eq get_country.country_id>selected</cfif>>#get_country.country_name#</option>
					</cfoutput>
				  </select>
				</td>
			</tr>
			<tr>
				<td></td>
				<td><cf_get_lang_main no='559.Şehir'></td>
				<td>
				  <cfif len(get_consumer.tax_city_id)>
					<cfquery name="GET_CITY_TAX" datasource="#DSN#">
						SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.tax_city_id#">
					</cfquery>				  
					<input type="hidden" name="tax_city_id" id="tax_city_id" value="<cfoutput>#get_consumer.tax_city_id#</cfoutput>">
					<input type="text" name="tax_city" id="tax_city" value="<cfoutput>#get_city_tax.city_name#</cfoutput>" readonly style="width:150px;">
				  <cfelse>
					<input type="hidden" name="tax_city_id" id="tax_city_id" value="">
					<input type="text" name="tax_city" id="tax_city" value="" readonly style="width:150px;">				  
				  </cfif>
				  <a href="javascript://" onClick="pencere_ac_city('tax');"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>	</td>
			<tr>
				<td></td>
				<td><cf_get_lang_main no='1226.İlçe'></td>
				<td>
				 <cfif len(get_consumer.tax_county_id)>
					<cfquery name="GET_COUNTY_TAX" datasource="#DSN#">
						SELECT * FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.tax_county_id#">
					</cfquery>		
					<input type="hidden" name="tax_county_id" id="tax_county_id" value="<cfoutput>#get_consumer.tax_county_id#</cfoutput>">
					<input type="text" name="tax_county" id="tax_county" value="<cfoutput>#get_county_tax.county_name#</cfoutput>" readonly style="width:150px;">				  
				  <cfelse>
					<input type="hidden" name="tax_county_id" id="tax_county_id" value="">
					<input type="text" name="tax_county" id="tax_county" value="" readonly style="width:150px;">
				  </cfif>
				  <a href="javascript://" onClick="pencere_ac('tax');"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>	</td>
			</tr>
			<tr>
				<td width="100"><cf_get_lang_main no='60.Posta Kodu'></td>
				<td><input type="text" name="tax_postcode" id="tax_postcode" maxlength="15" value="<cfoutput>#get_consumer.tax_postcode#</cfoutput>" style="width:150px;"></td>
				<td><cf_get_lang_main no='720.Semt'></td>
				<td><cfinput type="text" name="tax_semt" value="#get_consumer.tax_semt#" maxlength="30" style="width:150px;"></td>
			</tr>
		</table>
	</td>
</tr>
	<tr class="color-row">
		<td height="35"  style="text-align:right;">
			<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
		</td>
	</tr>
</table>
</cfform>
</td>
<td valign="top" width="200">
	<table cellspacing="1" cellpadding="2" width="98%" border="0" class="color-border">
		<tr class="color-header" height="22">
			<td class="form-title"><cf_get_lang no='207.Fotoğraf'></td>
		</tr>
		<tr class="color-header">
			<td class="color-row" valign="middle" align="center">
				<cfif len(get_consumer.picture)>
					<cfoutput>
					<!--- <img src="/documents/member/consumer/#get_consumer.PICTURE#" width="120" height="160"> --->
					<cf_get_server_file output_file="member/consumer/#get_consumer.picture#" output_server="#get_consumer.picture_server_id#" output_type="0" alt="#getLang('main',668)#" title="#getLang('main',668)#">
				    </cfoutput>
				<cfelse>
				<cf_get_lang_main no='716.Fotoğraf Girilmemiş'>
				</cfif>
			</td>
		</tr>
	</table>
<br/>
</td>
	</tr>
</table>
<script type="text/javascript">
function remove_adress(parametre,type)
{
	if(type=='work')
	{
		if(parametre==1)
		{
			document.upd_consumer.work_city_id.value = '';
			document.upd_consumer.work_city.value = '';
			document.upd_consumer.work_county_id.value = '';
			document.upd_consumer.work_county.value = '';
			document.upd_consumer.work_telcode.value = '';
			//document.upd_consumer.work_faxcode.value = '';			
		}
		else
		{
			document.upd_consumer.work_county_id.value = '';
			document.upd_consumer.work_county.value = '';
		}
	
	}	
	else if(type=='home')
	{
		if(parametre==1)
		{
			document.upd_consumer.home_city_id.value = '';
			document.upd_consumer.home_city.value = '';
			document.upd_consumer.home_county_id.value = '';
			document.upd_consumer.home_county.value = '';
			document.upd_consumer.home_telcode.value = '';		
		}
		else
		{
			document.upd_consumer.home_county_id.value = '';
			document.upd_consumer.home_county.value = '';
		}
	}
	else if(type=='tax')
	{
		if(parametre==1)
		{
			document.upd_consumer.tax_city_id.value = '';
			document.upd_consumer.tax_city.value = '';
			document.upd_consumer.tax_county_id.value = '';
			document.upd_consumer.tax_county.value = '';
		}
		else
		{
			document.upd_consumer.tax_county_id.value = '';
			document.upd_consumer.tax_county.value = '';
		}
	}	
}
function pencere_ac_city(type)
{
	if(type=='work')
	{
		x = document.upd_consumer.work_country.selectedIndex;
		if (document.upd_consumer.work_country[x].value == "")
		{
			alert("<cf_get_lang no='31.İlk Olarak Ülke Seçiniz'> (<cf_get_lang_main no='1033.Iş'>) ! ");
		}	
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_dsp_city&field_id=upd_consumer.work_city_id&field_name=upd_consumer.work_city&field_phone_code=upd_consumer.work_telcode&country_id=' + document.upd_consumer.work_country.value,'small');
		}
		return remove_adress('','work');
	}
	else if(type=='home')
	{
		x = document.upd_consumer.home_country.selectedIndex;
		if (document.upd_consumer.home_country[x].value == "")
		{
			alert("<cf_get_lang no='31.İlk Olarak Ülke Seçiniz'> (<cf_get_lang no ='1345.Ev'>) ! ");
		}	
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_dsp_city&field_id=upd_consumer.home_city_id&field_name=upd_consumer.home_city&field_phone_code=upd_consumer.home_telcode&country_id=' + document.upd_consumer.home_country.value,'small');
		}
		return remove_adress('','home');		
	}
	else if(type=='tax')
	{
		x = document.upd_consumer.tax_country.selectedIndex;
		if (document.upd_consumer.tax_country[x].value == "")
		{
			alert("<cf_get_lang no='31.İlk Olarak Ülke Seçiniz'> (<cf_get_lang_main no='29.Fatura'>) ! ");
		}	
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_dsp_city&field_id=upd_consumer.tax_city_id&field_name=upd_consumer.tax_city&country_id=' + document.upd_consumer.tax_country.value,'small');
		}
		return remove_adress('','tax');
	}
}
function pencere_ac(type)
{
	if(type=='work')
	{
		x = document.upd_consumer.work_country.selectedIndex;
		if (document.upd_consumer.work_country[x].value == "")
		{
			alert("<cf_get_lang no='31.İlk Olarak Ülke Seçiniz'>(<cf_get_lang_main no='1033.Iş'>) !");
		}	
		else if(document.upd_consumer.work_city_id.value == "")
		{
			alert("<cf_get_lang no='32.İl Seçiniz'> (<cf_get_lang_main no='1033.Iş'>) !");
		}
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_dsp_county&field_id=upd_consumer.work_county_id&field_name=upd_consumer.work_county&city_id=' + document.upd_consumer.work_city_id.value,'small');
			return remove_adress('','work');
		}
	}
	else if(type=='home')
	{
		x = document.upd_consumer.home_country.selectedIndex;
		if (document.upd_consumer.home_country[x].value == "")
		{
			alert("<cf_get_lang no='31.İlk Olarak Ülke Seçiniz'> (<cf_get_lang no ='1345.Ev'>) !");
		}	
		else if(document.upd_consumer.home_city_id.value == "")
		{
			alert("<cf_get_lang no='32.İl Seçiniz'> (<cf_get_lang no ='1345.Ev'>) !");
		}
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_dsp_county&field_id=upd_consumer.home_county_id&field_name=upd_consumer.home_county&city_id=' + document.upd_consumer.home_city_id.value,'small');
			return remove_adress('','home');
		}
	}
	else if(type=='tax')
	{
		x = document.upd_consumer.tax_country.selectedIndex;
		if (document.upd_consumer.tax_country[x].value == "")
		{
			alert("<cf_get_lang no='31.İlk Olarak Ülke Seçiniz'> (<cf_get_lang_main no='29.Fatura'>) !");
		}	
		else if(document.upd_consumer.tax_city_id.value == "")
		{
			alert("<cf_get_lang no='32.İl Seçiniz'> (<cf_get_lang_main no='29.Fatura'>) !");
		}
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_dsp_county&field_id=upd_consumer.tax_county_id&field_name=upd_consumer.tax_county&city_id=' + document.upd_consumer.tax_city_id.value,'small');
			return remove_adress('','tax');
		}
	}	
}

function kontrol()
{
	/*x = document.upd_consumer.consumer_cat_id.selectedIndex;
	if (document.upd_consumer.consumer_cat_id[x].value == "")
	{ 
		alert ("Üye Kategorisi Seçmediniz !");
		return false;
	}*/
	
	y = (75 - document.upd_consumer.work_address.value.length);
	if ( y < 0 )
	{ 
		alert ("<cf_get_lang no='216.İş Adresi'><cf_get_lang_main no='798.Alanindaki Fazla Karakter Sayisi'>"+ ((-1) * y));
		return false;
	}
	
	z = (200 - document.upd_consumer.home_address.value.length);
	if ( z < 0 )
	{ 
		alert ("<cf_get_lang no='213.Ev Adresi'><cf_get_lang_main no='798.Alanindaki Fazla Karakter Sayisi'>"+ ((-1) * z));
		return false;
	}

	v = (200 - document.upd_consumer.tax_address.value.length);
	if ( v < 0 )
	{ 
		alert ("<cf_get_lang no='220.Fatura Adresi'><cf_get_lang_main no='798.Alanindaki Fazla Karakter Sayisi'>"+ ((-1) * v));
		return false;
	}
	

	if(confirm("<cf_get_lang no='486.Girdiğiniz Bilgileri Kaydetmek Üzeresiniz Lütfen Değişiklikleri Onaylayın'> !")) return true; else return false;
}
</script>
<cfelse>
	<cfset hata  = 10>
	<cfinclude template="../../dsp_hata.cfm">
</cfif>
