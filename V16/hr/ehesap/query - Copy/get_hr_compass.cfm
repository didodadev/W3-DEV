<cftry>
<!--- İşten çıkışlar xml Döviz Karşılıklarından Hesaplansın 04032021ERU---->
<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
<cfif not isdefined("attributes.statue_type_individual")  or  attributes.statue_type_individual eq "undefined">
	<cfset attributes.statue_type_individual = 0>
</cfif>
<cfset get_salary_change_cmp = get_fuseaction_property.get_fuseaction_property(
	company_id : session.ep.company_id,
	fuseaction_name : 'ehesap.popup_form_fire2',
	property_name : 'x_is_employees_salary_change'
	)
	>
<cfif get_salary_change_cmp.recordcount eq 0>
	<cfset x_is_employees_salary_change = 0>
<cfelse>
	<cfset x_is_employees_salary_change = get_salary_change_cmp.PROPERTY_VALUE>
</cfif>

<cfscript>
	if(isdefined("from_fire_action") and from_fire_action eq 1)
		from_fire_action  = 1;
	else
		from_fire_action  = 0;
	if(isdefined("last_month_1_general") and len(last_month_1_general) and isdefined("last_month_30_general") and len(last_month_30_general) )
	{
		parameter_last_month_1 = last_month_1_general;
		parameter_last_month_30 = last_month_30_general;

	}
	else
	{
		if(isdefined("get_program_parameters.FIRST_DAY_MONTH") and len(get_program_parameters.FIRST_DAY_MONTH))
		{
			parameter_last_month_1 = CreateDateTime(attributes.sal_year, attributes.sal_mon-1,get_program_parameters.FIRST_DAY_MONTH,0,0,0);
			
		}
		else
			parameter_last_month_1 = CreateDateTime(attributes.sal_year,attributes.sal_mon,1,0,0,0);

		if((len(get_program_parameters.LAST_DAY_MONTH) and get_program_parameters.LAST_DAY_MONTH eq 0) or not (isdefined("get_program_parameters.LAST_DAY_MONTH") and len(get_program_parameters.LAST_DAY_MONTH)))
		{
			parameter_last_month_30 = CreateDateTime(attributes.sal_year,attributes.sal_mon,daysinmonth(createdate(attributes.sal_year,attributes.sal_mon,1)),0,0,0);
		} 	
		/* else if((isdefined("month_loop") and month_loop eq 2))
		{
			parameter_last_month_30 = CreateDateTime(attributes.sal_year,month(parameter_last_month_1),daysinmonth(parameter_last_month_1),0,0,0);
		} */
		else{
			parameter_last_month_30 = CreateDateTime(attributes.sal_year,attributes.sal_mon,get_program_parameters.LAST_DAY_MONTH,0,0,0);
			//parameter_last_month_30 = dateadd("m",1,parameter_last_month_30);
		}
	}
	//Aynı ayda 1 den fazla maaş varsa
	if(not isdefined("for_ssk_day"))
		for_ssk_day = 0;
		response = '';
	//THIS_TAX_ACCOUNT_STYLE_ = 0;
	ext_salary_gelir_vergisi = 0;
	ext_salary_damga_vergisi = 0;
	matrah_fark_ozel_kesinti_2 = 0;
	net_fark_ozel_kesinti_2 = 0;
	ssk_matrah_devirden_gelen_net = 0;
	ssk_matrah_devirden_gelen_ssk = 0;
	arge_gunu = 0;
	arge_gunu_tax = 0;
	absent_days = 0;
	first_salary_temp = 0;
	gelir_vergisi = 0;
	damga_vergisi = 0;
	is_devir_matrah_off = 0;
	offdays_count = 0; //genel tatiller
	offdays_sunday_count = 0; //pazara gelen genel tatiller
	ssdf_isci_hissesi = 0;
	SSDF_ISVEREN_HISSESI = 0;
	attributes.ihbar_amount_net = 0;
	devir_matrah_eklentisi = 0;
	devir_matrah_eklentisi_tip = 0;
	onceki_ssk_tax_net_odenek = 0;
	ozel_kesinti_gelir_dahil_olmayan_tutar = 0;
	ozel_kesinti_damga_dahil_olmayan_tutar = 0;
	total_pay_unstamped = 0; //Ödenek tanımlarında damga vergisi muafsa
	damga_dahil_olmayan = 0;
	vergi_istisna_damga_vergisi = 0;
	past_agi_day_payroll = 0;//geçmiş agi tutarı
	base_control_val = 0;
	net_payment_temp = 0;
	toplam_calisma_gunu = 0;
	arada_kalan = 0;
	arada_kalan_sonraki = 0;
	toplam_matrah = 0;

	EXT_TOTAL_HOURS_5 = 0;
	EXT_TOTAL_HOURS_8 = 0;
	EXT_TOTAL_HOURS_9 = 0;
	EXT_TOTAL_HOURS_10 = 0;
	EXT_TOTAL_HOURS_11 = 0;
	EXT_TOTAL_HOURS_12 = 0;	
	work_day_hour = 0;
	sunday_count_hour = 0;
	offdays_count_hour = 0;
	offdays_sunday_count_hour = 0;
	paid_izinli_sunday_count_hour = 0;
	izinli_sunday_count_hour = 0;
	ext_salary_net = 0;
	report_day = 0;
	unpaid_offtime = 0;
	icra_rakam = StructNew();
	
	/*yeni eklenen alanlar duzenleme SG 20130227 */
	yillik_izin_net = 0;
	yillik_izin_gelir_vergisi = 0;
	yillik_izin_damga_vergisi = 0;
	yillik_izin_isveren_toplam = 0;
	yillik_izin_isci_toplam = 0;
	yillik_izin_isveren_issizlik_toplam = 0;
	yillik_izin_isci_issizlik_toplam = 0;
	
	kidem_net = 0;
	kidem_damga_vergisi = 0;
	short_working_calc = 0;
	kisa_calisma = 0;
	ihbar_net = 0;
	ihbar_gelir_vergisi = 0;
	ihbar_damga_vergisi = 0;
	
	half_offtime_day_total = 0;
	half_offtime_day_total_net = 0;
	
	is_from_odenek = 0;
	is_total_calc = 0;
	ssk_matraha_dahil_olmayan_net_odenek_tutar = 0;
	
	
	//Genel tatil zamanı izine denk geliyorsa kullanılıyor.
	is_general_offtime = 0;

	/* SG 20130227*/
	
	// işten çıkarmada kullanılıyor
	if (isdefined('attributes.ihbardate') and len(attributes.ihbardate) and (attributes.ihbardate neq "NULL") and (datediff('d',attributes.ihbardate,last_month_30) gt 0))
		last_month_30 = attributes.ihbardate;
	/// işten çıkarmada kullanılıyor 

	//ARGE
	damga_vergisi_indirimi_5746 = 0;
	gelir_vergisi_indirimi_5746 = 0;
	ssk_isveren_hissesi_5746 = 0;
	salary_ssk_isveren_hissesi_5746 = 0;
	gvm_matrah_5746 = 0;
	
	damga_vergisi_matrah_5746 = 0;
	gelir_vergisi_matrah_5746 = 0;
	ssk_matrah_5746 = 0;
	
	//687 nolu tesvik
	ssk_isveren_hissesi_687 = 0;
	ssk_isci_hissesi_687 = 0;
	issizlik_isci_hissesi_687 = 0;
	issizlik_isveren_hissesi_687 = 0;
	gelir_vergisi_indirimi_687 = 0;
	damga_vergisi_indirimi_687 = 0;
	
	rd_dahil_olmayan_extsalary_ssk_isveren_hissesi = 0;
	rd_dahil_olmayan_extsalary_gelir_vergisi = 0;
	rd_dahil_olmayan_extsalary_damga_vergisi = 0;
	
	rd_dahil_extsalary_ssk_isveren_hissesi = 0;
	rd_dahil_extsalary_gelir_vergisi = 0;
	rd_dahil_extsalary_damga_vergisi = 0;
	
	brut_maas = 0;
	monthly_base = 30;//aylık matrah gün sayısı
			
	ssk_carpan_687 = 0;
	// 687 nolu kanun maddesi
	if(attributes.sal_year eq 2017 and (listfindnocase(get_hr_ssk.LAW_NUMBERS,'68750') or listfindnocase(get_hr_ssk.law_numbers,'687100')) and not listfind('2,13,21',get_hr_ssk.SSK_STATUTE)) //2017 yılı icerisinde faydalanabilir
	{
		is_687 = 1;
		if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'68750'))
			ssk_carpan_687 = 11.11;
		else
			ssk_carpan_687 = 22.22;
	}
	else
	{
		is_687 = 0;
	}
	
	// 7103 nolu kanun maddesi 17103 ve 27103 ise giris tarihi 2018-2020 yıllari icerisinde ise faydalanabilir
	law_number_7103 = 0;

	if((year(get_hr_ssk.start_date) gte 2018 and year(get_hr_ssk.start_date) lte 2022) and not listfind('2,13,21',get_hr_ssk.SSK_STATUTE))
	{
		//kacincidan faydalaniyor daha önceki puantajlara bakiliyor
		getPuantajRows7103 = new Query(datasource="#dsn#", sql="SELECT COUNT(EMPLOYEE_PUANTAJ_ID) AS BENEFIT_COUNT FROM EMPLOYEES_PUANTAJ_ROWS WHERE EMPLOYEE_ID = #get_hr_ssk.employee_id# AND IN_OUT_ID = #get_hr_ssk.in_out_id# AND LAW_NUMBER_7103 > 0").execute().getResult();
		
		if(listfindnocase(get_hr_ssk.law_numbers,'17103') and getPuantajRows7103.BENEFIT_COUNT lt get_hr_ssk.benefit_month_7103)
			law_number_7103 = 17103;
		else if(listfindnocase(get_hr_ssk.law_numbers,'27103') and getPuantajRows7103.BENEFIT_COUNT lt get_hr_ssk.benefit_month_7103)
			law_number_7103 = 27103;
		else if(listfindnocase(get_hr_ssk.law_numbers,'37103') and year(get_hr_ssk.start_date) eq 2018 and month(get_hr_ssk.start_date) lt 12)
			law_number_7103 = 37103;
	}
	
	//7103 tesvik
	ssk_isveren_hissesi_7103 = 0;
	ssk_isci_hissesi_7103 = 0;
	issizlik_isci_hissesi_7103 = 0;
	issizlik_isveren_hissesi_7103 = 0;
	gelir_vergisi_indirimi_7103 = 0;
	damga_vergisi_indirimi_7103 = 0;

	//7252 Kanunu: KÇÖ Kapsamında faydalanabilir. Esma R. Uysal
	if(listfindnocase(get_hr_ssk.law_numbers,'7252'))
	{
		is_7252_control = 1;
		ssk_days_7252 = get_hr_ssk.benefit_day_7252;
	}
	else
	{
		is_7252_control = 0;
		ssk_days_7252 = 0;
	}
	ssk_isveren_hissesi_7252 = 0;
	ssk_isci_hissesi_7252 = 0;
	issizlik_isci_hissesi_7252 = 0;
	issizlik_isveren_hissesi_7252 = 0;

	//7256 İstihdama Dönüş Kanunu Belirtilen 2 tarih arasında yararlanabilir Esma R. Uysal 
	if((listfindnocase(get_hr_ssk.LAW_NUMBERS,'17256') or listfindnocase(get_hr_ssk.law_numbers,'27256')) and get_hr_ssk.STARTDATE_7256 lte parameter_last_month_30 and get_hr_ssk.FINISHDATE_7256 gte parameter_last_month_1)
		is_7256_control = 1;
	else
		is_7256_control = 0;

	ssk_isveren_hissesi_7256 = 0;
	ssk_isci_hissesi_7256 = 0;
	issizlik_isci_hissesi_7256 = 0;
	issizlik_isveren_hissesi_7256 = 0;
	base_amount_7256 = 0;
	base_amount_7256_temp = 0;
	is_7256_plus = 0;
	total_not_execution = 0;//toplam icraya dahil olmayan ödenek netleri
	net_total_brut = 0;

	defection_date_control = 0;//engellilik tarih kontrolü
	retired_academic = 0;//emekli akademik
	all_basic_wage = 0;

	//2022 uygulaması değişkenleri
	daily_minimum_wage = 0;	//günlük asgari ücret
	dmw_employee_contribution = 0;//Asgari sgk işçi primi
	dmw_unemployment_workers_premium =  0;//Asgari sgk işsizlik işçi primi
	daily_minimum_wage_base = 0;//Asgari ücretin matrahı
	is_net_payment = 0;//net odenekten geliyorsa
	total_used_incoming_tax = 0; //yeni ücret uygulamasında kullanılan gelir vergisi matrahı
	total_used_stamp_tax = 0;//yeni ücret uygulamasında kullanılan damga vergisi matrahı
	temp_stamp_tax_base = 0;//geçiçi tutulan damga vergisi matrahı
	temp_stamp_tax = 0;//asgari ücret damga vergisi
	temp_gelir_vergisi_matrah = 0;//geçici olarak gelir vergisi matrah
	temp_daily_minimum_wage_stamp_tax = 0;//asgari damga vergisi
	temp_daily_minimum_wage = 0;//asgari ücret
	from_net = 0;//netten geliyorsa
	temp_first_min_wage = 0; //ilk hesaplanan asgari gv
	ssk_odenek_dahil_brut = 0;
	half_time_hour_day = 0;
	hourly_salary_brut = 0;
	first_exemption = 0;
	used_daily_disabled = 0;
	old_wage = 0; //2022 öncesine göre hesap(vergi indirimsiz)


	health_insurance_premium_worker_ratio = 0; //Hastalık Sigorta Primi İşçi Payı
	death_insurance_premium_worker_ratio = 0;//Malülük, Yaşlılık, Ölüm Sigorta Primi İşçi Payı

	health_insurance_premium_employer_ratio = 0; //Hastalık Sigorta Primi İşveren Payı
	death_insurance_premium_employer_ratio = 0;//Malülük, Yaşlılık, Ölüm Sigorta Primi İşveren Payı
	short_term_premium_ratio = 0;//Kısa Vadeli Sigorta Kolları Prim Oranı

	health_insurance_premium_worker = 0; //Hastalık Sigorta Primi İşçi
	health_insurance_premium_employer = 0; //Hastalık Sigorta Primi İşveren
	death_insurance_premium_worker = 0;//Malülük, Yaşlılık, Ölüm Sigorta Primi İşçi
	death_insurance_premium_employer = 0;//Malülük, Yaşlılık, Ölüm Sigorta Primi İşveren
	short_term_premium_employer = 0;//Kısa Vadeli Sigorta Kolları Prim 

	half_time_hour = 0;
	half_time_hour_day = 0;

	//İzin ve mazeret kategorileri üzerinden izin vergiye dahil seçiliyse
	included_in_tax_hour_paid = 0;
	included_in_tax_day_paid = 0;
	included_in_tax_paid_amount = 0;
	included_in_tax_paid_amount_stamp_tax = 0;
	included_in_tax_paid_amount_income_tax = 0;
	included_in_tax_paid_amount_brut = 0;
	included_in_tax_paid_amount_employee = 0;
	included_in_tax_paid_amount_unemployment = 0;
	included_in_tax_paid_amount_brut_base = 0;
	is_included_in_tax = 0;
	total_pay_ssk_net_damgasiz = 0;
	total_pay_ssk_damgasiz = 0;
	total_pay_ssk_untax_diff = 0;
	is_yearly_offtime = 0;
	is_tax_free_from_payment = 0;
	net_odenek_ssk_isci_hissesi = 0;
	net_odenek_ssk_issizlik_hissesi = 0;
	net_odenek_ssdf_isci_hissesi = 0;
	net_odenek_ssdf_isveren_hissesi = 0;
	is_brut_payment = 0;
	is_included_in_tax_hour_paid = 0;
	is_payment_exemption = 0;//ödeneklerdeki muafiyet
	unincluded_in_tax_day_paid = 0;

	akdi_day = 0;

	//Brüt kesinti
	ozel_kesinti_2_brut = 0;
	temp_ozel_kesinti_2 = 0;
	count_2022 = 0;
	is_salary = 0;//net ücretli çalışanın ilk brüt hesabını ayırt etmek için


	is_not_stamp = 0;//damga hariç ödeneğin brütleştirilmesinde kullanılıyor.
	total_pay_ssk_tax_net_notstamp_base = 0;//damga hariç ödeneğin matrahı
	total_pay_ssk_tax_notstamp_base = 0;

	seniority_salary = 0; //Kıdem hesabında kullanılıyor
	ssk_matrah_kullanilan_ = 0;

</cfscript>
<!--- şirket ssk çalışma saat bilgileri alınır --->
<!--- <cfset attributes.our_company_id = get_hr_ssk.comp_id> --->
<cfinclude template="get_hours.cfm">
<cfif len(get_hours.WEEKLY_OFFDAY)>
	<cfset this_weekly_offday_ = get_hours.WEEKLY_OFFDAY>
<cfelse>
	<cfset this_weekly_offday_ = 1>
</cfif>
<cfif get_hours.saturday_off eq 1>
	<cfset this_saturday_work_hour_ = 0>
<cfelse>
	<cfset this_saturday_work_hour_ = 1>
</cfif>
<cfif not get_hours.recordcount>
	<cfif not isdefined("attributes.from_employee_payroll") and isdefined('this.returnResult')>
		<cfset a= getLang('','isimli çalışan için','64483')>
		<cfset b= getLang('','Şirket SSK Çalışma Saatleri Eksik','64487')>
		<cfset response = "#get_hr_ssk.employee_name# #get_hr_ssk.employee_surname# #a# #b# !">
		<cfreturn response>
	<cfelse>
		<cfoutput>
			<script type="text/javascript">
				alert("#get_hr_ssk.employee_name# #get_hr_ssk.employee_surname# <cf_get_lang dictionary_id='64483.isimli çalışan için'> <cf_get_lang dictionary_id='64487.Şirket SSK Çalışma Saatleri Eksik'> !");
				<cfif isdefined("attributes.modal_id")>
					closeBoxDraggable('#attributes.modal_id#');
				</cfif>
				<cfif not isdefined("attributes.ajax")>
					history.back();
				</cfif>
			</script>
		</cfoutput>
		<cfabort>
	</cfif> 
</cfif>
<cfif get_active_program_parameter.recordcount gt 1 and isdefined('this.returnResult')>
	<cfif not isdefined("attributes.from_employee_payroll")>
		<cfset a= getLang('','isimli çalışan için','64483')>
		<cfset b= getLang('','tanımlı olan birden fazla akış parametresi bulunmaktadır.Akış parametresi tanımlarını kontrol ediniz','64486')>
		<cfset response = "#get_hr_ssk.employee_name# #get_hr_ssk.employee_surname# #a# #attributes.sal_mon#. #b# !">
		<cfreturn response> 
	<cfelse>
		<cfoutput>
			<script type="text/javascript">
				alert("#get_hr_ssk.employee_name# #get_hr_ssk.employee_surname# <cf_get_lang dictionary_id='64483.isimli çalışan için'> <cf_get_lang dictionary_id='64486.tanımlı olan birden fazla akış parametresi bulunmaktadır.Akış parametresi tanımlarını kontrol ediniz'>!");
				<cfif isdefined("attributes.modal_id")>
					closeBoxDraggable('#attributes.modal_id#');
				</cfif>
				<cfif not isdefined("attributes.ajax")>
					history.back();
				</cfif>
			</script>
		</cfoutput>
		<cfabort>
	</cfif>
</cfif>
<cfif duty_type eq 6 and not len(KISMI_ISTIHDAM_GUN) and not len(KISMI_ISTIHDAM_SAAT)><!--- kısmi istihdamlı çalışanda gün bilgisi yok ise--->
	<cfif not isdefined("attributes.from_employee_payroll") and isdefined('this.returnResult')>
		<cfset a= getLang('','isimli çalışan için','64483')>
		<cfset b= getLang('','Kısmi İstihdam gün/saat bilgisi girilmelidir','64485')>
		<cfset response = "#get_hr_ssk.employee_name# #get_hr_ssk.employee_surname# #a# #b#!">
		<cfreturn response> 
	<cfelse>
		<cfoutput>
			<script type="text/javascript">
				alert("#get_hr_ssk.employee_name# #get_hr_ssk.employee_surname# <cf_get_lang dictionary_id='64483.isimli çalışan için'> <cf_get_lang dictionary_id='64485.Kısmi İstihdam gün/saat bilgisi girilmelidir'>!");
				<cfif isdefined("attributes.modal_id")>
					closeBoxDraggable('#attributes.modal_id#');
				</cfif>
				<cfif not isdefined("attributes.ajax")>
					history.back();
				</cfif>
			</script>
		</cfoutput>
		<cfabort>
	</cfif>
</cfif>
<cfquery name="get_factor_definition" datasource="#dsn#" maxrows="1">
	SELECT SALARY_FACTOR,BASE_SALARY_FACTOR,BENEFIT_FACTOR FROM SALARY_FACTOR_DEFINITION WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#parameter_last_month_1#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#parameter_last_month_30#"> 
</cfquery>
<cfset salary_extra_value = 0>
<cfif get_hr_ssk.USE_SSK eq 2 and attributes.ssk_statue eq 2 and (attributes.statue_type eq 1 or attributes.statue_type eq 11)  and get_hr_ssk.administrative_academic neq 2><!--- Eğer çalışanın görev tipi derece kademe ise ve emekli akademik değilse maaş hesabı yapılacak --->
	<cfset salary_extra_value = officer_total_salary>
<cfelseif isdefined("administrative_academic_diff") and len(administrative_academic_diff) and administrative_academic_diff gt 0 and attributes.statue_type eq 5><!--- Emekli akademikse ve fark bordrosu varsa --->
	<cfset salary_extra_value = administrative_academic_diff>
</cfif>
<cfif get_hr_ssk.USE_SSK eq 2 and attributes.ssk_statue eq 2 and (attributes.statue_type eq 3 or attributes.statue_type eq 4 or attributes.statue_type eq 9)  and get_hr_ssk.administrative_academic neq 2><!--- Memur bordrosu ise ve ek ders bordrosu yapılıyor ise maaş 0 üzerinden alınıp ek dersler alnır.--->
	<cfset salary_extra_value = 0>
</cfif>
<cfif get_hr_ssk.USE_SSK eq 2 and attributes.ssk_statue eq 2 and attributes.statue_type eq 6 and isdefined("jury_membership_value")><!--- Memur bordrosu ise ve jüri üyeliği varsa ve bordro tipi jüri üyeliğiyse .--->
	<cfset salary_extra_value = jury_membership_value>
</cfif>

<cfif get_hr_ssk.USE_SSK eq 2 and attributes.ssk_statue eq 2 and attributes.statue_type eq 7 and isdefined("land_compensation_amount")><!--- Memur bordrosu ise ve arazi tazminatı varsa ve bordro tipi arazi tazminatıysa .--->
	<cfset salary_extra_value = land_compensation_amount>
</cfif>
<cfif get_hr_ssk.USE_SSK eq 2 and attributes.ssk_statue eq 2 and attributes.statue_type eq 8><!--- Memur bordrosu ise ve sanatçı bordrosuysa .--->
	<cfset salary_extra_value = artist_salary>
</cfif>
<cfif get_hr_ssk.USE_SSK eq 2 and attributes.ssk_statue eq 2 and attributes.statue_type eq 10  and isdefined("attributes.statue_type_individual") and len(attributes.statue_type_individual)><!--- Münferit ödeme --->
	<cfset salary_extra_value = 0>
</cfif>

<cfif salary_extra_value gt 0 or (get_hr_ssk.USE_SSK eq 2 and attributes.ssk_statue eq 2 and (attributes.statue_type eq 3 or attributes.statue_type eq 4 or attributes.statue_type eq 8 or attributes.statue_type eq 9 or (attributes.statue_type eq 10  and isdefined("attributes.statue_type_individual") and len(attributes.statue_type_individual))) and get_hr_ssk.administrative_academic neq 2)>
	<cfquery name="get_hr_salary" datasource="#dsn#" maxrows="2">
			SELECT
				#salary_extra_value# AS SALARY,
				'#session.ep.money#' MONEY,
				EMPLOYEES_IN_OUT.IN_OUT_ID,
				EMPLOYEES_IN_OUT.SALARY_TYPE,
				EMPLOYEES_IN_OUT.IS_DISCOUNT_OFF,
				EMPLOYEES_IN_OUT.CUMULATIVE_TAX_TOTAL,
				EMPLOYEES_IN_OUT.GROSS_NET,
				EMPLOYEES_IN_OUT.SSK_STATUTE,
				EMPLOYEES_IN_OUT.SABIT_PRIM,
				EMPLOYEES_IN_OUT.IS_KISMI_ISTIHDAM,
				EMPLOYEES_IN_OUT.USE_PDKS,
				EMPLOYEES_IN_OUT.START_DATE,
				EMPLOYEES_IN_OUT.FINISH_DATE
			FROM
				EMPLOYEES_IN_OUT
			WHERE
				EMPLOYEES_IN_OUT.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
				AND USE_SSK = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.ssk_statue#">
	</cfquery>
	<cfif (get_hr_ssk.use_ssk eq 2 and get_hr_ssk.administrative_academic eq 2)>
		<cfset retired_academic = get_hr_salary.SALARY>
	</cfif>
<cfelse>
	<cfquery name="get_hr_salary" datasource="#dsn#" maxrows="2">
		SELECT
			<cfif isdefined("x_is_employees_salary_change") and len(x_is_employees_salary_change) and x_is_employees_salary_change eq 1>
				(DOVIZ_NORMAL_CARPAN * MAAS_ILK) AS SALARY,
			<cfelse>
				CASE 
					WHEN FINISH_DATE IS NULL THEN  (DOVIZ_NORMAL_CARPAN * MAAS_ILK) 
					WHEN (FINISH_DATE IS NOT NULL AND DOVIZ_HISTORY_CARPAN > 0) THEN (DOVIZ_HISTORY_CARPAN * MAAS_ILK)
					ELSE (DOVIZ_NORMAL_CARPAN * MAAS_ILK) END AS SALARY,
			</cfif>
			*
		FROM
			(
			SELECT
				ISNULL((SELECT WORTH FROM EMPLOYEES_SALARY_CHANGE ESCH WHERE ESCH.SALARY_YEAR = EMPLOYEES_SALARY.PERIOD_YEAR AND ESCH.SALARY_MONTH = #attributes.SAL_MON# AND 	ESCH.MONEY = EMPLOYEES_SALARY.MONEY AND	ESCH.COMPANY_ID = #SESSION.EP.COMPANY_ID#),1) AS DOVIZ_NORMAL_CARPAN,
				ISNULL(
					(
						SELECT 
							TOP 1 RATE2 
						FROM 
							MONEY_HISTORY MH
						WHERE 
							MH.MONEY = EMPLOYEES_SALARY.MONEY
							AND MH.PERIOD_ID = (
												SELECT 
													PERIOD_ID 
												FROM 
													BRANCH B 
													INNER JOIN OUR_COMPANY OC ON B.COMPANY_ID = OC.COMP_ID 
													INNER JOIN SETUP_PERIOD SP ON SP.OUR_COMPANY_ID = OC.COMP_ID 
												WHERE 
													SP.PERIOD_YEAR = #attributes.sal_year# 
													AND EMPLOYEES_IN_OUT.BRANCH_ID = B.BRANCH_ID) 
													AND RECORD_DATE >= #dateadd('d',-1,last_month_30)# 
													AND RECORD_DATE < #last_month_30#),0
												) AS DOVIZ_HISTORY_CARPAN,
				EMPLOYEES_SALARY.M#attributes.SAL_MON+0# AS MAAS_ILK,
				EMPLOYEES_SALARY.MONEY,
				EMPLOYEES_IN_OUT.IN_OUT_ID,
				EMPLOYEES_IN_OUT.SALARY_TYPE,
				EMPLOYEES_IN_OUT.IS_DISCOUNT_OFF,
				EMPLOYEES_IN_OUT.CUMULATIVE_TAX_TOTAL,
				EMPLOYEES_IN_OUT.GROSS_NET,
				EMPLOYEES_IN_OUT.SSK_STATUTE,
				EMPLOYEES_IN_OUT.SABIT_PRIM,
				EMPLOYEES_IN_OUT.IS_KISMI_ISTIHDAM,
				EMPLOYEES_IN_OUT.USE_PDKS,
				EMPLOYEES_IN_OUT.START_DATE,
				EMPLOYEES_IN_OUT.FINISH_DATE
			FROM
				#maas_puantaj_table# AS EMPLOYEES_SALARY, 
				EMPLOYEES_IN_OUT
			WHERE
				EMPLOYEES_SALARY.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
				USE_SSK = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.ssk_statue#"> AND
				EMPLOYEES_IN_OUT.IN_OUT_ID = EMPLOYEES_SALARY.IN_OUT_ID AND
				EMPLOYEES_SALARY.PERIOD_YEAR = #attributes.sal_year# AND
				(
				(EMPLOYEES_SALARY.M#attributes.SAL_MON+0# > 0 AND EMPLOYEES_IN_OUT.USE_SSK = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.ssk_statue#">)
				OR
				EMPLOYEES_IN_OUT.USE_SSK = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.ssk_statue#">
				)
			) AS TBL1
			
	</cfquery>
	<cfif (get_hr_ssk.use_ssk eq 2 and get_hr_ssk.administrative_academic eq 2)>
		<cfset retired_academic = get_hr_salary.SALARY>
	</cfif>
</cfif>

<!---- 2022 itibarşyle asgari geçim indirimi kaldırıldı. --->
<!----
<cfif (attributes.sal_year gte 2022 and attributes.ssk_statue neq 2) or (attributes.ssk_statue eq 2 and (attributes.statue_type eq 6 or attributes.statue_type eq 7))>
	<cfquery name="get_hr_ssk"  dbtype="query">
		SELECT 1 IS_DISCOUNT_OFF,* from get_hr_ssk 
	</cfquery>
</cfif>
---->
<cfif isdefined("attributes.is_virtual_puantaj") and attributes.is_virtual_puantaj eq 1 and not get_hr_salary.RECORDCOUNT>
	<cfquery name="get_hr_salary" datasource="#dsn#" maxrows="2">
		SELECT
			<cfif isdefined("x_is_employees_salary_change") and len(x_is_employees_salary_change) and x_is_employees_salary_change eq 1>
				(DOVIZ_NORMAL_CARPAN * MAAS_ILK) AS SALARY,
			<cfelse>
				CASE 
					WHEN FINISH_DATE IS NULL THEN  (DOVIZ_NORMAL_CARPAN * MAAS_ILK) 
					WHEN (FINISH_DATE IS NOT NULL AND DOVIZ_HISTORY_CARPAN > 0) THEN (DOVIZ_HISTORY_CARPAN * MAAS_ILK)
					ELSE (DOVIZ_NORMAL_CARPAN * MAAS_ILK) END AS SALARY,
			</cfif>
			*
		FROM
			(
			SELECT
				ISNULL((SELECT WORTH FROM EMPLOYEES_SALARY_CHANGE ESCH WHERE ESCH.SALARY_YEAR = EMPLOYEES_SALARY.PERIOD_YEAR AND ESCH.SALARY_MONTH = #attributes.SAL_MON# AND 	ESCH.MONEY = EMPLOYEES_SALARY.MONEY AND	ESCH.COMPANY_ID = #SESSION.EP.COMPANY_ID#),1) AS DOVIZ_NORMAL_CARPAN,
				ISNULL(
					(
						SELECT 
							TOP 1 RATE2 
						FROM 
							MONEY_HISTORY MH 
						WHERE 
							MH.MONEY = EMPLOYEES_SALARY.MONEY 
							AND MH.PERIOD_ID = (
													SELECT
														PERIOD_ID 
													FROM 
														BRANCH B 
														INNER JOIN OUR_COMPANY OC ON B.COMPANY_ID = OC.COMP_ID 
														INNER JOIN SETUP_PERIOD SP ON SP.OUR_COMPANY_ID = OC.COMP_ID 
													WHERE 
														SP.PERIOD_YEAR = #attributes.sal_year#
														AND EMPLOYEES_IN_OUT.BRANCH_ID = B.BRANCH_ID) 
														AND RECORD_DATE >= #dateadd('d',-1,last_month_30)# 
														AND RECORD_DATE < #last_month_30#),0
												) 
						AS DOVIZ_HISTORY_CARPAN,
				EMPLOYEES_SALARY.M#attributes.SAL_MON+0# AS MAAS_ILK,
				EMPLOYEES_SALARY.MONEY,
				EMPLOYEES_IN_OUT.IN_OUT_ID,
				EMPLOYEES_IN_OUT.SALARY_TYPE,
				EMPLOYEES_IN_OUT.IS_DISCOUNT_OFF,
				EMPLOYEES_IN_OUT.CUMULATIVE_TAX_TOTAL,
				EMPLOYEES_IN_OUT.GROSS_NET,
				EMPLOYEES_IN_OUT.SSK_STATUTE,
				EMPLOYEES_IN_OUT.SABIT_PRIM,
				EMPLOYEES_IN_OUT.IS_KISMI_ISTIHDAM,
				EMPLOYEES_IN_OUT.USE_PDKS,
				EMPLOYEES_IN_OUT.START_DATE,
				EMPLOYEES_IN_OUT.FINISH_DATE
			FROM
				EMPLOYEES_SALARY, 
				EMPLOYEES_IN_OUT
			WHERE
				EMPLOYEES_SALARY.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
				EMPLOYEES_IN_OUT.IN_OUT_ID = EMPLOYEES_SALARY.IN_OUT_ID AND
				EMPLOYEES_SALARY.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
				(
				(EMPLOYEES_SALARY.M#attributes.SAL_MON+0# > 0 AND EMPLOYEES_IN_OUT.USE_SSK = 1)
				OR
				EMPLOYEES_IN_OUT.USE_SSK =<cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.ssk_statue#">
				)
			) AS TBL1
	</cfquery>
</cfif>

<cfif (not get_hr_salary.RECORDCOUNT and get_hr_ssk.use_ssk neq 2) or (get_hr_salary.salary eq 0 and get_hr_ssk.administrative_academic eq 2) >
	<cfif not isdefined("attributes.from_employee_payroll") and isdefined('this.returnResult')>
		<cfset a= getLang('','isimli çalışan için','64483')>
		<cfset b= getLang('','ayın Maaş, SSK, Para Kuru bilgilerinden bir veya birkaçı Eksik','64484')>
		<cfset response = "#get_hr_ssk.employee_name# #get_hr_ssk.employee_surname# #a# #attributes.sal_mon#. #b# !">
		<cfreturn response> 
	<cfelse>
		<cfoutput>
			<script type="text/javascript">
				alert("#get_hr_ssk.employee_name# #get_hr_ssk.employee_surname# <cf_get_lang dictionary_id='64483.isimli çalışan için'> #attributes.sal_mon#. <cf_get_lang dictionary_id='64484.ayın Maaş, SSK, Para Kuru bilgilerinden bir veya birkaçı Eksik'> <cfif not session.ep.ehesap>\nve/veya Yetkiniz Yok</cfif> !");
				<cfif isdefined("attributes.modal_id")>
					closeBoxDraggable('#attributes.modal_id#');
				</cfif>
				<cfif not isdefined("attributes.ajax")>
					history.back();
				</cfif>
			</script>
		</cfoutput>
		<cfabort>
	</cfif>
	<cfif not isdefined("attributes.is_pass_puantaj")><cfabort></cfif>
</cfif>

<cfif not isdefined("get_active_tax_slice.recordcount")>
	<cfquery name="get_active_tax_slice" datasource="#dsn#">
		SELECT 
			MIN_PAYMENT_1, MIN_PAYMENT_2, MIN_PAYMENT_3, MIN_PAYMENT_4, MIN_PAYMENT_5, MIN_PAYMENT_6,
			MAX_PAYMENT_1, MAX_PAYMENT_2, MAX_PAYMENT_3, MAX_PAYMENT_4, MAX_PAYMENT_5, MAX_PAYMENT_6,
			RATIO_1, RATIO_2, RATIO_3, RATIO_4, RATIO_5, RATIO_6, SAKAT1, SAKAT2, SAKAT3, SAKAT_STYLE
		FROM SETUP_TAX_SLICES 
		WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d', -1, last_month_30)#">
	</cfquery>
	
	<cfif not get_active_tax_slice.recordcount>
		<cfif not isdefined("attributes.from_employee_payroll") and isdefined('this.returnResult')>
			<cfset response = '#dateformat(last_month_1,dateformat_style)# - #dateformat(last_month_30,dateformat_style)# aralığında geçerli Vergi Dilimleri Tanımlı Değil !'>
			<cfreturn response> 
		<cfelse>
			<cfoutput>
				<script type="text/javascript">
					alert("#dateformat(last_month_1,dateformat_style)# - #dateformat(last_month_30,dateformat_style)# aralığında geçerli Vergi Dilimleri Tanımlı Değil !");
					<cfif isdefined("attributes.modal_id")>
						closeBoxDraggable('#attributes.modal_id#');
					</cfif>
					<cfif not isdefined("attributes.is_pass_puantaj")>history.back();</cfif>
				</script>
			</cfoutput> 
		</cfif>
		<cfif not isdefined("attributes.is_pass_puantaj")><cfabort></cfif>
	</cfif>
</cfif>

<cfif not isdefined("get_insurance.recordcount")>
	<cfquery name="get_insurance" datasource="#dsn#">
		SELECT * FROM INSURANCE_PAYMENT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#">
	</cfquery>
	
	<cfif not get_insurance.recordcount>
		<cfif not isdefined("attributes.from_employee_payroll") and isdefined('this.returnResult')>
			<cfset response ="#dateformat(last_month_1,dateformat_style)# - #dateformat(last_month_30,dateformat_style)# aralığında geçerli SSK Taban ve SSK Tavan Ücretleri Tanımlı Değil !">
			<cfreturn response> 
		<cfelse>
			<cfoutput>
				<script type="text/javascript">
					alert('#dateformat(last_month_1,dateformat_style)# - #dateformat(last_month_30,dateformat_style)# aralığında geçerli SSK Taban ve SSK Tavan Ücretleri Tanımlı Değil !');
					<cfif isdefined("attributes.modal_id")>
						closeBoxDraggable('#attributes.modal_id#');
					</cfif>
					<cfif not isdefined("attributes.is_pass_puantaj")>history.back();</cfif>
				</script>
			</cfoutput>
		</cfif>
		<cfif not isdefined("attributes.is_pass_puantaj")><cfabort></cfif>
	</cfif>
</cfif>

<cfif not isdefined("get_insurance_ratio.recordcount")>
	<cfquery name="get_insurance_ratio" datasource="#dsn#">
		SELECT
			MOM_INSURANCE_PREMIUM_WORKER, MOM_INSURANCE_PREMIUM_BOSS, 
			PAT_INS_PREMIUM_WORKER, PAT_INS_PREMIUM_BOSS, 
			PAT_INS_PREMIUM_WORKER_2, PAT_INS_PREMIUM_BOSS_2, 
			DEATH_INSURANCE_PREMIUM_WORKER, DEATH_INSURANCE_PREMIUM_BOSS, 
			DEATH_INSURANCE_WORKER, DEATH_INSURANCE_BOSS, 
			SOC_SEC_INSURANCE_WORKER, SOC_SEC_INSURANCE_BOSS,
			<!---Muzaffer Bas Maden işletmesi Vergi Dilimi İçin yapıldı--->
			DEATH_INSURANCE_PREMIUM_WORKER_MADEN,
			DEATH_INSURANCE_PREMIUM_BOSS_MADEN
			<!---Muzaffer Bit Maden işletmesi Vergi Dilimi İçin yapıldı--->	 
		FROM INSURANCE_RATIO
		WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#">
	</cfquery>
	<cfif not get_insurance_ratio.recordcount>
		<cfif not isdefined("attributes.from_employee_payroll") and isdefined('this.returnResult')>
			<cfset response ='#dateformat(last_month_1,dateformat_style)# - #dateformat(last_month_30,dateformat_style)# aralığında geçerli SSK Çarpanları Tanımlı Değil !'>
			<cfreturn response>
		<cfelse>
			<cfoutput>
				<script type="text/javascript">
					alert('#dateformat(last_month_1,dateformat_style)# - #dateformat(last_month_30,dateformat_style)# aralığında geçerli SSK Çarpanları Tanımlı Değil !');
					<cfif not isdefined("attributes.is_pass_puantaj")>history.back();</cfif>
				</script>
			</cfoutput> 
		</cfif>
		<cfif not isdefined("attributes.is_pass_puantaj")><cfabort></cfif>
	</cfif>
</cfif>

<cfquery name="GET_AVANS_VER" datasource="#dsn#">
	SELECT
		<cfif attributes.puantaj_type neq -1 or get_active_program_parameter.is_add_virtual_all eq 1>
			SUM(AMOUNT) AS AVANS_VERILEN 
		<cfelse>
			0 AS AVANS_VERILEN
		</cfif>
	FROM 
		CORRESPONDENCE_PAYMENT CP
	WHERE 
		CP.TO_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND 
		DUEDATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#"> AND 
		CP.STATUS=1 
		<cfif isdefined("attributes.in_out_id")>AND IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"></cfif>
</cfquery>
<!--- ek ödenek ve kesintiler --->

<!---
<cfif get_factor_definition.recordcount>
				CASE 
				WHEN (FACTOR_TYPE IS NOT NULL AND FACTOR_TYPE = 1) THEN  (#get_factor_definition.SALARY_FACTOR# * AMOUNT_PAY) 
				WHEN (FACTOR_TYPE IS NOT NULL AND FACTOR_TYPE = 2) THEN  (#get_factor_definition.BASE_SALARY_FACTOR# * AMOUNT_PAY) 
				WHEN (FACTOR_TYPE IS NOT NULL AND FACTOR_TYPE = 3) THEN  (#get_factor_definition.BENEFIT_FACTOR# * AMOUNT_PAY) 
				ELSE AMOUNT_PAY END AS ASIL_TUTAR,
			<cfelse>
				AMOUNT_PAY ASIL_TUTAR,	
			</cfif>
--->

<cfquery name="get_pay_salary" datasource="#dsn#">
	SELECT
		<cfif isdefined("x_is_employees_salary_change") and len(x_is_employees_salary_change) and x_is_employees_salary_change eq 1>
			(DOVIZ_NORMAL_CARPAN * ASIL_TUTAR * MULTIPLIER) AS AMOUNT_PAY,
		<cfelse>
			CASE 
				WHEN FINISH_DATE IS NULL THEN (DOVIZ_NORMAL_CARPAN * ASIL_TUTAR * MULTIPLIER) 
				WHEN (FINISH_DATE IS NOT NULL AND DOVIZ_HISTORY_CARPAN > 0) THEN (DOVIZ_HISTORY_CARPAN * ASIL_TUTAR * MULTIPLIER)
				ELSE (DOVIZ_NORMAL_CARPAN * ASIL_TUTAR * MULTIPLIER) END AS AMOUNT_PAY,
		</cfif>
		*
	FROM
		(
		SELECT 
			ISNULL((SELECT WORTH FROM EMPLOYEES_SALARY_CHANGE ESCH WHERE ESCH.SALARY_YEAR = SALARYPARAM_PAY.TERM AND ESCH.SALARY_MONTH = #attributes.SAL_MON# AND ESCH.MONEY = SALARYPARAM_PAY.MONEY AND ESCH.COMPANY_ID = #SESSION.EP.COMPANY_ID#),1) AS DOVIZ_NORMAL_CARPAN,
			ISNULL((SELECT TOP 1 RATE2 FROM MONEY_HISTORY MH WHERE MH.MONEY = SALARYPARAM_PAY.MONEY AND MH.PERIOD_ID = (SELECT PERIOD_ID FROM BRANCH B INNER JOIN OUR_COMPANY OC ON B.COMPANY_ID = OC.COMP_ID INNER JOIN SETUP_PERIOD SP ON SP.OUR_COMPANY_ID = OC.COMP_ID WHERE SP.PERIOD_YEAR = #attributes.sal_year# AND EIO.BRANCH_ID = B.BRANCH_ID) AND RECORD_DATE >= #dateadd('d',-1,last_month_30)# AND RECORD_DATE < #last_month_30#),0) AS DOVIZ_HISTORY_CARPAN,
			SALARYPARAM_PAY.AMOUNT_PAY ASIL_TUTAR,	
			SALARYPARAM_PAY.AMOUNT_PAY AS ILK_TUTAR,
			SALARYPARAM_PAY.COMMENT_PAY,
			SALARYPARAM_PAY.COMMENT_PAY_ID,
			SALARYPARAM_PAY.PERIOD_PAY,
			SALARYPARAM_PAY.METHOD_PAY,
			SALARYPARAM_PAY.SSK,
			SALARYPARAM_PAY.TAX,
			SALARYPARAM_PAY.SHOW,
			SALARYPARAM_PAY.START_SAL_MON,
			SALARYPARAM_PAY.END_SAL_MON,
			SALARYPARAM_PAY.EMPLOYEE_ID,
			SALARYPARAM_PAY.TERM,
			SALARYPARAM_PAY.CALC_DAYS,
			SALARYPARAM_PAY.IS_KIDEM,
			SALARYPARAM_PAY.IN_OUT_ID,
			SALARYPARAM_PAY.FROM_SALARY,
			SALARYPARAM_PAY.IS_EHESAP,
			SALARYPARAM_PAY.IS_DAMGA,
			SALARYPARAM_PAY.IS_ISSIZLIK,
			ISNULL(SALARYPARAM_PAY.IS_INCOME,0) IS_INCOME,
			ISNULL(SALARYPARAM_PAY.IS_NOT_EXECUTION,0) IS_NOT_EXECUTION,
			ISNULL(SALARYPARAM_PAY.FACTOR_TYPE,0) FACTOR_TYPE,
			ISNULL(SALARYPARAM_PAY.COMMENT_TYPE,1) COMMENT_TYPE,
			SALARYPARAM_PAY.SSK_EXEMPTION_TYPE,
			SALARYPARAM_PAY.SSK_EXEMPTION_RATE,
			SALARYPARAM_PAY.TAX_EXEMPTION_RATE,
			SALARYPARAM_PAY.TAX_EXEMPTION_VALUE,
			ISNULL(SALARYPARAM_PAY.IS_RD_DAMGA,0) IS_RD_DAMGA,
			ISNULL(SALARYPARAM_PAY.IS_RD_GELIR,0) IS_RD_GELIR,
			ISNULL(SALARYPARAM_PAY.IS_RD_SSK,0) IS_RD_SSK,
			SALARYPARAM_PAY.CHILD_HELP,
			CASE 
				WHEN SALARYPARAM_PAY.AMOUNT_MULTIPLIER IS NULL THEN 1
				ELSE SALARYPARAM_PAY.AMOUNT_MULTIPLIER END AS MULTIPLIER,
			SALARYPARAM_PAY.IS_AYNI_YARDIM,
			EIO.FINISH_DATE,
			SALARYPARAM_PAY.TOTAL_HOUR,
			SPI.DYNAMIC_RULES_ID,
			EXTRA_PAYMENT_ID
		FROM 
			SALARYPARAM_PAY
			INNER JOIN SETUP_PAYMENT_INTERRUPTION SPI ON SPI.ODKES_ID = SALARYPARAM_PAY.COMMENT_PAY_ID,
			EMPLOYEES_IN_OUT EIO
		WHERE 
			EIO.IN_OUT_ID = SALARYPARAM_PAY.IN_OUT_ID AND 
			SALARYPARAM_PAY.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
			SALARYPARAM_PAY.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
			AND SALARYPARAM_PAY.TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
			AND SALARYPARAM_PAY.START_SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
			AND SALARYPARAM_PAY.END_SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
			<cfif isdefined("attributes.is_virtual_puantaj") and attributes.is_virtual_puantaj eq 1 and get_active_program_parameter.is_add_virtual_all eq 1>
				AND (SALARYPARAM_PAY.SHOW = 0 OR SALARYPARAM_PAY.SHOW IS NULL OR SALARYPARAM_PAY.SHOW = 1)
			<cfelseif isdefined("attributes.is_virtual_puantaj") and attributes.is_virtual_puantaj eq 1>
				AND (SALARYPARAM_PAY.SHOW = 0 OR SALARYPARAM_PAY.SHOW IS NULL)
			<cfelse>
				AND SALARYPARAM_PAY.SHOW = 1
			</cfif>
			<cfif isdefined("attributes.ssk_statue") and len(attributes.ssk_statue)>
				AND SALARYPARAM_PAY.SSK_STATUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ssk_statue#">
				<cfif isdefined("attributes.ssk_statue") and len(attributes.ssk_statue) and attributes.ssk_statue eq 2 and len(attributes.statue_type)>
					AND SALARYPARAM_PAY.STATUE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.statue_type#">
					<cfif isdefined("attributes.statue_type_individual") and attributes.statue_type_individual neq 0>
                        AND SALARYPARAM_PAY.COMMENT_PAY_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.statue_type_individual#">
                    </cfif>
				</cfif>
			</cfif>
		) AS TBL2 ORDER BY FROM_SALARY ASC
		
</cfquery>
<!--- Kural seti artı ek ödenek seçildiyse --->
<cfquery name="get_pay_salary_name"  dbtype="query">
	SELECT COMMENT_PAY,DYNAMIC_RULES_ID,EXTRA_PAYMENT_ID,COMMENT_PAY_ID from get_pay_salary WHERE DYNAMIC_RULES_ID = 1 AND EXTRA_PAYMENT_ID IS NOT NULL
</cfquery>

<cfif get_pay_salary_name.recordcount gt 0>
	<!--- Eğer artı ek ödenek varsa --->
	<cfloop query = "#get_pay_salary_name#">
		<cfquery name="get_pay_salary_uni" datasource="#dsn#">
			SELECT
				<cfif isdefined("x_is_employees_salary_change") and len(x_is_employees_salary_change) and x_is_employees_salary_change eq 1>
					(DOVIZ_NORMAL_CARPAN * ASIL_TUTAR * MULTIPLIER) AS AMOUNT_PAY,
				<cfelse>
					CASE 
						WHEN FINISH_DATE IS NULL THEN (DOVIZ_NORMAL_CARPAN * ASIL_TUTAR * MULTIPLIER) 
						WHEN (FINISH_DATE IS NOT NULL AND DOVIZ_HISTORY_CARPAN > 0) THEN (DOVIZ_HISTORY_CARPAN * ASIL_TUTAR * MULTIPLIER)
						ELSE (DOVIZ_NORMAL_CARPAN * ASIL_TUTAR * MULTIPLIER) END AS AMOUNT_PAY,
				</cfif>
				*
			FROM
				(
				SELECT 
					ISNULL((SELECT WORTH FROM EMPLOYEES_SALARY_CHANGE ESCH WHERE ESCH.SALARY_YEAR = '#attributes.sal_year#' AND ESCH.SALARY_MONTH = #attributes.SAL_MON# AND ESCH.MONEY = SPI.MONEY AND ESCH.COMPANY_ID = #SESSION.EP.COMPANY_ID#),1) AS DOVIZ_NORMAL_CARPAN,
					ISNULL((SELECT TOP 1 RATE2 FROM MONEY_HISTORY MH WHERE MH.MONEY = SPI.MONEY AND MH.PERIOD_ID = (SELECT top 1 PERIOD_ID FROM BRANCH B INNER JOIN OUR_COMPANY OC ON B.COMPANY_ID = OC.COMP_ID INNER JOIN SETUP_PERIOD SP ON SP.OUR_COMPANY_ID = OC.COMP_ID WHERE SP.PERIOD_YEAR = #attributes.sal_year#) AND RECORD_DATE >= #dateadd('d',-1,last_month_30)# AND RECORD_DATE < #last_month_30#),0) AS DOVIZ_HISTORY_CARPAN,
					AMOUNT_PAY ASIL_TUTAR,	
					AMOUNT_PAY AS ILK_TUTAR,
					(SELECT COMMENT_PAY FROM SETUP_PAYMENT_INTERRUPTION WHERE ODKES_ID = #get_pay_salary_name.COMMENT_PAY_ID#) COMMENT_PAY,
					(SELECT ODKES_ID FROM SETUP_PAYMENT_INTERRUPTION WHERE ODKES_ID = #get_pay_salary_name.COMMENT_PAY_ID#) COMMENT_PAY_ID,
					PERIOD_PAY,
					METHOD_PAY,
					SSK,
					TAX,
					SHOW,
					#attributes.sal_mon# START_SAL_MON,
					#attributes.sal_mon# END_SAL_MON,
					#attributes.employee_id# EMPLOYEE_ID,
					#attributes.sal_year# TERM,
					CALC_DAYS,
					IS_KIDEM,
					#attributes.in_out_id# IN_OUT_ID,
					FROM_SALARY,
					IS_EHESAP,
					IS_DAMGA,
					IS_ISSIZLIK,
					ISNULL(IS_INCOME,0) IS_INCOME,
					ISNULL(IS_NOT_EXECUTION,0) IS_NOT_EXECUTION,
					ISNULL(FACTOR_TYPE,0) FACTOR_TYPE,
					ISNULL(COMMENT_TYPE,1) COMMENT_TYPE,
					SSK_EXEMPTION_TYPE,
					SSK_EXEMPTION_RATE,
					TAX_EXEMPTION_RATE,
					TAX_EXEMPTION_VALUE,
					ISNULL(IS_RD_DAMGA,0) IS_RD_DAMGA,
					ISNULL(IS_RD_GELIR,0) IS_RD_GELIR,
					ISNULL(IS_RD_SSK,0) IS_RD_SSK,
					CHILD_HELP,
					CASE 
						WHEN AMOUNT_MULTIPLIER IS NULL THEN 1
						ELSE AMOUNT_MULTIPLIER END AS MULTIPLIER,
					IS_AYNI_YARDIM,
					CAST('#get_hr_salary.FINISH_DATE#' AS datetime) FINISH_DATE,
					NULL TOTAL_HOUR,
					DYNAMIC_RULES_ID,
					EXTRA_PAYMENT_ID
				FROM 
					SETUP_PAYMENT_INTERRUPTION SPI
				WHERE 
					ODKES_ID IN (#get_pay_salary_name.EXTRA_PAYMENT_ID#)
					<cfif isdefined("attributes.is_virtual_puantaj") and attributes.is_virtual_puantaj eq 1 and get_active_program_parameter.is_add_virtual_all eq 1>
						AND (SHOW = 0 OR SHOW IS NULL OR SHOW = 1)
					<cfelseif isdefined("attributes.is_virtual_puantaj") and attributes.is_virtual_puantaj eq 1>
						AND (SHOW = 0 OR SHOW IS NULL)
					<cfelse>
						AND SHOW = 1
					</cfif>
					<cfif isdefined("attributes.ssk_statue") and len(attributes.ssk_statue)>
						AND SSK_STATUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ssk_statue#">
						<cfif isdefined("attributes.ssk_statue") and len(attributes.ssk_statue) and attributes.ssk_statue eq 2 and len(attributes.statue_type)>
							AND STATUE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.statue_type#">
						</cfif>
					</cfif>
				) AS TBL2
		</cfquery>
		<cfquery name="get_pay_salary"  dbtype="query">
			SELECT * FROM get_pay_salary
			UNION ALL
			SELECT * FROM get_pay_salary_uni
		</cfquery>
	</cfloop>
</cfif>

<cfinclude template="write_icra_rows.cfm">
<cfquery name="get_get_salary" datasource="#dsn#">
	SELECT
		<cfif isdefined("x_is_employees_salary_change") and len(x_is_employees_salary_change) and x_is_employees_salary_change eq 1>
			(DOVIZ_NORMAL_CARPAN * ASIL_TUTAR) AS AMOUNT_GET,
		<cfelse>
			CASE 
				WHEN FINISH_DATE IS NULL THEN  (DOVIZ_NORMAL_CARPAN * ASIL_TUTAR) 
				WHEN (FINISH_DATE IS NOT NULL AND DOVIZ_HISTORY_CARPAN > 0) THEN (DOVIZ_HISTORY_CARPAN * ASIL_TUTAR)
				ELSE (DOVIZ_NORMAL_CARPAN * ASIL_TUTAR) END AS AMOUNT_GET,
		</cfif>
		*
	FROM
		(
		SELECT 
			ISNULL((SELECT WORTH FROM EMPLOYEES_SALARY_CHANGE ESCH WHERE ESCH.SALARY_YEAR = SALARYPARAM_GET.TERM AND ESCH.SALARY_MONTH = #attributes.SAL_MON# AND ESCH.MONEY = SALARYPARAM_GET.MONEY AND ESCH.COMPANY_ID = #SESSION.EP.COMPANY_ID#),1) AS DOVIZ_NORMAL_CARPAN,
			ISNULL((SELECT TOP 1 RATE2 FROM MONEY_HISTORY MH WHERE MH.MONEY = SALARYPARAM_GET.MONEY AND MH.PERIOD_ID = (SELECT PERIOD_ID FROM BRANCH B INNER JOIN OUR_COMPANY OC ON B.COMPANY_ID = OC.COMP_ID INNER JOIN SETUP_PERIOD SP ON SP.OUR_COMPANY_ID = OC.COMP_ID WHERE SP.PERIOD_YEAR = #attributes.sal_year# AND EIO.BRANCH_ID = B.BRANCH_ID) AND RECORD_DATE >= #dateadd('d',-1,last_month_30)# AND RECORD_DATE < #last_month_30#),0) AS DOVIZ_HISTORY_CARPAN,
			AMOUNT_GET AS ASIL_TUTAR,
			COMMENT_GET,
			PERIOD_GET,
			METHOD_GET,
			SHOW,
			START_SAL_MON,
			END_SAL_MON,
			SALARYPARAM_GET.EMPLOYEE_ID,
			TERM,
			CALC_DAYS,
			FROM_SALARY,
			SALARYPARAM_GET.IN_OUT_ID,
			IS_INST_AVANS,
			IS_EHESAP,
			TOTAL_GET,
			COMPANY_ID,
			TAX,
			SALARYPARAM_GET.ACCOUNT_CODE,
			ACCOUNT_NAME,
			CONSUMER_ID,
			EIO.FINISH_DATE,
			CASE WHEN IS_INST_AVANS = 1 THEN -2 ELSE ACC_TYPE_ID END AS ACC_TYPE_ID,
			SALARYPARAM_GET.DETAIL,
			SALARYPARAM_GET.CAUTION_ID,
			IS_NET_TO_GROSS
		FROM 
			SALARYPARAM_GET,
			EMPLOYEES_IN_OUT EIO
		WHERE 
			EIO.IN_OUT_ID = SALARYPARAM_GET.IN_OUT_ID AND 
			SALARYPARAM_GET.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
			SALARYPARAM_GET.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
			AND TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
			AND START_SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
			AND END_SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
			<cfif isdefined("attributes.is_virtual_puantaj") and attributes.is_virtual_puantaj eq 1 and get_active_program_parameter.is_add_virtual_all eq 1>
				AND (SHOW = 0 OR SHOW IS NULL OR SHOW = 1)
			<cfelseif isdefined("attributes.is_virtual_puantaj") and attributes.is_virtual_puantaj eq 1>
				AND (SHOW = 0 OR SHOW IS NULL)
			<cfelse>
				AND SHOW = 1
			</cfif>
			<cfif (get_hr_ssk.USE_SSK eq 2 and attributes.ssk_statue eq 2 and (attributes.statue_type eq 2 or attributes.statue_type eq 3 or attributes.statue_type eq 4 or attributes.statue_type eq 8 or attributes.statue_type eq 9 or (attributes.statue_type eq 10  and isdefined("attributes.statue_type_individual") and len(attributes.statue_type_individual))) and get_hr_ssk.administrative_academic neq 2)>
				AND 1 = 0
			</cfif>
		) AS TBL3
</cfquery>
<!--- // ek ödenek ve kesintiler --->

<!--- otomatik bes sistemi --->
<cfquery name="get_bes" datasource="#dsn#">
	SELECT 
		SB.RATE_BES,
		SB.COMMENT_BES,
		SB.EMPLOYEE_ID,
		SB.TERM,
		SB.IN_OUT_ID,
		SB.START_SAL_MON,
		SB.END_SAL_MON
	FROM
		SALARYPARAM_BES SB,
		EMPLOYEES_IN_OUT EIO
	WHERE
		EIO.IN_OUT_ID = SB.IN_OUT_ID AND 
		SB.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
		SB.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		AND SB.TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
		AND SB.START_SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
		AND SB.END_SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
</cfquery>

<!--- icra kesintisi--->
<!---
<cfquery name="get_get_salary2" datasource="#dsn#">
	SELECT 
		EE.EXECUTION_ID,
		CASE WHEN EE.EXECUTION_CAT = 1 THEN 'İcra' WHEN EE.EXECUTION_CAT = 2 THEN 'Nafaka' END AS COMMENT_GET,
		EE.EXECUTION_CAT,
		EE.DEDUCTION_TYPE,
		EE.DEDUCTION_VALUE,
		EE.ACC_TYPE_ID,
		EE.ACCOUNT_CODE,
		EE.ACCOUNT_NAME,
		EE.COMPANY_ID,
		EE.CONSUMER_ID,
		EE.DEBT_AMOUNT,
		ISNULL((SELECT SUM(CASE WHEN PAY_METHOD = 1 THEN AMOUNT_2 WHEN PAY_METHOD = 2 THEN AMOUNT END) FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE COMMENT_PAY_ID = EE.EXECUTION_ID AND EXT_TYPE = 3),0) AS ODENEN_TOPLAM
	FROM 
		EMPLOYEES_EXECUTIONS EE
		INNER JOIN EMPLOYEES_IN_OUT EIO ON EIO.EMPLOYEE_ID = EE.EMPLOYEE_ID 
		WHERE
		EE.IS_ACTIVE = 1
		AND EE.NOTIFICATION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#parameter_last_month_30#">
		AND EIO.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
		AND ISNULL((SELECT SUM(CASE WHEN PAY_METHOD = 1 THEN AMOUNT_2 WHEN PAY_METHOD = 2 THEN AMOUNT END) FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE COMMENT_PAY_ID = EE.EXECUTION_ID AND EXT_TYPE = 3),0) < EE.DEBT_AMOUNT
	ORDER BY
			EE.PRIORITY
</cfquery>
--->
<cfset get_get_salary2.recordcount = 0>
<!---// icra kesintisi --->

<!--- vergi muafiyetleri --->
<cfquery name="get_tax_exception" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SALARYPARAM_EXCEPT_TAX
	WHERE 
		<cfif isdefined("attributes.in_out_id")>
			IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
		</cfif>
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND 
		TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
		START_MONTH <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND 
		FINISH_MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
		(IS_ISVEREN = 0 OR IS_ISVEREN IS NULL) AND
		(
		EXCEPTION_TYPE IS NULL OR
		EXCEPTION_TYPE = 2 OR
		EXCEPTION_TYPE = 4 OR
		EXCEPTION_TYPE = 6
		)
</cfquery>
<!--- // vergi muafiyetleri --->


<!--- vergi muafiyetleri isveren--->
<cfquery name="get_tax_exception_boss" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SALARYPARAM_EXCEPT_TAX
	WHERE 
	<cfif isdefined("attributes.in_out_id")>
		IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
	</cfif>
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		AND TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
		AND START_MONTH <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
		AND FINISH_MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
		IS_ISVEREN = 1 AND
		(IS_SSK = 0  OR IS_SSK IS NULL) AND
		EXCEPTION_TYPE IS NULL
</cfquery>
<!--- // vergi muafiyetleri isveren--->


<!--- vergi muafiyetleri ssk--->
<cfquery name="get_tax_ssk" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SALARYPARAM_EXCEPT_TAX
	WHERE 
	<cfif isdefined("attributes.in_out_id")>
		IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
	</cfif>
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND 
		TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
		START_MONTH <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND 
		FINISH_MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
		IS_SSK = 1 AND
		EXCEPTION_TYPE IS NULL
</cfquery>
<!--- // vergi muafiyetleri ssk--->


<!--- vergi muafiyetleri --->
<cfquery name="get_tax_exception_bei" datasource="#dsn#">
	SELECT * FROM SALARYPARAM_EXCEPT_TAX
	WHERE 
	<cfif isdefined("attributes.in_out_id")>
		IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
	</cfif>
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND 
		TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
		START_MONTH <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND 
		FINISH_MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
		EXCEPTION_TYPE = 1
</cfquery>
<!--- // vergi muafiyetleri --->
<!--- vergi muafiyetleri - İstisna tipi = Özel Sağlık Sigortası (İŞVEREN) --->
<cfquery name="get_tax_exception_osi" datasource="#dsn#">
	SELECT * FROM SALARYPARAM_EXCEPT_TAX
	WHERE 
		IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND 
		TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
		START_MONTH <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND 
		FINISH_MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
		EXCEPTION_TYPE = 3
</cfquery>
<!--- vergi muafiyetleri - İstisna tipi = Özel Sağlık Sigortası (İŞVEREN) --->
<cfquery name="get_tax_exception_hs" datasource="#dsn#">
	SELECT * FROM SALARYPARAM_EXCEPT_TAX
	WHERE 
		IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND 
		TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
		START_MONTH <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND 
		FINISH_MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
		EXCEPTION_TYPE = 5
</cfquery>
<!--- // vergi muafiyetleri --->
<cfquery name="get_old_tax_exception" datasource="#dsn#">
	SELECT 
		SUM(EPRE.AMOUNT) AS OLD_EXPECT 
	FROM 
		#ext_puantaj_table# EPRE,
		#row_puantaj_table# EPR,
		#main_puantaj_table# EP
	WHERE
		EPRE.PUANTAJ_ID = EP.PUANTAJ_ID AND
		EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
		EP.SAL_MON < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
		EPRE.EMPLOYEE_PUANTAJ_ID = EPR.EMPLOYEE_PUANTAJ_ID AND
		EPR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
		EPRE.EXT_TYPE = 2
</cfquery>
<cfif get_old_tax_exception.recordcount and len(get_old_tax_exception.OLD_EXPECT)>
	<cfset old_except = get_old_tax_exception.OLD_EXPECT>
<cfelse>
	<cfset old_except = 0>
</cfif>

<cfset yilbasi_ = CreateDateTime(attributes.sal_year,1,1,0,0,0)>
<cfset yilsonu_ = CreateDateTime(attributes.sal_year,7,1,0,0,0)>
<cfquery name="get_insurance_yilbasi" datasource="#dsn#" maxrows="1">
	SELECT MIN_GROSS_PAYMENT_NORMAL FROM INSURANCE_PAYMENT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#yilbasi_#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#yilbasi_#">
</cfquery>
<cfquery name="get_insurance_sonu" datasource="#dsn#" maxrows="1">
	SELECT MIN_GROSS_PAYMENT_NORMAL FROM INSURANCE_PAYMENT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#yilsonu_#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#yilsonu_#">
</cfquery>
<cfif not get_insurance_yilbasi.recordcount or not get_insurance_sonu.recordcount>
	<cfif not isdefined("attributes.from_employee_payroll") and isdefined('this.returnResult')>
		<cfset response = "Vergi İstisnası Hesapları İçin 1.Dönem ve 2.Dönem Asgari Ücretleri Girilmelidir!">
		<cfreturn response> 
	<cfelse>
		<script type="text/javascript">
			alert('Vergi İstisnası Hesapları İçin 1.Dönem ve 2.Dönem Asgari Ücretleri Girilmelidir!');
			<cfif isdefined("attributes.modal_id")>
				closeBoxDraggable('#attributes.modal_id#');
			</cfif>
			<cfif not isdefined("attributes.ajax")>
				history.back();
			</cfif>
		</script>
		<cfabort>
	</cfif>
<cfelse>
	<cfset yillik_toplam_asgari_ucret = (get_insurance_yilbasi.MIN_GROSS_PAYMENT_NORMAL * 6) + (get_insurance_sonu.MIN_GROSS_PAYMENT_NORMAL * 6)>
</cfif>
<!--- son kümülatifi alınır --->
<cfquery name="get_kumulative" datasource="#dsn#" maxrows="1"><!--- harcırah bordrosu varsa onun kümülatifi alınıyor --->
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
			B.COMPANY_ID = (SELECT B2.COMPANY_ID FROM BRANCH B2 WHERE B2.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hr_ssk.branch_id#">) AND
		</cfif>
		EPR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND 
		MONTH(EPR.EXPENSE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND 
		YEAR(EPR.EXPENSE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
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
					B.COMPANY_ID = (SELECT B2.COMPANY_ID FROM BRANCH B2 WHERE B2.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hr_ssk.BRANCH_ID[currentrow]#">) AND
				</cfif>
				EP.PUANTAJ_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.puantaj_type#"> AND
				EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND 
				EPR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND 
				<cfif isdefined("attributes.statue_type") and attributes.statue_type eq 11>
					EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(now())#"> AND 
				<cfelse>
					EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
					EP.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
				</cfif>
				EPR.KUMULATIF_GELIR_MATRAH > 0
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
						B.COMPANY_ID = (SELECT B2.COMPANY_ID FROM BRANCH B2 WHERE B2.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hr_ssk.BRANCH_ID[currentrow]#">) AND
					</cfif>
					EP.PUANTAJ_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.puantaj_type#"> AND
					EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND 
					EPR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND 
					EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
					EP.SAL_MON < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
					EPR.KUMULATIF_GELIR_MATRAH > 0
				ORDER BY 
					EPR.EMPLOYEE_PUANTAJ_ID DESC 
			</cfquery>
		</cfif>
	</cfif>
	<!--- Asgari Ücret KGVM --->
	<cfquery name="get_daily_minimum_wage_base" datasource="#dsn#" maxrows="1">
		SELECT 
			SUM(DAILY_MINIMUM_WAGE_BASE_CUMULATE) DAILY_MINIMUM_WAGE_BASE_CUMULATE 
		FROM 
			EMPLOYEES_PUANTAJ EP,
			EMPLOYEES_PUANTAJ_ROWS EPR
			<cfif this_tax_account_style_ eq 1>
				,BRANCH B
			</cfif>
		WHERE 
			<cfif this_tax_account_style_ eq 1>
				EP.SSK_BRANCH_ID = B.BRANCH_ID AND
				B.COMPANY_ID = (SELECT B2.COMPANY_ID FROM BRANCH B2 WHERE B2.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hr_ssk.BRANCH_ID[currentrow]#">) AND
			</cfif>
			EP.PUANTAJ_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.puantaj_type#"> AND
			EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND 
			EPR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND 
			EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
	</cfquery>
	<cfif len(get_daily_minimum_wage_base.DAILY_MINIMUM_WAGE_BASE_CUMULATE)>
		<cfset daily_minimum_wage_base_cumulate = get_daily_minimum_wage_base.DAILY_MINIMUM_WAGE_BASE_CUMULATE>
	<cfelse>
		<cfset daily_minimum_wage_base_cumulate = 0>
	</cfif>
	<cfif len(get_hr_ssk.START_CUMULATIVE_WAGE_TOTAL)>
		<cfset daily_minimum_wage_base_cumulate = daily_minimum_wage_base_cumulate + get_hr_ssk.START_CUMULATIVE_WAGE_TOTAL>
	</cfif>
<cfelse>
	<cfset daily_minimum_wage_base_cumulate = 0>
</cfif>
<cfif attributes.SAL_MON eq 1 and not (isdefined("get_kumulative") and get_kumulative.recordcount)>
	<cfset kontrol_matrah = 0>
	<cfset kontrol_kumulative = 1>
	<cfif len(get_hr_ssk.ex_in_out_id)>
		<cfquery name="get_det" datasource="#dsn#">
			SELECT B.COMPANY_ID FROM EMPLOYEES_IN_OUT EIO INNER JOIN BRANCH B ON EIO.BRANCH_ID = B.BRANCH_ID WHERE EIO.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hr_ssk.ex_in_out_id#"> 
		</cfquery>
		<cfif (get_det.company_id eq get_hr_ssk.COMP_ID and get_program_parameters.tax_account_style eq 1) or get_program_parameters.tax_account_style eq 0><!--- nakil oldugu şirket aynı ise ve akış parametrelerinde gelir vergisi devir durumu şirket içi devir ise veya akış paramtresinde grup içi devir seçili ise--->
			<cfquery name="get_gelir_matrah" datasource="#dsn#">
				SELECT
					SUM(KUMULATIF_GELIR_MATRAH) AS KUMULATIF_GELIR_MATRAH
				FROM
					EMPLOYEES_PUANTAJ EP INNER JOIN EMPLOYEES_PUANTAJ_ROWS EPR ON EP.PUANTAJ_ID = EPR.PUANTAJ_ID 
				WHERE
					EPR.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hr_ssk.ex_in_out_id#"> AND
					<cfif isdefined("attributes.statue_type") and attributes.statue_type eq 11>
						EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(now())#"> AND 
					<cfelse>
						EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
						EP.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
					</cfif>
					EP.PUANTAJ_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.puantaj_type#">
			</cfquery>
			<cfif get_gelir_matrah.recordcount and get_gelir_matrah.KUMULATIF_GELIR_MATRAH gt 0>
				<cfset get_kumulative.KUMULATIF_GELIR_MATRAH = get_gelir_matrah.KUMULATIF_GELIR_MATRAH>
				<cfset kontrol_matrah = get_gelir_matrah.KUMULATIF_GELIR_MATRAH>
			</cfif>
		</cfif>
	<cfelseif attributes.sal_mon eq 1> <!--- ocak ayında birden fazla ücret kartı varsa--->
		<cfquery name="get_gelir_matrah" datasource="#dsn#">
			SELECT
				TOP 1
				KUMULATIF_GELIR_MATRAH AS KUMULATIF_GELIR_MATRAH
			FROM
				EMPLOYEES_PUANTAJ EP 
				INNER JOIN EMPLOYEES_PUANTAJ_ROWS EPR ON EP.PUANTAJ_ID = EPR.PUANTAJ_ID 
				<cfif this_tax_account_style_ eq 1>
					,BRANCH B
				</cfif>
			WHERE
				<cfif this_tax_account_style_ eq 1>
					EP.SSK_BRANCH_ID = B.BRANCH_ID AND
					B.COMPANY_ID = (SELECT B2.COMPANY_ID FROM BRANCH B2 WHERE B2.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hr_ssk.BRANCH_ID[currentrow]#">) AND
				</cfif>
				<cfif isdefined("attributes.statue_type") and attributes.statue_type eq 11>
						EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(now())#"> AND 
				<cfelse>
					EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
					EP.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
				</cfif>
				EPR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
				<!--- EPR.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">--->
				EP.PUANTAJ_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.puantaj_type#">
			ORDER BY EMPLOYEE_PUANTAJ_ID DESC
		</cfquery>
		<cfif get_gelir_matrah.recordcount and get_gelir_matrah.KUMULATIF_GELIR_MATRAH gt 0>
			<cfset get_kumulative.KUMULATIF_GELIR_MATRAH = get_gelir_matrah.KUMULATIF_GELIR_MATRAH>
			<cfset kontrol_matrah = get_gelir_matrah.KUMULATIF_GELIR_MATRAH>
		</cfif>
	</cfif>
<cfelse>
	<cfset kontrol_kumulative = get_kumulative.recordcount>
	<cfif len(get_kumulative.KUMULATIF_GELIR_MATRAH)>
		<cfset kontrol_matrah = get_kumulative.KUMULATIF_GELIR_MATRAH>
	<cfelse>
		<cfset kontrol_matrah = 0>
	</cfif>
</cfif>
<!--- bu ay işten çıkmışsa çıkış bilgileri al --->
<cfquery name="get_last_in_out" dbtype="query">
	SELECT 
		KIDEM_AMOUNT, 
		IHBAR_AMOUNT, 
		KULLANILMAYAN_IZIN_AMOUNT,
		GROSS_COUNT_TYPE
	FROM 
		get_hr_ssk
	WHERE 
		IN_OUT_ID = #attributes.IN_OUT_ID# AND 
		FINISH_DATE BETWEEN #LAST_MONTH_1# AND #LAST_MONTH_30# AND VALID = 1
</cfquery>

<cfquery name="get_old_payroll_count" datasource="#dsn#">
	SELECT COUNT(EMPLOYEE_PUANTAJ_ID) AS COUNT FROM EMPLOYEES_PUANTAJ_ROWS WHERE IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> 
</cfquery>

<!--- bu ay içindeki genel tatiller --->
<cfscript>
	offdays_count = 0;
	offdays_day_list = '';
	for (ggotrc = 1; ggotrc lte get_GENERAL_OFFTIMES.recordcount; ggotrc=ggotrc+1)
	{
		for (ijklmn = 0; ijklmn lte datediff("d", get_GENERAL_OFFTIMES.start_date[ggotrc], get_GENERAL_OFFTIMES.FINISH_DATE[ggotrc]); ijklmn=ijklmn+1)
		{
			tempo_day = date_add("d", ijklmn, get_GENERAL_OFFTIMES.start_date[ggotrc]);
			offdays_day_list = listappend(offdays_day_list,'#dateformat(tempo_day,"ddmmyyyy")#');
			//Çalışanın  çıkışı yoksa resmi tatilde ya da çalışanın çıkışı varsa ve resmi 
			if (((datediff("d", last_month_1, tempo_day) gte 0) and (datediff("d", tempo_day, last_month_30) gte 0) and not(len(get_hr_ssk.finish_date)) ) or ((datediff("d", last_month_1, tempo_day) gte 0) and (datediff("h", tempo_day, last_month_30) gt 0) and len(get_hr_ssk.finish_date))) //genel tatil günü bu ay içinde
			{
				if (dayofweek(tempo_day) eq this_weekly_offday_) // pazar a geliyor
				{
					offdays_sunday_count = offdays_sunday_count + 1;
				}
				if(dayofweek(tempo_day) eq 7 and this_saturday_work_hour_ eq 0 and this_weekly_offday_ neq 7)
				{
					offdays_sunday_count = offdays_sunday_count + 1;
				}
				offdays_count = offdays_count + 1;
			}
		}
	}
</cfscript>
<!--- // bu ay içindeki genel tatiller --->

<!--- 7103 den yararlanıyor fakat agiden yararlanmiyor ise --->
<cfif law_number_7103 neq 0 and get_hr_ssk.is_discount_off eq 1>
	<cfset is_discount_off_ = 0>
<cfelse>
	<cfset is_discount_off_ = get_hr_ssk.is_discount_off>
</cfif>


<cfset engelli_cocuk = 0>
<cfset engelli_cocuk_derece = "">
<cfset engelli_cocuk_indirim = "">
<cfquery name="get_emp_relatives" dbtype="query">
	SELECT * FROM get_relatives WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id_#">
</cfquery>
<cfoutput query="get_emp_relatives">
	<cfif len(defection_level) and  defection_level gt 0 and ((DEFECTION_STARTDATE lte parameter_last_month_30 and DEFECTION_FINISHDATE gte parameter_last_month_1) or (not (len(DEFECTION_STARTDATE) and len(DEFECTION_FINISHDATE))))>
		<cfset engelli_cocuk = engelli_cocuk + 1>
		<cfset engelli_cocuk_derece = listappend(engelli_cocuk_derece,defection_level)>
		
		<cfif use_tax eq 1>
			<cfset engelli_cocuk_indirim = listappend(engelli_cocuk_indirim,"1")>
		<cfelse>
			<cfset engelli_cocuk_indirim = listappend(engelli_cocuk_indirim,"0")>
		</cfif>
	</cfif>
</cfoutput>
<cfif get_hr_ssk.use_tax eq 1 and not(len(get_hr_ssk.DEFECTION_STARTDATE) and len(get_hr_ssk.DEFECTION_FINISHDATE))><!--- engellilik indirimi tarih aralığı--->
	<cfif not isdefined("attributes.from_employee_payroll") and isdefined('this.returnResult')>
		<cfset response = "#get_hr_ssk.employee_name# #get_hr_ssk.employee_surname# #getLang('','İsimli Çalışanın Engellilik Geçerlilik Tarihi Girilmelidir!',64172)#">
		<cfreturn response> 
	<cfelse>
		<cfoutput>
			<script type="text/javascript">
				alert("#get_hr_ssk.employee_name# #get_hr_ssk.employee_surname# #getLang('','İsimli Çalışanın Engellilik Geçerlilik Tarihi Girilmelidir!',64172)#");
				<cfif isdefined("attributes.modal_id")>
					closeBoxDraggable('#attributes.modal_id#');
				</cfif>
				<cfif not isdefined("attributes.ajax")>
					history.back();
				</cfif>
			</script>
		</cfoutput>
		<cfabort>
	</cfif>
</cfif>
<cfif is_discount_off_ eq 1>
	<!--- asgari gecim almayacak kisiler icin simdilik bi islem yapmiyoruz --->
	<cfset asgari_gecim_max_tutar_ = 50000>
<cfelse>
	<!--- akrabalar --->
	<cfif this_cast_style_ eq 1 or this_cast_style_ eq 2>
		<cfset asgari_gecim_indirimi_ = 0>
		<cfset yilbasi_ = CreateDateTime(attributes.sal_year,1,1,0,0,0)>
		<cfif not isdefined("get_insurance_ilk.recordcount")>
			<cfquery name="get_insurance_ilk" datasource="#dsn#">
				SELECT MIN_GROSS_PAYMENT_NORMAL FROM INSURANCE_PAYMENT WHERE STARTDATE <= #yilbasi_# AND FINISHDATE >= #yilbasi_#
			</cfquery>
			<cfif not get_insurance_ilk.recordcount>
				<cfif not isdefined("attributes.from_employee_payroll") and isdefined('this.returnResult')>
					<cfset response = "AGİ Hesaplaması İçin Yılbaşı Asgari Ücretini Tanımlamalısınız!">
					<cfreturn response> 
				<cfelse>
					<script type="text/javascript">
						alert('AGİ Hesaplaması İçin Yılbaşı Asgari Ücretini Tanımlamalısınız!');
						<cfif isdefined("attributes.modal_id")>
							closeBoxDraggable('#attributes.modal_id#');
						</cfif>
						<cfif not isdefined("attributes.ajax")>
							history.back();
						</cfif>
					</script>	
					<cfabort>
				</cfif>
			</cfif>
		</cfif>
		<cfset asgari_ucret_ = get_insurance_ilk.MIN_GROSS_PAYMENT_NORMAL>
		<cfset asgari_gecim_indirimi_yuzdesi_ = 50>
		<cfset asgari_gecim_max_tutar_ = (get_insurance.MIN_GROSS_PAYMENT_NORMAL * 85 / 100) * 15 / 100>
		
		<cfif len(get_active_program_parameter.IS_AGI_PAY)><!--- hesaplama turu , normal (0) - asgari gecim (1) --->
			<cfset this_agi_style_ = get_active_program_parameter.IS_AGI_PAY>
		<cfelse>
			<cfset this_agi_style_ = 0>
		</cfif>
		
		<cfif this_agi_style_ eq 1>
			<cfquery name="get_old_" datasource="#dsn#">
				SELECT 
					SUM(VERGI_IADESI) AS TOPLAM_IADE
				FROM
					#row_puantaj_table# EPR,
					#main_puantaj_table# EP
				WHERE
					EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND
					EP.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
					EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
					EPR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id_#"> AND
					EPR.IN_OUT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
			</cfquery>
			<cfif get_old_.recordcount and len(get_old_.TOPLAM_IADE)>
				<cfset dusulecek_agi_ = get_old_.TOPLAM_IADE>
			<cfelse>
				<cfset dusulecek_agi_ = 0>
			</cfif>
		<cfelse>
			<cfset dusulecek_agi_ = 0>
		</cfif>
		
		<cfset es_oran_ = 0>
		<cfset cocuk_oran_ = 0>
		<cfset cocuk_sayi_ = 0>		
		<cfquery name="get_emp_relatives" dbtype="query">
			SELECT * FROM get_relatives WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id_#">
		</cfquery>
		<cfif get_emp_relatives.recordcount>
			<cfoutput query="get_emp_relatives">
				<cfif RELATIVE_LEVEL eq 3 and ((len(WORK_STATUS) and work_status eq 0) or not len(work_status)) and es_oran_ eq 0 and discount_status eq 1>
					<cfset es_oran_ = 10>
					<cfset asgari_gecim_indirimi_yuzdesi_ = asgari_gecim_indirimi_yuzdesi_ + es_oran_>
				<cfelseif RELATIVE_LEVEL eq 4 and work_status neq 1 and discount_status eq 1 and education_status eq 1 and len(BIRTH_DATE) and datediff("yyyy",BIRTH_DATE,last_month_30) lte 24>
					<cfset cocuk_sayi_ = cocuk_sayi_ + 1>
				<cfelseif RELATIVE_LEVEL eq 4 and work_status neq 1 and discount_status eq 1 and len(BIRTH_DATE) and datediff("yyyy",BIRTH_DATE,last_month_30) lt 18>
					<cfset cocuk_sayi_ = cocuk_sayi_ + 1>
				<cfelseif RELATIVE_LEVEL eq 5 and work_status neq 1 and discount_status eq 1 and education_status eq 1 and len(BIRTH_DATE) and datediff("yyyy",BIRTH_DATE,last_month_30) lte 24>
					<cfset cocuk_sayi_ = cocuk_sayi_ + 1>
				<cfelseif RELATIVE_LEVEL eq 5 and work_status neq 1 and discount_status eq 1 and len(BIRTH_DATE) and datediff("yyyy",BIRTH_DATE,last_month_30) lt 18>
					<cfset cocuk_sayi_ = cocuk_sayi_ + 1>
				</cfif>
			</cfoutput>
			<cfif parameter_last_month_1 gte CreateDateTime(2015,5,1,0,0,0)> <!--- 1 mayıs 2015 itibari ile değişen kanun ile birlikte yapılan düzenleme--->
				<cfif cocuk_sayi_ gt 0 and cocuk_sayi_ lte 2>
					<cfset asgari_gecim_indirimi_yuzdesi_ = asgari_gecim_indirimi_yuzdesi_ + (cocuk_sayi_ * 7.5)>
				<cfelseif cocuk_sayi_ gt 0 and cocuk_sayi_ eq 3>
					<cfset asgari_gecim_indirimi_yuzdesi_ = asgari_gecim_indirimi_yuzdesi_ + (2 * 7.5) + 10>
				<cfelseif cocuk_sayi_ gt 0 and cocuk_sayi_ eq 4 and es_oran_ eq 0>
					<cfset asgari_gecim_indirimi_yuzdesi_ = asgari_gecim_indirimi_yuzdesi_ + (2 * 7.5) + 10 + 5>
				<cfelseif cocuk_sayi_ gt 0 and cocuk_sayi_ eq 4 and es_oran_ gt 0> <!---oranın % 85 i gecmemesi gerektigi icin tekrar duzenleme yapıldı --->
					<cfset asgari_gecim_indirimi_yuzdesi_ = asgari_gecim_indirimi_yuzdesi_ + (2 * 7.5) + 10>
				<cfelseif cocuk_sayi_ gt 0 and cocuk_sayi_ gte 5 and es_oran_ eq 0><!---oranın % 85 i gecmemesi gerektigi icin tekrar duzenleme yapıldı --->
					<cfset asgari_gecim_indirimi_yuzdesi_ = asgari_gecim_indirimi_yuzdesi_ + (2 * 7.5) + 10 + 5 + 5>
				<cfelseif cocuk_sayi_ gt 0 and cocuk_sayi_ gte 5 and es_oran_ gt 0><!---oranın % 85 i gecmemesi gerektigi icin tekrar duzenleme yapıldı --->
					<cfset asgari_gecim_indirimi_yuzdesi_ = asgari_gecim_indirimi_yuzdesi_ + (2 * 7.5) + 10>
				</cfif>
			<cfelse>
				<cfif cocuk_sayi_ gt 0 and cocuk_sayi_ lte 2>
					<cfset asgari_gecim_indirimi_yuzdesi_ = asgari_gecim_indirimi_yuzdesi_ + (cocuk_sayi_ * 7.5)>
				<cfelseif cocuk_sayi_ gt 0 and cocuk_sayi_ eq 3>
					<cfset asgari_gecim_indirimi_yuzdesi_ = asgari_gecim_indirimi_yuzdesi_ + (2 * 7.5) + 5>
				<cfelseif cocuk_sayi_ gt 0 and cocuk_sayi_ gte 4>
					<cfset asgari_gecim_indirimi_yuzdesi_ = asgari_gecim_indirimi_yuzdesi_ + (2 * 7.5) + 5 + 5>
				</cfif>
			</cfif>		
			</cfif>
	<cfelse>
		<cfset asgari_gecim_max_tutar_ = 0>
	</cfif>
	<!--- akrabalar --->
</cfif>
<cfscript>
	mahsup_edilecek_gelir_vergisi_ = 0;
	ext_salary = 0;
	if(get_hr_salary.use_pdks eq 2) // tam bağlı saat
		include 'get_hr_compass_work_times_pdks.cfm'; /* calisma saatleri / fazla mesailer / izinler ve tum carpanlar */
	else if(get_hr_salary.use_pdks eq 3) // tam bağlı gün
		include 'get_hr_compass_work_times_pdks_day.cfm'; /* calisma saatleri / fazla mesailer / izinler ve tum carpanlar */
	else
		include 'get_hr_compass_work_times.cfm'; /* calisma saatleri / fazla mesailer / izinler ve tum carpanlar */

		if((len(get_hr_ssk.finish_date) or datediff("h",last_month_1,get_hr_ssk.start_date) eq 0) and use_ssk eq 2)
		{
			day_factor = work_days / ssk_full_days;
			officer_salary = officer_salary * day_factor;
			additional_indicators = additional_indicators * day_factor;
			university_allowance_payroll = university_allowance_payroll * day_factor;
			private_service_compensation = private_service_compensation * day_factor;
			business_risk = business_risk * day_factor;
			family_assistance = family_assistance * day_factor;
			child_assistance = child_assistance * day_factor;
			base_salary = base_salary * day_factor;
			severance_pension = severance_pension * day_factor;
			language_allowance = language_allowance * day_factor;
			academic_incentive_allowance_amount = academic_incentive_allowance_amount * day_factor;
			high_education_compensation_payroll = high_education_compensation_payroll * day_factor;
			executive_indicator_compensation = executive_indicator_compensation * day_factor;
			administrative_duty_allowance = administrative_duty_allowance * day_factor;
			education_allowance = education_allowance * day_factor;
			administrative_compensation = administrative_compensation * day_factor;
			additional_indicator_compensation = additional_indicator_compensation * day_factor;   
			high_education_compensation = high_education_compensation * day_factor;   
			collective_agreement_bonus = collective_agreement_bonus * day_factor;  
			additional_indicator_compensation_ = additional_indicator_compensation_ * day_factor;
			officer_total_salary = officer_salary + additional_indicators + base_salary + severance_pension + business_risk + retirement_allowance_5510 + retirement_allowance + plus_retired + family_assistance + child_assistance + 
			executive_indicator_compensation + administrative_compensation + language_allowance + collective_agreement_bonus + health_insurance_premium_5510 + general_health_insurance + private_service_compensation + additional_indicator_compensation_ + 
			administrative_duty_allowance + university_allowance_payroll + high_education_compensation_payroll + academic_incentive_allowance_amount + education_allowance + audit_compensation_amount;
		}
			
	// Eğer Çalışan memursa ve raporu varsa --->
	if(use_ssk eq 2 and isDefined("report_day") and report_day gt 0 and isDefined("get_hours.ssk_work_hours") and isdefined("private_service_compensation") and isdefined("business_risk"))
	{
		private_service_compensation_report = (private_service_compensation / 30) *  (25 / 100) * (report_day / get_hours.ssk_work_hours);// Özel Hizmet Tazminatı = Özel Hizmet Tazminatı / 30 * raporlu gün sayısı * %25
		private_service_compensation = private_service_compensation - private_service_compensation_report;
		business_risk_report = (business_risk / 30) *  (25 / 100) * (report_day / get_hours.ssk_work_hours);// Özel Hizmet Tazminatı = Özel Hizmet Tazminatı / 30 * raporlu gün sayısı * %25
		business_risk = business_risk - business_risk_report;
	}

	// 16 yaş kontrolü 
	if(len(get_hr_ssk.birth_date) and datediff("yyyy",get_hr_ssk.birth_date,now()) lt 16)
	{
		ssk_asgari_ucret = get_insurance.MIN_GROSS_PAYMENT_16;
	}
	else
	{	
		ssk_asgari_ucret = get_insurance.MIN_GROSS_PAYMENT_NORMAL;
	}

	if(not isDefined('attributes.employee_puantaj_id'))//puantaj guncelleme ekrani icin bu kisma gerek yok
	{
		/* 20050915 alttaki kisimlar ve dosyalarin icerikleri habersiz kesinlikle degismemeli, ! ! ! OYNAMAAA, ELLEMEEE ! ! !.*/
		
		// maas hesabi, ucret net ise bu ucret alinir ayni isimli degiskene brutu verilir ve from brut bundan devan eder, aksi halde bu degerler direk from brut e girer
		if (get_hr_salary.salary_type eq 0 and get_hr_salary.is_kismi_istihdam eq 1) // saatlik
		{
			salary = get_hr_salary.salary * total_hours;
			saatlik_ucret = get_hr_salary.salary;
			seniority_salary =  get_hr_salary.salary * 225;

			/*
			if (get_hr_salary.KISMI_ISTIHDAM_GUN gt 0 or get_hr_salary.KISMI_ISTIHDAM_HS_GUN gt 0 or get_hr_salary.KISMI_ISTIHDAM_GT_GUN gt 0)
				salary = get_hr_salary.salary * get_hours.daily_work_hours * (get_hr_salary.KISMI_ISTIHDAM_GUN + get_hr_salary.KISMI_ISTIHDAM_HS_GUN + get_hr_salary.KISMI_ISTIHDAM_GT_GUN);
			*/
		}
		else if (get_hr_salary.salary_type eq 0) // saatlik ücret
		{
			saatlik_ucret = get_hr_salary.salary;

			if(aydaki_gun_sayisi gt izin)
			{
				if(get_hr_salary.use_pdks eq 3) //tam bağlı gün
					salary = get_hr_salary.salary * total_hours;
				else if(get_hr_salary.use_pdks eq 2) // tam bağlı saat
					salary = get_hr_salary.salary * total_hours;
				else
					{
					salary = get_hr_salary.salary * (total_hours + get_half_offtimes_total_hour);
					//salary = get_hr_salary.salary * (total_hours + (sunday_count * get_hours.daily_work_hours) + (offdays_count * get_hours.daily_work_hours));
					}
			}
			else
			{
				salary = 0;
			}
			seniority_salary =  get_hr_salary.salary * 225;
		}
		else if (get_hr_salary.salary_type eq 1) // günlük
		{
			gunluk_ = get_hr_salary.salary;
			salary = get_hr_salary.salary * aydaki_gun_sayisi;
			seniority_salary =  get_hr_salary.salary * 30;
		}
		else if (get_hr_salary.salary_type eq 2) // aylık
		{
			salary = get_hr_salary.salary;
			seniority_salary =  salary;
		}
		else
		{
			salary = 0;
		}
		//128857 id li iş kapsamında saatlik çalışanın maaşını yanlış hesapladığı için kapatıldı
		if(get_hr_salary.salary_type eq 1 and aydaki_gun_sayisi gt ssk_days and (izin neq 0 or len(get_hr_salary.finish_date) or from_fire_action eq 1))
		{
			salary = get_hr_salary.salary * ssk_days;
		}  
		
		maas_tutar_ = salary;
		brut_maas = salary;
		
		include 'get_hr_compass_odenek_kesintiler.cfm';
		vergi_istisna = 0;
		vergi_istisna_boss = 0;
		vergi_istisna_bei = 0;
		vergi_istisna_hs = 0;
		vergi_istisna_osi = 0;
		vergi_istisna_damga_tutar = 0;
		vergi_istisna_damga_tutar_net = 0;
		vergi_istisna_ssk_tutar_net = 0;
		vergi_istisna_ssk_tutar = 0;
		vergi_istisna_ssk_tutar_hs = 0;
		total_vergi_istisna_ssk_tutar_hs = 0;
		temp_vergi_istisna_ssk_tutar_hs = 0;
		vergi_istisna_ssk_tutar_net_hs = 0;
		temp_vergi_istisna_damga_tutar_hs = 0;
		temp_vergi_istisna_damga_tutar_hs_net = 0;
		vergi_istisna_vergi_tutar = 0;
		vergi_istisna_vergi_tutar_net = 0;
		vergi_istisna_total = 0;
		
		daily_minimum_income_tax = 0;
		daily_minimum_wage_base = 0;
		all_basic_wage = 0;
		daily_minimum_wage_stamp_tax = 0;
		daily_minimum_wage = 0;
		control_daily_minimum_wage = 0;
		income_tax_temp = 0;
		stamp_tax_temp = 0;
		net_payment_stamp_tax = 0;//net ödenek damga vergisi(sadce damga dahil)
		temp_daily_minimum_income_tax = 0;
		max_daily_minimum_income_tax = 0; //2022 düzenlemeleri ile vergi dilimi değişimi için kullanılıyor. 

		/* 20050925 get_hr_compass_tax_exception aslen brut rakamlarin altinda olmali ancak get_hr_compass_formuls icinde 
			vergi_istisna istendigi icin aslen sorun var, vergi_istisna brut rakama	gore degisebilen bir deger bu yuzden
			net ucretle ilgili olarak cagrilmasi teorik olarak yanlis, bu durumda bu haliyle ucreti degil odenekleri yukseltmis oluyoruz*/

		tax_carpan = 0; // get_hr_compass_tax.cfm icinde kullanılıyor
		onceki_ay_kumulatif_gelir_vergisi_matrah = kumulatif_gelir;
		if(get_hr_salary.gross_net eq 0)
			ilk_salary_temp = salary;
		
		//2022 itibariyle asgari ücretin matrahı, gvm matrahından düşürülüyor ERU
		if(attributes.sal_year gte 2022 and attributes.statue_type_individual eq 0 and use_minimum_wage neq 1 and get_active_program_parameter.is_use_minimum_wage neq 1)
		{
			//aylık çalıştığı gün asgari ücret 
			daily_minimum_wage = ssk_asgari_ucret;		
			control_daily_minimum_wage = ssk_asgari_ucret;

			if(get_hr_ssk.use_ssk eq 2)
			{
				dmw_employee_contribution = daily_minimum_wage * ssk_isci_carpan / 100;//Asgari sgk işçi primi
				dmw_unemployment_workers_premium =  daily_minimum_wage * issizlik_isci_carpan / 100;//Asgari sgk işsizlik işçi primi
				daily_minimum_wage_base = daily_minimum_wage - dmw_employee_contribution - dmw_unemployment_workers_premium;//asgari ücret neti
			}
			else
			{
				daily_minimum_wage_base = daily_minimum_wage * 0.85;
			}
			
			daily_minimum_wage_stamp_tax = (daily_minimum_wage * get_active_program_parameter.STAMP_TAX_BINDE) / 1000;

			total_used_incoming_tax = wrk_round(daily_minimum_wage_base);
			total_used_stamp_tax = wrk_round(daily_minimum_wage);

			temp_daily_minimum_wage_base = daily_minimum_wage_base;
			temp_daily_minimum_wage = daily_minimum_wage;
			temp_daily_minimum_wage_stamp_tax = daily_minimum_wage_stamp_tax;
			old_wage = daily_minimum_wage_base - daily_minimum_wage_stamp_tax - (daily_minimum_wage_base * 15 / 100);

		}
		if(get_hr_salary.gross_net eq 1)/* net maaş ise brütü bul */
		{
			// ***** salary alarak buna uygun neti (net_ucret) ve brutu (salary) from netten bulalim

			if(ssk_days neq 0)
			{
				flag = true;
				count = 0;	

				this_net_ucret = salary;
				if(get_hr_salary.salary_type neq 0)
				{
					if(get_active_program_parameter.FULL_DAY eq 0 and get_hr_salary.salary_type eq 1 and daysinmonth(last_month_30) eq 31)
					{
						salary = maas_tutar_;
					}
					else if(get_active_program_parameter.FULL_DAY eq 0 and daysinmonth(last_month_30) eq 31 and ssk_days eq 31 and izin eq 0)
					{			
						salary = (maas_tutar_ * ssk_full_days)/30;
					}
					else if(get_active_program_parameter.FULL_DAY eq 0 and daysinmonth(last_month_30) eq 31 and ssk_days eq 31 and izin gt 0)
					{
						salary = (maas_tutar_ * ssk_days)/ssk_full_days;				
					}
					else if(get_active_program_parameter.FULL_DAY eq 0 and daysinmonth(last_month_30) eq 31 and ssk_days lt 31 and get_hr_salary.salary_type eq 2)
					{
						salary = (maas_tutar_ * ssk_days)/30;
					}
					else
					{
						//bordro akış parametrelerinden Şubatta (SGK gün)=(Çalışılan Gün) hayır işaretliyse ve günlük çalışan değilse(116442 ID'li iş için eklenmiştir. 23082019ERU)
						if(get_hr_salary.salary_type neq 1 and get_active_program_parameter.ssk_days_work_days eq 1)
							salary = (salary*ssk_days)/30;
						else if(get_hr_salary.salary_type neq 1)
							salary = (salary*ssk_days)/ssk_full_days;						
					}
				}
			
				first_salary_temp = salary;
				//yarim gunluk izinler gerekirse maastan düsülecek
				if(get_active_program_parameter.offtime_count_type eq 1 and get_half_offtimes.recordcount and len(get_half_offtimes_total_hour))
				{
					half_offtime_day_total = 0;
					if(get_hr_salary.salary_type eq 2)
						half_offtime_day_total_net = wrk_round(get_hr_salary.salary / get_hours.ssk_monthly_work_hours * get_half_offtimes_total_hour);
					else if(get_hr_salary.salary_type eq 1)
						half_offtime_day_total_net = wrk_round(get_hr_salary.salary / get_hours.ssk_work_hours * get_half_offtimes_total_hour);
					else
						half_offtime_day_total_net = wrk_round(get_hr_salary.salary * get_half_offtimes_total_hour);
				}
				else
				{
					half_offtime_day_total = 0;
					half_offtime_day_total_net = 0;
				}
				//yarim gunluk izinler gerekirse maastan düsülecek
				
				//abort('salary:#salary# half_offtime_day_total_net:#half_offtime_day_total_net# get_half_offtimes.total_hour:#get_half_offtimes.total_hour#');

				sal_temp = salary;
				devir_matrah_ = 0;
				salary_ilk = salary;
				ekten_gelen = 0;
					//bu islem sonradan iptal edilecek
					
					if(old_except lt yillik_toplam_asgari_ucret)
					{
						count = 1;
						is_salary = 1;
						while(flag)
						{
							count = count + 1;
							kontrol = salary;
							gelir_vergisi_matrah = kontrol;
							include 'get_hr_compass_tax.cfm';
							include 'get_hr_compass_formuls.cfm';
							include 'get_hr_compass_from_net.cfm';
							//	if (count gte 60 or sal_temp eq net_ucret)
							if (count gte 60 or sal_temp eq net_ucret  or wrk_round(sal_temp) eq net_ucret  or sal_temp eq wrk_round(net_ucret))
							{
								flag = false;
							}
							else if (net_ucret gt sal_temp)
								salary = kontrol - (net_ucret - sal_temp);
							else if (net_ucret lt sal_temp)
								salary = kontrol + (sal_temp - net_ucret);
						}
						

						if(wrk_round(sal_temp - net_ucret) eq 0.01)
						{
							salary = salary + 0.01;
							ssk_matrah = ssk_matrah + 0.01;
						}
						
						include 'get_hr_compass_tax_exception_osi.cfm';
						include 'get_hr_compass_tax_exception_bei.cfm';
						include 'get_hr_compass_tax_exception_boss.cfm';
						include 'get_hr_compass_tax_exception_hs.cfm';
						include 'get_hr_compass_tax_exception.cfm';
						gelir_vergisi_istisna_dusulecek = vergi_istisna;
						salary = salary_ilk;
						net_ucret = -1;
						sal_temp = salary_ilk;
						devir_matrah_ = 0;
						is_salary = 0;
						old_wage = daily_minimum_wage_base - daily_minimum_wage_stamp_tax - (daily_minimum_wage_base * tax_carpan);
						
					}
				//abort(salary);

			//bu islem sonradan iptal edilecek
			kumulatif_gelir = kumulatif_gelir - gelir_vergisi_istisna_dusulecek;
			//writeoutput('kumulatif_gelir1:#kumulatif_gelir#');
			vergi_istisna = 0;
			vergi_istisna_osi = 0;
			vergi_istisna_bei = 0;
			vergi_istisna_hs = 0;
			vergi_istisna_boss = 0;
			vergi_istisna_total = 0;

				if(not (get_hr_ssk.IS_TAX_FREE eq 1 and get_hr_ssk.IS_DAMGA_FREE eq 1 and get_hr_ssk.use_ssk eq 3))
				{
					flag = true;
					count = 0;
					sal_temp = salary;
					is_salary = 1;
					while(flag)
					{
						count = count + 1;
						kontrol = salary;
						gelir_vergisi_matrah = kontrol;
						include 'get_hr_compass_tax.cfm';
						include 'get_hr_compass_formuls.cfm';
						include 'get_hr_compass_from_net.cfm';
					//	if (count gte 60 or sal_temp eq net_ucret or wrk_round(sal_temp) eq net_ucret)
						if (count gte 60 or sal_temp eq net_ucret  or wrk_round(sal_temp) eq net_ucret  or sal_temp eq wrk_round(net_ucret))
						{
							flag = false;
						}
						else if (net_ucret gt sal_temp)
							salary = kontrol - (net_ucret - sal_temp);
						else if (net_ucret lt sal_temp)
							salary = kontrol + (sal_temp - net_ucret);
					}
					if(wrk_round(sal_temp - net_ucret) eq 0.01)
					{
					salary = salary + 0.01;
					}
					if(wrk_round(net_ucret - sal_temp) eq 0.01)
					{
					salary = salary - 0.01;
					}
					
					if( wrk_round(abs(numberFormat(salary,'0.0') - salary)) eq 0.01 and (get_hr_ssk.ssk_statute eq 2 or get_hr_ssk.ssk_statute eq 18) and daily_minimum_wage eq numberFormat(salary,'0.0'))
					{
						salary =  numberFormat(salary,'0.0');
					}

					if(half_offtime_day_total_net)//yarim mesailer maastan düsme durumu
						{
								salary_maas = wrk_round(salary);
								sal_temp = sal_temp - half_offtime_day_total_net;
								salary = sal_temp;
								count = 0;
								flag = true;
								while(flag)
								{
									count = count + 1;
									kontrol = salary;
									gelir_vergisi_matrah = kontrol;
									include 'get_hr_compass_tax.cfm';
									include 'get_hr_compass_formuls.cfm';
									include 'get_hr_compass_from_net.cfm';
									if (count gte 60 or sal_temp eq net_ucret or wrk_round(sal_temp) eq net_ucret)
										flag = false;
									else if (net_ucret gt sal_temp)
										salary = kontrol - (net_ucret - sal_temp);
									else if (net_ucret lt sal_temp)
										salary = kontrol + (sal_temp - net_ucret);
								}
								half_offtime_day_total = salary_maas - salary;
						}
					else
						salary = wrk_round(salary);
					
					is_salary = 0;
					old_wage = daily_minimum_wage_base - daily_minimum_wage_stamp_tax - (daily_minimum_wage_base * tax_carpan);
				}			

				devir_matrah_ = salary;
				odenek_oncesi_kumulatif_gelir = kumulatif_gelir+gelir_vergisi_istisna_dusulecek;
				odenek_oncesi_toplam = salary;
				odenek_oncesi_gelir_vergisi_matrah = gelir_vergisi_matrah;
				if(gelir_vergisi_matrah eq 0)
					odenek_oncesi_gelir_vergisi_matrah = odenek_oncesi_gelir_vergisi_matrah + temp_gelir_vergisi_matrah;
				//writeoutput("temp_gelir_vergisi_matrah  : #gelir_vergisi_matrah# + #temp_gelir_vergisi_matrah#")
				odenek_oncesi_gelir_vergisi = gelir_vergisi;
				odenek_oncesi_damga_vergisi = damga_vergisi;
				ilk_sal_temp = sal_temp;
				ilk_salary = salary;
				
				kumulatif_gelir = kumulatif_gelir + gelir_vergisi_istisna_dusulecek;
				//abort('kumulatif_gelir2:#kumulatif_gelir#');
				gelir_vergisi_istisna_dusulecek = 0;
				if(arraylen(puantaj_exts))
					{
						for(ccm=1;ccm lte arraylen(puantaj_exts);ccm=ccm+1)
							if(puantaj_exts[ccm][6] eq 2)
								puantaj_exts[ccm][6] = -2;
					}
				// vergi istisna tipi neden bu şekilde -2 olarak atılmış SG20150307 87430 idli iş
			}
			else
			{
				devir_matrah_ = 0;
				damga_vergisi = 0;
				gelir_vergisi_matrah = 0;
				odenek_oncesi_kumulatif_gelir = kumulatif_gelir;
				odenek_oncesi_toplam = 0;
				odenek_oncesi_gelir_vergisi_matrah = 0;
				odenek_oncesi_gelir_vergisi = 0;
				odenek_oncesi_damga_vergisi = 0;
				ilk_sal_temp = 0;
				ilk_salary = 0;
				net_ucret = 0; //net ucretlı sgk gunu 0 gelen calisanlar icin eklendi GSO 20150602
			}
			//writeoutput("1 net_ucret:#net_ucret#<br>");
			net_ucret_temp = net_ucret;
			salary_temp = salary;
			kumulatif_gelir_temp = kumulatif_gelir;
			maas_brutu_ = salary;
			brut_maas = salary;
			// *****bazi durumlar icin 10 adim yetmeyebiliyor ornek : net uzerinden 11200 alan bir emekli ***** 
			/*kontrol amacli buradaki net_ucret sadece bulmak istedigimiz rakami bulup bulmadigimiza bakmak icin
			gercek net ucret ; brut dosyasinin (get_hr_compass_from_brut.cfm) en altindadir */
			/* net odenekleri brut hale gelsin ve bunlardan sonra from_brut hesabina girsin */
			ekten_gelen = 0;

			ssk_matraha_dahil_olmayan_odenek_tutar_1 = ssk_matraha_dahil_olmayan_odenek_tutar;
			vergi_matraha_dahil_olmayan_odenek_tutar_1 = vergi_matraha_dahil_olmayan_odenek_tutar;

			ssk_matraha_dahil_olmayan_odenek_tutar = 0;
			vergi_matraha_dahil_olmayan_odenek_tutar = 0;
			if(attributes.sal_year gte 2022 and attributes.statue_type_individual eq 0 and use_minimum_wage neq 1 and get_active_program_parameter.is_use_minimum_wage neq 1)
			{
				//aylık çalıştığı gün asgari ücret 
				daily_minimum_wage = ssk_asgari_ucret;		
				control_daily_minimum_wage = ssk_asgari_ucret;
	
				if(get_hr_ssk.use_ssk eq 2)
				{
					dmw_employee_contribution = daily_minimum_wage * ssk_isci_carpan / 100;//Asgari sgk işçi primi
					dmw_unemployment_workers_premium =  daily_minimum_wage * issizlik_isci_carpan / 100;//Asgari sgk işsizlik işçi primi
					daily_minimum_wage_base = daily_minimum_wage - dmw_employee_contribution - dmw_unemployment_workers_premium;//asgari ücret neti
				}
				else
				{
					daily_minimum_wage_base = daily_minimum_wage * 0.85;
				}
				
				daily_minimum_wage_stamp_tax = (daily_minimum_wage * get_active_program_parameter.STAMP_TAX_BINDE) / 1000;

				total_used_incoming_tax = wrk_round(daily_minimum_wage_base);
				total_used_stamp_tax = wrk_round(daily_minimum_wage);
	
				temp_daily_minimum_wage_base = daily_minimum_wage_base;
				temp_daily_minimum_wage = daily_minimum_wage;
				temp_daily_minimum_wage_stamp_tax = daily_minimum_wage_stamp_tax;
		
			}
			if(total_pay_ssk_tax_net gt 0)
			{
				/*
				tutar_ = total_pay_ssk_tax_net;
				is_mesai_ = 0;
				is_izin_ = 0;
				is_tax_ = 1;
				is_ssk_ = 1;
				is_issizlik_ = 1;
				include 'get_hr_compass_from_net_odenek.cfm';
				ekten_gelen = ekten_gelen + eklenen;
				*/
				
				onceki_ssk_tax_net_odenek = 0;
				
				from_net = 0;
				for (i_ek_od=1; i_ek_od lte arraylen(puantaj_exts); i_ek_od = i_ek_od+1)
				{
					if(puantaj_exts[i_ek_od][6] eq 0 and puantaj_exts[i_ek_od][9] neq 1)//net odenekler
					{						
							if(puantaj_exts[i_ek_od][4] eq 2 and puantaj_exts[i_ek_od][5] eq 2 and puantaj_exts[i_ek_od][13] eq 1 and puantaj_exts[i_ek_od][14] eq 1)
							{
								ssk_matraha_dahil_olmayan_odenek_tutar = 0;
								vergi_matraha_dahil_olmayan_odenek_tutar = 0;

								if(arraylen(puantaj_exts[i_ek_od]) gte 40 and len(puantaj_exts[i_ek_od][40]))
								{
									muafiyet_ = puantaj_exts[i_ek_od][40];
									ssk_matraha_dahil_olmayan_odenek_tutar =  puantaj_exts[i_ek_od][40];
								}
							
								if(arraylen(puantaj_exts[i_ek_od]) gte 41 and len(puantaj_exts[i_ek_od][41]))
									vergi_matraha_dahil_olmayan_odenek_tutar =  puantaj_exts[i_ek_od][41];

									if(get_pay_salary.METHOD_PAY[i_ek_od] eq 2 and get_pay_salary.FROM_SALARY[i_ek_od] eq 0 and len(get_pay_salary.MULTIPLIER[i_ek_od]) and get_pay_salary.MULTIPLIER[i_ek_od] neq 0)
									{
										/*
										Ödenek aylık maaş üzerinden seçiliyse;
										Eğer çalışana net ödenek tanımlandıysa ve ücret brütse ücretin  neti  üzerinden çarpana göre orantılanıyor. 
										*/
										temp_total_net = net_ucret;
										if(wrk_round(sal_temp - net_ucret) eq 0.01)
											temp_total_net = net_ucret + 0.01;
										else if(wrk_round(net_ucret - sal_temp) eq 0.01)
											temp_total_net = net_ucret - 0.01;
										tutar_ = wrk_round(temp_total_net - asgari_gecim_indirimi_) * get_pay_salary.MULTIPLIER[i_ek_od];
										
										from_net_wage = 1;
									}
									else
										tutar_ = puantaj_exts[i_ek_od][3];
								is_ssk_tax_net_odenek = 1;
								odenek_sira =  i_ek_od;
								is_mesai_ = 0;
								is_izin_ = 0;
								is_tax_ = 1;
								is_ssk_ = 1;
								is_issizlik_ = 1;
								include 'get_hr_compass_from_net_odenek.cfm';
								is_ssk_tax_net_odenek = 0;
								ekten_gelen = ekten_gelen + eklenen;
						}
						
					}
				}			
			}
			ssk_matraha_dahil_olmayan_odenek_tutar = 0;
			vergi_matraha_dahil_olmayan_odenek_tutar = 0;
			
			
			for (i_ek_od=1; i_ek_od lte arraylen(puantaj_exts); i_ek_od = i_ek_od+1)
			{
				if(puantaj_exts[i_ek_od][4] eq 2 and puantaj_exts[i_ek_od][5] eq 2 and puantaj_exts[i_ek_od][13] eq 1 and puantaj_exts[i_ek_od][14] eq 1)
				{
					if(arraylen(puantaj_exts[i_ek_od]) gte 40 and len(puantaj_exts[i_ek_od][40]))
					{
						ssk_matraha_dahil_olmayan_odenek_tutar =  ssk_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][40];
					}
				
					if(arraylen(puantaj_exts[i_ek_od]) gte 41 and len(puantaj_exts[i_ek_od][41]))
						vergi_matraha_dahil_olmayan_odenek_tutar =  vergi_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][41];
				}
				else if(puantaj_exts[i_ek_od][4] eq 2 and puantaj_exts[i_ek_od][5] eq 1 and puantaj_exts[i_ek_od][13] eq 1 and puantaj_exts[i_ek_od][14] eq 1)
				{
					if(arraylen(puantaj_exts[i_ek_od]) gte 40 and len(puantaj_exts[i_ek_od][40]))
					{
						ssk_matraha_dahil_olmayan_odenek_tutar =  ssk_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][40];
					}
				}
				else if(puantaj_exts[i_ek_od][4] eq 1 and puantaj_exts[i_ek_od][5] eq 2 and puantaj_exts[i_ek_od][13] eq 1 and puantaj_exts[i_ek_od][14] eq 0)
				{
					if(arraylen(puantaj_exts[i_ek_od]) gte 41 and len(puantaj_exts[i_ek_od][41]))
						vergi_matraha_dahil_olmayan_odenek_tutar =  vergi_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][41];
				}

				
				//Kesinti Brüt ücretten kesilsin işaretliyse 31052022ERU
				if(puantaj_exts[i_ek_od][6] eq 1 and puantaj_exts[i_ek_od][9] eq 1 and puantaj_exts[i_ek_od][33] eq 1 and puantaj_exts[i_ek_od][49] eq 1)
				{
					temp_ozel_kesinti_2 = temp_ozel_kesinti_2 + puantaj_exts[i_ek_od][8];
					if(get_hr_salary.salary_type eq 0)
					{
						interruption_hour = brut_maas;
						interruption_day = brut_maas * 7.5;
						interruption_month = brut_maas * 225;
					}
					else if(get_hr_salary.salary_type eq 1)
					{
						interruption_hour = brut_maas / 7.5;
						interruption_day = brut_maas;
						interruption_month = brut_maas * 30;
					}
					else if(get_hr_salary.salary_type eq 2)
					{
						interruption_hour = brut_maas / 225;
						interruption_day = brut_maas / 30;
						interruption_month = brut_maas;
					}
					if(puantaj_exts[i_ek_od][2] eq 5)
						interruption_amount = interruption_month;
					else if(puantaj_exts[i_ek_od][2] eq 3)
						interruption_amount = interruption_day;
					else if(puantaj_exts[i_ek_od][2] eq 4)
						interruption_amount = interruption_hour;
					else
						interruption_amount = interruption_month;

					
					if (puantaj_exts[i_ek_od][7] eq 1)
					{
						puantaj_exts[i_ek_od][8] = ( (((interruption_amount/ssk_full_days)/100)*puantaj_exts[i_ek_od][3]));
						
					}
					else if (puantaj_exts[i_ek_od][7] eq 2)
					{
						
						puantaj_exts[i_ek_od][8] = ( (((interruption_amount/ssk_days)/100)*puantaj_exts[i_ek_od][3]) * fiili_gun_);
					}
					else
					{
						puantaj_exts[i_ek_od][8] = ((interruption_amount/100)*puantaj_exts[i_ek_od][3]/ssk_full_days);	writeoutput("vvv");
					}

					ozel_kesinti_2_brut = ozel_kesinti_2_brut + puantaj_exts[i_ek_od][8];
					
				}
			}
			if(ozel_kesinti_2_brut gt 0)
				ozel_kesinti_2 = ozel_kesinti_2 - temp_ozel_kesinti_2;	

			if(total_pay_ssk_net gt 0)
			{
				tutar_ = total_pay_ssk_net;
				is_mesai_ = 0;
				is_izin_ = 0;
				is_tax_ = 0;
				is_ssk_ = 1;
				is_ssk_tax_net_odenek = 0;
				is_issizlik_ = 1;
				include 'get_hr_compass_from_net_odenek.cfm';
				ekten_gelen = ekten_gelen + eklenen;
			}

			if(total_pay_ssk_tax_net_noissizlik gt 0)
			{
				tutar_ = total_pay_ssk_tax_net_noissizlik;
				is_mesai_ = 0;
				is_izin_ = 0;
				is_tax_ = 1;
				is_ssk_ = 1;
				is_issizlik_ = 0;
				is_ssk_tax_net_odenek = 0;
				include 'get_hr_compass_from_net_odenek.cfm';
				ekten_gelen = ekten_gelen + eklenen;
			}

			if(total_pay_ssk_net_noissizlik gt 0)
			{
				tutar_ = total_pay_ssk_net_noissizlik;
				is_tax_ = 0;
				is_izin_ = 0;
				is_ssk_ = 1;
				is_issizlik_ = 0;
				is_ssk_tax_net_odenek = 0;
				include 'get_hr_compass_from_net_odenek.cfm';
				ekten_gelen = ekten_gelen + eklenen;
			}	

			if(total_pay_tax_net gt 0)
			{
				tutar_ = total_pay_tax_net;
				is_mesai_ = 0;
				is_izin_ = 0;
				is_tax_ = 1;
				is_ssk_ = 0;
				is_issizlik_ = 0;
				is_ssk_tax_net_odenek = 0;
				include 'get_hr_compass_from_net_odenek.cfm';
				ekten_gelen = ekten_gelen + eklenen;
			}

			
			

			if(total_pay_d_net gt 0)
			{
				tutar_ = total_pay_d_net;
				is_mesai_ = 0;
				is_izin_ = 0;
				is_tax_ = 0;
				is_ssk_ = 0;
				is_ssk_tax_net_odenek = 0;
				include 'get_hr_compass_from_net_odenek.cfm';
			}			

			if(ssk_days)	
			{
				if (get_hr_salary.salary_type eq 2) // ay
					hourly_salary = this_net_ucret / get_hours.ssk_monthly_work_hours;
				else if (get_hr_salary.salary_type eq 1) //gün
					hourly_salary = gunluk_ / get_hours.ssk_work_hours;
				else if (get_hr_salary.salary_type eq 0)//saat
					hourly_salary = saatlik_ucret;

				if(get_hr_salary.salary_type eq 0)
					total_days_ = work_days;
				else if(get_hr_salary.salary_type eq 1)
					total_days_ = work_days;
				else if (get_hr_salary.salary_type eq 2)
					total_days_ = ssk_days;

				if(total_days_ + offdays_count eq 31 and total_days_ eq 30)
					work_days_total = 30;
				else if(total_days_ + offdays_count lt 31)
					work_days_total =  total_days_;
				else if(total_days_ eq 31)
				{
					work_days_total = total_days_;
				}
				else if(offdays_count eq 0)
					work_days_total = 30;
				else
					work_days_total = total_days_;
					
				total_work_hour = ((work_days_total) * get_hours.ssk_work_hours) - half_time_hour;	
				hourly_salary_brut = salary_temp / total_work_hour;
			}
			else
			{
				hourly_salary = 0;
				hourly_salary_brut = 0;
			}

			/*if(included_in_tax_hour_paid gt 0 and get_hr_ssk.IS_TAX_FREE eq 1 and get_hr_ssk.IS_DAMGA_FREE eq 1)
			{
				included_in_tax_paid_amount = included_in_tax_hour_paid * hourly_salary_brut;
			}*/
			
			//ilk maas net_ucreti bulunur
			net_ucret = net_ucret_temp;
			salary = salary_temp;
			kumulatif_gelir = kumulatif_gelir_temp;
			brut_salary = salary;
			ext_salary_1 = ext_salary;
			ext_salary = 0;
			ext_salary_diff = 0;
			ext_salary_gross = 0;
			ozel_kesinti_1 = ozel_kesinti;
			ozel_kesinti = 0; 
			ozel_kesinti_2_ = ozel_kesinti_2;
			ozel_kesinti_2 = 0; 
			//odenek sifirlama sonra geri alinacak
			total_pay_ssk_tax_1 = total_pay_ssk_tax;
			total_pay_tax_1 = total_pay_tax;
			total_pay_ssk_noissizlik_1 = total_pay_ssk_noissizlik;
			total_pay_1 = total_pay;
			total_pay_ssk_tax_noissizlik_1 = total_pay_ssk_tax_noissizlik;
			total_pay_d_1 = total_pay_d;
			total_pay_ssk_1 = total_pay_ssk;

			ssk_matraha_dahil_olmayan_odenek_tutar_1 = ssk_matraha_dahil_olmayan_odenek_tutar;
			vergi_matraha_dahil_olmayan_odenek_tutar_1 = vergi_matraha_dahil_olmayan_odenek_tutar;

			ssk_matraha_dahil_olmayan_odenek_tutar = 0;
			vergi_matraha_dahil_olmayan_odenek_tutar = 0;

			yillik_izin_amount_1 = attributes.yillik_izin_amount;
			kidem_amount_1 = attributes.kidem_amount;
			ihbar_amount_1 = attributes.ihbar_amount;
			total_pay_ssk_tax = 0;
			total_pay_tax = 0;
			total_pay_ssk_noissizlik = 0;
			total_pay = 0;
			total_pay_ssk_tax_noissizlik = 0;
			total_pay_d = 0;
			total_pay_ssk = 0;
			attributes.yillik_izin_amount = 0;
			attributes.kidem_amount = 0;
			attributes.ihbar_amount = 0;
			//odenek sifirlama sonra geri alinacak
			a_g_m_ = asgari_gecim_max_tutar_;
			net_ucret_kontrol = 1;
			is_devir_matrah_off = 1;
			from_net = 1;
			include 'get_hr_compass_from_brut.cfm';
			from_net = 0;
			is_devir_matrah_off = 0;
			net_ucret_kontrol = 0;
			asgari_gecim_max_tutar_ = a_g_m_;
			salary = brut_salary;
			ext_salary = ext_salary_1;
			ozel_kesinti = ozel_kesinti_1;
			ozel_kesinti_2 = ozel_kesinti_2_;
			maas_net_ucreti_ = net_ucret;

			//Çalışan Memursa
			if(use_ssk eq 2 and unpaid_offtime eq 0)
			{
				bes_isci_hissesi =  fix(wrk_round(sgk_base/100) * bes_isci_carpan );
				//Net Maaş Tutarı - Aile Yardımı Tutarı - Çocuk Yardımı Tutarı – Toplu Sözleşme İkramiyesi – Nafaka Tutarı + Sendika Kesintisi + Bireysel Emeklilik Kesintisi + Lojman Kesintisi + Kişi Borcu + Kefalet Kesintis
				maas_net_ucreti_ = officer_total_salary - (gelir_vergisi + damga_vergisi + retirement_allowance_5510  + retirement_allowance_personal_5510 + retirement_allowance + 
				retirement_allowance_personal + plus_retired + health_insurance_premium_5510 + general_health_insurance + health_insurance_premium_personal_5510 + bes_isci_hissesi + ozel_kesinti + ozel_kesinti_2 + avans + vergi_istisna_total + family_assistance + child_assistance + collective_agreement_bonus + penance_deduction);
			}
			else if(use_ssk eq 2 and unpaid_offtime neq 0)
			{
				bes_isci_hissesi = 0;
				maas_net_ucreti_ = 0;
			}
			
			maas_gelir_vergisi_ = gelir_vergisi;
			maas_damga_vergisi_ = damga_vergisi;
			maas_ssk_isveren_hissesi_ = ssk_isveren_hissesi;
			maas_ssk_isci_hissesi_ = ssk_isci_hissesi;
			maas_ssk_isveren_issizlik_ = issizlik_isveren_hissesi;
			maas_ssk_isci_issizlik_ = issizlik_isci_hissesi;
			salary_ssk_isveren_hissesi_5746 = ssk_isveren_hissesi_5746;
			//ilk maas net_ucreti bulunur
			
			if(isdefined("kisa_calisma") and kisa_calisma eq 1)
			{
				short_working_calc = salary;
				kisa_calisma = 0;
				if(isdefined("toplam_calisma_gunu") and len(toplam_calisma_gunu) and toplam_calisma_gunu neq 0)
				ssk_days = toplam_calisma_gunu;
			}
			ext_salary_net = ext_salary;
	
			if(total_pay_net gt 0)
			{
				total_pay = total_pay + total_pay_net;
				is_izin_ = 0;
			}
			if (len(get_hr_ssk.fazla_mesai_saat) and isnumeric(get_hr_ssk.fazla_mesai_saat) and get_hr_ssk.fazla_mesai_saat neq 0)
			{
				/*saat olarak tam kismi alinir*/
				if(ext_total_hours_0 neq ext_total_hours_3)
				{
					ext_total_hours_0 = ext_total_hours_0 + (ssk_days*get_hr_ssk.fazla_mesai_saat) \ ssk_full_days;
					ext_salary_net = ext_salary_net + (ext_total_hours_0 * (get_active_program_parameter.EX_TIME_PERCENT_HIGH/100) * hourly_salary);
				}
				else
				{
					ext_total_hours_in_out = (ssk_days*get_hr_ssk.fazla_mesai_saat) \ ssk_full_days;
					ext_salary_net = ext_salary_net + (ext_total_hours_in_out * (get_active_program_parameter.EX_TIME_PERCENT_HIGH/100) * hourly_salary);
					ext_total_hours_0 = ext_total_hours_in_out + ext_total_hours_0;
				}
			}

			if(len(get_active_program_parameter.WEEKEND_MULTIPLIER))
				ext_salary_net = ext_salary_net + (ext_total_hours_1 * get_active_program_parameter.WEEKEND_MULTIPLIER * hourly_salary);
			else
				ext_salary_net = ext_salary_net + (ext_total_hours_1 * get_active_program_parameter.EX_TIME_PERCENT_HIGH / 100 * hourly_salary);
			
			if(len(get_active_program_parameter.OFFICIAL_MULTIPLIER))	
				ext_salary_net = ext_salary_net + (ext_total_hours_2 * hourly_salary * get_active_program_parameter.OFFICIAL_MULTIPLIER);
			else
				ext_salary_net = ext_salary_net + (ext_total_hours_2 * hourly_salary);
			ext_salary_net = ext_salary_net + (ext_total_hours_3 * (get_active_program_parameter.EX_TIME_PERCENT_HIGH/100) * hourly_salary);// 45 saati asan kisim
			ext_salary_net = ext_salary_net + (ext_total_hours_4 * (get_active_program_parameter.EX_TIME_PERCENT/100) * hourly_salary);// 45 saate kadar kisim
			if(len(get_active_program_parameter.NIGHT_MULTIPLIER))
				ext_salary_net = ext_salary_net + (ext_total_hours_5 * get_active_program_parameter.NIGHT_MULTIPLIER * hourly_salary);
			else
				ext_salary_net = ext_salary_net + (ext_total_hours_5 * (10 / 100) * hourly_salary);

				 //---Muzaffer Bas-----	
			if(len(get_active_program_parameter.WEEKEND_DAY_MULTIPLIER))
				ext_salary_net = ext_salary_net + (ext_total_hours_8 * get_active_program_parameter.WEEKEND_DAY_MULTIPLIER * hourly_salary);
			else
				ext_salary_net = ext_salary_net + (ext_total_hours_8 * get_active_program_parameter.EX_TIME_PERCENT_HIGH / 100 * hourly_salary);
			if(len(get_active_program_parameter.AKDI_DAY_MULTIPLIER))
				ext_salary_net = ext_salary_net + (ext_total_hours_9 * get_active_program_parameter.AKDI_DAY_MULTIPLIER * hourly_salary);
			else
				ext_salary_net = ext_salary_net + (ext_total_hours_9 * get_active_program_parameter.EX_TIME_PERCENT_HIGH / 100 * hourly_salary);
			if(len(get_active_program_parameter.OFFICIAL_DAY_MULTIPLIER))
				ext_salary_net = ext_salary_net + (ext_total_hours_10 * get_active_program_parameter.OFFICIAL_DAY_MULTIPLIER * hourly_salary);
			else
				ext_salary_net = ext_salary_net + (ext_total_hours_10 * get_active_program_parameter.EX_TIME_PERCENT_HIGH / 100 * hourly_salary);
			if(len(get_active_program_parameter.ARAFE_DAY_MULTIPLIER))
				ext_salary_net = ext_salary_net + (ext_total_hours_11 * get_active_program_parameter.ARAFE_DAY_MULTIPLIER * hourly_salary);
			else
				ext_salary_net = ext_salary_net + (ext_total_hours_11 * get_active_program_parameter.EX_TIME_PERCENT_HIGH / 100 * hourly_salary);
			if(len(get_active_program_parameter.DINI_DAY_MULTIPLIER))
				ext_salary_net = ext_salary_net + (ext_total_hours_12 * get_active_program_parameter.DINI_DAY_MULTIPLIER * hourly_salary);
			else
				ext_salary_net = ext_salary_net + (ext_total_hours_12 * get_active_program_parameter.EX_TIME_PERCENT_HIGH / 100 * hourly_salary);
				//---Muzaffer Bit-----	
			
			onceki_odenek_netleri_toplam = 0;
			onceki_odenek_gelir_toplam = 0;
			onceki_odenek_damga_toplam = 0;
			onceki_odenek_isveren_toplam = 0;
			onceki_odenek_isci_toplam = 0;
			onceki_odenek_isveren_issizlik_toplam = 0;
			onceki_odenek_isci_issizlik_toplam = 0;
			//tum odenekleri ayrı al
			for (i_ek_od=1; i_ek_od lte arraylen(puantaj_exts); i_ek_od = i_ek_od+1)
			{	
				from_net = 1;	
				is_total_calc = 0;
				is_brut_payment = 1;
				if(puantaj_exts[i_ek_od][6] eq 0 and puantaj_exts[i_ek_od][9] eq 1)//brut odenekler
				{	
					//tüm hepsi muaf değil
					if(puantaj_exts[i_ek_od][4] eq 2 and puantaj_exts[i_ek_od][5] eq 2 and puantaj_exts[i_ek_od][13] eq 1 and puantaj_exts[i_ek_od][14] eq 1)
					{
						if((puantaj_exts[i_ek_od][7] eq 1 or puantaj_exts[i_ek_od][7] eq 2) and puantaj_exts[i_ek_od][8] neq 0)
						{
							total_pay_ssk_tax = total_pay_ssk_tax + puantaj_exts[i_ek_od][8];
							if(puantaj_exts[i_ek_od][33] eq 1)
								ssk_odenek_dahil_brut = ssk_odenek_dahil_brut + puantaj_exts[i_ek_od][8];
							
						}
						else
						{
							total_pay_ssk_tax = total_pay_ssk_tax + puantaj_exts[i_ek_od][3];
							if(puantaj_exts[i_ek_od][33] eq 1)
								ssk_odenek_dahil_brut = ssk_odenek_dahil_brut + puantaj_exts[i_ek_od][3];
						}
						if(arraylen(puantaj_exts[i_ek_od]) gte 40 and len(puantaj_exts[i_ek_od][40]))
							ssk_matraha_dahil_olmayan_odenek_tutar =  ssk_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][40];
						
						if(arraylen(puantaj_exts[i_ek_od]) gte 41 and len(puantaj_exts[i_ek_od][41]))
							vergi_matraha_dahil_olmayan_odenek_tutar = vergi_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][41];

						brut_salary = salary;
						a_g_m_ = asgari_gecim_max_tutar_;
						ozel_kesinti_ = ozel_kesinti;
						ozel_kesinti = 0; 
						ozel_kesinti_2_ = ozel_kesinti_2;
						ozel_kesinti_2 = 0; 	
						is_payment_exemption = 1;
						include 'get_hr_compass_from_brut.cfm';
						is_payment_exemption = 0;
						ozel_kesinti = ozel_kesinti_;
						ozel_kesinti_2 = ozel_kesinti_2_;
						asgari_gecim_max_tutar_ = a_g_m_;
						salary = brut_salary;
						this_ek_ucret_net = net_ucret - maas_net_ucreti_  - onceki_odenek_netleri_toplam; //+ ozel_kesinti
						this_ek_ucret_gelir = gelir_vergisi - maas_gelir_vergisi_ - onceki_odenek_gelir_toplam;
						this_ek_ucret_damga = damga_vergisi - maas_damga_vergisi_ - onceki_odenek_damga_toplam;
						this_ek_ucret_isveren = ssk_isveren_hissesi - maas_ssk_isveren_hissesi_ - onceki_odenek_isveren_toplam;
						this_ek_ucret_isci = ssk_isci_hissesi - maas_ssk_isci_hissesi_ - onceki_odenek_isci_toplam;
						this_ek_ucret_isveren_issizlik = issizlik_isveren_hissesi - maas_ssk_isveren_issizlik_ - onceki_odenek_isveren_issizlik_toplam;
						this_ek_ucret_isci_issizlik = issizlik_isci_hissesi - maas_ssk_isci_issizlik_ - onceki_odenek_isci_issizlik_toplam;
						onceki_odenek_gelir_toplam = onceki_odenek_gelir_toplam + this_ek_ucret_gelir;
						onceki_odenek_damga_toplam = onceki_odenek_damga_toplam + this_ek_ucret_damga;
						onceki_odenek_isveren_toplam = onceki_odenek_isveren_toplam + this_ek_ucret_isveren;
						onceki_odenek_isci_toplam = onceki_odenek_isci_toplam + this_ek_ucret_isci;
						onceki_odenek_isveren_issizlik_toplam = onceki_odenek_isveren_issizlik_toplam + this_ek_ucret_isveren_issizlik;
						onceki_odenek_isci_issizlik_toplam = onceki_odenek_isci_issizlik_toplam + this_ek_ucret_isci_issizlik;
						if((ArrayIsDefined(puantaj_exts[i_ek_od],33) and puantaj_exts[i_ek_od][33] eq 1) or (ArrayIsDefined(puantaj_exts[i_ek_od],32) and puantaj_exts[i_ek_od][32] neq 1))
							puantaj_exts[i_ek_od][15] = this_ek_ucret_net;
						else if(ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7] neq 0 and get_hr_salary.gross_net eq 0)
							puantaj_exts[i_ek_od][15] = puantaj_exts[i_ek_od][15]/30*ssk_days;
						if(ArrayIsDefined(puantaj_exts[i_ek_od],15))
							onceki_odenek_netleri_toplam = onceki_odenek_netleri_toplam + puantaj_exts[i_ek_od][15];
						puantaj_exts[i_ek_od][22] = this_ek_ucret_isveren;
						puantaj_exts[i_ek_od][23] = this_ek_ucret_isveren_issizlik;
						puantaj_exts[i_ek_od][24] = this_ek_ucret_isci;
						puantaj_exts[i_ek_od][25] = this_ek_ucret_isci_issizlik;
						puantaj_exts[i_ek_od][26] = this_ek_ucret_gelir;
						puantaj_exts[i_ek_od][27] = this_ek_ucret_damga;
						
						if(ArrayIsDefined(puantaj_exts[i_ek_od],43) and puantaj_exts[i_ek_od][43] eq 1)
						{
							rd_dahil_olan_gelir_vergisi = rd_dahil_olan_gelir_vergisi + this_ek_ucret_gelir;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir;
							}
						}
						else
						{
							rd_dahil_olmayan_gelir_vergisi = rd_dahil_olmayan_gelir_vergisi + this_ek_ucret_gelir;	
						}
						
						if(ArrayIsDefined(puantaj_exts[i_ek_od],42) and puantaj_exts[i_ek_od][42] eq 1)
						{
							rd_dahil_olan_damga_vergisi = rd_dahil_olan_damga_vergisi + this_ek_ucret_damga;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga;
							}
						}
						else
						{
							rd_dahil_olmayan_damga_vergisi = rd_dahil_olmayan_damga_vergisi + this_ek_ucret_damga;	
						}
						
						if(ArrayIsDefined(puantaj_exts[i_ek_od],44) and puantaj_exts[i_ek_od][44] eq 1)
						{
							rd_dahil_olan_ssk_isveren_hissesi = rd_dahil_olan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren;
							}
						}
						else
						{
							rd_dahil_olmayan_ssk_isveren_hissesi = rd_dahil_olmayan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							//abort('rd_dahil_olmayan_ssk_isveren_hissesi:#rd_dahil_olmayan_ssk_isveren_hissesi# ssk_matraha_dahil_olmayan_odenek_tutar:#ssk_matraha_dahil_olmayan_odenek_tutar#');
							if(this_ek_ucret_isveren gt 0 and ArrayIsDefined(puantaj_exts[i_ek_od],3) )
								rd_dahil_olmayan_ssk_matrah = rd_dahil_olmayan_ssk_matrah + puantaj_exts[i_ek_od][3];
						}
					}
					else if(get_pay_salary.ssk[i_ek_od] eq 1 and get_pay_salary.tax[i_ek_od] eq 1 and get_pay_salary.IS_DAMGA[i_ek_od] eq 0 and get_pay_salary.IS_ISSIZLIK[i_ek_od] eq 0)
					{
						if((ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7] eq 1 or puantaj_exts[i_ek_od][7] eq 2) and puantaj_exts[i_ek_od][8] neq 0)
							total_pay = total_pay + puantaj_exts[i_ek_od][8];
						else
							total_pay = total_pay + puantaj_exts[i_ek_od][3];
						brut_salary = salary;
						a_g_m_ = asgari_gecim_max_tutar_;
						ozel_kesinti_ = ozel_kesinti;
						ozel_kesinti = 0; 
						ozel_kesinti_2_ = 0;
						include 'get_hr_compass_from_brut.cfm';
						ozel_kesinti = ozel_kesinti_; 
						ozel_kesinti_2 = ozel_kesinti_2_;
						asgari_gecim_max_tutar_ = a_g_m_;
						salary = brut_salary;
						
						this_ek_ucret_net = net_ucret - maas_net_ucreti_  - onceki_odenek_netleri_toplam; //+ ozel_kesinti
						this_ek_ucret_gelir = gelir_vergisi - maas_gelir_vergisi_ - onceki_odenek_gelir_toplam;
						
						this_ek_ucret_damga = damga_vergisi - maas_damga_vergisi_ - onceki_odenek_damga_toplam;
						this_ek_ucret_isveren = ssk_isveren_hissesi - maas_ssk_isveren_hissesi_ - onceki_odenek_isveren_toplam;
						this_ek_ucret_isci = ssk_isci_hissesi - maas_ssk_isci_hissesi_ - onceki_odenek_isci_toplam;
						this_ek_ucret_isveren_issizlik = issizlik_isveren_hissesi - maas_ssk_isveren_issizlik_ - onceki_odenek_isveren_issizlik_toplam;
						this_ek_ucret_isci_issizlik = issizlik_isci_hissesi - maas_ssk_isci_issizlik_ - onceki_odenek_isci_issizlik_toplam;
						
						onceki_odenek_netleri_toplam = onceki_odenek_netleri_toplam + this_ek_ucret_net;
						onceki_odenek_gelir_toplam = onceki_odenek_gelir_toplam + this_ek_ucret_gelir;
						onceki_odenek_damga_toplam = onceki_odenek_damga_toplam + this_ek_ucret_damga;
						onceki_odenek_isveren_toplam = onceki_odenek_isveren_toplam + this_ek_ucret_isveren;
						onceki_odenek_isci_toplam = onceki_odenek_isci_toplam + this_ek_ucret_isci;
						onceki_odenek_isveren_issizlik_toplam = onceki_odenek_isveren_issizlik_toplam + this_ek_ucret_isveren_issizlik;
						onceki_odenek_isci_issizlik_toplam = onceki_odenek_isci_issizlik_toplam + this_ek_ucret_isci_issizlik;
						
						if((ArrayIsDefined(puantaj_exts[i_ek_od],33)and puantaj_exts[i_ek_od][33] eq 1) or (ArrayIsDefined(puantaj_exts[i_ek_od],32) and puantaj_exts[i_ek_od][32] neq 1))
							puantaj_exts[i_ek_od][15] = this_ek_ucret_net;
						else if(ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7]  neq 0 and get_hr_salary.gross_net eq 0)
							puantaj_exts[i_ek_od][15] = puantaj_exts[i_ek_od][15]/30*ssk_days;
						puantaj_exts[i_ek_od][22] = this_ek_ucret_isveren;
						puantaj_exts[i_ek_od][23] = this_ek_ucret_isveren_issizlik;
						puantaj_exts[i_ek_od][24] = this_ek_ucret_isci;
						puantaj_exts[i_ek_od][25] = this_ek_ucret_isci_issizlik;
						puantaj_exts[i_ek_od][26] = this_ek_ucret_gelir;
						puantaj_exts[i_ek_od][27] = this_ek_ucret_damga;

						if(puantaj_exts[i_ek_od][43] eq 1)
						{
							rd_dahil_olan_gelir_vergisi = rd_dahil_olan_gelir_vergisi + this_ek_ucret_gelir;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir;
							}
						}
						else
						{
							rd_dahil_olmayan_gelir_vergisi = rd_dahil_olmayan_gelir_vergisi + this_ek_ucret_gelir;	
						}
						
						if(puantaj_exts[i_ek_od][42] eq 1)
						{
							rd_dahil_olan_damga_vergisi = rd_dahil_olan_damga_vergisi + this_ek_ucret_damga;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga;
							}
						}
						else
						{
							rd_dahil_olmayan_damga_vergisi = rd_dahil_olmayan_damga_vergisi + this_ek_ucret_damga;	
						}
						
						if(puantaj_exts[i_ek_od][44] eq 1)
						{
							rd_dahil_olan_ssk_isveren_hissesi = rd_dahil_olan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren;
							}
						}
						else
						{
							rd_dahil_olmayan_ssk_isveren_hissesi = rd_dahil_olmayan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(this_ek_ucret_isveren gt 0)
								rd_dahil_olmayan_ssk_matrah = rd_dahil_olmayan_ssk_matrah + puantaj_exts[i_ek_od][3];
						}

					}
					else if (get_pay_salary.ssk[i_ek_od] eq 1 and get_pay_salary.tax[i_ek_od] eq 1 and get_pay_salary.IS_DAMGA[i_ek_od] eq 1 and get_pay_salary.IS_ISSIZLIK[i_ek_od] eq 0)
					{
						if((ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7] eq 1 or puantaj_exts[i_ek_od][7] eq 2) and puantaj_exts[i_ek_od][8] neq 0)
							total_pay_d = total_pay_d + puantaj_exts[i_ek_od][8];
						else
							total_pay_d = total_pay_d + puantaj_exts[i_ek_od][3];
						brut_salary = salary;
						a_g_m_ = asgari_gecim_max_tutar_;
						ozel_kesinti_ = ozel_kesinti;
						ozel_kesinti = 0; 
						ozel_kesinti_2_ = ozel_kesinti_2;
						ozel_kesinti_2 = 0; 
						include 'get_hr_compass_from_brut.cfm';
						ozel_kesinti = ozel_kesinti_; 
						ozel_kesinti_2 = ozel_kesinti_2_;
						asgari_gecim_max_tutar_ = a_g_m_;
						salary = brut_salary;
						
						this_ek_ucret_net = net_ucret - maas_net_ucreti_  - onceki_odenek_netleri_toplam; //+ ozel_kesinti
						this_ek_ucret_gelir = gelir_vergisi - maas_gelir_vergisi_ - onceki_odenek_gelir_toplam;
						this_ek_ucret_damga = damga_vergisi - maas_damga_vergisi_ - onceki_odenek_damga_toplam;
						this_ek_ucret_isveren = ssk_isveren_hissesi - maas_ssk_isveren_hissesi_ - onceki_odenek_isveren_toplam;
						this_ek_ucret_isci = ssk_isci_hissesi - maas_ssk_isci_hissesi_ - onceki_odenek_isci_toplam;
						this_ek_ucret_isveren_issizlik = issizlik_isveren_hissesi - maas_ssk_isveren_issizlik_ - onceki_odenek_isveren_issizlik_toplam;
						this_ek_ucret_isci_issizlik = issizlik_isci_hissesi - maas_ssk_isci_issizlik_ - onceki_odenek_isci_issizlik_toplam;
						
						onceki_odenek_netleri_toplam = onceki_odenek_netleri_toplam + this_ek_ucret_net;
						onceki_odenek_gelir_toplam = onceki_odenek_gelir_toplam + this_ek_ucret_gelir;
						onceki_odenek_damga_toplam = onceki_odenek_damga_toplam + this_ek_ucret_damga;
						onceki_odenek_isveren_toplam = onceki_odenek_isveren_toplam + this_ek_ucret_isveren;
						onceki_odenek_isci_toplam = onceki_odenek_isci_toplam + this_ek_ucret_isci;
						onceki_odenek_isveren_issizlik_toplam = onceki_odenek_isveren_issizlik_toplam + this_ek_ucret_isveren_issizlik;
						onceki_odenek_isci_issizlik_toplam = onceki_odenek_isci_issizlik_toplam + this_ek_ucret_isci_issizlik;
					
						if((ArrayIsDefined(puantaj_exts[i_ek_od],33)and puantaj_exts[i_ek_od][33] eq 1) or (ArrayIsDefined(puantaj_exts[i_ek_od],32) and puantaj_exts[i_ek_od][32] neq 1))
							puantaj_exts[i_ek_od][15] = this_ek_ucret_net;
						else if(ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7] neq 0 and get_hr_salary.gross_net eq 0)
							puantaj_exts[i_ek_od][15] = puantaj_exts[i_ek_od][15]/30*ssk_days;
						puantaj_exts[i_ek_od][22] = this_ek_ucret_isveren;
						puantaj_exts[i_ek_od][23] = this_ek_ucret_isveren_issizlik;
						puantaj_exts[i_ek_od][24] = this_ek_ucret_isci;
						puantaj_exts[i_ek_od][25] = this_ek_ucret_isci_issizlik;
						puantaj_exts[i_ek_od][26] = this_ek_ucret_gelir;
						puantaj_exts[i_ek_od][27] = this_ek_ucret_damga;	

						if(puantaj_exts[i_ek_od][43] eq 1)
						{
							rd_dahil_olan_gelir_vergisi = rd_dahil_olan_gelir_vergisi + this_ek_ucret_gelir;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir;
							}
						}
						else
						{
							rd_dahil_olmayan_gelir_vergisi = rd_dahil_olmayan_gelir_vergisi + this_ek_ucret_gelir;	
						}
						
						if(puantaj_exts[i_ek_od][42] eq 1)
						{
							rd_dahil_olan_damga_vergisi = rd_dahil_olan_damga_vergisi + this_ek_ucret_damga;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga;
							}
						}
						else
						{
							rd_dahil_olmayan_damga_vergisi = rd_dahil_olmayan_damga_vergisi + this_ek_ucret_damga;	
						}
						
						if(puantaj_exts[i_ek_od][44] eq 1)
						{
							rd_dahil_olan_ssk_isveren_hissesi = rd_dahil_olan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren;
							}
						}
						else
						{
							rd_dahil_olmayan_ssk_isveren_hissesi = rd_dahil_olmayan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(this_ek_ucret_isveren gt 0)
								rd_dahil_olmayan_ssk_matrah = rd_dahil_olmayan_ssk_matrah + puantaj_exts[i_ek_od][3];
						}	
						
					}
					else if(get_pay_salary.ssk[i_ek_od] eq 2 and get_pay_salary.tax[i_ek_od] eq 2 and get_pay_salary.IS_DAMGA[i_ek_od] eq 1 and get_pay_salary.IS_ISSIZLIK[i_ek_od] eq 1)
					{
						if((ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7] eq 1 or puantaj_exts[i_ek_od][7] eq 2) and puantaj_exts[i_ek_od][8] neq 0)
							total_pay_ssk_tax = total_pay_ssk_tax + puantaj_exts[i_ek_od][8];
						else
							total_pay_ssk_tax = total_pay_ssk_tax + puantaj_exts[i_ek_od][3];

						if(arraylen(puantaj_exts[i_ek_od]) gte 40 and len(puantaj_exts[i_ek_od][40]))
							ssk_matraha_dahil_olmayan_odenek_tutar =  ssk_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][40];
						
						if(arraylen(puantaj_exts[i_ek_od]) gte 41 and len(puantaj_exts[i_ek_od][41]))
							vergi_matraha_dahil_olmayan_odenek_tutar = vergi_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][41];

						brut_salary = salary;
						a_g_m_ = asgari_gecim_max_tutar_;
						ozel_kesinti_ = ozel_kesinti;
						ozel_kesinti = 0;	
						ozel_kesinti_2_ = ozel_kesinti_2;
						ozel_kesinti_2 = 0;				
						include 'get_hr_compass_from_brut.cfm';
						ozel_kesinti = ozel_kesinti_;
						ozel_kesinti_2 = ozel_kesinti_2;
						asgari_gecim_max_tutar_ = a_g_m_;
						salary = brut_salary;
						
						this_ek_ucret_net = net_ucret - maas_net_ucreti_  - onceki_odenek_netleri_toplam; //+ ozel_kesinti
						this_ek_ucret_gelir = gelir_vergisi - maas_gelir_vergisi_ - onceki_odenek_gelir_toplam;
						this_ek_ucret_damga = damga_vergisi - maas_damga_vergisi_ - onceki_odenek_damga_toplam;
						this_ek_ucret_isveren = ssk_isveren_hissesi - maas_ssk_isveren_hissesi_ - onceki_odenek_isveren_toplam;
						this_ek_ucret_isci = ssk_isci_hissesi - maas_ssk_isci_hissesi_ - onceki_odenek_isci_toplam;
						this_ek_ucret_isveren_issizlik = issizlik_isveren_hissesi - maas_ssk_isveren_issizlik_ - onceki_odenek_isveren_issizlik_toplam;
						this_ek_ucret_isci_issizlik = issizlik_isci_hissesi - maas_ssk_isci_issizlik_ - onceki_odenek_isci_issizlik_toplam;
						
						onceki_odenek_netleri_toplam = onceki_odenek_netleri_toplam + this_ek_ucret_net;
						onceki_odenek_gelir_toplam = onceki_odenek_gelir_toplam + this_ek_ucret_gelir;
						onceki_odenek_damga_toplam = onceki_odenek_damga_toplam + this_ek_ucret_damga;
						onceki_odenek_isveren_toplam = onceki_odenek_isveren_toplam + this_ek_ucret_isveren;
						onceki_odenek_isci_toplam = onceki_odenek_isci_toplam + this_ek_ucret_isci;
						onceki_odenek_isveren_issizlik_toplam = onceki_odenek_isveren_issizlik_toplam + this_ek_ucret_isveren_issizlik;
						onceki_odenek_isci_issizlik_toplam = onceki_odenek_isci_issizlik_toplam + this_ek_ucret_isci_issizlik;

						if((ArrayIsDefined(puantaj_exts[i_ek_od],33)and puantaj_exts[i_ek_od][33] eq 1) or (ArrayIsDefined(puantaj_exts[i_ek_od],32) and puantaj_exts[i_ek_od][32] neq 1))
							puantaj_exts[i_ek_od][15] = this_ek_ucret_net;
						else if(ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7] neq 0 and get_hr_salary.gross_net eq 0)
							puantaj_exts[i_ek_od][15] = puantaj_exts[i_ek_od][15]/30*ssk_days;
						puantaj_exts[i_ek_od][22] = this_ek_ucret_isveren;
						puantaj_exts[i_ek_od][23] = this_ek_ucret_isveren_issizlik;
						puantaj_exts[i_ek_od][24] = this_ek_ucret_isci;
						puantaj_exts[i_ek_od][25] = this_ek_ucret_isci_issizlik;
						puantaj_exts[i_ek_od][26] = this_ek_ucret_gelir;
						puantaj_exts[i_ek_od][27] = this_ek_ucret_damga;

						if(puantaj_exts[i_ek_od][43] eq 1)
						{
							rd_dahil_olan_gelir_vergisi = rd_dahil_olan_gelir_vergisi + this_ek_ucret_gelir;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir;
							}
						}
						else
						{
							rd_dahil_olmayan_gelir_vergisi = rd_dahil_olmayan_gelir_vergisi + this_ek_ucret_gelir;	
						}
						
						if(puantaj_exts[i_ek_od][42] eq 1)
						{
							rd_dahil_olan_damga_vergisi = rd_dahil_olan_damga_vergisi + this_ek_ucret_damga;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga;
							}
						}
						else
						{
							rd_dahil_olmayan_damga_vergisi = rd_dahil_olmayan_damga_vergisi + this_ek_ucret_damga;	
						}
						
						if(puantaj_exts[i_ek_od][44] eq 1)
						{
							rd_dahil_olan_ssk_isveren_hissesi = rd_dahil_olan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren;
							}
						}
						else
						{
							rd_dahil_olmayan_ssk_isveren_hissesi = rd_dahil_olmayan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(this_ek_ucret_isveren gt 0)
								rd_dahil_olmayan_ssk_matrah = rd_dahil_olmayan_ssk_matrah + puantaj_exts[i_ek_od][3];
						}
						
						//abort('puantaj_exts[i_ek_od][15]:#puantaj_exts[i_ek_od][15]# net_ucret:#net_ucret#-maas_net_ucreti_:#maas_net_ucreti_#-ext_salary_net:#ext_salary_net#-#onceki_odenek_netleri_toplam#');
					}
					else if (get_pay_salary.ssk[i_ek_od] eq 1 and get_pay_salary.tax[i_ek_od] eq 2 and get_pay_salary.IS_DAMGA[i_ek_od] eq 1 and get_pay_salary.IS_ISSIZLIK[i_ek_od] eq 0)
					{
						if((ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7] eq 1 or puantaj_exts[i_ek_od][7] eq 2) and puantaj_exts[i_ek_od][8] neq 0)
							total_pay_tax = total_pay_tax + puantaj_exts[i_ek_od][8];
						else
							total_pay_tax = total_pay_tax + puantaj_exts[i_ek_od][3];

						if(arraylen(puantaj_exts[i_ek_od]) gte 40 and len(puantaj_exts[i_ek_od][40]))
							ssk_matraha_dahil_olmayan_odenek_tutar =  ssk_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][40];
						
						if(arraylen(puantaj_exts[i_ek_od]) gte 41 and len(puantaj_exts[i_ek_od][41]))
							vergi_matraha_dahil_olmayan_odenek_tutar = vergi_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][41];

						brut_salary = salary;
						a_g_m_ = asgari_gecim_max_tutar_;
						ozel_kesinti_ = ozel_kesinti;
						ozel_kesinti = 0;					
						include 'get_hr_compass_from_brut.cfm';
						ozel_kesinti = ozel_kesinti_;					
						asgari_gecim_max_tutar_ = a_g_m_;
						salary = brut_salary;
						this_ek_ucret_net = net_ucret - maas_net_ucreti_ - onceki_odenek_netleri_toplam; // + ozel_kesinti
						this_ek_ucret_gelir = gelir_vergisi - maas_gelir_vergisi_ - onceki_odenek_gelir_toplam;
						this_ek_ucret_damga = damga_vergisi - maas_damga_vergisi_ - onceki_odenek_damga_toplam;
						this_ek_ucret_isveren = ssk_isveren_hissesi - maas_ssk_isveren_hissesi_ - onceki_odenek_isveren_toplam;
						this_ek_ucret_isci = ssk_isci_hissesi - maas_ssk_isci_hissesi_ - onceki_odenek_isci_toplam;
						this_ek_ucret_isveren_issizlik = issizlik_isveren_hissesi - maas_ssk_isveren_issizlik_ - onceki_odenek_isveren_issizlik_toplam;
						this_ek_ucret_isci_issizlik = issizlik_isci_hissesi - maas_ssk_isci_issizlik_ - onceki_odenek_isci_issizlik_toplam;
						
						onceki_odenek_netleri_toplam = onceki_odenek_netleri_toplam + this_ek_ucret_net;
						onceki_odenek_gelir_toplam = onceki_odenek_gelir_toplam + this_ek_ucret_gelir;
						onceki_odenek_damga_toplam = onceki_odenek_damga_toplam + this_ek_ucret_damga;
						onceki_odenek_isveren_toplam = onceki_odenek_isveren_toplam + this_ek_ucret_isveren;
						onceki_odenek_isci_toplam = onceki_odenek_isci_toplam + this_ek_ucret_isci;
						onceki_odenek_isveren_issizlik_toplam = onceki_odenek_isveren_issizlik_toplam + this_ek_ucret_isveren_issizlik;
						onceki_odenek_isci_issizlik_toplam = onceki_odenek_isci_issizlik_toplam + this_ek_ucret_isci_issizlik;
						
						if((ArrayIsDefined(puantaj_exts[i_ek_od],33)and puantaj_exts[i_ek_od][33] eq 1) or (ArrayIsDefined(puantaj_exts[i_ek_od],32) and puantaj_exts[i_ek_od][32] neq 1))
							puantaj_exts[i_ek_od][15] = this_ek_ucret_net;
						else if(ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7] neq 0 and get_hr_salary.gross_net eq 0)
							puantaj_exts[i_ek_od][15] = puantaj_exts[i_ek_od][15]/30*ssk_days;
						puantaj_exts[i_ek_od][22] = this_ek_ucret_isveren;
						puantaj_exts[i_ek_od][23] = this_ek_ucret_isveren_issizlik;
						puantaj_exts[i_ek_od][24] = this_ek_ucret_isci;
						puantaj_exts[i_ek_od][25] = this_ek_ucret_isci_issizlik;
						puantaj_exts[i_ek_od][26] = this_ek_ucret_gelir;
						puantaj_exts[i_ek_od][27] = this_ek_ucret_damga;
						
						if(puantaj_exts[i_ek_od][43] eq 1)
						{
							rd_dahil_olan_gelir_vergisi = rd_dahil_olan_gelir_vergisi + this_ek_ucret_gelir;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir;
							}
						}
						else
						{
							rd_dahil_olmayan_gelir_vergisi = rd_dahil_olmayan_gelir_vergisi + this_ek_ucret_gelir;	
						}
						
						if(puantaj_exts[i_ek_od][42] eq 1)
						{
							rd_dahil_olan_damga_vergisi = rd_dahil_olan_damga_vergisi + this_ek_ucret_damga;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga;
							}
						}
						else
						{
							rd_dahil_olmayan_damga_vergisi = rd_dahil_olmayan_damga_vergisi + this_ek_ucret_damga;	
						}
						
						if(puantaj_exts[i_ek_od][44] eq 1)
						{
							rd_dahil_olan_ssk_isveren_hissesi = rd_dahil_olan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren;
							}
						}
						else
						{
							rd_dahil_olmayan_ssk_isveren_hissesi = rd_dahil_olmayan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(this_ek_ucret_isveren gt 0)
								rd_dahil_olmayan_ssk_matrah = rd_dahil_olmayan_ssk_matrah + puantaj_exts[i_ek_od][3];
						}	
						//abort('net_ucret:#net_ucret# maas_net_ucreti_:#maas_net_ucreti_# onceki_odenek_netleri_toplam:#onceki_odenek_netleri_toplam#');
					}
					else if ((get_pay_salary.ssk[i_ek_od] eq 2) and (get_pay_salary.tax[i_ek_od] eq 2) and (get_pay_salary.IS_DAMGA[i_ek_od] eq 1) and (get_pay_salary.IS_ISSIZLIK[i_ek_od] eq 0)) // sadece issizlik yok
					{
						if((ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7] eq 1 or puantaj_exts[i_ek_od][7] eq 2) and puantaj_exts[i_ek_od][8] neq 0)
							total_pay_ssk_tax_noissizlik = total_pay_ssk_tax_noissizlik + puantaj_exts[i_ek_od][8];
						else
							total_pay_ssk_tax_noissizlik = total_pay_ssk_tax_noissizlik + puantaj_exts[i_ek_od][3];

						if(arraylen(puantaj_exts[i_ek_od]) gte 40 and len(puantaj_exts[i_ek_od][40]))
							ssk_matraha_dahil_olmayan_odenek_tutar =  ssk_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][40];
						
						if(arraylen(puantaj_exts[i_ek_od]) gte 41 and len(puantaj_exts[i_ek_od][41]))
							vergi_matraha_dahil_olmayan_odenek_tutar = vergi_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][41];

						brut_salary = salary;
						a_g_m_ = asgari_gecim_max_tutar_;
						ozel_kesinti_ = ozel_kesinti;
						ozel_kesinti = 0;					
						include 'get_hr_compass_from_brut.cfm';
						ozel_kesinti = ozel_kesinti_;					
						asgari_gecim_max_tutar_ = a_g_m_;
						salary = brut_salary;
						
						this_ek_ucret_net = net_ucret - maas_net_ucreti_ - onceki_odenek_netleri_toplam; //+ ozel_kesinti
						this_ek_ucret_gelir = gelir_vergisi - maas_gelir_vergisi_ - onceki_odenek_gelir_toplam;
						this_ek_ucret_damga = damga_vergisi - maas_damga_vergisi_ - onceki_odenek_damga_toplam;
						this_ek_ucret_isveren = ssk_isveren_hissesi - maas_ssk_isveren_hissesi_ - onceki_odenek_isveren_toplam;
						this_ek_ucret_isci = ssk_isci_hissesi - maas_ssk_isci_hissesi_ - onceki_odenek_isci_toplam;
						this_ek_ucret_isveren_issizlik = issizlik_isveren_hissesi - maas_ssk_isveren_issizlik_ - onceki_odenek_isveren_issizlik_toplam;
						this_ek_ucret_isci_issizlik = issizlik_isci_hissesi - maas_ssk_isci_issizlik_ - onceki_odenek_isci_issizlik_toplam;
						
						onceki_odenek_netleri_toplam = onceki_odenek_netleri_toplam + this_ek_ucret_net;
						onceki_odenek_gelir_toplam = onceki_odenek_gelir_toplam + this_ek_ucret_gelir;
						onceki_odenek_damga_toplam = onceki_odenek_damga_toplam + this_ek_ucret_damga;
						onceki_odenek_isveren_toplam = onceki_odenek_isveren_toplam + this_ek_ucret_isveren;
						onceki_odenek_isci_toplam = onceki_odenek_isci_toplam + this_ek_ucret_isci;
						onceki_odenek_isveren_issizlik_toplam = onceki_odenek_isveren_issizlik_toplam + this_ek_ucret_isveren_issizlik;
						onceki_odenek_isci_issizlik_toplam = onceki_odenek_isci_issizlik_toplam + this_ek_ucret_isci_issizlik;

						if((ArrayIsDefined(puantaj_exts[i_ek_od],33)and puantaj_exts[i_ek_od][33] eq 1) or (ArrayIsDefined(puantaj_exts[i_ek_od],32) and puantaj_exts[i_ek_od][32] neq 1))
							puantaj_exts[i_ek_od][15] = this_ek_ucret_net;
						else if(ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7] neq 0 and get_hr_salary.gross_net eq 0)
							puantaj_exts[i_ek_od][15] = puantaj_exts[i_ek_od][15]/30*ssk_days;
						puantaj_exts[i_ek_od][22] = this_ek_ucret_isveren;
						puantaj_exts[i_ek_od][23] = this_ek_ucret_isveren_issizlik;
						puantaj_exts[i_ek_od][24] = this_ek_ucret_isci;
						puantaj_exts[i_ek_od][25] = this_ek_ucret_isci_issizlik;
						puantaj_exts[i_ek_od][26] = this_ek_ucret_gelir;
						puantaj_exts[i_ek_od][27] = this_ek_ucret_damga;


						if(puantaj_exts[i_ek_od][43] eq 1)
						{
							rd_dahil_olan_gelir_vergisi = rd_dahil_olan_gelir_vergisi + this_ek_ucret_gelir;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir;
							}
						}
						else
						{
							rd_dahil_olmayan_gelir_vergisi = rd_dahil_olmayan_gelir_vergisi + this_ek_ucret_gelir;	
						}
						
						if(puantaj_exts[i_ek_od][42] eq 1)
						{
							rd_dahil_olan_damga_vergisi = rd_dahil_olan_damga_vergisi + this_ek_ucret_damga;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga;
							}
						}
						else
						{
							rd_dahil_olmayan_damga_vergisi = rd_dahil_olmayan_damga_vergisi + this_ek_ucret_damga;	
						}
						
						if(puantaj_exts[i_ek_od][44] eq 1)
						{
							rd_dahil_olan_ssk_isveren_hissesi = rd_dahil_olan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren;
							}
						}
						else
						{
							rd_dahil_olmayan_ssk_isveren_hissesi = rd_dahil_olmayan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(this_ek_ucret_isveren gt 0)
								rd_dahil_olmayan_ssk_matrah = rd_dahil_olmayan_ssk_matrah + puantaj_exts[i_ek_od][3];
						}
							
					}
					else if (get_pay_salary.ssk[i_ek_od] eq 2 and get_pay_salary.tax[i_ek_od] eq 1 and get_pay_salary.IS_DAMGA[i_ek_od] eq 0 and get_pay_salary.IS_ISSIZLIK[i_ek_od] eq 0) // sadece ssk var
					{
						if((ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7] eq 1 or puantaj_exts[i_ek_od][7] eq 2) and puantaj_exts[i_ek_od][8] neq 0)
							total_pay_ssk_noissizlik = total_pay_ssk_noissizlik + puantaj_exts[i_ek_od][8];
						else
							total_pay_ssk_noissizlik = total_pay_ssk_noissizlik + puantaj_exts[i_ek_od][3];

						if(arraylen(puantaj_exts[i_ek_od]) gte 40 and len(puantaj_exts[i_ek_od][40]))
							ssk_matraha_dahil_olmayan_odenek_tutar =  ssk_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][40];
						
						if(arraylen(puantaj_exts[i_ek_od]) gte 41 and len(puantaj_exts[i_ek_od][41]))
							vergi_matraha_dahil_olmayan_odenek_tutar = vergi_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][41];

						brut_salary = salary;
						a_g_m_ = asgari_gecim_max_tutar_;
						ozel_kesinti_ = ozel_kesinti;
						ozel_kesinti = 0;					
						include 'get_hr_compass_from_brut.cfm';
						ozel_kesinti = ozel_kesinti_;					
						asgari_gecim_max_tutar_ = a_g_m_;
						salary = brut_salary;
						
						this_ek_ucret_net = net_ucret - maas_net_ucreti_ - onceki_odenek_netleri_toplam; //+ ozel_kesinti
						this_ek_ucret_gelir = gelir_vergisi - maas_gelir_vergisi_ - onceki_odenek_gelir_toplam;
						this_ek_ucret_damga = damga_vergisi - maas_damga_vergisi_ - onceki_odenek_damga_toplam;
						this_ek_ucret_isveren = ssk_isveren_hissesi - maas_ssk_isveren_hissesi_ - onceki_odenek_isveren_toplam;
						this_ek_ucret_isci = ssk_isci_hissesi - maas_ssk_isci_hissesi_ - onceki_odenek_isci_toplam;
						this_ek_ucret_isveren_issizlik = issizlik_isveren_hissesi - maas_ssk_isveren_issizlik_ - onceki_odenek_isveren_issizlik_toplam;
						this_ek_ucret_isci_issizlik = issizlik_isci_hissesi - maas_ssk_isci_issizlik_ - onceki_odenek_isci_issizlik_toplam;
						
						onceki_odenek_netleri_toplam = onceki_odenek_netleri_toplam + this_ek_ucret_net;
						onceki_odenek_gelir_toplam = onceki_odenek_gelir_toplam + this_ek_ucret_gelir;
						onceki_odenek_damga_toplam = onceki_odenek_damga_toplam + this_ek_ucret_damga;
						onceki_odenek_isveren_toplam = onceki_odenek_isveren_toplam + this_ek_ucret_isveren;
						onceki_odenek_isci_toplam = onceki_odenek_isci_toplam + this_ek_ucret_isci;
						onceki_odenek_isveren_issizlik_toplam = onceki_odenek_isveren_issizlik_toplam + this_ek_ucret_isveren_issizlik;
						onceki_odenek_isci_issizlik_toplam = onceki_odenek_isci_issizlik_toplam + this_ek_ucret_isci_issizlik;
						
						if((ArrayIsDefined(puantaj_exts[i_ek_od],33)and puantaj_exts[i_ek_od][33] eq 1) or (ArrayIsDefined(puantaj_exts[i_ek_od],32) and puantaj_exts[i_ek_od][32] neq 1))
							puantaj_exts[i_ek_od][15] = this_ek_ucret_net;
						else if(ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7] neq 0 and get_hr_salary.gross_net eq 0)
							puantaj_exts[i_ek_od][15] = puantaj_exts[i_ek_od][15]/30*ssk_days;
						puantaj_exts[i_ek_od][22] = this_ek_ucret_isveren;
						puantaj_exts[i_ek_od][23] = this_ek_ucret_isveren_issizlik;
						puantaj_exts[i_ek_od][24] = this_ek_ucret_isci;
						puantaj_exts[i_ek_od][25] = this_ek_ucret_isci_issizlik;
						puantaj_exts[i_ek_od][26] = this_ek_ucret_gelir;
						puantaj_exts[i_ek_od][27] = this_ek_ucret_damga;
						
						if(puantaj_exts[i_ek_od][43] eq 1)
						{
							rd_dahil_olan_gelir_vergisi = rd_dahil_olan_gelir_vergisi + this_ek_ucret_gelir;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir;
							}
						}
						else
						{
							rd_dahil_olmayan_gelir_vergisi = rd_dahil_olmayan_gelir_vergisi + this_ek_ucret_gelir;	
						}
						
						if(puantaj_exts[i_ek_od][42] eq 1)
						{
							rd_dahil_olan_damga_vergisi = rd_dahil_olan_damga_vergisi + this_ek_ucret_damga;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga;
							}
						}
						else
						{
							rd_dahil_olmayan_damga_vergisi = rd_dahil_olmayan_damga_vergisi + this_ek_ucret_damga;	
						}
						
						if(puantaj_exts[i_ek_od][44] eq 1)
						{
							rd_dahil_olan_ssk_isveren_hissesi = rd_dahil_olan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren;
							}
						}
						else
						{
							rd_dahil_olmayan_ssk_isveren_hissesi = rd_dahil_olmayan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(this_ek_ucret_isveren gt 0)
								rd_dahil_olmayan_ssk_matrah = rd_dahil_olmayan_ssk_matrah + puantaj_exts[i_ek_od][3];
						}
					}
					else if (get_pay_salary.ssk[i_ek_od] eq 2 and get_pay_salary.tax[i_ek_od] eq 1 and get_pay_salary.IS_DAMGA[i_ek_od] eq 1 and get_pay_salary.IS_ISSIZLIK[i_ek_od] eq 1) // ssk
					{
						if((ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7] eq 1 or puantaj_exts[i_ek_od][7] eq 2) and puantaj_exts[i_ek_od][8] neq 0)
							total_pay_ssk = total_pay_ssk + puantaj_exts[i_ek_od][8];
						else
							total_pay_ssk = total_pay_ssk + puantaj_exts[i_ek_od][3];

						if(arraylen(puantaj_exts[i_ek_od]) gte 40 and len(puantaj_exts[i_ek_od][40]))
							ssk_matraha_dahil_olmayan_odenek_tutar =  ssk_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][40];
						
						if(arraylen(puantaj_exts[i_ek_od]) gte 41 and len(puantaj_exts[i_ek_od][41]))
							vergi_matraha_dahil_olmayan_odenek_tutar = vergi_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][41];
							
						brut_salary = salary;
						a_g_m_ = asgari_gecim_max_tutar_;
						ozel_kesinti_ = ozel_kesinti;
						ozel_kesinti = 0;					
						include 'get_hr_compass_from_brut.cfm';
						ozel_kesinti = ozel_kesinti_;					
						asgari_gecim_max_tutar_ = a_g_m_;
						salary = brut_salary;
						
						this_ek_ucret_net = net_ucret - maas_net_ucreti_  - onceki_odenek_netleri_toplam; //+ ozel_kesinti
						this_ek_ucret_gelir = gelir_vergisi - maas_gelir_vergisi_ - onceki_odenek_gelir_toplam;
						this_ek_ucret_damga = damga_vergisi - maas_damga_vergisi_ - onceki_odenek_damga_toplam;
						this_ek_ucret_isveren = ssk_isveren_hissesi - maas_ssk_isveren_hissesi_ - onceki_odenek_isveren_toplam;
						this_ek_ucret_isci = ssk_isci_hissesi - maas_ssk_isci_hissesi_ - onceki_odenek_isci_toplam;
						this_ek_ucret_isveren_issizlik = issizlik_isveren_hissesi - maas_ssk_isveren_issizlik_ - onceki_odenek_isveren_issizlik_toplam;
						this_ek_ucret_isci_issizlik = issizlik_isci_hissesi - maas_ssk_isci_issizlik_ - onceki_odenek_isci_issizlik_toplam;
						
						onceki_odenek_netleri_toplam = onceki_odenek_netleri_toplam + this_ek_ucret_net;
						onceki_odenek_gelir_toplam = onceki_odenek_gelir_toplam + this_ek_ucret_gelir;
						onceki_odenek_damga_toplam = onceki_odenek_damga_toplam + this_ek_ucret_damga;
						onceki_odenek_isveren_toplam = onceki_odenek_isveren_toplam + this_ek_ucret_isveren;
						onceki_odenek_isci_toplam = onceki_odenek_isci_toplam + this_ek_ucret_isci;
						onceki_odenek_isveren_issizlik_toplam = onceki_odenek_isveren_issizlik_toplam + this_ek_ucret_isveren_issizlik;
						onceki_odenek_isci_issizlik_toplam = onceki_odenek_isci_issizlik_toplam + this_ek_ucret_isci_issizlik;
						
						if((ArrayIsDefined(puantaj_exts[i_ek_od],33)and puantaj_exts[i_ek_od][33] eq 1) or (ArrayIsDefined(puantaj_exts[i_ek_od],32) and puantaj_exts[i_ek_od][32] neq 1))
							puantaj_exts[i_ek_od][15] = this_ek_ucret_net;
						else if(ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7] neq 0 and get_hr_salary.gross_net eq 0)
							puantaj_exts[i_ek_od][15] = puantaj_exts[i_ek_od][15]/30*ssk_days;
						puantaj_exts[i_ek_od][22] = this_ek_ucret_isveren;
						puantaj_exts[i_ek_od][23] = this_ek_ucret_isveren_issizlik;
						puantaj_exts[i_ek_od][24] = this_ek_ucret_isci;
						puantaj_exts[i_ek_od][25] = this_ek_ucret_isci_issizlik;
						puantaj_exts[i_ek_od][26] = this_ek_ucret_gelir;
						puantaj_exts[i_ek_od][27] = this_ek_ucret_damga;

						if(puantaj_exts[i_ek_od][43] eq 1)
						{
							rd_dahil_olan_gelir_vergisi = rd_dahil_olan_gelir_vergisi + this_ek_ucret_gelir;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir;
							}
						}
						else
						{
							rd_dahil_olmayan_gelir_vergisi = rd_dahil_olmayan_gelir_vergisi + this_ek_ucret_gelir;	
						}
						
						if(puantaj_exts[i_ek_od][42] eq 1)
						{
							rd_dahil_olan_damga_vergisi = rd_dahil_olan_damga_vergisi + this_ek_ucret_damga;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga;
							}
						}
						else
						{
							rd_dahil_olmayan_damga_vergisi = rd_dahil_olmayan_damga_vergisi + this_ek_ucret_damga;	
						}
						
						if(puantaj_exts[i_ek_od][44] eq 1)
						{
							rd_dahil_olan_ssk_isveren_hissesi = rd_dahil_olan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren;
							}
						}
						else
						{
							rd_dahil_olmayan_ssk_isveren_hissesi = rd_dahil_olmayan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(this_ek_ucret_isveren gt 0)
								rd_dahil_olmayan_ssk_matrah = rd_dahil_olmayan_ssk_matrah + puantaj_exts[i_ek_od][3];
						}
					}
					else if (get_pay_salary.ssk[i_ek_od] eq 2 and get_pay_salary.tax[i_ek_od] eq 1 and get_pay_salary.IS_DAMGA[i_ek_od] eq 0 and get_pay_salary.IS_ISSIZLIK[i_ek_od] eq 1) // dv ve v muaf 05042022ERU
				 	{
						//total_pay_ssk = total_pay_ssk + puantaj_exts[i_ek_od][3];
						if(listfind('2,3,4',get_pay_salary.method_pay[i_ek_od],','))
						{
							total_pay_ssk = total_pay_ssk + puantaj_exts[i_ek_od][8];
						}
						else 
						{
							total_pay_ssk = total_pay_ssk + puantaj_exts[i_ek_od][3];
						}

						if(listfind('2,3,4',get_pay_salary.method_pay[i_ek_od],','))
						{
							total_pay_unstamped = total_pay_unstamped + puantaj_exts[i_ek_od][8];
							total_pay_ssk_untax_diff = (puantaj_exts[i_ek_od][8] * 15 / 100);
						}
						else 
						{
							total_pay_unstamped = total_pay_unstamped + puantaj_exts[i_ek_od][3];
							total_pay_ssk_untax_diff = (puantaj_exts[i_ek_od][3] * 15 / 100);
						}

						brut_salary = salary;
						a_g_m_ = asgari_gecim_max_tutar_;
						ozel_kesinti_ = ozel_kesinti;
						ozel_kesinti = 0;			
						
						if(len(puantaj_exts[i_ek_od][40]))
						{
							ssk_matraha_dahil_olmayan_odenek_tutar = ssk_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][40];
						}
						
						if(len(puantaj_exts[i_ek_od][41]))
						{
							vergi_matraha_dahil_olmayan_odenek_tutar = vergi_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][41];
						}
						
						include 'get_hr_compass_from_brut.cfm';
						ozel_kesinti = ozel_kesinti_;						
						asgari_gecim_max_tutar_ = a_g_m_;
						salary = brut_salary;
						
						this_ek_ucret_net = net_ucret - maas_net_ucreti_ - onceki_odenek_netleri_toplam ; //+ ozel_kesinti
						this_ek_ucret_gelir = gelir_vergisi - maas_gelir_vergisi_ - onceki_odenek_gelir_toplam;
						this_ek_ucret_damga = damga_vergisi - maas_damga_vergisi_ - onceki_odenek_damga_toplam;
						this_ek_ucret_isveren = ssk_isveren_hissesi - maas_ssk_isveren_hissesi_ - onceki_odenek_isveren_toplam;
						this_ek_ucret_isci = ssk_isci_hissesi - maas_ssk_isci_hissesi_ -  onceki_odenek_isci_toplam;
						this_ek_ucret_isveren_issizlik = issizlik_isveren_hissesi - maas_ssk_isveren_issizlik_ - onceki_odenek_isveren_issizlik_toplam;
						this_ek_ucret_isci_issizlik = issizlik_isci_hissesi - maas_ssk_isci_issizlik_ - onceki_odenek_isci_issizlik_toplam;


						onceki_odenek_netleri_toplam = onceki_odenek_netleri_toplam + this_ek_ucret_net;
						onceki_odenek_gelir_toplam = onceki_odenek_gelir_toplam + this_ek_ucret_gelir;
						onceki_odenek_damga_toplam = onceki_odenek_damga_toplam + this_ek_ucret_damga;
						onceki_odenek_isveren_toplam = onceki_odenek_isveren_toplam + this_ek_ucret_isveren;
						onceki_odenek_isci_toplam = onceki_odenek_isci_toplam + this_ek_ucret_isci;
						onceki_odenek_isveren_issizlik_toplam = onceki_odenek_isveren_issizlik_toplam + this_ek_ucret_isveren_issizlik;
						onceki_odenek_isci_issizlik_toplam = onceki_odenek_isci_issizlik_toplam + this_ek_ucret_isci_issizlik;

						if((ArrayIsDefined(puantaj_exts[i_ek_od],33)and puantaj_exts[i_ek_od][33] eq 1) or (ArrayIsDefined(puantaj_exts[i_ek_od],32) and puantaj_exts[i_ek_od][32] neq 1))
							puantaj_exts[i_ek_od][15] = this_ek_ucret_net;
						else if(ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7] neq 0 and get_hr_salary.gross_net eq 0)
							puantaj_exts[i_ek_od][15] = puantaj_exts[i_ek_od][15]/30*ssk_days;
							
						if(len(puantaj_exts[i_ek_od][40]) and total_pay_ssk_tax gt 0)
						{
							this_ek_ucret_isveren = wrk_round((total_pay_ssk_tax - puantaj_exts[i_ek_od][40]) * this_ek_ucret_isveren / total_pay_ssk_tax);
						}
						else
							this_ek_ucret_isveren = 0;
							
						puantaj_exts[i_ek_od][22] = this_ek_ucret_isveren;
						puantaj_exts[i_ek_od][23] = this_ek_ucret_isveren_issizlik;
						puantaj_exts[i_ek_od][24] = this_ek_ucret_isci;
						puantaj_exts[i_ek_od][25] = this_ek_ucret_isci_issizlik;
						puantaj_exts[i_ek_od][26] = this_ek_ucret_gelir;
						puantaj_exts[i_ek_od][27] = this_ek_ucret_damga;

						if(puantaj_exts[i_ek_od][43] eq 1)
						{
							rd_dahil_olan_gelir_vergisi = rd_dahil_olan_gelir_vergisi + this_ek_ucret_gelir;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir;
							}
						}
						else
						{
							rd_dahil_olmayan_gelir_vergisi = rd_dahil_olmayan_gelir_vergisi + this_ek_ucret_gelir;	
						}
						
						if(puantaj_exts[i_ek_od][42] eq 1)
						{
							rd_dahil_olan_damga_vergisi = rd_dahil_olan_damga_vergisi + this_ek_ucret_damga;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga;
							}
						}
						else
						{
							rd_dahil_olmayan_damga_vergisi = rd_dahil_olmayan_damga_vergisi + this_ek_ucret_damga;	
						}
						
						if(puantaj_exts[i_ek_od][44] eq 1)
						{
							rd_dahil_olan_ssk_isveren_hissesi = rd_dahil_olan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren;
							}
						}
						else
						{
							rd_dahil_olmayan_ssk_isveren_hissesi = rd_dahil_olmayan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(this_ek_ucret_isveren gt 0)
								rd_dahil_olmayan_ssk_matrah = rd_dahil_olmayan_ssk_matrah + puantaj_exts[i_ek_od][3];
						}
					} 
					else if(get_pay_salary.ssk[i_ek_od] eq 2 and get_pay_salary.tax[i_ek_od] eq 2 and get_pay_salary.IS_DAMGA[i_ek_od] eq 0 and get_pay_salary.IS_ISSIZLIK[i_ek_od] eq 1)//sadece damga muaf 23062022ERU
					{
						if((ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7] eq 1 or puantaj_exts[i_ek_od][7] eq 2) and puantaj_exts[i_ek_od][8] neq 0)
						{
							total_pay_ssk_tax = total_pay_ssk_tax + puantaj_exts[i_ek_od][8];
							total_pay_unstamped = total_pay_unstamped + puantaj_exts[i_ek_od][8];
						}
						else{
							total_pay_ssk_tax = total_pay_ssk_tax + puantaj_exts[i_ek_od][3];
							total_pay_unstamped = total_pay_unstamped + puantaj_exts[i_ek_od][3];
						}
							

						if(arraylen(puantaj_exts[i_ek_od]) gte 40 and len(puantaj_exts[i_ek_od][40]))
							ssk_matraha_dahil_olmayan_odenek_tutar =  ssk_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][40];
						
						if(arraylen(puantaj_exts[i_ek_od]) gte 41 and len(puantaj_exts[i_ek_od][41]))
							vergi_matraha_dahil_olmayan_odenek_tutar = vergi_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][41];

						brut_salary = salary;
						a_g_m_ = asgari_gecim_max_tutar_;
						ozel_kesinti_ = ozel_kesinti;
						ozel_kesinti = 0;	
						ozel_kesinti_2_ = ozel_kesinti_2;
						ozel_kesinti_2 = 0;				
						include 'get_hr_compass_from_brut.cfm';
						ozel_kesinti = ozel_kesinti_;
						ozel_kesinti_2 = ozel_kesinti_2;
						asgari_gecim_max_tutar_ = a_g_m_;
						salary = brut_salary;
						
						this_ek_ucret_net = net_ucret - maas_net_ucreti_  - onceki_odenek_netleri_toplam; //+ ozel_kesinti
						this_ek_ucret_gelir = gelir_vergisi - maas_gelir_vergisi_ - onceki_odenek_gelir_toplam;
						this_ek_ucret_damga = damga_vergisi - maas_damga_vergisi_ - onceki_odenek_damga_toplam;
						this_ek_ucret_isveren = ssk_isveren_hissesi - maas_ssk_isveren_hissesi_ - onceki_odenek_isveren_toplam;
						this_ek_ucret_isci = ssk_isci_hissesi - maas_ssk_isci_hissesi_ - onceki_odenek_isci_toplam;
						this_ek_ucret_isveren_issizlik = issizlik_isveren_hissesi - maas_ssk_isveren_issizlik_ - onceki_odenek_isveren_issizlik_toplam;
						this_ek_ucret_isci_issizlik = issizlik_isci_hissesi - maas_ssk_isci_issizlik_ - onceki_odenek_isci_issizlik_toplam;
						onceki_odenek_netleri_toplam = onceki_odenek_netleri_toplam + this_ek_ucret_net;
						onceki_odenek_gelir_toplam = onceki_odenek_gelir_toplam + this_ek_ucret_gelir;
						onceki_odenek_damga_toplam = onceki_odenek_damga_toplam + this_ek_ucret_damga;
						onceki_odenek_isveren_toplam = onceki_odenek_isveren_toplam + this_ek_ucret_isveren;
						onceki_odenek_isci_toplam = onceki_odenek_isci_toplam + this_ek_ucret_isci;
						onceki_odenek_isveren_issizlik_toplam = onceki_odenek_isveren_issizlik_toplam + this_ek_ucret_isveren_issizlik;
						onceki_odenek_isci_issizlik_toplam = onceki_odenek_isci_issizlik_toplam + this_ek_ucret_isci_issizlik;

						if((ArrayIsDefined(puantaj_exts[i_ek_od],33)and puantaj_exts[i_ek_od][33] eq 1) or (ArrayIsDefined(puantaj_exts[i_ek_od],32) and puantaj_exts[i_ek_od][32] neq 1))
							puantaj_exts[i_ek_od][15] = this_ek_ucret_net;
						else if(ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7] neq 0 and get_hr_salary.gross_net eq 0)
							puantaj_exts[i_ek_od][15] = puantaj_exts[i_ek_od][15]/30*ssk_days;
						puantaj_exts[i_ek_od][22] = this_ek_ucret_isveren;
						puantaj_exts[i_ek_od][23] = this_ek_ucret_isveren_issizlik;
						puantaj_exts[i_ek_od][24] = this_ek_ucret_isci;
						puantaj_exts[i_ek_od][25] = this_ek_ucret_isci_issizlik;
						puantaj_exts[i_ek_od][26] = this_ek_ucret_gelir;
						puantaj_exts[i_ek_od][27] = this_ek_ucret_damga;

						if(puantaj_exts[i_ek_od][43] eq 1)
						{
							rd_dahil_olan_gelir_vergisi = rd_dahil_olan_gelir_vergisi + this_ek_ucret_gelir;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir;
							}
						}
						else
						{
							rd_dahil_olmayan_gelir_vergisi = rd_dahil_olmayan_gelir_vergisi + this_ek_ucret_gelir;	
						}
						
						if(puantaj_exts[i_ek_od][42] eq 1)
						{
							rd_dahil_olan_damga_vergisi = rd_dahil_olan_damga_vergisi + this_ek_ucret_damga;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga;
							}
						}
						else
						{
							rd_dahil_olmayan_damga_vergisi = rd_dahil_olmayan_damga_vergisi + this_ek_ucret_damga;	
						}
						
						if(puantaj_exts[i_ek_od][44] eq 1)
						{
							rd_dahil_olan_ssk_isveren_hissesi = rd_dahil_olan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren;
							}
						}
						else
						{
							rd_dahil_olmayan_ssk_isveren_hissesi = rd_dahil_olmayan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(this_ek_ucret_isveren gt 0)
								rd_dahil_olmayan_ssk_matrah = rd_dahil_olmayan_ssk_matrah + puantaj_exts[i_ek_od][3];
						}
						
					}
				
				}
				from_net = 0;
				is_brut_payment = 0;	
			}
			if(ext_salary_net gt 0)
			{
				brut_salary = salary;
				izin_oncesi_kumulatif_gelir=kumulatif_gelir;
				a_g_m_ = asgari_gecim_max_tutar_;
				ozel_kesinti_ = ozel_kesinti;
				ozel_kesinti = 0;
				tutar_ = ext_salary_net;
					is_tax_ = 1;
					is_ssk_ = 1;
					is_mesai_ = 1;
					include 'get_hr_compass_from_net_odenek.cfm';
					ext_salary = eklenen;
				salary = brut_salary;
				ozel_kesinti = ozel_kesinti_;					
				asgari_gecim_max_tutar_ = a_g_m_;
				ext_salary_gelir_vergisi = gelir_vergisi;
				ext_salary_damga_vergisi = damga_vergisi;
				this_ek_ucret_isci = ssk_isci_hissesi;
				this_ek_ucret_isci_issizlik = issizlik_isci_hissesi;
				kumulatif_gelir=izin_oncesi_kumulatif_gelir;

				onceki_odenek_isci_toplam = onceki_odenek_isci_toplam + this_ek_ucret_isci;
				onceki_odenek_isci_issizlik_toplam = onceki_odenek_isci_issizlik_toplam + this_ek_ucret_isci_issizlik;
				ekten_gelen = ekten_gelen + eklenen;

				if(get_active_program_parameter.is_5746_overtime neq 1)
				{
					rd_dahil_olmayan_extsalary_ssk_isveren_hissesi = this_ek_ucret_isveren;
					rd_dahil_olmayan_extsalary_gelir_vergisi = ext_salary_gelir_vergisi;
					rd_dahil_olmayan_extsalary_damga_vergisi = ext_salary_damga_vergisi;					
				}
				else
				{
					rd_dahil_extsalary_ssk_isveren_hissesi = this_ek_ucret_isveren;
					rd_dahil_extsalary_gelir_vergisi = ext_salary_gelir_vergisi;
					rd_dahil_extsalary_damga_vergisi = ext_salary_damga_vergisi;
				}

			}
			//izinde matrahı aşıyorsa brüt ücreti ssk tavanına tabi tutmuyordu. O yüzden yeri değiştirildi.
			if(izin_netten_hesaplama eq 1 and yillik_izin_amount_1 gt 0)
			{
				tutar_ = yillik_izin_amount_1;
				attributes.yillik_izin_amount_net = tutar_;
				is_izin_ = 1;
				is_mesai_ = 0;
				is_tax_ = 1;
				is_ssk_ = 1;
				is_issizlik_ = 1;
				is_ssk_tax_net_odenek = 0;
				if(get_hr_ssk.IS_TAX_FREE eq 1 and get_hr_ssk.IS_DAMGA_FREE eq 1 and listfind('8,9,10,19',get_hr_ssk.SSK_STATUTE))
				{
					daily_minimum_wage_stamp_tax = temp_daily_minimum_wage_stamp_tax;
					is_yearly_offtime = 1;
				}
				include 'get_hr_compass_from_net_odenek.cfm';
				if(get_hr_ssk.IS_TAX_FREE eq 1 and get_hr_ssk.IS_DAMGA_FREE eq 1 and listfind('8,9,10,19',get_hr_ssk.SSK_STATUTE))
				{
					is_yearly_offtime = 0;
				}
				attributes.yillik_izin_amount = eklenen;
				yillik_izin_amount_1 = attributes.yillik_izin_amount;
			}
			//this
			if(included_in_tax_hour_paid gt 0 and get_hr_ssk.IS_TAX_FREE eq 1 and get_hr_ssk.IS_DAMGA_FREE eq 1)
			{
				is_included_in_tax_hour_paid = 1;
				
				/*tempp = first_salary_temp;
				first_salary_temp = sal_temp;*/
				///*  */first_salary_temp = tempp;
				include 'get_hr_compass_2022.cfm';
				is_yearly_offtime = 1;
				flag = true;
				sal_temp = included_in_tax_hour_paid * hourly_salary;
				temp_salary_es = salary; 
				salary_ilk = salary;
				ekten_gelen = 0;
				count = 1;
				while(flag)
				{
					count = count + 1;
					kontrol = salary;
					gelir_vergisi_matrah = kontrol;
					include 'get_hr_compass_tax.cfm';
					include 'get_hr_compass_formuls.cfm';
					include 'get_hr_compass_from_net.cfm';
					//	if (count gte 60 or sal_temp eq net_ucret)
					if (count gte 60 or sal_temp eq net_ucret  or wrk_round(sal_temp) eq net_ucret  or sal_temp eq wrk_round(net_ucret))
					{
						flag = false;
					}
					else if (net_ucret gt sal_temp)
						salary = kontrol - (net_ucret - sal_temp);
					else if (net_ucret lt sal_temp)
						salary = kontrol + (sal_temp - net_ucret);
				}
				
				//writeoutput("---------------------------------------<br>")
				if(wrk_round(sal_temp - net_ucret) eq 0.01)
				{
					salary = salary + 0.01;
					ssk_matrah = ssk_matrah + 0.01;
				}
				//writeoutput("net_ucret : #net_ucret# : #salary# gelir_vergisi #gelir_vergisi# damga_vergisi : #damga_vergisi#<br>")
				included_in_tax_paid_amount_brut = salary;
				if (get_hr_ssk.SSK_STATUTE eq 2 or get_hr_ssk.SSK_STATUTE eq 18)
				{
					included_in_tax_paid_amount_employee = ssdf_isci_hissesi;
					included_in_tax_paid_amount_unemployment = 0;
				}
				else
				{
					included_in_tax_paid_amount_employee = ssk_isci_hissesi;
					included_in_tax_paid_amount_unemployment = issizlik_isci_hissesi;
				}
				included_in_tax_paid_amount_brut_base = included_in_tax_paid_amount_brut - included_in_tax_paid_amount_employee - included_in_tax_paid_amount_unemployment;
			
				//yıllık izinin brütü ayrı olduğu için ayırıldı.
				offtime_amount = (temp_salary_es / (total_work_hour/7.5))*((total_work_hour-included_in_tax_hour_paid)/7.5);
				salary = offtime_amount + included_in_tax_paid_amount_brut;
				net_ucret = -1;
				sal_temp = offtime_amount + included_in_tax_paid_amount_brut;
				ilk_salary = salary;
				brut_salary = salary;
				included_in_tax_paid_amount_stamp_tax = damga_vergisi;
				included_in_tax_paid_amount_income_tax = gelir_vergisi;
				is_yearly_offtime = 0;
				is_included_in_tax_hour_paid = 0;
				
			}  
			/*SG 20130227_ */
			if(yillik_izin_amount_1 gt 0)
			{
				attributes.yillik_izin_amount = yillik_izin_amount_1;
				brut_salary = salary;
				a_g_m_ = asgari_gecim_max_tutar_;
				ozel_kesinti_ = ozel_kesinti;
				ozel_kesinti = 0;
				from_net = 1;
				include 'get_hr_compass_from_brut.cfm';
				from_net = 0;
				ozel_kesinti = ozel_kesinti_;					
				asgari_gecim_max_tutar_ = a_g_m_;
				salary = brut_salary;
				
				
				/* Önceki Ayd.Dev.SGK Matrahı var ise yıllik iznin ssk payini hesaplarken düşülmesi gereken ssk payi */
				if(ssk_matrah_kullanilan gt 0)
				{
					onceki_aydan_devreden_isci_hissesi = ssk_matrah_kullanilan*ssk_isci_carpan/100;
					onceki_aydan_devreden_isci_issizlik_hissesi = ssk_matrah_kullanilan*issizlik_isci_carpan/100;
				} else {
					onceki_aydan_devreden_isci_hissesi = 0;
					onceki_aydan_devreden_isci_issizlik_hissesi = 0;
				}
				
				this_ek_ucret_net = net_ucret - maas_net_ucreti_ - ext_salary_net - onceki_odenek_netleri_toplam;
				this_ek_ucret_gelir = gelir_vergisi - maas_gelir_vergisi_ - ext_salary_gelir_vergisi - onceki_odenek_gelir_toplam;
				this_ek_ucret_damga = damga_vergisi - maas_damga_vergisi_ - ext_salary_damga_vergisi - onceki_odenek_damga_toplam;
				this_ek_ucret_isveren = ssk_isveren_hissesi - maas_ssk_isveren_hissesi_ - onceki_odenek_isveren_toplam;

				this_ek_ucret_isci = ssk_isci_hissesi - maas_ssk_isci_hissesi_ - onceki_odenek_isci_toplam - onceki_aydan_devreden_isci_hissesi;
				this_ek_ucret_isveren_issizlik = issizlik_isveren_hissesi - maas_ssk_isveren_issizlik_ - onceki_odenek_isveren_issizlik_toplam;
				this_ek_ucret_isci_issizlik = issizlik_isci_hissesi - maas_ssk_isci_issizlik_ - onceki_odenek_isci_issizlik_toplam - onceki_aydan_devreden_isci_issizlik_hissesi;

				onceki_odenek_netleri_toplam = onceki_odenek_netleri_toplam + this_ek_ucret_net;
				onceki_odenek_gelir_toplam = onceki_odenek_gelir_toplam + this_ek_ucret_gelir;
				onceki_odenek_damga_toplam = onceki_odenek_damga_toplam + this_ek_ucret_damga;
				onceki_odenek_isveren_toplam = onceki_odenek_isveren_toplam + this_ek_ucret_isveren;
				onceki_odenek_isci_toplam = onceki_odenek_isci_toplam + this_ek_ucret_isci;
				onceki_odenek_isveren_issizlik_toplam = onceki_odenek_isveren_issizlik_toplam + this_ek_ucret_isveren_issizlik;
				onceki_odenek_isci_issizlik_toplam = onceki_odenek_isci_issizlik_toplam + this_ek_ucret_isci_issizlik;
				yillik_izin_net = this_ek_ucret_net;
				yillik_izin_gelir_vergisi = this_ek_ucret_gelir;
				yillik_izin_damga_vergisi = this_ek_ucret_damga;
				yillik_izin_isveren_toplam = this_ek_ucret_isveren;
				yillik_izin_isci_toplam = this_ek_ucret_isci;
				yillik_izin_isveren_issizlik_toplam = this_ek_ucret_isveren_issizlik;
				yillik_izin_isci_issizlik_toplam = this_ek_ucret_isci_issizlik;
			}
			if(kidem_amount_1 gt 0)
			{
				attributes.kidem_amount = kidem_amount_1;
				brut_salary = salary;
				a_g_m_ = asgari_gecim_max_tutar_;
				ozel_kesinti_ = ozel_kesinti;
				ozel_kesinti = 0;			
				from_net = 1;		
				include 'get_hr_compass_from_brut.cfm';
				from_net = 0;
				ozel_kesinti = ozel_kesinti_;					
				asgari_gecim_max_tutar_ = a_g_m_;
				salary = brut_salary;
				
				this_ek_ucret_net = net_ucret - maas_net_ucreti_ - ext_salary_net - onceki_odenek_netleri_toplam;
				this_ek_ucret_damga = damga_vergisi - maas_damga_vergisi_ - ext_salary_damga_vergisi-onceki_odenek_damga_toplam;
				kidem_net = this_ek_ucret_net;			
				kidem_damga_vergisi = this_ek_ucret_damga;
				
				onceki_odenek_netleri_toplam = onceki_odenek_netleri_toplam + this_ek_ucret_net;
				onceki_odenek_damga_toplam = onceki_odenek_damga_toplam + this_ek_ucret_damga;
			}
			
			if(ihbar_amount_1 gt 0)
			{
				attributes.ihbar_amount = ihbar_amount_1;
				brut_salary = salary;
				a_g_m_ = asgari_gecim_max_tutar_;
				ozel_kesinti_ = ozel_kesinti;
				ozel_kesinti = 0;		
				from_net = 1;			
				include 'get_hr_compass_from_brut.cfm';
				from_net = 0;
				ozel_kesinti = ozel_kesinti_;					
				asgari_gecim_max_tutar_ = a_g_m_;
				salary = brut_salary;
				
				this_ek_ucret_net = net_ucret - maas_net_ucreti_ - ext_salary_net - onceki_odenek_netleri_toplam;
				this_ek_ucret_gelir = gelir_vergisi - maas_gelir_vergisi_ - ext_salary_gelir_vergisi-onceki_odenek_gelir_toplam;
				this_ek_ucret_damga = damga_vergisi - maas_damga_vergisi_ - ext_salary_damga_vergisi-onceki_odenek_damga_toplam;
				onceki_odenek_netleri_toplam = onceki_odenek_netleri_toplam + this_ek_ucret_net;
				onceki_odenek_gelir_toplam = onceki_odenek_gelir_toplam + this_ek_ucret_gelir;
				onceki_odenek_damga_toplam = onceki_odenek_damga_toplam + this_ek_ucret_damga;
				ihbar_net = this_ek_ucret_net;
				ihbar_gelir_vergisi = this_ek_ucret_gelir;
				ihbar_damga_vergisi = this_ek_ucret_damga;
			}

			// dv ve v muaf 05042022ERU
			if(total_pay_ssk_net_damgasiz gt 0)
			{
				temp_total_pay_ssk_net = total_pay_ssk_net;
				temp_total_pay_ssk = total_pay_ssk;
				total_pay_ssk_net = total_pay_ssk_net_damgasiz;
				tutar_ = total_pay_ssk_net_damgasiz;
			
				is_mesai_ = 0;
				is_izin_ = 0;
				is_tax_ = 0;
				is_ssk_ = 1;
				is_issizlik_ = 1;
				is_damga_ = 0;
				from_net = 1;
				include 'get_hr_compass_from_net_odenek.cfm';
				ekten_gelen = ekten_gelen + eklenen;
				StructDelete(Variables , "is_damga_");
				total_pay_ssk_untax_diff = total_pay_ssk_untax_diff + (total_pay_ssk - total_pay_ssk_net);
				total_pay_ssk = temp_total_pay_ssk + total_pay_ssk;
				total_pay_ssk_net = temp_total_pay_ssk_net + total_pay_ssk_net;
			}		
			//Damga hariç ödenek 22062022ERU
			if(total_pay_ssk_tax_net_notstamp gt 0)
			{
				temp_total_pay_ssk_tax_net = total_pay_ssk_tax_net;
				temp_total_pay_ssk_tax = total_pay_ssk_tax;
				total_pay_ssk_tax_net = total_pay_ssk_tax_net_notstamp;
				tutar_ = total_pay_ssk_tax_net_notstamp;
				is_mesai_ = 0;
				is_izin_ = 0;
				is_tax_ = 1;
				is_ssk_ = 1;
				is_issizlik_ = 1;
				is_damga_ = 0;
				from_net = 1;
				is_not_stamp = 1;
				include 'get_hr_compass_from_net_odenek.cfm';
				is_not_stamp = 0;

				ekten_gelen = ekten_gelen + eklenen;
				total_pay_ssk_tax_notstamp_base = eklenen;
				total_pay_ssk_tax_net_notstamp_base = total_pay_ssk_tax_net_notstamp;
				StructDelete(Variables , "is_damga_");
				total_pay_ssk_tax = temp_total_pay_ssk_tax;
				total_pay_ssk_tax_net = temp_total_pay_ssk_tax_net;
			}		
			/*SG 20130227_ */
			//burada eskiye dönüyor
			salary = ilk_salary;
			gelir_vergisi_matrah = odenek_oncesi_gelir_vergisi_matrah;
			gelir_vergisi = odenek_oncesi_gelir_vergisi;
			damga_vergisi = odenek_oncesi_damga_vergisi;
			kumulatif_gelir = odenek_oncesi_kumulatif_gelir;
			// netten vergi istisnasi alanlar
			from_net = 1;
			if(old_except lt yillik_toplam_asgari_ucret)
			{
				include 'get_hr_compass_tax_exception_osi.cfm';
				include 'get_hr_compass_tax_exception_bei.cfm';
				include 'get_hr_compass_tax_exception_boss.cfm';
				include 'get_hr_compass_tax_exception.cfm';	
			}

				
			if((isdefined("kidem_amount_1") and kidem_amount_1 gt 0) or from_fire_action eq 1 )
			{
				
				flag = true;
				temp_sal = salary;
				sal_temp = seniority_salary;
				temp_net = net_ucret;
				salary_ilk = seniority_salary
				ekten_gelen = 0;
				count = 1;
				while(flag)
				{
					count = count + 1;
					kontrol = salary;
					gelir_vergisi_matrah = kontrol;
					include 'get_hr_compass_tax.cfm';
					include 'get_hr_compass_formuls.cfm';
					include 'get_hr_compass_from_net.cfm';
					//	if (count gte 60 or sal_temp eq net_ucret)
					if (count gte 60 or sal_temp eq net_ucret  or wrk_round(sal_temp) eq net_ucret  or sal_temp eq wrk_round(net_ucret))
					{
						flag = false;
					}
					else if (net_ucret gt sal_temp)
						salary = kontrol - (net_ucret - sal_temp);
					else if (net_ucret lt sal_temp)
						salary = kontrol + (sal_temp - net_ucret);
				}
				
				//writeoutput("---------------------------------------<br>")
				if(wrk_round(sal_temp - net_ucret) eq 0.01)
				{
					salary = salary + 0.01;
					ssk_matrah = ssk_matrah + 0.01;
				}
				seniority_salary = salary;
				salary = temp_sal;
				net_ucret = temp_net;
				ilk_salary = salary;
				brut_salary = salary;
				
			}  
				// netten vergi istisnasi alanlar
		}
		else // (get_hr_salary.gross_net eq 0) brut ucret 
		{
			ekten_gelen = 0;
			//Memur değilse izinler maaşı etkiler
			if(use_ssk neq 2)
			{
				if (get_hr_salary.salary_type eq 2) //aylık
				{
					//Aylik Ucret
					hourly_salary = get_hr_salary.salary / get_hours.ssk_monthly_work_hours;
					salary = (get_hr_salary.salary * ssk_days)/ssk_full_days;

					if(get_active_program_parameter.FULL_DAY eq 0 and daysinmonth(last_month_30) eq 31 and ssk_days eq 31 and izin eq 0)
					{
						salary = (get_hr_salary.salary * ssk_full_days)/30;
					}
					else if(get_active_program_parameter.FULL_DAY eq 0 and daysinmonth(last_month_30) eq 31 and ssk_days eq 31 and izin gt 0)
					{
						salary = (get_hr_salary.salary * ssk_days)/ssk_full_days;
					}
					else if(get_active_program_parameter.FULL_DAY eq 0 and daysinmonth(last_month_30) eq 31 and ssk_days lt 31)
					{
						salary = (get_hr_salary.salary * ssk_days)/30;
					}
					//Kısa ÇAlışma Ödeneği Esma R. Uysal 24.04.2020
					
					
				}
				else if (get_hr_salary.salary_type eq 1) //günlük
				{
					//Gunluk Ucret
					hourly_salary = get_hr_salary.salary / get_hours.ssk_work_hours;
					salary = get_hr_salary.salary * work_days;
				}
				else if (get_hr_salary.salary_type eq 0)//saatlik
				{
					hourly_salary = get_hr_salary.salary;
					salary = get_hr_salary.salary * (total_hours + get_half_offtimes_total_hour);
				}
				else
					hourly_salary = 0;
				
				
				//yarim gunluk izinler gerekirse maastan düsülecek
				if(get_active_program_parameter.offtime_count_type eq 1 and get_half_offtimes.recordcount and len(get_half_offtimes_total_hour))
				{
					half_offtime_day_total = hourly_salary * get_half_offtimes_total_hour;
					half_offtime_day_total_net = 0;
					salary = salary - half_offtime_day_total;
				}
				else
				{
					half_offtime_day_total = 0;
					half_offtime_day_total_net = 0;
				}			
			}
			else
			{
				half_offtime_day_total = 0;
				half_offtime_day_total_net = 0;
				hourly_salary = 0;
			}
			//yarim gunluk izinler gerekirse maastan düsülecek

			mesai_salary = salary;
			if(isdefined("attributes.statue_type") and attributes.statue_type eq 9)
			{
				hourly_salary = weekday_rate_value  * weekday_fee_value;
			}
			
			hourly_salary_brut = hourly_salary;

			if(included_in_tax_hour_paid gt 0 and get_hr_ssk.IS_TAX_FREE eq 1 and get_hr_ssk.IS_DAMGA_FREE eq 1)
			{
				included_in_tax_paid_amount = included_in_tax_hour_paid * hourly_salary_brut;
			}
			
			// default fazla mesailer, sadece gunluk ve aylik ucretliler icin hesaplaniyor (toplam ssk gunune oranla ) 20040821
			if (len(get_hr_ssk.fazla_mesai_saat) and isnumeric(get_hr_ssk.fazla_mesai_saat) and get_hr_ssk.fazla_mesai_saat neq 0)
			{/*saat olarak tam kismi alinir*/
				if(ext_total_hours_0 neq ext_total_hours_3)
				{
					ext_total_hours_0 = ext_total_hours_0 + (ssk_days*get_hr_ssk.fazla_mesai_saat) \ ssk_full_days;/*ssk_days yerine (ssk_days-izin) olmali*/
					ext_salary = ext_salary + (ext_total_hours_0 * (get_active_program_parameter.EX_TIME_PERCENT_HIGH/100) * hourly_salary);
				}
				else
				{
					ext_total_hours_in_out = (ssk_days*get_hr_ssk.fazla_mesai_saat) \ ssk_full_days;/*ssk_days yerine (ssk_days-izin) olmali*/
					ext_salary = ext_salary + (ext_total_hours_in_out * (get_active_program_parameter.EX_TIME_PERCENT_HIGH/100) * hourly_salary);
					ext_total_hours_0 = ext_total_hours_in_out + ext_total_hours_0;
				}
			}

			if(len(get_active_program_parameter.WEEKEND_MULTIPLIER))
				ext_salary = ext_salary + (ext_total_hours_1 * get_active_program_parameter.WEEKEND_MULTIPLIER * hourly_salary);
			else
				ext_salary = ext_salary + (ext_total_hours_1 * (get_active_program_parameter.EX_TIME_PERCENT_HIGH/100) * hourly_salary);
			
			if(len(get_active_program_parameter.OFFICIAL_MULTIPLIER))
				ext_salary = ext_salary + (ext_total_hours_2 * hourly_salary * get_active_program_parameter.OFFICIAL_MULTIPLIER);
			else
				ext_salary = ext_salary + (ext_total_hours_2 * hourly_salary);
			
			ext_salary = ext_salary + (ext_total_hours_3 * (get_active_program_parameter.EX_TIME_PERCENT_HIGH/100) * hourly_salary);// 45 saati asan kisim
	
			ext_salary = ext_salary + (ext_total_hours_4 * (get_active_program_parameter.EX_TIME_PERCENT/100) * hourly_salary);// 45 saate kadar kisim
			
			if(len(get_active_program_parameter.NIGHT_MULTIPLIER))
				ext_salary = ext_salary + (ext_total_hours_5 * get_active_program_parameter.NIGHT_MULTIPLIER * hourly_salary);
			else
				ext_salary = ext_salary + (ext_total_hours_5 * (10 / 100) * hourly_salary);
					//--Muzaffer Bas---
			if(len(get_active_program_parameter.WEEKEND_DAY_MULTIPLIER))
				ext_salary = ext_salary + (ext_total_hours_8 * get_active_program_parameter.WEEKEND_DAY_MULTIPLIER * hourly_salary);
			else
			ext_salary = ext_salary + (ext_total_hours_8 * get_active_program_parameter.EX_TIME_PERCENT_HIGH / 100 * hourly_salary);
			if(len(get_active_program_parameter.AKDI_DAY_MULTIPLIER))
			ext_salary = ext_salary + (ext_total_hours_9 * get_active_program_parameter.AKDI_DAY_MULTIPLIER * hourly_salary);
			else
			ext_salary = ext_salary + (ext_total_hours_9 * get_active_program_parameter.EX_TIME_PERCENT_HIGH / 100 * hourly_salary);
			if(len(get_active_program_parameter.OFFICIAL_DAY_MULTIPLIER))
			ext_salary = ext_salary + (ext_total_hours_10 * get_active_program_parameter.OFFICIAL_DAY_MULTIPLIER * hourly_salary);
			else
			ext_salary = ext_salary + (ext_total_hours_10 * get_active_program_parameter.EX_TIME_PERCENT_HIGH / 100 * hourly_salary);
			if(len(get_active_program_parameter.ARAFE_DAY_MULTIPLIER))
			ext_salary = ext_salary + (ext_total_hours_11 * get_active_program_parameter.ARAFE_DAY_MULTIPLIER * hourly_salary);
			else
			ext_salary = ext_salary + (ext_total_hours_11 * get_active_program_parameter.EX_TIME_PERCENT_HIGH / 100 * hourly_salary);
			if(len(get_active_program_parameter.DINI_DAY_MULTIPLIER))
			ext_salary = ext_salary + (ext_total_hours_12 * get_active_program_parameter.DINI_DAY_MULTIPLIER * hourly_salary);
			else
			ext_salary = ext_salary + (ext_total_hours_12 * get_active_program_parameter.EX_TIME_PERCENT_HIGH / 100 * hourly_salary);

           //--Muzaffer Bas--	
			is_devir_matrah_off = 1;
			//ilk maas net_ucreti bulunur
			brut_salary = salary;
			ext_salary_1 = ext_salary;
			ext_salary = 0;
			ozel_kesinti_1 = ozel_kesinti;
			ozel_kesinti = 0; 
			//odenek sifirlama sonra geri alinacak
			total_pay_ssk_tax_1 = total_pay_ssk_tax;
			total_pay_tax_1 = total_pay_tax;
			total_pay_ssk_noissizlik_1 = total_pay_ssk_noissizlik;
			total_pay_1 = total_pay;
			total_pay_ssk_tax_noissizlik_1 = total_pay_ssk_tax_noissizlik;
			total_pay_d_1 = total_pay_d;
			total_pay_ssk_1 = total_pay_ssk;
			yillik_izin_amount_1 = attributes.yillik_izin_amount;
			kidem_amount_1 = attributes.kidem_amount;
			ihbar_amount_1 = attributes.ihbar_amount;
			
			ssk_matraha_dahil_olmayan_odenek_tutar_1 = ssk_matraha_dahil_olmayan_odenek_tutar;
			vergi_matraha_dahil_olmayan_odenek_tutar_1 = vergi_matraha_dahil_olmayan_odenek_tutar;
			
			ssk_matraha_dahil_olmayan_odenek_tutar = 0;
			vergi_matraha_dahil_olmayan_odenek_tutar = 0;
			total_pay_ssk_tax = 0;
			total_pay_tax = 0;
			total_pay_ssk_noissizlik = 0;
			total_pay = 0;
			total_pay_ssk_tax_noissizlik = 0;
			total_pay_d = 0;
			total_pay_ssk = 0;
			attributes.yillik_izin_amount = 0;
			attributes.kidem_amount = 0;
			attributes.ihbar_amount = 0;
			//odenek sifirlama sonra geri alinacak
			a_g_m_ = asgari_gecim_max_tutar_;
			net_ucret_kontrol = 1;
			ozel_kesinti_ = ozel_kesinti;
			ozel_kesinti = 0;			
			include 'get_hr_compass_from_brut.cfm';
			ozel_kesinti = ozel_kesinti_;			
			net_ucret_kontrol = 0;
			asgari_gecim_max_tutar_ = a_g_m_;
			salary = brut_salary;
			ext_salary = ext_salary_1;
			ozel_kesinti = ozel_kesinti_1;
			
			maas_net_ucreti_ = net_ucret;

			//Çalışan Memursa
			if(use_ssk eq 2 and unpaid_offtime eq 0)
			{
				bes_isci_hissesi =  fix(wrk_round(sgk_base/100) * bes_isci_carpan );
				//Net Maaş Tutarı - Aile Yardımı Tutarı - Çocuk Yardımı Tutarı – Toplu Sözleşme İkramiyesi – Nafaka Tutarı + Sendika Kesintisi + Bireysel Emeklilik Kesintisi + Lojman Kesintisi + Kişi Borcu + Kefalet Kesintis
				maas_net_ucreti_ = officer_total_salary - (gelir_vergisi + damga_vergisi + retirement_allowance_5510  + retirement_allowance_personal_5510 + retirement_allowance + 
				retirement_allowance_personal + plus_retired + health_insurance_premium_5510 + general_health_insurance + health_insurance_premium_personal_5510 + bes_isci_hissesi + ozel_kesinti + ozel_kesinti_2 + avans + vergi_istisna_total + family_assistance + child_assistance + collective_agreement_bonus + penance_deduction);
			}
			else if(use_ssk eq 2 and unpaid_offtime neq 0)
			{
				bes_isci_hissesi = 0;
				maas_net_ucreti_ = 0;
			}
			
			maas_gelir_vergisi_ = gelir_vergisi;
			maas_damga_vergisi_ = damga_vergisi;
			maas_ssk_isveren_hissesi_ = ssk_isveren_hissesi;
			maas_ssk_isci_hissesi_ = ssk_isci_hissesi;
			maas_ssk_isveren_issizlik_ = issizlik_isveren_hissesi;
			maas_ssk_isci_issizlik_ = issizlik_isci_hissesi;
			//ilk maas net_ucreti bulunur
			if(isdefined("kisa_calisma") and kisa_calisma eq 1)
			{
				short_working_calc = salary;
				kisa_calisma = 0;
				if(isdefined("toplam_calisma_gunu") and len(toplam_calisma_gunu) and toplam_calisma_gunu neq 0)
					ssk_days = toplam_calisma_gunu;
			}
			//fazla mesai net ucreti bulunur
			if(ext_salary gt 0)
			{
				brut_salary = salary;
				a_g_m_ = asgari_gecim_max_tutar_;
				ozel_kesinti_ = ozel_kesinti;
				ozel_kesinti = 0;			
				include 'get_hr_compass_from_brut.cfm';
				ozel_kesinti = ozel_kesinti_;			
				asgari_gecim_max_tutar_ = a_g_m_;
				salary = brut_salary;
				ext_salary_net = net_ucret - maas_net_ucreti_ ; // SG 20140204 fazla mesai net tutarinda kesinti_tutari dahil olmayacagi icin kapatıldı (ozel_kesinti)
				
				ext_salary_gelir = gelir_vergisi - maas_gelir_vergisi_;
				ext_salary_damga = damga_vergisi - maas_damga_vergisi_;
				ext_salary_isveren = ssk_isveren_hissesi - maas_ssk_isveren_hissesi_;
				ext_salary_isci = ssk_isci_hissesi - maas_ssk_isci_hissesi_;
				ext_salary_isveren_issizlik = issizlik_isveren_hissesi - maas_ssk_isveren_issizlik_;
				ext_salary_isci_issizlik = issizlik_isci_hissesi - maas_ssk_isci_issizlik_;
				
				if(get_active_program_parameter.is_5746_overtime neq 1)
				{
					rd_dahil_olmayan_extsalary_ssk_isveren_hissesi = ext_salary_isveren;
					rd_dahil_olmayan_extsalary_gelir_vergisi = ext_salary_gelir;
					rd_dahil_olmayan_extsalary_damga_vergisi = ext_salary_damga;					
				}
				else
				{
					rd_dahil_extsalary_ssk_isveren_hissesi = ext_salary_isveren;
					rd_dahil_extsalary_gelir_vergisi = ext_salary_gelir;
					rd_dahil_extsalary_damga_vergisi = ext_salary_damga;
				}
			}
			else
			{
				ext_salary_gelir = 0;
				ext_salary_damga = 0;
				ext_salary_isveren = 0;
				ext_salary_isci = 0;
				ext_salary_isveren_issizlik = 0;
				ext_salary_isci_issizlik = 0;
			}
			
			//fazla mesai net ucreti bulunur
			
			onceki_odenek_netleri_toplam = 0;
			onceki_odenek_gelir_toplam = 0;
			onceki_odenek_damga_toplam = 0;
			onceki_odenek_isveren_toplam = 0;
			onceki_odenek_isci_toplam = 0;
			onceki_odenek_isveren_issizlik_toplam = 0;
			onceki_odenek_isci_issizlik_toplam = 0;

			
			//tum odenekleri ayrı al
			for (i_ek_od=1; i_ek_od lte arraylen(puantaj_exts); i_ek_od = i_ek_od+1)
			{
				if(puantaj_exts[i_ek_od][6] eq 0 and puantaj_exts[i_ek_od][9] eq 1)//brut odenekler net karşılıklarını bul
				{
					if(puantaj_exts[i_ek_od][4] eq 2 and puantaj_exts[i_ek_od][5] eq 2 and puantaj_exts[i_ek_od][13] eq 1 and puantaj_exts[i_ek_od][14] eq 1)
					{
						/* % methodlu ödenek de amount2 tutarını gönder SG 20130508 */
						if(listfind('2,3,4',get_pay_salary.method_pay[i_ek_od],','))
							{total_pay_ssk_tax = total_pay_ssk_tax + puantaj_exts[i_ek_od][8];}
						else 
							{total_pay_ssk_tax = total_pay_ssk_tax + puantaj_exts[i_ek_od][3];}
						brut_salary = salary;
						a_g_m_ = asgari_gecim_max_tutar_;
						ozel_kesinti_ = ozel_kesinti;
						ozel_kesinti = 0;
						
						if(len(puantaj_exts[i_ek_od][40]))
						{
							ssk_matraha_dahil_olmayan_odenek_tutar = ssk_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][40];
						}
						
						if(len(puantaj_exts[i_ek_od][41]))
						{
							vergi_matraha_dahil_olmayan_odenek_tutar = vergi_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][41];
						}
						
						include 'get_hr_compass_from_brut.cfm';
						ozel_kesinti = ozel_kesinti_;
						asgari_gecim_max_tutar_ = a_g_m_;
						salary = brut_salary;
						
						this_ek_ucret_net = net_ucret - maas_net_ucreti_ - ext_salary_net - onceki_odenek_netleri_toplam ; //+ ozel_kesinti
						this_ek_ucret_gelir = gelir_vergisi - maas_gelir_vergisi_ - ext_salary_gelir - onceki_odenek_gelir_toplam;
						this_ek_ucret_damga = damga_vergisi - maas_damga_vergisi_ - ext_salary_damga - onceki_odenek_damga_toplam;
						this_ek_ucret_isveren = ssk_isveren_hissesi - maas_ssk_isveren_hissesi_ - ext_salary_isveren - onceki_odenek_isveren_toplam;
						this_ek_ucret_isci = ssk_isci_hissesi - maas_ssk_isci_hissesi_ - ext_salary_isci -  onceki_odenek_isci_toplam;
						this_ek_ucret_isveren_issizlik = issizlik_isveren_hissesi - maas_ssk_isveren_issizlik_ - ext_salary_isveren_issizlik - onceki_odenek_isveren_issizlik_toplam;
						this_ek_ucret_isci_issizlik = issizlik_isci_hissesi - maas_ssk_isci_issizlik_ - ext_salary_isci_issizlik - onceki_odenek_isci_issizlik_toplam;
						
						onceki_odenek_netleri_toplam = onceki_odenek_netleri_toplam + this_ek_ucret_net;
						onceki_odenek_gelir_toplam = onceki_odenek_gelir_toplam + this_ek_ucret_gelir;
						onceki_odenek_damga_toplam = onceki_odenek_damga_toplam + this_ek_ucret_damga;
						onceki_odenek_isveren_toplam = onceki_odenek_isveren_toplam + this_ek_ucret_isveren;
						onceki_odenek_isci_toplam = onceki_odenek_isci_toplam + this_ek_ucret_isci;
						onceki_odenek_isveren_issizlik_toplam = onceki_odenek_isveren_issizlik_toplam + this_ek_ucret_isveren_issizlik;
						onceki_odenek_isci_issizlik_toplam = onceki_odenek_isci_issizlik_toplam + this_ek_ucret_isci_issizlik;
						
						if((ArrayIsDefined(puantaj_exts[i_ek_od],33)and puantaj_exts[i_ek_od][33] eq 1) or (ArrayIsDefined(puantaj_exts[i_ek_od],32) and puantaj_exts[i_ek_od][32] neq 1))
							puantaj_exts[i_ek_od][15] = this_ek_ucret_net;
						else if(ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7] neq 0 and get_hr_salary.gross_net eq 0)
							puantaj_exts[i_ek_od][15] = puantaj_exts[i_ek_od][15]/30*ssk_days;
						
						puantaj_exts[i_ek_od][22] = this_ek_ucret_isveren;
						puantaj_exts[i_ek_od][23] = this_ek_ucret_isveren_issizlik;
						puantaj_exts[i_ek_od][24] = this_ek_ucret_isci;
						puantaj_exts[i_ek_od][25] = this_ek_ucret_isci_issizlik;
						puantaj_exts[i_ek_od][26] = this_ek_ucret_gelir;
						puantaj_exts[i_ek_od][27] = this_ek_ucret_damga;

						if(puantaj_exts[i_ek_od][43] eq 1)
						{
							rd_dahil_olan_gelir_vergisi = rd_dahil_olan_gelir_vergisi + this_ek_ucret_gelir;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir;
							}
						}
						else
						{
							rd_dahil_olmayan_gelir_vergisi = rd_dahil_olmayan_gelir_vergisi + this_ek_ucret_gelir;	
						}
						
						if(puantaj_exts[i_ek_od][42] eq 1)
						{
							rd_dahil_olan_damga_vergisi = rd_dahil_olan_damga_vergisi + this_ek_ucret_damga;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga;
							}
						}
						else
						{
							rd_dahil_olmayan_damga_vergisi = rd_dahil_olmayan_damga_vergisi + this_ek_ucret_damga;	
						}
						
						if(puantaj_exts[i_ek_od][44] eq 1)
						{
							rd_dahil_olan_ssk_isveren_hissesi = rd_dahil_olan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren;
							}
						}
						else
						{
							rd_dahil_olmayan_ssk_isveren_hissesi = rd_dahil_olmayan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							//abort('rd_dahil_olmayan_ssk_isveren_hissesi:#rd_dahil_olmayan_ssk_isveren_hissesi# ssk_matraha_dahil_olmayan_odenek_tutar:#ssk_matraha_dahil_olmayan_odenek_tutar#');
							if(this_ek_ucret_isveren gt 0)
								rd_dahil_olmayan_ssk_matrah = rd_dahil_olmayan_ssk_matrah + puantaj_exts[i_ek_od][3];
						}
					}
					else if(get_pay_salary.ssk[i_ek_od] eq 1 and get_pay_salary.tax[i_ek_od] eq 1 and get_pay_salary.IS_DAMGA[i_ek_od] eq 0 and get_pay_salary.IS_ISSIZLIK[i_ek_od] eq 0)
					{
						/* % methodlu ödenek de amount2 tutarını gönder SG 20130508 */
						if(listfind('2,3,4',get_pay_salary.method_pay[i_ek_od],','))
							{total_pay = total_pay + puantaj_exts[i_ek_od][8];}
						else 
							{total_pay = total_pay + puantaj_exts[i_ek_od][3];}
						
						//total_pay = total_pay + puantaj_exts[i_ek_od][3];
						brut_salary = salary;
						a_g_m_ = asgari_gecim_max_tutar_;
						ozel_kesinti_ = ozel_kesinti;
						ozel_kesinti = 0;	
						
						if(len(puantaj_exts[i_ek_od][40]))
						{
							ssk_matraha_dahil_olmayan_odenek_tutar = ssk_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][40];
						}
						
						if(len(puantaj_exts[i_ek_od][41]))
						{
							vergi_matraha_dahil_olmayan_odenek_tutar = vergi_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][41];
						}
						
						include 'get_hr_compass_from_brut.cfm';
						ozel_kesinti = ozel_kesinti_;						
						asgari_gecim_max_tutar_ = a_g_m_;
						salary = brut_salary;

						this_ek_ucret_net = net_ucret - maas_net_ucreti_ - ext_salary_net - onceki_odenek_netleri_toplam ; //+ ozel_kesinti
						this_ek_ucret_gelir = gelir_vergisi - maas_gelir_vergisi_ - ext_salary_gelir - onceki_odenek_gelir_toplam;
						this_ek_ucret_damga = damga_vergisi - maas_damga_vergisi_ - ext_salary_damga - onceki_odenek_damga_toplam;
						this_ek_ucret_isveren = ssk_isveren_hissesi - maas_ssk_isveren_hissesi_ - ext_salary_isveren - onceki_odenek_isveren_toplam;
						this_ek_ucret_isci = ssk_isci_hissesi - maas_ssk_isci_hissesi_ - ext_salary_isci -  onceki_odenek_isci_toplam;
						this_ek_ucret_isveren_issizlik = issizlik_isveren_hissesi - maas_ssk_isveren_issizlik_ - ext_salary_isveren_issizlik - onceki_odenek_isveren_issizlik_toplam;
						this_ek_ucret_isci_issizlik = issizlik_isci_hissesi - maas_ssk_isci_issizlik_ - ext_salary_isci_issizlik - onceki_odenek_isci_issizlik_toplam;
						
						//writeoutput("2 : this_ek_ucret_net : #this_ek_ucret_net#<br>");
						onceki_odenek_netleri_toplam = onceki_odenek_netleri_toplam + this_ek_ucret_net;
						onceki_odenek_gelir_toplam = onceki_odenek_gelir_toplam + this_ek_ucret_gelir;
						onceki_odenek_damga_toplam = onceki_odenek_damga_toplam + this_ek_ucret_damga;
						onceki_odenek_isveren_toplam = onceki_odenek_isveren_toplam + this_ek_ucret_isveren;
						onceki_odenek_isci_toplam = onceki_odenek_isci_toplam + this_ek_ucret_isci;
						onceki_odenek_isveren_issizlik_toplam = onceki_odenek_isveren_issizlik_toplam + this_ek_ucret_isveren_issizlik;
						onceki_odenek_isci_issizlik_toplam = onceki_odenek_isci_issizlik_toplam + this_ek_ucret_isci_issizlik;

						if((ArrayIsDefined(puantaj_exts[i_ek_od],33)and puantaj_exts[i_ek_od][33] eq 1) or (ArrayIsDefined(puantaj_exts[i_ek_od],32) and puantaj_exts[i_ek_od][32] neq 1))
							puantaj_exts[i_ek_od][15] = this_ek_ucret_net;
						else if(ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7] neq 0 and get_hr_salary.gross_net eq 0)
							puantaj_exts[i_ek_od][15] = puantaj_exts[i_ek_od][15]/30*ssk_days;
							
						puantaj_exts[i_ek_od][22] = this_ek_ucret_isveren;
						puantaj_exts[i_ek_od][23] = this_ek_ucret_isveren_issizlik;
						puantaj_exts[i_ek_od][24] = this_ek_ucret_isci;
						puantaj_exts[i_ek_od][25] = this_ek_ucret_isci_issizlik;
						puantaj_exts[i_ek_od][26] = this_ek_ucret_gelir;
						puantaj_exts[i_ek_od][27] = this_ek_ucret_damga;

						if(puantaj_exts[i_ek_od][43] eq 1)
						{
							rd_dahil_olan_gelir_vergisi = rd_dahil_olan_gelir_vergisi + this_ek_ucret_gelir;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir;
							}
						}
						else
						{
							rd_dahil_olmayan_gelir_vergisi = rd_dahil_olmayan_gelir_vergisi + this_ek_ucret_gelir;	
						}
						
						if(puantaj_exts[i_ek_od][42] eq 1)
						{
							rd_dahil_olan_damga_vergisi = rd_dahil_olan_damga_vergisi + this_ek_ucret_damga;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga;
							}
						}
						else
						{
							rd_dahil_olmayan_damga_vergisi = rd_dahil_olmayan_damga_vergisi + this_ek_ucret_damga;	
						}
						
						if(puantaj_exts[i_ek_od][44] eq 1)
						{
							rd_dahil_olan_ssk_isveren_hissesi = rd_dahil_olan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren;
							}
						}
						else
						{
							rd_dahil_olmayan_ssk_isveren_hissesi = rd_dahil_olmayan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(this_ek_ucret_isveren gt 0)
								rd_dahil_olmayan_ssk_matrah = rd_dahil_olmayan_ssk_matrah + puantaj_exts[i_ek_od][3];
						}
					}
					else if (get_pay_salary.ssk[i_ek_od] eq 1 and get_pay_salary.tax[i_ek_od] eq 1 and get_pay_salary.IS_DAMGA[i_ek_od] eq 1 and get_pay_salary.IS_ISSIZLIK[i_ek_od] eq 0)
					{
						//total_pay_d = total_pay_d + puantaj_exts[i_ek_od][3];
						/* % methodlu ödenek de amount2 tutarını gönder SG 20130508 */
						if(listfind('2,3,4',get_pay_salary.method_pay[i_ek_od],','))
							{total_pay_d = total_pay_d + puantaj_exts[i_ek_od][8];}
						else 
							{total_pay_d = total_pay_d + puantaj_exts[i_ek_od][3];}
						
						brut_salary = salary;
						a_g_m_ = asgari_gecim_max_tutar_;
						ozel_kesinti_ = ozel_kesinti;
						ozel_kesinti = 0;		
						
						if(len(puantaj_exts[i_ek_od][40]))
						{
							ssk_matraha_dahil_olmayan_odenek_tutar = ssk_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][40];
						}
						
						if(len(puantaj_exts[i_ek_od][41]))
						{
							vergi_matraha_dahil_olmayan_odenek_tutar = vergi_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][41];
						}
								
						include 'get_hr_compass_from_brut.cfm';
						ozel_kesinti = ozel_kesinti_;						
						asgari_gecim_max_tutar_ = a_g_m_;
						salary = brut_salary;
						
						this_ek_ucret_net = net_ucret - maas_net_ucreti_ - ext_salary_net - onceki_odenek_netleri_toplam ; //+ ozel_kesinti
						this_ek_ucret_gelir = gelir_vergisi - maas_gelir_vergisi_ - ext_salary_gelir - onceki_odenek_gelir_toplam;
						this_ek_ucret_damga = damga_vergisi - maas_damga_vergisi_ - ext_salary_damga - onceki_odenek_damga_toplam;
						this_ek_ucret_isveren = ssk_isveren_hissesi - maas_ssk_isveren_hissesi_ - ext_salary_isveren - onceki_odenek_isveren_toplam;
						this_ek_ucret_isci = ssk_isci_hissesi - maas_ssk_isci_hissesi_ - ext_salary_isci -  onceki_odenek_isci_toplam;
						this_ek_ucret_isveren_issizlik = issizlik_isveren_hissesi - maas_ssk_isveren_issizlik_ - ext_salary_isveren_issizlik - onceki_odenek_isveren_issizlik_toplam;
						this_ek_ucret_isci_issizlik = issizlik_isci_hissesi - maas_ssk_isci_issizlik_ - ext_salary_isci_issizlik - onceki_odenek_isci_issizlik_toplam;

						onceki_odenek_netleri_toplam = onceki_odenek_netleri_toplam + this_ek_ucret_net;
						onceki_odenek_gelir_toplam = onceki_odenek_gelir_toplam + this_ek_ucret_gelir;
						onceki_odenek_damga_toplam = onceki_odenek_damga_toplam + this_ek_ucret_damga;
						onceki_odenek_isveren_toplam = onceki_odenek_isveren_toplam + this_ek_ucret_isveren;
						onceki_odenek_isci_toplam = onceki_odenek_isci_toplam + this_ek_ucret_isci;
						onceki_odenek_isveren_issizlik_toplam = onceki_odenek_isveren_issizlik_toplam + this_ek_ucret_isveren_issizlik;
						onceki_odenek_isci_issizlik_toplam = onceki_odenek_isci_issizlik_toplam + this_ek_ucret_isci_issizlik;

						if((ArrayIsDefined(puantaj_exts[i_ek_od],33)and puantaj_exts[i_ek_od][33] eq 1) or (ArrayIsDefined(puantaj_exts[i_ek_od],32) and puantaj_exts[i_ek_od][32] neq 1))
							puantaj_exts[i_ek_od][15] = this_ek_ucret_net;
						else if(ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7] neq 0 and get_hr_salary.gross_net eq 0)
							puantaj_exts[i_ek_od][15] = puantaj_exts[i_ek_od][15]/30*ssk_days;
							
						puantaj_exts[i_ek_od][22] = this_ek_ucret_isveren;
						puantaj_exts[i_ek_od][23] = this_ek_ucret_isveren_issizlik;
						puantaj_exts[i_ek_od][24] = this_ek_ucret_isci;
						puantaj_exts[i_ek_od][25] = this_ek_ucret_isci_issizlik;
						puantaj_exts[i_ek_od][26] = this_ek_ucret_gelir;
						puantaj_exts[i_ek_od][27] = this_ek_ucret_damga;

						if(puantaj_exts[i_ek_od][43] eq 1)
						{
							rd_dahil_olan_gelir_vergisi = rd_dahil_olan_gelir_vergisi + this_ek_ucret_gelir;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir;
							}
						}
						else
						{
							rd_dahil_olmayan_gelir_vergisi = rd_dahil_olmayan_gelir_vergisi + this_ek_ucret_gelir;	
						}
						
						if(puantaj_exts[i_ek_od][42] eq 1)
						{
							rd_dahil_olan_damga_vergisi = rd_dahil_olan_damga_vergisi + this_ek_ucret_damga;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga;
							}
						}
						else
						{
							rd_dahil_olmayan_damga_vergisi = rd_dahil_olmayan_damga_vergisi + this_ek_ucret_damga;	
						}
						
						if(puantaj_exts[i_ek_od][44] eq 1)
						{
							rd_dahil_olan_ssk_isveren_hissesi = rd_dahil_olan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren;
							}
						}
						else
						{
							rd_dahil_olmayan_ssk_isveren_hissesi = rd_dahil_olmayan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(this_ek_ucret_isveren gt 0)
								rd_dahil_olmayan_ssk_matrah = rd_dahil_olmayan_ssk_matrah + puantaj_exts[i_ek_od][3];
						}	
					}
					else if(get_pay_salary.ssk[i_ek_od] eq 2 and get_pay_salary.tax[i_ek_od] eq 2 and get_pay_salary.IS_DAMGA[i_ek_od] eq 1 and get_pay_salary.IS_ISSIZLIK[i_ek_od] eq 1)
					{
						//total_pay_ssk_tax = total_pay_ssk_tax + puantaj_exts[i_ek_od][3];
						/* % methodlu ödenek de amount2 tutarını gönder SG 20130508 */
						
						if(listfind('2,3,4',get_pay_salary.method_pay[i_ek_od],','))
							{total_pay_ssk_tax = total_pay_ssk_tax + puantaj_exts[i_ek_od][8];}
						else 
							{total_pay_ssk_tax = total_pay_ssk_tax + puantaj_exts[i_ek_od][3];}
						
						brut_salary = salary;
						a_g_m_ = asgari_gecim_max_tutar_;
						ozel_kesinti_ = ozel_kesinti;
						ozel_kesinti = 0;
						
						if(len(puantaj_exts[i_ek_od][40]))
						{
							ssk_matraha_dahil_olmayan_odenek_tutar = ssk_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][40];
						}
						
						if(len(puantaj_exts[i_ek_od][41]))
						{
							vergi_matraha_dahil_olmayan_odenek_tutar = vergi_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][41];
						}
						
						include 'get_hr_compass_from_brut.cfm';
						ozel_kesinti = ozel_kesinti_;						
						asgari_gecim_max_tutar_ = a_g_m_;
						salary = brut_salary;
						
						this_ek_ucret_net = net_ucret - maas_net_ucreti_ - ext_salary_net - onceki_odenek_netleri_toplam ; //+ ozel_kesinti
						this_ek_ucret_gelir = gelir_vergisi - maas_gelir_vergisi_ - ext_salary_gelir - onceki_odenek_gelir_toplam;
						this_ek_ucret_damga = damga_vergisi - maas_damga_vergisi_ - ext_salary_damga - onceki_odenek_damga_toplam;
						this_ek_ucret_isveren = ssk_isveren_hissesi - maas_ssk_isveren_hissesi_ - ext_salary_isveren - onceki_odenek_isveren_toplam;
						this_ek_ucret_isci = ssk_isci_hissesi - maas_ssk_isci_hissesi_ - ext_salary_isci -  onceki_odenek_isci_toplam;
						this_ek_ucret_isveren_issizlik = issizlik_isveren_hissesi - maas_ssk_isveren_issizlik_ - ext_salary_isveren_issizlik - onceki_odenek_isveren_issizlik_toplam;
						this_ek_ucret_isci_issizlik = issizlik_isci_hissesi - maas_ssk_isci_issizlik_ - ext_salary_isci_issizlik - onceki_odenek_isci_issizlik_toplam;

						onceki_odenek_netleri_toplam = onceki_odenek_netleri_toplam + this_ek_ucret_net;
						onceki_odenek_gelir_toplam = onceki_odenek_gelir_toplam + this_ek_ucret_gelir;
						onceki_odenek_damga_toplam = onceki_odenek_damga_toplam + this_ek_ucret_damga;
						onceki_odenek_isveren_toplam = onceki_odenek_isveren_toplam + this_ek_ucret_isveren;
						onceki_odenek_isci_toplam = onceki_odenek_isci_toplam + this_ek_ucret_isci;
						onceki_odenek_isveren_issizlik_toplam = onceki_odenek_isveren_issizlik_toplam + this_ek_ucret_isveren_issizlik;
						onceki_odenek_isci_issizlik_toplam = onceki_odenek_isci_issizlik_toplam + this_ek_ucret_isci_issizlik;

						if((ArrayIsDefined(puantaj_exts[i_ek_od],33)and puantaj_exts[i_ek_od][33] eq 1) or (ArrayIsDefined(puantaj_exts[i_ek_od],32) and puantaj_exts[i_ek_od][32] neq 1))
							puantaj_exts[i_ek_od][15] = this_ek_ucret_net;
						else if(ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7] neq 0 and get_hr_salary.gross_net eq 0)
							puantaj_exts[i_ek_od][15] = puantaj_exts[i_ek_od][15]/30*ssk_days;
							
							
						if(len(puantaj_exts[i_ek_od][40]))
						{
							this_ek_ucret_isveren = wrk_round((total_pay_ssk_tax - puantaj_exts[i_ek_od][40]) * this_ek_ucret_isveren / total_pay_ssk_tax);
						}
							
						puantaj_exts[i_ek_od][22] = this_ek_ucret_isveren;
						puantaj_exts[i_ek_od][23] = this_ek_ucret_isveren_issizlik;
						puantaj_exts[i_ek_od][24] = this_ek_ucret_isci;
						puantaj_exts[i_ek_od][25] = this_ek_ucret_isci_issizlik;
						puantaj_exts[i_ek_od][26] = this_ek_ucret_gelir;
						puantaj_exts[i_ek_od][27] = this_ek_ucret_damga;

						if(puantaj_exts[i_ek_od][43] eq 1)
						{
							rd_dahil_olan_gelir_vergisi = rd_dahil_olan_gelir_vergisi + this_ek_ucret_gelir;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir;
							}
						}
						else
						{
							rd_dahil_olmayan_gelir_vergisi = rd_dahil_olmayan_gelir_vergisi + this_ek_ucret_gelir;	
						}
						
						if(puantaj_exts[i_ek_od][42] eq 1)
						{
							rd_dahil_olan_damga_vergisi = rd_dahil_olan_damga_vergisi + this_ek_ucret_damga;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga;
							}
						}
						else
						{
							rd_dahil_olmayan_damga_vergisi = rd_dahil_olmayan_damga_vergisi + this_ek_ucret_damga;	
						}
						
						if(puantaj_exts[i_ek_od][44] eq 1)
						{
							rd_dahil_olan_ssk_isveren_hissesi = rd_dahil_olan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren;
							}
						}
						else
						{
							rd_dahil_olmayan_ssk_isveren_hissesi = rd_dahil_olmayan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(this_ek_ucret_isveren gt 0)
								rd_dahil_olmayan_ssk_matrah = rd_dahil_olmayan_ssk_matrah + puantaj_exts[i_ek_od][3];
						}
						//abort('puantaj_exts[i_ek_od][15]:#puantaj_exts[i_ek_od][15]# net_ucret:#net_ucret#-maas_net_ucreti_:#maas_net_ucreti_#-ext_salary_net:#ext_salary_net#-#onceki_odenek_netleri_toplam#');
					}
					else if (get_pay_salary.ssk[i_ek_od] eq 1 and get_pay_salary.tax[i_ek_od] eq 2 and get_pay_salary.IS_DAMGA[i_ek_od] eq 1 and get_pay_salary.IS_ISSIZLIK[i_ek_od] eq 0)
					{
						//total_pay_tax = total_pay_tax + puantaj_exts[i_ek_od][3];
						/* % methodlu ödenek de amount2 tutarını gönder SG 20130508 */
						if(listfind('2,3,4',get_pay_salary.method_pay[i_ek_od],','))
							{total_pay_tax = total_pay_tax + puantaj_exts[i_ek_od][8];}
						else 
							{total_pay_tax = total_pay_tax + puantaj_exts[i_ek_od][3];}
						brut_salary = salary;
						a_g_m_ = asgari_gecim_max_tutar_;
						//writeoutput("5 : maas_net_ucreti_ : #maas_net_ucreti_#<br>");
						ozel_kesinti_ = ozel_kesinti;
						ozel_kesinti = 0;				

						if(len(puantaj_exts[i_ek_od][40]))
						{
							ssk_matraha_dahil_olmayan_odenek_tutar = ssk_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][40];
						}
						
						if(len(puantaj_exts[i_ek_od][41]))
						{
							vergi_matraha_dahil_olmayan_odenek_tutar = vergi_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][41];
						}
						
						include 'get_hr_compass_from_brut.cfm';
						ozel_kesinti = ozel_kesinti_;
						asgari_gecim_max_tutar_ = a_g_m_;
						salary = brut_salary;
						
						this_ek_ucret_net = net_ucret - maas_net_ucreti_ - ext_salary_net - onceki_odenek_netleri_toplam ; //+ ozel_kesinti
						this_ek_ucret_gelir = gelir_vergisi - maas_gelir_vergisi_ - ext_salary_gelir - onceki_odenek_gelir_toplam;
						this_ek_ucret_damga = damga_vergisi - maas_damga_vergisi_ - ext_salary_damga - onceki_odenek_damga_toplam;
						this_ek_ucret_isveren = ssk_isveren_hissesi - maas_ssk_isveren_hissesi_ - ext_salary_isveren - onceki_odenek_isveren_toplam;
						this_ek_ucret_isci = ssk_isci_hissesi - maas_ssk_isci_hissesi_ - ext_salary_isci -  onceki_odenek_isci_toplam;
						this_ek_ucret_isveren_issizlik = issizlik_isveren_hissesi - maas_ssk_isveren_issizlik_ - ext_salary_isveren_issizlik - onceki_odenek_isveren_issizlik_toplam;
						this_ek_ucret_isci_issizlik = issizlik_isci_hissesi - maas_ssk_isci_issizlik_ - ext_salary_isci_issizlik - onceki_odenek_isci_issizlik_toplam;						
						
						//writeoutput("net_ucret:#net_ucret#");
						//("maas_net_ucreti_:#maas_net_ucreti_#");
						//writeoutput("ext_salary_net:#ext_salary_net#");
						//writeoutput("onceki_odenek_netleri_toplam:#onceki_odenek_netleri_toplam#");
						onceki_odenek_netleri_toplam = onceki_odenek_netleri_toplam + this_ek_ucret_net;
						onceki_odenek_gelir_toplam = onceki_odenek_gelir_toplam + this_ek_ucret_gelir;
						onceki_odenek_damga_toplam = onceki_odenek_damga_toplam + this_ek_ucret_damga;
						onceki_odenek_isveren_toplam = onceki_odenek_isveren_toplam + this_ek_ucret_isveren;
						onceki_odenek_isci_toplam = onceki_odenek_isci_toplam + this_ek_ucret_isci;
						onceki_odenek_isveren_issizlik_toplam = onceki_odenek_isveren_issizlik_toplam + this_ek_ucret_isveren_issizlik;
						onceki_odenek_isci_issizlik_toplam = onceki_odenek_isci_issizlik_toplam + this_ek_ucret_isci_issizlik;

						if((ArrayIsDefined(puantaj_exts[i_ek_od],33)and puantaj_exts[i_ek_od][33] eq 1) or (ArrayIsDefined(puantaj_exts[i_ek_od],32) and puantaj_exts[i_ek_od][32] neq 1))
							puantaj_exts[i_ek_od][15] = this_ek_ucret_net;
						else if(ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7] neq 0 and get_hr_salary.gross_net eq 0)
							puantaj_exts[i_ek_od][15] = puantaj_exts[i_ek_od][15]/30*ssk_days;
							
						puantaj_exts[i_ek_od][22] = this_ek_ucret_isveren;
						puantaj_exts[i_ek_od][23] = this_ek_ucret_isveren_issizlik;
						puantaj_exts[i_ek_od][24] = this_ek_ucret_isci;
						puantaj_exts[i_ek_od][25] = this_ek_ucret_isci_issizlik;
						puantaj_exts[i_ek_od][26] = this_ek_ucret_gelir;
						puantaj_exts[i_ek_od][27] = this_ek_ucret_damga;

						if(puantaj_exts[i_ek_od][43] eq 1)
						{
							rd_dahil_olan_gelir_vergisi = rd_dahil_olan_gelir_vergisi + this_ek_ucret_gelir;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir;
							}
						}
						else
						{
							rd_dahil_olmayan_gelir_vergisi = rd_dahil_olmayan_gelir_vergisi + this_ek_ucret_gelir;	
						}
						
						if(puantaj_exts[i_ek_od][42] eq 1)
						{
							rd_dahil_olan_damga_vergisi = rd_dahil_olan_damga_vergisi + this_ek_ucret_damga;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga;
							}
						}
						else
						{
							rd_dahil_olmayan_damga_vergisi = rd_dahil_olmayan_damga_vergisi + this_ek_ucret_damga;	
						}
						
						if(puantaj_exts[i_ek_od][44] eq 1)
						{
							rd_dahil_olan_ssk_isveren_hissesi = rd_dahil_olan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren;
							}
						}
						else
						{
							rd_dahil_olmayan_ssk_isveren_hissesi = rd_dahil_olmayan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(this_ek_ucret_isveren gt 0)
								rd_dahil_olmayan_ssk_matrah = rd_dahil_olmayan_ssk_matrah + puantaj_exts[i_ek_od][3];
						}	
					}
					else if ((get_pay_salary.ssk[i_ek_od] eq 2) and (get_pay_salary.tax[i_ek_od] eq 2) and (get_pay_salary.IS_DAMGA[i_ek_od] eq 1) and (get_pay_salary.IS_ISSIZLIK[i_ek_od] eq 0)) // sadece issizlik yok
					{
						//total_pay_ssk_tax_noissizlik = total_pay_ssk_tax_noissizlik + puantaj_exts[i_ek_od][3];
						/* % methodlu ödenek de amount2 tutarını gönder SG 20130508 */
						if(listfind('2,3,4',get_pay_salary.method_pay[i_ek_od],','))
							{total_pay_ssk_tax_noissizlik = total_pay_ssk_tax_noissizlik + puantaj_exts[i_ek_od][8];}
						else 
							{total_pay_ssk_tax_noissizlik = total_pay_ssk_tax_noissizlik + puantaj_exts[i_ek_od][3];}
						
						brut_salary = salary;
						a_g_m_ = asgari_gecim_max_tutar_;
						ozel_kesinti_ = ozel_kesinti;
						ozel_kesinti = 0;			
						
						if(len(puantaj_exts[i_ek_od][40]))
						{
							ssk_matraha_dahil_olmayan_odenek_tutar = ssk_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][40];
						}
						
						if(len(puantaj_exts[i_ek_od][41]))
						{
							vergi_matraha_dahil_olmayan_odenek_tutar = vergi_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][41];
						}
						
						include 'get_hr_compass_from_brut.cfm';
						ozel_kesinti = ozel_kesinti_;						
						asgari_gecim_max_tutar_ = a_g_m_;
						salary = brut_salary;
						
						this_ek_ucret_net = net_ucret - maas_net_ucreti_ - ext_salary_net - onceki_odenek_netleri_toplam ; //+ ozel_kesinti
						this_ek_ucret_gelir = gelir_vergisi - maas_gelir_vergisi_ - ext_salary_gelir - onceki_odenek_gelir_toplam;
						this_ek_ucret_damga = damga_vergisi - maas_damga_vergisi_ - ext_salary_damga - onceki_odenek_damga_toplam;
						this_ek_ucret_isveren = ssk_isveren_hissesi - maas_ssk_isveren_hissesi_ - ext_salary_isveren - onceki_odenek_isveren_toplam;
						this_ek_ucret_isci = ssk_isci_hissesi - maas_ssk_isci_hissesi_ - ext_salary_isci -  onceki_odenek_isci_toplam;
						this_ek_ucret_isveren_issizlik = issizlik_isveren_hissesi - maas_ssk_isveren_issizlik_ - ext_salary_isveren_issizlik - onceki_odenek_isveren_issizlik_toplam;
						this_ek_ucret_isci_issizlik = issizlik_isci_hissesi - maas_ssk_isci_issizlik_ - ext_salary_isci_issizlik - onceki_odenek_isci_issizlik_toplam;
						
						onceki_odenek_netleri_toplam = onceki_odenek_netleri_toplam + this_ek_ucret_net;
						onceki_odenek_gelir_toplam = onceki_odenek_gelir_toplam + this_ek_ucret_gelir;
						onceki_odenek_damga_toplam = onceki_odenek_damga_toplam + this_ek_ucret_damga;
						onceki_odenek_isveren_toplam = onceki_odenek_isveren_toplam + this_ek_ucret_isveren;
						onceki_odenek_isci_toplam = onceki_odenek_isci_toplam + this_ek_ucret_isci;
						onceki_odenek_isveren_issizlik_toplam = onceki_odenek_isveren_issizlik_toplam + this_ek_ucret_isveren_issizlik;
						onceki_odenek_isci_issizlik_toplam = onceki_odenek_isci_issizlik_toplam + this_ek_ucret_isci_issizlik;

						if((ArrayIsDefined(puantaj_exts[i_ek_od],33)and puantaj_exts[i_ek_od][33] eq 1) or (ArrayIsDefined(puantaj_exts[i_ek_od],32) and puantaj_exts[i_ek_od][32] neq 1))
							puantaj_exts[i_ek_od][15] = this_ek_ucret_net;
						else if(ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7] neq 0 and get_hr_salary.gross_net eq 0)
							puantaj_exts[i_ek_od][15] = puantaj_exts[i_ek_od][15]/30*ssk_days;
							
						if(len(puantaj_exts[i_ek_od][40]))
						{
							this_ek_ucret_isveren = wrk_round((total_pay_ssk_tax - puantaj_exts[i_ek_od][40]) * this_ek_ucret_isveren / total_pay_ssk_tax);
						}
							
						puantaj_exts[i_ek_od][22] = this_ek_ucret_isveren;
						puantaj_exts[i_ek_od][23] = this_ek_ucret_isveren_issizlik;
						puantaj_exts[i_ek_od][24] = this_ek_ucret_isci;
						puantaj_exts[i_ek_od][25] = this_ek_ucret_isci_issizlik;
						puantaj_exts[i_ek_od][26] = this_ek_ucret_gelir;
						puantaj_exts[i_ek_od][27] = this_ek_ucret_damga;

						if(puantaj_exts[i_ek_od][43] eq 1)
						{
							rd_dahil_olan_gelir_vergisi = rd_dahil_olan_gelir_vergisi + this_ek_ucret_gelir;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir;
							}
						}
						else
						{
							rd_dahil_olmayan_gelir_vergisi = rd_dahil_olmayan_gelir_vergisi + this_ek_ucret_gelir;	
						}
						
						if(puantaj_exts[i_ek_od][42] eq 1)
						{
							rd_dahil_olan_damga_vergisi = rd_dahil_olan_damga_vergisi + this_ek_ucret_damga;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga;
							}
						}
						else
						{
							rd_dahil_olmayan_damga_vergisi = rd_dahil_olmayan_damga_vergisi + this_ek_ucret_damga;	
						}
						
						if(puantaj_exts[i_ek_od][44] eq 1)
						{
							rd_dahil_olan_ssk_isveren_hissesi = rd_dahil_olan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren;
							}
						}
						else
						{
							rd_dahil_olmayan_ssk_isveren_hissesi = rd_dahil_olmayan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(this_ek_ucret_isveren gt 0)
								rd_dahil_olmayan_ssk_matrah = rd_dahil_olmayan_ssk_matrah + puantaj_exts[i_ek_od][3];
						}
					}
					else if (get_pay_salary.ssk[i_ek_od] eq 2 and get_pay_salary.tax[i_ek_od] eq 1 and get_pay_salary.IS_DAMGA[i_ek_od] eq 0 and get_pay_salary.IS_ISSIZLIK[i_ek_od] eq 0) // sadece ssk var
					{
						//total_pay_ssk_noissizlik = total_pay_ssk_noissizlik + puantaj_exts[i_ek_od][3];
						/* % methodlu ödenek de amount2 tutarını gönder SG 20130508 */
						if(listfind('2,3,4',get_pay_salary.method_pay[i_ek_od],','))
							{total_pay_ssk_noissizlik = total_pay_ssk_noissizlik + puantaj_exts[i_ek_od][8];}
						else 
							{total_pay_ssk_noissizlik = total_pay_ssk_noissizlik + puantaj_exts[i_ek_od][3];}
						
						brut_salary = salary;
						a_g_m_ = asgari_gecim_max_tutar_;
						ozel_kesinti_ = ozel_kesinti;
						ozel_kesinti = 0;		
						
						if(len(puantaj_exts[i_ek_od][40]))
						{
							ssk_matraha_dahil_olmayan_odenek_tutar = ssk_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][40];
						}
						
						if(len(puantaj_exts[i_ek_od][41]))
						{
							vergi_matraha_dahil_olmayan_odenek_tutar = vergi_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][41];
						}
						
						include 'get_hr_compass_from_brut.cfm';
						ozel_kesinti = ozel_kesinti_;						
						asgari_gecim_max_tutar_ = a_g_m_;
						salary = brut_salary;
						
						this_ek_ucret_net = net_ucret - maas_net_ucreti_ - ext_salary_net - onceki_odenek_netleri_toplam ; //+ ozel_kesinti
						this_ek_ucret_gelir = gelir_vergisi - maas_gelir_vergisi_ - ext_salary_gelir - onceki_odenek_gelir_toplam;
						this_ek_ucret_damga = damga_vergisi - maas_damga_vergisi_ - ext_salary_damga - onceki_odenek_damga_toplam;
						this_ek_ucret_isveren = ssk_isveren_hissesi - maas_ssk_isveren_hissesi_ - ext_salary_isveren - onceki_odenek_isveren_toplam;
						this_ek_ucret_isci = ssk_isci_hissesi - maas_ssk_isci_hissesi_ - ext_salary_isci -  onceki_odenek_isci_toplam;
						this_ek_ucret_isveren_issizlik = issizlik_isveren_hissesi - maas_ssk_isveren_issizlik_ - ext_salary_isveren_issizlik - onceki_odenek_isveren_issizlik_toplam;
						this_ek_ucret_isci_issizlik = issizlik_isci_hissesi - maas_ssk_isci_issizlik_ - ext_salary_isci_issizlik - onceki_odenek_isci_issizlik_toplam;
						
						//writeoutput("7 : this_ek_ucret_net : #this_ek_ucret_net#<br>");
						onceki_odenek_netleri_toplam = onceki_odenek_netleri_toplam + this_ek_ucret_net;
						onceki_odenek_gelir_toplam = onceki_odenek_gelir_toplam + this_ek_ucret_gelir;
						onceki_odenek_damga_toplam = onceki_odenek_damga_toplam + this_ek_ucret_damga;
						onceki_odenek_isveren_toplam = onceki_odenek_isveren_toplam + this_ek_ucret_isveren;
						onceki_odenek_isci_toplam = onceki_odenek_isci_toplam + this_ek_ucret_isci;
						onceki_odenek_isveren_issizlik_toplam = onceki_odenek_isveren_issizlik_toplam + this_ek_ucret_isveren_issizlik;
						onceki_odenek_isci_issizlik_toplam = onceki_odenek_isci_issizlik_toplam + this_ek_ucret_isci_issizlik;

						if((ArrayIsDefined(puantaj_exts[i_ek_od],33)and puantaj_exts[i_ek_od][33] eq 1) or (ArrayIsDefined(puantaj_exts[i_ek_od],32) and puantaj_exts[i_ek_od][32] neq 1))
							puantaj_exts[i_ek_od][15] = this_ek_ucret_net;
						else if(ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7] neq 0 and get_hr_salary.gross_net eq 0)
							puantaj_exts[i_ek_od][15] = puantaj_exts[i_ek_od][15]/30*ssk_days;
							
						if(len(puantaj_exts[i_ek_od][40]))
						{
							this_ek_ucret_isveren = wrk_round((total_pay_ssk_tax - puantaj_exts[i_ek_od][40]) * this_ek_ucret_isveren / total_pay_ssk_tax);
						}	
						
						puantaj_exts[i_ek_od][22] = this_ek_ucret_isveren;
						puantaj_exts[i_ek_od][23] = this_ek_ucret_isveren_issizlik;
						puantaj_exts[i_ek_od][24] = this_ek_ucret_isci;
						puantaj_exts[i_ek_od][25] = this_ek_ucret_isci_issizlik;
						puantaj_exts[i_ek_od][26] = this_ek_ucret_gelir;
						puantaj_exts[i_ek_od][27] = this_ek_ucret_damga;	

						if(puantaj_exts[i_ek_od][43] eq 1)
						{
							rd_dahil_olan_gelir_vergisi = rd_dahil_olan_gelir_vergisi + this_ek_ucret_gelir;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir;
							}
						}
						else
						{
							rd_dahil_olmayan_gelir_vergisi = rd_dahil_olmayan_gelir_vergisi + this_ek_ucret_gelir;	
						}
						
						if(puantaj_exts[i_ek_od][42] eq 1)
						{
							rd_dahil_olan_damga_vergisi = rd_dahil_olan_damga_vergisi + this_ek_ucret_damga;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga;
							}
						}
						else
						{
							rd_dahil_olmayan_damga_vergisi = rd_dahil_olmayan_damga_vergisi + this_ek_ucret_damga;	
						}
						
						if(puantaj_exts[i_ek_od][44] eq 1)
						{
							rd_dahil_olan_ssk_isveren_hissesi = rd_dahil_olan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren;
							}
						}
						else
						{
							rd_dahil_olmayan_ssk_isveren_hissesi = rd_dahil_olmayan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(this_ek_ucret_isveren gt 0)
								rd_dahil_olmayan_ssk_matrah = rd_dahil_olmayan_ssk_matrah + puantaj_exts[i_ek_od][3];
						}
					}
					else if (get_pay_salary.ssk[i_ek_od] eq 2 and get_pay_salary.tax[i_ek_od] eq 1 and get_pay_salary.IS_DAMGA[i_ek_od] eq 1 and get_pay_salary.IS_ISSIZLIK[i_ek_od] eq 1) // ssk
					{
						//total_pay_ssk = total_pay_ssk + puantaj_exts[i_ek_od][3];
						/* % methodlu ödenek de amount2 tutarını gönder SG 20130508 */
						if(listfind('2,3,4',get_pay_salary.method_pay[i_ek_od],','))
							{total_pay_ssk = total_pay_ssk + puantaj_exts[i_ek_od][8];}
						else 
							{total_pay_ssk = total_pay_ssk + puantaj_exts[i_ek_od][3];}
						
						brut_salary = salary;
						a_g_m_ = asgari_gecim_max_tutar_;
						ozel_kesinti_ = ozel_kesinti;
						ozel_kesinti = 0;			
						
						if(len(puantaj_exts[i_ek_od][40]))
						{
							ssk_matraha_dahil_olmayan_odenek_tutar = ssk_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][40];
						}
						
						if(len(puantaj_exts[i_ek_od][41]))
						{
							vergi_matraha_dahil_olmayan_odenek_tutar = vergi_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][41];
						}
						
						include 'get_hr_compass_from_brut.cfm';
						ozel_kesinti = ozel_kesinti_;						
						asgari_gecim_max_tutar_ = a_g_m_;
						salary = brut_salary;
						
						this_ek_ucret_net = net_ucret - maas_net_ucreti_ - ext_salary_net - onceki_odenek_netleri_toplam ; //+ ozel_kesinti
						this_ek_ucret_gelir = gelir_vergisi - maas_gelir_vergisi_ - ext_salary_gelir - onceki_odenek_gelir_toplam;
						this_ek_ucret_damga = damga_vergisi - maas_damga_vergisi_ - ext_salary_damga - onceki_odenek_damga_toplam;
						this_ek_ucret_isveren = ssk_isveren_hissesi - maas_ssk_isveren_hissesi_ - ext_salary_isveren - onceki_odenek_isveren_toplam;
						this_ek_ucret_isci = ssk_isci_hissesi - maas_ssk_isci_hissesi_ - ext_salary_isci -  onceki_odenek_isci_toplam;
						this_ek_ucret_isveren_issizlik = issizlik_isveren_hissesi - maas_ssk_isveren_issizlik_ - ext_salary_isveren_issizlik - onceki_odenek_isveren_issizlik_toplam;
						this_ek_ucret_isci_issizlik = issizlik_isci_hissesi - maas_ssk_isci_issizlik_ - ext_salary_isci_issizlik - onceki_odenek_isci_issizlik_toplam;
						
						/*writeoutput("gelir_vergisi:#gelir_vergisi#<br>");
						writeoutput("maas_gelir_vergisi_:#maas_gelir_vergisi_#<br>");
						writeoutput("onceki_odenek_gelir_toplam:#onceki_odenek_gelir_toplam#<br>");
						writeoutput("onceki_odenek_netleri_toplam:#onceki_odenek_netleri_toplam#<br>");*/
						//writeoutput("8 : this_ek_ucret_net : #this_ek_ucret_net#<br>");
						onceki_odenek_netleri_toplam = onceki_odenek_netleri_toplam + this_ek_ucret_net;
						onceki_odenek_gelir_toplam = onceki_odenek_gelir_toplam + this_ek_ucret_gelir;
						onceki_odenek_damga_toplam = onceki_odenek_damga_toplam + this_ek_ucret_damga;
						onceki_odenek_isveren_toplam = onceki_odenek_isveren_toplam + this_ek_ucret_isveren;
						onceki_odenek_isci_toplam = onceki_odenek_isci_toplam + this_ek_ucret_isci;
						onceki_odenek_isveren_issizlik_toplam = onceki_odenek_isveren_issizlik_toplam + this_ek_ucret_isveren_issizlik;
						onceki_odenek_isci_issizlik_toplam = onceki_odenek_isci_issizlik_toplam + this_ek_ucret_isci_issizlik;

						if((ArrayIsDefined(puantaj_exts[i_ek_od],33)and puantaj_exts[i_ek_od][33] eq 1) or (ArrayIsDefined(puantaj_exts[i_ek_od],32) and puantaj_exts[i_ek_od][32] neq 1))
							puantaj_exts[i_ek_od][15] = this_ek_ucret_net;
						else if(ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7] neq 0 and get_hr_salary.gross_net eq 0)
							puantaj_exts[i_ek_od][15] = puantaj_exts[i_ek_od][15]/30*ssk_days;
							
						if(len(puantaj_exts[i_ek_od][40]) and total_pay_ssk_tax gt 0)
						{
							this_ek_ucret_isveren = wrk_round((total_pay_ssk_tax - puantaj_exts[i_ek_od][40]) * this_ek_ucret_isveren / total_pay_ssk_tax);
						}
						else
							this_ek_ucret_isveren = 0;
							
						puantaj_exts[i_ek_od][22] = this_ek_ucret_isveren;
						puantaj_exts[i_ek_od][23] = this_ek_ucret_isveren_issizlik;
						puantaj_exts[i_ek_od][24] = this_ek_ucret_isci;
						puantaj_exts[i_ek_od][25] = this_ek_ucret_isci_issizlik;
						puantaj_exts[i_ek_od][26] = this_ek_ucret_gelir;
						puantaj_exts[i_ek_od][27] = this_ek_ucret_damga;

						if(puantaj_exts[i_ek_od][43] eq 1)
						{
							rd_dahil_olan_gelir_vergisi = rd_dahil_olan_gelir_vergisi + this_ek_ucret_gelir;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir;
							}
						}
						else
						{
							rd_dahil_olmayan_gelir_vergisi = rd_dahil_olmayan_gelir_vergisi + this_ek_ucret_gelir;	
						}
						
						if(puantaj_exts[i_ek_od][42] eq 1)
						{
							rd_dahil_olan_damga_vergisi = rd_dahil_olan_damga_vergisi + this_ek_ucret_damga;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga;
							}
						}
						else
						{
							rd_dahil_olmayan_damga_vergisi = rd_dahil_olmayan_damga_vergisi + this_ek_ucret_damga;	
						}
						
						if(puantaj_exts[i_ek_od][44] eq 1)
						{
							rd_dahil_olan_ssk_isveren_hissesi = rd_dahil_olan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren;
							}
						}
						else
						{
							rd_dahil_olmayan_ssk_isveren_hissesi = rd_dahil_olmayan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(this_ek_ucret_isveren gt 0)
								rd_dahil_olmayan_ssk_matrah = rd_dahil_olmayan_ssk_matrah + puantaj_exts[i_ek_od][3];
						}
					}
					else if ((get_pay_salary.ssk[i_ek_od] eq 1) and (get_pay_salary.tax[i_ek_od] eq 2) and (get_pay_salary.IS_DAMGA[i_ek_od] eq 0) and (get_pay_salary.IS_ISSIZLIK[i_ek_od] eq 0) ) // ssk,vergi,damga,issizlik yok
					{
						//total_pay_tax = total_pay_tax + puantaj_exts[i_ek_od][3];
						/* % methodlu ödenek de amount2 tutarını gönder SG 20130508 */
						if(listfind('2,3,4',get_pay_salary.method_pay[i_ek_od],','))
							{total_pay_tax = total_pay_tax + puantaj_exts[i_ek_od][8];}
						else 
							{total_pay_tax = total_pay_tax + puantaj_exts[i_ek_od][3];}

						if(listfind('2,3,4',get_pay_salary.method_pay[i_ek_od],','))
							{total_pay_unstamped = total_pay_unstamped + puantaj_exts[i_ek_od][8];}
						else 
							{total_pay_unstamped = total_pay_unstamped + puantaj_exts[i_ek_od][3];}

						brut_salary = salary;
						a_g_m_ = asgari_gecim_max_tutar_;
						//writeoutput("5 : maas_net_ucreti_ : #maas_net_ucreti_#<br>");
						ozel_kesinti_ = ozel_kesinti;
						ozel_kesinti = 0;				

						if(len(puantaj_exts[i_ek_od][40]))
						{
							ssk_matraha_dahil_olmayan_odenek_tutar = ssk_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][40];
						}
						
						if(len(puantaj_exts[i_ek_od][41]))
						{
							vergi_matraha_dahil_olmayan_odenek_tutar = vergi_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][41];
						}
						
						include 'get_hr_compass_from_brut.cfm';
						ozel_kesinti = ozel_kesinti_;
						asgari_gecim_max_tutar_ = a_g_m_;
						salary = brut_salary;
						
						this_ek_ucret_net = net_ucret - maas_net_ucreti_ - ext_salary_net - onceki_odenek_netleri_toplam ; //+ ozel_kesinti
						this_ek_ucret_gelir = gelir_vergisi - maas_gelir_vergisi_ - ext_salary_gelir - onceki_odenek_gelir_toplam;
						this_ek_ucret_damga = damga_vergisi - maas_damga_vergisi_ - ext_salary_damga - onceki_odenek_damga_toplam;
						this_ek_ucret_isveren = ssk_isveren_hissesi - maas_ssk_isveren_hissesi_ - ext_salary_isveren - onceki_odenek_isveren_toplam;
						this_ek_ucret_isci = ssk_isci_hissesi - maas_ssk_isci_hissesi_ - ext_salary_isci -  onceki_odenek_isci_toplam;
						this_ek_ucret_isveren_issizlik = issizlik_isveren_hissesi - maas_ssk_isveren_issizlik_ - ext_salary_isveren_issizlik - onceki_odenek_isveren_issizlik_toplam;
						this_ek_ucret_isci_issizlik = issizlik_isci_hissesi - maas_ssk_isci_issizlik_ - ext_salary_isci_issizlik - onceki_odenek_isci_issizlik_toplam;						
						
						//writeoutput("net_ucret:#net_ucret#");
						//("maas_net_ucreti_:#maas_net_ucreti_#");
						//writeoutput("ext_salary_net:#ext_salary_net#");
						//writeoutput("onceki_odenek_netleri_toplam:#onceki_odenek_netleri_toplam#");
						onceki_odenek_netleri_toplam = onceki_odenek_netleri_toplam + this_ek_ucret_net;
						onceki_odenek_gelir_toplam = onceki_odenek_gelir_toplam + this_ek_ucret_gelir;
						onceki_odenek_damga_toplam = onceki_odenek_damga_toplam + this_ek_ucret_damga;
						onceki_odenek_isveren_toplam = onceki_odenek_isveren_toplam + this_ek_ucret_isveren;
						onceki_odenek_isci_toplam = onceki_odenek_isci_toplam + this_ek_ucret_isci;
						onceki_odenek_isveren_issizlik_toplam = onceki_odenek_isveren_issizlik_toplam + this_ek_ucret_isveren_issizlik;
						onceki_odenek_isci_issizlik_toplam = onceki_odenek_isci_issizlik_toplam + this_ek_ucret_isci_issizlik;

						if((ArrayIsDefined(puantaj_exts[i_ek_od],33)and puantaj_exts[i_ek_od][33] eq 1) or (ArrayIsDefined(puantaj_exts[i_ek_od],32) and puantaj_exts[i_ek_od][32] neq 1))
							puantaj_exts[i_ek_od][15] = this_ek_ucret_net;
						else if(ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7] neq 0 and get_hr_salary.gross_net eq 0)
							puantaj_exts[i_ek_od][15] = puantaj_exts[i_ek_od][15]/30*ssk_days;
							
						puantaj_exts[i_ek_od][22] = this_ek_ucret_isveren;
						puantaj_exts[i_ek_od][23] = this_ek_ucret_isveren_issizlik;
						puantaj_exts[i_ek_od][24] = this_ek_ucret_isci;
						puantaj_exts[i_ek_od][25] = this_ek_ucret_isci_issizlik;
						puantaj_exts[i_ek_od][26] = this_ek_ucret_gelir;
						puantaj_exts[i_ek_od][27] = this_ek_ucret_damga;

						if(puantaj_exts[i_ek_od][43] eq 1)
						{
							rd_dahil_olan_gelir_vergisi = rd_dahil_olan_gelir_vergisi + this_ek_ucret_gelir;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir;
							}
						}
						else
						{
							rd_dahil_olmayan_gelir_vergisi = rd_dahil_olmayan_gelir_vergisi + this_ek_ucret_gelir;	
						}
						
						if(puantaj_exts[i_ek_od][42] eq 1)
						{
							rd_dahil_olan_damga_vergisi = rd_dahil_olan_damga_vergisi + this_ek_ucret_damga;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga;
							}
						}
						else
						{
							rd_dahil_olmayan_damga_vergisi = rd_dahil_olmayan_damga_vergisi + this_ek_ucret_damga;	
						}
						
						if(puantaj_exts[i_ek_od][44] eq 1)
						{
							rd_dahil_olan_ssk_isveren_hissesi = rd_dahil_olan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren;
							}
						}
						else
						{
							rd_dahil_olmayan_ssk_isveren_hissesi = rd_dahil_olmayan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(this_ek_ucret_isveren gt 0)
								rd_dahil_olmayan_ssk_matrah = rd_dahil_olmayan_ssk_matrah + puantaj_exts[i_ek_od][3];
						}	
					}
					else if (get_pay_salary.ssk[i_ek_od] eq 2 and get_pay_salary.tax[i_ek_od] eq 1 and get_pay_salary.IS_DAMGA[i_ek_od] eq 0 and get_pay_salary.IS_ISSIZLIK[i_ek_od] eq 1) // dv ve v muaf 05042022ERU
				 	{
						//total_pay_ssk = total_pay_ssk + puantaj_exts[i_ek_od][3];
						if(listfind('2,3,4',get_pay_salary.method_pay[i_ek_od],','))
						{
							total_pay_ssk = total_pay_ssk + puantaj_exts[i_ek_od][8];
						}
						else 
						{
							total_pay_ssk = total_pay_ssk + puantaj_exts[i_ek_od][3];
						}

						if(listfind('2,3,4',get_pay_salary.method_pay[i_ek_od],','))
						{
							total_pay_unstamped = total_pay_unstamped + puantaj_exts[i_ek_od][8];
							if(len(puantaj_exts[puantaj_exts_index][40]))
								total_pay_ssk_untax_diff = ((puantaj_exts[i_ek_od][8]-puantaj_exts[puantaj_exts_index][40]) * 15 / 100);
							else
								total_pay_ssk_untax_diff = (puantaj_exts[i_ek_od][8] * 15 / 100);
						}
						else 
						{
							total_pay_unstamped = total_pay_unstamped + puantaj_exts[i_ek_od][3];
							if(len(puantaj_exts[puantaj_exts_index][40]))
								total_pay_ssk_untax_diff = ((puantaj_exts[i_ek_od][3]-puantaj_exts[puantaj_exts_index][40]) * 15 / 100);
							else
								total_pay_ssk_untax_diff = (puantaj_exts[i_ek_od][3] * 15 / 100);
						}

						brut_salary = salary;
						a_g_m_ = asgari_gecim_max_tutar_;
						ozel_kesinti_ = ozel_kesinti;
						ozel_kesinti = 0;			
						
						if(len(puantaj_exts[i_ek_od][40]))
						{
							ssk_matraha_dahil_olmayan_odenek_tutar = ssk_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][40];
						}
						
						if(len(puantaj_exts[i_ek_od][41]))
						{
							vergi_matraha_dahil_olmayan_odenek_tutar = vergi_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][41];
						}
						
						include 'get_hr_compass_from_brut.cfm';
						ozel_kesinti = ozel_kesinti_;						
						asgari_gecim_max_tutar_ = a_g_m_;
						salary = brut_salary;
						
						this_ek_ucret_net = net_ucret - maas_net_ucreti_ - ext_salary_net - onceki_odenek_netleri_toplam ; //+ ozel_kesinti
						this_ek_ucret_gelir = gelir_vergisi - maas_gelir_vergisi_ - ext_salary_gelir - onceki_odenek_gelir_toplam;
						this_ek_ucret_damga = damga_vergisi - maas_damga_vergisi_ - ext_salary_damga - onceki_odenek_damga_toplam;
						this_ek_ucret_isveren = ssk_isveren_hissesi - maas_ssk_isveren_hissesi_ - ext_salary_isveren - onceki_odenek_isveren_toplam;
						this_ek_ucret_isci = ssk_isci_hissesi - maas_ssk_isci_hissesi_ - ext_salary_isci -  onceki_odenek_isci_toplam;
						this_ek_ucret_isveren_issizlik = issizlik_isveren_hissesi - maas_ssk_isveren_issizlik_ - ext_salary_isveren_issizlik - onceki_odenek_isveren_issizlik_toplam;
						this_ek_ucret_isci_issizlik = issizlik_isci_hissesi - maas_ssk_isci_issizlik_ - ext_salary_isci_issizlik - onceki_odenek_isci_issizlik_toplam;


						onceki_odenek_netleri_toplam = onceki_odenek_netleri_toplam + this_ek_ucret_net;
						onceki_odenek_gelir_toplam = onceki_odenek_gelir_toplam + this_ek_ucret_gelir;
						onceki_odenek_damga_toplam = onceki_odenek_damga_toplam + this_ek_ucret_damga;
						onceki_odenek_isveren_toplam = onceki_odenek_isveren_toplam + this_ek_ucret_isveren;
						onceki_odenek_isci_toplam = onceki_odenek_isci_toplam + this_ek_ucret_isci;
						onceki_odenek_isveren_issizlik_toplam = onceki_odenek_isveren_issizlik_toplam + this_ek_ucret_isveren_issizlik;
						onceki_odenek_isci_issizlik_toplam = onceki_odenek_isci_issizlik_toplam + this_ek_ucret_isci_issizlik;

						if((ArrayIsDefined(puantaj_exts[i_ek_od],33)and puantaj_exts[i_ek_od][33] eq 1) or (ArrayIsDefined(puantaj_exts[i_ek_od],32) and puantaj_exts[i_ek_od][32] neq 1))
							puantaj_exts[i_ek_od][15] = this_ek_ucret_net;
						else if(ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7] neq 0 and get_hr_salary.gross_net eq 0)
							puantaj_exts[i_ek_od][15] = puantaj_exts[i_ek_od][15]/30*ssk_days;
							
						if(len(puantaj_exts[i_ek_od][40]) and total_pay_ssk_tax gt 0)
						{
							this_ek_ucret_isveren = wrk_round((total_pay_ssk_tax - puantaj_exts[i_ek_od][40]) * this_ek_ucret_isveren / total_pay_ssk_tax);
						}
						else
							this_ek_ucret_isveren = 0;
							
						puantaj_exts[i_ek_od][22] = this_ek_ucret_isveren;
						puantaj_exts[i_ek_od][23] = this_ek_ucret_isveren_issizlik;
						puantaj_exts[i_ek_od][24] = this_ek_ucret_isci;
						puantaj_exts[i_ek_od][25] = this_ek_ucret_isci_issizlik;
						puantaj_exts[i_ek_od][26] = this_ek_ucret_gelir;
						puantaj_exts[i_ek_od][27] = this_ek_ucret_damga;

						if(puantaj_exts[i_ek_od][43] eq 1)
						{
							rd_dahil_olan_gelir_vergisi = rd_dahil_olan_gelir_vergisi + this_ek_ucret_gelir;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir;
							}
						}
						else
						{
							rd_dahil_olmayan_gelir_vergisi = rd_dahil_olmayan_gelir_vergisi + this_ek_ucret_gelir;	
						}
						
						if(puantaj_exts[i_ek_od][42] eq 1)
						{
							rd_dahil_olan_damga_vergisi = rd_dahil_olan_damga_vergisi + this_ek_ucret_damga;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga;
							}
						}
						else
						{
							rd_dahil_olmayan_damga_vergisi = rd_dahil_olmayan_damga_vergisi + this_ek_ucret_damga;	
						}
						
						if(puantaj_exts[i_ek_od][44] eq 1)
						{
							rd_dahil_olan_ssk_isveren_hissesi = rd_dahil_olan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren;
							}
						}
						else
						{
							rd_dahil_olmayan_ssk_isveren_hissesi = rd_dahil_olmayan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(this_ek_ucret_isveren gt 0)
								rd_dahil_olmayan_ssk_matrah = rd_dahil_olmayan_ssk_matrah + puantaj_exts[i_ek_od][3];
						}
					} 
					else if(get_pay_salary.ssk[i_ek_od] eq 2 and get_pay_salary.tax[i_ek_od] eq 2 and get_pay_salary.IS_DAMGA[i_ek_od] eq 0 and get_pay_salary.IS_ISSIZLIK[i_ek_od] eq 1)//sadece damga muaf 23062022ERU
					{
						
						if(listfind('2,3,4',get_pay_salary.method_pay[i_ek_od],','))
						{
							total_pay_ssk_tax = total_pay_ssk_tax + puantaj_exts[i_ek_od][8];
							total_pay_unstamped = total_pay_unstamped + puantaj_exts[i_ek_od][8];
						}
						else 
						{
							total_pay_ssk_tax = total_pay_ssk_tax + puantaj_exts[i_ek_od][3];
							total_pay_unstamped = total_pay_unstamped + puantaj_exts[i_ek_od][3];
						}
						
						brut_salary = salary;
						a_g_m_ = asgari_gecim_max_tutar_;
						ozel_kesinti_ = ozel_kesinti;
						ozel_kesinti = 0;
						
						if(len(puantaj_exts[i_ek_od][40]))
						{
							ssk_matraha_dahil_olmayan_odenek_tutar = ssk_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][40];
						}
						
						if(len(puantaj_exts[i_ek_od][41]))
						{
							vergi_matraha_dahil_olmayan_odenek_tutar = vergi_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][41];
						}
						
						include 'get_hr_compass_from_brut.cfm';
						ozel_kesinti = ozel_kesinti_;						
						asgari_gecim_max_tutar_ = a_g_m_;
						salary = brut_salary;
						
						this_ek_ucret_net = net_ucret - maas_net_ucreti_ - ext_salary_net - onceki_odenek_netleri_toplam ; //+ ozel_kesinti
						this_ek_ucret_gelir = gelir_vergisi - maas_gelir_vergisi_ - ext_salary_gelir - onceki_odenek_gelir_toplam;
						this_ek_ucret_damga = damga_vergisi - maas_damga_vergisi_ - ext_salary_damga - onceki_odenek_damga_toplam;
						this_ek_ucret_isveren = ssk_isveren_hissesi - maas_ssk_isveren_hissesi_ - ext_salary_isveren - onceki_odenek_isveren_toplam;
						this_ek_ucret_isci = ssk_isci_hissesi - maas_ssk_isci_hissesi_ - ext_salary_isci -  onceki_odenek_isci_toplam;
						this_ek_ucret_isveren_issizlik = issizlik_isveren_hissesi - maas_ssk_isveren_issizlik_ - ext_salary_isveren_issizlik - onceki_odenek_isveren_issizlik_toplam;
						this_ek_ucret_isci_issizlik = issizlik_isci_hissesi - maas_ssk_isci_issizlik_ - ext_salary_isci_issizlik - onceki_odenek_isci_issizlik_toplam;

						onceki_odenek_netleri_toplam = onceki_odenek_netleri_toplam + this_ek_ucret_net;
						onceki_odenek_gelir_toplam = onceki_odenek_gelir_toplam + this_ek_ucret_gelir;
						onceki_odenek_damga_toplam = onceki_odenek_damga_toplam + this_ek_ucret_damga;
						onceki_odenek_isveren_toplam = onceki_odenek_isveren_toplam + this_ek_ucret_isveren;
						onceki_odenek_isci_toplam = onceki_odenek_isci_toplam + this_ek_ucret_isci;
						onceki_odenek_isveren_issizlik_toplam = onceki_odenek_isveren_issizlik_toplam + this_ek_ucret_isveren_issizlik;
						onceki_odenek_isci_issizlik_toplam = onceki_odenek_isci_issizlik_toplam + this_ek_ucret_isci_issizlik;

						if((ArrayIsDefined(puantaj_exts[i_ek_od],33)and puantaj_exts[i_ek_od][33] eq 1) or (ArrayIsDefined(puantaj_exts[i_ek_od],32) and puantaj_exts[i_ek_od][32] neq 1))
						{
							puantaj_exts[i_ek_od][15] = this_ek_ucret_net;
						}
						else if(ArrayIsDefined(puantaj_exts[i_ek_od],7) and puantaj_exts[i_ek_od][7] neq 0 and get_hr_salary.gross_net eq 0)
						{
							puantaj_exts[i_ek_od][15] = puantaj_exts[i_ek_od][15]/30*ssk_days;
						}
							
							
							
						if(len(puantaj_exts[i_ek_od][40]))
						{
							this_ek_ucret_isveren = wrk_round((total_pay_ssk_tax - puantaj_exts[i_ek_od][40]) * this_ek_ucret_isveren / total_pay_ssk_tax);
						}
							
						puantaj_exts[i_ek_od][22] = this_ek_ucret_isveren;
						puantaj_exts[i_ek_od][23] = this_ek_ucret_isveren_issizlik;
						puantaj_exts[i_ek_od][24] = this_ek_ucret_isci;
						puantaj_exts[i_ek_od][25] = this_ek_ucret_isci_issizlik;
						puantaj_exts[i_ek_od][26] = this_ek_ucret_gelir;
						puantaj_exts[i_ek_od][27] = this_ek_ucret_damga;

						if(puantaj_exts[i_ek_od][43] eq 1)
						{
							rd_dahil_olan_gelir_vergisi = rd_dahil_olan_gelir_vergisi + this_ek_ucret_gelir;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][46] = this_ek_ucret_gelir;
							}
						}
						else
						{
							rd_dahil_olmayan_gelir_vergisi = rd_dahil_olmayan_gelir_vergisi + this_ek_ucret_gelir;	
						}
						
						if(puantaj_exts[i_ek_od][42] eq 1)
						{
							rd_dahil_olan_damga_vergisi = rd_dahil_olan_damga_vergisi + this_ek_ucret_damga;
							
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][45] = this_ek_ucret_damga;
							}
						}
						else
						{
							rd_dahil_olmayan_damga_vergisi = rd_dahil_olmayan_damga_vergisi + this_ek_ucret_damga;	
						}
						
						if(puantaj_exts[i_ek_od][44] eq 1)
						{
							rd_dahil_olan_ssk_isveren_hissesi = rd_dahil_olan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE80'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 80 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE90'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 90 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE95'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren * 95 / 100;
							}
							if(listfindnocase(get_hr_ssk.LAW_NUMBERS,'ARGE100'))
							{
								puantaj_exts[i_ek_od][47] = this_ek_ucret_isveren;
							}
						}
						else
						{
							rd_dahil_olmayan_ssk_isveren_hissesi = rd_dahil_olmayan_ssk_isveren_hissesi + this_ek_ucret_isveren;
							if(this_ek_ucret_isveren gt 0)
								rd_dahil_olmayan_ssk_matrah = rd_dahil_olmayan_ssk_matrah + puantaj_exts[i_ek_od][3];
						}
						//abort('puantaj_exts[i_ek_od][15]:#puantaj_exts[i_ek_od][15]# net_ucret:#net_ucret#-maas_net_ucreti_:#maas_net_ucreti_#-ext_salary_net:#ext_salary_net#-#onceki_odenek_netleri_toplam#');
					}
				}
			}
			if(ext_salary gt 0) //fazla mesainin gelir vergisinin hesaplanması SG20140128
				{
					/*
					ext_salary = ext_salary;
					brut_salary = salary;
					a_g_m_ = asgari_gecim_max_tutar_;
					ozel_kesinti_ = ozel_kesinti;
					ozel_kesinti = 0;			
					include 'get_hr_compass_from_brut.cfm';
					ozel_kesinti = ozel_kesinti_;
					asgari_gecim_max_tutar_ = a_g_m_;
					salary = brut_salary;
					this_ek_ucret_net = net_ucret - maas_net_ucreti_ - ext_salary_net - onceki_odenek_netleri_toplam;
					this_ek_ucret_gelir = gelir_vergisi - maas_gelir_vergisi_ - onceki_odenek_gelir_toplam;
					this_ek_ucret_damga = damga_vergisi - maas_damga_vergisi_ - onceki_odenek_damga_toplam;
					this_ek_ucret_isveren = ssk_isveren_hissesi - maas_ssk_isveren_hissesi_ - onceki_odenek_isveren_toplam;
					this_ek_ucret_isci = ssk_isci_hissesi - maas_ssk_isci_hissesi_ - onceki_odenek_isci_toplam;
					this_ek_ucret_isveren_issizlik = issizlik_isveren_hissesi - maas_ssk_isveren_issizlik_ - onceki_odenek_isveren_issizlik_toplam;
					this_ek_ucret_isci_issizlik = issizlik_isci_hissesi - maas_ssk_isci_issizlik_ - onceki_odenek_isci_issizlik_toplam;
					*/

					onceki_odenek_netleri_toplam = onceki_odenek_netleri_toplam + ext_salary_net;
					onceki_odenek_gelir_toplam = onceki_odenek_gelir_toplam + ext_salary_gelir;
					onceki_odenek_damga_toplam = onceki_odenek_damga_toplam + ext_salary_damga;
					onceki_odenek_isveren_toplam = onceki_odenek_isveren_toplam + ext_salary_isveren;
					onceki_odenek_isci_toplam = onceki_odenek_isci_toplam + ext_salary_isci;
					onceki_odenek_isveren_issizlik_toplam = onceki_odenek_isveren_issizlik_toplam + ext_salary_isveren_issizlik;
					onceki_odenek_isci_issizlik_toplam = onceki_odenek_isci_issizlik_toplam + ext_salary_isci_issizlik;
				}
				
			/* leo da yapılan degisiklikler buraya tasindi.alltaki kalemler db de tutulacak SG 20130227 */
			if(isdefined("yillik_izin_amount_1") and yillik_izin_amount_1 gt 0)
			{
				attributes.yillik_izin_amount = yillik_izin_amount_1;
				brut_salary = salary;
				a_g_m_ = asgari_gecim_max_tutar_;
				ozel_kesinti_ = ozel_kesinti;
				ozel_kesinti = 0;				

				if(get_hr_ssk.IS_TAX_FREE eq 1 and get_hr_ssk.IS_DAMGA_FREE eq 1 and listfind('8,9,10,19',get_hr_ssk.SSK_STATUTE))
				{
					salary = 0;
					is_included_in_tax = 1;
					from_net = 1;
					is_yearly_offtime = 1;
				}

				include 'get_hr_compass_from_brut.cfm';
				
				ozel_kesinti = ozel_kesinti_;						
				asgari_gecim_max_tutar_ = a_g_m_;
				salary = brut_salary;
				
				this_ek_ucret_net = net_ucret - maas_net_ucreti_ - ext_salary_net - onceki_odenek_netleri_toplam;
				this_ek_ucret_gelir = gelir_vergisi - maas_gelir_vergisi_ - onceki_odenek_gelir_toplam;
				this_ek_ucret_damga = damga_vergisi - maas_damga_vergisi_ - onceki_odenek_damga_toplam;
				this_ek_ucret_isveren = ssk_isveren_hissesi - maas_ssk_isveren_hissesi_ - onceki_odenek_isveren_toplam;
				this_ek_ucret_isci = ssk_isci_hissesi - maas_ssk_isci_hissesi_ - onceki_odenek_isci_toplam;
				this_ek_ucret_isveren_issizlik = issizlik_isveren_hissesi - maas_ssk_isveren_issizlik_ - onceki_odenek_isveren_issizlik_toplam;
				this_ek_ucret_isci_issizlik = issizlik_isci_hissesi - maas_ssk_isci_issizlik_ - onceki_odenek_isci_issizlik_toplam;

				if(get_hr_ssk.IS_TAX_FREE eq 1 and get_hr_ssk.IS_DAMGA_FREE eq 1 and listfind('8,9,10,19',get_hr_ssk.SSK_STATUTE))
				{
					is_included_in_tax = 0;
					from_net = 0;
					included_in_tax_paid_amount_stamp_tax = this_ek_ucret_damga;
					included_in_tax_paid_amount_income_tax = this_ek_ucret_gelir;
					is_yearly_offtime = 0;
				}

				onceki_odenek_netleri_toplam = onceki_odenek_netleri_toplam + this_ek_ucret_net;
				onceki_odenek_gelir_toplam = onceki_odenek_gelir_toplam + this_ek_ucret_gelir;
				onceki_odenek_damga_toplam = onceki_odenek_damga_toplam + this_ek_ucret_damga;
				onceki_odenek_isveren_toplam = onceki_odenek_isveren_toplam + this_ek_ucret_isveren;
				onceki_odenek_isci_toplam = onceki_odenek_isci_toplam + this_ek_ucret_isci;
				onceki_odenek_isveren_issizlik_toplam = onceki_odenek_isveren_issizlik_toplam + this_ek_ucret_isveren_issizlik;
				onceki_odenek_isci_issizlik_toplam = onceki_odenek_isci_issizlik_toplam + this_ek_ucret_isci_issizlik;
				
				yillik_izin_net = this_ek_ucret_net;
				yillik_izin_gelir_vergisi = this_ek_ucret_gelir;
				yillik_izin_damga_vergisi = this_ek_ucret_damga;
				yillik_izin_isveren_toplam = this_ek_ucret_isveren;
				yillik_izin_isci_toplam = this_ek_ucret_isci;
				yillik_izin_isveren_issizlik_toplam = this_ek_ucret_isveren_issizlik;
				yillik_izin_isci_issizlik_toplam = this_ek_ucret_isci_issizlik;
			}

			if(included_in_tax_paid_amount gt 0 and get_hr_ssk.IS_TAX_FREE eq 1 and get_hr_ssk.IS_DAMGA_FREE eq 1)
			{
				brut_salary = salary;
				salary = salary - included_in_tax_paid_amount;
				is_included_in_tax = 1;
				from_net = 1;
				salary = included_in_tax_paid_amount;
				a_g_m_ = asgari_gecim_max_tutar_;
				ozel_kesinti_ = ozel_kesinti;
				ozel_kesinti = 0;	
				salary = salary - included_in_tax_paid_amount;
				include 'get_hr_compass_from_brut.cfm';
				ozel_kesinti = ozel_kesinti_;
				asgari_gecim_max_tutar_ = a_g_m_;
				salary = brut_salary;
				included_in_tax_paid_amount_stamp_tax = damga_vergisi;
				included_in_tax_paid_amount_income_tax = gelir_vergisi;
				is_included_in_tax = 0;
				from_net = 0;
			}
			
			if(isdefined("kidem_amount_1") and kidem_amount_1 gt 0)
			{
				attributes.kidem_amount = kidem_amount_1;
				brut_salary = salary;
				a_g_m_ = asgari_gecim_max_tutar_;
				ozel_kesinti_ = ozel_kesinti;
				ozel_kesinti = 0;				
				include 'get_hr_compass_from_brut.cfm';
				ozel_kesinti = ozel_kesinti_;
				asgari_gecim_max_tutar_ = a_g_m_;
				salary = brut_salary;
				
				this_ek_ucret_net = net_ucret - maas_net_ucreti_ - ext_salary_net - onceki_odenek_netleri_toplam;
				this_ek_ucret_damga = damga_vergisi - maas_damga_vergisi_ - onceki_odenek_damga_toplam;
				//writeoutput("1 : ozel_kesinti:#ozel_kesinti#<br>");
				//writeoutput("1 : net_ucret:#net_ucret#<br>");
				//writeoutput("1 : maas_net_ucreti_:#maas_net_ucreti_#<br>");
				//writeoutput("1 : ext_salary_net:#ext_salary_net#<br>");
				//writeoutput("1 : onceki_odenek_netleri_toplam:#onceki_odenek_netleri_toplam#<br>");
				//writeoutput("1 : this_ek_ucret_net:#this_ek_ucret_net#<br>");
				kidem_net = this_ek_ucret_net;
				kidem_damga_vergisi = this_ek_ucret_damga;
				
				onceki_odenek_netleri_toplam = onceki_odenek_netleri_toplam + this_ek_ucret_net;
				onceki_odenek_damga_toplam = onceki_odenek_damga_toplam + this_ek_ucret_damga;
			}
			
			if(isdefined("ihbar_amount_1") and ihbar_amount_1 gt 0)
			{
				attributes.ihbar_amount = ihbar_amount_1;
				brut_salary = salary;
				a_g_m_ = asgari_gecim_max_tutar_;
				ozel_kesinti_ = ozel_kesinti;
				ozel_kesinti = 0;				
				include 'get_hr_compass_from_brut.cfm';
				ozel_kesinti = ozel_kesinti_;				
				asgari_gecim_max_tutar_ = a_g_m_;
				salary = brut_salary;
				
				this_ek_ucret_net = net_ucret - maas_net_ucreti_ - ext_salary_net - onceki_odenek_netleri_toplam;
				this_ek_ucret_gelir = gelir_vergisi - maas_gelir_vergisi_ - onceki_odenek_gelir_toplam;
				this_ek_ucret_damga = damga_vergisi - maas_damga_vergisi_ - onceki_odenek_damga_toplam;
				//writeoutput("2 : net_ucret:#net_ucret#<br>");
				//writeoutput("2 : maas_net_ucreti_:#maas_net_ucreti_#<br>");

				//writeoutput("2 : ext_salary_net:#ext_salary_net#<br>");
				//writeoutput("2 : onceki_odenek_netleri_toplam:#onceki_odenek_netleri_toplam#<br>");
				//writeoutput("2 : this_ek_ucret_net:#this_ek_ucret_net#<br>");

				onceki_odenek_netleri_toplam = onceki_odenek_netleri_toplam + this_ek_ucret_net;
				onceki_odenek_gelir_toplam = onceki_odenek_gelir_toplam + this_ek_ucret_gelir;
				onceki_odenek_damga_toplam = onceki_odenek_damga_toplam + this_ek_ucret_damga;
				
				ihbar_net = this_ek_ucret_net;
				ihbar_gelir_vergisi = this_ek_ucret_gelir;
				ihbar_damga_vergisi = this_ek_ucret_damga;
			}
			/*bitti SG 20130227*/
			if(total_pay_tax_net gt 0 and get_hr_ssk.is_tax_free eq 1 and get_hr_ssk.is_damga_free eq 1)
			{
				total_pay_tax = total_pay_tax + total_pay_tax_net;
				total_pay_tax_net = 0;
			}
			if((total_pay_ssk_tax_net+total_pay_tax_net+total_pay_ssk_net_noissizlik+total_pay_net+total_pay_ssk_tax_net_noissizlik+total_pay_d_net+total_pay_ssk_net+total_pay_ssk+total_pay_ssk_net_damgasiz+total_pay_ssk_tax_net_notstamp) gt 0)
			{
				//ucret brut iken herhangi bir net ek odenek varsa brut hale getir ve bunlardan sonra from_brut hesabina gir
				brut_salary = salary;
				is_devir_matrah_off = 1;
				a_g_m_ = asgari_gecim_max_tutar_;
				ozel_kesinti_1 = ozel_kesinti;
				ozel_kesinti = 0;
				include 'get_hr_compass_from_brut.cfm';
				ozel_kesinti = ozel_kesinti_1;
				asgari_gecim_max_tutar_ = a_g_m_;
				is_devir_matrah_off = 0;

				sal_temp = wrk_round(net_ucret_kesintisiz);
				if(isdefined("asgari_gecim_indirimi_") and asgari_gecim_indirimi_ gt 0)
					sal_temp = sal_temp - wrk_round(asgari_gecim_indirimi_); 

				salary = brut_salary;

				devir_matrah_ = salary;
				odenek_oncesi_kumulatif_gelir = kumulatif_gelir;
				odenek_oncesi_toplam = salary;
				odenek_oncesi_gelir_vergisi_matrah = gelir_vergisi_matrah;
				odenek_oncesi_gelir_vergisi = gelir_vergisi;
				odenek_oncesi_damga_vergisi = damga_vergisi;
				/*
				ilk_sal_temp = sal_temp;
				ilk_salary = salary;
				*/
				//eski hali yukaridaki
				ilk_sal_temp = sal_temp;
				ilk_salary = ssk_matrah; //ssk_matrah //Senay 20140108 net ödenek ve brüt ödenekler aynı anda kullanıldığında net ödeneğin brüt tutarını düşürdüğü için bu şekilde düzeltildi. ssk_matrah yerine salary alınmıştır
				//yeni hali yukarıdaki		
				
				if(total_pay_ssk_tax_net gt 0 and ssk_matrah gte ssk_matrah_tavan)
				{
					if(total_pay_tax_net eq 0)
						devir_matrah_eklentisi_tip = 1;
					else
						{
						devir_matrah_eklentisi_tip = 2;
						devir_matrah_eklentisi_tutar = total_pay_ssk_tax_net;
						}
						
					total_pay_tax_net = total_pay_tax_net + total_pay_ssk_tax_net;
					total_pay_ssk_tax_net = 0;
					for (i=1; i lte arraylen(puantaj_exts); i = i+1)
					{
					if(puantaj_exts[i][6] eq 0 and puantaj_exts[i][9] eq 0)//net odenekler
						if(puantaj_exts[i][4] eq 2 and puantaj_exts[i][5] eq 2 and puantaj_exts[i][13] eq 1 and puantaj_exts[i][14] eq 1)
						{
						puantaj_exts[i][4] = 1; //ssk iptal edildi
						puantaj_exts[i][14] = 0; //ssk iptal edildi
						}
					}
				}
				
				/*
				if(total_pay_ssk_tax_net gt 0)
				{
					tutar_ = total_pay_ssk_tax_net;
					is_mesai_ = 0;
					is_izin_ = 0;
					is_tax_ = 1;
					is_ssk_ = 1;
					is_issizlik_ = 1;
					include 'get_hr_compass_from_net_odenek.cfm';
					
					ekten_gelen = ekten_gelen + eklenen;
				}
				*/
				
				ssk_matraha_dahil_olmayan_odenek_tutar_1 = ssk_matraha_dahil_olmayan_odenek_tutar;
				vergi_matraha_dahil_olmayan_odenek_tutar_1 = vergi_matraha_dahil_olmayan_odenek_tutar;

				ssk_matraha_dahil_olmayan_odenek_tutar = 0;
				vergi_matraha_dahil_olmayan_odenek_tutar = 0;
			
				if(total_pay_ssk_tax_net gt 0)
				{
					/*
					tutar_ = total_pay_ssk_tax_net;
					is_mesai_ = 0;
					is_izin_ = 0;
					is_tax_ = 1;
					is_ssk_ = 1;
					is_issizlik_ = 1;
					include 'get_hr_compass_from_net_odenek.cfm';
					ekten_gelen = ekten_gelen + eklenen;
					*/

					ilk_salary_start = ilk_salary;
					ilk_sal_temp_start = ilk_sal_temp;
					for (i_ek_od=1; i_ek_od lte arraylen(puantaj_exts); i_ek_od = i_ek_od+1)
					{
						if(puantaj_exts[i_ek_od][6] eq 0 and puantaj_exts[i_ek_od][9] neq 1)//net odenekler
						{		
								from_net = 1;				
								if(puantaj_exts[i_ek_od][4] eq 2 and puantaj_exts[i_ek_od][5] eq 2 and puantaj_exts[i_ek_od][13] eq 1 and puantaj_exts[i_ek_od][14] eq 1)
								{
									ssk_matraha_dahil_olmayan_odenek_tutar = 0;
									vergi_matraha_dahil_olmayan_odenek_tutar = 0;

									if(arraylen(puantaj_exts[i_ek_od]) gte 40 and len(puantaj_exts[i_ek_od][40]))
									{
										muafiyet_ = puantaj_exts[i_ek_od][40];
										ssk_matraha_dahil_olmayan_odenek_tutar =  puantaj_exts[i_ek_od][40];
									}
								
									if(arraylen(puantaj_exts[i_ek_od]) gte 41 and len(puantaj_exts[i_ek_od][41]))
										vergi_matraha_dahil_olmayan_odenek_tutar =  puantaj_exts[i_ek_od][41];

									if(get_pay_salary.METHOD_PAY[i_ek_od] eq 2 and get_pay_salary.FROM_SALARY[i_ek_od] eq 0 and len(get_pay_salary.MULTIPLIER[i_ek_od]) and get_pay_salary.MULTIPLIER[i_ek_od] neq 0)
									{
										/*
										Ödenek aylık maaş üzerinden seçiliyse;
										Eğer çalışana net ödenek tanımlandıysa ve ücret brütse ücretin  neti  üzerinden çarpana göre orantılanıyor. 
										*/
										tutar_ = (net_ucret - asgari_gecim_indirimi_) * get_pay_salary.MULTIPLIER[i_ek_od];
										net_odenek_aylik = 1;
									}
									else
										tutar_ = puantaj_exts[i_ek_od][3];
									is_ssk_tax_net_odenek = 1;
									odenek_sira =  i_ek_od;
									is_mesai_ = 0;
									is_izin_ = 0;
									is_tax_ = 1;
									is_ssk_ = 1;
									is_issizlik_ = 1;
									from_net = 1;
									include 'get_hr_compass_from_net_odenek.cfm';
									is_ssk_tax_net_odenek = 0;
									ekten_gelen = ekten_gelen + eklenen;
									ilk_salary = ilk_salary + eklenen;
									ilk_sal_temp = ilk_sal_temp + tutar_;
									
									if(puantaj_exts[i_ek_od][43] eq 1)
									{
										rd_dahil_olan_gelir_vergisi = rd_dahil_olan_gelir_vergisi + this_ek_ucret_gelir;
									}
									else
									{
										rd_dahil_olmayan_gelir_vergisi = rd_dahil_olmayan_gelir_vergisi + this_ek_ucret_gelir;	
									}
									
									if(puantaj_exts[i_ek_od][42] eq 1)
									{
										rd_dahil_olan_damga_vergisi = rd_dahil_olan_damga_vergisi + this_ek_ucret_damga;
									}
									else
									{
										rd_dahil_olmayan_damga_vergisi = rd_dahil_olmayan_damga_vergisi + this_ek_ucret_damga;	
									}
									
									if(puantaj_exts[i_ek_od][44] eq 1)
									{
										rd_dahil_olan_ssk_isveren_hissesi = rd_dahil_olan_ssk_isveren_hissesi + this_ek_ucret_isveren;
									}
									else
									{
										rd_dahil_olmayan_ssk_isveren_hissesi = rd_dahil_olmayan_ssk_isveren_hissesi + this_ek_ucret_isveren;
										if(this_ek_ucret_isveren gt 0)
											rd_dahil_olmayan_ssk_matrah = rd_dahil_olmayan_ssk_matrah + puantaj_exts[i_ek_od][3];
									}
								}							
						}
					}
				}

				ssk_matraha_dahil_olmayan_odenek_tutar = 0;
				vergi_matraha_dahil_olmayan_odenek_tutar = 0;
				for (i_ek_od=1; i_ek_od lte arraylen(puantaj_exts); i_ek_od = i_ek_od+1)
				{
					if(puantaj_exts[i_ek_od][4] eq 2 and puantaj_exts[i_ek_od][5] eq 2 and puantaj_exts[i_ek_od][13] eq 1 and puantaj_exts[i_ek_od][14] eq 1)
					{
						if(arraylen(puantaj_exts[i_ek_od]) gte 40 and len(puantaj_exts[i_ek_od][40]))
						{
							ssk_matraha_dahil_olmayan_odenek_tutar =  ssk_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][40];
						}
					
						if(arraylen(puantaj_exts[i_ek_od]) gte 41 and len(puantaj_exts[i_ek_od][41]))
							vergi_matraha_dahil_olmayan_odenek_tutar =  vergi_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][41];
					}
					else if(puantaj_exts[i_ek_od][4] eq 2 and puantaj_exts[i_ek_od][5] eq 1 and puantaj_exts[i_ek_od][13] eq 1 and puantaj_exts[i_ek_od][14] eq 1)
					{
						if(arraylen(puantaj_exts[i_ek_od]) gte 40 and len(puantaj_exts[i_ek_od][40]))
						{
							ssk_matraha_dahil_olmayan_odenek_tutar =  ssk_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][40];
						}
					}
					else if(puantaj_exts[i_ek_od][4] eq 1 and puantaj_exts[i_ek_od][5] eq 2 and puantaj_exts[i_ek_od][13] eq 1 and puantaj_exts[i_ek_od][14] eq 0)
					{
						if(arraylen(puantaj_exts[i_ek_od]) gte 41 and len(puantaj_exts[i_ek_od][41]))
							vergi_matraha_dahil_olmayan_odenek_tutar =  vergi_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][41];
					}
					else if(puantaj_exts[i_ek_od][4] eq 2 and puantaj_exts[i_ek_od][5] eq 1 and puantaj_exts[i_ek_od][13] eq 0 and puantaj_exts[i_ek_od][14] eq 1)
					{
						if(arraylen(puantaj_exts[i_ek_od]) gte 40 and len(puantaj_exts[i_ek_od][40]))
						{
							ssk_matraha_dahil_olmayan_odenek_tutar =  ssk_matraha_dahil_olmayan_odenek_tutar + puantaj_exts[i_ek_od][40];
						}
					}
				}
				
				if(total_pay_ssk_net gt 0)
				{
					tutar_ = total_pay_ssk_net;
					is_mesai_ = 0;
					is_izin_ = 0;
					is_tax_ = 0;
					is_ssk_ = 1;
					is_issizlik_ = 1;
					from_net = 1;
					include 'get_hr_compass_from_net_odenek.cfm';
					
					ekten_gelen = ekten_gelen + eklenen;
				}

			
				if(total_pay_tax_net gt 0)
				{
					tutar_ = total_pay_tax_net;
					is_mesai_ = 0;
					is_izin_ = 0;
					is_tax_ = 1;
					is_ssk_ = 0;
					is_issizlik_ = 0;
					from_net = 1;
					include 'get_hr_compass_from_net_odenek.cfm';
					ekten_gelen = ekten_gelen + eklenen;
					if(devir_matrah_eklentisi_tip eq 1)
						devir_matrah_eklentisi = devir_matrah_eklentisi + eklenen;
					else if(devir_matrah_eklentisi_tip eq 2)
					{
						oran = eklenen / tutar_; 
						devir_matrah_eklentisi_tutar = devir_matrah_eklentisi_tutar * oran;
						devir_matrah_eklentisi = devir_matrah_eklentisi + devir_matrah_eklentisi_tutar;
					}
				}			

				if(total_pay_ssk_tax_net_noissizlik gt 0)
				{
					tutar_ = total_pay_ssk_tax_net_noissizlik;
					is_mesai_ = 0;
					is_izin_ = 0;
					is_tax_ = 1;
					is_ssk_ = 1;
					is_issizlik_ = 0;
					from_net = 1;
					include 'get_hr_compass_from_net_odenek.cfm';
					ekten_gelen = ekten_gelen + eklenen;
				}

				if(total_pay_ssk_net_noissizlik gt 0)
				{
					tutar_ = total_pay_ssk_net_noissizlik;
					is_tax_ = 0;
					is_izin_ = 0;
					is_ssk_ = 1;
					is_issizlik_ = 0;
					from_net = 1;
					include 'get_hr_compass_from_net_odenek.cfm';
					
					ekten_gelen = ekten_gelen + eklenen;
				}	
				
				// dv ve v muaf 05042022ERU
				if(total_pay_ssk_net_damgasiz gt 0)
				{
					temp_total_pay_ssk_net = total_pay_ssk_net;
					temp_total_pay_ssk = total_pay_ssk;
					total_pay_ssk_net = total_pay_ssk_net_damgasiz;
					tutar_ = total_pay_ssk_net_damgasiz;
				
					is_mesai_ = 0;
					is_izin_ = 0;
					is_tax_ = 0;
					is_ssk_ = 1;
					is_issizlik_ = 1;
					is_damga_ = 0;
					from_net = 1;
					include 'get_hr_compass_from_net_odenek.cfm';
					ekten_gelen = ekten_gelen + eklenen;
					StructDelete(Variables , "is_damga_");
					total_pay_ssk_untax_diff = total_pay_ssk_untax_diff + (total_pay_ssk - total_pay_ssk_net);
					total_pay_ssk = temp_total_pay_ssk + total_pay_ssk;
					total_pay_ssk_net = temp_total_pay_ssk_net + total_pay_ssk_net;
				}	
				
				//Damga hariç ödenek 22062022ERU
				if(total_pay_ssk_tax_net_notstamp gt 0)
				{
					temp_total_pay_ssk_tax_net = total_pay_ssk_tax_net;
					temp_total_pay_ssk_tax = total_pay_ssk_tax;
					total_pay_ssk_tax_net = total_pay_ssk_tax_net_notstamp;
					tutar_ = total_pay_ssk_tax_net_notstamp;
					is_mesai_ = 0;
					is_izin_ = 0;
					is_tax_ = 1;
					is_ssk_ = 1;
					is_issizlik_ = 1;
					is_damga_ = 0;
					from_net = 1;
					is_not_stamp = 1;
					include 'get_hr_compass_from_net_odenek.cfm';
					is_not_stamp = 0;

					ekten_gelen = ekten_gelen + eklenen;
					total_pay_ssk_tax_notstamp_base = eklenen;
					total_pay_ssk_tax_net_notstamp_base = total_pay_ssk_tax_net_notstamp;
					StructDelete(Variables , "is_damga_");
					total_pay_ssk_tax = temp_total_pay_ssk_tax;
					total_pay_ssk_tax_net = temp_total_pay_ssk_tax_net;
				}				

				if(total_pay_net gt 0)
				{
					total_pay = total_pay + total_pay_net;
					is_izin_ = 0;
				}

				if(total_pay_d_net gt 0)
				{
					tutar_ = total_pay_d_net;
					is_mesai_ = 0;
					is_izin_ = 0;
					is_tax_ = 0;
					is_ssk_ = 0;
					from_net = 1;
					include 'get_hr_compass_from_net_odenek.cfm';
				}

				salary = brut_salary;
				kumulatif_gelir = odenek_oncesi_kumulatif_gelir;
				sakatlik_indirimi = sakatlik_indirimi_full;
			}
		}

		if(get_hr_salary.gross_net eq 0)
		{			
				
			include 'get_hr_compass_tax_exception_osi.cfm';
			include 'get_hr_compass_tax_exception_bei.cfm';
			include 'get_hr_compass_tax_exception_boss.cfm';
			include 'get_hr_compass_tax_exception_hs.cfm';
			include 'get_hr_compass_tax_exception.cfm';
			//abort("vergi_brut_toplam_tutari:#vergi_brut_toplam_tutari#vergi_istisna:#vergi_istisna#vergi_istisna_boss:#vergi_istisna_boss#vergi_istisna_osi:#vergi_istisna_osi#vergi_istisna_bei:#vergi_istisna_bei#");
		}
		
		{
			vergi_istisna_ssk_tutar_net = vergi_istisna_ssk_tutar;
			if(vergi_istisna_ssk_tutar gt 0)
			{
				sal_temp = salary;//from_net_odenek de oranlamak icin kullaniliyor
				gelir_vergisi_matrah = salary;
				include 'get_hr_compass_tax.cfm';//tax_ratio geliyor
				if(ssk_days)
					brut_total_pay_ssk_tax_net = vergi_istisna_ssk_tutar * (salary/sal_temp);
				else
				{
					brut_total_pay_ssk_tax_net = vergi_istisna_ssk_tutar;
					ssk_matrah_taban = get_insurance.MIN_PAYMENT;
					if (get_hr_ssk.SSK_STATUTE eq 21 or (get_hr_ssk.ssk_statute eq 2 and get_hr_ssk.working_abroad eq 1)) //sozlesmesiz ulkelere goturulecek calisanlar 
					{
						ssk_matrah_tavan = get_insurance.MIN_PAYMENT*3;
					}
					else
					{
						ssk_matrah_tavan = get_insurance.MAX_PAYMENT;	
					}
					
					gelir_vergisi_matrah = brut_total_pay_ssk_tax_net;
					include 'get_hr_compass_tax.cfm';
				}
				if(salary+ekten_gelen gt ssk_matrah_tavan)
				{
					oran_damga_duzeltme = get_active_program_parameter.STAMP_TAX_BINDE/(1-tax_carpan);
					vergi_istisna_ssk_tutar = vergi_istisna_ssk_tutar/(1-tax_carpan);
					vergi_istisna_ssk_tutar = wrk_round( (vergi_istisna_ssk_tutar*1000)/(1000-oran_damga_duzeltme) );
				}
				else if(salary+brut_total_pay_ssk_tax_net+ekten_gelen lte ssk_matrah_tavan)		
				{//brut ucret ve sadece hem ssk hem vergi dahil odenekler toplami tavandan kucukse
					oran_damga_duzeltme = (get_active_program_parameter.STAMP_TAX_BINDE*100)/( (1-tax_carpan) * (100-ssk_isci_carpan-issizlik_isci_carpan) );
					temp_total_pay_ssk_tax_net = vergi_istisna_ssk_tutar;
					total_pay_ssk_tax_net = vergi_istisna_ssk_tutar/(1-tax_carpan) ;
					total_pay_ssk_tax_net = (total_pay_ssk_tax_net*100)/(100-ssk_isci_carpan-issizlik_isci_carpan);
					vergi_istisna_ssk_tutar = wrk_round((total_pay_ssk_tax_net*1000)/(1000-oran_damga_duzeltme) );
				}
				else if(salary+brut_total_pay_ssk_tax_net+ekten_gelen gt ssk_matrah_tavan)	
				{//brut ucret ve hem ssk hem vergi dahil odenekler toplami tavandan buyukse
					oran_damga_duzeltme = get_active_program_parameter.STAMP_TAX_BINDE/(1-tax_carpan);
					brut_normal_total_pay_ssk_tax_net = (ssk_matrah_tavan-(salary+ekten_gelen));
					normal_total_pay_ssk_tax_net = (brut_normal_total_pay_ssk_tax_net * (100 - ssk_isci_carpan - issizlik_isci_carpan)) / 100;
					normal_total_pay_ssk_tax_net = normal_total_pay_ssk_tax_net*(1-tax_carpan);
					normal_total_pay_ssk_tax_net = normal_total_pay_ssk_tax_net - (brut_normal_total_pay_ssk_tax_net * get_active_program_parameter.STAMP_TAX_BINDE / 1000);
					ekten_gelen = ekten_gelen + brut_normal_total_pay_ssk_tax_net;
					fazla_total_pay_ssk_tax_net = vergi_istisna_ssk_tutar - normal_total_pay_ssk_tax_net;
					
					fazla_total_pay_ssk_tax_net = fazla_total_pay_ssk_tax_net/(1-tax_carpan);
					brut_fazla_total_pay_ssk_tax_net = wrk_round((fazla_total_pay_ssk_tax_net*1000)/(1000-oran_damga_duzeltme));
					
					vergi_istisna_ssk_tutar = (brut_normal_total_pay_ssk_tax_net + brut_fazla_total_pay_ssk_tax_net);
				}
			}
			temp_vergi_istisna_ssk_tutar_hs = total_vergi_istisna_ssk_tutar_hs;
			vergi_istisna_ssk_tutar_net_hs = total_vergi_istisna_ssk_tutar_hs;
			if(total_vergi_istisna_ssk_tutar_hs gt 0)
			{
				sal_temp = salary;//from_net_odenek de oranlamak icin kullaniliyor
				gelir_vergisi_matrah = salary;
				include 'get_hr_compass_tax.cfm';//tax_ratio geliyor

				if(salary+ekten_gelen gt ssk_matrah_tavan)
				{
					oran_damga_duzeltme = get_active_program_parameter.STAMP_TAX_BINDE;
					total_vergi_istisna_ssk_tutar_hs = wrk_round( (total_vergi_istisna_ssk_tutar_hs*1000)/(1000-oran_damga_duzeltme));
				}
				else if(salary+brut_total_pay_ssk_tax_net+ekten_gelen lte ssk_matrah_tavan)		
				{//brut ucret ve sadece hem ssk hem vergi dahil odenekler toplami tavandan kucukse
					oran_damga_duzeltme = (get_active_program_parameter.STAMP_TAX_BINDE*100)/((100-ssk_isci_carpan-issizlik_isci_carpan) );
					temp_total_pay_ssk_tax_net = total_vergi_istisna_ssk_tutar_hs;
					total_pay_ssk_tax_net = (temp_total_pay_ssk_tax_net*100)/(100-ssk_isci_carpan-issizlik_isci_carpan);
					total_vergi_istisna_ssk_tutar_hs = ((total_pay_ssk_tax_net*1000)/(1000-oran_damga_duzeltme) );
				}
				else if(salary+brut_total_pay_ssk_tax_net+ekten_gelen gt ssk_matrah_tavan)	
				{//brut ucret ve hem ssk hem vergi dahil odenekler toplami tavandan buyukse
					oran_damga_duzeltme = get_active_program_parameter.STAMP_TAX_BINDE;
					
					brut_normal_total_pay_ssk_tax_net = (ssk_matrah_tavan-(salary+ekten_gelen));
					normal_total_pay_ssk_tax_net = (brut_normal_total_pay_ssk_tax_net * (100 - ssk_isci_carpan - issizlik_isci_carpan)) / 100;
					normal_total_pay_ssk_tax_net = normal_total_pay_ssk_tax_net;
					normal_total_pay_ssk_tax_net = normal_total_pay_ssk_tax_net - (brut_normal_total_pay_ssk_tax_net * get_active_program_parameter.STAMP_TAX_BINDE / 1000);
					fazla_total_pay_ssk_tax_net = total_vergi_istisna_ssk_tutar_hs - normal_total_pay_ssk_tax_net;
					
					fazla_total_pay_ssk_tax_net = fazla_total_pay_ssk_tax_net;
					brut_fazla_total_pay_ssk_tax_net = wrk_round((fazla_total_pay_ssk_tax_net*1000)/(1000-oran_damga_duzeltme));
					
					total_vergi_istisna_ssk_tutar_hs = (brut_normal_total_pay_ssk_tax_net + brut_fazla_total_pay_ssk_tax_net);
				}
			}
		}
		if(temp_vergi_istisna_ssk_tutar_hs gt 0)
		{
			oran_damga_duzeltme = get_active_program_parameter.STAMP_TAX_BINDE/(1-0);
			temp_vergi_istisna_damga_tutar_hs_net = temp_vergi_istisna_ssk_tutar_hs;
			temp_vergi_istisna_damga_tutar_hs = temp_vergi_istisna_ssk_tutar_hs/(1-0);
			temp_vergi_istisna_damga_tutar_hs = wrk_round((temp_vergi_istisna_damga_tutar_hs*1000)/(1000-oran_damga_duzeltme));
		}
		vergi_istisna_ssk_tutar=vergi_istisna_ssk_tutar+total_vergi_istisna_ssk_tutar_hs;
		vergi_istisna_ssk_tutar_net=vergi_istisna_ssk_tutar_net+vergi_istisna_ssk_tutar_net_hs;
		vergi_istisna_damga_tutar = wrk_round(vergi_istisna_osi + vergi_istisna_bei+vergi_istisna_hs);
		vergi_istisna_damga_tutar_net = wrk_round(vergi_istisna_osi + vergi_istisna_bei+vergi_istisna_hs);
		if(vergi_istisna_damga_tutar gt 0)
		{
			oran_damga_duzeltme = get_active_program_parameter.STAMP_TAX_BINDE/(1-0);
			vergi_istisna_damga_tutar = vergi_istisna_damga_tutar/(1-0);
			vergi_istisna_damga_tutar = wrk_round((vergi_istisna_damga_tutar*1000)/(1000-oran_damga_duzeltme));
		}
		vergi_istisna_damga_vergisi = vergi_istisna_damga_tutar - vergi_istisna_damga_tutar_net;
		
		vergi_istisna_vergi_tutar = wrk_round(vergi_istisna_vergi_tutar);
		if(vergi_istisna_vergi_tutar gt 0)
		{
			gelir_vergisi_matrah = salary;
			include 'get_hr_compass_tax.cfm';
			vergi_istisna_vergi_tutar_net = vergi_istisna_vergi_tutar;
			oran_damga_duzeltme = get_active_program_parameter.STAMP_TAX_BINDE/(1-tax_carpan);
			vergi_istisna_vergi_tutar = vergi_istisna_vergi_tutar/(1-tax_carpan);
			vergi_istisna_vergi_tutar = wrk_round((vergi_istisna_vergi_tutar*1000)/(1000-oran_damga_duzeltme));
		}
		maas_tax_carpan = tax_carpan;
		vergi_istisna_vergi_tutar_net = wrk_round(vergi_istisna_vergi_tutar_net);
		//salary = salary - ozel_kesinti_2;
		if(isdefined("attributes.ihbar_amount") and attributes.ihbar_amount gt 0)
		{
				brut_salary = salary;
				ihbar_1_ = attributes.ihbar_amount;
				attributes.ihbar_amount = 0;
				a_g_m_ = asgari_gecim_max_tutar_;
				ozel_kesinti_ = ozel_kesinti;
				ozel_kesinti = 0;
				ozel_kesinti_2_ = ozel_kesinti_2;
				ozel_kesinti_2 = 0;		
				include 'get_hr_compass_from_brut.cfm';
				ozel_kesinti_2 = ozel_kesinti_2_;
				ozel_kesinti = ozel_kesinti_;				
				asgari_gecim_max_tutar_ = a_g_m_;
				attributes.ihbar_amount_net = net_ucret;
				attributes.ihbar_amount = ihbar_1_;
				salary = brut_salary;
		}
		//baz ucret brut ise ve odeneklerin de hepsi brut ise sadece brut hesabina girer.
		if(ozel_kesinti_2 gt 0)//Hata ile karşılaşıldı dönüşe göre tekrar düzenleme yapılacaks
		{
			brut_salary = salary;
			tempp = salary;
			a_g_m_ = asgari_gecim_max_tutar_;
			ozel_kesinti_2_ = ozel_kesinti_2;
			ozel_kesinti_2 = 0;
			ozel_kesinti_2_brut_= ozel_kesinti_2_brut;
			ozel_kesinti_2_brut = 0;
			is_total_calc = 1;
			is_devir_matrah_off = 0;
			include 'get_hr_compass_from_brut.cfm';

			ozel_kesinti_2_oncesi_net = net_ucret;
			ozel_kesinti_2_brut = ozel_kesinti_2_brut_;
			ozel_kesinti_2 = ozel_kesinti_2_;
			salary = tempp;
			brut_salary = salary;
			a_g_m_ = asgari_gecim_max_tutar_;
		}

		is_total_calc = 1;
		is_devir_matrah_off = 0;
		include 'get_hr_compass_from_brut.cfm';
		if(ozel_kesinti_2 gt 0)
		{
			ozel_kesinti_2_net = ozel_kesinti_2_oncesi_net - net_ucret;
			if(ozel_kesinti_2_brut)
				ozel_kesinti_2 = ozel_kesinti_2 + ozel_kesinti_2_brut;
		}
		if(ozel_kesinti_2 eq 0 and ozel_kesinti_2_brut gt 0)
		{
			ozel_kesinti_2 = ozel_kesinti_2_brut;
			ozel_kesinti_2_net = ozel_kesinti_2_brut;
		}
		//abort('net_ucret:#net_ucret# ozel_kesinti_2:#ozel_kesinti_2# ozel_kesinti_2_net:#ozel_kesinti_2_net# ');

		if(get_get_salary2.recordcount gt 0 and use_ssk eq 1)
		{ 
			//icra işlemleri start
			icraya_dahil_olmayan_odenek_tutar = 0; 
			yasal_kesintiler_toplam = 0;
			if(arraylen(puantaj_exts))
			{
				for(ccm=1;ccm lte arraylen(puantaj_exts);ccm=ccm+1)
					if(puantaj_exts[ccm][6] eq 0) // ödenekler
					{
						if(puantaj_exts[ccm][34] eq 1) // icraya dahil değil işaretli olduğu durumlarda 
						{
							icraya_dahil_olmayan_odenek_tutar = icraya_dahil_olmayan_odenek_tutar + puantaj_exts[ccm][3];
						}
					}
			}		
			if(get_active_program_parameter.interruption_type eq 0) // agi tutarı kontrol
				{
					yasal_kesintiler_toplam = yasal_kesintiler_toplam + ssk_isci_hissesi + ssdf_isci_hissesi + gelir_vergisi + damga_vergisi + issizlik_isci_hissesi + vergi_iadesi + bes_isci_hissesi;
				}
			else
				{
					yasal_kesintiler_toplam = yasal_kesintiler_toplam + ssk_isci_hissesi + ssdf_isci_hissesi + gelir_vergisi + damga_vergisi + issizlik_isci_hissesi + bes_isci_hissesi;
				}
			if(salary-icraya_dahil_olmayan_odenek_tutar-yasal_kesintiler_toplam gt 0 and ssk_days gt 0) // toplam kazanç 0 dan büyük ise icra hesabı yapılacak
			{
				if(get_hr_ssk.is_kidem_ihbar_all_total eq 1)
				{
					max_kesilebilecek_tutar = (((salary-ihbar_net-kidem_net-icraya_dahil_olmayan_odenek_tutar-yasal_kesintiler_toplam)/100)*25)+kidem_net+ihbar_net;
				}
				else
				{
					max_kesilebilecek_tutar = (((salary-icraya_dahil_olmayan_odenek_tutar-yasal_kesintiler_toplam)/100)*25);
				}
				devreden_tutar = 0;
				kesilen_icra_toplam = 0;
				finish = 0;
				
				for (i=1; i lte get_get_salary2.recordcount; i = i+1)
				{
					icra_kesinti_tutarı = 0;
					
					if(devreden_tutar gt 0) // 2.icra dan kesileceği durumlarda
					{
						max_kesilebilecek_tutar = devreden_tutar;
					}
					else if(i gt 1)
					{
						max_kesilebilecek_tutar = 0;
					}
					kalan = get_get_salary2.debt_amount[i] - get_get_salary2.odenen_toplam[i];
					if(get_get_salary2.deduction_type[i] eq 1) //yuzde
					{
						if (kalan lt max_kesilebilecek_tutar)
							{
								icra_kesinti_tutarı = icra_kesinti_tutarı+kalan;
								kesilen_icra_toplam = kesilen_icra_toplam+kalan;
							}
						else
							{
								icra_kesinti_tutarı = icra_kesinti_tutarı+max_kesilebilecek_tutar;	
								kesilen_icra_toplam = kesilen_icra_toplam+max_kesilebilecek_tutar;
							}
					}
					
					if(finish eq 0 and (icra_kesinti_tutarı gt 0 or get_get_salary2.deduction_type[i] eq 2) and (icra_kesinti_tutarı lte max_kesilebilecek_tutar)) //çalışanın toplam kazancının %25 i kadar kesinti yapılabilecek eğer 1.icrada max tutardan düşük olursa 2.icraya geçilecek
					{
						puantaj_exts_index = puantaj_exts_index + 1;
						puantaj_exts[puantaj_exts_index][1] = get_get_salary2.comment_get[i];
						puantaj_exts[puantaj_exts_index][2] = get_get_salary2.deduction_type[i]; // 2 eksi- 1 yuzde
						if(get_get_salary2.deduction_type[i] eq 1 or kalan gte get_get_salary2.deduction_value[i])
							{puantaj_exts[puantaj_exts_index][3] = get_get_salary2.deduction_value[i];}//amount
						else
							{puantaj_exts[puantaj_exts_index][3] = kalan;}
						puantaj_exts[puantaj_exts_index][4] = 0; //ssk
						puantaj_exts[puantaj_exts_index][5] = 0; //vergi
						puantaj_exts[puantaj_exts_index][6] = 3; // EXT_TYPE icra kesintilerinden gelen
						puantaj_exts[puantaj_exts_index][7] = 0; // calc_days
						puantaj_exts[puantaj_exts_index][8] = 0;
	
						if(get_get_salary2.deduction_type[i] eq 1) //yuzde
						{
							
							puantaj_exts[puantaj_exts_index][8] = icra_kesinti_tutarı; 
							ozel_kesinti = ozel_kesinti+icra_kesinti_tutarı; 
							net_ucret = net_ucret - icra_kesinti_tutarı;
						}
						else
						{
							if (kalan gte get_get_salary2.deduction_value[i])
								{
									ozel_kesinti = ozel_kesinti+get_get_salary2.deduction_value[i];
									net_ucret = net_ucret - get_get_salary2.deduction_value[i]; 
								}
							else
								{
									ozel_kesinti = ozel_kesinti+kalan;
									net_ucret = net_ucret - kalan;
								}
						}
						puantaj_exts[puantaj_exts_index][9] = 0;   //  0 net 1 brüt
						puantaj_exts[puantaj_exts_index][33] = 0;   //  0 net 1 brüt
						puantaj_exts[puantaj_exts_index][10] = '';/*kideme dahil mi ek odenekler icin kullaniliyor*/
						puantaj_exts[puantaj_exts_index][11] = '';/*yuzde sinir vergi istisnasi icin kullaniliyor*/
						puantaj_exts[puantaj_exts_index][12] = '';
						puantaj_exts[puantaj_exts_index][13] = '';
						puantaj_exts[puantaj_exts_index][14] = '';
						puantaj_exts[puantaj_exts_index][15] = '';
						puantaj_exts[puantaj_exts_index][16] = get_get_salary2.execution_id[i];
						puantaj_exts[puantaj_exts_index][17] = get_get_salary2.company_id[i];
						puantaj_exts[puantaj_exts_index][18] = get_get_salary2.account_code[i];
						puantaj_exts[puantaj_exts_index][19] = get_get_salary2.account_name[i];
						puantaj_exts[puantaj_exts_index][20] = get_get_salary2.consumer_id[i];
						puantaj_exts[puantaj_exts_index][21] = get_get_salary2.acc_type_id[i];
						puantaj_exts[puantaj_exts_index][22] = '';
						puantaj_exts[puantaj_exts_index][23] = '';
						puantaj_exts[puantaj_exts_index][24] = '';
						puantaj_exts[puantaj_exts_index][25] = '';
						puantaj_exts[puantaj_exts_index][26] = '';
						puantaj_exts[puantaj_exts_index][27] = '';
						puantaj_exts[puantaj_exts_index][28] = '';
						puantaj_exts[puantaj_exts_index][29] = '';
						puantaj_exts[puantaj_exts_index][30] = '';
						puantaj_exts[puantaj_exts_index][31] = '';
						puantaj_exts[puantaj_exts_index][32] = '';
						puantaj_exts[puantaj_exts_index][34] = '';
						devreden_tutar = max_kesilebilecek_tutar-icra_kesinti_tutarı;					
					}
					if(kesilen_icra_toplam eq max_kesilebilecek_tutar)
					{
						devreden_tutar = 0;
						finish = 1;
					}
				} 
			}
			//icra işlemleri finish
			//include 'get_hr_compass_from_brut.cfm';
		}
		gelir_vergisi_matrah_ay_icinde_nakil = gelir_vergisi_matrah_ay_icinde_nakil + gelir_vergisi_matrah;
		total_pay_ssk_tax_ = total_pay_ssk_tax;
		total_pay_tax_ = total_pay_tax;
		total_pay_ssk_ = total_pay_ssk;
		total_pay_ = total_pay;
		/*if(ssk_matrah_kullanilan gt 0 and get_hr_salary.gross_net eq 1)//121551 ID'Lİ İŞ İÇİN KAPATILMIŞTIR. KONTROLLERİ YAPILACAKTIR.
		{
			first_net_ucret = net_ucret;
			ssk_matrah_devirden_gelen_ssk = (ssk_isci_hissesi_dusulecek + issizlik_isci_hissesi_dusulecek);
			salary = wrk_round(maas_brutu_);
			if(SSK_MATRAH lt ssk_matrah_tavan and (SSK_MATRAH+ssk_matrah_kullanilan*20/100) gte ssk_matrah_tavan)
			{
				kontrol_matrah_ = 1;
				is_total_calc = 1;
				is_devir_matrah_off = 0;
				include 'get_hr_compass_from_brut.cfm';
			}
			ssk_matrah_devirden_gelen_ssk = (ssk_isci_hissesi_dusulecek + issizlik_isci_hissesi_dusulecek);
			salary = wrk_round(maas_brutu_);
			is_devir_matrah_off = 0;
			is_total_calc = 1;
			include 'get_hr_compass_from_brut.cfm';
			new_net_ucret = net_ucret;
			fark_ = wrk_round(abs(first_net_ucret-new_net_ucret));//devreden varken ve yokken maaşlar arasındaki fark bulunur
			brut_salary = salary;
			tutar_ = fark_;
			total_pay_ssk_tax_net = fark_;
			is_tax_ = 1;
			is_izin_ = 0;
			tax_control = 0;
			total_pay_ssk_oncesi = TOTAL_PAY_TAX;
			if(total_pay_ssk_tax_net gt 0)
			{
				if(SSK_MATRAH gte ssk_matrah_tavan or (SSK_MATRAH+ssk_matrah_kullanilan*20/100) gte ssk_matrah_tavan)//eğer ssk matrahı tavandan düşükse kullanılan matrah eklendiğinde matrahı geçiyor mu diye kontrol ediliyor
				{
					is_ssk_ = 0;
					//is_mesai_ = 1;
				}
				else
				{	
					is_ssk_ = 1;
					is_issizlik_ = 1; 
					is_damga_ = 1;
					is_mesai_ = 0; //83417 id li iş duzenleme SG 20141205
				}
				include 'get_hr_compass_from_net_odenek.cfm';
			}
			salary = wrk_round(maas_brutu_ + total_pay_ssk);
			is_devir_matrah_off = 0;
			is_total_calc = 1;
			if (get_kumulative.recordcount)
				kumulatif_gelir = get_kumulative.KUMULATIF_GELIR_MATRAH;
			else if(len(get_hr_salary.CUMULATIVE_TAX_TOTAL))
				kumulatif_gelir = get_hr_salary.CUMULATIVE_TAX_TOTAL;
			else
				kumulatif_gelir = 0;
			include 'get_hr_compass_from_brut.cfm';
			if(ssk_matrah_kullanilan gt 0)
				ssk_matrah_kullanilan = ssk_matrah + total_pay_ssk_oncesi - (SALARY-attributes.ihbar_amount);
		}*/	
	}

	total_pay_ssk_tax = total_pay_ssk_tax_;
	total_pay_tax = total_pay_tax_;
	total_pay_ssk = total_pay_ssk_;
	total_pay = total_pay_;
	if(included_in_tax_paid_amount gt 0 or is_yearly_offtime eq 1)
	{
		damga_vergisi = included_in_tax_paid_amount_stamp_tax;
		gelir_vergisi = included_in_tax_paid_amount_income_tax;
	}
	if( seniority_salary gt 0 and isdefined("maas_brutu_") )
	{
		seniority_salary = salary - maas_brutu_ + seniority_salary;
	}
	/*  daily_minimum_wage_stamp_tax = temp_daily_minimum_wage_stamp_tax;
	daily_minimum_income_tax = temp_daily_minimum_income_tax;*/
</cfscript>
<cfcatch type="any">
	<cfif not isdefined("attributes.from_employee_payroll") and isdefined('this.returnResult')>
		<cfset this.returnResult( status: false, fileid: attributes.in_out_id, errorMessage: cfcatch, in_out_id: attributes.in_out_id) />
	<cfelse>
		<cfdump var="#cfcatch#">
		<cfabort>
	</cfif>
</cfcatch>
</cftry>