<!---başvuru ise--->
	<cfif isdefined("attributes.app_pos_id") and len(attributes.app_pos_id)>
		<cfquery name="get_app" datasource="#dsn#">
			SELECT * FROM EMPLOYEES_APP_POS WHERE APP_POS_ID=#attributes.app_pos_id#
		</cfquery>
		<cfif get_app.recordcount>
		<cfquery name="get_empapp" datasource="#dsn#">
			SELECT NAME, SURNAME FROM EMPLOYEES_APP WHERE EMPAPP_ID=#get_app.empapp_id#
		</cfquery>
		<cfquery name="get_empapp_work_info" datasource="#dsn#">
			SELECT * FROM EMPLOYEES_APP_WORK_INFO WHERE EMPAPP_ID=#get_app.empapp_id#
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
					SELECT 
						* 
					FROM 
						SETUP_POSITION_CAT 
					WHERE 
						POSITION_CAT_ID IN (#ListSort(attributes.POSITION_CAT_ID,"numeric")#)
				</cfquery>
			<cfset POSITION_CAT = "#GET_POSITION_CAT.POSITION_CAT#">
		<cfelse>
			<cfset attributes.POSITION_CAT_ID = "">
			<cfset POSITION_CAT = "">
		</cfif>
		
		<cfquery name="GET_COMMETHODS" datasource="#dsn#">
			SELECT
				*
			FROM
				SETUP_COMMETHOD
			WHERE 
				COMMETHOD_ID=#get_app.commethod_id#
		</cfquery>
		<table width="100%" cellpadding="2" cellspacing="1" border="0">
		<tr><td class="headbold">&nbsp;&nbsp;<cf_get_lang dictionary_id='33130.Başvuru Detay'> <cfoutput>(#get_app.app_pos_id#)</cfoutput></td></tr>
			<tr>
				<td>
					<table>
						<tr>
							<td width="100"><cf_get_lang dictionary_id='32417.Başvuru No'></td>
							<td width="200">: <cfoutput>#get_app.app_pos_id#</cfoutput></td>
							<td><cf_get_lang dictionary_id='33132.Başvuru Durum'></td>
							<td>: <cfif get_app.app_pos_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='33330.İlan'></td>
							<td>:
								<cfif len(get_app.notice_id)>
								<cfquery name="get_notice" datasource="#dsn#">
									SELECT NOTICE_HEAD,NOTICE_NO FROM NOTICES WHERE NOTICE_ID = #get_app.notice_id#
								</cfquery>
								<cfoutput>#get_app.notice_id#</cfoutput>
								<cfoutput>#get_notice.NOTICE_NO#</cfoutput>
								<cfoutput>#get_notice.NOTICE_NO#-#get_notice.NOTICE_HEAD#</cfoutput>
								</cfif>
							<td><cf_get_lang dictionary_id='34174.Başvuru Tarihi'></td>
							<td>:
								<cfoutput>#dateformat(get_app.app_date,dateformat_style)#</cfoutput>
							</td>							  
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='58497.Pozisyon'> <cf_get_lang dictionary_id='57486.Kategori'></td>
							<td>:
								<cfoutput>#get_app.position_cat_id#</cfoutput>
								<cfoutput>#POSITION_CAT#</cfoutput>
							<td><cf_get_lang dictionary_id='33135.İstenen Ücret'></td>
							<td>:
								<cfoutput>#TLFormat(get_app.salary_wanted)# #get_app.salary_wanted_money# </cfoutput>
							</td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='58497.Pozisyon'></td>
							<td>: <cfoutput>#get_app.POSITION_ID# #app_position#</cfoutput></td>
							<td><cf_get_lang dictionary_id='33138.İşe Başlama Tarihi'></td>
							<td>: <cfoutput>#dateformat(get_app.STARTDATE_IF_ACCEPTED,dateformat_style)#</cfoutput></td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='57572.Department'></td>
							<td>:
								<cfif len(get_app.department_id) and len(get_app.our_company_id)>
									<cfquery name="get_our_company" datasource="#dsn#">
										SELECT BRANCH.BRANCH_NAME, BRANCH.BRANCH_ID, DEPARTMENT.DEPARTMENT_HEAD, DEPARTMENT.DEPARTMENT_ID FROM DEPARTMENT, BRANCH WHERE BRANCH.COMPANY_ID=#get_app.our_company_id# AND BRANCH.BRANCH_ID=DEPARTMENT.BRANCH_ID AND BRANCH.BRANCH_ID=#get_app.branch_id# AND DEPARTMENT.DEPARTMENT_ID=#get_app.department_id#
									</cfquery>
								</cfif>
								<cfoutput>#get_app.our_company_id#</cfoutput>
								<cfoutput>#get_app.department_id#</cfoutput>
								<cfif IsDefined('get_our_company') and get_our_company.recordcount><cfoutput>#get_our_company.department_head#</cfoutput></cfif>
							<td><cf_get_lang dictionary_id='57453.Şube'></td>
							<td>:
								<cfoutput>#get_app.branch_id#</cfoutput>
								<cfif IsDefined('get_our_company') and get_our_company.recordcount><cfoutput>#get_our_company.branch_name#</cfoutput></cfif>
							</td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='57585.Kurumsal Üye'></td>
							<td>:
							<cfif len(get_app.company_id)><cfoutput>#get_par_info(get_app.company_id,1,0,0)#</cfoutput></cfif>
							<td><cf_get_lang dictionary_id='58143.İletişim'></td>
							<td>:
							<cfoutput query="get_commethods">
								#get_commethods.commethod# 
							</cfoutput>
							</td>
						</tr>
					<tr>
						<td><cf_get_lang dictionary_id='33139.Onay Durumu'></td>
						<td>:
						<cfoutput>#get_app.validator_position_code#</cfoutput>
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
					</tr>
					<tr>
                        <td><cf_get_lang dictionary_id='58649.Ön yazı'></td>
                        <td colspan="3">:
                            <cfif len(get_app.detail)><cfoutput>#get_app.detail#</cfoutput></cfif>
                        </td>
					</tr>
					</table>
				</td>
			</tr>
		</table>
		<hr>
		</cfif> 
	</cfif>
<!---başvuru ise--->

<cfquery name="GET_APP" datasource="#DSN#">
	SELECT 
		EA.*,EI.MARRIED,EI.BIRTH_DATE 
	FROM 
		EMPLOYEES_APP EA, EMPLOYEES_IDENTY EI
	WHERE EA.EMPAPP_ID = #EMPAPP_ID#
		AND EI.EMPAPP_ID = #EMPAPP_ID#
</cfquery>
<cfif get_app.recordcount>
<cfoutput query="get_app">
	<cfquery name="IM_CATS" datasource="#dsn#">
		SELECT * FROM SETUP_IM
	</cfquery>
	<cfquery name="KNOW_LEVELS" datasource="#dsn#">
		SELECT * FROM SETUP_KNOWLEVEL
	</cfquery>
	<cfif len(get_app.homecity)>
		<cfquery name="get_city" datasource="#dsn#">
			SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID=#get_app.homecity#
		</cfquery>
	</cfif>
	<cfif len(get_app.homecountry)>
		<cfquery name="get_country" datasource="#dsn#">
			SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID=#get_app.homecountry#
		</cfquery>
	</cfif>
	<!--- <cfif len(get_app.edu4_id)>
		<cfquery name="get_edu4_1" datasource="#dsn#">
			SELECT SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_ID=#get_app.edu4_id#
		</cfquery>
	</cfif>
	<cfif len(get_app.edu4_id_2)>
		<cfquery name="get_edu4_2" datasource="#dsn#">
			SELECT SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_ID=#get_app.edu4_id_2#
		</cfquery>
	</cfif>
	<cfif len(get_app.edu4_part_id)>
		<cfquery name="get_edu4_part_1" datasource="#dsn#">
			SELECT PART_NAME FROM SETUP_SCHOOL_PART WHERE PART_ID=#get_app.edu4_part_id#
		</cfquery>
	</cfif>
	<cfif len(get_app.edu4_part_id_2)>
		<cfquery name="get_edu4_part_2" datasource="#dsn#">
			SELECT PART_NAME FROM SETUP_SCHOOL_PART WHERE PART_ID=#get_app.edu4_part_id_2#
		</cfquery>
	</cfif>
	<cfif len(get_app.edu3_part)>
		<cfquery name="get_edu3_part" datasource="#dsn#">
			SELECT HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART WHERE HIGH_PART_ID=#get_app.edu3_part#
		</cfquery>
	</cfif> --->
	<cfif len(get_app.training_level)>
		<cfquery name="get_edu_level" datasource="#dsn#">
			SELECT EDUCATION_NAME FROM SETUP_EDUCATION_LEVEL WHERE EDU_LEVEL_ID=#get_app.training_level#
		</cfquery>
	</cfif>
<table width="750" align="center" border="0">
<tr>
	<td colspan="2" class="headbold">&nbsp;&nbsp;<cf_get_lang dictionary_id='33144.Özgeçmiş Detay'></td>
</tr>
<tr>
	<td width="2"><cf_get_lang dictionary_id='33195.İ L E T İ Ş İ M'></td>
	<td valign="top" width="750" align="center">
		<table width="100%" border="0" cellspacing="2" cellpadding="1" height="100%">
            <tr>
                <td valign="top" width="100"><cf_get_lang dictionary_id='57570.Ad Soyad'></td>
                <td valign="top" class="headbold">#get_app.name# #get_app.surname#<br/></td>
                <td rowspan="9">
                    <cfif len(get_app.photo)>
                         <cf_get_server_file output_file="hr/#get_app.photo#" output_server="#get_app.photo_server_id#" output_type="0" image_width="120" image_height="140">
                    <cfelse>
                        <cf_get_lang dictionary_id='33146.Fotoğraf Yok'>
                    </cfif>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='58723.Adres'></td>
                <td>: #get_app.homeaddress# #get_app.homecounty# 	<cfif len(get_app.homecity)>#get_city.city_name#</cfif> <cfif len(get_app.homecountry)>#get_country.country_name#</cfif> - #get_app.homepostcode#<br/></td>
            </tr>
            <tr>
                <td rowspan="4" valign="top"><cf_get_lang dictionary_id='57499.Telefonlar'></td>
                <td>: <cfif len(get_app.hometel)><cf_get_lang dictionary_id='33147.Ev'>:#get_app.hometelcode# #get_app.hometel#<cfelse>&nbsp;</cfif><br/></td>
            </tr>
            <tr>
                <td>: <cfif len(get_app.worktel)><cf_get_lang dictionary_id='58445.İş'>:#get_app.worktelcode# #get_app.worktel#<cfelse>&nbsp;</cfif><br/></td>
            </tr>
            <tr>
                <td>: <cfif len(get_app.mobil)><cf_get_lang dictionary_id='33148.Cep'>: #get_app.mobilcode# #get_app.mobil#<cfelse>&nbsp;</cfif><br/></td>
            </tr>
            <tr>
                <td>:<cfif len(get_app.mobil2)><cf_get_lang dictionary_id='33148.Cep'>2: #get_app.mobilcode2# #get_app.mobil2#<cfelse>&nbsp;</cfif><br/></td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='33152.Email'></td>
                <td>: #get_app.email#</td>
            </tr>
		</table>  
	</td>
</tr>
<tr>
	<td colspan="2" align="left">&nbsp;</td>
</tr>
<tr>
	<td width="2"><cf_get_lang dictionary_id='33194.T E C R Ü B E'></td>
		<td>
		<cfif isdefined("get_empapp_work_info.recordcount") and get_empapp_work_info.recordcount>
			<table>
				<cfloop query="get_empapp_work_info">
				<tr>
					<td valign="top"><b>#dateformat(get_empapp_work_info.exp_start,'mm/yyyy')# - #dateformat(get_empapp_work_info.exp_finish,'mm/yyyy')#</b></td>
					<td><b>#get_empapp_work_info.exp#</b><br/>
						#get_empapp_work_info.exp_position#<br/>
						- #get_empapp_work_info.exp_extra#
					</td>
				</tr>
				</cfloop>
			</table>
		</cfif>
		</td>
</tr>
<tr>
	<td colspan="2" align="left">&nbsp;</td>
</tr>
<tr>
	<td width="2"><cf_get_lang dictionary_id='33193.E Ğ İ T İ M'></td>
	<td>
		<table>
			<tr>
				<td width="100"><cf_get_lang dictionary_id='33168.Eğitim Durumu'></td>
				<td>: <cfif len(get_app.training_level)>#get_edu_level.EDUCATION_NAME#<cfelse> - </cfif></td>
			</tr>
			<cfquery name="get_edu_info" datasource="#dsn#">
				SELECT 
					SE.EDUCATION_NAME,
					SE.EDU_TYPE,
					EI.EDU_ID,
					EI.EDU_NAME,
					EI.EDU_PART_ID,
					EI.EDU_PART_NAME
				FROM 
					EMPLOYEES_APP_EDU_INFO EI,
					SETUP_EDUCATION_LEVEL SE
				WHERE
					EI.EDU_TYPE = SE.EDU_LEVEL_ID AND
					EI.EMPAPP_ID = #get_app.empapp_id#					
			</cfquery>
			<cfquery name="get_edu_2" dbtype="query"><!--- üniversite bilgileri--->
				SELECT * FROM get_edu_info WHERE EDU_TYPE = 2
			</cfquery>
			<cfloop query="get_edu_2">
				<tr>
					<td>#EDUCATION_NAME#</td>
					<td>:
						<cfif get_edu_2.edu_id neq -1>
							<cfquery name="get_school" datasource="#dsn#">
								SELECT SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_ID=#get_edu_2.edu_id#
							</cfquery>
							#get_school.SCHOOL_NAME#
						<cfelse>
							#get_edu_2.edu_name#
						</cfif>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='57995.Bölüm'></td>
					<td>:
						<cfif get_edu_2.edu_part_id neq -1>
							<cfquery name="get_school_part" datasource="#dsn#">
								SELECT PART_NAME FROM SETUP_SCHOOL_PART WHERE PART_ID=#get_edu_2.edu_part_id#
							</cfquery>
							#get_school_part.PART_NAME#
						<cfelse>
							#get_edu_2.edu_part_name#
						</cfif>
					</td>
				</tr>
			</cfloop>
			<cfquery name="get_edu_1" dbtype="query"><!--- lise bilgileri--->
				SELECT * FROM get_edu_info WHERE EDU_TYPE = 1
			</cfquery>
			<cfloop query="get_edu_1">
				<tr>
					<td>#EDUCATION_NAME#</td>
					<td>#get_edu_1.edu_name#</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='57995.Bölüm'></td>
					<td>:
						<cfif get_edu_1.edu_part_id neq -1>
							<cfquery name="get_school_part" datasource="#dsn#">
								SELECT HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART WHERE HIGH_PART_ID=#get_edu_1.edu_part_id#
							</cfquery>
							#get_school_part.HIGH_PART_NAME#
						<cfelse>
							#get_edu_1.edu_part_name#
						</cfif>
					</td>
				</tr>
			</cfloop>
			<!--- <cfif len(get_app.edu7)>
			<tr>
				<td>Doktora:</td>
				<td>#get_app.edu7#</td>
			</tr>
			<tr>
				<td>Bölüm:</td>
				<td>#get_app.edu7_part#</td>
			</tr>
			</cfif>
			<cfif len(get_app.edu4_id_2)>
			<tr>
				<td>Üniversite 2</td>
				<td><cfif len(get_app.edu4_id)>#get_edu4_2.school_name# (#get_app.edu4_start_2# - #get_app.edu4_finish_2#)</cfif></td>
			</tr>
			<tr>
				<td>Bölüm</td>
				<td><cfif len(get_app.edu4_part_id_2)>#get_edu4_part_1.part_name#</cfif></td>
			</tr>
			</cfif>
			<cfif len(get_app.edu4_id) or len(get_app.edu4)>
			<tr>
				<td>Üniversite</td>
				<td><cfif len(get_app.edu4_id)>#get_edu4_1.school_name#<cfelse>#get_app.edu4#</cfif> (#get_app.edu4_start# - #get_app.edu4_finish#)</td>
			</tr>
			<tr>
				<td>Bölüm</td>
				<td><cfif len(get_app.edu4_part_id)>#get_edu4_part_1.part_name#<cfelse>#get_app.edu4_part#</cfif></td>
			</tr>
			</cfif>
			<cfif len(get_app.edu3)>
			<tr>
				<td>Lise</td>
				<td>#get_app.edu3# (#get_app.edu3_start# - #get_app.edu3_finish#)</td>
			</tr>
			<cfif len(edu3_part)>
			<tr>
				<td>Bölüm</td>
				<td>#get_edu3_part.high_part_name#</td>
			</tr>
			</cfif> --->
		<tr>
			<td valign="top"><cf_get_lang dictionary_id='33172.Yabancı Dil'></td>
			<cfquery name="get_language" datasource="#dsn#">
				SELECT 
					LANG_ID,
					LANG_WRITE,
					LANG_SPEAK,
					LANG_MEAN,
					LANG_WHERE 
				FROM 
					EMPLOYEES_APP_LANGUAGE	
				WHERE
					EMPAPP_ID = #get_app.empapp_id#		
			</cfquery>
			<td>:
				<cfloop query="get_language">
					<cfquery name="get_lang" datasource="#dsn#">
						SELECT LANGUAGE_SET FROM SETUP_LANGUAGES WHERE LANGUAGE_ID=#get_language.lang_id#
					</cfquery>
						#get_lang.language_set# 
					<cfquery name="know_level" dbtype="query">
						SELECT * FROM KNOW_LEVELS WHERE KNOWLEVEL_ID=<cfif len(get_language.lang_write)>#get_language.lang_write#<cfelse>0</cfif>
					</cfquery>
						(<cf_get_lang dictionary_id='33174.Yazma'>: #know_level.knowlevel#, 
					<cfquery name="know_level" dbtype="query">
						SELECT * FROM KNOW_LEVELS WHERE KNOWLEVEL_ID=<cfif len(get_language.lang_mean)>#get_language.lang_mean#<cfelse>0</cfif>
					</cfquery>
						<cf_get_lang dictionary_id='33175.Anlama'>: #know_level.knowlevel#, 
					<cfquery name="know_level" dbtype="query">
						SELECT * FROM KNOW_LEVELS WHERE KNOWLEVEL_ID=<cfif len(get_language.lang_speak)>#get_language.lang_speak#<cfelse>0</cfif>
					</cfquery>
						<cf_get_lang dictionary_id='33177.Konuşma'>: #know_level.knowlevel#)<br/>
				</cfloop>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id='33178.Bilgisayar Bilgileri'></td>
			<td>: #get_app.comp_exp#</td>
		</tr>
		</table>
	</td>
</tr>
<tr>
	<td colspan="2" align="left">&nbsp;</td>
</tr>
<tr>
	<td width="2"><cf_get_lang dictionary_id='33192.K İ Ş İ S E L'></td>
	<td>
		<table>
			<tr>
				<td width="100"><cf_get_lang dictionary_id='58727.Doğum Tarihi'></td>
				<td>: #dateformat(get_app.birth_date,dateformat_style)#</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='33179.Medeni Durum'></td>
				<td>:<cfif get_app.married eq 1><cf_get_lang dictionary_id='33190.Evli'><cfelse><cf_get_lang dictionary_id='33191.Bekar'></cfif></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='33183.Askerlik'></td>
				<td>:
					<cfif get_app.military_status eq 1> 
						<cf_get_lang dictionary_id='58786.Tamamlandı'> <cfif len(get_app.military_finishdate)>#dateformat(get_app.military_finishdate,dateformat_style)#</cfif>
					<cfelseif get_app.military_status eq 2>
						<cf_get_lang dictionary_id='33184.Muaf'> #get_app.military_exempt_detail#
					<cfelseif get_app.military_status eq 3>
						<cf_get_lang dictionary_id='33185.Yabancı'>
					<cfelseif get_app.military_status eq 4>
						<cf_get_lang dictionary_id='33186.Tecilli'> #get_app.military_delay_reason# <cfif len(get_app.military_delay_date)>#dateformat(get_app.military_delay_date,dateformat_style)#</cfif>
					</cfif>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='33187.Ehliyet'></td>
				<td>:
					<cfif get_app.driver_licence eq 1>
						<cf_get_lang dictionary_id='33188.Var Sınıfı'>: #get_app.driver_licence_type#
					<cfelse>
						<cf_get_lang dictionary_id='58546.Yok'>
					</cfif>
				</td>
			</tr>
			<tr>
                <cfquery name="get_emp_hobbies" datasource="#dsn#"> 
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
				<td><cf_get_lang dictionary_id='33333.Hobiler'></td>
				<td>: #hobbies#</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='33189.Dernek ve Klüpler'></td>
				<td>: #get_app.club#</td>
			</tr>
		</table>
	</td>
</tr>
<tr>
	<td colspan="2" align="left">&nbsp;</td>
</tr>
<tr>
	<td width="2"></td>
	<td>
		<table>
		<cfquery name="get_ref" datasource="#dsn#">
			SELECT 
				REFERENCE_NAME,
				REFERENCE_COMPANY,
				REFERENCE_POSITION,
				REFERENCE_TEL,
				REFERENCE_TELCODE,
				REFERENCE_EMAIL
			FROM 
				EMPLOYEES_REFERENCE	
			WHERE
				EMPAPP_ID = #get_app.empapp_id#	
		</cfquery>
		<cfloop query="get_ref">
			<tr>
				<td valign="top" width="100"><cf_get_lang dictionary_id='58784.Referans'> #currentrow#</td>
				<td valign="top">
					: #get_ref.REFERENCE_NAME# #get_ref.REFERENCE_COMPANY#  #get_ref.REFERENCE_POSITION#<br/>
					: #get_ref.REFERENCE_TELCODE# #get_ref.REFERENCE_TEL# #get_ref.REFERENCE_EMAIL#<br/>
				</td>
			</tr>
		</cfloop>
		<!--- <cfif len(get_app.ref1_emp)>
		<tr>
			<td valign="top">Grup İçi Referanslar 1:</td>
			<td>#get_app.ref1_emp# #get_app.ref1_company_emp#  #get_app.ref1_position_emp#<br/>
				#get_app.ref1_telcode_emp# #get_app.ref1_tel_emp# #get_app.ref1_email_emp#<br/>
			</td>
		</tr>
		</cfif>
		<cfif len(get_app.ref2_emp)>
		<tr>
			<td valign="top">Grup İçi Referanslar 2:</td>
			<td>
					#get_app.ref2_emp# #get_app.ref2_company_emp#  #get_app.ref2_position_emp#<br/>
					#get_app.ref2_telcode_emp# #get_app.ref2_tel_emp# #get_app.ref2_email_emp#<br/>
			</td>
		</tr>
		</cfif>
		<cfif len(get_app.ref1)>
		<tr>
			<td valign="top">Referanslar 1:</td>
			<td>#get_app.ref1# #get_app.ref1_company#  #get_app.ref1_position#<br/>
				#get_app.ref1_telcode# #get_app.ref1_tel# #get_app.ref1_email#<br/>
			</td>
		</tr>
		</cfif>
		<cfif len(get_app.ref2)>
		<tr>
			<td valign="top">Referanslar 2:</td>
			<td>#get_app.ref2# #get_app.ref2_company#  #get_app.ref2_position#<br/>
				#get_app.ref2_telcode# #get_app.ref2_tel# #get_app.ref2_email#<br/>
			</td>
		</tr>
		</cfif> --->
		</table>
	</td>
</tr>
</table>
</cfoutput>
</cfif>
