<!--- İlan Başvuru Detayı Partner --->
<!--- TODO: arayüzü düzenlenecek. --->

<cfif not isdefined("get_components_partner")>
	<cfset get_components_partner = createObject("component", "V16.objects2.career.cfc.data_career_partner")>
</cfif>
<cfif not isdefined("get_components")>
	<cfset get_components = createObject("component", "V16.objects2.career.cfc.data_career")>
</cfif>

<cfset file_web_path = application.systemParam.systemParam().file_web_path>
<cfset attributes.USERID = session.pp.USERID>
<cfset attributes.position_code = "">
<cfset empapp_id = attributes.empapp_id>

<cfset GET_ID_CARD_CATS = get_components.GET_ID_CARD_CATS()>
<cfset get_country = get_components.get_country()>
<cfset get_city = get_components.get_city()>
<cfset get_app_identy = get_components.get_app_identy()>
<cfset GET_APP = get_components.GET_APP(empapp_id: empapp_id)>
<cfset get_app_work = get_components.GET_WORK_INFO(empapp_id: empapp_id)>
<cfset get_app_edu = get_components.GET_EDU_INFO(empapp_id: empapp_id)>


<table width="98%" cellpadding="1" cellspacing="2" border="0">
	<tr>
		<td class="headbold" height="25"><cf_get_lang dictionary_id='35230.CV Detail'></td>
	</tr>
	<tr>
	<td valign="top" class="color-border">
		<table width="100%" cellpadding="2" cellspacing="1" border="0" class="color-row">
			<!--- <tr>
				<td  style="text-align:right;"><cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_dsp_cv_print&empapp_id=#attributes.empapp_id#','page');return false;" title="<cf_get_lang dictionary_id='35926.Print Resume'>"><img src="/images/print.gif" border="0" alt="<cf_get_lang dictionary_id='35926.Print Resume'>" /></a></cfoutput></td>
			</tr> --->
			<tr>
				<td>
				<table border="0">
					<tr>
						<td colspan="4" height="25"><strong><cf_get_lang dictionary_id='34518.Personal Details'></strong></td>
					</tr>
					<tr>
						<td width="125"><cf_get_lang_main no='219.Adınız'> *</td>
						<td width="150"><cfoutput>#get_app.name#</cfoutput></td>
						<td rowspan="7"  valign="top" style="text-align:right;">
						<table>
							<cfif len(get_app.photo)>
							<tr>
								<td colspan="3">
								<table>
									<tr>
										<td><img src="<cfoutput>#file_web_path#hr/#get_app.photo#</cfoutput>" alt="<cf_get_lang dictionary_id='34528.Photo'>" title="<cf_get_lang dictionary_id='34528.Photo'>" border="1" width="120" height="140" align="center" /></td>
										<td valign="top"></td>
									</tr>
								</table>
								</td>
							</tr>
							</cfif>
						</table>
					</td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id='58726.Last Name'></td>
						<td><cfoutput>#get_app.surname#</cfoutput></td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id='58482.Mobile No.'></td>
						<td><cfoutput>#trim(get_app.mobilcode)# #trim(get_app.mobil)#</cfoutput></td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id='58482.Mobile No.'> 2</td>
						<td><cfoutput>#trim(get_app.mobilcode2)# #trim(get_app.mobil2)#</cfoutput></td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id='34547.Home Phone'></td>
						<td><cfoutput>#trim(get_app.hometelcode)# #trim(get_app.hometel)#</cfoutput></td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id='34548.Work Phone'></td>
						<td><cfoutput>#trim(get_app.worktelcode)# #trim(get_app.worktel)#</cfoutput></td>
					</tr>
					<tr>
						<td valign="top" rowspan="2"><cf_get_lang dictionary_id='34534.Home Address'></td>
						<td rowspan="2">
							<cfoutput>#get_app.homeaddress#&nbsp;#get_app.homepostcode#&nbsp;#get_app.homecounty#</cfoutput>
							<cfif len(get_app.homecity)>
							<cfquery name="get_homecity" dbtype="query">
								SELECT CITY_NAME FROM get_city WHERE CITY_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.homecity#">
							</cfquery>
							<cfoutput>#get_homecity.city_name#</cfoutput>
							</cfif>
							<cfoutput query="get_country">
								<cfif get_app.homecountry eq get_country.country_id>#get_country.country_name#</cfif>
							</cfoutput>
						</td>
					</tr> 
					<tr>
						<td></td>
					</tr>
					<tr>
						<td width="125"><cf_get_lang dictionary_id='57428.Email'></td>
						<td width="150"><cfoutput>#get_app.email#</cfoutput></td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td><hr></td>
			</tr>
			<tr>
				<td colspan="4" height="25" STYLE="cursor:pointer;" onClick="gizle_goster(gizli1);"><strong><cf_get_lang dictionary_id='34546.Educational Background'></strong></td>
			</tr>
			<tr>
				<td style="display:none" id="gizli1">
					<cfset get_edu_level = get_components.get_edu_level()>
					<cfset know_levels = get_components.know_levels()>
					<cfset get_school = get_components.get_school()>
					<cfset get_school_part = get_components.get_school_part()>
					<cfset get_high_school_part = get_components.get_high_school_part()>
					<cfset get_languages = get_components.get_languages()>
					<table cellpadding="0" cellspacing="0">
						<tr>
							<td height="20"><strong></strong></td>
						</tr>
						<tr>
							<td width="125"><cf_get_lang dictionary_id='35155.Education Level'></td>
							<td width="150">
								<cfloop query="get_edu_level">
									<cfif get_edu_level.edu_level_id eq get_app.training_level><cfoutput>#get_edu_level.education_name#</cfoutput></cfif>
								</cfloop>
							</td>
							<td colspan="4" width="275"></td>
						</tr>
						<tr>
							<td></td>
							<td class="txtboldblue"><cf_get_lang dictionary_id='34841.School Name'></td>
							<td class="txtboldblue"><cf_get_lang dictionary_id='35159.Start Year'></td>
							<td class="txtboldblue"><cf_get_lang dictionary_id='35160.End Year'></td>
							<td class="txtboldblue"><cf_get_lang dictionary_id='35157.Grade Average'>.</td>
							<td class="txtboldblue"><cf_get_lang dictionary_id='57995.Section'></td>
						</tr>
						<cfoutput query="get_app_edu">
							<tr>
								<td>
									<cfif get_app_edu.edu_type eq 1>
										<cf_get_lang dictionary_id='35158.Primary School'>
									<cfelseif get_app_edu.edu_type eq 2>
										<cf_get_lang dictionary_id='34844.Middle School'>
									<cfelseif get_app_edu.edu_type eq 3>
										<cf_get_lang dictionary_id='34845.High School'>
									<cfelseif get_app_edu.edu_type eq 4>
										<cf_get_lang dictionary_id='29755.University'>
									<cfelseif get_app_edu.edu_type eq 5>
										<cf_get_lang dictionary_id='34847.Master'>
									<cfelseif get_app_edu.edu_type eq 6>
										<cf_get_lang dictionary_id='35161.PHD'>
									</cfif>
								</td>
								<td>#get_app_edu.edu_name#</td>
								<td>#get_app_edu.edu_start#</td>
								<td>#get_app_edu.edu_finish#</td>
								<td>#get_app_edu.edu_rank#</td>
								<td>#get_app_edu.edu_part_name#</td>
							</tr>
						</cfoutput>
						<tr>
							<td colspan="6">
								<table width="100%">
									<tr>
										<td colspan="6" class="txtboldblue"><cf_get_lang dictionary_id='35162.Foreign Languages'></td>
									</tr>
									<tr>
										<td></td>
										<td class="txtboldblue"><cf_get_lang dictionary_id='58996.Language'></td>
										<td class="txtboldblue"><cf_get_lang dictionary_id='35163.Dialogue'></td>
										<td class="txtboldblue"><cf_get_lang dictionary_id='35164.Understanding'></td>
										<td class="txtboldblue"><cf_get_lang dictionary_id='35165.Write'></td>
										<td class="txtboldblue"><cf_get_lang dictionary_id='35166.Place of Learning'></td>
									</tr>
									<tr>
										<td></td>
										<td>
											<cfoutput query="get_languages">
												<cfif get_languages.language_id eq get_app._LANG1>#language_set#</cfif>
											</cfoutput>
										</td>
										<td>
											<cfoutput query="know_levels">
												<cfif get_app._LANG1_SPEAK eq knowlevel_id>#knowlevel# </cfif>
											</cfoutput>
										</td>
										<td>
											<cfoutput query="know_levels">
												<cfif get_app._LANG1_MEAN eq knowlevel_id>#knowlevel#</cfif>
											</cfoutput>
										</td>
										<td>
											<cfoutput query="know_levels">
												<cfif get_app._LANG1_WRITE eq knowlevel_id>#knowlevel#</cfif>
											</cfoutput>
										</td>
										<td>
											<cfoutput>#get_app._lang1_where#</cfoutput>
										</td>
									</tr>
									<tr>
										<td></td>
										<td>
											<cfoutput query="get_languages">
												<cfif get_languages.language_id eq get_app._lang2>#language_set#</cfif> 
											</cfoutput>
										</td>
										<td>
											<cfoutput query="know_levels">
												<cfif get_app._LANG2_SPEAK eq knowlevel_id>#knowlevel#</cfif>
											</cfoutput>
										</td>
										<td>
											<cfoutput query="know_levels">
												<cfif get_app._LANG2_MEAN eq knowlevel_id>#knowlevel#</cfif>
											</cfoutput>
										</td>
										<td>
										<cfoutput query="know_levels">
											<cfif get_app._LANG2_WRITE eq knowlevel_id>#knowlevel#</cfif>
										</cfoutput>
										</td>
										<td><cfoutput>#get_app._lang2_where#</cfoutput></td>
									</tr>
									<tr>
										<td></td>
										<td>
											<cfoutput query="get_languages">
												<cfif get_languages.language_id eq get_app._lang3>#language_set#</cfif>
											</cfoutput>
										</td>
										<td>
											<cfoutput query="know_levels">
												<cfif get_app._LANG3_SPEAK eq knowlevel_id>#knowlevel#</cfif>
											</cfoutput>
										</td>
										<td>
											<cfoutput query="know_levels">
												<cfif get_app._LANG3_MEAN eq knowlevel_id>#knowlevel#</cfif>
											</cfoutput>
										</td>
										<td>
											<cfoutput query="know_levels">
												<cfif get_app._LANG3_WRITE eq knowlevel_id>#knowlevel#</cfif>
											</cfoutput>
										</td>
										<td>
											<cfoutput>#get_app._lang3_where#</cfoutput>
										</td>
									</tr>
									<tr>
										<td></td>
										<td>
											<cfoutput query="get_languages">
												<cfif get_languages.language_id eq get_app._lang4>#language_set#</cfif>
											</cfoutput>
										</td>
										<td>
											<cfoutput query="know_levels">
												<cfif get_app._LANG4_SPEAK eq knowlevel_id>#knowlevel#</cfif>
											</cfoutput>
										</td>
										<td>
											<cfoutput query="know_levels">
												<cfif get_app._LANG4_MEAN eq knowlevel_id>#knowlevel#</cfif>
											</cfoutput>
										</td>
										<td>
											<cfoutput query="know_levels">
												<cfif get_app._LANG4_WRITE eq knowlevel_id>#knowlevel#</cfif>
											</cfoutput>
										</td>
										<td>
											<cfoutput>#get_app._lang4_where#</cfoutput>
										</td>
									</tr>
									<tr>
										<td></td>
										<td>
											<cfoutput query="get_languages">
												<cfif get_languages.language_id eq get_app._lang5>#language_set#</cfif> 
											</cfoutput>
										</td>
										<td>
											<cfoutput query="know_levels">
												<cfif get_app._LANG5_SPEAK eq knowlevel_id>#knowlevel#</cfif>
											</cfoutput>
										</td>
										<td>
											<cfoutput query="know_levels">
												<cfif get_app._LANG5_MEAN eq knowlevel_id>#knowlevel#</cfif>
											</cfoutput>
										</td>
										<td>
											<cfoutput query="know_levels">
												<cfif get_app._LANG5_WRITE eq knowlevel_id>#knowlevel#</cfif>
											</cfoutput>
										</td>
										<td>
											<cfoutput>#get_app._lang5_where#</cfoutput>
										</td>
									</tr>
									<tr>
										<td colspan="6" class="txtboldblue"><cf_get_lang dictionary_id='35168.Computer Knowledge'></td>
									</tr>
									<tr>
										<td colspan="6">
											<cfoutput>#get_app.COMP_EXP#</cfoutput>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					</td>
			</tr>
			<tr>
				<td><hr></td>
			</tr>
			<tr>
				<td colspan="4" height="25" STYLE="cursor:pointer;" onClick="gizle_goster(gizli2);"><strong><cf_get_lang dictionary_id='35171.Work Experience'></strong></td>
			</tr>
			<tr>
			<td style="display:none" id="gizli2">
			<table>
				<tr>
					<td valign="top" class="txtbold" colspan="5"><cf_get_lang dictionary_id='34535.Experience'> 1</td>
				</tr>
				<cfoutput query="get_app_work">					
					<tr>
						<td width="114"><br/><cf_get_lang dictionary_id='57574.Company'>&nbsp;&nbsp;&nbsp;</td>
						<td width="188"><br/>#exp#&nbsp;&nbsp;&nbsp;</td>
						<td width="120"><br/><cf_get_lang dictionary_id='57501.Start'>&nbsp;&nbsp;&nbsp;</td>
					<td width="177"><br/><cfif len(exp_start)>#dateformat(exp_start,'dd/mm/yyyy')#</cfif></td>
					</tr>
					<tr>
						<td><br/><cf_get_lang dictionary_id='58497.Position'>&nbsp;&nbsp;&nbsp;</td>
						<td><br/>#exp_position#</td>
						<td><cf_get_lang dictionary_id='57502.Finish'>&nbsp;&nbsp;&nbsp;</td>	
						<td><cfif len(exp_finish)>#dateformat(exp_finish,'dd/mm/yyyy')#</cfif></td>
					</tr>
					<tr height="22">
						<td width="114"><br/<cf_get_lang dictionary_id='35082.Salary'> (35228)&nbsp;&nbsp;&nbsp;</td>
						<td><br/><cfif len(exp_salary)>#TLFormat(exp_salary)#</cfif></td>
						<td valign="top"><cf_get_lang dictionary_id='58585.Code'> / <cf_get_lang dictionary_id='57499.Phone'></td>
						<td colspan="2">#exp_TELCODE# #exp_TEL#</td>
					</tr>
					<tr>
						<td><br/><cf_get_lang dictionary_id='35084.Additional Payments'>&nbsp;&nbsp;&nbsp;</td>
						<td colspan="2"><br/>#exp_extra_salary#</td>
						<td>&nbsp;</td>
						<td width="77">&nbsp;</td>
					</tr>
					<tr height="22">
						<td valign="top" width="120"><br/><cf_get_lang dictionary_id='35086.Duties, Responsibilites and Additional Explanations'>&nbsp;&nbsp;&nbsp;</td>
						<td colspan="4">
						<br/>#exp_extra#&nbsp;&nbsp;&nbsp;
						</td>
					</tr>
					<tr height="22">
						<td valign="top"><br/><cf_get_lang dictionary_id='35087.Reason for exiting'>&nbsp;&nbsp;&nbsp;</td>
						<td colspan="4"><br/>#exp_reason#</td>
					</tr>
				</cfoutput>
			</table>
			</td>
			</tr>
			<tr>
				<td><hr></td>
			</tr>
			<tr>
				<td colspan="5" height="25" STYLE="cursor:pointer;" onClick="gizle_goster(gizli3);"><strong><cf_get_lang dictionary_id='35229.Other Details'></strong></td>
			</tr>
			<tr>
			<td style="display:none" id="gizli3">
			<table border="0" cellpadding="0" cellspacing="0" >
				<tr>
					<td><cf_get_lang dictionary_id='34523.Nationality'></td>
					<td><cfoutput query="get_country">
							<cfif get_country.country_id eq get_app.nationality>#country_name#</cfif>
						</cfoutput>
					</td>
				</tr>
				<tr>
					<td width="125"><cf_get_lang dictionary_id='58727.Date of Birth'> *</td>
					<td colspan="2" width="150"><cfif len(get_app_identy.birth_date)><cfoutput>#dateformat(get_app_identy.birth_date,'dd/mm/yyyy')#</cfoutput></cfif></td>
					<td  width="125"><cf_get_lang dictionary_id='57790.Place of Birth'></td>
					<td  width="150"><cfoutput>#get_app_identy.birth_place#</cfoutput>
				</tr>
				<tr>
					<td width="125"><cf_get_lang dictionary_id='57764.Gender'></td>
					<td colspan="2" width="150"><cfif get_app.sex eq 1 or not len(get_app.sex)><cf_get_lang dictionary_id='58959.Male'><cfelseif get_app.sex eq 0><cf_get_lang dictionary_id='58958.Female'></cfif></td>
					<td><cf_get_lang dictionary_id='35136.Marital Status'></td>
					<td><cfif get_app_identy.married eq 0 or not len(get_app_identy.married)><cf_get_lang dictionary_id='35137.Single'><cfelseif get_app_identy.married eq 1><cf_get_lang dictionary_id='34530.Married'></cfif></td>
			
				</tr>
				<tr>
					<td nowrap>34631</td>
					<td colspan="2">
					<cfif len(get_app.licencecat_id)>
						<cfquery name="GET_DRIVER_LIS" datasource="#DSN#">
							SELECT LICENCECAT FROM SETUP_DRIVERLICENCE WHERE LICENCECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.licencecat_id#"> ORDER BY LICENCECAT
						</cfquery>
						<cfoutput>#get_driver_lis.licencecat#</cfoutput>
					</cfif>
					<cfoutput><cfif len(get_app.licence_start_date)>#year(get_app.licence_start_date)#</cfif></cfoutput>
					</td>
					<td><cf_get_lang dictionary_id='34634.For how many years have you been actively driving?'> ?</td>
					<td><cfoutput>#get_app.driver_licence_actived#</cfoutput></td>
				<tr>	
					<td><cf_get_lang dictionary_id='34624.Spouses Name'></td>
					<td colspan="2"><cfoutput>#get_app.partner_name#</cfoutput></td>
					<td><cf_get_lang dictionary_id='34627.Do you smoke?'>?</td>
					<td><cfif get_app.use_cigarette eq 1><cf_get_lang dictionary_id='57495.Yes'><cfelse><cf_get_lang dictionary_id='57496.No'></cfif>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='34625.Spouses Company'></td>
					<td colspan="2"><cfoutput>#get_app.partner_company#</cfoutput></td>
					<td><cf_get_lang dictionary_id='35140.Is there physical disability?'>?</td>
					<td><cfif get_app.defected eq 1><cf_get_lang dictionary_id='57495.Yes'>  %<cfoutput>#get_app.defected_level#</cfoutput><cfelse><cf_get_lang dictionary_id='57496.No'></cfif> &nbsp;</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='34626.Spouses Position'></td>
					<td colspan="2"><cfoutput>#get_app.partner_position#</cfoutput></td>
					<td><cf_get_lang dictionary_id='34628.Are you a martyrs relative?'></td>
					<td><cfif get_app.martyr_relative eq 1><cf_get_lang dictionary_id='57495.Yes'><cfelseif get_app.martyr_relative eq 0 or not len(get_app.martyr_relative)><cf_get_lang dictionary_id='57496.No'></cfif></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='34527.Number of Children'></td>
					<td colspan="2"><cfoutput>#get_app.child#</cfoutput></td>
					<td><cf_get_lang dictionary_id='35139.Ever he/she judged and/or convicted?'>?</td>
					<td><cfif get_app.sentenced eq 1><cf_get_lang dictionary_id='57495.Yes'><cfelse><cf_get_lang dictionary_id='57496.No'></cfif></td>
				</tr> 
				<tr>
					<td><cf_get_lang dictionary_id='35141.Military Service Status'></td>
					<td colspan="2" nowrap>
					<cfif get_app.military_status eq 0><cf_get_lang dictionary_id='34640.Not Performed'>&nbsp;
					<cfelseif get_app.military_status eq 1><cf_get_lang dictionary_id='34641.Performed'>>&nbsp;</cfif>
					</td>
					<td><cf_get_lang dictionary_id='35142.Specify the quality and duration if any'></td>
					<td><cfoutput>#get_app.INVESTIGATION#</cfoutput></td>
				</tr>
				<tr>
					<td colspan="3">
						<cfif get_app.military_status eq 2><cf_get_lang no='321.Muaf'>&nbsp;
						<cfelseif get_app.military_status eq 3><cf_get_lang no='322.Yabancı'>&nbsp;
						<cfelseif get_app.military_status eq 4><cf_get_lang no='323.Tecilli'></cfif>
					</td>
					<td><cf_get_lang dictionary_id='35143.Is there any ongoing disease?'>?</td>
					<td><cfif get_app.illness_probability eq 1><cf_get_lang dictionary_id='57495.Yes'> &nbsp;<cfelseif get_app.illness_probability eq 0><cf_get_lang dictionary_id='57496.No'></cfif></td>
				</tr>
				<tr>
					<td colspan="3" rowspan="2">
						<cfif get_app.military_status eq 4>
						<table id="Tecilli">
							<tr>
								<td><cf_get_lang dictionary_id='34645.Postponement Reason'></td>
								<td><cfoutput>#get_app.military_delay_reason#</cfoutput></td>
							</tr>
							<tr>
								<td><cf_get_lang dictionary_id='34646.Postponement Duration'></td>
								<td><cfif len(get_app.military_delay_date)><cfoutput>#dateformat(get_app.military_delay_date,'dd/mm/yyyy')#</cfoutput></cfif></td>
							</tr>
						</table>
						</cfif>
						<cfif get_app.military_status eq 2>
						<table id="Muaf">
							<tr>
								<td><cf_get_lang dictionary_id='34648.Reason of Exemption'> *</td>
								<td><cfoutput>#get_app.military_exempt_detail#</cfoutput></td>
							</tr>
						</table>
						</cfif>
						<cfif get_app.military_status eq 1>
						<table id="Yapti">
							<tr>
								<td colspan="2">
								<table>
									<tr>
										<td><cf_get_lang dictionary_id='34647.Discharge Date'></td>
										<td nowrap><cfif len(get_app.military_finishdate)><cfoutput>#dateformat(get_app.military_finishdate,'dd/mm/yyyy')#</cfoutput></cfif></td>
									</tr>
									<tr>
										<td><cf_get_lang dictionary_id='29513.Duration'> (<cf_get_lang dictionary_id='35144.Please Enter as Months'>)</td>
										<td><cfoutput>#get_app.military_month#</cfoutput></td>
									</tr>
									<tr>
										<td colspan="2">
											<cfif get_app.military_rank eq 0 or not len(get_app.military_rank)><cf_get_lang dictionary_id='35480.Private'>
											<cfelseif get_app.military_rank eq 1><cf_get_lang dictionary_id='35145.Reserve Officer'></cfif>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					</cfif>
					</td>
					<td valign="top"><cf_get_lang dictionary_id='34637.If yes, please explain?'></td>
					<td><cfoutput>#get_app.illness_detail#</cfoutput></td>
				</tr>
				<tr>
					<td valign="top"><cf_get_lang dictionary_id='35147.Please indicate if you had any surgery'></td>
					<td valign="top"><cfoutput>#get_app.SURGICAL_OPERATION#</cfoutput></td>
				</tr>
			</table>
			</td></tr>
			<tr>
				<td><hr></td>
			</tr>
			<tr>
				<td colspan="4" STYLE="cursor:pointer;" onClick="gizle_goster(gizli4);"><strong><cf_get_lang dictionary_id='35173.Reference Details'></strong></td>
			</tr>
			<tr>
			<td style="display:none" id="gizli4">
			<table border="0">
				<tr>
					<td class="txtbold" colspan="2"><br/><cf_get_lang dictionary_id='35174.Contacts we can learn more about you'>:</td>
					<td colspan="2" class="txtbold"><br/><cf_get_lang dictionary_id='35176.If you have a relative, acquaintance and / or friend working in our company'>:</td>
				</tr>
				<tr>
					<td class="txtbold" colspan="2">1</td>
					<td class="txtbold" colspan="2">1</td>
				</tr>
				<tr>
					<td width="100"><cf_get_lang dictionary_id='57570.Name  Last name'></td>
					<td width="250"><cfoutput>#get_app._ref1#</cfoutput></td>
					<td width="100"><cf_get_lang dictionary_id='57570.Name  Last name'></td>
					<td width="250"><cfoutput>#get_app._ref1_emp#</cfoutput></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='57574.Company'></td>
					<td><cfoutput>#get_app._ref1_company#</cfoutput></td>
					<td><cf_get_lang dictionary_id='57574.Company'></td>
					<td><cfoutput>#get_app._ref1_company_emp#</cfoutput></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='58497.Position'></td>
					<td><cfoutput>#get_app._ref1_position#</cfoutput></td>
					<td><cf_get_lang dictionary_id='58497.Position'></td>
					<td><cfoutput>#get_app._ref1_position_emp#</cfoutput></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='57499.Phone'></td>
					<td><cfoutput>#get_app._ref1_telcode# #get_app._ref1_tel#</cfoutput></td>
					<td><cf_get_lang dictionary_id='57499.Phone'></td>
					<td><cfoutput>#get_app._ref1_telcode_emp# #get_app._ref1_tel_emp#</cfoutput></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='57428.Email'></td>
					<td><cfoutput>#get_app._ref1_email#</cfoutput></td>
					<td><cf_get_lang dictionary_id='57428.Email'></td>
					<td><cfoutput>#get_app._ref1_email_emp#</cfoutput></td>
				</tr>
				<tr>
					<td class="txtbold" colspan="2">2</td>
					<td class="txtbold" colspan="2">2</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='57570.Name  Last name'></td>
					<td><cfoutput>#get_app._ref2#</cfoutput></td>
					<td><cf_get_lang dictionary_id='57570.Name  Last name'></td>
					<td><cfoutput>#get_app._ref2_emp#</cfoutput></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='57574.Company'></td>
					<td><cfoutput>#get_app._ref2_company#</cfoutput></td>
					<td><cf_get_lang dictionary_id='57574.Company'></td>
					<td><cfoutput>#get_app._ref2_company_emp#</cfoutput></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='58497.Position'></td>
					<td><cfoutput>#get_app._ref2_position#</cfoutput></td>
					<td><cf_get_lang dictionary_id='58497.Position'></td>
					<td><cfoutput>#get_app._ref2_position_emp#</cfoutput></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='57499.Phone'></td>
					<td><cfoutput>#get_app._ref1_telcode# #get_app._ref1_tel#</cfoutput></td>
					<td><cf_get_lang dictionary_id='57499.Phone'></td>
					<td><cfoutput>#get_app._ref2_telcode_emp# #get_app._ref2_tel_emp#</cfoutput></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='57428.Email'></td>
					<td><cfoutput>#get_app._ref1_email#</cfoutput></td>
					<td><cf_get_lang dictionary_id='57428.Email'></td>
					<td><cfoutput>#get_app._ref2_email_emp#</cfoutput></td>
				</tr>
			</table>
		
			</td>
			</tr>
			<tr>
				<td><hr></td>
			</tr>
			<tr>
				<td colspan="2" height="25" STYLE="cursor:pointer;" onClick="gizle_goster(gizli5);"><strong><cf_get_lang dictionary_id='35178.Special Interests'></strong></td>
			</tr>
			<tr>
				<td style="display:none" id="gizli5">
					<table border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td width="125"><cf_get_lang dictionary_id='35178.Special Interests'>td>
							<td width="425" colspan="2">
								<cfoutput>#get_app.hobby#</cfoutput>
							</td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='35179.Clubs and Associations Memberships'></td>
							<td><cfoutput>#get_app.club#</cfoutput></td>
							<td>&nbsp;</td>
						</tr>
					</table>
				</td>
			</tr>
			<cfset get_relatives = get_components.GET_RELATIVES(empapp_id : attributes.empapp_id)>
			<cfif get_relatives.recordcount>
			<tr>
				<td><hr></td>
			</tr>
			<tr>
				<td class="txtbold" colspan="2" STYLE="cursor:pointer;" onClick="gizle_goster(gizli6);"><cf_get_lang dictionary_id='35182.Family Details'></td>
			</tr>
			<tr>
				<td style="display:none" id="gizli6">
					<table>
						<tr>
							<td colspan="2">
								<cfif get_relatives.recordcount>
									<table border="0" cellpadding="2"  cellspacing="1" id="table_list">
										<tr class="txtboldblue">
											<td><cf_get_lang dictionary_id='57631.Name'></td>
											<td><cf_get_lang dictionary_id='57570.Name  Last name'></td>
											<td><cf_get_lang dictionary_id='35115.Relationship Degree'></td>
											<td width="15"></td>
										</tr>
										<cfoutput query="get_relatives">
										<tr>
											<td>#get_relatives.name#</td>
											<td>#get_relatives.surname#</td>
											<td><cfif get_relatives.relative_level eq 1><cf_get_lang dictionary_id='35116.Father'>
												<cfelseif get_relatives.relative_level eq 2><cf_get_lang dictionary_id='35117.Mother'>
												<cfelseif get_relatives.relative_level eq 3><cf_get_lang dictionary_id='35118.Spouse'>
												<cfelseif get_relatives.relative_level eq 4><cf_get_lang dictionary_id='35119.Son'>
												<cfelseif get_relatives.relative_level eq 5><cf_get_lang dictionary_id='35120.Daughter'>
												<cfelseif get_relatives.relative_level eq 6><cf_get_lang dictionary_id='35121.Sibling'></cfif>
											</td>
											<td width="15"></td>
										</tr>
										</cfoutput>
									</table>
								</cfif>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			</cfif>
			<tr>
				<td><hr></td>
			</tr>
			<tr>
				<td height="25" class="txtbold" STYLE="cursor:pointer;" onClick="gizle_goster(gizli7);"><strong><cf_get_lang dictionary_id='35183.Preffered Unit'></strong></td>
			</tr>
			<tr>
				<td style="display:none" id="gizli7">
					<cfset get_app_unit = get_components.get_app_unit(empapp_id: attributes.empapp_id)>
					<cfset get_cv_unit = get_components.get_cv_unit()>
					<cfif get_cv_unit.recordcount>
						<table border="0" cellpadding="0" cellspacing="0" >
							<tr>
								<td>
									<table cellpadding="0" cellspacing="0">
										<tr class="txtbold">
										<cfset liste = valuelist(get_app_unit.unit_id)>
										<cfset liste_row = valuelist(get_app_unit.unit_row)>					
										<cfoutput query="get_cv_unit">
											<cfif get_cv_unit.currentrow-1 mod 3 eq 0><tr></cfif>
											<td width="150">#get_cv_unit.unit_name# :</td>
											<td width="100">
												<cfif listfind(liste,get_cv_unit.unit_id,',')>
													#listgetat(liste_row,listfind(liste,get_cv_unit.unit_id,','),',')#
												<cfelse>
													--
												</cfif>
											</td>
											<cfif get_cv_unit.currentrow mod 3 eq 0 and get_cv_unit.currentrow-1 neq 0></tr></cfif>	  
										</cfoutput>
									</table>
								</td>
							</tr>
						</table>
					</cfif>
				</td>
			</tr>
			<tr>
				<td><hr></td>
			</tr>
			<tr STYLE="cursor:pointer;" onClick="gizle_goster(gizli8);">
				<td valign="top">
					<strong><cf_get_lang dictionary_id='35195.Preferred City'></strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<strong><cf_get_lang dictionary_id='31705.Ability to make business-related trips?'>?</strong>
				</td>
			</tr>
			<tr> 
			<td style="display:none" id="gizli8">
				<table>
					<cfset get_asset = get_components.get_asset(empapp_id: attributes.empapp_id)>
					<tr>
						<td>1-</td>
						<td>
							<cfif listfind(get_app.prefered_city,'',',') or not len(get_app.prefered_city)><cf_get_lang dictionary_id='35107.All of Turkey'>
							<cfelse>
								<cfoutput query="get_city">
									<cfif listlen(get_app.prefered_city,',') gt 0 and listgetat(get_app.prefered_city,1,',') eq get_city.city_id>#city_name#</cfif>
								</cfoutput>
							</cfif>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<cfif get_app.IS_TRIP is 1 OR get_app.IS_TRIP IS ""> <cf_get_lang dictionary_id='57495.Yes'>
							<cfelseif get_app.IS_TRIP is 0><cf_get_lang dictionary_id='57496.No'></cfif> 
						</td>
					</tr>
					<tr>
						<td>2-</td>
						<td>
							<cfif listfind(get_app.prefered_city,'',',') or not len(get_app.prefered_city)><cf_get_lang dictionary_id='35107.All of Turkey'>
							<cfelse>
								<cfoutput query="get_city">
									<cfif listlen(get_app.prefered_city,',') gt 1 and listgetat(get_app.prefered_city,2,',') eq get_city.city_id>#city_name#</cfif>
								</cfoutput>
							</cfif>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<strong><cf_get_lang dictionary_id='35074.Requested Salary'> (<cf_get_lang dictionary_id='58083.Net'>)</strong><br/><cfoutput>#TLFormat(get_app.expected_price)# #get_app.expected_money_type#</cfoutput>
						</td>
					</tr>
					<tr>
						<td>3-</td>
						<td>
							<cfif listfind(get_app.prefered_city,'',',') or not len(get_app.prefered_city)><cf_get_lang dictionary_id='35107.All of Turkey'>
							<cfelse>
								<cfoutput query="get_city">
									<cfif listlen(get_app.prefered_city,',') gt 2 and listgetat(get_app.prefered_city,3,',') eq get_city.city_id>#city_name#</cfif>
								</cfoutput>
							</cfif>
						</td>
						<td></td>
					</tr>
					<tr>
						<td colspan="3" nowrap><strong><cf_get_lang dictionary_id='35191.Additional Info'></strong></td>
					</tr>
					<tr>
						<td colspan="3" nowrap><cfoutput>#GET_APP.APPLICANT_NOTES#</cfoutput></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
 	</td>
	</tr>
</table>
