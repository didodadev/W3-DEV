<cfif isdefined("attributes.event") and attributes.event is 'det'>
	<cfif not len(attributes.in_out_id)>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='53622.Böyle bir giriş çıkış kaydı bulunamadı'>!");
			window.close();
		</script>
		<cfexit method="exittemplate">
	</cfif>
	
	<cfquery name="get_in_out" datasource="#dsn#">
		SELECT 
			BRANCH.*,
			EMPLOYEES_IN_OUT.*,
			OUR_COMPANY.COMPANY_NAME,
			OUR_COMPANY.NICK_NAME
		FROM
			EMPLOYEES_IN_OUT
			INNER JOIN BRANCH ON BRANCH.BRANCH_ID = EMPLOYEES_IN_OUT.BRANCH_ID
			INNER JOIN OUR_COMPANY ON OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
		WHERE
			EMPLOYEES_IN_OUT.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> 
	</cfquery>
	
	<cfif not len(get_in_out.finish_date)>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='Çıkış Tarihi Bulunamadı'>!");
			history.back();
		</script>
		<cfexit method="exittemplate">
	</cfif>
	
	<cfquery name="emp_last_work" datasource="#dsn#">
		SELECT 
			ED.*,
			EI.*,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME
		FROM 
			EMPLOYEES_DETAIL ED
			INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = ED.EMPLOYEE_ID
			INNER JOIN EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID = ED.EMPLOYEE_ID
		WHERE 
			ED.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	</cfquery>
	
	<cfscript>
		attributes.sal_mon = month(get_in_out.finish_date);
		attributes.sal_year = year(get_in_out.finish_date);
		attributes.group_id = "";
		if (len(get_in_out.puantaj_group_ids))
			attributes.group_id = "#get_in_out.puantaj_group_ids#,";
		attributes.branch_id = get_in_out.branch_id;
		not_kontrol_parameter = 1;
		include "../hr/ehesap/query/get_program_parameter.cfm";
		parameter_last_month_1 = CreateDateTime(attributes.sal_year,attributes.sal_mon,1,0,0,0);
		parameter_last_month_30 = CreateDateTime(attributes.sal_year,attributes.sal_mon,daysinmonth(createdate(attributes.sal_year,attributes.sal_mon,1)),23,59,59);
		parameter_last_month_30_start = CreateDateTime(attributes.sal_year,attributes.sal_mon,daysinmonth(createdate(attributes.sal_year,attributes.sal_mon,1)),0,0,0);
	</cfscript>
	<cfquery name="get_insurance" datasource="#dsn#">
		SELECT ISNULL(MAX_PAYMENT,0) MAX_PAYMENT FROM INSURANCE_PAYMENT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#parameter_last_month_1#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#parameter_last_month_30_start#">
	</cfquery>
	<cfif not get_insurance.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='54572.Asgari Ücret Tanımları Eksik'>!");
		</script>
		<cfabort>
	</cfif>
	
	<cfscript>
		if (get_program_parameters.SSK_31_DAYS eq 1)
			all_days = daysinmonth(bu_ay_sonu);
		else
			all_days = 30;
		fazla_mesai_45 = 0;
		t_ext_salary_0 = 0;
		t_ext_salary_1 = 0;
		t_ext_salary_2 = 0;
		t_ext_salary_3 = 0;
		t_ext_salary_5 = 0;
		t_ssk_paid_izin = 0;
		t_ssdf_paid_izin = 0;
		t_ssdf_mesai_amount = 0;
		t_ssk_mesai_amount = 0;
		t_ssdf_sunday_amount = 0;
		t_ssk_sunday_amount = 0;
		t_offdays_amount = 0;
		
		puantaj_gun_ = daysinmonth(createdate(year(get_in_out.finish_date),month(get_in_out.finish_date),1));
		bu_ay_basi = dateadd('m',-1,createdate(year(get_in_out.finish_date),month(get_in_out.finish_date),1));
		bu_ay_sonu = createodbcdatetime(date_add("d",1,createdate(year(get_in_out.finish_date),month(get_in_out.finish_date),puantaj_gun_)));
	</cfscript>
	
	<cfquery name="get_izins" datasource="#dsn#">
		SELECT 
			OFFTIME.EMPLOYEE_ID, SETUP_OFFTIME.EBILDIRGE_TYPE_ID, SETUP_OFFTIME.IS_PAID, SETUP_OFFTIME.SIRKET_GUN,
			OFFTIME.STARTDATE,OFFTIME.FINISHDATE
		FROM 
			OFFTIME
			INNER JOIN SETUP_OFFTIME ON SETUP_OFFTIME.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID
		WHERE
			OFFTIME.VALID = 1 AND 
			OFFTIME.STARTDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#"> AND 
			OFFTIME.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_basi#"> AND
			OFFTIME.IS_PUANTAJ_OFF = 0
		ORDER BY 
			OFFTIME.EMPLOYEE_ID, OFFTIME.STARTDATE
	</cfquery>
	<cfquery name="GET_PUANTAJ_PERSONAL" datasource="#DSN#">
		SELECT
			EMPLOYEES_IN_OUT.IN_OUT_ID,
			EMPLOYEES_IN_OUT.USE_SSK,
			EMPLOYEES_IN_OUT.START_DATE,
			EMPLOYEES_IN_OUT.FINISH_DATE,
			EMPLOYEES_PUANTAJ.*,
			EMPLOYEES_PUANTAJ_ROWS.*
		FROM
			EMPLOYEES_PUANTAJ_ROWS
			INNER JOIN EMPLOYEES_PUANTAJ ON EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID
			INNER JOIN EMPLOYEES_IN_OUT ON EMPLOYEES_IN_OUT.IN_OUT_ID = EMPLOYEES_PUANTAJ_ROWS.IN_OUT_ID
			INNER JOIN BRANCH ON EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID AND BRANCH.SSK_OFFICE = EMPLOYEES_PUANTAJ.SSK_OFFICE AND BRANCH.SSK_NO = EMPLOYEES_PUANTAJ.SSK_OFFICE_NO
		WHERE
			EMPLOYEES_PUANTAJ.SAL_MON IN (#month(dateadd('m',-1,get_in_out.finish_date))#,#month(get_in_out.finish_date)#) AND
			EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
			EMPLOYEES_PUANTAJ.SAL_YEAR >= <cfqueryparam cfsqltype="cf_sql_integer" value="#year(dateadd('m',-1,get_in_out.finish_date))#"> AND
			EMPLOYEES_IN_OUT.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#"> AND
			(EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_basi#"> OR EMPLOYEES_IN_OUT.FINISH_DATE IS NULL)
		ORDER BY
			EMPLOYEES_PUANTAJ.SAL_YEAR,
			EMPLOYEES_PUANTAJ.SAL_MON
	</cfquery>
	<!---<cfloop from="#month(get_in_out.finish_date)-1#" to="#month(get_in_out.finish_date)#" index="indx">--->
	<cfloop from="1" to="#get_puantaj_personal.recordcount#" index="indx">
		<cfscript>
			't_kidem_amount#indx#' = 0;
			't_ihbar_amount#indx#' = 0;
			't_yillik_izin_amount#indx#' = 0;
			't_ext_salary#indx#' = 0;
			't_ssk_paid_izin_amount#indx#' = 0;
			't_ssdf_paid_izin_amount#indx#' = 0;
			'genel_tatil_amount#indx#' = 0;
			'normal_amount#indx#' = 0;
			'haftalik_tatil_amount#indx#' = 0;
			't_paid_izin#indx#' = 0;
			'normal_gun_#indx#' = 0;
			//'genel_odenek_total#indx#' = 0; SG 20130816
			't_vergi_istisna_yaz#indx#' = 0;
			't_normal_gun#indx#' = 0;
			'izin#indx#' = 0;
			'EKSIKGUNNEDENI#indx#' = 0;
			'total_ikramiye#indx#' = 0;
			'total_ikramiye_yaz#indx#' = 0;
			'total_kazanc#indx#' = 0;
			'total_ucret#indx#' = 0;
			'ikramiye_tutar#indx#' = 0;
		</cfscript>
	</cfloop>
	
	<cfoutput query="GET_PUANTAJ_PERSONAL">
		<cfscript>
		fazla_mesai_hafta_ici = 0;
		fazla_mesai_hafta_sonu = 0;
		fazla_mesai_gece_calismasi = 0;
		//if(total_days gt 0)
		{
			if(salary_type eq 0)
			{
				ucret = TOTAL_SALARY - TOTAL_PAY_SSK_TAX - TOTAL_PAY_SSK - TOTAL_PAY_TAX - TOTAL_PAY - ext_salary - IHBAR_AMOUNT - KIDEM_AMOUNT - YILLIK_IZIN_AMOUNT + ozel_kesinti_2;
				if(total_days gt 0)
					ucret = ucret / total_days * all_days;
			}
			else if(salary_type eq 1)
			{
				ucret = TOTAL_SALARY - TOTAL_PAY_SSK_TAX - TOTAL_PAY_SSK - TOTAL_PAY_TAX - TOTAL_PAY - ext_salary - IHBAR_AMOUNT - KIDEM_AMOUNT - YILLIK_IZIN_AMOUNT + ozel_kesinti_2;
				if(total_days gt 0)
					ucret = ucret / total_days * all_days;
				else
					ucret = 0;
			}
			else if(salary_type eq 2)
			{
				ucret = TOTAL_SALARY - TOTAL_PAY_SSK_TAX - TOTAL_PAY_SSK - TOTAL_PAY_TAX - TOTAL_PAY - ext_salary - IHBAR_AMOUNT - KIDEM_AMOUNT - YILLIK_IZIN_AMOUNT + ozel_kesinti_2;
				if(total_days gt 0)
					ucret = wrk_round((ucret/total_days)*all_days,2);
				else
					ucret = 0;
			}
			't_kidem_amount#currentrow#' =  evaluate('t_kidem_amount#currentrow#') + KIDEM_AMOUNT;
			't_ihbar_amount#currentrow#' =  evaluate('t_ihbar_amount#currentrow#') + IHBAR_AMOUNT;
			't_yillik_izin_amount#currentrow#' =  evaluate('t_yillik_izin_amount#currentrow#') + YILLIK_IZIN_AMOUNT;
			't_vergi_istisna_yaz#currentrow#' = VERGI_ISTISNA_SSK + VERGI_ISTISNA_VERGI + VERGI_ISTISNA_DAMGA;
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
				t_ext_salary_0 = ((EXT_SALARY/fazla_mesai_toplam) * (fazla_mesai_hafta_ici + fazla_mesai_45));
				t_ext_salary_1 = ((EXT_SALARY/fazla_mesai_toplam) * fazla_mesai_hafta_sonu);
				t_ext_salary_2 = ((EXT_SALARY/fazla_mesai_toplam) * fazla_mesai_resmi_tatil);
				t_ext_salary_5 = ((EXT_SALARY/fazla_mesai_toplam) * fazla_mesai_gece_calismasi); // Gece Çalışması Ücreti
			}
			't_ext_Salary#currentrow#' = t_ext_salary_0 + t_ext_salary_1 + t_ext_salary_2 + t_ext_salary_5;
			
			if(izin_paid gt 0)
				ucretli_izin_gunu = izin_paid;	
			else
				ucretli_izin_gunu = 0;
			if(ucretli_izin_gunu lt 0)
				ucretli_izin_gunu = 0;
			if (ssdf_isveren_hissesi gt 0)/* ssk li emekliler icin*/
			{
				t_ssdf_paid_izin = ucretli_izin_gunu;
				't_ssdf_paid_izin_amount#currentrow#' = ((ucretli_izin_gunu/all_days) * ucret);//ucretli_izin_amount
				haftalik_tatil_ = sunday_count-paid_izinli_sunday_count-offdays_sunday_count-izinli_sunday_count;
				t_ssdf_sunday_amount =  ((haftalik_tatil_ / all_days) * ucret);//haftalik_tatil_amount
				normal_gun_ = total_days - haftalik_tatil_ - ucretli_izin_gunu - OFFDAYS_COUNT;
				't_normal_gun#currentrow#' =  total_days;
			
				'izin#currentrow#' =  izin;
				t_ssdf_mesai_amount =  ((normal_gun_ / all_days) * ucret);//normal_amount
				t_offdays_amount =  ((OFFDAYS_COUNT/all_days)*ucret);//genel_tatil_amount
			}
			else
			{/* emekli olmayan ama kazanci olan kisiler gelsin (ssk li veya degil), ucretlere ait bilgiler hesaplansin*/
				t_ssk_paid_izin =  ucretli_izin_gunu ;
				't_ssk_paid_izin_amount#currentrow#' = ((ucretli_izin_gunu/all_days) * ucret);//ucretli_izin_amount
				haftalik_tatil_ = sunday_count-paid_izinli_sunday_count-offdays_sunday_count-izinli_sunday_count;
				normal_gun_ = total_days - haftalik_tatil_ - ucretli_izin_gunu - OFFDAYS_COUNT;
				't_normal_gun#currentrow#' = total_days;
				'izin#currentrow#' =  izin;
				t_ssk_mesai_amount =  ((normal_gun_/ all_days) * ucret);//normal_amount
				haftalik_tatil_ = sunday_count-paid_izinli_sunday_count-offdays_sunday_count-izinli_sunday_count;
				t_ssk_sunday_amount =  ((haftalik_tatil_ / all_days) * ucret);//haftalik_tatil_amount
				t_offdays_amount = ((OFFDAYS_COUNT/all_days)*ucret);//genel_tatil_amount
			}
			'haftalik_tatil_amount#currentrow#' = t_ssdf_sunday_amount + t_ssk_sunday_amount;//haftalik_tatil_amount
			't_paid_izin#currentrow#' = t_ssk_paid_izin + t_ssdf_paid_izin;
			'normal_amount#currentrow#' = t_ssk_mesai_amount + t_ssdf_mesai_amount;//normal_amount
			'genel_tatil_amount#currentrow#' = t_offdays_amount;//genel_tatil_amount
	
			'total_kazanc#currentrow#' = TOTAL_SALARY - (SSK_DEVIR + SSK_DEVIR_LAST + TOTAL_PAY_TAX + KIDEM_AMOUNT + IHBAR_AMOUNT + TOTAL_PAY);
			'total_ikramiye#currentrow#' = TOTAL_PAY_SSK_TAX + TOTAL_PAY_SSK + SSK_DEVIR + SSK_DEVIR_LAST;
			'total_ucret#currentrow#' = evaluate('total_kazanc#currentrow#') - evaluate('total_ikramiye#currentrow#');
			if(evaluate('total_ucret#currentrow#') gte SSK_MATRAH)
			{
				'total_ikramiye_yaz#currentrow#' = 0;
			}
			else if(evaluate('total_kazanc#currentrow#') gte SSK_MATRAH)
			{
				'total_ikramiye_yaz#currentrow#' = SSK_MATRAH - evaluate('total_ucret#currentrow#');
			}
			else if(evaluate('total_kazanc#currentrow#') lt SSK_MATRAH)
			{
				'total_ikramiye_yaz#currentrow#' = evaluate('total_ikramiye#currentrow#');
			}
			if(SSK_ISVEREN_HISSESI_5921 gt 0 and (TOTAL_DAYS + IZIN) gt SSK_ISVEREN_HISSESI_5921_DAY)
			{
				'ikramiye_tutar#currentrow#' = wrk_round(evaluate('total_ikramiye_yaz#currentrow#') / TOTAL_DAYS * (TOTAL_DAYS - SSK_ISVEREN_HISSESI_5921_DAY),2);
			}
			else
			{
				'ikramiye_tutar#currentrow#' = wrk_round(evaluate('total_ikramiye_yaz#currentrow#'),2);
			}
		}
	
			if(SSK_ISVEREN_HISSESI_5921_DAY GT 0 and KANUN_NO eq 5921)
			{
				if(izin_paid gt 0 and izin gt 0)
					'EKSIKGUNNEDENI#currentrow#' = 12;
				else if(izin gt 0)
				{
					get_emp_izins = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND IS_PAID = 0");
					eksik_neden_id = get_emp_izins.EBILDIRGE_TYPE_ID;
					if (get_emp_izins.recordcount gte 2)
						for (geii=2; geii lte get_emp_izins.recordcount; geii=geii+1)
							if (get_emp_izins.EBILDIRGE_TYPE_ID[geii-1] neq get_emp_izins.EBILDIRGE_TYPE_ID[geii])
								eksik_neden_id = 12;
					'EKSIKGUNNEDENI#currentrow#' = eksik_neden_id;
				}
				else if(izin_paid gt 0)
				{
					get_emp_izins = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND IS_PAID = 1");
					eksik_neden_id = get_emp_izins.EBILDIRGE_TYPE_ID;
					if (get_emp_izins.recordcount gte 2)
						for (geii=2; geii lte get_emp_izins.recordcount; geii=geii+1)
							if (get_emp_izins.EBILDIRGE_TYPE_ID[geii-1] neq get_emp_izins.EBILDIRGE_TYPE_ID[geii])
								eksik_neden_id = 12;
					'EKSIKGUNNEDENI#currentrow#' = eksik_neden_id;
				}
				else
				{
					'EKSIKGUNNEDENI#currentrow#' = 12;
				}
			}
			else
			{
				if(SSK_ISVEREN_HISSESI_5921_DAY GT 0 and KANUN_NO eq 0 and izin gt 0)
					'EKSIKGUNNEDENI#currentrow#' = 12;
				else if(SSK_ISVEREN_HISSESI_5921_DAY GT 0 and KANUN_NO eq 0 and izin eq 0)
					'EKSIKGUNNEDENI#currentrow#' = 13;
				else if(SALARY_TYPE eq 0 and IS_KISMI_ISTIHDAM eq 1)
					'EKSIKGUNNEDENI#currentrow#' = 6;
				else if (izin gt 0)
				{
					get_emp_izins = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND IS_PAID = 0");
					eksik_neden_id = get_emp_izins.EBILDIRGE_TYPE_ID;
					if (get_emp_izins.recordcount gte 2)
						for (geii=2; geii lte get_emp_izins.recordcount; geii=geii+1)
							if (get_emp_izins.EBILDIRGE_TYPE_ID[geii-1] neq get_emp_izins.EBILDIRGE_TYPE_ID[geii])
								eksik_neden_id = 12;
					'EKSIKGUNNEDENI#currentrow#' = eksik_neden_id;
				}
				else
				{
					'EKSIKGUNNEDENI#currentrow#' = 0;
				}
			}
		</cfscript>
		<cfquery name="get_odeneks" datasource="#dsn#">
			SELECT * FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE EMPLOYEE_PUANTAJ_ID = #GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID# AND SSK = 2 ORDER BY COMMENT_PAY
		</cfquery>
		<cfloop query="get_odeneks">
			<cfset tmp_total = 0>
			<cfif PAY_METHOD eq 2>
				<cfset tmp_total = tmp_total + amount_2>
			<cfelse>
				<cfset tmp_total = tmp_total + amount>
			</cfif>
			<!--- <cfset 'genel_odenek_total#currentrow#' = evaluate('genel_odenek_total#currentrow#') + tmp_total> --->
		</cfloop>
	</cfoutput>
	
	<cfif not isdefined('attributes.print')>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr class="color-border">
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="2">
						<tr class="color-row">
							<td style="text-align:right;">
								<a href="javascript://" onClick="<cfoutput>windowopen('#request.self#?fuseaction=ehesap.popup_new_ssk_worker_out_self&print=true#page_code#','page')</cfoutput>"><img src="/images/print.gif" title="<cf_get_lang_main no='1331.Gönder'>" border="0"></a> 
								<a href="javascript://" onClick="window.close();"><img src="/images/close.gif" title="<cf_get_lang_main no ='141.Kapat'>" border="0"></a>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	<cfelse>
		<script type="text/javascript">
			function waitfor(){
			window.close();
			}	
			setTimeout("waitfor()",3000);
			window.print();
		</script>
	</cfif>
	
	<style>
		.header_
		{
			text-align:center;
			font-weight:bold;
		}
	
		.tbl
		{
			border-collapse:collapse;
			border:1px black solid;
			width:100%;
		}
	
		.tbl td
		{
			border:1px black solid;
		}
	
		.tbl_tcNo td
		{
			border-collapse:collapse;
			border:1px black solid;
		}
	</style>
	<cfset attributes.sal_mon = month(get_in_out.finish_date)>
	<cfset attributes.sal_year = year(get_in_out.finish_date)>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		function send_page()
		{
			window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_job_exit_declaration&event=det&employee_id='+$('#employee_id').val()+'&in_out_id='+$('#in_out_id').val()+'&branch_id='+$('#branch_id').val()+'$employee='+$('#employee').val();
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'det'>
		function doc_repeat(is_repeat)
		{
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_doc_repeat_ajax&in_out_id=#attributes.in_out_id#&employee_id=#attributes.employee_id#</cfoutput>&is_repeat=' + is_repeat + '','doc_repeat');
		}
	</cfif>
</script>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.popup_job_exit_declaration';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/job_exit_declaration.cfm';
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'ehesap.popup_new_ssk_worker_out_self';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'hr/ehesap/display/new_ssk_worker_out_self.cfm';
</cfscript>
