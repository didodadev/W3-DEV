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
		(
        SELECT TOP 1
            B.BANK_NAME
        FROM
            EMPLOYEES_BANK_ACCOUNTS BA,
            SETUP_BANK_TYPES B
        WHERE
            BA.BANK_ID = B.BANK_ID AND
            BA.EMP_BANK_ID = EPR.EMP_BANK_ID
        ) AS BANKA_ADI,
        (
        SELECT TOP 1
            BA.BANK_ACCOUNT_NO
        FROM
            EMPLOYEES_BANK_ACCOUNTS BA,
            SETUP_BANK_TYPES B
        WHERE
            BA.BANK_ID = B.BANK_ID AND
            BA.EMP_BANK_ID = EPR.EMP_BANK_ID
        ) AS BANKA_HESAP,
        E.EMPLOYEE_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
        EI.LAST_SURNAME,
		EIO.IN_OUT_ID,
		EIO.START_DATE,
		EIO.FINISH_DATE,
        EIO.DUTY_TYPE,
        EIO.SSK_STATUTE,
        EI.TC_IDENTY_NO,
        EP.PUANTAJ_ID,
        EPR.SSK_MATRAH,
        EPR.TOTAL_DAYS,
        EPR.SSK_DAYS,
        EPR.NET_UCRET,
        EPR.VERGI_IADESI,
		EPR.EXT_SALARY_NET,
        (EPR.NET_UCRET - EPR.VERGI_IADESI) AGI_ONCESI_NET,
        EPR.EMPLOYEE_PUANTAJ_ID,
        ISNULL((SELECT TOP 1 SS.WEEK_OFFDAY FROM SETUP_SHIFTS SS WHERE SS.SHIFT_ID = EIO.SHIFT_ID),1) AS HAFTA_TATILI,
        ISNULL((SELECT TOP 1 M#attributes.sal_mon# FROM EMPLOYEES_SALARY ES WHERE ES.IN_OUT_ID = EIO.IN_OUT_ID AND ES.PERIOD_YEAR = #attributes.sal_year#),0) AS MAAS,
        (WEEKLY_AMOUNT + WEEKEND_AMOUNT + OFFDAYS_AMOUNT + IZIN_PAID_AMOUNT) BRUT_UCRET,
        (EPR.TOTAL_PAY_SSK + EPR.TOTAL_PAY_SSK_TAX + EPR.TOTAL_PAY_TAX + EPR.TOTAL_PAY) EK_ODENEKLER,
        (SSK_ISVEREN_HISSESI + SSDF_ISVEREN_HISSESI) AS ISVEREN_SSK,
        (ISSIZLIK_ISVEREN_HISSESI) AS ISVEREN_ISSIZLIK,
        (TOTAL_SALARY + (SSK_ISVEREN_HISSESI + SSDF_ISVEREN_HISSESI) + ISSIZLIK_ISVEREN_HISSESI) AS ISCI_TOPLAM_MALIYET,
        AVANS,
        OZEL_KESINTI,
        OZEL_KESINTI_2,
        EPR.EXT_SALARY,
        (EPR.NET_UCRET + EPR.AVANS + EPR.OZEL_KESINTI + EPR.OZEL_KESINTI_2 + EPR.VERGI_IADESI) AS KESINTI_VE_AGI_ONCESI_NET,
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
    <cfquery name="get_net_sorunlu_calisanlar" dbtype="query">
        SELECT * FROM get_emps WHERE AGI_ONCESI_NET < 0 OR NET_UCRET < 0
    </cfquery>
    <cfif get_net_sorunlu_calisanlar.recordcount>
    	<b style="color:red;" class="yanip-sonen"><cf_get_lang dictionary_id='64898.Proformanızda Net Ücreti Sıfır (0) dan düşük ücretli çalışan bulunmaktadır!'></b>
        <br />
    </cfif>
</cfif>

<cfif get_emps.recordcount>
	<cfset emp_p_list = valuelist(get_emps.EMPLOYEE_PUANTAJ_ID)>
    <cfquery name="get_odenekler" datasource="#dsn#">
    	SELECT
        *,
        ISNULL((SELECT SL.ITEM FROM SETUP_LANGUAGE_INFO AS SL WHERE (SL.UNIQUE_COLUMN_ID= EPR.COMMENT_PAY_ID OR SL.ITEM = EPR.COMMENT_PAY) AND SL.TABLE_NAME= 'SETUP_PAYMENT_INTERRUPTION' AND SL.LANGUAGE='#ucase(session.ep.language)#' GROUP BY SL.ITEM),COMMENT_PAY) AS COMMENT_PAY_NAME
        FROM EMPLOYEES_PUANTAJ_ROWS_EXT EPR WHERE EXT_TYPE = 0 AND EMPLOYEE_PUANTAJ_ID IN (#emp_p_list#)
    </cfquery>
    <cfif get_odenekler.recordcount>
    	<cfquery name="get_odenek_adlar" dbtype="query">
        	SELECT DISTINCT COMMENT_PAY,COMMENT_PAY_NAME FROM get_odenekler
        </cfquery>
    </cfif>
    
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

<cfif isdefined("get_odenek_adlar.recordcount")>
	<cfset odenek_sayi = get_odenek_adlar.recordcount>
    <cfoutput query="get_odenek_adlar">
    	<cfset 'odenek_total_#currentrow#' = 0>
    </cfoutput>
<cfelse>
	<cfset odenek_sayi = 0>
</cfif>

<cf_ajax_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='58577.Sıra'></th>
            <th><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
            <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
			<th><cf_get_lang dictionary_id='57521.Banka'></th>
            <th><cf_get_lang dictionary_id='58178.Hesap No'></th>
            <th style="text-align:right;"><cf_get_lang dictionary_id='690.Çalışma Gün Sayısı'></th>
            <th><cf_get_lang dictionary_id='57982.Tür'></th>
            <th style="text-align:right;"><cf_get_lang dictionary_id='64875.Sabit Maaş'></th>
            <th style="text-align:right;"><cf_get_lang dictionary_id='46143.Çalışılan Gün Maaş'></th>
            <th style="text-align:right;"><cf_get_lang dictionary_id='64629.Brüt Maaş'></th>
            <th style="text-align:right;"><cf_get_lang dictionary_id='39709.Net Maaş'></th>
			<th style="text-align:right;"><cf_get_lang dictionary_id='64494.Fazla Mesai Net'></th>
            <cfif odenek_sayi gt 0>
            	<cfoutput query="get_odenek_adlar">
            	<th style="text-align:right;">#COMMENT_PAY_NAME# <cf_get_lang dictionary_id='49337.Net Tutar'></th>
                </cfoutput>
            </cfif>
            <th style="text-align:right;"><cf_get_lang dictionary_id='49337.Net Tutar'></th>
            <th style="text-align:right;"><cf_get_lang dictionary_id='39964.AGİ'></th>
            <th style="text-align:right;"><cf_get_lang dictionary_id='48543.Ödeme Tutarı'></th>
        </tr>
	</thead>
	<tbody>
	<cfset gun_toplam = 0>
    <cfset maas_toplam = 0>
    <cfset c_maas_toplam = 0>
    <cfset brut_maas_toplam = 0>
    
    <cfset yt_toplam = 0>
    
    <cfset net_toplam = 0>
    <cfset kesinti_toplam = 0>
    <cfset agi_toplam = 0>
    <cfset odeme_toplam = 0>
	
	<cfset fm_toplam = 0>
        
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

		<cfset calisma_gun_sayisi = datediff('d',kisi_start,kisi_finish)+1>
        
		<cfset reel_calisma_gun_sayisi = datediff('d',kisi_start,kisi_finish)+1>
		<cfif isdefined("kisi_ucretsiz_total_#employee_id#")>
			<cfset calisma_gun_sayisi = calisma_gun_sayisi - evaluate("kisi_ucretsiz_total_#employee_id#")>
		</cfif>
		
		<cfif calisma_gun_sayisi eq 31>
			<cfset calisma_gun_sayisi = 30>
		</cfif>
		<cfset gun_toplam = gun_toplam + ssk_days>
        <cfset tc_identy_no_ = tc_identy_no>
		<tr class="color-row">
			<td>#currentrow#</td>
			<td>
            <cfif listgetat(session.ep.user_level, 3)>
            	<a href="#request.self#?fuseaction=hr.form_upd_emp&employee_id=#employee_id#" target="hr_profil" class="tableyazi">#tc_identy_no#</a>
            <cfelse>
                #tc_identy_no#
            </cfif>
            </td>
			<td nowrap="nowrap"><a href="javascript://" style="color:<cfif bu_ay_basladi eq 1>green<cfelseif bu_ay_cikti eq 1>red<cfelseif reel_calisma_gun_sayisi lt aydaki_gun_sayisi>blue</cfif>;" onclick="windowopen('<cfif GET_PUANTAJ.recordcount or session.ep.ehesap>index.cfm?fuseaction=<cfif session.ep.ehesap>ehesap<cfelse>proforma</cfif>.popup_view_price_compass&style=one&employee_puantaj_id=#EMPLOYEE_PUANTAJ_ID#&employee_id=#employee_id#&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&puantaj_type=-1','wwide');<cfelse>alert('Puantajlar Oluşturulmadı!');</cfif>" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# #LAST_SURNAME#</a>
            	<cfif DUTY_TYPE eq 6>(<cf_get_lang dictionary_id='55896.Kısmi İstihdam'>)</cfif>
                 <cfif SSK_STATUTE eq 2 or SSK_STATUTE eq 18>(<cf_get_lang dictionary_id='58541.Emekli'>)</cfif><!---Muzaffer Yeraltı Emeli--->
            </td>
            <td nowrap="nowrap">#BANKA_ADI#</td>
            <td nowrap="nowrap"><cfif len(BANKA_HESAP)>#BANKA_HESAP#<cfelse><a href="javascript://" onclick="windowopen('index.cfm?fuseaction=objects.popup_form_add_bank_account&employee_id=#employee_id#&employee_puantaj_id=#employee_puantaj_id#','medium')" class="tableyazi"><cf_get_lang dictionary_id='46125.Tanımla'></a></cfif></td>
            <td style="text-align:right;">#ssk_days#</td>
            <td><cfif GROSS_NET eq 0><cf_get_lang dictionary_id='56257.Brüt'><cfelse><cf_get_lang dictionary_id='58083.Net'></cfif></td>
            <td style="text-align:right;">#tlformat(MAAS)#<cfset maas_toplam = maas_toplam + MAAS></td>
            <td style="text-align:right;">#tlformat(MAAS / 30 * ssk_days)#<cfset c_maas_toplam = c_maas_toplam + (MAAS / 30 * ssk_days)></td>
            <td style="text-align:right;">#tlformat(BRUT_UCRET)#<cfset brut_maas_toplam = brut_maas_toplam + BRUT_UCRET></td>
            <cfset EMPLOYEE_PUANTAJ_ID_ = EMPLOYEE_PUANTAJ_ID>
            <cfset row_net_odenek_toplam = 0>
            
            <cfset kesinti_toplam = kesinti_toplam + OZEL_KESINTI>
            
			<cfif odenek_sayi gt 0>
            	<cfset count_ = 0>
                <cfloop query="get_odenek_adlar">
					<cfset count_ = count_ + 1>
                    <cfset odenek_ad_ = comment_pay>
                    <cfquery name="get_odenek" dbtype="query">
                        SELECT SUM(AMOUNT_PAY) AS T_AMOUNT FROM get_odenekler WHERE EMPLOYEE_PUANTAJ_ID = #EMPLOYEE_PUANTAJ_ID_# AND COMMENT_PAY = '#odenek_ad_#'
                    </cfquery>
					<cfquery name="get_odenek_All" dbtype="query">
                        SELECT * FROM get_odenekler WHERE EMPLOYEE_PUANTAJ_ID = #EMPLOYEE_PUANTAJ_ID_# AND COMMENT_PAY = '#odenek_ad_#'
                    </cfquery>
                    <cfif get_odenek.recordcount and len(get_odenek.T_AMOUNT)>
                        <cfset odenek_ = get_odenek.T_AMOUNT>
                    <cfelse>
                        <cfset odenek_ = 0>
                    </cfif>
					<cfset row_net_odenek_toplam = row_net_odenek_toplam + odenek_>
                </cfloop>
            </cfif>
            <td style="text-align:right;">
            	<cfif agi_oncesi_net lt 0>
                	<b style="color:red;" class="yanip-sonen">#tlformat(AGI_ONCESI_NET-row_net_odenek_toplam + OZEL_KESINTI - ext_salary_net)#</b>
                <cfelse>
                	#tlformat(AGI_ONCESI_NET-row_net_odenek_toplam + OZEL_KESINTI - ext_salary_net)#
                </cfif>
            </td>
			<td style="text-align:right;">#tlformat(ext_salary_net)#</td>
			<cfset row_net_odenek_toplam = 0>
			<cfif odenek_sayi gt 0>
            	<cfset count_ = 0>
                <cfloop query="get_odenek_adlar">
                <cfset count_ = count_ + 1>
                <cfset odenek_ad_ = comment_pay>
                <cfquery name="get_odenek" dbtype="query">
                	SELECT SUM(AMOUNT_PAY) AS T_AMOUNT FROM get_odenekler WHERE EMPLOYEE_PUANTAJ_ID = #EMPLOYEE_PUANTAJ_ID_# AND COMMENT_PAY = '#odenek_ad_#'
                </cfquery>
                <cfif get_odenek.recordcount and len(get_odenek.T_AMOUNT)>
                	<cfset odenek_ = get_odenek.T_AMOUNT>
                <cfelse>
                	<cfset odenek_ = 0>
                </cfif>
                <cfset 'odenek_total_#count_#' = evaluate('odenek_total_#count_#') + odenek_>
            	<td style="text-align:right;">#tlformat(odenek_)#</th>
                <cfset row_net_odenek_toplam = row_net_odenek_toplam + odenek_>
                </cfloop>
            </cfif>
            <td style="text-align:right;"><cfif agi_oncesi_net lt 0><b style="color:red;" class="yanip-sonen">#tlformat(AGI_ONCESI_NET)#</b><cfelse>#tlformat(AGI_ONCESI_NET)#</cfif></td>
            <td style="text-align:right;">#tlformat(VERGI_IADESI)#</td>
            <td style="text-align:right;">#tlformat(NET_UCRET)#</td>
		</tr>
        <cfset net_toplam = net_toplam + (NET_UCRET - VERGI_IADESI)>
		<cfset agi_toplam = agi_toplam + VERGI_IADESI>
        <cfset odeme_toplam = odeme_toplam + NET_UCRET>
		<cfset fm_toplam = fm_toplam + ext_salary_net>
	</cfoutput>
	</tbody>
	<tfoot>
	<cfoutput>
		<tr class="color-list">
			<td colspan="2" class="formbold" style="text-align:right;"><cf_get_lang dictionary_id='53263.Toplamlar'></td>
			<td style="text-align:center;" class="formbold">#get_emps.recordcount# <cf_get_lang dictionary_id='29831.Kişi'></td>
			<td style="text-align:center;" colspan="2">&nbsp;</td>
            <td style="text-align:right;" class="formbold">#gun_toplam#</td>
            <td>&nbsp;</td>
            <td style="text-align:right;" class="formbold">#tlformat(maas_toplam)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(c_maas_toplam)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(brut_maas_toplam)#</td>
            <cfset row_odenek_toplam = 0>
			<cfif odenek_sayi gt 0>
            	<cfset count_ = 0>
            	<cfloop query="get_odenek_adlar">
                	<cfset count_ = count_ + 1>
                	<cfset row_odenek_toplam = row_odenek_toplam + evaluate('odenek_total_#count_#')>
                </cfloop>
            </cfif>
            <td style="text-align:right;" class="formbold">#tlformat(net_toplam - row_odenek_toplam + kesinti_toplam - fm_toplam)#</td>
			<td style="text-align:right;" class="formbold">#tlformat(fm_toplam)#</td>
            <cfset row_odenek_toplam = 0>
			<cfif odenek_sayi gt 0>
            	<cfset count_ = 0>
            	<cfloop query="get_odenek_adlar">
                	<cfset count_ = count_ + 1>
                    <td style="text-align:right;" class="formbold">#tlformat(evaluate('odenek_total_#count_#'))#</td>
                	<cfset row_odenek_toplam = row_odenek_toplam + evaluate('odenek_total_#count_#')>
                </cfloop>
            </cfif>
            <td style="text-align:right;" class="formbold">#tlformat(net_toplam)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(agi_toplam)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(odeme_toplam)#</td>
		</tr>
	</cfoutput>
	</tfoot>
</cf_ajax_list>
<script>
$(document).ready(function(){
  setInterval(function(){
	if($(".yanip-sonen").css("visibility") == "visible")
	{
	  $(".yanip-sonen").css("visibility","hidden");
	}
	else
	{
	  $(".yanip-sonen").css("visibility","visible");
	}
  },200);
});
</script>