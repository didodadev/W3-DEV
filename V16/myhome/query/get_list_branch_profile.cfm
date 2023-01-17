<cfloop from="1" to="12" index="init_month1_">
	<cfset 'genel_odenek_total_#init_month1_#' = 0>
	<cfset 't_toplam_kazanc_#init_month1_#' = 0>
	<cfset 't_ext_salary_0_#init_month1_#' = 0>
	<cfset 't_ext_salary_1_#init_month1_#' = 0>
	<cfset 't_ext_salary_2_#init_month1_#' = 0>
	<cfset 't_ext_salary_5_#init_month1_#' = 0>
	<cfset 't_issizlik_isveren_hissesi_#init_month1_#' = 0>
	<cfset 't_ssk_primi_isveren_hesaplanan_#init_month1_#' = 0>
	<cfset 't_ssdf_isveren_hissesi_#init_month1_#' = 0>
	<cfset 't_ssk_primi_isci_#init_month1_#' = 0>
	<cfset 't_ssk_primi_isci_devirsiz_#init_month1_#' = 0>
	<cfset 't_sgdp_devir_#init_month1_#' = 0>
	<cfset 't_ssk_primi_isveren_gov_#init_month1_#'= 0>
	<cfset 't_issizlik_isci_hissesi_#init_month1_#' = 0>
	<cfset 't_issizlik_isci_hissesi_devirsiz_#init_month1_#' = 0>
	<cfset 't_ssk_primi_isveren_#init_month1_#' = 0>
	<cfset 't_ssk_primi_isveren_5921_#init_month1_#' = 0>
	<cfset 't_ssk_primi_isveren_5746_#init_month1_#' = 0>
	<cfset 't_ssk_primi_isveren_6111_#init_month1_#' = 0>
	<cfset 't_ext_work_hours_0_#init_month1_#' = 0>
	<cfset 't_ext_work_hours_1_#init_month1_#' = 0>
	<cfset 't_ext_work_hours_2_#init_month1_#' = 0>
	<cfset 'isveren_maliyeti_indirimsiz_#init_month1_#' = 0>
	<cfset 'isveren_maliyeti_#init_month1_#' = 0>
	<cfset 'toplam_mesai_saati_#init_month1_#' = 0>
	<cfset 'toplam_mesai_tutari_#init_month1_#' = 0>
	<cfset 'genel_odenek_total2_#init_month1_#' = 0>
	<cfset 't_toplam_kazanc2_#init_month1_#' = 0>
	<cfset 't_ext_Salary_#init_month1_#' = 0>
	<cfset 'toplam_kazanc_artis_orani_#init_month1_#' = 0>
	<cfset 'toplam_hakedilen_izin_#init_month1_#' = 0>
	<cfset 'genel_izin_toplam_#init_month1_#' = 0>
	<cfset 'tahmini_izin_yuku_#init_month1_#' = 0>
	<cfset 'get_emp_in_the_past#init_month1_#' = 0>
	<cfset 'get_emp_in_the_past_#init_month1_#' = 0>
	<cfset 'get_emp_in_total_#init_month1_#' = 1>
	<cfset 'get_emp_out_total_#init_month1_#' = 0>
	<cfset 'emp_number_#init_month1_#' = 0>
</cfloop>
<cfscript>
	all_days = 30;
	t_devirden_gelen = 0;
	fazla_mesai_resmi_tatil = 0;
	fazla_mesai_hafta_ici = 0;
	fazla_mesai_hafta_sonu = 0;
	fazla_mesai_gece_calismasi = 0;
	t_toplam_kazanc = 0;
	genel_odenek_total = 0;
	t_ext_salary = 0;
	fazla_mesai_45 = 0;
	get_branch_profile_det_.recordcount = 0;
</cfscript>
<cfquery name="GET_BRANCH_PROFILE_DET" datasource="#DSN#"> 
	SELECT
		E.KIDEM_DATE,
		EIO.START_DATE,
		EIO.FINISH_DATE,
		EIO.EXPLANATION_ID,
		EIO.BRANCH_ID,
		EIO.PUANTAJ_GROUP_IDS,        
		(SELECT USE_SSK FROM EMPLOYEES_IN_OUT EIO WHERE EIO.IN_OUT_ID = EPR.IN_OUT_ID) USE_SSK,
		EP.*,
		EPR.*        
	FROM
		EMPLOYEES_PUANTAJ EP,
		EMPLOYEES_PUANTAJ_ROWS EPR,
		EMPLOYEES_IN_OUT EIO,
		EMPLOYEES E
	WHERE
		E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
		EPR.IN_OUT_ID = EIO.IN_OUT_ID AND
		EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND 
		EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#"> AND
        EP.PUANTAJ_TYPE = -1
</cfquery>
<!--- maliyet-mesai-toplam kazanc --->
<!--- <cfif attributes.selection neq 4> --->
	<cfquery name="GET_ODENEKS_" datasource="#DSN#">
		SELECT * FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE EXT_TYPE = 0 ORDER BY COMMENT_PAY
	</cfquery>
	<!--- maliyet ve mesai --->
	<cfloop from="1" to="12" index="month_">
		<cfset 'toplam_kazanc_#month_#' = 0>
		<cfset fazla_mesai_45 = 0>
		<cfquery name="GET_BRANCH_PROFILE_BASED_MONTH" dbtype="query">
			SELECT * FROM GET_BRANCH_PROFILE_DET WHERE SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#month_#">
		</cfquery>
		<cfset 'emp_number_#month_#' = get_branch_profile_based_month.recordcount>
		<cfloop query="get_branch_profile_based_month">
			<cfset attributes.branch_id = branch_id>
			<cfif len(puantaj_group_ids)>
				<cfset attributes.group_id = "#PUANTAJ_GROUP_IDS#,">
			</cfif>
			<cfset not_kontrol_parameter = 1>
			<cfset attributes.sal_year = sal_year>
			<cfset attributes.sal_mon = sal_mon> 
			<cfinclude template="../../hr/ehesap/query/get_program_parameter.cfm">
			<cfquery name="GET_ODENEKS" dbtype="query">
				SELECT * FROM GET_ODENEKS_ WHERE EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_branch_profile_based_month.employee_puantaj_id#">
			</cfquery>
			<cfoutput query="get_odeneks" group="COMMENT_PAY">
				<cfset tmp_total = 0>
				<cfoutput>
					<cfif pay_method eq 2>
						<cfset tmp_total = tmp_total + amount_2>
					<cfelse>
						<cfset tmp_total = tmp_total + amount>
					</cfif>
				</cfoutput>
				<cfset 'genel_odenek_total_#month_#' = evaluate('genel_odenek_total_#month_#') + tmp_total>
			</cfoutput> 
			<cfscript>
				total_salary_ = TOTAL_SALARY - (EXT_SALARY + total_pay_ssk_tax + total_pay_tax + total_pay_ssk + total_pay);
				't_toplam_kazanc_#month_#' = evaluate('t_toplam_kazanc_#month_#') + total_salary_ - VERGI_ISTISNA_VERGI;
				//if(EXT_TOTAL_HOURS_3 neq 0 && get_program_parameters.EX_TIME_PERCENT_HIGH neq 0)
				if(len(get_program_parameters.EX_TIME_PERCENT_HIGH))
					fazla_mesai_45 = EXT_TOTAL_HOURS_3 * get_program_parameters.EX_TIME_PERCENT_HIGH / 100;// 45 saati asan kisim
				if(len(get_program_parameters.EX_TIME_PERCENT))
					fazla_mesai_hafta_ici = (EXT_TOTAL_HOURS_0-EXT_TOTAL_HOURS_3) * get_program_parameters.EX_TIME_PERCENT  / 100;
		
				if(len(get_program_parameters.WEEKEND_MULTIPLIER))
					fazla_mesai_hafta_sonu = (EXT_TOTAL_HOURS_1 * get_program_parameters.WEEKEND_MULTIPLIER);
				else if(len(get_program_parameters.EX_TIME_PERCENT))
					fazla_mesai_hafta_sonu = (EXT_TOTAL_HOURS_1 * get_program_parameters.EX_TIME_PERCENT/ 100);
		
				if(len(get_program_parameters.OFFICIAL_MULTIPLIER))	
					fazla_mesai_resmi_tatil = EXT_TOTAL_HOURS_2 * get_program_parameters.OFFICIAL_MULTIPLIER; // resmi tatil
				else
					fazla_mesai_resmi_tatil = EXT_TOTAL_HOURS_2 * 100 / 100; // resmi tatil
				if(len(get_program_parameters.EX_TIME_PERCENT))	
					fazla_mesai_45 = EXT_TOTAL_HOURS_3 * get_program_parameters.EX_TIME_PERCENT / 100;// 45 saati asan kisim
				if(len(EXT_TOTAL_HOURS_5))
					fazla_mesai_gece_calismasi = (EXT_TOTAL_HOURS_5 * 10 / 100);

				fazla_mesai_toplam = fazla_mesai_hafta_ici + fazla_mesai_hafta_sonu + fazla_mesai_resmi_tatil + fazla_mesai_45 + fazla_mesai_gece_calismasi;
				if (fazla_mesai_toplam neq 0)
				{
					't_ext_salary_0_#month_#' =  evaluate('t_ext_salary_0_#month_#') + ((EXT_SALARY/fazla_mesai_toplam) * (fazla_mesai_hafta_ici + fazla_mesai_45));
					't_ext_salary_1_#month_#' =  evaluate('t_ext_salary_1_#month_#') + ((EXT_SALARY/fazla_mesai_toplam) * fazla_mesai_hafta_sonu);
					't_ext_salary_2_#month_#' =  evaluate('t_ext_salary_2_#month_#') + ((EXT_SALARY/fazla_mesai_toplam) * fazla_mesai_resmi_tatil);
					't_ext_salary_5_#month_#' =  evaluate('t_ext_salary_5_#month_#') + ((EXT_SALARY/fazla_mesai_toplam) * fazla_mesai_gece_calismasi); // Gece Çalışması Ücreti
				}
				
				't_ext_Salary_#month_#' = evaluate('t_ext_salary_0_#month_#') + evaluate('t_ext_salary_1_#month_#') + evaluate('t_ext_salary_2_#month_#') + evaluate('t_ext_salary_5_#month_#');
				't_issizlik_isveren_hissesi_#month_#' = evaluate('t_issizlik_isveren_hissesi_#month_#') + issizlik_isveren_hissesi;
				if (use_ssk eq 1)
				{
					isveren_hesaplanan = ssk_isveren_hissesi + ssk_isveren_hissesi_5510 + ssk_isveren_hissesi_5084;
					't_ssk_primi_isveren_hesaplanan_#month_#' =  evaluate('t_ssk_primi_isveren_hesaplanan_#month_#') + isveren_hesaplanan;
					't_ssk_primi_isveren_#month_#' = evaluate('t_ssk_primi_isveren_#month_#') + ssk_isveren_hissesi;
				}
				't_ssdf_isveren_hissesi_#month_#' =  evaluate('t_ssdf_isveren_hissesi_#month_#') + ssdf_isveren_hissesi;
				't_ssk_primi_isci_#month_#' =  evaluate('t_ssk_primi_isci_#month_#') + ssk_isci_hissesi;
				ssk_devir_toplam = 0;
				if(len(ssk_devir))
				{
					ssk_devir_toplam = ssk_devir_toplam + ssk_devir;
					t_devirden_gelen = t_devirden_gelen + ssk_devir;
				}
				if(ssk_isci_hissesi gt 0 and ssk_devir_toplam gt 0)
					't_ssk_primi_isci_devirsiz_#month_#' = evaluate('t_ssk_primi_isci_devirsiz_#month_#') + wrk_round((SSK_MATRAH - ssk_devir_toplam) * 14 / 100);
				else
					't_ssk_primi_isci_devirsiz_#month_#' = evaluate('t_ssk_primi_isci_devirsiz_#month_#') + ssk_isci_hissesi;
					
				't_issizlik_isci_hissesi_#month_#' = evaluate('t_issizlik_isci_hissesi_#month_#') + issizlik_isci_hissesi;
				ssk_devir_toplam = 0;
				if(len(ssk_devir))
				{
					ssk_devir_toplam = ssk_devir_toplam + ssk_devir;
					t_devirden_gelen = t_devirden_gelen + ssk_devir;
				}
				if(issizlik_isci_hissesi gt 0 and ssk_devir_toplam gt 0)
					't_issizlik_isci_hissesi_devirsiz_#month_#' = evaluate('t_issizlik_isci_hissesi_devirsiz_#month_#') + wrk_round((SSK_MATRAH - ssk_devir_toplam) * 1 / 100);
				else
					't_issizlik_isci_hissesi_devirsiz_#month_#' = evaluate('t_issizlik_isci_hissesi_devirsiz_#month_#') + issizlik_isci_hissesi;
				if(len(SSK_ISCI_HISSESI_DUSULECEK) and ssdf_isveren_hissesi gt 0)
					't_sgdp_devir_#month_#' = evaluate('t_sgdp_devir_#month_#') + SSK_ISCI_HISSESI_DUSULECEK;
				if(len(ssk_isveren_hissesi_gov))
					't_ssk_primi_isveren_gov_#month_#' = evaluate('t_ssk_primi_isveren_gov_#month_#') + ssk_isveren_hissesi_gov;
				else
					't_ssk_primi_isveren_gov_#month_#' = evaluate('t_ssk_primi_isveren_gov_#month_#') + 0;
					't_ssk_primi_isveren_5921_#month_#' = evaluate('t_ssk_primi_isveren_5921_#month_#') + ssk_isveren_hissesi_5921;
					't_ssk_primi_isveren_5746_#month_#' = evaluate('t_ssk_primi_isveren_5746_#month_#') + ssk_isveren_hissesi_5746;
					't_ssk_primi_isveren_6111_#month_#' = evaluate('t_ssk_primi_isveren_6111_#month_#') + 0;//bakilacak
					't_ext_work_hours_0_#month_#' = evaluate('t_ext_work_hours_0_#month_#') + EXT_TOTAL_HOURS_0;
					't_ext_work_hours_1_#month_#' = evaluate('t_ext_work_hours_1_#month_#') + EXT_TOTAL_HOURS_1;
					't_ext_work_hours_2_#month_#' = evaluate('t_ext_work_hours_2_#month_#') + EXT_TOTAL_HOURS_2;
			</cfscript>
			<cfset 'isveren_maliyeti_indirimsiz_#month_#' = evaluate('t_toplam_kazanc_#month_#')+evaluate('t_ext_salary_#month_#')+evaluate('t_issizlik_isveren_hissesi_#month_#')+evaluate('t_ssk_primi_isveren_hesaplanan_#month_#')+evaluate('t_ssdf_isveren_hissesi_#month_#')+evaluate('genel_odenek_total_#month_#')+(evaluate('t_ssk_primi_isci_#month_#')-evaluate('t_ssk_primi_isci_devirsiz_#month_#'))+(evaluate('t_issizlik_isci_hissesi_#month_#') - evaluate('t_issizlik_isci_hissesi_devirsiz_#month_#'))+evaluate('t_sgdp_devir_#month_#')> 
			<cfset 'isveren_maliyeti_#month_#' = evaluate('t_toplam_kazanc_#month_#') + evaluate('t_ext_salary_#month_#') + evaluate('t_issizlik_isveren_hissesi_#month_#') + evaluate('t_ssk_primi_isveren_#month_#') + evaluate('t_ssdf_isveren_hissesi_#month_#') + evaluate('genel_odenek_total_#month_#') - evaluate('t_ssk_primi_isveren_gov_#month_#') - evaluate('t_ssk_primi_isveren_5921_#month_#') - evaluate('t_ssk_primi_isveren_5746_#month_#') - evaluate('t_ssk_primi_isveren_6111_#month_#') + (evaluate('t_ssk_primi_isci_#month_#') - evaluate('t_ssk_primi_isci_devirsiz_#month_#')) + (evaluate('t_issizlik_isci_hissesi_#month_#') - evaluate('t_issizlik_isci_hissesi_devirsiz_#month_#')) + evaluate('t_sgdp_devir_#month_#')> 
			<cfset 'toplam_mesai_saati_#month_#' = evaluate('t_ext_work_hours_0_#month_#') + evaluate('t_ext_work_hours_1_#month_#') + evaluate('t_ext_work_hours_2_#month_#')>
			<cfset 'toplam_mesai_tutari_#month_#' = evaluate('t_ext_salary_0_#month_#') + evaluate('t_ext_salary_1_#month_#') + evaluate('t_ext_salary_2_#month_#') + evaluate('t_ext_salary_5_#month_#')>
			<cfset 'toplam_kazanc_#month_#' = evaluate('t_toplam_kazanc_#month_#')+evaluate('genel_odenek_total_#month_#')+evaluate('t_ext_Salary_#month_#')>
		</cfloop>
	</cfloop>
	<!---  toplam kazanc artis oranini hesaplarken kullanildi--->
	<cfquery name="GET_TOTAL_GAIN_"  datasource="#DSN#">
		SELECT
			EP.*,
			EPR.* ,
			E.IZIN_DATE 
		FROM
			EMPLOYEES_PUANTAJ EP,
			EMPLOYEES_PUANTAJ_ROWS EPR,
			EMPLOYEES E 
		WHERE
			EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND  
			E.EMPLOYEE_ID = EPR.EMPLOYEE_ID
		<cfif isdefined("attributes.sal_mon") and attributes.sal_mon eq 1>
            AND EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year-1#"> 
        <cfelse> 
            AND EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#">
        </cfif> 
	</cfquery>
	<cfloop from="1" to="12" index="month2_">
		<cfquery name="get_total_gain_based_month" dbtype="query">
			SELECT * FROM get_total_gain_ WHERE <cfif month2_ eq 1>SAL_MON = 12<cfelse>SAL_MON = #month2_-1#</cfif> 
		</cfquery>
		<cfloop query="get_total_gain_based_month">
			<cfif len(get_branch_profile_based_month.employee_puantaj_id)>
			 <cfquery name="GET_ODENEKS" dbtype="query">
				SELECT * FROM GET_ODENEKS_ WHERE EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_branch_profile_based_month.employee_puantaj_id#">
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
				<cfset 'genel_odenek_total2_#month2_#' = evaluate('genel_odenek_total2_#month2_#') + tmp_total>
			</cfoutput> 
			</cfif> 
			<cfscript>
				total_salary_ = TOTAL_SALARY - (EXT_SALARY + total_pay_ssk_tax + total_pay_tax + total_pay_ssk + total_pay);
				't_toplam_kazanc2_#month2_#' = evaluate('t_toplam_kazanc2_#month2_#') + total_salary_ - VERGI_ISTISNA_VERGI;
				if(len(get_program_parameters.EX_TIME_PERCENT_HIGH))
					fazla_mesai_45 = EXT_TOTAL_HOURS_3 * get_program_parameters.EX_TIME_PERCENT_HIGH / 100;// 45 saati asan kisim
				fazla_mesai_toplam = fazla_mesai_hafta_ici + fazla_mesai_hafta_sonu + fazla_mesai_resmi_tatil + fazla_mesai_45 + fazla_mesai_gece_calismasi;
				if (fazla_mesai_toplam neq 0)
				{
					't_ext_salary_0_#month2_#' = evaluate('t_ext_salary_0_#month2_#') + ((EXT_SALARY/fazla_mesai_toplam) * (fazla_mesai_hafta_ici + fazla_mesai_45));
					't_ext_salary_1_#month2_#' = evaluate('t_ext_salary_1_#month2_#') + ((EXT_SALARY/fazla_mesai_toplam) * fazla_mesai_hafta_sonu);
					't_ext_salary_2_#month2_#' = evaluate('t_ext_salary_2_#month2_#') + ((EXT_SALARY/fazla_mesai_toplam) * fazla_mesai_resmi_tatil);
					't_ext_salary_5_#month2_#' = evaluate('t_ext_salary_5_#month2_#') + ((EXT_SALARY/fazla_mesai_toplam) * fazla_mesai_gece_calismasi); // Gece Çalışması Ücreti
				}
				't_ext_Salary2_#month2_#' = evaluate('t_ext_salary_0_#month2_#') + evaluate('t_ext_salary_1_#month2_#') + evaluate('t_ext_salary_2_#month2_#') + evaluate('t_ext_salary_5_#month2_#');
			</cfscript>
			<cfset 'toplam_kazanc_artis_orani_#month2_#' = evaluate('t_toplam_kazanc2_#month2_#')+evaluate('genel_odenek_total2_#month2_#')+evaluate('t_ext_Salary2_#month2_#')>
		</cfloop>
	</cfloop>
<!--- </cfif>  --->

<!--- devir hızı --->
<cfset month_day_ = 0>
<cfset month_start_ = 0>
<cfset month_finish_ = 0>
<cfset get_emp_in_det.emp_in_total = 0>
<cfset get_emp_out_det.emp_out_total = 0>
<cfif attributes.selection eq 4>
	<cfquery name="GET_EMP_IN_OUT_DET" datasource="#DSN#">
		SELECT 
			E.KIDEM_DATE,
			E.EMPLOYEE_ID,
			EIO.START_DATE,
			EIO.FINISH_DATE
		FROM 
			EMPLOYEES_IN_OUT EIO,
			EMPLOYEES E
		WHERE
			E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
			EIO.EXPLANATION_ID <> 18 <!--- worknet-nakil --->
	</cfquery>
	<cfloop from="1" to="12" index="month3_">
		<cfset month_day_ = daysinmonth(CREATEDATE(session.ep.period_year,month3_,1))>
		<cfset month_start_ = CREATEDATE(session.ep.period_year,month3_,1)>
		<cfset month_finish_ = CREATEDATE(session.ep.period_year,month3_,month_day_)>
		<cfquery name="GET_EMP_IN_DET" dbtype="query">
			SELECT 
				EMPLOYEE_ID
			FROM 
				GET_EMP_IN_OUT_DET
			WHERE
				START_DATE >= #month_start_#  AND
				START_DATE <= #month_finish_#
		</cfquery>
		<cfset 'get_emp_in_total_#month3_#' = get_emp_in_det.recordcount>
		<cfquery name="GET_EMP_OUT_DET" dbtype="query">
			SELECT 
				EMPLOYEE_ID
			FROM 
				GET_EMP_IN_OUT_DET
			WHERE
				FINISH_DATE >= #month_start_#  AND
				FINISH_DATE <= #month_finish_#
		</cfquery>
		<cfset 'get_emp_out_total_#month3_#' =  get_emp_out_det.recordcount>
		<!---kidem tarihi bir yildan once olanlar--->
		<cfquery name="GET_EMP_IN_THE_PAST" dbtype="query">
			SELECT 
				KIDEM_DATE
			FROM            	
				GET_BRANCH_PROFILE_DET
			WHERE
				KIDEM_DATE <= #dateadd('yyyy',-1,month_finish_)# AND
				SAL_MON = #month3_# 
		</cfquery>
		<cfquery name="GET_EMP_IN_THE_PAST2_" dbtype="query">
			SELECT 
				KIDEM_DATE
			FROM 
				GET_EMP_IN_OUT_DET
			WHERE
				KIDEM_DATE <= #dateadd('yyyy',-1,month_finish_)# AND
				FINISH_DATE >= #month_start_#  AND
				FINISH_DATE <= #month_finish_#
		</cfquery>
		<cfset 'get_emp_in_the_past#month3_#' = get_emp_in_the_past.recordcount - get_emp_in_the_past2_.recordcount>
		<!---kidem tarihi son bir yil olanlar--->
		<cfquery name="GET_EMP_IN_THE_PAST_" dbtype="query">
			SELECT 
				KIDEM_DATE
			FROM 
				GET_BRANCH_PROFILE_DET
			WHERE
				KIDEM_DATE > #dateadd('yyyy',-1,month_finish_)#  AND
				SAL_MON = #month3_# 
		</cfquery>
		<cfquery name="GET_EMP_IN_THE_PAST_2_" dbtype="query">
			SELECT 
				KIDEM_DATE
			FROM 
				GET_EMP_IN_OUT_DET
			WHERE
				KIDEM_DATE > #dateadd('yyyy',-1,month_finish_)#  AND
				FINISH_DATE >= #month_start_#  AND
				FINISH_DATE <= #month_finish_#
		</cfquery>
		<cfset 'get_emp_in_the_past_#month3_#' = get_emp_in_the_past_.recordcount - get_emp_in_the_past_2_.recordcount>
	</cfloop>
</cfif>
