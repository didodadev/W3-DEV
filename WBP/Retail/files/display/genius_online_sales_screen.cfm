<cfparam name="attributes.branch_ids" default="">
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
            <cfif not session.ep.ehesap>
                B.BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) AND
            </cfif>
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
            <cfif not session.ep.ehesap>
                B.BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) AND
            </cfif>
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
            <cfif not session.ep.ehesap>
                B.BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) AND
            </cfif>
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
    

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=retail.genius_online_sales_screen" method="post" name="search_">
            <cf_box_search>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57501.Başlangıç'></cfsavecontent>
                        <cfinput type="text" name="startdate" value="#dateformat(attributes.startdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57502.Bitiş'></cfsavecontent>
                        <cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                    </div>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='61544.Genius Online Satış İzleme Ekranı'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='61506.Mağaza Adı'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='61545.Brüt KDVli Tutar'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='61546.İskonto Tutarı'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='61547.Net KDVli Tutar'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='61548.KDV''li İade Tutar'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='61549.Kartlı Müşteri Tutarı'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='61550.Kartlı Müşteri Sayısı'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='35976.Müşteri Sayısı'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='61551.Sepet Ortalama'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='58984.Puan'> +</th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='58984.Puan'> -</th>
                    <th><cf_get_lang dictionary_id='61552.Son Satış Saati'></th>
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
                kdv_tutar = 0;
            </cfscript>
            <cfoutput query="get_ciro_report">
                <tr onclick="get_cash_info_genius('#branch_id#');get_cash_info_genius2('#branch_id#');" style="cursor:pointer;">
                    <td>#branch_name#</td>
                    <td style="text-align:right;">#tlformat(FIS_TOPLAM + FIS_TOPLAM_INDIRIM - IADE_FIS_TOPLAM)#<cfset brut_kdvli_tutar = brut_kdvli_tutar + (FIS_TOPLAM + FIS_TOPLAM_INDIRIM - IADE_FIS_TOPLAM)></td>
                    <td style="text-align:right;">#tlformat(FIS_TOPLAM_INDIRIM)#<cfset iskonto_tutar = iskonto_tutar + FIS_TOPLAM_INDIRIM></td>
                    <td style="text-align:right;">#tlformat(FIS_TOPLAM - IADE_FIS_TOPLAM)#<cfset net_kdvli_tutar = net_kdvli_tutar + FIS_TOPLAM - IADE_FIS_TOPLAM></td>
                    <td style="text-align:right;">#tlformat(IADE_FIS_TOPLAM)#<cfset iade_tutar = iade_tutar + IADE_FIS_TOPLAM></td>
                    <td style="text-align:right;">#tlformat(KARTLI_MUSTERI_TUTARI_TOPLAM)#<cfset kartli_musteri_tutar = kartli_musteri_tutar + KARTLI_MUSTERI_TUTARI_TOPLAM></td>                
                    <td style="text-align:right;">#tlformat(KARTLI_MUSTERI_SAYISI_TOPLAM,0)#<cfset kartli_musteri_sayisi = kartli_musteri_sayisi + KARTLI_MUSTERI_SAYISI_TOPLAM></td> 
                    <td style="text-align:right;">#tlformat(MUSTERI_SAYISI_TOPLAM,0)#<cfset musteri_sayisi = musteri_sayisi + MUSTERI_SAYISI_TOPLAM></td>
                    <td style="text-align:right;">#tlformat((FIS_TOPLAM - IADE_FIS_TOPLAM) / MUSTERI_SAYISI_TOPLAM)#</td>
                    <td style="text-align:right;">#tlformat(KAZANILAN_PUAN_TOPLAM)#<cfset puan_arti = puan_arti + KAZANILAN_PUAN_TOPLAM></td>
                    <td style="text-align:right;">#tlformat(HARCANILAN_PUAN_TOPLAM)#<cfset puan_eksi = puan_eksi + HARCANILAN_PUAN_TOPLAM></td>
                    <td>#timeformat(SON_FIS,'HH:MM')#</td>
                </tr>
            </cfoutput>
            </tbody>
            <cfif get_ciro_report.recordcount>
            <tfoot>
                <cfoutput>
                    <tr onclick="get_cash_info_genius('0');get_cash_info_genius2('0');" style="cursor:pointer;">
                        <td><cf_get_lang dictionary_id='41564.Toplamlar'></td>
                        <td style="text-align:right;">#tlformat(brut_kdvli_tutar)#</td>
                        <td style="text-align:right;">#tlformat(iskonto_tutar)#</td>
                        <td style="text-align:right;">#tlformat(net_kdvli_tutar)#</td>
                        <td style="text-align:right;">#tlformat(iade_tutar)#</td>
                        <td style="text-align:right;">#tlformat(kartli_musteri_tutar)#</td>
                        <td style="text-align:right;">#tlformat(kartli_musteri_sayisi,0)#</td>
                        <td style="text-align:right;">#tlformat(musteri_sayisi,0)#</td>
                        <td style="text-align:right;">#tlformat(net_kdvli_tutar / musteri_sayisi)#</td>
                        <td style="text-align:right;">#tlformat(puan_arti)#</td>
                        <td style="text-align:right;">#tlformat(puan_eksi)#</td>
                        <td>&nbsp;</td>
                    </tr>
                </cfoutput>
            </tfoot>
            </cfif>
        </cf_grid_list>
    </cf_box>
</div>


<script>
function get_cash_info_genius(branch_id)
{
	<cfoutput>AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_genius_cash_screen&startdate=#dateformat(attributes.startdate,"dd/mm/yyyy")#&finishdate=#dateformat(attributes.finishdate,"dd/mm/yyyy")#&branch_id=' + branch_id,'cash_div');</cfoutput>
}
function get_cash_info_genius2(branch_id)
{
	<cfoutput>AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_genius_cash_screen2&startdate=#dateformat(attributes.startdate,"dd/mm/yyyy")#&finishdate=#dateformat(attributes.finishdate,"dd/mm/yyyy")#&branch_id=' + branch_id,'payment_div');</cfoutput>
}
get_cash_info_genius('0');
get_cash_info_genius2('0');
</script>


<div id="cash_div"></div>
<div id="payment_div"></div>