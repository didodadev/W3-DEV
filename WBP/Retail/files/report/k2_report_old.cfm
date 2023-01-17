﻿<cfparam name="attributes.search_department_id" default="">
<cfparam name="attributes.kasa_numarasi" default="">
<cfparam name="attributes.iptal_type" default="0">
<cfset baslangic_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cfset base_date_start_ = baslangic_>
<cfset base_date_ = baslangic_>
<cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdate(attributes.startdate)>
	<cf_date tarih='attributes.startdate'>
<cfelse>
	<cfset attributes.startdate = createodbcdatetime('#year(base_date_start_)#-#month(base_date_start_)#-#day(base_date_start_)#')>	
</cfif>

<cfif isdefined("attributes.finishdate") and len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih='attributes.finishdate'>
<cfelse>
	<cfset attributes.finishdate = createodbcdatetime('#year(base_date_)#-#month(base_date_)#-#day(base_date_)#')>	
</cfif>

<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	BRANCH_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
        D.DEPARTMENT_ID NOT IN (#iade_depo_id#,#merkez_depo_id#)
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cfquery name="get_action" datasource="#dsn_dev#">
	SELECT
        I.INVOICE_DATE,
        I.BRANCH_ID,
        B.BRANCH_NAME,
        SUM(I.TOPLAM_SATIS + I.FATURALI_SATIS_TOTAL - I.IADE_TOTAL) AS TOPLAM_SATIS,
        SUM(I.NAKIT_TOTAL + I.FATURALI_SATIS_TOTAL - I.ODEME_TOTAL - I.MASRAF_FISI_TOTAL - I.IADE_TOTAL - I.DOLAR_TOTAL_TL - I.EURO_TOTAL_TL) AS NAKIT_TOTAL,
        SUM(I.ODEME_TOTAL + I.MASRAF_FISI_TOTAL) AS ODEME_TOTAL,
        SUM(I.IADE_TOTAL) AS IADE_TOTAL,
        SUM(I.YEMEK_TOTAL) AS YEMEK_TOTAL,
        SUM(I.KK_TOTAL) AS KK_TOTAL,
        SUM(I.DOLAR_TOTAL_TL) AS DOLAR_TOTAL_TL,
        SUM(I.EURO_TOTAL_TL) AS EURO_TOTAL_TL,
        SUM(I.DOLAR_TOTAL) AS DOLAR_TOTAL,
        SUM(I.EURO_TOTAL) AS EURO_TOTAL
    FROM 
    	GET_ALL_Z_INVOICE I,
        #DSN_ALIAS#.BRANCH B
    WHERE
		I.BRANCH_ID = B.BRANCH_ID AND
		<cfif not session.ep.ehesap>
            I.BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) AND
        </cfif>
        <cfif isdefined("attributes.search_department_id") and len(attributes.search_department_id)>
        	I.BRANCH_ID IN (#attributes.search_department_id#) AND
        </cfif>
    	I.INVOICE_DATE >= #attributes.startdate# AND I.INVOICE_DATE < #dateadd('d',1,attributes.finishdate)#
    GROUP BY
    	I.INVOICE_DATE,
        I.BRANCH_ID,
        B.BRANCH_NAME
    ORDER BY
    	I.INVOICE_DATE
</cfquery>


<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_action.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cf_big_list_search title="Günlük Satış Tahsilat Tablosu">
<cfform action="#request.self#?fuseaction=retail.k2_report" method="post" name="search_">
	<cf_big_list_search_area>
    	<table>
        	<tr>
                <td>
                	<cf_multiselect_check 
                        query_name="get_departments_search"  
                        name="search_department_id"
                        option_text="Şube" 
                        width="150"
                        option_name="department_head" 
                        option_value="BRANCH_ID"
                        filter="0"
                        value="#attributes.search_department_id#">
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
</cfform>
</cf_big_list_search>

<cfscript>
	g_nakit_total = 0;
	g_odeme_total = 0;
	g_kk_total = 0;
	g_yemek_total = 0;
	g_iade_total = 0;
	g_toplam_satis = 0;
	g_dolar_total_tl = 0;
	g_euro_total_tl = 0;
	g_dolar_total = 0;
	g_euro_total = 0;
	g_kasa_arti = 0;
	g_kasa_eksi = 0;
</cfscript>
<cf_big_list>
    <thead>
        <tr>
            <th>Sıra</th>
            <th>Tarih</th>
            <th>Mağaza</th>
            <th>Toplam Satış</th>
            <th>Nakit</th>
            <th>Kasadan Ödeme</th>
            <th>Kredi Kartı</th>
            <th>Yemek Çeki</th>
            <th>İade</th>
        </tr>
    </thead>
    <tbody>
    <cfif get_action.recordcount>
        <cfoutput query="get_action" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
        <cfset fark_ = (NAKIT_TOTAL + KK_TOTAL + YEMEK_TOTAL + ODEME_TOTAL + IADE_TOTAL) - TOPLAM_SATIS>
        <cfif fark_ gt 0>
        	<cfset kasa_eksi = fark_>
            <cfset kasa_arti = 0>
        <cfelse>
        	<cfset kasa_arti = fark_>
            <cfset kasa_eksi = 0>
        </cfif>
        <tr>
            <td>#currentrow#</td>
            <td>#dateformat(invoice_date,'dd.mm.yyyy')#</td>
            <td>#BRANCH_NAME#</td>
            <td style="text-align:right;">#tlformat(toplam_satis)#</td>
            <td style="text-align:right;">#tlformat(NAKIT_TOTAL)#</td>
            <td style="text-align:right;">#tlformat(ODEME_TOTAL)#</td>
            <td style="text-align:right;">#tlformat(KK_TOTAL)#</td>
            <td style="text-align:right;">#tlformat(YEMEK_TOTAL)#</td>
            <td style="text-align:right;">#tlformat(IADE_TOTAL)#</td>
        </tr>
        <cfscript>
			g_nakit_total = g_nakit_total + NAKIT_TOTAL;
			g_odeme_total = g_odeme_total + ODEME_TOTAL;
			g_kk_total = g_kk_total + KK_TOTAL;
			g_yemek_total = g_yemek_total + YEMEK_TOTAL;
			g_iade_total = g_iade_total + IADE_TOTAL;
			g_toplam_satis = g_toplam_satis + toplam_satis;
			g_dolar_total_tl = g_dolar_total_tl + dolar_total_tl;
			g_euro_total_tl = g_euro_total_tl + euro_total_tl;
			g_dolar_total = g_dolar_total + dolar_total;
			g_euro_total = g_euro_total + euro_total;
			g_kasa_arti = g_kasa_arti + kasa_arti;
			g_kasa_eksi = g_kasa_eksi + kasa_eksi;
		</cfscript>
        </cfoutput>
        <cfoutput>
        <tfoot>
        <tr>
        	<td colspan="3" style="text-align:right;" class="formbold">USD</td>
            <td style="text-align:right;" class="formbold">#tlformat(g_dolar_total)# $</td>
            <td style="text-align:right;" class="formbold">#tlformat(g_dolar_total_tl)# TL</td>
            <td style="text-align:right;" class="formbold"></td>
            <td style="text-align:right;" class="formbold"></td>
            <td style="text-align:right;" class="formbold"></td>
            <td style="text-align:right;" class="formbold"></td>
        </tr>
        <tr>
        	<td colspan="3" style="text-align:right;" class="formbold">EURO</td>
            <td style="text-align:right;" class="formbold">#tlformat(g_euro_total)# €</td>
            <td style="text-align:right;" class="formbold">#tlformat(g_euro_total_tl)# TL</td>
            <td style="text-align:right;" class="formbold"></td>
            <td style="text-align:right;" class="formbold"></td>
            <td style="text-align:right;" class="formbold"></td>
            <td style="text-align:right;" class="formbold"></td>
        </tr>
        <tr>
        	<td colspan="3" style="text-align:right;" class="formbold">Kasa (+ / -)</td>
            <td style="text-align:right;" class="formbold"></td>
            <td style="text-align:right;" class="formbold">#tlformat(g_toplam_satis - (g_nakit_total + g_odeme_total + g_kk_total + g_yemek_total))#</td>
            <td style="text-align:right;" class="formbold"></td>
            <td style="text-align:right;" class="formbold"></td>
            <td style="text-align:right;" class="formbold"></td>
            <td style="text-align:right;" class="formbold"></td>
        </tr>
        <tr>
        	<td colspan="3" style="text-align:right;" class="formbold">Toplam</td>
            <td style="text-align:right;" class="formbold">#tlformat(g_toplam_satis)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(g_nakit_total)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(g_odeme_total)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(g_kk_total)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(g_yemek_total)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(g_iade_total)#</td>
        </tr>
        <tr>
        	<td colspan="3" style="text-align:right;" class="formbold">Fark</td>
            <td style="text-align:right;" class="formbold">#tlformat(g_toplam_satis - (g_nakit_total + g_odeme_total + g_kk_total + g_yemek_total))#</td>
            <td style="text-align:right;" class="formbold">#tlformat(0)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(0)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(0)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(0)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(0)#</td>
        </tr>
        </tfoot>
        </cfoutput>
    </cfif>
    </tbody>
</cf_big_list>
<cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
    <cfset url_string = ''>
    <cfif len(attributes.startdate)>
        <cfset url_string = '#url_string#&startdate=#dateformat(attributes.startdate,"dd/mm/yyyy")#'>
    </cfif>
    <cfif len(attributes.finishdate)>
        <cfset url_string = '#url_string#&finishdate=#dateformat(attributes.finishdate,"dd/mm/yyyy")#'>
    </cfif>
    <cfif isdefined("attributes.search_department_id")>
        <cfset url_string = '#url_string#&search_department_id=#attributes.search_department_id#'>
    </cfif>	
    <table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
        <tr>
            <td>
                <cf_pages page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="retail.k2_report#url_string#">
            </td>
            <!-- sil -->
            <td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
            <!-- sil -->
        </tr>
    </table>
</cfif>