<cfsetting showdebugoutput="no">
<cfparam name="attributes.emp_pro_selection" default="#attributes.search_type#">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfinclude template="../query/get_list_employee_profile.cfm">
<cfquery name="get_dept_det" dbtype="query">
	SELECT 
		* 
	FROM 
		get_emp_positions_det 
	WHERE 
		COMPANY_ID = #comp_id# AND 
		BRANCH_ID = #branch_id# AND 
		DEPARTMENT_ID = #department_id# 
		<cfif isdefined("attributes.collar_type_") and len(attributes.collar_type_)>
			AND COLLAR_TYPE = #attributes.collar_type_#
		</cfif> 
</cfquery>
<cfset currentrow_ = 0>
<div id="div_dept_det">
<table width="98%" cellpadding="2" cellspacing="1" border="0" class="color-row">
	<tr>
		<td valign="top" height="<cfoutput>#get_dept_det.recordcount*21#</cfoutput>">
		<form name="form_dept_det" action="" method="post">
			<input type="hidden" name="comp_id" id="comp_id" value="<cfoutput>#attributes.comp_id#</cfoutput>">
			<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">	
			<input type="hidden" name="department_id" id="department_id" value="<cfoutput>#attributes.department_id#</cfoutput>">	
			<table width="100%" cellpadding="2" cellspacing="1" border="0" class="color-row">
				<tr>
					<td style="text-align:right" colspan="12">
						<select name="emp_pro_selection" id="emp_pro_selection" onChange="change_dept_det(this.value);">
							<option value="1"><cf_get_lang_main no='322.Seçiniz'></option>
							<option value="2" <cfif attributes.emp_pro_selection eq 2>selected</cfif>><cf_get_lang_main no='1029.Kan Grubu'></option>
							<option value="3" <cfif attributes.emp_pro_selection eq 3>selected</cfif>><cf_get_lang no='748.Yaş'></option>
							<option value="4" <cfif attributes.emp_pro_selection eq 4>selected</cfif>><cf_get_lang no='642.Kıdem'></option> 
						</select> 
					</td>
					<td width="3%"><a href="javascript://" onClick="back_();"><img src="/images/ac_c.gif" border="0"></a></td>
				</tr>
				<tr id="emp_pro_selection_1" <cfif attributes.emp_pro_selection neq 1>style="display:none;"</cfif> height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					<td align="left" class="txtbold"><cf_get_lang_main no='75.No'></td>
					<td align="left" class="txtbold"><cf_get_lang_main no='1592.Pozisyon Tipi'></td>
					<td align="left" class="txtbold"><cf_get_lang_main no='158.Ad Soyad'></td>
					<td align="left" class="txtbold"><cf_get_lang no='171.Yaka Tipi'></td>
					<td align="left" class="txtbold"><cf_get_lang_main no='352.Cinsiyet'></td>
					<td align="left" class="txtbold"><cf_get_lang no='172.Öğrenim Durumu'></td>
				</tr>
				<tr id="emp_pro_selection_2" <cfif attributes.emp_pro_selection neq 2>style="display:none;"</cfif> class="color-row">
					<td align="left" class="txtbold"><cf_get_lang_main no='75.No'></td>
					<td align="left" class="txtbold"><cf_get_lang_main no='1592.Pozisyon Tipi'></td>
					<td align="left" class="txtbold"><cf_get_lang_main no='158.Ad Soyad'></td>
					<td align="left" class="txtbold"><cf_get_lang_main no='1029.Kan Grubu'></td>
				</tr>
				<tr id="emp_pro_selection_3" <cfif attributes.emp_pro_selection neq 3>style="display:none;"</cfif> class="color-row">
					<td align="left" class="txtbold"><cf_get_lang_main no='75.No'></td>
					<td align="left" class="txtbold"><cf_get_lang_main no='1592.Pozisyon Tipi'></td>
					<td align="left" class="txtbold"><cf_get_lang_main no='158.Ad Soyad'></td>
					<td align="left" class="txtbold"><cf_get_lang no='748.Yaş'></td>
				</tr>
				<tr id="emp_pro_selection_4" <cfif attributes.emp_pro_selection neq 4>style="display:none;"</cfif> class="color-row">
					<td align="left" class="txtbold"><cf_get_lang_main no='75.No'></td>
					<td align="left" class="txtbold"><cf_get_lang_main no='1592.Pozisyon Tipi'></td>
					<td align="left" class="txtbold"><cf_get_lang_main no='158.Ad Soyad'></td>
					<td align="left" class="txtbold"><cf_get_lang no='642.Kıdem'></td>
				</tr>
				<cfif get_dept_det.recordcount>
				<cfoutput query="get_dept_det">
					<cfif len(employee_id)>
						<cfquery name="get_emp_det" dbtype="query">
							SELECT 
								SEX,
								LAST_SCHOOL 
							FROM 
								get_emp_edu_det 
							WHERE 
								EMPLOYEE_ID = #employee_id#  
								<cfif isdefined("attributes.sex_") and len(attributes.sex_)>
									AND SEX = #attributes.sex_#
								</cfif> 
								<cfif isdefined("attributes.last_school_") and len(attributes.last_school_)>
									AND LAST_SCHOOL = #attributes.last_school_#
								</cfif> 
						</cfquery>
						<cfif len(get_emp_det.last_school)>
							 <cfquery name="get_education_level" datasource="#dsn#">
								SELECT EDUCATION_NAME FROM SETUP_EDUCATION_LEVEL WHERE EDU_LEVEL_ID = #get_emp_det.LAST_SCHOOL#
							</cfquery>
						</cfif>
					</cfif>
					<cfif len(employee_id)>
					<tr id="emp_pro_selection_1_" <cfif attributes.emp_pro_selection neq 1>style="display:none;"</cfif>  class="color-row">
						<td align="left">#currentrow#</td>
						<td align="left">#position_name#</td>
						<td align="left"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#emp_name#</a></td>
						<td align="left"><cfif get_dept_det.collar_type eq 2><cf_get_lang no='201.Beyaz'><cfelseif get_dept_det.collar_type eq 1><cf_get_lang no='203.Mavi'></cfif></td>
						<td align="left"><cfif isdefined("get_emp_det.sex") and get_emp_det.sex eq 1><cf_get_lang_main no='1547.Erkek'><cfelse><cf_get_lang_main no='1546.Kadın'></cfif></td>
						<td align="left"><cfif isdefined("get_education_level") and get_education_level.recordcount>#get_education_level.education_name#</cfif></td>
						<td>&nbsp;</td>
					</tr>
					</cfif>
					<cfif attributes.emp_pro_selection eq 2>
						<cfquery name="get_emp_age_blood_" dbtype="query">
							SELECT BLOOD_TYPE FROM get_emp_age_blood WHERE COMPANY_ID = #comp_id# AND BRANCH_ID = #branch_id# AND DEPARTMENT_ID = #department_id# AND EMPLOYEE_ID = #employee_id# <cfif isdefined('attributes.blood_type') and len(attributes.blood_type)>AND BLOOD_TYPE = #attributes.blood_type#</cfif>
						</cfquery>
						<cfif len(get_emp_age_blood_.recordcount)>
							<cfif len(get_emp_age_blood_.blood_type)>
								<cfset currentrow_ = currentrow_ + 1>
								<tr id="emp_pro_selection_2_" <cfif attributes.emp_pro_selection neq 2>style="display:none;"</cfif> class="color-row">
									<td align="left">#currentrow_#</td>
									<td align="left">#position_name#</td>
									<td align="left"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#emp_name#</a></td>
									<td align="left">
										<cfif get_emp_age_blood_.BLOOD_TYPE eq 0>
											0 RH(+)
										<cfelseif get_emp_age_blood_.BLOOD_TYPE eq 1>
											0 RH(-)
										<cfelseif get_emp_age_blood_.BLOOD_TYPE eq 2>
											A RH(+)
										<cfelseif get_emp_age_blood_.BLOOD_TYPE eq 3>
											A RH(-)
										<cfelseif get_emp_age_blood_.BLOOD_TYPE eq 4>
											B RH(+)
										<cfelseif get_emp_age_blood_.BLOOD_TYPE eq 5>
											B RH(-)
										<cfelseif get_emp_age_blood_.BLOOD_TYPE eq 6>
											AB RH(+)
										<cfelseif get_emp_age_blood_.BLOOD_TYPE eq 7>
											AB RH(-)
										</cfif>
									</td>
								</tr>
							</cfif>
						</cfif> 
					</cfif> 
					<cfif attributes.emp_pro_selection eq 3>
						<cfquery name="get_emp_age" dbtype="query">
							SELECT AGE FROM get_emp_age_blood WHERE COMPANY_ID = #comp_id# AND BRANCH_ID = #branch_id# AND DEPARTMENT_ID = #department_id# AND EMPLOYEE_ID = #employee_id#  <cfif isdefined("attributes.age") and len(attributes.age)>AND AGE >= #listfirst(attributes.age,'-')# AND AGE < #listlast(attributes.age,'-')#</cfif>
						</cfquery>
						<cfif get_emp_age.recordcount>
							<cfif len(get_emp_age.age)>
								<cfset currentrow_ = currentrow_ + 1>
								<tr id="emp_pro_selection_3_" <cfif attributes.emp_pro_selection neq 3>style="display:none;"</cfif> class="color-row">
									<td align="left">#currentrow_#</td>
									<td align="left">#position_name#</td>
									<td align="left"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#emp_name#</a></td>
									<td align="left">&nbsp;#get_emp_age.age#</td>
								</tr>
							</cfif>
						</cfif> 
					</cfif>
					<cfif attributes.emp_pro_selection eq 4>
						<cfquery name="get_emp_kidem" dbtype="query">
							SELECT KIDEM FROM get_emp_age_blood WHERE COMPANY_ID = #comp_id#  AND BRANCH_ID = #branch_id# AND DEPARTMENT_ID = #department_id# AND EMPLOYEE_ID = #employee_id#   <cfif isdefined("attributes.kidem") and len(attributes.kidem)>AND KIDEM >= #listfirst(attributes.kidem,'-')# AND KIDEM < #listlast(attributes.kidem,'-')#</cfif> 
						</cfquery>
						<cfif get_emp_kidem.recordcount>
							<cfif len(get_emp_kidem.kidem)>
								<cfset currentrow_ = currentrow_ + 1>
								<tr id="emp_pro_selection_4_" <cfif attributes.emp_pro_selection neq 4>style="display:none;"</cfif> class="color-row">
									<td align="left">#currentrow_#</td>
									<td align="left">#position_name#</td>
									<td align="left"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#emp_name#</a></td>
									<td align="left">#get_emp_kidem.kidem#</td>
									
								</tr>
							</cfif>
						</cfif> 
					</cfif>
				</cfoutput>
			</table>
			<cfelse>
				<tr class="color-row">
					<td class="txtbold" colspan="7"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
				</tr>
			</cfif>
		</form>
	</td>
</tr>
</table>
</div>
<script language="javascript">
function back_()
{
	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.emptypopup_list_dept_details&search_type='+document.form_dept_det.emp_pro_selection.value+'&comp_id='+document.form_dept_det.comp_id.value+'&branch_id='+document.form_dept_det.branch_id.value+'&department_id='+document.form_dept_det.department_id.value+'</cfoutput>','div_dept_details',1);
	return false;
}
function change_dept_det(selection)
{
	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.emptypopup_list_dept_det&comp_id='+document.form_dept_det.comp_id.value+'&branch_id='+document.form_dept_det.branch_id.value+'&department_id='+document.form_dept_det.department_id.value+'&search_type='+selection+'</cfoutput>','div_dept_det',1);
	return true;
}

</script>

