<cfparam name="attributes.form_submitted" default="1">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.search_department_id" default="">
<cfparam name="attributes.search_type_id" default="">
<cfparam name="attributes.status" default="1">
<cfparam name="attributes.limit" default="0">

<cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdate(attributes.startdate)>
	<cf_date tarih='attributes.startdate'>
<cfelse>
	<cfset attributes.startdate = createodbcdatetime('2014-9-1')>
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih='attributes.finishdate'>
<cfelse>
	<cfset attributes.finishdate = createodbcdatetime('#year(now())#-12-31')>	
</cfif>

<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cfquery name="get_search_types" datasource="#dsn_dev#">
	SELECT PC.TYPE_NAME,PC.TYPE_ID FROM SEARCH_TABLE_PROCESS_TYPES PC ORDER BY PC.TYPE_NAME
</cfquery>



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



<cfquery name="get_donemsel_rows" datasource="#dsn_dev#">
	SELECT
    	'0' AS TYPE,
        0 AS REVENUE_PERIOD,
        CAST(PROCESS_TYPE AS NVARCHAR) AS ACTION_TYPE,
        ROW_ID AS ACTION_ID,
        RECORD_DATE,
        (SELECT D.DEPARTMENT_HEAD FROM #dsn_alias#.DEPARTMENT D WHERE D.DEPARTMENT_ID = PROCESS_ROWS.DEPARTMENT_ID) AS DEPARTMENT_HEAD,
        (SELECT PC.TYPE_NAME FROM SEARCH_TABLE_PROCESS_TYPES PC WHERE PC.TYPE_ID = PROCESS_ROWS.PROCESS_TYPE) AS TIP,
        COST AS BRUT,
        PROCESS_DETAIL,
        QUANTITY,
        CAST(MONTH(PAYMENT_DATE) AS NVARCHAR) + '-' + CAST(YEAR(PAYMENT_DATE) AS NVARCHAR) AS PERIOD,
        PROCESS_STARTDATE,
        PROCESS_FINISHDATE,
        ACTION_STARTDATE,
        ACTION_FINISHDATE,
        PAYMENT_DATE,
        PAID_DATE,
        COST,
        ISNULL(COST_PAID,0) ODENEN,
    	ROUND(COST - ISNULL(COST_PAID,0),2) AS KALAN
    FROM
    	PROCESS_ROWS
    WHERE
    	PAYMENT_DATE BETWEEN #attributes.startdate# AND #attributes.finishdate# AND
		<cfif len(attributes.status)>
        STATUS = #attributes.status# AND
        </cfif>
		<cfif listlen(attributes.search_type_id)>
        PROCESS_TYPE IN (#attributes.search_type_id#) AND
        </cfif>
        <cfif listlen(attributes.search_department_id)>
        DEPARTMENT_ID IN (#attributes.search_department_id#) AND
        </cfif>
		<cfif isdefined("attributes.project_id") and len(attributes.project_id) and attributes.project_id neq 0>
        	PROJECT_ID = #attributes.project_id# AND
        </cfif>
    	COMPANY_ID = #attributes.cpid# AND
        COST <> 0
	ORDER BY 
    	PROCESS_STARTDATE ASC
</cfquery>


<cfquery name="get_ff_rows" datasource="#dsn_dev#">
SELECT
    '2' AS TYPE,  
    0 AS REVENUE_PERIOD,  
	ACTION_TYPE,
    -1 AS ACTION_ID,
    MIN(INVOICE_DATE) AS RECORD_DATE,
    '' AS DEPARTMENT_HEAD,
    CASE 
        	WHEN ACTION_TYPE = 0 THEN AY_KOD + ' - Fiyat Farkı'
            WHEN ACTION_TYPE = 1 THEN AY_KOD + ' - Kasa Çıkış'
            ELSE AY_KOD + ' - Alış-Satış' END AS TIP,
    SUM(BRUT) AS BRUT,
    '' AS PROCESS_DETAIL,
    SUM(QUANTITY) AS QUANTITY,
    --'2' AS PERIOD,
    CAST(MONTH(MIN(INVOICE_DATE)) AS NVARCHAR) + '-' + CAST(YEAR(MIN(INVOICE_DATE)) AS NVARCHAR) AS PERIOD,
    MIN(INVOICE_DATE) AS PROCESS_STARTDATE,
    MAX(INVOICE_DATE) AS PROCESS_FINISHDATE,
    GETDATE() AS ACTION_STARTDATE,
    GETDATE() AS ACTION_FINISHDATE,
    GETDATE() AS PAYMENT_DATE,
    PAID_DATE,
    SUM(COST) AS COST,
    SUM(ODENEN) AS ODENEN,
    ROUND(SUM(COST - ODENEN),2) AS KALAN
FROM
	(
	SELECT 
        CAST(MONTH(INVOICE_DATE) AS NVARCHAR) + '-' + CAST(YEAR(INVOICE_DATE) AS NVARCHAR) AS AY_KOD,
        CAST(FF_TYPE AS NVARCHAR) AS ACTION_TYPE,
        INVOICE_DATE AS RECORD_DATE,
        SUM(FF_GROSS * AMOUNT) AS BRUT,
        SUM(AMOUNT) AS QUANTITY,
        INVOICE_DATE,
        PAID_DATE,
        SUM(FF_NET) AS COST,
        SUM(FF_PAID) AS ODENEN
    FROM 
    	INVOICE_FF_ROWS 
    WHERE 
    	<cfif len(attributes.status)>
        	STATUS = #attributes.status# AND
        </cfif>
        INVOICE_DATE BETWEEN #attributes.startdate# AND #attributes.finishdate# AND
        COMP_CODE = '#get_comp.COMP_CODE#'
    GROUP BY
    	INVOICE_DATE,
        FF_TYPE,
        PAID_DATE
    ) T1
GROUP BY
	AY_KOD,
	ACTION_TYPE,
    PAID_DATE
</cfquery>


<cfquery name="get_ciro_rows" datasource="#dsn_dev#">
SELECT
    '1' AS TYPE,
    REVENUE_PERIOD,
    REVENUE_RATE AS ACTION_TYPE,
    -1 AS ACTION_ID,
    MIN(INVOICE_DATE) AS RECORD_DATE,
    '' AS DEPARTMENT_HEAD,
    '%' + CAST(REVENUE_RATE AS NVARCHAR) + ' ' + ISNULL((SELECT TOP 1 STPT.TYPE_NAME FROM PROCESS_ROWS PR,SEARCH_TABLE_PROCESS_TYPES STPT WHERE PR.PROCESS_TYPE = STPT.TYPE_ID AND PR.PROCESS_STARTDATE <= MIN(INVOICE_DATE) AND PR.PROCESS_FINISHDATE >= MIN(INVOICE_DATE) AND ISNULL(PR.REVENUE_RATE,'0') = CAST(T1.REVENUE_RATE AS NVARCHAR) AND PR.COMPANY_ID = #attributes.cpid# AND PR.PERIOD = T1.REVENUE_PERIOD),'CİRO PRİMİ') TIP,
    SUM(REVENUE_GROSS) AS BRUT,
    (SELECT TOP 1 PROCESS_DETAIL FROM PROCESS_ROWS WHERE PROCESS_STARTDATE <= MIN(INVOICE_DATE) AND PROCESS_FINISHDATE >= MIN(INVOICE_DATE) AND ISNULL(REVENUE_RATE,'0') = CAST(T1.REVENUE_RATE AS NVARCHAR) AND COMPANY_ID = #attributes.cpid# AND PERIOD = T1.REVENUE_PERIOD) AS PROCESS_DETAIL,
    SUM(AMOUNT) AS QUANTITY,
    AYLIK_DAGILIM AS PERIOD,
    MIN(INVOICE_DATE) AS PROCESS_STARTDATE,
    MAX(INVOICE_DATE) AS PROCESS_FINISHDATE,
    GETDATE() AS ACTION_STARTDATE,
    GETDATE() AS ACTION_FINISHDATE,
    GETDATE() AS PAYMENT_DATE,
    PAID_DATE,
    SUM(REVENUE_NET) AS COST,
    SUM(REVENUE_PAID) AS ODENEN,
    ROUND(SUM(REVENUE_NET - REVENUE_PAID),2) AS KALAN
FROM
   (
    SELECT 
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
            END AS AYLIK_DAGILIM,
        '1' AS TYPE,
        -1 AS ACTION_ID,
        INVOICE_DATE,
        REVENUE_RATE,
        REVENUE_GROSS,
        AMOUNT,
        REVENUE_PERIOD,
        PAID_DATE,
        REVENUE_NET,
        REVENUE_PAID
    FROM 
        INVOICE_REVENUE_ROWS
    WHERE 
        <cfif len(attributes.status)>
        STATUS = #attributes.status# AND
        </cfif>
        INVOICE_DATE BETWEEN #attributes.startdate# AND #attributes.finishdate# AND
        COMP_CODE = '#get_comp.COMP_CODE#'
    ) T1       
 GROUP BY
 	REVENUE_PERIOD,
    AYLIK_DAGILIM,
    REVENUE_RATE,
    PAID_DATE
</cfquery>

<cfquery name="get_all_rows" dbtype="query">
	SELECT * FROM get_donemsel_rows WHERE KALAN > #attributes.limit#
    UNION
    SELECT * FROM get_ciro_rows WHERE KALAN > #attributes.limit#
    UNION
    SELECT * FROM get_ff_rows WHERE KALAN > #attributes.limit#
ORDER BY
	TYPE ASC,
    PROCESS_STARTDATE ASC
</cfquery>
<table align="left" cellpadding="0" cellspacing="0">
<tr>
<td>


<cfsavecontent variable="header_"><cfoutput>#get_comp.TEDARIKCI_ADI# <cfif len(get_comp.PROJE_ADI)>(#get_comp.PROJE_ADI#)</cfif></cfoutput> Havuz İcmali</cfsavecontent>
<cfform name="search_form" method="post" action="">
<input type="hidden" name="form_submitted" id="form_submitted" value="1">
<cfinput type="hidden" name="cpid" value="#attributes.cpid#">
<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
    <cfinput type="hidden" name="project_id" value="#attributes.project_id#">
</cfif>
    <cf_big_list_search title="#header_#"> 
        <cf_big_list_search_area>
            <table>
                <tr>
                    <td>Departman</td>
                    <td>
                        <cf_multiselect_check 
                                query_name="get_departments_search"  
                                name="search_department_id"
                                option_text="Departman" 
                                width="180"
                                option_name="department_head" 
                                option_value="department_id"
                                value="#attributes.search_department_id#">
                    </td>
                    <td>Uygulama Tipi</td>
                    <td>
                        <cf_multiselect_check 
                                query_name="get_search_types"  
                                name="search_type_id"
                                option_text="Tip" 
                                width="180"
                                option_name="type_name" 
                                option_value="type_id"
                                value="#attributes.search_type_id#">
                    </td>
                    <td>
                    	<select name="status" id="status">
                        	<option value="">Durum</option>
                            <option value="1" <cfif attributes.status eq 1>selected</cfif>>Aktif</option>
                            <option value="0" <cfif attributes.status eq 0>selected</cfif>>Pasif</option>
                        </select>
                    </td>
                    <td>Limit</td>
                    <td>
                        <cfsavecontent variable="message">Limit Alanını Kontrol Ediniz!</cfsavecontent>
                        <cfinput type="text" name="limit" value="#attributes.limit#" validate="integer" maxlength="10" message="#message#" required="yes" style="width:65px;">
                    </td>
                    <td>
                        <cfsavecontent variable="message">Başlangıç</cfsavecontent>
                        <cfinput type="text" name="startdate" value="#dateformat(attributes.startdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <cf_wrk_date_image date_field="startdate">
                    </td>
                    <td>
                        <cfsavecontent variable="message">Bitiş</cfsavecontent>
                        <cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <cf_wrk_date_image date_field="finishdate">
                    </td>
                    <td><cf_wrk_search_button></td>
                </tr>
            </table>
        </cf_big_list_search_area>
    </cf_big_list_search>
</cfform>
<cfform name="add_" method="post" action="#request.self#?fuseaction=retail.periodic_apps_comps_add">
<cfinput type="hidden" name="cpid" value="#attributes.cpid#"/>
<cfinput type="hidden" name="project_id" value="#attributes.project_id#"/>
<!-- sil -->
<table class="big_list" style="margin-left:5px;">
	<thead>
    	<tr>
        	<th width="35">Sıra</th>
            <th>Kayıt Tar.</th>
            <th>Mağaza</th>
            <th>Uygulama Tipi</th>
            <th>Açıklama</th>
            <th>Adet</th>
            <th>Periyot</th>
            <th>Dönem</th>
            <th>Uygulama Baş.</th>
            <th>Uygulama Bit.</th>
            <th>Yapılış Baş.</th>
            <th>Yapılış Bit.</th>
            <th>Prim Ödeme T.</th>
            <th>Ödendiği T.</th>
            <th>Ciro</th>
            <th>Toplam</th>
            <th>Fatura Kesilmiş</th>
            <th>Bakiye</th>
            <th>Bitmemiş Dv. Uy.</th>
            <th>Bitmiş Fat. Kesilmemiş</th>
            <th><input type="checkbox" value="1" name="s_all" id="s_all" onclick="wrk_select_all('s_all','checked_row');"/></th>
        </tr>
    </thead>
    <cfset rows_ = 0>
	<cfset brut_toplam = 0>
    <cfset cost_toplam = 0>
    <cfset odenen_toplam = 0>
    <cfset bakiye_toplam = 0>
    <tbody>
    	<cfsavecontent variable="body">
           <cfoutput query="get_all_rows">
            <tr>
            	<td>
                	<input type="hidden" name="type_#currentrow#" value="#type#"/>
                    <input type="hidden" name="action_type_#currentrow#" value="#ACTION_TYPE#"/>
                    <input type="hidden" name="revenue_rate_#currentrow#" value="#action_type#"/>
                    <input type="hidden" name="row_id_#currentrow#" value="#action_id#"/>
                    <input type="hidden" name="action_start_#currentrow#" value="#dateformat(PROCESS_STARTDATE,'dd/mm/yyyy')#"/>
                    <input type="hidden" name="action_finish_#currentrow#" value="#dateformat(PROCESS_FINISHDATE,'dd/mm/yyyy')#"/>
                    <input type="hidden" name="period_#currentrow#" value="#period#"/>
                    <input type="hidden" name="revenue_period_#currentrow#" value="#REVENUE_PERIOD#"/>
                    #currentrow#
                </td>
                <td>#dateformat(record_date,'dd/mm/yyyy')#</td>
                <td>#DEPARTMENT_HEAD#</td>
                <td style="background-color:##bc8f8f;color:white;">#TIP#</td>
                <td>#PROCESS_DETAIL#</td>
                <td>#quantity#</td>
                <td nowrap><cfif REVENUE_PERIOD gt 0>#REVENUE_PERIOD# Aylık</cfif></td>
                <td nowrap>#period#</td>
                <td style="background-color:##90ff90;">#dateformat(PROCESS_STARTDATE,'dd/mm/yyyy')#</td>
                <td style="background-color:##90ff90;">#dateformat(PROCESS_FINISHDATE,'dd/mm/yyyy')#</td>
                <td style="background-color:##ffe4b5;"><cfif type eq 0>#dateformat(ACTION_STARTDATE,'dd/mm/yyyy')#</cfif></td>
                <td style="background-color:##ffe4b5;"><cfif type eq 0>#dateformat(ACTION_FINISHDATE,'dd/mm/yyyy')#</cfif></td>
                <td>
					<cfif type eq 0>
                		#dateformat(PAYMENT_DATE,'dd/mm/yyyy')#
                	<cfelseif type eq 1>
                    	<cftry>#get_period_info_date(period,YEAR(PROCESS_STARTDATE))#<cfcatch type="any">#dateformat(PROCESS_STARTDATE,'dd/mm/yyyy')#</cfcatch></cftry>
                    <cfelseif type eq 2>
                    	<cfset bitis_ = dateadd('m',1,PROCESS_FINISHDATE)>
                        <cfset bitis_ = createodbcdatetime(createdate(year(bitis_),month(bitis_),1))>
                        #dateformat(bitis_,'dd/mm/yyyy')#
                    </cfif>
                </td>
                <td>
					<cfif type eq 0>
                		#dateformat(PAID_DATE,'dd/mm/yyyy')#
                	<cfelseif type eq 1>
                    	#dateformat(PAID_DATE,'dd/mm/yyyy')#
                    </cfif>
                </td>
                <td style="text-align:right; background-color:##8fbc8f;"><cfif type eq 1>#tlformat(brut)#</cfif></td>
                <td style="text-align:right; background-color:##8fbc8f;">#tlformat(cost)#</td>
                <td style="text-align:right; background-color:##adff2f;">#tlformat(ODENEN)#</td>
                <td style="text-align:right; background-color:##afeeee;">#tlformat(cost - ODENEN)#</td>
                <td style="text-align:right; background-color:##ffedb5;">-</td>
                <td style="text-align:right; background-color:##fa8072;">-</td>
                <td style="text-align:right; background-color:##fa8072;"><input type="checkbox" name="checked_row" id="checked_row_#currentrow#" value="#currentrow#"/></td>
            </tr>
            <!---toplamlar--->
            <cfif type eq 1>
            	<cfset brut_toplam = brut_toplam + brut>
			</cfif>
            <cfset cost_toplam = cost_toplam + cost>
            <cfset odenen_toplam = odenen_toplam + ODENEN>
            <cfset bakiye_toplam = bakiye_toplam + (cost - ODENEN)>
            </cfoutput>
    	</cfsavecontent>
            <cfoutput>
         	<tr>
            	<td style="text-align:right; background-color:##0000cd; color:white;" colspan="14">Toplamlar</td>                
                <td style="text-align:right; background-color:##0000cd; color:white;">#tlformat(brut_toplam)#</td>
                <td style="text-align:right; background-color:##0000cd; color:white;">#tlformat(cost_toplam)#</td>
                <td style="text-align:right; background-color:##0000cd; color:white;">#tlformat(odenen_toplam)#</td>
                <td style="text-align:right; background-color:##0000cd; color:white;">#tlformat(bakiye_toplam)#</td>
                <td style="text-align:right; background-color:##0000cd; color:white;">-</td>
                <td style="text-align:right; background-color:##0000cd; color:white;">-</td>
                <td style="text-align:right; background-color:##0000cd; color:white;"><input type="submit" value="Kes"/></td>
            </tr>
            #body#
            </cfoutput>
    </tbody>
</table>
<!-- sil -->
</cfform>
</td>
</tr>
</table>