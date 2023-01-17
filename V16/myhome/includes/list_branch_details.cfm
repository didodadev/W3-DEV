<cfsetting showdebugoutput="no">
<cfparam name="attributes.emp_pro_selection" default="#attributes.search_type#">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfinclude template="../query/get_list_employee_profile.cfm">
<cfquery name="get_branches" datasource="#dsn#">
	SELECT
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID,
		OUR_COMPANY.COMP_ID
	FROM
		BRANCH,
		OUR_COMPANY
	WHERE
		BRANCH.BRANCH_STATUS = 1
		AND BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID 
		AND BRANCH.COMPANY_ID = #attributes.comp_id#
	ORDER BY
		BRANCH.BRANCH_NAME
</cfquery>	
<cfquery name="get_education_level" datasource="#dsn#">
	SELECT EDU_LEVEL_ID,EDUCATION_NAME FROM SETUP_EDUCATION_LEVEL WHERE IS_ACTIVE = 1 ORDER BY EDU_LEVEL_ID
</cfquery>
<!--- <cfif get_branches.recordcount gt 10>
	<div id="div_branch_details" style="position:absolute;width:100%;height:100%;overflow:auto;">
<cfelse> --->
	<div id="div_branch_details">
<!--- </cfif> --->
<table width="100%" cellpadding="2" cellspacing="1" border="0" class="color-row">
	<tr>
		<td valign="top" height="<cfoutput>#get_branches.recordcount*21#</cfoutput>">
			
			<cfform name="form_branch_details" action="" method="post">
				<input type="hidden" name="comp_id" id="comp_id" value="<cfoutput>#attributes.comp_id#</cfoutput>">
				<table width="100%" cellpadding="2" cellspacing="1" border="0" class="color-row">
					<tr>
						<td style="text-align:right" colspan="12">
							<select name="emp_pro_selection" id="emp_pro_selection" onChange="change_branch_det(this.value);">
								<option value="1"><cf_get_lang_main no='322.Seçiniz'></option>
								<option value="2" <cfif attributes.emp_pro_selection eq 2>selected</cfif>><cf_get_lang_main no='1029.Kan Grubu'></option>
								<option value="3" <cfif attributes.emp_pro_selection eq 3>selected</cfif> ><cf_get_lang no='748.Yaş'></option>
								<option value="4" <cfif attributes.emp_pro_selection eq 4>selected</cfif>><cf_get_lang no='642.Kıdem'></option> 
							</select> 
						</td>
						<td width="5%"><a href="javascript://" onClick="back_();"><img src="/images/ac_c.gif" border="0"></a></td>
					</tr>
					<tr id="emp_branch_selection_1" <cfif attributes.emp_pro_selection neq 1>style="display:none;"</cfif> height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<td width="20%" class="txtbold" align="center"><cf_get_lang_main no='162.Şirket'></td>
						<td width="20%" colspan="2" align="center" class="txtbold"><cf_get_lang_main no='1085.Pozisyon'></td>
						<td width="20%" colspan="2" style="text-align:center;" class="txtbold"><cf_get_lang_main no='164.Çalışan'></td>
						<td width="20%" colspan="2" style="text-align:center;" class="txtbold"><cf_get_lang no='171.Yaka Tipi'></td>
						<td width="15%" colspan="5" style="text-align:center;" class="txtbold"><cf_get_lang no='172.Öğrenim Durumu'></td>
					</tr>
					<tr id="emp_branch_selection_1_1" <cfif attributes.emp_pro_selection neq 1>style="display:none;"</cfif>  class="color-row">
						<td>&nbsp;</td>
						<td align="center" class="txtboldblue"><cf_get_lang no='176.Dolu'></td>
						<td align="center" class="txtboldblue"><cf_get_lang no='184.Boş'></td>
						<td align="center" class="txtboldblue"><cf_get_lang_main no='1546.Kadın'></td>
						<td align="center" class="txtboldblue"><cf_get_lang_main no='1547.Erkek'></td>
						<td align="center" class="txtboldblue"><cf_get_lang no='201.Beyaz'></td>
						<td align="center" class="txtboldblue"><cf_get_lang no='203.Mavi'></td>
						<cfoutput query="get_education_level">
							<td align="center" class="txtboldblue">#Left(education_name,1)#</td>
						</cfoutput>
						<td>&nbsp;</td>
					</tr>
					<tr id="emp_branch_selection_2" <cfif attributes.emp_pro_selection neq 2>style="display:none;"</cfif> class="color-row">
						<td>&nbsp;</td>
						<td align="center" class="txtboldblue">0 RH(+)</td>
						<td align="center" class="txtboldblue">0 RH(-)</td>
						<td align="center" class="txtboldblue">A RH(+)</td>
						<td align="center" class="txtboldblue">A RH(-)</td>
						<td align="center" class="txtboldblue">B RH(+)</td>
						<td align="center" class="txtboldblue">B RH(-)</td>
						<td align="center" class="txtboldblue">AB RH(+)</td>
						<td align="center" class="txtboldblue">AB RH(-)</td>
					</tr>
					<tr id="emp_branch_selection_3" <cfif attributes.emp_pro_selection neq 3>style="display:none;"</cfif> class="color-row">
						<td>&nbsp;</td>
						<td align="center" class="txtboldblue">18'<cf_get_lang no='206.den Küçük'></td>
						<td align="center" class="txtboldblue">18-25 <cf_get_lang no='748.Yaş'></td>
						<td align="center" class="txtboldblue">25 - 35 <cf_get_lang no='748.Yaş'></td>
						<td align="center" class="txtboldblue">35 - 50 <cf_get_lang no='748.Yaş'></td>
						<td align="center" class="txtboldblue">50 <cf_get_lang_main no='1976.Üstü'></td>
					</tr>
					<tr id="emp_branch_selection_4" <cfif attributes.emp_pro_selection neq 4>style="display:none;"</cfif> class="color-row">
						<td>&nbsp;</td>
						<td align="center" class="txtboldblue">0-1 <cf_get_lang_main no='1043.Yıl'></td>
						<td align="center" class="txtboldblue">1 -3 <cf_get_lang_main no='1043.Yıl'></td>
						<td align="center" class="txtboldblue">3-5 <cf_get_lang_main no='1043.Yıl'></td>
						<td align="center" class="txtboldblue">5 - 9 <cf_get_lang_main no='1043.Yıl'></td>
						<td align="center" class="txtboldblue">9 <cf_get_lang_main no='1043.Yıl'> <cf_get_lang_main no='1976.Üstü'> </td>
					</tr>
					<cfif get_branches.recordcount>
						<cfoutput query="get_branches">
							<cfquery name="get_total_full_positions" dbtype="query">
								SELECT EMPLOYEE_ID FROM get_emp_positions_det_ WHERE EMPLOYEE_ID <> 0 AND EMPLOYEE_ID IS NOT NULL AND COMPANY_ID = #comp_id# AND BRANCH_ID = #branch_id#
							</cfquery>
							<cfquery name="get_total_empty_positions" dbtype="query">
								SELECT EMPLOYEE_ID FROM get_emp_positions_det_ WHERE (EMPLOYEE_ID = 0 OR EMPLOYEE_ID IS NULL) AND COMPANY_ID = #comp_id# AND BRANCH_ID = #branch_id#
							</cfquery>
							<cfquery name="get_total_white_collar" dbtype="query">
								SELECT COLLAR_TYPE EMPTY_POSITIONS FROM get_emp_positions_det WHERE COLLAR_TYPE = 2 AND COMPANY_ID = #comp_id# AND BRANCH_ID = #branch_id#
							</cfquery>
							<cfquery name="get_total_blue_collar" dbtype="query">
								SELECT COLLAR_TYPE EMPTY_POSITIONS FROM get_emp_positions_det WHERE COLLAR_TYPE = 1 AND COMPANY_ID = #comp_id# AND BRANCH_ID = #branch_id#
							</cfquery>
							<cfquery name="get_total_emp_sex" dbtype="query">
								SELECT SEX  FROM get_emp_edu_det WHERE COMPANY_ID = #comp_id# AND BRANCH_ID = #branch_id#
							</cfquery>
							<cfquery name="get_total_emp_women" dbtype="query">
								SELECT SEX  FROM get_emp_edu_det WHERE SEX = 0  AND COMPANY_ID = #comp_id# AND BRANCH_ID = #branch_id#
							</cfquery>
							<cfquery name="get_total_emp_men" dbtype="query">
								SELECT SEX  FROM get_emp_edu_det WHERE SEX = 1 AND COMPANY_ID = #comp_id# AND BRANCH_ID = #branch_id#
							</cfquery>
							<tr id="emp_branch_selection_1_" <cfif attributes.emp_pro_selection neq 1>style="display:none;"</cfif>  class="color-row">
								<td class="txtbold" nowrap><a href="javascript://" OnClick="load_comp_dept('#branch_id#');">#get_branches.BRANCH_NAME#</a></td>
								<td align="center">#get_total_full_positions.recordcount#</td>
								<td align="center">#get_total_empty_positions.recordcount#</td>
								<td align="center">#get_total_emp_women.recordcount#</td>
								<td align="center">#get_total_emp_men.recordcount#</td>
								<td align="center">#get_total_white_collar.recordcount#</td>
								<td align="center">#get_total_blue_collar.recordcount#</td>
								<cfloop query="get_education_level">
									<cfquery name="get_total_emp_edu" dbtype="query">
										SELECT COUNT(LAST_SCHOOL) EMPLOYEE_NUMBER FROM get_emp_edu_det WHERE LAST_SCHOOL = #get_education_level.edu_level_id# AND COMPANY_ID = #get_branches.comp_id# AND BRANCH_ID = #get_branches.branch_id#
									</cfquery>
									<td align="center"><cfif get_total_emp_edu.recordcount>#get_total_emp_edu.EMPLOYEE_NUMBER#<cfelse>0</cfif></td>
								</cfloop>
								<td>&nbsp;</td>
							</tr>
							<tr id="emp_branch_selection_2_" <cfif attributes.emp_pro_selection neq 2>style="display:none;"</cfif> class="color-row">
								<td class="txtbold" nowrap><a href="javascript://" OnClick="load_comp_dept('#branch_id#');">#get_branches.BRANCH_NAME#</a></td>
								<cfif attributes.emp_pro_selection eq 2>
									<cfloop from="0" to="7" index="kk">
										<cfquery name="get_emp_age_blood_" dbtype="query">
											SELECT COUNT_BLOOD_TYPE FROM get_emp_age_blood WHERE COMPANY_ID = #comp_id# AND BRANCH_ID = #branch_id# AND BLOOD_TYPE = #kk#
										</cfquery>
										<td align="center">#get_emp_age_blood_.COUNT_BLOOD_TYPE#</td>
									</cfloop>
								</cfif>
							</tr>
							<tr id="emp_branch_selection_3_" <cfif attributes.emp_pro_selection neq 3>style="display:none;"</cfif> class="color-row">
								<td class="txtbold" nowrap><a href="javascript://" OnClick="load_comp_dept('#branch_id#');">#get_branches.BRANCH_NAME#</a></td>
								<cfif attributes.emp_pro_selection eq 3>
									<cfquery name="get_emp_age_18_" dbtype="query">
										SELECT COMPANY_ID FROM get_emp_age_18 WHERE COMPANY_ID = #comp_id# AND BRANCH_ID = #branch_id#
									</cfquery>
									<cfquery name="get_emp_age_25_" dbtype="query">
										SELECT COMPANY_ID FROM get_emp_age_25 WHERE COMPANY_ID = #comp_id# AND BRANCH_ID = #branch_id#
									</cfquery>
									<cfquery name="get_emp_age_35_" dbtype="query">
										SELECT COMPANY_ID FROM get_emp_age_35 WHERE COMPANY_ID = #comp_id# AND BRANCH_ID = #branch_id#
									</cfquery>
									<cfquery name="get_emp_age_50_" dbtype="query">
										SELECT COMPANY_ID FROM get_emp_age_50 WHERE COMPANY_ID = #comp_id# AND BRANCH_ID = #branch_id#
									</cfquery>
									<cfquery name="get_emp_age_50_ustu_" dbtype="query">
										SELECT COMPANY_ID FROM get_emp_age_50_ustu WHERE COMPANY_ID = #comp_id# AND BRANCH_ID = #branch_id#
									</cfquery>
									<td align="center">#get_emp_age_18_.recordcount#</td>
									<td align="center">#get_emp_age_25_.recordcount#</td>
									<td align="center">#get_emp_age_35_.recordcount#</td>
									<td align="center">#get_emp_age_50_.recordcount#</td>
									<td align="center">#get_emp_age_50_ustu_.recordcount#</td>
								</cfif>
							</tr>
							<tr id="emp_branch_selection_4_" <cfif attributes.emp_pro_selection neq 4>style="display:none;"</cfif> class="color-row">
								<td class="txtbold" nowrap><a href="javascript://" OnClick="load_comp_dept('#branch_id#');">#get_branches.BRANCH_NAME#</a></td>
								<cfif attributes.emp_pro_selection eq 4>
									<cfquery name="get_emp_kidem_1_" dbtype="query">
										SELECT COMPANY_ID FROM get_emp_kidem_1 WHERE COMPANY_ID = #comp_id#  AND BRANCH_ID = #branch_id#
									</cfquery>
									<cfquery name="get_emp_kidem_3_" dbtype="query">
										SELECT COMPANY_ID FROM get_emp_kidem_3 WHERE COMPANY_ID = #comp_id#  AND BRANCH_ID = #branch_id#
									</cfquery>
									<cfquery name="get_emp_kidem_5_" dbtype="query">
										SELECT COMPANY_ID FROM get_emp_kidem_5 WHERE COMPANY_ID = #comp_id#  AND BRANCH_ID = #branch_id#
									</cfquery>
									<cfquery name="get_emp_kidem_9_" dbtype="query">
										SELECT COMPANY_ID FROM get_emp_kidem_9 WHERE COMPANY_ID = #comp_id#  AND BRANCH_ID = #branch_id#
									</cfquery>
									<cfquery name="get_emp_kidem_9_ustu_" dbtype="query">
										SELECT COMPANY_ID FROM get_emp_kidem_9_ustu WHERE COMPANY_ID = #comp_id#  AND BRANCH_ID = #branch_id#
									</cfquery>
									<td align="center">#get_emp_kidem_1_.recordcount#</td>
									<td align="center">#get_emp_kidem_3_.recordcount#</td>
									<td align="center">#get_emp_kidem_5_.recordcount#</td>
									<td align="center">#get_emp_kidem_9_.recordcount#</td>
									<td align="center">#get_emp_kidem_9_ustu_.recordcount#</td>
								</cfif>
							</tr>
						</cfoutput>
					<cfelse>
						<tr class="color-row">
							<td class="txtbold" colspan="13"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
						</tr>
					</cfif>
				</table>
			</cfform>
		</td>
	</tr>	
</table>
</div>
<script language="javascript">
function load_comp_dept(branch_id)
{
	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.emptypopup_list_dept_details&comp_id='+document.form_branch_details.comp_id.value+'&branch_id='+branch_id+'&search_type='+document.form_branch_details.emp_pro_selection.value+'</cfoutput>','div_branch_details',1);
	return false;
}
function back_()
{
	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.emptypopup_list_company_details&search_type='+document.form_branch_details.emp_pro_selection.value+'&comp_id='+document.form_branch_details.comp_id.value+'</cfoutput>','div_branch_details',1);
	return false;
}
function change_branch_det(selection)
{
	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.emptypopup_list_branch_details&comp_id='+document.form_branch_details.comp_id.value+'&search_type='+selection+'</cfoutput>','div_branch_details',1);
	return true;
}

</script>
