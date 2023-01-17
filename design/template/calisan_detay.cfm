<!--- standart calisan detay --->
<cf_get_lang_set module_name="hr"><!--- sayfanin en altinda kapanisi var --->
<cfset d4=0>
<cfset d3=0>
<cfset d2=0>
<cfset d1=0>
<cfset attributes.employee_id=attributes.iid>
<cfquery name="Get_Employee" datasource="#dsn#">
	SELECT 
		EMPLOYEES.EMPLOYEE_NO,
		EMPLOYEES.EMPLOYEE_NAME, 
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES.PHOTO,
		EMPLOYEES_DETAIL.LAST_SCHOOL,
		EMPLOYEES_IDENTY.BIRTH_DATE,
		EMPLOYEES_IDENTY.BIRTH_PLACE,
		EMPLOYEES_DETAIL.STARTDATE,
		EMPLOYEES_DETAIL.MILITARY_FINISHDATE,
		EMPLOYEES_DETAIL.MILITARY_DELAY_REASON,
		EMPLOYEES_DETAIL.MILITARY_DELAY_DATE,
		EMPLOYEES_DETAIL.MILITARY_STATUS,
		EMPLOYEES_DETAIL.PARTNER_POSITION,
		EMPLOYEES_DETAIL.HOMEADDRESS,
		EMPLOYEES_DETAIL.HOMETEL,
		EMPLOYEES_DETAIL.HOMETEL_CODE,
		EMPLOYEES.MOBILCODE,
		EMPLOYEES.MOBILTEL,
		EMPLOYEES_DETAIL.HOMEPOSTCODE,
		EMPLOYEES_DETAIL.HOMECOUNTY,
		EMPLOYEES.GROUP_STARTDATE,
		EMPLOYEES_DETAIL.CHILD_0,
		EMPLOYEES.EMPLOYEE_ID,
		EMPLOYEES_DETAIL.HOMECITY,
		EMPLOYEES_DETAIL.HOMECOUNTRY,
		EMPLOYEES_DETAIL.DEFECTED_LEVEL,
		EMPLOYEES_DETAIL.DEFECTED,
	    EMPLOYEES_IDENTY.MARRIED,
        EMPLOYEE_POSITIONS.POSITION_ID
	FROM 
		EMPLOYEES, 
		EMPLOYEES_DETAIL,
		EMPLOYEES_IDENTY,
        EMPLOYEE_POSITIONS
	WHERE 
		EMPLOYEES.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND 
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_DETAIL.EMPLOYEE_ID AND
        EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID AND
		EMPLOYEES_IDENTY.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID 
</cfquery>
<cfquery name="Get_Work_Info" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_APP_WORK_INFO WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
</cfquery>
<cfquery name="Get_Edu_Info" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_APP_EDU_INFO WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND EDU_TYPE NOT IN (1,2)
</cfquery>
<cfquery name="Get_Position" datasource="#dsn#">
	SELECT 
		EMPLOYEE_POSITIONS.POSITION_NAME,
		EMPLOYEE_POSITIONS.TITLE_ID,
		DEPARTMENT.DEPARTMENT_HEAD,
		BRANCH.BRANCH_NAME,
		OUR_COMPANY.COMPANY_NAME
	FROM
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		BRANCH,
		OUR_COMPANY
	WHERE
		EMPLOYEE_POSITIONS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
		EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND 
		BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID 
</cfquery>
<br/>
<cfif GET_EMPLOYEE.RecordCount>
<cfoutput>
<table cellSpacing="0" cellpadding="0" border="0" width="750" align="center">
	<tr>
		<td>
			<table cellspacing="1" cellpadding="2">
				<tr bgcolor="##CCCCCC">
					<td align="center" colspan="4" height="20"><strong><font color="##000066"><cf_get_lang no="95.PERSONEL BİLGİ FORMU"></font></strong></td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td height="20" colspan="4"></td>
				</tr>
				<tr bgcolor="##CCCCCC">
					<td colspan="4" height="20"><strong><font color="##000066"><cf_get_lang no='42.Kimlik Bilgileri'></font></strong></td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang_main no='1075.Çalışan No'>:</b></td>
					<td>#get_employee.employee_no#</td>
					<td align="center" rowspan="9" width="150"colspan="2">
						<cfif len(get_employee.photo)>
							<img src="#file_web_path#hr/#get_employee.photo#" border="0" width="120" height="160" align="center">
						<cfelse>
							<cf_get_lang no='25.Fotoğrafı'> <cf_get_lang_main no='1134.Yok'> !
						</cfif>
					</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang no='672.Adı Soyadı'>:</b></td>
					<td width="225">#get_employee.employee_name#&nbsp;#get_employee.employee_surname#</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang_main no='1085.Pozisyon'>:</b></td>
					<td width="225"><cfloop query="get_position">#get_position.position_name#,</cfloop></td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang_main no='162.Şirket'>:</b></td>
					<td width="225">#get_position.company_name#</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang_main no='41.Şube'>:</b></td>
					<td width="225"><cfloop query="get_position">#get_position.branch_name#,</cfloop></td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang_main no='160.Departman'>:</b></td>
					<td width="225"><cfloop query="get_position">#get_position.department_head#,</cfloop></td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang_main no='159.Ünvanı'>:</b></td>
					<td>
					<cfif len(get_position.title_id)>
						<cfquery name="unvan" datasource="#dsn#">
							SELECT 
								TITLE_ID,
								TITLE
							FROM
								SETUP_TITLE
							WHERE
								TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_position.title_id#">
						</cfquery>
						#unvan.title#
					</cfif>
					</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang no='1545.Kıdem'>:</b></td>
					<td width="225">
					<cfif len(get_employee.group_startdate)>
						#TLFormat(DATEDIFF('D',dateformat(get_employee.group_startdate,dateformat_style),dateformat(now(),dateformat_style))/365)#
					</cfif>
					</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<cfquery name="get_in_outs" datasource="#dsn#" maxrows="1">
						SELECT 
							START_DATE,
							FINISH_DATE 
						FROM 
							EMPLOYEES_IN_OUT 
						WHERE 
							EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
					</cfquery>
					<td width="150"><b><cf_get_lang no='1458.İşe Giriş Tarihi'>/<cf_get_lang no='432.Ayrılış Tarihi:'></b></td>
					<td width="225"><cfif len(get_in_outs.start_date)>#dateformat(get_in_outs.start_date,dateformat_style)#</cfif> - <cfif len(get_in_outs.finish_date)>#dateformat(get_in_outs.finish_date,dateformat_style)#</cfif></td>
				</tr>
					<cfquery name="contract" datasource="#dsn#">
						SELECT 
							CONTRACT_DATE,
							CONTRACT_FINISHDATE
						FROM
							EMPLOYEES_CONTRACT
						WHERE
							EMPLOYEES_CONTRACT.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_employee.employee_id#">
					</cfquery>
				<!--- <tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang_main no='1725.Sözleşme'> <cf_get_lang_main no='89.Başlangıç'>/<cf_get_lang_main no='288.Bitiş Tarihi'>:</b></td>
					<td colspan="4">#dateformat(contract.contract_date,dateformat_style)# - #dateformat(contract.contract_finishdate,dateformat_style)#</td>
				</tr> --->
				<tr bgcolor="##CCCCCC">
					<td colspan="4" height="20"><strong><font color="##000066"><cf_get_lang no='41.Kişisel Bilgiler'></font></strong></td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang no="133.Yabancı Dil Bilgisi">:</b></td>
					<td width="225">
					<!--- <cfif len(get_employee.lang1)>
						<cfquery name="lang" datasource="#dsn#">
							SELECT 
								LANGUAGE_SET
							FROM 
								SETUP_LANGUAGES
							WHERE 
								LANGUAGE_ID = #get_employee.lang1#
						</cfquery>
							#lang.language_set#
					</cfif>
					<cfif len(get_employee.lang2)>
						<cfquery name="lang" datasource="#dsn#">
							SELECT 
								LANGUAGE_SET
							FROM 
								SETUP_LANGUAGES
							WHERE 
								LANGUAGE_ID = #get_employee.lang2#
						</cfquery>
						,#lang.language_set#
					</cfif>
					<cfif len(get_employee.lang3)>
						<cfquery name="lang" datasource="#dsn#">
							SELECT 
								LANGUAGE_SET
							FROM 
								SETUP_LANGUAGES
							WHERE 
								LANGUAGE_ID = #get_employee.lang3#
						</cfquery>
						,#lang.language_set#
					</cfif>
					<cfif len(get_employee.lang4)>
						<cfquery name="lang" datasource="#dsn#">
							SELECT 
								LANGUAGE_SET
							FROM 
								SETUP_LANGUAGES
							WHERE 
								LANGUAGE_ID = #get_employee.lang4#
						</cfquery>
						,#lang.language_set#
					</cfif>
					<cfif len(get_employee.lang5)>
						<cfquery name="lang" datasource="#dsn#">
							SELECT 
								LANGUAGE_SET
							FROM 
								SETUP_LANGUAGES
							WHERE 
								LANGUAGE_ID = #get_employee.lang5#
						</cfquery>
						,#lang.language_set#
					</cfif>
					</td>
					<td rowspan="4"><b><cf_get_lang_main no='1311.Adresi'>:</b></td>
					<td rowspan="4">#get_employee.homeaddress#&nbsp;#get_employee.homepostcode#&nbsp;#get_employee.homecounty#&nbsp;
					<cfif len(get_employee.homecity)>
						<cfquery name="city" datasource="#dsn#">
							SELECT 
								CITY_NAME
							FROM 
								SETUP_CITY
							WHERE 
								SETUP_CITY.CITY_ID = #get_employee.homecity#
						</cfquery>
						#city.city_name#
					</cfif>&nbsp;
					<cfif len(get_employee.homecountry)>
						<cfquery name="country" datasource="#dsn#">
							SELECT 
								COUNTRY_NAME
							FROM
								SETUP_COUNTRY
							WHERE 
								SETUP_COUNTRY.COUNTRY_ID = #get_employee.homecountry# 
						</cfquery>
						#country.country_name#
					</cfif> --->
					</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang_main no='1315.Doğum Tarihi'>/<cf_get_lang_main no='1252.Yeri'>:</b></td>
					<td width="225">#dateformat(get_employee.birth_date,dateformat_style)# - #get_employee.birth_place#</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang no='1460.Askerlik Durumu'>:</b></td>
					<td width="225">
					<cfif get_employee.military_status eq 1> 
					<cf_get_lang_main no='1374.Tamamlandı'> <cfif len(get_employee.military_finishdate)>#dateformat(get_employee.military_finishdate,dateformat_style)#
					</cfif>
					<cfelseif get_employee.military_status eq 2>
					<cf_get_lang no='541.Muaf'> 
					<cfelseif get_employee.military_status eq 3>
					<cf_get_lang no='542.Yabancı'>
					<cfelseif get_employee.military_status eq 4>
					<cf_get_lang no='255.Tecilli'> #get_employee.military_delay_reason# <cfif len(get_employee.military_delay_date)>#dateformat(get_employee.military_delay_date,dateformat_style)#</cfif>
					<cfelseif get_employee.military_status eq 0>
					<cf_get_lang no='539.Yapmadı'>
					</cfif>
					</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang no='1349.Sakatlık Derecesi'>(%):</b></td>
					<td width="225">
					<cfif get_employee.defected eq 0><cf_get_lang_main no='1134.yok'></cfif>
					<cfif get_employee.defected eq 1>#get_employee.defected_level#</cfif>
					</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang no='249.Ehliyet'> <cf_get_lang no='169.Sınıfı'>:</b></td>
					<td width="225"><!--- #get_employee.driver_licence_type# ---></td>
					<td width="150"><b><cf_get_lang_main no='1402.Ev Telefonu'>:</b></td>
					<td width="225">#get_employee.hometel_code#&nbsp;#get_employee.hometel#</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang no='1440.Medeni Hali'>:</b></td>
					<td width="225"><cfif get_employee.married eq 1><cf_get_lang no='658.evli'><cfelse><cf_get_lang no='659.bekar'></cfif></td>
					<td width="150"><b><cf_get_lang_main no='1401.Cep Telefonu'>:</b></td>
					<td width="225">#get_employee.mobilcode#&nbsp;#get_employee.mobiltel#</td>
				</tr>
			</table>
		</td>	
	</tr>
	<tr>
		<td colspan="4" width="100%">
			<table cellpadding="1" cellspacing="2">
				<!--- <tr bgcolor="##CCCCCC">
				<cfif len(get_employee.last_school)>
					<cfquery name="get_education" datasource="#dsn#">
						SELECT 
							EDUCATION_NAME,EDU_LEVEL_ID
						FROM 
							SETUP_EDUCATION_LEVEL
						WHERE 
							SETUP_EDUCATION_LEVEL.EDU_LEVEL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_employee.last_school#">
					</cfquery>
				</cfif>
					<td colspan="5" height="20"><strong><font color="##000066"><cf_get_lang no='654.Eğitim Bilgileri'></font> &nbsp;&nbsp;[<cf_get_lang no='410.Eğitim Durumu'> : <cfif len(get_employee.last_school) and get_education.recordcount and len(get_education.education_name)>#get_education.education_name#</cfif>]</strong></td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"></td>
					<td width="150"><strong><cf_get_lang no='595.Lise'></strong></td>
					<td width="150"><strong><cf_get_lang_main no='1958.Üniversite'></strong></td>
					<td width="150"><strong><cf_get_lang no='597.Yüksek Lisans'></strong></td>
					<td width="150"><strong><cf_get_lang no='248.Doktora'></strong></td>
				</tr>
				<tr bgcolor="##FFFFFF">
				<cfset okul=0>
					<td width="150"><b><cf_get_lang_main no='7.Eğitim'> <cf_get_lang_main no='300.Kurumu'></b></td>
					<cfloop query="get_edu_info">
						<td><cfif get_edu_info.edu_type eq 3>#get_edu_info.edu_name#</cfif></td>
						<td><cfif get_edu_info.edu_type eq 4>#get_edu_info.edu_name#</cfif></td>
						<td><cfif get_edu_info.edu_type eq 5>#get_edu_info.edu_name#</cfif></td>
						<td><cfif get_edu_info.edu_type eq 6>#get_edu_info.edu_name#</cfif></td>
					</cfloop>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang_main no='583.Bölüm'></b></td>
					<cfloop query="get_edu_info">
						<td><cfif get_edu_info.edu_type eq 3>#get_edu_info.edu_part_name#</cfif></td>
						<td><cfif get_edu_info.edu_type eq 4>#get_edu_info.edu_part_name#</cfif></td>
						<td><cfif get_edu_info.edu_type eq 5>#get_edu_info.edu_part_name#</cfif></td>
						<td><cfif get_edu_info.edu_type eq 6>#get_edu_info.edu_part_name#</cfif></td>
					</cfloop>
					
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang no='1411.Giriş Yılı'></b></td>
					<cfloop query="get_edu_info">
						<td><cfif get_edu_info.edu_type eq 3>#get_edu_info.edu_start#</cfif></td>
						<td><cfif get_edu_info.edu_type eq 4>#get_edu_info.edu_start#</cfif></td>
						<td><cfif get_edu_info.edu_type eq 5>#get_edu_info.edu_start#</cfif></td>
						<td><cfif get_edu_info.edu_type eq 6>#get_edu_info.edu_start#</cfif></td>
					</cfloop>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang no="760.Mezuniyet Yılı"></b></td>
					<cfloop query="get_edu_info">
						<td><cfif get_edu_info.edu_type eq 3>#get_edu_info.edu_finish#</cfif></td>
						<td><cfif get_edu_info.edu_type eq 4>#get_edu_info.edu_finish#</cfif></td>
						<td><cfif get_edu_info.edu_type eq 5>#get_edu_info.edu_finish#</cfif></td>
						<td><cfif get_edu_info.edu_type eq 6>#get_edu_info.edu_finish#</cfif></td>
					</cfloop>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang no="788.Mezuniyet Derecesi"></b></td>
					<cfloop query="get_edu_info">
						<td><cfif get_edu_info.edu_type eq 3>#get_edu_info.edu_rank#</cfif></td>
						<td><cfif get_edu_info.edu_type eq 4>#get_edu_info.edu_rank#</cfif></td>
						<td><cfif get_edu_info.edu_type eq 5>#get_edu_info.edu_rank#</cfif></td>
						<td><cfif get_edu_info.edu_type eq 6>#get_edu_info.edu_rank#</cfif></td>
					</cfloop>
				</tr> --->
                				<tr bgcolor="##CCCCCC">
				<cfif len(get_employee.last_school)>
					<cfquery name="get_education" datasource="#dsn#">
						SELECT 
							EDUCATION_NAME,EDU_LEVEL_ID
						FROM 
							SETUP_EDUCATION_LEVEL
						WHERE 
							SETUP_EDUCATION_LEVEL.EDU_LEVEL_ID = #get_employee.last_school#
					</cfquery>
				</cfif>
					<td colspan="6" height="20"><strong><font color="##000066"><cf_get_lang no='654.Eğitim Bilgileri'></font> &nbsp;&nbsp;[<cf_get_lang no='410.Eğitim Durumu'> : <cfif len(get_employee.last_school) and get_education.recordcount and len(get_education.education_name)>#get_education.education_name#</cfif>]</strong></td>
				</tr>
                <tr bgcolor="##FFFFFF">
                    <td style="width:75px;"><b><cf_get_lang no ='1396.Okul Türü'></b></td>
                    <td style="width:250px;"><b><cf_get_lang no ='1397.Okul Adı'></b></td>
                    <td style="width:65px;"><b><cf_get_lang no ='1398.Başl Yılı'></b></td>
                    <td style="width:65px;"><b><cf_get_lang no ='1399.Bitiş Yılı'></b></td>
                    <td style="width:65px;"><b><cf_get_lang no ='1068.Not Ort'></b></td>
                    <td style="width:250px;"><b><cf_get_lang_main no='583.Bölüm'></b></td>
                </tr>
                <cfloop query="get_edu_info">
                    <tr bgcolor="FFFFFF">
                        <td>
                            <cfset edu_type_id_control = "">
                            <cfif len(edu_type)>
                                <cfquery name="get_education_level_name" datasource="#dsn#">
                                    SELECT EDU_LEVEL_ID,EDUCATION_NAME,EDU_TYPE FROM SETUP_EDUCATION_LEVEL WHERE EDU_LEVEL_ID =#edu_type#
                                </cfquery>
                                #get_education_level_name.education_name#
                                <cfset edu_type_id_control = get_education_level_name.EDU_TYPE>								
                            </cfif>	
                        </td>	
                        <td>
                            <cfif len(edu_id) and edu_id neq -1>
                                <cfquery name="get_unv_name" datasource="#dsn#">
                                    SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_ID = #edu_id#
                                </cfquery>
                                #get_unv_name.SCHOOL_NAME#
                            <cfelse>
                                #edu_name#
                            </cfif>
                        </td>	
                        <td>#edu_start#</td>		
                        <td>#edu_finish#</td>		
                        <td>#edu_rank#</td>		
                        <td>
                            <cfif (len(edu_part_id) and edu_part_id neq -1)>
                                <cfif edu_type_id_control eq 2><!--- edu_type lise ise--->
                                    <cfquery name="get_high_school_part_name" datasource="#dsn#">
                                        SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART WHERE HIGH_PART_ID = #edu_part_id#
                                    </cfquery>
                                    #get_high_school_part_name.HIGH_PART_NAME#
                                <cfelseif listfind('2',edu_type_id_control)> <!--- üniversite ise--->
                                    <cfquery name="get_school_part_name" datasource="#dsn#">
                                        SELECT PART_ID, PART_NAME FROM SETUP_SCHOOL_PART WHERE PART_ID = #edu_part_id#
                                    </cfquery>
                                    #get_school_part_name.PART_NAME#
                                </cfif>
                            <cfelseif len(edu_part_name)>
                                #edu_part_name#
                            </cfif>
                        </td>		
                    </tr>
                </cfloop>
				<cfloop query="get_work_info">
					<cfif len(get_work_info.EXP_START) and len(get_work_info.EXP_FINISH)><cfset d1=d1 + DATEDIFF('y',dateformat(get_work_info.EXP_START,'yyyy'),dateformat(get_work_info.EXP_FINISH,'yyyy'))></cfif>
				</cfloop>
				<tr bgcolor="##CCCCCC">
					<td colspan="6" height="20"><strong><font color="##000066"><cf_get_lang no="1530.Deneyimler"> &nbsp;&nbsp;[<cf_get_lang no="781.Toplam Çalışma Süresi">:#d1#]</font></strong></td>
				</tr>
                <tr>
                	<td colspan="6">
                    <table cellpadding="0" cellspacing="0" width="100%">
                        <tr bgcolor="##FFFFFF">
                            <td><b><cf_get_lang_main no='300.Kurum'> <cf_get_lang_main no='485.Adı'>:</b></td>
                            <cfloop query="get_work_info">
                            <td><cfif len(EXP)>#get_work_info.EXP#</cfif></td>
                            </cfloop>
                        </tr>
                        <tr bgcolor="##FFFFFF">
                            <td><b><cf_get_lang no='69.Başlama Tarihi'>:</b></td>
                            <cfloop query="get_work_info">
                            <td><cfif len(get_work_info.EXP_START)>#dateformat(get_work_info.EXP_START,dateformat_style)#</cfif></td>
                            </cfloop>
                        </tr>
                        <tr bgcolor="##FFFFFF">
                            <td><b><cf_get_lang no='432.Ayrılış Tarihi'>:</b></td>
                            <cfloop query="get_work_info">
                            <td><cfif len(get_work_info.EXP_FINISH)>#dateformat(get_work_info.EXP_FINISH,dateformat_style)#</cfif></td>
                            </cfloop>
                        </tr>
                        <tr bgcolor="##FFFFFF">
                            <td><b><cf_get_lang_main no='159.Ünvan'>:</b></td>
                            <cfloop query="get_work_info">
                            <td><cfif len(get_work_info.EXP_POSITION)>#get_work_info.EXP_POSITION#</cfif></td>
                            </cfloop>
                        </tr>
                        <tr bgcolor="##FFFFFF">
                            <td><b><cf_get_lang no="792.Çalışma Süresi">(<cf_get_lang_main no="1043.yıl">):</b></td>
                            <cfloop query="get_work_info">
                            <td>
                                <cfif len(get_work_info.EXP_START)and len(get_work_info.EXP_FINISH)>
                                    <cfset d2= datediff('y',dateformat(get_work_info.EXP_START,'yyyy'),dateformat(get_work_info.EXP_FINISH,'yyyy'))> 
                                    #d2#
                                </cfif>
                            </td>
                            </cfloop>
                        </tr>
                    </table>
               		</td>
                </tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="4" width="100%">
			<table cellpadding="1" cellspacing="2" width="100%">
				<tr bgcolor="##CCCCCC">
					<td colspan="5" height="20"><strong><font color="##000066"><cf_get_lang no='881.Katıldığı Eğitim'>,<cf_get_lang no="794.Seminer ve Kurs"></font></strong></td>
				</tr>
				<cfquery name="egitim" datasource="#dsn#">
					SELECT
						EMP_ID,
						CLASS_ID
					FROM
						TRAINING_CLASS_ATTENDER
					WHERE 
						TRAINING_CLASS_ATTENDER.EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_employee.employee_id#">
				</cfquery>
				<cfif egitim.recordcount>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang no="793.Eğitim Türü">:</b></td>
						<cfquery name="get_trainer_class" datasource="#dsn#">
							SELECT 
								TRAINING_CLASS.CLASS_NAME,
								TRAINING_CLASS.CLASS_TARGET,
								TRAINING_CLASS.START_DATE,
								TRAINING_CLASS.FINISH_DATE,
								TRAINING_CLASS.DATE_NO,
								TRAINING_CLASS.HOUR_NO
							FROM
								TRAINING_CLASS
							WHERE 
								TRAINING_CLASS.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#egitim.class_id#">
						</cfquery>
					<td colspan="3" align="left">#get_trainer_class.class_name#</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang_main no='641.Başlangıç Tarihi'>:</b></td>
					<td colspan="3" align="left">#dateformat(get_trainer_class.start_date,dateformat_style)#</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang_main no='288.Bitiş Tarihi'>:</b></td>
					<td colspan="3" align="left">#dateformat(get_trainer_class.finish_date,dateformat_style)#</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td><b><cf_get_lang_main no='1716.Süre'>(<cf_get_lang_main no='78.gün'>/<cf_get_lang_main no='79.saat'>):</b></td>
					<td colspan="3" align="left">#get_trainer_class.date_no#/#get_trainer_class.hour_no#</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang_main no='7.Eğitim'> <cf_get_lang_main no='485.Adı'>:</b></td>
					<td colspan="3" align="left">#get_trainer_class.class_target#</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang no='828.Eğitimci'>\<cf_get_lang_main no='300.Kurum'>:</b></td>
					<td colspan="3" align="left">&nbsp;</td>
				</tr>
				</cfif>
			</table>
		</td>
	</tr>		 
	<tr>
		<td colspan="4" width="100%">
			<table cellpadding="1" cellspacing="2" width="100%">
				<tr bgcolor="##CCCCCC">
					<td colspan="9" height="20" ><strong><font color="##000066"><cf_get_lang no="24.Çalışan Yakını"></font></strong></td>
				</tr>
                <cfquery name="emp_relatives" datasource="#dsn#">
                    SELECT
                        RELATIVE_LEVEL,
                        NAME,
                        SURNAME,
                        BIRTH_DATE,
                        BIRTH_PLACE,
                        TC_IDENTY_NO,
                        EDUCATION,
                        JOB,
                        COMPANY,
                        JOB_POSITION
                    FROM
                        EMPLOYEES_RELATIVES
                    WHERE
                        EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">
                    ORDER BY
                        BIRTH_DATE,NAME,SURNAME,RELATIVE_LEVEL
                </cfquery>
				<cfif emp_relatives.recordcount>
				<tr bgcolor="##FFFFFF">
					<td><b><cf_get_lang_main no='158.Ad Soyad'></b></td>
					<td><b><cf_get_lang no='1086.Yakınlık Derecesi'></b></td>
					<td><b><cf_get_lang_main no='1315.Doğum Tarihi'></b></td>
					<td><b><cf_get_lang_main no='378.Doğum Yeri'></b></td>
					<td><b><cf_get_lang_main no='613.TC Kimlik No'></b></td>
					<td><b><cf_get_lang_main no='7.Eğitim'></b></td>
					<td><b><cf_get_lang no='409.Meslek'></b></td>
					<td><b><cf_get_lang_main no='162.Şirket'></b></td>
					<td><b><cf_get_lang_main no='1085.Pozisyon'></b></td>
				</tr>    
				<cfloop query="emp_relatives">
					<cfif RELATIVE_LEVEL eq 1><cfset relative_type = "Baba">
					<cfelseif RELATIVE_LEVEL eq 2><cfset relative_type = "Anne">
					<cfelseif RELATIVE_LEVEL eq 3><cfset relative_type = "Eşi">
					<cfelseif RELATIVE_LEVEL eq 4><cfset relative_type = "Oğlu">
					<cfelseif RELATIVE_LEVEL eq 5><cfset relative_type = "Kızı">
					<cfelseif RELATIVE_LEVEL eq 6><cfset relative_type = "Kardeşi">
					</cfif>
				<tr bgcolor="##FFFFFF">
					<td>#NAME#&nbsp;#SURNAME#</td>
					<td>#relative_type#</td>
					<td>#DateFormat(BIRTH_DATE,dateformat_style)#</td>
					<td>#BIRTH_PLACE#</td>
					<td>#TC_IDENTY_NO#</td>
					<td>			
						<cfif len(EDUCATION)>
                            <cfquery name="GET_EDUCATION" datasource="#DSN#">
                                SELECT EDUCATION_NAME FROM SETUP_EDUCATION_LEVEL WHERE EDU_LEVEL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#EDUCATION#">
                            </cfquery>
							#GET_EDUCATION.EDUCATION_NAME#
						</cfif>
					</td>
					<td>#JOB#</td>
					<td>#COMPANY#</td>
					<td>#JOB_POSITION#</td>
				</tr>
				</cfloop>
				</cfif>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="4" width="100%">
			<table cellpadding="1" cellspacing="2" width="100%">
				<tr bgcolor="##CCCCCC">
					<td colspan="7" height="20" ><strong><font color="##000066">Görev Değişiklikleri</font></strong></td>
				</tr>
					<cfquery name="pos_history" datasource="#dsn#">
						SELECT 
							EMPLOYEE_POSITIONS_CHANGE_HISTORY.POSITION_NAME,
							EMPLOYEE_POSITIONS_CHANGE_HISTORY.START_DATE,
							EMPLOYEE_POSITIONS_CHANGE_HISTORY.FINISH_DATE,
							EMPLOYEE_POSITIONS_CHANGE_HISTORY.RECORD_DATE,
							OUR_COMPANY.NICK_NAME, 
							DEPARTMENT.DEPARTMENT_HEAD,
							BRANCH.BRANCH_NAME 
						FROM 
							EMPLOYEE_POSITIONS_CHANGE_HISTORY,
							OUR_COMPANY,
							DEPARTMENT,
							BRANCH
						WHERE 
							EMPLOYEE_POSITIONS_CHANGE_HISTORY.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_employee.employee_id#">
                            AND EMPLOYEE_POSITIONS_CHANGE_HISTORY.POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_employee.position_id#">
							AND EMPLOYEE_POSITIONS_CHANGE_HISTORY.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
							AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
							AND BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
					</cfquery>
				<cfif pos_history.recordcount>
				<tr bgcolor="##FFFFFF">
					<td><b><cf_get_lang_main no='1085.Pozisyon'></b></td>
					<td><b><cf_get_lang_main no='162.Şirket'></b></td>
					<td><b><cf_get_lang_main no='41.Şube'></b></td>
					<td><b><cf_get_lang_main no='160.Departman'></b></td>
					<td width="65"><b><cf_get_lang_main no='89.Baslangıç'></b></td>
					<td width="65"><b><cf_get_lang_main no='90.Bitiş'></b></td>
					<td width="65"><b><cf_get_lang_main no='215.Kayıt Tarihi'></b></td>
				</tr>    
				<cfloop query="pos_history">
				<tr bgcolor="##FFFFFF">
					<td>#POSITION_NAME#</td>
					<td>#NICK_NAME#</td>
					<td>#BRANCH_NAME#</td>
					<td>#DEPARTMENT_HEAD#</td>
					<td>#dateformat(START_DATE,dateformat_style)#</td>
					<td>#dateformat(FINISH_DATE,dateformat_style)#</td>
					<td>#dateformat(RECORD_DATE,dateformat_style)#</td>
				</tr>
				</cfloop>
				</cfif>
			</table>
		</td>
	</tr>
</table>
</cfoutput>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
