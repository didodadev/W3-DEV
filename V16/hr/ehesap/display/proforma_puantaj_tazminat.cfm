<cfsetting showdebugoutput="no">

<cfset p_baslangic = createodbcdatetime(createdatetime(attributes.sal_year,attributes.sal_mon,1))>
<cfset aydaki_gun_sayisi = daysinmonth(p_baslangic)>
<cfset p_bitis = createodbcdatetime(createdatetime(attributes.sal_year,attributes.sal_mon,aydaki_gun_sayisi))>


<cfquery name="get_emps" datasource="#dsn#">
SELECT DISTINCT
	*
FROM
	(
	SELECT
		E.EMPLOYEE_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		EIO.IN_OUT_ID,
		EIO.START_DATE,
		EIO.FINISH_DATE,
        EIO.DUTY_TYPE,
        EIO.SSK_STATUTE,
        EIO.PUANTAJ_GROUP_IDS,
        EI.TC_IDENTY_NO,
        EP.PUANTAJ_ID,
        EIO.EXPLANATION_ID,
        EPR.SSK_MATRAH,
        EPR.TOTAL_DAYS,
        EPR.SSK_DAYS,
        EPR.NET_UCRET,
        EPR.EMPLOYEE_PUANTAJ_ID,
        ISNULL((SELECT M#attributes.sal_mon# FROM EMPLOYEES_SALARY ES WHERE ES.IN_OUT_ID = EIO.IN_OUT_ID AND ES.PERIOD_YEAR = #attributes.sal_year#),0) AS MAAS,

		EPR.YILLIK_IZIN_AMOUNT_DAMGA_VERGISI,
        EPR.YILLIK_IZIN_AMOUNT_GELIR_VERGISI,
        EPR.YILLIK_IZIN_AMOUNT_SSK_ISCI_HISSESI,
        EPR.YILLIK_IZIN_AMOUNT_SSK_ISCI_ISSIZLIK,
        EPR.YILLIK_IZIN_AMOUNT_SSK_ISVEREN_HISSESI,
        EPR.YILLIK_IZIN_AMOUNT_SSK_ISVEREN_ISSIZLIK,
        EPR.YILLIK_IZIN_AMOUNT,
        EPR.YILLIK_IZIN_AMOUNT_NET,
    
        EPR.IHBAR_AMOUNT,
        EPR.IHBAR_AMOUNT_NET,
        EPR.IHBAR_AMOUNT_DAMGA_VERGISI,
        EPR.IHBAR_AMOUNT_GELIR_VERGISI,
    
        EPR.KIDEM_AMOUNT,
        EPR.KIDEM_AMOUNT_NET,
        EPR.KIDEM_AMOUNT_DAMGA_VERGISI,

        EIO.GROSS_NET
	FROM
		EMPLOYEES_PUANTAJ EP,
        EMPLOYEES_PUANTAJ_ROWS EPR,
        EMPLOYEES_IN_OUT EIO,
		EMPLOYEES_IDENTY EI,
		EMPLOYEES E
	WHERE
		EIO.BRANCH_ID = #attributes.ssk_office# AND
        EIO.IN_OUT_ID = EPR.IN_OUT_ID AND
        EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND
        EP.SAL_YEAR = #attributes.sal_year# AND
        EP.SAL_MON = #attributes.sal_mon# AND
		EIO.START_DATE <= #p_bitis# AND
		(EIO.FINISH_DATE >= #p_baslangic# OR EIO.FINISH_DATE IS NULL) AND
		EI.EMPLOYEE_ID = E.EMPLOYEE_ID AND
		E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
	) T1
ORDER BY
	EMPLOYEE_NAME ASC,
	EMPLOYEE_SURNAME ASC
</cfquery>

<cfif get_emps.recordcount>
    <cfquery name="GET_PUANTAJ" datasource="#dsn#">
        SELECT
            *
        FROM
            EMPLOYEES_PUANTAJ
        WHERE
            PUANTAJ_ID IN (#listdeleteduplicates(valuelist(get_emps.puantaj_id))#)
            AND
            IS_LOCKED = 1
    </cfquery>
</cfif>

<cf_ajax_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='58577.Sıra'></th>
            <th><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
            <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
			
            <th><cf_get_lang dictionary_id='53702.İşe Giriş'></th>
            <th><cf_get_lang dictionary_id='29832.İşten Çıkış'></th>
            
            <th><cf_get_lang dictionary_id='690.Çalışma Gün Sayısı'></th>
            <th><cf_get_lang dictionary_id='64884.Çıkış Nedeni'></th>
            <th><cf_get_lang dictionary_id='57982.Tür'></th>
            <th><cf_get_lang dictionary_id='64875.Sabit Maaş'></th>
            <th></th>
            
            <th><cf_get_lang dictionary_id='64885.Kıdem Brüt'></th>
            <th><cf_get_lang dictionary_id='64886.Kıdem Damga V.'></th>
            <th><cf_get_lang dictionary_id='64887.Kıdem Net'></th>
            <th></th>
            
            <th><cf_get_lang dictionary_id='64888.İhbar Brüt'></th>
            <th><cf_get_lang dictionary_id='64889.İhbar Damga V.'></th>
            <th><cf_get_lang dictionary_id='64890.İhbar Gelir V.'></th>
            <th><cf_get_lang dictionary_id='64891.İhbar Net'></th>
            <th></th>
            
            
            <th><cf_get_lang dictionary_id='64892.Yıllık İzin Brüt'></th>
            <th><cf_get_lang dictionary_id='64893.Yıllık İzin Damga V.'></th>
            <th><cf_get_lang dictionary_id='64894.Yıllık İzin Gelir V.'></th>
            <th><cf_get_lang dictionary_id='64895.Yıllık İzin İşçi'></th>
            <th><cf_get_lang dictionary_id='64896.Yıllık İzin İşçi İşsizlik'></th>
            <th><cf_get_lang dictionary_id='64897.Yıllık İzin Net'></th>
        </tr>
	</thead>
	<tbody>
	<cfset gun_toplam = 0>
    <cfset maas_toplam = 0>
    
    <cfset T_KIDEM_AMOUNT = 0>
    <cfset T_KIDEM_AMOUNT_NET = 0>
    <cfset T_KIDEM_AMOUNT_DAMGA = 0>
    
    <cfset T_IHBAR_AMOUNT = 0>
    <cfset T_IHBAR_AMOUNT_NET = 0>
    <cfset T_IHBAR_AMOUNT_DAMGA = 0>
    <cfset T_IHBAR_AMOUNT_GELIR = 0>
    
    <cfset T_YILLIK_IZIN_AMOUNT = 0>
    <cfset T_YILLIK_IZIN_AMOUNT_DAMGA = 0>
    <cfset T_YILLIK_IZIN_AMOUNT_GELIR = 0>
    <cfset T_YILLIK_IZIN_AMOUNT_ISVEREN = 0>
    <cfset T_YILLIK_IZIN_AMOUNT_ISVEREN_ISSIZLIK = 0>
    <cfset T_YILLIK_IZIN_AMOUNT_ISCI = 0>
    <cfset T_YILLIK_IZIN_AMOUNT_ISCI_ISSIZLIK = 0>
    <cfset T_YILLIK_IZIN_AMOUNT_NET = 0>
    
    <cfset brut_maas_toplam = 0>
    <cfset fazla_mesai_toplam = 0>
    <cfset ek_kazanc_toplam = 0>
    <cfset toplam_kazanc_toplam = 0>
    
    <cfset isveren_ssk_toplam = 0>
    <cfset issizlik_isveren_toplam = 0>
    
    <cfset toplam_maliyet = 0>
    
    <cfset toplam_ssk_matrah = 0>
    
    
    <cfset kisi_sayisi = 0>
	<cfoutput query="get_emps">
		<cfset employee_id_ = employee_id>
		<cfif year(start_date) eq year(p_baslangic) and month(start_date) eq month(p_baslangic)>
			<cfset kisi_start = start_date>
			<cfset bu_ay_basladi = 1>
		<cfelse>
			<cfset kisi_start = p_baslangic>
			<cfset bu_ay_basladi = 0>
		</cfif>
		<cfif len(FINISH_DATE) and year(FINISH_DATE) eq year(p_bitis) and month(FINISH_DATE) eq month(p_bitis)>
			<cfset kisi_finish= FINISH_DATE>
			<cfset bu_ay_cikti = 1>
		<cfelse>
			<cfset kisi_finish = p_bitis>
			<cfset bu_ay_cikti = 0>
		</cfif>
    <cfif bu_ay_cikti eq 1> 
		<cfset calisma_gun_sayisi = datediff('d',kisi_start,kisi_finish)+1>

		<cfset reel_calisma_gun_sayisi = datediff('d',kisi_start,kisi_finish)+1>
		<cfif isdefined("kisi_ucretsiz_total_#employee_id#")>
			<cfset calisma_gun_sayisi = calisma_gun_sayisi - evaluate("kisi_ucretsiz_total_#employee_id#")>
		</cfif>
		
		<cfif calisma_gun_sayisi eq 31>
			<cfset calisma_gun_sayisi = 30>
		</cfif>
		<cfset gun_toplam = gun_toplam + ssk_days>
        <cfset kisi_sayisi = kisi_sayisi + 1>
		<tr class="color-row">
			<td>#kisi_sayisi#</td>
			<td>
            	#tc_identy_no#
            </td>
			<td nowrap="nowrap">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#
            	<cfif DUTY_TYPE eq 6>(<cf_get_lang dictionary_id='55896.Kısmi İstihdam'>)</cfif>
                <cfif (SSK_STATUTE eq 2 or SSK_STATUTE eq 18)>(<cf_get_lang dictionary_id='58541.Emekli'>)</cfif>
            </td>

            <td>#dateformat(start_Date,'dd/mm/yyyy')#</td>
            <td>#dateformat(finish_date,'dd/mm/yyyy')#</td>
            
            <td style="text-align:right;">#ssk_days#</td>
            <td>#get_explanation_name(EXPLANATION_ID)#</td>
            <td><cfif GROSS_NET eq 0><cf_get_lang dictionary_id='56257.Brüt'><cfelse><cf_get_lang dictionary_id='58083.Net'></cfif></td>
            <td style="text-align:right;">#tlformat(MAAS)#<cfset maas_toplam = maas_toplam + MAAS></td>
            <td class="color-border"></td>
            
            <td style="text-align:right;">#tlformat(KIDEM_AMOUNT)#</td>
            <td style="text-align:right;">#tlformat(KIDEM_AMOUNT_DAMGA_VERGISI)#</td>
            <td style="text-align:right; font-weight:bold;">#tlformat(KIDEM_AMOUNT_NET)#</td>
            <td class="color-border"></td>
            
            <td style="text-align:right;">#tlformat(IHBAR_AMOUNT)#</td>
            <td style="text-align:right;">#tlformat(IHBAR_AMOUNT_DAMGA_VERGISI)#</td>
            <td style="text-align:right;">#tlformat(IHBAR_AMOUNT_GELIR_VERGISI)#</td>
            <td style="text-align:right;font-weight:bold;">#tlformat(IHBAR_AMOUNT_NET)#</td>
            <td class="color-border"></td>
            
            <td style="text-align:right;">#tlformat(YILLIK_IZIN_AMOUNT)#</td>
            <td style="text-align:right;">#tlformat(YILLIK_IZIN_AMOUNT_DAMGA_VERGISI)#</td>
            <td style="text-align:right;">#tlformat(YILLIK_IZIN_AMOUNT_GELIR_VERGISI)#</td>
            <td style="text-align:right;">#tlformat(YILLIK_IZIN_AMOUNT_SSK_ISCI_HISSESI)#</td>
            <td style="text-align:right;">#tlformat(YILLIK_IZIN_AMOUNT_SSK_ISCI_ISSIZLIK)#</td>
            <td style="text-align:right; font-weight:bold;">#tlformat(YILLIK_IZIN_AMOUNT_NET)#</td>
		</tr>
        
		<cfset T_KIDEM_AMOUNT = T_KIDEM_AMOUNT + KIDEM_AMOUNT>
		<cfset T_KIDEM_AMOUNT_NET = T_KIDEM_AMOUNT_NET + KIDEM_AMOUNT_NET>
        <cfset T_IHBAR_AMOUNT = T_IHBAR_AMOUNT + IHBAR_AMOUNT>
        <cfset T_IHBAR_AMOUNT_NET = T_IHBAR_AMOUNT_NET + IHBAR_AMOUNT_NET>
        <cfset T_YILLIK_IZIN_AMOUNT = T_YILLIK_IZIN_AMOUNT + YILLIK_IZIN_AMOUNT>
        <cfset T_YILLIK_IZIN_AMOUNT_NET = T_YILLIK_IZIN_AMOUNT_NET + YILLIK_IZIN_AMOUNT_NET>
        <cfset T_KIDEM_AMOUNT_DAMGA = T_KIDEM_AMOUNT_DAMGA + KIDEM_AMOUNT_DAMGA_VERGISI>
        <cfset T_IHBAR_AMOUNT_DAMGA = T_IHBAR_AMOUNT_DAMGA + IHBAR_AMOUNT_DAMGA_VERGISI>
		<cfset T_IHBAR_AMOUNT_GELIR = T_IHBAR_AMOUNT_DAMGA + IHBAR_AMOUNT_GELIR_VERGISI>
        <cfset T_YILLIK_IZIN_AMOUNT_DAMGA = T_YILLIK_IZIN_AMOUNT_DAMGA + YILLIK_IZIN_AMOUNT_DAMGA_VERGISI>
		<cfset T_YILLIK_IZIN_AMOUNT_GELIR = T_YILLIK_IZIN_AMOUNT_GELIR + YILLIK_IZIN_AMOUNT_GELIR_VERGISI>
        <cfset T_YILLIK_IZIN_AMOUNT_ISVEREN = T_YILLIK_IZIN_AMOUNT_ISVEREN + YILLIK_IZIN_AMOUNT_SSK_ISVEREN_HISSESI>
        <cfset T_YILLIK_IZIN_AMOUNT_ISVEREN_ISSIZLIK = T_YILLIK_IZIN_AMOUNT_ISVEREN_ISSIZLIK + YILLIK_IZIN_AMOUNT_SSK_ISVEREN_HISSESI>
        <cfset T_YILLIK_IZIN_AMOUNT_ISCI = T_YILLIK_IZIN_AMOUNT_ISCI + YILLIK_IZIN_AMOUNT_SSK_ISCI_HISSESI>
        <cfset T_YILLIK_IZIN_AMOUNT_ISCI_ISSIZLIK = T_YILLIK_IZIN_AMOUNT_ISCI_ISSIZLIK + YILLIK_IZIN_AMOUNT_SSK_ISCI_ISSIZLIK>
    </cfif>
	</cfoutput>
	</tbody>
	<tfoot>
	<cfoutput>
		<tr class="color-list">
			<td colspan="2" class="formbold" style="text-align:right;"><cf_get_lang dictionary_id='53263.Toplamlar'></td>
			<td style="text-align:center;" class="formbold">#kisi_sayisi# <cf_get_lang dictionary_id='29831.Kişi'></td>
			<td style="text-align:center;" colspan="2">&nbsp;</td>
            <td style="text-align:right;" class="formbold">#gun_toplam#</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td style="text-align:right;" class="formbold">#tlformat(maas_toplam)#</td>
            <td class="color-border"></td>
            
            <td style="text-align:right;" class="formbold">#tlformat(T_KIDEM_AMOUNT)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(T_KIDEM_AMOUNT_DAMGA)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(T_KIDEM_AMOUNT_NET)#</td>
            <td class="color-border"></td>
            
            <td style="text-align:right;" class="formbold">#tlformat(T_IHBAR_AMOUNT)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(T_IHBAR_AMOUNT_DAMGA)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(T_IHBAR_AMOUNT_GELIR)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(T_IHBAR_AMOUNT_NET)#</td>
            <td class="color-border"></td>
            
            <td style="text-align:right;" class="formbold">#tlformat(T_YILLIK_IZIN_AMOUNT)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(T_YILLIK_IZIN_AMOUNT_DAMGA)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(T_YILLIK_IZIN_AMOUNT_GELIR)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(T_YILLIK_IZIN_AMOUNT_ISCI)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(T_YILLIK_IZIN_AMOUNT_ISCI_ISSIZLIK)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(T_YILLIK_IZIN_AMOUNT_NET)#</td>
		</tr>
	</cfoutput>
	</tfoot>
</cf_ajax_list>