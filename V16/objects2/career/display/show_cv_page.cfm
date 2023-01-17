<!--- CV Önizleme --->
<cfset file_web_path = application.systemParam.systemParam().file_web_path>

<cfsetting showdebugoutput="no">
<cfset d4=0>
<cfset d3=0>
<cfset d2=0>
<cfset d1=0>

<cfset get_components = createObject("component", "V16.objects2.career.cfc.employees_cv")>
<cfset get_components_career = createObject("component", "V16.objects2.career.cfc.data_career")>

<cfset get_employee = get_components.GET_EMPLOYEE(employee_id: attributes.employee_id)>
<cfset get_position = get_components.get_position(employee_id: attributes.employee_id)>

<cfif GET_EMPLOYEE.recordcount>
<cfoutput>
<table cellSpacing="0" cellpadding="0" border="0" width="750" align="center">
	<tr>
		<td>
			<table cellspacing="1" cellpadding="2">
				<tr bgcolor="##CCCCCC">
					<td align="center" colspan="4" height="20"><strong><font color="##000066"><cf_get_lang dictionary_id='55180.PERSONNEL INFORMATION FORM'></font></strong></td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td height="20" colspan="4"></td>
				</tr>
				<tr bgcolor="##CCCCCC">
					<td colspan="4" height="20"><strong><font color="##000066"><cf_get_lang dictionary_id='35251.Identity Information'></font></strong></td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang dictionary_id='58487.Employee No.'>:</b></td>
					<td>#get_employee.employee_no#</td>
					<td align="center" rowspan="9" width="150"colspan="2">
						<cfif len(get_employee.photo)>
							<img src="#file_web_path#hr/#get_employee.photo#" border="0" width="120" height="160" alt="<cf_get_lang dictionary_id='31495.Photo'>" title="<cf_get_lang dictionary_id='31495.Photo'>" align="center" />
						<cfelse>
							<cf_get_lang dictionary_id='31928.There is no photo!'>!
						</cfif>
					</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang dictionary_id='32370.Name Last Name'>:</b></td>
					<td width="225">#get_employee.employee_name#&nbsp;#get_employee.employee_surname#</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang dictionary_id='58497.Position'>:</b></td>
					<td width="225"><cfloop query="get_position">#get_position.position_name#,</cfloop></td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang dictionary_id='57574.Company'>:</b></td>
					<td width="225">#get_position.company_name#</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang dictionary_id='57453.Branch Office'>:</b></td>
					<td width="225"><cfloop query="get_position">#get_position.branch_name#,</cfloop></td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang dictionary_id='57572.Department'>:</b></td>
					<td width="225"><cfloop query="get_position">#get_position.department_head#,</cfloop></td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang dictionary_id='57571.Title'>:</b></td>
					<td>
						<cfif len(get_position.title_id)>
							<cfset unvan = get_components.get_TITLE(title_id: get_position.title_id)>
							#unvan.title#
						</cfif>
					</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang dictionary_id='35263.Seniority'>:</b></td>
					<td width="225"><cfif len(get_employee.group_startdate)>
					#TLFormat(DATEDIFF('D',dateformat(get_employee.group_startdate,'DD/MM/YYYY'),dateformat(now(),'DD/MM/YYYY'))/365)#
					</cfif>
					</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<cfset get_in_outs = get_components.get_in_outs(employee_id : attributes.employee_id)>
					<td width="150"><b><cf_get_lang dictionary_id='35227.Employment Start Date'>/<cf_get_lang dictionary_id='35264.End of Employment Date'>:</b></td>
					<td width="225"><cfif len(get_in_outs.start_date)>#dateformat(get_in_outs.start_date,'dd/mm/yyyy')#</cfif> - <cfif len(get_in_outs.finish_date)>#dateformat(get_in_outs.finish_date,'dd/mm/yyyy')#</cfif></td>
				</tr>
					<cfset contract = get_components.contract(employee_id: get_employee.employee_id)>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang dictionary_id='35265.Contract starts'>/<cf_get_lang dictionary_id='57700.End Date'>:</b></td>
					<td colspan="4">#dateformat(contract.contract_date,'dd/mm/yyyy')# - #dateformat(contract.contract_finishdate,'dd/mm/yyyy')#</td>
				</tr>
				<tr bgcolor="##CCCCCC">
					<td colspan="4" height="20"><strong><font color="##000066"><cf_get_lang dictionary_id='34518.Personal Details'></font></strong></td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang dictionary_id='35162.Foreign Languages'>:</b></td>
					<td width="225">
					<cfif len(get_employee._lang1)>
							<cfset lang = get_components.lang(language_id: get_employee._lang1)>
							#lang.language_set#
					</cfif>
					<cfif len(get_employee._lang2)>
						<cfset lang = get_components.lang(language_id: get_employee._lang2)>
						,#lang.language_set#
					</cfif>
					<cfif len(get_employee._lang3)>
						<cfset lang = get_components.lang(language_id: get_employee._lang3)>
						,#lang.language_set#
					</cfif>
					<cfif len(get_employee._lang4)>
						<cfset lang = get_components.lang(language_id: get_employee._lang4)>
						,#lang.language_set#
					</cfif>
					<cfif len(get_employee._lang5)>
						<cfset lang = get_components.lang(language_id: get_employee._lang5)>
						,#lang.language_set#
					</cfif>
					</td>
					<td rowspan="4"><b><cf_get_lang dictionary_id='58723.Address'>:</b></td>
					<td rowspan="4">#get_employee.homeaddress#&nbsp;#get_employee.homepostcode#&nbsp;#get_employee.homecounty#&nbsp;
					<cfif len(get_employee.homecity)>
						<cfset city = get_components_career.GET_CITY(city_id: get_employee.homecity)>
						#city.city_name#
					</cfif>&nbsp;
					<cfif len(get_employee.homecountry)>
						<cfset country = get_components_career.GET_COUNTRY(county_id: Get_employee.homecountry)>
						#country.country_name#
					</cfif>
					</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang dictionary_id='58727.Date of Birth'>/<cf_get_lang dictionary_id='57790.Place of Birth'>:</b></td>
					<td width="225">#dateformat(get_employee.birth_date,'dd/mm/yyyy')# - #get_employee.birth_place#</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang dictionary_id='35141.Military Service Status'>:</b></td>
					<td width="225">
					<cfif get_employee.military_status eq 1> 
						<cf_get_lang dictionary_id='34641.Performed'> <cfif len(get_employee.military_finishdate)>#dateformat(get_employee.military_finishdate,'dd/mm/yyyy')#
					</cfif>
					<cfelseif get_employee.military_status eq 2>
						<cf_get_lang dictionary_id='34642.Exempted'>
					<cfelseif get_employee.military_status eq 3>
						<cf_get_lang dictionary_id='34643.Foreigner'>
					<cfelseif get_employee.military_status eq 4>
						<cf_get_lang dictionary_id='34644.Postponed'> #get_employee.military_delay_reason# <cfif len(get_employee.military_delay_date)>#dateformat(get_employee.military_delay_date,'dd/mm/yyyy')#</cfif>
					<cfelseif get_employee.military_status eq 0>
						<cf_get_lang dictionary_id='34640.Not Performed'>
					</cfif>
					</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang dictionary_id='35266.Disability Degree'>(%):</b></td>
					<td width="225">
					<cfif get_employee.defected eq 0><cf_get_lang dictionary_id='58546.Unavailable'></cfif>
					<cfif get_employee.defected eq 1>#get_employee.defected_level#</cfif>
					</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><!---<b> <cf_get_lang no='912.Ehliyet Sınıfı'>:</b> ---></td>
					<td width="225"><!--- #get_employee.driver_licence_type# ---></td>
					<td width="150"><b><cf_get_lang dictionary_id='34547.Home Phone'>:</b></td>
					<td width="225">#get_employee.hometel_code#&nbsp;#get_employee.hometel#</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang dictionary_id='35136.Marital Status'>:</b></td>
					<td width="225"><cfif get_employee.married eq 1>evli<cfelse>bekar</cfif></td>
					<td width="150"><b><cf_get_lang dictionary_id='58482.Mobile No.'>:</b></td>
					<td width="225">#get_employee.mobilcode#&nbsp;#get_employee.mobiltel#</td>
				</tr>
			</table>
		</td>	
	</tr>
	<tr>
		<td colspan="4" width="100%">
			<table cellpadding="1" cellspacing="2">
				<tr bgcolor="##CCCCCC">
					<cfif len(get_employee.last_school)>
						<cfset get_education = get_components_career.GET_EDU_LEVEL(edu_level_id: get_employee.last_school)>
					</cfif>
					<td colspan="5" height="20"><strong><font color="##000066"><cf_get_lang dictionary_id='34546.Educational Background'></font> &nbsp;&nbsp;[<cf_get_lang dictionary_id='34526.Education Status'> : <cfif len(get_employee.last_school) and get_education.recordcount and len(get_education.education_name)>#get_education.education_name#</cfif>]</strong></td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"></td>
					<td width="150"><strong><cf_get_lang dictionary_id='34845.High School'></strong></td>
					<td width="150"><strong><cf_get_lang dictionary_id='29755.University'></strong></td>
					<td width="150"><strong><cf_get_lang dictionary_id='34847.Master'></strong></td>
					<td width="150"><strong><cf_get_lang dictionary_id='35161.PHD'></strong></td>
				</tr>
				
				<cfset get_edu_info = get_components.get_edu_info(employee_id : attributes.EMPLOYEE_ID)>

				<tr bgcolor="##FFFFFF">
					<cfset okul=0>
					<td width="150"><b><cf_get_lang dictionary_id='34841.School Name'></b></td>
					<cfloop query="get_edu_info">
						<td>#edu_name#</td>
					</cfloop>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang dictionary_id='57995.Section'></b></td>
					<cfloop query="get_edu_info">
						<td>#edu_part_name#</td>
					</cfloop>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang dictionary_id='35159.Start Year'></b></td>
					<cfloop query="get_edu_info">
						<td>#edu_start#</td>
					</cfloop>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang dictionary_id='35160.End Year'></b></td>
					<cfloop query="get_edu_info">
						<td>#edu_finish#</td>
					</cfloop>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang dictionary_id='35267.Graduation Degree'></b></td>
					<cfloop query="get_edu_info">
						<td>#edu_rank#&nbsp;</td>
					</cfloop>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="4" width="100%">
			<table cellpadding="1" cellspacing="2" width="100%">
				<tr bgcolor="##CCCCCC">
					<td colspan="5" height="20"><strong><font color="##000066"><cf_get_lang dictionary_id='35268.Attended Trainings, Seminars and Courses'></font></strong></td>
				</tr>
				<cfset egitim = get_components.egitim(employee_id: get_employee.employee_id)>
				<cfif egitim.recordcount>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang dictionary_id='35269.Type of Training'>:</b></td>
					<cfset get_trainer_class = get_components.get_trainer_class(class_id: egitim.class_id)>
					<td colspan="3" align="left">#get_trainer_class.class_name#</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang dictionary_id='58053.Start Date'>:</b></td>
					<td colspan="3" align="left">#dateformat(get_trainer_class.start_date,'dd/mm/yyyy')#</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang dictionary_id='57700.End Date'>:</b></td>
					<td colspan="3" align="left">#dateformat(get_trainer_class.finish_date,'dd/mm/yyyy')#</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td><b><cf_get_lang dictionary_id='29513.Duration'>(<cf_get_lang dictionary_id='57490.Day'>/<cf_get_lang dictionary_id='57491.Hour'>):</b></td>
					<td colspan="3" align="left">#get_trainer_class.date_no#/#get_trainer_class.hour_no#</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang dictionary_id='35270.Training Name'>:</b></td>
					<td colspan="3" align="left">#get_trainer_class.class_target#</td>
				</tr>
				<tr bgcolor="##FFFFFF">
					<td width="150"><b><cf_get_lang dictionary_id='35271.Trainer'>\<cf_get_lang dictionary_id='57712.Organization'>:</b></td>
					<td colspan="3" align="left">
					<cfif len(get_trainer_class.trainer_emp)>
						#get_trainer_class.employee_name#&nbsp;#get_trainer_class.employee_surname#
					<cfelseif len(get_trainer_class.trainer_par)>
						<cfset get_trainer_par = get_components.get_trainer_par(class_id: egitim.class_id)>
						#get_trainer_par.company_partner_name#&nbsp;#get_trainer_par.company_partner_surname#
					<cfelseif len(get_trainer_class.trainer_cons)>
						<cfset get_trainer_cons = get_components.get_trainer_cons(class_id: egitim.class_id)>
						#get_trainer_cons.consumer_name#&nbsp;#get_trainer_cons.consumer_surname#
					</cfif>
					</td>
				</tr>
				</cfif>
			</table>
		</td>
	</tr>		 
	<tr>
		<td colspan="4" width="100%">
			<table cellpadding="1" cellspacing="2" width="100%">
				<tr bgcolor="##CCCCCC">
					<td colspan="9" height="20" ><strong><font color="##000066"><cf_get_lang dictionary_id='35272.Employee Relative'></font></strong></td>
				</tr>
					<cfset emp_relatives = get_components.emp_relatives(employee_id: attributes.EMPLOYEE_ID)>
				<cfif emp_relatives.recordcount>
					<tr bgcolor="##FFFFFF">
						<td><b><cf_get_lang dictionary_id='57570.Name  Last name'></b></td>
						<td><b><cf_get_lang dictionary_id='35115.Relationship Degree'></b></td>
						<td><b><cf_get_lang dictionary_id='58727.Date of Birth'></b></td>
						<td><b><cf_get_lang dictionary_id='57790.Place of Birth'></b></td>
						<td><b><cf_get_lang dictionary_id='58025.ID No'></b></td>
						<td><b><cf_get_lang dictionary_id='57419.Trainings'></b></td>
						<td><b><cf_get_lang dictionary_id='34533.Profession'></b></td>
						<td><b><cf_get_lang dictionary_id='57574.Company'></b></td>
						<td><b><cf_get_lang dictionary_id='58497.Position'></b></td>
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
							<td>#DateFormat(BIRTH_DATE,'dd/mm/yyyy')#</td>
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
					<td colspan="7" height="20" ><strong><font color="##000066"><cf_get_lang dictionary_id='62596.'></font></strong></td>
				</tr>
				<cfset pos_history = get_components.pos_history(employee_id: get_employee.employee_id)>
					
				<cfif pos_history.recordcount>
				<tr bgcolor="##FFFFFF">
					<td><b><cf_get_lang dictionary_id='58497.Position'></b></td>
					<td><b><cf_get_lang dictionary_id='57574.Company'></b></td>
					<td><b><cf_get_lang dictionary_id='57453.Branch Office'></b></td>
					<td><b><cf_get_lang dictionary_id='57572.Department'></b></td>
					<td width="65"><b><cf_get_lang dictionary_id='57501.Start'></b></td>
					<td width="65"><b><cf_get_lang dictionary_id='57502.Finish'></b></td>
					<td width="65"><b><cf_get_lang dictionary_id='57627.Record Date'></b></td>
				</tr>    
				<cfloop query="pos_history">
				<tr bgcolor="##FFFFFF">
					<td>#POSITION_NAME#</td>
					<td>#NICK_NAME#</td>
					<td>#BRANCH_NAME#</td>
					<td>#DEPARTMENT_HEAD#</td>
					<td>#dateformat(START_DATE,"dd/mm/yyyy")#</td>
					<td>#dateformat(FINISH_DATE,"dd/mm/yyyy")#</td>
					<td>#dateformat(RECORD_DATE,"dd/mm/yyyy")#</td>
				</tr>
				</cfloop>
				</cfif>
			</table>
		</td>
	</tr>
</table>
</cfoutput>
</cfif>
