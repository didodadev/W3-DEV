<cf_date tarih='attributes.startdate'>
<cf_date tarih='attributes.finishdate'>
<cfquery name="get_kdv_tutar" datasource="#dsn_dev#" result="query_r">
SELECT
	 SUM(T1.KDV0) AS KDV0,
     SUM(T1.KDV1) AS KDV1,
     SUM(T1.KDV8) AS KDV8,
     SUM(T1.KDV18) AS KDV18
FROM
	(
    SELECT
        SUM(GA2.KDV0) AS KDV0,
        SUM(GA2.KDV1) AS KDV1,
        SUM(GA2.KDV8) AS KDV8,
        SUM(GA2.KDV18) AS KDV18
    FROM 
        #dsn_alias#.BRANCH B2,
        GENIUS_ACTIONS GA2,
        #dsn3_alias#.POS_EQUIPMENT PE2
    WHERE 
        <cfif not session.ep.ehesap>
            B2.BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) AND
        </cfif>
        GA2.FIS_IPTAL = 0 AND
        GA2.BELGE_TURU <> '2' AND
		<cfif attributes.branch_id gt 0>
        B2.BRANCH_ID = #attributes.branch_id# AND
        </cfif>
        PE2.BRANCH_ID = B2.BRANCH_ID AND
        PE2.EQUIPMENT_CODE = GA2.KASA_NUMARASI AND
        GA2.FIS_TARIHI >= #attributes.startdate# AND 
        GA2.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)#
    UNION
    SELECT
        SUM(-1 * GA2.KDV0) AS KDV0,
        SUM(-1 * GA2.KDV1) AS KDV1,
        SUM(-1 * GA2.KDV8) AS KDV8,
        SUM(-1 * GA2.KDV18) AS KDV18
    FROM 
        #dsn_alias#.BRANCH B2,
        GENIUS_ACTIONS GA2,
        #dsn3_alias#.POS_EQUIPMENT PE2
    WHERE 
        <cfif not session.ep.ehesap>
            B2.BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) AND
        </cfif>
        GA2.FIS_IPTAL = 0 AND
        GA2.BELGE_TURU = '2' AND
		<cfif attributes.branch_id gt 0>
        B2.BRANCH_ID = #attributes.branch_id# AND
        </cfif>
        PE2.BRANCH_ID = B2.BRANCH_ID AND
        PE2.EQUIPMENT_CODE = GA2.KASA_NUMARASI AND
        GA2.FIS_TARIHI >= #attributes.startdate# AND 
        GA2.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)#
    ) T1	
</cfquery>

<cfquery name="get_ciro_report_cash_kdv_matrah" datasource="#dsn_dev#" result="query_r">
    SELECT
        SUM(GAR2.SATIR_TOPLAM - (GAR2.SATIR_INDIRIM + GAR2.SATIR_PROMOSYON_INDIRIM)) AS KDV_MATRAH,
        GAR2.SATIR_KDV
    FROM 
        #dsn_alias#.BRANCH B2,
        GENIUS_ACTIONS GA2 WITH (NOLOCK),
        GENIUS_ACTIONS_ROWS GAR2 WITH (NOLOCK),
        #dsn3_alias#.POS_EQUIPMENT PE2
    WHERE 
        <cfif not session.ep.ehesap>
            B2.BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) AND
        </cfif>
        GA2.ACTION_ID = GAR2.ACTION_ID AND
        GAR2.SATIR_IPTALMI = 0 AND
        GA2.FIS_IPTAL = 0 AND
        GA2.BELGE_TURU NOT IN ('2','P','L') AND
		<cfif attributes.branch_id gt 0>
        B2.BRANCH_ID = #attributes.branch_id# AND
        </cfif>
        PE2.BRANCH_ID = B2.BRANCH_ID AND
        PE2.EQUIPMENT_CODE = GA2.KASA_NUMARASI AND
        GA2.FIS_TARIHI >= #attributes.startdate# AND 
        GA2.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)#
    GROUP BY
    	GAR2.SATIR_KDV
</cfquery>


<cfquery name="get_ciro_report_cash_kdv_matrah_iptal" datasource="#dsn_dev#" result="query_r">
    SELECT
        SUM(GAR2.SATIR_TOPLAM - (GAR2.SATIR_INDIRIM + GAR2.SATIR_PROMOSYON_INDIRIM)) AS KDV_MATRAH,
        GAR2.SATIR_KDV
    FROM 
        #dsn_alias#.BRANCH B2,
        GENIUS_ACTIONS GA2 WITH (NOLOCK),
        GENIUS_ACTIONS_ROWS GAR2 WITH (NOLOCK),
        #dsn3_alias#.POS_EQUIPMENT PE2
    WHERE 
        <cfif not session.ep.ehesap>
            B2.BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) AND
        </cfif>
        GA2.ACTION_ID = GAR2.ACTION_ID AND
        GAR2.SATIR_IPTALMI = 1 AND
        GA2.FIS_IPTAL = 0 AND
        GA2.BELGE_TURU <> '2' AND
		<cfif attributes.branch_id gt 0>
        B2.BRANCH_ID = #attributes.branch_id# AND
        </cfif>
        PE2.BRANCH_ID = B2.BRANCH_ID AND
        PE2.EQUIPMENT_CODE = GA2.KASA_NUMARASI AND
        GA2.FIS_TARIHI >= #attributes.startdate# AND 
        GA2.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)#
    GROUP BY
    	GAR2.SATIR_KDV
</cfquery>

<cfquery name="get_ciro_report_cash_kdv_matrah_iade" datasource="#dsn_dev#" result="query_r2">
    SELECT
        SUM(
        	CASE WHEN GAR2.SATIR_IPTALMI = 0 THEN
        		(GAR2.SATIR_TOPLAM - (GAR2.SATIR_INDIRIM + GAR2.SATIR_PROMOSYON_INDIRIM))
             ELSE
             	-1 * (GAR2.SATIR_TOPLAM - (GAR2.SATIR_INDIRIM + GAR2.SATIR_PROMOSYON_INDIRIM)) END
           ) AS KDV_MATRAH,
        GAR2.SATIR_KDV
    FROM 
        #dsn_alias#.BRANCH B2,
        GENIUS_ACTIONS GA2 WITH (NOLOCK),
        GENIUS_ACTIONS_ROWS GAR2 WITH (NOLOCK),
        #dsn3_alias#.POS_EQUIPMENT PE2
    WHERE 
        <cfif not session.ep.ehesap>
            B2.BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) AND
        </cfif>
        GA2.ACTION_ID = GAR2.ACTION_ID AND
        GA2.FIS_IPTAL = 0 AND
        GA2.BELGE_TURU = '2' AND
		<cfif attributes.branch_id gt 0>
        B2.BRANCH_ID = #attributes.branch_id# AND
        </cfif>
        PE2.BRANCH_ID = B2.BRANCH_ID AND
        PE2.EQUIPMENT_CODE = GA2.KASA_NUMARASI AND
        GA2.FIS_TARIHI >= #attributes.startdate# AND 
        GA2.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)#
    GROUP BY
    	GAR2.SATIR_KDV
</cfquery>

<cfquery name="get_ciro_report_cash_odemeler" datasource="#dsn_dev#" result="query_r">
SELECT
	CASE
    	WHEN T1.ODEME_TURU = 26 THEN -1 * ODEME_TUTAR
        ELSE ODEME_TUTAR END AS ODEME_TUTAR,
	T1.ODEME_TURU,
    (SELECT HEADER FROM SETUP_POS_PAYMETHODS SPP WHERE SPP.CODE = T1.ODEME_TURU) AS BASLIK
FROM
	(
    SELECT
        GAP2.ODEME_TURU,
        SUM(GAP2.ODEME_TUTAR) AS ODEME_TUTAR
    FROM 
        #dsn_alias#.BRANCH B2,
        GENIUS_ACTIONS GA2 WITH (NOLOCK),
        GENIUS_ACTIONS_PAYMENTS GAP2 WITH (NOLOCK),
        #dsn3_alias#.POS_EQUIPMENT PE2
    WHERE 
		<cfif not session.ep.ehesap>
            B2.BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
        </cfif>
        GA2.ACTION_ID = GAP2.ACTION_ID AND
        GA2.FIS_IPTAL = 0 AND
        GA2.BELGE_TURU <> '2' AND
		<cfif attributes.branch_id gt 0>
        B2.BRANCH_ID = #attributes.branch_id# AND
        </cfif>
        PE2.BRANCH_ID = B2.BRANCH_ID AND
        PE2.EQUIPMENT_CODE = GA2.KASA_NUMARASI AND
        GA2.FIS_TARIHI >= #attributes.startdate# AND 
        GA2.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)#
    GROUP BY
        GAP2.ODEME_TURU
    ) T1
ORDER BY
	ODEME_TURU
</cfquery>

<cfquery name="get_ciro_report_cash_odemeler_iade" datasource="#dsn_dev#">
SELECT
	*,
    (SELECT HEADER FROM SETUP_POS_PAYMETHODS SPP WHERE SPP.CODE = T1.ODEME_TURU) AS BASLIK
FROM
	(
    SELECT
        GAP2.ODEME_TURU,
        SUM(GAP2.ODEME_TUTAR) AS ODEME_TUTAR
    FROM 
        #dsn_alias#.BRANCH B2,
        GENIUS_ACTIONS GA2 WITH (NOLOCK),
        GENIUS_ACTIONS_PAYMENTS GAP2 WITH (NOLOCK),
        #dsn3_alias#.POS_EQUIPMENT PE2
    WHERE 
        <cfif not session.ep.ehesap>
            B2.BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) AND
        </cfif>
        GA2.ACTION_ID = GAP2.ACTION_ID AND
        GA2.FIS_IPTAL = 0 AND
        GA2.BELGE_TURU = '2' AND
		<cfif attributes.branch_id gt 0>
        B2.BRANCH_ID = #attributes.branch_id# AND
        </cfif>
        PE2.BRANCH_ID = B2.BRANCH_ID AND
        PE2.EQUIPMENT_CODE = GA2.KASA_NUMARASI AND
        GA2.FIS_TARIHI >= #attributes.startdate# AND 
        GA2.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)#
    GROUP BY
        GAP2.ODEME_TURU
    ) T1
ORDER BY
	ODEME_TURU
</cfquery>

<cfoutput query="get_ciro_report_cash_odemeler_iade">
	<cfset 'iade_#ODEME_TURU#' = ODEME_TUTAR>
</cfoutput>

<cfset matrah0 = 0>
<cfset matrah1 = 0>
<cfset matrah8 = 0>
<cfset matrah18 = 0>

<cfset kdv0 = 0>
<cfset kdv1 = 0>
<cfset kdv8 = 0>
<cfset kdv18 = 0>


<cfoutput query="get_ciro_report_cash_kdv_matrah">
	<cfset 'matrah#SATIR_KDV#' = KDV_MATRAH>
</cfoutput>

<cfoutput query="get_ciro_report_cash_kdv_matrah_iade">
	<cfset 'matrah#SATIR_KDV#' = evaluate('matrah#SATIR_KDV#') - KDV_MATRAH>
</cfoutput>

<cfoutput query="get_ciro_report_cash_kdv_matrah_iptal">
	<cfset 'matrah#SATIR_KDV#' = evaluate('matrah#SATIR_KDV#') - KDV_MATRAH>
</cfoutput>


<cf_medium_list>
    <tbody>
        <tr class="nohover">
            <td width="225" valign="top">
               	<table width="200" align="center" border="0" cellpadding="0" cellspacing="0">
                	<tr>
                    	<td colspan="4" style="text-align:center;" class="formbold">TOPLAM KDV BİLGİLERİ</td>
                    </tr>
                    <tr>
                    	<td class="txtboldblue" width="20">%</td>
                        <td class="txtboldblue" style="text-align:right;">KDV Matrahı</td>
                        <td class="txtboldblue" style="text-align:right;">KDV Tutarı</td>
                        <td class="txtboldblue" style="text-align:right;">KDV'li Toplam</td>
                    </tr>
                    <cfif len(get_kdv_tutar.kdv0) or len(get_kdv_tutar.kdv1) or len(get_kdv_tutar.kdv8) or len(get_kdv_tutar.kdv18)>
						<cfoutput>
                        <tr>
                            <td style="background-color:##FFC;">0</td>
                            <td style="text-align:right; background-color:##FFC;"">#tlformat(matrah0 - get_kdv_tutar.kdv0)#</td>
                            <td style="text-align:right; background-color:##FFC;"">#tlformat(get_kdv_tutar.kdv0)#</td>
                            <td style="text-align:right; background-color:##FFC;"">#tlformat(matrah0)#</td>
                        </tr>
                        <tr>
                            <td>1</td>
                            <td style="text-align:right;">#tlformat(matrah1 - get_kdv_tutar.kdv1)#</td>
                            <td style="text-align:right;">#tlformat(get_kdv_tutar.kdv1)#</td>
                            <td style="text-align:right;">#tlformat(matrah1)#</td>
                        </tr>
                        <tr>
                            <td style="background-color:##FFC;">8</td>
                            <td style="text-align:right; background-color:##FFC;"">#tlformat(matrah8 - get_kdv_tutar.kdv8)#</td>
                            <td style="text-align:right; background-color:##FFC;"">#tlformat(get_kdv_tutar.kdv8)#</td>
                            <td style="text-align:right; background-color:##FFC;"">#tlformat(matrah8)#</td>
                        </tr>
                        <tr>
                            <td>18</td>
                            <td style="text-align:right;">#tlformat(matrah18 - get_kdv_tutar.kdv18)#</td>
                            <td style="text-align:right;">#tlformat(get_kdv_tutar.kdv18)#</td>
                            <td style="text-align:right;">#tlformat(matrah18)#</td>
                        </tr>
                        <tr>
                            <td style="background-color:##FC9;">TOP.</td>
                            <td style="text-align:right;background-color:##FC9;">#tlformat(matrah0 + matrah1 + matrah8 + matrah18 - (get_kdv_tutar.kdv0 + get_kdv_tutar.kdv1 + get_kdv_tutar.kdv8 + get_kdv_tutar.kdv18))#</td>
                            <td style="text-align:right;background-color:##FC9;">#tlformat(get_kdv_tutar.kdv0 + get_kdv_tutar.kdv1 + get_kdv_tutar.kdv8 + get_kdv_tutar.kdv18)#</td>
                            <td style="text-align:right;background-color:##FC9;">#tlformat(matrah0 + matrah1 + matrah8 + matrah18)#</td>
                        </tr>
                        </cfoutput>
                    </cfif>
                </table>
            </td>
            <td valign="top">
               	 <table width="300" align="center" border="0" cellpadding="0" cellspacing="0">
                	<tr>
                    	<td colspan="3" style="text-align:center;" class="formbold">TOPLAM ÖDEME BİLGİLERİ</td>
                    </tr>
                    <tr>
                    	<td class="txtboldblue" width="60">ÖDEME NO</td>
                        <td class="txtboldblue">ÖDEME AÇIKLAMASI</td>
                        <td class="txtboldblue" style="text-align:right;">ÖDEME TUTARI</td>
                    </tr>
                    <cfset odeme_toplam = 0>
                    <cfoutput query="get_ciro_report_cash_odemeler">
                    <cfset odeme_t_ = ODEME_TUTAR>
                    <cfif isdefined("iade_#ODEME_TURU#")>
                    	<cfset odeme_t_ = odeme_t_ - evaluate("iade_#ODEME_TURU#")>
                    </cfif>
                    <tr>
                    	<td width="60" style="<cfif currentrow mod 2>background-color:##FFC;</cfif>">#ODEME_TURU#</td>
                        <td style="<cfif currentrow mod 2>background-color:##FFC;</cfif>">#baslik#</td>
                        <td style="text-align:right;<cfif currentrow mod 2>background-color:##FFC;</cfif>">#tlformat(odeme_t_)#</td>
                    </tr>
                    <cfset odeme_toplam = odeme_toplam + odeme_t_>
                    </cfoutput>
                    <cfoutput>
                    <tr>
                    	<td colspan="2" style="background-color:##FC9;">Toplamlar</td>
                        <td style="text-align:right;background-color:##FC9;">#tlformat(odeme_toplam)#</td>
                    </tr>	
                    </cfoutput>
                 </table>
            </td>
        </tr>
    </tbody>
</cf_medium_list>
