<cfquery name="get_emp_ozel_gider" datasource="#dsn#"><!--- özel gider indirimi sube ile baglanabilirdi ama gerek yok x yilin y ayinda bir kisi icin bir satir olabilir --->
	SELECT
		ODENECEK_TUTAR,
		DAMGA_VERGISI
	FROM
		EMPLOYEES_OZEL_GIDER_IND_ROWS AS OGIR,
		EMPLOYEES_OZEL_GIDER_IND AS OGI
	WHERE
		OGIR.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
		OGI.PERIOD_YEAR = #attributes.SAL_YEAR# AND
		OGI.PERIOD_MONTH = #attributes.SAL_MON# AND
		OGIR.OZEL_GIDER_IND_ID = OGI.OZEL_GIDER_IND_ID
</cfquery>
<cfif not get_emp_ozel_gider.recordcount>
	<!--- 20050215 ocak ayinda bu tutarlar puantajdan gelen kisiye bagli olmadigi icin 0 set ediliyor --->
	<cfset get_emp_ozel_gider.ODENECEK_TUTAR = 0>
	<cfset get_emp_ozel_gider.DAMGA_VERGISI = 0>
</cfif>

<cfif isdefined("attributes.print") and isdefined("attributes.show")>
<table width="640" height="35" cellpadding="0" cellspacing="0" class="txtbold" border="0">
  <tr>
    <td class="headbold"></td>
    <td  class="headbold" style="text-align:right;"> </td>
	<td><cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_view_price_compass&employee_id=#attributes.employee_id#&show=1&sal_mon=#attributes.sal_mon#','page');"> <img src="/images/print.gif" alt="<cf_get_lang dictionary_id='29740.Yazıcıya Gönder'>" border="0"></a></cfoutput></td>
  </tr>
</table>
</cfif>
<table border="1" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" width="719" bgcolor="#FFFFFF" align="center">
  <tr>
    <td colspan="2" valign="baseline">
     <br/>
	<table width="98%" cellpadding="0" cellspacing="0" border="1" bordercolor="CCCCCC" align="center">
        <tr>
          <td colspan="4" class="txtbold"><cfoutput>#get_company_name.company_name#</cfoutput></td>
          <td colspan="2"  class="txtbold" style="text-align:right;"> <cfoutput>#listgetat(ay_list(),attributes.sal_mon)# - #session.ep.period_year#</cfoutput> <cf_get_lang dictionary_id="52975.ÜCRET PUSULASI"></td>
        </tr>
        <tr>
          <td width="83" class="txtbold"><cf_get_lang dictionary_id="57570.Ad Soyad"></td>
          <td>: <cfoutput>#get_hr_ssk.EMPLOYEE_NAME# #get_hr_ssk.EMPLOYEE_SURNAME#</cfoutput></td>
          <td width="89" class="txtbold"><cf_get_lang dictionary_id="38996.Brüt Kazanç"></td>
          <td>: <cfoutput>#TLFormat(salary)#</cfoutput></td>
          <td width="14" class="txtbold"><cf_get_lang dictionary_id="53127.Ücret"> </td>
          <td>: <cfoutput>#TLFormat(get_hr_salary.salary)#</cfoutput></td>
        </tr>
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="32328.Sicil No"></td>
          <td>: <cfoutput>#get_hr_ssk.EMPLOYEE_No#</cfoutput></td>
          <td class="txtbold"><cf_get_lang dictionary_id="58083.Net"> <cf_get_lang dictionary_id="53971.Kazanç"></td>
          <td>: <cfoutput>#TLFormat(net_ucret+ozel_kesinti)#</cfoutput></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="45579.SSK Sicil No"></td>
          <td>: <cfoutput>#get_hr_ssk.socialsecurity_no#</cfoutput></td>
          <td class="txtbold"><cf_get_lang dictionary_id="56437.Ücret Yöntemi"></td>
          <td>:
            <cfif get_hr_salary.salary_type eq 0> <cf_get_lang dictionary_id="57491.Saat">
            <cfelseif get_hr_salary.salary_type eq 1> <cf_get_lang dictionary_id="57490.Gün">
            <cfelseif get_hr_salary.salary_type eq 2> <cf_get_lang dictionary_id="58724.Ay"></cfif>
            -
            <cfif get_hr_salary.gross_net eq 1> <cf_get_lang dictionary_id="58083.Net">
			<cfelseif get_hr_salary.gross_net eq 0> <cf_get_lang dictionary_id="56257.Brüt">
			<cfelse> <cf_get_lang dictionary_id="58546.Yok"></cfif>
          </td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
      </table><br/>

    </td>
  </tr>
  <tr>
    <cfset bu_ay = listgetat(ay_list(),dateformat(last_month_1,'mm'))>
    <td valign="top">
      <br/>
	<cfscript>
	t_offdays = OFFDAYS_COUNT;
	t_offdays_sundays = OFFDAYS_SUNDAY_COUNT;
	total_salary_ = salary - (ext_salary + total_pay_ssk_tax + total_pay_tax + total_pay_ssk + total_pay);
	if (ssk_days eq 0){
		normal_amount = 0;
		haftalik_tatil_amount = 0;
		izin_amount = 0;
		izin_paid_amount = 0;
		}
	else{
		normal_amount = (total_salary_ * (ssk_days - izin_paid - sunday_count + paid_izinli_sunday_count - t_offdays + t_offdays_sundays)) / ssk_days;
		haftalik_tatil_amount = (total_salary_ * (sunday_count - paid_izinli_sunday_count - izinli_sunday_count - t_offdays_sundays)) / ssk_days;
		izin_amount = (total_salary_ * izin) / ssk_days;
		izin_paid_amount = (total_salary_ * izin_paid) / ssk_days;
		}
	</cfscript>
	  <table width="98%" cellpadding="0" cellspacing="0" border="1" bordercolor="CCCCCC" align="center">
        <tr class="FORMBOLD">
          <td width="100">aaaaaaaaaa<cf_get_lang dictionary_id="56546.Toplam Çalıştığı Süre"></td>
          <td width="75"><cf_get_lang dictionary_id="57490.Gün"> - <cf_get_lang dictionary_id="57491.Saat"></td>
          <td width="100"><cf_get_lang dictionary_id="57673.Tutar"></td>
        </tr>
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="47864.Normal"></td>
          <td>
		<cfif get_hr_salary.salary_type eq 2>
			<cfoutput>&nbsp;#ssk_days - (sunday_count + izin_paid + t_offdays) + paid_izinli_sunday_count + izinli_sunday_count + t_offdays_sundays# - </cfoutput>
		<cfelse>
			<cfoutput>&nbsp;#work_days# - </cfoutput>
		</cfif>
          </td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(normal_amount)#</cfoutput>&nbsp;</td>
        </tr>
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="56021.Hafta Sonu"></td>
          <td>&nbsp;<cfoutput>#sunday_count - paid_izinli_sunday_count - izinli_sunday_count - t_offdays_sundays# - </cfoutput></td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(haftalik_tatil_amount)#</cfoutput>&nbsp;</td>
        </tr>
		<cfif offdays_count gt 0>
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="29482.Genel Tatil"></td>
          <td>&nbsp;<cfoutput>#round(offdays_count)#</cfoutput> - </td>
          <td  style="text-align:right;"><cfoutput>#TLFormat((total_salary_*t_offdays) / ssk_days)#</cfoutput>&nbsp;</td>
        </tr>
		</cfif>
		<cfif izin gt 0>
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="53688.Ücretsiz İzin	"></td>
          <td>&nbsp;<cfoutput>#round(izin)# - #round(izin_count)#</cfoutput></td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(izin_amount)#</cfoutput>&nbsp;</td>
        </tr>
		</cfif>
		<cfif izin_paid gt 0>
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="53686.Ücretli İzin"></td>
          <td>&nbsp;<cfoutput>#round(izin_paid)# - #round(izin_paid_count)#</cfoutput></td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(izin_paid_amount)#</cfoutput>&nbsp;</td>
        </tr>
		</cfif>
		<cfif ext_total_hours_0+ext_total_hours_1+ext_total_hours_2 + ext_total_hours_5>
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="59208.Fazla Mesai"></td>
          <td>&nbsp;<cfoutput>&nbsp; -#ext_total_hours_0+ext_total_hours_1+ext_total_hours_2#</cfoutput></td>
          <td  style="text-align:right;">&nbsp;<cfoutput>#TLFormat(ext_salary)#</cfoutput>&nbsp;</td>
        </tr>
		</cfif>
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="37764.SSK Gün"></td>
          <td>&nbsp;<cfoutput>#ssk_days#</cfoutput></td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(total_salary_+ext_salary)#</cfoutput>&nbsp;</td>
        </tr>
	  </table>
	  <br/>
		<table width="98%" cellpadding="0" cellspacing="0" border="1" bordercolor="CCCCCC" align="center">
        <tr>
          <td colspan="2" class="txtbold"><strong><cf_get_lang dictionary_id="59373.SGK Primi"></strong></td>
        </tr>
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="53245.SGK Matrahı"></td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(ssk_matrah)#</cfoutput></td>
        </tr>
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="59373.SGK Primi"> (<cf_get_lang dictionary_id="45049.İşçi)"></td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(ssk_isci_hissesi)#</cfoutput></td>
        </tr>
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="59545.SSK Primi Hesaplanan"> (<cf_get_lang dictionary_id="56406.İşveren">) </td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(ssk_isveren_hissesi + ssk_isveren_hissesi_5510 + ssk_isveren_hissesi_5084)#</cfoutput></td>
        </tr>
	<tr>
          <td class="txtbold"><cf_get_lang dictionary_id="59546.SSK Primi İndirimler"> (<cf_get_lang dictionary_id="56406.İşveren">)</td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(ssk_isveren_hissesi_5510 + ssk_isveren_hissesi_5084)#</cfoutput></td>
        </tr>
	<tr>
          <td class="txtbold"><cf_get_lang dictionary_id="59373.SGK Primi"> (<cf_get_lang dictionary_id="56406.İşveren">)</td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(ssk_isveren_hissesi)#</cfoutput></td>
        </tr>
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="59547.İşsizlik Primi">(<cf_get_lang dictionary_id="45049.İşçi)">)</td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(issizlik_isci_hissesi)#</cfoutput></td>
        </tr>
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="59547.İşsizlik Primi"> (<cf_get_lang dictionary_id="56406.İşveren">)</td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(issizlik_isveren_hissesi)#</cfoutput></td>
        </tr>
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="54312.SGDP Primi"> (<cf_get_lang dictionary_id="45049.İşçi)">)</td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(ssdf_isci_hissesi)#</cfoutput></td>
        </tr>
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="54312.SGDP Primi"> (<cf_get_lang dictionary_id="56406.İşveren">)</td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(ssdf_isveren_hissesi)#</cfoutput></td>
        </tr>
      </table><br/>

    </td>
    <td valign="top">
      <br/>
	  <table width="98%" cellpadding="0" cellspacing="0" border="1" bordercolor="CCCCCC" align="center">
        <tr>
          <td width="135" class="txtbold"><cf_get_lang dictionary_id="56446.Sendika Kesintisi"></td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(get_hr_ssk.TRADE_UNION_DEDUCTION)#</cfoutput></td>
        </tr>
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="41630.Özel İndirim"></td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(vergi_istisna+sakatlik_indirimi)#</cfoutput></td>
        </tr>
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="54321.Gelir Ver. Matrahı"></td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(gelir_vergisi_matrah)#</cfoutput></td>
        </tr>
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="53251.Küm. Gelir Ver.Mat."></td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(kumulatif_gelir+gelir_vergisi_matrah_ay_icinde_nakil)#<!---  /// #kumulatif_gelir# /// ## ---></cfoutput></td><!--- AK20040913 --->
        </tr>
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="53689.Gelir Vergisi Hesaplanan"></td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(gelir_vergisi + vergi_iadesi + vergi_indirim_5084 - mahsup_edilecek_gelir_vergisi_)#</cfoutput></td>
        </tr>
	<tr>
		<td class="txtbold"><cf_get_lang dictionary_id="39964.AGİ"></td>
		<td  style="text-align:right;"><cfoutput>#TLFormat(vergi_iadesi)#</cfoutput></td>
	</tr>
	<tr>
		<td class="txtbold"><cf_get_lang dictionary_id="56368.Vergi İndirimi"> 5084</td>
		<td  style="text-align:right;"><cfoutput>#TLFormat(vergi_indirim_5084)#</cfoutput></td>
	</tr>
	<tr>
          <td class="txtbold"><cf_get_lang dictionary_id="40452.Gelir Vergisi"></td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(gelir_vergisi)#</cfoutput></td>
        </tr>
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="53252.Damga Vergisi"></td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(damga_vergisi)#</cfoutput></td>
        </tr>
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="53568.Özel Gider İndirim Tutarı"></td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(get_emp_ozel_gider.ODENECEK_TUTAR)#</cfoutput></td>
        </tr>
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="59548.Özel Gid. İnd. Tutarı Dmg. Vrg."></td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(get_emp_ozel_gider.DAMGA_VERGISI)#</cfoutput></td>
        </tr>
        <!--- özel kesinti  --->
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="53254.Muhtelif Kesintiler"></td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(ozel_kesinti+ozel_kesinti_2)#</cfoutput></td>
        </tr>
        <!--- ssk ve vergiden muaf OLMAYAN --->
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="58204.Avans"></td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(AVANS)#</cfoutput></td>
        </tr>
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="59549.Kıdem Fonu Payı"> (<cf_get_lang dictionary_id="56406.İşveren">)</td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(kidem_isveren_payi)#</cfoutput></td>
        </tr>
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="59549.Kıdem Fonu Payı"> (<cf_get_lang dictionary_id="45049.İşçi)">)</td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(kidem_isci_payi)#</cfoutput></td>
        </tr>
		<cfif attributes.kidem_amount gt 0>
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="55751.Kıdem Tazminatı"> <cf_get_lang dictionary_id ="56257.Brüt"></td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(attributes.kidem_amount)#</cfoutput></td>
        </tr>
		</cfif>
		<cfif attributes.ihbar_amount gt 0>
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="55752.İhbar Tazminatı"> <cf_get_lang dictionary_id ="56257.Brüt"></td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(attributes.ihbar_amount)#</cfoutput></td>
        </tr>
		</cfif>
	<cfif attributes.yillik_izin_amount gt 0>
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="53393.Yıllık İzin Tutarı"> <cf_get_lang dictionary_id ="56257.Brüt"></td>
          <td  style="text-align:right;"><cfoutput>#TLFormat(attributes.yillik_izin_amount)#</cfoutput></td>
        </tr>
	</cfif>
	
        <tr>
          <td colspan="2" class="txtbold"><cf_get_lang dictionary_id="53399.Ek Ödenekler"></td>
        </tr>
		<cfloop from="1" to="#puantaj_exts_index#" index="i">
		<cfif puantaj_exts[i][6] eq 0>
        <tr>
          <td class="txtbold"><cfoutput>#puantaj_exts[i][1]#</cfoutput></td>
          <td  style="text-align:right;"><cfif puantaj_exts[i][2] eq 2>%</cfif><cfoutput>#TLFormat(puantaj_exts[i][3])#</cfoutput></td>
        </tr>
		</cfif>
		</cfloop>
        <tr>
          <td colspan="2" class="txtbold"><cf_get_lang dictionary_id="39999.Ek Kesintiler"></td>
        </tr>
		<cfloop from="1" to="#puantaj_exts_index#" index="i">
		<cfif puantaj_exts[i][6] eq 1>
        <tr>
          <td class="txtbold"><cfoutput>#puantaj_exts[i][1]#</cfoutput></td>
          <td  style="text-align:right;"><cfif puantaj_exts[i][2] eq 2>%</cfif><cfoutput>#TLFormat(puantaj_exts[i][3])#</cfoutput></td>
        </tr>
		</cfif>
		</cfloop>
        <tr>
          <td colspan="2" class="txtbold"><cf_get_lang dictionary_id="53838.Vergi Muafiyetleri"></td>
        </tr>
		<cfloop from="1" to="#puantaj_exts_index#" index="i">
		<cfif puantaj_exts[i][6] eq 2>
        <tr>
          <td class="txtbold"><cfoutput>#puantaj_exts[i][1]#</cfoutput></td>
          <td  style="text-align:right;"><cfif puantaj_exts[i][2] eq 2>%</cfif><cfoutput>#TLFormat(puantaj_exts[i][3])#</cfoutput></td>
        </tr>
		</cfif>
		</cfloop>
      </table>
    </td>
  </tr>
  <tr>
    <td colspan="2">
<cfif isdefined("GET_PUANTAJ_PERSONAL.emp_bank_id") and len(GET_PUANTAJ_PERSONAL.emp_bank_id)>
	<cfquery name="get_bank_" datasource="#dsn#">
	SELECT 
		BA.BANK_BRANCH_CODE,
		BA.BANK_ACCOUNT_NO,
		B.BANK_NAME
	FROM
		EMPLOYEES_BANK_ACCOUNTS BA,
		SETUP_BANK_TYPES B
	WHERE
		BA.BANK_ID = B.BANK_ID AND
		BA.EMP_BANK_ID = #GET_PUANTAJ_PERSONAL.emp_bank_id#
	</cfquery>
<cfelse>
	<cfset get_bank_.recordcount = 0>
</cfif>
      <table width="100%">
        <tr>
          <td rowspan="2" valign="top">
            <cf_get_lang dictionary_id="59536.Bu Ücret Pusulasıyla Tahakkuku Yapılan Ödemelerin Fiili Çalışmama Uygun Olduğunu">, <cfif (ext_total_hours_0+ext_total_hours_1+ext_total_hours_2) eq 0><cf_get_lang dictionary_id="59537.Fazla Mesai Yapmadığımı">,</cfif> <cf_get_lang dictionary_id="59538.Ücretlerimi"> <cfif get_bank_.recordcount><CFOUTPUT><b>#get_bank_.BANK_NAME# (#get_bank_.BANK_BRANCH_CODE#-#get_bank_.BANK_ACCOUNT_NO#)</b></CFOUTPUT> <cf_get_lang dictionary_id="59544.Nolu Hesabımdan"></cfif> <cf_get_lang dictionary_id="59539.Aldığımı , Ücret Alacağımın kalmadığını Kabul Ve Beyan Ederim.">
		  </td>
          <td width="400"  class="formbold" style="text-align:right;"><cf_get_lang dictionary_id="58957.İmza"></td>
        </tr>
        <tr>
          <td> <br/>
            <br/>
            <br/>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<cfif not isdefined("attributes.print") and isdefined("attributes.show")>
  <script type="text/javascript">
		function waitfor(){
		<cfif isDefined("attributes.is_pop") and (attributes.is_pop EQ 1)>
		  window.opener.close();
		</cfif>	
		  window.close();
		}
		setTimeout("waitfor()",3000); 		
		window.print();	
	</script>
</cfif>
