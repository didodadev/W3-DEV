<!--- 
Belge icerisindeki indirimler muhasebelesirken borç_accountta bir deger yaziyor.bu nedenle asagıdaki case yazildi  
DISCOUNTTOTAL SUM(GROSSTOTAL-TAXTOTAL) KDV_SIZ_TOPLAM  
 satis iskontolari hesabina da  alttaki degeri yazildi, bu degerden iptal edilen satislarin (row_type 1 e dikkat) toplam discount u dusulecek
borc_totals, DISCOUNTTOTAL-get_sum_accounts_iptal_1.DISCOUNTTOTAL, 
eb20060217
--->
<cfquery name="kontrol" datasource="#dsn2#">
	SELECT * FROM ACCOUNT_CARD WHERE ACTION_ID = #attributes.invoice_id# AND ACTION_TYPE = 67
</cfquery>
<cfif kontrol.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='139.Bu Belge İçin Muhasebeleştirme İşlemi Yapılmıştır'>");
		//location.href="<cfoutput>#request.self#?fuseaction=pos.list_sales_import</cfoutput>";
		window.close();
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_SALE_IMPORT_BRANCH" datasource="#DSN2#">
	SELECT
		FI.I_ID,
		FI.STARTDATE,
		FI.FINISHDATE,
		FI.SOURCE_SYSTEM,
		FI.INVOICE_ID,
		FI.IMPORTED,
		B.BRANCH_ID,
		B.BRANCH_NAME,
		I.INVOICE_NUMBER
	FROM
		FILE_IMPORTS FI,
		INVOICE I,
		#dsn_alias#.DEPARTMENT D,
		#dsn_alias#.BRANCH B
	WHERE
		FI.I_ID = #attributes.I_ID# AND
		FI.INVOICE_ID = I.INVOICE_ID AND
		FI.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		D.BRANCH_ID = B.BRANCH_ID
	<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
		AND B.BRANCH_ID = #attributes.branch_id#
	</cfif>
</cfquery>
Muhasebeleştirme İşlemi Başladı, Lütfen Bekleyiniz...<br/>
<cfflush>

<cfquery name="GET_SALE_IMPORT_SUMS" datasource="#DSN2#">
	SELECT
		SUM(GROSSTOTAL-TAXTOTAL) KDV_SIZ_TOPLAM,
		SUM(TAXTOTAL) KDV_TOPLAM,
		SUM(DISCOUNTTOTAL) DISCOUNTTOTAL,
		TAX
	FROM
		INVOICE_ROW_POS
	WHERE
		INVOICE_ID = #get_sale_import_branch.invoice_id# AND
		<!--- NETTOTAL > 0 AND --->
		ROW_TYPE IS NULL
	GROUP BY
		TAX
</cfquery>
<cfquery name="GET_SALE_IMPORT_IPTAL" datasource="#DSN2#">
	SELECT
		SUM(GROSSTOTAL-TAXTOTAL)*(-1) KDV_SIZ_TOPLAM,
		SUM(TAXTOTAL)*(-1) KDV_TOPLAM,
		SUM(DISCOUNTTOTAL)*(-1) DISCOUNTTOTAL,
		TAX
	FROM
		INVOICE_ROW_POS
	WHERE
		INVOICE_ID = #get_sale_import_branch.invoice_id# AND
		ROW_TYPE = 1
	GROUP BY
		TAX
</cfquery>
<cfquery name="GET_SALE_IMPORT_IADE_SUMS" datasource="#DSN2#">
	SELECT
		SUM(GROSSTOTAL-TAXTOTAL)*(-1) KDV_SIZ_TOPLAM,
		SUM(TAXTOTAL)*(-1) KDV_TOPLAM,
		TAX
	FROM
		INVOICE_ROW_POS
	WHERE
		INVOICE_ID = #get_sale_import_branch.invoice_id# AND
		ROW_TYPE = 0 <!--- NETTOTAL < 0 20060216 sadece iade satirlarinda KDV oldugu icin iade tipli satirlari cekiyoruz, iptalleri (ROW_TYPE:1) almiyoruz ve almamaliyiz  --->
	GROUP BY TAX
</cfquery>
<cfquery name="GET_SALE_IMPORT_ALL_SUMS" datasource="#DSN2#">
	SELECT
		SUM(GROSSTOTAL-DISCOUNTTOTAL) KDV_LI_TOPLAM,
		ISNULL(SUM(DISCOUNTTOTAL),0) INDIRIM,
		TAX
	FROM
		INVOICE_ROW_POS
	WHERE
		INVOICE_ID = #get_sale_import_branch.invoice_id#
	GROUP BY TAX
</cfquery>
<cfquery name="GET_BRANCH_TAX_ACCOUNTS" datasource="#DSN3#">
	SELECT
		SETUP_TAX.TAX,
		SETUP_TAX.SALE_CODE,
		SETUP_TAX.SALE_CODE_IADE,
		SETUP_BRANCH_SALES.ACCOUNT_CODE,
		SETUP_BRANCH_SALES.ACCOUNT_CODE_IADE,
		SETUP_BRANCH_SALES.ACCOUNT_CODE_INDIRIM,
		ISNULL(SETUP_BRANCH_SALES.IS_ACC_DISCOUNT,0) IS_ACC_DISCOUNT<!--- indirimlerin muhasebe işlemine yansıtılıp yansıtılmayacagını gösterir --->
	FROM
		#dsn2_alias#.SETUP_TAX,
		SETUP_BRANCH_SALES
	WHERE
		SETUP_BRANCH_SALES.BRANCH_ID = #get_sale_import_branch.branch_id# AND
		SETUP_TAX.TAX_ID = SETUP_BRANCH_SALES.TAX_ID
</cfquery>
<cfquery name="GET_BRANCH_CASH" datasource="#DSN2#" maxrows="1">
	SELECT
		CASH_ACC_CODE 
	FROM
		CASH 
	WHERE
		BRANCH_ID = #get_sale_import_branch.branch_id# AND
		ISOPEN = 1 AND
		CASH_CURRENCY_ID = '#session.ep.money#'
	ORDER BY
		RECORD_DATE ASC
</cfquery>
<!--- muhasebeleştirme --->
<cfset borc_accounts = "">
<cfset borc_totals = "">
<cfset alacak_accounts = "">
<cfset alacak_totals = "">

<cfloop query="get_sale_import_sums">
	<cfquery name="get_sum_accounts" dbtype="query">
		SELECT * FROM GET_BRANCH_TAX_ACCOUNTS WHERE TAX = #TAX#
	</cfquery>

	<cfset alacak_accounts = ListAppend(alacak_accounts, get_sum_accounts.sale_code, ",")>
	<cfset alacak_accounts = ListAppend(alacak_accounts, get_sum_accounts.account_code, ",")>
	<cfquery name="get_sum_accounts_iptal_1" dbtype="query">
		SELECT * FROM GET_SALE_IMPORT_IPTAL WHERE TAX = #TAX#
	</cfquery>
	<cfif get_sum_accounts_iptal_1.KDV_SIZ_TOPLAM gt 0>
		<cfif GET_BRANCH_TAX_ACCOUNTS.IS_ACC_DISCOUNT eq 0> <!--- indirimler muhasebe fişine yansıtılıyor --->
			<cfset alacak_totals = ListAppend(alacak_totals, KDV_TOPLAM-get_sum_accounts_iptal_1.KDV_TOPLAM, ",")>
			<cfset alacak_totals = ListAppend(alacak_totals, KDV_SIZ_TOPLAM-get_sum_accounts_iptal_1.KDV_SIZ_TOPLAM, ",")>
			<cfset borc_accounts = ListAppend(borc_accounts, get_sum_accounts.ACCOUNT_CODE_INDIRIM, ",")>
			<cfset borc_totals = ListAppend(borc_totals, DISCOUNTTOTAL-get_sum_accounts_iptal_1.DISCOUNTTOTAL, ",")>
		<cfelse>
			<cfset alacak_totals = ListAppend(alacak_totals, KDV_TOPLAM-get_sum_accounts_iptal_1.KDV_TOPLAM, ",")>
			<cfset alacak_totals = ListAppend(alacak_totals, KDV_SIZ_TOPLAM-get_sum_accounts_iptal_1.KDV_SIZ_TOPLAM-DISCOUNTTOTAL, ",")>
		</cfif>
	<cfelse>
		<cfif GET_BRANCH_TAX_ACCOUNTS.IS_ACC_DISCOUNT eq 0> <!--- indirimler muhasebe fişine yansıtılıyor --->
			<cfset alacak_totals = ListAppend(alacak_totals, KDV_TOPLAM, ",")>
			<cfset alacak_totals = ListAppend(alacak_totals, KDV_SIZ_TOPLAM, ",")>
			<cfset borc_accounts = ListAppend(borc_accounts, get_sum_accounts.ACCOUNT_CODE_INDIRIM, ",")>
			<cfset borc_totals = ListAppend(borc_totals, DISCOUNTTOTAL, ",")>
		<cfelse>
			<cfset alacak_totals = ListAppend(alacak_totals, KDV_TOPLAM, ",")>
			<cfset alacak_totals = ListAppend(alacak_totals, KDV_SIZ_TOPLAM-DISCOUNTTOTAL, ",")>
		</cfif>
	</cfif>
</cfloop>

<cfloop query="get_sale_import_iade_sums">
	<cfquery name="get_sum_accounts" dbtype="query">
		SELECT * FROM get_branch_tax_accounts WHERE TAX = #TAX#
	</cfquery>
	<cfset borc_accounts = ListAppend(borc_accounts, get_sum_accounts.ACCOUNT_CODE_IADE, ",")>
	<cfset borc_accounts = ListAppend(borc_accounts, get_sum_accounts.SALE_CODE_IADE, ",")>
	<cfset borc_totals = ListAppend(borc_totals, KDV_SIZ_TOPLAM, ",")>
	<cfset borc_totals = ListAppend(borc_totals, KDV_TOPLAM, ",")>
</cfloop>

<cfloop query="get_sale_import_all_sums">
	<cfquery name="get_sum_accounts" dbtype="query">
		SELECT * FROM get_branch_tax_accounts WHERE TAX = #TAX#
	</cfquery>
	<cfif KDV_LI_TOPLAM gt 0>
		<cfset borc_accounts = ListAppend(borc_accounts, get_branch_cash.CASH_ACC_CODE, ",")>
		<cfset borc_totals = ListAppend(borc_totals, KDV_LI_TOPLAM, ",")>
	</cfif>
</cfloop>
<cfscript>
//borc alacak tutar farkında 5 ytl ye kadar yuvarlama yapılıyor...
	temp_total_alacak = evaluate(ListChangeDelims(alacak_totals,'+',','));
	temp_total_borc = evaluate(ListChangeDelims(borc_totals,'+',','));
	temp_fark = round((temp_total_alacak-temp_total_borc)*100);
	if( temp_fark gte -800 and temp_fark lt 0 )
	{
		fark_account = cfquery(datasource:"#dsn3#",sqlstring:"SELECT FARK_GELIR FROM SETUP_INVOICE");
		alacak_accounts = ListAppend(alacak_accounts, fark_account.FARK_GELIR, ",");
		alacak_totals = ListAppend(alacak_totals, abs(temp_fark/100), ",");
	}
	else if( temp_fark lte 800 and temp_fark gt 0 )
	{
		fark_account = cfquery(datasource:"#dsn3#",sqlstring:"SELECT FARK_GIDER FROM SETUP_INVOICE");
		borc_accounts = ListAppend(borc_accounts, fark_account.FARK_GIDER, ",");
		borc_totals = ListAppend(borc_totals, abs(temp_fark/100), ",");
	}
</cfscript>
<cflock timeout="60" name="#CreateUUID()#">
	<cftransaction>
		<cfscript>
			/* action_id : get_sale_import_branch.I_ID, */
			kasa_muhasebelesti = muhasebeci(
				action_id : get_sale_import_branch.INVOICE_ID,
				workcube_process_type : 67,
				account_card_type : 13,
				islem_tarihi : CreateODBCDate(get_sale_import_branch.STARTDATE),
				borc_hesaplar : borc_accounts,
				borc_tutarlar : borc_totals,
				alacak_hesaplar : alacak_accounts,
				alacak_tutarlar : alacak_totals,
				to_branch_id: get_sale_import_branch.branch_id,
				fis_detay : '#get_sale_import_branch.branch_name# #dateformat(get_sale_import_branch.startdate,dateformat_style)# Perakende Satış',
				fis_satir_detay : '#get_sale_import_branch.branch_name# #dateformat(get_sale_import_branch.startdate,dateformat_style)# Perakende Satış',
				belge_no : get_sale_import_branch.INVOICE_NUMBER
			);
		</cfscript>
		<cfif len(kasa_muhasebelesti) and kasa_muhasebelesti neq 0>
			<cfquery name="upd_file" datasource="#dsn2#">
				UPDATE FILE_IMPORTS SET IS_MUHASEBE = 1 WHERE I_ID = #attributes.I_ID#
			</cfquery>
		</cfif>
	</cftransaction>
</cflock>
<!--- <script type="text/javascript">
	alert("<cf_get_lang no ='140.Muhasebeleştirme İşlemi Tamamlandı'> !");
	//location.href="<cfoutput>#request.self#?fuseaction=pos.list_sales_import</cfoutput>";
	wrk_opener_reload();
	window.close();
</script> --->
