<cfsetting showdebugoutput="no">
<cfset attributes.per_rot_id=attributes.action_id>
<cfquery name="GET_PER_FORM" datasource="#dsn#">
	SELECT
		*
	FROM
		PERSONEL_ROTATION_FORM
	WHERE
		ROTATION_FORM_ID=#attributes.per_rot_id#
</cfquery>
<cfif len(get_per_form.headquarters_exist)>
	<cfquery name="get_head_exist" datasource="#dsn#">
		SELECT
			HEADQUARTERS_ID,
			NAME
		FROM
			SETUP_HEADQUARTERS
		WHERE
			HEADQUARTERS_ID=#get_per_form.headquarters_exist#
	</cfquery>
</cfif>
<cfif len(get_per_form.company_exist)>
	<cfquery name="get_comp_exist" datasource="#dsn#">
		SELECT
			COMP_ID,
			NICK_NAME
		FROM
			OUR_COMPANY
		WHERE
			COMP_ID=#get_per_form.company_exist#
	</cfquery>
</cfif>
<cfif len(get_per_form.department_exist)>
	<cfquery name="get_dep_exist" datasource="#dsn#">
		SELECT
			DEPARTMENT_ID,
			DEPARTMENT_HEAD
		FROM
			DEPARTMENT
		WHERE
			DEPARTMENT_ID=#get_per_form.department_exist#
	</cfquery>
</cfif>
<cfquery name="get_exist" datasource="#dsn#">
	SELECT
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		POSITION_NAME
	FROM
		EMPLOYEE_POSITIONS
	WHERE
		POSITION_CODE=#GET_PER_FORM.POS_CODE_EXIST#
</cfquery>
<cfif len(get_per_form.pos_code_request)>
	<cfquery name="get_request" datasource="#dsn#">
		SELECT
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME,
			POSITION_NAME
		FROM
			EMPLOYEE_POSITIONS
		WHERE
			POSITION_CODE=#GET_PER_FORM.POS_CODE_REQUEST#
	</cfquery>
</cfif>
<cfif len(get_per_form.department_request)>
	<cfquery name="get_dep_request" datasource="#dsn#">
		SELECT
			DEPARTMENT_ID,
			DEPARTMENT_HEAD
		FROM
			DEPARTMENT
		WHERE
			DEPARTMENT_ID=#get_per_form.department_request#
	</cfquery>
</cfif>
<cfquery name="get_authority" datasource="#dsn#">
	SELECT 
		SLA.*,
		EP.POSITION_NAME,
		EP.EMPLOYEE_NAME,
		EP.EMPLOYEE_SURNAME
	FROM
		EMPLOYEES_APP_AUTHORITY SLA,
		EMPLOYEE_POSITIONS EP
	WHERE
		ROTATION_FORM_ID = #attributes.per_rot_id# AND
		EP.POSITION_CODE = SLA.POS_CODE
	ORDER BY
		SLA.VALID_DATE DESC
</cfquery>
<cf_box title="#getlang('','TERFİ-TRANSFER-ROTASYON TALEP FORMU',31344)#"  uidrop="1" responsive_table="1">
	<table width="650" height="700" align="center" cellpadding="0" cellspacing="0" border="0">
		<tr> 
		  <td class="headbold" align="center"><cf_get_lang dictionary_id="31344.TERFİ-TRANSFER-ROTASYON TALEP FORMU"></td>
		</tr>
		<tr valign="top"> 
			<td> 
			<table width="100%" align="center" cellpadding="2" cellspacing="1" border="1">
				<cfoutput>
				<tr> 
					<td><input type="checkbox"<cfif get_per_form.is_rise>checked</cfif>>&nbsp;<cf_get_lang dictionary_id="58567.TERFİ"></td>
					<td><input type="checkbox"<cfif get_per_form.is_transfer>checked</cfif>>&nbsp;<cf_get_lang dictionary_id="58568.TRANSFER"></td>
					<td><input type="checkbox"<cfif get_per_form.is_rotation>checked</cfif>>&nbsp;<cf_get_lang dictionary_id="58569.ROTASYON"></td>
					<td><input type="checkbox" <cfif get_per_form.is_salary_change>checked</cfif>>&nbsp;<cf_get_lang dictionary_id="58570.ÜCRET DEĞİŞİKLİĞİ"></td>
				</tr>
				<tr>
					<td colspan="2" width="325"><b><cf_get_lang dictionary_id="32370.ADI VE SOYADI"> :</b> #get_exist.employee_name# #get_exist.employee_surname#</td>
					<td colspan="2" width="325"><b><cf_get_lang dictionary_id="56542.SİCİL NO"> :</b> #get_per_form.sicil_no#</td>
				</tr>
				<tr>
					<td colspan="2"><b><cf_get_lang dictionary_id="57790.DOĞUM YERİ">/<cf_get_lang dictionary_id="58593.TARİHİ"> :</b> #get_per_form.emp_birth_city#/<cfif len(get_per_form.emp_birth_date)>#dateformat(get_per_form.emp_birth_date,dateformat_style)#</cfif></td>
					<td colspan="2"><b><cf_get_lang dictionary_id="38923.İŞE GİRİŞ TARİHİ"> :</b> <cfif len(get_per_form.work_startdate)>#dateformat(get_per_form.work_startdate,dateformat_style)#</cfif></td>
				</tr>
				<tr>
					<td colspan="2"><b><cf_get_lang dictionary_id="30929.ÖĞRENİM DURUMU"> :</b>
						<cfif len(get_per_form.training_level)>
							<cfquery name="get_edu_level" datasource="#dsn#">
								SELECT
									EDUCATION_NAME
								FROM
									SETUP_EDUCATION_LEVEL
								WHERE
									EDU_LEVEL_ID=#get_per_form.training_level#
							</cfquery>
						</cfif>
						<cfif isdefined("get_edu_level")>#get_edu_level.education_name#</cfif>
					</td>
					<td colspan="2"><b><cf_get_lang dictionary_id="35141.ASKERLİK DURUMU">:</b>
						<cfif get_per_form.military_status eq 0><cfset askerlik="Yapmadı">
						<cfelseif get_per_form.military_status eq 1><cfset askerlik="Yaptı">
						<cfelseif get_per_form.military_status eq 2><cfset askerlik="Muaf">
						<cfelseif get_per_form.military_status eq 3><cfset askerlik="Yabancı">
						<cfelseif get_per_form.military_status eq 4><cfset askerlik="Tecilli">
						<cfelse>
							<cfset askerlik="">
						</cfif>
						#askerlik#
					</td>
				</tr>
				<tr>
					<td colspan="2" class="txtbold" align="center"><cf_get_lang dictionary_id="58571.MEVCUT"></td>
					<td colspan="2" class="txtbold" align="center"><cf_get_lang dictionary_id="31181.TALEP EDİLEN"></td>
				</tr>
				<tr>
					<td>&nbsp;<cfif isdefined("get_head_exist")>#get_head_exist.name#</cfif></td>
					<td align="center" colspan="2" class="txtbold"><cf_get_lang dictionary_id="31765.GRUP BAŞKANLIĞI"></td>
					<td>&nbsp;<cfif isdefined("get_head_request")>#get_head_request.name#</cfif></td>
				</tr>
				<tr>
					<td>&nbsp;<cfif isdefined("get_comp_exist")>#get_comp_exist.nick_name#</cfif></td>
					<td align="center" colspan="2" class="txtbold"><cf_get_lang dictionary_id="57574.ŞİRKET"></td>
					<td>&nbsp;<cfif isdefined("get_head_request")>#get_head_request.nick_name#</cfif></td>
				</tr>
				<tr>
					<td>&nbsp;<cfif isdefined("get_dep_exist")>#get_dep_exist.department_head#</cfif></td>
					<td align="center" colspan="2" class="txtbold"><cf_get_lang dictionary_id="57572.DEPARTMAN"></td>
					<td>&nbsp;<cfif isdefined("get_dep_request")>#get_dep_request.department_head#</cfif></td>
				</tr>
				<tr>
					<td>&nbsp;#get_exist.position_name#</td>
					<td align="center" colspan="2" class="txtbold"><cf_get_lang dictionary_id="57571.UNVAN"></td>
					<td>&nbsp;<cfif len(get_per_form.pos_code_request)>#get_request.position_name#</cfif></td>
				</tr>
				<tr>
					<td>&nbsp;#TLFormat(get_per_form.salary_exist)# #get_per_form.salary_exist_money#</td>
					<td align="center" colspan="2" class="txtbold"><cf_get_lang dictionary_id="31282.ÜCRET"></td>
					<td>&nbsp;#TLFormat(get_per_form.salary_request)# #get_per_form.salary_request_money#</td>
				</tr>
				<tr>
					<td colspan="4" align="center" class="txtbold"><cf_get_lang dictionary_id="31766.ÖZLÜK HAKLARI"></td>
				</tr>
				<tr>
					<td>&nbsp;#get_per_form.tool_exist#</td>
					<td colspan="2" align="center" class="txtbold"><cf_get_lang dictionary_id="58480.Araç"></td>
					<td>&nbsp;#get_per_form.tool_request#</td>
				</tr>
				<tr>
					<td>&nbsp;#get_per_form.tel_exist#</td>
					<td colspan="2" align="center" class="txtbold"><cf_get_lang dictionary_id="57499.Telefon"></td>
					<td>&nbsp;#get_per_form.tel_request#</td>
				</tr>
				<tr>
					<td>&nbsp;#get_per_form.other_exist#</td>
					<td colspan="2" align="center" class="txtbold"><cf_get_lang dictionary_id="58156.Diğer"></td>
					<td>&nbsp;#get_per_form.other_request#</td>
				</tr>
				<tr>
					<td colspan="2"><b><cf_get_lang dictionary_id="54848.TAŞINMA YARDIMI TUTARI"> :</b> #TLFormat(get_per_form.move_amount)# #get_per_form.move_amount_money#</td>
					<td colspan="2"><b><cf_get_lang dictionary_id="31768.TAHMİNİ TAŞINMA TARİHİ"> :</b> #dateformat(get_per_form.move_date,dateformat_style)#</td>
				</tr>
				<tr>
					<td colspan="4">
						<table>
							<tr>
								<td height="50"><b><cf_get_lang dictionary_id="36199.AÇIKLAMA"> :</b> #get_per_form.detail#</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="4"><b><cf_get_lang dictionary_id="31769.TOPLAM ÇALIŞTIĞI SÜRE"> :</b> #get_per_form.work_year# <cf_get_lang dictionary_id="58455.Yıl"> - #get_per_form.work_month# <cf_get_lang dictionary_id="58724.Ay"> - #get_per_form.work_day# <cf_get_lang dictionary_id="57490.Gün"></td>
				</tr>
				<tr>
					<td colspan="2"><b><cf_get_lang dictionary_id="31770.YENİ GÖREVE BAŞLAMA TARİHİ"> :</b> #dateformat(get_per_form.new_start_date,dateformat_style)#</td>
					<td colspan="2"><b><cf_get_lang dictionary_id="51210.ROTASYON İSE TAMAMLANMA TARİHİ"> :</b> #dateformat(get_per_form.rotation_finish_date,dateformat_style)#</td>
				</tr>
				<tr>
					<td colspan="4" width="100%">
						<table cellpadding="1" cellspacing="2" width="100%">
							<tr>
								<td colspan="4"><strong><cf_get_lang dictionary_id="57500.ONAY"></strong></td>
							</tr>
							<cfif get_authority.recordcount>
							<tr>
								<td><b><cf_get_lang dictionary_id="57570.Ad Soyad"></b></td>
								<td><b><cf_get_lang dictionary_id="58497.Pozisyon"></b></td>
								<td><b><cf_get_lang dictionary_id="36912.Onaylama"></b></td>
								<td><b><cf_get_lang dictionary_id="32655.Onay Tarihi"></b></td>
							</tr>
							<cfloop query="get_authority">
							<tr>
								<td>#employee_name#&nbsp;#employee_surname#</td>
								<td>#position_name#</td>
								<td>#get_emp_info(valid_emp,0,0)#</td>
								<td>#dateformat(valid_date,'dd.mm.yyyy')#</td>
							</tr>
							</cfloop>
							</cfif>
						</cfoutput>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						</table>
					</td>
				</tr>
		</table>
		</td>
		</tr>
	</table>
</cf_box>

