<cfif not get_is_integrated.is_integrated><!--- Muhasebe Dönemi Entegre Olmadigi zaman sadece cari kaydi yapilir --->
	<cfquery name="GET_old_cari_row_ACCOUNTED" datasource="#dsn2#">
		SELECT
			ACTION_ID
		FROM
			CARI_ROWS
		WHERE
			IS_ACCOUNT = 1 AND
			ACTION_TYPE_ID = 130 AND
			ACTION_ID = #attributes.PUANTAJ_ID#
	</cfquery>

	<cfif GET_old_cari_row_ACCOUNTED.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id ='53383.Puantaj Muhasebeleştirilmiş Öncelikle Muhasebe Kaydını Siliniz'> !");
			history.back();
		</script>
		<cfabort>
	</cfif>
	
	<cfquery name="del_old_cari_row" datasource="#dsn2#">
		DELETE FROM
			CARI_ROWS
		WHERE
			IS_ACCOUNT = 0 AND
			ACTION_TYPE_ID = 130 AND
			ACTION_ID = #attributes.PUANTAJ_ID#
	</cfquery>

	<cfquery name="ADD_CARI_ROWS" datasource="#dsn2#">
		INSERT INTO CARI_ROWS
			(
			IS_ACCOUNT,
			ACTION_ID,
			ACTION_TABLE,
			ACTION_TYPE_ID,
			ACTION_NAME,
			ACTION_VALUE,
			ACTION_DATE,
			ACTION_CURRENCY_ID
			)
		VALUES
			(
			0,
			#attributes.PUANTAJ_ID#,
			'EMPLOYEES_PUANTAJ',
			130,  
			'PUANTAJ AKTARIMI',
			#t_brut_personel_ucreti+t_personel_isveren_odentisi+t_other#,
			#now()#,
			'#session.ep.money#'
			)
	</cfquery>

	<cfquery name="UPD_PUANTAJ_MUHASEBE_STATUS" datasource="#DSN#">
		UPDATE
			EMPLOYEES_PUANTAJ
		SET
			IS_ACCOUNT = 0
		WHERE
			PUANTAJ_ID = #attributes.PUANTAJ_ID#
	</cfquery>
	<li><cf_get_lang dictionary_id="59572.Muhasebe Dönemi Entegre Olmadığından Cari Kayıt Yapıldı">!</li>
	<cfexit method="exittemplate">
</cfif>

<cfquery name="GET_ACCOUNTS" datasource="#dsn3#" maxrows="1">
	SELECT 
    	PA_ID, 
        TAX_ACCOUNT, 
        PERSONAL_ADVANCE_ACCOUNT, 
        SSK_BOSS_ACCOUNT, 
        SSK_WORKER_ACCOUNT, 
        SSK_STAMP_TAX_ACCOUNT, 
        UNEMPLOYMENT_WORKER_ACCOUNT, 
        UNEMPLOYMENT_BOSS_ACCOUNT, 
        GROSS_WORKER_PAYMENT_ACCOUNT, 
        KIDEM_WORKER_ACCOUNT, 
        KIDEM_BOSS_ACCOUNT, 
        SSK_BOSS_ACCOUNT_OUT, 
        UNEMPLOYMENT_BOSS_ACCOUNT_OUT, 
        DEFINITION, 
        RECORD_EMP, 
        RECORD_IP, 
        RECORD_DATE, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
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

<cfquery name="get_user_accounts" dbtype="query">
	SELECT * FROM GET_ACCOUNTS
</cfquery>

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
		EI.ACCOUNT_BILL_TYPE IS NULL AND
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
		EI.FINISH_DATE
	FROM 
		EMPLOYEES_IN_OUT EI,
		EMPLOYEES E
	WHERE 
		EI.IN_OUT_ID IN (#in_out_list#) AND 
		EI.ACCOUNT_BILL_TYPE = #get_user_accounts.pa_id# AND
		EI.EMPLOYEE_ID = E.EMPLOYEE_ID
	ORDER BY
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
			<td>#get_user_accounts.definition#</td>
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
<cfoutput query="get_user_accounts">
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
</cfscript>

<cfloop query="get_puantaj_rows">
		<cfscript>
			t_vergi_fon = t_vergi_fon + GELIR_VERGISI;
			t_personel_avanslari = t_personel_avanslari + net_ucret;
			t_ssk_primi_isci = t_ssk_primi_isci + SSK_ISCI_HISSESI + SSDF_ISCI_HISSESI;
			t_ssk_primi_isveren = t_ssk_primi_isveren + SSK_ISVEREN_HISSESI + SSDF_ISVEREN_HISSESI;
			t_ssk_damga_vergisi = t_ssk_damga_vergisi + DAMGA_VERGISI;
			t_issizlik_isci_hissesi = t_issizlik_isci_hissesi + ISSIZLIK_ISCI_HISSESI;
			t_issizlik_isveren_hissesi = t_issizlik_isveren_hissesi + ISSIZLIK_ISVEREN_HISSESI;
			t_kidem_worker = t_kidem_worker + kidem_worker;
			t_kidem_boss = t_kidem_boss + kidem_boss;
			t_brut_personel_ucreti = t_brut_personel_ucreti + TOTAL_SALARY;
			t_personel_isveren_odentisi = t_personel_isveren_odentisi + ISSIZLIK_ISVEREN_HISSESI + SSK_ISVEREN_HISSESI + SSDF_ISVEREN_HISSESI;
			t_other = t_other + kidem_worker+ kidem_boss;
		</cfscript>
</cfloop>

		<cfif t_brut_personel_ucreti neq 0>
			<cflock name="#createUUID()#" timeout="20">
				<cftransaction>
				<cfquery name="get_bill_no" datasource="#dsn2#">
					SELECT BILL_NO, MAHSUP_BILL_NO FROM BILLS
				</cfquery>
				<cfquery name="add_card" datasource="#dsn2#" result="MAX_ID">
					INSERT INTO
						ACCOUNT_CARD
						(
						CARD_DETAIL,
						ACTION_DATE,
						CARD_TYPE,
						ACTION_TYPE,
						BILL_NO,
						CARD_TYPE_NO,
						IS_ACCOUNT,
						ACTION_ID,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE
						)
					VALUES
						(
						'#session.ep.period_year# #get_puantaj.sal_mon#.Ay - #get_puantaj.SSK_OFFICE# <cf_get_lang dictionary_id ="53674.Personel Maaş Ödemesi">',
						#CreateODBCDateTime('#year(now())#-#month(now())#-#day(now())#')#,
						13,
						130,
						#get_bill_no.bill_no#,
						#get_bill_no.mahsup_bill_no#,
						1,
						#attributes.PUANTAJ_ID#,
						#session.ep.userid#,
						'#cgi.REMOTE_ADDR#',
						#now()#
						)
				</cfquery>
				<cfif t_vergi_fon gt 0>
					<cfquery name="add_card_row_vergi_fon" datasource="#dsn2#">
						INSERT INTO	
							ACCOUNT_CARD_ROWS
							(
							CARD_ID,
							ACCOUNT_ID,
							BA,
							AMOUNT,
							AMOUNT_CURRENCY,
							DETAIL
							)
						VALUES
							(
							#MAX_ID.IDENTITYCOL#,
							'#get_ACCOUNTS.TAX_ACCOUNT#',
							1,
							#t_vergi_fon#,
							'#session.ep.money#',
							'#session.ep.period_year# #get_puantaj.sal_mon#.<cf_get_lang dictionary_id ="53675.Ay Vergi ve Fonlar">'
							)
					</cfquery>
				</cfif>
			
				<cfif t_personel_avanslari gt 0>
					<cfquery name="add_card_row_PERSONEL_AVANS" datasource="#dsn2#">
						INSERT INTO	
							ACCOUNT_CARD_ROWS
							(
							CARD_ID,
							ACCOUNT_ID,
							BA,
							AMOUNT,
							AMOUNT_CURRENCY,
							DETAIL
							)
						VALUES
							(
							#MAX_ID.IDENTITYCOL#,
							'#get_ACCOUNTS.PERSONAL_ADVANCE_ACCOUNT#',
							1,
							#t_personel_avanslari#,
							'#session.ep.money#',
							'#session.ep.period_year# #get_puantaj.sal_mon#.<cf_get_lang dictionary_id ="53676.Ay Personel Avansları">'
							)
					</cfquery>
				</cfif>
				
				<cfif t_ssk_primi_isci gt 0>
					<cfquery name="add_card_row_ssk_isci" datasource="#dsn2#">
						INSERT INTO	
							ACCOUNT_CARD_ROWS
							(
							CARD_ID,
							ACCOUNT_ID,
							BA,
							AMOUNT,
							AMOUNT_CURRENCY,
							DETAIL
							)
						VALUES
							(
							#MAX_ID.IDENTITYCOL#,
							'#get_ACCOUNTS.SSK_WORKER_ACCOUNT#',
							1,
							#t_ssk_primi_isci#,
							'#session.ep.money#',
							'#session.ep.period_year# #get_puantaj.sal_mon#.<cf_get_lang dictionary_id ="53677.Ay SSK İşçi Payları Toplamı">'
							)
					</cfquery>
				</cfif>
					
				<cfif t_ssk_primi_isveren gt 0>
					<cfquery name="add_card_row_ssk_isveren" datasource="#dsn2#">
						INSERT INTO	
							ACCOUNT_CARD_ROWS
							(
							CARD_ID,
							ACCOUNT_ID,
							BA,
							AMOUNT,
							AMOUNT_CURRENCY,
							DETAIL
							)
						VALUES
							(
							#MAX_ID.IDENTITYCOL#,
							'#get_ACCOUNTS.SSK_BOSS_ACCOUNT#',
							1,
							#t_ssk_primi_isveren#,
							'#session.ep.money#',
							'#session.ep.period_year# #get_puantaj.sal_mon#.<cf_get_lang dictionary_id ="53678.Ay SSK İşveren Payları Toplamı">'
							)
					</cfquery>
					<cfquery name="add_card_row_ssk_isveren" datasource="#dsn2#">
						INSERT INTO	
							ACCOUNT_CARD_ROWS
							(
							CARD_ID,
							ACCOUNT_ID,
							BA,
							AMOUNT,
							AMOUNT_CURRENCY,
							DETAIL
							)
						VALUES
							(
							#MAX_ID.IDENTITYCOL#,
							'#get_ACCOUNTS.SSK_BOSS_ACCOUNT_OUT#',
							0,
							#t_ssk_primi_isveren#,
							'#session.ep.money#',
							'#session.ep.period_year# #get_puantaj.sal_mon#.<cf_get_lang dictionary_id ="53679.Ay SSK İşveren Payları Toplamı Çıkış">'
							)
					</cfquery>
				</cfif>
					
				<cfif t_ssk_damga_vergisi gt 0>
					<cfquery name="add_card_row_damga_vergisi" datasource="#dsn2#">
						INSERT INTO	
							ACCOUNT_CARD_ROWS
							(
							CARD_ID,
							ACCOUNT_ID,
							BA,
							AMOUNT,
							AMOUNT_CURRENCY,
							DETAIL
							)
						VALUES
							(
							#MAX_ID.IDENTITYCOL#,
							'#get_ACCOUNTS.SSK_STAMP_TAX_ACCOUNT#',
							1,
							#t_ssk_damga_vergisi#,
							'#session.ep.money#',
							'#session.ep.period_year# #get_puantaj.sal_mon#.<cf_get_lang dictionary_id ="53680.Ay Damga Vergisi">'
							)
					</cfquery>
				</cfif>
					
				<cfif t_issizlik_isci_hissesi gt 0>
					<cfquery name="add_card_row_issizlik_isci" datasource="#dsn2#">
						INSERT INTO	
							ACCOUNT_CARD_ROWS
							(
							CARD_ID,
							ACCOUNT_ID,
							BA,
							AMOUNT,
							AMOUNT_CURRENCY,
							DETAIL
							)
						VALUES
							(
							#MAX_ID.IDENTITYCOL#,
							'#get_ACCOUNTS.UNEMPLOYMENT_WORKER_ACCOUNT#',
							1,
							#t_issizlik_isci_hissesi#,
							'#session.ep.money#',
							'#session.ep.period_year# #get_puantaj.sal_mon#.<cf_get_lang dictionary_id ="53681.Ay İşsizlik Primi İşçi Payı">'
							)
					</cfquery>
				</cfif>
					
				<cfif t_issizlik_isveren_hissesi gt 0>
					<cfquery name="add_card_row_issizlik_isveren" datasource="#dsn2#">
						INSERT INTO	
							ACCOUNT_CARD_ROWS
							(
							CARD_ID,
							ACCOUNT_ID,
							BA,
							AMOUNT,
							AMOUNT_CURRENCY,
							DETAIL
							)
						VALUES
							(
							#MAX_ID.IDENTITYCOL#,
							'#get_ACCOUNTS.UNEMPLOYMENT_BOSS_ACCOUNT#',
							1,
							#t_issizlik_isveren_hissesi#,
							'#session.ep.money#',
							'#session.ep.period_year# #get_puantaj.sal_mon#.<cf_get_lang dictionary_id ="53682.Ay İşsizlik Primi İşveren Payı">'
							)
					</cfquery>
					<cfquery name="add_card_row_issizlik_isveren" datasource="#dsn2#">
						INSERT INTO	
							ACCOUNT_CARD_ROWS
							(
							CARD_ID,
							ACCOUNT_ID,
							BA,
							AMOUNT,
							AMOUNT_CURRENCY,
							DETAIL
							)
						VALUES
							(
							#MAX_ID.IDENTITYCOL#,
							'#get_ACCOUNTS.UNEMPLOYMENT_BOSS_ACCOUNT_OUT#',
							0,
							#t_issizlik_isveren_hissesi#,
							'#session.ep.money#',
							'#session.ep.period_year# #get_puantaj.sal_mon#.<cf_get_lang dictionary_id ="53683.Ay İşsizlik Primi İşveren Payı Çıkış">'
							)
					</cfquery>
				</cfif>
					
				<cfif t_brut_personel_ucreti gt 0>
					<cfquery name="add_card_row_brut_ucretler" datasource="#dsn2#">
						INSERT INTO	
							ACCOUNT_CARD_ROWS
							(
							CARD_ID,
							ACCOUNT_ID,
							BA,
							AMOUNT,
							AMOUNT_CURRENCY,
							DETAIL
							)
						VALUES
							(
							#MAX_ID.IDENTITYCOL#,
							'#get_ACCOUNTS.GROSS_WORKER_PAYMENT_ACCOUNT#',
							0,
							#t_brut_personel_ucreti#,
							'#session.ep.money#',
							'#session.ep.period_year# #get_puantaj.sal_mon#.<cf_get_lang dictionary_id ="53673.Ay Brüt Personel Ücretleri">'
							)
					</cfquery>
				</cfif>
				<cfif t_kidem_worker gt 0>
					<cfquery name="add_card_row_KIDEM_ISCI_PAYI" datasource="#dsn2#">
						INSERT INTO	
							ACCOUNT_CARD_ROWS
							(
							CARD_ID,
							ACCOUNT_ID,
							BA,
							AMOUNT,
							AMOUNT_CURRENCY,
							DETAIL
							)
						VALUES
							(
							#MAX_ID.IDENTITYCOL#,
							'#get_ACCOUNTS.KIDEM_WORKER_ACCOUNT#',
							1,
							#t_kidem_worker#,
							'#session.ep.money#',
							'#session.ep.period_year# #get_puantaj.sal_mon#. <cf_get_lang dictionary_id ='53536.Ay Kıdem Tazminatı İşveren Ödentileri'>'
							)
					</cfquery>
				</cfif>
					
				<cfif t_kidem_boss gt 0>
					<cfquery name="add_card_row_KIDEM_ISVEREN_PAYI" datasource="#dsn2#">
						INSERT INTO	
							ACCOUNT_CARD_ROWS
							(
							CARD_ID,
							ACCOUNT_ID,
							BA,
							AMOUNT,
							AMOUNT_CURRENCY,
							DETAIL
							)
						VALUES
							(
							#MAX_ID.IDENTITYCOL#,
							'#get_ACCOUNTS.KIDEM_BOSS_ACCOUNT#',
							1,
							#t_kidem_boss#,
							'#session.ep.money#',
							'#session.ep.period_year# #get_puantaj.sal_mon#. <cf_get_lang dictionary_id ="53536.Ay Kıdem Tazminatı İşveren Ödentileri">'
							)
					</cfquery>
				</cfif>
			
				<cfif t_other gt 0>
					<cfquery name="add_card_row_diger" datasource="#dsn2#">
						INSERT INTO	
							ACCOUNT_CARD_ROWS
							(
							CARD_ID,
							ACCOUNT_ID,
							BA,
							AMOUNT,
							AMOUNT_CURRENCY,
							DETAIL
							)
						VALUES
							(
							#MAX_ID.IDENTITYCOL#,
							'#get_ACCOUNTS.OTHER_ACCOUNT#',
							0,
							#t_other#,
							'#session.ep.money#',
							'#session.ep.period_year# #get_puantaj.sal_mon#. <cf_get_lang dictionary_id="59573.Ay Diğer Ödentiler">'
							)
					</cfquery>
				</cfif>
			
				<cfquery name="upd_bill_no" datasource="#dsn2#">
					UPDATE BILLS SET
						BILL_NO = BILL_NO + 1,
						MAHSUP_BILL_NO = MAHSUP_BILL_NO + 1
				</cfquery>
		
				</cftransaction>
			</cflock>
			
			<cfquery name="UPD_PUANTAJ_MUHASEBE_STATUS" datasource="#DSN#">
				UPDATE
					EMPLOYEES_PUANTAJ
				SET
					IS_ACCOUNT = 1
				WHERE
					PUANTAJ_ID = #attributes.PUANTAJ_ID#
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
