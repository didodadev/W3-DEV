<cfif not len(attributes.in_out_id)>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='46350.Giriş - Çıkış Kaydı Bulunamadı'>!");
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
		BRANCH,
		OUR_COMPANY,
		EMPLOYEES_IN_OUT 
	WHERE
		BRANCH.BRANCH_ID = EMPLOYEES_IN_OUT.BRANCH_ID AND
		OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID AND
		EMPLOYEES_IN_OUT.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> 
</cfquery>

<cfif not len(get_in_out.finish_date)>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='54569.Çıkış Tarihi Bulunamadı'>!");
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
		EMPLOYEES_DETAIL ED,
		EMPLOYEES_IDENTY EI,
		EMPLOYEES E
	WHERE 
		ED.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
		EI.EMPLOYEE_ID = ED.EMPLOYEE_ID AND
		E.EMPLOYEE_ID = ED.EMPLOYEE_ID
</cfquery>
<cfset attributes.sal_mon = MONTH(get_in_out.finish_date)>
<cfset attributes.sal_year = YEAR(get_in_out.finish_date)>
<cfset attributes.group_id = "">
<cfif len(get_in_out.puantaj_group_ids)>
	<cfset attributes.group_id = "#get_in_out.PUANTAJ_GROUP_IDS#,">
</cfif>
<cfset attributes.branch_id = get_in_out.branch_id>
<cfset not_kontrol_parameter = 1>
<cfinclude template="../query/get_program_parameter.cfm">
<cfscript>
	parameter_last_month_1 = CreateDateTime(attributes.sal_year,attributes.sal_mon,1,0,0,0);
	parameter_last_month_30 = CreateDateTime(attributes.sal_year,attributes.sal_mon,daysinmonth(createdate(attributes.sal_year,attributes.sal_mon,1)),23,59,59);
	parameter_last_month_30_start = CreateDateTime(attributes.sal_year,attributes.sal_mon,daysinmonth(createdate(attributes.sal_year,attributes.sal_mon,1)),0,0,0);
</cfscript>
<cfquery name="get_insurance" datasource="#dsn#">
	SELECT ISNULL(MAX_PAYMENT,0) MAX_PAYMENT FROM INSURANCE_PAYMENT WHERE STARTDATE <= #parameter_last_month_1# AND FINISHDATE >= #parameter_last_month_30_start#
</cfquery>
<cfif not get_insurance.RECORDCOUNT>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='54640.Asgari Ücret Tanımları Eksik'>!");
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
</cfscript>

<cfset puantaj_gun_ = daysinmonth(CREATEDATE(year(get_in_out.finish_date),month(get_in_out.finish_date),1))>
<cfset bu_ay_basi = dateadd('m',-1,createdate(year(get_in_out.finish_date),month(get_in_out.finish_date),1))>
<cfset bu_ay_sonu = CREATEODBCDATETIME(date_add("d",1,CREATEDATE(year(get_in_out.finish_date),month(get_in_out.finish_date),puantaj_gun_)))>

<cfquery name="get_izins" datasource="#dsn#">
	SELECT 
		OFFTIME.EMPLOYEE_ID, SETUP_OFFTIME.EBILDIRGE_TYPE_ID, SETUP_OFFTIME.IS_PAID, SETUP_OFFTIME.SIRKET_GUN,
		OFFTIME.STARTDATE,OFFTIME.FINISHDATE
	FROM 
		OFFTIME, SETUP_OFFTIME
	WHERE
		SETUP_OFFTIME.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID AND 
		OFFTIME.VALID = 1 AND 
		OFFTIME.STARTDATE < #BU_AY_SONU# AND 
		OFFTIME.FINISHDATE >= #BU_AY_BASI# AND
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
		BRANCH,
		EMPLOYEES_IN_OUT,
		EMPLOYEES_PUANTAJ,
		EMPLOYEES_PUANTAJ_ROWS
	WHERE
		EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID AND
		EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID AND
		BRANCH.SSK_OFFICE = EMPLOYEES_PUANTAJ.SSK_OFFICE AND
		BRANCH.SSK_NO = EMPLOYEES_PUANTAJ.SSK_OFFICE_NO AND
		EMPLOYEES_IN_OUT.IN_OUT_ID = EMPLOYEES_PUANTAJ_ROWS.IN_OUT_ID AND
		EMPLOYEES_PUANTAJ.SAL_MON IN (#month(dateadd('m',-1,get_in_out.finish_date))#,#month(get_in_out.finish_date)#) AND
		EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = #attributes.employee_id# AND
		EMPLOYEES_PUANTAJ.SAL_YEAR >= #year(dateadd('m',-1,get_in_out.finish_date))# AND
		EMPLOYEES_IN_OUT.START_DATE < #bu_ay_sonu# AND
		(EMPLOYEES_IN_OUT.FINISH_DATE >= #bu_ay_basi# OR EMPLOYEES_IN_OUT.FINISH_DATE IS NULL)
	ORDER BY
		EMPLOYEES_PUANTAJ.SAL_YEAR,
		EMPLOYEES_PUANTAJ.SAL_MON
</cfquery>
<!---<cfloop from="#month(get_in_out.finish_date)-1#" to="#month(get_in_out.finish_date)#" index="indx">--->
<cfloop from="1" to="#get_puantaj_personal.recordcount#" index="indx">
	<cfset 't_kidem_amount#indx#' = 0>
	<cfset 't_ihbar_amount#indx#' = 0>
	<cfset 't_yillik_izin_amount#indx#' = 0>
	<cfset 't_ext_salary#indx#' = 0>
	<cfset 't_ssk_paid_izin_amount#indx#' = 0>
	<cfset 't_ssdf_paid_izin_amount#indx#' = 0>
	<cfset 'genel_tatil_amount#indx#' = 0>
	<cfset 'normal_amount#indx#' = 0>
	<cfset 'haftalik_tatil_amount#indx#' = 0>
	<cfset 't_paid_izin#indx#' = 0>
	<cfset 'normal_gun_#indx#' = 0>
	<!--- <cfset 'genel_odenek_total#indx#' = 0>  SG 20130816--->
	<cfset 't_vergi_istisna_yaz#indx#' = 0>
	<cfset 't_normal_gun#indx#' =  0>
	<cfset 'izin#indx#' = 0>
	<cfset 'EKSIKGUNNEDENI#indx#' = 0>
	<cfset 'total_ikramiye#indx#' = 0>
	<cfset 'total_ikramiye_yaz#indx#' = 0>
	<cfset 'total_kazanc#indx#' = 0>
	<cfset 'total_ucret#indx#' = 0>
	<cfset 'ikramiye_tutar#indx#' = 0>
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
	</cfscript>
	<cfscript>
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
<cfif isdefined('attributes.print')>
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
<cfoutput>
<cf_box title="#getlang('','SİGORTALI İŞTEN AYRILIŞ BİLDİRGESİ','46339')#" uidrop="1">
	<div class="ui-scroll ListContent">
	<table style="width:180mm; height:255mm;" align="center" class="tbl_tcNo">
		<tr>
			<td class="header_" colspan="2">
				<cf_get_lang dictionary_id="45795.T.C."><br />
				<cf_get_lang dictionary_id="30489.SOSYAL GÜVENLİK KURUMU">
				<br />
				<cf_get_lang dictionary_id="46339.SİGORTALI İŞTEN AYRILIŞ BİLDİRGESİ"><br />
				<span style="font-size:-6;">(<cf_get_lang dictionary_id="46338.4/1-a-b VE 505 SK GM 20 kapsamındaki sigortalılar için">)</span>
			</td>
		</tr>
		<tr><!--- SOSYAL GUVENLIK SICIL NUMARASI (T.C.Kimlik Numarası) --->
			<td colspan="2" align="center" valign="middle">
				<table class="tbl_tcNo">
					<tr>
						<td colspan="11" class="header_"><cf_get_lang dictionary_id="46334.SOSYAL GÜVENLİK SICIL NUMARASI">(<cf_get_lang dictionary_id="58025.T.C. Kimlik Numarası">)</td>
					</tr>
					<tr>
						<cfif Len(emp_last_work.TC_IDENTY_NO)>
							<cfloop from="1" to="#Len(emp_last_work.TC_IDENTY_NO)#" index="Sayac">
								<td align="center">#Mid(emp_last_work.TC_IDENTY_NO,Sayac,1)#</td>
							</cfloop>
						<cfelse>
								<td align="center">&nbsp;</td>
								<td align="center">&nbsp;</td>
								<td align="center">&nbsp;</td>
								<td align="center">&nbsp;</td>
								<td align="center">&nbsp;</td>
								<td align="center">&nbsp;</td>
								<td align="center">&nbsp;</td>
								<td align="center">&nbsp;</td>
								<td align="center">&nbsp;</td>
								<td align="center">&nbsp;</td>
								<td align="center">&nbsp;</td>
						</cfif>
					</tr>
				</table>
			</td>
		</tr>
		<!--- A-SİGORTALINlN KİMLİK ADRES BİLGİLERİ --->
		<tr>
			<td colspan="2" class="header_">A-<cf_get_lang dictionary_id="46332.SİGORTALINlN KİMLİK ADRES BİLGİLERİ"></td>
		</tr>
		<tr>
			<td width="50%" valign="top">
				<table class="tbl">
					<tr>
						<td style="width:5%;">1</td>
						<td style="width:48%;"><cf_get_lang dictionary_id="57897.Adı"></td>
						<td style="width:47%;">#emp_last_work.employee_name#&nbsp;</td>
					</tr>
					<tr>
						<td>2</td>
						<td><cf_get_lang dictionary_id="58550.Soyadı"></td>
						<td>#emp_last_work.employee_surname#&nbsp;</td>
					</tr>
					<tr>
						<td>3</td>
						<td><cf_get_lang dictionary_id="45931.İlk Soyadı"></td>
						<td>#emp_last_work.LAST_SURNAME#&nbsp;</td>
					</tr>
					<tr>
						<td>4</td>
						<td><cf_get_lang dictionary_id="58033.Baba Adı"></td>
						<td>#emp_last_work.father#&nbsp;</td>
					</tr>
					<tr>
						<td>5</td>
						<td><cf_get_lang dictionary_id="58440.Ana Adı"></td>
						<td>#emp_last_work.mother#&nbsp;</td>
					</tr>
					<tr>
						<td>6</td>
						<td><cf_get_lang dictionary_id="57790.Doğum Yeri"></td>
						<td>#emp_last_work.BIRTH_PLACE#&nbsp;</td>
					</tr>
					<tr>
						<td>7</td>
						<td><cf_get_lang dictionary_id="58727.Doğum Tarihi"></td>
						<td><cfif len(emp_last_work.birth_date)>#dateformat(emp_last_work.birth_date,dateformat_style)#<cfelse>&nbsp;</cfif></td>
					</tr>
					<tr>
						<td>8</td>
						<td><cf_get_lang dictionary_id="32872.Cinsiyeti"></td>
						<td><cf_get_lang_main no='58959.Erkek'>&nbsp;&nbsp;:<input type="radio" <cfif emp_last_work.sex eq 1>checked</cfif>>
							<cf_get_lang_main no='58958.Kadın'>&nbsp;&nbsp;:<input type="radio" <cfif emp_last_work.sex eq 0>checked</cfif>>
						</td>
					</tr>
					<tr>
						<td>9</td>
						<td><cf_get_lang dictionary_id="30693.Medeni Hali"></td>
						<td><cf_get_lang dictionary_id="38916.Evli"><input type="radio"<cfif emp_last_work.married eq 1>checked</cfif>>&nbsp;
							<cf_get_lang dictionary_id="30694.Bekar"><input type="radio"<cfif emp_last_work.married eq 0>checked</cfif>>
						</td>
					</tr>
					<tr>
						<td>10</td>
						<td><cf_get_lang dictionary_id="45940.Yabancı Uyruklu ise Ülke Adı"></td>
						<td> <cfif emp_last_work.nationality eq 1>
							<cf_get_lang dictionary_id="45795.T.C.">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:<input type="radio" name="nationality" id="nationality" checked><br>
							  <cfelseif len(emp_last_work.nationality)>
								<cfquery name="get_nationality" datasource="#dsn#">
									SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID= #emp_last_work.nationality#
								</cfquery>
							 <cf_get_lang dictionary_id="46550.Yabancı">&nbsp;:#get_nationality.COUNTRY_NAME#
							  </cfif>
						</td>
					</tr>
				</table>
			</td>
			<!--- NÜFUSA KAYITLI OLDUĞU YER --->
			<td valign="top">
				<table class="tbl">
					<tr>
						<td rowspan="7" style="width:5%;">11</td>
						<td colspan="2" class="header_"><cf_get_lang dictionary_id="53926.NÜFUSA KAYITLI OLDUĞU YER"></td>
					</tr>
					<tr>
						<td style="width:50%;"><cf_get_lang dictionary_id="58608.İl"></td>
						<td>&nbsp;#emp_last_work.CITY#</td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id="58638.İlçe"></td>
						<td>&nbsp;#emp_last_work.COUNTY#</td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id="58735.Mahalle">/<cf_get_lang dictionary_id="30326.Köy"></td>
						<td>&nbsp;#emp_last_work.WARD#/#emp_last_work.VILLAGE#</td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id="31249.Cilt No"></td>
						<td>&nbsp;#emp_last_work.BINDING#</td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id="31251.Aile Sıra No"></td>
						<td>&nbsp;#emp_last_work.FAMILY#</td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id="31253.Sıra No"></td>
						<td>&nbsp;#emp_last_work.CUE#</td>
					</tr>
				</table>
				<br />
				<table class="tbl">
					<tr>
						<td rowspan="7" style="width:5%;">12</td>
						<td colspan="4" class="header_"><cf_get_lang dictionary_id="38974.İKAMETGAH ADRESİ"></td>
					</tr>
					<tr>
						<td style="width:30%;"><cf_get_lang dictionary_id="58723.Adres"></td>
						<td colspan="3">&nbsp;#emp_last_work.homeaddress#</td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id="30629.Cadde">-<cf_get_lang dictionary_id="30630.Sokak"></td>
						<td>-</td>
						<td><cf_get_lang dictionary_id="55987.Dış Kapı">: -<br /><cf_get_lang dictionary_id="46323.BLOK">: -</td>
						<td><cf_get_lang dictionary_id="55988.İç Kapı">: -</td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id="53928.Mahalle/Köy"></td>
						<td>-</td>
						<td><cf_get_lang dictionary_id="57472.Posta Kodu"></td>
						<td>#emp_last_work.homepostcode#</td>
					</tr>
					<cfif Len(emp_last_work.homecity)>
						<cfquery name="get_city" datasource="#dsn#">
							SELECT CITY_ID, CITY_NAME, PHONE_CODE, COUNTRY_ID FROM SETUP_CITY WHERE CITY_ID = #emp_last_work.homecity#
						</cfquery>
					</cfif>

					<cfif Len(emp_last_work.homecounty)>
						<cfquery name="get_county" datasource="#dsn#">
							SELECT COUNTY_NAME, COUNTY_ID, CITY FROM SETUP_COUNTY WHERE COUNTY_ID = #emp_last_work.homecounty#
						</cfquery>
					</cfif>
					<tr>
						<td><cf_get_lang dictionary_id="58638.İlçe"></td>
						<td><cfif Len(emp_last_work.homecounty)>#get_county.COUNTY_NAME#<cfelse>-</cfif></td>
						<td><cf_get_lang dictionary_id="58608.İl"></td>
						<td><cfif Len(emp_last_work.homecity)>#get_city.CITY_NAME#<cfelse>-</cfif></td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id="31261.Ev Tel"></td>
						<td>#emp_last_work.hometel_code# #emp_last_work.hometel#</td>
						<td><cf_get_lang dictionary_id="30697.Cep Tel"></td>
						<td><cfif Len(emp_last_work.MOBILCODE_SPC) and Len(emp_last_work.MOBILTEL_SPC)>
								#emp_last_work.MOBILCODE_SPC# #emp_last_work.MOBILTEL_SPC#
							<cfelse>
								<cfif Len(emp_last_work.MOBILCODE2_SPC) and Len(emp_last_work.MOBILTEL2_SPC)>
									#emp_last_work.MOBILCODE2_SPC# #emp_last_work.MOBILTEL2_SPC#
								<cfelse>
									&nbsp;
								</cfif>
							</cfif>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id="57428.E-posta"></td>
						<td colspan="3">#emp_last_work.EMAIL_SPC#</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<table class="tbl">
					<tr>
						<td colspan="7" class="header_">B-<cf_get_lang dictionary_id="53950.SİGORTALININ SOSYAL GÜVENLİK BİLGİLERİ"></td>
					</tr>
					<tr>
						<td rowspan="2">13</td>
						<td rowspan="2">#DateFormat(get_in_out.start_date, dateformat_style)# <cf_get_lang dictionary_id="46330.tarihinden önce hizmet varsa"></td>
						<td><cf_get_lang dictionary_id="57712.Kurum"></td>
						<td><cf_get_lang dictionary_id="46328.SSK"></td>
						<td><cf_get_lang dictionary_id="52518.BAĞ"></td>
						<td><cf_get_lang dictionary_id="54132.Emekli Sandığı"></td>
						<td>506-G.20. M</td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id="32328.Sicil No"></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>14</td>
						<td><cf_get_lang dictionary_id="46321.Meslek Adı ve Kodu"></td>
						<td colspan="5">
							<cfif len(get_in_out.business_code_id)>
								<cfquery name="get_business_codes" datasource="#DSN#">
									SELECT * FROM SETUP_BUSINESS_CODES WHERE BUSINESS_CODE_ID = #get_in_out.business_code_id#
								</cfquery>
								<cfif get_business_codes.recordcount>#get_business_codes.business_code_name# (#get_business_codes.business_code#)</cfif>
							</cfif>						
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<table class="tbl">
					<tr>
						<td colspan="13" class="header_">C-<cf_get_lang dictionary_id="46318.SİGORTALININ HİZMET BİLGİLERİ"></td>
					</tr>
					<tr>
						<td>15</td>
						<td colspan="4"><cf_get_lang dictionary_id="46316.Sigortalının işten ayrılış tarihi"></td>
						<td colspan="3">#dateformat(get_in_out.finish_date,dateformat_style)#</td>
						<td>16</td>
						<td colspan="2"><cf_get_lang dictionary_id="46364.Sigortalının İşten Ayrılış Nedeni (Kodu)"></td>
						<td colspan="2">#get_explanation_name(get_in_out.explanation_id)#</td>
					</tr>
					<tr>
						<cfset rows_ = 3+GET_PUANTAJ_PERSONAL.recordcount>
						<td rowspan="#rows_#">17</td>
						<td rowspan="3"><cf_get_lang dictionary_id="58455.Yıl"></td>
						<td rowspan="3"><cf_get_lang dictionary_id="58724.Ay"></td>
						<td rowspan="3"><cf_get_lang dictionary_id="58578.Belge Türü"></td>
						<td rowspan="3"><cf_get_lang dictionary_id="38879.Gün Sayısı"></td>
						<td colspan="2" rowspan="2"><cf_get_lang dictionary_id="46570.Prime Esas Kazanç Tutarı"></td>
						<td colspan="4"><cf_get_lang dictionary_id="53857.Ay İçinde"></td>
						<td rowspan="2" colspan="2"><cf_get_lang dictionary_id="46568.Eksik Gün"></td>
					</tr>
					<tr>
						<td colspan="2"><cf_get_lang dictionary_id="38923.İşe Giriş Tarihi"></td>
						<td colspan="2"><cf_get_lang dictionary_id="31287.İşten Çıkış Tarihi"></td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id="46567.Hak Edilen Ücret"></td>
						<td><cf_get_lang dictionary_id="46490.Prim İkramiye ve Bu Nitelikteki İstihkak"></td>
						<td><cf_get_lang dictionary_id="57490.Gün"></td>
						<td><cf_get_lang dictionary_id="58724.Ay"></td>
						<td><cf_get_lang dictionary_id="57490.Gün"></td>
						<td><cf_get_lang dictionary_id="58724.Ay"></td>
						<td><cf_get_lang dictionary_id="39852.Sayısı"></td>
						<td><cf_get_lang dictionary_id="34777.Nedeni"></td>
					</tr>
					
					<!---<cfif GET_PUANTAJ_PERSONAL.recordcount gt 1>--->
						<cfloop query="GET_PUANTAJ_PERSONAL">
							<cfset ucret = 0>
							<cfset ikramiye = 0>
							<tr>
								<td>#sal_year#</td>
								<td>#sal_mon#</td>
								<td><cfif get_in_out.ssk_statute eq 1><cf_get_lang dictionary_id="32287.Normal"><cfelseif get_in_out.ssk_statute eq 2 or get_in_out.ssk_statute eq 18><cf_get_lang dictionary_id="58541.Emekli"></cfif></td> <!---Muzaffer Köse İmbat Yeraltı gurubu--->
								<td>#evaluate('t_normal_gun#currentrow#')#</td>
								<cfif evaluate('t_paid_izin#currentrow#') gt 0>
									<cfset 'ucretli_izin_amount#currentrow#' =  evaluate('t_ssdf_paid_izin_amount#currentrow#') +  evaluate('t_ssk_paid_izin_amount#currentrow#')>
								<cfelse>
									<cfset 'ucretli_izin_amount#currentrow#' = 0>
								</cfif>
								<td>
									<cfscript>
										ssk_matrah_tavan = (get_insurance.MAX_PAYMENT * GET_PUANTAJ_PERSONAL.total_days) / 30;
									</cfscript>
									<cfset ucret = evaluate('t_yillik_izin_amount#currentrow#') + evaluate('genel_tatil_amount#currentrow#') + evaluate('normal_amount#currentrow#') + evaluate('haftalik_tatil_amount#currentrow#') + evaluate('ucretli_izin_amount#currentrow#') + evaluate('t_ext_salary#currentrow#')>
									<cfif ucret gt 0>
										<cfif ucret gt ssk_matrah_tavan>
											<cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TlFormat(ssk_matrah_tavan)#">
										<cfelse>
											<cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(ucret)#">	
										</cfif>
									</cfif>
								</td>
								<td>
									<cfset ikramiye = evaluate('ikramiye_tutar#currentrow#')>
									<cfif ikramiye gt 0>
										<cfif ucret+ikramiye gt ssk_matrah_tavan>
											<cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TlFormat(ssk_matrah_tavan-ucret)#">	
										<cfelse>
											<cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(ikramiye)#">	
										</cfif>
									</cfif>
								</td>
								<td><cfif sal_mon eq month(get_in_out.start_date) and sal_year eq year(get_in_out.start_date)>#day(get_in_out.start_date)#</cfif></td>
								<td><cfif sal_mon eq month(get_in_out.start_date) and sal_year eq year(get_in_out.start_date)>#month(get_in_out.start_date)#</cfif></td>
								<td><cfif sal_mon eq month(get_in_out.finish_date) and sal_year eq year(get_in_out.finish_date)>#day(get_in_out.finish_date)#</cfif></td>
								<td><cfif sal_mon eq month(get_in_out.finish_date) and sal_year eq year(get_in_out.finish_date)>#month(get_in_out.finish_date)#</cfif></td>
								<td>#evaluate('izin#currentrow#')#</td>
								<td>#evaluate('EKSIKGUNNEDENI#currentrow#')#</td>
							</tr>
						</cfloop>
					<!---</cfif>
					<cfloop query="get_in_out">
						<tr>
							<td>#year(finish_date)#</td>
							<td>#month(finish_date)#</td>
							<td><cfif ssk_statute eq 1>Normal<cfelseif ssk_statute eq 2>Emekli</cfif></td>
							<td>#evaluate('t_normal_gun#month(finish_date)#')#</td>
							<cfif evaluate('t_paid_izin#month(finish_date)#') gt 0>
								<cfset 'ucretli_izin_amount#month(finish_date)#' =  evaluate('t_ssdf_paid_izin_amount#month(finish_date)#') +  evaluate('t_ssk_paid_izin_amount#month(finish_date)#')>
							<cfelse>
								<cfset 'ucretli_izin_amount#month(finish_date)#' = 0>
							</cfif>
							<td>#TLFormat(wrk_round(evaluate('t_yillik_izin_amount#month(finish_date)#')) + wrk_round(evaluate('t_kidem_amount#month(finish_date)#')) + wrk_round(evaluate('t_ihbar_amount#month(finish_date)#')) + wrk_round(evaluate('genel_tatil_amount#month(finish_date)#')) + wrk_round(evaluate('normal_amount#month(finish_date)#')) + wrk_round(evaluate('haftalik_tatil_amount#month(finish_date)#')) + wrk_round(evaluate('ucretli_izin_amount#month(finish_date)#')) + wrk_round(evaluate('t_ext_salary#month(finish_date)#')))#</td>
							<td>#TLFormat(evaluate('genel_odenek_total#month(finish_date)#')+evaluate('t_vergi_istisna_yaz#month(finish_date)#'))#</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>#day(finish_date)#</td>
							<td>#month(finish_date)#</td>
							<td>#evaluate('izin#month(finish_date)#')#</td>
							<td>#evaluate('EKSIKGUNNEDENI#month(finish_date)#')#</td>
						</tr>
					</cfloop>--->
					<tr>
						<td>18</td>
						<td colspan="4"><cf_get_lang dictionary_id="35082.ÜCRET">(<cf_get_lang dictionary_id="46486.Yüzde Usulü">)</td>
						<td colspan="3">...</td>
						<td colspan="5">...</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<table class="tbl">
					<tr>
						<td colspan="21" class="header_">D-<cf_get_lang dictionary_id="46487.İŞVEREN/İŞYERİ/VERGİ DAİRESİ/ESNAF SAN.SİC.MEMURLUĞU/ZiRAAT ODASl/TARIM İL/İLÇE MD./ŞİRKET BİLGİLERİ"></td>
					</tr>
					<tr>
						<td rowspan="2">22</td>
						<td rowspan="2"><cf_get_lang dictionary_id="46485.ÇSGB İŞ KOLU">:</td>
						<td rowspan="2" colspan="4"><cf_get_lang dictionary_id="46483.ÇSGB BÖLGE MÜDÜRLÜĞÜ DOSYA NUMARASI">:</td>
						<td>S</td>
						<td colspan="4"><cf_get_lang dictionary_id="46226.MESLEK"></td>
						<td colspan="7"><cf_get_lang dictionary_id="50132.DOSYA NO"></td>
						<td colspan="2"><cf_get_lang dictionary_id="58608.İL"></td>
					</tr>
					<tr>
						<td>.</td>
						<td>.</td>
						<td>.</td>
						<td>.</td>
						<td>.</td>
						<td>.</td>
						<td>.</td>
						<td>.</td>
						<td>.</td>
						<td>.</td>
						<td>.</td>
						<td>.</td>
						<td>.</td>
						<td>.</td>
					</tr>
					<tr>
						<td rowspan="3">23</td>
						<td rowspan="3" class="style1"><cf_get_lang dictionary_id="46564.SGK İŞYERİ SİCİL NUMARASI"></td>
						<td rowspan="2">M</td>
						<td rowspan="2"><cf_get_lang dictionary_id="39973.İŞ KOLU"></td>
						<td colspan="2"><cf_get_lang dictionary_id="46472.ÜNİTE"></td>
						<td rowspan="2" colspan="4"><cf_get_lang dictionary_id="39975.İŞYERİ NO"></td>
						<td rowspan="2" colspan="3"><cf_get_lang dictionary_id="39976.İL KOD"></td>
						<td rowspan="2" colspan="2"><cf_get_lang dictionary_id="58638.İLÇE"></td>
						<td rowspan="2" colspan="2">KONT KOD</td>
						<td rowspan="2" colspan="3">ALT İŞV.</td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id="58674.YENİ"></td>
						<td><cf_get_lang dictionary_id="53832.ESKİ"></td>
					</tr>
					<tr>
						<td>&nbsp;#get_in_out.ssk_m#</td>
						<td>&nbsp;#mid(get_in_out.SSK_JOB,1,1)# #mid(get_in_out.SSK_JOB,2,1)# #mid(get_in_out.SSK_JOB,3,1)# #mid(get_in_out.SSK_JOB,4,1)#</td>
						<td>&nbsp;#mid(get_in_out.SSK_BRANCH,1,1)# #mid(get_in_out.SSK_BRANCH,2,1)#</td>
						<td>&nbsp;#mid(get_in_out.SSK_BRANCH_OLD,1,1)# #mid(get_in_out.SSK_BRANCH_OLD,2,1)#</td>
						<td colspan="4">&nbsp;#mid(get_in_out.SSK_NO,6,1)# #mid(get_in_out.SSK_NO,7,1)# #mid(get_in_out.SSK_CITY,1,1)# #mid(get_in_out.SSK_CITY,2,1)# #mid(get_in_out.SSK_CITY,3,1)# #mid(get_in_out.SSK_COUNTRY,1,1)# #mid(get_in_out.SSK_COUNTRY,2,1)#</td>
						<td colspan="3">&nbsp;#mid(get_in_out.SSK_CD,1,1)# #mid(get_in_out.SSK_CD,2,1)#</td>
						<td colspan="2"></td>
						<td colspan="2">.</td>
						<td colspan="3">.</td>
					</tr>
					<tr>
						<td>24</td>
						<td colspan="9"><cf_get_lang dictionary_id="56085.Vergi Numarası"></td>
						<td colspan="10">...</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<table class="tbl">
					<tr>
						<td colspan="3" class="header_">E-<cf_get_lang dictionary_id="53908.BEYAN VE TAAHHÜTLER"></td>
					</tr>
					<tr>
						<td>25</td>
						<td align="center"><cf_get_lang dictionary_id="46391.İşverenin/İşyerinin/İlgili Kuruluşun Adı-Soyadı/Ünv."><br />#get_in_out.COMPANY_NAME#</td>
						<td align="center"><cf_get_lang dictionary_id="53901.İşyerinin Adresi"><br />#get_in_out.BRANCH_ADDRESS# #get_in_out.BRANCH_POSTCODE# #get_in_out.BRANCH_COUNTY# <br />#get_in_out.BRANCH_CITY# - #get_in_out.BRANCH_COUNTRY#</td>
					</tr>
					<tr>
						<td>26</td>
						<td><cf_get_lang dictionary_id="46468.Yukarıda yazılı hususların gerçeğe uygun olduğunu beyan ederim."></td>
						<td><cf_get_lang dictionary_id="46460.Sigortalının adı-soyadı">:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id="58957.İmzası"></td>
					</tr>
					<tr>
						<td>27</td>
						<td colspan="2" align="center"><cf_get_lang dictionary_id="46469.Yukarıda yazılı hususların sigortalının nüfus cüzdanındaki ve beyan ettiği resmi belgelerdeki kayıtlara uygun olduğunu, belgenin 5510,4857,5953,854 ve 2821 sayılı kanunlarda belirtilen yükümlülükler esas alınarak düzenlendiğini beyan ederim."><br /><cf_get_lang dictionary_id="46357.Onaylayan Yetkilinin"> (<cf_get_lang dictionary_id="46466.Kaşe/Mühür/İmza">)</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
</cf_box>
</cfoutput>

<script type="text/javascript">
	function doc_repeat(is_repeat)
	{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_doc_repeat_ajax&in_out_id=#attributes.in_out_id#&employee_id=#attributes.employee_id#</cfoutput>&is_repeat=' + is_repeat + '','doc_repeat');
	}	
</script>
