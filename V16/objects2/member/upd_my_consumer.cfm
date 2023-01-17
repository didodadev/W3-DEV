<cfquery name="GET_CONSUMER" datasource="#DSN#">
	SELECT 
		CONSUMER_NAME,
		CONSUMER_EMAIL,
		PICTURE,
		CONSUMER_SURNAME,
		MOBIL_CODE,
		MOBILTEL,
		CONSUMER_HOMETELCODE,
		CONSUMER_HOMETEL,
		CONSUMER_USERNAME,
		CONSUMER_WORKTELCODE,
		CONSUMER_WORKTEL,
		HOMEPAGE,
		BIRTHPLACE,
		EDUCATION_ID,
		BIRTHDATE,
		SEX,
		TC_IDENTY_NO,
		MARRIED,
		NATIONALITY,
		CHILD,
		PICTURE_SERVER_ID,
		COMPANY,
		CONSUMER_CAT_ID,
		SECTOR_CAT_ID,
		TITLE,
		VOCATION_TYPE_ID,
		MISSION,
		COMPANY_SIZE_CAT_ID,
		DEPARTMENT,
		HOME_DISTRICT_ID,
		HOMEADDRESS,
		HOME_COUNTRY_ID,
		HOME_CITY_ID,
		HOME_COUNTY_ID ,
		HOMESEMT,
		HOMEPOSTCODE,
		WORK_DISTRICT_ID,
		WORKADDRESS,
		WORK_COUNTRY_ID,
		WORK_CITY_ID ,
		WORK_COUNTY_ID,
		WORKSEMT,
		WORKPOSTCODE,
		TAX_DISTRICT_ID,
		TAX_OFFICE,
		TAX_NO,
		TAX_ADRESS,
		TAX_COUNTRY_ID,
		TAX_CITY_ID,
		TAX_COUNTY_ID,
		TAX_SEMT,
		TAX_POSTCODE
	FROM 
		CONSUMER 
	WHERE 
		CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
		<cfif isdefined('session.pp')>
			HIERARCHY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
		<cfelse>
			HIERARCHY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">
		</cfif>
</cfquery>
<cfif not get_consumer.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='499.Yetki Dışı Erişim Yapamazsınız'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfif get_consumer.recordcount>
	<cfinclude template="../query/get_company_cat.cfm">
	<cfinclude template="../query/get_im.cfm">
	<cfinclude template="../query/get_mobilcat.cfm">
	<cfinclude template="../query/get_identycard_cat.cfm">
	<cfinclude template="../query/get_consumer_cat.cfm">
	<cfinclude template="../query/get_language.cfm">
	<cfinclude template="../query/get_company_size.cfm">
	<cfinclude template="../query/get_company_sector.cfm">
	<cfinclude template="../query/get_partner_positions.cfm">
	<cfinclude template="../query/get_partner_departments.cfm">
	<cfinclude template="../query/get_sector_cats.cfm">
	<cfinclude template="../query/get_company_size_cats.cfm">
	<cfinclude template="../query/get_vocation_type.cfm">
	<cfinclude template="../query/get_country.cfm">
	<cfinclude template="../query/get_edu_level.cfm">
	<cfif not isdefined("attributes.is_detail_adres")>
		<cfset attributes.is_detail_adres = 0>
	</cfif>
	<cfif not isdefined("attributes.is_residence_select")>
		<cfset attributes.is_residence_select = 0>
	</cfif>
	<cfform name="upd_consumer" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=objects2.emptypopup_upd_my_consumer">
	<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
	<table width="100%" align="center" cellpadding="2" cellspacing="1" border="0">
		<tr class="color-row">
			<td>
			<table>
				<tr>
					<td width="100"><cf_get_lang_main no='219.Ad'>*</td>
					<td width="200">
						<cfsavecontent variable="message"><cf_get_lang no='219.Ad girmelisiniz'> !</cfsavecontent>
						<cfinput type="text" name="consumer_name" id="consumer_name" required="Yes" value="#get_consumer.consumer_name#" style="width:150px;" maxlength="30">
					</td>
					<td width="100"><cf_get_lang_main no='16.E-mail'> <cfif isdefined('attributes.is_email') and attributes.is_email eq 1>*</cfif></td>
					<td>
						<cfif isdefined('attributes.is_email') and attributes.is_email eq 1>
							<cfsavecontent variable="message"><cf_get_lang no='238.E-mail Girmelisiniz'>!</cfsavecontent>
							<cfinput type="text" name="consumer_email" id="consumer_email" value="#get_consumer.consumer_email#" style="width:150px;" maxlength="40" required="yes">
						<cfelse>
							<cfinput type="text" name="consumer_email" id="consumer_email" value="#get_consumer.consumer_email#" style="width:150px;" maxlength="40" validate="email">
						</cfif>
					</td>
					<td valign="top" rowspan="5">
						<cfif len(get_consumer.picture)>
							<cfoutput>
							<cf_get_server_file output_file="member/consumer/#get_consumer.picture#" output_server="#get_consumer.picture_server_id#" output_type="0" image_width="120" image_height="130" alt="#getLang('main',668)#" title="#getLang('main',668)#">
							</cfoutput>
						<cfelse>
							<cf_get_lang_main no='1083.Fotoğraf Girilmemiş'>
						</cfif>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='1314.Soyad'>*</td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang no ='237.Soyad girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="consumer_surname" id="consumer_surname" required="Yes" value="#get_consumer.consumer_surname#" style="width:150px;" maxlength="30">
					</td>
					<td><cf_get_lang_main no='1070.Mobil Tel'></td>
					<td>
						<select name="mobilcat_id" id="mobilcat_id" style="width:65px;">
						  	<option value="0"><cf_get_lang_main no='322.Seçiniz'>
						  	<cfoutput query="get_mobilcat">
								<option value="#mobilcat#"<cfif mobilcat eq get_consumer.mobil_code>selected</cfif>>#mobilcat#
							</cfoutput>
						</select>
						<cfsavecontent variable="alrt"><cf_get_lang no ='19.Geçerli GSM Numarası Giriniz!'></cfsavecontent>
						<cfinput type="text" name="mobiltel" id="mobiltel" maxlength="9" validate="integer" value="#get_consumer.mobiltel#" message="#alrt#" onKeyUp="isNumber(this);" style="width:81px;">
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='1197.Üye Kategorisi'></td>
					<td>
						<select name="consumer_cat_id" id="consumer_cat_id" style="width:150px;">
						  	<cfoutput query="get_consumer_cat">
								<option value="#conscat_id#" <cfif conscat_id eq get_consumer.consumer_cat_id>selected</cfif>>#conscat#
						  	</cfoutput>
						</select>
					</td>
					<td><cf_get_lang no='226.Ev Tel'></td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang_main no ='1173.Kod'>/<cf_get_lang_main no='87.Telefon'></cfsavecontent>
					  	<cfinput type="text" name="home_telcode" id="home_telcode" value="#get_consumer.consumer_hometelcode#" maxlength="5" validate="integer" message="#message#" onKeyUp="isNumber(this);" style="width:65px;">
					  	<cfinput type="text" name="home_tel" id="home_tel" value="#get_consumer.consumer_hometel#" maxlength="9" validate="integer" message="#message#" onKeyUp="isNumber(this);" style="width:81px;">
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='139.Kullanıcı Adı'></td>
					<td><cfinput type="text" name="consumer_username" id="consumer_username" value="#get_consumer.consumer_username#" maxlength="20" style="width:150px;"></td>
					<td><cf_get_lang no='227.İş Tel'></td>
					<td>
						<cfsavecontent variable="alert"><cf_get_lang no ='21.Geçerli Telefon Kodu Girmelisiniz'></cfsavecontent>
						<cfsavecontent variable="alert2"><cf_get_lang no ='22.Geçerli Telefon No Girmelisiniz'></cfsavecontent>
						<cfinput name="work_telcode" id="work_telcode"  value="#get_consumer.consumer_worktelcode#" validate="integer" message="#alert#" maxlength="5" onKeyUp="isNumber(this);" style="width:65px;">
						<cfinput name="work_tel" id="work_tel" type="text" value="#get_consumer.consumer_worktel#" validate="integer" message="#alert2#" maxlength="9" onKeyUp="isNumber(this);" style="width:81px;">
					</td>
				</tr>
				<tr>
					<td width="110"><cf_get_lang_main no='140.Şifre'></td>
					<td><cfinput type="Password" name="consumer_password" id="consumer_password" value="" maxlength="10" style="width:150px;"></td>
					<td><cf_get_lang_main no='667.İnternet'></td>
					<td><input  type="text" name="homepage" id="homepage" value="<cfoutput>#get_consumer.homepage#</cfoutput>" maxlength="50" style="width:150px;"></td>
				</tr>
			</table>
			</td>
		</tr>
		<!--- Kisisel Bilgileri --->
		<tr class="color-row">
			<td height="20" style="cursor:pointer;" onclick="gizle_goster(gizli1);"><strong> >> <cf_get_lang no='197.Kişisel Bilgiler'></strong></td>
		</tr>
		<tr style="display:none;" id="gizli1">
			<td class="color-row">
				<table>
					<tr>
						<td width="110"><cf_get_lang_main no='378.Doğum Yeri'></td>
						<td width="200"><input type="text" name="birthplace" id="birthplace" style="width:150px;" value="<cfoutput>#get_consumer.birthplace#</cfoutput>" maxlength="30"></td>
						<td width="100"><cf_get_lang no='205.Eğitim Durumu'></td>
						<td>
							<select name="education_level" id="education_level" style="width:150px;">
						  	<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
						  	<cfoutput query="get_edu_level">
								<option value="#edu_level_id#" <cfif get_consumer.education_id eq edu_level_id> selected</cfif>>#education_name#</option>
						  	</cfoutput>
						  	</select>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang_main no='1315.Doğum Tarih'></td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang no='299.Doğum Tarihi Girmelisiniz'> !</cfsavecontent>
						  	<cfinput type="text" name="birthdate" id="birthdate" validate="eurodate" message="#message#" value="#dateformat(get_consumer.birthdate,'dd/mm/yyyy')#" style="width:150px;">
						  	<cf_wrk_date_image date_field="birthdate">
						</td>
						<td><cf_get_lang_main no='1584.Dil'></td>
						<td>
							<select name="language_id"  id="language_id"  style="width:150px;">
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
						<td><cf_get_lang_main no='613.TC Kimlik No'><cfif isdefined("attributes.is_tc_number") and attributes.is_tc_number> *</cfif></td>
						<td>
							<!--- BK 20100620 6 aya silinsin<input type="text" name="tc_identy_no" value="<cfoutput>#get_consumer.tc_identy_no#</cfoutput>" maxlength="50" style="width:150px;"> --->
							<cf_wrkTcNumber fieldId="tc_identity_no" tc_identity_number="#get_consumer.tc_identy_no#" tc_identity_required="#attributes.is_tc_number#" width_info='150'>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang no='201.Evlilik Durumu'></td>
						<td><input type="checkbox" name="married" id="married" value="checkbox" <cfif get_consumer.married eq 1>checked</cfif>>&nbsp;<cf_get_lang no='209.Evli'></td>
						<td><cf_get_lang no='202.Uyruğu'></td>
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
						<td>
							<cfsavecontent variable="message"><cf_get_lang no='817.Çocuk Sayısı Girmelisiniz'> !</cfsavecontent>
						  	<cfinput type="text" name="child" id="child" value="#get_consumer.child#" validate="integer" message="#message#" maxlength="2" style="width:150px;">
						</td>
						<td><cf_get_lang no='207.Fotoğraf'></td>
						<input type="Hidden" name="old_photo" id="old_photo" value="<cfoutput>#get_consumer.picture#</cfoutput>">
						<input type="Hidden" name="old_photo_server_id" id="old_photo_server_id" value="<cfoutput>#get_consumer.picture_server_id#</cfoutput>">
						<td><input type="file" name="picture" id="picture" style="width:150px;"></td>
					</tr>
				</table>
			</td>
		</tr>
		<!--- İş Meslek Bilgileri --->
		<tr class="color-row">
			<td height="20" style="cursor:pointer;" onclick="gizle_goster(gizli2);"><strong> >><cf_get_lang no ='1369.İş Meslek Bilgileri'> </strong></td>
		</tr>
		<tr style="display:none;" id="gizli2">	
			<td class="color-row">
				<table>
					<tr>
						<td width="110"><cf_get_lang_main no='162.Şirket'></td>
						<td width="200"><cfinput type="text" name="company" id="company"  value="#get_consumer.company#" style="width:150px;"></td>
						<td width="100"><cf_get_lang_main no='167.Sektör'></td>
						<td> 
							<select name="sector_cat_id" id="sector_cat_id" style="width:150px;"  size="1">
							<cfoutput query="get_sector_cats">
								<option value="#sector_cat_id#" <cfif sector_cat_id eq get_consumer.sector_cat_id>selected</cfif>>#sector_cat#</option>
							</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
					  	<td><cf_get_lang_main no='159.Ünvan'></td>
					  	<td><cfinput type="text" name="title" id="title" value="#get_consumer.title#" style="width:150px;"></td>
					  	<td><cf_get_lang no='212.Meslek'></td>
					  	<td>
					  		<select name="vocation_type" id="vocation_type" style="width:150px;">
							  	<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							  	<cfoutput query="get_vocation_type">
									<option value="#vocation_type_id#" <cfif get_consumer.vocation_type_id eq vocation_type_id> selected</cfif>>#vocation_type#</option>
							  	</cfoutput>
						  	</select>
					  	</td>
					</tr>
					<tr>
						<td><cf_get_lang_main no='161.Görev'></td>
						<td>
							<select name="mission" id="mission" style="width:150px;">
						   	<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
						   	<cfoutput query="get_partner_positions">
								<option value="#partner_position_id#" <cfif get_consumer.mission eq partner_position_id>selected</cfif>>#partner_position#</option>
						   	</cfoutput>
						 	</select>
						</td>
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
						<td>
							<select name="department" id="department" style="width:150px;">
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
		<!--- Adres bilgileri --->
		<tr class="color-row">
			<td height="20" style="cursor:pointer;" onclick="gizle_goster(gizli3);"><strong> >> <cf_get_lang no='213.Ev Adresi'></strong></td>
		</tr>
		<cfif len(get_consumer.home_district_id)>
			<cfquery name="GET_HOME_DIST" datasource="#DSN#">
				SELECT DISTRICT_NAME FROM SETUP_DISTRICT WHERE DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.home_district_id#">
			</cfquery>
			<cfset home_dis = '#get_home_dist.district_name# '>
		<cfelse>
			<cfset home_dis = ''>
		</cfif>
		<tr style="display:none;" id="gizli3">
			<td valign="top" class="color-row">
				<table>
					<tr>
						<cfif attributes.is_detail_adres eq 0>
							<td width="110"><cf_get_lang_main no='1311.Adres'></td>
							<td rowspan="3" width="200">
								<textarea name="home_address" id="home_address" style="width:150px;height:75px;"><cfoutput>#home_dis##get_consumer.homeaddress#</cfoutput></textarea>
							</td>
						</cfif>
						<td width="100"><cf_get_lang_main no='807.Ülke'></td>
						<td width="200"><select name="home_country" id="home_country" style="width:150px;" onchange="LoadCity(this.value,'home_city_id','home_county_id',0<cfif attributes.is_detail_adres eq 1 and attributes.is_residence_select eq 1>,'home_district_id'</cfif>)">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfoutput query="get_country">
									<option value="#country_id#" <cfif get_consumer.home_country_id eq country_id>selected</cfif>>#country_name#</option>
								</cfoutput>
							</select>				
						</td>
						<cfif attributes.is_detail_adres eq 1>
							<td><cf_get_lang_main no='1323.Mahalle'></td>
							<td>
								<cfif attributes.is_residence_select eq 0>
									<input type="text" name="home_district" id="home_district" style="width:150px;" value="<cfif len(get_consumer.home_district)><cfoutput>#get_consumer.home_district#</cfoutput><cfelse><cfoutput>#home_dis#</cfoutput></cfif>">
								<cfelse>
									 <select style="width:150px;" name="home_district_id" id="home_district_id">
										<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
										<cfif len(get_consumer.home_district_id)>
											<cfquery name="GET_DISTRICT_NAME" datasource="#DSN#">
												SELECT DISTRICT_ID, DISTRICT_NAME FROM SETUP_DISTRICT WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.home_county_id#">
											</cfquery>										
											<cfoutput query="get_district_name">
												<option value="#district_id#" <cfif get_consumer.home_district_id eq district_id>selected</cfif>>#district_name#</option>
											</cfoutput>
										</cfif>
									</select>
								</cfif>
							</td>
						</cfif>
					</tr>
					<tr>
					  	<cfif attributes.is_detail_adres eq 0>
							<td></td>
					  	</cfif>
						<td><cf_get_lang_main no='559.Şehir'><cfif isdefined("attributes.is_city_county_required") and attributes.is_city_county_required eq 1>*</cfif></td>
						<td>
							<select style="width:150px;" name="home_city_id" id="home_city_id" onchange="LoadCounty(this.value,'home_county_id','home_telcode','0'<cfif attributes.is_detail_adres eq 1 and attributes.is_residence_select eq 1>,'home_district_id'</cfif>);">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfif len(get_consumer.home_city_id)>
									<cfquery name="GET_CITY_HOME" datasource="#DSN#">
										SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.home_country_id#">
									</cfquery>
									<cfoutput query="get_city_home">
										<option value="#city_id#" <cfif get_consumer.home_city_id eq city_id>selected</cfif>>#city_name#</option>	
									</cfoutput>
								</cfif>
							</select>
						</td>
						<cfif attributes.is_detail_adres eq 1>
							 <td><cf_get_lang no ='1335.Cadde'></td>
							 <td><input type="text" name="home_main_street" id="home_main_street" style="width:150px;" value="<cfoutput>#get_consumer.home_main_street#</cfoutput>"></td>
						</cfif>
					</tr>
					<tr>
						<cfif attributes.is_detail_adres eq 0>
							<td></td>
						</cfif>
						<td><cf_get_lang_main no='1226.İlçe'><cfif isdefined("attributes.is_city_county_required") and attributes.is_city_county_required eq 1>*</cfif></td>
						<td>
							<select style="width:150px;" name="home_county_id" id="home_county_id" <cfif attributes.is_detail_adres eq 1 and attributes.is_residence_select eq 1>onChange="LoadDistrict(this.value,'home_district_id');"</cfif>>
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfif len(get_consumer.home_county_id)>
									<cfquery name="GET_COUNTY_HOME" datasource="#DSN#">
										SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.home_city_id#">
									</cfquery>										
									<cfoutput query="get_county_home">
										<option value="#county_id#" <cfif get_consumer.home_county_id eq county_id>selected</cfif>>#county_name#</option>
									</cfoutput>
								</cfif>
							</select>
						</td>
						<cfif attributes.is_detail_adres eq 1>
							<td><cf_get_lang no ='1334.Sokak'></td>
							<td><input type="text" name="home_street" id="home_street" style="width:150px;" value="<cfoutput>#get_consumer.home_street#</cfoutput>"></td>
						</cfif>
					</tr>
					<tr>
						<td><cf_get_lang_main no='720.Semt'></td>
						<td><input type="text" name="home_semt" id="home_semt" value="<cfoutput>#get_consumer.homesemt#</cfoutput>" maxlength="30" style="width:150px;"></td>				
						<cfif attributes.is_detail_adres eq 0>
							<td><cf_get_lang_main no='60.Posta Kodu'></td>
							<td><input type="text" name="home_postcode" id="home_postcode" maxlength="15" value="<cfoutput>#get_consumer.homepostcode#</cfoutput>" onkeyup="isNumber(this);" style="width:150px;"></td>
						</cfif>
						<cfif attributes.is_detail_adres eq 1>
							<td valign="top"><cf_get_lang no ='1628.Adres Detay'></td>
							<td><textarea name="home_door_no" id="home_door_no" style="width:150px;" maxlength="200"><cfoutput>#get_consumer.home_door_no#</cfoutput></textarea></td>
						</cfif>
					</tr>
					<cfif attributes.is_detail_adres eq 1>
						<tr>
							<td><cf_get_lang_main no='60.Posta Kodu'></td>
							<td><input type="text" name="home_postcode" id="home_postcode" maxlength="15" value="<cfoutput>#get_consumer.homepostcode#</cfoutput>" onkeyup="isNumber(this);" style="width:150px;"></td>
						</tr>
					</cfif>
				</table>
			</td>
		</tr>
		<tr class="color-row">
			<td height="20" style="cursor:pointer;" onclick="gizle_goster(gizli4);"><strong> >><cf_get_lang no ='216.İş Adresi'> </strong></td>
		</tr>
		<cfif len(get_consumer.work_district_id)>
			<cfquery name="GET_WORK_DIST" datasource="#DSN#">
				SELECT DISTRICT_NAME FROM SETUP_DISTRICT WHERE DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_district_id#">
			</cfquery>
			<cfset work_dis = '#get_work_dist.district_name# '>
		<cfelse>
			<cfset work_dis = ''>
		</cfif>
		<tr style="display:none;" id="gizli4">
			<td valign="top" class="color-row">
				<table>
					<tr>
						<cfif attributes.is_detail_adres eq 0>
							<td width="110"><cf_get_lang_main no='1311.Adres'></td>
							<td rowspan="3" width="200">
								<textarea name="work_address" id="work_address" style="width:150px;height:75px;"><cfoutput>#work_dis##get_consumer.workaddress#</cfoutput></textarea>
							</td>
						</cfif>
						<td width="100"><cf_get_lang_main no='807.Ülke'></td>
						<td><select name="work_country" id="work_country" style="width:150px;" onchange="LoadCity(this.value,'work_city_id','work_county_id',0<cfif attributes.is_detail_adres eq 1 and attributes.is_residence_select eq 1>,'work_district_id'</cfif>)">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfoutput query="get_country">
									<option value="#country_id#" <cfif get_consumer.work_country_id eq country_id>selected</cfif>>#country_name#</option>
								</cfoutput>
							</select>				
						</td>
						<cfif attributes.is_detail_adres eq 1>
							<td><cf_get_lang_main no='1323.Mahalle'></td>
							<td>
								<cfif attributes.is_residence_select eq 0>
									<input type="text" name="work_district" id="work_district" style="width:150px;" value="<cfif len(get_consumer.work_district)><cfoutput>#get_consumer.work_district#</cfoutput><cfelse><cfoutput>#work_dis#</cfoutput></cfif>">
								<cfelse>
									 <select style="width:150px;" name="work_district_id" id="work_district_id">
										<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
										<cfif len(get_consumer.work_district_id)>
											<cfquery name="GET_DISTRICT_NAME" datasource="#DSN#">
												SELECT DISTRICT_ID, DISTRICT_NAME FROM SETUP_DISTRICT WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_county_id#">
											</cfquery>										
											<cfoutput query="get_district_name">
												<option value="#district_id#" <cfif get_consumer.work_district_id eq district_id>selected</cfif>>#district_name#</option>
											</cfoutput>
										</cfif>
									</select>
								</cfif>
							</td>
						</cfif>
					</tr>
					<tr>
					  	<cfif attributes.is_detail_adres eq 0>
							<td></td>
					  	</cfif>
						<td><cf_get_lang_main no='559.Şehir'></td>
						<td>
							<select style="width:150px;" name="work_city_id" id="work_city_id" onchange="LoadCounty(this.value,'work_county_id','work_telcode','0'<cfif attributes.is_detail_adres eq 1 and attributes.is_residence_select eq 1>,'work_district_id'</cfif>);">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfif len(get_consumer.work_city_id)>
									<cfquery name="GET_CITY_WORK" datasource="#DSN#">
										SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_country_id#">
									</cfquery>
									<cfoutput query="get_city_work">
										<option value="#city_id#" <cfif get_consumer.work_city_id eq city_id>selected</cfif>>#city_name#</option>	
									</cfoutput>
								</cfif>
							</select>
						</td>
						<cfif attributes.is_detail_adres eq 1>
							 <td><cf_get_lang no ='1335.Cadde'></td>
							 <td><input type="text" name="work_main_street" id="work_main_street" style="width:150px;" value="<cfoutput>#get_consumer.work_main_street#</cfoutput>"></td>
						</cfif>
					</tr>
					<tr>
						<cfif attributes.is_detail_adres eq 0>
							<td></td>
						</cfif>
						<td><cf_get_lang_main no='1226.İlçe'></td>
						<td>
							<select style="width:150px;" name="work_county_id" id="work_county_id" <cfif attributes.is_detail_adres eq 1 and attributes.is_residence_select eq 1>onChange="LoadDistrict(this.value,'work_district_id');"</cfif>>
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfif len(get_consumer.work_county_id)>
									<cfquery name="GET_COUNTY_WORK" datasource="#DSN#">
										SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_city_id#">
									</cfquery>										
									<cfoutput query="get_county_work">
										<option value="#county_id#" <cfif get_consumer.work_county_id eq county_id>selected</cfif>>#county_name#</option>
									</cfoutput>
								</cfif>
							</select>
						</td>
						<cfif attributes.is_detail_adres eq 1>
							<td><cf_get_lang no ='1334.Sokak'></td>
							<td><input type="text" name="work_street" id="work_street" style="width:150px;" value="<cfoutput>#get_consumer.work_street#</cfoutput>"></td>
						</cfif>
					</tr>
					<tr>
						<td><cf_get_lang_main no='720.Semt'></td>
						<td><input type="text" name="work_semt" id="work_semt" value="<cfoutput>#get_consumer.worksemt#</cfoutput>" maxlength="30" style="width:150px;"></td>				
						<cfif attributes.is_detail_adres eq 0>
							<td><cf_get_lang_main no='60.Posta Kodu'></td>
							<td><input type="text" name="work_postcode" id="work_postcode" maxlength="15" value="<cfoutput>#get_consumer.workpostcode#</cfoutput>" onkeyup="isNumber(this);" style="width:150px;"></td>
						</cfif>
						<cfif attributes.is_detail_adres eq 1>
							<td valign="top"><cf_get_lang no='1628.Adres Detay'></td>
							<td><textarea name="work_door_no" id="work_door_no" style="width:150px;" maxlength="200"><cfoutput>#get_consumer.work_door_no#</cfoutput></textarea></td>
						</cfif>
					</tr>
					<cfif attributes.is_detail_adres eq 1>
						<tr>
							<td><cf_get_lang_main no='60.Posta Kodu'></td>
							<td><input type="text" name="work_postcode" id="work_postcode" maxlength="15" value="<cfoutput>#get_consumer.workpostcode#</cfoutput>" onkeyup="isNumber(this);" style="width:150px;"></td>
						</tr>
					</cfif>
				</table>
			</td>
		</tr>
		<tr class="color-row">
			<td height="20" style="cursor:pointer;" onclick="gizle_goster(gizli5);"><strong> >> <cf_get_lang no='220.Fatura Adresi'></strong></td>
		</tr>
		<cfif len(get_consumer.tax_district_id)>
			<cfquery name="GET_TAX_DIST" datasource="#DSN#">
				SELECT DISTRICT_NAME FROM SETUP_DISTRICT WHERE DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.tax_district_id#"> 
			</cfquery>
			<cfset tax_dis = '#get_tax_dist.district_name# '>
		<cfelse>
			<cfset tax_dis = ''>
		</cfif>
		<tr style="display:none;" id="gizli5">
			<td valign="top" class="color-row">
				<table>
					<tr>
						<td width="110"><cf_get_lang_main no='1350.Vergi Dairesi'></td>
						<td width="200"><input type="text" name="tax_office" id="tax_office" value="<cfoutput>#get_consumer.tax_office#</cfoutput>" maxlength="50" style="width:150px;"></td>
						<td width="100"><cf_get_lang_main no ='340.Vergi No'></td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang no ='508.Vergi No Girmelisiniz'> !</cfsavecontent>
							<cfinput type="text" name="tax_no" id="tax_no" value="#get_consumer.tax_no#" onKeyUp="isNumber(this);" validate="integer" message="#message#" maxlength="30" style="width:150px;">	
						</td>
					</tr>
					<tr>
						<cfif attributes.is_detail_adres eq 0>
							<td><cf_get_lang_main no='1311.Adres'></td>
							<td rowspan="3">
								<textarea name="tax_address" id="tax_address" style="width:150px;height:75px;"><cfoutput>#tax_dis##get_consumer.tax_adress#</cfoutput></textarea>
							</td>
						</cfif>
						<td><cf_get_lang_main no='807.Ülke'></td>
						<td><select name="tax_country" id="tax_country" style="width:150px;" onchange="LoadCity(this.value,'tax_city_id','tax_county_id',0<cfif attributes.is_detail_adres eq 1 and attributes.is_residence_select eq 1>,'tax_district_id'</cfif>)">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfoutput query="get_country">
									<option value="#country_id#" <cfif get_consumer.tax_country_id eq country_id>selected</cfif>>#country_name#</option>
								</cfoutput>
							</select>				
						</td>
						<cfif attributes.is_detail_adres eq 1>
							<td><cf_get_lang_main no='1323.Mahalle'></td>
							<td>
								<cfif attributes.is_residence_select eq 0>
									<input type="text" name="tax_district" id="tax_district" style="width:150px;" value="<cfif len(get_consumer.tax_district)><cfoutput>#get_consumer.tax_district#</cfoutput><cfelse><cfoutput>#tax_dis#</cfoutput></cfif>">
								<cfelse>
									 <select style="width:150px;" name="tax_district_id" id="tax_district_id">
										<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
										<cfif len(get_consumer.tax_district_id)>
											<cfquery name="GET_DISTRICT_NAME" datasource="#DSN#">
												SELECT DISTRICT_ID, DISTRICT_NAME FROM SETUP_DISTRICT WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.tax_county_id#">
											</cfquery>										
											<cfoutput query="get_district_name">
												<option value="#district_id#" <cfif get_consumer.tax_district_id eq district_id>selected</cfif>>#district_name#</option>
											</cfoutput>
										</cfif>
									</select>
								</cfif>
							</td>
						</cfif>
					</tr>
					<tr>
					  	<cfif attributes.is_detail_adres eq 0>
							<td></td>
						</cfif>
						<td><cf_get_lang_main no='559.Şehir'></td>
						<td>
							<select style="width:150px;" name="tax_city_id" id="tax_city_id" onchange="LoadCounty(this.value,'tax_county_id','','0'<cfif attributes.is_detail_adres eq 1 and attributes.is_residence_select eq 1>,'tax_district_id'</cfif>);">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfif len(get_consumer.tax_city_id)>
									<cfquery name="GET_CITY_TAX" datasource="#DSN#">
										SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.tax_country_id#">
									</cfquery>
									<cfoutput query="get_city_tax">
										<option value="#city_id#" <cfif get_consumer.tax_city_id eq city_id>selected</cfif>>#city_name#</option>	
									</cfoutput>
								</cfif>
							</select>
						</td>
						<cfif attributes.is_detail_adres eq 1>
							 <td><cf_get_lang no ='1335.Cadde'></td>
							 <td><input type="text" name="tax_main_street" id="tax_main_street" style="width:150px;" value="<cfoutput>#get_consumer.tax_main_street#</cfoutput>"></td>
						</cfif>
					</tr>
					<tr>
						<cfif attributes.is_detail_adres eq 0>
							<td></td>
						</cfif>
						<td><cf_get_lang_main no='1226.İlçe'></td>
						<td>
							<select style="width:150px;" name="tax_county_id" id="tax_county_id" <cfif attributes.is_detail_adres eq 1 and attributes.is_residence_select eq 1>onChange="LoadDistrict(this.value,'tax_district_id');"</cfif>>
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfif len(get_consumer.tax_county_id)>
									<cfquery name="GET_COUNTY_TAX" datasource="#DSN#">
										SELECT COUNTY_ID, COUNTY_NAME  FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.tax_city_id#">
									</cfquery>										
									<cfoutput query="get_county_tax">
										<option value="#county_id#" <cfif get_consumer.tax_county_id eq county_id>selected</cfif>>#county_name#</option>
									</cfoutput>
								</cfif>
							</select>
						</td>
						<cfif attributes.is_detail_adres eq 1>
							<td><cf_get_lang no ='1334.Sokak'></td>
							<td><input type="text" name="tax_street" id="tax_street" style="width:150px;" value="<cfoutput>#get_consumer.tax_street#</cfoutput>"></td>
						</cfif>
					</tr>
					<tr>
						<td><cf_get_lang_main no='720.Semt'></td>
						<td><input type="text" name="tax_semt" id="tax_semt" value="<cfoutput>#get_consumer.tax_semt#</cfoutput>" maxlength="30" style="width:150px;"></td>				
						<cfif attributes.is_detail_adres eq 0>
							<td><cf_get_lang_main no='60.Posta Kodu'></td>
							<td><input type="text" name="tax_postcode" id="tax_postcode"maxlength="15" value="<cfoutput>#get_consumer.tax_postcode#</cfoutput>" onkeyup="isNumber(this);" style="width:150px;"></td>
						</cfif>
						<cfif attributes.is_detail_adres eq 1>
							<td valign="top"><cf_get_lang no='1628.Adres Detay'></td>
							<td><textarea name="tax_door_no" id="tax_door_no" style="width:150px;" maxlength="200"><cfoutput>#get_consumer.tax_door_no#</cfoutput></textarea></td>
						</cfif>
					</tr>
					<cfif attributes.is_detail_adres eq 1>
						<tr>
							<td><cf_get_lang_main no='60.Posta Kodu'></td>
							<td><input type="text" name="tax_postcode" id="tax_postcode" maxlength="15" value="<cfoutput>#get_consumer.tax_postcode#</cfoutput>" onkeyup="isNumber(this);" style="width:150px;"></td>
						</tr>
					</cfif>
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
	<script type="text/javascript">
		<cfif isdefined("attributes.is_tc_number")>
			var is_tc_number = '<cfoutput>#attributes.is_tc_number#</cfoutput>';
		<cfelse>
			var is_tc_number = 0;
		</cfif>		
	
		var home_country_= document.getElementById('home_country').value;
		<cfif not len(get_consumer.home_city_id)>
			if(home_country_.length)
				LoadCity(home_country_,'home_city_id','home_county_id',0)
		</cfif>
		var home_city_= document.getElementById('home_city_id').value;
		<cfif not len(get_consumer.home_county_id)>
			if(home_city_.length)
				LoadCounty(home_city_,'home_county_id')
		</cfif>
		if(document.getElementById('home_district_id') != undefined)
		{
			var home_county_= document.getElementById('home_county_id').value;
			<cfif not len(get_consumer.home_district_id)>
				if(home_county_.length)
					LoadDistrict(home_county_,'home_district_id')
			</cfif>
		}	
		var work_country_= document.getElementById('work_country').value;
		<cfif not len(get_consumer.work_city_id)>
			if(work_country_.length)
				LoadCity(work_country_,'work_city_id','work_county_id',0)
		</cfif>
		var work_city_= document.getElementById('work_city_id').value;
		<cfif not len(get_consumer.work_county_id)>
			if(work_city_.length)
				LoadCounty(work_city_,'work_county_id')
		</cfif>
		if(document.getElementById('work_district_id') != undefined)
		{
			var work_county_= document.getElementById('work_county_id').value;
			<cfif not len(get_consumer.work_district_id)>
				if(work_county_.length)
					LoadDistrict(work_county_,'work_district_id')
			</cfif>
		}	
		var tax_country_= document.getElementById('tax_country').value;
		<cfif not len(get_consumer.tax_city_id)>
			if(tax_country_.length)
				LoadCity(tax_country_,'tax_city_id','tax_county_id',0)
		</cfif>
		var tax_city_= document.getElementById('tax_city_id').value;
		<cfif not len(get_consumer.tax_county_id)>
			if(tax_city_.length)
				LoadCounty(tax_city_,'tax_county_id')
		</cfif>
		if(document.getElementById('tax_district_id') != undefined)
		{
			var tax_county_= document.getElementById('tax_county_id').value;
			<cfif not len(get_consumer.tax_district_id)>
				if(tax_county_.length)
					LoadDistrict(tax_county_,'tax_district_id')
			</cfif>
		}
		function kontrol()
		{	
			<cfif isdefined("attributes.is_city_county_required") and attributes.is_city_county_required eq 1>
			if(document.upd_consumer.home_city_id != undefined)
			{
				x = document.upd_consumer.home_city_id.selectedIndex;
				if (document.upd_consumer.home_city_id[x].value == "")
				{ 
					alert ("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='559.Şehir'>");
					return false;
				}
			} 
		
			if(document.upd_consumer.home_county_id != undefined)
			{
				x = document.upd_consumer.home_county_id.selectedIndex;
				if (document.upd_consumer.home_county_id[x].value == "")
				{ 
					alert ("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='1226.İlçe'>");
					return false;
				}
			}
			</cfif>
		
			if(is_tc_number== 1)
			{
				if(!isTCNUMBER(document.upd_consumer.tc_identity_no)) return false;
			}
		
			if(document.upd_consumer.work_address != undefined)
			{
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
			}
			<cfif attributes.xml_check_cell_phone eq 1>
				if(document.getElementById('mobilcat_id').value != "" && document.getElementById('mobiltel').value != "")
				{
					
					var listParam = document.getElementById('consumer_id').value + "*" +document.getElementById('mobilcat_id').value + "*" + document.getElementById('mobiltel').value;
					var get_results = wrk_safe_query('mr_upd_cell_phone',"dsn",0,listParam);
					if(get_results.recordcount>0)
					{
						  alert("<cf_get_lang no='78.Girdiğiniz Cep Telefonuna Kayıtlı Başka Temsilci Bulunmaktadır!'>");
						  document.getElementById('mobiltel').focus();
						  return false;
					}              
				}
			</cfif>
			
			if(confirm("<cf_get_lang no='486.Girdiğiniz Bilgileri Kaydetmek Üzeresiniz, Lütfen Değişiklikleri Onaylayın'> !")) return true; else return false;
		}
	</script>
<cfelse>
	<cfset hata  = 10>
	<cfinclude template="../../dsp_hata.cfm">
</cfif>

