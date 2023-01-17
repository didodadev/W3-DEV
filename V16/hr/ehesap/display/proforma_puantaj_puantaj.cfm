<cfsetting showdebugoutput="no">

<cfset p_baslangic = createodbcdatetime(createdatetime(attributes.sal_year,attributes.sal_mon,1))>
<cfset aydaki_gun_sayisi = daysinmonth(p_baslangic)>
<cfset p_bitis = createodbcdatetime(createdatetime(attributes.sal_year,attributes.sal_mon,aydaki_gun_sayisi))>

<cfquery name="get_emps" datasource="#dsn#" result="AAA">
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
        EI.TC_IDENTY_NO,
        EP.PUANTAJ_ID,
        EPR.SSK_MATRAH,
        EPR.TOTAL_DAYS,
        EPR.SSK_DAYS,
        EPR.NET_UCRET,
        EPR.EMPLOYEE_PUANTAJ_ID,
        ISNULL((SELECT TOP 1 M#attributes.sal_mon# FROM EMPLOYEES_SALARY ES WHERE ES.IN_OUT_ID = EIO.IN_OUT_ID AND ES.PERIOD_YEAR = #attributes.sal_year#),0) AS MAAS,
        (WEEKLY_AMOUNT + WEEKEND_AMOUNT + OFFDAYS_AMOUNT + IZIN_PAID_AMOUNT) BRUT_UCRET,
        (EPR.TOTAL_PAY_SSK + EPR.TOTAL_PAY_SSK_TAX + EPR.TOTAL_PAY_TAX + EPR.TOTAL_PAY) EK_ODENEKLER,
        SSK_ISVEREN_CARPAN,
        (SSK_ISVEREN_HISSESI + SSDF_ISVEREN_HISSESI + ROUND(SSK_ISVEREN_HISSESI_5510,2)) AS ISVEREN_SSK,
        (ISSIZLIK_ISVEREN_HISSESI) AS ISVEREN_ISSIZLIK,
        (TOTAL_SALARY + (SSK_ISVEREN_HISSESI + SSDF_ISVEREN_HISSESI + ROUND(SSK_ISVEREN_HISSESI_5510,2)) + ISSIZLIK_ISVEREN_HISSESI) AS ISCI_TOPLAM_MALIYET,
        AVANS,
        OZEL_KESINTI,
        OZEL_KESINTI_2,
        EPR.EXT_SALARY,
        (EPR.NET_UCRET + EPR.AVANS + EPR.OZEL_KESINTI + EPR.OZEL_KESINTI_2 + EPR.VERGI_IADESI) AS KESINTI_VE_AGI_ONCESI_NET,
        ROUND(SSK_ISVEREN_HISSESI_5510,2) AS ISVEREN_INDIRIM,
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
<cfquery name="get_insurance_ilk" datasource="#dsn#">
    SELECT MIN_GROSS_PAYMENT_NORMAL FROM INSURANCE_PAYMENT WHERE STARTDATE <= #p_bitis# AND FINISHDATE >= #p_baslangic#
</cfquery>


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
			<th style="width:20px;text-align:center;  color:black; font-weight:bold;"><cf_get_lang dictionary_id='58577.Sıra'></th>
            <th></th>
            <th></th>
			<th style="text-align:center;  color:black; font-weight:bold;"><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
			<th style="text-align:center;  color:black; font-weight:bold;"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
			<th style="text-align:center;  color:black; font-weight:bold;"><cf_get_lang dictionary_id='690.Çalışma Gün Sayısı'></th>
            <th style="text-align:center;  color:black; font-weight:bold;"><cf_get_lang dictionary_id='57982.Tür'></th>
            <th style="text-align:center;  color:black; font-weight:bold;"><cf_get_lang dictionary_id='64875.Sabit Maaş'></th>
            <th style="text-align:center;  color:black; font-weight:bold;"><cf_get_lang dictionary_id='64629.Brüt Maaş'></th>
            <th style="text-align:center;  color:black; font-weight:bold;"><cf_get_lang dictionary_id='64876.Brüt Fazla Mesai'></th>
            <cfif odenek_sayi gt 0>
            	<cfoutput query="get_odenek_adlar">
            	<th style="text-align:center;  color:black; font-weight:bold;">#COMMENT_PAY_NAME#</th>
                </cfoutput>
            </cfif>
            <th style="text-align:center;  color:black; font-weight:bold;"><cf_get_lang dictionary_id='56257.Brüt'><cf_get_lang dictionary_id='38997.Ek Kazanç'></th>
            <th style="text-align:center;  color:black; font-weight:bold;"><cf_get_lang dictionary_id='53244.Toplam Kazanç'></th>
            <th style="text-align:center;  color:black; font-weight:bold;"><cf_get_lang dictionary_id='53245.SGK Matrahı'></th>
            <th style="text-align:center;  color:black; font-weight:bold;"><cf_get_lang dictionary_id='64877.İşveren Çarpan'></th>
            <th style="text-align:center;  color:black; font-weight:bold;"><cf_get_lang dictionary_id='64878.İşveren SGK'></th>
            <th style="text-align:center;  color:black; font-weight:bold;"><cf_get_lang dictionary_id='64879.İşveren İndirim'></th>
            <th style="text-align:center;  color:black; font-weight:bold;"><cf_get_lang dictionary_id='64880.İşveren İşsizlik'></th>
            <th style="text-align:center;  color:black; font-weight:bold;"><cf_get_lang dictionary_id='56864.Toplam Maliyet'></th>
        </tr>
	</thead>
	<tbody>
	<cfset gun_toplam = 0>
    <cfset maas_toplam = 0>
    <cfset brut_maas_toplam = 0>
    <cfset fazla_mesai_toplam = 0>
    <cfset ek_kazanc_toplam = 0>
    <cfset toplam_kazanc_toplam = 0>
    
    <cfset isveren_ssk_toplam = 0>
    <cfset issizlik_isveren_toplam = 0>
    <cfset isveren_indirim_toplam = 0>
    
    <cfset toplam_maliyet = 0>
    
    <cfset toplam_ssk_matrah = 0>
    
    
    <cfset bolge_list = ''>
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
        
		<tr class="color-row">
			<td>#currentrow#</td>
            <td nowrap>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='54138.Çalışanın puantaj satırlarını siliyorsunuz. Emin misiniz?'></cfsavecontent>
                <a href="javascript://" onClick="if (confirm('#message#')) delet_puantaj_row_('#employee_puantaj_id#'); else return false;"><i class="fa fa-minus" title="<cf_get_lang_main no='51.Sil'>"></i></a>
                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_list_employee_payroll&employee_puantaj_id=#employee_puantaj_id#&employee_id=#employee_id#&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&in_out_id=#in_out_id#','page')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='53012.Puantaj Güncelle'>"></i></a>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='53343.Çalışanın Puantajı Varsa Sıfırlanarak  Yeniden Oluşturulacak'></cfsavecontent>
                <a href="##" onClick="if (confirm('#message#')) {create_puantaj('#employee_id#'); AjaxPageLoad('#request.self#?fuseaction=ehesap.emptypopup_ajax_view_puantaj&branch_or_user=1<cfif x_select_puantaj_type eq 1>&detail_select=#attributes.detail_select#</cfif>&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&branch_id=#attributes.branch_id#&max_row=#attributes.MAXROWS#&start_row=#attributes.startrow#&PUANTAJ_TYPE=#attributes.PUANTAJ_TYPE#&ssk_office=#attributes.ssk_office#&puantaj_id=#attributes.puantaj_id#&defaultOpen=sayfa_8','puantaj_list_layer','1','yükleniyor.');}else return false;">
                    <i class="fa fa-lg fa-refresh" title="<cf_get_lang dictionary_id='38599.Yeniden Hesapla'>"></i>
                </a>
            </td>
            <td style="text-align:center">
                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_view_price_compass&style=one&employee_puantaj_id=#employee_puantaj_id#&employee_id=#employee_id#&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&puantaj_type=-1','page')"><i class="fa fa-print"  title="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a>
			<td>
            <cfif listgetat(session.ep.user_level, 3)>
            	<a href="#request.self#?fuseaction=hr.form_upd_emp&employee_id=#employee_id#" target="hr_profil" class="tableyazi">#tc_identy_no#</a>
            <cfelse>
            	#tc_identy_no#
            </cfif>
            </td>
			<td nowrap="nowrap">
            	<a href="javascript://" style="color:<cfif bu_ay_basladi eq 1>green<cfelseif bu_ay_cikti eq 1>red<cfelseif reel_calisma_gun_sayisi lt aydaki_gun_sayisi>blue</cfif>;" onclick="<cfif GET_PUANTAJ.recordcount or session.ep.ehesap>windowopen('index.cfm?fuseaction=<cfif session.ep.ehesap>ehesap<cfelse>proforma</cfif>.popup_view_price_compass&style=one&employee_puantaj_id=#EMPLOYEE_PUANTAJ_ID#&employee_id=#employee_id#&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&puantaj_type=-1','wwide');<cfelse>alert('<cf_get_lang dictionary_id='64881.Puantajlar Oluşturulmadı!'>!');</cfif>" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a>
            	<cfif DUTY_TYPE eq 6>(<cf_get_lang dictionary_id='55896.Kısmi İstihdam'>)</cfif>
                <cfif (SSK_STATUTE eq 2 or SSK_STATUTE eq 18)>(<cf_get_lang dictionary_id='58541.Emekli'>)</cfif><!--Yeraltı Emekli-->
            </td>
            <td style="text-align:right;">#ssk_days#</td>
            <td><cfif GROSS_NET eq 0><cf_get_lang dictionary_id='56257.Brüt'><cfelse><cf_get_lang dictionary_id='58083.Net'></cfif></td>
            <td style="text-align:right;">#tlformat(MAAS)#<cfset maas_toplam = maas_toplam + MAAS></td>
            <td style="text-align:right;">#tlformat(BRUT_UCRET)#<cfset brut_maas_toplam = brut_maas_toplam + BRUT_UCRET></td>
            <td style="text-align:right;">#tlformat(EXT_SALARY)#<cfset fazla_mesai_toplam = fazla_mesai_toplam + EXT_SALARY></td>
            <cfset EMPLOYEE_PUANTAJ_ID_ = EMPLOYEE_PUANTAJ_ID>
			<cfif odenek_sayi gt 0>
            	<cfset count_ = 0>
                <cfloop query="get_odenek_adlar">
                <cfset count_ = count_ + 1>
                <cfset odenek_ad_ = comment_pay>
                <cfquery name="get_odenek" dbtype="query">
                	SELECT SUM(AMOUNT) AS T_AMOUNT FROM get_odenekler WHERE EMPLOYEE_PUANTAJ_ID = #EMPLOYEE_PUANTAJ_ID_# AND COMMENT_PAY = '#odenek_ad_#'
                </cfquery>
                <cfif get_odenek.recordcount and len(get_odenek.T_AMOUNT)>
                	<cfset odenek_ = get_odenek.T_AMOUNT>
                <cfelse>
                	<cfset odenek_ = 0>
                </cfif>
                <cfset 'odenek_total_#count_#' = evaluate('odenek_total_#count_#') + odenek_>
            	<td style="text-align:right;">#tlformat(odenek_)#</th>
                </cfloop>
            </cfif>
            <td style="text-align:right;">#tlformat(EK_ODENEKLER)#<cfset ek_kazanc_toplam = ek_kazanc_toplam + EK_ODENEKLER></td>
            <td style="text-align:right;">#tlformat(BRUT_UCRET + EK_ODENEKLER + EXT_SALARY)#<cfset toplam_kazanc_toplam = toplam_kazanc_toplam + (BRUT_UCRET + EK_ODENEKLER + EXT_SALARY)></td>
            <td style="text-align:right;">
            	<cfset kisi_ssk_taban_ = wrk_round(get_insurance_ilk.MIN_GROSS_PAYMENT_NORMAL / 30 * ssk_days)>
				<cfif SSK_MATRAH lt kisi_ssk_taban_><b style="color:red;" class="yanip-sonen">#tlformat(SSK_MATRAH)#</b><cfelse>#tlformat(SSK_MATRAH)#</cfif>
				<cfset toplam_ssk_matrah = toplam_ssk_matrah + SSK_MATRAH>
            </td>
            <td style="text-align:right;">#tlformat(SSK_ISVEREN_CARPAN)#</td>
            <td style="text-align:right;">#tlformat(ISVEREN_SSK)#<cfset isveren_ssk_toplam = isveren_ssk_toplam + ISVEREN_SSK></td>
            <td style="text-align:right;">#tlformat(ISVEREN_INDIRIM)#</td><cfset isveren_indirim_toplam = isveren_indirim_toplam + ISVEREN_INDIRIM>
            <td style="text-align:right;">#tlformat(ISVEREN_ISSIZLIK)#<cfset issizlik_isveren_toplam = issizlik_isveren_toplam + ISVEREN_ISSIZLIK></td>
            <td style="text-align:right;">#tlformat(ISCI_TOPLAM_MALIYET)#<cfset toplam_maliyet = toplam_maliyet + ISCI_TOPLAM_MALIYET></td>
		</tr>
	</cfoutput>
	</tbody>
	<tfoot>
	<cfoutput>
		<tr class="color-list">
			<td colspan="4" class="formbold" style="text-align:right;"><cf_get_lang dictionary_id='53263.Toplamlar'></td>
			<td style="text-align:center;" class="formbold">#get_emps.recordcount# <cf_get_lang dictionary_id='29831.Kişi'></td>
            <td style="text-align:right;" class="formbold">#gun_toplam#</td>
            <td>&nbsp;</td>
            <td style="text-align:right;" class="formbold">#tlformat(maas_toplam)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(brut_maas_toplam)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(fazla_mesai_toplam)#</td>
            <cfif odenek_sayi gt 0>
            	<cfset count_ = 0>
            	<cfloop query="get_odenek_adlar">
                	<cfset count_ = count_ + 1>
                    <td style="text-align:right;" class="formbold">#tlformat(evaluate('odenek_total_#count_#'))#</td>
                </cfloop>
            </cfif>
            <td style="text-align:right;" class="formbold">#tlformat(ek_kazanc_toplam)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(toplam_kazanc_toplam)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(toplam_ssk_matrah)#</td>
            <td style="text-align:right;" class="formbold">&nbsp;</td>
            <td style="text-align:right;" class="formbold">#tlformat(isveren_ssk_toplam)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(isveren_indirim_toplam)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(issizlik_isveren_toplam)#</td>
            <td style="text-align:right;" class="formbold">#tlformat(toplam_maliyet)#</td>
		</tr>
	</cfoutput>
	<tr>
		<td colspan="22" class="color-list" style="text-align:right;">
		<cfif get_emps.recordcount>
			<input type="button" value="<cfoutput>#getLang('','Toplu Bordro Bas','64883')#</cfoutput>" onClick="send_print();"/>
			<input type="button" value="<cfoutput>#getLang('','Bordro Oluştur','64882')#</cfoutput>" onclick="make_puantaj();"/>
		</cfif>
        </td>
	</tr>
	</tfoot>
</cf_ajax_list>
<script>
<cfoutput>
<cfif get_emps.recordcount>
<cfoutput>
function send_print()
{
	windowopen('index.cfm?fuseaction=ehesap.popupflush_view_puantaj_print_pdf&puantaj_type=-1&puantaj_id=#get_emps.puantaj_id#&HIERARCHY=&SAL_YEAR=#attributes.sal_year#&SAL_MON=#attributes.sal_mon#','page');
}
</cfoutput>
</cfif>

function make_puantaj()
{
	window.open('index.cfm?fuseaction=ehesap.list_puantaj','_blank');
}
</cfoutput>
</script>