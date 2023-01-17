<cfif not evaluate("#query_name#.recordcount")>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='58486.Kayıt bulunamadı'>");
		history.back();
	</script>
	<cfexit method="exittemplate">
</cfif>
<cfscript>
	if (get_program_parameters.SSK_31_DAYS eq 1)
		all_days = daysinmonth(bu_ay_sonu);
	else
		all_days = 30;
	t_ssk_matrahi = 0;
	t_toplam_kazanc = 0;
	t_vergi_indirimi = 0;
	t_vergi_indirimi_5084 = 0;
	t_kum_gelir_vergisi_matrahi = 0;
	t_gelir_vergisi_matrahi = 0;
	t_gelir_vergisi = 0;
	t_damga_vergisi = 0;
	t_damga_vergisi_matrahi = 0;
	t_kesinti = 0;
	t_net_ucret = 0;
	t_ssk_primi_isci = 0;
	t_ssk_primi_isveren = 0;
	t_issizlik_isci_hissesi = 0;
	t_issizlik_isveren_hissesi = 0;
	t_ozel_kesinti = 0;
	t_ssk_days = 0;
	t_ssk_ssk_days = 0;
	t_ext_work_days = 0;
	t_ext_work_days_2 = 0;
	t_ext_work_hours_1 = 0;
	t_ext_work_hours_2 = 0;
	t_sundays = 0;
	t_offdays = 0;
	t_offdays_amount = 0;
	t_offdays_sundays = 0;
	t_paid_izinli_sundays = 0;
	t_izinli_sundays = 0;
	t_izin = 0;
	t_izin_amount = 0;
	t_paid_izin = 0;
	t_ssk_paid_izin = 0;
	t_ssdf_paid_izin = 0;
	t_ssk_paid_izin_amount = 0;
	t_ssdf_paid_izin_amount = 0;
	ssk_count = 0;
	t_ssdf_ssk_days = 0;
	t_ssdf_days = 0;
	t_ssdf_izin_days = 0;
	t_ssdf_izin_amount = 0;
	t_ssdf_matrah = 0;
	t_ssdf_isci_hissesi = 0;
	t_ssdf_isveren_hissesi = 0;
	t_sakatlik = 0;
	t_gocmen_indirimi = 0;
	t_ext_salary = 0;
	t_ext_salary_1 = 0;
	t_ext_salary_2 = 0;
	t_avans = 0;
	ssdf_say = 0;
	ssk_say = 0;
	sakat_say = 0;
	gocmen_say = 0;
	if (isnumeric(get_kumulatif_gelir_vergisi.TOPLAM))
		t_kum_gelir_vergisi = get_kumulatif_gelir_vergisi.TOPLAM;
	else
		t_kum_gelir_vergisi = 0;  
	t_total_pay_ssk_tax = 0;
	t_total_pay_ssk = 0;
	t_total_pay_tax = 0;
	t_total_pay = 0;
	
	t_ssdf_mesai_amount = 0;
	t_ssdf_sunday_amount = 0;
	t_ssk_mesai_amount = 0;
	t_ssk_sunday_amount = 0;
	
	eksi_ssk = 0;
	eksi_ssk_paid_izin = 0;
	
	/* 20040824 simdilik yok bkz satir 119
	t_kidem_isci_payi = 0;
	t_kidem_isveren_payi = 0;
	*/
</cfscript>
<cfset bu_ay_basi = createdate(attributes.sal_year,attributes.sal_mon, 1)>
<cfset bu_ay_sonu = date_add('s',-1,date_add('m',1,bu_ay_basi))>

<cfquery name="get_izins" datasource="#dsn#">
	SELECT
		OFFTIME.EMPLOYEE_ID,
		SETUP_OFFTIME.EBILDIRGE_TYPE_ID,
		SETUP_OFFTIME.SIRKET_GUN,
		SETUP_OFFTIME.IS_PAID
	FROM
		OFFTIME, SETUP_OFFTIME
	WHERE
		SETUP_OFFTIME.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID AND
		OFFTIME.VALID = 1 AND
		OFFTIME.STARTDATE <= #bu_ay_sonu# AND
		OFFTIME.FINISHDATE >= #bu_ay_basi# AND 
		OFFTIME.IS_PUANTAJ_OFF = 0
	ORDER BY
		OFFTIME.EMPLOYEE_ID
</cfquery>
<cfoutput query="#query_name#">
	<cfscript>
	//if(total_days gt 0)
	{
			if(salary_type eq 0)
				ucret = salary;
			else if(salary_type eq 1)
				ucret = salary;
			else if(salary_type eq 2)
				{
				ucret = TOTAL_SALARY - TOTAL_PAY_SSK_TAX - TOTAL_PAY_SSK - TOTAL_PAY_TAX - TOTAL_PAY - ext_salary - IHBAR_AMOUNT - KIDEM_AMOUNT - YILLIK_IZIN_AMOUNT + ozel_kesinti_2;
					if(total_days gt 0)
					ucret = wrk_round((ucret/total_days)*all_days,2);
					else
					ucret = 0;
				}
		total_salary_ = TOTAL_SALARY - (EXT_SALARY + total_pay_ssk_tax + total_pay_tax + total_pay_ssk + total_pay);
		t_toplam_kazanc = t_toplam_kazanc + total_salary_;
		t_vergi_indirimi = t_vergi_indirimi + vergi_indirimi;
		t_vergi_indirimi_5084 = t_vergi_indirimi_5084 + vergi_indirimi_5084;
		t_kum_gelir_vergisi_matrahi = t_kum_gelir_vergisi_matrahi + KUMULATIF_GELIR_MATRAH - gelir_vergisi_matrah;
		t_gelir_vergisi_matrahi = t_gelir_vergisi_matrahi + gelir_vergisi_matrah;
		t_gelir_vergisi = t_gelir_vergisi + gelir_vergisi;
		t_damga_vergisi = t_damga_vergisi + damga_vergisi;
		t_kesinti = t_kesinti + ssk_isci_hissesi + ssdf_isci_hissesi + issizlik_isci_hissesi + gelir_vergisi + damga_vergisi;
		t_net_ucret = t_net_ucret + net_ucret;
		/* 20040824 simdilik yok (kidem_boss ve kidem_worker kolonlari db de puantaj_row da var) bkz satir 81
		t_kidem_isveren_payi = t_kidem_isveren_payi + kidem_boss;
		t_kidem_isci_payi = t_kidem_isci_payi + kidem_worker;
		*/
		t_ozel_kesinti = t_ozel_kesinti + ozel_kesinti + ozel_kesinti_2;
		if (SAKATLIK_INDIRIMI gt 0)
			{
			t_sakatlik = t_sakatlik + SAKATLIK_INDIRIMI;
			sakat_say = sakat_say + 1;
			}
		if (GOCMEN_INDIRIMI gt 0)
			{
			t_gocmen_indirimi = t_gocmen_indirimi + GOCMEN_INDIRIMI;
			gocmen_say = gocmen_say + 1;
			}
		t_damga_vergisi_matrahi = t_damga_vergisi_matrahi + DAMGA_VERGISI_MATRAH ;//+ total_pay
		// fazle mesai özel
		/*c1 = (get_program_parameters.EX_TIME_PERCENT);
		c2 = (get_program_parameters.EX_TIME_PERCENT_HIGH);*/
		fazla_mesai_hafta_ici = (EXT_TOTAL_HOURS_0-EXT_TOTAL_HOURS_3) * get_program_parameters.EX_TIME_PERCENT;
		fazla_mesai_hafta_sonu = (EXT_TOTAL_HOURS_1 * get_program_parameters.EX_TIME_PERCENT);
		//fazla_mesai_resmi_tatil = EXT_TOTAL_HOURS_2 * 200; // resmi tatil
		fazla_mesai_resmi_tatil = EXT_TOTAL_HOURS_2 * 100; // resmi tatil
		fazla_mesai_45 = EXT_TOTAL_HOURS_3 * get_program_parameters.EX_TIME_PERCENT_HIGH;// 45 saati asan kisim
		fazla_mesai_toplam = fazla_mesai_hafta_ici + fazla_mesai_hafta_sonu + fazla_mesai_resmi_tatil + fazla_mesai_45;
		if (fazla_mesai_toplam neq 0)
			{
			t_ext_salary_1 = t_ext_salary_1 + ((EXT_SALARY/fazla_mesai_toplam) * (fazla_mesai_hafta_ici + fazla_mesai_hafta_sonu + fazla_mesai_45));
			t_ext_salary_2 = t_ext_salary_2 + ((EXT_SALARY/fazla_mesai_toplam) * fazla_mesai_resmi_tatil);
			}
		t_ext_Salary = t_ext_salary_1 + t_ext_salary_2;
		t_avans = t_avans + AVANS;
		t_ext_work_days_1 = t_ext_work_days + ((EXT_TOTAL_HOURS_0 + EXT_TOTAL_HOURS_1) / SSK_WORK_HOURS);
		t_ext_work_days_2 = t_ext_work_days_2 + ((EXT_TOTAL_HOURS_2) / SSK_WORK_HOURS);
		t_ext_work_hours_1 = t_ext_work_hours_1 + EXT_TOTAL_HOURS_0 + EXT_TOTAL_HOURS_1;
		t_ext_work_hours_2 = t_ext_work_hours_2 + EXT_TOTAL_HOURS_2;
		t_ext_work_days = t_ext_work_days_1 + t_ext_work_days_2;
		t_sundays = t_sundays + SUNDAY_COUNT;
		t_offdays = t_offdays + OFFDAYS_COUNT;
		t_offdays_sundays = t_offdays_sundays + OFFDAYS_SUNDAY_COUNT;
		if (isnumeric(PAID_IZINLI_SUNDAY_COUNT))
			t_paid_izinli_sundays = t_paid_izinli_sundays + PAID_IZINLI_SUNDAY_COUNT;
		else
			PAID_IZINLI_SUNDAY_COUNT = 0;
			
		if (isnumeric(IZINLI_SUNDAY_COUNT))
			t_izinli_sundays = t_izinli_sundays + IZINLI_SUNDAY_COUNT;
		else
			IZINLI_SUNDAY_COUNT = 0;
		
	if(isdefined("attributes.employee_id"))
		get_emp_izins = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND SIRKET_GUN > 0");
	else
		get_emp_izins = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0");
	
	if(izin_paid gt 0 and get_emp_izins.recordcount) ucretli_izin_gunu = izin_paid - (2*get_emp_izins.recordcount); else ucretli_izin_gunu=izin_paid;
	if (ssdf_isveren_hissesi gt 0)/* ssk li emekliler icin*/
		{
		ssdf_say = ssdf_say + 1;
		t_ssdf_izin_days = t_ssdf_izin_days + izin;
		t_ssdf_paid_izin = t_ssdf_paid_izin + ucretli_izin_gunu ;
		t_ssdf_izin_amount = t_ssdf_izin_amount + (ucret * (izin/all_days));
		t_ssdf_paid_izin_amount = t_ssdf_paid_izin_amount + ( (ucretli_izin_gunu/all_days) * ucret);
		t_ssdf_mesai_amount = t_ssdf_mesai_amount + ( ((total_days-(sunday_count-OFFDAYS_SUNDAY_COUNT)-offdays_count+paid_izinli_sunday_count-ucretli_izin_gunu) / all_days) * ucret );
		t_ssdf_sunday_amount = t_ssdf_sunday_amount + ( ((sunday_count-paid_izinli_sunday_count-offdays_sunday_count) / all_days) * ucret );
		t_offdays_amount = t_offdays_amount + ((OFFDAYS_COUNT/all_days)*ucret);
		t_ssdf_ssk_days = t_ssdf_ssk_days + total_days;
		t_ssdf_days = t_ssdf_days + total_days - sunday_count;
		t_ssdf_matrah = t_ssdf_matrah + SSK_MATRAH;
		t_ssdf_isci_hissesi = t_ssdf_isci_hissesi + ssdf_isci_hissesi;
		t_ssdf_isveren_hissesi = t_ssdf_isveren_hissesi + ssdf_isveren_hissesi;
		}
	else
		{/* emekli olmayan ama kazanci olan kisiler gelsin (ssk li veya degil), ucretlere ait bilgiler hesaplansin*/
		t_izin = t_izin + izin;
		t_ssk_paid_izin = t_ssk_paid_izin + ucretli_izin_gunu ;
		t_izin_amount = t_izin_amount + (ucret * (izin/all_days));
		t_ssk_paid_izin_amount = t_ssk_paid_izin_amount + ((ucretli_izin_gunu/all_days) * ucret); 
		t_ssk_mesai_amount = t_ssk_mesai_amount + ( ((total_days-(sunday_count-OFFDAYS_SUNDAY_COUNT)-offdays_count+paid_izinli_sunday_count-ucretli_izin_gunu) / all_days) * ucret);
		t_ssk_sunday_amount = t_ssk_sunday_amount + (((sunday_count-paid_izinli_sunday_count-offdays_sunday_count) / all_days) * ucret );
		t_offdays_amount = t_offdays_amount + ((OFFDAYS_COUNT/all_days)*ucret);
		t_ssk_ssk_days = t_ssk_ssk_days + total_days;
		t_ssk_days = t_ssk_days + total_days - sunday_count;
		if (use_ssk eq 1){
			ssk_say = ssk_say + 1;
			t_ssk_matrahi = t_ssk_matrahi + SSK_MATRAH;
			t_ssk_primi_isci = t_ssk_primi_isci + ssk_isci_hissesi;
			t_ssk_primi_isveren = t_ssk_primi_isveren + ssk_isveren_hissesi;
			t_issizlik_isci_hissesi = t_issizlik_isci_hissesi + issizlik_isci_hissesi;
			t_issizlik_isveren_hissesi = t_issizlik_isveren_hissesi + issizlik_isveren_hissesi;
			}
		else{/*ssk li olmayan diger sosyal guvenlik kurumuna tabi ise asagida toplam gunden cikacak gun sayisi bulunuyor*/
			eksi_ssk = eksi_ssk + total_days;
			eksi_ssk_paid_izin = eksi_ssk_paid_izin + ucretli_izin_gunu;
			}
		}
		t_total_pay_ssk_tax = t_total_pay_ssk_tax + total_pay_ssk_tax;
		t_total_pay_ssk = t_total_pay_ssk + total_pay_ssk;
		t_total_pay_tax = t_total_pay_tax + total_pay_tax;
		t_total_pay = t_total_pay + total_pay;
	}
	</cfscript>
</cfoutput>
<cfscript>
	t_paid_izin = t_ssk_paid_izin + t_ssdf_paid_izin;
	toplam_gun = t_ssk_days + t_ssdf_days + t_sundays;
	normal_gun = t_ssk_days + t_ssdf_days + t_izinli_sundays + t_offdays_sundays - t_paid_izin - t_offdays;
	normal_amount = t_ssk_mesai_amount + t_ssdf_mesai_amount;
	haftalik_tatil = t_sundays - t_offdays_sundays - t_izinli_sundays;
	haftalik_tatil_amount = t_ssdf_sunday_amount + t_ssk_sunday_amount;
	genel_tatil = t_offdays;
	genel_tatil_amount = t_offdays_amount;
</cfscript>
<cfquery name="CHECK" datasource="#DSN#">
	SELECT
		ASSET_FILE_NAME3
	FROM
	   OUR_COMPANY
	WHERE
	<cfif isDefined("SESSION.EP.COMPANY_ID")>
	    COMP_ID = #SESSION.EP.COMPANY_ID#
	<cfelseif isDefined("SESSION.PP.COMPANY")>	
	    COMP_ID = #SESSION.PP.COMPANY#
	</cfif> 
</cfquery>
<table width="900" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#CCCCCC">
	<tr>
		<td height="30"  style="text-align:right;">&nbsp;</td>
	</tr>
</table>
<table width="900" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#CCCCCC"> 
  <tr>
  	<td colspan="2"><cfif len(CHECK.asset_file_name3)><cfoutput><img src="#user_domain##file_web_path#settings/#CHECK.asset_file_name3#" border="0"></cfoutput></cfif><br/></td>
  </tr>
  <tr>
  	<td colspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td width="50%" style="height:5mm;"><cf_get_lang dictionary_id="57574.Şirket"> :
	<cfif icmal_type is 'personal'><cfoutput>#GET_PUANTAJ_PERSONAL.COMPANY_NAME# - #GET_PUANTAJ_PERSONAL.BRANCH_FULLNAME#</cfoutput>
	<cfelseif icmal_type is 'comp'><cfoutput>#get_puantaj_comp.COMPANY_NAME#</cfoutput>
	<cfelseif icmal_type is 'genel'><cfoutput>#GET_BRANCH.COMPANY_NAME# - #GET_BRANCH.BRANCH_FULLNAME#</cfoutput>
	<cfelseif icmal_type is 'dept'><cfoutput>#GET_BRANCH.COMPANY_NAME# - #GET_BRANCH.BRANCH_FULLNAME#</cfoutput>
	</cfif><br/>
	</td>
    <td width="50%">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
		<tr>
			<td><cf_get_lang dictionary_id="57453.Şube"> :
			<cfoutput>#GET_PUANTAJ_PERSONAL.BRANCH_NAME#</cfoutput>
			</td>
			<td  style="text-align:right;"><cfif icmal_type is "personal"><cf_get_lang dictionary_id="31592.Personel"> <cf_get_lang dictionary_id="57487.No"> :<cfoutput>#EMPLOYEE_NO#</cfoutput><cfelse>&nbsp;</cfif></td>
		</tr>
	</table>	
	</td>
  </tr>
   <tr>
    <td width="50%" style="height:5mm;">
	<cfif icmal_type is "personal"><cf_get_lang dictionary_id="32370.Adı Soyadı"> :<cfoutput>#employee_name# #employee_surname#</cfoutput><cfelse>&nbsp;</cfif><br/>
	</td>
    <td width="50%">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
		<tr>
			<td><cf_get_lang dictionary_id="31282.Ücret"> : <cfif icmal_type is "personal"><cfoutput>#TLFormat(ucret)#</cfoutput></cfif></td>
			<td  style="text-align:right;"><cf_get_lang dictionary_id="58700.Organizasyon Birimleri"> : <cfoutput>#get_position_detail.DEPARTMENT_HEAD#</cfoutput></td>
		</tr>
	</table>	
	</td>
  </tr>
   <tr>
    <td width="50%" style="height:5mm;">
	<cfset attributes.branch_id = GET_PUANTAJ_PERSONAL.branch_id>
	<cf_get_lang dictionary_id="33779.SGK No"> : <cfoutput>#GET_PUANTAJ_PERSONAL.SOCIALSECURITY_NO#</cfoutput>
	</td>
    <td width="50%">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
		<tr>
			<td><cf_get_lang dictionary_id="53816.SGK Günü"> : <cfoutput><cfif (normal_gun + haftalik_tatil + t_offdays - t_ssdf_ssk_days - eksi_ssk)>#normal_gun + haftalik_tatil + t_offdays - t_ssdf_ssk_days - eksi_ssk#<cfelse>0</cfif></cfoutput></td>
			<td  style="text-align:right;"><cf_get_lang dictionary_id="30978.Pozisyonu"> : <cfoutput>#get_position_detail.position_name#</cfoutput></td>
		</tr>
	</table>	
	</td>
  </tr>
</table>

<table width="900" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#CCCCCC">
	<tr>
		<td width="300" valign="top">
			<table width="100%" border="0" bordercolor="#CCCCCC">
				<tr>
					<td><cf_get_lang dictionary_id="38996.Toplam Brüt Kazançlar"></td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<td width="125"><cf_get_lang dictionary_id="59395.Normal Çalışma"></td>
					<td width="75"  style="text-align:right;"><cfoutput>#normal_gun#</cfoutput></td>
					<td width="100"  style="text-align:right;"><cfoutput>#TLFormat(normal_amount)#</cfoutput></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="58956.Haftalık Tatil"></td>
					<td  style="text-align:right;"><cfoutput>#haftalik_tatil#</cfoutput></td>
					<td  style="text-align:right;"><cfoutput>#TLFormat(haftalik_tatil_amount)#</cfoutput></td>
				</tr>
				 <cfif genel_tatil gt 0>
				  <tr>
					<td><cf_get_lang dictionary_id="29482.Genel Tatil"></td>
					<td  style="text-align:right;"><cfoutput>#genel_tatil#</cfoutput></td>
					<td  style="text-align:right;"><cfoutput>#TLFormat(genel_tatil_amount)#</cfoutput></td>
				  </tr>
				  </cfif>
				<tr>
					<td><cf_get_lang dictionary_id="38224.Fazla Mesai"></td>
					<td  style="text-align:right;"><cfoutput>#round(t_ext_work_hours_1 + t_ext_work_hours_2)#</cfoutput></td>
					<td  style="text-align:right;"><cfoutput>#TLFormat(t_ext_salary_1 + t_ext_salary_2)#</cfoutput></td>
				</tr>
				<cfoutput query="get_odeneks" group="COMMENT_PAY">
					<cfset tmp_total = 0>
					<cfoutput><!--- 20040824 ellemeyin yanlis kullanim degil --->
						<cfif PAY_METHOD eq 2>
							<cfset tmp_total = tmp_total + amount_2>
						<cfelse>
							<cfset tmp_total = tmp_total + amount>
						</cfif>
					</cfoutput>
				  <tr>
					<td>#comment_pay#</td>
					<td>&nbsp;</td>
					<td  style="text-align:right;">#TLFormat(tmp_total)#</td>
				  </tr>
				</cfoutput>
			</table>
		</td>
		<td width="250">
			<table>
				<tr>
					<td width="125"><cf_get_lang dictionary_id="59396.Yasal Kesintiler"></td>
					<td width="125"></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="53249.Gelir Vergisi Matrahı"></td>
					<td  style="text-align:right;"><cfoutput>#TLFormat(t_gelir_vergisi_matrahi)#</cfoutput></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="59397.KGVM"></td>
					<td  style="text-align:right;"><cfoutput>#TLFormat(t_kum_gelir_vergisi_matrahi+t_gelir_vergisi_matrahi)#</cfoutput></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="59398.Gelir Vergisi Dilimi"></td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="40452.Gelir Vergisi"></td>
					<td  style="text-align:right;"><cfoutput>#TLFormat(t_kum_gelir_vergisi+t_gelir_vergisi)#</cfoutput></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="53252.Damga Vergisi"></td>
					<td  style="text-align:right;"><cfoutput>#TLFormat(t_damga_vergisi)#</cfoutput>
						<!--- <cfoutput>#TLFormat(t_istisna)#</cfoutput> --->
					</td>
				</tr>
				<cfif len(sakat_say) and sakat_say neq 0 and len(t_sakatlik) and t_sakatlik neq 0> 
				<tr>
					<td><cf_get_lang dictionary_id="54168.Sakatlık İndirimi"> (<cfoutput>#sakat_say#</cfoutput>)</td>
					<td  style="text-align:right;"><cfoutput>#TLFormat(t_sakatlik)#</cfoutput></td>
				</tr>
				</cfif>
				<cfif isdefined("t_vergi_indirimi_5084") and len(t_vergi_indirimi_5084) and t_vergi_indirimi_5084 neq 0>
				<tr>
					<td><cf_get_lang dictionary_id="38971.Vergi İndirimi"> 5084</td>
					<td  style="text-align:right;"><cfoutput>#TLFormat(t_vergi_indirimi_5084)#</cfoutput></td>
				</tr>
				</cfif>
				<cfif isdefined("t_istisna") and len(t_istisna) and t_istisna neq 0>
				<tr>
					<td><cf_get_lang dictionary_id="41630.Özel İndirim"></td>
					<td  style="text-align:right;"><cfoutput>#TLFormat(t_vergi_indirimi-t_istisna)#</cfoutput></td>
				</tr>
				</cfif>
				<cfif isdefined("t_gocmen_indirimi") and len(t_gocmen_indirimi) and t_gocmen_indirimi neq 0>
				<tr>
					<td><cf_get_lang dictionary_id="54315.Göçmen İndirimi"> (<cfoutput>#gocmen_say#</cfoutput>)</td>
					<td  style="text-align:right;"><cfoutput>#TLFormat(t_gocmen_indirimi)#</cfoutput></td>
				</tr>
				</cfif>
				<tr>
					<td><cf_get_lang dictionary_id="53816.Toplam SGK Günü"></td>
					<td  style="text-align:right;"><cfoutput><cfif (normal_gun + haftalik_tatil + t_offdays - t_ssdf_ssk_days - eksi_ssk)>#normal_gun + haftalik_tatil + t_offdays - t_ssdf_ssk_days - eksi_ssk#<cfelse>0</cfif></cfoutput></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="53245.SGK Matrahı"></td>
					<td  style="text-align:right;"><cfoutput>#TLFormat(t_ssk_matrahi)#</cfoutput></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="53719.SGK İşçi Primi"></td>
					<td  style="text-align:right;"><cfoutput>#TLFormat(t_ssk_primi_isci)#</cfoutput></td>
				</tr>
				<cfquery name="get_insurance_ratio" datasource="#dsn#">
					SELECT
						*
					FROM
						INSURANCE_RATIO
					WHERE
						STARTDATE <= #now()# AND
						FINISHDATE >= #now()#
				</cfquery>
				<tr>
					<td><cf_get_lang dictionary_id="54330.İşsizlik Sigortası İşçi Primi"></td>
					<td  style="text-align:right;"><cfoutput>(%#ssk_isci_carpan#) #TLFormat(t_issizlik_isci_hissesi)#</cfoutput></td>
				</tr>
			</table>
		</td>
		<td width="250" valign="top">
			<table>
				<tr>
					<td width="125"><cf_get_lang dictionary_id="59399.Özel Kesintiler"></td>
					<td width="125"></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="58204.Avans"></td>
					<td  style="text-align:right;"><cfoutput>#TLFormat(t_avans)#</cfoutput></td>
				</tr>
				<cfset taksit_1 = 0>
				<cfoutput query="get_kesintis" group="COMMENT_PAY">
					<cfset tmp_total = 0>
					<cfoutput><!--- 20040824 ellemeyin yanlis kullanim degil --->
					<cfif PAY_METHOD eq 2>
						<cfset tmp_total = tmp_total + amount_2>
						<cfset taksit_1 = amount_2>
					<cfelse>
						<cfset tmp_total = tmp_total + amount>
						<cfset taksit_1 = amount>
					</cfif>
					</cfoutput>
				  <tr>
					<td>#comment_pay#</td>
					<td  style="text-align:right;">#TLFormat(taksit_1)#</td>
				  </tr>
				</cfoutput>    
			</table>
		</td>
	</tr>
</table>
<table width="900" cellpadding="0" cellspacing="0" align="center" bordercolor="#CCCCCC">
	<tr><td colspan="6" style="height:1mm;">&nbsp;</td></tr>
	<tr>
		<cfset yasal_kesintiler = wrk_round(t_kum_gelir_vergisi+t_gelir_vergisi+t_damga_vergisi+t_ssk_primi_isci+t_issizlik_isci_hissesi)>
		<cfset ozel_kesintiler = (t_avans + taksit_1)>
		<cfset brut_kazanc = wrk_round(t_ext_salary_1+t_ext_salary_2+normal_amount+haftalik_tatil_amount+genel_tatil_amount+t_total_pay+t_total_pay_tax+t_total_pay_ssk+t_total_pay_ssk_tax)>
		<td width="270"><cf_get_lang dictionary_id="38996.Toplam Brüt Kazanç"></td>
		<td width="65"><cfoutput>#TLFormat(brut_kazanc)#</cfoutput></td>
		<td width="205"><cf_get_lang dictionary_id="59396.Yasal Kesintiler"></td>
		<td width="80"><cfoutput>#TLFormat(yasal_kesintiler)#</cfoutput></td>
		<td width="227"><cf_get_lang dictionary_id="59399.Özel Kesintiler"></td>
		<td><cfoutput>#TLFormat(t_avans+taksit_1)#</cfoutput></td>
	</tr>
	<tr><td colspan="6">&nbsp;</td></tr>
</table>
<table bordercolor="#CCCCCC" border="1" width="900" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td height="20" width="615" valign="top">
			<table>
				<tr>
					<td width="120"><cf_get_lang dictionary_id="53256.SGK İşveren Primi"></td>
					<td  style="text-align:right;"><cfoutput>(%#ssk_isveren_carpan#) #TLFormat(t_ssk_primi_isveren)#</cfoutput></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="59372.İşsizlik İşveren İndirimi"></td>
					<td  style="text-align:right;"><cfoutput>(%#get_insurance_ratio.death_insurance_boss#) #TLFormat(t_issizlik_isveren_hissesi)#</cfoutput></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id="30888.İşveren Maliyeti"></td>
					<td  style="text-align:right;"><cfif icmal_type is "personal"><cfoutput>#TLFormat(t_ssk_primi_isveren + t_issizlik_isveren_hissesi)#</cfoutput></cfif></td>
				</tr>
			</table>
		</td>
		<td>
			<table>
				<tr>
					<td height="30"><cf_get_lang dictionary_id="50035.Net Ödenen"></td>
					<td><cfif icmal_type is "personal"><cfoutput>#TLFormat(brut_kazanc - (ozel_kesintiler + yasal_kesintiler))#</cfoutput></cfif></td>
				</tr>
				<tr>
					<td width="100">&nbsp;</td>
					<td height="60" valign="top"><cf_get_lang dictionary_id="58957.İmza"></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
