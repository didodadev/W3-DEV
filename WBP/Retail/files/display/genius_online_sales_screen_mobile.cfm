<cfif cgi.http_user_agent contains 'iPhone'>
    <meta name="viewport" content="width=320,user-scalable=true" />
<cfelseif cgi.http_user_agent contains 'Android'>
    <meta name="viewport" content="width=320,user-scalable=true" />
<cfelse>
    <meta name="viewport" content="width=300,user-scalable=true" />
</cfif>
<cfparam name="attributes.branch_id" default="0">
<cfset bugun_ = now()>
<cfset base_date_ = bugun_>
<cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdate(attributes.startdate)>
	<cf_date tarih='attributes.startdate'>
<cfelse>
	<cfset attributes.startdate = createodbcdatetime('#year(base_date_)#-#month(base_date_)#-#day(base_date_)#')>	
</cfif>

<cfif isdefined("attributes.finishdate") and len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih='attributes.finishdate'>
<cfelse>
	<cfset attributes.finishdate = createodbcdatetime('#year(base_date_)#-#month(base_date_)#-#day(base_date_)#')>	
</cfif>



<table style="width:320px;" cellpadding="0" cellspacing="0">
<tr>
<td>
<cf_big_list_search title="#market_name# Online Satış İzleme Ekranı">
<cfform action="#request.self#?fuseaction=schedules.popup_gen_gl_onln_yns_sls_2014_scrn_1992" method="post" name="search_">
	<cf_big_list_search_area>
    	<table>
        	<tr>
                <td>Başlangıç</td>
                <td>
                    <cfsavecontent variable="message">Başlangıç</cfsavecontent>
                    <cfinput type="text" name="startdate" value="#dateformat(attributes.startdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                    <cf_wrk_date_image date_field="startdate" c_position="M">
                </td>
                <td>Bitiş</td>
                <td>
                    <cfsavecontent variable="message">Bitiş</cfsavecontent>
                    <cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                    <cf_wrk_date_image date_field="finishdate">
                </td>
                <td><cf_wrk_search_button></td>
            </tr>
        </table>
    </cf_big_list_search_area>
</cfform>
</cf_big_list_search>

<cfquery name="get_ciro_report" datasource="#dsn_dev#">
SELECT
	(SELECT TOP 1 
    	GA2.FIS_TARIHI 
     FROM 
     	#dsn_alias#.BRANCH B2,
        GENIUS_ACTIONS GA2,
        #dsn3_alias#.POS_EQUIPMENT PE2
     WHERE 
     	B2.BRANCH_NAME = T1.BRANCH_NAME AND
        PE2.BRANCH_ID = B2.BRANCH_ID AND
        PE2.EQUIPMENT_CODE = GA2.KASA_NUMARASI AND
        GA2.FIS_TARIHI >= #attributes.startdate# AND 
        GA2.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)# 
     ORDER BY 
     	GA2.FIS_TARIHI DESC
    ) AS SON_FIS,
    BRANCH_ID,
    BRANCH_NAME,
    SUM(FIS_TOPLAM) AS FIS_TOPLAM,
    SUM(FIS_TOPLAM_KDV) AS FIS_TOPLAM_KDV,
    SUM(FIS_TOPLAM_INDIRIM) AS FIS_TOPLAM_INDIRIM,
    SUM(IADE_FIS_TOPLAM) AS IADE_FIS_TOPLAM,
    SUM(KARTLI_MUSTERI_TUTARI) AS KARTLI_MUSTERI_TUTARI_TOPLAM,
    SUM(MUSTERI_SAYISI) AS MUSTERI_SAYISI_TOPLAM,
    SUM(KARTLI_MUSTERI_SAYISI) AS KARTLI_MUSTERI_SAYISI_TOPLAM,
    SUM(KAZANILAN_PUAN) AS KAZANILAN_PUAN_TOPLAM,
    SUM(HARCANILAN_PUAN) AS HARCANILAN_PUAN_TOPLAM
FROM
	(
    SELECT
        B.BRANCH_NAME,
        B.BRANCH_ID,
        SUM(FIS_TOPLAM) AS FIS_TOPLAM,
        SUM(FIS_TOPLAM_KDV) AS FIS_TOPLAM_KDV,
        SUM(FIS_PROMOSYON_INDIRIM + FIS_SATIR_ALTI_INDIRIM) AS FIS_TOPLAM_INDIRIM,
        0 AS IADE_FIS_TOPLAM,
        0 AS KARTLI_MUSTERI_TUTARI,
        COUNT(ACTION_ID) AS MUSTERI_SAYISI,
        0 AS KARTLI_MUSTERI_SAYISI,
        SUM(KAZANILAN_PUAN) AS KAZANILAN_PUAN,
        SUM(KULLANILAN_PUAN) AS HARCANILAN_PUAN
    FROM
        #dsn_alias#.BRANCH B,
        GENIUS_ACTIONS GA,
        #dsn3_alias#.POS_EQUIPMENT PE
    WHERE
        GA.BELGE_TURU NOT IN ('2','P','L') AND
        GA.FIS_IPTAL = 0 AND
        PE.BRANCH_ID = B.BRANCH_ID AND
        PE.EQUIPMENT_CODE = GA.KASA_NUMARASI AND
        GA.FIS_TARIHI >= #attributes.startdate# AND GA.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)#
    GROUP BY
        B.BRANCH_NAME,
        B.BRANCH_ID
UNION ALL
    SELECT
        B.BRANCH_NAME,
        B.BRANCH_ID,
        0 AS FIS_TOPLAM,
        0 AS FIS_TOPLAM_KDV,
        0 AS FIS_TOPLAM_INDIRIM,
        SUM(FIS_TOPLAM) AS IADE_FIS_TOPLAM,
        0 AS KARTLI_MUSTERI_TUTARI,
        0 AS MUSTERI_SAYISI,
        0 AS KARTLI_MUSTERI_SAYISI,
        0 AS KAZANILAN_PUAN,
        0 AS HARCANILAN_PUAN
    FROM
        #dsn_alias#.BRANCH B,
        GENIUS_ACTIONS GA,
        #dsn3_alias#.POS_EQUIPMENT PE
    WHERE
        GA.BELGE_TURU = '2' AND
        GA.FIS_IPTAL = 0 AND
        PE.BRANCH_ID = B.BRANCH_ID AND
        PE.EQUIPMENT_CODE = GA.KASA_NUMARASI AND
        GA.FIS_TARIHI >= #attributes.startdate# AND GA.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)#
    GROUP BY
        B.BRANCH_NAME,
        B.BRANCH_ID
UNION ALL
    SELECT
        B.BRANCH_NAME,
        B.BRANCH_ID,
        0 AS FIS_TOPLAM,
        0 AS FIS_TOPLAM_KDV,
        0 AS FIS_TOPLAM_INDIRIM,
        0 AS IADE_FIS_TOPLAM,
        SUM(FIS_TOPLAM) AS KARTLI_MUSTERI_TUTARI,
        0 AS MUSTERI_SAYISI,
        COUNT(ACTION_ID) AS KARTLI_MUSTERI_SAYISI,
        0 AS KAZANILAN_PUAN,
        0 AS HARCANILAN_PUAN
    FROM
        #dsn_alias#.BRANCH B,
        GENIUS_ACTIONS GA,
        #dsn3_alias#.POS_EQUIPMENT PE
    WHERE
        GA.MUSTERI_NO <> '' AND
        GA.BELGE_TURU <> '2' AND
        GA.FIS_IPTAL = 0 AND
        PE.BRANCH_ID = B.BRANCH_ID AND
        PE.EQUIPMENT_CODE = GA.KASA_NUMARASI AND
        GA.FIS_TARIHI >= #attributes.startdate# AND GA.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)#
    GROUP BY
        B.BRANCH_NAME,
        B.BRANCH_ID
    ) AS T1
GROUP BY
    T1.BRANCH_ID,
    T1.BRANCH_NAME
ORDER BY
	T1.BRANCH_ID,
    T1.BRANCH_NAME
</cfquery>

<form name="send_" action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>" method="post">
	<input type="hidden" name="startdate" value="<cfoutput>#dateformat(attributes.startdate,'dd.mm.yyyy')#</cfoutput>">
    <input type="hidden" name="finishdate" value="<cfoutput>#dateformat(attributes.finishdate,'dd.mm.yyyy')#</cfoutput>">
    <input type="hidden" name="branch_id" id="branch_id" value="0">
</form>
<script>
function get_cash_info_genius2(branch_id_)
{
	<cfoutput>
		document.getElementById('branch_id').value = branch_id_;
		document.send_.submit();
	</cfoutput>
}
</script>
	<cf_big_list>
    	<thead>
        	<tr>
            	<th>Mağaza</th>
                <th style="text-align:right;">Net KDV'li Tutar</th>
                <th style="text-align:right;">İade Tutar</th>
                <th style="text-align:right;">Müş. Sayı</th>
                <th style="text-align:right;">Sepet Ort.</th>
                <th style="text-align:right;">Saat</th>
            </tr>
        </thead>
        <tbody>
        <cfscript>
			brut_kdvli_tutar = 0;
			iskonto_tutar = 0;
			net_kdvli_tutar = 0;
			iade_tutar = 0;
			kartli_musteri_tutar = 0;
			kartli_musteri_sayisi = 0;
			musteri_sayisi = 0;
			puan_arti = 0;
			puan_eksi = 0;
		</cfscript>
        <cfoutput query="get_ciro_report">
        	<tr onclick="get_cash_info_genius2('#branch_id#');" style="cursor:pointer;">
            	<td>#branch_name#</td>
                <td style="text-align:right;">#tlformat(FIS_TOPLAM - IADE_FIS_TOPLAM)#<cfset net_kdvli_tutar = net_kdvli_tutar + FIS_TOPLAM - IADE_FIS_TOPLAM></td>
                <td style="text-align:right;">#tlformat(IADE_FIS_TOPLAM)#<cfset iade_tutar = iade_tutar + IADE_FIS_TOPLAM></td>
                <td style="text-align:right;">#tlformat(MUSTERI_SAYISI_TOPLAM,0)#<cfset musteri_sayisi = musteri_sayisi + MUSTERI_SAYISI_TOPLAM></td>
                <td style="text-align:right;">#tlformat((FIS_TOPLAM - IADE_FIS_TOPLAM) / MUSTERI_SAYISI_TOPLAM)#</td>
                <td>#timeformat(SON_FIS,'HH:MM')#</td>
            </tr>
        </cfoutput>
        </tbody>
        <cfif get_ciro_report.recordcount>
        <tfoot>
        	<cfoutput>
            	<tr onclick="get_cash_info_genius2('0');" style="cursor:pointer;">
                    <td>Toplamlar</td>
                    <td style="text-align:right;">#tlformat(net_kdvli_tutar)#</td>
                    <td style="text-align:right;">#tlformat(iade_tutar)#</td>
                    <td style="text-align:right;">#tlformat(musteri_sayisi,0)#</td>
                    <td style="text-align:right;">#tlformat(net_kdvli_tutar / musteri_sayisi)#</td>
                    <td></td>
                </tr>
            </cfoutput>
        </tfoot>
        </cfif>
    </cf_big_list>
</td>
</tr>
</table>
<div id="payment_div">
<cfquery name="get_ciro_report_cash_odemeler" datasource="#dsn_dev#" result="query_r">
SELECT
	ODEME_TIPI,
    ODEME_TURU,
    SUM(ODEME_TUTAR) AS ODEME_TUTAR
FROM
	(
    SELECT
        CASE 
        	WHEN SPP.CODE = 0 THEN 'NAKİT'
            WHEN SPP.PAY_SELECTS LIKE '%256%' THEN 'KREDİ KARTI'
            WHEN SPP.PAY_SELECTS LIKE '%8192%' THEN 'YEMEK ÇEKİ'
            WHEN (SPP.PAY_SELECTS LIKE '%,8,%' OR PAY_SELECTS = '8' OR SPP.PAY_SELECTS LIKE '%,8' OR SPP.PAY_SELECTS LIKE '8,%') THEN 'DÖVİZ'
            WHEN SPP.CODE = 26 THEN 'Çekme'
            ELSE 'DİĞER' END AS ODEME_TIPI, 
        CASE 
        	WHEN SPP.CODE = 0 THEN '0'
            WHEN SPP.PAY_SELECTS LIKE '%256%' THEN '1'
            WHEN SPP.PAY_SELECTS LIKE '%8192%' THEN '2'
            WHEN (SPP.PAY_SELECTS LIKE '%,8,%' OR PAY_SELECTS = '8' OR SPP.PAY_SELECTS LIKE '%,8' OR SPP.PAY_SELECTS LIKE '8,%') THEN '3'
            ELSE '4' END AS ODEME_TURU,            	
        CASE
        	WHEN SPP.CODE = 26 THEN -1 * GAP2.ODEME_TUTAR
         	ELSE GAP2.ODEME_TUTAR END AS ODEME_TUTAR 
    FROM 
        #dsn_alias#.BRANCH B2,
        GENIUS_ACTIONS GA2 WITH (NOLOCK),
        GENIUS_ACTIONS_PAYMENTS GAP2 WITH (NOLOCK),
        #dsn3_alias#.POS_EQUIPMENT PE2,
        SETUP_POS_PAYMETHODS SPP
    WHERE 
        SPP.CODE = GAP2.ODEME_TURU AND
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
    ) T1
GROUP BY
	ODEME_TURU,
    ODEME_TIPI
ORDER BY
	ODEME_TURU
</cfquery>

<cfquery name="get_ciro_report_cash_odemeler_iade" datasource="#dsn_dev#">
SELECT
	ODEME_TIPI,
    ODEME_TURU,
    SUM(ODEME_TUTAR) AS ODEME_TUTAR
FROM
	(
    SELECT
        CASE 
        	WHEN SPP.CODE = 0 THEN 'NAKİT'
            WHEN SPP.PAY_SELECTS LIKE '%256%' THEN 'KREDİ KARTI'
            WHEN SPP.PAY_SELECTS LIKE '%8192%' THEN 'YEMEK ÇEKİ'
            WHEN (SPP.PAY_SELECTS LIKE '%,8,%' OR PAY_SELECTS = '8' OR SPP.PAY_SELECTS LIKE '%,8' OR SPP.PAY_SELECTS LIKE '8,%') THEN 'DÖVİZ'
            ELSE 'DİĞER' END AS ODEME_TIPI, 
        CASE 
        	WHEN SPP.CODE = 0 THEN '0'
            WHEN SPP.PAY_SELECTS LIKE '%256%' THEN '1'
            WHEN SPP.PAY_SELECTS LIKE '%8192%' THEN '2'
            WHEN (SPP.PAY_SELECTS LIKE '%,8,%' OR PAY_SELECTS = '8' OR SPP.PAY_SELECTS LIKE '%,8' OR SPP.PAY_SELECTS LIKE '8,%') THEN '3'
            ELSE '4' END AS ODEME_TURU,            	
        GAP2.ODEME_TUTAR
    FROM 
        #dsn_alias#.BRANCH B2,
        GENIUS_ACTIONS GA2 WITH (NOLOCK),
        GENIUS_ACTIONS_PAYMENTS GAP2 WITH (NOLOCK),
        #dsn3_alias#.POS_EQUIPMENT PE2,
        SETUP_POS_PAYMETHODS SPP
    WHERE 
        SPP.CODE = GAP2.ODEME_TURU AND
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
    ) T1
GROUP BY
	ODEME_TURU,
    ODEME_TIPI
ORDER BY
	ODEME_TURU
</cfquery>

<cfoutput query="get_ciro_report_cash_odemeler_iade">
	<cfset 'iade_#ODEME_TURU#' = ODEME_TUTAR>
</cfoutput>

<cfif len(attributes.branch_id)>
	<cfquery name="get_branch" datasource="#dsn#">
    	SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = #attributes.branch_id#
    </cfquery>
</cfif>

<table style="width:320px;" cellpadding="0" cellspacing="0">
<tr>
<td>
<cf_big_list style="width:320px;">
<thead>
    <tr>
        <th colspan="3" style="text-align:center; background-color:#FFF;" class="formbold">TOPLAM ÖDEME BİLGİLERİ : <cfif attributes.branch_id gt 0><cfoutput>#get_branch.branch_name#</cfoutput><cfelse>Tüm Şubeler</cfif></th>
    </tr>
    <tr>
        <th class="txtboldblue" style="background-color:#FFF;">ÖDEME AÇIKLAMASI</th>
        <th class="txtboldblue" style="text-align:right;background-color:#FFF;">ÖDEME TUTARI</th>
    </tr>
</thead>
<tbody>
    <cfset odeme_toplam = 0>
    <cfoutput query="get_ciro_report_cash_odemeler">
    <cfset odeme_t_ = ODEME_TUTAR>
    <cfif isdefined("iade_#ODEME_TURU#")>
        <cfset odeme_t_ = odeme_t_ - evaluate("iade_#ODEME_TURU#")>
    </cfif>
    <tr>
        <td style="<cfif currentrow mod 2>background-color:##FFC;</cfif>">#ODEME_TIPI#</td>
        <td style="text-align:right;<cfif currentrow mod 2>background-color:##FFC;</cfif>">#tlformat(odeme_t_)#</td>
    </tr>
    <cfset odeme_toplam = odeme_toplam + odeme_t_>
    </cfoutput>
    <cfoutput>
    <tr>
        <td style="background-color:##FC9;">Toplamlar</td>
        <td style="text-align:right;background-color:##FC9;">#tlformat(odeme_toplam)#</td>
    </tr>	
    </cfoutput>
</tbody>
</cf_big_list>
</td>
</tr>
</table>
</div>
<div id="cash_div">
<cf_date tarih='attributes.startdate'>
<cf_date tarih='attributes.finishdate'>
<cfquery name="get_ciro_report_cash" datasource="#dsn_dev#">
    SELECT
        MAX(GA2.FIS_TARIHI) AS SON_FIS,
        PE2.EQUIPMENT_CODE
    FROM 
        #dsn_alias#.BRANCH B2,
        GENIUS_ACTIONS GA2,
        #dsn3_alias#.POS_EQUIPMENT PE2
    WHERE 
		<cfif attributes.branch_id gt 0>
        B2.BRANCH_ID = #attributes.branch_id# AND
        <cfelse>
        B2.BRANCH_ID < 0 AND
        </cfif>
        PE2.BRANCH_ID = B2.BRANCH_ID AND
        PE2.EQUIPMENT_CODE = GA2.KASA_NUMARASI AND
        GA2.FIS_TARIHI >= #attributes.startdate# AND 
        GA2.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)# 
    GROUP BY 
        PE2.EQUIPMENT_CODE
</cfquery>
<table style="width:320px;" cellpadding="0" cellspacing="0">
<tr>
<td>
<cf_medium_list style="width:320px;">
    <tbody>
        <cfoutput query="get_ciro_report_cash">
        <tr>
            <td style="background-color:##FFC;">
                Kasa No : <b>#EQUIPMENT_CODE#</b> : #dateformat(SON_FIS,"dd/mm/yyyy")# (#timeformat(SON_FIS,"HH:MM")#)
            </td>
        </tr>
        </cfoutput>
    </tbody>
</cf_medium_list>
</td>
</tr>
</table>
</div>