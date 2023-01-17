<cfquery name="GET_EMPLOYEE" datasource="#dsn#">
	SELECT 
		EMPLOYEES.EMPLOYEE_NAME, 
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES.PHOTO,
		EMPLOYEES_DETAIL.LAST_SCHOOL,
		EMPLOYEES_DETAIL.STARTDATE,
		EMPLOYEES.EMPLOYEE_ID
	FROM 
		EMPLOYEES, 
		EMPLOYEES_DETAIL,
		EMPLOYEES_IDENTY
	WHERE 
		EMPLOYEES.EMPLOYEE_ID =#attributes.employee_id# AND 
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_DETAIL.EMPLOYEE_ID AND
		EMPLOYEES_IDENTY.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID 
</cfquery>
<cfquery name="get_position" datasource="#dsn#">
	SELECT 
		EMPLOYEE_POSITIONS.POSITION_NAME,
		EMPLOYEE_POSITIONS.UPPER_POSITION_CODE,
		EMPLOYEE_POSITIONS.POSITION_CODE,
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
		EMPLOYEE_POSITIONS.EMPLOYEE_ID = #attributes.employee_id# AND
		EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND 
		BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID 
</cfquery>
<cfquery name="get_edu_info" datasource="#dsn#">
	SELECT 
		*
	FROM
		EMPLOYEES_APP_EDU_INFO
	WHERE
		EMPLOYEE_ID = #attributes.employee_id# AND
		EDU_TYPE NOT IN (1,2)
	ORDER BY EDU_START ASC
</cfquery>
<cfquery name="get_work_info" datasource="#DSN#" maxrows="3">
	SELECT
		*
	FROM
		EMPLOYEES_APP_WORK_INFO
	WHERE
		EMPLOYEE_ID = #attributes.employee_id#
	ORDER BY EXP_START DESC
</cfquery>
<cfquery name="get_emp_in_out" datasource="#dsn#" maxrows="1">
		SELECT START_DATE FROM EMPLOYEES_IN_OUT EI WHERE EI.EMPLOYEE_ID = #attributes.employee_id# ORDER BY START_DATE DESC
</cfquery>
<cfif get_position.recordcount>
	<cfquery name="get_upper" datasource="#dsn#">
		SELECT * FROM EMPLOYEE_POSITIONS WHERE UPPER_POSITION_CODE  = #get_position.POSITION_CODE#
	</cfquery>
</cfif>
<cfif GET_EMPLOYEE.recordcount>
	<cfoutput>
		<table cellSpacing="0" cellpadding="0" border="0" width="98%" align="center">
			<tr>
			<td>
					<table cellspacing="1" cellpadding="2" border="0" width="96%">
						<tr>
							<td colspan="2" style="height:10px;"></td>
						</tr>
						<tr>
							<td align="center" rowspan="6" colspan="2" style="border-right:1px solid ##000000;">
							<cfif len(get_employee.photo)>
							<img src="#file_web_path#hr/#get_employee.photo#" border="0" width="100" height="120" align="center">
							<cfelse>
							<cf_get_lang dictionary_id ='31928.Fotoğrafı Yok'> !&nbsp;
							</cfif>
						</td>
						</tr>
						<tr>
							<td width="121" height="24"><cf_get_lang dictionary_id ='57570.Adı Soyadı'></td>
							<td width="70%">&nbsp;: #get_employee.EMPLOYEE_NAME# #get_employee.EMPLOYEE_SURNAME#</td>
						</tr>
						<tr>
							<td width="121" height="24"><cf_get_lang dictionary_id ='57571.Ünvanı'></td>
							<td>&nbsp;: #get_position.POSITION_NAME#</td>
						</tr>
						<tr>
							<td width="121" height="24"><cf_get_lang dictionary_id='57995.Bölümü'></td>
							<td>&nbsp;: #get_position.DEPARTMENT_HEAD#</td>
						</tr>
						<tr>
							<td width="121" height="24"><cf_get_lang dictionary_id ='31929.İlk Amiri'></td>
							<td>
								&nbsp;: 
								<cfif len(get_position.UPPER_POSITION_CODE)>
									<cfquery name="get_upper_position_name" datasource="#dsn#">
										SELECT * FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #get_position.UPPER_POSITION_CODE#
									</cfquery>
									#get_upper_position_name.employee_name# #get_upper_position_name.employee_surname# (#get_upper_position_name.position_name#)
								</cfif>
							</td>
						</tr>
						<tr>
							<td width="121" height="24">&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
					</table>
				</td>
			</tr>
				<tr>
				<td style="border-top:1px solid ##000000;" height="180" valign="top">
					<table cellspacing="1" cellpadding="2" border="0" width="96%">
						<tr>
							<td class="formbold" colspan="4"><cf_get_lang dictionary_id ='31372.Eğitim Bilgileri'></td>
						</tr>
						<cfloop query="get_edu_info">
							<tr>
								<td width="14%"><cfset edu_type_id_control = "">
									<input type="hidden" name="edu_type#currentrow#" id="edu_type#currentrow#"  value="#edu_type#" readonly>													
									<cfif len(edu_type)>
										<cfquery name="get_education_level_name" datasource="#dsn#">
											SELECT EDU_LEVEL_ID,EDUCATION_NAME,EDU_TYPE FROM SETUP_EDUCATION_LEVEL WHERE EDU_LEVEL_ID =#edu_type#
										</cfquery>
										<cfset edu_type_name=get_education_level_name.education_name>
										<cfset edu_type_id_control = get_education_level_name.EDU_TYPE>											
									</cfif>
									#edu_type_name#
								</td>
								<td width="25%">
									<cfif len(edu_id) and edu_id neq -1>
										<cfquery name="get_unv_name" datasource="#dsn#">
											SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_ID = #edu_id#
										</cfquery>
										<cfset edu_name_degisken = get_unv_name.SCHOOL_NAME>
									<cfelse>
										<cfset edu_name_degisken = edu_name>
									</cfif>
									#edu_name_degisken#
								</td>
								<td width="50%">#get_edu_info.edu_part_name#</td>
								<td>(#dateformat(edu_start,dateformat_style)# - #dateformat(edu_finish,dateformat_style)#)</td>
							</tr>
						</cfloop>
						<!--- <cfif len(get_employee.EDU3)>
						<tr>
							<td width="14%"><cf_get_lang no='533.Lise'>&nbsp;</td>
							<td width="25%">
								: #get_employee.EDU3#
							</td>
							<td width="50%">
								<cfif len(get_employee.EDU3_PART)>
									<cfquery name="get_high_school_part" datasource="#dsn#">
										SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART WHERE HIGH_PART_ID = #get_employee.EDU3_PART#
									</cfquery>
									: #get_high_school_part.HIGH_PART_NAME#
								</cfif>
							</td>
							<td>
								(#get_employee.EDU3_START# - #get_employee.EDU3_FINISH#)
							</td>
						</tr>
						</cfif>
						<cfif len(get_employee.EDU4_ID)>
						<tr>
							<td width="14%"><cf_get_lang no='532.Üniversite'>&nbsp;</td>
							<td width="25%"> :
							<cfif len(get_employee.EDU4_ID)>
								<cfquery name="get_unv" datasource="#dsn#">
									SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_ID=#get_employee.EDU4_ID#
								</cfquery>
								#get_unv.SCHOOL_NAME#
							</cfif>
							</td>
							<td width="50%">
							<cfif len(get_employee.EDU4_PART_ID)>
								<cfquery name="get_school_part" datasource="#dsn#"> 
									SELECT PART_ID,PART_NAME FROM SETUP_SCHOOL_PART WHERE PART_ID = #get_employee.EDU4_PART_ID#
								</cfquery>
								: #get_school_part.PART_NAME#
							</cfif>
							</td>
							<td>
								(#get_employee.EDU4_START# - #get_employee.EDU4_FINISH#)
							</td>
						</tr>
						</cfif>
						<cfif len(get_employee.edu4_id_2) or len(get_employee.edu4)>
						<tr>
							<td width="14%"><cf_get_lang no='532.Üniversite'>&nbsp;</td>
							<td width="25%"> :
							<cfif len(get_employee.edu4_id_2)>
								<cfquery name="get_unv_2" datasource="#dsn#">
									SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_ID=#get_employee.EDU4_ID_2#
								</cfquery>
								#get_unv_2.SCHOOL_NAME#
							<cfelse>
								#get_employee.edu4#
							</cfif>
							</td>
							<td width="50%">
							<cfif len(get_employee.EDU4_PART_ID_2)>
								<cfquery name="get_school_part_2" datasource="#dsn#"> 
									SELECT PART_ID,PART_NAME FROM SETUP_SCHOOL_PART WHERE PART_ID = #get_employee.EDU4_PART_ID_2#
								</cfquery>
								: #get_school_part_2.PART_NAME#
							<cfelse>
								#get_employee.edu4_part#
							</cfif>
							</td>
							<td>
							<cfif len(get_employee.edu4_finish_2)>
								(#get_employee.EDU4_START_2# - #get_employee.EDU4_FINISH_2#)
							<cfelse>
								devam ediyor
							</cfif>
							</td>
						</tr>
						</cfif>
						<cfif len(get_employee.edu5)>
						<tr>
							<td width="14%"><cf_get_lang no='535.Yüksek Lisans'>&nbsp;</td>
							<td width="25%">
								: #get_employee.edu5#
							</td>
							<td width="50%">
							: #get_employee.edu5_part#</td>
							<td>
							<cfif len(get_employee.edu5_finish)>
								(#get_employee.edu5_start# - #get_employee.edu5_finish#)
							<cfelse>
								devam ediyor
							</cfif>
							</td>
						</tr>
						</cfif>
						<cfif len(get_employee.edu7)>
						<tr>
							<td width="14%"><cf_get_lang no='536.Doktora'>&nbsp;</td>
							<td width="25%">
								: #get_employee.edu7#
							</td>
							<td width="50%">
							: #get_employee.edu7_part#</td>
							<td>
							<cfif len(get_employee.edu7_finish)>
								(#get_employee.edu7_start# - #get_employee.edu7_finish#)
							<cfelse>
								devam ediyor
							</cfif>
							</td>
						</tr>
						</cfif> --->
					</table>
				</td>
			</tr>
			<tr>
				<td style="border-top:1px solid ##000000;" height="180" valign="top">
					<table cellspacing="1" cellpadding="2" border="0" width="96%">
						<tr>
							<td class="formbold" colspan="4"><cf_get_lang dictionary_id ='31488.İş Deneyimi'></td>
						</tr>
					<cfif get_work_info.recordcount>
						<cfloop query="get_work_info">
							<tr>
								<td width="20%">#get_work_info.exp#</td>
								<td width="20%"> : #get_work_info.exp_position#</td>
								<td width="18%">
								<cfif len(get_work_info.exp_sector_cat)>
									<cfquery name="get_sector_cat" datasource="#dsn#">
										SELECT SECTOR_CAT_ID,SECTOR_CAT FROM SETUP_SECTOR_CATS WHERE SECTOR_CAT_ID = #get_work_info.exp_sector_cat#
									</cfquery>
									#get_sector_cat.SECTOR_CAT#
								</cfif>
								</td>
								<td width="20%">
								<cfif len(get_work_info.exp_task_id)>
									<cfquery name="get_exp_task_name" datasource="#dsn#">
										SELECT PARTNER_POSITION_ID,PARTNER_POSITION FROM SETUP_PARTNER_POSITION WHERE PARTNER_POSITION_ID = #get_work_info.exp_task_id#
									</cfquery>
									#get_exp_task_name.PARTNER_POSITION#
								</cfif>
								</td>
								<td width="25%"  style="text-align:right;">
									( #dateformat(get_work_info.exp_start,dateformat_style)# - #dateformat(get_work_info.exp_finish,dateformat_style)# )
								</td>
							</tr>
						</cfloop>
					<cfelse>
							<tr>
								<td></td>
							</tr>
					</cfif>
					</table>
				</td>
			</tr>
			<tr valign="top">
				<td style="border-top:1px solid ##000000;" valign="top">
					<table cellspacing="1" cellpadding="2" border="0" width="96%" valign="top">
						<tr valign="top">
							<td width="90%" class="formbold" height="50" ><cf_get_lang dictionary_id ='57655.Başlama Tarihi'></td>
							<td  style="text-align:right;">#dateformat(get_emp_in_out.start_date,dateformat_style)#</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td style="border-top:1px solid ##000000;" height="180" valign="top">
					<table cellspacing="1" cellpadding="2" border="0" width="100%">
						<tr>
							<td colspan="2" class="formbold" height="10"><cf_get_lang dictionary_id ='31930.Kendisine Bağlı Çalışanlar'></td>
						</tr>
					<cfif get_position.recordcount and get_upper.recordcount>
						<cfloop query="get_upper">
							<cfquery name="get_list_upper" datasource="#dsn#">
								SELECT * FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #get_upper.position_code#
							</cfquery>
						<tr>
							<td>#get_list_upper.employee_name# #get_list_upper.employee_surname#</td>
							<td>
								#get_list_upper.position_name#
							</td>
						</tr>
						</cfloop>
					</cfif>
					</table>
				</td>
			</tr>
			<tr>
				<td style="border-top:1px solid ##000000;">
					<table cellspacing="1" cellpadding="2" border="0" width="100%">
						<tr>
							<td height="8">&nbsp;</td>
						</tr>
						<tr>
							<td align="left" class="formbold" style="font-size:13px"><cf_get_lang dictionary_id='58780.Sayın'>#get_employee.employee_name# #get_employee.employee_surname# <cf_get_lang dictionary_id ='31932.Grubumuza katılmasından duyduğumuz sevinci paylaşır, kendisine başarılar dileriz'>.</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</cfoutput>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='31931.Çalışanın Pozisyonu tanımlanmamış'>!");
		window.close();
	</script>
</cfif>
