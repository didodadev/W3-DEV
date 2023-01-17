<cfinclude template="/invoice/query/control_bill_no.cfm">
<cfquery name="GET_ACCOUNTS" datasource="#dsn#">
	SELECT 
        PAYROLL_ID, 
        DEFINITION, 
        RECORD_EMP, 
        UPDATE_EMP, 
        RECORD_IP, 
        UPDATE_IP, 
        RECORD_DATE, 
        UPDATE_DATE, 
        TAX_ACCOUNT, 
        AGI_TAX_ACCOUNT, 
        PERSONAL_ADVANCE_ACCOUNT, 
        SSK_BOSS_ACCOUNT, 
        SSK_WORKER_ACCOUNT, 
        SGDP_BOSS_ACCOUNT, 
        SGDP_WORKER_ACCOUNT, 
        SGDP_OUT, 
        STAMP_TAX_ACCOUNT, 
        UNEMPLOYMENT_WORKER_ACCOUNT, 
        UNEMPLOYMENT_BOSS_ACCOUNT, 
        GROSS_WORKER_PAYMENT_ACCOUNT, 
        KIDEM_BOSS_ACCOUNT, 
        SSK_BOSS_ACCOUNT_OUT, 
        KIDEM_BOSS_BUDGET, 
        IHBAR_BUDGET
    FROM 
	    SETUP_SALARY_PAYROLL_ACCOUNTS
</cfquery>

<cfif not GET_ACCOUNTS.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='53384.Dönemde Tanımlı Muhasebe Hesap Planı Bulunamadı Lütfen Şirket Hesap Planlarını Tanımlayınız'>!");
		window.close();
	</script>
	<cfabort>
</cfif>

<cfquery name="get_employee_no_accounts" datasource="#dsn#">
	SELECT 
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		EI.START_DATE,
		EI.FINISH_DATE
	FROM 
		EMPLOYEES_IN_OUT EI,
		EMPLOYEES E
	WHERE 
		EI.IN_OUT_ID IN (#in_out_list#) AND 
		EI.IN_OUT_ID NOT IN (SELECT EIOP.IN_OUT_ID FROM EMPLOYEES_IN_OUT_PERIOD EIOP WHERE EIOP.ACCOUNT_BILL_TYPE IS NOT NULL AND EIOP.PERIOD_ID = #session.ep.period_id#) AND
		EI.EMPLOYEE_ID = E.EMPLOYEE_ID
	ORDER BY
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
</cfquery>

<cfquery name="get_employee_accounts" datasource="#dsn#">
	SELECT 
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		EI.START_DATE,
		EI.FINISH_DATE,
		SA.DEFINITION,
		EIOP.ACCOUNT_BILL_TYPE
	FROM 
		EMPLOYEES_IN_OUT EI,
		EMPLOYEES_IN_OUT_PERIOD EIOP,
		EMPLOYEES E,
		SETUP_SALARY_PAYROLL_ACCOUNTS SA
	WHERE 
		EI.IN_OUT_ID IN (#in_out_list#) AND 
		EIOP.ACCOUNT_BILL_TYPE IS NOT NULL AND
		EIOP.IN_OUT_ID = EI.IN_OUT_ID AND
		EIOP.PERIOD_ID = #session.ep.period_id# AND
		EI.EMPLOYEE_ID = E.EMPLOYEE_ID AND
		SA.PAYROLL_ID = EIOP.ACCOUNT_BILL_TYPE	
	ORDER BY
		SA.DEFINITION,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
</cfquery>

<table>
	<tr height="25" class="formbold">
		<td colspan="3"><cf_get_lang dictionary_id ='53413.Muhasebe Hesap Tanımı Olmayan Çalışanlar'></td>
	</tr>
	<tr class="txtboldblue">
		<td width="200"><cf_get_lang dictionary_id ='57576.Çalışan'></td>
		<td width="75"><cf_get_lang dictionary_id ='57501.Başlangıç'></td>
		<td width="75"><cf_get_lang dictionary_id ='57502.Bitiş'></td>
	</tr>
	<cfif get_employee_no_accounts.recordcount>
		<cfoutput query="get_employee_no_accounts">
			<tr>
				<td>#employee_name# #employee_surname#</td>
				<td>#dateformat(start_date,dateformat_style)#</td>
				<td><cfif len(finish_date)>#dateformat(finish_date,dateformat_style)#</cfif></td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td colspan="3"><cf_get_lang dictionary_id ='57484.Kayıt Bulunamadı'>!</td>
		</tr>
	</cfif>
</table>
<br/>
<table>
	<tr height="25" class="formbold">
		<td colspan="4"><cf_get_lang dictionary_id ='53520.Muhasebe Hesap Tanımı Olan Çalışanlar'></td>
	</tr>
	<tr class="txtboldblue">
		<td width="200"><cf_get_lang dictionary_id='58233.Tanım'></td>
		<td width="200"><cf_get_lang dictionary_id ='57576.Çalışan'></td>
		<td width="75"><cf_get_lang dictionary_id ='57501.Başlangıç'></td>
		<td width="75"><cf_get_lang dictionary_id ='57502.Bitiş'></td>
	</tr>
	<cfif get_employee_accounts.recordcount>
		<cfoutput query="get_employee_accounts">
			<tr>
				<td>#definition#</td>
				<td>#employee_name# #employee_surname#</td>
				<td>#dateformat(start_date,dateformat_style)#</td>
				<td><cfif len(finish_date)>#dateformat(finish_date,dateformat_style)#</cfif></td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td colspan="4"><cf_get_lang dictionary_id ='57484.Kayıt Bulunamadı'>!</td>
		</tr>
	</cfif>
</table>

<table>
	<tr height="25" class="formbold">
		<td colspan="2"><cf_get_lang dictionary_id ='53521.Muhasebe Aktarım Durumu'></td>
	</tr>
	<tr class="txtboldblue">
		<td width="200"><cf_get_lang dictionary_id='58233.Tanım'></td>
		<td><cf_get_lang dictionary_id ='57556.Bilgi'></td>
	</tr>
	<cfscript>
		t_vergi_fon = 0;
		t_personel_avanslari = 0;
		t_ssk_damga_vergisi = 0;
		t_ssk_primi_isci = 0;
		t_ssk_primi_isveren = 0;
		t_issizlik_isci_hissesi = 0;
		t_issizlik_isveren_hissesi = 0;
		t_brut_personel_ucreti = 0;
		t_personel_isveren_odentisi = 0;
		t_kidem_worker = 0;
		t_kidem_boss = 0;
		t_other = 0;
		t_kidem_amount = 0;
		t_agi = 0;
		t_ozel_kesintiler = 0;
		t_sgdp_isveren = 0;
		t_sgdp_isci = 0;
		t_sgdp_isveren_odentisi = 0;
	</cfscript>

<cfoutput query="GET_ACCOUNTS">
	<cfquery name="get_account_puantaj" dbtype="query">
		SELECT * FROM get_puantaj_rows WHERE ACCOUNT_BILL_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#PAYROLL_ID#">
	</cfquery>
	<cfloop query="get_account_puantaj">
		<cfscript>
			this_kidem_ = 0;
			if(KIDEM_AMOUNT gt 0)
				this_kidem_ = wrk_round((KIDEM_AMOUNT - ((KIDEM_AMOUNT * get_program_parameters.STAMP_TAX_BINDE) / 1000)),2);

			t_ozel_kesintiler = wrk_round((t_ozel_kesintiler + avans + ozel_kesinti + ozel_kesinti_2),2);
			t_vergi_fon = wrk_round((t_vergi_fon + GELIR_VERGISI),2);
			t_personel_avanslari = wrk_round((t_personel_avanslari + (net_ucret - VERGI_IADESI - this_kidem_) + (avans + ozel_kesinti + ozel_kesinti_2)),2);

			t_ssk_primi_isci = wrk_round((t_ssk_primi_isci + SSK_ISCI_HISSESI),2);
			t_ssk_primi_isveren = wrk_round((t_ssk_primi_isveren + SSK_ISVEREN_HISSESI - SSK_ISVEREN_HISSESI_GOV),2);

			//		SGDP
			t_sgdp_isveren = wrk_round(t_sgdp_isveren + SSDF_ISVEREN_HISSESI);
			t_sgdp_isci = wrk_round(t_sgdp_isci + SSDF_ISCI_HISSESI);
			t_sgdp_isveren_odentisi = wrk_round(t_sgdp_isveren_odentisi + SSDF_ISVEREN_HISSESI);
			//		/SGDP

			t_ssk_damga_vergisi = wrk_round((t_ssk_damga_vergisi + DAMGA_VERGISI),2);
			t_issizlik_isci_hissesi = wrk_round((t_issizlik_isci_hissesi + ISSIZLIK_ISCI_HISSESI),2);
			t_issizlik_isveren_hissesi = wrk_round((t_issizlik_isveren_hissesi + ISSIZLIK_ISVEREN_HISSESI),2);
			t_kidem_worker = wrk_round((t_kidem_worker + kidem_worker),2);
			t_kidem_boss = wrk_round((t_kidem_boss + kidem_boss),2);
			t_brut_personel_ucreti = wrk_round((t_brut_personel_ucreti + TOTAL_SALARY),2);
			t_personel_isveren_odentisi = wrk_round((t_personel_isveren_odentisi + ISSIZLIK_ISVEREN_HISSESI + SSK_ISVEREN_HISSESI),2);

			t_other = wrk_round((t_other + kidem_worker+ kidem_boss),2);
			t_agi = wrk_round((t_agi + VERGI_IADESI),2);
			t_kidem_amount = wrk_round((t_kidem_amount + this_kidem_),2);
		</cfscript>
	</cfloop>
	<cfif t_brut_personel_ucreti neq 0>
		<cflock name="#createUUID()#" timeout="20">
			<cftransaction>
				<cfscript>
					DETAIL_1 = '#session.ep.period_year# #get_puantaj.sal_mon#.Ay - #get_puantaj.SSK_OFFICE# Personel Maaş Tahakkuku';
					satir_detay_list = ArrayNew(2); //muhasebe fisi satır detaylarını tutar. satir_detay_list[1]'a  borc yazan satırların acıklamaları, satir_detay_list[2]'a alacak yazan satırların acıklamaları set edilir. 
					str_borclu_hesaplar = '' ;
					str_borclu_tutarlar = '' ;
					str_alacakli_hesaplar = '' ;
					str_alacakli_tutarlar = '' ;
					
					genel_alacak_ = 0;
					
					if(t_vergi_fon gt 0)
					{
						str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,get_ACCOUNTS.TAX_ACCOUNT, ",");
						str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,t_vergi_fon, ",");
						satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#session.ep.period_year# #get_puantaj.sal_mon#.Ay Vergi ve Fonlar';
					}
					genel_alacak_ = genel_alacak_ + t_vergi_fon;
					//writeoutput("#t_vergi_fon#___#genel_alacak_#<br/>");
					
					if(t_personel_avanslari gt 0)
					{
						str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,get_ACCOUNTS.PERSONAL_ADVANCE_ACCOUNT, ",");
						str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,t_personel_avanslari, ",");
						satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#session.ep.period_year# #get_puantaj.sal_mon#.Ay Personel Ücretleri';/*Personel Avansları*/
					}	
					genel_alacak_ = genel_alacak_ + t_personel_avanslari;
					//writeoutput("#t_vergi_fon#_#t_personel_avanslari#__#genel_alacak_#<br/>");

					if(t_kidem_amount gt 0)					
					{
						str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,get_ACCOUNTS.KIDEM_BOSS_ACCOUNT, ",");
						str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,t_kidem_amount, ",");
						satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#session.ep.period_year# #get_puantaj.sal_mon#.Ay Kıdem Tazminatı Ödemeleri';
					}	
					genel_alacak_ = genel_alacak_ + t_kidem_amount;
					//writeoutput("#t_vergi_fon#_#t_personel_avanslari#_#t_kidem_amount#_#genel_alacak_#<br/>");
					if(t_agi gt 0)					
					{
						str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,get_ACCOUNTS.AGI_TAX_ACCOUNT, ",");
						str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,t_agi, ",");
						satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#session.ep.period_year# #get_puantaj.sal_mon#.Ay AGİ Ödemeleri';
					}	
					genel_alacak_ = genel_alacak_ + t_agi;
					//writeoutput("#t_vergi_fon#_#t_personel_avanslari#_#t_kidem_amount#___#t_agi#___#genel_alacak_#<br/>");
					
					if(t_ssk_primi_isci gt 0)
					{
						str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,get_ACCOUNTS.SSK_WORKER_ACCOUNT, ",");
						str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,t_ssk_primi_isci, ",");
						satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#session.ep.period_year# #get_puantaj.sal_mon#.Ay SSK İşçi Payları Toplamı';
					}	
					genel_alacak_ = genel_alacak_ + t_ssk_primi_isci;

					//			SGDP

					if(t_sgdp_isveren gt 0)
					{
						str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,get_ACCOUNTS.SGDP_BOSS_ACCOUNT, ",");
						str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,t_sgdp_isveren, ",");
						satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#session.ep.period_year# #get_puantaj.sal_mon#.Ay SGDP İşveren Payları Toplamı';
					}	
					//genel_alacak_ = genel_alacak_ + t_sgdp_isveren;

					if(t_sgdp_isci gt 0)
					{
						str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,get_ACCOUNTS.SGDP_WORKER_ACCOUNT, ",");
						str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,t_sgdp_isci, ",");
						satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#session.ep.period_year# #get_puantaj.sal_mon#.Ay SGDP İşçi Payları Toplamı';
					}	
					genel_alacak_ = genel_alacak_ + t_sgdp_isci;

					//			/SGDP

					if(t_ssk_damga_vergisi gt 0)
					{
						str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,get_ACCOUNTS.STAMP_TAX_ACCOUNT, ",");
						str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,t_ssk_damga_vergisi, ",");
						satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#session.ep.period_year# #get_puantaj.sal_mon#.Ay Damga Vergisi';
					}	
					genel_alacak_ = genel_alacak_ + t_ssk_damga_vergisi;
					
					
					if(t_issizlik_isci_hissesi gt 0)
					{
						str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,get_ACCOUNTS.UNEMPLOYMENT_WORKER_ACCOUNT, ",");
						str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,t_issizlik_isci_hissesi, ",");
						satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#session.ep.period_year# #get_puantaj.sal_mon#.Ay İşsizlik Primi İşçi Payı';
					}
					genel_alacak_ = genel_alacak_ + t_issizlik_isci_hissesi;
					
					if(t_kidem_worker gt 0)
					{
						str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,get_ACCOUNTS.KIDEM_WORKER_ACCOUNT, ",");
						str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,t_kidem_worker, ",");
						satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#session.ep.period_year# #get_puantaj.sal_mon#.Ay Kıdem Tazminatı İşveren Ödentileri';
					}
					genel_alacak_ = genel_alacak_ + t_kidem_worker;	
					
					if(t_kidem_boss gt 0)
					{
						str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,get_ACCOUNTS.KIDEM_BOSS_ACCOUNT, ",");
						str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,t_kidem_boss, ",");
						satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#session.ep.period_year# #get_puantaj.sal_mon#.Ay Kıdem Tazminatı İşveren Ödentileri';
					}	
					genel_alacak_ = genel_alacak_ + t_kidem_boss;
										
					
					if(t_issizlik_isveren_hissesi gt 0)
					{
						str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,get_ACCOUNTS.UNEMPLOYMENT_BOSS_ACCOUNT, ",");
						str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,t_issizlik_isveren_hissesi, ",");
						satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#session.ep.period_year# #get_puantaj.sal_mon#.Ay İşsizlik Primi İşveren Payı';
					}

					if(t_ssk_primi_isveren gt 0)
					{
						str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar,get_ACCOUNTS.SSK_BOSS_ACCOUNT, ",");
						str_alacakli_tutarlar = ListAppend(str_alacakli_tutarlar,t_ssk_primi_isveren, ",");
						satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#session.ep.period_year# #get_puantaj.sal_mon#.Ay SSK İşveren Payları Toplamı';
					}
					
					//borclu hesaplar asagida yazilacak						
					if((t_issizlik_isveren_hissesi + t_ssk_primi_isveren) gt 0)
					{
						str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,get_ACCOUNTS.SSK_BOSS_ACCOUNT_OUT, ",");
						str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,wrk_round((t_issizlik_isveren_hissesi + t_ssk_primi_isveren),2), ",");
						satir_detay_list[1][listlen(str_borclu_tutarlar)]='#session.ep.period_year# #get_puantaj.sal_mon#.Ay İşveren Payları Toplamı';
					}
					if(genel_alacak_ gt 0)
					{
						str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,get_ACCOUNTS.GROSS_WORKER_PAYMENT_ACCOUNT, ",");
						str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,genel_alacak_, ",");
						satir_detay_list[1][listlen(str_borclu_tutarlar)]='#session.ep.period_year# #get_puantaj.sal_mon#.Ay Brüt Personel Ücretleri';
					}

					//		SGDP
					if(t_sgdp_isveren_odentisi gt 0)
					{
						str_borclu_hesaplar = ListAppend(str_borclu_hesaplar,get_ACCOUNTS.SGDP_OUT, ",");
						str_borclu_tutarlar = ListAppend(str_borclu_tutarlar,wrk_round(t_sgdp_isveren_odentisi,2), ",");
						satir_detay_list[1][listlen(str_borclu_tutarlar)]='#session.ep.period_year# #get_puantaj.sal_mon#.Ay SGDP İşveren Ödentisi Toplamı';
					}
					//		/SGDP

					acc_flag=muhasebeci(
						action_id :attributes.PUANTAJ_ID,
						workcube_process_type : 130,
						account_card_type : 13,
						islem_tarihi : CREATEODBCDATETIME(CREATEDATE(attributes.sal_year,attributes.SAL_MON,puantaj_gun_)),
						borc_hesaplar : str_borclu_hesaplar,
						borc_tutarlar : str_borclu_tutarlar,
						alacak_hesaplar : str_alacakli_hesaplar,
						alacak_tutarlar : str_alacakli_tutarlar,
						from_branch_id : listgetat(session.ep.user_location,2,'-'),
						fis_detay : "#DETAIL_1#",
						fis_satir_detay : satir_detay_list
					);
				</cfscript>
			</cftransaction>
		</cflock>
		<cfquery name="UPD_PUANTAJ_MUHASEBE_STATUS" datasource="#DSN#">
			UPDATE
				EMPLOYEES_PUANTAJ
			SET
				IS_ACCOUNT = 1
			WHERE
				PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PUANTAJ_ID#">
		</cfquery>
		<tr>
			<td>#definition#</td>
			<td><font color="FF0000"><cf_get_lang dictionary_id ='53535.Muhasebe Aktarımı Başarıyla Yapıldı'>!</font></td>
		</tr>
	<cfelse>
		<tr>
			<td>#definition#</td>
			<td><font color="FF0000"><cf_get_lang dictionary_id ='59574.Maaş Toplamları Sıfır(0) Olduğundan Muhasebeleştirme Yapılmadı'>!</font></td>
		</tr>
	</cfif>
</cfoutput>
</table>
