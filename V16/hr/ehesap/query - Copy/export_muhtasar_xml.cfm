<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.export_reason" default="A">
<cfparam name="attributes.export_type" default="A">
<cfparam name="attributes.is_sgk_only" default="0">
<cf_xml_page_edit fuseact='ehesap.list_muhtasar_xml_export'>

<cfif isdefined("attributes.companyid") and len(attributes.companyid)>
	<cfset attributes.company_id = attributes.companyid>
</cfif>

<cfif isdefined("attributes.ssk_office") and len(attributes.ssk_office)>
	<cfset file_name = "#attributes.sal_year#_#attributes.ssk_office#_#dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHMMSS')#">
<cfelseif isdefined("attributes.company_id") and len(attributes.company_id)>
	<cfset file_name = "#attributes.sal_year#_#attributes.company_id#_#dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHMMSS')#">
<cfelse>
	<cfset file_name = "#attributes.sal_year#_all_#dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHMMSS')#">
</cfif>

<cfset bu_ay_basi = createdate(attributes.sal_year,attributes.sal_mon, 1)>
<cfset bu_ay_sonu = date_add('d',-1,date_add('m',1,bu_ay_basi))>
<cfset bu_ay_sonu_izin = date_add('m',1,bu_ay_basi)>
<cfset bu_ay_sonu = createdate(year(bu_ay_sonu),month(bu_ay_sonu),day(bu_ay_sonu))>
<cfset bu_ay_sonu_izin = createdate(year(bu_ay_sonu_izin),month(bu_ay_sonu_izin),day(bu_ay_sonu_izin))>
<cfset aydaki_gun_sayisi = daysinmonth(bu_ay_basi)>

<cffunction name="para_format" returntype="string">
	<cfargument name="gelen" required="yes" type="string">
	<cfset donen_rakam = replace(wrk_round(gelen),'.',',','all')>
	<cfreturn donen_rakam>
</cffunction>

<cfquery name="get_insurance" datasource="#dsn#">
	SELECT * FROM INSURANCE_PAYMENT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_basi#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#">
</cfquery>
<cfset ilgili_ay_asgari_ucret = get_insurance.MIN_PAYMENT>
<cfset ilgili_ay_asgari_ucret_net = get_insurance.MIN_PAYMENT * 0.85>

<cfset ilgili_ay_asgari_gvm = wrk_round(get_insurance.MIN_PAYMENT - (get_insurance.MIN_PAYMENT * 15 /100))>
<cfset ilgili_ay_asgari_gv = ilgili_ay_asgari_gvm * 15 / 100>
<cfset max_payment_ = get_insurance.max_payment>
<cfquery name="get_branch_employees" datasource="#dsn#">
	SELECT 
    	(SELECT SBC.BUSINESS_CODE FROM SETUP_BUSINESS_CODES SBC WHERE SBC.BUSINESS_CODE_ID = EIO.BUSINESS_CODE_ID) AS BUSINESS_CODE,
		EPR.SALARY,
		EPR.OZEL_KESINTI_2,
		EPR.SSDF_ISVEREN_HISSESI,
		EPR.KIDEM_AMOUNT,
		EPR.IHBAR_AMOUNT,
		EPR.EMPLOYEE_PUANTAJ_ID,
		EPR.EMPLOYEE_ID,
		EPR.PUANTAJ_ID,
		EPR.IN_OUT_ID,
		EPR.SSK_DAYS,
		B.SSK_M,
		B.SSK_JOB,
		B.SSK_BRANCH,
		B.SSK_BRANCH_OLD,
		B.SSK_NO,
		B.SSK_CITY,
		B.SSK_COUNTRY,
		B.SSK_AGENT,
		B.SSK_OFFICE,
		B.BRANCH_ID,
		B.KANUN_6322,
		EIO.SOCIALSECURITY_NO,
		EI.TC_IDENTY_NO,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		ISNULL(EIO.IS_TAX_FREE,0) IS_TAX_FREE,
		EIO.START_DATE,
		EIO.FINISH_DATE,
		EIO.EXPLANATION_ID,
		EIO.IS_56486,
		EIO.IS_66486,
		EIO.IS_46486,
		EIO.DAYS_5746,
		EIO.LAW_NUMBERS,
		EPR.IS_7252_CONTROL,
		EPR.SSK_DAYS_7252,
		EIO.DUTY_TYPE,
		EPR.VERGI_IADESI,
		EPR.GELIR_VERGISI_MATRAH,
		EIO.DEFECTION_LEVEL,
		EIO.DEFECTION_RATE,
		EIO.IS_14857,
		EPR.GELIR_VERGISI,
		EIO.SSK_STATUTE,
		EIO.DAYS_506,
		EIO.IS_USE_506,
        EPR.SSK_MATRAH_RD_OUT, 
        EPR.SSK_MATRAH,
		EPR.SSK_ISVEREN_HISSESI,
		EPR.SSK_ISVEREN_HISSESI_14857,
		EPR.SSK_ISVEREN_HISSESI_3294,
		EPR.SSK_ISVEREN_HISSESI_5746,
		EPR.SSK_ISVEREN_HISSESI_687,
		EPR.SSK_ISVEREN_HISSESI_6645,
		EPR.SSK_ISVEREN_HISSESI_6111,
		EPR.SSK_ISVEREN_HISSESI_6486,
		EPR.SSK_ISVEREN_HISSESI_6322,
		EPR.SSK_ISVEREN_HISSESI_5921,
		EPR.SSK_ISVEREN_HISSESI_5921_DAY,
		EPR.SSK_ISVEREN_HISSESI_GOV,
		EPR.SSK_ISVEREN_HISSESI_GOV_100,
		EPR.SSK_ISVEREN_HISSESI_GOV_80,
		EPR.SSK_ISVEREN_HISSESI_GOV_60,
		EPR.SSK_ISVEREN_HISSESI_GOV_40,
		EPR.SSK_ISVEREN_HISSESI_GOV_20,
		EPR.SSK_ISVEREN_HISSESI_GOV_100_DAY,
		EPR.SSK_ISVEREN_HISSESI_GOV_80_DAY,
		EPR.SSK_ISVEREN_HISSESI_GOV_60_DAY,
		EPR.SSK_ISVEREN_HISSESI_GOV_40_DAY,
		EPR.SSK_ISVEREN_HISSESI_GOV_20_DAY,
		EPR.TOTAL_PAY,
		EPR.SSK_MATRAH_EXEMPTION,
		VERGI_ISTISNA_SSK,
		VERGI_ISTISNA_VERGI,
		EPR.SSK_DAYS AS TOTAL_DAYS,
		EPR.VERGI_IADESI AS ASGARI_GECIM_INDIRIMI,
		EIO.TRADE_UNION_DEDUCTION,
		B.IS_5510 AS SUBE_IS_5510,
		EIO.IS_5510,
		EIO.IS_SAKAT_KONTROL,
		ISNULL(EPR.SSK_DAYS_5746,0) AS SSK_DAYS_5746,
		ISNULL(EPR.TAX_DAYS_5746,0) AS TAX_DAYS_5746,
		EPR.TOTAL_SALARY,
		EPR.IHBAR_AMOUNT,
		EPR.KIDEM_AMOUNT,
		EPR.TOTAL_PAY_TAX,
		EPR.TOTAL_PAY_SSK_TAX,
		EPR.TOTAL_PAY_SSK,
		EPR.SSK_DEVIR,
		EPR.SSK_DEVIR_LAST,
		EPR.LAW_NUMBER_7103,
		EPR.SSK_ISVEREN_HISSESI_7103,
		EPR.SSK_ISCI_HISSESI_7103,
		EPR.ISSIZLIK_ISCI_HISSESI_7103,
		EPR.ISSIZLIK_ISVEREN_HISSESI_7103,
		EPR.GELIR_VERGISI_INDIRIMI_7103,
		EPR.DAMGA_VERGISI_INDIRIMI_7103,
		DAMGA_VERGISI_INDIRIMI_687,
		DAMGA_VERGISI,
		DAMGA_VERGISI_INDIRIMI_7103,
		EPR.IZIN,
		EPR.IZIN_PAID,
		EPR.BASE_AMOUNT_7256,
		EP.SSK_OFFICE_NO,
		EPR.EXT_SALARY,
		RWD.*,
		SAKATLIK_INDIRIMI,
		DAILY_MINIMUM_WAGE_BASE_CUMULATE,
		MINIMUM_WAGE_CUMULATIVE,
		DAILY_MINIMUM_INCOME_TAX,
		DAILY_MINIMUM_WAGE_STAMP_TAX,
		DAILY_MINIMUM_WAGE,
		INCOME_TAX_TEMP,
		STAMP_TAX_TEMP,
		GELIR_VERGISI_INDIRIMI_687,
		GELIR_VERGISI_INDIRIMI_7103,
		VERGI_INDIRIMI_5084,
		GELIR_VERGISI_INDIRIMI_5746,
		GELIR_VERGISI_INDIRIMI_4691,
		ES.M#attributes.sal_mon# EMPLOYEE_SALARY,
		EIO.SALARY_TYPE,
		EIO.GROSS_NET,
		CASE 
			WHEN
				EIO.SALARY_TYPE = 2 AND EIO.GROSS_NET = 0 AND ES.M#attributes.sal_mon# = #ilgili_ay_asgari_ucret#
			THEN
				1
			WHEN
				EIO.SALARY_TYPE = 2 AND EIO.GROSS_NET = 1 AND ES.M#attributes.sal_mon# = #ilgili_ay_asgari_ucret_net#
			THEN
				1
			WHEN 
				EIO.SALARY_TYPE = 1 AND EIO.GROSS_NET = 0 AND ES.M#attributes.sal_mon# = #ilgili_ay_asgari_ucret / 30#
			THEN 
				1
			WHEN 
				EIO.SALARY_TYPE = 1 AND EIO.GROSS_NET = 1 AND ES.M#attributes.sal_mon# = #ilgili_ay_asgari_ucret_net / 30#
			THEN 
				1
			WHEN 
				EIO.SALARY_TYPE = 0 AND EIO.GROSS_NET = 0 AND ES.M#attributes.sal_mon# = #ilgili_ay_asgari_ucret / 225#
			THEN 
				1
			WHEN 
				EIO.SALARY_TYPE = 0 AND EIO.GROSS_NET = 1 AND ES.M#attributes.sal_mon# = #ilgili_ay_asgari_ucret_net / 225#
			THEN 
				1
			ELSE 
				0
		END AS IS_DAILY_MIN_WAGE,
		EIO.USE_SSK,
		ISNULL(GELIR_VERGISI_MATRAH_5746,0) GELIR_VERGISI_MATRAH_5746,
		(EPR.DAMGA_VERGISI_INDIRIMI_5746 / 7.59 * 1000) AS DVM_MATRAH_5746,
		ISNULL((SELECT SUM(VERGI_ISTISNA_AMOUNT) FROM EMPLOYEES_PUANTAJ_ROWS_EXT EEP WHERE EEP.EMPLOYEE_PUANTAJ_ID = EPR.EMPLOYEE_PUANTAJ_ID AND EEP.EXT_TYPE = 2),0) VERGI_ISTISNA_AMOUNT
	FROM
    	BRANCH B,
        EMPLOYEES_PUANTAJ EP,
		EMPLOYEES_PUANTAJ_ROWS EPR,
		EMPLOYEES_IN_OUT EIO
			LEFT JOIN REMOTE_WORKING_DAY RWD ON RWD.IN_OUT_ID = EIO.IN_OUT_ID AND RWD.PERIOD_YEAR = #attributes.sal_year#
			LEFT JOIN EMPLOYEES_SALARY ES ON ES.IN_OUT_ID = EIO.IN_OUT_ID AND ES.PERIOD_YEAR = #attributes.sal_year#,
		EMPLOYEES_IDENTY EI,
		EMPLOYEES E
    WHERE
		EP.PUANTAJ_TYPE = -1 AND
        EPR.EMPLOYEE_ID = E.EMPLOYEE_ID AND
		EPR.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
    	EPR.IN_OUT_ID = EIO.IN_OUT_ID AND
		EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND
		EP.SSK_OFFICE = B.SSK_OFFICE AND
		EP.SSK_OFFICE_NO = B.SSK_NO AND
		EIO.BRANCH_ID = B.BRANCH_ID AND
		EP.SAL_YEAR = #ATTRIBUTES.SAL_YEAR# AND
		EP.SAL_MON = #ATTRIBUTES.SAL_MON# AND
		EIO.USE_SSK = 1
		AND B.BRANCH_ID IN 
		(
			SELECT
				BRANCH_ID
			FROM
				EMPLOYEE_POSITION_BRANCHES
			WHERE
				EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#
		)
		AND B.COMPANY_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
		<cfif isdefined("attributes.company_id") and listlen(attributes.company_id)>
			AND B.COMPANY_ID = #attributes.company_id#
		</cfif>
        <cfif isdefined("attributes.ssk_office") and listlen(attributes.ssk_office)>
        	AND B.BRANCH_ID = #attributes.ssk_office#
        </cfif> 
</cfquery>
<!---Eksik gün nedeni için eklendi Esma R. Uysal 04/06/2020 ---->
<cfquery name="get_offtimes" datasource="#dsn#">
	SELECT
		OFFTIME.EMPLOYEE_ID,
		SETUP_OFFTIME.EBILDIRGE_TYPE_ID,
		SETUP_OFFTIME.SIRKET_GUN,
		OFFTIME.STARTDATE,
		OFFTIME.IN_OUT_ID,
		OFFTIME.FINISHDATE,
		DATEDIFF("hh",STARTDATE, FINISHDATE) HOUR_DIFF
	FROM
		OFFTIME, SETUP_OFFTIME
	WHERE
		SETUP_OFFTIME.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID
		AND (SETUP_OFFTIME.IS_PAID = 0 OR SETUP_OFFTIME.EBILDIRGE_TYPE_ID = 1)
		AND OFFTIME.IS_PUANTAJ_OFF = 0
		AND ISNULL(SETUP_OFFTIME.IS_PUANTAJ_OFF,0) = 0
		AND OFFTIME.VALID = 1
		AND OFFTIME.STARTDATE < #bu_ay_sonu_izin#
		AND OFFTIME.FINISHDATE >= #bu_ay_basi#
	ORDER BY
		OFFTIME.EMPLOYEE_ID
</cfquery>
<cfif attributes.is_sgk_only eq 1>
	<cfif not get_branch_employees.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='54638.Çalışan Kaydı Bulunamadı'>!");
			location.reload();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfset CRLF = Chr(13) & Chr(10)>
<cfset TAB_CHR = Chr(9)>
<cfset row_list = "">
<cfset header_list ="#getlang('','BELGENİN MAHİYETİ',45953)#;#getlang('','BELGE TÜRÜ',58578)#;#getlang('','DÜZENLEMEYE ESAS NO',913)#;#getlang('','YENİ ÜNİTE KODU',914)#;#getlang('','ESKİ ÜNİTE KODU',915)#;#getlang('','İŞYERİ SIRA NO;İL KODU',916)#;#getlang('','ALT İŞVEREN NO',917)#;#getlang('','SSK SİCİL',918)#;#getlang('','SG-TC NO',919)#;#getlang('','ADI',57897)#;#getlang('','SOYADI',58550)#">
<cfset header_list ="#header_list#;#getlang('','PRİM ÖDEME GÜNÜ',59482)#;#getlang('','UZAKTAN ÇALIŞMA GÜN',63061)#;#getlang('','HAK EDİLEN ÜCRET',46567)#;#getlang('','PRİM İKRAMİYE VE BU NİTELİKTE İSTİHKAK',920)#;#getlang('','İŞE GİRİŞ GÜN',921)#;#getlang('','İŞE GİRİŞ AY',924)#;#getlang('','İŞTEN ÇIKIŞ GÜN',923)#;#getlang('','İŞTEN ÇIKIŞ AY',922)#">
<cfset header_list ="#header_list#;#getlang('','İŞTEN ÇIKIŞ NEDENİ',53882)#;#getlang('','EKSİK GÜN SAYISI',925)#;#getlang('','EKSİK GÜN NEDENİ',53881)#;#getlang('','MESLEK KODU;İSTİRAHAT SÜRELERİNDE ÇALIŞMAMIŞTIR',926)#;#getlang('','TAHAKKUK NEDENİ',62279)#;#getlang('','HİZMET DÖNEM AY',927)#">
<cfset header_list ="#header_list#;#getlang('','HİZMET DÖNEM YIL',928)#;#getlang('','GELİR VERGİSİNDEN MUAF MI',929)#">
<cfif attributes.sal_year lte 2021>
	<cfset header_list ="#header_list#;#getlang('','ASGARİ GEÇİM İNDİRİMİ',53659)#">
</cfif>
<cfset header_list ="#header_list#;#getlang('','İLGİLİ DÖNEME AİT GELİR VERGİSİ MATRAHI',930)#;#getlang('','GELİR VERGİSİ ENGELLİLİK ORANI',931)#">

<cfif attributes.sal_year gte 2022>
	<cfset header_list ="#header_list#;#getlang('','HESAPLANAN GELİR VERGİSİ',947)#;#UCase(getlang('','Asgari Ücret İstisna Gelir Vergisi',65148))#">
</cfif>

<cfset header_list ="#header_list#;#getlang('','GELİR VERGİSİ KESİNTİSİ',932)#">

<cfif attributes.sal_year gte 2022>
	<cfset header_list ="#header_list#;#UCase(getlang('','Asgari Ücret İstisna Damga Vergisi',65149))#;#UCase(getlang('','Damga Vergisi Kesintisi',65150))#">
</cfif>

<cfset header_list ="#header_list##CRLF#">

<cfset h_type_list = "nvarchar;nvarchar;nvarchar;nvarchar;nvarchar;nvarchar;nvarchar;nvarchar;nvarchar;nvarchar;nvarchar;nvarchar;nvarchar">
<cfset h_type_list = "#h_type_list#;integer;float;float;integer;integer;integer;integer">
<cfset h_type_list = "#h_type_list#;nvarchar;integer;integer;nvarchar;integer;integer;integer">
<cfset h_type_list = "#h_type_list#;integer;integer">
<cfif attributes.sal_year lte 2021>
	<cfset h_type_list = "#h_type_list#;float">
</cfif>
<cfset h_type_list = "#h_type_list#;float;integer">
<cfif attributes.sal_year gte 2022>
	<cfset h_type_list = "#h_type_list#;float;float">
</cfif>

<cfset h_type_list = "#h_type_list#;float"><!--- gelir vergisi --->

<cfif attributes.sal_year gte 2022>
	<cfset h_type_list = "#h_type_list#;float;float">
</cfif>

<cfset rowCount = 0>
<cfquery name="get_rows_ext" datasource="#DSN#">
	SELECT * FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE COMMENT_PAY_ID IS NOT NULL
</cfquery>
<cfoutput query="get_branch_employees">
<cfquery name="get_offtimes_type" dbtype="query">
	SELECT EBILDIRGE_TYPE_ID, SUM(HOUR_DIFF) HOUR_DIFF FROM get_offtimes WHERE IN_OUT_ID = #IN_OUT_ID# GROUP BY EBILDIRGE_TYPE_ID
</cfquery>
<cfquery name="get_payment" dbtype="query">
	SELECT 
		SUM(AMOUNT) AMOUNT_, 
		SUM(AMOUNT_2) AMOUNT_2_, 
		PAY_METHOD 
	FROM 
		get_rows_ext 
	WHERE 
		EMPLOYEE_PUANTAJ_ID = #get_branch_employees.EMPLOYEE_PUANTAJ_ID# 
		AND SSK = 2 
	GROUP BY
		PAY_METHOD
</cfquery>

<cfscript>
	declaration_type_id = '';
	declaration_types = '';
	
	//kısmi istihdam eksik gün nedeni
	if(duty_type eq 6 and (not isdefined("get_offtimes_type.recordcount") or not get_offtimes_type.recordcount))
		declaration_type_id = 6;
	else if(duty_type eq 6)
		declaration_type_id = 12;
	
	//Eksik gün nedeni için eklendi Esma R. Uysal 04/06/2020
	if(get_offtimes_type.recordcount)
	{
		declaration_types = valuelist(get_offtimes_type.EBILDIRGE_TYPE_ID);
		declaration_types_hour = valuelist(get_offtimes_type.HOUR_DIFF);

		
		 //izin 1 den fazla ve izinlerden birisi ücretsiz izinse ve bu izin yarım günlük izinden küçükse
		if(ListLen(declaration_types) eq 2 and ListFindNoCase(declaration_types,21) and listGetAt(declaration_types_hour, ListFindNoCase(declaration_types,21)) lt 7.5){
			declaration_types_hour = ListDeleteAt(declaration_types_hour, ListFindNoCase(declaration_types,21),",");
			declaration_types = ListDeleteAt(declaration_types, ListFindNoCase(declaration_types,21),",");
		} 
		
		if(not len(get_offtimes_type.EBILDIRGE_TYPE_ID))
			declaration_type_id = 13;
		else if(ListLen(declaration_types) gte 2)
		{
			if(ListFindNoCase(declaration_types,18) and not ListFindNoCase(declaration_types,28)){
				declaration_type_id = 27;//Kısa Çalışma Ödeneği ve başka kategoride
			}
			else if(ListFindNoCase(declaration_types,28)){
				declaration_type_id = 29;//Pandemi Ücretsiz İzin ve başka kategoride
			}
			else if(listlen(declaration_types) eq 1)
				declaration_type_id = declaration_types;
			else{
				declaration_type_id = 12; // birden fazla
			}
		}
		else
			declaration_type_id = get_offtimes_type.EBILDIRGE_TYPE_ID;
	}

	
	if(attributes.sal_year lte 2021)
		gelir_vergisi_hesaplanan = gelir_vergisi + vergi_indirimi_5084 + vergi_iadesi + gelir_vergisi_indirimi_5746 + gelir_vergisi_indirimi_4691;
	else if(gelir_vergisi - GELIR_VERGISI_INDIRIMI_687 - GELIR_VERGISI_INDIRIMI_7103  gt 0)
		gelir_vergisi_hesaplanan = gelir_vergisi - GELIR_VERGISI_INDIRIMI_687 - GELIR_VERGISI_INDIRIMI_7103  + daily_minimum_income_tax;
	else if(gelir_vergisi eq 0 and income_tax_temp gt 0)
		gelir_vergisi_hesaplanan = income_tax_temp;
	else
		gelir_vergisi_hesaplanan = 0;
	
	damga_vergisi_ = damga_vergisi - DAMGA_VERGISI_INDIRIMI_687 - DAMGA_VERGISI_INDIRIMI_7103;
	
	ext_matrah_ = '';
	ext_ikramiye = 0;
	ext_total_days = '';
	ext_eksik_sayi = '';
	ext_eksik_neden = '';
	ext_kanun_no = '';
	ext_varmi = 0;
	asgari_gecim = VERGI_IADESI;
	eksik_neden = declaration_type_id;
	eksik_sayi = '';
	gelir_vergisi_temp = gelir_vergisi;
	gelir_vergisi_matrah_temp = gelir_vergisi_matrah;
	SSK_ISVEREN_HISSESI_temp = SSK_ISVEREN_HISSESI;
	SSK_MATRAH_RD_OUT_temp = SSK_MATRAH_RD_OUT;
	SSK_MATRAH_temp = SSK_MATRAH;
	SSK_ISVEREN_HISSESI_5746_temp = SSK_ISVEREN_HISSESI_5746;
	
	ssk_matrah_ = SSK_MATRAH_temp;
	
	
	TOTAL_SALARY_temp = TOTAL_SALARY-VERGI_ISTISNA_SSK-VERGI_ISTISNA_VERGI;
	IHBAR_AMOUNT_temp = IHBAR_AMOUNT;
	KIDEM_AMOUNT_temp = KIDEM_AMOUNT;
	TOTAL_PAY_TAX_temp = TOTAL_PAY_TAX;
	TOTAL_PAY_SSK_TAX_temp = TOTAL_PAY_SSK_TAX;
	TOTAL_PAY_SSK_temp = TOTAL_PAY_SSK;
	
	if(not len(SSK_MATRAH_RD_OUT_temp))
		SSK_MATRAH_RD_OUT_temp = 0;

	total_days_ = total_days;


	total_matrah_yaz = SSK_MATRAH_temp;
	total_kazanc = TOTAL_SALARY_temp  + OZEL_KESINTI_2+SSK_DEVIR +SSK_DEVIR_LAST - (  TOTAL_PAY_TAX_temp + KIDEM_AMOUNT_temp + IHBAR_AMOUNT_temp + SSK_MATRAH_RD_OUT_temp + TOTAL_PAY);
	total_ikramiye = TOTAL_PAY_SSK_TAX_temp + TOTAL_PAY_SSK_temp + SSK_DEVIR + SSK_DEVIR_LAST - SSK_MATRAH_RD_OUT_temp;
	total_ikramiye_asil = TOTAL_PAY_SSK_TAX_temp + TOTAL_PAY_SSK_temp + SSK_DEVIR + SSK_DEVIR_LAST;
	total_ucret = total_kazanc - total_ikramiye;
	

	if(total_days eq 0 and izin eq 30 and aydaki_gun_sayisi eq 31)
	{
		if(aydaki_gun_sayisi eq 31 and TOTAL_DAYS eq 30)
		{
			eksik_gun_sayisi = 0;
		}
		else
		{
			eksik_gun_sayisi = 31;
		}
	}
	else
	{
		if(aydaki_gun_sayisi eq 31 and TOTAL_DAYS eq 30)
		{
			eksik_gun_sayisi = 0;
		}
		else
		{
			//eksik_gun_sayisiIZIN;
			if ((len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0) and (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)))) {
				eksik_gun_sayisi = dateformat(FINISH_DATE,"dd") - dateformat(start_date,"dd") + 1 - total_days_ ;
			}
			else if(len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu))
			{
				eksik_gun_sayisi = dateformat(FINISH_DATE,"dd") - total_days_;
			}
			else if(len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0) and explanation_id eq 18)
			{
				eksik_gun_sayisi = dateformat(start_date,"dd") - total_days_ - 1;
			}
			else if(len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0))
			{
				eksik_gun_sayisi = aydaki_gun_sayisi - dateformat(start_date,"dd") - total_days_ ;
			}
			else
			{
				eksik_gun_sayisi = aydaki_gun_sayisi - total_days_;
			}			
			if(len(izin) and not(aydaki_gun_sayisi eq 28 and TOTAL_DAYS eq 0) and duty_type neq 6 and izin neq 0) 
				eksik_gun_sayisi = izin;
			
			if(eksik_gun_sayisi < 0)
				eksik_gun_sayisi = 0;		
		}
	}
	eksik_sayi =  eksik_gun_sayisi;

	//Güne göre max matrah büyükse tavan matrahtan
	if((SALARY/30* total_days_) gte ssk_matrah_)
	{
		total_matrah_yaz = ssk_matrah_;
		total_ikramiye_yaz = 0;
		total_ikramiye_asil = 0;		
	}
	else if(total_ucret gte ssk_matrah_)
	{
		total_matrah_yaz = ssk_matrah_;
		total_ikramiye_yaz = 0;
		total_ikramiye_asil = 0; 
		
		if(get_payment.recordcount gt 0)
		{
			diff_salary = total_kazanc - get_payment.amount_ - SSK_DEVIR - SSK_DEVIR_LAST;
			
			if(diff_salary lte ssk_matrah_)
			{
				total_ikramiye_yaz = ssk_matrah_ - diff_salary;
			}
		}
	}
	else if(total_kazanc gte ssk_matrah_)
	{
		total_matrah_yaz = ssk_matrah_;
		total_ikramiye_yaz = ssk_matrah_ - total_ucret;
		total_ikramiye_asil = ssk_matrah_ - total_ucret;
		if(get_payment.recordcount gt 0)
		{
			if(listfindnocase('2,3,4',get_payment.PAY_METHOD))
				diff_salary = total_kazanc - get_payment.amount_2_ - SSK_DEVIR - SSK_DEVIR_LAST;
			else
				diff_salary = total_kazanc - get_payment.amount_ - SSK_DEVIR - SSK_DEVIR_LAST;
			
			if(diff_salary lte ssk_matrah_)
			{
				total_ikramiye_yaz = ssk_matrah_ - diff_salary;
				total_ikramiye_asil = ssk_matrah_ - diff_salary;
				
			}
		}
	}	
	else if(total_kazanc lt ssk_matrah_ and salary_type eq 1 and eksik_sayi eq 0 and aydaki_gun_sayisi eq 28)//Günlük çalışansa ve kazanç matrahtan düşükse ve şubat ayıysa ve çalışanın izini yoksa
	{
		total_matrah_yaz = ssk_matrah_;
		total_ikramiye_yaz = total_ikramiye;
		total_ikramiye_asil = total_ikramiye_asil;
	}			
	else if(total_kazanc lt ssk_matrah_)
	{
		total_matrah_yaz = total_kazanc;
		total_ikramiye_yaz = total_ikramiye;
		total_ikramiye_asil = total_ikramiye_asil;
	}
	//Kısmi çalışansa ve ücreti matrahın altında kalıyorsa.
	if(duty_type eq 6 and total_kazanc lt ssk_matrah_ and TOTAL_SALARY_temp lt ssk_matrah_)
	{
		total_matrah_yaz = ssk_matrah_;
		total_ikramiye_yaz = total_ikramiye;
		total_ikramiye_asil = total_ikramiye_asil;
	}
	
				
	if (len(TRADE_UNION_DEDUCTION) and (TRADE_UNION_DEDUCTION gt 0)) 
		kanun = "04369";
	else if(((DEFECTION_LEVEL gt 0 and IS_SAKAT_KONTROL eq 0 and SAKATLIK_INDIRIMI gt 0) or (not len(IS_SAKAT_KONTROL) AND IS_5510 eq 1)) and SSK_STATUTE neq 2 and IS_14857 eq 1)
		kanun = "14857";
	else if(IS_7252_CONTROL eq 1)//7252 KÇÖ Esma R. Uysal
		kanun = "07252";
	else if(IS_56486 gt 0)
		kanun = "56486";
	else if(IS_46486 gt 0)
		kanun = "46486";
	else if(IS_66486 gt 0)
		kanun = "66486";
	else if(SSK_ISVEREN_HISSESI_14857 gt 0 or IS_14857 eq 1)
		kanun = "14857";
	else if(SSK_ISVEREN_HISSESI_3294 gt 0 or listfindnocase(LAW_NUMBERS,'3294'))
		kanun = "03294";
	else if(SSK_ISVEREN_HISSESI_6645 gt 0)
		kanun = "06645";
	else if(SSK_ISVEREN_HISSESI_5921 gt 0)
		kanun = "05921";
	else if(SSK_ISVEREN_HISSESI_GOV_100 gt 0 AND DEFECTION_LEVEL eq 0 AND IS_5510 eq 1)
		kanun = "14447";
	else if(SSK_ISVEREN_HISSESI_GOV_80 gt 0 AND DEFECTION_LEVEL eq 0 AND IS_5510 eq 1)
		kanun = "84447";
	else if(SSK_ISVEREN_HISSESI_GOV_60 gt 0 AND DEFECTION_LEVEL eq 0 AND IS_5510 eq 1)
		kanun = "64447";
	else if(SSK_ISVEREN_HISSESI_GOV_40 gt 0 AND DEFECTION_LEVEL eq 0 AND IS_5510 eq 1)
		kanun = "44447";
	else if(SSK_ISVEREN_HISSESI_GOV_20 gt 0 AND DEFECTION_LEVEL eq 0 AND IS_5510 eq 1)
		kanun = "24447";
	else if(SSK_ISVEREN_HISSESI_6111 gt 0)
		kanun = "06111";
	else if(SSK_ISVEREN_HISSESI_6486 gt 0)
		kanun = "06486";
	else if(get_branch_employees.KANUN_6322 eq 1 and SSK_ISVEREN_HISSESI_6322 gt 0)
		kanun = "16322";
	else if(get_branch_employees.KANUN_6322 eq 2 and SSK_ISVEREN_HISSESI_6322 gt 0)
		kanun = "26322";
	else if(SSK_ISVEREN_HISSESI_6322 gt 0)
		kanun = "06322";
	else if(SSK_ISVEREN_HISSESI_687 gt 0)
		kanun = "00687";
	else if(BASE_AMOUNT_7256 gt 0 AND listfindnocase(LAW_NUMBERS,'17256'))
		kanun = "17256";
	else if(BASE_AMOUNT_7256 gt 0 AND listfindnocase(LAW_NUMBERS,'27256'))
		kanun = "27256";
	else if(listfindnocase(LAW_NUMBERS,'574680') or listfindnocase(LAW_NUMBERS,'574690') or listfindnocase(LAW_NUMBERS,'5746100') or listfindnocase(LAW_NUMBERS,'574695'))
	{
		kanun = "05746";
		eksik_neden = '';
		total_day_5746 = ssk_days_5746 - izin;
		eksik_gun_sayisi = aydaki_gun_sayisi - total_day_5746;
		if(eksik_gun_sayisi gt 0)
		{
			eksik_sayi = eksik_gun_sayisi;
			eksik_neden = 25;
		}
	}
	else if(SSK_DAYS_5746 gt 0)
	{
		kanun = "05746";
		total_days_ = ssk_days_5746;
		
		total_matrah_ilk = total_matrah_yaz;
		total_ikramiye_ilk = total_ikramiye_yaz;
		
		if(total_matrah_yaz eq max_payment_)
			total_matrah_yaz = (total_matrah_yaz - total_ikramiye_yaz-EXT_SALARY) * ssk_days_5746 / TOTAL_DAYS;
		else
			total_matrah_yaz = (total_matrah_yaz - total_ikramiye_yaz) * ssk_days_5746 / TOTAL_DAYS;
		total_ikramiye_yaz = total_ikramiye_yaz - SSK_MATRAH_RD_OUT_temp;
		
		

		//arge varsa total ikramiye her zaman 0 dır
		total_ikramiye_yaz = 0;
		

		if(total_ikramiye_yaz lt 0) 
			total_ikramiye_yaz = 0;	
		
			if (aydaki_gun_sayisi eq 31 and TOTAL_DAYS eq 30 and ssk_days_5746 neq 30)
				gun_hesap_ = aydaki_gun_sayisi;
			else if(aydaki_gun_sayisi eq 31 and TOTAL_DAYS eq 30 and ssk_days_5746 eq 30 and izin eq 1)
				gun_hesap_ = 30 - izin;
			else if(total_days gt aydaki_gun_sayisi)
				gun_hesap_ = aydaki_gun_sayisi;
			else
				gun_hesap_ = total_days;
			
			eksik_gun_sayisi = gun_hesap_ - ssk_days_5746 + izin;
			
			is_eksik_gun = eksik_gun_sayisi;
			
			if(eksik_gun_sayisi gt 0)
			{
				
				eksik_sayi = eksik_gun_sayisi;
				eksik_neden = 25;
				asgari_gecim = 0;
				gelir_vergisi_temp = 0;
				gelir_vergisi_matrah_temp = 0;
			}
			
			
			if(total_days gt ssk_days_5746 or SSK_MATRAH_RD_OUT_temp gt 0)
			{
				ext_varmi = 1;
				
				ext_matrah_ = ssk_matrah_ - total_matrah_yaz;
				
				if(total_ikramiye_asil gt total_ikramiye_yaz)
					ext_ikramiye = numberFormat(total_ikramiye_asil - total_ikramiye_yaz,'.00');//ext_ikramiye = total_ikramiye_asil - total_ikramiye_yaz;					
				if(numberFormat(total_matrah_yaz,'.00')+numberFormat(ext_matrah_,'.00') gt total_matrah_ilk)
				{
					diff_base = numberFormat(total_matrah_yaz,'.00')+numberFormat(ext_matrah_,'.00') - total_matrah_ilk;
					ext_ikramiye = ext_ikramiye - diff_base;
					ext_matrah_ = ext_matrah_ - diff_base;
				}
			
				ext_total_days = total_days - ssk_days_5746;
				ext_max_matrah = max_payment_ / 30 * ext_total_days;
				ext_eksik_sayi = gun_hesap_ - ext_total_days + izin;
				if(ext_max_matrah < ext_matrah_)
				{
					ext_total_days = total_days;
					total_days_ = 0;
					eksik_sayi = aydaki_gun_sayisi;
					ext_eksik_sayi = izin;
				}
				
				
				
				if(ext_eksik_sayi gt 0)
				{
					ext_eksik_neden = 25;
					if(declaration_type_id != '')
						ext_eksik_neden = 12;
				}
					
				ext_kanun_no = '05510';
			}
	}
	else if(LAW_NUMBER_7103 is '17103')
		kanun = "17103";
	else if(LAW_NUMBER_7103 is '27103')
		kanun = "27103";
	else if(LAW_NUMBER_7103 is '37103')
		kanun = "37103";
	else if((SSK_STATUTE eq 1 or SSK_STATUTE eq 6) and SUBE_IS_5510 eq 1 and len(SSK_ISVEREN_HISSESI_GOV) AND SSK_ISVEREN_HISSESI_GOV eq 0) 
		kanun = "05510";
	else
		kanun = "00000";
</cfscript>

<cfscript>
	if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 60) belge_turu = "29";
	else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 90) belge_turu = "32";
	else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 180) belge_turu = "35";
	else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1) belge_turu = "03";
	else if(SSK_STATUTE eq 32) belge_turu = "32";
	else if (SSK_STATUTE eq 1) belge_turu = "01";
	else if (SSK_STATUTE eq 2) belge_turu = "02";
	else if (SSK_STATUTE eq 3) belge_turu = "22";
	else if (SSK_STATUTE eq 75) belge_turu = "07";
	else if (SSK_STATUTE eq 4) belge_turu = "07";
	else if (SSK_STATUTE eq 5) belge_turu = "10";
	else if (SSK_STATUTE eq 6) belge_turu = "15";
	else if (SSK_STATUTE eq 71) belge_turu = "15";
	else if (SSK_STATUTE eq 12) belge_turu = "13";
	else if (SSK_STATUTE eq 15) belge_turu = "52";
	else if (SSK_STATUTE eq 8) belge_turu = "04";//yeraltı sürekli
	else if (SSK_STATUTE eq 9) belge_turu = "05";//yeraltı gruplu
	else if (SSK_STATUTE eq 10) belge_turu = "06";//yerüstü gruplu
	else belge_turu = "01";
</cfscript>
<cfsavecontent variable="is_tax_info"><cfif IS_TAX_FREE eq 1>1<cfelse>2</cfif></cfsavecontent>
<cfsavecontent variable="explanation_info"><cfif (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu))>#ListGetAt(law_list(),explanation_id,",")#</cfif></cfsavecontent>
<cfsavecontent variable="eksik_neden_info"><cfif len(eksik_neden) and len(eksik_sayi) and eksik_sayi gt 0>#eksik_neden#</cfif></cfsavecontent>
<cfsavecontent variable="eksik_sayi_info"><cfif len(eksik_sayi) and eksik_sayi gt 0 and len(eksik_neden)>#eksik_sayi#</cfif></cfsavecontent>
<cfsavecontent variable="start_date_info"><cfif (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0))>#dateformat(start_date,"dd")#</cfif></cfsavecontent>
<cfsavecontent variable="start_date_m_info"><cfif (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0))>#dateformat(start_date,"mm")#</cfif></cfsavecontent>
<cfsavecontent variable="FINISH_DATE_info"><cfif (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu))>#dateformat(FINISH_DATE,"dd")#</cfif></cfsavecontent>
<cfsavecontent variable="FINISH_DATE_m_info"><cfif (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu))>#dateformat(FINISH_DATE,"mm")#</cfif></cfsavecontent>
<cfsavecontent variable="sgk_agent_info"><cfif len(SSK_AGENT)>#SSK_AGENT#<cfelse>000</cfif></cfsavecontent>
<cfsavecontent variable="defection_info"><cfif len(DEFECTION_RATE) and len(DEFECTION_LEVEL) and DEFECTION_LEVEL gt 0 and SAKATLIK_INDIRIMI gt 0>#DEFECTION_RATE#<cfelse></cfif></cfsavecontent>

<cfif isdefined("x_rest_day") and x_rest_day eq 0>
	<cfif ListFindNoCase(declaration_types,1) and ext_varmi eq 0>
		<cfsavecontent variable="istirahatta_calistimi">2</cfsavecontent>
	<cfelse>
		<cfsavecontent variable="istirahatta_calistimi">0</cfsavecontent>
	</cfif>
<cfelse>
	<cfif ListFindNoCase(declaration_types,1) and ext_varmi eq 0>
		<cfsavecontent variable="istirahatta_calistimi">Evet</cfsavecontent>
	<cfelse>
		<cfsavecontent variable="istirahatta_calistimi">Hayır</cfsavecontent>
	</cfif>
</cfif>
<cfif get_branch_employees.recordcount neq currentrow or ext_varmi eq 1>
	<cfset CRLF_ = Chr(13) & Chr(10)>
<cfelse>
	<cfset CRLF_ = ''> 
</cfif>
<cfset kisi_yazilan_matrah = 0>
<cfset kisi_yazilan_matrah = kisi_yazilan_matrah + total_matrah_yaz>
<cfset row_list = "#row_list##attributes.EXPORT_REASON#;#belge_turu#;#kanun#;#SSK_BRANCH#;#SSK_BRANCH_OLD#;#SSK_NO#;#SSK_CITY#;#sgk_agent_info#;#SOCIALSECURITY_NO#;#TC_IDENTY_NO#;#EMPLOYEE_NAME#;#EMPLOYEE_SURNAME#;#total_days_#;#evaluate("get_branch_employees.M#attributes.sal_mon#")#;#para_format(total_matrah_yaz-total_ikramiye_yaz)#;#para_format(total_ikramiye_yaz)#;#start_date_info#;#start_date_m_info#;#FINISH_DATE_info#;#FINISH_DATE_m_info#;#trim(explanation_info)#;#eksik_sayi_info#;#eksik_neden_info#;#BUSINESS_CODE#;#istirahatta_calistimi#;#attributes.export_type#;#numberformat(attributes.sal_mon,'00')#;#attributes.sal_year#;#is_tax_info#">

<cfif attributes.sal_year lte 2021>
	<cfset row_list = "#row_list#;#para_format(asgari_gecim)#">
</cfif>

<cfset row_list = "#row_list#;#para_format(gelir_vergisi_matrah_temp)#;#defection_info#">

<cfif attributes.sal_year gte 2022>
	<cfset row_list = "#row_list#;#para_format(gelir_vergisi_hesaplanan)#;#para_format(income_tax_temp)#">
</cfif>

<cfset row_list = "#row_list#;#para_format(gelir_vergisi_temp + asgari_gecim)#"><!--- gelir vergisi --->

<cfif attributes.sal_year gte 2022>
	<cfset row_list = "#row_list#;#para_format(stamp_tax_temp)#;#para_format(damga_vergisi_)#">
</cfif>

<cfset row_list = "#row_list##CRLF_#">
<cfset rowCount = rowCount + 1>
<cfif ext_varmi eq 1>
	<cfscript>
		if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 60) belge_turu = "29";
		else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 90) belge_turu = "32";
		else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 180) belge_turu = "35";
		else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1) belge_turu = "03";
		else if(SSK_STATUTE eq 32) belge_turu = "32";
		else if (SSK_STATUTE eq 1) belge_turu = "01";
		else if (SSK_STATUTE eq 2) belge_turu = "02";
		else if (SSK_STATUTE eq 3) belge_turu = "22";
		else if (SSK_STATUTE eq 75) belge_turu = "07";
		else if (SSK_STATUTE eq 4) belge_turu = "07";
		else if (SSK_STATUTE eq 5) belge_turu = "10";
		else if (SSK_STATUTE eq 6) belge_turu = "15";
		else if (SSK_STATUTE eq 71) belge_turu = "15";
		else if (SSK_STATUTE eq 12) belge_turu = "13";
		else if (SSK_STATUTE eq 15) belge_turu = "52";
		else if (SSK_STATUTE eq 8) belge_turu = "04";//yeraltı sürekli
		else if (SSK_STATUTE eq 9) belge_turu = "05";//yeraltı gruplu
		else if (SSK_STATUTE eq 10) belge_turu = "06";//yerüstü gruplu
		else belge_turu = "01";
		asgari_gecim = VERGI_IADESI;
	</cfscript>
	<cfset gelir_vergisi_matrah_temp = gelir_vergisi_matrah>
	<cfset gelir_vergisi_temp = gelir_vergisi>
	<cfsavecontent variable="explanation_info"><cfif (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu))>#ListGetAt(law_list(),explanation_id,",")#</cfif></cfsavecontent>
	<cfsavecontent variable="sgk_agent_info"><cfif len(SSK_AGENT)>#SSK_AGENT#<cfelse>000</cfif></cfsavecontent>
	<cfsavecontent variable="start_date_info"><cfif (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0))>#dateformat(start_date,"dd")#</cfif></cfsavecontent>
	<cfsavecontent variable="start_date_m_info"><cfif (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0))>#dateformat(start_date,"mm")#</cfif></cfsavecontent>
	<cfsavecontent variable="FINISH_DATE_info"><cfif (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu))>#dateformat(FINISH_DATE,"dd")#</cfif></cfsavecontent>
	<cfsavecontent variable="FINISH_DATE_m_info"><cfif (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu))>#dateformat(FINISH_DATE,"mm")#</cfif></cfsavecontent>
	<cfsavecontent variable="ext_eksik_sayi_info"><cfif len(ext_eksik_sayi) and ext_eksik_sayi gt 0>#ext_eksik_sayi#</cfif></cfsavecontent>	
	<cfsavecontent variable="eksik_neden_info"><cfif len(eksik_neden) and ext_eksik_sayi gt 0>#ext_eksik_neden#</cfif></cfsavecontent>	
	<cfsavecontent variable="is_tax_info"><cfif IS_TAX_FREE eq 1>1<cfelse>2</cfif></cfsavecontent>
	<cfsavecontent variable="defection_info"><cfif len(DEFECTION_RATE) and len(DEFECTION_LEVEL) and DEFECTION_LEVEL gt 0 and SAKATLIK_INDIRIMI gt 0>#DEFECTION_RATE#<cfelse></cfif></cfsavecontent>
	
	
	<cfif isdefined("x_rest_day") and x_rest_day eq 0>
		<cfif ListFindNoCase(declaration_types,1) and ext_varmi eq 1>
			<cfsavecontent variable="istirahatta_calistimi">2</cfsavecontent>
		<cfelse>
			<cfsavecontent variable="istirahatta_calistimi">0</cfsavecontent>
		</cfif>
	<cfelse>
		<cfif ListFindNoCase(declaration_types,1) and ext_varmi eq 1>
			<cfsavecontent variable="istirahatta_calistimi">Evet</cfsavecontent>
		<cfelse>
			<cfsavecontent variable="istirahatta_calistimi">Hayır</cfsavecontent>
		</cfif>
	</cfif>
	<cfset kisi_yazilan_matrah = wrk_round(kisi_yazilan_matrah)>
	<cfset ext_matrah_ = wrk_round(ext_matrah_)>
	<cfset ext_ikramiye = wrk_round(ext_ikramiye)>
	<cfset kisi_yazilan_matrah = wrk_round(kisi_yazilan_matrah + (ext_matrah_ - ext_ikramiye) + ext_ikramiye)>
	<cfif ssk_matrah_ lt kisi_yazilan_matrah>
		<cfset matrah_fark_ = wrk_round(kisi_yazilan_matrah - ssk_matrah_)>
		<cfset ext_matrah_ = ext_matrah_ - matrah_fark_>
	</cfif>
	<cfset row_list = "#row_list##attributes.EXPORT_REASON#;#belge_turu#;#ext_kanun_no#;#SSK_BRANCH#;#SSK_BRANCH_OLD#;#SSK_NO#;#SSK_CITY#;#sgk_agent_info#;#SOCIALSECURITY_NO#;#TC_IDENTY_NO#;#EMPLOYEE_NAME#;#EMPLOYEE_SURNAME#;#ext_total_days#;#evaluate("get_branch_employees.M#attributes.sal_mon#")#;#para_format(ext_matrah_-ext_ikramiye)#;#para_format(ext_ikramiye)#;#start_date_info#;#start_date_m_info#;#FINISH_DATE_info#;#FINISH_DATE_m_info#;#trim(explanation_info)#;#ext_eksik_sayi_info#;#eksik_neden_info#;#BUSINESS_CODE#;#istirahatta_calistimi#;#attributes.export_type#;#numberformat(attributes.sal_mon,'00')#;#attributes.sal_year#;#is_tax_info#">
	<cfif attributes.sal_year lte 2021>
		<cfset row_list = "#row_list#;#para_format(asgari_gecim)#">
	</cfif>
	<cfset row_list = "#row_list#;#para_format(gelir_vergisi_matrah_temp)#;#defection_info#">

	<cfif attributes.sal_year gte 2022>
		<cfset row_list = "#row_list#;#para_format(gelir_vergisi_hesaplanan)#;#para_format(income_tax_temp)#">
	</cfif>	

	<cfset row_list = "#row_list#;#para_format(gelir_vergisi_temp + asgari_gecim)#"><!--- gelir vergisi --->

	<cfif attributes.sal_year gte 2022>
		<cfset row_list = "#row_list#;#para_format(stamp_tax_temp)#;#para_format(damga_vergisi_)#">
	</cfif>

	<cfset row_list = "#row_list##CRLF_#">
	<cfset rowCount = rowCount + 1>	
</cfif>
</cfoutput>


<cfset header_list_7103 = "#getlang('','İL KODU',53827)#;#getlang('','YENİ ÜNİTE KODU',914)# (2);#getlang('','ESKİ ÜNİTE KODU',915)#(2);#getlang('','İŞYERİ SIRA NO',44618)#(7);#getlang('','ARACI KURUM KODU',940)# (3);#getlang('','VERGİ DAİRESİNDE KAYITLI İŞYERİ/ ŞUBE KODU',941)#;#getlang('','SİGORTALININ ADI SOYADI',942)#;#getlang('','T.C.KİMLİK NUMARASI',943)#;#getlang('','ÜCRETİN AİT OLDUĞU AY',944)#;#getlang('','İŞE BAŞLAMA TARİHİ',53817)#;#getlang('','ÇALIŞILAN GÜN SAYISI',945)#;#getlang('','BRÜT ÜCRET TUTARI',946)#;#getlang('','GELİR VERGİSİ MATRAHI',53249)#;#getlang('','HESAPLANAN GELİR VERGİSİ',947)#;#getlang('','ASGARİ ÜCRET ÜZERİNDEN HESAPLANAN GELİR VERGİSİ (ÇALIŞMA GÜN SAYISINA İSABET EDEN TUTAR)',948)#">
<cfif attributes.sal_year lte 2021>
	<cfset header_list_7103 ="#header_list_7103#;#getlang('','HESAPLANAN ASGARİ GEÇİM İNDİRİMİ',949)#">
</cfif>
<cfset header_list_7103 ="#header_list_7103#;#getlang('','TERKİN EDİLEBİLECEK TUTAR  Q-R',950)#">

<cfset h_type_list_7103 = "nvarchar;nvarchar;nvarchar;nvarchar;nvarchar;nvarchar;nvarchar;nvarchar;integer;nvarchar;integer;float;float;float;float">
<cfif attributes.sal_year lte 2021>
	<cfset h_type_list_7103 ="#h_type_list_7103#;float">
</cfif>
<cfset h_type_list_7103 ="#h_type_list_7103#;float">
<cfquery name="get_7103" dbtype="query">
	SELECT * FROM get_branch_employees WHERE LAW_NUMBER_7103 = 17103 OR LAW_NUMBER_7103 = 27103 OR LAW_NUMBER_7103 = 37103
</cfquery>
<cfset rowCount_7103 = 0>
<cfset row_list_7103 = "">
<cfoutput query="get_7103">
<cfscript>
	ext_matrah_ = '';
	ext_ikramiye = '';
	ext_total_days = '';
	ext_eksik_sayi = '';
	ext_eksik_neden = '';
	ext_kanun_no = '';
	ext_varmi = 0;
	
	eksik_neden = '';
	eksik_sayi = '';

	SSK_ISVEREN_HISSESI_temp = SSK_ISVEREN_HISSESI;
	SSK_MATRAH_RD_OUT_temp = SSK_MATRAH_RD_OUT;
	SSK_MATRAH_temp = SSK_MATRAH;
	SSK_ISVEREN_HISSESI_5746_temp = SSK_ISVEREN_HISSESI_5746;
	
	ssk_matrah_ = SSK_MATRAH_temp;
	
	
	TOTAL_SALARY_temp = TOTAL_SALARY;
	IHBAR_AMOUNT_temp = IHBAR_AMOUNT;
	KIDEM_AMOUNT_temp = KIDEM_AMOUNT;
	TOTAL_PAY_TAX_temp = TOTAL_PAY_TAX;
	TOTAL_PAY_SSK_TAX_temp = TOTAL_PAY_SSK_TAX;
	TOTAL_PAY_SSK_temp = TOTAL_PAY_SSK;
	
	if(not len(SSK_MATRAH_RD_OUT_temp))
		SSK_MATRAH_RD_OUT_temp = 0;

	total_days_ = total_days;


	total_matrah_yaz = SSK_MATRAH_temp;
	total_kazanc = TOTAL_SALARY_temp - (SSK_DEVIR + SSK_DEVIR_LAST + TOTAL_PAY_TAX_temp + KIDEM_AMOUNT_temp + IHBAR_AMOUNT_temp + SSK_MATRAH_RD_OUT_temp);

	total_ikramiye = TOTAL_PAY_SSK_TAX_temp + TOTAL_PAY_SSK_temp + SSK_DEVIR + SSK_DEVIR_LAST - SSK_MATRAH_RD_OUT_temp;
	total_ikramiye_asil = TOTAL_PAY_SSK_TAX_temp + TOTAL_PAY_SSK_temp + SSK_DEVIR + SSK_DEVIR_LAST;
	total_ucret = total_kazanc - total_ikramiye;
	
	
	if(total_ucret gte ssk_matrah_)
		{
		total_matrah_yaz = ssk_matrah_;
		total_ikramiye_yaz = 0;
		total_ikramiye_asil = 0; 
		}
	else if(total_kazanc gte ssk_matrah_)
		{
		total_matrah_yaz = ssk_matrah_;
		total_ikramiye_yaz = ssk_matrah_ - total_ucret;
		total_ikramiye_asil = ssk_matrah_ - total_ucret;
		}				
	else if(total_kazanc lt ssk_matrah_)
		{
		total_matrah_yaz = total_kazanc;
		total_ikramiye_yaz = total_ikramiye;
		total_ikramiye_asil = total_ikramiye_asil;
		}
	
	if(total_days eq 0 and izin eq 30 and aydaki_gun_sayisi eq 31)
	{
		if(aydaki_gun_sayisi eq 31 and TOTAL_DAYS eq 30)
			{
				eksik_gun_sayisi = 0;
			}
		else
			{
				eksik_gun_sayisi = 31;
			}
	}
	else
	{
		if(aydaki_gun_sayisi eq 31 and TOTAL_DAYS eq 30)
		{
			eksik_gun_sayisi = 0;
		}
		else
		{
			eksik_gun_sayisi = IZIN;
		}
	}
	
	eksik_sayi =  eksik_gun_sayisi;
				
	if (len(TRADE_UNION_DEDUCTION) and (TRADE_UNION_DEDUCTION gt 0)) 
		kanun = "04369";
	else if(((DEFECTION_LEVEL gt 0 and IS_SAKAT_KONTROL eq 0 and SAKATLIK_INDIRIMI gt 0) or (not len(IS_SAKAT_KONTROL) AND IS_5510 eq 1)) and SSK_STATUTE neq 2 and IS_14857 eq 1)
		kanun = "14857";
	else if(SSK_ISVEREN_HISSESI_5921 gt 0)
		kanun = "05921";
	else if(SSK_ISVEREN_HISSESI_6645 gt 0)
		kanun = "06645";
	else if(SSK_ISVEREN_HISSESI_GOV_100 gt 0 AND DEFECTION_LEVEL eq 0 AND IS_5510 eq 1)
		kanun = "14447";
	else if(SSK_ISVEREN_HISSESI_GOV_80 gt 0 AND DEFECTION_LEVEL eq 0 AND IS_5510 eq 1)
		kanun = "84447";
	else if(SSK_ISVEREN_HISSESI_GOV_60 gt 0 AND DEFECTION_LEVEL eq 0 AND IS_5510 eq 1)
		kanun = "64447";
	else if(SSK_ISVEREN_HISSESI_GOV_40 gt 0 AND DEFECTION_LEVEL eq 0 AND IS_5510 eq 1)
		kanun = "44447";
	else if(SSK_ISVEREN_HISSESI_GOV_20 gt 0 AND DEFECTION_LEVEL eq 0 AND IS_5510 eq 1)
		kanun = "24447";
	else if(SSK_ISVEREN_HISSESI_6111 gt 0)
		kanun = "06111";
	else if(SSK_ISVEREN_HISSESI_6486 gt 0)
		kanun = "06486";
	else if(get_branch_employees.KANUN_6322 eq 1 and SSK_ISVEREN_HISSESI_6322 gt 0)
		kanun = "16322";
	else if(get_branch_employees.KANUN_6322 eq 2 and SSK_ISVEREN_HISSESI_6322 gt 0)
		kanun = "26322";
	else if(SSK_ISVEREN_HISSESI_6322 gt 0)
		kanun = "06322";
	else if(SSK_ISVEREN_HISSESI_687 gt 0)
		kanun = "00687";
	else if(listfindnocase(LAW_NUMBERS,'574680') or listfindnocase(LAW_NUMBERS,'574690') or listfindnocase(LAW_NUMBERS,'5746100') or listfindnocase(LAW_NUMBERS,'574695'))
	{
		kanun = "05746";
		eksik_neden = '';
	}
	else if(SSK_DAYS_5746 gt 0)
		{
		kanun = "05746";
		total_days_ = ssk_days_5746;
		
		total_matrah_ilk = total_matrah_yaz;
		total_ikramiye_ilk = total_ikramiye_yaz;
		
		total_matrah_yaz = total_matrah_yaz * ssk_days_5746 / TOTAL_DAYS;
		total_ikramiye_yaz = total_ikramiye_yaz - SSK_MATRAH_RD_OUT_temp;
		
		if(total_ikramiye_yaz lt 0) 
			total_ikramiye_yaz = 0;	
		
			if(total_days gt aydaki_gun_sayisi)
				gun_hesap_ = aydaki_gun_sayisi;
			else
				gun_hesap_ = total_days;
				
			eksik_gun_sayisi = gun_hesap_ - ssk_days_5746 + izin;
			is_eksik_gun = eksik_gun_sayisi;
			
			if(eksik_gun_sayisi gt 0)
			{
				eksik_neden = 13;
				eksik_sayi = eksik_gun_sayisi;
			}
			
			
			if(total_days gt ssk_days_5746 or SSK_MATRAH_RD_OUT_temp gt 0)
			{
				ext_varmi = 1;
				
				ext_matrah_ = ssk_matrah_ - total_matrah_yaz;
					
				if(total_ikramiye_asil gt total_ikramiye_yaz)
					ext_ikramiye = total_ikramiye_asil - total_ikramiye_yaz;						
				
				ext_total_days = total_days - ssk_days_5746;
				
				ext_eksik_sayi = ssk_days_5746;
				
				if(ext_eksik_sayi gt 0)
					ext_eksik_neden = '13';
					
				ext_kanun_no = '05510';
			}			
		}
	else if(LAW_NUMBER_7103 is '17103')
		kanun = "17103";
	else if(LAW_NUMBER_7103 is '27103')
		kanun = "27103";
	else if(LAW_NUMBER_7103 is '37103')
		kanun = "37103";
	else if((SSK_STATUTE eq 1 or SSK_STATUTE eq 6) and SUBE_IS_5510 eq 1 and len(SSK_ISVEREN_HISSESI_GOV) AND SSK_ISVEREN_HISSESI_GOV eq 0) 
		kanun = "05510";
	else
		kanun = "00000";
</cfscript>

<cfscript>
	if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 60) belge_turu = "29";
	else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 90) belge_turu = "32";
	else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 180) belge_turu = "35";
	else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1) belge_turu = "03";
	else if(SSK_STATUTE eq 32) belge_turu = "32";
	else if (SSK_STATUTE eq 1) belge_turu = "01";
	else if (SSK_STATUTE eq 2) belge_turu = "02";
	else if (SSK_STATUTE eq 3) belge_turu = "22";
	else if (SSK_STATUTE eq 75) belge_turu = "07";
	else if (SSK_STATUTE eq 4) belge_turu = "07";
	else if (SSK_STATUTE eq 5) belge_turu = "10";
	else if (SSK_STATUTE eq 6) belge_turu = "15";
	else if (SSK_STATUTE eq 71) belge_turu = "15";
	else if (SSK_STATUTE eq 12) belge_turu = "13";
	else if (SSK_STATUTE eq 15) belge_turu = "52";
	else belge_turu = "01";
</cfscript>
<cfset gelir_vergisi_temp = gelir_vergisi>
<cfset gelir_vergisi_matrah_temp = gelir_vergisi_matrah>
<cfsavecontent variable="is_tax_info"><cfif IS_TAX_FREE eq 1>1<cfelse>2</cfif></cfsavecontent>
<cfsavecontent variable="explanation_info"><cfif (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu))>#ListGetAt(law_list(),explanation_id,",")#</cfif></cfsavecontent>
<cfsavecontent variable="eksik_neden_info"><cfif len(eksik_neden)>#eksik_neden#</cfif></cfsavecontent>
<cfsavecontent variable="eksik_sayi_info"><cfif len(eksik_sayi) and eksik_sayi gt 0>#eksik_sayi#</cfif></cfsavecontent>
<cfsavecontent variable="start_date_info"><cfif (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0))>#dateformat(start_date,"dd")#</cfif></cfsavecontent>
<cfsavecontent variable="start_date_m_info"><cfif (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0))>#dateformat(start_date,"mm")#</cfif></cfsavecontent>
<cfsavecontent variable="FINISH_DATE_info"><cfif (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu))>#dateformat(FINISH_DATE,"dd")#</cfif></cfsavecontent>
<cfsavecontent variable="FINISH_DATE_m_info"><cfif (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu))>#dateformat(FINISH_DATE,"mm")#</cfif></cfsavecontent>
<cfsavecontent variable="sgk_agent_info"><cfif len(SSK_AGENT)>#SSK_AGENT#<cfelse>000</cfif></cfsavecontent>
<cfsavecontent variable="defection_info"><cfif len(DEFECTION_RATE) and len(DEFECTION_LEVEL) and DEFECTION_LEVEL gt 0 and SAKATLIK_INDIRIMI gt 0>#DEFECTION_RATE#<cfelse></cfif></cfsavecontent>
<cfsavecontent variable="isyerino_info"></cfsavecontent>
<cfif get_7103.recordcount neq currentrow>
	<cfset CRLF_ = Chr(13) & Chr(10)>
<cfelse>
	<cfset CRLF_ = ''> 
</cfif>
<cfset row_list_7103 = "#row_list_7103##SSK_CITY#;#SSK_BRANCH#;#SSK_BRANCH_OLD#;#SSK_NO#;#sgk_agent_info#;#isyerino_info#;#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#;#TC_IDENTY_NO#;#ucasetr(listgetat(ay_list(),attributes.sal_mon))#;#dateformat(start_date,'dd/mm/yyyy')#;#total_days_#;#para_format(total_matrah_yaz)#;#para_format(gelir_vergisi_matrah)#;#para_format(gelir_vergisi + asgari_gecim_indirimi)#;#para_format(ilgili_ay_asgari_gv * total_days_ / 30)#">
<cfif attributes.sal_year lte 2021>
	<cfset row_list_7103 = "#row_list_7103#;#para_format(asgari_gecim_indirimi)#">
</cfif>
<cfset row_list_7103 = "#row_list_7103#;#para_format(GELIR_VERGISI_INDIRIMI_7103)##CRLF#">

<cfset rowCount_7103 = rowCount_7103 + 1>
</cfoutput>

<!--- Arge --->
<cfquery name="get_5746" dbtype="query">
	SELECT 
		* 
	FROM 
		get_branch_employees 
	WHERE 
		(
			LAW_NUMBERS LIKE 'ARGE%'
			AND
			(SSK_DAYS_5746 > 0 OR TAX_DAYS_5746 > 0) OR LAW_NUMBERS LIKE '5746%'
		)
</cfquery>
<cfset rowCount_5746 = get_5746.recordCount>
<cfset row_list_5746 = "">
<cfset header_list_5746 = "#UCase(getlang('','Adı Soyadı',55757))#;#UCase(getlang('','TC Kimlik No',58025))#;#UCase(getlang('','İşe Başlama Tarihi',55154))#;#UCase(getlang('','Brüt Kazançlar Toplamı',60251))#;#UCase(getlang('','ARGE Ücret Matrahı',60252))#;;#UCase(getlang('','arge',59684))# #UCase(getlang('','vergi',59181))#;#UCase(getlang('','Terkin Oranı',60254))#;#UCase(getlang('','Terkin Edilecek Tutar',60255))##CRLF#">
<cfset h_type_list_5746 = "nvarchar;nvarchar;nvarchar;nvarchar;float;float;float;integer;float">
<cfoutput query="get_5746">
	<cfscript>
		cmp_rd_employees = createObject("component","V16.report.cfc.rd_employees");

        get_active_tax_slice = cmp_rd_employees.get_active_tax_slice(sal_year : attributes.sal_year);
        s1 = get_active_tax_slice.MAX_PAYMENT_1;	v1 = get_active_tax_slice.RATIO_1;
        s2 = get_active_tax_slice.MAX_PAYMENT_2;	v2 = get_active_tax_slice.RATIO_2;
        s3 = get_active_tax_slice.MAX_PAYMENT_3;	v3 = get_active_tax_slice.RATIO_3;
        s4 = get_active_tax_slice.MAX_PAYMENT_4;	v4 = get_active_tax_slice.RATIO_4;
        s5 = get_active_tax_slice.MAX_PAYMENT_5;	v5 = get_active_tax_slice.RATIO_5;
        s6 = get_active_tax_slice.MAX_PAYMENT_6;	v6 = get_active_tax_slice.RATIO_6;
		//total brüt kazanç
		toplam_kazanc = TOTAL_SALARY -VERGI_ISTISNA_SSK-VERGI_ISTISNA_VERGI;
		if(len(VERGI_ISTISNA_AMOUNT))
			toplam_kazanc = toplam_kazanc + VERGI_ISTISNA_AMOUNT;

		toplam_kazanc = toplam_kazanc / ssk_days * TAX_DAYS_5746;
		asgari_damga = (stamp_tax_temp * 1000 / 7.59) / ssk_days * TAX_DAYS_5746;
		brut_kazanc_5746 = DVM_MATRAH_5746 + asgari_damga;

		//Vergi Dilimi Hesaplaması
		if (isdefined("GELIR_VERGISI_MATRAH") and isnumeric(GELIR_VERGISI_MATRAH))
			t_kum_gelir_vergisi_matrahi = GELIR_VERGISI_MATRAH;
		else
			t_kum_gelir_vergisi_matrahi = 0;
			
		tax_ratio_ = '';
		all_ = t_kum_gelir_vergisi_matrahi;
		if (all_ lte s1)
		{
			tax_ratio_ = v1;
		}
		else if (all_ lte s2)
		{	
			tax_ratio_ = v2;
		}
		else if (all_ lte s3)
		{	
			tax_ratio_ = v3;
		}
		else if (all_ lte s4)
		{
				tax_ratio_ = v4;
		}
		else if (all_ lte s5)
		{
				tax_ratio_ = v5;
		}
		
		arge_vergi_tutarı = gelir_vergisi_matrah_5746 * 100 / tax_ratio_;
		arge_tax = gelir_vergisi_matrah_5746 + vergi_iadesi;

		// 5746 Oran
		if(len(law_numbers) and (listfindnocase(law_numbers,'ARGE80') OR listfindnocase(law_numbers,'574680')))
			arge_rate = 80;
		else if(len(law_numbers) and (listfindnocase(law_numbers,'ARGE90') OR listfindnocase(law_numbers,'574690')))
			arge_rate = 90; 
		else if (len(law_numbers) and (listfindnocase(law_numbers,'ARGE95') OR listfindnocase(law_numbers,'574695')))
			arge_rate = 95; 
		else if(len(law_numbers) and (listfindnocase(law_numbers,'ARGE100') OR listfindnocase(law_numbers,'5746100')))
			arge_rate = 100; 
		//Arge İndirimi = terkin edilen tutar
		arge_indirimi = gelir_vergisi_indirimi_5746+gelir_vergisi_indirimi_4691;
		if(arge_indirimi lt 0)
			arge_indirimi = 0;
			
	</cfscript>
	

	<cfset row_list_5746 = "#row_list_5746##EMPLOYEE_NAME# #EMPLOYEE_SURNAME#;#TC_IDENTY_NO#;#dateFormat(start_date,dateformat_style)#;#para_format(brut_kazanc_5746)#;#para_format(arge_vergi_tutarı)#;#para_format(arge_tax)#;#arge_rate#;#para_format(arge_indirimi)##CRLF#">
</cfoutput>


<cfif attributes.sal_year gt 2021>
	<cfset isnot_ssk_count = 0>
	<cfset isnot_ssk_count_2 = 0>

	<cfset gelir_vergisi_matrah_1 = 0>
	<cfset gelir_vergisi_matrah_2 = 0>

	<cfset income_tax_temp_1 = 0>
	<cfset income_tax_temp_2 = 0>

	<cfset gelir_vergisi_1 = 0>
	<cfset gelir_vergisi_2 = 0>

	<cfset stamp_tax_temp_1 = 0>
	<cfset stamp_tax_temp_2 = 0>

	<cfset damga_vergisi_1 = 0>
	<cfset damga_vergisi_2 = 0>

	<cfquery name="get_daily_minimum_wage"  dbtype="query">
		SELECT 
			*
		FROM 
			get_branch_employees 
		WHERE 
			IS_DAILY_MIN_WAGE = 1
	</cfquery>
	<cfoutput query = "get_daily_minimum_wage">

		<cfif use_ssk eq 3 and duty_type eq 2>
			<cfset isnot_ssk_count++> 
		</cfif>
		<!--- <cfset gelir_vergisi_matrah_1 += gelir_vergisi_matrah>  --->
		<cfset income_tax_temp_1 += income_tax_temp>
		<cfset gelir_vergisi_1 += gelir_vergisi>
		<cfset stamp_tax_temp_1 += stamp_tax_temp>
		<cfset damga_vergisi_1 = damga_vergisi_1 + damga_vergisi - DAMGA_VERGISI_INDIRIMI_687 - DAMGA_VERGISI_INDIRIMI_7103>

	</cfoutput>

	<cfset gelir_vergisi_matrah_1 = ilgili_ay_asgari_ucret_net * (get_daily_minimum_wage.recordCount - ListValueCount(valueList(get_daily_minimum_wage.IS_TAX_FREE),true))>

	<cfquery name="get_not_daily_minimum_wage"  dbtype="query">
		SELECT 
			*
		FROM 
			get_branch_employees 
		WHERE 
			IS_DAILY_MIN_WAGE = 0
	</cfquery>
	<cfoutput query = "get_not_daily_minimum_wage">

		<cfif use_ssk eq 3 and duty_type eq 2>
			<cfset isnot_ssk_count_2++> 
		</cfif>
		<cfset gelir_vergisi_matrah_2 += gelir_vergisi_matrah>
		<cfset income_tax_temp_2 += income_tax_temp>
		<cfset gelir_vergisi_2 += gelir_vergisi>
		<cfset stamp_tax_temp_2 += stamp_tax_temp>
		<cfset damga_vergisi_2 = damga_vergisi_2 + damga_vergisi - DAMGA_VERGISI_INDIRIMI_687 - DAMGA_VERGISI_INDIRIMI_7103>

	</cfoutput>


    <cfset row_list_total ="#attributes.sal_mon#. #getlang('','Ay Asgari Ücretli',65207)#;#get_daily_minimum_wage.recordCount#;#ListValueCount(valueList(get_daily_minimum_wage.IS_TAX_FREE),true)#;#isnot_ssk_count#;#para_format(gelir_vergisi_matrah_1)#;#para_format(income_tax_temp_1)#;#para_format(gelir_vergisi_1)#;#para_format(stamp_tax_temp_1)#;#para_format(damga_vergisi_1)##Chr(13) & Chr(10)#">
	<cfset row_list_total ="#row_list_total##attributes.sal_mon#. #getlang('','Ay Diğer Ücretli',65208)#;#get_not_daily_minimum_wage.recordCount#;#ListValueCount(valueList(get_not_daily_minimum_wage.IS_TAX_FREE),true)#;#isnot_ssk_count_2#;#para_format(gelir_vergisi_matrah_2)#;#para_format(income_tax_temp_2)#;#para_format(gelir_vergisi_2)#;#para_format(stamp_tax_temp_2)#;#para_format(damga_vergisi_2)#">
</cfif>
	<cfif attributes.fuseaction neq 'report.muhtasar_beyanname' >
		<cfif not directoryexists("#download_folder#/documents/hr/emuhtasar")>
			<cfdirectory action="create" directory="#download_folder#/documents/hr/emuhtasar">
		</cfif>
		<cffile action="write" 
			file="#download_folder#documents#dir_seperator#hr#dir_seperator#emuhtasar#dir_seperator##file_name#.csv" 
			nameconflict="overwrite" 
			charset="windows-1254"
			output="#header_list##row_list#">
			
		<cffile action="write" 
			file="#download_folder#documents#dir_seperator#hr#dir_seperator#emuhtasar#dir_seperator##file_name#.txt" 
			nameconflict="overwrite"
			charset="windows-1254"
			output="#replace(row_list,';','#TAB_CHR#','all')#">
		
		<cffile action="write" 
			file="#download_folder#documents#dir_seperator#hr#dir_seperator#emuhtasar#dir_seperator##file_name#_total.txt" 
			nameconflict="overwrite"
			charset="windows-1254"
			output="#replace(row_list_total,';','#TAB_CHR#','all')#">

		<cffile action="write" 
			file="#download_folder#documents#dir_seperator#hr#dir_seperator#emuhtasar#dir_seperator##file_name#.xls" 
			nameconflict="overwrite"
			charset="windows-1254"
			output="#replace(header_list,';','#TAB_CHR#','all')##replace(row_list,';','#TAB_CHR#','all')#">
			
		<cffile action="write" 
			file="#download_folder#documents#dir_seperator#hr#dir_seperator#emuhtasar#dir_seperator##file_name#_7103.csv" 
			nameconflict="overwrite" 
			charset="windows-1254"
			output="#header_list_7103##row_list_7103#">
			
		<cffile action="write" 
			file="#download_folder#documents#dir_seperator#hr#dir_seperator#emuhtasar#dir_seperator##file_name#_7103.txt" 
			nameconflict="overwrite"
			charset="windows-1254"
			output="#replace(row_list_7103,';','#TAB_CHR#','all')#">

		<cffile action="write" 
			file="#download_folder#documents#dir_seperator#hr#dir_seperator#emuhtasar#dir_seperator##file_name#_7103.xls" 
			nameconflict="overwrite"
			charset="windows-1254"
			output="#replace(header_list_7103,';','#TAB_CHR#','all')##replace(row_list_7103,';','#TAB_CHR#','all')#">
		
		<cffile action="write" 
			file="#download_folder#/documents#dir_seperator#hr#dir_seperator#emuhtasar#dir_seperator##file_name#_5746.txt" 
			nameconflict="overwrite"
			charset="windows-1254"
			output="#replace(row_list_5746,';','#TAB_CHR#','all')#">
			
		<cfquery name="add_to_db" datasource="#dsn#">
			INSERT INTO EMPLOYEES_MUHTASAR_EXPORTS
				(
					FILE_NAME,
					EXCEL_FILE_NAME,
					FILE_NAME_7103,
					EXCEL_FILE_NAME_7103,
					EXPORT_REASON,
					EXPORT_TYPE,
					SAL_MON,
					SAL_YEAR,
					SSK_OFFICE,
					SSK_OFFICE_NO,
					SSK_BRANCH_ID,
					COMPANY_ID,
					ROW_COUNT,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP,
					EXCEL_XLS_FILE_NAME,
					EXCEL_XLS_FILE_NAME_7103,
					TOTAL_FILE_NAME,
					FILE_NAME_5746
				)
			VALUES
				(
					'#file_name#.txt',
					'#file_name#.csv',
					'#file_name#_7103.txt',
					'#file_name#_7103.csv',
					'#attributes.export_reason#',
					'#attributes.export_type#',
					#attributes.SAL_MON#,
					#attributes.SAL_YEAR#,
					<cfif isdefined("attributes.ssk_office") and listlen(attributes.ssk_office)>'#get_branch_employees.SSK_OFFICE#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.ssk_office") and listlen(attributes.ssk_office)>'#get_branch_employees.SSK_NO#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.ssk_office") and listlen(attributes.ssk_office)>#get_branch_employees.BRANCH_ID#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.company_id") and listlen(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
					#get_branch_employees.recordcount#,
					#now()#,
					#session.ep.userid#,
					'#cgi.REMOTE_ADDR#',
					'#file_name#.xls',
					'#file_name#_7103.xls',
					'#file_name#_total.txt',
					'#file_name#_5746.txt'
				)
		</cfquery>
	</cfif>
<cfif attributes.is_sgk_only eq 1>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='44509.Dosya Oluşturuldu'> !");
		location.reload();
	</script>
</cfif>