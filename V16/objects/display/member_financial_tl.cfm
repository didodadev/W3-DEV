<cfquery name="GET_CHEQUES_KENDI_CEKLERI" datasource="#dsn2#">
	SELECT
		SUM(CHEQUE.CHEQUE_VALUE*(SM.RATE2/SM.RATE1)) AS TOPLAM
	FROM
		CHEQUE,
		CHEQUE_HISTORY,
		PAYROLL,		
		#dsn_alias#.SETUP_MONEY SM
	WHERE
		SM.PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
		CHEQUE.CHEQUE_ID IS NOT NULL AND
		CHEQUE.CURRENCY_ID = SM.MONEY AND
		CHEQUE_HISTORY.CHEQUE_ID = CHEQUE.CHEQUE_ID AND
		CHEQUE_HISTORY.PAYROLL_ID = PAYROLL.ACTION_ID AND
		PAYROLL.COMPANY_ID = #attributes.company_id# AND
		PAYROLL.PROCESS_CAT = 58 AND
		CHEQUE.SELF_CHEQUE = 1
</cfquery>
<cfquery name="GET_CHEQUES_DIGER_CEKLERI" datasource="#dsn2#">
	SELECT
		SUM(CHEQUE.CHEQUE_VALUE*(SM.RATE2/SM.RATE1)) AS TOPLAM
	FROM
		CHEQUE,
		CHEQUE_HISTORY,
		PAYROLL,		
		#dsn_alias#.SETUP_MONEY SM
	WHERE
		SM.PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
		CHEQUE.CHEQUE_ID IS NOT NULL AND
		CHEQUE.CURRENCY_ID = SM.MONEY AND
		CHEQUE_HISTORY.CHEQUE_ID = CHEQUE.CHEQUE_ID AND
		CHEQUE_HISTORY.PAYROLL_ID = PAYROLL.ACTION_ID AND
		PAYROLL.COMPANY_ID = #attributes.company_id# AND
		PAYROLL.PROCESS_CAT = 58 AND
		CHEQUE.SELF_CHEQUE <> 1
</cfquery>
<cfquery name="GET_VOUCHER_KENDI_SENETLERI" datasource="#dsn2#">
	SELECT
		SUM(V.VOUCHER_VALUE*(SM.RATE2/SM.RATE1)) AS TOPLAM
	FROM
		VOUCHER V,
		VOUCHER_HISTORY,
		VOUCHER_PAYROLL VP,
		#dsn_alias#.SETUP_MONEY SM
	WHERE
		V.VOUCHER_ID IS NOT NULL AND
		V.CURRENCY_ID = SM.MONEY AND
		VOUCHER_HISTORY.VOUCHER_ID = V.VOUCHER_ID AND
		VOUCHER_HISTORY.PAYROLL_ID = VP.ACTION_ID AND
		VP.COMPANY_ID = #attributes.company_id# AND
		VP.PROCESS_CAT = 65 AND
		V.SELF_VOUCHER = 1
		<!--- AND
		V.VOUCHER_PAYROLL_ID = VP.ACTION_ID --->
</cfquery>
<cfquery name="GET_VOUCHER_DIGER_SENETLERI" datasource="#dsn2#">
	SELECT
		SUM(V.VOUCHER_VALUE*(SM.RATE2/SM.RATE1)) AS TOPLAM
	FROM
		VOUCHER V,
		VOUCHER_HISTORY,
		VOUCHER_PAYROLL VP,
		#dsn_alias#.SETUP_MONEY SM
	WHERE
		V.VOUCHER_ID IS NOT NULL AND
		V.CURRENCY_ID = SM.MONEY AND
		VOUCHER_HISTORY.VOUCHER_ID = V.VOUCHER_ID AND
		VOUCHER_HISTORY.PAYROLL_ID = VP.ACTION_ID AND
		VP.COMPANY_ID = #attributes.company_id# AND
		SM.PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
		VP.PROCESS_CAT = 65 AND
		V.SELF_VOUCHER <> 1
		<!--- AND
		V.VOUCHER_PAYROLL_ID = VP.ACTION_ID --->
</cfquery>

<cfoutput>
<table width="99%" align="center">
  <tr class="color-list">
	<td colspan="3" class="txtbold"><cf_get_lang dictionary_id='33046.Sistem Para Birimi'>: #session.ep.money#</td>
  </tr>
  <tr class="color-list">
	<td width="125" class="txtboldblue"><cf_get_lang dictionary_id='33056.Finansal İşlemler'></td>
	<td width="140"  class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='58488.Alınan'></td>
  </tr>
  <tr class="color-list">
	<td><cf_get_lang dictionary_id='33057.Kendi Çekleri'></td>
	<td  style="text-align:right;">#TLFormat(GET_CHEQUES_KENDI_CEKLERI.TOPLAM)# #session.ep.money#</td>
  </tr>
  <tr class="color-list">
	<td><cf_get_lang dictionary_id='33058.Diğer Çekler'></td>
	<td  style="text-align:right;">#TLFormat(GET_CHEQUES_DIGER_CEKLERI.TOPLAM)# #session.ep.money#</td>
  </tr>
  <tr class="color-list">
	<td><cf_get_lang dictionary_id='58979.Karşılıksız Çek'></td>
	<td  style="text-align:right;">#TLFormat(GET_COMPANY_RISK.CEK_KARSILIKSIZ)# #session.ep.money#</td>
  </tr>
  <tr class="color-list">
	<td><cf_get_lang dictionary_id='33060.Kendi Senetleri'></td>
	<td  style="text-align:right;">#TLFormat(GET_VOUCHER_KENDI_SENETLERI.TOPLAM)# #session.ep.money#</td>
  </tr>
  <tr class="color-list">
	<td><cf_get_lang dictionary_id='33061.Diğer Senetler'></td>
	<td  style="text-align:right;">#TLFormat(GET_VOUCHER_DIGER_SENETLERI.TOPLAM)# #session.ep.money#</td>
  </tr>
	<tr class="color-list">
	<td><cf_get_lang dictionary_id='33062.Karşılıksız Senet'></td>
	<td  style="text-align:right;">#TLFormat(GET_COMPANY_RISK.SENET_KARSILIKSIZ)# #session.ep.money#</td>
  </tr>
</table>
</cfoutput>
