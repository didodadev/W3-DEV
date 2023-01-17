<cf_date tarih="attributes.expense_date">
<cfset attributes.sal_mon = month(attributes.expense_date)>
<cfset attributes.sal_year = year(attributes.expense_date)>
<cfset expense_rules_cmp = createObject("component","V16.hr.ehesap.cfc.expense_rules") />
<cfset get_expense_rules = expense_rules_cmp.GET_EXPENSE_RULES(expense_hr_rules_id : attributes.expense_type_id) /><!--- Harcırah kuralları 20122019ERU--->
<cfset allowance_expense_cmp = createObject("component","V16.myhome.cfc.allowance_expense") /><!--- Ek Ödenek 20122019ERU--->
<cfset get_in_out_id  = allowance_expense_cmp.GET_IN_OUT_ID(attributes.EMPLOYEE_ID)><!--- In Out Id --->
<cfset tax_exemption_value = total_amount - amount><!--- (ödeneğin vergi matrahı = (günlük harcama * gün) - (istisna tutarı * gün)) --->
<cfquery name="get_hr_ssk" datasource="#dsn#">
	SELECT
		E.EMPLOYEE_ID,
		BRANCH.BRANCH_ID,
		EIO.PUANTAJ_GROUP_IDS,
		EIO.IN_OUT_ID,
		EIO.CUMULATIVE_TAX_TOTAL,
		EIO.IS_TAX_FREE,
		EIO.IS_DAMGA_FREE,
		EIO.USE_SSK,
		EIO.SSK_STATUTE
 	FROM
		EMPLOYEES_IDENTY EI,
		EMPLOYEES_DETAIL ED,
		EMPLOYEES_IN_OUT EIO,
		BRANCH,
		DEPARTMENT,
		OUR_COMPANY,
		EMPLOYEES E
	WHERE
		EIO.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
		BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND
		E.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
		E.EMPLOYEE_ID = ED.EMPLOYEE_ID AND
		E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
		(EIO.IS_PUANTAJ_OFF = 0 OR EIO.IS_PUANTAJ_OFF IS NULL) AND
		EIO.IN_OUT_ID = #attributes.in_out_id#
		AND BRANCH.BRANCH_ID = EIO.BRANCH_ID
</cfquery>
<cfquery name="get_factor_definition" datasource="#dsn#" maxrows="1">
	SELECT SALARY_FACTOR FROM SALARY_FACTOR_DEFINITION WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.expense_date#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.expense_date#">  AND SALARY_FACTOR>0
</cfquery>
<cfif get_factor_definition.recordcount eq 0>
	<script type="text/javascript">
		alert("İlgili Dönemde Aylık Katsayı Tanımı Bulunamadı !");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="get_position_cat" datasource="#dsn#">
	SELECT TITLE_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND IS_MASTER = 1
</cfquery>
<cfquery name="get_expense_factor" datasource="#dsn#" maxrows="1">
	SELECT 
		<cfif attributes.expense_type eq 1>
			DOMESTIC_FACTOR FACTOR
		<cfelse>
			OVERSEAS_FACTOR	FACTOR
		</cfif>
	FROM 
		MARCHING_MONEY_MAIN M1,
		MARCHING_MONEY_FACTORS M2,
		MARCHING_MONEY_POSITION_CATS M3 
	WHERE 
		M1.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.expense_date#"> 
		AND M1.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.expense_date#"> 
		AND M1.MARCHING_MONEY_MAIN_ID = M2.MARCHING_MONEY_MAIN_ID
		AND M2.MARCH_MONEY_ID = M3.MARCH_MONEY_ID
		AND M3.TITLE_ID = #get_position_cat.title_id#
		<cfif attributes.expense_type eq 1>
			AND DOMESTIC_FACTOR > 0
		<cfelse>
			AND OVERSEAS_FACTOR	> 0
		</cfif>
</cfquery>
<cfif get_expense_factor.recordcount eq 0>
	<script type="text/javascript">
		alert("İlgili Dönemde Harcırah Katsayısı Tanımı Bulunamadı !");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="get_insurance" datasource="#dsn#">
	SELECT * FROM INSURANCE_PAYMENT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.expense_date#">  AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.expense_date#"> 
</cfquery>
<cfif isdefined("attributes.expense_type_id") and len(attributes.expense_type_id)>
	<cfset salary_factor = 0>
<cfelseif get_factor_definition.recordcount>
	<cfset salary_factor = get_factor_definition.salary_factor>
<cfelse>
	<cfset salary_factor = 0>
</cfif>
<cfif get_expense_factor.recordcount>
	<cfset expense_factor = get_expense_factor.factor>
<cfelse>
	<cfset expense_factor = 0>
</cfif>
<cfscript>
	last_month_1 = CreateDateTime(attributes.sal_year, attributes.sal_mon,1,0,0,0);
	last_month_30 = CreateDateTime(attributes.sal_year, attributes.sal_mon,daysinmonth(last_month_1),23,59,59);
	if( isdefined("attributes.total_amount") and len(attributes.total_amount))
		puantaj_amount = attributes.total_amount;
	else 
		puantaj_amount = salary_factor*expense_factor*attributes.expense_day;
	last_branch_id = get_hr_ssk.BRANCH_ID;
	attributes.branch_id = get_hr_ssk.BRANCH_ID;
	attributes.group_id = "";
	if(len(get_hr_ssk.puantaj_group_ids))
		attributes.group_id = "#get_hr_ssk.PUANTAJ_GROUP_IDS#,";
</cfscript>
<cfinclude template="../query/get_program_parameter.cfm">
<cfquery name="get_active_program_parameter" dbtype="query">
	SELECT * FROM get_program_parameters
</cfquery>
<cfquery name="get_active_tax_slice" datasource="#dsn#">
	SELECT 
		MIN_PAYMENT_1, MIN_PAYMENT_2, MIN_PAYMENT_3, MIN_PAYMENT_4, MIN_PAYMENT_5, MIN_PAYMENT_6,
		MAX_PAYMENT_1, MAX_PAYMENT_2, MAX_PAYMENT_3, MAX_PAYMENT_4, MAX_PAYMENT_5, MAX_PAYMENT_6,
		RATIO_1, RATIO_2, RATIO_3, RATIO_4, RATIO_5, RATIO_6, SAKAT1, SAKAT2, SAKAT3, SAKAT_STYLE
	FROM 
		SETUP_TAX_SLICES 
	WHERE 
		STARTDATE <= #last_month_1# AND FINISHDATE >= #DATEADD("d", -1, last_month_30)#
</cfquery>
<cfif len(get_active_program_parameter.TAX_ACCOUNT_STYLE)>
	<cfset this_tax_account_style_ = get_active_program_parameter.TAX_ACCOUNT_STYLE>
<cfelse>
	<cfset this_tax_account_style_ = 0>
</cfif>
<cfquery name="get_kumulative" datasource="#dsn#" maxrows="1">
	SELECT 
		KUMULATIF_GELIR_MATRAH 
	FROM 
		EMPLOYEES_EXPENSE_PUANTAJ EPR
		<cfif this_tax_account_style_ eq 1>
			,BRANCH B
		</cfif>
	WHERE 
		<cfif this_tax_account_style_ eq 1>
			EPR.BRANCH_ID = B.BRANCH_ID AND
			B.COMPANY_ID = (SELECT B2.COMPANY_ID FROM BRANCH B2 WHERE B2.BRANCH_ID = #get_hr_ssk.BRANCH_ID#) AND
		</cfif>
		EPR.EMPLOYEE_ID = #attributes.employee_id# AND 
		EPR.EXPENSE_DATE <= #attributes.expense_date# AND 
		YEAR(EPR.EXPENSE_DATE) >= #year(attributes.expense_date)# AND 
		MONTH(EPR.EXPENSE_DATE) = #month(attributes.expense_date)#
		<cfif isdefined("attributes.expense_puantaj_id")>
			AND EXPENSE_PUANTAJ_ID<>#attributes.expense_puantaj_id#
		</cfif>
	ORDER BY 
		EPR.EXPENSE_DATE DESC
</cfquery>
<cfif attributes.SAL_MON neq 1>
	<cfif not get_kumulative.recordcount>
		<cfquery name="get_kumulative" datasource="#dsn#" maxrows="1">
			SELECT 
				KUMULATIF_GELIR_MATRAH 
			FROM 
				EMPLOYEES_PUANTAJ EP,
				EMPLOYEES_PUANTAJ_ROWS EPR
				<cfif this_tax_account_style_ eq 1>
					,BRANCH B
				</cfif>
			WHERE 
				<cfif this_tax_account_style_ eq 1>
					EP.SSK_BRANCH_ID = B.BRANCH_ID AND
					B.COMPANY_ID = (SELECT B2.COMPANY_ID FROM BRANCH B2 WHERE B2.BRANCH_ID = #get_hr_ssk.BRANCH_ID#) AND
				</cfif>
				EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND 
				EPR.EMPLOYEE_ID = #attributes.employee_id# AND 
				EP.SAL_YEAR = #attributes.sal_year# AND 
				EP.SAL_MON = #attributes.sal_mon#
			ORDER BY 
				EPR.EMPLOYEE_PUANTAJ_ID DESC 
		</cfquery>
		<cfif not get_kumulative.recordcount>
			<cfquery name="get_kumulative" datasource="#dsn#" maxrows="1">
				SELECT 
					KUMULATIF_GELIR_MATRAH 
				FROM 
					EMPLOYEES_PUANTAJ EP,
					EMPLOYEES_PUANTAJ_ROWS EPR
					<cfif this_tax_account_style_ eq 1>
						,BRANCH B
					</cfif>
				WHERE 
					<cfif this_tax_account_style_ eq 1>
						EP.SSK_BRANCH_ID = B.BRANCH_ID AND
						B.COMPANY_ID = (SELECT B2.COMPANY_ID FROM BRANCH B2 WHERE B2.BRANCH_ID = #get_hr_ssk.BRANCH_ID#) AND
					</cfif>
					EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND 
					EPR.EMPLOYEE_ID = #attributes.employee_id# AND 
					EP.SAL_YEAR = #attributes.sal_year# AND 
					EP.SAL_MON < #attributes.SAL_MON#
				ORDER BY 
					EPR.EMPLOYEE_PUANTAJ_ID DESC 
			</cfquery>
		</cfif>
	</cfif>
</cfif>
<cfif attributes.SAL_MON eq 1 and not (isdefined("get_kumulative") and get_kumulative.recordcount)>
	<cfset kontrol_matrah = 0>
	<cfset kontrol_kumulative = 1>
<cfelse>
	<cfset kontrol_kumulative = get_kumulative.recordcount>
	<cfif len(get_kumulative.KUMULATIF_GELIR_MATRAH)>
		<cfset kontrol_matrah = get_kumulative.KUMULATIF_GELIR_MATRAH>
	<cfelse>
		<cfset kontrol_matrah = 0>
	</cfif>
</cfif>
<cfscript>
	kazanca_dahil_olan_odenek_tutar_muaf = 0;
	brut_salary = puantaj_amount;
	ilk_salary = puantaj_amount;
	tutar_ = puantaj_amount;
	ilk_sal_temp = puantaj_amount;
	is_mesai_ = 0;
	is_izin_ = 0;
	is_tax_ = 1;
	is_ssk_ = 0;
	total_pay_tax = 0;
	is_issizlik_ = 1;
	devir_matrah_ = 0;
	ssk_isci_carpan = 0;
	issizlik_isci_carpan = 0;
	sakatlik_indirimi = 0;
	vergi_istisna = 0;
	puantaj_exts = ArrayNew(2);
	ssk_matrah_taban = get_insurance.MIN_PAYMENT;
	ssk_matrah_tavan = get_insurance.MAX_PAYMENT;
	get_hr_salary.gross_net = 1;
	if (kontrol_kumulative eq 1)
		kumulatif_gelir = kontrol_matrah;
	else if(len(get_hr_ssk.CUMULATIVE_TAX_TOTAL))
		kumulatif_gelir = get_hr_ssk.CUMULATIVE_TAX_TOTAL;
	else
		kumulatif_gelir = 0;
	onceki_ay_kumulatif_gelir_vergisi_matrah = kumulatif_gelir;
	odenek_oncesi_gelir_vergisi_matrah = 0;
	ssk_isveren_carpan = 0;
	issizlik_isveren_carpan = 0;
	sendika_indirimi = 0;
	odenek_oncesi_gelir_vergisi = 0;
	odenek_oncesi_damga_vergisi = 0;
	damga_vergisi = 0;
	total_pay_ssk_tax = 0;
	ssk_days = 30;
	include('get_hr_compass_from_net_odenek.cfm');
	damga_vergisi = ((eklenen) * get_active_program_parameter.STAMP_TAX_BINDE ) / 1000;
</cfscript>
<cfif isdefined("attributes.expense_puantaj_id")>
	<cfquery name="upd_expense_puantaj" datasource="#dsn#">
		UPDATE
			EMPLOYEES_EXPENSE_PUANTAJ
		SET
			EXPENSE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.expense_date#">,
			EXPENSE_DAY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_day#">,
			EXPENSE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_type#">,
			KUMULATIF_GELIR_MATRAH = <cfqueryparam cfsqltype="cf_sql_float" value="#kumulatif_gelir+GELIR_VERGISI_MATRAH#">,
			GELIR_VERGISI_MATRAH = <cfqueryparam cfsqltype="cf_sql_float" value="#GELIR_VERGISI_MATRAH#">,
			BRUT_AMOUNT = <cfqueryparam cfsqltype="cf_sql_float" value="#eklenen#">,
			NET_AMOUNT = <cfqueryparam cfsqltype="cf_sql_float" value="#puantaj_amount#">,
			DAMGA_VERGISI = <cfqueryparam cfsqltype="cf_sql_float" value="#damga_vergisi#">,
			GELIR_VERGISI = <cfqueryparam cfsqltype="cf_sql_float" value="#gelir_vergisi#">,
			EXP_AMOUNT = <cfqueryparam cfsqltype="cf_sql_float" value="#salary_factor#">,
			TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_position_cat.title_id#">,
			EXPENSE_CENTER_ID = <cfif len(attributes.expense_center_id)>#attributes.expense_center_id#<cfelse>NULL</cfif>,
            EXPENSE_CODE = <cfif len(attributes.expense_code)>'#attributes.expense_code#'<cfelse>NULL</cfif>,
            EXPENSE_CODE_NAME = <cfif len(attributes.EXPENSE_CODE_NAME)>'#attributes.EXPENSE_CODE_NAME#'<cfelse>NULL</cfif>,
            UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
			PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
			PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#">,
			EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#">,
			EXPENSE_HR_RULES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_type_id#">,
			TAX_EXCEPTION_AMOUNT = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.tax_exception_amount#">,
			TAX_EXCEPTION_MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tax_exception_money_type#">,
			SALARYPARAM_PAY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.salaryparam_pay_id#">,
			DAILY_SPENDING = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.daily_spending#">
		WHERE
			EXPENSE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_puantaj_id#">
	</cfquery>
	<!--- Harcırah Bordrosunu harcırah kurallarından gelen verilere göre Ek ödenek olarak ekler 20122019ERU--->
	<cfset get_allowance_expense = allowance_expense_cmp.UPD_SALARYPARAM_PAY(
			comment_pay :  attributes.expense_type_name,<!--- Ödenek İsmi --->
        	comment_pay_id : attributes.expense_type_id,<!---Ödenek Id --->
        	amount_pay : attributes.total_amount,<!--- Ödenek --->
        	ssk : 1,<!--- ssk 1 : muaf, 2: muaf değil ---> 
       		tax :2,<!--- vergi 1 : muaf, 2: muaf değil---> 
        	is_damga : get_expense_rules.is_stamp_tax,<!--- damga vergisi --->
        	is_issizlik : 0,<!--- işsizlik ---> 
        	show : 1,<!--- bordroda görünsün ---> 
        	method_pay : 1,<!--- 1: artı, 2 : ay , 3 : gün, 4 : saat---> 
        	period_pay : 1,<!--- 1: ayda 1, 2 : 3 ayda 1 , 3 : 6 ayda 1, 4 : yılda 1---> 
        	start_sal_mon : attributes.sal_mon,<!--- Başlangıç Ayı --->
        	end_sal_mon : attributes.sal_mon,<!--- Bitiş Ayı --->
        	employee_id : attributes.employee_id,<!--- çalışan id --->
        	term : attributes.sal_year,<!--- yıl --->
        	calc_days : 0,<!---tutar günü 0 : tümü, 1: gün,2 : fiili gün --->
        	is_kidem : 0,<!--- kıdeme dahil 1:kıdeme ahil,0 kıdeme dahil değil --->
        	in_out_id : get_in_out_id.in_out_id,<!--- Giriş çıkış id --->
        	from_salary : 0, <!--- 0 :net,1 : brüt --->
       		is_ehesap : 0,<!--- üst düzey ik yetkisi 1 : dahi, 0 :dahil değil--->
        	is_ayni_yardim : 0,<!--- ayni yardım --->
        	tax_exemption_value : tax_exemption_value,<!--- Gelir Vergisi Muafiyet Tutarı (ödeneğin vergi matrahı = (günlük harcama * gün) - (istisna tutarı * gün)) --->
        	tax_exemption_rate : attributes.amount,<!--- Gelir Vergisi Muafiyet Oranı--->
        	money : get_expense_rules.MONEY_TYPE,<!--- Para birimi--->
        	is_income : 0,<!--- kazançlara dahil--->
        	is_not_execution : 1,<!--- İcraya Dahil Değil --->
        	comment_type : 1,<!--- 1: ek ödenek, 2: kazanc --->
			expense_puantaj_id : attributes.expense_puantaj_id
			) />
<cfelse>	
	<cfquery name="add_expense_puantaj" datasource="#dsn#" result="MAX_ID">
		INSERT INTO
			EMPLOYEES_EXPENSE_PUANTAJ
			(
				EMPLOYEE_ID,
				IN_OUT_ID,
				BRANCH_ID,
				EXPENSE_DATE,
				EXPENSE_DAY,
				EXPENSE_TYPE,
				GELIR_VERGISI_MATRAH,
				KUMULATIF_GELIR_MATRAH,
				BRUT_AMOUNT,
				NET_AMOUNT,
				DAMGA_VERGISI,
				GELIR_VERGISI,
				EXP_AMOUNT,
				TITLE_ID,
                EXPENSE_CENTER_ID,
                EXPENSE_CODE,
                EXPENSE_CODE_NAME,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP,
				PROCESS_STAGE,
				PAPER_NO,
				EXPENSE_ITEM_ID,
				EXPENSE_HR_RULES_ID,
				TAX_EXCEPTION_AMOUNT,
				TAX_EXCEPTION_MONEY_TYPE,
				SALARYPARAM_PAY_ID,
				DAILY_SPENDING
			)				
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#last_branch_id#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.expense_date#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_day#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_type#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#GELIR_VERGISI_MATRAH#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#kumulatif_gelir+GELIR_VERGISI_MATRAH#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#eklenen#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#puantaj_amount#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#damga_vergisi#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#gelir_vergisi#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#salary_factor#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#get_position_cat.title_id#">,
                <cfif len(attributes.expense_center_id)>#attributes.expense_center_id#<cfelse>NULL</cfif>,
                <cfif len(attributes.expense_code)>'#attributes.expense_code#'<cfelse>NULL</cfif>,
                <cfif len(attributes.EXPENSE_CODE_NAME)>'#attributes.EXPENSE_CODE_NAME#'<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_type_id#">,		
				<cfqueryparam cfsqltype="cf_sql_float" value="#attributes.tax_exception_amount#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tax_exception_money_type#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.salaryparam_pay_id#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.daily_spending#">
			)
	</cfquery>
	<!--- Harcırah Bordrosunu harcırah kurallarından gelen verilere göre Ek ödenek olarak ekler 20122019ERU--->
	<cfset get_allowance_expense = allowance_expense_cmp.ADD_SALARYPARAM_PAY(
			comment_pay :  attributes.expense_type_name,<!--- Ödenek İsmi --->
        	comment_pay_id : attributes.expense_type_id,<!---Ödenek Id --->
        	amount_pay : attributes.total_amount,<!--- Ödenek --->
        	ssk : 1,<!--- ssk 1 : muaf, 2: muaf değil ---> 
       		tax :2,<!--- vergi 1 : muaf, 2: muaf değil---> 
        	is_damga : get_expense_rules.is_stamp_tax,<!--- damga vergisi --->
        	is_issizlik : 0,<!--- işsizlik ---> 
        	show : 1,<!--- bordroda görünsün ---> 
        	method_pay : 1,<!--- 1: artı, 2 : ay , 3 : gün, 4 : saat---> 
        	period_pay : 1,<!--- 1: ayda 1, 2 : 3 ayda 1 , 3 : 6 ayda 1, 4 : yılda 1---> 
        	start_sal_mon : attributes.sal_mon,<!--- Başlangıç Ayı --->
        	end_sal_mon : attributes.sal_mon,<!--- Bitiş Ayı --->
        	employee_id : attributes.employee_id,<!--- çalışan id --->
        	term : attributes.sal_year,<!--- yıl --->
        	calc_days : 0,<!---tutar günü 0 : tümü, 1: gün,2 : fiili gün --->
        	is_kidem : 0,<!--- kıdeme dahil 1:kıdeme ahil,0 kıdeme dahil değil ??? sorulacak--->
        	in_out_id : get_in_out_id.in_out_id,<!--- Giriş çıkış id --->
        	from_salary : 0, <!--- 0 :net,1 : brüt --->
       		is_ehesap : 0,<!--- üst düzey ik yetkisi 1 : dahi, 0 :dahil değil--->
        	is_ayni_yardim : 0,<!--- ayni yardım --->
        	tax_exemption_value : tax_exemption_value,<!--- Gelir Vergisi Muafiyet Tutarı (ödeneğin vergi matrahı = (günlük harcama * gün) - (istisna tutarı * gün)) --->
        	tax_exemption_rate : attributes.amount,<!--- Gelir Vergisi Muafiyet Oranı--->
        	money : get_expense_rules.MONEY_TYPE,<!--- Para birimi--->
        	is_income : 0,<!--- kazançlara dahil--->
        	is_not_execution : 1,<!--- İcraya Dahil Değil --->
        	comment_type : 1,<!--- 1: ek ödenek, 2: kazanc --->
			expense_puantaj_id : MAX_ID.IDENTITYCOL
			) />
</cfif>
<script type="text/javascript">
	<cfif isdefined("attributes.expense_puantaj_id") and len(attributes.expense_puantaj_id)>
		window.location.href='<cfoutput>#request.self#?fuseaction=ehesap.list_expense_puantaj&event=upd&expense_puantaj_id=#attributes.expense_puantaj_id#</cfoutput>';
	<cfelse>
		window.location.href='<cfoutput>#request.self#?fuseaction=ehesap.list_expense_puantaj&event=upd&expense_puantaj_id=#MAX_ID.IDENTITYCOL#</cfoutput>';
	</cfif>
</script>