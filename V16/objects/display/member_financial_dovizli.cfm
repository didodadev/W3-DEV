<cfquery name="GET_SETUP_MONEY" datasource="#dsn#">
	SELECT
		RATE2,
		MONEY
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
		RATE2 <> RATE1
</cfquery>

<cfoutput>
<table width="99%" align="center">
  <tr class="color-list">
	<td colspan="3" class="txtbold"><cf_get_lang dictionary_id='57796.Dövizli'>(<cf_get_lang dictionary_id='60150.Çek ve senetlerin, tanımlı her bir döviz cinsinden değerleri'>)</td>
  </tr>
  <tr class="color-list">
	<td width="125" class="txtboldblue"><cf_get_lang dictionary_id='33056.Finansal İşlemler'></td>
	<td width="140"  class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='58488.Alınan'></td>
  </tr>
  <tr class="color-list">
	<td><cf_get_lang dictionary_id='33057.Kendi Çekleri'></td>
	<td  style="text-align:right;"><cfloop query="GET_SETUP_MONEY"><cfif isNumeric(GET_CHEQUES_KENDI_CEKLERI.TOPLAM)>#TLFormat(GET_CHEQUES_KENDI_CEKLERI.TOPLAM / RATE2)# #money#<br/></cfif></cfloop></td>
  </tr>
  <tr class="color-list">
	<td><cf_get_lang dictionary_id='33058.Diğer Çekler'></td>
	<td  style="text-align:right;"><cfloop query="GET_SETUP_MONEY"><cfif isNumeric(GET_CHEQUES_DIGER_CEKLERI.TOPLAM)>#TLFormat(GET_CHEQUES_DIGER_CEKLERI.TOPLAM / RATE2)# #money#<br/></cfif></cfloop></td>
  </tr>
  <tr class="color-list">
	<td><cf_get_lang dictionary_id='58979.Karşılıksız Çek'></td>
	<td  style="text-align:right;"><cfloop query="GET_SETUP_MONEY">#TLFormat(GET_COMPANY_RISK.CEK_KARSILIKSIZ / RATE2)# #money#<br/></cfloop></td>
  </tr>
  <tr class="color-list">
	<td><cf_get_lang dictionary_id='33060.Kendi Senetleri'></td>
	<td  style="text-align:right;"><cfloop query="GET_SETUP_MONEY"><cfif isNumeric(GET_VOUCHER_KENDI_SENETLERI.TOPLAM)>#TLFormat(GET_VOUCHER_KENDI_SENETLERI.TOPLAM / RATE2)# #money#<br/></cfif></cfloop></td>
  </tr>
  <tr class="color-list">
	<td><cf_get_lang dictionary_id='33061.Diğer Senetler'></td>
	<td  style="text-align:right;"><cfloop query="GET_SETUP_MONEY"><cfif isNumeric(GET_VOUCHER_DIGER_SENETLERI.TOPLAM)>#TLFormat(GET_VOUCHER_DIGER_SENETLERI.TOPLAM / RATE2)# #money#<br/></cfif></cfloop></td>
  </tr>
	<tr class="color-list">
	<td><cf_get_lang dictionary_id='33062.Karşılıksız Senet'></td>
	<td  style="text-align:right;"><cfloop query="GET_SETUP_MONEY">#TLFormat(GET_COMPANY_RISK.SENET_KARSILIKSIZ / RATE2)# #money#<br/></cfloop></td>
  </tr>
</table>
</cfoutput>
