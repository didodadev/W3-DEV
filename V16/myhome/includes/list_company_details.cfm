<cfsetting showdebugoutput="no">
<cfparam name="attributes.emp_pro_selection" default="#attributes.search_type#">
<cfparam name="attributes.comp_id" default="">
<cfinclude template="../query/get_list_employee_profile.cfm">
<cfquery name="get_company" datasource="#dsn#">
	SELECT
		COMP_ID,
		COMPANY_NAME,
		NICK_NAME
	FROM
		OUR_COMPANY
	ORDER BY
		COMPANY_NAME
</cfquery>
<cfquery name="get_education_level" datasource="#dsn#">
	SELECT EDU_LEVEL_ID,EDUCATION_NAME FROM SETUP_EDUCATION_LEVEL WHERE IS_ACTIVE = 1 AND EDU_LEVEL_ID IN(SELECT DISTINCT LAST_SCHOOL FROM EMPLOYEES_DETAIL WHERE LAST_SCHOOL IS NOT NULL ) ORDER BY EDU_LEVEL_ID
</cfquery>
<cfquery name="get_org_step" datasource="#dsn#">
	SELECT ORGANIZATION_STEP_ID,ORGANIZATION_STEP_NAME,ORGANIZATION_STEP_NO FROM SETUP_ORGANIZATION_STEPS ORDER BY ORGANIZATION_STEP_NAME
</cfquery>
<!--- <cfif get_company.recordcount gt 10>
	<div id="div_comp_details" style="position:absolute;width:100%;height:100%;overflow:auto;">
 <cfelse> --->
	<div id="div_comp_details"> 
<!--- </cfif> --->
<table cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
	<tr>
		<td valign="top" height="<cfoutput>#get_company.recordcount*21#</cfoutput>">
		<cfform name="emp_comp_profile" method="post" action="">
			<table width="100%" cellpadding="2" cellspacing="1" border="0" class="color-row">
				<tr>
					<td style="text-align:right" colspan="12">
						<select name="emp_pro_selection" id="emp_pro_selection" onChange="change_comp_profile_det(this.value);">
							<option value="1"><cf_get_lang_main no='322.Seçiniz'></option>
							<option value="2" <cfif attributes.emp_pro_selection eq 2>selected</cfif>><cf_get_lang_main no='1029.Kan Grubu'></option>
							<option value="3" <cfif attributes.emp_pro_selection eq 3>selected</cfif>><cf_get_lang no='748.Yaş'></option>
							<option value="4" <cfif attributes.emp_pro_selection eq 4>selected</cfif>><cf_get_lang no='642.Kıdem'></option> 
							<option value="5" <cfif attributes.emp_pro_selection eq 5>selected</cfif>>Eğitim Durumu</option> 
							<option value="6" <cfif attributes.emp_pro_selection eq 6>selected</cfif>>Kademe</option> 
						</select> 
					</td>
					<td width="5%"><a href="javascript://" onClick="back_();"><img src="/images/ac_c.gif" border="0"></a></td>
				</tr>
				<tr id="emp_comp_selection_1" <cfif attributes.emp_pro_selection neq 1>style="display:none;"</cfif> height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					<td class="txtbold"><cf_get_lang_main no='162.Şirket'></td>
					<td colspan="2" style="text-align:center;" class="txtbold"><cf_get_lang_main no='1085.Pozisyon'></td>
					<td colspan="2" style="text-align:center;" class="txtbold"><cf_get_lang_main no='164.Çalışan'></td>
					<td colspan="2" class="txtbold" style="text-align:center;"><cf_get_lang no='171.Yaka Tipi'></td>
					<!---<td width="15%" colspan="5" style="text-align:center;" class="txtbold"><cf_get_lang no='172.Öğrenim Durumu'></td>--->
				</tr>
				<tr id="emp_comp_selection_1_1" <cfif attributes.emp_pro_selection neq 1>style="display:none;"</cfif>  class="color-row">
					<td>&nbsp;</td>
					<td style="text-align:center;" class="txtboldblue"><cf_get_lang no='176.Dolu'></td>
					<td style="text-align:center;" class="txtboldblue"><cf_get_lang no='184.Boş'></td>
					<td style="text-align:center;" class="txtboldblue"><cf_get_lang_main no='1546.Kadın'></td>
					<td style="text-align:center;" class="txtboldblue"><cf_get_lang_main no='1547.Erkek'></td>
					<td style="text-align:center;" class="txtboldblue"><cfoutput>#getLang('hr',981)#</cfoutput></td>
					<td style="text-align:center;" class="txtboldblue"><cfoutput>#getLang('hr',980)#</cfoutput></td>
					<!---<cfoutput query="get_education_level">-
						<td align="center" class="txtboldblue">#Left(education_name,1)#</td>
					</cfoutput>--->
					<td>&nbsp;</td>
				</tr>
				<tr id="emp_comp_selection_2" <cfif attributes.emp_pro_selection neq 2>style="display:none;"</cfif> class="color-row">
					<td>&nbsp;</td>
					<td style="text-align:center;" class="txtboldblue">0 RH(+)</td>
					<td style="text-align:center;" class="txtboldblue">0 RH(-)</td>
					<td style="text-align:center;" class="txtboldblue">A RH(+)</td>
					<td style="text-align:center;" class="txtboldblue">A RH(-)</td>
					<td style="text-align:center;" class="txtboldblue">B RH(+)</td>
					<td style="text-align:center;" class="txtboldblue">B RH(-)</td>
					<td style="text-align:center;" class="txtboldblue">AB RH(+)</td>
					<td style="text-align:center;" class="txtboldblue">AB RH(-)</td>
				</tr>
				<tr id="emp_comp_selection_3" <cfif attributes.emp_pro_selection neq 3>style="display:none;"</cfif> class="color-row">
					<td>&nbsp;</td>
					<td style="text-align:center;" class="txtboldblue">18'<cf_get_lang no='206.den Küçük'></td>
					<td style="text-align:center;" class="txtboldblue">18-25 <cf_get_lang no='748.Yaş'></td>
					<td style="text-align:center;" class="txtboldblue">25 - 35 <cf_get_lang no='748.Yaş'></td>
					<td style="text-align:center;" class="txtboldblue">35 - 50 <cf_get_lang no='748.Yaş'></td>
					<td style="text-align:center;" class="txtboldblue">50 <cf_get_lang_main no='1976.Üstü'></td>
				</tr>
				<tr id="emp_comp_selection_4" <cfif attributes.emp_pro_selection neq 4>style="display:none;"</cfif> class="color-row">
		
					<td>&nbsp;</td>
					<td style="text-align:center;" class="txtboldblue">0-1 <cf_get_lang_main no='1043.Yıl'></td>
					<td style="text-align:center;" class="txtboldblue">1 -3 <cf_get_lang_main no='1043.Yıl'></td>
					<td style="text-align:center;" class="txtboldblue">3-5 <cf_get_lang_main no='1043.Yıl'></td>
					<td style="text-align:center;" class="txtboldblue">5 - 9 <cf_get_lang_main no='1043.Yıl'></td>
					<td style="text-align:center;" class="txtboldblue">9 <cf_get_lang_main no='1043.Yıl'> <cf_get_lang_main no='1976.Üstü'> </td>
				</tr>
				<tr id="emp_comp_selection_5" <cfif attributes.emp_pro_selection neq 5>style="display:none;"</cfif> class="color-row">
					<td><a href="javascript://" OnClick="load_our_company();"><cf_get_lang_main no='162.Şirket'></a></td>	
					<cfoutput query="get_education_level">
						<td style="text-align:center;" class="txtboldblue">#education_name#</td>
					</cfoutput>
				</tr>
				<tr id="emp_comp_selection_6" <cfif attributes.emp_pro_selection neq 6>style="display:none;"</cfif> class="color-row">
					<td><a href="javascript://" OnClick="load_our_company();"><cf_get_lang_main no='162.Şirket'></a></td>	
					<cfoutput query="get_org_step">
						<td style="text-align:center;" class="txtboldblue">#ORGANIZATION_STEP_NAME#</td>
					</cfoutput>
				</tr>
				 <cfif get_company.recordcount> 
					<cfoutput query="get_company">
						<cfquery name="get_total_full_positions" dbtype="query">
							SELECT EMPLOYEE_ID FROM get_emp_positions_det WHERE EMPLOYEE_ID <> 0 AND EMPLOYEE_ID IS NOT NULL AND COMPANY_ID = #comp_id# 
						</cfquery>
						<cfquery name="get_total_empty_positions" dbtype="query">
							SELECT EMPLOYEE_ID FROM get_emp_positions_det_ WHERE (EMPLOYEE_ID = 0 OR EMPLOYEE_ID IS NULL) AND COMPANY_ID = #comp_id#
						</cfquery>
						<cfquery name="get_total_white_collar" dbtype="query">
							SELECT COLLAR_TYPE EMPTY_POSITIONS FROM get_emp_positions_det WHERE COLLAR_TYPE = 2 AND COMPANY_ID = #comp_id#
						</cfquery>
						<cfquery name="get_total_blue_collar" dbtype="query">
							SELECT COLLAR_TYPE EMPTY_POSITIONS FROM get_emp_positions_det WHERE COLLAR_TYPE = 1 AND COMPANY_ID = #comp_id#
						</cfquery>
						<cfquery name="get_total_emp_sex" dbtype="query">
							SELECT SEX  FROM get_emp_edu_det WHERE COMPANY_ID = #comp_id#
						</cfquery>
						<cfquery name="get_total_emp_women" dbtype="query">
							SELECT SEX  FROM get_emp_edu_det WHERE SEX = 0 AND COMPANY_ID = #comp_id#
						</cfquery>
						<cfquery name="get_total_emp_men" dbtype="query">
							SELECT SEX  FROM get_emp_edu_det WHERE SEX = 1 AND COMPANY_ID = #comp_id#
						</cfquery>
						<tr id="emp_comp_selection_1_" <cfif attributes.emp_pro_selection neq 1>style="display:none;"</cfif>  class="color-row">
							<td class="txtbold" nowrap>#get_company.COMPANY_NAME#</td>
							<cfif attributes.emp_pro_selection eq 1>
								<td style="text-align:center;"><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&is_dolu=1&comp_id=#get_company.comp_id#','list')"  class="tableyazi">#get_total_full_positions.recordcount#</a></td>
								<td style="text-align:center;"><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&is_empty=1&comp_id=#get_company.comp_id#','list')"  class="tableyazi">#get_total_empty_positions.recordcount#</a></td>
								<td style="text-align:center;"><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&is_female=1&comp_id=#get_company.comp_id#','list')"  class="tableyazi">#get_total_emp_women.recordcount#</a></td>
								<td style="text-align:center;"><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&is_male=1&comp_id=#get_company.comp_id#','list')"  class="tableyazi">#get_total_emp_men.recordcount#</a></td>
								<td style="text-align:center;"><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&collar_type=2&comp_id=#get_company.comp_id#','list')"  class="tableyazi">#get_total_white_collar.recordcount#</a></td>
								<td style="text-align:center;"><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&collar_type=1&comp_id=#get_company.comp_id#','list')"  class="tableyazi">#get_total_blue_collar.recordcount#</a></td>
								<!---<cfloop query="get_education_level">
									<cfquery name="get_total_emp_edu" dbtype="query">
										SELECT COUNT(LAST_SCHOOL) EMPLOYEE_NUMBER FROM get_emp_edu_det WHERE LAST_SCHOOL = #get_education_level.edu_level_id# AND COMPANY_ID = #get_company.comp_id#
									</cfquery>
									<td style="text-align:center;"><cfif get_total_emp_edu.recordcount>#get_total_emp_edu.EMPLOYEE_NUMBER#<cfelse>0</cfif></td>
								</cfloop>--->
								<td>&nbsp;</td>
							</cfif>
						</tr>
						<tr id="emp_comp_selection_2_" <cfif attributes.emp_pro_selection neq 2>style="display:none;"</cfif> class="color-row">
							<td class="txtbold" nowrap>#get_company.company_name#</td>
							<cfif attributes.emp_pro_selection eq 2>
								<cfloop from="0" to="7" index="kk">
									<cfquery name="get_emp_age_blood_" dbtype="query">
										SELECT COUNT_BLOOD_TYPE FROM get_emp_age_blood WHERE COMPANY_ID = #comp_id# AND BLOOD_TYPE = #kk#
									</cfquery>
									<td style="text-align:center;"><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&blood_type=#kk#&comp_id=#comp_id#','list')"  class="tableyazi">#get_emp_age_blood_.COUNT_BLOOD_TYPE#</a></td>
								</cfloop>
							</cfif>
						</tr>
						<tr id="emp_comp_selection_3_" <cfif attributes.emp_pro_selection neq 3>style="display:none;"</cfif> class="color-row">
							<td class="txtbold" nowrap>#get_company.COMPANY_NAME#</td>
							<cfif attributes.emp_pro_selection eq 3>
								<cfquery name="get_emp_age_18_" dbtype="query">
									SELECT COMPANY_ID FROM get_emp_age_18 WHERE COMPANY_ID = #comp_id# 
								</cfquery>
								<cfquery name="get_emp_age_25_" dbtype="query">
									SELECT COMPANY_ID FROM get_emp_age_25 WHERE COMPANY_ID = #comp_id#
								</cfquery>
								<cfquery name="get_emp_age_35_" dbtype="query">
									SELECT COMPANY_ID FROM get_emp_age_35 WHERE COMPANY_ID = #comp_id#
								</cfquery>
								<cfquery name="get_emp_age_50_" dbtype="query">
									SELECT COMPANY_ID FROM get_emp_age_50 WHERE COMPANY_ID = #comp_id#
								</cfquery>
								<cfquery name="get_emp_age_50_ustu_" dbtype="query">
									SELECT COMPANY_ID FROM get_emp_age_50_ustu WHERE COMPANY_ID = #comp_id#
								</cfquery>
								<td style="text-align:center;"><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&age_18=1&comp_id=#comp_id#','list')"  class="tableyazi">#get_emp_age_18_.recordcount#</a></td>
								<td style="text-align:center;"><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&age_18_25=1&comp_id=#comp_id#','list')"  class="tableyazi">#get_emp_age_25_.recordcount#</a></td>
								<td style="text-align:center;"><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&age_25_35=1&comp_id=#comp_id#','list')"  class="tableyazi">#get_emp_age_35_.recordcount#</a></td>
								<td style="text-align:center;"><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&age_50=1&comp_id=#comp_id#','list')"  class="tableyazi">#get_emp_age_50_.recordcount#</a></td>
								<td style="text-align:center;"><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&age_50_=1&comp_id=#comp_id#','list')"  class="tableyazi">#get_emp_age_50_ustu_.recordcount#</a></td>
							</cfif>
						</tr>
						<tr id="emp_comp_selection_4_" <cfif attributes.emp_pro_selection neq 4>style="display:none;"</cfif> class="color-row">
							<td class="txtbold" nowrap>#get_company.COMPANY_NAME#</td>
							<cfif attributes.emp_pro_selection eq 4>
								<cfquery name="get_emp_kidem_1_" dbtype="query">
									SELECT COMPANY_ID FROM get_emp_kidem_1 WHERE COMPANY_ID = #comp_id#
								</cfquery>
								<cfquery name="get_emp_kidem_3_" dbtype="query">
									SELECT COMPANY_ID FROM get_emp_kidem_3 WHERE COMPANY_ID = #comp_id#
								</cfquery>
								<cfquery name="get_emp_kidem_5_" dbtype="query">
									SELECT COMPANY_ID FROM get_emp_kidem_5 WHERE COMPANY_ID = #comp_id# 
								</cfquery>
								<cfquery name="get_emp_kidem_9_" dbtype="query">
									SELECT COMPANY_ID FROM get_emp_kidem_9 WHERE COMPANY_ID = #comp_id# 
								</cfquery>
								<cfquery name="get_emp_kidem_9_ustu_" dbtype="query">
									SELECT COMPANY_ID FROM get_emp_kidem_9_ustu WHERE COMPANY_ID = #comp_id#
								</cfquery>
								<td style="text-align:center;"><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&kidem1=1&comp_id=#comp_id#','list')"  class="tableyazi">#get_emp_kidem_1_.recordcount#</a></td>
								<td style="text-align:center;"><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&kidem2=1&comp_id=#comp_id#','list')"  class="tableyazi">#get_emp_kidem_3_.recordcount#</a></td>
								<td style="text-align:center;"><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&kidem3=1&comp_id=#comp_id#','list')"  class="tableyazi">#get_emp_kidem_5_.recordcount#</a></td>
								<td style="text-align:center;"><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&kidem4=1&comp_id=#comp_id#','list')"  class="tableyazi">#get_emp_kidem_9_.recordcount#</a></td>
								<td style="text-align:center;"><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&kidem5=1&comp_id=#comp_id#','list')"  class="tableyazi">#get_emp_kidem_9_ustu_.recordcount#</a></td>
							</cfif>
						</tr>
						<tr id="emp_pro_selection_5_" <cfif attributes.emp_pro_selection neq 5>style="display:none;"</cfif>>
                            <td class="txtbold" nowrap="nowrap">#get_company.COMPANY_NAME#</td>
                            <cfloop query="get_education_level">
                                    <cfquery name="get_total_emp_edu" dbtype="query">
                                        SELECT LAST_SCHOOL FROM get_emp_edu_det WHERE LAST_SCHOOL = #get_education_level.edu_level_id# AND COMPANY_ID = #get_company.comp_id#
                                    </cfquery>
                                    <td style="text-align:center;"><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&edu_level_id=#get_education_level.edu_level_id#&comp_id=#get_company.comp_id#','list')"  class="tableyazi">#get_total_emp_edu.recordcount#</a></td>
                                </cfloop>
                        </tr>
						<tr id="emp_pro_selection_6_" <cfif attributes.emp_pro_selection neq 6>style="display:none;"</cfif>>
                            <td class="txtbold" nowrap>#get_company.COMPANY_NAME#</td>
                            <cfif attributes.emp_pro_selection eq 6>
                            	<cfloop query="get_org_step">
                                    <cfquery name="get_total_org_step" dbtype="query">
                                        SELECT COUNT_STEP_ID FROM get_emp_age_blood WHERE ORGANIZATION_STEP_ID = #ORGANIZATION_STEP_ID# AND COMPANY_ID = #get_company.comp_id#
                                    </cfquery>
                                    <td style="text-align:center;"><a href="##" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_profile_detail&org_step=#get_org_step.ORGANIZATION_STEP_NO#&comp_id=#get_company.comp_id#','list')"  class="tableyazi">#get_total_org_step.COUNT_STEP_ID#</a></td>
                                </cfloop>
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
function back_()
{
	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.emptypopup_list_employee_profile_ajaxempprofile&search_type='+document.emp_comp_profile.emp_pro_selection.value+'</cfoutput>','div_comp_details',1);
	return false;
}
function change_comp_profile_det(selection)
{
	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.emptypopup_list_company_details&search_type='+selection+'</cfoutput>','div_comp_details',1);
	return true;

}

</script>
