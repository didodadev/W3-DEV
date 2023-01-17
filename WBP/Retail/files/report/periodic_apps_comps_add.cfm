<cfif not isdefined("attributes.checked_row")>
	<script>
		alert('İşlem Satırı Seçmelisiniz!');
		history.back();
	</script>
    <cfabort>
</cfif>

<cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdate(attributes.startdate)>
	<cf_date tarih='attributes.startdate'>
<cfelse>
	<cfset attributes.startdate = createodbcdatetime('#year(now())#-1-1')>
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih='attributes.finishdate'>
<cfelse>
	<cfset attributes.finishdate = now()>	
</cfif>

<cfquery name="get_price_types" datasource="#dsn_dev#">
	SELECT * FROM PRICE_TYPES ORDER BY TYPE_ID ASC
</cfquery>
<cfoutput query="get_price_types">
	<cfset 'p_type_#TYPE_ID#' = type_code>
</cfoutput>

<cfquery name="get_comp" datasource="#dsn#">
SELECT
    *
FROM
	(
        <cfif isdefined("attributes.project_id") and len(attributes.project_id) and attributes.project_id neq 0>
        	SELECT
                CAST(C.COMPANY_ID AS NVARCHAR) + '_' + CAST(PP.PROJECT_ID AS NVARCHAR) AS COMP_CODE,
                PP.PROJECT_ID,
                C.COMPANY_ID,
                C.NICKNAME TEDARIKCI_ADI,
                PP.PROJECT_HEAD AS PROJE_ADI,
                C.MEMBER_CODE,
                C.CITY,
                CC.COMPANYCAT
            FROM
                COMPANY C,
                COMPANY_CAT CC,
                PRO_PROJECTS PP
            WHERE
                C.COMPANY_ID = #attributes.cpid# AND
                PP.PROJECT_ID = #attributes.project_id# AND
                C.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
                C.COMPANY_ID = PP.COMPANY_ID
        <cfelse>
        	SELECT
                CAST(C.COMPANY_ID AS NVARCHAR) + '_' + CAST(0 AS NVARCHAR) AS COMP_CODE,
                0 AS PROJECT_ID,
                C.COMPANY_ID,
                C.NICKNAME AS TEDARIKCI_ADI,
                '' AS PROJE_ADI,
                C.MEMBER_CODE,
                C.CITY,
                CC.COMPANYCAT
            FROM
                COMPANY C,
                COMPANY_CAT CC
            WHERE
                C.COMPANY_ID = #attributes.cpid# AND
                C.COMPANYCAT_ID = CC.COMPANYCAT_ID 
		--AND C.COMPANY_ID NOT IN (SELECT PP.COMPANY_ID FROM PRO_PROJECTS PP WHERE PP.COMPANY_ID IS NOT NULL)
        </cfif>
        ) 
        T1
ORDER BY
    T1.TEDARIKCI_ADI ASC,
    T1.PROJE_ADI ASC
</cfquery>

<cfquery name="get_donemsel_rows" datasource="#dsn_dev#" result="d1">
	SELECT
        NULL AS SALES_COUNT,
    	NULL AS FAZLA_SATIS,
        0 AS REVENUE_PERIOD,
        0 AS PRICE_TYPE,
        '' AS PRODUCT_CODE,
        0 AS PRODUCT_ID,
        0 AS STOCK_ID,
        '0' AS TYPE,
        0 AS TABLE_ROW_ID,
        '' AS TABLE_CODE,
        'DONEMSEL' AS ACTION_CODE,
        CAST(PROCESS_TYPE AS NVARCHAR) AS ACTION_TYPE,
        TAX AS VERGI,
        ROW_ID AS ACTION_ID,
        RECORD_DATE,
        (SELECT D.DEPARTMENT_HEAD FROM #dsn_alias#.DEPARTMENT D WHERE D.DEPARTMENT_ID = PROCESS_ROWS.DEPARTMENT_ID) AS DEPARTMENT_HEAD,
        (SELECT PC.TYPE_NAME FROM SEARCH_TABLE_PROCESS_TYPES PC WHERE PC.TYPE_ID = PROCESS_ROWS.PROCESS_TYPE) AS TIP,
        COST AS BRUT,
        COST AS BASE,
        COST AS DAILY_COST,
        PROCESS_DETAIL,
        QUANTITY,
        CAST(PERIOD AS NVARCHAR) AS PERIOD,     
        PROCESS_STARTDATE,
        PROCESS_FINISHDATE,
        PROCESS_STARTDATE AS A_PROCESS_STARTDATE,
        PROCESS_FINISHDATE AS A_PROCESS_FINISHDATE,
        ACTION_STARTDATE,
        ACTION_FINISHDATE,
        PAYMENT_DATE,
        PAID_DATE,
        COST,
        ISNULL(COST_PAID,0) ODENEN,
        CAST(ROW_ID AS NVARCHAR) AS ACTION_NO,
        '' AS FATURA_NO,
        '' AS STOCK_CODE,
        (SELECT PC.TYPE_NAME FROM SEARCH_TABLE_PROCESS_TYPES PC WHERE PC.TYPE_ID = PROCESS_ROWS.PROCESS_TYPE) AS PROPERTY
    FROM
    	PROCESS_ROWS
    WHERE
	<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
        ISNULL(PROJECT_ID,0) = #attributes.project_id# AND
        </cfif>
    	COMPANY_ID = #attributes.cpid# AND
        COST <> 0
	ORDER BY 
    	PROCESS_STARTDATE ASC
</cfquery>

<cfquery name="get_ff_rows" datasource="#dsn_dev#" result="d2">
SELECT
    0 AS SALES_COUNT,
    *
FROM
	(
	SELECT
        ISNULL(IFR.FF_DAILY_AMOUNT,0) AS FAZLA_SATIS,
        0 AS REVENUE_PERIOD,
        PRICE_TYPE,
        S.PRODUCT_CODE,
        S.PRODUCT_ID,
        S.STOCK_ID,
        '2' AS TYPE,
        CASE
        	WHEN PRICE_TYPE >= 0 THEN IFR.TABLE_ROW_ID
            ELSE NULL 
            END AS TABLE_ROW_ID,
        IFR.TABLE_CODE,
        CASE
        	WHEN PRICE_TYPE >= 0 THEN (SELECT PT.ACTION_CODE FROM PRICE_TABLE PT WHERE PT.ROW_ID = IFR.TABLE_ROW_ID) 
          	ELSE 'FIYATFARKLARI'
          END AS ACTION_CODE,
        CAST(IFR.FF_TYPE AS NVARCHAR) AS ACTION_TYPE,
        S.TAX_PURCHASE AS VERGI,
        IFR.FF_ROW_ID AS ACTION_ID,
        IFR.INVOICE_DATE AS RECORD_DATE,
        '' AS DEPARTMENT_HEAD,
        CASE 
        	WHEN IFR.FF_TYPE = 0 THEN 'Fiyat Farkı'
            WHEN IFR.FF_TYPE = 1 THEN 'Kasa Çıkışı'
            WHEN (IFR.FF_TYPE = 2 AND IFR.FF_DAILY_AMOUNT IS NULL) THEN 'Alış Satış' 
            WHEN (IFR.FF_TYPE = 2 AND IFR.FF_DAILY_AMOUNT IS NOT NULL) THEN 'Alış Satış'
            END AS TIP,
        IFR.FF_GROSS AS BRUT,
        IFR.FF_BASE AS BASE,
        ISNULL(IFR.FF_DAILY_COST,IFR.FF_BASE) AS DAILY_COST,
        '' AS PROCESS_DETAIL,
        AMOUNT AS QUANTITY,
        --'2' AS PERIOD,
        CAST(MONTH(INVOICE_DATE) AS NVARCHAR) + '-' + CAST(YEAR(INVOICE_DATE) AS NVARCHAR) AS PERIOD,
        CASE
        	WHEN PRICE_TYPE > 0 THEN ISNULL((SELECT PT.STARTDATE FROM PRICE_TABLE PT WHERE PT.ROW_ID = IFR.TABLE_ROW_ID),INVOICE_DATE)
            WHEN PRICE_TYPE = -1 THEN GETDATE()
            WHEN PRICE_TYPE = -2 THEN GETDATE()
        	END AS PROCESS_STARTDATE,
        CASE
        	WHEN PRICE_TYPE > 0 THEN  ISNULL((SELECT PT.FINISHDATE FROM PRICE_TABLE PT WHERE PT.ROW_ID = IFR.TABLE_ROW_ID),INVOICE_DATE)
            WHEN PRICE_TYPE = -1 THEN GETDATE()
            WHEN PRICE_TYPE = -2 THEN GETDATE()
            END AS PROCESS_FINISHDATE, 
        CASE
        	WHEN PRICE_TYPE > 0 THEN ISNULL((SELECT PT.P_STARTDATE FROM PRICE_TABLE PT WHERE PT.ROW_ID = IFR.TABLE_ROW_ID),INVOICE_DATE)
            WHEN PRICE_TYPE = -1 THEN GETDATE()
            WHEN PRICE_TYPE = -2 THEN GETDATE()
        	END AS A_PROCESS_STARTDATE,
        CASE
        	WHEN PRICE_TYPE > 0 THEN  ISNULL((SELECT PT.P_FINISHDATE FROM PRICE_TABLE PT WHERE PT.ROW_ID = IFR.TABLE_ROW_ID),INVOICE_DATE)
            WHEN PRICE_TYPE = -1 THEN GETDATE()
            WHEN PRICE_TYPE = -2 THEN GETDATE()
            END AS A_PROCESS_FINISHDATE,
        GETDATE() AS ACTION_STARTDATE,
        GETDATE() AS ACTION_FINISHDATE,
        GETDATE() AS PAYMENT_DATE,
        PAID_DATE,
        FF_NET AS COST,
        FF_PAID AS ODENEN,
        CAST(IFR.FF_ROW_ID AS NVARCHAR) AS ACTION_NO,
        IFR.INVOICE_NUMBER AS FATURA_NO,
        CAST(S.STOCK_ID AS NVARCHAR) AS STOCK_CODE,
        S.PROPERTY
    FROM 
    	INVOICE_FF_ROWS IFR,
        #dsn3_alias#.STOCKS S      
    WHERE 
        FF_NET > 0.00009 AND
        COMP_CODE = '#get_comp.COMP_CODE#' AND
        IFR.STOCK_ID = S.STOCK_ID
   ) T1
</cfquery>

<cfquery name="get_ciro_rows" datasource="#dsn_dev#" result="d3">
	SELECT 
    	NULL AS SALES_COUNT,
        NULL AS FAZLA_SATIS,
        REVENUE_PERIOD,
        0 AS PRICE_TYPE,
        P.PRODUCT_CODE,
        P.PRODUCT_ID,
        S.STOCK_ID,
        '1' AS TYPE,
        0 AS TABLE_ROW_ID,
        '' AS TABLE_CODE,
        'CIROPRIMLERI' AS ACTION_CODE,
        IRR.REVENUE_RATE AS ACTION_TYPE,
        P.TAX_PURCHASE AS VERGI,
        IRR.C_ROW_ID AS ACTION_ID,
        IRR.INVOICE_DATE AS RECORD_DATE,
        '' AS DEPARTMENT_HEAD,
        '%' + CAST(IRR.REVENUE_RATE AS NVARCHAR) + ' ' + ISNULL((SELECT TOP 1 PROCESS_DETAIL FROM PROCESS_ROWS WHERE PROCESS_STARTDATE <= IRR.INVOICE_DATE AND PROCESS_FINISHDATE >= IRR.INVOICE_DATE AND ISNULL(REVENUE_RATE,'0') = CAST(IRR.REVENUE_RATE AS NVARCHAR) AND COMPANY_ID = #attributes.cpid# AND PERIOD = IRR.REVENUE_PERIOD),'CİRO PRİMİ') TIP,
        IRR.REVENUE_GROSS AS BRUT,
        IRR.REVENUE_GROSS AS BASE,
        IRR.REVENUE_GROSS AS DAILY_COST,
        '' AS PROCESS_DETAIL,
        IRR.AMOUNT AS QUANTITY,
        --CAST(MONTH(INVOICE_DATE) AS NVARCHAR) + '-' + CAST(YEAR(INVOICE_DATE) AS NVARCHAR) AS PERIOD,
        CASE 
            WHEN REVENUE_PERIOD = 1 AND MONTH(INVOICE_DATE) = 1 THEN 'Ocak ' + '-' + CAST(YEAR(INVOICE_DATE) AS NVARCHAR)
            WHEN REVENUE_PERIOD = 1 AND MONTH(INVOICE_DATE) = 2 THEN 'Şubat ' + '-' + CAST(YEAR(INVOICE_DATE) AS NVARCHAR)
            WHEN REVENUE_PERIOD = 1 AND MONTH(INVOICE_DATE) = 3 THEN 'Mart ' + '-' + CAST(YEAR(INVOICE_DATE) AS NVARCHAR)
            WHEN REVENUE_PERIOD = 1 AND MONTH(INVOICE_DATE) = 4 THEN 'Nisan ' + '-' + CAST(YEAR(INVOICE_DATE) AS NVARCHAR)
            WHEN REVENUE_PERIOD = 1 AND MONTH(INVOICE_DATE) = 5 THEN 'Mayıs ' + '-' + CAST(YEAR(INVOICE_DATE) AS NVARCHAR)
            WHEN REVENUE_PERIOD = 1 AND MONTH(INVOICE_DATE) = 6 THEN 'Haziran ' + '-' + CAST(YEAR(INVOICE_DATE) AS NVARCHAR)
            WHEN REVENUE_PERIOD = 1 AND MONTH(INVOICE_DATE) = 7 THEN 'Temmuz ' + '-' + CAST(YEAR(INVOICE_DATE) AS NVARCHAR)
            WHEN REVENUE_PERIOD = 1 AND MONTH(INVOICE_DATE) = 8 THEN 'Ağustos ' + '-' + CAST(YEAR(INVOICE_DATE) AS NVARCHAR)
            WHEN REVENUE_PERIOD = 1 AND MONTH(INVOICE_DATE) = 9 THEN 'Eylül ' + '-' + CAST(YEAR(INVOICE_DATE) AS NVARCHAR)
            WHEN REVENUE_PERIOD = 1 AND MONTH(INVOICE_DATE) = 10 THEN 'Ekim ' + '-' + CAST(YEAR(INVOICE_DATE) AS NVARCHAR)
            WHEN REVENUE_PERIOD = 1 AND MONTH(INVOICE_DATE) = 11 THEN 'Kasım ' + '-' + CAST(YEAR(INVOICE_DATE) AS NVARCHAR)
            WHEN REVENUE_PERIOD = 1 AND MONTH(INVOICE_DATE) = 12 THEN 'Aralık ' + '-' + CAST(YEAR(INVOICE_DATE) AS NVARCHAR)
            WHEN REVENUE_PERIOD = 2 AND MONTH(INVOICE_DATE) IN (1,2) THEN 'Ocak - Şubat' + '-' + CAST(YEAR(INVOICE_DATE) AS NVARCHAR)
            WHEN REVENUE_PERIOD = 2 AND MONTH(INVOICE_DATE) IN (3,4) THEN 'Mart - Nisan' + '-' + CAST(YEAR(INVOICE_DATE) AS NVARCHAR)
            WHEN REVENUE_PERIOD = 2 AND MONTH(INVOICE_DATE) IN (5,6) THEN 'Mayıs - Haziran' + '-' + CAST(YEAR(INVOICE_DATE) AS NVARCHAR)
            WHEN REVENUE_PERIOD = 2 AND MONTH(INVOICE_DATE) IN (7,8) THEN 'Temmuz - Ağustos' + '-' + CAST(YEAR(INVOICE_DATE) AS NVARCHAR)
            WHEN REVENUE_PERIOD = 2 AND MONTH(INVOICE_DATE) IN (9,10) THEN 'Eylül - Ekim' + '-' + CAST(YEAR(INVOICE_DATE) AS NVARCHAR)
            WHEN REVENUE_PERIOD = 2 AND MONTH(INVOICE_DATE) IN (11,12) THEN 'Kasım - Aralık' + '-' + CAST(YEAR(INVOICE_DATE) AS NVARCHAR)
            WHEN REVENUE_PERIOD = 3 AND MONTH(INVOICE_DATE) IN (1,2,3) THEN 'Ocak - Şubat - Mart' + '-' + CAST(YEAR(INVOICE_DATE) AS NVARCHAR)
            WHEN REVENUE_PERIOD = 3 AND MONTH(INVOICE_DATE) IN (4,5,6) THEN 'Nisan - Mayıs - Haziran' + '-' + CAST(YEAR(INVOICE_DATE) AS NVARCHAR)
            WHEN REVENUE_PERIOD = 3 AND MONTH(INVOICE_DATE) IN (7,8,9) THEN 'Temmuz - Ağustos - Eylül' + '-' + CAST(YEAR(INVOICE_DATE) AS NVARCHAR)
            WHEN REVENUE_PERIOD = 3 AND MONTH(INVOICE_DATE) IN (10,11,12) THEN 'Ekim-Kasım-Aralık' + '-' + CAST(YEAR(INVOICE_DATE) AS NVARCHAR)
            WHEN REVENUE_PERIOD = 6 AND MONTH(INVOICE_DATE) IN (1,2,3,4,5,6) THEN 'Ocak - Haziran Arası' + '-' + CAST(YEAR(INVOICE_DATE) AS NVARCHAR)
            WHEN REVENUE_PERIOD = 6 AND MONTH(INVOICE_DATE) IN (7,8,9,10,11,12) THEN 'Temmuz - Aralık Arası' + '-' + CAST(YEAR(INVOICE_DATE) AS NVARCHAR)
            WHEN REVENUE_PERIOD = 12 THEN 'YILLIK' + '-' + CAST(YEAR(INVOICE_DATE) AS NVARCHAR)
            END AS PERIOD,
       	IRR.INVOICE_DATE AS PROCESS_STARTDATE,
        IRR.INVOICE_DATE AS PROCESS_FINISHDATE,
        IRR.INVOICE_DATE AS A_PROCESS_STARTDATE,
        IRR.INVOICE_DATE AS A_PROCESS_FINISHDATE,
        GETDATE() AS ACTION_STARTDATE,
        GETDATE() AS ACTION_FINISHDATE,
        GETDATE() AS PAYMENT_DATE,
        IRR.PAID_DATE,
        IRR.REVENUE_NET AS COST,
        IRR.REVENUE_PAID AS ODENEN,
        CAST(IRR.C_ROW_ID AS NVARCHAR) AS ACTION_NO,
        IRR.INVOICE_NUMBER AS FATURA_NO,
        CAST(S.STOCK_ID AS NVARCHAR) AS STOCK_CODE,
        S.PROPERTY
    FROM 
    	INVOICE_REVENUE_ROWS IRR,
        #dsn1_alias#.STOCKS S,
        #dsn1_alias#.PRODUCT P
    WHERE 
    	IRR.COMP_CODE = '#get_comp.COMP_CODE#' AND
        IRR.STOCK_ID = S.STOCK_ID AND
        S.PRODUCT_ID = P.PRODUCT_ID
</cfquery>

<cfquery name="get_all_rows1" dbtype="query">
	SELECT * FROM get_donemsel_rows
    	WHERE
		<!--- COST > ODENEN AND --->
		<cfset count_ = 0>
        <cfloop list="#attributes.checked_row#" index="ccc">
            <cfset count_ = count_ + 1>
            <cfset r_type = evaluate("attributes.TYPE_#ccc#")>
            <cfset r_action_type = evaluate("attributes.ACTION_TYPE_#ccc#")>
            <cfset r_id_ = evaluate("attributes.ROW_ID_#ccc#")>
            <cfset r_rate_ = evaluate("attributes.revenue_rate_#ccc#")>
            <cfset r_start_ = evaluate("attributes.action_start_#ccc#")>
            <cfset r_finish_ = evaluate("attributes.action_finish_#ccc#")>
            <cfset r_period_ = evaluate("attributes.period_#ccc#")>
            <cfset r_revenue_ = evaluate("attributes.revenue_period_#ccc#")>
            <cf_date tarih="r_start_">
            <cf_date tarih="r_finish_">
            <cfif r_type eq 0>
                (TYPE = '0' AND ACTION_ID = #r_id_#)
            <cfelseif r_type eq 1>
                (
                    TYPE = '1' AND 
                    ACTION_TYPE = '#r_rate_#' AND
                    PERIOD = '#r_period_#' AND
                    REVENUE_PERIOD = '#r_revenue_#' AND
                    RECORD_DATE BETWEEN #r_start_# AND #r_finish_#
                ) 
            <cfelse>
            	(
                    ACTION_TYPE = '#r_action_type#' AND
                    TYPE = '2' AND 
                    PERIOD = '#r_period_#' AND
                    RECORD_DATE BETWEEN #r_start_# AND #r_finish_#
                ) 
            </cfif>
            <cfif count_ neq listlen(attributes.checked_row)>
            OR
            </cfif> 
        </cfloop>
    UNION
    SELECT * FROM get_ciro_rows
   		WHERE
		<!--- COST > ODENEN AND --->
		<cfset count_ = 0>
        <cfloop list="#attributes.checked_row#" index="ccc">
            <cfset count_ = count_ + 1>
            <cfset r_type = evaluate("attributes.TYPE_#ccc#")>
            <cfset r_action_type = evaluate("attributes.ACTION_TYPE_#ccc#")>
            <cfset r_id_ = evaluate("attributes.ROW_ID_#ccc#")>
            <cfset r_rate_ = evaluate("attributes.revenue_rate_#ccc#")>
            <cfset r_start_ = evaluate("attributes.action_start_#ccc#")>
            <cfset r_finish_ = evaluate("attributes.action_finish_#ccc#")>
            <cfset r_period_ = evaluate("attributes.period_#ccc#")>
            <cf_date tarih="r_start_">
            <cf_date tarih="r_finish_">
            <cfif r_type eq 0>
                (TYPE = '0' AND ACTION_ID = #r_id_#)
            <cfelseif r_type eq 1>
                (
                    TYPE = '1' AND 
                    ACTION_TYPE = '#r_rate_#' AND
                    PERIOD = '#r_period_#' AND
                    RECORD_DATE BETWEEN #r_start_# AND #r_finish_#
                ) 
            <cfelse>
            	(
                    ACTION_TYPE = '#r_action_type#' AND
                    TYPE = '2' AND 
                    PERIOD = '#r_period_#' AND
                    RECORD_DATE BETWEEN #r_start_# AND #r_finish_#
                ) 
            </cfif>
            <cfif count_ neq listlen(attributes.checked_row)>
            OR
            </cfif> 
        </cfloop>
    UNION
    SELECT * FROM get_ff_rows
   		WHERE
		<!--- COST > ODENEN AND --->
		<cfset count_ = 0>
        <cfloop list="#attributes.checked_row#" index="ccc">
            <cfset count_ = count_ + 1>
            <cfset r_type = evaluate("attributes.TYPE_#ccc#")>
            <cfset r_action_type = evaluate("attributes.ACTION_TYPE_#ccc#")>
            <cfset r_id_ = evaluate("attributes.ROW_ID_#ccc#")>
            <cfset r_rate_ = evaluate("attributes.revenue_rate_#ccc#")>
            <cfset r_start_ = evaluate("attributes.action_start_#ccc#")>
            <cfset r_finish_ = evaluate("attributes.action_finish_#ccc#")>
            <cfset r_period_ = evaluate("attributes.period_#ccc#")>
            <cf_date tarih="r_start_">
            <cf_date tarih="r_finish_">
            <cfif r_type eq 0>
                (TYPE = '0' AND ACTION_ID = #r_id_#)
            <cfelseif r_type eq 1>
                (
                    TYPE = '1' AND 
                    ACTION_TYPE = '#r_rate_#' AND
                    PERIOD = '#r_period_#' AND
                    RECORD_DATE BETWEEN #r_start_# AND #r_finish_#
                ) 
            <cfelse>
            	(
                    ACTION_TYPE = '#r_action_type#' AND 
                    TYPE = '2' AND 
                    PERIOD = '#r_period_#' AND
                    RECORD_DATE BETWEEN #r_start_# AND #r_finish_#
                ) 
            </cfif>
            <cfif count_ neq listlen(attributes.checked_row)>
            OR
            </cfif> 
        </cfloop>
</cfquery>


<cfquery name="get_all_rows" dbtype="query">
	SELECT 
    	* 
    FROM 
    	get_all_rows1
    ORDER BY
        TYPE ASC,
        ACTION_TYPE,
        ACTION_CODE,
        TABLE_CODE,
        PRICE_TYPE ASC,
        PROCESS_STARTDATE ASC,
        PROCESS_FINISHDATE ASC,
        PRODUCT_CODE,
        PRODUCT_ID,
        STOCK_ID,
        RECORD_DATE
</cfquery>
<cfform name="add_invoice_" action="#request.self#?fuseaction=invoice.form_add_bill" method="post">
<input type="hidden" value="<cfoutput>#get_comp.company_id#</cfoutput>" id="cpid" name="cpid"/>
<input type="hidden" value="<cfoutput>#get_comp.project_id#</cfoutput>" id="project_id" name="project_id"/>
<input type="hidden" value="<cfoutput>#get_comp.TEDARIKCI_ADI#</cfoutput>" id="company_name" name="company_name"/>
<input type="hidden" value="<cfoutput>#get_comp.PROJE_ADI#</cfoutput>" id="project_head" name="project_head"/>
<input type="hidden" value="<cfoutput>#get_all_rows.recordcount#</cfoutput>" id="row_count" name="row_count"/>
<input type="hidden" value="1" id="ciro_islem" name="ciro_islem"/>
<input type="hidden" value="" id="last_row" name="last_row"/>
<div id="manage_table_div">
<table align="left" cellpadding="0" cellspacing="0">
<tr>
<td>
<cfsavecontent variable="header_">
<table cellpadding="0" cellspacing="0">
<tr>
<!-- sil --><cf_workcube_file_action pdf='1' print='1' doc='1' mail='1' flash_paper='0' trail='0'><!-- sil -->
<td><cfoutput>#get_comp.TEDARIKCI_ADI# <cfif len(get_comp.PROJE_ADI)>(#get_comp.PROJE_ADI#)</cfif></cfoutput> Havuz İcmali</td>
</tr>
</table>
</cfsavecontent>
<!-- sil --><cf_big_list_search title="#header_#"></cf_big_list_search><!-- sil -->
<table class="big_list" style="margin-left:10px;" id="manage_table">
	<thead>
    	<tr>
        	<th width="35" rowspan="2">Lokasyon Adı</th>
            <th rowspan="2"><input type="checkbox" value="1" name="s_all" id="s_all" onclick="check_all_rows();"/></th>
            <th rowspan="2">Uygulama No</th>
            <th rowspan="2">Ürün Kodu</th>
            <th rowspan="2">Stok Kodu</th>
            <th rowspan="2">Ürün Adı</th>
            <th rowspan="2">Uygulama Tipi</th>
            <th rowspan="2">Hesaplama Şekli</th>
            <th colspan="6">Uygulama Tarihleri</th>
            <th colspan="3">Miktarlar</th>
            <th colspan="3">Fiyat</th>
            <th colspan="3">Maliyeti Yüksek Olan Eldeki Stok</th>
            <th colspan="5">Tutarlar</th>
            <th rowspan="2">Stc. İrsaliye Tarihi</th>
            <th rowspan="2">Stc.İrs.No</th>
            <th rowspan="2">Satıcı Fat. No</th>
            <th rowspan="2">Açıklama</th>
        </tr>
        <tr>           
            <th>Baş. Tar.</th>
            <th>Bit. Tar</th>
            <th>Al. Baş. Tar.</th>
            <th>Al. Bit. Tar</th>
            <th>İadeler Dş</th>
            <th>KDV</th>
            <th style="text-align:right;">Satış Miktarı</th>
            <th style="text-align:right;">Alış Miktarı</th>
            <th style="text-align:right;">Hes. Miktarı</th>
            <th>Fat. Alış Fiyatı</th>
            <th>Uyg. Net Alış</th>
            <th>Önc. Stok Maliyet Fiyatı</th>
            <th>Fazla Stok</th>
            <th>Fazla Stok Fark</th>
            <th>Fazla Stok Tutar</th>
            <th>Tutar</th>
            <th>Toplam Fark Tu.</th>
            <th>Ödenen</th>
            <th>Kalan</th>
            <th>Kesilecek</th>
        </tr>
    </thead>
<cfset rows_ = 0>
<cfset cost_toplam = 0>
<cfset odenen_toplam = 0>
<cfset bakiye_toplam = 0>

<cfset ara_row_id_list = ''>
<cfset ara_fatura_list = ''>
<cfset ara_product_list = ''>
<cfset ara_tarih_start_list = ''>
<cfset ara_tarih_end_list = ''>

<cfset ara_tarih_a_start_list = ''>
<cfset ara_tarih_a_end_list = ''>

<cfset ara_alis_toplam = 0>
<cfset ara_satis_toplam = 0>
<cfset ara_hareket_toplam = 0>
<cfset ara_cost_toplam = 0>
<cfset ara_odenen_toplam = 0>
<cfset ara_bakiye_toplam = 0>


<cfset ara_fstok_toplam = 0>
<cfset ara_fstokfark_toplam = 0>
<cfset ara_fstokcost_toplam = 0>
<cfset ara_sales_write = 0>

<cfset last_code_ = "">

<cfset group_cost_toplam = 0>
<cfset group_odenen_toplam = 0>
<cfset group_bakiye_toplam = 0>
<cfset g_ara_tarih_start_list = ''>
<cfset g_ara_tarih_end_list = ''>

<cfset g_ara_tarih_a_start_list = ''>
<cfset g_ara_tarih_a_end_list = ''>

<cfset group_g_list = ''>
<cfset group_g_row_list = ''>
<cfset g_ara_product_list = ''>

<cfset group_count = 1>
<cfset upper_group_count = 1>
    <tbody>
    	<cfsavecontent variable="body">
           <cfoutput query="get_all_rows">
			<cfset p_code_ = "#TYPE#_#PRICE_TYPE#_#product_id#_#stock_id#_#DEPARTMENT_HEAD#_#TABLE_CODE#_#ACTION_TYPE#_#dateformat(PROCESS_STARTDATE,'ddmmyyyy')#_#dateformat(PROCESS_FINISHDATE,'ddmmyyyy')#">
			<cfset next_p_code_ = "#TYPE[currentrow+1]#_#PRICE_TYPE[currentrow+1]#_#product_id[currentrow+1]#_#stock_id[currentrow+1]#_#DEPARTMENT_HEAD[currentrow+1]#_#TABLE_CODE[currentrow+1]#_#ACTION_TYPE[currentrow+1]#_#dateformat(PROCESS_STARTDATE[currentrow+1],'ddmmyyyy')#_#dateformat(PROCESS_FINISHDATE[currentrow+1],'ddmmyyyy')#">
            
            <cfset group_code_ = ACTION_CODE>
            <cfset next_group_code_ = ACTION_CODE[currentrow+1]>
                  
            <cfset group_g_row_list = listappend(group_g_row_list,action_id)>      
            <tr group_code="#group_count#" style="display:none;">
            	<td>#DEPARTMENT_HEAD#</td>
                <td>
                <input type="hidden" name="tax_#currentrow#" value="#VERGI#"/>
                <input type="checkbox" name="row_type_#currentrow#" id="row_type_#currentrow#" group_check="#group_count#" onclick="check_row_cont('#currentrow#');" value="#TYPE#_#ACTION_ID#"/>
                </td>
                <td>#ACTION_CODE#</td>
                <td style="background-color:##bc8f8f;color:white;">#listlast(PRODUCT_CODE,'.')#</td>
                <td style="background-color:##bc8f8f;color:white;">#STOCK_CODE#</td>
                <td nowrap="nowrap">#PROPERTY#</td>
                <td>
                	<cfif len(PRICE_TYPE) and PRICE_TYPE gt 0>
                    	#evaluate('p_type_#PRICE_TYPE#')#
                    </cfif>
                </td>
                <td>
					<cfif type eq 0>
                    	Dönemsel
					<cfelseif type eq 1>
                    	#TIP#
					<cfelseif type eq 2>
						<cfif len(TABLE_ROW_ID)>
                            <cfif FAZLA_SATIS gt 0>Alış Satış Fazlası<cfelse>#TIP#</cfif>
                        <cfelseif PRICE_TYPE eq -2>
                            Aktif Standart Alış
                        <cfelseif PRICE_TYPE eq -1>
                            Standart Alış
                        </cfif>
                    </cfif>
					
                </td>
                <td style="background-color:##90ff90;">
                	<cfif type eq 2 and (listfind('-1,-2',price_type) or action_type eq 1)>
                    	#dateformat(record_date,'dd/mm/yyyy')#
                	<cfelse>
                        #dateformat(PROCESS_STARTDATE,'dd/mm/yyyy')#
                	</cfif>
                </td>
                <td style="background-color:##90ff90;">
                	<cfif type eq 2 and (listfind('-1,-2',price_type) or action_type eq 1)>
                    	#dateformat(record_date,'dd/mm/yyyy')#
                	<cfelse>
                        #dateformat(PROCESS_FINISHDATE,'dd/mm/yyyy')#
                	</cfif>                
                </td>
                <td style="background-color:##90ff90;">
                	<cfif type eq 2 and (listfind('-1,-2',price_type) or action_type eq 1)>
                    	#dateformat(record_date,'dd/mm/yyyy')#
                	<cfelse>
                        #dateformat(A_PROCESS_STARTDATE,'dd/mm/yyyy')#
                	</cfif>
                </td>
                <td style="background-color:##90ff90;">
                	<cfif type eq 2 and (listfind('-1,-2',price_type) or action_type eq 1)>
                    	#dateformat(record_date,'dd/mm/yyyy')#
                	<cfelse>
                        #dateformat(A_PROCESS_FINISHDATE,'dd/mm/yyyy')#
                	</cfif>                
                </td>
                <td style="background-color:##90ff90;"></td>
                <td style="background-color:##90ff90;">#VERGI#</td>
                <td style="background-color:##ffe4b5; text-align:right;">
					<cfif type eq 2 and FAZLA_SATIS gt 0>
                    	#FAZLA_SATIS#
                    <cfelse>
                    	<cfif type eq 1 or (type eq 2 and ACTION_TYPE eq 1)>
                            #QUANTITY#
                        </cfif>
                    </cfif>
                </td>
                <td style="background-color:##ffe4b5; text-align:right;">
					<cfif not (type eq 2 and FAZLA_SATIS gt 0)>
                    	<cfif type eq 0 or (type eq 2 and ACTION_TYPE neq 1)>
                            #QUANTITY#
                        </cfif>
                    <cfelse>
                    	0
                    </cfif>
                </td>
                <td style="background-color:##ffe4b5; text-align:right;">
                	<cfif type eq 2 and FAZLA_SATIS gt 0>
                    	#FAZLA_SATIS#
                    <cfelse>
                        #QUANTITY#
                    </cfif>
                </td>                
                <td style="text-align:right;">
						<cfif (type eq 2 and action_type eq 1)>
                        <cfelse>
                        	<cfif type eq 0>
                                -
                            <cfelseif type gt 1>
                                #tlformat(BRUT,4)#
                            </cfif>
                        </cfif>
                    </td>
                    <td style="text-align:right;">
						<cfif (type eq 2 and action_type eq 1)>
                        	#tlformat(BRUT / QUANTITY,4)#
                        <cfelse>
                        	<cfif type eq 0>
                                -
                            <cfelseif type gt 1>
                               #tlformat(BASE,4)#
                            </cfif>
                       	</cfif>
                    </td>
                    <td style="text-align:right;">
                        <cfif (type eq 2 and action_type eq 1) or (type eq 2 and action_type eq 2)>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.popup_detail_product_cost&product_id=#product_id#&stock_id=#stock_id#','list');" class="tableyazi">#tlformat(daily_cost,4)#</a>
                        </cfif>
                    </td>   
                <td style="text-align:right; background-color:##8fbc8f;">
                	<cfif type eq 2 and FAZLA_SATIS gt 0>
                    	#FAZLA_SATIS#
						<cfset ara_fstok_toplam = ara_fstok_toplam + FAZLA_SATIS>
                    </cfif>
                </td>
                <td style="text-align:right; background-color:##8fbc8f;">
                	<cfif type eq 2 and FAZLA_SATIS gt 0>
                    	#tlformat(BRUT - BASE)#
						<cfset ara_fstokfark_toplam = ara_fstokfark_toplam + BRUT - BASE>
                    </cfif>
                </td>
                <td style="text-align:right; background-color:##8fbc8f;">
                	<cfif type eq 2 and FAZLA_SATIS gt 0>
                    	#tlformat(COST)#
                        <cfset ara_fstokcost_toplam = ara_fstokcost_toplam + COST>
                    </cfif>
                </td>
                <td style="text-align:right; background-color:##adff2f;">
                	#tlformat(COST)#
                </td>
                <td style="text-align:right; background-color:##adff2f;">
                    #tlformat(COST)#
                </td>
                <td style="text-align:right; background-color:##adff2f;">
                    #tlformat(ODENEN)#
                </td>
                <td style="text-align:right; background-color:##adff2f;">
                	<input type="hidden" name="row_start_value_#currentrow#" id="row_start_value_#currentrow#" value="#COST - ODENEN#" />
                    #tlformat(COST - ODENEN)#
                </td>
                <td style="text-align:right; background-color:##adff2f;">
                	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.popup_close_action_rows&action_type=#TYPE#&action_id=#action_id#','medium');"><img src="/images/attach.gif" /></a>
                    <input type="text" name="row_end_value_#currentrow#" id="row_end_value_#currentrow#" value="" onfocus="document.getElementById('last_row').value=this.value;" onblur="hesapla('#currentrow#');" onkeyup="return(control_row('#currentrow#') && FormatCurrency(this,event,2));" readonly style="width:50px;"/>
                </td>
                <td style="text-align:right; background-color:##afeeee;"></td>
                <td style="text-align:right; background-color:##ffedb5;"></td>
                <td style="text-align:right; background-color:##fa8072;">#FATURA_NO#</td>
                <td style="text-align:right; background-color:##fa8072;"></td>
            </tr>
            <!---toplamlar--->
			<cfset cost_toplam = cost_toplam + cost>
            <cfset odenen_toplam = odenen_toplam + ODENEN>
            <cfset bakiye_toplam = bakiye_toplam + (cost - ODENEN)>
            <cfset ara_cost_toplam = ara_cost_toplam + cost>
            <cfset ara_odenen_toplam = ara_odenen_toplam + ODENEN>
            <cfset ara_bakiye_toplam = ara_bakiye_toplam + (cost - ODENEN)>
            
            <cfset group_cost_toplam = group_cost_toplam + cost>
            <cfset group_odenen_toplam = group_odenen_toplam + ODENEN>
            <cfset group_bakiye_toplam = group_bakiye_toplam + (cost - ODENEN)>
            
            <cfset g_ara_product_list = listappend(g_ara_product_list,product_id)>
			<cfset ara_fatura_list = listappend(ara_fatura_list,FATURA_NO)>
            <cfset ara_row_id_list = listappend(ara_row_id_list,currentrow)>
            <cfset ara_product_list = listappend(ara_product_list,product_id)>
            
			<cfif type eq 2 and listfind('-1,-2',price_type)>
            	<cfset ara_tarih_start_list = listappend(ara_tarih_start_list,dateformat(RECORD_DATE,'dd/mm/yyyy'))>
                <cfset ara_tarih_a_start_list = listappend(ara_tarih_a_start_list,dateformat(RECORD_DATE,'dd/mm/yyyy'))>
                <cfset g_ara_tarih_start_list = listappend(g_ara_tarih_start_list,dateformat(RECORD_DATE,'dd/mm/yyyy'))>
                <cfset g_ara_tarih_a_start_list = listappend(g_ara_tarih_a_start_list,dateformat(RECORD_DATE,'dd/mm/yyyy'))>
           	<cfelse>
            	<cfset ara_tarih_start_list = listappend(ara_tarih_start_list,dateformat(PROCESS_STARTDATE,'dd/mm/yyyy'))>
                <cfset ara_tarih_a_start_list = listappend(ara_tarih_a_start_list,dateformat(A_PROCESS_STARTDATE,'dd/mm/yyyy'))>
                <cfset g_ara_tarih_start_list = listappend(g_ara_tarih_start_list,dateformat(PROCESS_STARTDATE,'dd/mm/yyyy'))>
                <cfset g_ara_tarih_a_start_list = listappend(g_ara_tarih_a_start_list,dateformat(A_PROCESS_STARTDATE,'dd/mm/yyyy'))>
			</cfif>
            
            <cfif type eq 2 and listfind('-1,-2',price_type)>
            	<cfset ara_tarih_end_list = listappend(ara_tarih_end_list,dateformat(RECORD_DATE,'dd/mm/yyyy'))>
                <cfset g_ara_tarih_end_list = listappend(g_ara_tarih_end_list,dateformat(RECORD_DATE,'dd/mm/yyyy'))>
                <cfset ara_tarih_a_end_list = listappend(ara_tarih_a_end_list,dateformat(RECORD_DATE,'dd/mm/yyyy'))>
                <cfset g_ara_tarih_a_end_list = listappend(g_ara_tarih_a_end_list,dateformat(RECORD_DATE,'dd/mm/yyyy'))>
           	<cfelse>
            	<cfset ara_tarih_end_list = listappend(ara_tarih_end_list,dateformat(PROCESS_FINISHDATE,'dd/mm/yyyy'))>
                <cfset g_ara_tarih_end_list = listappend(g_ara_tarih_end_list,dateformat(PROCESS_FINISHDATE,'dd/mm/yyyy'))>
                <cfset ara_tarih_a_end_list = listappend(ara_tarih_a_end_list,dateformat(A_PROCESS_FINISHDATE,'dd/mm/yyyy'))>
                <cfset g_ara_tarih_a_end_list = listappend(g_ara_tarih_a_end_list,dateformat(A_PROCESS_FINISHDATE,'dd/mm/yyyy'))>
			</cfif>
            
            <cfif type eq 0 or (type eq 2 and ACTION_TYPE eq 1)>
				<cfset ara_satis_toplam = ara_satis_toplam + QUANTITY>
            </cfif>
            
            <cfif (type eq 2 and FAZLA_SATIS gt 0)>
            	<cfset ara_satis_toplam = ara_satis_toplam + FAZLA_SATIS>
            </cfif>
            
			<cfif not (type eq 2 and FAZLA_SATIS gt 0)>
            	<cfif type eq 1 or (type eq 2 and ACTION_TYPE neq 1)>
                    <cfset ara_alis_toplam = ara_alis_toplam + QUANTITY>
                </cfif>
            </cfif>
            
            <cfif not (type eq 2 and FAZLA_SATIS gt 0)>
            	<cfset ara_hareket_toplam = ara_hareket_toplam + QUANTITY>
            <cfelse>
            	<cfset ara_hareket_toplam = ara_hareket_toplam + FAZLA_SATIS>
            </cfif>    

			<cfif currentrow eq get_all_rows.recordcount or p_code_ is not next_p_code_>
                <cfset group_g_list = listappend(group_g_list,group_count)>
                 <tr style="background-color:##ffefd5;display:none;" upper_group_code="#upper_group_count#">
                    <td style="background-color:##ffefd5;">#DEPARTMENT_HEAD#</td>
                    <td style="background-color:##ffefd5;"><input type="checkbox" name="g_row_type_#group_count#" id="g_row_type_#group_count#" onclick="check_group_row_cont('#group_count#');" value="#group_count#"/></td>
                    <td style="background-color:##ffefd5;">
						<cfif len(ACTION_CODE)>
                        	<cfif type eq 2 and price_type gt 0>
                            	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.popup_detail_product_price_group&action_code=#ACTION_CODE#&TABLE_CODE=#TABLE_CODE#&product_id_list=#ara_product_list#','wwide');" class="tableyazi">#ACTION_CODE#</a>
                            <cfelse>
                            	#ACTION_CODE#
                            </cfif>
                        <cfelse>
                        	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.popup_detail_product_price_group&row_id=#ACTION_NO#','wwide');" class="tableyazi">#ACTION_NO#</a>
                        </cfif>
                    </td>
                    <td style="background-color:##ffefd5;">#listlast(PRODUCT_CODE,'.')#</td>
                    <td style="background-color:##ffefd5;color:white;"><a href="javascript://" onclick="get_group_detail('#group_count#');" class="tableyazi">#STOCK_CODE#</a></td>
                    <td style="background-color:##ffefd5;" nowrap="nowrap"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.popup_detail_product_price&pid=#product_id#','wide2');" class="tableyazi">#PROPERTY#</a></td>
                    <td style="background-color:##ffefd5;">
                    	<cfif len(price_type) and price_type gt 0>
                            #evaluate('p_type_#price_type#')#
                        </cfif>
                    </td>
                    <td style="background-color:##ffefd5;">
						<cfif type eq 0>Dönemsel<cfelseif type eq 1>#TIP#<cfelseif type eq 2>
							<cfif len(TABLE_ROW_ID)>
                                #TIP#
                            <cfelseif PRICE_TYPE eq -2>
                                Aktif Standart Alış
                            <cfelseif PRICE_TYPE eq -1>
                                Standart Alış
                            </cfif>
                        </cfif>
                    </td>
                    <td style="background-color:##1E90FF; color:##FFFFFF;" nowrap>
                        <cfset ilk_tarih_ = listfirst(ara_tarih_start_list)>
                        <cf_date tarih="ilk_tarih_">
                        <cfloop list="#ara_tarih_start_list#" index="ccc">
                            <cf_date tarih="ccc">
                            <cfif datediff('d',ilk_tarih_,ccc) lt 0>
								<cfset ilk_tarih_ = ccc>
                            </cfif>
                        </cfloop>
                        #dateformat(ilk_tarih_,'dd/mm/yyyy')#
                    </td>
                    <td style="background-color:##1E90FF; color:##FFFFFF;">
                    	<cfset ilk_tarih_ = listfirst(ara_tarih_end_list)>
                        <cf_date tarih="ilk_tarih_">
                        <cfloop list="#ara_tarih_end_list#" index="ccc">
                            <cf_date tarih="ccc">
                            <cfif datediff('d',ilk_tarih_,ccc) gt 0>
								<cfset ilk_tarih_ = ccc>
                            </cfif>
                        </cfloop>
                        #dateformat(ilk_tarih_,'dd/mm/yyyy')#
                    </td>
                    <td style="background-color:##1E90FF; color:##FFFFFF;" nowrap>
                        <cfset ilk_tarih_ = listfirst(ara_tarih_a_start_list)>
                        <cf_date tarih="ilk_tarih_">
                        <cfloop list="#ara_tarih_a_start_list#" index="ccc">
                            <cf_date tarih="ccc">
                            <cfif datediff('d',ilk_tarih_,ccc) lt 0>
								<cfset ilk_tarih_ = ccc>
                            </cfif>
                        </cfloop>
                        #dateformat(ilk_tarih_,'dd/mm/yyyy')#
                    </td>
                    <td style="background-color:##1E90FF; color:##FFFFFF;">
                    	<cfset ilk_tarih_ = listfirst(ara_tarih_a_end_list)>
                        <cf_date tarih="ilk_tarih_">
                        <cfloop list="#ara_tarih_a_end_list#" index="ccc">
                            <cf_date tarih="ccc">
                            <cfif datediff('d',ilk_tarih_,ccc) gt 0>
								<cfset ilk_tarih_ = ccc>
                            </cfif>
                        </cfloop>
                        #dateformat(ilk_tarih_,'dd/mm/yyyy')#
                    </td>
                    <td style="background-color:##ffefd5;"></td>
                    <td style="background-color:##ffefd5;">#VERGI#</td>
                    <td style="background-color:##ADFF2F; text-align:right;">#ara_satis_toplam#</td>
                    <td style="background-color:##FFDEAD; text-align:right;">#ara_alis_toplam#</td>
                    <td style="background-color:##ffefd5; text-align:right;">#ara_hareket_toplam#</td>                
                    <td style="background-color:##FFDEAD;text-align:right;">
						<cfif (type eq 2 and action_type eq 1)>
                        <cfelse>
                        	<cfif type eq 0>
                                -
                            <cfelseif type gt 1>
                                <cfif ara_alis_toplam gt 0>
                                	#tlformat(((ara_cost_toplam - ara_fstokcost_toplam) / ara_alis_toplam) + BASE,4)#
                                <cfelse>
                                	#tlformat(BRUT,4)#
                                </cfif>
                            </cfif>
                        </cfif>
                    </td>
                    <td style="background-color:##000000; color:##FFFFFF;text-align:right;">
						<cfif (type eq 2 and action_type eq 1)>
                        	#tlformat(BRUT / QUANTITY,4)#
                        <cfelse>
                        	<cfif type eq 0>
                                -
                            <cfelseif type gt 1>
                                #tlformat(BASE,4)#
                            </cfif>
                       	</cfif>
                    </td>
                    <td style="background-color:##A9A9A9;text-align:right;">
                        <cfif (type eq 2 and action_type eq 1) or (type eq 2 and action_type eq 2)>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.popup_detail_product_cost&product_id=#product_id#&stock_id=#stock_id#','list');" class="tableyazi">#tlformat(daily_cost,4)#</a>
                        </cfif>
                    </td>    
                    <td style="background-color:##808000;color:##FFFFFF;text-align:right;">
                        #ara_fstok_toplam#
                    </td>
                    <td style="text-align:right; background-color:##808000;color:##FFFFFF;">
                        #tlformat(ara_fstokfark_toplam)#
                    </td>
                    <td style="text-align:right; background-color:##808000;color:##FFFFFF;">
                        #tlformat(ara_fstokcost_toplam)#
                    </td>
                    <td style="text-align:right; background-color:##ffefd5;">
                        #tlformat(ara_cost_toplam)#
                    </td>
                    <td style="text-align:right; background-color:##ffefd5;">
                            #tlformat(ara_cost_toplam)#
                    </td>
                    <td style="text-align:right; background-color:##ffefd5;">
                            #tlformat(ara_odenen_toplam)#
                    </td>
                    <td style="text-align:right; background-color:##ffefd5;">
                        <input type="hidden" name="g_row_start_value_#group_count#" id="g_row_start_value_#group_count#" value="#ara_bakiye_toplam#" />
                            #tlformat(ara_bakiye_toplam)#
                    </td>
                    <td style="text-align:right; background-color:##ffefd5;">
                        <input type="hidden" name="g_row_end_value_#group_count#" id="g_row_end_value_#group_count#" value="" onfocus="document.getElementById('last_row').value=this.value;" onblur="hesapla('#currentrow#');" onkeyup="return(control_row('#currentrow#') && FormatCurrency(this,event,2));" readonly style="width:50px;"/>
                    	<input type="hidden" name="g_row_list_#group_count#" id="g_row_list_#group_count#" value="#ara_row_id_list#" />
                    </td>
                    <td style="text-align:right; background-color:##ffefd5;"></td>
                    <td style="text-align:right; background-color:##ffefd5;"></td>
                    <td style="text-align:right; background-color:##ffefd5;"><!--- #ara_fatura_list# ---></td>
                    <td style="text-align:right; background-color:##ffefd5;"></td>
                </tr>
                <cfset ara_cost_toplam = 0>
                <cfset ara_odenen_toplam = 0>
                <cfset ara_bakiye_toplam = 0>
                <cfset ara_alis_toplam = 0>
				<cfset ara_satis_toplam = 0>
                <cfset ara_hareket_toplam = 0>
                
                <cfset ara_fstok_toplam = 0>
				<cfset ara_fstokfark_toplam = 0>
                <cfset ara_fstokcost_toplam = 0>
                <cfset ara_sales_write = 0>
                
                <cfset ara_fatura_list = ''>
                <cfset ara_tarih_start_list = ''>
                <cfset ara_tarih_end_list = ''>
                <cfset ara_tarih_a_start_list = ''>
                <cfset ara_tarih_a_end_list = ''>
                <cfset ara_product_list = ''>
                <cfset ara_row_id_list = ''>
                <cfset group_count = group_count + 1>
            </cfif>
            <cfif currentrow eq get_all_rows.recordcount or group_code_ is not next_group_code_>
            	<tr>
                    <td style="background-color:##f0e68c;">
                    	<input type="hidden" name="u_g_row_list_#upper_group_count#" id="u_g_row_list_#upper_group_count#" value="#group_g_list#" />
                        <input type="hidden" name="u_g_row_id_list_#upper_group_count#" id="u_g_row_id_list_#upper_group_count#" value="#group_g_row_list#" />
                    </td>
                    <td style="background-color:##f0e68c;"><input type="checkbox" name="u_g_row_type_#upper_group_count#" id="u_g_row_type_#upper_group_count#" onclick="check_upper_group_row_cont('#upper_group_count#');" value="#upper_group_count#"/></td>
                    <td style="background-color:##f0e68c;"><a href="javascript://" onclick="get_u_group_detail('#upper_group_count#');" class="tableyazi">#group_code_#</td>
                    <td style="background-color:##f0e68c;"></td>
                    <td style="background-color:##f0e68c;"></td>
                    <td style="background-color:##f0e68c;"></td>
                    <td style="background-color:##f0e68c;">
                    	<cfif len(price_type) and price_type gt 0>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.popup_detail_product_price_group&action_code=#group_code_#&product_id_list=#g_ara_product_list#','wwide');" class="tableyazi">#evaluate('p_type_#price_type#')#</a>
                        </cfif>
                    </td>
                    <td style="background-color:##f0e68c;">
                    	<cfif type eq 0>Dönemsel<cfelseif type eq 1>#TIP#<cfelseif type eq 2>
							<cfif len(TABLE_ROW_ID)>
                                #TIP#
                            <cfelseif PRICE_TYPE eq -2>
                                Aktif Standart Alış
                            <cfelseif PRICE_TYPE eq -1>
                                Standart Alış
                            </cfif>
                        </cfif>
                    </td>
                    <td style="background-color:##f0e68c;">
                    	<cfset ilk_tarih_ = listfirst(g_ara_tarih_start_list)>
                        <cf_date tarih="ilk_tarih_">
                        <cfloop list="#g_ara_tarih_start_list#" index="ccc">
                            <cf_date tarih="ccc">
                            <cfif datediff('d',ilk_tarih_,ccc) lt 0>
								<cfset ilk_tarih_ = ccc>
                            </cfif>
                        </cfloop>
                        #dateformat(ilk_tarih_,'dd/mm/yyyy')#
                    </td>
                    <td style="background-color:##f0e68c;">
                    	<cfset son_tarih_ = listfirst(g_ara_tarih_end_list)>
                        <cf_date tarih="son_tarih_">
                        <cfloop list="#g_ara_tarih_end_list#" index="ccc">
                            <cf_date tarih="ccc">
                            <cfif datediff('d',son_tarih_,ccc) gt 0>
								<cfset son_tarih_ = ccc>
                            </cfif>
                        </cfloop>
                        #dateformat(son_tarih_,'dd/mm/yyyy')#
                    </td>
                    <td style="background-color:##f0e68c;">
                    	<cfset ilk_tarih_ = listfirst(g_ara_tarih_a_start_list)>
                        <cf_date tarih="ilk_tarih_">
                        <cfloop list="#g_ara_tarih_a_start_list#" index="ccc">
                            <cf_date tarih="ccc">
                            <cfif datediff('d',ilk_tarih_,ccc) lt 0>
								<cfset ilk_tarih_ = ccc>
                            </cfif>
                        </cfloop>
                        #dateformat(ilk_tarih_,'dd/mm/yyyy')#
                    </td>
                    <td style="background-color:##f0e68c;">
                    	<cfset son_tarih_ = listfirst(g_ara_tarih_a_end_list)>
                        <cf_date tarih="son_tarih_">
                        <cfloop list="#g_ara_tarih_a_end_list#" index="ccc">
                            <cf_date tarih="ccc">
                            <cfif datediff('d',son_tarih_,ccc) gt 0>
								<cfset son_tarih_ = ccc>
                            </cfif>
                        </cfloop>
                        #dateformat(son_tarih_,'dd/mm/yyyy')#
                    </td>
                    <td colspan="5" style="background-color:##f0e68c;"></td>
                    <td style="background-color:##f0e68c;"></td>
                    <td style="background-color:##f0e68c;"></td>
                    <td style="background-color:##f0e68c;"></td>
                    <td style="background-color:##f0e68c;"></td>
                    <td style="background-color:##f0e68c;"></td>
                    <td style="background-color:##f0e68c;"></td>
                    <td style="background-color:##f0e68c;"></td>
                    <td style="text-align:right; font-weight:bold;background-color:##f0e68c;">#tlformat(group_cost_toplam)#</td>
                    <td style="text-align:right; font-weight:bold;background-color:##f0e68c;">#tlformat(group_odenen_toplam)#</td>
                    <td style="text-align:right; font-weight:bold;background-color:##f0e68c;">#tlformat(group_bakiye_toplam)#</td>
                    <td style="background-color:##f0e68c;">
                    	<a href="javascript://" onclick="send_group_rows('#upper_group_count#','#type#');"><img src="/images/attach.gif" /></a>
                        <a href="javascript://" onclick="hide_group_rows('#upper_group_count#','#type#');"><img src="/images/icons_invalid.gif" /></a>
                    </td>
                    <td style="background-color:##f0e68c;"></td>
                    <td style="background-color:##f0e68c;"></td>
                    <td style="background-color:##f0e68c;"></td>
                    <td style="background-color:##f0e68c;"></td>
                </tr>
                <cfset upper_group_count = upper_group_count + 1>
                <cfset group_g_list = ''>
                <cfset group_g_row_list = ''>
                <cfset group_cost_toplam = 0>
				<cfset group_odenen_toplam = 0>
                <cfset group_bakiye_toplam = 0>
                <cfset g_ara_tarih_start_list = ''>
                <cfset g_ara_tarih_end_list = ''>
                <cfset g_ara_tarih_a_start_list = ''>
                <cfset g_ara_tarih_a_end_list = ''>
                <cfset g_ara_product_list = ''>
            </cfif>
			<cfif currentrow eq get_all_rows.recordcount>
                <tr>
                    <td colspan="32">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="14" style="background-color:##f08080;">Toplamlar</td>
                    <td style="background-color:##f08080;"></td>
                    <td style="background-color:##f08080;"></td>
                    <td style="background-color:##f08080;"></td>
                    <td style="background-color:##f08080;"></td>
                    <td style="background-color:##f08080;"></td>
                    <td style="background-color:##f08080;"></td>
                    <td style="background-color:##f08080;"></td>
                    <td style="background-color:##f08080;"></td>
                    <td style="background-color:##f08080;"></td>
                    <td style="background-color:##f08080;"></td>
                    <td style="text-align:right; font-weight:bold;background-color:##f08080;">#tlformat(cost_toplam)#</td>
                    <td style="text-align:right; font-weight:bold;background-color:##f08080;">#tlformat(odenen_toplam)#</td>
                    <td style="text-align:right; font-weight:bold;background-color:##f08080;">#tlformat(bakiye_toplam)#</td>
                    <td style="background-color:##f08080;"></td>
                    <td style="background-color:##f08080;"></td>
                    <td style="background-color:##f08080;"></td>
                    <td style="background-color:##f08080;"></td>
                    <td style="background-color:##f08080;"></td>
                </tr>
            </cfif>
            <!---toplamlar--->
            </cfoutput>
    	</cfsavecontent>
            <cfoutput>
            <!-- sil -->
         	<tr>
            	<td style="text-align:right; background-color:##0000cd; color:white;" colspan="10">Toplamlar <input type="submit" value="Gönder"/></td>                
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;">
                	<input type="text" name="end_value_total" id="end_value_total" readonly style="width:50px;"/>
                </td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
            </tr>
            <!-- sil -->
            #body#
            </cfoutput>
    </tbody>
</table>

</td>
</tr>
</table>
</cfform>
</div>
<cfform name="group_kapama" action="" method="post">
	<textarea id="row_list_id" name="row_list_id" style="display:none;"></textarea>
    <cfinput type="hidden" name="type" value="">
</cfform>
<script>
function send_group_rows(group_id,type)
{
	document.getElementById('row_list_id').value = document.getElementById('u_g_row_id_list_' + group_id).value;
	document.group_kapama.type.value = type;
	adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=retail.popup_close_action_group_rows';
	
	windowopen('','medium','close_group_screen');
	document.group_kapama.action = adres_;
	document.group_kapama.target = 'close_group_screen';
	document.group_kapama.submit();
	//windowopen('#request.self#?fuseaction=retail.popup_close_action_group_rows&type=#type#&row_list_id=#group_g_row_list#','list');	
}

function hide_group_rows(group_id,type)
{
	document.getElementById('row_list_id').value = document.getElementById('u_g_row_id_list_' + group_id).value;
	document.group_kapama.type.value = type;
	adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=retail.popup_hide_action_group_rows';
	
	windowopen('','medium','close_group_screen');
	document.group_kapama.action = adres_;
	document.group_kapama.target = 'close_group_screen';
	document.group_kapama.submit();
	//windowopen('#request.self#?fuseaction=retail.popup_close_action_group_rows&type=#type#&row_list_id=#group_g_row_list#','list');	
}
function get_group_detail(group_id)
{
	rel_ = "group_code='" + group_id + "'";
	col1 = $("#manage_table tr[" + rel_ + "]");	
	col1.toggle();
}

function get_u_group_detail(u_group_id)
{
	rel_ = "upper_group_code='" + u_group_id + "'";
	col1 = $("#manage_table tr[" + rel_ + "]");	
	col1.toggle();
	
	u_eleman_sayisi_ = list_len(document.getElementById('u_g_row_list_' + u_group_id).value);
	for(var k=1; k <= u_eleman_sayisi_; k++)
	{
		group_id = list_getat(document.getElementById('u_g_row_list_' + u_group_id).value,k);
		rel_ = "group_code='" + group_id + "'";
		col1 = $("#manage_table tr[" + rel_ + "]");	
		col1.hide();	
	}
}

function check_group_row_cont(group_id)
{
	eleman_sayisi_ = list_len(document.getElementById('g_row_list_' + group_id).value);
	for(var m=1; m <= eleman_sayisi_; m++)
	{
		eleman_ = list_getat(document.getElementById('g_row_list_' + group_id).value,m);
		if(document.getElementById('g_row_type_' + group_id).checked == true)
		{
			document.getElementById('row_type_' + eleman_).checked = true;
			check_row_cont(eleman_);
		}
		else
		{
			document.getElementById('row_type_' + eleman_).checked = false;
			check_row_cont(eleman_);
		}
	}
}

function check_upper_group_row_cont(u_group_id)
{
	u_eleman_sayisi_ = list_len(document.getElementById('u_g_row_list_' + u_group_id).value);
	for(var k=1; k <= u_eleman_sayisi_; k++)
	{
		group_id = list_getat(document.getElementById('u_g_row_list_' + u_group_id).value,k);
		if(document.getElementById('u_g_row_type_' + u_group_id).checked == true)
		{
			document.getElementById('g_row_type_' + group_id).checked = true;
			check_group_row_cont(group_id);
		}
		else
		{
			document.getElementById('g_row_type_' + group_id).checked = false;
			check_group_row_cont(group_id);
		}			
	}
}

function check_row_cont(sira_)
{
	if(document.getElementById('row_type_' + sira_).checked == true)
	{
		document.getElementById('row_end_value_' + sira_).value = commaSplit(document.getElementById('row_start_value_' + sira_).value);
		
		if(document.getElementById('end_value_total').value != '')
			total_ = parseFloat(filterNum(document.getElementById('end_value_total').value));
		else
			total_ = 0;
			
		total_ = total_ + parseFloat(document.getElementById('row_start_value_' + sira_).value);
		document.getElementById('end_value_total').value = commaSplit(total_);
	}	
	else
	{
		deger_ = document.getElementById('row_type_' + sira_).value;
		document.getElementById('row_end_value_' + sira_).value = '';
		
		if(document.getElementById('end_value_total').value != '')
			total_ = parseFloat(filterNum(document.getElementById('end_value_total').value));
		else
			total_ = 0;
			
		total_ = total_ - parseFloat(document.getElementById('row_start_value_' + sira_).value);
		document.getElementById('end_value_total').value = commaSplit(total_);	
	}
}
function check_all_rows()
{
	group_sayisi_ = <cfoutput>#group_count#</cfoutput>;
	upper_group_sayisi_ = <cfoutput>#upper_group_count#</cfoutput>;
	satir_sayisi_ = document.getElementById('row_count').value;
	document.getElementById('end_value_total').value = '';
	
	for(var m=1; m <= satir_sayisi_; m++)
	{
		if(document.getElementById('s_all').checked == true)
		{
			document.getElementById('row_type_' + m).checked = true;
			document.getElementById('row_end_value_' + m).value = commaSplit(document.getElementById('row_start_value_' + m).value);
			
			if(document.getElementById('end_value_total').value != '')
				total_ = parseFloat(filterNum(document.getElementById('end_value_total').value));
			else
				total_ = 0;
				
			total_ = total_ + parseFloat(document.getElementById('row_start_value_' + m).value);
			document.getElementById('end_value_total').value = commaSplit(total_);
		}
		else
		{
			document.getElementById('row_type_' + m).checked = false;
			document.getElementById('row_end_value_' + m).value = '';	
			document.getElementById('end_value_total').value = '';
		}
	}
	
	for(var m=1; m <= group_sayisi_; m++)
	{
		if(document.getElementById('s_all').checked == true)
		{
			try
			{
			document.getElementById('g_row_type_' + m).checked = true;
			document.getElementById('g_row_end_value_' + m).value = commaSplit(document.getElementById('g_row_start_value_' + m).value);
			}
			catch(e)
			{
			//	
			}
		}
		else
		{
			try
			{
			document.getElementById('g_row_type_' + m).checked = false;
			document.getElementById('g_row_end_value_' + m).value = '';
			}
			catch(e)
			{
			//	
			}
		}
	}
	
	for(var m=1; m <= upper_group_sayisi_; m++)
	{
		if(document.getElementById('s_all').checked == true)
		{
			try
			{
			document.getElementById('u_g_row_type_' + m).checked = true;
			}
			catch(e)
			{
			//	
			}
		}
		else
		{
			try
			{
			document.getElementById('u_g_row_type_' + m).checked = false;
			}
			catch(e)
			{
			//	
			}
		}
	}
}
function hesapla(sira_)
{
	if(document.getElementById('row_end_value_' + sira_).value == '')
	{
		document.getElementById('row_type_' + sira_).checked = false;	
	}
	else
	{
		last_ = filterNum(document.getElementById('last_row').value);
		yeni_deger_ = filterNum(document.getElementById('row_end_value_' + sira_).value);
		if(last_ != yeni_deger_)
		{
			if(last_ != '')
			{
				if(document.getElementById('end_value_total').value != '')
					total_ = parseFloat(filterNum(document.getElementById('end_value_total').value));
				else
					total_ = 0;
					
				total_ = total_ - parseFloat(filterNum(last_));			
				total_ = total_ + parseFloat(filterNum(document.getElementById('row_end_value_' + sira_).value));
				
				document.getElementById('end_value_total').value = commaSplit(total_);		
			}				
		}
	}
}
function control_row(sira_)
{
	if(document.getElementById('row_type_' + sira_).checked == false)
	{
		document.getElementById('row_end_value_' + sira_).value = '';
		alert('Rakam Girebilmek İçin Satırı Seçiniz!');
		return false;	
	}
}
</script>