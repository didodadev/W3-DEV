<!--- 
Puantaj, Pusula, İcmal Print Şablonu
Bu şablon değişkenler set edildikten sonra include edilmelidir.
Gerekli değişkenler :
	comp_name : Şirket Adı
	branch_name : Şube Adı
	emp_name : Çalışan adı
	ay_no : Kaçıncı Aya ait
	yil_no : Hangi Yıla Ait
	tur : "İcmal","Pusula"
	kisi_say : Eğer tek kişi için değilse kaç kişilik olduğu
	normal_gun : hafta tatilleri hariç çalışılan gün toplam
	normal_gun_tutar : normal_gun kazancı
	hs_gun : İzinli olunmayan hafta sonları toplam
	hs_gun_tutar : hs_gun kazancı
	genel_tatil_gun : genel tatil gün sayısı
	genel_tatil_gun_tutar : genel_tatil_gun tutarı
	ucretsiz_izin_gun : Ücretsiz izin gün sayısı
	ucretsiz_izin_gun _tutar : Ücretsiz izin Gün Tutarı
	ucretli_izin_gun : Ücretli izin gün sayısı
	ucretli_izin_gun _tutar : Ücretli izin Gün Tutarı
	fazla_mesai_nrm_gun : Normal Fazla Mesai gün sayısı
	fazla_mesai_nrm_gun_tutar : fazla_mesai_1_gun kazancı
	fazla_mesai_hs_gun : Hafta Sonu Fazla Mesai gün sayısı
	fazla_mesai_hs_gun_tutar : fazla_mesai_hs_gun kazancı
	fazla_mesai_rt_gun : Resmi Tatil Fazla Mesai gün sayısı
	fazla_mesai_rt_gun_tutar : fazla_mesai_rt_gun kazancı
// ek ödenek, kesinti, vergi muafiyetleri ayarlanacak
		

Ergün KOÇAK 20040605
  
--->

<!-- sil -->
<table width="98%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="CCCCCC">
  <tr>
    <td bgcolor="FFFFFF">
<!-- sil -->
	<br/>
<table width="98%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#CCCCCC"> 
  <tr>
    <td width="50%"><cf_get_lang dictionary_id="58485.Şirket Adı"> : <cfif isdefined("get_company_name")><cfoutput>#get_company_name.COMPANY_NAME#</cfoutput><cfelseif isdefined("get_branch")><cfoutput>#GET_BRANCH.branch_name#</cfoutput><cfelse><cf_get_lang dictionary_id="58081.Hepsi"></cfif>&nbsp;</td>
    <td width="50%"><cfoutput>#LISTGETAT(AY_LIST(),attributes.SAL_MON)# #session.ep.period_year#</cfoutput>&nbsp; <cf_get_lang dictionary_id="58584.İcmal"></td>
  </tr>
  <tr>
	<td><cfif icmal_type is "personal"><cf_get_lang dictionary_id="32370.Adı Soyadı"> <cfoutput>#get_employee_name.employee_name# #get_employee_name.employee_surname#</cfoutput><cfelse>&nbsp;</cfif></td>
    <td><cfif icmal_type is not "personal"><cf_get_lang dictionary_id="37915.Kişi Sayısı"> <cfoutput>#kisi_say#</cfoutput><cfelse>&nbsp;</cfif></td>
  </tr>
</table>

<hr>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#CCCCCC"> 
  <tr class="txtbold">
    <td width="25%" valign="top"><table width="100%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#CCCCCC">
      <tr class="txtbold" height="25">
        <td><cf_get_lang dictionary_id="53777.Kazançlar"></td>
        <td><cf_get_lang dictionary_id="57490.Gün"></td>
        <td><cf_get_lang dictionary_id="57673.Tutar"></td>
      </tr>
	  <cfset t_paid_izin = t_ssk_paid_izin + t_ssdf_paid_izin>
	  <cfset toplam_gun = t_work_days + t_ssdf_days + t_sundays + t_offdays>
	  <cfset normal_gun = t_work_days + t_ssdf_days + t_paid_izinli_sundays + t_izinli_sundays + t_offdays_sundays - t_paid_izin - t_offdays>
	  <cfset haftalik_tatil = t_sundays - t_paid_izinli_sundays - t_offdays_sundays - t_izinli_sundays>
	  <cfset genel_tatil = t_offdays>
	  <cfset normal_amount = t_ssdf_mesai_amount + t_ssk_mesai_amount>
	  <cfset haftalik_tatil_amount = t_ssdf_sunday_amount + t_ssk_sunday_amount>
      <tr>
        <td><cf_get_lang dictionary_id="32287.NORMAL"></td>
        <td  style="text-align:right;"><cfoutput>#normal_gun#</cfoutput>&nbsp;</td>
        <td  style="text-align:right;"><cfoutput>#TLFormat(normal_amount)#</cfoutput>&nbsp;</td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="58956.HAFTALIK TATİL"></td>
        <td  style="text-align:right;"><cfoutput>#haftalik_tatil#</cfoutput>&nbsp;</td>
        <td  style="text-align:right;"><cfoutput>#TLFormat(haftalik_tatil_amount)#</cfoutput>&nbsp;</td>
      </tr>
	  <cfif t_offdays gt 0>
		  <cfset genel_tatil_amount = (t_toplam_kazanc*genel_tatil) / toplam_gun>
      <tr>
        <td><cf_get_lang dictionary_id="29482.GENEL TATİL"></td>
        <td  style="text-align:right;"><cfoutput>#t_offdays#</cfoutput>&nbsp;</td>
        <td  style="text-align:right;"><cfoutput>#TLFormat(genel_tatil_amount)#</cfoutput>&nbsp;</td>
      </tr>
	  <cfelse>
		  <cfset genel_tatil_amount = 0>
	  </cfif>
	  <cfif (t_izin+t_ssdf_izin_days) gt 0>
		  <cfset ucretsiz_izin_amount = t_ssdf_izin_amount + t_izin_amount>
      <tr>
        <td><cf_get_lang dictionary_id="43317.ÜCRETSİZ İZİN"></td>
        <td  style="text-align:right;"><cfoutput>#t_izin+t_ssdf_izin_days#</cfoutput>&nbsp;</td>
        <td  style="text-align:right;"><cfoutput>#TLFormat(ucretsiz_izin_amount)#</cfoutput>&nbsp;</td>
      </tr>
	  <cfelse>
		  <cfset ucretsiz_izin_amount = 0>
	  </cfif>
	  <cfif t_paid_izin gt 0>
		  <cfset ucretli_izin_amount = t_ssdf_paid_izin_amount + t_ssk_paid_izin_amount>
      <tr>
        <td><cf_get_lang dictionary_id="53686.ÜCRETLİ İZİN"></td>
        <td  style="text-align:right;"><cfoutput>#t_paid_izin#&nbsp;</cfoutput></td>
        <td  style="text-align:right;"><cfoutput>#TLFormat(ucretli_izin_amount)#</cfoutput>&nbsp;</td>
      </tr>
	  <cfelse>
		  <cfset ucretli_izin_amount = 0>
	  </cfif>
	  <cfif round(t_ext_work_hours_1) gt 0>
      <tr>
        <td><cf_get_lang dictionary_id="55724.FAZLA MESAİ">-1</td>
        <td  style="text-align:right;"><cfoutput>#round(t_ext_work_hours_1)#</cfoutput>&nbsp;</td>
        <td  style="text-align:right;"><cfoutput>#TLFormat(t_ext_salary_1)#</cfoutput>&nbsp;</td>
      </tr>
	  </cfif>
	  <cfif round(t_ext_work_hours_2) gt 0>
      <tr>
        <td><cf_get_lang dictionary_id="55724.FAZLA MESAİ">-2</td>
        <td  style="text-align:right;"><cfoutput>#round(t_ext_work_hours_2)#</cfoutput>&nbsp;</td>
        <td  style="text-align:right;"><cfoutput>#TLFormat(t_ext_salary_2)#</cfoutput>&nbsp;</td>
      </tr>
	  </cfif>

    </table>
	</td>
    <td width="25%" valign="top">
	<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#CCCCCC">
      <tr class="txtbold" height="25">
        <td><cf_get_lang dictionary_id="53399.Ek Ödenekler"></td>
        <td><cf_get_lang dictionary_id="57673.Tutar"></td>
      </tr>
	<cfoutput query="get_odeneks" group="COMMENT_PAY">
		<cfset tmp_total = 0>
		<cfoutput>
		<CFif PAY_METHOD eq 2>
			<cfset tmp_total = tmp_total + amount_2>
		<cfelse>
			<cfset tmp_total = tmp_total + amount>
		</CFif>
		</cfoutput>
      <tr>
        <td>#comment_pay#</td>
        <td  style="text-align:right;">#TLFormat(tmp_total)#</td>
      </tr>
	</cfoutput>
    </table>
	</td>
    <td width="25%" valign="top"><table width="100%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#CCCCCC">
      <tr class="txtbold" height="25">
        <td><cf_get_lang dictionary_id="38977.Kesintiler"></td>
        <td><cf_get_lang dictionary_id="57673.Tutar"></td>
      </tr>
	  <cfif t_avans gt 0>
      <tr>
        <td><cf_get_lang dictionary_id="58204.AVANS"></td>
        <td  style="text-align:right;"><cfoutput>#TLFormat(t_avans)#</cfoutput>&nbsp;</td>
      </tr>
	  </cfif>
	<cfoutput query="get_kesintis" group="COMMENT_PAY">
		<cfset tmp_total = 0>
		<cfoutput>
		<CFif PAY_METHOD eq 2>
			<cfset tmp_total = tmp_total + amount_2>
		<cfelse>
			<cfset tmp_total = tmp_total + amount>
		</CFif>
		</cfoutput>
      <tr>
        <td>#comment_pay#</td>
        <td  style="text-align:right;">#TLFormat(tmp_total)#</td>
      </tr>
	</cfoutput>    
	</table>
	</td>
    <td width="25%" valign="top"><table width="100%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#CCCCCC">
      <tr class="txtbold" height="25">
        <td><cf_get_lang dictionary_id="53838.Vergi Muafiyetleri"></td>
        <td><cf_get_lang dictionary_id="57673.Tutar"></td>
      </tr>
	<cfset t_istisna = 0>
	<cfoutput query="get_vergi_istisnas" group="COMMENT_PAY">
		<cfset tmp_total = 0>
		<cfoutput>
		<CFif PAY_METHOD eq 2>
			<cfset tmp_total = tmp_total + amount_2>
			<cfset t_istisna = t_istisna + amount_2>
		<cfelse>
			<cfset tmp_total = tmp_total + amount>
			<cfset t_istisna = t_istisna + amount>
		</CFif>
		</cfoutput>
      <tr>
        <td>#comment_pay#</td>
        <td  style="text-align:right;">#TLFormat(tmp_total)#</td>
      </tr>
	</cfoutput> </table>
	</td>
  </tr>
	<cfset ergun_toplam_salary = normal_amount + haftalik_tatil_amount + t_ext_salary_1 + t_ext_salary_2 + ucretli_izin_amount>
  <tr class="txtbold">
    <td valign="top">
	<br/>
	<table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC">
	  <tr>
        <td width="42%"><cf_get_lang dictionary_id="57492.TOPLAM"></td>
        <td  style="text-align:right;">&nbsp;</td>
        <td width="43%"  style="text-align:right;"><cfoutput>#TLFormat(ergun_toplam_salary+t_total_pay)#</cfoutput></td><!--- t_toplam_kazanc+t_ext_salary --->
	  </tr>
    </table>
	</td>
    <td valign="top">
	<br/>
	<table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC">
      <tr>
        <td><cf_get_lang dictionary_id="57492.TOPLAM"></td>
        <td  style="text-align:right;"><cfoutput>#TLFormat(t_total_pay+t_total_pay_tax+t_total_pay_ssk+t_total_pay_ssk_tax)#</cfoutput></td>
      </tr>
    </table></td>
    <td valign="top">
	<br/>
	<table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC">
      <tr>
        <td><cf_get_lang dictionary_id="57492.TOPLAM"></td>
        <td  style="text-align:right;"><cfoutput>#TLFormat(t_avans+t_ozel_kesinti)#</cfoutput></td>
      </tr>
    </table></td>
    <td valign="top">
	<br/>
	<table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC">
      <tr>
        <td><cf_get_lang dictionary_id="57492.TOPLAM"></td>
        <td  style="text-align:right;"><cfoutput>#TLFormat(t_istisna)#</cfoutput></td>
      </tr>
    </table>
	</td>
  </tr>
</table>
<br/>
<table width="98%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#CCCCCC">
  <tr>
    <td width="22%"><cf_get_lang dictionary_id="58714.SGK"> <cf_get_lang dictionary_id="31474.Normal Gün"></td>
    <td width="25%"  style="text-align:right;"><cfoutput>#normal_gun+haftalik_tatil-t_ssdf_ssk_days-eksi_ssk+t_offdays#</cfoutput>&nbsp;</td>
    <td width="36%">&nbsp;</td>
    <td width="17%"  style="text-align:right;">&nbsp;</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="32287.NORMAL"><cf_get_lang dictionary_id="58714.SGK"> <cf_get_lang dictionary_id="54269.İzin Gün"></td>
    <td  style="text-align:right;"><cfoutput>#t_ssk_paid_izin-eksi_ssk_paid_izin#</cfoutput>&nbsp; </td>
    <td>&nbsp;</td>
    <td  style="text-align:right;">&nbsp;</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="53245.SGK Matrahı"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_ssk_matrahi-eksi_ssk_matrah)#</cfoutput>&nbsp; </td>
    <td><cf_get_lang dictionary_id="41540.Normal Kazanç"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_toplam_kazanc)#</cfoutput>&nbsp;</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="53719.SGK İşçi Primi">(<cfoutput>#ssk_say#</cfoutput>)</td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_ssk_primi_isci)#</cfoutput>&nbsp;</td>
    <td><cf_get_lang dictionary_id="41783.Ek Kazanç Top."></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_ext_salary_1 + t_ext_salary_2)#</cfoutput>&nbsp;</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="53256.SGK İşveren Primi"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_ssk_primi_isveren)#</cfoutput>&nbsp;</td><!--- t_issizlik_isveren_hissesi --->
    <td><cf_get_lang dictionary_id="41785.Sosyal Yardımlar"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_total_pay_ssk_tax+t_total_pay_ssk+t_total_pay_tax+t_total_pay)#</cfoutput>&nbsp;</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="41786.Toplam SGK Primi"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_ssk_primi_isveren+t_ssk_primi_isci)#</cfoutput>&nbsp;</td>
    <td>&nbsp;</td>
    <td  style="text-align:right;">&nbsp;</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="54306.SGDP Normal Gün"></td>
    <td  style="text-align:right;"><cfoutput>#t_ssdf_ssk_days#</cfoutput>&nbsp;</td>
    <td>&nbsp;</td>
    <td  style="text-align:right;">&nbsp;</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="41782.SGDP İzin Gün"></td>
    <td  style="text-align:right;"><cfoutput>#t_ssdf_paid_izin#</cfoutput>&nbsp;</td>
    <td>&nbsp;</td>
    <td  style="text-align:right;">&nbsp; </td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="54307.SGDP Matrahı"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_ssdf_matrah)#</cfoutput>&nbsp;</td>
    <td><cf_get_lang dictionary_id="30871.Toplam Kazanç"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_toplam_kazanc+t_total_pay_ssk_tax+t_total_pay_ssk+t_total_pay_tax+t_total_pay+t_ext_Salary)#</cfoutput>&nbsp;</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="54308.SGDP İşçi Primi"> (<cfoutput>#ssdf_say#</cfoutput>)</td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_ssdf_isci_hissesi)#</cfoutput>&nbsp;</td>
    <td><cf_get_lang dictionary_id="53253.Toplam Yasal Kesinti"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_kesinti)#</cfoutput>&nbsp;</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="54311.SGDP İşveren Primi"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_ssdf_isveren_hissesi)#</cfoutput>&nbsp;</td>
    <td><cf_get_lang dictionary_id="41743.Toplam Özel Kesinti"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_ozel_kesinti+t_avans)#</cfoutput>&nbsp;</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="54312.Toplam SGDP Primi"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_ssdf_isci_hissesi+t_ssdf_isveren_hissesi)#</cfoutput>&nbsp;</td>
    <td><cf_get_lang dictionary_id="41740.Ters Bakiye"></td>
    <td  style="text-align:right;">&nbsp;</td>
  </tr>
</table>
<br/>
<table width="98%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#CCCCCC">
  <tr>
    <td width="22%"><cf_get_lang dictionary_id="54283.İşsizlik Sigortası Matrahı"></td>
    <td width="25%"  style="text-align:right;"><cfoutput>#TLFormat(t_ssk_matrahi-eksi_ssk_matrah)#</cfoutput>&nbsp;</td>
    <td width="36%">&nbsp;</td>
    <td width="17%"  style="text-align:right;">&nbsp;</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="54275.İşsizlik Sigortası İşçi"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_issizlik_isci_hissesi)#</cfoutput>&nbsp;</td>
    <td><cf_get_lang dictionary_id="50023.Net Ödenecek"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_net_ucret)#</cfoutput>&nbsp;</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="53257.İşsizlik Sigortası İşveren"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_issizlik_isveren_hissesi)#</cfoutput>&nbsp;</td>
    <td>&nbsp;</td>
    <td  style="text-align:right;">&nbsp;</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="41748.Toplam İşsizlik Sigortası"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_issizlik_isveren_hissesi+t_issizlik_isci_hissesi)#</cfoutput>&nbsp;</td>
    <td><cf_get_lang dictionary_id="41747.Küm. Tas. İşçi İşveren"></td>
    <td  style="text-align:right;">&nbsp;</td>
  </tr>
</table>
<br/>
<table width="98%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#CCCCCC">
  <tr>
    <td width="22%"><cf_get_lang dictionary_id="54314.Gayri Safi Kazanç"></td>
    <td width="25%"  style="text-align:right;"><cfoutput>#TLFormat(t_toplam_kazanc+t_total_pay_ssk_tax+t_total_pay_ssk+t_total_pay_tax+t_total_pay+t_ext_Salary-t_ssk_primi_isci-t_issizlik_isci_hissesi-t_ssdf_isci_hissesi)#</cfoutput>&nbsp;</td>
    <td width="36%"><cf_get_lang dictionary_id="54313.Kümülatif Vergi Matrahı"></td>
    <td width="17%"  style="text-align:right;"><cfoutput>#TLFormat(t_kum_gelir_vergisi_matrahi+t_gelir_vergisi_matrahi)#<!--- <br/>#TLFormat(get_kumulatif_gelir_vergisi2.TOPLAM2)# ---></cfoutput>&nbsp;</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="41630.Özel İndirim"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_vergi_indirimi-t_istisna)#</cfoutput>&nbsp;</td>
    <td><cf_get_lang dictionary_id="54319.Kümüle Gelir Vergisi"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_kum_gelir_vergisi+t_gelir_vergisi)#</cfoutput>&nbsp;</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="54168.Sakatlık İndirimi"> (<cfoutput>#sakat_say#</cfoutput>)</td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_sakatlik)#</cfoutput>&nbsp;</td>
    <td>&nbsp;</td>
    <td  style="text-align:right;">&nbsp;</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="54315.Göçmen İndirimi"> (<cfoutput>#gocmen_say#</cfoutput>)</td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_gocmen_indirimi)#</cfoutput>&nbsp;</td>
    <td>&nbsp;</td>
    <td  style="text-align:right;">&nbsp;</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="54316.Diğer Muafiyet"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_istisna)#</cfoutput>&nbsp;</td>
    <td><cf_get_lang dictionary_id="41873.Özel Gid. İnd."></td>
    <td  style="text-align:right;"><cfif len(get_ogis.ogi_odenecek_toplam)><cfoutput>#TLFormat(get_ogis.ogi_odenecek_toplam)#</cfoutput><cfelse>0</cfif>&nbsp;</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="54321.Net Gelir Ver. Matrahı"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_gelir_vergisi_matrahi)#</cfoutput>&nbsp;</td>
    <td><cf_get_lang dictionary_id="41904.Ö.Gider İnd. Damga Vergisi"></td>
    <td  style="text-align:right;"><cfif len(get_ogis.ogi_damga_toplam)><cfoutput>#TLFormat(get_ogis.ogi_damga_toplam)#</cfoutput><cfelse>0</cfif>&nbsp;</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="40452.Gelir Vergisi"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_gelir_vergisi)#</cfoutput>&nbsp;</td>
    <td><cf_get_lang dictionary_id="41903.Ö.Gider İnd. Sonra GV."></td>
    <td  style="text-align:right;"><cfoutput><cfif len(get_ogis.ogi_odenecek_toplam)>#TLFormat(t_gelir_vergisi-get_ogis.ogi_odenecek_toplam-get_ogis.ogi_damga_toplam)#<cfelse>#TLFormat(t_gelir_vergisi)#</cfif></cfoutput>&nbsp;</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="41842.DV. Matrahı"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_damga_vergisi_matrahi)#</cfoutput>&nbsp;</td>
    <td>&nbsp;</td>
    <td  style="text-align:right;">&nbsp;</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="41439.Damga Vergisi"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_damga_vergisi)#</cfoutput>&nbsp;</td><!--- <cfif len(get_ogis.ogi_damga_toplam)>#TLFormat(t_damga_vergisi-get_ogis.ogi_damga_toplam)#<cfelse>#TLFormat(t_damga_vergisi)#</cfif> --->
    <td><cf_get_lang dictionary_id="31846.Toplam İşveren Maliyeti"></td>
    <td  style="text-align:right;"><cfoutput>#TLFormat(t_toplam_kazanc+t_ext_salary+t_issizlik_isveren_hissesi+t_ssk_primi_isveren+t_ssdf_isveren_hissesi+t_total_pay+t_total_pay_tax+t_total_pay_ssk+t_total_pay_ssk_tax)#</cfoutput>&nbsp;</td>
  </tr>
</table>
<br/>
<!-- sil -->
</td>
  </tr>
</table>
<!-- sil -->
