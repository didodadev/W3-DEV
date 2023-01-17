<cf_get_lang_set module_name="myhome"><!--- sayfanin en altinda kapanisi var --->
<cfsetting showdebugoutput="no">
<cfset attributes.empapp_id = attributes.iid>
<cfset empapp_id = attributes.iid>
<cfquery name="get_app" datasource="#dsn#">
	SELECT 
		EA.*,
		EI.MARRIED,
		EI.BIRTH_DATE 
	FROM 
		EMPLOYEES_APP EA,
		EMPLOYEES_IDENTY EI
	WHERE
		EI.EMPAPP_ID = EA.EMPAPP_ID AND
		EI.EMPAPP_ID = #empapp_id#
</cfquery>
<cfquery name="get_app_edu_info" datasource="#dsn#"><!--- egitim bilgileri --->
	SELECT
		EI.EDU_ID,
		EI.EDU_NAME,
		EI.EDU_PART_NAME,
		EI.EDU_START,
		EI.EDU_FINISH,
		EI.EDU_RANK,
		EI.IS_EDU_CONTINUE,
		SEL.EDUCATION_NAME
	FROM
		EMPLOYEES_APP_EDU_INFO EI,
		SETUP_EDUCATION_LEVEL SEL
	WHERE
		EI.EDU_TYPE = SEL.EDU_LEVEL_ID AND
		EI.EMPAPP_ID = #empapp_id#
</cfquery>
<cfquery name="get_app_language" datasource="#dsn#" maxrows="5"><!--- dil bilgileri--->
	SELECT
		LANG_ID,
		LANG_SPEAK,
		LANG_MEAN,
		LANG_WRITE,
		LANG_WHERE
	FROM
		EMPLOYEES_APP_LANGUAGE
	WHERE
		EMPAPP_ID = #empapp_id#
</cfquery>
<cfquery name="get_app_work_info" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_APP_WORK_INFO WHERE EMPAPP_ID = #empapp_id# ORDER BY EXP_START DESC
</cfquery>
<cfif get_app.recordcount>
	<cfquery name="im_cats" datasource="#dsn#">
		SELECT * FROM SETUP_IM
	</cfquery>
	<cfquery name="know_levels" datasource="#dsn#">
		SELECT * FROM SETUP_KNOWLEVEL
	</cfquery>
	<cfif len(get_app.homecity)>
		<cfquery name="get_city" datasource="#dsn#">
			SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #get_app.homecity#
		</cfquery>
	</cfif>
	<cfif len(get_app.homecountry)>
		<cfquery name="get_country" datasource="#dsn#">
			SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = #get_app.homecountry#
		</cfquery>
	</cfif>
	<cfif len(get_app.training_level)>
		<cfquery name="get_edu_level" datasource="#dsn#">
			SELECT EDUCATION_NAME FROM SETUP_EDUCATION_LEVEL WHERE EDU_LEVEL_ID = #get_app.training_level#
		</cfquery>
	</cfif>
<cfoutput query="get_app">
	<div align="center">
	<br/><br/><br/><br/><br/>
	<table  border="0" width="98%">
		<tr>
			<td>
			  <table style="width:175mm" align="center" border="1" cellpadding="0" cellspacing="0">
				<tr>
					<td width="10" class="txtbold"><cf_get_lang_main no='731.İletisim'></td>
					<td valign="top" width="750" align="center">
						<table width="100%" border="0" cellspacing="2" cellpadding="1" height="100%">
						<tr>
							<td valign="top" class="txtbold"><cf_get_lang_main no='158.Ad Soyad'>:</td>
							<td valign="top" class="headbold">#get_app.name# #get_app.surname#<br/></td>
							<td rowspan="8">
								<table border="1" width="100%" height="100%"><tr><td align="center">
								<cfif len(get_app.photo)>
									<img src="<cfoutput>#file_web_path#hr/#get_app.photo#</cfoutput>" border="0" width="120" height="140" align="center">
								<cfelse>
									<cf_get_lang no='1170.Fotoğrafı Yok'>
								</cfif>
								</td></tr></table>
							</td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang_main no='1311.Adres'>:</td>
							<td>#get_app.homeaddress# #get_app.homecounty# 	<cfif len(get_app.homecity)>#get_city.city_name#</cfif><cfif len(get_app.homecountry)>#get_country.country_name#</cfif> - #get_app.homepostcode#<br/></td>
						</tr>
						<tr>
							<td rowspan="4" valign="top" class="txtbold"><cf_get_lang no="417.Telefonlar">:</td>
							<td><cfif len(get_app.hometel)><cf_get_lang no="442.Ev">: #get_app.hometelcode# #get_app.hometel#<cfelse>&nbsp;</cfif><br/></td>
						</tr>
						<tr>
							<td><cfif len(get_app.worktel)><cf_get_lang_main no='1033.İş'>: #get_app.worktelcode# #get_app.worktel#<cfelse>&nbsp;</cfif><br/></td>
						</tr>
						<tr>
							<td><cfif len(get_app.mobil)><cf_get_lang_main no='1401.Cep Telefonu'>: #get_app.mobilcode# #get_app.mobil#<cfelse>&nbsp;</cfif><br/></td>
						</tr>
						<tr>
							<td><cfif len(get_app.mobil2)><cf_get_lang_main no='1401.Cep Telefonu'>2: #get_app.mobilcode2# #get_app.mobil2#<cfelse>&nbsp;</cfif><br/></td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang_main no='16.E-posta'>:</td>
							<td>#get_app.email#</td>
						</tr>
						</table>  
					</td>
				</tr>
				<tr>
					<td width="10" class="txtbold"><cf_get_lang_main no='1891.Kisisel'></td>
					<td>
						<table>
							<tr>
								<td class="txtbold"><cf_get_lang_main no='1315.Doğum Tarihi'>:</td>
								<td>#dateformat(get_app.birth_date,dateformat_style)#</td>
							</tr>
							<tr>
								<td class="txtbold"><cf_get_lang no='446.Medeni Durum'>:</td>
								<td><cfif get_app.married eq 1><cf_get_lang no='447.Evli'><cfelse><cf_get_lang no='448.Bekar'></cfif></td>
							</tr>
							<tr>
								<td class="txtbold"><cf_get_lang no='452.Askerlik'>:</td>
								<td><cfif get_app.military_status eq 1> 
										<cf_get_lang_main no='1374.Tamamlandı'> <cfif len(get_app.military_finishdate)>#dateformat(get_app.military_finishdate,dateformat_style)#</cfif>
									<cfelseif get_app.military_status eq 2>
										<cf_get_lang no='455.Muaf'> #get_app.military_exempt_detail#
									<cfelseif get_app.military_status eq 3>
										<cf_get_lang no='456.Yabancı'>
									<cfelseif get_app.military_status eq 4>
										<cf_get_lang no='457.Tecilli'> #get_app.military_delay_reason# <cfif len(get_app.military_delay_date)>#dateformat(get_app.military_delay_date,dateformat_style)#</cfif>
									</cfif>
								</td>
							</tr>
							<tr>
								<td class="txtbold"><cf_get_lang no="443.Ehliyet">:</td>
								<td><cfif get_app.driver_licence eq 1>
										<cf_get_lang_main no='1152.Var'> <cf_get_lang no='1568.Sınıf'>: #get_app.driver_licence_type#
									<cfelse>
										<cf_get_lang_main no='1134.Yok'>
									</cfif>
								</td>
							</tr>
							<tr><cfquery name="get_emp_hobbies" datasource="#dsn#"> 
									SELECT 
										EMPLOYEES_HOBBY.HOBBY_ID,
										SETUP_HOBBY.HOBBY_NAME
									FROM 
										EMPLOYEES_HOBBY,
										SETUP_HOBBY
									WHERE
										SETUP_HOBBY.HOBBY_ID=EMPLOYEES_HOBBY.HOBBY_ID AND 
										EMPAPP_ID=#attributes.empapp_id#
								</cfquery>
								<cfset hobbies=lcase(valuelist(get_emp_hobbies.hobby_name,','))>
								<td class="txtbold"><cf_get_lang no="445.Hobiler">:</td>
								<td>#hobbies#</td>
							</tr>
							<tr>
								<td class="txtbold"><cf_get_lang no="444.Dernek ve Kulüpler">:</td>
								<td>#get_app.club#</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td width="10" class="txtbold"><cf_get_lang_main no='7.Egitim'></td>
					<td>
						<table>
							<tr>
								<td class="txtbold"><cf_get_lang no='569.Eğitim Durumu'>:</td>
								<td><cfif len(get_app.training_level)>#get_edu_level.EDUCATION_NAME#<cfelse> - </cfif></td>
							</tr>
							<cfif get_app_edu_info.recordcount>
								<cfloop query="get_app_edu_info">
									<tr>
										<td class="txtbold">#education_name#:</td>
										<td>#edu_name#</td>
									</tr>
									<tr>
										<td class="txtbold"><cf_get_lang_main no='583.Bölüm'>:</td>
										<td>#edu_part_name#&nbsp;</td>
									</tr>
									<tr>
										<td class="txtbold"><cf_get_lang_main no='1055.Baslama'> - <cf_get_lang_main no='288.Bitis Tarihi'></td>
										<td>(#edu_start # - #edu_finish#)</td>
									</tr>
								</cfloop>
							</cfif>
							<tr>
								<td class="txtbold"><cf_get_lang no="456.Yabancı"> <cf_get_lang_main no="1584.Dil">:</td>
								<td>
									<cfloop query="get_app_language">
										<cfquery name="get_lang" datasource="#dsn#">
											SELECT LANGUAGE_SET FROM SETUP_LANGUAGES WHERE LANGUAGE_ID=#get_app_language.lang_id#
										</cfquery>
											#get_lang.language_set# 
										<cfquery name="know_level" dbtype="query">
											SELECT * FROM KNOW_LEVELS WHERE KNOWLEVEL_ID=<cfif len(get_app_language.lang_write)>#get_app_language.lang_write#<cfelse>0</cfif>
										</cfquery>
											(<cf_get_lang no='549.Yazma'>: #know_level.knowlevel#, 
										<cfquery name="know_level" dbtype="query">
											SELECT * FROM KNOW_LEVELS WHERE KNOWLEVEL_ID=<cfif len(get_app_language.lang_mean)>#get_app_language.lang_mean#<cfelse>0</cfif>
										</cfquery>
											<cf_get_lang no='548.Anlama'>: #know_level.knowlevel#, 
										<cfquery name="know_level" dbtype="query">
											SELECT * FROM KNOW_LEVELS WHERE KNOWLEVEL_ID=<cfif len(get_app_language.lang_speak)>#get_app_language.lang_speak#<cfelse>0</cfif>
										</cfquery>
											<cf_get_lang no='547.Konuşma'>: #know_level.knowlevel#)<br/>
									</cfloop>
								</td>
							</tr>
							<tr>
								<td class="txtbold"><cf_get_lang no='544.Bilgisayar Bilgisi'>:</td>
								<td>#get_app.comp_exp#</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td width="10" class="txtbold"><cf_get_lang no='1578.Deneyim'></td>
						<td>
							<table>
								<cfif get_app_work_info.RECORDCOUNT>
								 <cfloop query="get_app_work_info">
								<tr>
									<td class="txtbold">İşe giriş-çıkış tarihi:</td>
									<td valign="top">#dateformat(get_app_work_info.exp_start,'mm/yyyy')# - #dateformat(get_app_work_info.exp_finish,'mm/yyyy')#</td>
								</tr>
								<tr>
									<td class="txtbold"><cf_get_lang_main no='162.Şirket'>:</td>
									<td>#get_app_work_info.exp#</td>
								</tr>
								<tr>	
									<td class="txtbold"><cf_get_lang_main no='1085.Pozisyon'>:</td>
									<td>#get_app_work_info.exp_position#</td>
								</tr>
								<tr>
									<td class="txtbold"><cf_get_lang_main no='1875.Ekstra'>:</td>
									<td>#get_app_work_info.exp_extra#</td>
								</tr>
								</cfloop>
								</cfif>
							</table>
						</td>
					</tr>
				<tr>
					<td width="10" class="txtbold"><cf_get_lang_main no='1372.Referans'></td>
					<td>
						<table>
							<cfset ref_type_list = "">
							<cfquery name="get_reference" datasource="#dsn#">
								SELECT 
									REFERENCE_ID,
									REFERENCE_TYPE,
									REFERENCE_NAME,
									REFERENCE_COMPANY,
									REFERENCE_POSITION,
									REFERENCE_TELCODE,
									REFERENCE_TEL,
									REFERENCE_EMAIL
								FROM 
									EMPLOYEES_REFERENCE 
								WHERE 
									 EMPAPP_ID = #attributes.empapp_id#
								ORDER BY
									REFERENCE_TYPE
							</cfquery>
							<cfloop query="get_reference">
								<cfif len(reference_type) and not listfind(ref_type_list,reference_type,',')>
									<cfset ref_type_list = listappend(ref_type_list,reference_type,',')>
								</cfif>
							</cfloop>
							<cfif len(ref_type_list)>
								<cfquery name="get_ref_type" datasource="#dsn#">
									SELECT REFERENCE_TYPE_ID,REFERENCE_TYPE FROM SETUP_REFERENCE_TYPE REFERENCE_TYPE_ID IN(#ref_type_list#) ORDER BY REFERENCE_TYPE_ID
								</cfquery>
								<cfset ref_type_list = listsort(ref_type_list,"numeric","ASC",',')>
							</cfif>
							<cfif get_reference.recordcount>
							<cfloop query="get_reference">
								<tr>
									<td>Referans Tipi : <cfif len(reference_type)>#get_ref_type.reference_type[listfind(ref_type_list,reference_type,',')]#</cfif></td>
									<td>#get_reference.reference_name# #get_reference.REFERENCE_COMPANY# #get_reference.REFERENCE_POSITION#
										#get_reference.REFERENCE_TELCODE# #get_reference.REFERENCE_TEL# #get_reference.REFERENCE_EMAIL#
									</td>
								</tr>
							</cfloop>
							</cfif>
						</table>
					</td>
				</tr>
			</table>
			</td>
		</tr>
	</table>
	</div>
</cfoutput>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->