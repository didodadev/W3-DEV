<!---başvuru ise--->
<cf_get_lang_set module_name="hr"><!--- sayfanin en altinda kapanisi var --->
<cfif isdefined('attributes.iid')>
	<cfset attributes.app_pos_id = attributes.iid>
</cfif>
<cfif isdefined("attributes.app_pos_id") and len(attributes.app_pos_id)>
	<cfquery name="get_app" datasource="#dsn#">
		SELECT * FROM EMPLOYEES_APP_POS WHERE APP_POS_ID=#attributes.app_pos_id#
	</cfquery>
	<cfif get_app.recordcount>
		<cfquery name="get_empapp" datasource="#dsn#">
			SELECT NAME, SURNAME FROM EMPLOYEES_APP WHERE EMPAPP_ID=#get_app.empapp_id#
		</cfquery>
		<cfif len(GET_APP.POSITION_ID)>
			<cfset attributes.POSITION_CODE = GET_APP.POSITION_ID>
			<cfquery name="get_position" datasource="#dsn#">
				SELECT EMPLOYEE_POSITIONS.POSITION_ID, EMPLOYEE_POSITIONS.POSITION_CODE, EMPLOYEE_POSITIONS.POSITION_NAME, EMPLOYEE_POSITIONS.EMPLOYEE_NAME, EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_POSITIONS.POSITION_CODE = #GET_APP.POSITION_ID#
			</cfquery>
			<cfset app_position = "#GET_POSITION.POSITION_NAME#">
		<cfelse>
			<cfset attributes.POSITION_CODE = "">
			<cfset app_position = "">
		</cfif>
		
		<cfif len(GET_APP.POSITION_CAT_ID)>
			<cfset attributes.POSITION_CAT_ID = GET_APP.POSITION_CAT_ID>
			<cfquery name="GET_POSITION_CAT" datasource="#dsn#">
				SELECT * FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID IN (#ListSort(attributes.POSITION_CAT_ID,"numeric")#)
			</cfquery>
			<cfset POSITION_CAT = "#GET_POSITION_CAT.POSITION_CAT#">
		<cfelse>
			<cfset attributes.POSITION_CAT_ID = "">
			<cfset POSITION_CAT = "">
		</cfif>
		<cfquery name="GET_COMMETHODS" datasource="#dsn#">
			SELECT * FROM SETUP_COMMETHOD WHERE COMMETHOD_ID = #get_app.commethod_id#
		</cfquery>
			
		<table width="100%" cellpadding="2" cellspacing="1" border="0">
			<tr>
				<td class="headbold"><cf_get_lang no="31.Başvuru"> <cf_get_lang_main no="359.Detay"> <cfoutput>(#get_app.app_pos_id#)</cfoutput></td>
			</tr>
			<tr>
				<td>
				<table>
					<cfoutput>
					<tr>
						<td width="100"><cf_get_lang no='162.Başvuru No'></td>
						<td width="200">#get_app.app_pos_id#</td>
						<td><cf_get_lang no="31.Başvuru"> <cf_get_lang_main no="344.Durum"></td>
						<td><cfif get_app.app_pos_status eq 1><cf_get_lang_main no="81.Aktif"><cfelse><cf_get_lang_main no="82.Pasif"></cfif></td>
					</tr>
					<tr>
						<td><cf_get_lang no='74.İlan'></td>
						<td><cfif len(get_app.notice_id)>
								<cfquery name="get_notice" datasource="#dsn#">
									SELECT NOTICE_HEAD,NOTICE_NO FROM NOTICES WHERE NOTICE_ID = #get_app.notice_id#
								</cfquery>
								#get_notice.notice_no#-#get_notice.notice_head#
							</cfif>
						</td>
						<td><cf_get_lang no='349.Başvuru Tarihi'></td>
						<td>#dateformat(get_app.app_date,dateformat_style)#</td>							  
					</tr>
					<tr>
						<td><cf_get_lang_main no='1085.Pozisyon'> <cf_get_lang_main no='74.Kategori'></td>
						<td>#position_cat#</td>
						<td><cf_get_lang no='655.İstenen Ücret'></td>
						<td>#TLFormat(get_app.salary_wanted)# #get_app.salary_wanted_money#</td>
					</tr>
					<tr>
						<td><cf_get_lang_main no='1085.Pozisyon'></td>
						<td>#app_position#</td>
						<td><cf_get_lang no='69.İşe Başlama Tarihi'></td>
						<td>#dateformat(get_app.STARTDATE_IF_ACCEPTED,dateformat_style)#</td>
					</tr>
					<tr>
						<td><cf_get_lang_main no='160.Departman'></td>
						<td><cfif len(get_app.department_id) and len(get_app.our_company_id)>
								<cfquery name="get_our_company" datasource="#dsn#">
									SELECT BRANCH.BRANCH_NAME, BRANCH.BRANCH_ID, DEPARTMENT.DEPARTMENT_HEAD, DEPARTMENT.DEPARTMENT_ID FROM DEPARTMENT, BRANCH WHERE BRANCH.COMPANY_ID=#get_app.our_company_id# AND BRANCH.BRANCH_ID=DEPARTMENT.BRANCH_ID AND BRANCH.BRANCH_ID=#get_app.branch_id# AND DEPARTMENT.DEPARTMENT_ID=#get_app.department_id#
								</cfquery>
							</cfif>
							<cfif IsDefined('get_our_company') and get_our_company.recordcount>#get_our_company.department_head#</cfif>
						</td>
						<td><cf_get_lang_main no='41.Şube'></td>
						<td><cfif IsDefined('get_our_company') and get_our_company.recordcount>#get_our_company.branch_name#</cfif></td>
					</tr>
					</cfoutput>
					<tr>
						<td><cf_get_lang_main no='173.Kurumsal Üye'></td>
						<td><cfif len(get_app.company_id)>#get_par_info(get_app.company_id,1,0,0)#</cfif></td>
						<td><cf_get_lang_main no='731.İletişim'></td>
						<td><cfoutput query="get_commethods">#get_commethods.commethod#</cfoutput></td>
					</tr>
					<!--- <tr>
						<td><cf_get_lang no="719.Onay Durumu"></td>
						<td><cfoutput>#get_app.validator_position_code#</cfoutput>
							<cfif len(get_APP.validator_position_code)>
							<cfset attributes.position_code = get_APP.validator_position_code>
							<cfset attributes.employee_id = "">
							<cfquery name="GET_POSITION" datasource="#dsn#">
								SELECT
									DEPARTMENT.DEPARTMENT_HEAD,
									EMPLOYEE_POSITIONS.DEPARTMENT_ID,
									EMPLOYEE_POSITIONS.POSITION_ID,
									EMPLOYEE_POSITIONS.POSITION_CODE,
									EMPLOYEE_POSITIONS.POSITION_NAME,
									EMPLOYEE_POSITIONS.EMPLOYEE_ID,
									EMPLOYEE_POSITIONS.POSITION_CAT_ID,
									EMPLOYEE_POSITIONS.USER_GROUP_ID,
									EMPLOYEES.EMPLOYEE_NAME,
									EMPLOYEES.EMPLOYEE_SURNAME,
									EMPLOYEES.EMPLOYEE_NO,
									EMPLOYEES.EMPLOYEE_EMAIL,
									SETUP_POSITION_CAT.POSITION_CAT
								FROM
									EMPLOYEE_POSITIONS,
									EMPLOYEES,
									DEPARTMENT,
									SETUP_POSITION_CAT
								WHERE
									SETUP_POSITION_CAT.POSITION_CAT_ID = EMPLOYEE_POSITIONS.POSITION_CAT_ID
									AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID
									AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
									AND EMPLOYEE_POSITIONS.POSITION_STATUS = 1
									<cfif isDefined("attributes.POSITION_CODE") and len(attributes.POSITION_CODE)>
										AND EMPLOYEE_POSITIONS.POSITION_CODE = #attributes.POSITION_CODE#
									</cfif>
									<cfif isDefined("attributes.EMPLOYEE_ID") and len(attributes.EMPLOYEE_ID)>
										AND EMPLOYEE_POSITIONS.EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
									</cfif>
								</cfquery>
								<cfset pos_temp = "#get_position.employee_name# #get_position.employee_surname#">
							<cfelse>
								<cfset pos_temp = "">
							</cfif>
							<cfoutput>#pos_temp#</cfoutput>
						</td>
					</tr> --->
					<tr>
						<td><cf_get_lang_main no="1237.Ön Yazı"></td>
						<td colspan="3"><cfif len(get_app.detail)><cfoutput>#get_app.detail#</cfoutput></cfif></td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		<hr>
	</cfif> 
</cfif>

<!---başvuru ise--->
<cfif isdefined('attributes.app_pos_id')>
	<cfset attributes.empapp_id = get_app.empapp_id>
<cfelseif isdefined('attributes.action_id')>
	<cfset attributes.empapp_id = action_id>
</cfif>

<cfquery name="GET_APP" datasource="#DSN#">
	SELECT 
		EA.*,
		EI.MARRIED,
		EI.BIRTH_DATE,
		EI.EMPAPP_ID
	FROM 
		EMPLOYEES_APP EA, 
		EMPLOYEES_IDENTY EI
	WHERE 
		EA.EMPAPP_ID = EI.EMPAPP_ID
		AND EA.EMPAPP_ID = #attributes.empapp_id#
</cfquery>
<cfquery name="get_edu_info" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_APP_EDU_INFO WHERE EMPAPP_ID = #attributes.empapp_id# ORDER BY EDU_START
</cfquery>
<cfquery name="get_work_info" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_APP_WORK_INFO WHERE EMPAPP_ID = #attributes.empapp_id# ORDER BY EXP_START
</cfquery>
<cfif get_app.recordcount> 
	<cfoutput query="get_app">
		<cfquery name="IM_CATS" datasource="#dsn#">
			SELECT * FROM SETUP_IM
		</cfquery>
		<cfquery name="KNOW_LEVELS" datasource="#dsn#">
			SELECT * FROM SETUP_KNOWLEVEL
		</cfquery>
		<cfif len(get_app.homecounty)>
			<cfquery name="get_county" datasource="#dsn#">
				SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #get_app.homecounty#
			</cfquery>
		</cfif>
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
		<table width="750" align="center" border="0">
		<tr>
			<td colspan="2" class="headbold"><cf_get_lang no="773.Özgeçmiş Detay"></td>
		</tr>
		<tr>
			<td width="2"><cf_get_lang no="774.İ L E T İ Ş İ M"></td>
			<td valign="top" width="750" align="center">
				<table width="100%" border="0" cellspacing="2" cellpadding="1" height="100%">
				<tr>
					<td valign="top"><cf_get_lang_main no='219.Ad'> <cf_get_lang_main no='1314.Soyad'>:</td>
					<td valign="top" class="headbold">#get_app.name# #get_app.surname#<br/></td>
					<td rowspan="9">
						<cfif len(get_app.photo)>
							<img src="<cfoutput>#file_web_path#hr/#get_app.photo#</cfoutput>" border="0" width="120" height="140" align="center">
						<cfelse>
							<cf_get_lang_main no='1083.Fotoğrafı Yok'>
						</cfif>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='1311.Adres'>:</td>
					<td>#get_app.homeaddress# <cfif len(get_app.homecounty)> #get_county.county_name#</cfif><cfif len(get_app.homecity)> #get_city.city_name#</cfif><cfif len(get_app.homecountry)> #get_country.country_name#</cfif> - #get_app.homepostcode#<br/></td>
				</tr>
				<tr>
					<td rowspan="4" valign="top"><cf_get_lang_main no='87.Telefonlar'>:</td>
					<td><cfif len(get_app.hometel)><cf_get_lang_main no='1402.Ev'>: #get_app.hometelcode# #get_app.hometel#<cfelse>&nbsp;</cfif><br/></td>
				</tr>
				<tr>
					<td><cfif len(get_app.worktel)><cf_get_lang_main no='1033.İş'>: #get_app.worktelcode# #get_app.worktel#<cfelse>&nbsp;</cfif><br/></td>
				</tr>
				<tr>
					<td><cfif len(get_app.mobil)><cf_get_lang_main no='1401.Cep'>: #get_app.mobilcode# #get_app.mobil#<cfelse>&nbsp;</cfif><br/></td>
				</tr>
				<tr>
					<td><cfif len(get_app.mobil2)><cf_get_lang_main no='1401.Cep'>2: #get_app.mobilcode2# #get_app.mobil2#<cfelse>&nbsp;</cfif><br/></td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='1666.mail'>:</td>
					<td>#get_app.email#</td>
				</tr>
			</table>  
			</td>
		</tr>
		<tr>
			<td colspan="2" align="left"><hr width="200"></td>
		</tr>
		<tr>
			<td width="2"><cf_get_lang no="775.T E C R Ü B E"></td>
			<td>
			<table>
				<cfif get_work_info.recordcount>
					<cfloop query="get_work_info">
					<tr>
						<td valign="top"></b>#dateformat(get_work_info.exp_start,'mm/yyyy')# - #dateformat(get_work_info.exp_finish,'mm/yyyy')#</b></td>
						<td><b>#get_work_info.exp#<br/>
							#get_work_info.exp_position#<br/>
						- #get_work_info.exp_extra#</b>
						</td>
					</tr>
					</cfloop>
				</cfif>
			</table>
			</td>
		</tr>
		<tr>
			<td colspan="2" align="left"><hr width="200"></td>
		</tr>
		<tr>
			<td width="2"><cf_get_lang no="776.E Ğ İ T İ M"></td>
			<td>
			<table>
				<tr>
					<td><cf_get_lang no="410.Eğitim Durumu">:</td>
					<td><cfif len(get_app.training_level)>#get_edu_level.EDUCATION_NAME#<cfelse> - </cfif></td>
				</tr>
				<cfif get_edu_info.recordcount>
					<cfloop query="get_edu_info">
					<tr>
						<td>
							<cfif get_edu_info.edu_type eq 1>
								<cf_get_lang_main no="1136.İlk"> <cf_get_lang_main no="297.Okul">
							<cfelseif get_edu_info.edu_type eq 2>
								<cf_get_lang_main no="516.Orta"> <cf_get_lang_main no="297.Okul">
							<cfelseif get_edu_info.edu_type eq 3>
								<cf_get_lang no="595.Lise">
							<cfelseif get_edu_info.edu_type eq 4>
								<cf_get_lang_main no="1958.Üniversite">
							<cfelseif get_edu_info.edu_type eq 5>
								<cf_get_lang no="597.Yüksek Lisans">
							<cfelseif get_edu_info.edu_type eq 6>
								<cf_get_lang no="248.Doktora">
							</cfif>
						</td>
						<td>#get_edu_info.edu_name#</td>
					</tr>
					<cfif listfind('3,4,5,6',get_edu_info.edu_type)>
						<tr>
							<td><cf_get_lang_main no='583.Bölüm'>:</td>
							<td>#get_edu_info.edu_part_name#</td>
						</tr>
					</cfif>
					<tr>
						<td></td>
						<td></td>
					</tr>
					</cfloop>
				</cfif>
				<tr>
					<td valign="top"><cf_get_lang no="131.Yabancı Dil">:</td>
					<td>
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
								EMPAPP_ID = #get_app.empapp_id#
						</cfquery>
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
					<td><cf_get_lang no="777.Bilgisayar Bilgileri">:</td>
					<td>#get_app.comp_exp#</td>
				</tr>
			</table>
			</td>
		</tr>
		<tr>
			<td colspan="2" align="left"><hr width="200"></td>
		</tr>
		<tr>
			<td width="2"><cf_get_lang no="778.K İ Ş İ S E L"></td>
			<td>
			<table>
				<tr>
					<td><cf_get_lang_main no='1315.Doğum Tarihi'>:</td>
					<td>#dateformat(get_app.birth_date,dateformat_style)#</td>
				</tr>
				<tr>
					<td><cf_get_lang no="569.Medeni Durum">:</td>
					<td><cfif get_app.married eq 1><cf_get_lang no="658.Evli"><cfelse><cf_get_lang no="659.Bekar"></cfif></td>
				</tr>
				<tr>
					<td><cf_get_lang no="534.Askerlik">:</td>
					<td><cfif get_app.military_status eq 1> 
							<cf_get_lang_main no='1374.Tamamlandı'> <cfif len(get_app.military_finishdate)>#dateformat(get_app.military_finishdate,dateformat_style)#</cfif>
						<cfelseif get_app.military_status eq 2>
							<cf_get_lang no="541.Muaf"> #get_app.military_exempt_detail#
						<cfelseif get_app.military_status eq 3>
							<cf_get_lang no="542.Yabancı">
						<cfelseif get_app.military_status eq 4>
							<cf_get_lang no="255.Tecilli"> #get_app.military_delay_reason# <cfif len(get_app.military_delay_date)>#dateformat(get_app.military_delay_date,dateformat_style)#</cfif>
						</cfif>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang no="249.Ehliyet">:</td>
					<td><cfif get_app.driver_licence eq 1>
							<cf_get_lang_main no='1152.Var'> Sınıfı: #get_app.driver_licence_type#
						<cfelse>
							<cf_get_lang_main no='1134.Yok'>
						</cfif>
					</td>
				</tr>
				<cfquery name="get_emp_hobbies" datasource="#dsn#"> 
					SELECT 
						EMPLOYEES_HOBBY.HOBBY_ID,
						SETUP_HOBBY.HOBBY_NAME
					FROM 
						EMPLOYEES_HOBBY,
						SETUP_HOBBY
					WHERE
						SETUP_HOBBY.HOBBY_ID = EMPLOYEES_HOBBY.HOBBY_ID AND 
						EMPAPP_ID = #attributes.empapp_id#
				</cfquery>
				<cfset hobbies=lcase(valuelist(get_emp_hobbies.hobby_name,','))>
				<tr>
					<td><cf_get_lang no='1514.Hobiler'>:</td>
					<td>#hobbies#</td>
				</tr>
				<tr>
					<td><cf_get_lang no="779.Dernek ve Kulüpler">:</td>
					<td>#get_app.club#</td>
				</tr>
			</table>
			</td>
		</tr>
		<tr>
			<td colspan="2" align="left"><hr width="200"></td>
		</tr>
		<tr>
			<td width="2"></td>
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
				<cfoutput query="get_reference">
					<tr>
						<td><cf_get_lang no="155.Referans Tipi"> : <cfif len(reference_type)>#get_ref_type.reference_type[listfind(ref_type_list,reference_type,',')]#</cfif></td>
						<td>#get_reference.reference_name# #get_reference.REFERENCE_COMPANY# #get_reference.REFERENCE_POSITION#
							#get_reference.REFERENCE_TELCODE# #get_reference.REFERENCE_TEL# #get_reference.REFERENCE_EMAIL#
						</td>
					</tr>
				</cfoutput>
				</cfif>
				<!---<cfif len(get_app.ref1_emp)>
					<tr>
						<td valign="top"><cf_get_lang no='1082.Grup İçi Referanslar'> 1:</td>
						<td>#get_app.ref1_emp# #get_app.ref1_company_emp#  #get_app.ref1_position_emp#<br/>
							#get_app.ref1_telcode_emp# #get_app.ref1_tel_emp# #get_app.ref1_email_emp#<br/>
						</td>
					</tr>
				</cfif>
				<cfif len(get_app.ref2_emp)>
					<tr>
						<td valign="top"><cf_get_lang no='1082.Grup İçi Referanslar'> 2:</td>
						<td>#get_app.ref2_emp# #get_app.ref2_company_emp#  #get_app.ref2_position_emp#<br/>
							#get_app.ref2_telcode_emp# #get_app.ref2_tel_emp# #get_app.ref2_email_emp#<br/>
						</td>
					</tr>
				</cfif>
				<cfif len(get_app.ref1)>
					<tr>
						<td valign="top"><cf_get_lang_main no='1372.Referanslar'> 1:</td>
						<td>#get_app.ref1# #get_app.ref1_company#  #get_app.ref1_position#<br/>
							#get_app.ref1_telcode# #get_app.ref1_tel# #get_app.ref1_email#<br/>
						</td>
					</tr>
				</cfif>
				<cfif len(get_app.ref2)>
					<tr>
						<td valign="top"><cf_get_lang_main no='1372.Referanslar'> 2:</td>
						<td>#get_app.ref2# #get_app.ref2_company#  #get_app.ref2_position#<br/>
							#get_app.ref2_telcode# #get_app.ref2_tel# #get_app.ref2_email#<br/>
						</td>
					</tr>
				</cfif>--->
				</table>
				</td>
			</tr>
		</table>
	</cfoutput>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
