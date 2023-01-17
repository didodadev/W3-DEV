<cfscript>
	all_days = 30;
	t_sgdp_devir = 0; // Sosyal güvenlik destek primi 
	t_devirden_gelen = 0;
	t_toplam_kazanc = 0;
	t_ssk_primi_isci = 0;
	t_ssk_primi_isci_devirsiz = 0;
	t_ssk_primi_isveren_hesaplanan = 0;
	t_ssk_primi_isveren = 0;
	t_ssk_primi_isveren_gov = 0;
	t_ssk_primi_isveren_5921 = 0;
	t_ssk_primi_isveren_5746 = 0;
	t_ssk_primi_isveren_6111 = 0;
	t_issizlik_isci_hissesi = 0;
	t_issizlik_isci_hissesi_devirsiz = 0;
	t_issizlik_isveren_hissesi = 0;
	t_ext_work_hours_0 = 0;
	t_ext_work_hours_1 = 0;
	t_ext_work_hours_2 = 0;
	t_ext_work_hours_5 = 0;
	t_ssdf_isveren_hissesi = 0;
	t_ext_salary = 0;
	t_ext_salary_0 = 0;
	t_ext_salary_1 = 0;
	t_ext_salary_2 = 0;
	t_ext_salary_3 = 0;
	t_ext_salary_5 = 0;
	t_toplam_kazanc2 = 0;
	genel_odenek_total2 = 0;
	t_ext_Salary2 = 0;
	genel_odenek_total = 0;
	fazla_mesai_resmi_tatil = 0;
	fazla_mesai_hafta_ici = 0;
	fazla_mesai_45 = 0;
	fazla_mesai_hafta_sonu = 0;
	fazla_mesai_gece_calismasi = 0;
	get_branch_profile_det.recordcount = 0;
	get_branch_profile_det_.recordcount = 0;
	get_branch_profile_det2_.recordcount = 0;
</cfscript>
<!--- maliyet-mesai-toplam kazanc --->
<!---<cfif attributes.dept_selection neq 4>--->
	<cfquery name="get_odeneks_" datasource="#dsn#">
		SELECT * FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE  EXT_TYPE = 0 ORDER BY COMMENT_PAY
	</cfquery>
	<!--- ilgili ay ve yıl icin puantaj kaydi getirir --->
	<cfquery name="get_branch_profile_det_main" datasource="#dsn#">
		SELECT 
			E.KIDEM_DATE,
			EPR.*,
			EP.*,
			B.BRANCH_FULLNAME,
			EIO.USE_SSK,
			EIO.BRANCH_ID,
			EIO.PUANTAJ_GROUP_IDS
		FROM
			EMPLOYEES_PUANTAJ EP,
			EMPLOYEES_PUANTAJ_ROWS EPR,
			EMPLOYEES_IN_OUT EIO,
			EMPLOYEES E,
			DEPARTMENT D,
			BRANCH B
		WHERE	
			EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND	
			EPR.IN_OUT_ID = EIO.IN_OUT_ID AND
			E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
			EIO.DEPARTMENT_ID = D.DEPARTMENT_ID AND
			EIO.BRANCH_ID = B.BRANCH_ID AND
			B.COMPANY_ID = #comp_id# AND
			B.BRANCH_ID = #branch_id# AND
			D.DEPARTMENT_ID = #department_id# AND
			EP.SAL_YEAR = #session.ep.period_year#
	</cfquery>
	<cfquery name="get_branch_profile_det" dbtype="query">
		SELECT 
			*
		FROM
			get_branch_profile_det_main
		WHERE	
			SAL_MON = #attributes.sal_mon# 
	</cfquery>
	<!--- fazla mesaisi olan puantajlari getirir --->
	<cfquery name="get_branch_profile_det_" dbtype="query">
		SELECT
			EXT_SALARY
		FROM
			get_branch_profile_det
		WHERE
			EXT_SALARY > 0
	</cfquery>

	<!---  toplam kazanc artis oranini hesaplarken kullanildi, bir onceki ayla kiyaslandi--->
	<cfquery name="get_branch_profile_det2_" datasource="#dsn#">
		SELECT
			EP.*,
			EPR.* ,
			E.IZIN_DATE,
			(SELECT BRANCH_ID FROM EMPLOYEES_IN_OUT WHERE IN_OUT_ID =EPR.IN_OUT_ID) AS BRANCH_ID,
			(SELECT PUANTAJ_GROUP_IDS FROM EMPLOYEES_IN_OUT WHERE IN_OUT_ID =EPR.IN_OUT_ID) AS PUANTAJ_GROUP_IDS
		FROM
			EMPLOYEES_PUANTAJ EP,
			EMPLOYEES_PUANTAJ_ROWS EPR,
			EMPLOYEES E 
		WHERE
			EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND  
			E.EMPLOYEE_ID = EPR.EMPLOYEE_ID
		 <cfif attributes.sal_mon eq 1>
			AND SAL_MON = 12 
			AND SAL_YEAR = #session.ep.period_year-1#
		<cfelse> 
			AND SAL_MON = #attributes.sal_mon-1# 
			AND SAL_YEAR = #session.ep.period_year#
		 </cfif> 
	</cfquery>
	<cfloop query="get_branch_profile_det">
		<cfset attributes.branch_id = branch_id>
		<cfif len(puantaj_group_ids)>
			<cfset attributes.group_id = "#PUANTAJ_GROUP_IDS#,">
		</cfif>
		<cfset not_kontrol_parameter = 1>
		<cfset attributes.sal_year = sal_year>
		<cfset attributes.sal_mon = sal_mon> 
		<cfinclude template="../../hr/ehesap/query/get_program_parameter.cfm">
		 <cfquery name="get_odeneks" dbtype="query">
			SELECT * FROM get_odeneks_ WHERE EMPLOYEE_PUANTAJ_ID = #get_branch_profile_det.employee_puantaj_id#
		</cfquery>
		<cfoutput query="get_odeneks" group="COMMENT_PAY">
			<cfset tmp_total = 0>
			<cfoutput>
				<cfif PAY_METHOD eq 2>
					<cfset tmp_total = tmp_total + amount_2>
				<cfelse>
					<cfset tmp_total = tmp_total + amount>
				</cfif>
			</cfoutput>
			<cfset genel_odenek_total = genel_odenek_total + tmp_total>
		</cfoutput> 
		<cfscript>
			total_salary_ = TOTAL_SALARY - (EXT_SALARY + total_pay_ssk_tax + total_pay_tax + total_pay_ssk + total_pay);
			t_toplam_kazanc = t_toplam_kazanc + total_salary_ - VERGI_ISTISNA_VERGI;
			if(len(get_program_parameters.EX_TIME_PERCENT_HIGH))
				fazla_mesai_45 = EXT_TOTAL_HOURS_3 * get_program_parameters.EX_TIME_PERCENT_HIGH / 100;// 45 saati asan kisim
			if(len(get_program_parameters.EX_TIME_PERCENT))
				fazla_mesai_hafta_ici = (EXT_TOTAL_HOURS_0-EXT_TOTAL_HOURS_3) * get_program_parameters.EX_TIME_PERCENT / 100;
	
			if(len(get_program_parameters.WEEKEND_MULTIPLIER))
				fazla_mesai_hafta_sonu = (EXT_TOTAL_HOURS_1 * get_program_parameters.WEEKEND_MULTIPLIER);
			else if(len(get_program_parameters.EX_TIME_PERCENT))
				fazla_mesai_hafta_sonu = (EXT_TOTAL_HOURS_1 * get_program_parameters.EX_TIME_PERCENT / 100);
	
			if(len(get_program_parameters.OFFICIAL_MULTIPLIER))	
				fazla_mesai_resmi_tatil = EXT_TOTAL_HOURS_2 * get_program_parameters.OFFICIAL_MULTIPLIER; // resmi tatil
			else
				fazla_mesai_resmi_tatil = EXT_TOTAL_HOURS_2 * 100 / 100; // resmi tatil
			if(len(get_program_parameters.EX_TIME_PERCENT_HIGH))			
				fazla_mesai_45 = EXT_TOTAL_HOURS_3 * get_program_parameters.EX_TIME_PERCENT_HIGH / 100;// 45 saati asan kisim
	
			fazla_mesai_gece_calismasi = (EXT_TOTAL_HOURS_5 * 10 / 100);
			fazla_mesai_toplam = fazla_mesai_hafta_ici + fazla_mesai_hafta_sonu + fazla_mesai_resmi_tatil + fazla_mesai_45 + fazla_mesai_gece_calismasi;
			if (fazla_mesai_toplam neq 0)
			{
				t_ext_salary_0 = t_ext_salary_0 + ((EXT_SALARY/fazla_mesai_toplam) * (fazla_mesai_hafta_ici + fazla_mesai_45));
				t_ext_salary_1 = t_ext_salary_1 + ((EXT_SALARY/fazla_mesai_toplam) * fazla_mesai_hafta_sonu);
				t_ext_salary_2 = t_ext_salary_2 + ((EXT_SALARY/fazla_mesai_toplam) * fazla_mesai_resmi_tatil);
				t_ext_salary_5 = t_ext_salary_5 + ((EXT_SALARY/fazla_mesai_toplam) * fazla_mesai_gece_calismasi); // Gece Çalışması Ücreti
			}
			t_ext_Salary = t_ext_salary_0 + t_ext_salary_1 + t_ext_salary_2 + t_ext_salary_5;
			t_issizlik_isveren_hissesi = t_issizlik_isveren_hissesi + issizlik_isveren_hissesi;
			if (use_ssk eq 1)
			
			{
				isveren_hesaplanan = ssk_isveren_hissesi + ssk_isveren_hissesi_5510 + ssk_isveren_hissesi_5084;
				t_ssk_primi_isveren_hesaplanan = t_ssk_primi_isveren_hesaplanan + isveren_hesaplanan;
				t_issizlik_isci_hissesi = t_issizlik_isci_hissesi + issizlik_isci_hissesi;
			}
			t_ssdf_isveren_hissesi = t_ssdf_isveren_hissesi + ssdf_isveren_hissesi;
			t_ssk_primi_isci = t_ssk_primi_isci + ssk_isci_hissesi;
			ssk_devir_toplam = 0;
			if(len(ssk_devir))
			{
				ssk_devir_toplam = ssk_devir_toplam + ssk_devir;
				t_devirden_gelen = t_devirden_gelen + ssk_devir;
			}
			if(ssk_isci_hissesi gt 0 and ssk_devir_toplam gt 0)
				t_ssk_primi_isci_devirsiz = t_ssk_primi_isci_devirsiz + wrk_round((SSK_MATRAH - ssk_devir_toplam) * 14 / 100);
			else
				t_ssk_primi_isci_devirsiz = t_ssk_primi_isci_devirsiz + ssk_isci_hissesi;
			
			ssk_devir_toplam = 0;
			if(len(ssk_devir))
			{
				ssk_devir_toplam = ssk_devir_toplam + ssk_devir;
				t_devirden_gelen = t_devirden_gelen + ssk_devir;
			}
			if(issizlik_isci_hissesi gt 0 and ssk_devir_toplam gt 0)
				t_issizlik_isci_hissesi_devirsiz = t_issizlik_isci_hissesi_devirsiz + wrk_round((SSK_MATRAH - ssk_devir_toplam) * 1 / 100);
			else
				t_issizlik_isci_hissesi_devirsiz = t_issizlik_isci_hissesi_devirsiz + issizlik_isci_hissesi;
			if(len(SSK_ISCI_HISSESI_DUSULECEK) and ssdf_isveren_hissesi gt 0)
				t_sgdp_devir = t_sgdp_devir + SSK_ISCI_HISSESI_DUSULECEK;
			t_ssk_primi_isveren = t_ssk_primi_isveren + ssk_isveren_hissesi;
			if(len(ssk_isveren_hissesi_gov))
				t_ssk_primi_isveren_gov = t_ssk_primi_isveren_gov + ssk_isveren_hissesi_gov;
			else
				t_ssk_primi_isveren_gov = t_ssk_primi_isveren_gov + 0;
				t_ssk_primi_isveren_5921 = t_ssk_primi_isveren_5921 + ssk_isveren_hissesi_5921;
				t_ssk_primi_isveren_5746 = t_ssk_primi_isveren_5746 + ssk_isveren_hissesi_5746;
				t_ssk_primi_isveren_6111 = t_ssk_primi_isveren_6111 + ssk_isveren_hissesi_6111;
				t_ext_work_hours_0 = t_ext_work_hours_0 + EXT_TOTAL_HOURS_0;
				t_ext_work_hours_1 = t_ext_work_hours_1 + EXT_TOTAL_HOURS_1;
				t_ext_work_hours_2 = t_ext_work_hours_2 + EXT_TOTAL_HOURS_2;
		</cfscript>
	</cfloop>
	<!---  toplam kazanc artis oranini hesaplarken kullanildi--->
	<cfloop query="get_branch_profile_det2_">
		<cfset attributes.branch_id = branch_id>
		<cfif len(puantaj_group_ids)>
			<cfset attributes.group_id = "#PUANTAJ_GROUP_IDS#,">
		</cfif>
		<cfset not_kontrol_parameter = 1>
		<cfset attributes.sal_mon = get_branch_profile_det2_.sal_mon>
		<cfset attributes.sal_year = get_branch_profile_det2_.sal_year> 
		<cfinclude template="../../hr/ehesap/query/get_program_parameter.cfm">
		 <cfquery name="get_odeneks" dbtype="query">
			SELECT * FROM get_odeneks_ WHERE EMPLOYEE_PUANTAJ_ID = #get_branch_profile_det2_.employee_puantaj_id#
		</cfquery>
		 <cfoutput query="get_odeneks" group="COMMENT_PAY">
			<cfset tmp_total = 0>
			<cfoutput>
				<cfif PAY_METHOD eq 2>
					<cfset tmp_total = tmp_total + amount_2>
				<cfelse>
					<cfset tmp_total = tmp_total + amount>
				</cfif>
			</cfoutput>
			<cfset genel_odenek_total2 = genel_odenek_total2 + tmp_total>
		</cfoutput>  
		<cfscript>
			total_salary_ = TOTAL_SALARY - (EXT_SALARY + total_pay_ssk_tax + total_pay_tax + total_pay_ssk + total_pay);
			//t_toplam_kazanc2 = t_toplam_kazanc2 + total_salary_ - VERGI_ISTISNA_VERGI;
			t_toplam_kazanc2 = 0;
			if(len(get_program_parameters.EX_TIME_PERCENT_HIGH))
				fazla_mesai_45 = EXT_TOTAL_HOURS_3 * get_program_parameters.EX_TIME_PERCENT_HIGH / 100;// 45 saati asan kisim
			fazla_mesai_toplam = fazla_mesai_hafta_ici + fazla_mesai_hafta_sonu + fazla_mesai_resmi_tatil + fazla_mesai_45 + fazla_mesai_gece_calismasi;
			if (fazla_mesai_toplam neq 0)
			{
				t_ext_salary_0 = t_ext_salary_0 + ((EXT_SALARY/fazla_mesai_toplam) * (fazla_mesai_hafta_ici + fazla_mesai_45));
				t_ext_salary_1 = t_ext_salary_1 + ((EXT_SALARY/fazla_mesai_toplam) * fazla_mesai_hafta_sonu);
				t_ext_salary_2 = t_ext_salary_2 + ((EXT_SALARY/fazla_mesai_toplam) * fazla_mesai_resmi_tatil);
				t_ext_salary_5 = t_ext_salary_5 + ((EXT_SALARY/fazla_mesai_toplam) * fazla_mesai_gece_calismasi); // Gece Çalışması Ücreti
			}
			t_ext_Salary2 = t_ext_salary_0 + t_ext_salary_1 + t_ext_salary_2 + t_ext_salary_5;
		</cfscript>
	</cfloop>
<!---</cfif>--->
<!--- giris_cikis --->
<cfset month_day_ = 0>
<cfset month_start_ = 0>
<cfset month_finish_ = 0>
<cfset get_emp_in_det.emp_in_total = 0>
<cfset get_emp_out_det.emp_out_total = 0>
<cfset emp_number_previous_month = 0>
<cfset get_emp_in_total_ = 0>
<cfset get_emp_out_total_ = 0>
<cfset emp_number_ = 0>
<cfset get_emp_in_the_past = 0>
<cfset get_emp_in_the_past_ = 0>
<cfset GET_EMP_OUT_TOTAL_PREVIOUS_MONTH  = 0>
<cfif attributes.dept_selection eq 4>
	<cfquery name="get_emp_in_out_det" datasource="#dsn#">
		SELECT 
			E.EMPLOYEE_ID,
			EIO.START_DATE,
			EIO.FINISH_DATE,
			E.KIDEM_DATE
		FROM 
			EMPLOYEES_IN_OUT EIO,
			EMPLOYEES E,
			BRANCH B
		WHERE
			B.BRANCH_ID = EIO.BRANCH_ID AND
			E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
			EIO.EXPLANATION_ID <> 18 AND<!--- worknet-nakil ---> 
			B.COMPANY_ID = #comp_id# AND
			B.BRANCH_ID = #branch_id# AND
			EIO.DEPARTMENT_ID = #department_id#
	</cfquery>
	<!---<cfloop from="1" to="12" index="month3_">--->
		<cfset month_day_ = daysinmonth(CREATEDATE(session.ep.period_year,attributes.sal_mon,1))>
		<cfset month_start_ = CREATEDATE(session.ep.period_year,attributes.sal_mon,1)>
		<cfset month_finish_ = CREATEDATE(session.ep.period_year,attributes.sal_mon,month_day_)>
		
		<cfquery name="get_emp_in_det" dbtype="query">
			SELECT 
				EMPLOYEE_ID
			FROM 
				get_emp_in_out_det
			WHERE
				START_DATE >= #month_start_#  AND
				START_DATE <= #month_finish_#
		</cfquery>
		<cfset get_emp_in_total_ = get_emp_in_det.recordcount>
		<cfquery name="get_emp_out_det" dbtype="query">
			SELECT 
				EMPLOYEE_ID
			FROM 
				get_emp_in_out_det
			WHERE
				FINISH_DATE >= #month_start_#  AND
				FINISH_DATE <= #month_finish_#
		</cfquery>
		<cfquery name="get_emp_out_det_previous_month" dbtype="query">
			SELECT 
				EMPLOYEE_ID
			FROM 
				get_emp_in_out_det
			WHERE
				FINISH_DATE >= #dateadd('m',-1,month_start_)#  AND
				FINISH_DATE <= #dateadd('m',-1,month_finish_)#
		</cfquery>
		<cfset get_emp_out_total_ =  get_emp_out_det.recordcount>
		<cfset get_emp_out_total_previous_month =  get_emp_out_det_previous_month.recordcount>
		<cfquery name="get_branch_profile_previous_month" dbtype="query">
			SELECT * FROM get_branch_profile_det_main WHERE SAL_MON = #attributes.sal_mon-1#
		</cfquery>
		<cfset emp_number_previous_month = get_branch_profile_previous_month.recordcount>
		<cfif get_branch_profile_det.recordcount>
			
			<!---kidem tarihi bir yildan once olanlar--->
			<cfquery name="get_emp_in_the_past" dbtype="query">
				SELECT 
					KIDEM_DATE
				FROM 
					get_branch_profile_det
				WHERE
					KIDEM_DATE <= #dateadd('yyyy',-1,month_finish_)# AND
					SAL_MON = #attributes.sal_mon# 
			</cfquery>
			<cfquery name="get_emp_in_the_past2_" dbtype="query">
				SELECT 
					KIDEM_DATE
				FROM 
					get_emp_in_out_det
				WHERE
					KIDEM_DATE <= #dateadd('yyyy',-1,month_finish_)# AND
					FINISH_DATE >= #month_start_#  AND
					FINISH_DATE <= #month_finish_#
			</cfquery>
			<cfset get_emp_in_the_past = get_emp_in_the_past.recordcount - get_emp_in_the_past2_.recordcount>
			<!---kidem tarihi son bir yil olanlar--->
			<cfquery name="get_emp_in_the_past_" dbtype="query">
				SELECT 
					KIDEM_DATE
				FROM 
					get_branch_profile_det
				WHERE
					KIDEM_DATE > #dateadd('yyyy',-1,month_finish_)#  AND
					SAL_MON = #attributes.sal_mon# 
			</cfquery>
			<cfquery name="get_emp_in_the_past_2_" dbtype="query">
				SELECT 
					KIDEM_DATE
				FROM 
					get_emp_in_out_det
				WHERE
					KIDEM_DATE > #dateadd('yyyy',-1,month_finish_)#  AND
					FINISH_DATE >= #month_start_#  AND
					FINISH_DATE <= #month_finish_#
			</cfquery>
			<cfset get_emp_in_the_past_ = get_emp_in_the_past_.recordcount - get_emp_in_the_past_2_.recordcount>
		<cfelse>
			<cfset get_emp_in_the_past = 0>
			<cfset get_emp_in_the_past_ = 0>
		</cfif>
	<!---</cfloop>--->
</cfif>

