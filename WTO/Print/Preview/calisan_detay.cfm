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
		EMPLOYEES.OZEL_KOD,
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
		EMPLOYEES.KIDEM_DATE,
		EMPLOYEES_DETAIL.HOMEPOSTCODE,
		EMPLOYEES_DETAIL.HOMECOUNTY,
		EMPLOYEES.GROUP_STARTDATE,
		EMPLOYEES_DETAIL.CHILD_0,
		EMPLOYEES.EMPLOYEE_ID,
		EMPLOYEES_DETAIL.HOMECITY,
		EMPLOYEES_DETAIL.HOMECOUNTRY,
		EMPLOYEES_DETAIL.DEFECTED_LEVEL,
		EMPLOYEES_DETAIL.DEFECTED,
		EMPLOYEES_DETAIL.SEX,
		EMPLOYEES_DETAIL.EMPLOYEE_ID,
		EMPLOYEES_IDENTY.MARRIED,
		EMPLOYEE_POSITIONS.POSITION_ID,
		EMPLOYEES.EMPLOYEE_EMAIL
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
	SELECT * FROM EMPLOYEES_APP_EDU_INFO WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">/*  EDU_TYPE NOT IN (1,2) */
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
<cfquery name="CHECK" datasource="#DSN#">
	SELECT 
		ASSET_FILE_NAME2,
		ASSET_FILE_NAME2_SERVER_ID,
	COMPANY_NAME
	FROM 
		OUR_COMPANY 
	WHERE 
		<cfif isdefined("attributes.our_company_id")>
		COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
		<cfelse>
		<cfif isDefined("session.ep.company_id") and len(session.ep.company_id)>
			COMP_ID = #session.ep.company_id#
		<cfelseif isDefined("session.pp.company_id") and len(session.pp.company_id)>  
			COMP_ID = #session.pp.company_id#
		<cfelseif isDefined("session.ww.our_company_id")>
			COMP_ID = #session.ww.our_company_id#
		<cfelseif isDefined("session.cp.our_company_id")>
			COMP_ID = #session.cp.our_company_id#
		</cfif> 
		</cfif> 
	</cfquery>
<br/>
<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">
<cfif GET_EMPLOYEE.RecordCount>
<cfoutput>
	<table style="width:210mm">
		<tr>
			<td>
				<table width="100%">
					<tr class="row_border">
						<td class="print-head">
							<table style="width:100%;">
								<tr>
									<td class="print_title"><cf_get_lang dictionary_id='55180.PERSONEL BİLGİ FORMU'></td>
										<td style="text-align:right;">
											<cfif len(check.asset_file_name2)>
											<cfset attributes.type = 1>
												<cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5">
											</cfif>
										</td>
									</td>
								</tr> 
							</table>
						</td>
					</tr>
					<tr class="row_border" class="row_border">
						<td>
							<table style="width:140mm">
								<!--- <tr>
									<td><cf_get_lang dictionary_id='31234.Kimlik Bilgileri'></td>
								</tr> --->
								<tr>
									<td><b><cf_get_lang dictionary_id='58487.Çalışan No'></b></td>
									<td>#get_employee.employee_no#</td>
									<!--- <td align="center" rowspan="9" colspan="2" >
									<cfif len(get_employee.photo)>
											<img src="#file_web_path#hr/#get_employee.photo#" border="1px" color="black" width="100px" height="100px" align="center">
										<cfelse>
											<cf_get_lang dictionary_id='25.Fotoğrafı'> <cf_get_lang dictionary_id='1134.Yok'> !
										</cfif> 
									</td> --->
									

									<td><b><cf_get_lang dictionary_id='57574.Şirket'></b></td>
									<td>#get_position.company_name#</td>
								</tr>
								<tr>
									<td><b><cf_get_lang dictionary_id='57789.Özel Kod'></b></td>
									<td>#get_employee.ozel_kod#</td>
									<td><b><cf_get_lang dictionary_id='29532.Şube Adı'></b></td>
									<td><cfloop query="get_position">#get_position.branch_name#</cfloop></td>
								</tr>
								<tr>
									<td><b><cf_get_lang dictionary_id='32370.Adı Soyadı'></b></td>
									<td>#get_employee.employee_name#&nbsp;#get_employee.employee_surname#</td>
									<td><b><cf_get_lang dictionary_id='57572.Departman'></b></td>
									<td><cfloop query="get_position">#get_position.department_head#</cfloop></td>
									
									<!--- <td>
									<cfif len(get_employee.group_startdate)>
										#TLFormat(DATEDIFF('D',dateformat(get_employee.group_startdate,dateformat_style),dateformat(now(),dateformat_style))/365)#
									</cfif>
									</td> --->
								</tr>
									<td><b><cf_get_lang dictionary_id='30978.Pozisyon'></b></td>
									<td><cfloop query="get_position">#get_position.position_name#</cfloop></td>
									<cfquery name="get_in_outs" datasource="#dsn#" maxrows="1">
										SELECT 
											START_DATE,
											FINISH_DATE 
										FROM 
											EMPLOYEES_IN_OUT 
										WHERE 
											EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
									</cfquery>
									<td><b><cf_get_lang dictionary_id='51232.İşe Giriş Tarihi'></b></td>
									<td><cfif len(get_in_outs.start_date)>#dateformat(get_in_outs.start_date,dateformat_style)#</cfif></td>
								
									<tr>
										<td><b><cf_get_lang dictionary_id='57571.Ünvanı'></b></td>
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
										<td><b><cf_get_lang dictionary_id='31287.İşten Çıkış Tarihi'></b></td>
											<cfquery name="get_in_outs" datasource="#dsn#" maxrows="1">
													SELECT 
														START_DATE,
														FINISH_DATE 
													FROM 
														EMPLOYEES_IN_OUT 
													WHERE 
														EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
											</cfquery>
										<td><cfif len(get_in_outs.finish_date)>#dateformat(get_in_outs.finish_date,dateformat_style)#</cfif></td>
										
									</tr>
									<!--- <tr>
										<td><b><cf_get_lang dictionary_id='31399.Kıdem'></b></td>
										<td>
										<cfif len(get_employee.kidem_date)>
											#TLFormat(DATEDIFF('D',dateformat(get_employee.kidem_date,dateformat_style),dateformat(now(),dateformat_style))/365)#
										</cfif>
										
									</tr> --->
								
								<!---<tr>
									<cfquery name="contract" datasource="#dsn#">
										SELECT 
											CONTRACT_DATE,
											CONTRACT_FINISHDATE
										FROM
											EMPLOYEES_CONTRACT
										WHERE
											EMPLOYEES_CONTRACT.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_employee.employee_id#">
									</cfquery>
									<td><b><cf_get_lang dictionary_id='1725.Sözleşme'> </b></td><cf_get_lang dictionary_id='89.Başlangıç'>/<cf_get_lang dictionary_id='288.Bitiş Tarihi'></b></td>
									<td>#dateformat(contract.contract_date,dateformat_style)# </td>- #dateformat(contract.contract_finishdate,dateformat_style)#</td> 
								</tr>--->
							</table>
						</td>
					</tr>
					<table>
						<tr>
							<td style="height:35px;"><b><cf_get_lang dictionary_id='31198.Kişisel Bilgiler'></b></td>
						</tr>
					</table>
					<table  class="print_border" style="width:100%;"> 
						<!--- <tr> --->
							<!--- <td><b><cf_get_lang dictionary_id="55218.Yabancı Dil Bilgisi"></b></td>
							<td> --->
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
							<td rowspan="4"><b><cf_get_lang dictionary_id='1311.Adresi'></b></td>
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
							<!--- </td> --->
						<!--- </tr> --->
						<tr>
							<td><b><cf_get_lang dictionary_id='58727.Doğum Tarihi'></b></td>
							<td><b><cf_get_lang dictionary_id='57790.Doğum yeri'></b></td>
							<td><b><cf_get_lang dictionary_id='58813.Cep Telefonu'></b></td>
							<td><b><cf_get_lang_main dictionary_id='58814.Ev Telefonu'></b></td>
							<td><b><cf_get_lang dictionary_id='30693.Medeni Hali'></b></td>
							<td><b><cf_get_lang dictionary_id='31109.Mail adresi'></b></td>
							<cfif Get_Employee.sex eq 1>
								<td><b><cf_get_lang dictionary_id='35141.Askerlik Durumu'></b></td>
							</cfif>
						</tr>
						<tr>
							<td>#dateformat(get_employee.birth_date,dateformat_style)# </td>
							<td>#get_employee.birth_place#</td>
							<td>#get_employee.mobilcode#&nbsp;#get_employee.mobiltel#</td>
							<td>#get_employee.hometel_code#&nbsp;#get_employee.hometel#</td>	
							<td><cfif get_employee.married eq 1><cf_get_lang dictionary_id='31204.evli'><cfelse><cf_get_lang dictionary_id='30694.bekar'></cfif></td>
							<td>#get_employee.employee_email#</td>
							<cfif Get_Employee.sex eq 1>
								<cfif get_employee.military_status eq 1>
								<td><cf_get_lang dictionary_id='58786.Tamamlandı'> <cfif len(get_employee.military_finishdate)>#dateformat(get_employee.military_finishdate,dateformat_style)#</td>
								</cfif>
								<cfelseif get_employee.military_status eq 2>
								<td><cf_get_lang dictionary_id='31212.Muaf'> </td>
								<cfelseif get_employee.military_status eq 3>
								<td><cf_get_lang dictionary_id='31213.Yabancı'></td>
								<cfelseif get_employee.military_status eq 4>
								<td><cf_get_lang dictionary_id='31214.Tecilli'> #get_employee.military_delay_reason# <cfif len(get_employee.military_delay_date)>#dateformat(get_employee.military_delay_date,dateformat_style)#</cfif></td>
								<cfelseif get_employee.military_status eq 0>
								<td><cf_get_lang dictionary_id='31210.Yapmadı'></td>
								</cfif>
							</cfif>
						</tr>
							<!--- <tr>
									<td><b><cf_get_lang dictionary_id='35266.Sakatlık Derecesi'></b></td>
									<td>
									<cfif get_employee.defected eq 0><cf_get_lang dictionary_id='58546.yok'></cfif>
									<cfif get_employee.defected eq 1>(%)#get_employee.defected_level#</cfif>
									</td>
								</tr> --->
								
								<!--- <td><b><cf_get_lang dictionary_id='33187.Ehliyet'> <cf_get_lang dictionary_id='169.Sınıfı'></b></td>
									<td><cfif len(get_employee.driver_licence_type)>#get_employee.driver_licence_type#<cfelse><cf_get_lang dictionary_id='58546.yok'></cfif> 
							</td> --->	
					</table>
						<!--- <table cellpadding="1" cellspacing="2">
							<tr>
							<cfif len(get_employee.last_school)>
								<cfquery name="get_education" datasource="#dsn#">
									SELECT 
										EDUCATION_NAME,
										EDU_LEVEL_ID
									FROM 
										SETUP_EDUCATION_LEVEL
									WHERE 
										SETUP_EDUCATION_LEVEL.EDU_LEVEL_ID = #get_employee.last_school#
								</cfquery>
							</cfif>
							--->
					<table>
						<td style="height:35px;"><b><cf_get_lang dictionary_id='30644.Eğitim Bilgileri'></b></td>
					</table>
					<table  class="print_border"  style="width:210mm;"> 
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
					
						<tr>
							<td><b><cf_get_lang dictionary_id='30645.Okul Adı'></b></td>
							<td><b><cf_get_lang dictionary_id='57995.Bölüm'></b></td>
							<td><b><cf_get_lang dictionary_id='31556.Giriş Yılı'></b></td>
							<td><b><cf_get_lang dictionary_id="31050.Mezuniyet Yılı"></b></td>
							<td ><b><cf_get_lang dictionary_id="35267.Mezuniyet Derecesi"></b></td>
						</tr>	
						<cfloop query="get_edu_info">
							<tr>
								<td><cfif get_employee.employee_id eq  Get_Edu_Info.employee_id >#Get_Edu_Info.EDU_NAME#</cfif></td>
								<td><cfif get_employee.employee_id eq  Get_Edu_Info.employee_id>#get_edu_info.EDU_PART_NAME#</cfif></td>
								<td><cfif get_employee.employee_id eq  Get_Edu_Info.employee_id>#get_edu_info.EDU_START#</cfif></td>
								<td><cfif get_employee.employee_id eq  Get_Edu_Info.employee_id>#get_edu_info.EDU_FINISH#</cfif></td>
								<td style="text-align:right;"><cfif get_employee.employee_id eq  Get_Edu_Info.employee_id>#get_edu_info.EDU_RANK#</cfif></td>
							</tr>
							</cfloop>
					
						<!--- 
							<td><cfif get_edu_info.edu_type eq 3>#get_edu_info.edu_rank#</cfif></td>
							<td><cfif get_edu_info.edu_type eq 4>#get_edu_info.edu_rank#</cfif></td>
							<td><cfif get_edu_info.edu_type eq 5>#get_edu_info.edu_rank#</cfif></td>
							<td><cfif get_edu_info.edu_type eq 6>#get_edu_info.edu_rank#</cfif></td>
							--->
					</table>
						<!---<table>
								<tr>
									<td style="height:35px;"><b><cf_get_lang dictionary_id='30644.Eğitim Bilgileri'></b></td>
								</tr>
							</table>
							<table  class="print_border" > 
								<tr> 
									<td><b><cf_get_lang dictionary_id='31326.Eğitim Durumu'>  <cfif len(get_employee.last_school) and get_education.recordcount and len(get_education.education_name)>#get_education.education_name#</cfif></b></td>
								
									<td style="width75px;"><b><cf_get_lang dictionary_id ='31551.Okul Türü'></b></td>
									<td style="width250px;"><b><cf_get_lang dictionary_id ='30645.Okul Adı'></b></td>
									<td style="width65px;"><b><cf_get_lang dictionary_id ='35159.Başl Yılı'></b></td>
									<td style="width65px;"><b><cf_get_lang dictionary_id ='31554.Bitiş Yılı'></b></td>
									<td style="width65px;"><b><cf_get_lang dictionary_id ='35157.Not Ort'></b></td>
									<td style="width250px;"><b><cf_get_lang dictionary_id='583.Bölüm'></b></td>
								</tr>
								<cfloop query="get_edu_info">
									<tr>
										<td>
											<cfset edu_type_id_control = "">
											<cfif len(edu_type)>
												<cfquery name="get_education_level_name" datasource="#dsn#">
													SELECT EDU_LEVEL_ID,EDUCATION_NAME,EDU_TYPE,EDU_PART_NAME FROM SETUP_EDUCATION_LEVEL WHERE EDU_LEVEL_ID =#edu_type#
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
							</table>
						--->
					<table>
						<tr>
							<td style="height:35px;"><b><cf_get_lang dictionary_id="31527.Deneyimler"></b></td>
						</tr>
					</table>
					<table  class="print_border" style="width:100%;" >
						<tr>
							<td><b><cf_get_lang dictionary_id='43106.Kurum Adı'></b></td>
							<td><b><cf_get_lang dictionary_id='57655.Başlama Tarihi'></b></td>
							<td><b><cf_get_lang dictionary_id='59405.Ayrılış Tarihi'></b></td>
							<td><b><cf_get_lang dictionary_id='30978.Pozisyon'></b></td>
							<td><b><cf_get_lang dictionary_id="55866.Çalışma Süresi">(<cf_get_lang dictionary_id="58455.yıl">)</b></td>
							
						</tr> 
						<cfloop query="get_work_info">
							<cfif len(get_work_info.EXP_START) and len(get_work_info.EXP_FINISH)><cfset d1=d1 + DATEDIFF('y',dateformat(get_work_info.EXP_START,'yyyy'),dateformat(get_work_info.EXP_FINISH,'yyyy'))></cfif>
						</cfloop>
						<tr>
							<cfloop query="get_work_info">
							<td><cfif len(EXP)>#get_work_info.EXP#</cfif></td>
							</cfloop>
							<cfloop query="get_work_info">
							<td><cfif len(get_work_info.EXP_START)>#dateformat(get_work_info.EXP_START,dateformat_style)#</cfif></td>
							</cfloop>
							<cfloop query="get_work_info">
							<td><cfif len(get_work_info.EXP_FINISH)>#dateformat(get_work_info.EXP_FINISH,dateformat_style)#</cfif></td>
							</cfloop>
							<cfloop query="get_work_info">
							<td><cfif len(get_work_info.EXP_POSITION)>#get_work_info.EXP_POSITION#</cfif></td>
							</cfloop>
							<cfloop query="get_work_info">
							<td style="text-align:right;">
								<cfif len(get_work_info.EXP_START)and len(get_work_info.EXP_FINISH)>
									<cfset d2= datediff('y',dateformat(get_work_info.EXP_START,'yyyy'),dateformat(get_work_info.EXP_FINISH,'yyyy'))> 
									#d2#
								</cfif>
							</td>
							</cfloop>
						</tr>
					</table>
						<!---
								<tr> 
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
							<tr class="row_border" class="row_border">
								<td>
									<table style="width:140mm">
											<tr>
											<td >
												<cf_get_lang dictionary_id='35268.Katıldığı Eğitim,Seminer ve Kurs'></td>
										</tr>
										<tr>
											<td><b><cf_get_lang dictionary_id="46956.Eğitim Türü"></b></td>
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
											<td >#get_trainer_class.class_name#</td>
										</tr>
										<tr>
											<td><b><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></b></td>
											<td >#dateformat(get_trainer_class.start_date,dateformat_style)#</td>
										</tr>
										<tr>
											<td><b><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></b></td>
											<td >#dateformat(get_trainer_class.finish_date,dateformat_style)#</td>
										</tr>
										<tr>
											<td><b><cf_get_lang dictionary_id='29513.Süre'>(<cf_get_lang dictionary_id='78.gün'>/<cf_get_lang dictionary_id='79.saat'>)</b></td>
											<td >#get_trainer_class.date_no#/#get_trainer_class.hour_no#</td>
										</tr>
										<tr>
											<td><b><cf_get_lang dictionary_id='31090.Eğitim Adı'></b></td>
											<td >#get_trainer_class.class_target#</td>
										</tr> --->
										<!--- <tr>
											<td><b><cf_get_lang dictionary_id='828.Eğitimci'>\<cf_get_lang dictionary_id='300.Kurum'></b></td>
											<td >&nbsp;</td>
										</tr> --->
								<!--- 	<cfelse>
										<table style="width:140mm">
										<tr>
											<td><cf_get_lang dictionary_id='35268.Katıldığı Eğitim,Seminer ve Kurs'></td>
											<td>eğitime katılmamıştır</td>
										</tr> --->
									<!--- </table>
										</cfif>
									</table>
								</td>
							</tr>		  --->
							<!--- 
								<tr class="row_border" class="row_border">
								<td>
									<table>
										<tr>
											<td colspan="9" height="20" ><strong><font color="##000066"><cf_get_lang dictionary_id="24.Çalışan Yakını"></font></strong></td>
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
										<tr>
											<td><b><cf_get_lang dictionary_id='158.Ad Soyad'></b></td>
											<td><b><cf_get_lang dictionary_id='1086.Yakınlık Derecesi'></b></td>
											<td><b><cf_get_lang dictionary_id='1315.Doğum Tarihi'></b></td>
											<td><b><cf_get_lang dictionary_id='378.Doğum Yeri'></b></td>
											<td><b><cf_get_lang dictionary_id='613.TC Kimlik No'></b></td>
											<td><b><cf_get_lang dictionary_id='7.Eğitim'></b></td>
											<td><b><cf_get_lang dictionary_id='409.Meslek'></b></td>
											<td><b><cf_get_lang dictionary_id='162.Şirket'></b></td>
											<td><b><cf_get_lang dictionary_id='1085.Pozisyon'></b></td>
										</tr>    
										<cfloop query="emp_relatives">
											<cfif RELATIVE_LEVEL eq 1><cfset relative_type = "Baba">
											<cfelseif RELATIVE_LEVEL eq 2><cfset relative_type = "Anne">
											<cfelseif RELATIVE_LEVEL eq 3><cfset relative_type = "Eşi">
											<cfelseif RELATIVE_LEVEL eq 4><cfset relative_type = "Oğlu">
											<cfelseif RELATIVE_LEVEL eq 5><cfset relative_type = "Kızı">
											<cfelseif RELATIVE_LEVEL eq 6><cfset relative_type = "Kardeşi">
											</cfif>
										<tr>
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
							</tr> --->
							<!--- 
								<tr>
								<tr class="row_border" class="row_border">
									<td>
									<table>
										<tr>
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
										<tr>
											<td><b><cf_get_lang dictionary_id='1085.Pozisyon'></b></td>
											<td><b><cf_get_lang dictionary_id='162.Şirket'></b></td>
											<td><b><cf_get_lang dictionary_id='41.Şube'></b></td>
											<td><b><cf_get_lang dictionary_id='160.Departman'></b></td>
											<td width="65"><b><cf_get_lang dictionary_id='89.Baslangıç'></b></td>
											<td width="65"><b><cf_get_lang dictionary_id='90.Bitiş'></b></td>
											<td width="65"><b><cf_get_lang dictionary_id='215.Kayıt Tarihi'></b></td>
										</tr>    
										<cfloop query="pos_history">
										<tr>
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
						--->
					<table>
						<tr class="fixed">
						<td  style="font-size:9px!important;" height="35"><b>© Copyright</b> <cfoutput>#check.COMPANY_NAME#</cfoutput> dışında kullanılamaz, paylaşılamaz.</td>
						</tr>
					</table>
				</table>
			</td>
		</tr>
	</table>
</cfoutput>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
